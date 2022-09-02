/*
 * Copyright (c) 2022 NetEase, Inc. All rights reserved.
 * Use of this source code is governed by a MIT license that can be
 * found in the LICENSE file.
 */

package com.netease.nimflutter.initialize

import android.content.Context
import com.netease.nimflutter.FLTService
import com.netease.nimflutter.NimCore
import com.netease.nimflutter.NimResult
import com.netease.nimflutter.ResultCallback
import com.netease.nimflutter.SafeResult
import com.netease.nimflutter.convertToStatusBarNotificationConfig
import com.netease.nimflutter.services.LoginInfoFactory
import com.netease.nimlib.sdk.NIMClient
import com.netease.nimlib.sdk.NosTokenSceneConfig
import com.netease.nimlib.sdk.Observer
import com.netease.nimlib.sdk.SDKOptions
import com.netease.nimlib.sdk.lifecycle.SdkLifecycleObserver
import com.netease.nimlib.sdk.mixpush.MixPushConfig
import com.netease.yunxin.kit.alog.ALog
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.catch
import kotlinx.coroutines.flow.filter
import kotlinx.coroutines.flow.launchIn
import kotlinx.coroutines.flow.onEach
import kotlinx.coroutines.flow.take
import org.json.JSONObject

class FLTInitializeService(
    applicationContext: Context,
    nimCore: NimCore
) : FLTService(applicationContext, nimCore) {

    private val initial = 0
    private val initializing = 1
    private val initialized = 2

    override val serviceName = "InitializeService"

    private val state = MutableStateFlow(initial)

    lateinit var sdkOptions: SDKOptions

    val isInitialized: Boolean
        get() {
            if (state.value == initialized) {
                return true
            }

            // / 可能会存在 IM 复用的情况，这个时候上层已经进行了初始化
            // / 检查 NIMClient.getService 方法是否正常返回，如果时，说明已经初始化了
            runCatching {
                NIMClient.getService(SdkLifecycleObserver::class.java)
                state.value = initialized
                return true
            }

            return false
        }

    fun onInitialized(callback: suspend () -> Unit) =
        state.filter { st -> st == initialized }
            .take(count = 1)
            .onEach { callback() }
            .catch { exp ->
                ALog.i(
                    serviceName,
                    "onInitialized callback exception: ${exp.message}"
                )
            }
            .launchIn(nimCore.lifeCycleScope)

    @Suppress("UNCHECKED_CAST")
    override fun onMethodCalled(method: String, arguments: Map<String, *>, safeResult: SafeResult) {
        val callback = ResultCallback<Nothing>(safeResult)
        if (method == "initialize" && state.value == initial) {
            state.value = initializing
            runCatching {
                NIMClient.config(
                    applicationContext,
                    arguments["autoLoginInfo"]?.let { LoginInfoFactory.fromMap(it as Map<String, *>) },
                    SDKOptions().configureWithMap(arguments).also {
                        sdkOptions = it
                    }
                )
                NIMClient.initSDK()
                NIMClient.getService(SdkLifecycleObserver::class.java)
                    .observeMainProcessInitCompleteResult(
                        object : Observer<Boolean> {
                            override fun onEvent(success: Boolean) {
                                if (state.value == initializing) {
                                    ALog.i(
                                        serviceName,
                                        "sdk initialize result: $success"
                                    )
                                    state.value = if (success) initialized else initial
                                    callback.result(if (success) NimResult.SUCCESS else NimResult.FAILURE)
                                    NIMClient.getService(SdkLifecycleObserver::class.java)
                                        .observeMainProcessInitCompleteResult(this, false)
                                }
                            }
                        },
                        true
                    )
            }.onFailure { exception ->
                ALog.e(
                    serviceName,
                    "sdk initialize exception",
                    exception
                )
                state.value = initial
                callback.result(NimResult.FAILURE.copy(errorDetails = exception.message))
            }
        } else {
            callback.result(
                if (isInitialized) {
                    ALog.e(serviceName, "duplicated initialize")
                    NimResult(code = 0)
                } else {
                    NimResult.FAILURE
                }
            )
        }
    }
}

fun SDKOptions.configureWithMap(configurations: Map<String, *>) = apply {
    val args = configurations.withDefault { null }

    appKey = configurations["appKey"] as String
    require(appKey.isNotEmpty()) { "AppKey cannot be empty!" }
    useAssetServerAddressConfig =
        configurations.getOrElse("useAssetServerAddressConfig") { false } as Boolean
    sdkStorageRootPath = configurations["sdkRootDir"] as String?
    cdnRequestDataInterval =
        (configurations.getOrElse("cdnTrackInterval") { 3000 } as Number).toInt()
    loginCustomTag = configurations["loginCustomTag"] as String?
    enableDatabaseBackup = configurations.getOrElse("enableDatabaseBackup") { false } as Boolean
    sessionReadAck = configurations.getOrElse("shouldSyncUnreadCount") { false } as Boolean
    shouldConsiderRevokedMessageUnreadCount =
        configurations.getOrElse("shouldConsiderRevokedMessageUnreadCount") { false } as Boolean
    enableTeamMsgAck = configurations.getOrElse("enableTeamMessageReadReceipt") { false } as Boolean
    teamNotificationMessageMarkUnread =
        configurations.getOrElse("shouldTeamNotificationMessageMarkUnread") { false } as Boolean
    animatedImageThumbnailEnabled =
        configurations.getOrElse("enableAnimatedImageThumbnail") { false } as Boolean
    preloadAttach =
        configurations.getOrElse("enablePreloadMessageAttachment") { true } as Boolean
    notifyStickTopSession =
        configurations.getOrElse("shouldSyncStickTopSessionInfos") { false } as Boolean
    reportImLog = configurations.getOrElse("enableReportLogAutomatically") { false } as Boolean
    val nosSceneConfig: Map<String, Number>? by args
    if (nosSceneConfig != null) {
        mNosTokenSceneConfig = NosTokenSceneConfig().apply {
            nosSceneConfig!!.forEach {
                appendCustomScene(it.key, it.value.toInt())
            }
        }
    }

    val extras: Map<String, Any?>? by args
    flutterSdkVersion = extras?.get("versionName") as String?

    improveSDKProcessPriority =
        configurations.getOrElse("improveSDKProcessPriority") { true } as Boolean
    preLoadServers = configurations.getOrElse("preLoadServers") { true } as Boolean
    reducedIM = configurations.getOrElse("reducedIM") { false } as Boolean
    checkManifestConfig = configurations.getOrElse("checkManifestConfig") { false } as Boolean
    disableAwake = configurations.getOrElse("disableAwake") { false } as Boolean
    fetchServerTimeInterval =
        (configurations.getOrElse("fetchServerTimeInterval") { 1000 } as Number).toLong()
    customPushContentType = configurations["customPushContentType"] as String?
    databaseEncryptKey = configurations["databaseEncryptKey"] as String?
    thumbnailSize = (configurations.getOrElse("thumbnailSize") { 350 } as Number).toInt()

    val mixPushConfig: Map<String, *>? by args
    if (mixPushConfig != null) {
        this.mixPushConfig =
            MixPushConfig.fromJson(
                JSONObject(
                    mixPushConfig!!.filter {
                        it.value != null
                    }
                )
            )
    }

    val notificationConfig: Map<String, Any?>? by args
    if (notificationConfig != null) {
        statusBarNotificationConfig = convertToStatusBarNotificationConfig(notificationConfig)
    }
    // 状态对齐ios
    enableLoseConnection = true
}
