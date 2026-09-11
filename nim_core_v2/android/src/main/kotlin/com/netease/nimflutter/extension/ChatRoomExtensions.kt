/*
 * Copyright (c) 2022 NetEase, Inc. All rights reserved.
 * Use of this source code is governed by a MIT license that can be
 * found in the LICENSE file.
 */

package com.netease.nimflutter.extension

import com.netease.nimflutter.FLTConstant
import com.netease.nimlib.sdk.v2.chatroom.attachment.V2NIMChatroomChatBannedNotificationAttachment
import com.netease.nimlib.sdk.v2.chatroom.attachment.V2NIMChatroomMemberEnterNotificationAttachment
import com.netease.nimlib.sdk.v2.chatroom.attachment.V2NIMChatroomMemberRoleUpdateAttachment
import com.netease.nimlib.sdk.v2.chatroom.attachment.V2NIMChatroomMessageRevokeNotificationAttachment
import com.netease.nimlib.sdk.v2.chatroom.attachment.V2NIMChatroomNotificationAttachment
import com.netease.nimlib.sdk.v2.chatroom.attachment.V2NIMChatroomQueueNotificationAttachment
import com.netease.nimlib.sdk.v2.chatroom.config.V2NIMChatroomMessageConfig
import com.netease.nimlib.sdk.v2.chatroom.config.V2NIMUserInfoConfig
import com.netease.nimlib.sdk.v2.chatroom.enums.V2NIMChatroomMessageNotificationType
import com.netease.nimlib.sdk.v2.chatroom.model.V2NIMChatroomEnterInfo
import com.netease.nimlib.sdk.v2.chatroom.model.V2NIMChatroomInfo
import com.netease.nimlib.sdk.v2.chatroom.model.V2NIMChatroomKickedInfo
import com.netease.nimlib.sdk.v2.chatroom.model.V2NIMChatroomMember
import com.netease.nimlib.sdk.v2.chatroom.model.V2NIMChatroomMessage
import com.netease.nimlib.sdk.v2.chatroom.model.V2NIMChatroomQueueElement
import com.netease.nimlib.sdk.v2.chatroom.model.V2NIMLocationInfo
import com.netease.nimlib.sdk.v2.chatroom.result.V2NIMChatroomEnterResult
import com.netease.nimlib.sdk.v2.chatroom.result.V2NIMChatroomMemberListResult
import com.netease.nimlib.sdk.v2.chatroom.result.V2NIMSendChatroomMessageResult
import com.netease.nimlib.sdk.v2.message.attachment.V2NIMMessageAttachment
import com.netease.nimlib.sdk.v2.message.attachment.V2NIMMessageAudioAttachment
import com.netease.nimlib.sdk.v2.message.attachment.V2NIMMessageCallAttachment
import com.netease.nimlib.sdk.v2.message.attachment.V2NIMMessageFileAttachment
import com.netease.nimlib.sdk.v2.message.attachment.V2NIMMessageImageAttachment
import com.netease.nimlib.sdk.v2.message.attachment.V2NIMMessageLocationAttachment
import com.netease.nimlib.sdk.v2.message.attachment.V2NIMMessageVideoAttachment
import com.netease.nimlib.sdk.v2.message.enums.V2NIMMessageAttachmentUploadState
import com.netease.nimlib.sdk.v2.message.enums.V2NIMMessageSendingState
import com.netease.nimlib.sdk.v2.message.enums.V2NIMMessageType
import com.netease.nimlib.v2.chatroom.builder.V2NIMChatroomMessageBuilder

fun V2NIMSendChatroomMessageResult.toMap(): Map<String, Any?> {
    return mapOf(
        "message" to message?.toMap(),
        "antispamResult" to antispamResult,
        "clientAntispamResult" to clientAntispamResult?.toMap()
    )
}

fun V2NIMChatroomMessage.toMap(): Map<String, Any?> {
    return mapOf(
        "messageClientId" to messageClientId,
        "senderClientType" to senderClientType,
        "createTime" to createTime,
        "senderId" to senderId,
        "roomId" to roomId,
        "isSelf" to isSelf,
        "attachment" to this.attachmentToMap(),
        "attachmentUploadState" to attachmentUploadState?.value,
        "sendingState" to sendingState?.value,
        "messageType" to messageType?.value,
        "subType" to subType,
        "text" to text,
        "serverExtension" to serverExtension,
        "callbackExtension" to callbackExtension,
        "routeConfig" to routeConfig?.toMap(),
        "antispamConfig" to antispamConfig?.toMap(),
        "notifyTargetTags" to notifyTargetTags,
        "messageConfig" to messageConfig?.toMap(),
        "userInfoConfig" to userInfoConfig?.toMap(),
        "locationInfo" to locationInfo?.toMap()
    )
}

fun V2NIMChatroomMessage.attachmentToMap(): Map<String, Any?>? {
    when (messageType) {
        V2NIMMessageType.V2NIM_MESSAGE_TYPE_FILE -> {
            val att = attachment as? V2NIMMessageFileAttachment
            return att?.toMap()
        }

        V2NIMMessageType.V2NIM_MESSAGE_TYPE_IMAGE -> {
            val att = attachment as? V2NIMMessageImageAttachment
            return att?.toMap()
        }

        V2NIMMessageType.V2NIM_MESSAGE_TYPE_AUDIO -> {
            val att = attachment as? V2NIMMessageAudioAttachment
            return att?.toMap()
        }

        V2NIMMessageType.V2NIM_MESSAGE_TYPE_VIDEO -> {
            val att = attachment as? V2NIMMessageVideoAttachment
            return att?.toMap()
        }

        V2NIMMessageType.V2NIM_MESSAGE_TYPE_LOCATION -> {
            val att = attachment as? V2NIMMessageLocationAttachment
            return att?.toMap()
        }

        V2NIMMessageType.V2NIM_MESSAGE_TYPE_NOTIFICATION -> {
            if (attachment is V2NIMChatroomNotificationAttachment) {
                val att = attachment as V2NIMChatroomNotificationAttachment
                return when (att.type) {
                    V2NIMChatroomMessageNotificationType.V2NIM_CHATROOM_MESSAGE_NOTIFICATION_TYPE_MEMBER_ENTER -> {
                        (att as? V2NIMChatroomMemberEnterNotificationAttachment)?.toMap() ?: att.toMap()
                    }

                    V2NIMChatroomMessageNotificationType.V2NIM_CHATROOM_MESSAGE_NOTIFICATION_TYPE_MEMBER_CHAT_BANNED_ADDED -> {
                        (att as? V2NIMChatroomChatBannedNotificationAttachment)?.toMap() ?: att.toMap()
                    }

                    V2NIMChatroomMessageNotificationType.V2NIM_CHATROOM_MESSAGE_NOTIFICATION_TYPE_MEMBER_CHAT_BANNED_REMOVED -> {
                        (att as? V2NIMChatroomChatBannedNotificationAttachment)?.toMap() ?: att.toMap()
                    }

                    V2NIMChatroomMessageNotificationType.V2NIM_CHATROOM_MESSAGE_NOTIFICATION_TYPE_MEMBER_TEMP_CHAT_BANNED_ADDED -> {
                        (att as? V2NIMChatroomChatBannedNotificationAttachment)?.toMap() ?: att.toMap()
                    }

                    V2NIMChatroomMessageNotificationType.V2NIM_CHATROOM_MESSAGE_NOTIFICATION_TYPE_MEMBER_TEMP_CHAT_BANNED_REMOVED -> {
                        (att as? V2NIMChatroomChatBannedNotificationAttachment)?.toMap() ?: att.toMap()
                    }

                    V2NIMChatroomMessageNotificationType.V2NIM_CHATROOM_MESSAGE_NOTIFICATION_TYPE_TAG_TEMP_CHAT_BANNED_ADDED -> {
                        (att as? V2NIMChatroomChatBannedNotificationAttachment)?.toMap() ?: att.toMap()
                    }

                    V2NIMChatroomMessageNotificationType.V2NIM_CHATROOM_MESSAGE_NOTIFICATION_TYPE_TAG_TEMP_CHAT_BANNED_REMOVED -> {
                        (att as? V2NIMChatroomChatBannedNotificationAttachment)?.toMap() ?: att.toMap()
                    }

                    V2NIMChatroomMessageNotificationType.V2NIM_CHATROOM_MESSAGE_NOTIFICATION_TYPE_QUEUE_CHANGE -> {
                        (att as? V2NIMChatroomQueueNotificationAttachment)?.toMap() ?: att.toMap()
                    }

                    V2NIMChatroomMessageNotificationType.V2NIM_CHATROOM_MESSAGE_NOTIFICATION_TYPE_ROLE_UPDATE -> {
                        (att as? V2NIMChatroomMemberRoleUpdateAttachment)?.toMap() ?: att.toMap()
                    }

                    V2NIMChatroomMessageNotificationType.V2NIM_CHATROOM_MESSAGE_NOTIFICATION_TYPE_MESSAGE_REVOKE -> {
                        (att as? V2NIMChatroomMessageRevokeNotificationAttachment)?.toMap() ?: att.toMap()
                    }

                    else -> {
                        att.toMap()
                    }
                }
            } else if (attachment is V2NIMMessageAttachment) {
                val att = attachment as V2NIMMessageAttachment
                return att.toMap()
            } else {
                return mapOf()
            }
        }

        V2NIMMessageType.V2NIM_MESSAGE_TYPE_CALL -> {
            val att = attachment as? V2NIMMessageCallAttachment
            return att?.toMap()
        }

        else -> {
            return attachment?.toMap()
        }
    }
}

fun V2NIMChatroomMessageConfig.toMap(): Map<String, Any?> {
    return mapOf(
        "historyEnabled" to isHistoryEnabled,
        "highPriority" to isHighPriority
    )
}

fun V2NIMUserInfoConfig.toMap(): Map<String, Any?> {
    return mapOf(
        "userInfoTimestamp" to userInfoTimestamp,
        "senderNick" to senderNick,
        "senderAvatar" to senderAvatar,
        "senderExtension" to senderExtension
    )
}

fun V2NIMLocationInfo.toMap(): Map<String, Any?> {
    return mapOf(
        "x" to x,
        "y" to y,
        "z" to z
    )
}

fun V2NIMChatroomMemberListResult.toMap(): Map<String, Any?> {
    return mapOf(
        "pageToken" to pageToken,
        "finished" to isFinished,
        "memberList" to memberList?.map { it.toMap() }
    )
}

fun V2NIMChatroomMember.toMap(): Map<String, Any?> {
    return mapOf(
        "roomId" to roomId,
        "accountId" to accountId,
        "memberRole" to memberRole.value,
        "memberLevel" to memberLevel,
        "roomNick" to roomNick,
        "roomAvatar" to roomAvatar,
        "serverExtension" to serverExtension,
        "isOnline" to isOnline,
        "blocked" to isBlocked,
        "valid" to isValid,
        "chatBanned" to isChatBanned,
        "tempChatBanned" to isTempChatBanned,
        "tempChatBannedDuration" to tempChatBannedDuration,
        "tags" to tags,
        "notifyTargetTags" to notifyTargetTags,
        "enterTime" to enterTime,
        "updateTime" to updateTime,
        "multiEnterInfo" to multiEnterInfo.map { it.toMap() }

    )
}

fun V2NIMChatroomEnterInfo.toMap(): Map<String, Any?> {
    return mapOf(
        "roomNick" to roomNick,
        "roomAvatar" to roomAvatar,
        "enterTime" to enterTime,
        "clientType" to clientType
    )
}

fun V2NIMChatroomInfo.toMap(): Map<String, Any?> {
    return mapOf(
        "roomId" to roomId,
        "roomName" to roomName,
        "announcement" to announcement,
        "liveUrl" to liveUrl,
        "isValidRoom" to isValidRoom,
        "serverExtension" to serverExtension,
        "queueLevelMode" to queueLevelMode?.value,
        "creatorAccountId" to creatorAccountId,
        "onlineUserCount" to onlineUserCount,
        "chatBanned" to isChatBanned
    )
}

fun V2NIMChatroomEnterResult.toMap(): Map<String, Any?> {
    return mapOf(
        "chatroom" to chatroom?.toMap(),
        "selfMember" to selfMember?.toMap()
    )
}

fun V2NIMChatroomKickedInfo.toMap(): Map<String, Any?> {
    return mapOf(
        "serverExtension" to serverExtension,
        "kickedReason" to kickedReason?.value
    )
}

fun V2NIMChatroomNotificationAttachment.toMap(): Map<String, Any?> {
    return mapOf(
        "nimCoreMessageType" to FLTConstant.chatRoomNotificationType,
        "type" to type.value,
        "targetIds" to targetIds,
        "targetNicks" to targetNicks,
        "targetTag" to targetTag,
        "tags" to tags,
        "operatorId" to operatorId,
        "operatorNick" to operatorNick,
        "notificationExtension" to notificationExtension,
        "raw" to raw
    )
}

fun V2NIMChatroomMemberEnterNotificationAttachment.toMap(): Map<String, Any?> {
    return mapOf(
        "nimCoreMessageType" to FLTConstant.chatRoomNotificationType,
        "type" to type.value,
        "targetIds" to targetIds,
        "targetNicks" to targetNicks,
        "targetTag" to targetTag,
        "tags" to tags,
        "operatorId" to operatorId,
        "operatorNick" to operatorNick,
        "notificationExtension" to notificationExtension,
        "chatBanned" to isChatBanned,
        "tempChatBanned" to isTempChatBanned,
        "tempChatBannedDuration" to tempChatBannedDuration,
        "raw" to raw
    )
}

fun V2NIMChatroomChatBannedNotificationAttachment.toMap(): Map<String, Any?> {
    return mapOf(
        "nimCoreMessageType" to FLTConstant.chatRoomNotificationType,
        "type" to type.value,
        "targetIds" to targetIds,
        "targetNicks" to targetNicks,
        "targetTag" to targetTag,
        "tags" to tags,
        "operatorId" to operatorId,
        "operatorNick" to operatorNick,
        "notificationExtension" to notificationExtension,
        "chatBanned" to isChatBanned,
        "tempChatBanned" to isTempChatBanned,
        "tempChatBannedDuration" to tempChatBannedDuration,
        "raw" to raw
    )
}

fun V2NIMChatroomQueueNotificationAttachment.toMap(): Map<String, Any?> {
    return mapOf(
        "nimCoreMessageType" to FLTConstant.chatRoomNotificationType,
        "type" to type.value,
        "targetIds" to targetIds,
        "targetNicks" to targetNicks,
        "targetTag" to targetTag,
        "tags" to tags,
        "operatorId" to operatorId,
        "operatorNick" to operatorNick,
        "notificationExtension" to notificationExtension,
        "elements" to elements?.map { it.toMap() },
        "queueChangeType" to queueChangeType.value,
        "raw" to raw
    )
}

fun V2NIMChatroomQueueElement.toMap(): Map<String, Any?> {
    return mapOf(
        "key" to key,
        "value" to value,
        "nick" to nick,
        "extension" to extension,
        "accountId" to accountId
    )
}

fun V2NIMChatroomMessageRevokeNotificationAttachment.toMap(): Map<String, Any?> {
    return mapOf(
        "nimCoreMessageType" to FLTConstant.chatRoomNotificationType,
        "type" to type.value,
        "targetIds" to targetIds,
        "targetNicks" to targetNicks,
        "targetTag" to targetTag,
        "tags" to tags,
        "operatorId" to operatorId,
        "operatorNick" to operatorNick,
        "notificationExtension" to notificationExtension,
        "messageClientId" to messageClientId,
        "messageTime" to messageTime,
        "raw" to raw
    )
}

fun V2NIMChatroomMemberRoleUpdateAttachment.toMap(): Map<String, Any?> {
    return mapOf(
        "nimCoreMessageType" to FLTConstant.chatRoomNotificationType,
        "type" to type.value,
        "targetIds" to targetIds,
        "targetNicks" to targetNicks,
        "targetTag" to targetTag,
        "tags" to tags,
        "operatorId" to operatorId,
        "operatorNick" to operatorNick,
        "notificationExtension" to notificationExtension,
        "currentMember" to currentMember?.toMap(),
        "previousRole" to previousRole.value,
        "raw" to raw
    )
}

fun Map<String, *>.toV2NIMChatroomMessage(): V2NIMChatroomMessage =
    V2NIMChatroomMessageBuilder
        .builder()
        .senderId(this["senderId"] as? String)
        .roomId(this["roomId"] as? String)
        .messageClientId(this["messageClientId"] as? String)
        .senderClientType((this["senderClientType"] as? Int) ?: 0)
        .createTime(this["createTime"] as? Long ?: 0)
        .isSelf(this["isSelf"] as? Boolean ?: false)
        .attachmentUploadState(
            V2NIMMessageAttachmentUploadState.typeOfValue(this["attachmentUploadState"] as? Int ?: 0)
        ).sendingState(
            V2NIMMessageSendingState.typeOfValue(this["sendingState"] as? Int ?: 0)
        ).messageType(
            V2NIMMessageType.typeOfValue(this["messageType"] as? Int ?: 0)
        ).subType(this["subType"] as? Int ?: 0)
        .text(this["text"] as? String)
        .attachment((this["attachment"] as? Map<String, Any?>)?.toMessageAttachment())
        .serverExtension(this["serverExtension"] as? String)
        .callbackExtension(this["callbackExtension"] as? String)
        .messageConfig((this["messageConfig"] as? Map<String, Any?>)?.let { convertToV2NIMChatroomMessageConfig(it) })
        .userInfoConfig((this["userInfoConfig"] as? Map<String, Any?>)?.let { convertToV2NIMUserInfoConfig(it) })
        .routeConfig((this["routeConfig"] as? Map<String, Any?>)?.toMessageRouteConfig())
        .antispamConfig((this["antispamConfig"] as? Map<String, Any?>)?.toMessageAntispamConfig())
        .locationInfo(
            (this["locationInfo"] as? Map<String, Any?>)?.let { info ->
                V2NIMLocationInfo().apply {
                    val distancex = info["x"] as? Double?
                    if (distancex != null) {
                        this.x = distancex
                    }
                    val distancey = info["y"] as? Double?
                    if (distancey != null) {
                        this.y = distancey
                    }
                    val distancez = info["z"] as? Double?
                    if (distancez != null) {
                        this.z = distancez
                    }
                }
            }
        )
        .notifyTargetTags(this["notifyTargetTags"] as? String)
        .build()
