/*
 * Copyright (c) 2022 NetEase, Inc. All rights reserved.
 * Use of this source code is governed by a MIT license that can be
 * found in the LICENSE file.
 */

package com.netease.nimflutter

import android.text.TextUtils
import android.util.Pair
import com.netease.nimflutter.services.AttachmentHelper
import com.netease.nimlib.qchat.model.QChatMessageImpl
import com.netease.nimlib.qchat.model.QChatMsgUpdateContentImpl
import com.netease.nimlib.qchat.model.QChatMsgUpdateInfoImpl
import com.netease.nimlib.qchat.model.QChatSystemNotificationImpl
import com.netease.nimlib.qchat.model.systemnotification.QChatSystemNotificationAttachmentImpl
import com.netease.nimlib.sdk.auth.ClientType
import com.netease.nimlib.sdk.qchat.enums.QChatApplyJoinMode
import com.netease.nimlib.sdk.qchat.enums.QChatDimension
import com.netease.nimlib.sdk.qchat.enums.QChatInviteApplyRecordStatus
import com.netease.nimlib.sdk.qchat.enums.QChatInviteApplyRecordType
import com.netease.nimlib.sdk.qchat.enums.QChatInviteMode
import com.netease.nimlib.sdk.qchat.enums.QChatMemberType
import com.netease.nimlib.sdk.qchat.enums.QChatPushMsgType
import com.netease.nimlib.sdk.qchat.enums.QChatSearchServerTypeEnum
import com.netease.nimlib.sdk.qchat.enums.QChatServerSearchSortEnum
import com.netease.nimlib.sdk.qchat.enums.QChatSubscribeOperateType
import com.netease.nimlib.sdk.qchat.enums.QChatSubscribeType
import com.netease.nimlib.sdk.qchat.enums.QChatSystemNotificationType
import com.netease.nimlib.sdk.qchat.event.QChatStatusChangeEvent
import com.netease.nimlib.sdk.qchat.model.QChatAntiSpamConfig
import com.netease.nimlib.sdk.qchat.model.QChatBannedServerMember
import com.netease.nimlib.sdk.qchat.model.QChatChannel
import com.netease.nimlib.sdk.qchat.model.QChatChannelCategory
import com.netease.nimlib.sdk.qchat.model.QChatChannelIdInfo
import com.netease.nimlib.sdk.qchat.model.QChatChannelMember
import com.netease.nimlib.sdk.qchat.model.QChatChannelRole
import com.netease.nimlib.sdk.qchat.model.QChatClient
import com.netease.nimlib.sdk.qchat.model.QChatInviteApplyRecord
import com.netease.nimlib.sdk.qchat.model.QChatInviteApplyServerMemberInfo
import com.netease.nimlib.sdk.qchat.model.QChatInvitedUserInfo
import com.netease.nimlib.sdk.qchat.model.QChatMemberRole
import com.netease.nimlib.sdk.qchat.model.QChatMessage
import com.netease.nimlib.sdk.qchat.model.QChatMessageAntiSpamOption
import com.netease.nimlib.sdk.qchat.model.QChatMessageAntiSpamResult
import com.netease.nimlib.sdk.qchat.model.QChatMessageRefer
import com.netease.nimlib.sdk.qchat.model.QChatMsgUpdateContent
import com.netease.nimlib.sdk.qchat.model.QChatMsgUpdateInfo
import com.netease.nimlib.sdk.qchat.model.QChatQuickComment
import com.netease.nimlib.sdk.qchat.model.QChatServer
import com.netease.nimlib.sdk.qchat.model.QChatServerMember
import com.netease.nimlib.sdk.qchat.model.QChatServerRole
import com.netease.nimlib.sdk.qchat.model.QChatServerRoleMember
import com.netease.nimlib.sdk.qchat.model.QChatSystemNotification
import com.netease.nimlib.sdk.qchat.model.QChatUnreadInfo
import com.netease.nimlib.sdk.qchat.model.QChatUserPushConfig
import com.netease.nimlib.sdk.qchat.model.inviteapplyrecord.QChatApplyRecordData
import com.netease.nimlib.sdk.qchat.model.inviteapplyrecord.QChatBeInvitedRecordData
import com.netease.nimlib.sdk.qchat.model.inviteapplyrecord.QChatGenerateInviteCodeRecordData
import com.netease.nimlib.sdk.qchat.model.inviteapplyrecord.QChatInviteApplyRecordData
import com.netease.nimlib.sdk.qchat.model.inviteapplyrecord.QChatInviteRecordData
import com.netease.nimlib.sdk.qchat.model.inviteapplyrecord.QChatJoinByInviteCodeRecordData
import com.netease.nimlib.sdk.qchat.model.systemnotification.QChatSystemNotificationAttachment
import com.netease.nimlib.sdk.qchat.model.systemnotification.QChatUpdatedMyMemberInfo
import com.netease.nimlib.sdk.qchat.param.QChatAcceptServerApplyParam
import com.netease.nimlib.sdk.qchat.param.QChatAcceptServerInviteParam
import com.netease.nimlib.sdk.qchat.param.QChatAddChannelRoleParam
import com.netease.nimlib.sdk.qchat.param.QChatAddMemberRoleParam
import com.netease.nimlib.sdk.qchat.param.QChatAddMembersToServerRoleParam
import com.netease.nimlib.sdk.qchat.param.QChatApplyServerJoinParam
import com.netease.nimlib.sdk.qchat.param.QChatBanServerMemberParam
import com.netease.nimlib.sdk.qchat.param.QChatCheckPermissionParam
import com.netease.nimlib.sdk.qchat.param.QChatCheckPermissionsParam
import com.netease.nimlib.sdk.qchat.param.QChatCreateChannelParam
import com.netease.nimlib.sdk.qchat.param.QChatCreateServerParam
import com.netease.nimlib.sdk.qchat.param.QChatCreateServerRoleParam
import com.netease.nimlib.sdk.qchat.param.QChatDeleteChannelParam
import com.netease.nimlib.sdk.qchat.param.QChatDeleteMessageParam
import com.netease.nimlib.sdk.qchat.param.QChatDeleteServerParam
import com.netease.nimlib.sdk.qchat.param.QChatDeleteServerRoleParam
import com.netease.nimlib.sdk.qchat.param.QChatDownloadAttachmentParam
import com.netease.nimlib.sdk.qchat.param.QChatEnterServerAsVisitorParam
import com.netease.nimlib.sdk.qchat.param.QChatGenerateInviteCodeParam
import com.netease.nimlib.sdk.qchat.param.QChatGetBannedServerMembersByPageParam
import com.netease.nimlib.sdk.qchat.param.QChatGetChannelBlackWhiteRolesByPageParam
import com.netease.nimlib.sdk.qchat.param.QChatGetChannelMembersByPageParam
import com.netease.nimlib.sdk.qchat.param.QChatGetChannelRolesParam
import com.netease.nimlib.sdk.qchat.param.QChatGetChannelUnreadInfosParam
import com.netease.nimlib.sdk.qchat.param.QChatGetChannelsByPageParam
import com.netease.nimlib.sdk.qchat.param.QChatGetChannelsParam
import com.netease.nimlib.sdk.qchat.param.QChatGetExistingAccidsInServerRoleParam
import com.netease.nimlib.sdk.qchat.param.QChatGetExistingAccidsOfMemberRolesParam
import com.netease.nimlib.sdk.qchat.param.QChatGetExistingChannelBlackWhiteRolesParam
import com.netease.nimlib.sdk.qchat.param.QChatGetExistingChannelRolesByServerRoleIdsParam
import com.netease.nimlib.sdk.qchat.param.QChatGetExistingServerRolesByAccidsParam
import com.netease.nimlib.sdk.qchat.param.QChatGetInviteApplyRecordOfSelfParam
import com.netease.nimlib.sdk.qchat.param.QChatGetInviteApplyRecordOfServerParam
import com.netease.nimlib.sdk.qchat.param.QChatGetMemberRolesParam
import com.netease.nimlib.sdk.qchat.param.QChatGetMembersFromServerRoleParam
import com.netease.nimlib.sdk.qchat.param.QChatGetMessageHistoryByIdsParam
import com.netease.nimlib.sdk.qchat.param.QChatGetMessageHistoryParam
import com.netease.nimlib.sdk.qchat.param.QChatGetServerMembersByPageParam
import com.netease.nimlib.sdk.qchat.param.QChatGetServerMembersParam
import com.netease.nimlib.sdk.qchat.param.QChatGetServerRolesByAccidParam
import com.netease.nimlib.sdk.qchat.param.QChatGetServerRolesParam
import com.netease.nimlib.sdk.qchat.param.QChatGetServersByPageParam
import com.netease.nimlib.sdk.qchat.param.QChatGetServersParam
import com.netease.nimlib.sdk.qchat.param.QChatGetUserServerPushConfigsParam
import com.netease.nimlib.sdk.qchat.param.QChatInviteServerMembersParam
import com.netease.nimlib.sdk.qchat.param.QChatJoinByInviteCodeParam
import com.netease.nimlib.sdk.qchat.param.QChatKickOtherClientsParam
import com.netease.nimlib.sdk.qchat.param.QChatKickServerMembersParam
import com.netease.nimlib.sdk.qchat.param.QChatLeaveServerAsVisitorParam
import com.netease.nimlib.sdk.qchat.param.QChatLeaveServerParam
import com.netease.nimlib.sdk.qchat.param.QChatLoginParam
import com.netease.nimlib.sdk.qchat.param.QChatMarkMessageReadParam
import com.netease.nimlib.sdk.qchat.param.QChatMarkSystemNotificationsReadParam
import com.netease.nimlib.sdk.qchat.param.QChatRejectServerApplyParam
import com.netease.nimlib.sdk.qchat.param.QChatRejectServerInviteParam
import com.netease.nimlib.sdk.qchat.param.QChatRemoveChannelRoleParam
import com.netease.nimlib.sdk.qchat.param.QChatRemoveMemberRoleParam
import com.netease.nimlib.sdk.qchat.param.QChatRemoveMembersFromServerRoleParam
import com.netease.nimlib.sdk.qchat.param.QChatResendMessageParam
import com.netease.nimlib.sdk.qchat.param.QChatResendSystemNotificationParam
import com.netease.nimlib.sdk.qchat.param.QChatRevokeMessageParam
import com.netease.nimlib.sdk.qchat.param.QChatSearchChannelByPageParam
import com.netease.nimlib.sdk.qchat.param.QChatSearchChannelMembersParam
import com.netease.nimlib.sdk.qchat.param.QChatSearchServerByPageParam
import com.netease.nimlib.sdk.qchat.param.QChatSearchServerMemberByPageParam
import com.netease.nimlib.sdk.qchat.param.QChatSendMessageParam
import com.netease.nimlib.sdk.qchat.param.QChatSendSystemNotificationParam
import com.netease.nimlib.sdk.qchat.param.QChatServerMarkReadParam
import com.netease.nimlib.sdk.qchat.param.QChatSubscribeAllChannelParam
import com.netease.nimlib.sdk.qchat.param.QChatSubscribeChannelParam
import com.netease.nimlib.sdk.qchat.param.QChatSubscribeServerAsVisitorParam
import com.netease.nimlib.sdk.qchat.param.QChatSubscribeServerParam
import com.netease.nimlib.sdk.qchat.param.QChatUnbanServerMemberParam
import com.netease.nimlib.sdk.qchat.param.QChatUpdateChannelBlackWhiteMembersParam
import com.netease.nimlib.sdk.qchat.param.QChatUpdateChannelBlackWhiteRolesParam
import com.netease.nimlib.sdk.qchat.param.QChatUpdateChannelParam
import com.netease.nimlib.sdk.qchat.param.QChatUpdateChannelRoleParam
import com.netease.nimlib.sdk.qchat.param.QChatUpdateMemberRoleParam
import com.netease.nimlib.sdk.qchat.param.QChatUpdateMessageParam
import com.netease.nimlib.sdk.qchat.param.QChatUpdateMyMemberInfoParam
import com.netease.nimlib.sdk.qchat.param.QChatUpdateParam
import com.netease.nimlib.sdk.qchat.param.QChatUpdateServerMemberInfoParam
import com.netease.nimlib.sdk.qchat.param.QChatUpdateServerParam
import com.netease.nimlib.sdk.qchat.param.QChatUpdateServerRoleParam
import com.netease.nimlib.sdk.qchat.param.QChatUpdateServerRolePrioritiesParam
import com.netease.nimlib.sdk.qchat.param.QChatUpdateSystemNotificationParam
import com.netease.nimlib.sdk.qchat.param.QChatUpdateUserServerPushConfigParam
import com.netease.nimlib.sdk.qchat.result.QChatAddChannelRoleResult
import com.netease.nimlib.sdk.qchat.result.QChatAddMemberRoleResult
import com.netease.nimlib.sdk.qchat.result.QChatAddMembersToServerRoleResult
import com.netease.nimlib.sdk.qchat.result.QChatApplyServerJoinResult
import com.netease.nimlib.sdk.qchat.result.QChatCheckPermissionResult
import com.netease.nimlib.sdk.qchat.result.QChatCheckPermissionsResult
import com.netease.nimlib.sdk.qchat.result.QChatCreateChannelResult
import com.netease.nimlib.sdk.qchat.result.QChatCreateServerResult
import com.netease.nimlib.sdk.qchat.result.QChatCreateServerRoleResult
import com.netease.nimlib.sdk.qchat.result.QChatDeleteMessageResult
import com.netease.nimlib.sdk.qchat.result.QChatEnterServerAsVisitorResult
import com.netease.nimlib.sdk.qchat.result.QChatGenerateInviteCodeResult
import com.netease.nimlib.sdk.qchat.result.QChatGetBannedServerMembersByPageResult
import com.netease.nimlib.sdk.qchat.result.QChatGetChannelBlackWhiteRolesByPageResult
import com.netease.nimlib.sdk.qchat.result.QChatGetChannelMembersByPageResult
import com.netease.nimlib.sdk.qchat.result.QChatGetChannelRolesResult
import com.netease.nimlib.sdk.qchat.result.QChatGetChannelUnreadInfosResult
import com.netease.nimlib.sdk.qchat.result.QChatGetChannelsByPageResult
import com.netease.nimlib.sdk.qchat.result.QChatGetChannelsResult
import com.netease.nimlib.sdk.qchat.result.QChatGetExistingAccidsInServerRoleResult
import com.netease.nimlib.sdk.qchat.result.QChatGetExistingAccidsOfMemberRolesResult
import com.netease.nimlib.sdk.qchat.result.QChatGetExistingChannelBlackWhiteRolesResult
import com.netease.nimlib.sdk.qchat.result.QChatGetExistingChannelRolesByServerRoleIdsResult
import com.netease.nimlib.sdk.qchat.result.QChatGetExistingServerRolesByAccidsResult
import com.netease.nimlib.sdk.qchat.result.QChatGetInviteApplyRecordOfSelfResult
import com.netease.nimlib.sdk.qchat.result.QChatGetInviteApplyRecordOfServerResult
import com.netease.nimlib.sdk.qchat.result.QChatGetMemberRolesResult
import com.netease.nimlib.sdk.qchat.result.QChatGetMembersFromServerRoleResult
import com.netease.nimlib.sdk.qchat.result.QChatGetMessageHistoryResult
import com.netease.nimlib.sdk.qchat.result.QChatGetServerMembersByPageResult
import com.netease.nimlib.sdk.qchat.result.QChatGetServerMembersResult
import com.netease.nimlib.sdk.qchat.result.QChatGetServerRolesByAccidResult
import com.netease.nimlib.sdk.qchat.result.QChatGetServerRolesResult
import com.netease.nimlib.sdk.qchat.result.QChatGetServersByPageResult
import com.netease.nimlib.sdk.qchat.result.QChatGetServersResult
import com.netease.nimlib.sdk.qchat.result.QChatGetUserPushConfigsResult
import com.netease.nimlib.sdk.qchat.result.QChatInviteServerMembersResult
import com.netease.nimlib.sdk.qchat.result.QChatKickOtherClientsResult
import com.netease.nimlib.sdk.qchat.result.QChatLeaveServerAsVisitorResult
import com.netease.nimlib.sdk.qchat.result.QChatLoginResult
import com.netease.nimlib.sdk.qchat.result.QChatRemoveMembersFromServerRoleResult
import com.netease.nimlib.sdk.qchat.result.QChatRevokeMessageResult
import com.netease.nimlib.sdk.qchat.result.QChatSearchChannelByPageResult
import com.netease.nimlib.sdk.qchat.result.QChatSearchChannelMembersResult
import com.netease.nimlib.sdk.qchat.result.QChatSearchServerByPageResult
import com.netease.nimlib.sdk.qchat.result.QChatSearchServerMemberByPageResult
import com.netease.nimlib.sdk.qchat.result.QChatSendMessageResult
import com.netease.nimlib.sdk.qchat.result.QChatSendSystemNotificationResult
import com.netease.nimlib.sdk.qchat.result.QChatServerMarkReadResult
import com.netease.nimlib.sdk.qchat.result.QChatSubscribeAllChannelResult
import com.netease.nimlib.sdk.qchat.result.QChatSubscribeChannelResult
import com.netease.nimlib.sdk.qchat.result.QChatSubscribeServerAsVisitorResult
import com.netease.nimlib.sdk.qchat.result.QChatSubscribeServerResult
import com.netease.nimlib.sdk.qchat.result.QChatUpdateChannelResult
import com.netease.nimlib.sdk.qchat.result.QChatUpdateChannelRoleResult
import com.netease.nimlib.sdk.qchat.result.QChatUpdateMemberRoleResult
import com.netease.nimlib.sdk.qchat.result.QChatUpdateMessageResult
import com.netease.nimlib.sdk.qchat.result.QChatUpdateMyMemberInfoResult
import com.netease.nimlib.sdk.qchat.result.QChatUpdateServerMemberInfoResult
import com.netease.nimlib.sdk.qchat.result.QChatUpdateServerResult
import com.netease.nimlib.sdk.qchat.result.QChatUpdateServerRolePrioritiesResult
import com.netease.nimlib.sdk.qchat.result.QChatUpdateServerRoleResult
import com.netease.nimlib.sdk.qchat.result.QChatUpdateSystemNotificationResult
import org.json.JSONException
import org.json.JSONObject

fun Map<String, *>.toQChatAcceptServerApplyParam(): QChatAcceptServerApplyParam {
    val requestId = (this["requestId"] as Number).toLong()
    val serverId = (this["serverId"] as Number).toLong()
    val accid = this["accid"] as String
    return QChatAcceptServerApplyParam(serverId, accid, requestId)
}

fun Map<String, *>.toQChatLoginParam(): QChatLoginParam {
    return QChatLoginParam()
}

fun Map<String, *>.toQChatAcceptServerInviteParam(): QChatAcceptServerInviteParam {
    val requestId = (this["requestId"] as Number).toLong()
    val serverId = (this["serverId"] as Number).toLong()
    val accid = this["accid"] as String
    return QChatAcceptServerInviteParam(serverId, accid, requestId)
}

fun Map<String, *>.toQChatApplyServerJoinParam(): QChatApplyServerJoinParam {
    val ttl = (this["ttl"] as? Number)?.toLong()
    val serverId = (this["serverId"] as Number).toLong()
    val postscript = this["postscript"] as? String
    return QChatApplyServerJoinParam(serverId).apply {
        this.ttl = ttl
        this.postscript = postscript ?: ""
    }
}

@Suppress("UNCHECKED_CAST")
fun Map<String, *>.toQChatKickOtherClientsParam(): QChatKickOtherClientsParam {
    val deviceIds = (this["deviceIds"] as List<Any>).map { it.toString() }
    return QChatKickOtherClientsParam(deviceIds)
}

@Suppress("UNCHECKED_CAST")
fun Map<String, *>.toQChatCreateServerParam(): QChatCreateServerParam {
    val name = this["name"] as String
    val icon = this["icon"] as? String
    val custom = this["custom"] as? String
    val inviteMode =
        (this["inviteMode"] as? String)?.toQChatInviteMode() ?: QChatInviteMode.AGREE_NEED_NOT
    val applyJoinMode = (this["applyJoinMode"] as? String)?.toQChatApplyJoinMode()
        ?: QChatApplyJoinMode.AGREE_NEED_NOT
    val searchType = (this["searchType"] as? Number)?.toInt()
    val searchEnable = this["searchEnable"] as Boolean
    val antiSpamConfig = (this["antiSpamConfig"] as? Map<String, *>)?.toQChatAntiSpamConfig()
    return QChatCreateServerParam(name).apply {
        this.icon = icon
        this.custom = custom
        this.inviteMode = inviteMode
        this.applyJoinMode = applyJoinMode
        this.searchType = searchType
        this.searchEnable = searchEnable
        this.antiSpamConfig = antiSpamConfig
    }
}

fun Map<String, *>.toQChatDeleteServerParam(): QChatDeleteServerParam {
    val serverId = (this["serverId"] as Number).toLong()
    return QChatDeleteServerParam(serverId)
}

@Suppress("UNCHECKED_CAST")
fun Map<String, *>.toQChatGetServerMembersParam(): QChatGetServerMembersParam {
    val list = (this["serverIdAccidPairList"] as List<Any>).map {
        (it as Map<String, *>).toPairIntWithString()
    }
    return QChatGetServerMembersParam(list)
}

@Suppress("UNCHECKED_CAST")
fun Map<String, *>.toQChatGetServersParam(): QChatGetServersParam {
    val list = (this["serverIds"] as List<Any>).map {
        it.toString().toLong()
    }
    return QChatGetServersParam(list)
}

fun Map<String, *>.toPairIntWithString(): Pair<Long, String> {
    return Pair((this["first"] as? Number)?.toLong(), this["second"] as? String)
}

fun Map<String, *>.toQChatAntiSpamConfig(): QChatAntiSpamConfig {
    return QChatAntiSpamConfig().also {
        it.antiSpamBusinessId = this["antiSpamBusinessId"] as? String
    }
}

fun Map<String, *>.toQChatGetServerMembersByPageParam(): QChatGetServerMembersByPageParam {
    return QChatGetServerMembersByPageParam(
        (this["serverId"] as Number).toLong(),
        (this["timeTag"] as Number).toLong(),
        (this["limit"] as Number).toInt()
    )
}

fun Map<String, *>.toQChatGetServersByPageParam(): QChatGetServersByPageParam {
    return QChatGetServersByPageParam(
        (this["timeTag"] as Number).toLong(),
        (this["limit"] as Number).toInt()
    )
}

@Suppress("UNCHECKED_CAST")
fun Map<String, *>.toQChatInviteServerMembersParam(): QChatInviteServerMembersParam {
    return QChatInviteServerMembersParam(
        (this["serverId"] as Number).toLong(),
        (this["accids"] as List<Any>).map {
            it.toString()
        }
    ).also {
        it.postscript = this["postscript"] as? String ?: ""
        it.ttl = (this["ttl"] as? Number)?.toLong()
    }
}

@Suppress("UNCHECKED_CAST")
fun Map<String, *>.toQChatKickServerMembersParam(): QChatKickServerMembersParam {
    return QChatKickServerMembersParam(
        (this["serverId"] as Number).toLong(),
        (this["accids"] as List<Any>).map {
            it.toString()
        }
    )
}

fun Map<String, *>.toQChatLeaveServerParam(): QChatLeaveServerParam {
    return QChatLeaveServerParam(
        (this["serverId"] as Number).toLong()
    )
}

fun Map<String, *>.toQChatRejectServerApplyParam(): QChatRejectServerApplyParam {
    return QChatRejectServerApplyParam(
        (this["serverId"] as Number).toLong(),
        this["accid"] as String,
        (this["requestId"] as Number).toLong()
    ).also {
        it.postscript = this["postscript"] as? String ?: ""
    }
}

fun Map<String, *>.toQChatRejectServerInviteParam(): QChatRejectServerInviteParam {
    return QChatRejectServerInviteParam(
        (this["serverId"] as Number).toLong(),
        this["accid"] as String,
        (this["requestId"] as Number).toLong()
    ).also {
        it.postscript = this["postscript"] as? String ?: ""
    }
}

@Suppress("UNCHECKED_CAST")
fun Map<String, *>.toQChatUpdateServerParam(): QChatUpdateServerParam {
    return QChatUpdateServerParam(
        (this["serverId"] as Number).toLong()
    ).also {
        it.name = this["name"] as? String
        it.icon = this["icon"] as? String
        it.custom = this["custom"] as? String
        it.inviteMode = (this["inviteMode"] as? String)?.toQChatInviteMode()
        it.applyMode = (this["applyMode"] as? String)?.toQChatApplyJoinMode()
        it.searchType = (this["searchType"] as? Number)?.toInt()
        it.searchEnable = this["searchEnable"] as? Boolean
        it.antiSpamConfig = (this["antiSpamConfig"] as? Map<String, *>)?.toQChatAntiSpamConfig()
    }
}

@Suppress("UNCHECKED_CAST")
fun Map<String, *>.toQChatUpdateMyMemberInfoParam(): QChatUpdateMyMemberInfoParam {
    return QChatUpdateMyMemberInfoParam(
        (this["serverId"] as Number).toLong()
    ).also {
        it.nick = this["nick"] as? String
        it.avatar = this["avatar"] as? String
        it.custom = this["custom"] as? String
        it.antiSpamConfig = (this["antiSpamConfig"] as? Map<String, *>)?.toQChatAntiSpamConfig()
    }
}

@Suppress("UNCHECKED_CAST")
fun Map<String, *>.toQChatSubscribeServerParam(): QChatSubscribeServerParam {
    return QChatSubscribeServerParam(
        (this["type"] as? String)?.toQChatSubscribeType()!!,
        (this["operateType"] as? String)?.toQChatSubscribeOperateType()!!,
        (this["serverIds"] as List<Any>).map { it.toString().toLong() }
    )
}

@Suppress("UNCHECKED_CAST")
fun Map<String, *>.toQChatSearchServerByPageParam(): QChatSearchServerByPageParam {
    return QChatSearchServerByPageParam(
        this["keyword"] as String,
        this["asc"] as? Boolean ?: false,
        (this["searchType"] as? String)?.toQChatSearchServerTypeEnum()!!,
        (this["startTime"] as? Number)?.toLong(),
        (this["endTime"] as? Number)?.toLong(),
        (this["limit"] as? Number)?.toInt(),
        (this["serverTypes"] as? List<Any>)?.map { it.toString().toInt() },
        (this["sort"] as? String)?.toQChatServerSearchSortEnum(),
        this["cursor"] as? String
    )
}

@Suppress("UNCHECKED_CAST")
fun Map<String, *>.toQChatGenerateInviteCodeParam(): QChatGenerateInviteCodeParam {
    return QChatGenerateInviteCodeParam(
        (this["serverId"] as Number).toLong()
    ).also {
        it.ttl = (this["ttl"] as? Number)?.toLong()
    }
}

@Suppress("UNCHECKED_CAST")
fun Map<String, *>.toQChatJoinByInviteCodeParam(): QChatJoinByInviteCodeParam {
    return QChatJoinByInviteCodeParam(
        (this["serverId"] as? Number)?.toLong() ?: 0L,
        this["inviteCode"] as? String
    ).also {
        it.postscript = this["postscript"] as? String
    }
}

fun String.toQChatInviteMode() = when (this) {
    "agreeNeedNot" -> QChatInviteMode.AGREE_NEED_NOT
    "agreeNeed" -> QChatInviteMode.AGREE_NEED
    else -> null
}

fun String.toQChatApplyJoinMode() = when (this) {
    "agreeNeedNot" -> QChatApplyJoinMode.AGREE_NEED_NOT
    "agreeNeed" -> QChatApplyJoinMode.AGREE_NEED
    else -> null
}

fun String.toQChatSubscribeType() = when (this) {
    "channelMsg" -> QChatSubscribeType.CHANNEL_MSG
    "channelMsgUnreadCount" -> QChatSubscribeType.CHANNEL_MSG_UNREAD_COUNT
    "channelMsgUnreadStatus" -> QChatSubscribeType.CHANNEL_MSG_UNREAD_STATUS
    "serverMsg" -> QChatSubscribeType.SERVER_MSG
    "channelMsgTyping" -> QChatSubscribeType.CHANNEL_MSG_TYPING
    else -> null
}

fun String.toQChatSearchServerTypeEnum() = when (this) {
    "undefined" -> QChatSearchServerTypeEnum.undefined
    "square" -> QChatSearchServerTypeEnum.Square
    "personal" -> QChatSearchServerTypeEnum.Personal
    else -> null
}

fun String.toQChatServerSearchSortEnum() = when (this) {
    "reorderWeight" -> QChatServerSearchSortEnum.ReorderWeight
    "createTime" -> QChatServerSearchSortEnum.CreateTime
    "totalMember" -> QChatServerSearchSortEnum.TotalMember
    else -> null
}

fun String.toQChatSubscribeOperateType() = when (this) {
    "sub" -> QChatSubscribeOperateType.SUB
    "unSub" -> QChatSubscribeOperateType.UN_SUB
    else -> null
}

fun QChatApplyServerJoinResult.toMap(): Map<String, Any?> {
    return mapOf(
        "applyServerMemberInfo" to applyServerMemberInfo?.toMap()
    )
}

fun QChatInviteApplyServerMemberInfo.toMap(): Map<String, Any?> {
    return mapOf(
        "requestId" to requestId,
        "expireTime" to expireTime
    )
}

fun QChatCreateServerResult.toMap(): Map<String, Any?> {
    return mapOf(
        "server" to server?.toMap()
    )
}

fun QChatServer.toMap(): Map<String, Any?> {
    return mapOf(
        "serverId" to serverId,
        "name" to name,
        "icon" to icon,
        "custom" to custom,
        "owner" to owner,
        "memberNumber" to memberNumber,
        "inviteMode" to inviteMode?.toStr(),
        "applyMode" to applyMode?.toStr(),
        "valid" to isValid,
        "createTime" to createTime,
        "updateTime" to updateTime,
        "channelNum" to channelNum,
        "channelCategoryNum" to channelCategoryNum,
        "searchType" to searchType,
        "searchEnable" to searchEnable,
        "reorderWeight" to reorderWeight
    )
}

fun QChatInviteMode.toStr() = when (this) {
    QChatInviteMode.AGREE_NEED -> "agreeNeed"
    QChatInviteMode.AGREE_NEED_NOT -> "agreeNeedNot"
}

fun QChatApplyJoinMode.toStr() = when (this) {
    QChatApplyJoinMode.AGREE_NEED_NOT -> "agreeNeedNot"
    QChatApplyJoinMode.AGREE_NEED -> "agreeNeed"
}

fun QChatGetServerMembersResult.toMap() = mapOf<String, Any?>(
    "serverMembers" to serverMembers?.map {
        it.toMap()
    }
)

fun QChatServerMember.toMap() = mapOf<String, Any?>(
    "serverId" to serverId,
    "accid" to accid,
    "nick" to nick,
    "avatar" to avatar,
    "custom" to if (custom == null) "" else custom,
    "type" to type.toStr(),
    "joinTime" to joinTime,
    "inviter" to inviter,
    "valid" to isValid,
    "createTime" to createTime,
    "updateTime" to updateTime
)

fun QChatMemberType.toStr() = when (this) {
    QChatMemberType.Normal -> "normal"
    QChatMemberType.Owner -> "owner"
}

fun QChatGetServerMembersByPageResult.toMap() = mapOf<String, Any?>(
    "hasMore" to isHasMore,
    "nextTimeTag" to nextTimeTag,
    "serverMembers" to serverMembers?.map {
        it.toMap()
    }
)

fun QChatGetServersByPageResult.toMap() = mapOf<String, Any?>(
    "hasMore" to isHasMore,
    "nextTimeTag" to nextTimeTag,
    "servers" to servers?.map { it.toMap() }
)

fun QChatInviteServerMembersResult.toMap() = mapOf<String, Any?>(
    "failedAccids" to failedAccids,
    "bannedAccids" to bannedAccids,
    "inviteServerMemberInfo" to inviteServerMemberInfo?.toMap()
)

fun QChatUpdateServerResult.toMap() = mapOf<String, Any?>(
    "server" to server?.toMap()
)

fun QChatUpdateMyMemberInfoResult.toMap() = mapOf<String, Any?>(
    "member" to member?.toMap()
)

fun QChatSubscribeServerResult.toMap() = mapOf<String, Any?>(
    "failedList" to failedList
)

fun QChatSearchServerByPageResult.toMap() = mapOf<String, Any?>(
    "servers" to servers?.map { it.toMap() },
    "hasMore" to isHasMore,
    "nextTimeTag" to nextTimeTag,
    "cursor" to cursor
)

fun QChatGenerateInviteCodeResult.toMap() = mapOf<String, Any?>(
    "serverId" to serverId,
    "requestId" to requestId,
    "inviteCode" to inviteCode,
    "expireTime" to expireTime
)

fun QChatGetServersResult.toMap() = mapOf<String, Any?>(
    "servers" to servers?.map { it.toMap() }
)

fun QChatKickOtherClientsResult.toMap() = mapOf<String, Any?>(
    "clientIds" to clientIds
)

fun QChatLoginResult.toMap() = mapOf<String, Any?>(
    "currentClient" to currentClient.toMap(),
    "otherClients" to otherClients.map { it.toMap() }
)

fun QChatClient.toMap() = mapOf<String, Any?>(
    "clientType" to clientType.toStr(),
    "os" to os,
    "loginTime" to loginTime,
    "clientIp" to clientIp,
    "clientPort" to clientPort,
    "deviceId" to deviceId,
    "customTag" to customTag,
    "customClientType" to customClientType
)

fun Int.toStr(): String? = when (this) {
    ClientType.UNKNOW -> "unknown"
    ClientType.Android -> "android"
    ClientType.iOS -> "ios"
    ClientType.Windows -> "windows"
    ClientType.WP -> "wp"
    ClientType.Web -> "web"
    ClientType.REST -> "rest"
    ClientType.MAC -> "macos"
    else -> null
}

@Suppress("UNCHECKED_CAST")
fun Map<String, *>.toQChatCreateChannelParamParam(): QChatCreateChannelParam {
    val type = stringToQChatChannelType(this["type"] as String)
    val serverId = (this["serverId"] as Number).toLong()
    val name = this["name"] as String
    val antiSpamConfig = (this["antiSpamConfig"] as? Map<String, *>)?.toQChatAntiSpamConfig()
    val param = QChatCreateChannelParam(serverId, name, type)
    param.viewMode = stringToQChatChannelMode(this["viewMode"] as String?)
    param.custom = this["custom"] as String?
//    (this["categoryId"] as Number?)?.toLong()?.let {
//        param.categoryId = it
//    }
    param.topic = this["topic"] as String?
//    param.syncMode = stringToQChatChannelSyncMode(this["syncMode"] as String?)
    antiSpamConfig?.let {
        param.antiSpamConfig = it
    }
    param.visitorMode = stringToQChatVisitorMode(this["visitorMode"] as String?)
    return param
}

fun QChatCreateChannelResult.toMap() = mapOf<String, Any?>(
    "channel" to channel.toMap()
)

fun QChatChannel.toMap() = mapOf<String, Any?>(
    "channelId" to channelId,
    "serverId" to serverId,
    "viewMode" to stringFromQChatChannelMode(viewMode),
    "syncMode" to stringFromQChatChannelSyncMode(syncMode),
    "categoryId" to categoryId,
    "topic" to topic,
    "custom" to custom,
    "name" to name,
    "type" to stringFromQChatChannelType(type),
    "createTime" to createTime,
    "reorderWeight" to reorderWeight,
    "owner" to owner,
    "updateTime" to updateTime,
    "valid" to isValid,
    "visitorMode" to stringFromQChatVisitorMode(visitorMode)
)

fun Map<String, *>.toQChatDeleteChannelParam(): QChatDeleteChannelParam {
    return QChatDeleteChannelParam((this["channelId"] as Number).toLong())
}

@Suppress("UNCHECKED_CAST")
fun Map<String, *>.toQChatUpdateChannelParam(): QChatUpdateChannelParam {
    val param = QChatUpdateChannelParam((this["channelId"] as Number).toLong())
    param.custom = this["custom"] as String?
    param.topic = this["topic"] as String?
    param.name = this["name"] as String?
    param.viewMode = stringToQChatChannelMode(this["viewMode"] as String?)
    val antiSpamConfig = (this["antiSpamConfig"] as? Map<String, *>)?.toQChatAntiSpamConfig()
    param.antiSpamConfig = antiSpamConfig
    param.visitorMode = stringToQChatVisitorMode(this["visitorMode"] as String?)
    return param
}

fun QChatUpdateChannelResult.toMap() = mapOf<String, Any?>(
    "channel" to channel.toMap()
)

@Suppress("UNCHECKED_CAST")
fun Map<String, *>.toQChatGetChannelsParam(): QChatGetChannelsParam {
    val channelIds = (this["channelIds"] as List<Any?>).map { (it as Number).toLong() }
    return QChatGetChannelsParam(channelIds)
}

fun QChatGetChannelsResult.toMap() = mapOf<String, Any?>(
    "channels" to channels.map { it?.toMap() }.toList()
)

fun Map<String, *>.toQChatGetChannelsByPageParam(): QChatGetChannelsByPageParam {
    val serverId = (this["serverId"] as Number).toLong()
    val timeTag = (this["timeTag"] as Number).toLong()
    val limit = (this["limit"] as Number).toInt()
    return QChatGetChannelsByPageParam(serverId, timeTag, limit)
}

fun QChatGetChannelsByPageResult.toMap() = mapOf<String, Any?>(
    "channels" to channels.map { it?.toMap() }.toList(),
    "hasMore" to isHasMore,
    "nextTimeTag" to nextTimeTag
)

fun Map<String, *>.toQChatGetChannelMembersByPageParam(): QChatGetChannelMembersByPageParam {
    val serverId = (this["serverId"] as Number).toLong()
    val channelId = (this["channelId"] as Number).toLong()
    val timeTag = (this["timeTag"] as Number).toLong()
    val limit = (this["limit"] as Number?)?.toInt()
    val param = QChatGetChannelMembersByPageParam(serverId, channelId, timeTag)
    limit?.let { param.limit = limit }
    return param
}

fun QChatGetChannelMembersByPageResult.toMap() = mapOf<String, Any?>(
    "members" to members.map { it?.toMap() }.toList(),
    "hasMore" to isHasMore,
    "nextTimeTag" to nextTimeTag
)

@Suppress("UNCHECKED_CAST")
fun Map<String, *>.toQChatGetChannelUnreadInfosParam(): QChatGetChannelUnreadInfosParam {
    val channelIdInfos =
        (this["channelIdInfos"] as List<Map<String, *>?>).map { it?.toQChatChannelIdInfo() }
    return QChatGetChannelUnreadInfosParam(channelIdInfos)
}

fun Map<String, *>.toQChatChannelIdInfo(): QChatChannelIdInfo {
    val serverId = (this["serverId"] as Number).toLong()
    val channelId = (this["channelId"] as Number).toLong()
    return QChatChannelIdInfo(serverId, channelId)
}

fun QChatGetChannelUnreadInfosResult.toMap() = mapOf<String, Any?>(
    "unreadInfoList" to unreadInfoList.map { it.toMap() }.toList()
)

fun QChatUnreadInfo.toMap() = mapOf<String, Any?>(
    "serverId" to serverId,
    "channelId" to channelId,
    "unreadCount" to unreadCount,
    "mentionedCount" to mentionedCount,
    "maxCount" to maxCount,
    "ackTimeTag" to ackTimeTag,
    "lastMsgTime" to lastMsgTime,
    "time" to time
)

@Suppress("UNCHECKED_CAST")
fun Map<String, *>.toQChatSubscribeChannelParam(): QChatSubscribeChannelParam {
    val channelIdInfos =
        (this["channelIdInfos"] as List<Map<String, *>?>).map { it?.toQChatChannelIdInfo() }
    val type = stringToQChatSubscribeType(this["type"] as String)
    val operateType = stringToQChatSubscribeOperateType(this["operateType"] as String)
    return QChatSubscribeChannelParam(type!!, operateType!!, channelIdInfos)
}

fun QChatSubscribeChannelResult.toMap() = mapOf<String, Any?>(
    "unreadInfoList" to unreadInfoList.map { it.toMap() }.toList(),
    "failedList" to failedList.map { it.toMap() }.toList()
)

fun QChatChannelIdInfo.toMap() = mapOf<String, Any?>(
    "serverId" to serverId,
    "channelId" to channelId
)

fun Map<String, *>.toQChatSearchChannelByPageParam(): QChatSearchChannelByPageParam {
    val keyword = this["keyword"] as String
    val asc = this["asc"] as Boolean
    val param = QChatSearchChannelByPageParam(keyword, asc)
    (this["startTime"] as Number?)?.toLong()?.let {
        param.startTime = it
    }
    (this["endTime"] as Number?)?.toLong()?.let {
        param.endTime = it
    }
    (this["limit"] as Number?)?.toInt()?.let {
        param.limit = it
    }
    (this["serverId"] as Number?)?.toLong()?.let {
        param.serverId = it
    }
    (this["cursor"] as String?)?.let {
        param.cursor = it
    }
    stringToQChatChannelSearchSortEnum(this["sort"] as String?)?.let {
        param.sort = it
    }
    return param
}

fun QChatSearchChannelByPageResult.toMap() = mapOf<String, Any?>(
    "channels" to channels.map { it.toMap() }.toList(),
    "hasMore" to isHasMore,
    "nextTimeTag" to nextTimeTag,
    "cursor" to cursor
)

fun Map<String, *>.toQChatSearchChannelMembersParam(): QChatSearchChannelMembersParam {
    val keyword = this["keyword"] as String
    val serverId = (this["serverId"] as Number).toLong()
    val channelId = (this["channelId"] as Number).toLong()
    val param = QChatSearchChannelMembersParam(serverId, channelId, keyword)
    (this["limit"] as Number?)?.toInt()?.let {
        param.limit = it
    }
    return param
}

fun Map<String, *>.toQChatUpdateChannelBlackWhiteRolesParam(): QChatUpdateChannelBlackWhiteRolesParam {
    val serverId = (this["serverId"] as Number).toLong()
    val channelId = (this["channelId"] as Number).toLong()
    val type = stringToQChatChannelBlackWhiteType(this["type"] as String)!!
    val operateType = stringToQChatChannelBlackWhiteOperateType(this["operateType"] as String)!!
    val roleId = (this["roleId"] as Number).toLong()
    return QChatUpdateChannelBlackWhiteRolesParam(serverId, channelId, type, operateType, roleId)
}

fun Map<String, *>.toQChatGetChannelBlackWhiteRolesByPageParam(): QChatGetChannelBlackWhiteRolesByPageParam {
    val serverId = (this["serverId"] as Number).toLong()
    val channelId = (this["channelId"] as Number).toLong()
    val type = stringToQChatChannelBlackWhiteType(this["type"] as String)!!
    val timeTag = (this["timeTag"] as Number).toLong()
    val param = QChatGetChannelBlackWhiteRolesByPageParam(serverId, channelId, type, timeTag)
    (this["limit"] as Number?)?.toInt()?.let {
        param.limit = it
    }
    return param
}

fun QChatGetChannelBlackWhiteRolesByPageResult.toMap() = mapOf<String, Any?>(
    "hasMore" to isHasMore,
    "nextTimeTag" to nextTimeTag,
    "roleList" to roleList?.map { it.toMap() }?.toList()
)

fun Map<String, *>.toQChatGetExistingChannelBlackWhiteRolesParam(): QChatGetExistingChannelBlackWhiteRolesParam {
    val serverId = (this["serverId"] as Number).toLong()
    val channelId = (this["channelId"] as Number).toLong()
    val type = stringToQChatChannelBlackWhiteType(this["type"] as String)!!
    val roleIds = (this["roleIds"] as List<*>).map { (it as Number).toLong() }
    return QChatGetExistingChannelBlackWhiteRolesParam(serverId, channelId, type, roleIds)
}

fun QChatGetExistingChannelBlackWhiteRolesResult.toMap() = mapOf<String, Any?>(
    "roleList" to roleList?.map { it.toMap() }?.toList()
)

fun Map<String, *>.toQChatUpdateChannelBlackWhiteMembersParam(): QChatUpdateChannelBlackWhiteMembersParam {
    val serverId = (this["serverId"] as Number).toLong()
    val channelId = (this["channelId"] as Number).toLong()
    val type = stringToQChatChannelBlackWhiteType(this["type"] as String)!!
    val operateType = stringToQChatChannelBlackWhiteOperateType(this["operateType"] as String)!!
    val toAccids = (this["toAccids"] as List<String>)
    return QChatUpdateChannelBlackWhiteMembersParam(
        serverId,
        channelId,
        type,
        operateType,
        toAccids
    )
}

fun QChatSearchChannelMembersResult.toMap() = mapOf<String, Any?>(
    "members" to members?.map { it.toMap() }?.toList()
)

fun QChatChannelMember.toMap() = mapOf<String, Any?>(
    "serverId" to serverId,
    "channelId" to channelId,
    "avatar" to avatar,
    "accid" to accid,
    "nick" to nick,
    "createTime" to createTime,
    "updateTime" to updateTime
)

@Suppress("UNCHECKED_CAST")
fun Map<String, *>.toQChatDeleteMessageParam(): QChatDeleteMessageParam {
    val updateParam = (this["updateParam"] as Map<String, *>).toQChatUpdateParam()
    val serverId = (this["serverId"] as Number).toLong()
    val channelId = (this["channelId"] as Number).toLong()
    val time = (this["time"] as Number).toLong()
    val msgIdServer = (this["msgIdServer"] as Number).toLong()
    return QChatDeleteMessageParam(updateParam, serverId, channelId, time, msgIdServer)
}

@Suppress("UNCHECKED_CAST")
fun Map<String, *>.toQChatUpdateParam(): QChatUpdateParam {
    val param = QChatUpdateParam()
    param.postscript = this["postscript"] as String
    (this["extension"] as String?)?.let {
        param.extension = it
    }
    (this["pushContent"] as String?)?.let {
        param.pushContent = it
    }
    (this["env"] as String?)?.let {
        param.env = it
    }
    (this["routeEnable"] as Boolean?)?.let {
        param.isRouteEnable = it
    }
    (this["pushPayload"] as Map<String, Any>?)?.let {
        param.pushPayload = it
    }
    return param
}

fun QChatDeleteMessageResult.toMap() = mapOf<String, Any?>(
    "message" to message.toMap()
)

fun QChatMessage.toMap() = mapOf<String, Any?>(
    "qChatServerId" to qChatServerId,
    "qChatChannelId" to qChatChannelId,
    "fromAccount" to fromAccount,
    "fromClientType" to fromClientType,
    "fromNick" to fromNick,
    "time" to time,
    "updateTime" to updateTime,
    "msgType" to stringFromMsgTypeEnum(msgType),
    "content" to content,
    "remoteExtension" to remoteExtension,
    "uuid" to uuid,
    "msgIdServer" to msgIdServer,
    "resend" to isResend,
    "serverStatus" to serverStatus,
    "pushPayload" to pushPayload,
    "pushContent" to pushContent,
    "mentionedAccidList" to (mentionedAccidList ?: emptyList<String>()),
    "mentionedAll" to isMentionedAll,
    "historyEnable" to isHistoryEnable,
    "attachment" to AttachmentHelper.attachmentToMap(msgType, attachment),
    "attachStatus" to stringFromAttachStatusEnum(attachStatus),
    "pushEnable" to isPushEnable,
    "needBadge" to isNeedBadge,
    "needPushNick" to isNeedPushNick,
    "routeEnable" to isRouteEnable,
    "env" to env,
    "callbackExtension" to callbackExtension,
    "replyRefer" to replyRefer?.toMap(),
    "threadRefer" to threadRefer?.toMap(),
    "rootThread" to isRootThread,
    "antiSpamOption" to antiSpamOption?.toMap(),
    "antiSpamResult" to antiSpamResult?.toMap(),
    "updateContent" to updateContent?.toMap(),
    "updateOperatorInfo" to updateOperatorInfo?.toMap(),
    "mentionedRoleIdList" to mentionedRoleIdList,
    "subType" to subType,
    "direct" to stringFromMsgDirectionEnum(direct),
    "localExtension" to localExtension,
    "status" to stringFromMsgStatusEnum(status, false)
)

fun QChatMessageRefer.toMap() = mapOf<String, Any?>(
    "fromAccount" to fromAccount,
    "time" to time,
    "msgIdServer" to msgIdServer,
    "uuid" to uuid
)

fun QChatMessageAntiSpamOption.toMap() = mapOf<String, Any?>(
    "isCustomAntiSpamEnable" to customAntiSpamEnable,
    "customAntiSpamContent" to customAntiSpamContent,
    "antiSpamBusinessId" to antiSpamBusinessId,
    "isAntiSpamUsingYidun" to antiSpamUsingYidun,
    "yidunCallback" to yidunCallback,
    "yidunAntiCheating" to yidunAntiCheating,
    "yidunAntiSpamExt" to yidunAntiSpamExt
)

fun Map<String, *>.toQChatMessageAntiSpamOption(): QChatMessageAntiSpamOption {
    val param = QChatMessageAntiSpamOption()
    (this["customAntiSpamEnable"] as Boolean?)?.let {
        param.customAntiSpamEnable = it
    }
    (this["customAntiSpamContent"] as String?)?.let {
        param.customAntiSpamContent = it
    }
    (this["antiSpamBusinessId"] as String?)?.let {
        param.antiSpamBusinessId = it
    }
    (this["antiSpamUsingYidun"] as Boolean?)?.let {
        param.antiSpamUsingYidun = it
    }
    (this["yidunCallback"] as String?)?.let {
        param.yidunCallback = it
    }
    (this["yidunAntiCheating"] as String?)?.let {
        param.yidunAntiCheating = it
    }
    (this["yidunAntiSpamExt"] as String?)?.let {
        param.yidunAntiSpamExt = it
    }
    return param
}

fun QChatMessageAntiSpamResult.toMap() = mapOf<String, Any?>(
    "isAntiSpam" to isAntiSpam,
    "yidunAntiSpamRes" to yidunAntiSpamRes
)

fun Map<String, *>.toQChatMessageAntiSpamResult(): QChatMessageAntiSpamResult {
    val yidunAntiSpamRes = this["yidunAntiSpamRes"] as String?
    val isAntiSpam = this["isAntiSpam"] as Boolean?
    return QChatMessageAntiSpamResult(isAntiSpam ?: false, yidunAntiSpamRes)
}

fun QChatMsgUpdateContent.toMap() = mapOf<String, Any?>(
    "serverStatus" to serverStatus,
    "content" to content,
    "remoteExtension" to remoteExtension
)

fun Map<String, *>.toQChatMsgUpdateContent(): QChatMsgUpdateContent {
    val result = QChatMsgUpdateContentImpl()
    val content = this["content"] as String?
    val serverStatus = (this["serverStatus"] as Number?)?.toInt()
    val remoteExtension = this["remoteExtension"]?.toString()
    result.content = content
    result.serverStatus = serverStatus
    result.setRemoteExtension(remoteExtension)
    return result
}

fun QChatMsgUpdateInfo.toMap() = mapOf<String, Any?>(
    "operatorAccount" to operatorAccount,
    "operatorClientType" to operatorClientType,
    "msg" to msg,
    "ext" to ext,
    "pushContent" to pushContent,
    "pushPayload" to pushPayload,
    "routeEnable" to routeEnable,
    "env" to env
)

fun Map<String, *>.toQChatGetMessageHistoryParam(): QChatGetMessageHistoryParam {
    val serverId = (this["serverId"] as Number).toLong()
    val channelId = (this["channelId"] as Number).toLong()
    val param = QChatGetMessageHistoryParam(serverId, channelId)
    (this["fromTime"] as Number?)?.toLong()?.let {
        param.fromTime = it
    }
    (this["toTime"] as Number?)?.toLong()?.let {
        param.toTime = it
    }
    (this["excludeMessageId"] as Number?)?.toLong()?.let {
        param.excludeMessageId = it
    }
    (this["limit"] as Number?)?.toInt()?.let {
        param.limit = it
    }
    (this["reverse"] as Boolean?)?.let {
        param.isReverse = it
    }
    return param
}

fun QChatGetMessageHistoryResult.toMap() = mapOf<String, Any?>(
    "messages" to messages.map { it.toMap() }.toList()
)

@Suppress("UNCHECKED_CAST")
fun Map<String, *>.toQChatGetMessageHistoryByIdsParam(): QChatGetMessageHistoryByIdsParam {
    val serverId = (this["serverId"] as Number).toLong()
    val channelId = (this["channelId"] as Number).toLong()
    val messageReferList =
        (this["messageReferList"] as List<Map<String, *>>).map { it.toQChatMessageRefer() }
    return QChatGetMessageHistoryByIdsParam(serverId, channelId, messageReferList)
}

fun Map<String, *>.toQChatMessageRefer(): QChatMessageRefer {
    val fromAccount = this["fromAccount"] as String
    val time = (this["time"] as Number).toLong()
    val msgIdServer = (this["msgIdServer"] as Number).toLong()
    val uuid = this["uuid"] as String
    return QChatMessageRefer(fromAccount, time, msgIdServer, uuid)
}

fun Map<String, *>.toQChatMarkMessageReadParam(): QChatMarkMessageReadParam {
    val serverId = (this["serverId"] as Number).toLong()
    val channelId = (this["channelId"] as Number).toLong()
    val ackTimestamp = (this["ackTimestamp"] as Number).toLong()
    return QChatMarkMessageReadParam(serverId, channelId, ackTimestamp)
}

@Suppress("UNCHECKED_CAST")
fun Map<String, *>.toQChatMarkSystemNotificationsReadParam(): QChatMarkSystemNotificationsReadParam {
    val pairs = (this["pairs"] as List<Map<String, *>>).map { it.toReadPair() }
    return QChatMarkSystemNotificationsReadParam(pairs)
}

fun Map<String, *>.toReadPair(): Pair<Long, QChatSystemNotificationType> {
    val msgId = (this["msgId"] as Number).toLong()
    val type = stringToQChatSystemNotificationType(this["type"] as String?)
    return Pair<Long, QChatSystemNotificationType>(msgId, type)
}

@Suppress("UNCHECKED_CAST")
fun Map<String, *>.toQChatRevokeMessageParam(): QChatRevokeMessageParam {
    val updateParam = (this["updateParam"] as Map<String, *>).toQChatUpdateParam()
    val serverId = (this["serverId"] as Number).toLong()
    val channelId = (this["channelId"] as Number).toLong()
    val time = (this["time"] as Number).toLong()
    val msgIdServer = (this["msgIdServer"] as Number).toLong()
    return QChatRevokeMessageParam(updateParam, serverId, channelId, time, msgIdServer)
}

fun QChatRevokeMessageResult.toMap() = mapOf<String, Any?>(
    "message" to message.toMap()
)

fun String.getMap(): MutableMap<String, Any>? {
    try {
        val jsonObject = JSONObject(this)
        val keyIter: Iterator<String> = jsonObject.keys()
        val valueMap = mutableMapOf<String, Any>()
        keyIter.forEach {
            valueMap[it] = jsonObject[it] as Any
        }
        return valueMap
    } catch (e: JSONException) {
        e.printStackTrace()
    }
    return null
}

@Suppress("UNCHECKED_CAST")
fun Map<String, *>.toQChatSendMessageParam(): QChatSendMessageParam {
    val serverId = (this["serverId"] as Number).toLong()
    val channelId = (this["channelId"] as Number).toLong()
    val type = stringToMsgTypeEnum(this["type"] as String)
    val param = QChatSendMessageParam(serverId, channelId, type)
    (this["extension"] as Map<String, Any>?)?.let {
        param.extension = it
    }
    (this["antiSpamOption"] as Map<String, Any>?)?.let {
        param.antiSpamOption = it.toQChatMessageAntiSpamOption()
    }
    // 先转map，再走attachment统一的反序列化逻辑
    (this["attach"] as String?)?.let {
        val map = it.getMap()
        if (map != null) {
            val attachment = AttachmentHelper.attachmentFromMap(type, map)
            param.attach = attachment?.toJson(false)
        }
    }
    (this["body"] as String?)?.let {
        param.body = it
    }
    (this["env"] as String?)?.let {
        param.env = it
    }
    (this["historyEnable"] as Boolean?)?.let {
        param.isHistoryEnable = it
    }
    (this["isRouteEnable"] as Boolean?)?.let {
        param.isRouteEnable = it
    }
    (this["mentionedAccidList"] as List<String>?)?.let {
        param.mentionedAccidList = it
    }
    (this["mentionedAll"] as Boolean?)?.let {
        param.isMentionedAll = it
    }
    (this["mentionedRoleIdList"] as List<*>?)?.let { e ->
        param.mentionedRoleIdList = e.map { (it as Number).toLong() }
    }
    (this["needBadge"] as Boolean?)?.let {
        param.isNeedBadge = it
    }
    (this["needPushNick"] as Boolean?)?.let {
        param.isNeedPushNick = it
    }
    (this["pushContent"] as String?)?.let {
        param.pushContent = it
    }
    (this["pushEnable"] as Boolean?)?.let {
        param.isPushEnable = it
    }
    (this["pushPayload"] as Map<String, Any>?)?.let {
        param.pushPayload = it
    }
    (this["subType"] as Number?)?.toInt()?.let {
        param.subType = it
    }
    return param
}

fun QChatSendMessageResult.toMap() = mapOf<String, Any?>(
    "sentMessage" to sentMessage.toMap()
)

@Suppress("UNCHECKED_CAST")
fun Map<String, *>.toQChatSendSystemNotificationParam(): QChatSendSystemNotificationParam {
    val serverId = (this["serverId"] as Number).toLong()
    val channelId = (this["channelId"] as Number?)?.toLong()
    val toAccids = this["toAccids"] as List<String>?
    var param = QChatSendSystemNotificationParam(serverId)
    if (channelId != null && (toAccids == null || toAccids.isEmpty())) {
        param = QChatSendSystemNotificationParam(serverId, channelId)
    } else if (channelId == null && toAccids != null && toAccids.isNotEmpty()) {
        param = QChatSendSystemNotificationParam(serverId, toAccids)
    } else if (channelId != null && toAccids != null && toAccids.isNotEmpty()) {
        param = QChatSendSystemNotificationParam(serverId, channelId, toAccids)
    }
    (this["status"] as Number?)?.toInt()?.let {
        param.status = it
    }
    (this["persistEnable"] as Boolean?)?.let {
        param.isPersistEnable = it
    }
    (this["extension"] as Map<String, Any>?)?.let {
        param.extension = it
    }
    (this["attach"] as String?)?.let {
        param.attach = it
    }
    (this["body"] as String?)?.let {
        param.body = it
    }
    (this["env"] as String?)?.let {
        param.env = it
    }
    (this["isRouteEnable"] as Boolean?)?.let {
        param.isRouteEnable = it
    }
    (this["needBadge"] as Boolean?)?.let {
        param.isNeedBadge = it
    }
    (this["needPushNick"] as Boolean?)?.let {
        param.isNeedPushNick = it
    }
    (this["pushContent"] as String?)?.let {
        param.pushContent = it
    }
    (this["pushEnable"] as Boolean?)?.let {
        param.isPushEnable = it
    }
    (this["pushPayload"] as Map<String, Any>?)?.let {
        param.pushPayload = it
    }
    return param
}

fun QChatSendSystemNotificationResult.toMap() = mapOf<String, Any?>(
    "sentCustomNotification" to sentCustomNotification.toMap()
)

fun QChatSystemNotification.toMap() = mapOf<String, Any?>(
    "serverId" to serverId,
    "channelId" to channelId,
    "toAccids" to toAccids,
    "fromAccount" to fromAccount,
    "toType" to stringFromQChatSystemMessageToType(toType),
    "fromClientType" to fromClientType,
    "fromDeviceId" to fromDeviceId,
    "fromNick" to fromNick,
    "time" to time,
    "updateTime" to updateTime,
    "type" to stringFromQChatSystemNotificationType(type),
    "msgIdClient" to msgIdClient,
    "msgIdServer" to msgIdServer,
    "body" to body,
    "attach" to attach,
    "attachment" to attachment?.toMap(),
    "extension" to extension,
    "status" to status,
    "pushPayload" to pushPayload,
    "pushContent" to pushContent,
    "persistEnable" to isPersistEnable,
    "pushEnable" to isPushEnable,
    "needBadge" to isNeedBadge,
    "needPushNick" to isNeedPushNick,
    "routeEnable" to isRouteEnable,
    "env" to env,
    "callbackExtension" to callbackExtension
)

fun QChatSystemNotificationAttachment.toMap(): Map<String, Any?>? {
    return (this as QChatSystemNotificationAttachmentImpl?)?.toMap()
}

fun QChatSystemNotificationAttachmentImpl.toMap() = mapOf<String, Any?>(
    "server" to server?.toMap(),
    "channel" to channel?.toMap(),
    "serverMember" to serverMember?.toMap(),
    "kickedAccids" to kickedAccids,
    "invitedAccids" to invitedAccids,
    "inviteAccid" to inviteAccid,
    "applyAccid" to applyAccid,
    "serverId" to serverId,
    "channelId" to channelId,
    "channelBlackWhiteType" to stringFromQChatChannelBlackWhiteType(channelBlackWhiteType),
    "channelBlackWhiteOperateType" to stringFromQChatChannelBlackWhiteOperateType(
        channelBlackWhiteOperateType
    ),
    "channelBlackWhiteToAccids" to channelBlackWhiteToAccids,
    "channelBlackWhiteRoleId" to channelBlackWhiteRoleId,
    "quickComment" to quickComment?.toMap(),
    "toAccids" to toAccids,
    "roleId" to roleId,
    "channelCategory" to channelCategory?.toMap(),
    "channelCategoryId" to channelCategoryId,
    "addAccids" to addAccids,
    "deleteAccids" to deleteAccids,
    "updateAuths" to updateAuths?.filter {
        !TextUtils.isEmpty(stringFromQChatRoleResource(it.key)) &&
            !TextUtils.isEmpty(stringFromQChatRoleResource(it.key))
    }?.mapKeys {
        stringFromQChatRoleResource(it.key)
    }?.mapValues {
        stringFromQChatRoleOption(it.value)
    },
    "parentRoleId" to parentRoleId,
    "accid" to accid,
    "inOutType" to stringFromQChatInOutType(inOutType),
    "requestId" to requestId,
    "inviteCode" to inviteCode,
    "updatedInfos" to updatedInfos?.map { it.toMap() }?.toList()
)

fun QChatUpdatedMyMemberInfo.toMap() = mapOf<String, Any?>(
    "serverId" to serverId,
    "nick" to nick,
    "isNickChanged" to isNickChanged,
    "avatar" to avatar,
    "isAvatarChanged" to isAvatarChanged
)

fun QChatChannelCategory.toMap() = mapOf<String, Any?>(
    "categoryId" to categoryId,
    "serverId" to serverId,
    "name" to name,
    "custom" to custom,
    "owner" to owner,
    "viewMode" to stringFromQChatChannelMode(viewMode),
    "valid" to isValid,
    "createTime" to createTime,
    "updateTime" to updateTime,
    "channelNumber" to channelNumber
)

fun QChatQuickComment.toMap() = mapOf<String, Any?>(
    "serverId" to serverId,
    "channelId" to channelId,
    "msgSenderAccid" to msgSenderAccid,
    "msgIdServer" to msgIdServer,
    "msgTime" to msgTime,
    "type" to type,
    "operateType" to stringFromQChatQuickCommentOperateType(operateType)
)

@Suppress("UNCHECKED_CAST")
fun Map<String, *>.toQChatUpdateMessageParam(): QChatUpdateMessageParam {
    val updateParam = (this["updateParam"] as Map<String, *>).toQChatUpdateParam()
    val serverId = (this["serverId"] as Number).toLong()
    val channelId = (this["channelId"] as Number).toLong()
    val time = (this["time"] as Number).toLong()
    val msgIdServer = (this["msgIdServer"] as Number).toLong()
    return QChatUpdateMessageParam(updateParam, serverId, channelId, time, msgIdServer).also {
        it.body = this["body"] as? String
        it.extension = this["extension"] as? Map<String, Any?>
        it.serverStatus = (this["serverStatus"] as? Number)?.toInt()
        it.antiSpamOption =
            (this["antiSpamOption"] as? Map<String, Any?>)?.toQChatMessageAntiSpamOption()
        it.subType = (this["subType"] as? Number)?.toInt()
    }
}

fun QChatUpdateMessageResult.toMap() = mapOf<String, Any?>(
    "message" to message.toMap()
)

@Suppress("UNCHECKED_CAST")
fun Map<String, *>.toQChatUpdateSystemNotificationParam(): QChatUpdateSystemNotificationParam {
    val updateParam = (this["updateParam"] as Map<String, *>).toQChatUpdateParam()
    val msgIdServer = (this["msgIdServer"] as Number).toLong()
    val type = stringToQChatSystemNotificationType(this["type"] as String)
    val param = QChatUpdateSystemNotificationParam(updateParam, msgIdServer, type)
    (this["body"] as String?)?.let {
        param.body = it
    }
    (this["extension"] as Map<String, Any?>?)?.let {
        param.extension = it
    }
    (this["status"] as Number?)?.toInt()?.let {
        param.status = it
    }
    return param
}

fun QChatUpdateSystemNotificationResult.toMap() = mapOf<String, Any?>(
    "sentCustomNotification" to sentCustomNotification.toMap()
)

@Suppress("UNCHECKED_CAST")
fun Map<String, *>.toQChatDownloadAttachmentParam(): QChatDownloadAttachmentParam {
    val message = (this["message"] as Map<String, *>).toQChatMessage()
    val thumb = this["thumb"] as Boolean?
    return QChatDownloadAttachmentParam(message, thumb ?: false)
}

@Suppress("UNCHECKED_CAST")
fun Map<String, *>.toQChatMessage(): QChatMessage {
    val message = QChatMessageImpl()
    message.direct = stringToMsgDirectionEnum(this["direct"] as String?)
    message.localExtension = this["localExtension"] as MutableMap<String, Any>?
    message.isChecked = this["checked"] as Boolean?
    message.status = stringToMsgStatusEnum(this["status"] as String?)
    message.qChatServerId = (this["qChatServerId"] as Number?)?.toLong() ?: 0
    message.qChatChannelId = (this["qChatChannelId"] as Number?)?.toLong() ?: 0
    message.fromAccount = this["fromAccount"] as String?
    message.fromClientType = (this["fromClientType"] as Number?)?.toInt() ?: 0
    message.fromNick = this["fromNick"] as String?
    message.time = (this["time"] as Number?)?.toLong() ?: 0
    message.updateTime = (this["updateTime"] as Number?)?.toLong() ?: 0
    message.setType(stringToMsgTypeEnum(this["msgType"] as String?).value)
    message.content = this["content"] as String?
    message.remoteExtension = this["remoteExtension"] as Map<String, Any?>?
    message.uuid = this["uuid"] as String?
    message.msgIdServer = (this["msgIdServer"] as Number?)?.toLong() ?: 0
    message.isResend = (this["resend"] as Boolean?) ?: false
    message.serverStatus = (this["serverStatus"] as Number?)?.toInt() ?: 0
    message.pushPayload = this["pushPayload"] as Map<String, Any?>?
    message.pushContent = this["pushContent"] as String?
    message.mentionedAccidList = this["mentionedAccidList"] as List<String>?
    message.isMentionedAll = (this["mentionedAll"] as Boolean?) ?: false
    message.isHistoryEnable = (this["historyEnable"] as Boolean?) ?: true
    message.attachment = this["attachment"]?.let { it1 ->
        val type =
            stringToMsgTypeEnum((it1 as Map<String, Any?>?)?.get("messageType") as String?)
        AttachmentHelper.attachmentFromMap(type, it1 as Map<String, *>)
    }
    message.attachStatus = stringToAttachStatusEnum(this["attachStatus"] as String?)
    message.isPushEnable = (this["pushEnable"] as Boolean?) ?: true
    message.isNeedBadge = (this["needBadge"] as Boolean?) ?: true
    message.isNeedPushNick = (this["needPushNick"] as Boolean?) ?: true
    message.isRouteEnable = (this["routeEnable"] as Boolean?) ?: true
    message.env = this["env"] as String?
    message.callbackExtension = this["callbackExtension"] as String?
    message.replyRefer = (this["replyRefer"] as Map<String, *>?)?.toQChatMessageRefer()
    message.threadRefer = (this["threadRefer"] as Map<String, *>?)?.toQChatMessageRefer()
    message.antiSpamOption =
        (this["antiSpamOption"] as Map<String, *>?)?.toQChatMessageAntiSpamOption()
    message.antiSpamResult =
        (this["antiSpamResult"] as Map<String, *>?)?.toQChatMessageAntiSpamResult()

    message.updateContent = (this["updateContent"] as Map<String, *>?)?.toQChatMsgUpdateContent()
    message.updateOperatorInfo =
        (this["updateOperatorInfo"] as Map<String, *>?)?.toQChatMsgUpdateInfo()
    message.mentionedRoleIdList =
        (this["mentionedRoleIdList"] as List<*>?)?.map { n -> (n as Number).toLong() }
    message.subType = (this["subType"] as Number?)?.toInt()
    return message
}

fun Map<String, *>.toQChatMsgUpdateInfo(): QChatMsgUpdateInfo {
    val info = QChatMsgUpdateInfoImpl()
    info.routeEnable = this["routeEnable"] as Boolean?
    info.pushPayload = this["pushPayload"] as String?
    info.env = this["env"] as String?
    info.pushContent = this["pushContent"] as String?
    info.ext = this["ext"] as String?
    info.msg = this["msg"] as String?
    info.operatorAccount = this["operatorAccount"] as String?
    info.operatorClientType = (this["operatorClientType"] as Number?)?.toInt() ?: 0
    return info
}

fun QChatStatusChangeEvent.toMap() = mapOf<String, Any?>(
    "status" to dartNameOfStatusCode(status)
)

@Suppress("UNCHECKED_CAST")
fun Map<String, *>.toQChatResendMessageParam(): QChatResendMessageParam {
    val message = (this["message"] as Map<String, *>).toQChatMessage()
    return QChatResendMessageParam(message)
}

@Suppress("UNCHECKED_CAST")
fun Map<String, *>.toQChatResendSystemNotificationParam(): QChatResendSystemNotificationParam {
    val systemNotification =
        (this["systemNotification"] as Map<String, *>).toQChatSystemNotification()
    return QChatResendSystemNotificationParam(systemNotification)
}

@Suppress("UNCHECKED_CAST")
fun Map<String, *>.toQChatSystemNotification(): QChatSystemNotification {
    val notification = QChatSystemNotificationImpl()
    (this["serverId"] as Number?)?.toLong()?.let {
        notification.serverId = it
    }
    (this["channelId"] as Number?)?.toLong()?.let {
        notification.channelId = it
    }
    notification.toAccids = this["toAccids"] as List<String>?
    notification.fromAccount = this["fromAccount"] as String?
    (this["fromClientType"] as Number?)?.toInt()?.let {
        notification.fromClientType = it
    }
    notification.fromDeviceId = this["fromDeviceId"] as String?
    notification.fromNick = this["fromNick"] as String?
    (this["time"] as Number?)?.toLong()?.let {
        notification.time = it
    }
    (this["updateTime"] as Number?)?.toLong()?.let {
        notification.updateTime = it
    }
    notification.type = stringToQChatSystemNotificationType(this["type"] as String?)
    notification.msgIdClient = this["msgIdClient"] as String?
    (this["msgIdServer"] as Number?)?.toLong()?.let {
        notification.msgIdServer = it
    }
    notification.body = this["body"] as String?
    notification.attach = this["attach"] as String?
    notification.extension = this["extension"] as String?
    (this["status"] as Number?)?.toInt()?.let {
        notification.status = it
    }
    notification.pushPayload = this["pushPayload"] as String?
    notification.pushContent = this["pushContent"] as String?
    notification.isPersistEnable = (this["persistEnable"] as Boolean?) ?: false
    notification.isPushEnable = (this["pushEnable"] as Boolean?) ?: false
    notification.isNeedBadge = (this["needBadge"] as Boolean?) ?: true
    notification.isNeedPushNick = (this["needPushNick"] as Boolean?) ?: true
    notification.isRouteEnable = (this["routeEnable"] as Boolean?) ?: true
    notification.env = this["env"] as String?
    notification.callbackExtension = this["callbackExtension"] as String?
//    notification.attachment = (this["attachment"] as Map<String,*>?)?.toQChatSystemNotificationAttachmentImpl()
    QChatSystemNotificationAttachmentImpl.parseQChatSystemNotificationAttachment(notification)
    return notification
}

@Suppress("UNCHECKED_CAST")
fun Map<String, *>.toQChatCreateServerRoleParam(): QChatCreateServerRoleParam {
    val serverId = (this["serverId"] as Number).toLong()
    val name = this["name"] as String
    val type = stringToQChatRoleType(this["type"] as String)
    val qChatCreateServerRoleParam = QChatCreateServerRoleParam(serverId, name, type)
    qChatCreateServerRoleParam.icon = this["icon"] as String?
    qChatCreateServerRoleParam.extension = this["extension"] as String?
    (this["priority"] as Number?)?.toLong()?.let {
        qChatCreateServerRoleParam.priority = it
    }
    return qChatCreateServerRoleParam
}

fun QChatCreateServerRoleResult.toMap() = mapOf<String, Any?>(
    "role" to role?.toMap()
)

fun QChatServerRole.toMap() = mapOf<String, Any?>(
    "roleId" to roleId,
    "serverId" to serverId,
    "name" to name,
    "icon" to icon,
    "extension" to extension,
    "resourceAuths" to resourceAuths?.filter {
        !TextUtils.isEmpty(stringFromQChatRoleResource(it.key)) &&
            !TextUtils.isEmpty(stringFromQChatRoleResource(it.key))
    }?.mapKeys {
        stringFromQChatRoleResource(it.key)
    }?.mapValues {
        stringFromQChatRoleOption(it.value)
    },
    "type" to stringFromQChatRoleType(type),
    "memberCount" to memberCount,
    "priority" to priority,
    "createTime" to createTime,
    "updateTime" to updateTime
)

@Suppress("UNCHECKED_CAST")
fun Map<String, *>.toQChatDeleteServerRoleParam(): QChatDeleteServerRoleParam {
    val serverId = (this["serverId"] as Number).toLong()
    val roleId = (this["roleId"] as Number).toLong()
    return QChatDeleteServerRoleParam(serverId, roleId)
}

@Suppress("UNCHECKED_CAST")
fun Map<String, *>.toQChatUpdateServerRoleParam(): QChatUpdateServerRoleParam {
    val serverId = (this["serverId"] as Number).toLong()
    val roleId = (this["roleId"] as Number).toLong()
    val param = QChatUpdateServerRoleParam(serverId, roleId)
    param.name = this["name"] as String?
    param.icon = this["icon"] as String?
    param.ext = this["ext"] as String?
    param.resourceAuths =
        (this["resourceAuths"] as Map<String, String>?)?.let {
            it.mapKeys { k ->
                stringToQChatRoleResource(k.key)
            }.mapValues { v ->
                stringToQChatRoleOption(v.value)
            }
        }
    param.priority = (this["priority"] as? Number)?.toLong()
    return param
}

fun QChatUpdateServerRoleResult.toMap() = mapOf<String, Any?>(
    "role" to role?.toMap()
)

@Suppress("UNCHECKED_CAST")
fun Map<String, *>.toQChatUpdateServerRolePrioritiesParam(): QChatUpdateServerRolePrioritiesParam {
    val serverId = (this["serverId"] as Number).toLong()
    val roleIdPriorityMap = (this["roleIdPriorityMap"] as Map<String, Number>).let {
        it.mapKeys { k ->
            k.key.toLong()
        }.mapValues { v ->
            v.value.toLong()
        }
    }
    return QChatUpdateServerRolePrioritiesParam(serverId, roleIdPriorityMap)
}

fun QChatUpdateServerRolePrioritiesResult.toMap() = mapOf<String, Any?>(
    "roleIdPriorityMap" to roleIdPriorityMap
)

@Suppress("UNCHECKED_CAST")
fun Map<String, *>.toQChatGetServerRolesParam(): QChatGetServerRolesParam {
    val serverId = (this["serverId"] as Number).toLong()
    val priority = (this["priority"] as Number).toLong()
    val limit = (this["limit"] as Number).toInt()
    return QChatGetServerRolesParam(serverId, priority, limit).also {
        it.channelId = (this["channelId"] as? Number)?.toLong()
        it.categoryId = (this["categoryId"] as? Number)?.toLong()
    }
}

fun QChatGetServerRolesResult.toMap() = mapOf<String, Any?>(
    "roleList" to roleList?.map { it.toMap() }?.toList(),
    "isMemberSet" to isMemberSet?.toList()
)

@Suppress("UNCHECKED_CAST")
fun Map<String, *>.toQChatAddChannelRoleParam(): QChatAddChannelRoleParam {
    val serverId = (this["serverId"] as Number).toLong()
    val channelId = (this["channelId"] as Number).toLong()
    val serverRoleId = (this["serverRoleId"] as Number).toLong()
    return QChatAddChannelRoleParam(serverId, channelId, serverRoleId)
}

fun QChatAddChannelRoleResult.toMap() = mapOf<String, Any?>(
    "role" to role?.toMap()
)

fun QChatChannelRole.toMap() = mapOf<String, Any?>(
    "serverId" to serverId,
    "roleId" to roleId,
    "parentRoleId" to parentRoleId,
    "channelId" to channelId,
    "name" to name,
    "icon" to icon,
    "ext" to ext,
    "resourceAuths" to resourceAuths?.filter {
        !TextUtils.isEmpty(stringFromQChatRoleResource(it.key)) &&
            !TextUtils.isEmpty(stringFromQChatRoleResource(it.key))
    }?.mapKeys {
        stringFromQChatRoleResource(it.key)
    }?.mapValues {
        stringFromQChatRoleOption(it.value)
    },
    "type" to stringFromQChatRoleType(type),
    "createTime" to createTime,
    "updateTime" to updateTime
)

@Suppress("UNCHECKED_CAST")
fun Map<String, *>.toQChatRemoveChannelRoleParam(): QChatRemoveChannelRoleParam {
    val serverId = (this["serverId"] as Number).toLong()
    val channelId = (this["channelId"] as Number).toLong()
    val roleId = (this["roleId"] as Number).toLong()
    return QChatRemoveChannelRoleParam(serverId, channelId, roleId)
}

@Suppress("UNCHECKED_CAST")
fun Map<String, *>.toQChatUpdateChannelRoleParam(): QChatUpdateChannelRoleParam {
    val serverId = (this["serverId"] as Number).toLong()
    val channelId = (this["channelId"] as Number).toLong()
    val roleId = (this["roleId"] as Number).toLong()
    val resourceAuths = (this["resourceAuths"] as Map<String, String>).let {
        it.mapKeys { k ->
            stringToQChatRoleResource(k.key)
        }.mapValues { v ->
            stringToQChatRoleOption(v.value)
        }
    }
    return QChatUpdateChannelRoleParam(serverId, channelId, roleId, resourceAuths)
}

fun QChatUpdateChannelRoleResult.toMap() = mapOf<String, Any?>(
    "role" to role?.toMap()
)

@Suppress("UNCHECKED_CAST")
fun Map<String, *>.toQChatGetChannelRolesParam(): QChatGetChannelRolesParam {
    val serverId = (this["serverId"] as Number).toLong()
    val channelId = (this["channelId"] as Number).toLong()
    val timeTag = (this["timeTag"] as Number).toLong()
    val limit = (this["limit"] as Number).toInt()
    return QChatGetChannelRolesParam(serverId, channelId, timeTag, limit)
}

fun QChatGetChannelRolesResult.toMap() = mapOf<String, Any?>(
    "roleList" to roleList?.map { it.toMap() }?.toList()
)

@Suppress("UNCHECKED_CAST")
fun Map<String, *>.toQChatAddMembersToServerRoleParam(): QChatAddMembersToServerRoleParam {
    val serverId = (this["serverId"] as Number).toLong()
    val roleId = (this["roleId"] as Number).toLong()
    val accids = this["accids"] as List<String>
    return QChatAddMembersToServerRoleParam(serverId, roleId, accids)
}

fun QChatAddMembersToServerRoleResult.toMap() = mapOf<String, Any?>(
    "successAccids" to successAccids,
    "failedAccids" to failedAccids
)

@Suppress("UNCHECKED_CAST")
fun Map<String, *>.toQChatRemoveMembersFromServerRoleParam(): QChatRemoveMembersFromServerRoleParam {
    val serverId = (this["serverId"] as Number).toLong()
    val roleId = (this["roleId"] as Number).toLong()
    val accids = this["accids"] as List<String>
    return QChatRemoveMembersFromServerRoleParam(serverId, roleId, accids)
}

fun QChatRemoveMembersFromServerRoleResult.toMap() = mapOf<String, Any?>(
    "successAccids" to successAccids,
    "failedAccids" to failedAccids
)

@Suppress("UNCHECKED_CAST")
fun Map<String, *>.toQChatGetMembersFromServerRoleParam(): QChatGetMembersFromServerRoleParam {
    val serverId = (this["serverId"] as Number).toLong()
    val roleId = (this["roleId"] as Number).toLong()
    val timeTag = (this["timeTag"] as Number).toLong()
    val limit = (this["limit"] as Number).toInt()
    val param = QChatGetMembersFromServerRoleParam(serverId, roleId, timeTag, limit)
    param.accid = this["accid"] as String?
    return param
}

fun QChatGetMembersFromServerRoleResult.toMap() = mapOf<String, Any?>(
    "roleMemberList" to roleMemberList?.map { it.toMap() }?.toList()
)

fun QChatServerRoleMember.toMap() = mapOf<String, Any?>(
    "serverId" to serverId,
    "roleId" to roleId,
    "accid" to accid,
    "createTime" to createTime,
    "updateTime" to updateTime,
    "nick" to nick,
    "avatar" to avatar,
    "custom" to custom,
    "type" to type?.toStr(),
    "jointime" to jointime,
    "inviter" to inviter
)

@Suppress("UNCHECKED_CAST")
fun Map<String, *>.toQChatGetServerRolesByAccidParam(): QChatGetServerRolesByAccidParam {
    val serverId = (this["serverId"] as Number).toLong()
    val accid = this["accid"] as String
    val timeTag = (this["timeTag"] as Number).toLong()
    val limit = (this["limit"] as Number).toInt()
    return QChatGetServerRolesByAccidParam(serverId, accid, timeTag, limit)
}

fun QChatGetServerRolesByAccidResult.toMap() = mapOf<String, Any?>(
    "roleList" to roleList?.map { it.toMap() }?.toList()
)

@Suppress("UNCHECKED_CAST")
fun Map<String, *>.toQChatGetExistingServerRolesByAccidsParam(): QChatGetExistingServerRolesByAccidsParam {
    val serverId = (this["serverId"] as Number).toLong()
    val accids = this["accids"] as List<String>
    return QChatGetExistingServerRolesByAccidsParam(serverId, accids)
}

fun QChatGetExistingServerRolesByAccidsResult.toMap() = mapOf<String, Any?>(
    "accidServerRolesMap" to accidServerRolesMap?.mapValues {
        it.value.map { item ->
            item.toMap()
        }
    }
)

@Suppress("UNCHECKED_CAST")
fun Map<String, *>.toQChatGetExistingAccidsInServerRoleParam(): QChatGetExistingAccidsInServerRoleParam {
    val serverId = (this["serverId"] as Number).toLong()
    val roleId = (this["roleId"] as Number).toLong()
    val accids = this["accids"] as List<String>
    return QChatGetExistingAccidsInServerRoleParam(serverId, roleId, accids)
}

fun QChatGetExistingAccidsInServerRoleResult.toMap() = mapOf<String, Any?>(
    "accidList" to accidList
)

@Suppress("UNCHECKED_CAST")
fun Map<String, *>.toQChatGetExistingChannelRolesByServerRoleIdsParam(): QChatGetExistingChannelRolesByServerRoleIdsParam {
    val serverId = (this["serverId"] as Number).toLong()
    val channelId = (this["channelId"] as Number).toLong()
    val roleIds = (this["roleIds"] as List<Number>).map { it.toLong() }.toList()
    return QChatGetExistingChannelRolesByServerRoleIdsParam(serverId, channelId, roleIds)
}

fun QChatGetExistingChannelRolesByServerRoleIdsResult.toMap() = mapOf<String, Any?>(
    "roleList" to roleList?.map { it.toMap() }?.toList()
)

@Suppress("UNCHECKED_CAST")
fun Map<String, *>.toQChatGetExistingAccidsOfMemberRolesParam(): QChatGetExistingAccidsOfMemberRolesParam {
    val serverId = (this["serverId"] as Number).toLong()
    val channelId = (this["channelId"] as Number).toLong()
    val accids = this["accids"] as List<String>
    return QChatGetExistingAccidsOfMemberRolesParam(serverId, channelId, accids)
}

fun QChatGetExistingAccidsOfMemberRolesResult.toMap() = mapOf<String, Any?>(
    "accidList" to accidList
)

@Suppress("UNCHECKED_CAST")
fun Map<String, *>.toQChatUpdateServerMemberInfoParam(): QChatUpdateServerMemberInfoParam {
    val serverId = (this["serverId"] as Number).toLong()
    val accid = this["accid"] as String
    val nick = this["nick"] as String?
    val avatar = this["avatar"] as String?
    val antiSpamConfig = (this["antiSpamConfig"] as Map<String, *>?)?.toQChatAntiSpamConfig()
    return QChatUpdateServerMemberInfoParam(serverId, accid).apply {
        this.nick = nick
        this.avatar = avatar
        this.antiSpamConfig = antiSpamConfig
    }
}

fun QChatUpdateServerMemberInfoResult.toMap() = mapOf<String, Any?>(
    "member" to member?.toMap()
)

fun Map<String, *>.toQChatBanServerMemberParam(): QChatBanServerMemberParam {
    val serverId = (this["serverId"] as Number?)?.toLong() ?: 0L
    val targetAccid = this["targetAccid"] as String?
    val customExt = this["customExt"] as String?
    return QChatBanServerMemberParam(serverId, targetAccid).apply {
        this.customExt = customExt
    }
}

fun Map<String, *>.toQChatUnbanServerMemberParam(): QChatUnbanServerMemberParam {
    val serverId = (this["serverId"] as Number?)?.toLong() ?: 0L
    val targetAccid = this["targetAccid"] as String?
    val customExt = this["customExt"] as String?
    return QChatUnbanServerMemberParam(serverId, targetAccid).apply {
        this.customExt = customExt
    }
}

fun Map<String, *>.toQChatGetBannedServerMembersByPageParam(): QChatGetBannedServerMembersByPageParam {
    val serverId = (this["serverId"] as Number).toLong()
    val timeTag = (this["timeTag"] as Number).toLong()
    val limit = (this["limit"] as Number?)?.toInt()
    return QChatGetBannedServerMembersByPageParam(serverId, timeTag).apply {
        this.limit = limit
    }
}

fun QChatGetBannedServerMembersByPageResult.toMap() = mapOf<String, Any?>(
    "hasMore" to isHasMore,
    "nextTimeTag" to nextTimeTag,
    "serverMemberBanInfoList" to serverMemberBanInfoList?.map { it.toMap() }
)

fun QChatBannedServerMember.toMap() = mapOf<String, Any?>(
    "serverId" to serverId,
    "accid" to accid,
    "custom" to custom,
    "banTime" to banTime,
    "isValid" to isValid,
    "createTime" to createTime,
    "updateTime" to updateTime
)

fun Map<String, *>.toQChatUpdateUserServerPushConfigParam(): QChatUpdateUserServerPushConfigParam {
    val serverId = (this["serverId"] as Number).toLong()
    val pushMsgType = (this["pushMsgType"] as String?)?.toQChatPushMsgType()!!
    return QChatUpdateUserServerPushConfigParam(serverId, pushMsgType)
}

fun String.toQChatPushMsgType(): QChatPushMsgType? {
    return when (this) {
        "all" -> QChatPushMsgType.ALL
        "highMidLevel" -> QChatPushMsgType.HIGH_MID_LEVEL
        "highLevel" -> QChatPushMsgType.HIGH_LEVEL
        "none" -> QChatPushMsgType.NONE
        "inherit" -> QChatPushMsgType.INHERIT
        else -> null
    }
}

@Suppress("UNCHECKED_CAST")
fun Map<String, *>.toQChatGetUserServerPushConfigsParam(): QChatGetUserServerPushConfigsParam {
    val serverIdList = (this["serverIdList"] as List<Any>).map { it.toString().toLong() }
    return QChatGetUserServerPushConfigsParam(serverIdList)
}

fun QChatGetUserPushConfigsResult.toMap() = mapOf<String, Any?>(
    "userPushConfigs" to userPushConfigs?.map {
        it.toMap()
    }
)

fun QChatUserPushConfig.toMap() = mapOf<String, Any?>(
    "serverId" to serverId,
    "channelId" to channelId,
    "channelCategoryId" to (channelCategoryId ?: 0),
    "dimension" to dimension?.toStr(),
    "pushMsgType" to pushMsgType?.toStr()
)

fun QChatDimension.toStr() = when (this) {
    QChatDimension.CHANNEL -> "channel"
    QChatDimension.SERVER -> "server"
    QChatDimension.CHANNEL_CATEGORY -> "channelCategory"
}

fun QChatPushMsgType.toStr() = when (this) {
    QChatPushMsgType.ALL -> "all"
    QChatPushMsgType.HIGH_MID_LEVEL -> "highMidLevel"
    QChatPushMsgType.HIGH_LEVEL -> "highLevel"
    QChatPushMsgType.NONE -> "none"
    QChatPushMsgType.INHERIT -> "inherit"
}

fun Map<String, *>.toQChatSearchServerMemberByPageParam(): QChatSearchServerMemberByPageParam {
    val serverId = (this["serverId"] as Number).toLong()
    val limit = (this["limit"] as Number?)?.toInt()
    val keyword = this["keyword"] as String
    return QChatSearchServerMemberByPageParam(keyword, serverId).apply {
        this.limit = limit
    }
}

fun QChatSearchServerMemberByPageResult.toMap() = mapOf<String, Any?>(
    "members" to members?.map { it.toMap() }
)

fun Map<String, *>.toQChatGetInviteApplyRecordOfServerParam(): QChatGetInviteApplyRecordOfServerParam {
    val serverId = (this["serverId"] as Number).toLong()
    val fromTime = (this["fromTime"] as Number?)?.toLong()
    val toTime = (this["toTime"] as Number?)?.toLong()
    val limit = (this["limit"] as Number?)?.toInt()
    val excludeRecordId = (this["excludeRecordId"] as Number?)?.toLong()
    val reverse = this["reverse"] as Boolean?
    return QChatGetInviteApplyRecordOfServerParam(
        serverId,
        fromTime,
        toTime,
        reverse,
        limit,
        excludeRecordId
    )
}

fun QChatGetInviteApplyRecordOfServerResult.toMap() = mapOf<String, Any?>(
    "records" to records?.map { it.toMap() }
)

fun QChatInviteApplyRecord.toMap() = mapOf<String, Any?>(
    "accid" to accid,
    "type" to type?.toStr(),
    "serverId" to serverId,
    "status" to status?.toStr(),
    "requestId" to requestId,
    "createTime" to createTime,
    "updateTime" to updateTime,
    "expireTime" to expireTime,
    "data" to data?.toMap(),
    "recordId" to recordId
)

fun QChatInviteApplyRecordData.toMap() = when (this) {
    is QChatApplyRecordData -> mapOf<String, Any?>(
        "applyPostscript" to applyPostscript,
        "updateAccid" to updateAccid,
        "updatePostscript" to updatePostscript
    )
    is QChatBeInvitedRecordData -> mapOf<String, Any?>(
        "invitePostscript" to invitePostscript,
        "updatePostscript" to updatePostscript
    )
    is QChatGenerateInviteCodeRecordData -> mapOf<String, Any?>(
        "inviteCode" to inviteCode,
        "invitedUserCount" to invitedUserCount,
        "invitePostscript" to invitePostscript
    )
    is QChatInviteRecordData -> mapOf<String, Any?>(
        "invitedUsers" to invitedUsers?.map { it.toMap() },
        "invitePostscript" to invitePostscript
    )
    is QChatJoinByInviteCodeRecordData -> mapOf<String, Any?>(
        "invitePostscript" to invitePostscript,
        "inviteCode" to inviteCode,
        "updatePostscript" to updatePostscript
    )
    else -> null
}

fun QChatInvitedUserInfo.toMap() = mapOf<String, Any?>(
    "accid" to accid,
    "status" to status?.toStr(),
    "updatePostscript" to updatePostscript,
    "updateTime" to updateTime
)

fun QChatInviteApplyRecordType.toStr() = when (this) {
    QChatInviteApplyRecordType.APPLY -> "apply"
    QChatInviteApplyRecordType.INVITE -> "invite"
    QChatInviteApplyRecordType.BE_INVITED -> "beInvited"
    QChatInviteApplyRecordType.GENERATE_INVITE_CODE -> "generateInviteCode"
    QChatInviteApplyRecordType.JOIN_BY_INVITE_CODE -> "joinByInviteCode"
}

fun QChatInviteApplyRecordStatus.toStr() = when (this) {
    QChatInviteApplyRecordStatus.INITIAL -> "initial"
    QChatInviteApplyRecordStatus.ACCEPT -> "accept"
    QChatInviteApplyRecordStatus.REJECT -> "reject"
    QChatInviteApplyRecordStatus.ACCEPT_BY_OTHER -> "acceptByOther"
    QChatInviteApplyRecordStatus.REJECT_BY_OTHER -> "rejectByOther"
    QChatInviteApplyRecordStatus.AUTO_JOIN -> "autoJoin"
    QChatInviteApplyRecordStatus.EXPIRED -> "expired"
}

fun Map<String, *>.toQChatGetInviteApplyRecordOfSelfParam(): QChatGetInviteApplyRecordOfSelfParam {
    val fromTime = (this["fromTime"] as Number?)?.toLong()
    val toTime = (this["toTime"] as Number?)?.toLong()
    val limit = (this["limit"] as Number?)?.toInt()
    val excludeRecordId = (this["excludeRecordId"] as Number?)?.toLong()
    val reverse = this["reverse"] as Boolean?
    return QChatGetInviteApplyRecordOfSelfParam(fromTime, toTime, reverse, limit, excludeRecordId)
}

fun QChatGetInviteApplyRecordOfSelfResult.toMap() = mapOf<String, Any?>(
    "records" to records?.map { it.toMap() }
)

@Suppress("UNCHECKED_CAST")
fun Map<String, *>.toQChatServerMarkReadParam(): QChatServerMarkReadParam {
    val serverIds = (this["serverIds"] as List<Any>).map {
        it.toString().toLong()
    }
    return QChatServerMarkReadParam(serverIds)
}

fun QChatServerMarkReadResult.toMap() = mapOf<String, Any>(
    "successServerIds" to successServerIds,
    "failedServerIds" to failedServerIds,
    "timestamp" to timestamp
)

@Suppress("UNCHECKED_CAST")
fun Map<String, *>.toQChatSubscribeAllChannelParam(): QChatSubscribeAllChannelParam {
    val serverIds = (this["serverIds"] as List<Any>).map {
        it.toString().toLong()
    }
    val type = (this["type"] as String).toQChatSubscribeType()!!
    return QChatSubscribeAllChannelParam(type, serverIds)
}

fun QChatSubscribeAllChannelResult.toMap() = mapOf<String, Any?>(
    "failedList" to failedList,
    "unreadInfoList" to unreadInfoList?.map {
        it.toMap()
    }
)

fun Map<String, *>.toQChatAddMemberRoleParam(): QChatAddMemberRoleParam {
    val serverId = (this["serverId"] as Number).toLong()
    val channelId = (this["channelId"] as Number).toLong()
    val accid = this["accid"] as String
    return QChatAddMemberRoleParam(serverId, channelId, accid)
}

fun QChatAddMemberRoleResult.toMap() = mapOf<String, Any?>(
    "role" to role?.toMap()
)

fun QChatMemberRole.toMap() = mapOf<String, Any?>(
    "serverId" to serverId,
    "id" to id,
    "accid" to accid,
    "channelId" to channelId,
    "resourceAuths" to resourceAuths?.filter {
        !TextUtils.isEmpty(stringFromQChatRoleResource(it.key)) &&
            !TextUtils.isEmpty(stringFromQChatRoleResource(it.key))
    }?.mapKeys {
        stringFromQChatRoleResource(it.key)
    }?.mapValues {
        stringFromQChatRoleOption(it.value)
    },
    "createTime" to createTime,
    "updateTime" to updateTime,
    "nick" to nick,
    "avatar" to if (avatar == null) "" else avatar,
    "custom" to if (custom == null) "" else custom,
    "type" to type?.toStr(),
    "joinTime" to jointime,
    "inviter" to inviter
)

fun Map<String, *>.toQChatRemoveMemberRoleParam(): QChatRemoveMemberRoleParam {
    val serverId = (this["serverId"] as Number).toLong()
    val channelId = (this["channelId"] as Number).toLong()
    val accid = this["accid"] as String
    return QChatRemoveMemberRoleParam(serverId, channelId, accid)
}

@Suppress("UNCHECKED_CAST")
fun Map<String, *>.toQChatUpdateMemberRoleParam(): QChatUpdateMemberRoleParam {
    val serverId = (this["serverId"] as Number).toLong()
    val channelId = (this["channelId"] as Number).toLong()
    val accid = this["accid"] as String
    val resourceAuths = (this["resourceAuths"] as Map<String, String>).let {
        it.mapKeys { k ->
            stringToQChatRoleResource(k.key)
        }.mapValues { v ->
            stringToQChatRoleOption(v.value)
        }
    }
    return QChatUpdateMemberRoleParam(serverId, channelId, accid, resourceAuths)
}

fun QChatUpdateMemberRoleResult.toMap() = mapOf<String, Any?>(
    "role" to role?.toMap()
)

fun Map<String, *>.toQChatGetMemberRolesParam(): QChatGetMemberRolesParam {
    val serverId = (this["serverId"] as Number).toLong()
    val channelId = (this["channelId"] as Number).toLong()
    val timeTag = (this["timeTag"] as Number).toLong()
    val limit = (this["limit"] as Number).toInt()
    return QChatGetMemberRolesParam(serverId, channelId, timeTag, limit)
}

fun QChatGetMemberRolesResult.toMap() = mapOf<String, Any?>(
    "roleList" to roleList?.map {
        it.toMap()
    }
)

fun Map<String, *>.toQChatCheckPermissionParam(): QChatCheckPermissionParam {
    val serverId = (this["serverId"] as Number).toLong()
    val channelId = (this["channelId"] as Number?)?.toLong()
    val permission = this["permission"] as String
    val type = stringToQChatRoleResource(permission)
    return if (channelId == null) {
        QChatCheckPermissionParam(serverId, type)
    } else {
        QChatCheckPermissionParam(serverId, channelId, type)
    }
}

fun QChatCheckPermissionResult.toMap() = mapOf<String, Any?>(
    "hasPermission" to isHasPermission
)

@Suppress("UNCHECKED_CAST")
fun Map<String, *>.toQChatCheckPermissionsParam(): QChatCheckPermissionsParam {
    val serverId = (this["serverId"] as Number).toLong()
    val channelId = (this["channelId"] as Number?)?.toLong()
    val permissionTypeList = (this["permissions"] as List<Any>?)?.map {
        stringToQChatRoleResource(it.toString())
    }
    return if (channelId == null) {
        QChatCheckPermissionsParam(serverId, permissionTypeList)
    } else {
        QChatCheckPermissionsParam(serverId, channelId, permissionTypeList)
    }
}

fun QChatCheckPermissionsResult.toMap() = mapOf<String, Any?>(
    "permissions" to permissions?.filter {
        !TextUtils.isEmpty(stringFromQChatRoleResource(it.key)) &&
            !TextUtils.isEmpty(stringFromQChatRoleResource(it.key))
    }?.mapKeys {
        stringFromQChatRoleResource(it.key)
    }?.mapValues {
        stringFromQChatRoleOption(it.value)
    }
)

@Suppress("UNCHECKED_CAST")
fun Map<String, *>.toQChatSubscribeServerAsVisitorParam(): QChatSubscribeServerAsVisitorParam {
    return QChatSubscribeServerAsVisitorParam(
        (this["operateType"] as? String)?.toQChatSubscribeOperateType()!!,
        (this["serverIds"] as List<Any>).map { it.toString().toLong() }
    )
}

fun QChatSubscribeServerAsVisitorResult.toMap() = mapOf<String, Any?>(
    "failedList" to failedList
)

@Suppress("UNCHECKED_CAST")
fun Map<String, *>.toQChatEnterServerAsVisitorParam(): QChatEnterServerAsVisitorParam {
    return QChatEnterServerAsVisitorParam(
        (this["serverIds"] as List<Any>).map { it.toString().toLong() }
    )
}

fun QChatEnterServerAsVisitorResult.toMap() = mapOf<String, Any?>(
    "failedList" to failedList
)

@Suppress("UNCHECKED_CAST")
fun Map<String, *>.toQChatLeaveServerAsVisitorParam(): QChatLeaveServerAsVisitorParam {
    return QChatLeaveServerAsVisitorParam(
        (this["serverIds"] as List<Any>).map { it.toString().toLong() }
    )
}

fun QChatLeaveServerAsVisitorResult.toMap() = mapOf<String, Any?>(
    "failedList" to failedList
)
