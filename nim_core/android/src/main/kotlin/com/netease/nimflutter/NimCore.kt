/*
 * Copyright (c) 2022 NetEase, Inc. All rights reserved.
 * Use of this source code is governed by a MIT license that can be
 * found in the LICENSE file.
 */

package com.netease.nimflutter

import android.app.Activity
import android.content.Context
import com.netease.nimflutter.initialize.FLTInitializeService
import com.netease.nimflutter.services.FLTAudioRecorderService
import com.netease.nimflutter.services.FLTAuthService
import com.netease.nimflutter.services.FLTChatroomService
import com.netease.nimflutter.services.FLTEventSubscribeService
import com.netease.nimflutter.services.FLTMessageService
import com.netease.nimflutter.services.FLTNOSService
import com.netease.nimflutter.services.FLTPassThroughService
import com.netease.nimflutter.services.FLTQChatChannelService
import com.netease.nimflutter.services.FLTQChatMessageService
import com.netease.nimflutter.services.FLTQChatObserverService
import com.netease.nimflutter.services.FLTQChatPushService
import com.netease.nimflutter.services.FLTQChatRoleService
import com.netease.nimflutter.services.FLTQChatServerService
import com.netease.nimflutter.services.FLTQChatService
import com.netease.nimflutter.services.FLTSettingsService
import com.netease.nimflutter.services.FLTSignallingService
import com.netease.nimflutter.services.FLTSuperTeamService
import com.netease.nimflutter.services.FLTSystemMessageService
import com.netease.nimflutter.services.FLTTeamService
import com.netease.nimflutter.services.FLTUserService
import com.netease.yunxin.kit.alog.ALog
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterAssets
import kotlinx.coroutines.CoroutineExceptionHandler
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob

typealias ServiceFactory = (context: Context, nimCore: NimCore) -> FLTService

class NimCore private constructor(
    private val context: Context,
    val flutterAssets: FlutterAssets
) {

    companion object : SingletonHolder<NimCore, Context, FlutterAssets>(::NimCore)

    val lifeCycleScope = CoroutineScope(
        context = SupervisorJob() + Dispatchers.Main.immediate +
            CoroutineExceptionHandler { _, throwable ->
                ALog.e(tag, "coroutine exception", throwable)
            }
    )

    var activity: Activity? = null

    var methodChannel: ArrayList<SafeMethodChannel> = ArrayList()

    private val services = mutableMapOf<String, FLTService>()

    private lateinit var initializer: FLTInitializeService

    init {
        registerService(::FLTInitializeService)
        registerService(::FLTAuthService)
        registerService(::FLTMessageService)
        registerService(::FLTAudioRecorderService)
        registerService(::FLTUserService)
        registerService(::FLTEventSubscribeService)
        registerService(::FLTSystemMessageService)
        registerService(::FLTChatroomService)
        registerService(::FLTTeamService)
        registerService(::FLTSuperTeamService)
        registerService(::FLTNOSService)
        registerService(::FLTSettingsService)
        registerService(::FLTPassThroughService)
        registerService(::FLTSignallingService)
        registerService(::FLTQChatServerService)
        registerService(::FLTQChatService)
        registerService(::FLTQChatChannelService)
        registerService(::FLTQChatMessageService)
        registerService(::FLTQChatObserverService)
        registerService(::FLTQChatRoleService)
        registerService(::FLTQChatPushService)
    }

    private val tag = "FLTNimCore_K"

    private fun registerService(factory: ServiceFactory) =
        factory(context, this).also { service ->
            services[service.serviceName] = service
            if (service is FLTInitializeService) {
                initializer = service
            }
        }

    fun onMethodCall(method: String, arguments: Map<String, *>?, safeResult: SafeResult) {
        if (arguments == null) {
            ALog.e(tag, "$method has not been implemented,arguments is null")
            safeResult.notImplemented()
            return
        }
        val serviceName = arguments["serviceName"] as? String
        ALog.i(tag, "onMethodCall: $serviceName#$method")
        if (services.containsKey(serviceName)) {
            val service = services[serviceName] as FLTService
            if (isInitialized || service === initializer) {
                service.dispatchFlutterMethodCall(method, arguments, safeResult)
            } else {
                safeResult.success(
                    NimResult<Nothing>(
                        code = -1,
                        errorDetails = "SDK Uninitialized"
                    ).toMap()
                )
            }
        } else {
            ALog.e(tag, "$serviceName#$method has not been implemented")
            safeResult.notImplemented()
        }
    }

    val sdkOptions
        get() = initializer.sdkOptions

    val isInitialized
        get() = initializer.isInitialized

    fun onInitialized(callback: suspend () -> Unit) =
        initializer.onInitialized(callback)
}

open class SingletonHolder<out T, in A, B>(private val creator: (A, B) -> T) {
    @Volatile
    private var instance: T? = null

    fun getInstance(argA: A, argB: B): T {
        val i = instance
        if (i != null) {
            return i
        }

        return synchronized(this) {
            val i2 = instance
            if (i2 != null) {
                i2
            } else {
                val created = creator(argA, argB)
                instance = created
                created
            }
        }
    }
}
