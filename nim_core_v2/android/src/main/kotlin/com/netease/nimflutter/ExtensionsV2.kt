/*
 * Copyright (c) 2022 NetEase, Inc. All rights reserved.
 * Use of this source code is governed by a MIT license that can be
 * found in the LICENSE file.
 */

package com.netease.nimflutter
import com.netease.nimlib.sdk.v2.conversation.model.V2NIMConversation
import com.netease.nimlib.sdk.v2.conversation.model.V2NIMLastMessage
import com.netease.nimlib.sdk.v2.conversation.params.V2NIMConversationFilter
import com.netease.nimlib.sdk.v2.message.attachment.V2NIMMessageAudioAttachment
import com.netease.nimlib.sdk.v2.message.attachment.V2NIMMessageCallAttachment
import com.netease.nimlib.sdk.v2.message.attachment.V2NIMMessageFileAttachment
import com.netease.nimlib.sdk.v2.message.attachment.V2NIMMessageImageAttachment
import com.netease.nimlib.sdk.v2.message.attachment.V2NIMMessageLocationAttachment
import com.netease.nimlib.sdk.v2.message.attachment.V2NIMMessageNotificationAttachment
import com.netease.nimlib.sdk.v2.message.attachment.V2NIMMessageVideoAttachment
import com.netease.nimlib.sdk.v2.message.enums.V2NIMMessageType
import com.netease.nimlib.sdk.v2.notification.V2NIMBroadcastNotification
import com.netease.nimlib.sdk.v2.notification.V2NIMCustomNotification
import com.netease.nimlib.sdk.v2.setting.V2NIMDndConfig
import com.netease.nimlib.sdk.v2.storage.V2NIMStorageScene
import com.netease.nimlib.sdk.v2.storage.V2NIMUploadFileParams
import com.netease.nimlib.sdk.v2.storage.V2NIMUploadFileTask
import com.netease.nimlib.sdk.v2.storage.result.V2NIMGetMediaResourceInfoResult
import com.netease.nimlib.sdk.v2.team.model.V2NIMTeam
import com.netease.nimlib.sdk.v2.team.model.V2NIMTeamJoinActionInfo
import com.netease.nimlib.sdk.v2.team.model.V2NIMTeamMember
import com.netease.nimlib.sdk.v2.team.result.V2NIMCreateTeamResult
import com.netease.nimlib.sdk.v2.team.result.V2NIMTeamJoinActionInfoResult
import com.netease.nimlib.sdk.v2.team.result.V2NIMTeamMemberListResult
import com.netease.nimlib.sdk.v2.team.result.V2NIMTeamMemberSearchResult
import com.netease.nimlib.sdk.v2.user.V2NIMUser

fun V2NIMUser.toMap(): Map<String, Any?> =
    mapOf(
        "accountId" to accountId,
        "name" to name,
        "avatar" to avatar,
        "sign" to sign,
        "gender" to gender,
        "email" to email,
        "birthday" to birthday,
        "mobile" to mobile,
        "serverExtension" to serverExtension,
        "createTime" to createTime,
        "updateTime" to updateTime
    )

fun V2NIMConversation.toMap(): Map<String, Any?> =
    mapOf(
        "conversationId" to conversationId,
        "type" to type.value,
        "name" to name,
        "avatar" to avatar,
        "mute" to isMute,
        "stickTop" to isStickTop,
        "groupIds" to groupIds,
        "localExtension" to localExtension,
        "serverExtension" to serverExtension,
        "lastMessage" to lastMessage?.toMap(),
        "unreadCount" to unreadCount,
        "sortOrder" to sortOrder,
        "createTime" to createTime,
        "updateTime" to updateTime
    )

fun V2NIMConversationFilter.toMap(): Map<String, Any?> =
    mapOf(
        "conversationTypes" to conversationTypes.map { it.value },
        "conversationGroupId" to conversationGroupId,
        "ignoreMuted" to isIgnoreMuted
    )

fun V2NIMLastMessage.attachmentToMap(): Map<String, Any?>? {
    when (messageType) {
        V2NIMMessageType.V2NIM_MESSAGE_TYPE_FILE -> {
            val att = attachment as V2NIMMessageFileAttachment
            return att.toMap()
        }

        V2NIMMessageType.V2NIM_MESSAGE_TYPE_IMAGE -> {
            val att = attachment as V2NIMMessageImageAttachment
            return att.toMap()
        }

        V2NIMMessageType.V2NIM_MESSAGE_TYPE_AUDIO -> {
            val att = attachment as V2NIMMessageAudioAttachment
            return att.toMap()
        }

        V2NIMMessageType.V2NIM_MESSAGE_TYPE_VIDEO -> {
            val att = attachment as V2NIMMessageVideoAttachment
            return att.toMap()
        }

        V2NIMMessageType.V2NIM_MESSAGE_TYPE_LOCATION -> {
            val att = attachment as V2NIMMessageLocationAttachment
            return att.toMap()
        }

        V2NIMMessageType.V2NIM_MESSAGE_TYPE_NOTIFICATION -> {
            val att = attachment as V2NIMMessageNotificationAttachment
            return att.toMap()
        }

        V2NIMMessageType.V2NIM_MESSAGE_TYPE_CALL -> {
            val att = attachment as V2NIMMessageCallAttachment
            return att.toMap()
        }

        else -> {
            return attachment?.toMap()
        }
    }
}

fun V2NIMLastMessage.toMap(): Map<String, Any?> =
    mapOf(
        "lastMessageState" to lastMessageState?.value,
        "messageRefer" to messageRefer?.toMap(),
        "messageType" to messageType?.value,
        "subType" to subType,
        "sendingState" to sendingState?.value,
        "text" to text,
        "attachment" to this.attachmentToMap(),
        "revokeAccountId" to revokeAccountId,
        "revokeType" to revokeType?.value,
        "serverExtension" to serverExtension,
        "callbackExtension" to callbackExtension,
        "senderName" to senderName
    )

fun V2NIMTeam.toMap(): Map<String, Any?> {
    return mapOf(
        "teamId" to teamId,
        "name" to name,
        "teamType" to teamType.value,
        "ownerAccountId" to ownerAccountId,
        "memberLimit" to memberLimit,
        "memberCount" to memberCount,
        "createTime" to createTime,
        "updateTime" to updateTime,
        "intro" to intro,
        "announcement" to announcement,
        "avatar" to avatar,
        "serverExtension" to serverExtension,
        "customerExtension" to customerExtension,
        "joinMode" to joinMode.value,
        "agreeMode" to agreeMode.value,
        "inviteMode" to inviteMode.value,
        "updateInfoMode" to updateInfoMode.value,
        "updateExtensionMode" to updateExtensionMode.value,
        "chatBannedMode" to chatBannedMode.value,
        "isValidTeam" to isValidTeam
    )
}

fun V2NIMTeamMember.toMap(): Map<String, Any?> {
    return mapOf(
        "teamId" to teamId,
        "teamType" to teamType.value,
        "accountId" to accountId,
        "memberRole" to memberRole.value,
        "teamNick" to teamNick,
        "serverExtension" to serverExtension,
        "joinTime" to joinTime,
        "updateTime" to updateTime,
        "invitorAccountId" to invitorAccountId,
        "inTeam" to isInTeam,
        "chatBanned" to isChatBanned
    )
}

fun V2NIMTeamJoinActionInfo.toMap(): Map<String, Any?> {
    return mapOf(
        "teamId" to teamId,
        "actionType" to actionType.value,
        "teamType" to teamType.value,
        "operatorAccountId" to operatorAccountId,
        "postscript" to postscript,
        "timestamp" to timestamp,
        "actionStatus" to actionStatus.value
    )
}

fun V2NIMCreateTeamResult.toMap(): Map<String, Any?> {
    return mapOf(
        "team" to team.toMap(),
        "failedList" to failedList
    )
}

fun V2NIMTeamMemberListResult.toMap(): Map<String, Any?> {
    return mapOf(
        "nextToken" to nextToken,
        "finished" to isFinished,
        "memberList" to memberList.map { it.toMap() }
    )
}

fun V2NIMTeamJoinActionInfoResult.toMap(): Map<String, Any?> {
    return mapOf(
        "offset" to offset,
        "finished" to isFinished,
        "infos" to infos.map { it.toMap() }
    )
}

fun V2NIMTeamMemberSearchResult.toMap(): Map<String, Any?> {
    return mapOf(
        "memberList" to memberList.map { it.toMap() },
        "nextToken" to nextToken,
        "finished" to isFinished
    )
}

fun V2NIMDndConfig.toMap(): Map<String, Any?> {
    return mapOf(
        "fromH" to fromH,
        "fromM" to fromM,
        "toH" to toH,
        "toM" to toM,
        "showDetail" to isShowDetail,
        "dndOn" to isDndOn
    )
}

fun V2NIMStorageScene.toMap(): Map<String, Any?> {
    return mapOf(
        "sceneName" to sceneName,
        "expireTime" to expireTime
    )
}

fun V2NIMUploadFileParams.toMap(): Map<String, Any?> {
    return mapOf(
        "filePath" to filePath,
        "sceneName" to sceneName
    )
}

fun V2NIMUploadFileTask.toMap(): Map<String, Any?> {
    return mapOf(
        "taskId" to taskId,
        "uploadParams" to uploadParams.toMap()
    )
}

fun V2NIMGetMediaResourceInfoResult.toMap(): Map<String, Any?> {
    return mapOf(
        "url" to url,
        "authHeaders" to authHeaders
    )
}

fun V2NIMCustomNotification.toMap(): Map<String, Any?> {
    return mapOf(
        "senderId" to senderId,
        "receiverId" to receiverId,
        "content" to content,
        "timestamp" to timestamp,
        "conversationType" to conversationType?.value,
        "notificationConfig" to notificationConfig?.toMap(),
        "pushConfig" to pushConfig?.toMap(),
        "antispamConfig" to antispamConfig?.toMap(),
        "routeConfig" to routeConfig?.toMap()
    )
}

fun V2NIMBroadcastNotification.toMap(): Map<String, Any?> {
    return mapOf(
        "content" to content,
        "timestamp" to timestamp,
        "id" to id,
        "senderId" to senderId
    )
}
