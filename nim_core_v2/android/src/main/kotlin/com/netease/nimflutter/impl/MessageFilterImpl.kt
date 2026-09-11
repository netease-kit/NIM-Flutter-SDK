/*
 * Copyright (c) 2022 NetEase, Inc. All rights reserved.
 * Use of this source code is governed by a MIT license that can be
 * found in the LICENSE file.
 */

package com.netease.nimflutter.impl

import com.netease.nimflutter.MethodChannelSuspendResult
import com.netease.nimflutter.NimCore
import com.netease.nimflutter.extension.toMap
import com.netease.nimlib.sdk.v2.message.V2NIMMessage
import com.netease.nimlib.sdk.v2.message.model.V2NIMMessageFilter
import com.netease.yunxin.kit.alog.ALog
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.runBlocking
import kotlinx.coroutines.suspendCancellableCoroutine
import kotlinx.coroutines.withTimeoutOrNull

class MessageFilterImpl(val serviceName: String, val nimCore: NimCore) : V2NIMMessageFilter {
    private val messageFilterTimeout = 500L

    fun notifyEvent(
        method: String,
        arguments: Map<String, Any?>,
        callback: MethodChannel.Result? = null
    ) {
        ALog.d("MessageFilterImpl", "MessageFilterImpl notifyEvent method = $method arguments = $arguments")
        val params = arguments.toMutableMap().also { args -> args["serviceName"] = serviceName }
        nimCore.methodChannel.forEach { channel ->
            channel.invokeMethod(
                method,
                params,
                callback
            )
        }
    }

    override fun shouldIgnore(message: V2NIMMessage?): Boolean {
        return runBlocking {
            withTimeoutOrNull(messageFilterTimeout) {
                suspendCancellableCoroutine<Any?> { continuation ->
                    notifyEvent(
                        method = "shouldIgnore",
                        arguments = mapOf(
                            "message" to message?.toMap()
                        ),
                        callback = MethodChannelSuspendResult(continuation)
                    )
                } as Boolean? ?: false
            } == true
        }
    }
}
