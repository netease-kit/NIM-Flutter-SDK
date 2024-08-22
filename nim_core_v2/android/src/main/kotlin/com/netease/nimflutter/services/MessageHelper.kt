/*
 * Copyright (c) 2022 NetEase, Inc. All rights reserved.
 * Use of this source code is governed by a MIT license that can be
 * found in the LICENSE file.
 */

package com.netease.nimflutter.services

import android.text.TextUtils
import com.netease.nimflutter.convertCustomMessageConfig
import com.netease.nimflutter.convertMemberPushOption
import com.netease.nimflutter.convertMsgThreadOption
import com.netease.nimflutter.convertNIMAntiSpamOption
import com.netease.nimflutter.convertNIMMessageRobotInfo
import com.netease.nimflutter.stringToAttachStatusEnum
import com.netease.nimflutter.stringToClientTypeEnum
import com.netease.nimflutter.stringToMsgDirectionEnum
import com.netease.nimflutter.stringToMsgStatusEnum
import com.netease.nimflutter.stringToMsgTypeEnum
import com.netease.nimflutter.stringToNimNosSceneKeyConstant
import com.netease.nimflutter.stringToSessionTypeEnum
import com.netease.nimlib.chatroom.model.ChatRoomMessageImpl
import com.netease.nimlib.sdk.chatroom.model.ChatRoomMessage
import com.netease.nimlib.sdk.chatroom.model.ChatRoomMessageExtension
import com.netease.nimlib.sdk.chatroom.model.CustomChatRoomMessageConfig
import com.netease.nimlib.sdk.msg.MessageBuilder
import com.netease.nimlib.sdk.msg.constant.MsgTypeEnum
import com.netease.nimlib.sdk.msg.constant.SessionTypeEnum
import com.netease.nimlib.sdk.msg.model.IMMessage
import com.netease.nimlib.sdk.msg.model.MessageKey
import com.netease.nimlib.session.IMMessageImpl
import com.netease.yunxin.kit.alog.ALog
import java.io.File
import org.json.JSONObject

object MessageHelper {

    // 仅供创建消息使用，如果是一个完整消息从 Dart 层过来，使用 convert 方法
    @Suppress("UNCHECKED_CAST")
    fun createMessage(arguments: Map<String, *>): IMMessage? {
        val messageType = stringToMsgTypeEnum(arguments["messageType"] as String?)
        val sessionId = arguments["sessionId"] as String?
        val sessionType = stringToSessionTypeEnum(arguments["sessionType"] as String?)
        return when (messageType) {
            MsgTypeEnum.text -> createTextMessage(
                sessionId,
                sessionType,
                arguments["content"] as? String
            )
            MsgTypeEnum.image -> createImageMessage(
                sessionId,
                sessionType,
                arguments["messageAttachment"] as? Map<String, Any?>
            )
            MsgTypeEnum.audio -> createAudioMessage(
                sessionId,
                sessionType,
                arguments["messageAttachment"] as? Map<String, Any?>
            )
            MsgTypeEnum.video -> createVideoMessage(
                sessionId,
                sessionType,
                arguments["messageAttachment"] as? Map<String, Any?>
            )
            MsgTypeEnum.location -> createLocationMessage(
                sessionId,
                sessionType,
                arguments["messageAttachment"] as? Map<String, Any?>
            )
            MsgTypeEnum.file -> createFileMessage(
                sessionId,
                sessionType,
                arguments["messageAttachment"] as? Map<String, Any?>
            )
            MsgTypeEnum.tip -> createTipMessage(
                sessionId,
                sessionType,
                arguments["content"] as? String
            )
            MsgTypeEnum.custom -> createCustomMessage(
                sessionId,
                sessionType,
                arguments["content"] as? String?,
                arguments["messageAttachment"] as? Map<String, Any?>,
                arguments["config"] as? Map<String, Any?>?
            )
            else -> null
        }
    }

    private fun createTextMessage(
        sessionId: String?,
        sessionType: SessionTypeEnum,
        text: String?
    ): IMMessage? {
        return MessageBuilder.createTextMessage(sessionId, sessionType, text)
    }

    private fun createTipMessage(
        sessionId: String?,
        sessionType: SessionTypeEnum,
        content: String?
    ): IMMessage? {
        val message = MessageBuilder.createTipMessage(sessionId, sessionType)
        message.content = content
        return message
    }

    private fun createImageMessage(
        sessionId: String?,
        sessionType: SessionTypeEnum,
        attachment: Map<String, *>?
    ): IMMessage? {
        return attachment?.let {
            runCatching {
                val filePath = attachment["path"] as? String
                val displayName = attachment["name"] as? String
                val nosScene = attachment["sen"] as? String
                filePath?.let {
                    MessageBuilder.createImageMessage(
                        sessionId,
                        sessionType,
                        File(filePath),
                        displayName,
                        stringToNimNosSceneKeyConstant(nosScene)
                    )
                }
            }.onFailure { exception ->
                ALog.e(
                    "MessageHelper",
                    "createImageMessage exception:${exception.message}"
                )
            }.getOrNull()
        }
    }

    private fun createAudioMessage(
        sessionId: String?,
        sessionType: SessionTypeEnum,
        attachment: Map<String, *>?
    ): IMMessage? {
        return attachment?.let {
            runCatching {
                val filePath = attachment["path"] as? String
                val duration = attachment["dur"] as? Number
                val nosScene = attachment["sen"] as? String
                filePath?.let {
                    val file = File(filePath)
                    MessageBuilder.createAudioMessage(
                        sessionId,
                        sessionType,
                        file,
                        duration!!.toLong(),
                        stringToNimNosSceneKeyConstant(nosScene)
                    )
                }
            }.onFailure { exception ->
                ALog.e("MessageHelper", "createAudioMessage exception:${exception.message}")
            }.getOrNull()
        }
    }

    private fun createVideoMessage(
        sessionId: String?,
        sessionType: SessionTypeEnum,
        attachment: Map<String, *>?
    ): IMMessage? {
        return attachment?.let {
            runCatching {
                val filePath = it["path"] as? String
                val duration = it["dur"] as? Number
                val width = it["w"] as? Number
                val height = it["h"] as? Number
                val displayName = it["name"] as? String
                val nosScene = it["sen"] as? String
                filePath?.let {
                    val file = File(it)
                    MessageBuilder.createVideoMessage(
                        sessionId,
                        sessionType,
                        file,
                        duration!!.toLong(),
                        width!!.toInt(),
                        height!!.toInt(),
                        displayName,
                        stringToNimNosSceneKeyConstant(nosScene)
                    )
                }
            }.onFailure { exception ->
                ALog.e("MessageHelper", "createVideoMessage exception:${exception.message}")
            }.getOrNull()
        }
    }

    private fun createLocationMessage(
        sessionId: String?,
        sessionType: SessionTypeEnum,
        attachment: Map<String, *>?
    ): IMMessage? {
        return attachment?.let {
            val latitude = it["lat"] as? Number
            val longitude = it["lng"] as? Number
            val address = it["title"] as? String
            MessageBuilder.createLocationMessage(
                sessionId,
                sessionType,
                latitude!!.toDouble(),
                longitude!!.toDouble(),
                address
            )
        }
    }

    private fun createFileMessage(
        sessionId: String?,
        sessionType: SessionTypeEnum,
        attachment: Map<String, *>?
    ): IMMessage? {
        return attachment?.let {
            runCatching {
                val filePath = it["path"] as? String
                val displayName = it["name"] as? String
                val nosScene = it["sen"] as? String
                filePath?.let {
                    val file = File(filePath)
                    MessageBuilder.createFileMessage(
                        sessionId,
                        sessionType,
                        file,
                        displayName,
                        stringToNimNosSceneKeyConstant(nosScene)
                    )
                }
            }.onFailure { exception ->
                ALog.e("MessageHelper", "createFileMessage exception:${exception.message}")
            }.getOrNull()
        }
    }

    private fun createCustomMessage(
        sessionId: String?,
        sessionType: SessionTypeEnum,
        content: String?,
        attachment: Map<String, *>?,
        config: Map<String, Any?>?
    ): IMMessage? {
        return attachment?.let {
            runCatching {
                val nosScene = attachment["sen"] as? String
                val customConfig = convertCustomMessageConfig(config)
                val messageType = stringToMsgTypeEnum(attachment["messageType"] as? String)
                val messageAttachment = AttachmentHelper.attachmentFromMap(messageType, attachment)

                MessageBuilder.createCustomMessage(
                    sessionId,
                    sessionType,
                    content,
                    messageAttachment,
                    customConfig,
                    stringToNimNosSceneKeyConstant(nosScene)
                )
            }.onFailure { exception ->
                ALog.e("MessageHelper", "createCustomMessage exception:${exception.message}")
            }.getOrNull()
        }
    }

    @Suppress("UNCHECKED_CAST")
    private fun IMMessageImpl.configureWithMap(configurations: Map<String, Any?>): IMMessageImpl {
        configurations.let {
            messageId = (it.getOrElse("messageId") { "-1" } as String).toLong()
            sessionId = it["sessionId"] as String?
            sessionType = stringToSessionTypeEnum(it["sessionType"] as String?)
            setMsgType(stringToMsgTypeEnum(it["messageType"] as String?).value)
            (it["messageSubType"] as Number?)?.toInt()?.let { sub ->
                if (sub > 0) subtype = sub
            }
            status = stringToMsgStatusEnum(it["status"] as String?)
            direct = stringToMsgDirectionEnum(it["messageDirection"] as String?)
            fromAccount = it["fromAccount"] as String?
            content = it["content"] as String?
            time = (it.getOrElse("timestamp") { 0L } as Number).toLong()
            attachment = it["messageAttachment"].let { it1 ->
                val type =
                    stringToMsgTypeEnum((it1 as Map<String, Any?>?)?.get("messageType") as String?)
                AttachmentHelper.attachmentFromMap(type, it1 as Map<String, *>)
            }
            attachStatus = stringToAttachStatusEnum(it["attachmentStatus"] as String?)
            uuid = it["uuid"] as String?
            serverId = (it.getOrElse("serverId") { -1 } as Number).toLong()
            config = convertCustomMessageConfig(it["config"] as Map<String, Any?>?)
            remoteExtension = it["remoteExtension"] as MutableMap<String, Any>?
            localExtension = it["localExtension"] as MutableMap<String, Any>?
            callbackExtension = it["callbackExtension"] as String?
            pushPayload = it["pushPayload"] as MutableMap<String, Any>?
            pushContent = it["pushContent"] as String?
            memberPushOption =
                convertMemberPushOption(it["memberPushOption"] as Map<String, Any?>?)
            fromClientType = stringToClientTypeEnum(it["senderClientType"] as String?)
            nimAntiSpamOption =
                convertNIMAntiSpamOption(it["antiSpamOption"] as Map<String, Any?>?)
            setMsgAck(it.getOrElse("messageAck") { false } as Boolean)
            setHasSendAck(it.getOrElse("hasSendAck") { false } as Boolean)
            teamMsgAckCount = it.getOrElse("ackCount") { 0 } as Int
            teamMsgUnAckCount = it.getOrElse("unAckCount") { 0 } as Int
            clientAntiSpam = it.getOrElse("clientAntiSpam") { false } as Boolean
            isInBlackList = it.getOrElse("isInBlackList") { false } as Boolean
            isChecked = it.getOrElse("isChecked") { false } as Boolean
            isSessionUpdate = it.getOrElse("sessionUpdate") { true } as Boolean
            threadOption =
                convertMsgThreadOption(it["messageThreadOption"] as Map<String, Any?>?)
            quickCommentUpdateTime =
                (it.getOrElse("quickCommentUpdateTime") { 0L } as Number).toLong()
            isDeleted = it.getOrElse("isDeleted") { true } as Boolean
            yidunAntiCheating = it["yidunAntiCheating"]?.let { it1 ->
                (it1 as? Map<*, *>)?.let { it2 ->
                    JSONObject(it2).toString()
                }
            }
            yidunAntiSpamExt = it["yidunAntiSpamExt"] as String?
            yidunAntiSpamRes = it["yidunAntiSpamRes"] as String?
            env = it["env"] as String?
            robotInfo = convertNIMMessageRobotInfo(it["robotInfo"] as Map<String, Any?>?)
        }
        return this
    }

    fun convertIMMessage(map: Map<String, Any?>?): IMMessage? {
        return map?.let {
            val sessionType = stringToSessionTypeEnum(map["sessionType"] as String?)
            if (sessionType == SessionTypeEnum.ChatRoom) {
                convertChatroomMessage(map)
            } else {
                IMMessageImpl().configureWithMap(it)
            }
        }
    }

    @Suppress("UNCHECKED_CAST")
    fun convertChatroomMessage(map: Map<String, Any?>): ChatRoomMessage {
        return ChatRoomMessageImpl().apply {
            configureWithMap(map)
            chatRoomConfig = CustomChatRoomMessageConfig().apply {
                skipHistory = !(map.getOrElse("enableHistory") { true } as Boolean)
            }
            (map["extension"] as? Map<String, *>)?.let {
                chatRoomMessageExtension = ChatRoomMessageExtension().apply {
                    senderNick = it["nickname"] as? String
                    senderAvatar = it["avatar"] as? String
                    senderExtension = it["senderExtension"] as? Map<String, *>
                }
            }
        }
    }

    fun sessionIdOfMsg(msgKey: MessageKey): String? {
        val sessionType = msgKey.sessionType
        val fromId = msgKey.fromAccount
        val receiver = msgKey.toAccount
        val currentLoginAccount =
            MessageBuilder.createTextMessage("", SessionTypeEnum.None, "").fromAccount
        return if (sessionType == SessionTypeEnum.P2P) {
            if (TextUtils.equals(currentLoginAccount, fromId)) receiver else fromId
        } else {
            receiver
        }
    }

    fun receiverOfMsg(msg: IMMessage): String? {
        if (msg.sessionType == SessionTypeEnum.None) {
            return ""
        }
        val currentLoginAccount =
            MessageBuilder.createTextMessage("", SessionTypeEnum.None, "").fromAccount
        val me: String = currentLoginAccount ?: return ""
        val isP2P = msg.sessionType == SessionTypeEnum.P2P
        return if (!isP2P || me == msg.fromAccount) msg.sessionId else me
    }
}
