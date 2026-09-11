/*
 * Copyright (c) 2022 NetEase, Inc. All rights reserved.
 * Use of this source code is governed by a MIT license that can be
 * found in the LICENSE file.
 */

package com.netease.nimflutter.impl

import com.netease.nimflutter.MethodChannelSuspendResult
import com.netease.nimflutter.NimCore
import com.netease.nimlib.sdk.v2.chatroom.provider.V2NIMChatroomTokenProvider
import com.netease.yunxin.kit.alog.ALog
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.runBlocking
import kotlinx.coroutines.suspendCancellableCoroutine
import kotlinx.coroutines.withTimeoutOrNull

class ChatroomTokenProviderImpl(val serviceName: String, val nimCore: NimCore, val instanceId: Int) : V2NIMChatroomTokenProvider {
    private val chatroomLinkProviderTimeout = 500L

    override fun getToken(roomId: String?, accountId: String?): String? {
        return runBlocking {
            withTimeoutOrNull(chatroomLinkProviderTimeout) {
                suspendCancellableCoroutine<Any?> { continuation ->
                    notifyEvent(
                        method = "getToken",
                        arguments = mapOf(
                            "accountId" to accountId,
                            "roomId" to roomId,
                            "instanceId" to instanceId
                        ),
                        callback = MethodChannelSuspendResult(continuation)
                    )
                } as String?
            }
        }
    }

    protected fun notifyEvent(
        method: String,
        arguments: Map<String, Any?>,
        callback: MethodChannel.Result? = null
    ) {
        ALog.d("${instanceId}_K", "ChatroomClientListenerImpl notifyEvent method = $method arguments = $arguments")
        val params = arguments.toMutableMap().also { args -> args["serviceName"] = serviceName }
        nimCore.methodChannel.forEach { channel ->
            channel.invokeMethod(
                method,
                params,
                callback
            )
        }
    }
}
