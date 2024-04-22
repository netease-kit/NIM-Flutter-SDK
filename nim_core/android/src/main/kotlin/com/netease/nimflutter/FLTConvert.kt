/*
 * Copyright (c) 2022 NetEase, Inc. All rights reserved.
 * Use of this source code is governed by a MIT license that can be
 * found in the LICENSE file.
 */

package com.netease.nimflutter

import android.app.Activity
import com.netease.nimlib.NimNosSceneKeyConstant
import com.netease.nimlib.push.net.lbs.IPVersion
import com.netease.nimlib.push.packet.asymmetric.AsymmetricType
import com.netease.nimlib.push.packet.symmetry.SymmetryType
import com.netease.nimlib.sdk.NimHandshakeType
import com.netease.nimlib.sdk.NotificationFoldStyle
import com.netease.nimlib.sdk.ServerAddresses
import com.netease.nimlib.sdk.StatusBarNotificationConfig
import com.netease.nimlib.sdk.StatusCode
import com.netease.nimlib.sdk.auth.ClientType
import com.netease.nimlib.sdk.avsignalling.constant.ChannelStatus
import com.netease.nimlib.sdk.avsignalling.constant.ChannelType
import com.netease.nimlib.sdk.avsignalling.constant.InviteAckStatus
import com.netease.nimlib.sdk.avsignalling.constant.SignallingEventType
import com.netease.nimlib.sdk.event.model.Event
import com.netease.nimlib.sdk.misc.DirCacheFileType
import com.netease.nimlib.sdk.msg.constant.AttachStatusEnum
import com.netease.nimlib.sdk.msg.constant.ChatRoomQueueChangeType
import com.netease.nimlib.sdk.msg.constant.MsgDirectionEnum
import com.netease.nimlib.sdk.msg.constant.MsgStatusEnum
import com.netease.nimlib.sdk.msg.constant.MsgTypeEnum
import com.netease.nimlib.sdk.msg.constant.NotificationExtraTypeEnum
import com.netease.nimlib.sdk.msg.constant.RevokeType
import com.netease.nimlib.sdk.msg.constant.SessionTypeEnum
import com.netease.nimlib.sdk.msg.constant.SystemMessageStatus
import com.netease.nimlib.sdk.msg.constant.SystemMessageType
import com.netease.nimlib.sdk.msg.model.CustomMessageConfig
import com.netease.nimlib.sdk.msg.model.CustomNotification
import com.netease.nimlib.sdk.msg.model.CustomNotificationConfig
import com.netease.nimlib.sdk.msg.model.GetMessageDirectionEnum
import com.netease.nimlib.sdk.msg.model.MemberPushOption
import com.netease.nimlib.sdk.msg.model.MessageKey
import com.netease.nimlib.sdk.msg.model.MessageRobotInfo
import com.netease.nimlib.sdk.msg.model.MsgFullKeywordSearchConfig
import com.netease.nimlib.sdk.msg.model.MsgSearchOption
import com.netease.nimlib.sdk.msg.model.MsgThreadOption
import com.netease.nimlib.sdk.msg.model.NIMAntiSpamOption
import com.netease.nimlib.sdk.msg.model.QueryDirectionEnum
import com.netease.nimlib.sdk.msg.model.SearchOrderEnum
import com.netease.nimlib.sdk.robot.model.RobotMsgType
import com.netease.nimlib.sdk.team.constant.TeamAllMuteModeEnum
import com.netease.nimlib.sdk.team.constant.TeamBeInviteModeEnum
import com.netease.nimlib.sdk.team.constant.TeamExtensionUpdateModeEnum
import com.netease.nimlib.sdk.team.constant.TeamFieldEnum
import com.netease.nimlib.sdk.team.constant.TeamInviteModeEnum
import com.netease.nimlib.sdk.team.constant.TeamMemberType
import com.netease.nimlib.sdk.team.constant.TeamMessageNotifyTypeEnum
import com.netease.nimlib.sdk.team.constant.TeamTypeEnum
import com.netease.nimlib.sdk.team.constant.TeamUpdateModeEnum
import com.netease.nimlib.sdk.team.constant.VerifyTypeEnum
import kotlin.properties.ReadOnlyProperty
import kotlin.reflect.KProperty

val msgTypeEnumMap = mapOf(
    MsgTypeEnum.undef to "undef",
    MsgTypeEnum.text to "text",
    MsgTypeEnum.image to "image",
    MsgTypeEnum.audio to "audio",
    MsgTypeEnum.video to "video",
    MsgTypeEnum.location to "location",
    MsgTypeEnum.file to "file",
    MsgTypeEnum.avchat to "avchat",
    MsgTypeEnum.notification to "notification",
    MsgTypeEnum.tip to "tip",
    MsgTypeEnum.robot to "robot",
    MsgTypeEnum.nrtc_netcall to "netcall",
    MsgTypeEnum.custom to "custom",
    MsgTypeEnum.appCustom to "appCustom",
    MsgTypeEnum.qiyuCustom to "qiyuCustom",
    MsgTypeEnum.qchatCustom to "qchatCustom"
)

val msgDirectionEnumMap = mapOf(
    MsgDirectionEnum.Out to "outgoing",
    MsgDirectionEnum.In to "received"
)

val sessionTypeEnumMap = mapOf(
    SessionTypeEnum.None to "none",
    SessionTypeEnum.P2P to "p2p",
    SessionTypeEnum.Team to "team",
    SessionTypeEnum.SUPER_TEAM to "superTeam",
    SessionTypeEnum.System to "system",
    SessionTypeEnum.Ysf to "ysf",
    SessionTypeEnum.ChatRoom to "chatRoom"
)

val msgStatusEnumMap = mapOf(
    MsgStatusEnum.sending to "sending",
    MsgStatusEnum.success to "success",
    MsgStatusEnum.fail to "fail",
    MsgStatusEnum.read to "read",
    MsgStatusEnum.unread to "unread",
    MsgStatusEnum.draft to "draft"
)

val attachStatusEnumMap = mapOf(
    AttachStatusEnum.def to "initial",
    AttachStatusEnum.transferring to "transferring",
    AttachStatusEnum.fail to "failed",
    AttachStatusEnum.transferred to "transferred",
    AttachStatusEnum.cancel to "cancel"
)

val nimNosSceneKeyConstantMap = mapOf(
    NimNosSceneKeyConstant.NIM_DEFAULT_IM to "defaultIm",
    NimNosSceneKeyConstant.NIM_DEFAULT_PROFILE to "defaultProfile",
    NimNosSceneKeyConstant.NIM_SYSTEM_NOS_SCENE to "systemNosScene",
    NimNosSceneKeyConstant.NIM_SECURITY_PREFIX to "securityPrefix"
)

val clientTypeEnumMap = mapOf(
    ClientType.UNKNOW to "unknown",
    ClientType.Android to "android",
    ClientType.iOS to "ios",
    ClientType.Windows to "windows",
    ClientType.WP to "wp",
    ClientType.Web to "web",
    ClientType.REST to "rest",
    ClientType.MAC to "macos"
)

val systemMessageTypeEnumMap = mapOf(
    SystemMessageType.undefined to "undefined",
    SystemMessageType.ApplyJoinTeam to "applyJoinTeam",
    SystemMessageType.RejectTeamApply to "rejectTeamApply",
    SystemMessageType.TeamInvite to "teamInvite",
    SystemMessageType.DeclineTeamInvite to "declineTeamInvite",
    SystemMessageType.AddFriend to "addFriend",
    SystemMessageType.SuperTeamApply to "superTeamApply",
    SystemMessageType.SuperTeamApplyReject to "superTeamApplyReject",
    SystemMessageType.SuperTeamInvite to "superTeamInvite",
    SystemMessageType.SuperTeamInviteReject to "superTeamInviteReject"
)

val systemMessageStatusEnumMap = mapOf(
    SystemMessageStatus.init to "init",
    SystemMessageStatus.passed to "passed",
    SystemMessageStatus.declined to "declined",
    SystemMessageStatus.ignored to "ignored",
    SystemMessageStatus.expired to "expired",
    SystemMessageStatus.extension1 to "extension1",
    SystemMessageStatus.extension2 to "extension2",
    SystemMessageStatus.extension3 to "extension3",
    SystemMessageStatus.extension4 to "extension4",
    SystemMessageStatus.extension5 to "extension5"
)

val revokeMessageTypeEnumMap = mapOf(
    RevokeType.undefined to "undefined",
    RevokeType.P2P_DELETE_MSG to "p2pDeleteMsg",
    RevokeType.TEAM_DELETE_MSG to "teamDeleteMsg",
    RevokeType.SUPER_TEAM_DELETE_MSG to "superTeamDeleteMsg",
    RevokeType.P2P_ONE_WAY_DELETE_MSG to "p2pOneWayDeleteMsg",
    RevokeType.TEAM_ONE_WAY_DELETE_MSG to "teamOneWayDeleteMsg"
)

val teamMessageNotifyTypeEnumMap = mapOf(
    TeamMessageNotifyTypeEnum.All to "all",
    TeamMessageNotifyTypeEnum.Manager to "manager",
    TeamMessageNotifyTypeEnum.Mute to "mute"
)

val teamTypeEnumMap = mapOf(
    TeamTypeEnum.Normal to "normal",
    TeamTypeEnum.Advanced to "advanced"
)

val verifyTypeEnumMap = mapOf(
    VerifyTypeEnum.Free to "free",
    VerifyTypeEnum.Apply to "apply",
    VerifyTypeEnum.Private to "private"
)

val teamInviteModeEnumMap = mapOf(
    TeamInviteModeEnum.Manager to "manager",
    TeamInviteModeEnum.All to "all"
)

val teamBeInviteModeEnumMap = mapOf(
    TeamBeInviteModeEnum.NeedAuth to "needAuth",
    TeamBeInviteModeEnum.NoAuth to "noAuth"
)
val teamUpdateModeEnumMap = mapOf(
    TeamUpdateModeEnum.Manager to "manager",
    TeamUpdateModeEnum.All to "all"
)
val teamExtensionUpdateModeEnumMap = mapOf(
    TeamExtensionUpdateModeEnum.Manager to "manager",
    TeamExtensionUpdateModeEnum.All to "all"
)

val teamAllMuteModeEnumMap = mapOf(
    TeamAllMuteModeEnum.Cancel to "cancel",
    TeamAllMuteModeEnum.MuteNormal to "muteNormal",
    TeamAllMuteModeEnum.MuteALL to "muteAll"
)
val teamMemberTypeMap = mapOf(
    TeamMemberType.Normal to "normal",
    TeamMemberType.Owner to "owner",
    TeamMemberType.Manager to "manager",
    TeamMemberType.Apply to "apply"
)

val teamFieldEnumTypeMap = mapOf(
    TeamFieldEnum.undefined to "undefined",
    TeamFieldEnum.Name to "name",
    TeamFieldEnum.ICON to "icon",
    TeamFieldEnum.Introduce to "introduce",
    TeamFieldEnum.Announcement to "announcement",
    TeamFieldEnum.Extension to "extension",
    TeamFieldEnum.Ext_Server_Only to "serverExtension",
    TeamFieldEnum.VerifyType to "verifyType",
    TeamFieldEnum.InviteMode to "inviteMode",
    TeamFieldEnum.BeInviteMode to "beInviteMode",
    TeamFieldEnum.TeamUpdateMode to "teamUpdateMode",
    TeamFieldEnum.TeamExtensionUpdateMode to "teamExtensionUpdateMode",
    TeamFieldEnum.AllMute to "allMuteMode",
    TeamFieldEnum.MaxMemberCount to "maxMemberCount"
)

val asymmetricTypeMap = mapOf(
    AsymmetricType.RSA to "rsa",
    AsymmetricType.SM2 to "sm2",
    AsymmetricType.RSA_OAEP_1 to "rsaOaep1",
    AsymmetricType.RSA_OAEP_256 to "rsaOaep256"
)

val symmetryTypeMap = mapOf(
    SymmetryType.RC4 to "rc4",
    SymmetryType.AES to "aes",
    SymmetryType.SM4 to "sm4"
)

val versionOfIPMap = mapOf(
    IPVersion.IPV4 to "ipv4",
    IPVersion.IPV6 to "ipv6",
    IPVersion.ANY to "any"
)

val nimHandshakeTypeMap = mapOf(
    NimHandshakeType.V0 to "v0",
    NimHandshakeType.V1 to "v1"
)

fun stringToTeamFieldEnumTypeMap(type: String?): TeamFieldEnum =
    teamFieldEnumTypeMap.filterValues { it == type }.keys.firstOrNull() ?: TeamFieldEnum.undefined

fun stringFromTeamFieldEnumTypeMap(type: TeamFieldEnum?): String =
    teamFieldEnumTypeMap[type] ?: teamFieldEnumTypeMap[TeamFieldEnum.undefined]!!

fun stringToTeamTypeEnumMap(type: String?): TeamTypeEnum =
    teamTypeEnumMap.filterValues { it == type }.keys.firstOrNull() ?: TeamTypeEnum.Normal

fun stringFromTeamTypeEnumMap(type: TeamTypeEnum?) =
    teamTypeEnumMap[type]
        ?: teamTypeEnumMap[TeamTypeEnum.Normal]

fun stringToVerifyTypeEnumMap(type: String?): VerifyTypeEnum =
    verifyTypeEnumMap.filterValues { it == type }.keys.firstOrNull() ?: VerifyTypeEnum.Free

fun stringFromVerifyTypeEnumMap(type: VerifyTypeEnum?) =
    verifyTypeEnumMap[type]
        ?: verifyTypeEnumMap[VerifyTypeEnum.Free]

fun stringToTeamMessageNotifyTypeEnumMap(type: String?): TeamMessageNotifyTypeEnum =
    teamMessageNotifyTypeEnumMap.filterValues { it == type }.keys.firstOrNull()
        ?: TeamMessageNotifyTypeEnum.All

fun stringFromTeamMessageNotifyTypMap(type: TeamMessageNotifyTypeEnum?) =
    teamMessageNotifyTypeEnumMap[type]
        ?: teamMessageNotifyTypeEnumMap[TeamMessageNotifyTypeEnum.All]

fun stringToTeamInviteModeEnumMap(type: String?): TeamInviteModeEnum =
    teamInviteModeEnumMap.filterValues { it == type }.keys.firstOrNull()
        ?: TeamInviteModeEnum.Manager

fun stringFromTeamInviteModeEnumMap(type: TeamInviteModeEnum?) =
    teamInviteModeEnumMap[type]
        ?: teamInviteModeEnumMap[TeamInviteModeEnum.Manager]

fun stringToTeamBeInviteModeEnumMap(type: String?): TeamBeInviteModeEnum =
    teamBeInviteModeEnumMap.filterValues { it == type }.keys.firstOrNull()
        ?: TeamBeInviteModeEnum.NeedAuth

fun stringFromTeamBeInviteModeEnumMap(type: TeamBeInviteModeEnum?) =
    teamBeInviteModeEnumMap[type]
        ?: teamBeInviteModeEnumMap[TeamBeInviteModeEnum.NeedAuth]

fun stringToTeamUpdateModeEnumMap(type: String?): TeamUpdateModeEnum =
    teamUpdateModeEnumMap.filterValues { it == type }.keys.firstOrNull()
        ?: TeamUpdateModeEnum.Manager

fun stringFromTeamUpdateModeEnumMap(type: TeamUpdateModeEnum?) =
    teamUpdateModeEnumMap[type]
        ?: teamUpdateModeEnumMap[TeamUpdateModeEnum.Manager]

fun stringToTeamExtensionUpdateModeEnumMap(type: String?): TeamExtensionUpdateModeEnum =
    teamExtensionUpdateModeEnumMap.filterValues { it == type }.keys.firstOrNull()
        ?: TeamExtensionUpdateModeEnum.Manager

fun stringFromTeamExtensionUpdateModeEnumMap(type: TeamExtensionUpdateModeEnum?) =
    teamExtensionUpdateModeEnumMap[type]
        ?: teamExtensionUpdateModeEnumMap[TeamExtensionUpdateModeEnum.Manager]

fun stringToTeamAllMuteModeEnumMap(type: String?): TeamAllMuteModeEnum =
    teamAllMuteModeEnumMap.filterValues { it == type }.keys.firstOrNull()
        ?: TeamAllMuteModeEnum.Cancel

fun stringFromTeamAllMuteModeEnumMap(type: TeamAllMuteModeEnum?) =
    teamAllMuteModeEnumMap[type]
        ?: teamAllMuteModeEnumMap[TeamAllMuteModeEnum.Cancel]

fun stringToTeamMemberTypeMapMap(type: String?): TeamMemberType =
    teamMemberTypeMap.filterValues { it == type }.keys.firstOrNull() ?: TeamMemberType.Normal

fun stringFromTeamMemberTypeMapMap(type: TeamMemberType?) =
    teamMemberTypeMap[type ?: TeamMemberType.Normal]

fun stringToMsgTypeEnum(type: String?): MsgTypeEnum =
    msgTypeEnumMap.filterValues { it == type }.keys.firstOrNull() ?: MsgTypeEnum.undef

fun stringFromMsgTypeEnum(type: MsgTypeEnum?) =
    msgTypeEnumMap[type] ?: msgTypeEnumMap[MsgTypeEnum.undef]

fun stringToMsgDirectionEnum(direction: String?) =
    msgDirectionEnumMap.filterValues { it == direction }.keys.firstOrNull() ?: MsgDirectionEnum.Out

fun stringFromMsgDirectionEnum(direction: MsgDirectionEnum?) =
    msgDirectionEnumMap[direction] ?: msgDirectionEnumMap[MsgDirectionEnum.Out]

fun stringToSessionTypeEnum(type: String?) =
    sessionTypeEnumMap.filterValues { it == type }.keys.firstOrNull() ?: SessionTypeEnum.P2P

fun stringFromSessionTypeEnum(type: SessionTypeEnum?) =
    sessionTypeEnumMap[type] ?: sessionTypeEnumMap[SessionTypeEnum.P2P]

fun stringToMsgStatusEnum(status: String?) =
    msgStatusEnumMap.filterValues { it == status }.keys.firstOrNull() ?: MsgStatusEnum.sending

fun stringFromMsgStatusEnum(status: MsgStatusEnum?, successToRead: Boolean?): String? {
    return if (successToRead == true && status == MsgStatusEnum.success) {
        msgStatusEnumMap[MsgStatusEnum.read] ?: msgStatusEnumMap[MsgStatusEnum.sending]
    } else {
        msgStatusEnumMap[status] ?: msgStatusEnumMap[MsgStatusEnum.sending]
    }
}

fun stringToAttachStatusEnum(status: String?) =
    attachStatusEnumMap.filterValues { it == status }.keys.firstOrNull() ?: AttachStatusEnum.def

fun stringFromAttachStatusEnum(status: AttachStatusEnum?) =
    attachStatusEnumMap[status] ?: attachStatusEnumMap[AttachStatusEnum.def]

fun stringToNimNosSceneKeyConstant(key: String?) =
    nimNosSceneKeyConstantMap.filterValues { it == key }.keys.firstOrNull()
        ?: NimNosSceneKeyConstant.NIM_DEFAULT_IM

fun stringFromNimNosSceneKeyConstant(key: String?) =
    nimNosSceneKeyConstantMap[key]
        ?: nimNosSceneKeyConstantMap[NimNosSceneKeyConstant.NIM_DEFAULT_IM]

fun stringToClientTypeEnum(type: String?) =
    clientTypeEnumMap.filterValues { it == type }.keys.firstOrNull()
        ?: ClientType.UNKNOW

fun stringFromClientTypeEnum(type: Int?) =
    clientTypeEnumMap[type]
        ?: clientTypeEnumMap[ClientType.UNKNOW]

fun stringFromSystemMessageType(type: SystemMessageType?) =
    systemMessageTypeEnumMap[type]
        ?: systemMessageTypeEnumMap[SystemMessageType.undefined]

fun stringFromSystemMessageStatus(type: SystemMessageStatus?) =
    systemMessageStatusEnumMap[type]
        ?: systemMessageStatusEnumMap[SystemMessageStatus.init]

fun stringFromRevokeMessageType(type: RevokeType) =
    revokeMessageTypeEnumMap[type]
        ?: revokeMessageTypeEnumMap[RevokeType.undefined]

fun convertCustomMessageConfig(map: Map<String, Any?>?): CustomMessageConfig? {
    return map?.let {
        CustomMessageConfig().apply {
            enableHistory = it.getOrElse("enableHistory") { true } as Boolean
            enablePersist = it.getOrElse("enablePersist") { true } as Boolean
            enablePush = it.getOrElse("enablePush") { true } as Boolean
            enablePushNick = it.getOrElse("enablePushNick") { true } as Boolean
            enableRoaming = it.getOrElse("enableRoaming") { true } as Boolean
            enableRoute = it.getOrElse("enableRoute") { true } as Boolean
            enableSelfSync = it.getOrElse("enableSelfSync") { true } as Boolean
            enableUnreadCount = it.getOrElse("enableUnreadCount") { true } as Boolean
        }
    }
}

fun convertMsgThreadOption(map: Map<String, Any?>?): MsgThreadOption? {
    return map?.let {
        MsgThreadOption().apply {
            replyMsgFromAccount = it.getOrElse("replyMessageFromAccount") { "" } as String
            replyMsgToAccount = it.getOrElse("replyMessageToAccount") { "" } as String
            replyMsgTime = (it.getOrElse("replyMessageTime") { 0L } as Number).toLong()
            replyMsgIdServer = (it.getOrElse("replyMessageIdServer") { 0L } as Number).toLong()
            replyMsgIdClient = it.getOrElse("replyMessageIdClient") { "" } as String
            threadMsgFromAccount = it.getOrElse("threadMessageFromAccount") { "" } as String
            threadMsgToAccount = it.getOrElse("threadMessageToAccount") { "" } as String
            threadMsgTime = (it.getOrElse("threadMessageTime") { 0L } as Number).toLong()
            threadMsgIdServer = (it.getOrElse("threadMessageIdServer") { 0L } as Number).toLong()
            threadMsgIdClient = it.getOrElse("threadMessageIdClient") { "" } as String
        }
    }
}

@Suppress("UNCHECKED_CAST")
fun convertMemberPushOption(map: Map<String, Any?>?): MemberPushOption? {
    return map?.let {
        MemberPushOption().apply {
            forcePushList = it.getOrElse("forcePushList") { listOf<String>() } as List<String>
            forcePushContent = it.getOrElse("forcePushContent") { "" } as String
            isForcePush = it.getOrElse("isForcePush") { true } as Boolean
        }
    }
}

fun convertNIMAntiSpamOption(map: Map<String, Any?>?): NIMAntiSpamOption? {
    return map?.let {
        NIMAntiSpamOption().apply {
            enable = it.getOrElse("enable") { true } as Boolean
            content = it["content"] as String?
            antiSpamConfigId = it["antiSpamConfigId"] as String?
        }
    }
}

fun convertNIMMessageRobotInfo(map: Map<String, Any?>?): MessageRobotInfo? {
    return map?.let {
        MessageRobotInfo(
            it["function"] as String?,
            it["topic"] as String?,
            it["customContent"] as String?,
            it["account"] as String?
        )
    }
}

fun convertToQueryDirectionEnum(param: Int): QueryDirectionEnum {
    return if (param == 0) QueryDirectionEnum.QUERY_OLD else QueryDirectionEnum.QUERY_NEW
}

fun convertToMessageKey(param: Map<String, Any?>?): MessageKey? {
    return param?.let {
        val sessionType = stringToSessionTypeEnum(it["sessionType"] as String?)
        val fromAccount = it["fromAccount"] as String?
        val toAccount = it["toAccount"] as String?
        val time = (it.getOrElse("time") { 0L } as Number).toLong()
        val uuid = it["uuid"] as String?
        val serverId = (it.getOrElse("serverId") { 0L } as Number).toLong()
        return MessageKey(sessionType, fromAccount, toAccount, time, serverId, uuid)
    }
}

fun convertToSearchOption(param: Map<String, Any?>?): MsgSearchOption? {
    return param?.let {
        MsgSearchOption().apply {
            startTime = (it.getOrElse("startTime") { 0L } as Number).toLong()
            endTime = (it.getOrElse("endTime") { 0L } as Number).toLong()
            limit = (it.getOrElse("limit") { 100 } as Number).toInt()
            order =
                if ((it.getOrElse("order") { 0 } as Number).toInt() == 0) SearchOrderEnum.DESC else SearchOrderEnum.ASC
            messageTypes =
                (it["msgTypeList"] as List<*>?)?.map { stringToMsgTypeEnum(it as String) }?.toList()
            messageSubTypes =
                (it["messageSubTypes"] as List<*>?)?.map { (it as Number).toInt() }?.toList()
            isAllMessageTypes = it.getOrElse("allMessageTypes") { false } as Boolean
            searchContent = it["searchContent"] as String?
            fromIds = (it["fromIds"] as List<*>?)?.map { it as String }?.toList()
            isEnableContentTransfer = it.getOrElse("enableContentTransfer") { true } as Boolean
        }
    }
}

fun convertToSearchConfig(param: Map<String, Any?>?): MsgFullKeywordSearchConfig {
    val searchConfig = MsgFullKeywordSearchConfig(
        param?.get("keyword") as String,
        (param.getOrElse("fromTime") { 0L } as Number).toLong(),
        (param.getOrElse("toTime") { 0L } as Number).toLong()
    )
    return param.let {
        searchConfig.apply {
            sessionLimit = (it.getOrElse("sessionLimit") { 0 } as Number).toInt()
            msgLimit = (it.getOrElse("msgLimit") { 0 } as Number).toInt()
            isAsc = it.getOrElse("asc") { false } as Boolean
            p2pList = (it["p2pList"] as List<*>?)?.map { it as String }?.toList()
            teamList = (it["teamList"] as List<*>?)?.map { it as String }?.toList()
            senderList = (it["senderList"] as List<*>?)?.map { it as String }?.toList()
            msgTypeList =
                (it["msgTypeList"] as List<*>?)?.map { stringToMsgTypeEnum(it as String) }?.toList()
            msgSubtypeList =
                (it["msgSubtypeList"] as List<*>?)?.map { (it as Number).toInt() }?.toList()
        }
    }
}

fun convertToCustomNotification(param: Map<String, Any?>?): CustomNotification? {
    return param?.let {
        CustomNotification().apply {
            sessionId = it["sessionId"] as String
            sessionType = stringToSessionTypeEnum(it["sessionType"] as String)
            fromAccount = it["fromAccount"] as String?
            time = (it.getOrElse("time") { 0L } as Number).toLong()
            content = it["content"] as String?
            isSendToOnlineUserOnly = it.getOrElse("sendToOnlineUserOnly") { true } as Boolean
            apnsText = it["apnsText"] as String?
            pushPayload = it["pushPayload"] as Map<String, Any?>?
            config = convertToCustomNotificationConfig(it["config"] as Map<String, Any?>?)
            nimAntiSpamOption =
                convertToNIMAntiSpamOption(it["antiSpamOption"] as Map<String, Any?>?)
            env = it["env"] as String?
        }
    }
}

fun convertToCustomNotificationConfig(param: Map<String, Any?>?): CustomNotificationConfig? {
    return param?.let {
        CustomNotificationConfig().apply {
            enablePush = it.getOrElse("enablePush") { true } as Boolean
            enablePushNick = it.getOrElse("enablePushNick") { false } as Boolean
            enableUnreadCount = it.getOrElse("enableUnreadCount") { true } as Boolean
        }
    }
}

fun convertToNIMAntiSpamOption(param: Map<String, Any?>?): NIMAntiSpamOption? {
    return param?.let {
        NIMAntiSpamOption().apply {
            enable = it.getOrElse("enable") { true } as Boolean
            content = it["content"] as String
            antiSpamConfigId = it["antiSpamConfigId"] as String
        }
    }
}

fun convertToNIMServerAddresses(param: Map<String, Any?>?): ServerAddresses? {
    return param?.let {
        ServerAddresses().apply {
            module = it["module"] as String?
            publicKeyVersion = it.getOrElse("publicKeyVersion") { 0 } as Int
            lbs = it["lbs"] as String?
            lbsBackup = (it["lbsBackup"] as List<*>?)?.mapNotNull {
                it as String?
            }
            defaultLink = it["defaultLink"] as String?
            defaultLinkBackup = (it["defaultLinkBackup"] as List<*>?)?.mapNotNull {
                it as String?
            }
            nosUploadLbs = it["nosUploadLbs"] as String?
            nosUploadDefaultLink = it["nosUploadDefaultLink"] as String?
            nosUpload = it["nosUpload"] as String?
            nosSupportHttps = it.getOrElse("nosSupportHttps") { true } as Boolean
            nosDownloadUrlFormat = it["nosDownloadUrlFormat"] as String?
            nosDownload = it["nosDownload"] as String?
            nosAccess = it["nosAccess"] as String?
            ntServerAddress = it["ntServerAddress"] as String?
            bdServerAddress = it["bdServerAddress"] as String?
            test = it.getOrElse("test") { false } as Boolean
            dedicatedClusteFlag = it.getOrElse("dedicatedClusteFlag") { 0 } as Int
            negoKeyNeca = stringToAsymmetricType(it["negoKeyNeca"] as String?)
            negoKeyEncaKeyVersion = it.getOrElse("negoKeyEncaKeyVersion") { 0 } as Int
            negoKeyEncaKeyParta = it["negoKeyEncaKeyParta"] as String?
            negoKeyEncaKeyPartb = it["negoKeyEncaKeyPartb"] as String?
            commEnca = stringToSymmetryType(it["commEnca"] as String?)
            linkIpv6 = it["linkIpv6"] as String?
            ipProtocolVersion = stringToIPVersion(it["ipProtocolVersion"] as String?)
            probeIpv4Url = it["probeIpv4Url"] as String?
            probeIpv6Url = it["probeIpv6Url"] as String?
            handshakeType = stringToNimHandshakeType(it["handshakeType"] as String?)
            nosCdnEnable = it.getOrElse("nosCdnEnable") { true } as Boolean
            nosDownloadSet = (it["nosDownloadSet"] as List<*>?)?.mapNotNull {
                it as String?
            }?.toSet()
        }
    }
}

fun stringToAsymmetricType(type: String?) =
    asymmetricTypeMap.filterValues { it == type }.keys.firstOrNull() ?: AsymmetricType.RSA

fun stringToSymmetryType(type: String?) =
    symmetryTypeMap.filterValues { it == type }.keys.firstOrNull() ?: SymmetryType.RC4

fun stringToIPVersion(version: String?) =
    versionOfIPMap.filterValues { it == version }.keys.firstOrNull() ?: IPVersion.IPV4

fun stringToNimHandshakeType(type: String?) =
    nimHandshakeTypeMap.filterValues { it == type }.keys.firstOrNull() ?: NimHandshakeType.V1

fun stringToSystemMessageType(type: String?) =
    systemMessageTypeEnumMap.filterValues { it == type }.keys.firstOrNull()
        ?: SystemMessageType.undefined

fun stringToSystemMessageStatus(type: String?) =
    systemMessageStatusEnumMap.filterValues { it == type }.keys.firstOrNull()
        ?: SystemMessageStatus.init

fun convertToEvent(param: Map<String, *>): Event {
    val event = Event(
        (param["eventType"] as Number).toInt(),
        (param["eventValue"] as Number).toInt(),
        (param.getOrElse("expiry") { 0L } as Number).toLong()
    )
    event.apply {
        config = param["config"] as String?
        isBroadcastOnlineOnly = param.getOrElse("broadcastOnlineOnly") { false } as Boolean
        isSyncSelfEnable = param.getOrElse("syncSelfEnable") { false } as Boolean
    }
    return event
}

fun convertToTeamFieldEnumMap(param: Map<TeamFieldEnum, *>): Map<String, Any?> {
    val newFields = mutableMapOf<String, Any?>()
    param.forEach { entry ->
        when (entry.key) {
            TeamFieldEnum.Name -> newFields["updatedName"] = entry.value as String?
            TeamFieldEnum.ICON -> newFields["updatedIcon"] = entry.value as String?
            TeamFieldEnum.Introduce -> newFields["updatedIntroduce"] = entry.value as String?
            TeamFieldEnum.Announcement -> newFields["updatedAnnouncement"] = entry.value as String?
            TeamFieldEnum.Extension -> newFields["updatedExtension"] = entry.value as String?
            TeamFieldEnum.Ext_Server_Only -> newFields["updatedServerExtension"] =
                entry.value as String?
            TeamFieldEnum.VerifyType -> newFields["updatedVerifyType"] =
                stringFromVerifyTypeEnumMap(entry.value as? VerifyTypeEnum)
            TeamFieldEnum.InviteMode -> newFields["updatedInviteMode"] =
                stringFromTeamInviteModeEnumMap(entry.value as? TeamInviteModeEnum)
            TeamFieldEnum.BeInviteMode -> newFields["updatedBeInviteMode"] =
                stringFromTeamBeInviteModeEnumMap(entry.value as? TeamBeInviteModeEnum)
            TeamFieldEnum.TeamUpdateMode -> newFields["updatedUpdateMode"] =
                stringFromTeamUpdateModeEnumMap(entry.value as? TeamUpdateModeEnum)
            TeamFieldEnum.TeamExtensionUpdateMode -> newFields["updatedExtensionUpdateMode"] =
                stringFromTeamExtensionUpdateModeEnumMap(entry.value as? TeamExtensionUpdateModeEnum)
            TeamFieldEnum.AllMute -> newFields["updatedAllMuteMode"] =
                stringFromTeamAllMuteModeEnumMap(entry.value as? TeamAllMuteModeEnum)
            TeamFieldEnum.MaxMemberCount -> newFields["updatedMaxMemberCount"] = entry.value as? Int
            else -> null
        }
    }
    return newFields
}

fun convertToStatusBarNotificationConfig(param: Map<String, Any?>?): StatusBarNotificationConfig? {
    return param?.let {
        StatusBarNotificationConfig().apply {
            ring = it["ring"] as Boolean
            notificationSound = it["notificationSound"] as String?
            vibrate = it["vibrate"] as Boolean
            ledARGB = (it.getOrElse("ledARGB") { -1 } as Number).toInt()
            ledOnMs = (it.getOrElse("ledOnMs") { -1 } as Number).toInt()
            ledOffMs = (it.getOrElse("ledOffMs") { -1 } as Number).toInt()
            hideContent = it["hideContent"] as Boolean
            downTimeToggle = it["downTimeToggle"] as Boolean
            downTimeEnableNotification = it["downTimeEnableNotification"] as Boolean
            downTimeBegin = it["downTimeBegin"] as String?
            downTimeEnd = it["downTimeEnd"] as String?

            val notificationClsName = it["notificationEntranceClassName"] as String?
            if (notificationClsName != null) {
                notificationEntrance =
                    Class.forName(notificationClsName).asSubclass(Activity::class.java)
            }

            titleOnlyShowAppName = it["titleOnlyShowAppName"] as Boolean
            notificationColor = (it.getOrElse("notificationColor") { 0 } as Number).toInt()
            showBadge = it["showBadge"] as Boolean
            customTitleWhenTeamNameEmpty = it["customTitleWhenTeamNameEmpty"] as String?

            notificationFoldStyle = EnumTypeMappingRegistry.enumFromValue(
                it["notificationFoldStyle"] as String
            )
            notificationExtraType = EnumTypeMappingRegistry.enumFromValue(
                it["notificationExtraType"] as String
            )
        }
    }
}

object EnumTypeMappingRegistry {

    val enumTypeMappingRegistry = mapOf<Class<*>, Map<*, Any>>(
        NotificationFoldStyle::class.java to mapOf(
            NotificationFoldStyle.ALL to "all",
            NotificationFoldStyle.EXPAND to "expand",
            NotificationFoldStyle.CONTACT to "contact"
        ),
        NotificationExtraTypeEnum::class.java to mapOf(
            NotificationExtraTypeEnum.MESSAGE to "message",
            NotificationExtraTypeEnum.JSON_ARR_STR to "jsonArrStr"
        ),
        RobotMsgType::class.java to mapOf(
            RobotMsgType.TEXT to "text",
            RobotMsgType.LINK to "link",
            RobotMsgType.WELCOME to "welcome"
        ),
        ChatRoomQueueChangeType::class.java to mapOf(
            ChatRoomQueueChangeType.undefined to "undefined",
            ChatRoomQueueChangeType.OFFER to "offer",
            ChatRoomQueueChangeType.POLL to "poll",
            ChatRoomQueueChangeType.DROP to "drop",
            ChatRoomQueueChangeType.PARTCLEAR to "partialClear",
            ChatRoomQueueChangeType.BATCH_UPDATE to "batchUpdate"
        ),
        DirCacheFileType::class.java to mapOf(
            DirCacheFileType.IMAGE to "image",
            DirCacheFileType.VIDEO to "video",
            DirCacheFileType.THUMB to "thumb",
            DirCacheFileType.AUDIO to "audio",
            DirCacheFileType.LOG to "log",
            DirCacheFileType.OTHER to "other"
        )
    )

    inline fun <reified TYPE, V> enumToValue(enumType: TYPE): V? =
        enumTypeMappingRegistry[TYPE::class.java]?.get(enumType) as V?

    inline fun <reified TYPE, V> enumFromValue(value: V?): TYPE =
        (enumTypeMappingRegistry[TYPE::class.java] as Map<TYPE, V>)
            .filterValues { v -> v == value }.keys.first()

    inline fun <reified TYPE, V> enumFromValueOrDefault(value: V?, fallback: TYPE): TYPE {
        val map = enumTypeMappingRegistry[TYPE::class.java] as? Map<TYPE, V>
        return map?.let {
            it.filterValues { v -> v == value }.keys.firstOrNull() ?: fallback
        } ?: fallback
    }
}

class MapProperty<T : Any>(
    private val map: Map<String, *>?,
    private val orElse: T
) : ReadOnlyProperty<Any?, T> {

    private var value: T? = null

    override operator fun getValue(thisRef: Any?, property: KProperty<*>): T {
        if (value == null) {
            value = (map?.getOrElse(property.name) { orElse } ?: orElse) as T
        }
        return value!!
    }
}

val channelTypeEnumTypeMap = mapOf(
    ChannelType.VIDEO to "video",
    ChannelType.AUDIO to "audio",
    ChannelType.CUSTOM to "custom"
)

fun stringFromChannelTypeEnum(type: ChannelType?) =
    channelTypeEnumTypeMap[type] ?: channelTypeEnumTypeMap[ChannelType.CUSTOM]

fun stringToChannelTypeEnum(type: String) =
    channelTypeEnumTypeMap.filterValues { it == type }.keys.firstOrNull() ?: ChannelType.CUSTOM

val channelStatusEnumTypeMap = mapOf(
    ChannelStatus.NORMAL to "normal",
    ChannelStatus.INVALID to "invalid"
)

fun stringFromChannelStatusEnum(status: ChannelStatus?) =
    channelStatusEnumTypeMap[status] ?: channelStatusEnumTypeMap[ChannelStatus.NORMAL]

val signallingEventTypeMap = mapOf(
    SignallingEventType.UN_KNOW to "unKnow",
    SignallingEventType.CLOSE to "close",
    SignallingEventType.JOIN to "join",
    SignallingEventType.INVITE to "invite",
    SignallingEventType.CANCEL_INVITE to "cancelInvite",
    SignallingEventType.REJECT to "reject",
    SignallingEventType.ACCEPT to "accept",
    SignallingEventType.LEAVE to "leave",
    SignallingEventType.CONTROL to "control"
)

fun stringFromSignallingEventType(type: SignallingEventType?) =
    signallingEventTypeMap[type] ?: signallingEventTypeMap[SignallingEventType.UN_KNOW]

val inviteAckStatusMap = mapOf(
    InviteAckStatus.REJECT to "reject",
    InviteAckStatus.ACCEPT to "accept"
)

fun dartNameOfStatusCode(status: StatusCode) = when (status) {
    StatusCode.UNLOGIN -> "unLogin"
    StatusCode.NET_BROKEN -> "netBroken"
    StatusCode.CONNECTING -> "connecting"
    StatusCode.LOGINING -> "logging"
    StatusCode.LOGINED -> "loggedIn"
    StatusCode.KICKOUT -> "kickOut"
    StatusCode.KICK_BY_OTHER_CLIENT -> "kickOutByOtherClient"
    StatusCode.FORBIDDEN -> "forbidden"
    StatusCode.VER_ERROR -> "versionError"
    StatusCode.PWD_ERROR -> "pwdError"
    else -> "unknown"
}

val getMessageDirectionEnumMap = mapOf(
    GetMessageDirectionEnum.FORWARD to "forward",
    GetMessageDirectionEnum.BACKWARD to "backward"
)

fun stringFromGetMessageDirectionEnum(direction: GetMessageDirectionEnum?) =
    getMessageDirectionEnumMap[direction] ?: getMessageDirectionEnumMap[GetMessageDirectionEnum.FORWARD]

fun stringToGetMessageDirectionEnum(direction: String) =
    getMessageDirectionEnumMap.filterValues { it == direction }.keys.firstOrNull()
        ?: GetMessageDirectionEnum.FORWARD
