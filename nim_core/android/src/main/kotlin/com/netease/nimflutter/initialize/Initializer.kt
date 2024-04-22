/*
 * Copyright (c) 2022 NetEase, Inc. All rights reserved.
 * Use of this source code is governed by a MIT license that can be
 * found in the LICENSE file.
 */

package com.netease.nimflutter.initialize

import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.text.TextUtils
import com.netease.nimflutter.FLTService
import com.netease.nimflutter.MethodChannelSuspendResult
import com.netease.nimflutter.NimCore
import com.netease.nimflutter.NimResult
import com.netease.nimflutter.ResultCallback
import com.netease.nimflutter.SafeResult
import com.netease.nimflutter.convertToNIMServerAddresses
import com.netease.nimflutter.convertToStatusBarNotificationConfig
import com.netease.nimflutter.services.LoginInfoFactory
import com.netease.nimflutter.stringFromSessionTypeEnum
import com.netease.nimflutter.toMap
import com.netease.nimlib.sdk.NIMClient
import com.netease.nimlib.sdk.NosTokenSceneConfig
import com.netease.nimlib.sdk.Observer
import com.netease.nimlib.sdk.SDKOptions
import com.netease.nimlib.sdk.lifecycle.SdkLifecycleObserver
import com.netease.nimlib.sdk.mixpush.MixPushConfig
import com.netease.nimlib.sdk.msg.MessageNotifierCustomization
import com.netease.nimlib.sdk.msg.constant.SessionTypeEnum
import com.netease.nimlib.sdk.msg.model.IMMessage
import com.netease.nimlib.sdk.uinfo.UserInfoProvider
import com.netease.nimlib.sdk.uinfo.model.UserInfo
import com.netease.yunxin.kit.alog.ALog
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.catch
import kotlinx.coroutines.flow.filter
import kotlinx.coroutines.flow.launchIn
import kotlinx.coroutines.flow.onEach
import kotlinx.coroutines.flow.take
import kotlinx.coroutines.runBlocking
import kotlinx.coroutines.suspendCancellableCoroutine
import kotlinx.coroutines.withTimeoutOrNull
import org.json.JSONObject

// 获取用户信息返回超时 500ms
const val userProviderTimeout = 500L

class FLTInitializeService(
    applicationContext: Context,
    nimCore: NimCore
) : FLTService(applicationContext, nimCore) {

    private val initial = 0
    private val initializing = 1
    private val initialized = 2

    override val serviceName = "InitializeService"

    private val state = MutableStateFlow(initial)

    private val innerMessageNotifierCustomization = object : MessageNotifierCustomization {
        override fun makeNotifyContent(nick: String?, message: IMMessage?): String? {
            return runBlocking {
                withTimeoutOrNull(userProviderTimeout) {
                    suspendCancellableCoroutine<Any?> { continuation ->
                        notifyEvent(
                            method = "onMakeNotifyContent",
                            arguments = mapOf(
                                "nick" to nick,
                                "message" to message?.toMap()
                            ),
                            callback = MethodChannelSuspendResult(continuation)
                        )
                    } as String?
                }
            }
        }

        override fun makeTicker(nick: String?, message: IMMessage?): String? {
            return runBlocking {
                withTimeoutOrNull(userProviderTimeout) {
                    suspendCancellableCoroutine<Any?> { continuation ->
                        notifyEvent(
                            method = "onMakeTicker",
                            arguments = mapOf(
                                "nick" to nick,
                                "message" to message?.toMap()
                            ),
                            callback = MethodChannelSuspendResult(continuation)
                        )
                    } as String?
                }
            }
        }

        override fun makeRevokeMsgTip(revokeAccount: String?, item: IMMessage?): String? {
            return runBlocking {
                withTimeoutOrNull(userProviderTimeout) {
                    suspendCancellableCoroutine<Any?> { continuation ->
                        notifyEvent(
                            method = "onMakeRevokeMsgTip",
                            arguments = mapOf(
                                "revokeAccount" to revokeAccount,
                                "item" to item?.toMap()
                            ),
                            callback = MethodChannelSuspendResult(continuation)
                        )
                    } as String?
                }
            }
        }

        override fun makeCategory(message: IMMessage?): String? = null
    }

    private val innerUserInfoProvider = object : UserInfoProvider {
        override fun getUserInfo(account: String?): UserInfo? = null

        override fun getDisplayNameForMessageNotifier(
            account: String?,
            sessionId: String?,
            sessionType: SessionTypeEnum?
        ): String? {
            return runBlocking {
                withTimeoutOrNull(userProviderTimeout) {
                    suspendCancellableCoroutine<Any?> { continuation ->
                        notifyEvent(
                            method = "onGetDisplayNameForMessageNotifier",
                            arguments = mapOf(
                                "account" to account,
                                "sessionId" to sessionId,
                                "sessionType" to stringFromSessionTypeEnum(sessionType)
                            ),
                            callback = MethodChannelSuspendResult(continuation)
                        )
                    } as String?
                }
            }
        }

        override fun getAvatarForMessageNotifier(
            sessionType: SessionTypeEnum?,
            sessionId: String?
        ): Bitmap? {
            return runBlocking {
                withTimeoutOrNull(userProviderTimeout) {
                    @Suppress("UNCHECKED_CAST")
                    val map = suspendCancellableCoroutine<Any?> { continuation ->
                        notifyEvent(
                            method = "onGetAvatarForMessageNotifier",
                            arguments = mapOf(
                                "sessionId" to sessionId,
                                "sessionType" to stringFromSessionTypeEnum(sessionType)
                            ),
                            callback = MethodChannelSuspendResult(continuation)
                        )
                    } as Map<String, Any>?
                    val path = map?.get("path") as String?
                    val type = map?.get("type") as String?
                    val inSampleSize = (map?.get("inSampleSize") as Int?) ?: 2
                    if (TextUtils.isEmpty(path) || TextUtils.isEmpty(type)) {
                        ALog.w(
                            serviceName,
                            "onGetAvatarForMessageNotifier##param error, path=$path, type=$type, inSampleSize=$inSampleSize"
                        )
                        return@withTimeoutOrNull null
                    }
                    when (type) {
                        "asset" -> {
                            val filePath = nimCore.flutterAssets.getAssetFilePathByName(path!!)
                            applicationContext.assets.open(filePath).use {
                                val options = BitmapFactory.Options()
                                options.inSampleSize = inSampleSize
                                BitmapFactory.decodeStream(it, null, options)
                            }
                        }
                        "file" -> {
                            val options = BitmapFactory.Options()
                            options.inSampleSize = inSampleSize
                            BitmapFactory.decodeFile(path!!, options)
                        }
                        else -> {
                            ALog.w(
                                serviceName,
                                "onGetAvatarForMessageNotifier##type error, type=$type"
                            )
                            null
                        }
                    }
                }
            }
        }

        override fun getDisplayTitleForMessageNotifier(message: IMMessage?): String? {
            return runBlocking {
                withTimeoutOrNull(userProviderTimeout) {
                    suspendCancellableCoroutine<Any?> { continuation ->
                        notifyEvent(
                            method = "onGetDisplayTitleForMessageNotifier",
                            arguments = mapOf("message" to message?.toMap()),
                            callback = MethodChannelSuspendResult(continuation)
                        )
                    } as String?
                }
            }
        }
    }

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
                    SDKOptions().configureWithMap(arguments).apply {
                        this.userInfoProvider = innerUserInfoProvider
                        this.messageNotifierCustomization = innerMessageNotifierCustomization
                    }.also {
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
                // 初始化ALog,使plugin层日志可以输出到本地日志文件
                ALog.init(applicationContext, ALog.LEVEL_DEBUG)
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

    val serverConfig: Map<String, *>? by args
    if (serverConfig != null) {
        this.serverConfig = convertToNIMServerAddresses(serverConfig)
    }

    val extras: Map<String, Any?>? by args
    flutterSdkVersion = extras?.get("versionName") as String?

    improveSDKProcessPriority =
        configurations.getOrElse("improveSDKProcessPriority") { true } as Boolean
    preLoadServers = configurations.getOrElse("preLoadServers") { true } as Boolean
    reducedIM = configurations.getOrElse("reducedIM") { false } as Boolean
    enableFcs = configurations.getOrElse("enableFcs") { true } as Boolean
    checkManifestConfig = configurations.getOrElse("checkManifestConfig") { false } as Boolean
    disableAwake = configurations.getOrElse("disableAwake") { false } as Boolean
    fetchServerTimeInterval =
        (configurations.getOrElse("fetchServerTimeInterval") { 1000 } as Number).toLong()
    customPushContentType = configurations["customPushContentType"] as String?
    databaseEncryptKey = configurations["databaseEncryptKey"] as String?
    thumbnailSize = (configurations.getOrElse("thumbnailSize") { 350 } as Number).toInt()
    enabledQChatMessageCache = configurations.getOrElse("enabledQChatMessageCache") { false } as Boolean

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
