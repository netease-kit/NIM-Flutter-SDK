/*
 * Copyright (c) 2022 NetEase, Inc. All rights reserved.
 * Use of this source code is governed by a MIT license that can be
 * found in the LICENSE file.
 */

package com.netease.nimflutter

import com.netease.nimlib.sdk.qchat.enums.QChatChannelBlackWhiteOperateType
import com.netease.nimlib.sdk.qchat.enums.QChatChannelBlackWhiteType
import com.netease.nimlib.sdk.qchat.enums.QChatChannelMode
import com.netease.nimlib.sdk.qchat.enums.QChatChannelSearchSortEnum
import com.netease.nimlib.sdk.qchat.enums.QChatChannelSyncMode
import com.netease.nimlib.sdk.qchat.enums.QChatChannelType
import com.netease.nimlib.sdk.qchat.enums.QChatInOutType
import com.netease.nimlib.sdk.qchat.enums.QChatKickOutReason
import com.netease.nimlib.sdk.qchat.enums.QChatMessageReferType
import com.netease.nimlib.sdk.qchat.enums.QChatMessageSearchSortEnum
import com.netease.nimlib.sdk.qchat.enums.QChatMultiSpotNotifyType
import com.netease.nimlib.sdk.qchat.enums.QChatNotifyReason
import com.netease.nimlib.sdk.qchat.enums.QChatQuickCommentOperateType
import com.netease.nimlib.sdk.qchat.enums.QChatRoleOption
import com.netease.nimlib.sdk.qchat.enums.QChatRoleResource
import com.netease.nimlib.sdk.qchat.enums.QChatRoleType
import com.netease.nimlib.sdk.qchat.enums.QChatSubscribeOperateType
import com.netease.nimlib.sdk.qchat.enums.QChatSubscribeType
import com.netease.nimlib.sdk.qchat.enums.QChatSystemMessageToType
import com.netease.nimlib.sdk.qchat.enums.QChatSystemNotificationType
import com.netease.nimlib.sdk.qchat.enums.QChatVisitorMode

val qChatChannelTypeMap = mapOf(
    QChatChannelType.CustomChannel to "customChannel",
    QChatChannelType.RTCChannel to "RTCChannel",
    QChatChannelType.MessageChannel to "messageChannel"
)

fun stringToQChatChannelType(type: String): QChatChannelType =
    qChatChannelTypeMap.filterValues { it == type }.keys.firstOrNull()
        ?: QChatChannelType.MessageChannel

fun stringFromQChatChannelType(type: QChatChannelType?) =
    qChatChannelTypeMap[type] ?: qChatChannelTypeMap[QChatChannelType.MessageChannel]

val qChatVisitorModeMap = mapOf(
    QChatVisitorMode.VISIBLE to "visible",
    QChatVisitorMode.INVISIBLE to "invisible",
    QChatVisitorMode.FOLLOW to "follow"
)

fun stringToQChatVisitorMode(type: String?): QChatVisitorMode? =
    qChatVisitorModeMap.filterValues { it == type }.keys.firstOrNull()

fun stringFromQChatVisitorMode(type: QChatVisitorMode?) =
    qChatVisitorModeMap[type]

val qChatChannelModeMap = mapOf(
    QChatChannelMode.PRIVATE to "private",
    QChatChannelMode.PUBLIC to "public"
)

fun stringToQChatChannelMode(type: String?): QChatChannelMode? =
    qChatChannelModeMap.filterValues { it == type }.keys.firstOrNull()

fun stringFromQChatChannelMode(type: QChatChannelMode?) =
    qChatChannelModeMap[type]

val qQChatChannelSyncMode = mapOf(
    QChatChannelSyncMode.NONE to "none",
    QChatChannelSyncMode.SYNC to "sync"
)

fun stringToQChatChannelSyncMode(type: String?): QChatChannelSyncMode? =
    qQChatChannelSyncMode.filterValues { it == type }.keys.firstOrNull()

fun stringFromQChatChannelSyncMode(type: QChatChannelSyncMode?) =
    qQChatChannelSyncMode[type]

val qChatSubscribeTypeMap = mapOf(
    QChatSubscribeType.CHANNEL_MSG to "channelMsg",
    QChatSubscribeType.CHANNEL_MSG_TYPING to "channelMsgTyping",
    QChatSubscribeType.CHANNEL_MSG_UNREAD_COUNT to "channelMsgUnreadCount",
    QChatSubscribeType.SERVER_MSG to "serverMsg",
    QChatSubscribeType.CHANNEL_MSG_UNREAD_STATUS to "channelMsgUnreadStatus"
)

fun stringToQChatSubscribeType(type: String?): QChatSubscribeType? =
    qChatSubscribeTypeMap.filterValues { it == type }.keys.firstOrNull()

fun stringFromQChatSubscribeType(type: QChatSubscribeType?) = qChatSubscribeTypeMap[type]

val qChatSubscribeOperateTypeMap = mapOf(
    QChatSubscribeOperateType.SUB to "sub",
    QChatSubscribeOperateType.UN_SUB to "unSub"
)

fun stringToQChatSubscribeOperateType(type: String?): QChatSubscribeOperateType? =
    qChatSubscribeOperateTypeMap.filterValues { it == type }.keys.firstOrNull()

fun stringFromQChatSubscribeOperateType(type: QChatSubscribeOperateType?) =
    qChatSubscribeOperateTypeMap[type]

val qChatChannelSearchSortEnumMap = mapOf(
    QChatChannelSearchSortEnum.ReorderWeight to "ReorderWeight",
    QChatChannelSearchSortEnum.CreateTime to "CreateTime"
)

fun stringToQChatChannelSearchSortEnum(type: String?): QChatChannelSearchSortEnum? =
    qChatChannelSearchSortEnumMap.filterValues { it == type }.keys.firstOrNull()

val qChatNotifyReasonMap = mapOf(
    QChatNotifyReason.notifyAll to "notifyAll",
    QChatNotifyReason.notifySubscribe to "notifySubscribe"
)

fun stringFromQChatNotifyReason(type: QChatNotifyReason?): String? =
    qChatNotifyReasonMap[type]

val qChatSystemNotificationTypeMap = mapOf(
    QChatSystemNotificationType.SERVER_MEMBER_INVITE to "server_member_invite",
    QChatSystemNotificationType.SERVER_MEMBER_INVITE_REJECT to "server_member_invite_reject",
    QChatSystemNotificationType.SERVER_MEMBER_APPLY to "server_member_apply",
    QChatSystemNotificationType.SERVER_MEMBER_APPLY_REJECT to "server_member_apply_reject",
    QChatSystemNotificationType.SERVER_CREATE to "server_create",
    QChatSystemNotificationType.SERVER_REMOVE to "server_remove",
    QChatSystemNotificationType.SERVER_UPDATE to "server_update",
    QChatSystemNotificationType.SERVER_MEMBER_INVITE_DONE to "server_member_invite_done",
    QChatSystemNotificationType.SERVER_MEMBER_INVITE_ACCEPT to "server_member_invite_accept",
    QChatSystemNotificationType.SERVER_MEMBER_APPLY_DONE to "server_member_apply_done",
    QChatSystemNotificationType.SERVER_MEMBER_APPLY_ACCEPT to "server_member_apply_accept",
    QChatSystemNotificationType.SERVER_MEMBER_KICK to "server_member_kick",
    QChatSystemNotificationType.SERVER_MEMBER_LEAVE to "server_member_leave",
    QChatSystemNotificationType.SERVER_MEMBER_UPDATE to "server_member_update",
    QChatSystemNotificationType.CHANNEL_CREATE to "channel_create",
    QChatSystemNotificationType.CHANNEL_REMOVE to "channel_remove",
    QChatSystemNotificationType.CHANNEL_UPDATE to "channel_update",
    QChatSystemNotificationType.CHANNEL_UPDATE_WHITE_BLACK_ROLE to "channel_update_white_black_role",
    QChatSystemNotificationType.CHANNEL_UPDATE_WHITE_BLACK_MEMBER to "channel_update_white_black_member",
    QChatSystemNotificationType.UPDATE_QUICK_COMMENT to "update_quick_comment",
    QChatSystemNotificationType.CHANNEL_CATEGORY_CREATE to "channelL_category_create",
    QChatSystemNotificationType.CHANNEL_CATEGORY_REMOVE to "channel_category_remove",
    QChatSystemNotificationType.CHANNEL_CATEGORY_UPDATE to "channel_category_update",
    QChatSystemNotificationType.CHANNEL_CATEGORY_UPDATE_WHITE_BLACK_ROLE to "channel_category_update_white_black_role",
    QChatSystemNotificationType.CHANNEL_CATEGORY_UPDATE_WHITE_BLACK_MEMBER to "channel_category_update_white_black_member",
    QChatSystemNotificationType.SERVER_ROLE_MEMBER_ADD to "server_role_member_add",
    QChatSystemNotificationType.SERVER_ROLE_MEMBER_DELETE to "server_role_member_delete",
    QChatSystemNotificationType.SERVER_ROLE_AUTH_UPDATE to "server_role_auth_update",
    QChatSystemNotificationType.CHANNEL_ROLE_AUTH_UPDATE to "channel_role_auth_update",
    QChatSystemNotificationType.MEMBER_ROLE_AUTH_UPDATE to "member_role_auth_update",
    QChatSystemNotificationType.CHANNEL_VISIBILITY_UPDATE to "channel_visibility_update",
    QChatSystemNotificationType.SERVER_ENTER_LEAVE to "server_enter_leave",
    QChatSystemNotificationType.SERVER_MEMBER_JOIN_BY_INVITE_CODE to "server_member_join_by_invite_code",
    QChatSystemNotificationType.CUSTOM to "custom",
    QChatSystemNotificationType.MY_MEMBER_INFO_UPDATED to "my_member_info_update"
)

fun stringToQChatSystemNotificationType(type: String?): QChatSystemNotificationType? =
    qChatSystemNotificationTypeMap.filterValues { it == type }.keys.firstOrNull()

fun stringFromQChatSystemNotificationType(type: QChatSystemNotificationType?): String? =
    qChatSystemNotificationTypeMap[type]

val qChatSystemMessageToTypeEnumMap = mapOf(
    QChatSystemMessageToType.SERVER to "server",
    QChatSystemMessageToType.CHANNEL to "channel",
    QChatSystemMessageToType.SERVER_ACCIDS to "server_accids",
    QChatSystemMessageToType.CHANNEL_ACCIDS to "channel_accids",
    QChatSystemMessageToType.ACCIDS to "accids"
)

fun stringToQChatSystemMessageToType(type: String?): QChatSystemMessageToType? =
    qChatSystemMessageToTypeEnumMap.filterValues { it == type }.keys.firstOrNull()

fun stringFromQChatSystemMessageToType(type: QChatSystemMessageToType?): String? =
    qChatSystemMessageToTypeEnumMap[type]

val qchatMultiSpotNotifyTypeMap = mapOf(
    QChatMultiSpotNotifyType.QCHAT_IN to "qchat_in",
    QChatMultiSpotNotifyType.QCHAT_OUT to "qchat_out"
)

fun stringFromQChatMultiSpotNotifyType(type: QChatMultiSpotNotifyType?): String? =
    qchatMultiSpotNotifyTypeMap[type]

val qChatKickOutReasonMap = mapOf(
    QChatKickOutReason.KICK_BY_SAME_PLATFORM to "kick_by_same_platform",
    QChatKickOutReason.KICK_BY_SERVER to "kick_by_server",
    QChatKickOutReason.KICK_BY_OTHER_PLATFORM to "kick_by_other_platform",
    QChatKickOutReason.UNKNOWN to "unknown"
)

fun stringFromQChatKickOutReason(type: QChatKickOutReason?): String? =
    qChatKickOutReasonMap[type]

val qChatChannelBlackWhiteTypeMap = mapOf(
    QChatChannelBlackWhiteType.WHITE to "white",
    QChatChannelBlackWhiteType.BLACK to "black"
)

fun stringFromQChatChannelBlackWhiteType(type: QChatChannelBlackWhiteType?): String? =
    qChatChannelBlackWhiteTypeMap[type]

fun stringToQChatChannelBlackWhiteType(type: String?): QChatChannelBlackWhiteType? =
    qChatChannelBlackWhiteTypeMap.filterValues { it == type }.keys.firstOrNull()

val qChatChannelBlackWhiteOperateTypeMap = mapOf(
    QChatChannelBlackWhiteOperateType.ADD to "add",
    QChatChannelBlackWhiteOperateType.REMOVE to "remove"
)

fun stringFromQChatChannelBlackWhiteOperateType(type: QChatChannelBlackWhiteOperateType?): String? =
    qChatChannelBlackWhiteOperateTypeMap[type]

fun stringToQChatChannelBlackWhiteOperateType(type: String?): QChatChannelBlackWhiteOperateType? =
    qChatChannelBlackWhiteOperateTypeMap.filterValues { it == type }.keys.firstOrNull()

val qChatQuickCommentOperateTypeMap = mapOf(
    QChatQuickCommentOperateType.ADD to "add",
    QChatQuickCommentOperateType.REMOVE to "remove"
)

fun stringFromQChatQuickCommentOperateType(type: QChatQuickCommentOperateType?): String? =
    qChatQuickCommentOperateTypeMap[type]

val qChatRoleResourceMap = mapOf(
    QChatRoleResource.MANAGE_SERVER to "manageServer",

    QChatRoleResource.MANAGE_CHANNEL to "manageChannel",

    QChatRoleResource.MANAGE_ROLE to "manageRole",

    QChatRoleResource.SEND_MSG to "sendMsg",

    QChatRoleResource.ACCOUNT_INFO_SELF to
        "accountInfoSelf",

    QChatRoleResource.INVITE_SERVER to
        "inviteServer",

    QChatRoleResource.KICK_SERVER to
        "kickServer",

    QChatRoleResource.ACCOUNT_INFO_OTHER to
        "accountInfoOther",

    QChatRoleResource.RECALL_MSG to
        "recallMsg",

    QChatRoleResource.DELETE_MSG to
        "deleteMsg",

    QChatRoleResource.REMIND_OTHER to
        "remindOther",

    QChatRoleResource.REMIND_EVERYONE to
        "remindEveryone",

    QChatRoleResource.MANAGE_BLACK_WHITE_LIST to
        "manageBlackWhiteList",

    QChatRoleResource.BAN_SERVER_MEMBER to
        "banServerMember",

    QChatRoleResource.RTC_CHANNEL_CONNECT to
        "rtcChannelConnect",

    QChatRoleResource.RTC_CHANNEL_DISCONNECT_OTHER to
        "rtcChannelDisconnectOther",

    QChatRoleResource.RTC_CHANNEL_OPEN_MICROPHONE to
        "rtcChannelOpenMicrophone",

    QChatRoleResource.RTC_CHANNEL_OPEN_CAMERA to
        "rtcChannelOpenCamera",

    QChatRoleResource.RTC_CHANNEL_OPEN_CLOSE_OTHER_MICROPHONE to
        "rtcChannelOpenCloseOtherMicrophone",

    QChatRoleResource.RTC_CHANNEL_OPEN_CLOSE_OTHER_CAMERA to
        "rtcChannelOpenCloseOtherCamera",

    QChatRoleResource.RTC_CHANNEL_OPEN_CLOSE_EVERYONE_MICROPHONE to
        "rtcChannelOpenCloseEveryoneMicrophone",

    QChatRoleResource.RTC_CHANNEL_OPEN_CLOSE_EVERYONE_CAMERA to
        "rtcChannelOpenCloseEveryoneCamera",

    QChatRoleResource.RTC_CHANNEL_OPEN_SCREEN_SHARE to
        "rtcChannelOpenScreenShare",

    QChatRoleResource.RTC_CHANNEL_CLOSE_OTHER_SCREEN_SHARE to
        "rtcChannelCloseOtherScreenShare",

    QChatRoleResource.SERVER_APPLY_HANDLE to
        "serverApplyHandle",

    QChatRoleResource.INVITE_APPLY_HISTORY_QUERY to
        "inviteApplyHistoryQuery",

    QChatRoleResource.MENTIONED_ROLE to
        "mentionedRole"
)

fun stringFromQChatRoleResource(type: QChatRoleResource?): String? =
    qChatRoleResourceMap[type]

fun stringToQChatRoleResource(type: String): QChatRoleResource =
    qChatRoleResourceMap.filterValues { it == type }.keys.first()

val qChatRoleOptionMap = mapOf(
    QChatRoleOption.ALLOW to "allow",
    QChatRoleOption.DENY to "deny",
    QChatRoleOption.INHERIT to "inherit"
)

fun stringFromQChatRoleOption(type: QChatRoleOption?): String? =
    qChatRoleOptionMap[type]

fun stringToQChatRoleOption(type: String): QChatRoleOption =
    qChatRoleOptionMap.filterValues { it == type }.keys.firstOrNull() ?: QChatRoleOption.ALLOW

val qChatInOutTypeMap = mapOf(
    QChatInOutType.OUT to "out",
    QChatInOutType.IN to "inner"
)

fun stringFromQChatInOutType(type: QChatInOutType?): String? =
    qChatInOutTypeMap[type]

val qChatRoleTypeMap = mapOf(
    QChatRoleType.EVERYONE to "everyone",
    QChatRoleType.CUSTOM to "custom"
)

fun stringToQChatRoleType(type: String): QChatRoleType =
    qChatRoleTypeMap.filterValues { it == type }.keys.firstOrNull() ?: QChatRoleType.EVERYONE

fun stringFromQChatRoleType(type: QChatRoleType?) =
    qChatRoleTypeMap[type] ?: qChatRoleTypeMap[QChatRoleType.EVERYONE]

val qChatMessageReferTypeMap = mapOf(
    QChatMessageReferType.ALL to "all",
    QChatMessageReferType.REPLAY to "replay",
    QChatMessageReferType.THREAD to "thread"
)

fun stringToQChatMessageReferType(type: String): QChatMessageReferType =
    qChatMessageReferTypeMap.filterValues { it == type }.keys.firstOrNull() ?: QChatMessageReferType.ALL

fun stringFromQChatMessageReferType(type: QChatMessageReferType?) =
    qChatMessageReferTypeMap[type] ?: qChatMessageReferTypeMap[QChatMessageReferType.ALL]

val qQChatMessageSearchSortEnum = mapOf(
    QChatMessageSearchSortEnum.CreateTime to "createTime"
)

fun stringToQChatMessageSearchSortEnum(type: String?): QChatMessageSearchSortEnum? =
    qQChatMessageSearchSortEnum.filterValues { it == type }.keys.firstOrNull()
