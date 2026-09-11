/*
 * Copyright (c) 2022 NetEase, Inc. All rights reserved.
 * Use of this source code is governed by a MIT license that can be
 * found in the LICENSE file.
 */

package com.netease.nimflutter.impl

import com.netease.nimflutter.NimCore
import com.netease.nimflutter.extension.toMap
import com.netease.nimlib.sdk.v2.chatroom.V2NIMChatroomListener
import com.netease.nimlib.sdk.v2.chatroom.enums.V2NIMChatroomMemberRole
import com.netease.nimlib.sdk.v2.chatroom.model.V2NIMChatroomInfo
import com.netease.nimlib.sdk.v2.chatroom.model.V2NIMChatroomMember
import com.netease.nimlib.sdk.v2.chatroom.model.V2NIMChatroomMessage
import com.netease.yunxin.kit.alog.ALog
import io.flutter.plugin.common.MethodChannel

class ChatroomListenerImpl(val serviceName: String, val nimCore: NimCore, val instanceId: Int) : V2NIMChatroomListener {
    override fun onReceiveMessages(messages: MutableList<V2NIMChatroomMessage>?) {
        val resultMap = mapOf(
            "messages" to messages?.map { it.toMap() },
            "instanceId" to instanceId
        )
        notifyEvent("onReceiveMessages", resultMap)
    }

    override fun onSendMessage(message: V2NIMChatroomMessage?) {
        val resultMap = mapOf(
            "message" to message?.toMap(),
            "instanceId" to instanceId
        )
        notifyEvent("onSendMessage", resultMap)
    }

    override fun onChatroomMemberEnter(member: V2NIMChatroomMember?) {
        val resultMap = mapOf(
            "member" to member?.toMap(),
            "instanceId" to instanceId
        )
        notifyEvent("onChatroomMemberEnter", resultMap)
    }

    override fun onChatroomMemberExit(accountId: String?) {
        val resultMap = mapOf(
            "accountId" to accountId,
            "instanceId" to instanceId
        )
        notifyEvent("onChatroomMemberExit", resultMap)
    }

    override fun onChatroomMemberRoleUpdated(previousRole: V2NIMChatroomMemberRole?, member: V2NIMChatroomMember?) {
        val resultMap = mapOf(
            "previousRole" to previousRole?.value,
            "member" to member?.toMap(),
            "instanceId" to instanceId
        )
        notifyEvent("onChatroomMemberRoleUpdated", resultMap)
    }

    override fun onChatroomMemberInfoUpdated(member: V2NIMChatroomMember?) {
        val resultMap = mapOf(
            "member" to member?.toMap(),
            "instanceId" to instanceId
        )
        notifyEvent("onChatroomMemberInfoUpdated", resultMap)
    }

    override fun onSelfChatBannedUpdated(chatBanned: Boolean) {
        val resultMap = mapOf(
            "chatBanned" to chatBanned,
            "instanceId" to instanceId
        )
        notifyEvent("onSelfChatBannedUpdated", resultMap)
    }

    override fun onSelfTempChatBannedUpdated(tempChatBanned: Boolean, tempChatBannedDuration: Long) {
        val resultMap = mapOf(
            "tempChatBanned" to tempChatBanned,
            "tempChatBannedDuration" to tempChatBannedDuration,
            "instanceId" to instanceId
        )
        notifyEvent("onSelfTempChatBannedUpdated", resultMap)
    }

    override fun onChatroomInfoUpdated(chatroom: V2NIMChatroomInfo?) {
        val resultMap = mapOf(
            "info" to chatroom?.toMap(),
            "instanceId" to instanceId
        )
        notifyEvent("onChatroomInfoUpdated", resultMap)
    }

    override fun onChatroomChatBannedUpdated(chatBanned: Boolean) {
        val resultMap = mapOf(
            "chatBanned" to chatBanned,
            "instanceId" to instanceId
        )
        notifyEvent("onChatroomChatBannedUpdated", resultMap)
    }

    override fun onMessageRevokedNotification(messageClientId: String?, messageTime: Long) {
        val resultMap = mapOf(
            "messageClientId" to messageClientId,
            "messageTime" to messageTime,
            "instanceId" to instanceId
        )
        notifyEvent("onMessageRevokedNotification", resultMap)
    }

    override fun onChatroomTagsUpdated(tags: MutableList<String>?) {
        val resultMap = mapOf(
            "tags" to tags?.map { it },
            "instanceId" to instanceId
        )
        notifyEvent("onChatroomTagsUpdated", resultMap)
    }

    protected fun notifyEvent(
        method: String,
        arguments: Map<String, Any?>,
        callback: MethodChannel.Result? = null
    ) {
        ALog.d("${instanceId}_K", "ChatroomListenerImpl notifyEvent method = $method arguments = $arguments")
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
