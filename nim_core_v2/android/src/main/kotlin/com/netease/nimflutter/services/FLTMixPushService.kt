/*
 * Copyright (c) 2022 NetEase, Inc. All rights reserved.
 * Use of this source code is governed by a MIT license that can be
 * found in the LICENSE file.
 */

package com.netease.nimflutter.services

import android.content.Context
import android.os.Handler
import android.os.Looper
import android.util.Pair
import com.netease.nimflutter.FLTService
import com.netease.nimflutter.NimCore
import com.netease.nimflutter.NimResult
import com.netease.nimlib.sdk.NIMClient
import com.netease.nimlib.sdk.Observer
import com.netease.nimlib.sdk.mixpush.IManualProvidePushTokenCallback
import com.netease.nimlib.sdk.mixpush.MixPushServiceObserve
import com.netease.nimlib.sdk.mixpush.NIMPushClient
import com.netease.nimlib.sdk.mixpush.model.MixPushToken
import com.netease.nimlib.sdk.mixpush.model.MixPushTypeEnum
import com.netease.yunxin.kit.alog.ALog
import io.flutter.plugin.common.MethodChannel
import java.util.concurrent.CountDownLatch
import java.util.concurrent.TimeUnit

class FLTMixPushService(
    applicationContext: Context,
    nimCore: NimCore
) : FLTService(applicationContext, nimCore) {
    private val tag = "FLTMixPushService"

    override val serviceName = "MixPushService"

    // / 标记是否已注册手动提供 Token 的回调
    private var isManualCallbackRegistered = false

    init {
        registerFlutterMethodCalls(
            "registerManuallyProvidePushTokenCallback" to ::registerManuallyProvidePushTokenCallback
        )

        // SDK 初始化后注册推送 Token 变化监听
        nimCore.onInitialized {
            NIMClient.getService(MixPushServiceObserve::class.java).apply {
                observeMixPushToken(mixPushTokenObserver, true)
            }

            // 如果在初始化前调用了注册，则在初始化后执行实际注册
            if (isManualCallbackRegistered) {
                doRegisterManuallyProvidePushTokenCallback()
            }
        }
    }

    // / 监听推送 Token 变化
    private val mixPushTokenObserver =
        Observer<MixPushToken> { pushToken ->
            ALog.d(tag, "onMixPushToken: $pushToken")
            notifyEvent("onMixPushToken", pushToken.toMap() as MutableMap<String, Any?>)
        }

    // / 手动提供 Token 的回调实现
    private val manualProvidePushTokenCallback =
        object : IManualProvidePushTokenCallback {
            override fun onToken(suggestedPushType: MixPushTypeEnum?): Pair<MixPushTypeEnum, String>? {
                ALog.d(tag, "onToken called with suggestedPushType: $suggestedPushType")

                // 使用 CountDownLatch 来等待 Flutter 返回结果
                val latch = CountDownLatch(1)
                var resultPushType: MixPushTypeEnum? = null
                var resultToken: String? = null

                val params =
                    mutableMapOf<String, Any?>(
                        "suggestedPushType" to (suggestedPushType?.value ?: MixPushTypeEnum.UNKNOWN.value)
                    )

                // 需要在主线程调用 invokeMethod
                Handler(Looper.getMainLooper()).post {
                    notifyEvent(
                        "onManuallyProvidePushToken",
                        params,
                        object : MethodChannel.Result {
                            override fun success(result: Any?) {
                                ALog.d(tag, "onManuallyProvidePushToken success: $result")
                                (result as? Map<*, *>)?.let { map ->
                                    val pushTypeValue = (map["pushType"] as? Number)?.toInt()
                                    resultPushType = pushTypeValue?.let { MixPushTypeEnum.typeOfValue(it) }
                                    resultToken = map["token"] as? String
                                }
                                latch.countDown()
                            }

                            override fun error(
                                errorCode: String,
                                errorMessage: String?,
                                errorDetails: Any?
                            ) {
                                ALog.e(tag, "onManuallyProvidePushToken error: $errorCode, $errorMessage")
                                latch.countDown()
                            }

                            override fun notImplemented() {
                                ALog.e(tag, "onManuallyProvidePushToken notImplemented")
                                latch.countDown()
                            }
                        }
                    )
                }

                // 等待最多 30 秒获取 Flutter 返回的结果
                try {
                    val success = latch.await(30, TimeUnit.SECONDS)
                    if (!success) {
                        ALog.e(tag, "onToken timeout waiting for Flutter response")
                        return null
                    }
                } catch (e: InterruptedException) {
                    ALog.e(tag, "onToken interrupted", e)
                    return null
                }

                return if (resultPushType != null && resultToken != null) {
                    ALog.d(tag, "onToken returning: pushType=$resultPushType, token=$resultToken")
                    Pair(resultPushType, resultToken)
                } else {
                    ALog.d(tag, "onToken returning null")
                    null
                }
            }
        }

    // / 实际执行注册手动提供 Token 回调
    private fun doRegisterManuallyProvidePushTokenCallback() {
        ALog.d(tag, "doRegisterManuallyProvidePushTokenCallback")
        NIMPushClient.registerManuallyProvidePushTokenCallback(manualProvidePushTokenCallback)
    }

    private suspend fun registerManuallyProvidePushTokenCallback(
        arguments: Map<String, *>
    ): NimResult<Nothing> {
        ALog.d(tag, "registerManuallyProvidePushTokenCallback called, isInitialized: ${nimCore.isInitialized}")

        isManualCallbackRegistered = true

        // 如果 SDK 已初始化，立即注册；否则在 onInitialized 回调中注册
        if (nimCore.isInitialized) {
            doRegisterManuallyProvidePushTokenCallback()
        }

        return NimResult(code = 0, data = null)
    }
}

// / MixPushToken 转换为 Map
fun MixPushToken.toMap() =
    mapOf<String, Any?>(
        "token" to token,
        "tokenName" to tokenName,
        "pushType" to pushType.value
    )
