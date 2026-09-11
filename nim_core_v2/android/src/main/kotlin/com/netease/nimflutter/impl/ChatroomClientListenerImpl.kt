/*
 * Copyright (c) 2022 NetEase, Inc. All rights reserved.
 * Use of this source code is governed by a MIT license that can be
 * found in the LICENSE file.
 */

package com.netease.nimflutter.impl

import com.netease.nimflutter.NimCore
import com.netease.nimflutter.extension.toMap
import com.netease.nimlib.sdk.v2.V2NIMError
import com.netease.nimlib.sdk.v2.chatroom.V2NIMChatroomClientListener
import com.netease.nimlib.sdk.v2.chatroom.enums.V2NIMChatroomStatus
import com.netease.nimlib.sdk.v2.chatroom.model.V2NIMChatroomKickedInfo
import com.netease.yunxin.kit.alog.ALog
import io.flutter.plugin.common.MethodChannel

class ChatroomClientListenerImpl(val serviceName: String, val nimCore: NimCore, val instanceId: Int) : V2NIMChatroomClientListener {

    override fun onChatroomStatus(status: V2NIMChatroomStatus?, error: V2NIMError?) {
        val resultMap = mapOf(
            "error" to error?.toMap(),
            "status" to status?.value,
            "instanceId" to instanceId
        )
        notifyEvent("onChatroomStatus", resultMap)
    }

    override fun onChatroomEntered() {
        notifyEvent("onChatroomEntered", mapOf("instanceId" to instanceId))
    }

    override fun onChatroomExited(error: V2NIMError?) {
        val resultMap = mapOf(
            "error" to error?.toMap(),
            "instanceId" to instanceId
        )
        notifyEvent("onChatroomExited", resultMap)
    }

    override fun onChatroomKicked(kickedInfo: V2NIMChatroomKickedInfo?) {
        val resultMap = mapOf(
            "instanceId" to instanceId,
            "kickedInfo" to kickedInfo?.toMap()
        )
        notifyEvent("onChatroomKicked", resultMap)
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
