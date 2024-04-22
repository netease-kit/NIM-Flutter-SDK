/*
 * Copyright (c) 2022 NetEase, Inc. All rights reserved.
 * Use of this source code is governed by a MIT license that can be
 * found in the LICENSE file.
 */

package com.netease.nimflutter

import com.netease.nimflutter.Utils.jsonStringToMap
import com.netease.nimflutter.services.AttachmentHelper
import com.netease.nimflutter.services.CustomAttachment
import com.netease.nimflutter.services.MessageHelper
import com.netease.nimlib.chatroom.model.ChatRoomMessageImpl
import com.netease.nimlib.sdk.avsignalling.constant.SignallingEventType
import com.netease.nimlib.sdk.avsignalling.event.CanceledInviteEvent
import com.netease.nimlib.sdk.avsignalling.event.ChannelCommonEvent
import com.netease.nimlib.sdk.avsignalling.event.InviteAckEvent
import com.netease.nimlib.sdk.avsignalling.event.InvitedEvent
import com.netease.nimlib.sdk.avsignalling.event.MemberUpdateEvent
import com.netease.nimlib.sdk.avsignalling.event.SyncChannelListEvent
import com.netease.nimlib.sdk.avsignalling.event.UserJoinEvent
import com.netease.nimlib.sdk.avsignalling.model.ChannelBaseInfo
import com.netease.nimlib.sdk.avsignalling.model.ChannelFullInfo
import com.netease.nimlib.sdk.avsignalling.model.MemberInfo
import com.netease.nimlib.sdk.avsignalling.model.SignallingPushConfig
import com.netease.nimlib.sdk.chatroom.constant.MemberType
import com.netease.nimlib.sdk.chatroom.model.ChatRoomInfo
import com.netease.nimlib.sdk.chatroom.model.ChatRoomMember
import com.netease.nimlib.sdk.chatroom.model.ChatRoomMessage
import com.netease.nimlib.sdk.chatroom.model.ChatRoomNotificationAttachment
import com.netease.nimlib.sdk.chatroom.model.ChatRoomPartClearAttachment
import com.netease.nimlib.sdk.chatroom.model.ChatRoomQueueChangeAttachment
import com.netease.nimlib.sdk.chatroom.model.ChatRoomRoomMemberInAttachment
import com.netease.nimlib.sdk.chatroom.model.ChatRoomTempMuteAddAttachment
import com.netease.nimlib.sdk.chatroom.model.ChatRoomTempMuteRemoveAttachment
import com.netease.nimlib.sdk.chatroom.model.EnterChatRoomResultData
import com.netease.nimlib.sdk.event.model.Event
import com.netease.nimlib.sdk.event.model.EventSubscribeResult
import com.netease.nimlib.sdk.friend.model.Friend
import com.netease.nimlib.sdk.friend.model.MuteListChangedNotify
import com.netease.nimlib.sdk.msg.attachment.AudioAttachment
import com.netease.nimlib.sdk.msg.attachment.FileAttachment
import com.netease.nimlib.sdk.msg.attachment.ImageAttachment
import com.netease.nimlib.sdk.msg.attachment.LocationAttachment
import com.netease.nimlib.sdk.msg.attachment.NotificationAttachmentWithExtension
import com.netease.nimlib.sdk.msg.attachment.VideoAttachment
import com.netease.nimlib.sdk.msg.constant.ChatRoomQueueChangeType
import com.netease.nimlib.sdk.msg.constant.MsgDirectionEnum
import com.netease.nimlib.sdk.msg.constant.MsgTypeEnum
import com.netease.nimlib.sdk.msg.constant.SessionTypeEnum
import com.netease.nimlib.sdk.msg.model.AttachmentProgress
import com.netease.nimlib.sdk.msg.model.BroadcastMessage
import com.netease.nimlib.sdk.msg.model.CollectInfo
import com.netease.nimlib.sdk.msg.model.CustomMessageConfig
import com.netease.nimlib.sdk.msg.model.CustomNotification
import com.netease.nimlib.sdk.msg.model.CustomNotificationConfig
import com.netease.nimlib.sdk.msg.model.HandleQuickCommentOption
import com.netease.nimlib.sdk.msg.model.IMMessage
import com.netease.nimlib.sdk.msg.model.MemberPushOption
import com.netease.nimlib.sdk.msg.model.MessageKey
import com.netease.nimlib.sdk.msg.model.MessageReceipt
import com.netease.nimlib.sdk.msg.model.MessageRobotInfo
import com.netease.nimlib.sdk.msg.model.MsgPinDbOption
import com.netease.nimlib.sdk.msg.model.MsgPinSyncResponseOption
import com.netease.nimlib.sdk.msg.model.MsgThreadOption
import com.netease.nimlib.sdk.msg.model.NIMAntiSpamOption
import com.netease.nimlib.sdk.msg.model.QuickCommentOption
import com.netease.nimlib.sdk.msg.model.QuickCommentOptionWrapper
import com.netease.nimlib.sdk.msg.model.RecentContact
import com.netease.nimlib.sdk.msg.model.RecentSession
import com.netease.nimlib.sdk.msg.model.RecentSessionList
import com.netease.nimlib.sdk.msg.model.RevokeMsgNotification
import com.netease.nimlib.sdk.msg.model.StickTopSessionInfo
import com.netease.nimlib.sdk.msg.model.SystemMessage
import com.netease.nimlib.sdk.msg.model.TeamMessageReceipt
import com.netease.nimlib.sdk.msg.model.TeamMsgAckInfo
import com.netease.nimlib.sdk.msg.model.ThreadTalkHistory
import com.netease.nimlib.sdk.nos.model.NosTransferInfo
import com.netease.nimlib.sdk.nos.model.NosTransferProgress
import com.netease.nimlib.sdk.passthrough.model.PassthroughNotifyData
import com.netease.nimlib.sdk.passthrough.model.PassthroughProxyData
import com.netease.nimlib.sdk.superteam.SuperTeam
import com.netease.nimlib.sdk.superteam.SuperTeamMember
import com.netease.nimlib.sdk.team.model.CreateTeamResult
import com.netease.nimlib.sdk.team.model.DismissAttachment
import com.netease.nimlib.sdk.team.model.LeaveTeamAttachment
import com.netease.nimlib.sdk.team.model.MemberChangeAttachment
import com.netease.nimlib.sdk.team.model.MuteMemberAttachment
import com.netease.nimlib.sdk.team.model.Team
import com.netease.nimlib.sdk.team.model.TeamMember
import com.netease.nimlib.sdk.team.model.UpdateTeamAttachment
import com.netease.nimlib.sdk.uinfo.model.NimUserInfo
import com.netease.nimlib.session.IMMessageImpl
import java.io.File
import java.util.Objects.requireNonNull
import org.json.JSONArray

fun IMMessage.toMap(): Map<String, Any?> {
    return (this as IMMessageImpl).toMap()
}

fun ChatRoomMessage.toMap(): Map<String, Any?> {
    return (this as ChatRoomMessageImpl).toMap()
}

fun IMMessageImpl.toMap(): Map<String, Any?> {
    return mapOf(
        "messageId" to messageId.toString(),
        "sessionId" to sessionId,
        "sessionType" to stringFromSessionTypeEnum(sessionType),
        "messageType" to stringFromMsgTypeEnum(msgType),
        "messageSubType" to subtype,
        "status" to stringFromMsgStatusEnum(
            status,
            direct == MsgDirectionEnum.Out &&
                sessionType == SessionTypeEnum.P2P && isRemoteRead
        ),
        "messageDirection" to stringFromMsgDirectionEnum(direct),
        "fromAccount" to fromAccount,
        "content" to content,
        "timestamp" to time,
        "messageAttachment" to AttachmentHelper.attachmentToMap(msgType, attachment),
        "attachmentStatus" to stringFromAttachStatusEnum(attachStatus),
        "uuid" to uuid,
        "serverId" to serverId,
        // "attachString" to attachStr, // String
        "config" to if (config == null) CustomMessageConfig().toMap() else config.toMap(), // Map<String, Any?>
        // "configString" to configStr, // 通过 Config 转换 Json
        "remoteExtension" to remoteExtension, // Map<String, Any?>
        "localExtension" to localExtension, // Map<String, Any?>
        "callbackExtension" to callbackExtension,
        "pushPayload" to pushPayload, // Map<String, Any?>
        "pushContent" to pushContent, // String
        "memberPushOption" to memberPushOption?.toMap(), // Map<String, Any?>
        // "memberPushOptionString" to memberPushOptionStr, // 通过 MemberPushOption 转换 Json
        "senderClientType" to stringFromClientTypeEnum(fromClientType),
        "antiSpamOption" to nimAntiSpamOption?.toMap(), // Map<String, Any?>
        // "nimAntiSpamOptionString" to nimAntiSpamOptionStr, // 通过 AntiSpamOption 转换 Json
        "messageAck" to needMsgAck(),
        "hasSendAck" to hasSendAck(),
        "ackCount" to if (uuid == null) 0 else teamMsgAckCount,
        "unAckCount" to if (uuid == null) 0 else teamMsgUnAckCount,
        "clientAntiSpam" to clientAntiSpam,
        "isInBlackList" to isInBlackList,
        "isChecked" to isChecked,
        "sessionUpdate" to isSessionUpdate,
        "messageThreadOption" to threadOption?.toMap(), // Map<String, Any?>
        "quickCommentUpdateTime" to quickCommentUpdateTime,
        "isDeleted" to isDeleted,
        "yidunAntiCheating" to Utils.jsonStringToMap(yidunAntiCheating), // Map<String, Any?>
        "yidunAntiSpamExt" to yidunAntiSpamExt,
        "yidunAntiSpamRes" to yidunAntiSpamRes,
        "env" to env,
        "fromNickname" to fromNick, // Only Dart
        "isRemoteRead" to isRemoteRead, // Only Dart
        "robotInfo" to robotInfo?.toMap()
    )
}

fun ChatRoomMessageImpl.toMap(): Map<String, Any?> {
    return hashMapOf<String, Any?>(
        "enableHistory" to (chatRoomConfig?.skipHistory?.not() ?: true),
        "isHighPriorityMessage" to isHighPriorityMessage,
        "extension" to mapOf(
            "nickname" to chatRoomMessageExtension?.senderNick,
            "avatar" to chatRoomMessageExtension?.senderAvatar,
            "senderExtension" to chatRoomMessageExtension?.senderExtension
        )
    ).apply { putAll((this@toMap as IMMessageImpl).toMap()) }
}

fun CustomAttachment.toMap(): Map<String, Any?> {
    return attach.toMutableMap().apply {
        this["messageType"] = stringFromMsgTypeEnum(MsgTypeEnum.custom)
    }
}

fun ImageAttachment.toMap(): Map<String, Any?> {
    return mapOf(
        "w" to width,
        "h" to height,
        "path" to path,
        "size" to size,
        "md5" to md5,
        "url" to url,
        "name" to displayName,
        "ext" to extension,
        "expire" to expire,
        "force_upload" to isForceUpload,
        "messageType" to stringFromMsgTypeEnum(MsgTypeEnum.image),
        "thumbPath" to thumbPath,
        "thumbUrl" to thumbUrl,
        "sen" to stringFromNimNosSceneKeyConstant(nosTokenSceneKey)
    )
}

fun AudioAttachment.toMap(): Map<String, Any?> {
    return mapOf(
        "dur" to duration,
        "autoTransform" to autoTransform,
        "text" to text,
        "path" to path,
        "size" to size,
        "md5" to md5,
        "url" to url,
        "name" to displayName,
        "ext" to extension,
        "expire" to expire,
        "force_upload" to isForceUpload,
        "messageType" to stringFromMsgTypeEnum(MsgTypeEnum.audio),
        "thumbPath" to thumbPath,
        "sen" to stringFromNimNosSceneKeyConstant(nosTokenSceneKey)
    )
}

fun VideoAttachment.toMap(): Map<String, Any?> {
    var thumb = thumbPath
    val thumbForSave = thumbPathForSave
    if (thumb == null || thumb.isEmpty()) {
        // 发送视频消息上传成功之后，回调的path名称会被修改成md5，导致这里可能获取不到缩略图
        val index = thumbForSave.lastIndexOf('/')
        val prefix = thumbForSave.substring(0, index)
        val realThumbPath = "$prefix/$displayName"
        // 判断发送时生成的缩略图是否存在
        if (File(realThumbPath).exists()) {
            thumb = realThumbPath
        }
    }
    return mapOf(
        "dur" to duration,
        "w" to width,
        "h" to height,
        "path" to path,
        "size" to size,
        "md5" to md5,
        "url" to url,
        "name" to displayName,
        "ext" to extension,
        "expire" to expire,
        "force_upload" to isForceUpload,
        "messageType" to stringFromMsgTypeEnum(MsgTypeEnum.video),
        "thumbPath" to thumb,
        "thumbUrl" to thumbUrl,
        "sen" to stringFromNimNosSceneKeyConstant(nosTokenSceneKey)
    )
}

fun LocationAttachment.toMap(): Map<String, Any?> {
    return mapOf(
        "lat" to latitude,
        "lng" to longitude,
        "title" to address,
        "messageType" to stringFromMsgTypeEnum(MsgTypeEnum.location)
    )
}

fun FileAttachment.toMap(): Map<String, Any?> {
    return mapOf(
        "path" to path,
        "size" to size,
        "md5" to md5,
        "url" to url,
        "name" to displayName,
        "ext" to extension,
        "expire" to expire,
        "force_upload" to isForceUpload,
        "messageType" to stringFromMsgTypeEnum(MsgTypeEnum.file),
        "thumbPath" to thumbPath,
        "sen" to stringFromNimNosSceneKeyConstant(nosTokenSceneKey)
    )
}

fun CustomMessageConfig.toMap(): Map<String, Any?> {
    return mapOf(
        "enableHistory" to enableHistory,
        "enableRoaming" to enableRoaming,
        "enableSelfSync" to enableSelfSync,
        "enablePush" to enablePush,
        "enablePushNick" to enablePushNick,
        "enableUnreadCount" to enableUnreadCount,
        "enableRoute" to enableRoute,
        "enablePersist" to enablePersist
    )
}

fun MessageReceipt.toMap(): Map<String, Any?> {
    return mapOf(
        "sessionId" to sessionId,
        "time" to time
    )
}

fun TeamMessageReceipt.toMap(): Map<String, Any?> {
    return mapOf(
        "messageId" to msgId,
        "ackCount" to ackCount,
        "unAckCount" to unAckCount,
        "newReaderAccount" to newReaderAccount
    )
}

fun NIMAntiSpamOption.toMap(): Map<String, Any?> {
    return mapOf(
        "enable" to enable,
        "content" to content,
        "antiSpamConfigId" to antiSpamConfigId
    )
}

fun MessageRobotInfo.toMap(): Map<String, Any?> {
    return mapOf(
        "topic" to topic,
        "function" to function,
        "customContent" to customContent,
        "account" to account
    )
}

fun MemberPushOption.toMap(): Map<String, Any?> {
    return mapOf(
        "forcePushContent" to forcePushContent,
        "isForcePush" to isForcePush,
        "forcePushList" to forcePushList // List<String>
    )
}

fun MsgThreadOption.toMap(): Map<String, Any?> {
    return mapOf(
        "replyMessageFromAccount" to replyMsgFromAccount,
        "replyMessageToAccount" to replyMsgToAccount,
        "replyMessageTime" to replyMsgTime,
        "replyMessageIdServer" to replyMsgIdServer,
        "replyMessageIdClient" to replyMsgIdClient,
        "threadMessageFromAccount" to threadMsgFromAccount,
        "threadMessageToAccount" to threadMsgToAccount,
        "threadMessageTime" to threadMsgTime,
        "threadMessageIdServer" to threadMsgIdServer,
        "threadMessageIdClient" to threadMsgIdClient
    )
}

fun AttachmentProgress.toMap(): Map<String, Any?> {
    return mapOf(
        "id" to uuid,
        "progress" to if (total > 0L) transferred.toDouble() / total else 1
    )
}

fun NosTransferProgress.toMap(): Map<String, Any?> {
    return mapOf(
        "key" to key,
        "transferred" to transferred,
        "total" to total
    )
}

@kotlin.ExperimentalStdlibApi
fun NosTransferInfo.toMap(): Map<String, Any?> {
    return mapOf(
        "transferType" to transferType.name.lowercase(),
        "key" to key,
        "path" to path,
        "size" to size,
        "md5" to md5,
        "url" to url,
        "extension" to extension,
        "status" to status.name.lowercase()
    )
}

fun RevokeMsgNotification.toMap(): Map<String, Any?> {
    return mapOf(
        "message" to message?.toMap(),
        "attach" to attach,
        "revokeAccount" to revokeAccount,
        "customInfo" to customInfo,
        "notificationType" to notificationType,
        "revokeType" to stringFromRevokeMessageType(revokeType),
        "callbackExt" to callbackExt
    )
}

fun BroadcastMessage.toMap(): Map<String, Any?> {
    return mapOf(
        "id" to id,
        "fromAccount" to fromAccount,
        "time" to time,
        "content" to content
    )
}

@kotlin.ExperimentalStdlibApi
fun NimUserInfo.toMap(): Map<String, Any?> {
    return mapOf(
        "userId" to account,
        "nick" to name,
        "avatar" to avatar,
        "signature" to signature,
        "gender" to genderEnum.name.lowercase(),
        "email" to email,
        "birthday" to birthday,
        "mobile" to mobile,
        "extension" to extension
    )
}

fun Friend.toMap(): Map<String, Any?> {
    return mapOf(
        "userId" to account,
        "alias" to alias,
        "extension" to extension,
        "serverExtension" to serverExtension
    )
}

fun SystemMessage.toMap(): Map<String, Any?> {
    return mapOf(
        "messageId" to messageId,
        "type" to stringFromSystemMessageType(type),
        "fromAccount" to fromAccount,
        "targetId" to targetId,
        "time" to time,
        "status" to stringFromSystemMessageStatus(status),
        "content" to content,
        "attach" to attach,
        "unread" to isUnread,
        "customInfo" to customInfo
    )
}

fun CustomNotification.toMap(): Map<String, Any?> {
    return mapOf(
        "sessionId" to sessionId,
        "sessionType" to stringFromSessionTypeEnum(sessionType),
        "fromAccount" to fromAccount,
        "time" to time,
        "content" to content,
        "sendToOnlineUserOnly" to isSendToOnlineUserOnly,
        "apnsText" to apnsText,
        "pushPayload" to pushPayload,
        "config" to config?.toMap(),
        "antiSpamOption" to nimAntiSpamOption?.toMap(),
        "env" to env
    )
}

fun CustomNotificationConfig.toMap(): Map<String, Any?> {
    return mapOf(
        "enablePush" to enablePush,
        "enablePushNick" to enablePushNick,
        "enableUnreadCount" to enableUnreadCount
    )
}

fun EnterChatRoomResultData.toMap(): Map<String, Any?> {
    return mapOf(
        "roomId" to roomId,
        "roomInfo" to roomInfo?.toMap(),
        "member" to member?.toMap()
    )
}

fun ChatRoomInfo.toMap(): Map<String, Any?> =
    mapOf(
        "roomId" to roomId,
        "name" to name,
        "announcement" to announcement,
        "broadcastUrl" to broadcastUrl,
        "creator" to creator,
        "validFlag" to (if (isValid) 1 else 0),
        "onlineUserCount" to onlineUserCount,
        "mute" to (if (isMute) 1 else 0),
        "extension" to extension,
        "queueModificationLevel" to (if (queueLevel == 1) "manager" else "anyone")
    )

fun ChatRoomMember.toMap(): Map<String, Any?> = mapOf(
    "roomId" to roomId,
    "account" to account,
    "memberType" to memberType.dartName,
    "nickname" to nick,
    "avatar" to avatar,
    "extension" to extension,
    "isOnline" to isOnline,
    "isInBlackList" to isInBlackList,
    "isMuted" to isMuted,
    "isTempMuted" to isTempMuted,
    "tempMuteDuration" to tempMuteDuration,
    "isValid" to isValid,
    "enterTime" to enterTime,
    "tags" to if (tags.isNullOrEmpty()) null else JSONArray(tags).toList<String>(),
    "notifyTargetTags" to notifyTargetTags
)

fun TeamMsgAckInfo.toMap(): Map<String, Any?> = mapOf(
    "teamId" to teamId,
    "msgId" to msgId,
    "newReaderAccount" to newReaderAccount,
    "ackCount" to ackCount,
    "unAckCount" to unAckCount,
    "ackAccountList" to ackAccountList,
    "unAckAccountList" to unAckAccountList
)

val MemberType.dartName: String
    get() = memberTypeToDartName[this]!!

val memberTypeToDartName = mapOf(
    MemberType.UNKNOWN to "unknown",
    MemberType.GUEST to "guest",
    MemberType.LIMITED to "restricted",
    MemberType.NORMAL to "normal",
    MemberType.CREATOR to "creator",
    MemberType.ADMIN to "manager",
    MemberType.ANONYMOUS to "anonymous"
)

fun <K, V> MutableMap<K, V>.update(
    key: K,
    remappingFunction: (key: K, value: V?) -> V?
): V? {
    requireNonNull(remappingFunction)
    val oldValue = get(key)
    val newValue: V? = remappingFunction(key, oldValue)
    return if (newValue == null) {
        if (oldValue != null || containsKey(key)) {
            remove(key)
            null
        } else {
            null
        }
    } else {
        put(key, newValue)
        newValue
    }
}

fun <T> JSONArray.toList(): List<T> =
    mutableListOf<T>().also {
        for (index in 0 until length()) {
            it += get(index) as T
        }
    }

fun NotificationAttachmentWithExtension.toMap() = mapOf(
    "extension" to extension,
    "messageType" to stringFromMsgTypeEnum(MsgTypeEnum.notification)
)

fun MemberChangeAttachment.toMap() = mapOf(
    "targets" to targets,
    "extension" to extension,
    "messageType" to stringFromMsgTypeEnum(MsgTypeEnum.notification)
)

fun DismissAttachment.toMap() = mapOf(
    "extension" to extension,
    "messageType" to stringFromMsgTypeEnum(MsgTypeEnum.notification)
)

fun LeaveTeamAttachment.toMap() = mapOf(
    "extension" to extension,
    "messageType" to stringFromMsgTypeEnum(MsgTypeEnum.notification)
)

fun MuteMemberAttachment.toMap() = mapOf(
    "mute" to isMute
) + (this as MemberChangeAttachment).toMap()

fun UpdateTeamAttachment.toMap() = mapOf(
    "updatedFields" to convertToTeamFieldEnumMap(updatedFields)
) + (this as NotificationAttachmentWithExtension).toMap()

fun ChatRoomNotificationAttachment.toMap() = mapOf(
    "type" to type.value,
    "targets" to targets,
    "targetNicks" to targetNicks,
    "operator" to operator,
    "operatorNick" to operatorNick,
    "extension" to extension,
    "messageType" to stringFromMsgTypeEnum(MsgTypeEnum.notification)
)

fun ChatRoomRoomMemberInAttachment.toMap() = mapOf(
    "muted" to isMuted,
    "tempMuted" to isTempMuted,
    "tempMutedDuration" to tempMutedTime
) + (this as ChatRoomNotificationAttachment).toMap()

fun ChatRoomTempMuteAddAttachment.toMap() = mapOf(
    "duration" to muteDuration
) + (this as ChatRoomNotificationAttachment).toMap()

fun ChatRoomTempMuteRemoveAttachment.toMap() = mapOf(
    "duration" to muteDuration
) + (this as ChatRoomNotificationAttachment).toMap()

fun ChatRoomQueueChangeAttachment.toMap() = mapOf(
    "key" to key,
    "content" to content,
    "contentMap" to contentMap,
    "queueChangeType" to
        EnumTypeMappingRegistry.enumToValue<ChatRoomQueueChangeType, String>(
            chatRoomQueueChangeType ?: ChatRoomQueueChangeType.undefined
        )
) + (this as ChatRoomNotificationAttachment).toMap()

fun ChatRoomPartClearAttachment.toMap() = mapOf(
    "contentMap" to contentMap,
    "queueChangeType" to EnumTypeMappingRegistry.enumToValue<ChatRoomQueueChangeType, String>(
        chatRoomQueueChangeType ?: ChatRoomQueueChangeType.undefined
    )
) + (this as ChatRoomNotificationAttachment).toMap()

fun Team.toMap(): Map<String, Any?> {
    return mapOf(
        "id" to id,
        "name" to name,
        "icon" to icon,
        "type" to stringFromTeamTypeEnumMap(type),
        "announcement" to announcement,
        "introduce" to introduce,
        "creator" to creator,
        "memberCount" to memberCount,
        "memberLimit" to memberLimit,
        "verifyType" to stringFromVerifyTypeEnumMap(verifyType),
        "createTime" to createTime,
        "isMyTeam" to isMyTeam,
        "extension" to extension,
        "extServer" to extServer,
        "messageNotifyType" to stringFromTeamMessageNotifyTypMap(messageNotifyType),
        "teamInviteMode" to stringFromTeamInviteModeEnumMap(teamInviteMode),
        "teamBeInviteModeEnum" to stringFromTeamBeInviteModeEnumMap(teamBeInviteMode),
        "teamUpdateMode" to stringFromTeamUpdateModeEnumMap(teamUpdateMode),
        "teamExtensionUpdateMode" to stringFromTeamExtensionUpdateModeEnumMap(
            teamExtensionUpdateMode
        ),
        "isAllMute" to isAllMute,
        "muteMode" to stringFromTeamAllMuteModeEnumMap(muteMode)
    )
}

fun TeamMember.toMap(): Map<String, Any?> {
    return mapOf(
        "id" to tid,
        "account" to account,
        "type" to stringFromTeamMemberTypeMapMap(type),
        "teamNick" to teamNick,
        "isInTeam" to isInTeam,
        "extension" to extension,
        "isMute" to isMute,
        "joinTime" to joinTime,
        "invitorAccid" to invitorAccid
    )
}

fun SuperTeam.toMap(): Map<String, Any?> {
    // superTeam 中type写死superTeam
    return mapOf(
        "id" to id,
        "name" to name,
        "icon" to icon,
        "type" to "superTeam",
        "announcement" to announcement,
        "introduce" to introduce,
        "creator" to creator,
        "memberCount" to memberCount,
        "memberLimit" to memberLimit,
        "verifyType" to stringFromVerifyTypeEnumMap(verifyType),
        "createTime" to createTime,
        "isMyTeam" to isMyTeam,
        "extension" to extension,
        "extServer" to extServer,
        "messageNotifyType" to stringFromTeamMessageNotifyTypMap(messageNotifyType),
        "teamInviteMode" to stringFromTeamInviteModeEnumMap(teamInviteMode),
        "teamBeInviteModeEnum" to stringFromTeamBeInviteModeEnumMap(teamBeInviteMode),
        "teamUpdateMode" to stringFromTeamUpdateModeEnumMap(teamUpdateMode),
        "teamExtensionUpdateMode" to stringFromTeamExtensionUpdateModeEnumMap(
            teamExtensionUpdateMode
        ),
        "isAllMute" to isAllMute,
        "muteMode" to stringFromTeamAllMuteModeEnumMap(muteMode)
    )
}

fun SuperTeamMember.toMap(): Map<String, Any?> {
    return mapOf(
        "id" to tid,
        "account" to account,
        "type" to stringFromTeamMemberTypeMapMap(type),
        "teamNick" to teamNick,
        "isInTeam" to isInTeam,
        "extension" to Utils.jsonStringToMap(extension),
        "isMute" to isMute,
        "joinTime" to joinTime,
        "invitorAccid" to invitorAccid
    )
}

fun ThreadTalkHistory.toMap(): Map<String, Any?> {
    return mapOf(
        "thread" to thread?.toMap(),
        "time" to time,
        "replyAmount" to replyAmount,
        "replyList" to replyList?.map { it.toMap() }?.toList()
    )
}

fun CreateTeamResult.toMap(): Map<String, Any?> {
    return mapOf(
        "team" to team?.toMap(),
        "failedInviteAccounts" to failedInviteAccounts
    )
}

fun EventSubscribeResult.toMap(): Map<String, Any?> {
    return mapOf(
        "eventType" to eventType,
        "expiry" to expiry,
        "time" to time,
        "publisherAccount" to publisherAccount
    )
}

fun RecentContact.toMap() = mapOf(
    "sessionId" to contactId,
    "senderAccount" to fromAccount,
    "senderNickname" to fromNick,
    "sessionType" to stringFromSessionTypeEnum(sessionType),
    "lastMessageId" to recentMessageId,
    "lastMessageType" to stringFromMsgTypeEnum(msgType),
    "lastMessageStatus" to stringFromMsgStatusEnum(msgStatus, false),
    "lastMessageContent" to content,
    "lastMessageTime" to time,
    "lastMessageAttachment" to AttachmentHelper.attachmentToMap(msgType, attachment),
    "unreadCount" to unreadCount,
    "extension" to extension,
    "tag" to tag
)

fun Event.toMap() = mapOf(
    "eventId" to eventId,
    "eventType" to eventType,
    "eventValue" to eventValue,
    "config" to config,
    "expiry" to expiry,
    "broadcastOnlineOnly" to isBroadcastOnlineOnly,
    "syncSelfEnable" to isSyncSelfEnable,
    "publisherAccount" to publisherAccount,
    "publishTime" to publishTime,
    "publisherClientType" to publisherClientType,
    "multiClientConfig" to multiClientConfig,
    "nimConfig" to nimConfig
)

fun PassthroughProxyData.toMap(): Map<String, Any?> {
    return mapOf(
        "zone" to zone,
        "path" to path,
        "method" to method,
        "header" to header,
        "body" to body
    )
}

fun PassthroughNotifyData.toMap(): Map<String, Any?> {
    return mapOf(
        "fromAccid" to fromAccid,
        "body" to body,
        "time" to time
    )
}

fun CollectInfo.toMap() = mapOf<String, Any?>(
    "id" to id,
    "type" to type,
    "data" to data,
    "ext" to ext,
    "uniqueId" to uniqueId,
    "createTime" to createTime.toDouble(),
    "updateTime" to updateTime.toDouble()
)

data class NimCollectInfo constructor(
    private val id: Long,
    private val type: Int,
    private val data: String,
    private val ext: String?,
    private val uniqueId: String?,
    private val createTime: Long = 0,
    private val updateTime: Long = 0
) : CollectInfo {
    override fun getId(): Long = id

    override fun getType(): Int = type

    override fun getData(): String = data

    override fun getExt(): String? = ext

    override fun getUniqueId(): String? = uniqueId

    override fun getCreateTime(): Long = createTime

    override fun getUpdateTime(): Long = updateTime

    companion object {
        fun fromMap(map: Map<String, *>?): NimCollectInfo? =
            if (map != null) {
                runCatching {
                    NimCollectInfo(
                        (map["id"] as Number).toLong(),
                        (map["type"] as Number).toInt(),
                        map["data"] as String,
                        map["ext"] as String?,
                        map["uniqueId"] as String?,
                        (map["createTime"] as Number).toLong(),
                        (map["updateTime"] as Number).toLong()
                    )
                }.getOrNull()
            } else {
                null
            }
    }
}

fun MsgPinDbOption.toMap(sessionType: SessionTypeEnum, message: IMMessage?) = mapOf(
    "sessionId" to sessionId,
    "sessionType" to stringFromSessionTypeEnum(sessionType),
    "messageFromAccount" to message?.fromAccount,
    "messageToAccount" to message?.let { MessageHelper.receiverOfMsg(it) },
    "messageTime" to (message?.time ?: 0),
//    "messageId" to (message as IMMessageImpl).messageId,
    "messageServerId" to message?.serverId,
    "messageUuid" to uuid,
    "pinOperatorAccount" to pinOption.account,
    "pinExt" to pinOption.ext,
    "pinCreateTime" to pinOption.createTime,
    "pinUpdateTime" to pinOption.updateTime
)

fun MsgPinSyncResponseOption.toMap() = mapOf(
    "sessionId" to MessageHelper.sessionIdOfMsg(key),
    "sessionType" to stringFromSessionTypeEnum(key.sessionType),
    "messageFromAccount" to key.fromAccount,
    "messageToAccount" to key.toAccount,
//    "messageTime" to message.time,
//    "messageId" to key.messageId,
    "messageServerId" to key.serverId,
    "messageUuid" to key.uuid,
    "pinOperatorAccount" to pinOption.account,
    "pinExt" to pinOption.ext,
    "pinCreateTime" to pinOption.createTime,
    "pinUpdateTime" to pinOption.updateTime
)

fun RecentSession.toMap(): Map<String, Any?> {
    return mapOf(
        "sessionId" to sessionId,
        "updateTime" to updateTime,
        "ext" to ext,
        "lastMsg" to lastMsg,
        "lastMsgType" to lastMsgType,
        "recentSession" to toRecentContact()?.toMap(),
        "sessionType" to stringFromSessionTypeEnum(parseSessionId().first),
        "sessionTypePair" to parseSessionId().second,
        "revokeNotification" to revokeNotification?.toMap()
    )
}

fun RecentSessionList.toMap(): Map<String, Any?> {
    return mapOf(
        "hasMore" to hasMore(),
        "sessionList" to sessionList.map { it?.toMap() }.toList()
    )
}

fun QuickCommentOption.toMap(): Map<String, Any?> {
    return mapOf(
        "fromAccount" to fromAccount,
        "replyType" to replyType,
        "time" to time,
        "ext" to ext,
        "needBadge" to isNeedBadge,
        "needPush" to isNeedPush,
        "pushTitle" to pushTitle,
        "pushContent" to pushContent,
        "pushPayload" to pushPayload
    )
}

fun MessageKey.toMap(): Map<String, Any?> {
    return mapOf(
        "sessionType" to stringFromSessionTypeEnum(sessionType),
        "fromAccount" to fromAccount,
        "toAccount" to toAccount,
        "time" to time,
        "serverId" to serverId,
        "uuid" to uuid
    )
}

fun QuickCommentOptionWrapper.toMap(): Map<String, Any?> {
    return mapOf(
        "key" to key.toMap(),
        "quickCommentList" to quickCommentList?.map { it.toMap() }?.toList(),
        "modify" to isModify,
        "time" to time
    )
}

fun StickTopSessionInfo.toMap(): Map<String, Any?> {
    return mapOf(
        "sessionId" to sessionId,
        "sessionType" to stringFromSessionTypeEnum(sessionType),
        "ext" to ext,
        "createTime" to createTime,
        "updateTime" to updateTime
    )
}

fun HandleQuickCommentOption.toMap(): Map<String, Any?> {
    return mapOf(
        "key" to key?.toMap(),
        "commentOption" to commentOption?.toMap()
    )
}

fun MuteListChangedNotify.toMap(): Map<String, Any?> {
    return mapOf(
        "account" to account,
        "mute" to isMute
    )
}

fun ChannelBaseInfo.toMap(): Map<String, Any?> {
    return mapOf(
        "channelName" to channelName,
        "channelId" to channelId,
        "type" to stringFromChannelTypeEnum(type),
        "channelExt" to channelExt,
        "createTimestamp" to createTimestamp,
        "expireTimestamp" to expireTimestamp,
        "creatorAccountId" to creatorAccountId,
        "channelStatus" to stringFromChannelStatusEnum(channelStatus)
    )
}

fun ChannelFullInfo.toMap(): Map<String, Any?> {
    return mapOf(
        "channelBaseInfo" to channelBaseInfo.toMap(),
        "members" to members?.map { it.toMap() }?.toList()
    )
}

fun MemberInfo.toMap(): Map<String, Any?> {
    return mapOf(
        "accountId" to accountId,
        "uid" to uid,
        "joinTime" to joinTime,
        "expireTime" to expireTime
    )
}

fun SignallingPushConfig.toMap(): Map<String, Any?> {
    return mapOf(
        "needPush" to needPush(),
        "pushTitle" to pushTitle,
        "pushContent" to pushContent,
        "pushPayload" to jsonStringToMap(pushPayload)
    )
}

fun ChannelCommonEvent.toMap(): Map<String, Any?> {
    val channelMap = channelBaseInfo.toMap()
    val signallingEvent = mapOf(
        "channelBaseInfo" to channelMap,
        "eventType" to stringFromSignallingEventType(eventType),
        "fromAccountId" to fromAccountId,
        "time" to time,
        "customInfo" to customInfo
    )
    val eventMap = mutableMapOf<String, Any?>(
        "signallingEvent" to signallingEvent
    )
    when (eventType) {
        SignallingEventType.JOIN ->
            eventMap["joinMember"] = (this as UserJoinEvent).memberInfo.toMap()
        SignallingEventType.INVITE ->
            {
                val invent = (this as InvitedEvent)
                eventMap["toAccountId"] = invent.toAccountId
                eventMap["requestId"] = invent.requestId
                eventMap["pushConfig"] = invent.pushConfig.toMap()
            }
        SignallingEventType.CANCEL_INVITE -> {
            val cancelInvite = (this as CanceledInviteEvent)
            eventMap["toAccountId"] = cancelInvite.toAccount
            eventMap["requestId"] = cancelInvite.requestId
        }
        SignallingEventType.ACCEPT,
        SignallingEventType.REJECT -> {
            val inviteAckEvent = (this as InviteAckEvent)
            eventMap["toAccountId"] = inviteAckEvent.toAccountId
            eventMap["requestId"] = inviteAckEvent.requestId
            eventMap["ackStatus"] = inviteAckStatusMap[inviteAckEvent.ackStatus]
        }
        else -> {}
    }
    return eventMap
}

fun MemberUpdateEvent.toMap(): Map<String, Any?> {
    return mapOf(
        "channelFullInfo" to channelFullInfo.toMap()
    )
}

fun SyncChannelListEvent.toMap(): Map<String, Any?> {
    return mapOf(
        "channelFullInfo" to channelFullInfo.toMap()
    )
}
