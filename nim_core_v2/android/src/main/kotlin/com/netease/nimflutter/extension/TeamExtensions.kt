/*
 * Copyright (c) 2022 NetEase, Inc. All rights reserved.
 * Use of this source code is governed by a MIT license that can be
 * found in the LICENSE file.
 */

package com.netease.nimflutter.extension

import com.netease.nimlib.sdk.v2.team.enums.V2NIMTeamAgreeMode
import com.netease.nimlib.sdk.v2.team.enums.V2NIMTeamChatBannedMode
import com.netease.nimlib.sdk.v2.team.enums.V2NIMTeamInviteMode
import com.netease.nimlib.sdk.v2.team.enums.V2NIMTeamJoinActionStatus
import com.netease.nimlib.sdk.v2.team.enums.V2NIMTeamJoinActionType
import com.netease.nimlib.sdk.v2.team.enums.V2NIMTeamJoinMode
import com.netease.nimlib.sdk.v2.team.enums.V2NIMTeamType
import com.netease.nimlib.sdk.v2.team.enums.V2NIMTeamUpdateExtensionMode
import com.netease.nimlib.sdk.v2.team.enums.V2NIMTeamUpdateInfoMode
import com.netease.nimlib.sdk.v2.team.model.V2NIMTeam
import com.netease.nimlib.sdk.v2.team.model.V2NIMTeamJoinActionInfo
import com.netease.nimlib.sdk.v2.team.model.V2NIMTeamMember
import com.netease.nimlib.sdk.v2.team.model.V2NIMTeamRefer
import com.netease.nimlib.sdk.v2.team.params.V2NIMCreateTeamParams
import com.netease.nimlib.sdk.v2.team.params.V2NIMSearchTeamMemberParams
import com.netease.nimlib.sdk.v2.team.params.V2NIMTeamInviteParams
import com.netease.nimlib.sdk.v2.team.params.V2NIMTeamSearchParams
import com.netease.nimlib.sdk.v2.team.result.V2NIMCreateTeamResult
import com.netease.nimlib.sdk.v2.team.result.V2NIMTeamJoinActionInfoResult
import com.netease.nimlib.sdk.v2.team.result.V2NIMTeamMemberListResult
import com.netease.nimlib.sdk.v2.team.result.V2NIMTeamMemberSearchResult
import com.netease.nimlib.sdk.v2.team.result.V2NIMTeamMemberSearchResultEx
import com.netease.nimlib.v2.builder.V2NIMTeamJoinActionInfoBuilder

fun getV2NIMTeamJoinActionInfoFromMap(map: Map<String, Any?>): V2NIMTeamJoinActionInfo {
    val jsonInfo = V2NIMTeamJoinActionInfoBuilder.builder()
    (map["teamId"] as String?)?.let {
        jsonInfo.setTeamId(it)
    }
    (map["teamType"] as Int?)?.let {
        jsonInfo.setTeamType(V2NIMTeamType.typeOfValue(it))
    }
    map["operatorAccountId"]?.let {
        jsonInfo.setOperatorAccountId(it as String)
    }
    val postscript = map["postscript"] as String?
    postscript?.let { jsonInfo.setPostscript(it) }
    (map["actionStatus"] as Int?)?.let {
        jsonInfo.setActionStatus(V2NIMTeamJoinActionStatus.typeOfValue(it))
    }
    (map["actionType"] as Int?)?.let {
        jsonInfo.setActionType(V2NIMTeamJoinActionType.typeOfValue(it))
    }
    (map["timestamp"] as Long?)?.let { jsonInfo.setTimestamp(it) }

    (map["serverExtension"] as String?)?.let {
        jsonInfo.setServerExtension(it)
    }

    return jsonInfo.build()
}

fun V2NIMTeamJoinActionInfo.toMap(): Map<String, Any?> {
    return mapOf(
        "teamId" to teamId,
        "actionType" to actionType.value,
        "teamType" to teamType.value,
        "operatorAccountId" to operatorAccountId,
        "postscript" to postscript,
        "timestamp" to timestamp,
        "actionStatus" to actionStatus.value,
        "serverExtension" to serverExtension,
        "read" to isRead
    )
}

fun getV2NIMTeamInviteParamsFromMap(map: Map<String, Any?>): V2NIMTeamInviteParams {
    val params = V2NIMTeamInviteParams()
    (map["inviteeAccountIds"] as List<String>?)?.let {
        params.inviteeAccountIds = it
    }
    (map["postscript"] as String?)?.let {
        params.postscript = it
    }
    (map["serverExtension"] as String?)?.let {
        params.serverExtension = it
    }
    return params
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
        "isValidTeam" to isValidTeam,
        "isTeamEffective" to isTeamEffective
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
        "chatBanned" to isChatBanned,
        "followAccountIds" to followAccountIds
    )
}

fun V2NIMTeamMemberSearchResultEx.toMap(): Map<String, Any?> {
    val listResult = list.entries.map { entry ->
        mapOf(
            "teamRefer" to mapOf(
                "teamId" to entry.key.teamId,
                "teamType" to entry.key.teamType.value
            ),
            "members" to entry.value.map { it.toMap() }
        )
    }
    return mapOf(
        "resultList" to listResult,
        "count" to count,
        "nextToken" to nextToken,
        "finished" to isFinished
    )
}

// Lightweight implementation of V2NIMTeamRefer interface for passing into SDK
data class NIMTeamReferImpl(
    private val id: String,
    private val type: V2NIMTeamType
) : V2NIMTeamRefer {
    override fun getTeamId(): String = id
    override fun getTeamType(): V2NIMTeamType = type
}

fun convertToSearchTeamMemberParams(arguments: Map<String, *>): V2NIMSearchTeamMemberParams {
    val params = V2NIMSearchTeamMemberParams()
    // Support both keywordList (new) and keyword (legacy fallback)
    (arguments["keywordList"] as? List<*>)?.mapNotNull { it as? String }?.let {
        params.keywordList = it
    } ?: (arguments["keyword"] as? String)?.let {
        params.keywordList = listOf(it)
    }
    (arguments["teamRefers"] as List<*>?)?.mapNotNull { it as? Map<*, *> }?.let { refers ->
        params.teamRefers = refers.mapNotNull { ref ->
            val teamId = ref["teamId"] as? String ?: return@mapNotNull null
            val teamType = (ref["teamType"] as? Int)?.let { t -> V2NIMTeamType.typeOfValue(t) }
                ?: V2NIMTeamType.V2NIM_TEAM_TYPE_NORMAL
            NIMTeamReferImpl(teamId, teamType)
        }
    }
    params.isSearchAccountId = (arguments["searchAccountId"] as? Boolean) ?: true
    params.isSearchTeamNick = (arguments["searchTeamNick"] as? Boolean) ?: true
    (arguments["limit"] as? Int)?.let { params.limit = it }
    (arguments["nextToken"] as? String)?.let { params.nextToken = it }
    return params
}

fun convertToTeamSearchParams(arguments: Map<String, *>): V2NIMTeamSearchParams {
    val params = V2NIMTeamSearchParams()
    // Support both keywordList (new) and keyword (legacy fallback)
    (arguments["keywordList"] as? List<*>)?.mapNotNull { it as? String }?.let {
        params.keywordList = it
    } ?: (arguments["keyword"] as? String)?.let {
        params.keywordList = listOf(it)
    }
    (arguments["teamTypes"] as List<*>?)?.mapNotNull { (it as? Int)?.let { v -> V2NIMTeamType.typeOfValue(v) } }?.let {
        params.teamTypes = it
    }
    (arguments["limit"] as? Int)?.let { params.limit = it }
    (arguments["nextToken"] as? String)?.let { params.nextToken = it }
    return params
}

fun convertToCreateTeamParam(arguments: Map<String, *>?): V2NIMCreateTeamParams {
    val teamParam = V2NIMCreateTeamParams()
    if (arguments == null) {
        return teamParam
    }
    teamParam.name = arguments["name"] as String?
    teamParam.teamType = (arguments["teamType"] as Int?)?.let { V2NIMTeamType.typeOfValue(it) }
    (arguments["memberLimit"] as Int?)?.let {
        teamParam.memberLimit = it
    }
    (arguments["intro"] as String?)?.let {
        teamParam.intro = it
    }
    (arguments["announcement"] as String?)?.let {
        teamParam.announcement = it
    }
    (arguments["avatar"] as String?)?.let {
        teamParam.avatar = it
    }
    (arguments["serverExtension"] as String?)?.let {
        teamParam.serverExtension = it
    }
    (arguments["joinMode"] as Int?)?.let {
        teamParam.joinMode = V2NIMTeamJoinMode.typeOfValue(it)
    }
    (arguments["agreeMode"] as Int?)?.let {
        teamParam.agreeMode = V2NIMTeamAgreeMode.typeOfValue(it)
    }
    (arguments["inviteMode"] as Int?)?.let {
        teamParam.inviteMode = V2NIMTeamInviteMode.typeOfValue(it)
    }
    (arguments["updateInfoMode"] as Int?)?.let {
        teamParam.updateInfoMode =
            V2NIMTeamUpdateInfoMode.typeOfValue(it)
    }
    (arguments["updateExtensionMode"] as Int?)?.let {
        teamParam.updateExtensionMode = V2NIMTeamUpdateExtensionMode.typeOfValue(it)
    }

    (arguments["chatBannedMode"] as Int?)?.let {
        teamParam.chatBannedMode =
            V2NIMTeamChatBannedMode.typeOfValue(it)
    }

    return teamParam
}
