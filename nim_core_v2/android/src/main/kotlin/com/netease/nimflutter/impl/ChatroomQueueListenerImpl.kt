/*
 * Copyright (c) 2022 NetEase, Inc. All rights reserved.
 * Use of this source code is governed by a MIT license that can be
 * found in the LICENSE file.
 */

package com.netease.nimflutter.impl

import com.netease.nimflutter.NimCore
import com.netease.nimflutter.extension.toMap
import com.netease.nimlib.sdk.v2.chatroom.V2NIMChatroomQueueListener
import com.netease.nimlib.sdk.v2.chatroom.model.V2NIMChatroomQueueElement
import com.netease.yunxin.kit.alog.ALog
import io.flutter.plugin.common.MethodChannel

class ChatroomQueueListenerImpl(val serviceName: String, val nimCore: NimCore, val instanceId: Int) : V2NIMChatroomQueueListener {
    override fun onChatroomQueueOffered(element: V2NIMChatroomQueueElement?) {
        val resultMap = mapOf(
            "element" to element?.toMap(),
            "instanceId" to instanceId
        )
        notifyEvent("onChatroomQueueOffered", resultMap)
    }

    override fun onChatroomQueuePolled(element: V2NIMChatroomQueueElement?) {
        val resultMap = mapOf(
            "element" to element?.toMap(),
            "instanceId" to instanceId
        )
        notifyEvent("onChatroomQueuePolled", resultMap)
    }

    override fun onChatroomQueueDropped() {
        val resultMap = mapOf(
            "instanceId" to instanceId
        )
        notifyEvent("onChatroomQueueDropped", resultMap)
    }

    override fun onChatroomQueuePartCleared(elements: MutableList<V2NIMChatroomQueueElement>?) {
        val resultMap = mapOf(
            "elements" to elements?.map { it.toMap() }?.toList(),
            "instanceId" to instanceId
        )
        notifyEvent("onChatroomQueuePartCleared", resultMap)
    }

    override fun onChatroomQueueBatchUpdated(elements: MutableList<V2NIMChatroomQueueElement>?) {
        val resultMap = mapOf(
            "elements" to elements?.map { it.toMap() }?.toList(),
            "instanceId" to instanceId
        )
        notifyEvent("onChatroomQueueBatchUpdated", resultMap)
    }

    override fun onChatroomQueueBatchOffered(elements: MutableList<V2NIMChatroomQueueElement>?) {
        val resultMap = mapOf(
            "elements" to elements?.map { it.toMap() }?.toList(),
            "instanceId" to instanceId
        )
        notifyEvent("onChatroomQueueBatchOffered", resultMap)
    }

    protected fun notifyEvent(
        method: String,
        arguments: Map<String, Any?>,
        callback: MethodChannel.Result? = null
    ) {
        ALog.d("${instanceId}_K", "ChatroomQueueListenerImpl notifyEvent method = $method arguments = $arguments")
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
