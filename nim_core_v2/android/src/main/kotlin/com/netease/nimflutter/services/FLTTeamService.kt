/*
 * Copyright (c) 2022 NetEase, Inc. All rights reserved.
 * Use of this source code is governed by a MIT license that can be
 * found in the LICENSE file.
 */

package com.netease.nimflutter.services

import android.content.Context
import com.netease.nimflutter.FLTConstant
import com.netease.nimflutter.FLTService
import com.netease.nimflutter.NimCore
import com.netease.nimflutter.NimResult
import com.netease.nimflutter.convertV2NIMAntispamConfig
import com.netease.nimflutter.convertV2NIMTeamJoinActionInfoQueryOption
import com.netease.nimflutter.convertV2NIMTeamMemberQueryOption
import com.netease.nimflutter.convertV2NIMUpdateSelfMemberInfoParams
import com.netease.nimflutter.convertV2NIMUpdateTeamInfoParams
import com.netease.nimflutter.toMap
import com.netease.nimlib.sdk.NIMClient
import com.netease.nimlib.sdk.v2.V2NIMError
import com.netease.nimlib.sdk.v2.common.V2NIMAntispamConfig
import com.netease.nimlib.sdk.v2.message.enums.V2NIMSortOrder
import com.netease.nimlib.sdk.v2.team.V2NIMTeamListener
import com.netease.nimlib.sdk.v2.team.V2NIMTeamService
import com.netease.nimlib.sdk.v2.team.enums.V2NIMTeamAgreeMode
import com.netease.nimlib.sdk.v2.team.enums.V2NIMTeamChatBannedMode
import com.netease.nimlib.sdk.v2.team.enums.V2NIMTeamInviteMode
import com.netease.nimlib.sdk.v2.team.enums.V2NIMTeamJoinActionStatus
import com.netease.nimlib.sdk.v2.team.enums.V2NIMTeamJoinActionType
import com.netease.nimlib.sdk.v2.team.enums.V2NIMTeamJoinMode
import com.netease.nimlib.sdk.v2.team.enums.V2NIMTeamMemberRole
import com.netease.nimlib.sdk.v2.team.enums.V2NIMTeamType
import com.netease.nimlib.sdk.v2.team.enums.V2NIMTeamUpdateExtensionMode
import com.netease.nimlib.sdk.v2.team.enums.V2NIMTeamUpdateInfoMode
import com.netease.nimlib.sdk.v2.team.model.V2NIMTeam
import com.netease.nimlib.sdk.v2.team.model.V2NIMTeamJoinActionInfo
import com.netease.nimlib.sdk.v2.team.model.V2NIMTeamMember
import com.netease.nimlib.sdk.v2.team.option.V2NIMTeamMemberSearchOption
import com.netease.nimlib.sdk.v2.team.params.V2NIMCreateTeamParams
import com.netease.nimlib.sdk.v2.team.params.V2NIMUpdateTeamInfoParams
import com.netease.nimlib.v2.builder.V2NIMTeamJoinActionInfoBuilder
import kotlin.coroutines.resume
import kotlinx.coroutines.suspendCancellableCoroutine

class FLTTeamService(
    applicationContext: Context,
    nimCore: NimCore
) : FLTService(applicationContext, nimCore) {
    private val tag = "FLTTeamService"
    private val teamService: V2NIMTeamService by lazy {
        NIMClient.getService(V2NIMTeamService::class.java)
    }

    override val serviceName = "TeamService"

    init {
        nimCore.onInitialized {
            teamService.addTeamListener(teamListener)
        }
        registerFlutterMethodCalls(
            "createTeam" to this::createTeam,
            "updateTeamInfo" to this::updateTeamInfo,
            "leaveTeam" to this::leaveTeam,
            "getTeamInfo" to this::getTeamInfo,
            "getTeamInfoByIds" to this::getTeamInfoByIds,
            "dismissTeam" to this::dismissTeam,
            "inviteMember" to this::inviteMember,
            "acceptInvitation" to this::acceptInvitation,
            "rejectInvitation" to this::rejectInvitation,
            "kickMember" to this::kickMember,
            "applyJoinTeam" to this::applyJoinTeam,
            "rejectJoinApplication" to this::rejectJoinApplication,
            "acceptJoinApplication" to this::acceptJoinApplication,
            "updateTeamMemberRole" to this::updateTeamMemberRole,
            "transferTeamOwner" to this::transferTeamOwner,
            "updateSelfTeamMemberInfo" to this::updateSelfTeamMemberInfo,
            "updateTeamMemberNick" to this::updateTeamMemberNick,
            "setTeamChatBannedMode" to this::setTeamChatBannedMode,
            "setTeamMemberChatBannedStatus" to this::setTeamMemberChatBannedStatus,
            "getJoinedTeamList" to this::getJoinedTeamList,
            "getJoinedTeamCount" to this::getJoinedTeamCount,
            "getTeamMemberList" to this::getTeamMemberList,
            "getTeamMemberListByIds" to this::getTeamMemberListByIds,
            "getTeamMemberInvitor" to this::getTeamMemberInvitor,
            "getTeamJoinActionInfoList" to this::getTeamJoinActionInfoList,
            "searchTeamByKeyword" to this::searchTeamByKeyword,
            "searchTeamMembers" to this::searchTeamMembers
        )
    }

    private val teamListener =
        object : V2NIMTeamListener {
            override fun onSyncStarted() {
                notifyEvent("onSyncStarted", mapOf())
            }

            override fun onSyncFinished() {
                notifyEvent("onSyncFinished", mapOf())
            }

            override fun onSyncFailed(error: V2NIMError?) {
                if (error == null) {
                    notifyEvent("onSyncFailed", mapOf())
                } else {
                    notifyEvent(
                        "onSyncFailed",
                        mapOf(
                            "code" to error.code,
                            "desc" to error.desc
                        )
                    )
                }
            }

            override fun onTeamCreated(team: V2NIMTeam) {
                notifyEvent("onTeamCreated", team.toMap())
            }

            override fun onTeamDismissed(team: V2NIMTeam?) {
                if (team != null) {
                    notifyEvent("onTeamDismissed", team.toMap())
                } else {
                    notifyEvent("onTeamDismissed", mapOf())
                }
            }

            override fun onTeamJoined(team: V2NIMTeam?) {
                if (team != null) {
                    notifyEvent("onTeamJoined", team.toMap())
                } else {
                    notifyEvent("onTeamJoined", mapOf())
                }
            }

            override fun onTeamLeft(
                team: V2NIMTeam?,
                isKicked: Boolean
            ) {
                notifyEvent(
                    "onTeamLeft",
                    mapOf(
                        "team" to team?.toMap(),
                        "isKicked" to
                            isKicked
                    )
                )
            }

            override fun onTeamInfoUpdated(team: V2NIMTeam?) {
                if (team != null) {
                    notifyEvent("onTeamInfoUpdated", team.toMap())
                } else {
                    notifyEvent("onTeamInfoUpdated", mapOf())
                }
            }

            override fun onTeamMemberJoined(teamMembers: MutableList<V2NIMTeamMember>?) {
                notifyEvent("onTeamMemberJoined", mapOf("memberList" to teamMembers?.map { it.toMap() }))
            }

            override fun onTeamMemberKicked(
                operatorAccountId: String?,
                teamMembers: MutableList<V2NIMTeamMember>?
            ) {
                notifyEvent(
                    "onTeamMemberKicked",
                    mapOf(
                        "operatorAccountId" to operatorAccountId,
                        "memberList" to teamMembers?.map { it.toMap() }
                    )
                )
            }

            override fun onTeamMemberLeft(teamMembers: MutableList<V2NIMTeamMember>?) {
                notifyEvent(
                    "onTeamMemberLeft",
                    mapOf("memberList" to teamMembers?.map { it.toMap() })
                )
            }

            override fun onTeamMemberInfoUpdated(teamMembers: MutableList<V2NIMTeamMember>?) {
                notifyEvent(
                    "onTeamMemberInfoUpdated",
                    mapOf("memberList" to teamMembers?.map { it.toMap() })
                )
            }

            override fun onReceiveTeamJoinActionInfo(joinActionInfo: V2NIMTeamJoinActionInfo?) {
                if (joinActionInfo != null) {
                    notifyEvent("onReceiveTeamJoinActionInfo", joinActionInfo.toMap())
                } else {
                    notifyEvent("onReceiveTeamJoinActionInfo", mapOf())
                }
            }
        }

    // 创建群组
    // createTeamParams – 创建群组参数
    // inviteeAccountIds – 群组创建时，同时被邀请加入群的成员列表
    // postscript – 邀请入群的附言
    // antispamConfig – 易盾反垃圾配置，如果不审核，该配置不需要配置；
    // 如果开启了安全通，默认采用安全通，该配置不需要配置；如果需要审核，且直接对接易盾，则配置该配置
    private suspend fun createTeam(
        arguments: Map<String, *>
    ): NimResult<Map<String, Any?>?> {
        return suspendCancellableCoroutine { cont ->
            val createTeamParams = arguments["createTeamParams"] as Map<String, *>?
            val teamParam = convertToCreateTeamParam(createTeamParams)
            val inviteeAccountIds = arguments["inviteeAccountIds"] as List<String>?
            val postscript = arguments["postscript"] as String?
            val antisMap = arguments["antispamConfig"] as Map<String, *>?
            var antispamConfig: V2NIMAntispamConfig? = null
            antisMap?.let {
                antispamConfig = convertV2NIMAntispamConfig(it)
            }
            teamService.createTeam(
                teamParam,
                inviteeAccountIds,
                postscript,
                antispamConfig,
                { result ->
                    cont.resume(
                        NimResult(
                            code = 0,
                            data = result.toMap()
                        )
                    )
                },
                { error ->
                    cont.resume(
                        if (error != null) {
                            NimResult(code = error.code, errorDetails = error.desc)
                        } else {
                            NimResult(code = -1, errorDetails = "createTeam failed!")
                        }
                    )
                }
            )
        }
    }

    // 修改群组信息
    // Params:
    // teamId – 群组id
    // teamType – 群组类型
    // updateTeamInfoParams – 修改群组信息参数
    // antispamConfig – 易盾反垃圾配置，如果不审核，该配置不需要配置；
    // 如果开启了安全通，默认采用安全通，该配置不需要配置；如果需要审核，且直接对接易盾，则配置该配置
    private suspend fun updateTeamInfo(
        arguments: Map<String, *>
    ): NimResult<Nothing> {
        return suspendCancellableCoroutine { cont ->
            val teamId = arguments["teamId"] as String?
            val teamType = arguments["teamType"] as Int?
            var updateParam: V2NIMUpdateTeamInfoParams? = null
            val updateMap = arguments["updateTeamInfoParams"] as Map<String, *>?
            updateMap?.let {
                updateParam = convertV2NIMUpdateTeamInfoParams(updateMap)
            }
            var antispamConfig: V2NIMAntispamConfig? = null
            val antisMap = arguments["antispamConfig"] as Map<String, *>?
            antisMap?.let {
                antispamConfig = convertV2NIMAntispamConfig(it)
            }
            if (teamId == null || teamType == null) {
                cont.resume(
                    NimResult(
                        code = FLTConstant.paramErrorCode,
                        errorDetails = "updateTeamInfo param is invalid"
                    )
                )
            } else {
                teamService.updateTeamInfo(
                    teamId,
                    V2NIMTeamType.typeOfValue(teamType),
                    updateParam,
                    antispamConfig,
                    {
                        cont.resume(NimResult.SUCCESS)
                    },
                    { error ->
                        cont.resume(
                            if (error != null) {
                                NimResult(code = error.code, errorDetails = error.desc)
                            } else {
                                NimResult(code = -1, errorDetails = "updateTeamInfo failed!")
                            }
                        )
                    }
                )
            }
        }
    }

    // 离开群组
    // Params:
    // teamId – 群组id
    // teamType – 群组类型
    private suspend fun leaveTeam(
        arguments: Map<String, *>
    ): NimResult<Nothing> {
        return suspendCancellableCoroutine { cont ->
            val teamId = arguments["teamId"] as String?
            val teamType = arguments["teamType"] as Int?
            if (teamId == null || teamType == null) {
                cont.resume(
                    NimResult(
                        code = FLTConstant.paramErrorCode,
                        errorDetails = "leaveTeam param is invalid"
                    )
                )
            } else {
                teamService.leaveTeam(teamId, V2NIMTeamType.typeOfValue(teamType), {
                    cont.resume(NimResult.SUCCESS)
                }, { error ->
                    cont.resume(
                        if (error != null) {
                            NimResult(code = error.code, errorDetails = error.desc)
                        } else {
                            NimResult(code = -1, errorDetails = "leaveTeam failed!")
                        }
                    )
                })
            }
        }
    }

    // 获取群组信息
    // Params:
    // teamId – 群组id
    // teamType – 群组类型
    private suspend fun getTeamInfo(
        arguments: Map<String, *>
    ): NimResult<Map<String, Any?>?> {
        return suspendCancellableCoroutine { cont ->
            val teamId = arguments["teamId"] as String?
            val teamType = arguments["teamType"] as Int?
            if (teamId == null || teamType == null) {
                cont.resume(
                    NimResult(
                        code = FLTConstant.paramErrorCode,
                        errorDetails = "getTeamInfo param is invalid"
                    )
                )
            } else {
                teamService.getTeamInfo(teamId, V2NIMTeamType.typeOfValue(teamType), {
                    cont.resume(NimResult(code = 0, data = it.toMap()))
                }, { error ->
                    cont.resume(
                        if (error != null) {
                            NimResult(code = error.code, errorDetails = error.desc)
                        } else {
                            NimResult(code = -1, errorDetails = "getTeamInfo failed!")
                        }
                    )
                })
            }
        }
    }

    // 根据群组ID获取群组信息
    // Params:
    // teamIds – 群组id列表
    // teamType – 群组类型
    private suspend fun getTeamInfoByIds(
        arguments: Map<String, *>
    ): NimResult<Map<String, Any?>?> {
        return suspendCancellableCoroutine { cont ->
            val teamIdList = arguments["teamIds"] as List<String>?
            val teamType = arguments["teamType"] as Int?
            if (teamIdList == null || teamType == null) {
                cont.resume(
                    NimResult(
                        code = FLTConstant.paramErrorCode,
                        errorDetails = "getTeamInfoByIds teamIdList param is invalid"
                    )
                )
            } else {
                teamService.getTeamInfoByIds(
                    teamIdList,
                    V2NIMTeamType.typeOfValue(teamType),
                    {
                        cont.resume(
                            NimResult(
                                code = 0,
                                data = mapOf("teamList" to it.map { team -> team.toMap() })
                            )
                        )
                    },
                    { error ->
                        cont.resume(
                            if (error != null) {
                                NimResult(code = error.code, errorDetails = error.desc)
                            } else {
                                NimResult(code = -1, errorDetails = "getTeamInfo failed!")
                            }
                        )
                    }
                )
            }
        }
    }

    // 解散群组
    // Params:
    // teamId – 群组id
    // teamType – 群组类型
    private suspend fun dismissTeam(
        arguments: Map<String, *>
    ): NimResult<Nothing> {
        return suspendCancellableCoroutine { cont ->
            val teamId = arguments["teamId"] as String?
            val teamType = arguments["teamType"] as Int?
            if (teamId == null || teamType == null) {
                cont.resume(
                    NimResult(
                        code = FLTConstant.paramErrorCode,
                        errorDetails = "dismissTeam param is invalid"
                    )
                )
            } else {
                teamService.dismissTeam(teamId, V2NIMTeamType.typeOfValue(teamType), {
                    cont.resume(NimResult.SUCCESS)
                }, { error ->
                    cont.resume(
                        if (error != null) {
                            NimResult(code = error.code, errorDetails = error.desc)
                        } else {
                            NimResult(code = -1, errorDetails = "dismissTeam failed!")
                        }
                    )
                })
            }
        }
    }

    // 邀请成员加入群组
    // Params:
    // teamId – 群组id
    // teamType – 群组类型
    // invitorAccountIds – 邀请进群的成员列表
    // postscript – 邀请入群的附言
    private suspend fun inviteMember(
        arguments: Map<String, *>
    ): NimResult<Map<String, *>?> {
        return suspendCancellableCoroutine { cont ->
            val teamId = arguments["teamId"] as String
            val postscript = arguments["postscript"] as String?
            val teamType = arguments["teamType"] as Int?
            val invitorAccountIds =
                (arguments["inviteeAccountIds"] as List<*>?)?.map {
                    it as String
                }
            if (teamId == null || teamType == null) {
                cont.resume(
                    NimResult(
                        code = FLTConstant.paramErrorCode,
                        errorDetails = "inviteMember param is invalid"
                    )
                )
            } else {
                teamService.inviteMember(
                    teamId,
                    V2NIMTeamType.typeOfValue(teamType),
                    invitorAccountIds,
                    postscript,
                    {
                        cont.resume(NimResult(code = 0, data = mapOf("failedList" to it)))
                    },
                    { error ->
                        cont.resume(
                            if (error != null) {
                                NimResult(code = error.code, errorDetails = error.desc)
                            } else {
                                NimResult(code = -1, errorDetails = "inviteMember failed!")
                            }
                        )
                    }
                )
            }
        }
    }

    // 同意邀请入群
    // Params:
    // invitationInfo – 收到的邀请入群信息
    private suspend fun acceptInvitation(
        arguments: Map<String, *>
    ): NimResult<Map<String, *>?> {
        return suspendCancellableCoroutine { cont ->
            val paramMap = arguments["invitationInfo"] as Map<String, *>
            val teamId = paramMap["teamId"] as String?
            val teamType = paramMap["teamType"] as Int?
            val operatorAccountId = paramMap["operatorAccountId"] as String?
            if (teamId == null || teamType == null) {
                cont.resume(
                    NimResult(
                        code = FLTConstant.paramErrorCode,
                        errorDetails = "acceptInvitation param is invalid"
                    )
                )
            } else {
                val jsonInfo = V2NIMTeamJoinActionInfoBuilder.builder()
                jsonInfo.setTeamId(teamId)
                jsonInfo.setTeamType(V2NIMTeamType.typeOfValue(teamType))
                jsonInfo.setOperatorAccountId(operatorAccountId)
                jsonInfo.setPostscript(paramMap["postscript"] as String?)
                (paramMap["actionStatus"] as Int?)?.let {
                    jsonInfo.setActionStatus(V2NIMTeamJoinActionStatus.typeOfValue(it))
                }
                (paramMap["actionType"] as Int?)?.let {
                    jsonInfo.setActionType(V2NIMTeamJoinActionType.typeOfValue(it))
                }
                (paramMap["timestamp"] as Long?)?.let { jsonInfo.setTimestamp(it) }
                teamService.acceptInvitation(
                    jsonInfo.build(),
                    { it ->
                        cont.resume(
                            NimResult(
                                code = 0,
                                data = it.toMap()
                            )
                        )
                    },
                    { error ->
                        cont.resume(
                            if (error != null) {
                                NimResult(code = error.code, errorDetails = error.desc)
                            } else {
                                NimResult(code = -1, errorDetails = "acceptInvitation failed!")
                            }
                        )
                    }
                )
            }
        }
    }

    // 拒绝邀请入群
    // Params:
    // invitationInfo – 收到的邀请入群信息
    // postscript – 拒绝入群的附言
    private suspend fun rejectInvitation(
        arguments: Map<String, *>
    ): NimResult<Nothing> {
        return suspendCancellableCoroutine { cont ->
            val paramMap = arguments["invitationInfo"] as Map<String, *>
            val teamId = paramMap["teamId"] as String?
            val teamType = paramMap["teamType"] as Int?
            val operatorAccountId = paramMap["operatorAccountId"] as String?
            if (teamId == null || teamType == null) {
                cont.resume(
                    NimResult(
                        code = FLTConstant.paramErrorCode,
                        errorDetails = "acceptInvitation param is invalid"
                    )
                )
            } else {
                val jsonInfo = V2NIMTeamJoinActionInfoBuilder.builder()
                jsonInfo.setTeamId(teamId)
                jsonInfo.setTeamType(V2NIMTeamType.typeOfValue(teamType))
                jsonInfo.setOperatorAccountId(operatorAccountId)
                val rejectPostscript = arguments["postscript"] as String?
                val postscript = paramMap["postscript"] as String?
                postscript?.let { jsonInfo.setPostscript(it) }
                (paramMap["actionStatus"] as Int?)?.let {
                    jsonInfo.setActionStatus(V2NIMTeamJoinActionStatus.typeOfValue(it))
                }
                (paramMap["actionType"] as Int?)?.let {
                    jsonInfo.setActionType(V2NIMTeamJoinActionType.typeOfValue(it))
                }
                (paramMap["timestamp"] as Long?)?.let { jsonInfo.setTimestamp(it) }
                teamService.rejectInvitation(
                    jsonInfo.build(),
                    rejectPostscript,
                    {
                        cont.resume(NimResult.SUCCESS)
                    },
                    { error ->
                        cont.resume(
                            if (error != null) {
                                NimResult(code = error.code, errorDetails = error.desc)
                            } else {
                                NimResult(code = -1, errorDetails = "acceptInvitation failed!")
                            }
                        )
                    }
                )
            }
        }
    }

    // 接受入群加入请求
    // Params:
    // applicationInfo – 加入申请的相关信息
    private suspend fun acceptJoinApplication(
        arguments: Map<String, *>
    ): NimResult<Nothing> {
        return suspendCancellableCoroutine { cont ->
            val paramMap = arguments["joinInfo"] as Map<String, *>
            val teamId = paramMap["teamId"] as String?
            val teamType = paramMap["teamType"] as Int?
            val operatorAccountId = paramMap["operatorAccountId"] as String?
            if (teamId == null || teamType == null) {
                cont.resume(
                    NimResult(
                        code = FLTConstant.paramErrorCode,
                        errorDetails = "acceptJoinApplication param is invalid"
                    )
                )
            } else {
                val jsonInfo = V2NIMTeamJoinActionInfoBuilder.builder()
                jsonInfo.setTeamId(teamId)
                jsonInfo.setTeamType(V2NIMTeamType.typeOfValue(teamType))
                jsonInfo.setOperatorAccountId(operatorAccountId)
                val postscript = paramMap["postscript"] as String?
                postscript?.let { jsonInfo.setPostscript(it) }
                (paramMap["actionStatus"] as Int?)?.let {
                    jsonInfo.setActionStatus(V2NIMTeamJoinActionStatus.typeOfValue(it))
                }
                (paramMap["actionType"] as Int?)?.let {
                    jsonInfo.setActionType(V2NIMTeamJoinActionType.typeOfValue(it))
                }
                (paramMap["timestamp"] as Long?)?.let { jsonInfo.setTimestamp(it) }
                teamService.acceptJoinApplication(
                    jsonInfo.build(),
                    {
                        cont.resume(NimResult.SUCCESS)
                    },
                    { error ->
                        cont.resume(
                            if (error != null) {
                                NimResult(code = error.code, errorDetails = error.desc)
                            } else {
                                NimResult(code = -1, errorDetails = "acceptJoinApplication failed!")
                            }
                        )
                    }
                )
            }
        }
    }

    // 接受入群加入请求
    // Params:
    // applicationInfo – 加入申请的相关信息
    private suspend fun rejectJoinApplication(
        arguments: Map<String, *>
    ): NimResult<Nothing> {
        return suspendCancellableCoroutine { cont ->
            val paramMap = arguments["joinInfo"] as Map<String, *>
            val teamId = paramMap["teamId"] as String?
            val teamType = paramMap["teamType"] as Int?
            val operatorAccountId = paramMap["operatorAccountId"] as String?
            if (teamId == null || teamType == null) {
                cont.resume(
                    NimResult(
                        code = FLTConstant.paramErrorCode,
                        errorDetails = "rejectJoinApplication param is invalid"
                    )
                )
            } else {
                val jsonInfo = V2NIMTeamJoinActionInfoBuilder.builder()
                jsonInfo.setTeamId(teamId)
                jsonInfo.setTeamType(V2NIMTeamType.typeOfValue(teamType))
                jsonInfo.setOperatorAccountId(operatorAccountId)
                val rejectPostscript = arguments["postscript"] as String?
                val postscript = paramMap["postscript"] as String?
                postscript?.let { jsonInfo.setPostscript(it) }
                (paramMap["actionStatus"] as Int?)?.let {
                    jsonInfo.setActionStatus(V2NIMTeamJoinActionStatus.typeOfValue(it))
                }
                (paramMap["actionType"] as Int?)?.let {
                    jsonInfo.setActionType(V2NIMTeamJoinActionType.typeOfValue(it))
                }
                (paramMap["timestamp"] as Long?)?.let { jsonInfo.setTimestamp(it) }
                teamService.rejectJoinApplication(
                    jsonInfo.build(),
                    rejectPostscript,
                    {
                        cont.resume(NimResult.SUCCESS)
                    },
                    { error ->
                        cont.resume(
                            if (error != null) {
                                NimResult(code = error.code, errorDetails = error.desc)
                            } else {
                                NimResult(code = -1, errorDetails = "rejectJoinApplication failed!")
                            }
                        )
                    }
                )
            }
        }
    }

    // 踢出群组成员
    // Params:
    // teamId – 群组id
    // teamType – 群组类型
    // memberAccountIds – 被踢出群组的成员列表
    private suspend fun kickMember(
        arguments: Map<String, *>
    ): NimResult<Nothing> {
        return suspendCancellableCoroutine { cont ->
            val teamId = arguments["teamId"] as String?
            val teamType = arguments["teamType"] as Int?
            val memberAccountIds = arguments["memberAccountIds"] as List<String>?
            if (teamId == null || teamType == null) {
                cont.resume(
                    NimResult(
                        code = FLTConstant.paramErrorCode,
                        errorDetails = "kickMember param is invalid"
                    )
                )
            } else {
                teamService.kickMember(
                    teamId,
                    V2NIMTeamType.typeOfValue(teamType),
                    memberAccountIds,
                    {
                        cont.resume(NimResult.SUCCESS)
                    },
                    { error ->
                        cont.resume(
                            if (error != null) {
                                NimResult(code = error.code, errorDetails = error.desc)
                            } else {
                                NimResult(code = -1, errorDetails = "kickMember failed!")
                            }
                        )
                    }
                )
            }
        }
    }

    // 申请加入群组
    // Params:
    // teamId – 群组id
    private suspend fun applyJoinTeam(
        arguments: Map<String, *>
    ): NimResult<Map<String, *>?> {
        return suspendCancellableCoroutine { cont ->
            val teamId = arguments["teamId"] as String?
            val teamType = arguments["teamType"] as Int?
            val postscript = arguments["postscript"] as String?
            if (teamId == null || teamType == null) {
                cont.resume(
                    NimResult(
                        code = FLTConstant.paramErrorCode,
                        errorDetails = "applyJoinTeam param is invalid"
                    )
                )
            } else {
                teamService.applyJoinTeam(
                    teamId,
                    V2NIMTeamType.typeOfValue(teamType),
                    postscript,
                    {
                        cont.resume(NimResult(code = 0, data = it.toMap()))
                    },
                    { error ->
                        cont.resume(
                            if (error != null) {
                                NimResult(code = error.code, errorDetails = error.desc)
                            } else {
                                NimResult(code = -1, errorDetails = "applyJoinTeam failed!")
                            }
                        )
                    }
                )
            }
        }
    }

    // 更新群组成员角色
    // Params:
    // teamId – 群组id
    // teamType – 群组类型
    // memberAccountIds – 群成员账号id列表
    // memberRole – 群成员角色
    private suspend fun updateTeamMemberRole(
        arguments: Map<String, *>
    ): NimResult<Nothing> {
        return suspendCancellableCoroutine { cont ->
            val teamId = arguments["teamId"] as String?
            val teamType = arguments["teamType"] as Int?
            val memberAccountIds = arguments["memberAccountIds"] as List<String>?
            val memberRole = arguments["memberRole"] as Int?
            if (teamId == null || teamType == null || memberRole == null) {
                cont.resume(
                    NimResult(
                        code = FLTConstant.paramErrorCode,
                        errorDetails = "updateTeamMemberRole param is invalid"
                    )
                )
            } else {
                teamService.updateTeamMemberRole(
                    teamId,
                    V2NIMTeamType.typeOfValue(teamType),
                    memberAccountIds,
                    V2NIMTeamMemberRole.typeOfValue(memberRole),
                    {
                        cont.resume(NimResult.SUCCESS)
                    },
                    { error ->
                        cont.resume(
                            if (error != null) {
                                NimResult(code = error.code, errorDetails = error.desc)
                            } else {
                                NimResult(code = -1, errorDetails = "applyJoinTeam failed!")
                            }
                        )
                    }
                )
            }
        }
    }

    // 转移群组群主
    // Params:
    // teamId – 群组id
    // teamType – 群组类型
    // accountId – 新群主的账号id
    // leave – 转让群主后，是否同时退出该群
    private suspend fun transferTeamOwner(
        arguments: Map<String, *>
    ): NimResult<Nothing> {
        return suspendCancellableCoroutine { cont ->
            val teamId = arguments["teamId"] as String?
            val teamType = arguments["teamType"] as Int?
            val accountId = arguments["accountId"] as String?
            val leave = arguments["leave"] as Boolean?
            if (teamId == null || teamType == null || leave == null) {
                cont.resume(
                    NimResult(
                        code = FLTConstant.paramErrorCode,
                        errorDetails = "transferTeamOwner param is invalid"
                    )
                )
            } else {
                teamService.transferTeamOwner(
                    teamId,
                    V2NIMTeamType.typeOfValue(teamType),
                    accountId,
                    leave,
                    {
                        cont.resume(NimResult.SUCCESS)
                    },
                    { error ->
                        cont.resume(
                            if (error != null) {
                                NimResult(code = error.code, errorDetails = error.desc)
                            } else {
                                NimResult(code = -1, errorDetails = "applyJoinTeam failed!")
                            }
                        )
                    }
                )
            }
        }
    }

    // 修改自己的群成员信息
    // Params:
    // teamId – 群组id
    // teamType – 群组类型
    // memberInfoParams – 被修改的字段
    private suspend fun updateSelfTeamMemberInfo(
        arguments: Map<String, *>
    ): NimResult<Nothing> {
        return suspendCancellableCoroutine { cont ->
            val teamId = arguments["teamId"] as String?
            val teamType = arguments["teamType"] as Int?
            val memberInfoParams = convertV2NIMUpdateSelfMemberInfoParams(arguments["memberInfoParams"] as Map<String, *>)
            if (teamId == null || teamType == null) {
                cont.resume(
                    NimResult(
                        code = FLTConstant.paramErrorCode,
                        errorDetails = "updateSelfTeamMemberInfo param is invalid"
                    )
                )
            } else {
                teamService.updateSelfTeamMemberInfo(
                    teamId,
                    V2NIMTeamType.typeOfValue(teamType),
                    memberInfoParams,
                    {
                        cont.resume(NimResult.SUCCESS)
                    },
                    { error ->
                        cont.resume(
                            if (error != null) {
                                NimResult(code = error.code, errorDetails = error.desc)
                            } else {
                                NimResult(code = -1, errorDetails = "updateSelfTeamMemberInfo failed!")
                            }
                        )
                    }
                )
            }
        }
    }

    // 修改群成员昵称
    // Params:
    // teamId – 群组id
    // teamType – 群组类型
    // accountId – 被修改成员的账号
    // teamNick – 被修改成员新的昵称
    private suspend fun updateTeamMemberNick(
        arguments: Map<String, *>
    ): NimResult<Nothing> {
        return suspendCancellableCoroutine { cont ->
            val teamId = arguments["teamId"] as String?
            val teamType = arguments["teamType"] as Int?
            val accountId = arguments["accountId"] as String?
            val teamNick = arguments["teamNick"] as String?
            if (teamId == null || teamType == null) {
                cont.resume(
                    NimResult(
                        code = FLTConstant.paramErrorCode,
                        errorDetails = "updateSelfTeamMemberInfo param is invalid"
                    )
                )
            } else {
                teamService.updateTeamMemberNick(
                    teamId,
                    V2NIMTeamType.typeOfValue(teamType),
                    accountId,
                    teamNick,
                    {
                        cont.resume(NimResult.SUCCESS)
                    },
                    { error ->
                        cont.resume(
                            if (error != null) {
                                NimResult(code = error.code, errorDetails = error.desc)
                            } else {
                                NimResult(code = -1, errorDetails = "updateTeamMemberNick failed!")
                            }
                        )
                    }
                )
            }
        }
    }

    // 设置群组禁言模式
    // Params:
    // teamId – 群组id
    // teamType – 群组类型
    // chatBannedMode – 群组禁言模式
    private suspend fun setTeamChatBannedMode(
        arguments: Map<String, *>
    ): NimResult<Nothing> {
        return suspendCancellableCoroutine { cont ->
            val teamId = arguments["teamId"] as String?
            val teamType = arguments["teamType"] as Int?
            val chatBannedMode = arguments["chatBannedMode"] as Int?
            if (teamId == null || teamType == null || chatBannedMode == null) {
                cont.resume(
                    NimResult(
                        code = FLTConstant.paramErrorCode,
                        errorDetails = "setTeamChatBannedMode param is invalid"
                    )
                )
            } else {
                teamService.setTeamChatBannedMode(
                    teamId,
                    V2NIMTeamType.typeOfValue(teamType),
                    V2NIMTeamChatBannedMode.typeOfValue(chatBannedMode),
                    {
                        cont.resume(NimResult.SUCCESS)
                    },
                    { error ->
                        cont.resume(
                            if (error != null) {
                                NimResult(code = error.code, errorDetails = error.desc)
                            } else {
                                NimResult(code = -1, errorDetails = "setTeamChatBannedMode failed!")
                            }
                        )
                    }
                )
            }
        }
    }

    // 设置群组成员聊天禁言状态
    // Params:
    // teamId – 群组id
    // teamType – 群组类型
    // accountId – 被修改成员的账号
    // chatBanned – 群组中聊天是否被禁言,true:被禁言,false:未禁言
    private suspend fun setTeamMemberChatBannedStatus(
        arguments: Map<String, *>
    ): NimResult<Nothing> {
        return suspendCancellableCoroutine { cont ->
            val teamId = arguments["teamId"] as String?
            val teamType = arguments["teamType"] as Int?
            val accountId = arguments["accountId"] as String?
            val chatBanned = arguments["chatBanned"] as Boolean?
            if (teamId == null || teamType == null || chatBanned == null) {
                cont.resume(
                    NimResult(
                        code = FLTConstant.paramErrorCode,
                        errorDetails = "setTeamChatBannedMode param is invalid"
                    )
                )
            } else {
                teamService.setTeamMemberChatBannedStatus(
                    teamId,
                    V2NIMTeamType.typeOfValue(teamType),
                    accountId,
                    chatBanned,
                    {
                        cont.resume(NimResult.SUCCESS)
                    },
                    { error ->
                        cont.resume(
                            if (error != null) {
                                NimResult(code = error.code, errorDetails = error.desc)
                            } else {
                                NimResult(code = -1, errorDetails = "setTeamChatBannedMode failed!")
                            }
                        )
                    }
                )
            }
        }
    }

    // 获取当前已经加入的群组列表
    // Params:
    // teamTypes – 群组类型列表，如果为null，或者列表为empty， 表示查询所有所有群类型,否则按输入群类型进行查询
    private suspend fun getJoinedTeamList(
        arguments: Map<String, *>
    ): NimResult<Map<String, Any?>?> {
        return suspendCancellableCoroutine { cont ->
            val teamTypes = arguments["teamTypes"] as List<Int>?
            teamService.getJoinedTeamList(
                teamTypes?.map { V2NIMTeamType.typeOfValue(it) },
                { it ->
                    cont.resume(
                        NimResult(
                            code = 0,
                            data = mapOf("teamList" to it.map { team -> team.toMap() })
                        )
                    )
                },
                { error ->
                    cont.resume(
                        if (error != null) {
                            NimResult(code = error.code, errorDetails = error.desc)
                        } else {
                            NimResult(code = -1, errorDetails = "getJoinedTeamList failed!")
                        }
                    )
                }
            )
        }
    }

    // 获取当前已经加入的群组列表数量
    // Params:
    // teamTypes – 群组类型列表，如果为null，或者列表为empty， 表示查询所有所有群类型,否则按输入群类型进行查询
    // Returns:
    // 群组数量
    private suspend fun getJoinedTeamCount(
        arguments: Map<String, *>
    ): NimResult<Int> {
        return suspendCancellableCoroutine { cont ->
            val teamTypes = arguments["teamTypes"] as List<Int>?
            val count =
                teamService.getJoinedTeamCount(
                    teamTypes?.map { V2NIMTeamType.typeOfValue(it) }
                )
            cont.resume(
                NimResult(
                    code = 0,
                    data = count
                )
            )
        }
    }

    // 获取群组成员列表
    // Params:
    // teamId – 群组id
    // teamType – 群组类型
    // queryOption – 查询选项
    private suspend fun getTeamMemberList(
        arguments: Map<String, *>
    ): NimResult<Map<String, Any?>?> {
        return suspendCancellableCoroutine { cont ->
            val teamId = arguments["teamId"] as String?
            val teamType = arguments["teamType"] as Int?
            val queryOption =
                if (arguments["queryOption"] as Map<String, *>? == null) {
                    null
                } else {
                    convertV2NIMTeamMemberQueryOption(
                        arguments["queryOption"] as Map<String, *>
                    )
                }

            if (teamId == null || teamType == null) {
                cont.resume(
                    NimResult(
                        code = FLTConstant.paramErrorCode,
                        errorDetails = "getTeamMemberList param is invalid"
                    )
                )
            } else {
                teamService.getTeamMemberList(
                    teamId,
                    V2NIMTeamType.typeOfValue(teamType),
                    queryOption,
                    { it ->
                        cont.resume(
                            NimResult(
                                code = 0,
                                data = it.toMap()
                            )
                        )
                    },
                    { error ->
                        cont.resume(
                            if (error != null) {
                                NimResult(code = error.code, errorDetails = error.desc)
                            } else {
                                NimResult(code = -1, errorDetails = "getTeamMemberList failed!")
                            }
                        )
                    }
                )
            }
        }
    }

    // 根据账号ID列表获取群组成员列表
    // Params:
    // teamId – 群组id
    // teamType – 群组类型
    // accountIds – 账号id列表
    private suspend fun getTeamMemberListByIds(
        arguments: Map<String, *>
    ): NimResult<Map<String, Any?>?> {
        return suspendCancellableCoroutine { cont ->
            val teamId = arguments["teamId"] as String?
            val teamType = arguments["teamType"] as Int?
            val accountIds = arguments["accountIds"] as List<String>?
            if (teamId == null || teamType == null || accountIds == null) {
                cont.resume(
                    NimResult(
                        code = FLTConstant.paramErrorCode,
                        errorDetails = "getTeamMemberListByIds param is invalid"
                    )
                )
            } else {
                teamService.getTeamMemberListByIds(
                    teamId,
                    V2NIMTeamType.typeOfValue(teamType),
                    accountIds,
                    { it ->
                        cont.resume(
                            NimResult(
                                code = 0,
                                data = mapOf("memberList" to it.map { member -> member.toMap() })
                            )
                        )
                    },
                    { error ->
                        cont.resume(
                            if (error != null) {
                                NimResult(code = error.code, errorDetails = error.desc)
                            } else {
                                NimResult(code = -1, errorDetails = "getTeamMemberListByIds failed!")
                            }
                        )
                    }
                )
            }
        }
    }

    // 根据账号ID列表获取群组成员邀请人
    // Params:
    // teamId – 群组id
    // teamType – 群组类型
    // accountIds – 账号id列表
    private suspend fun getTeamMemberInvitor(
        arguments: Map<String, *>
    ): NimResult<Map<String, Any?>?> {
        return suspendCancellableCoroutine { cont ->
            val teamId = arguments["teamId"] as String?
            val teamType = arguments["teamType"] as Int?
            val accountIds = arguments["accountIds"] as List<String>?
            if (teamId == null || teamType == null) {
                cont.resume(
                    NimResult(
                        code = FLTConstant.paramErrorCode,
                        errorDetails = "getTeamMemberInvitor param is invalid"
                    )
                )
            } else {
                teamService.getTeamMemberInvitor(
                    teamId,
                    V2NIMTeamType.typeOfValue(teamType),
                    accountIds,
                    { it ->
                        cont.resume(
                            NimResult(
                                code = 0,
                                data = it
                            )
                        )
                    },
                    { error ->
                        cont.resume(
                            if (error != null) {
                                NimResult(code = error.code, errorDetails = error.desc)
                            } else {
                                NimResult(code = -1, errorDetails = "getTeamMemberInvitors failed!")
                            }
                        )
                    }
                )
            }
        }
    }

    // 获取群加入相关信息
    private suspend fun getTeamJoinActionInfoList(
        arguments: Map<String, *>
    ): NimResult<Map<String, Any?>?> {
        return suspendCancellableCoroutine { cont ->
            val option = convertV2NIMTeamJoinActionInfoQueryOption(arguments["queryOption"] as Map<String, *>)
            teamService.getTeamJoinActionInfoList(
                option,
                { it ->
                    cont.resume(
                        NimResult(
                            code = 0,
                            data = it.toMap()
                        )
                    )
                },
                { error ->
                    cont.resume(
                        if (error != null) {
                            NimResult(code = error.code, errorDetails = error.desc)
                        } else {
                            NimResult(code = -1, errorDetails = "getTeamMemberInvitors failed!")
                        }
                    )
                }
            )
        }
    }

    // 根据关键字搜索群信息 混合搜索高级群和超大群，like匹配 只搜索群名称 不限制群有效性，不限制是否加入，不限制群是否有效 基于本地数据存储查找
    // Params:
    // keyword – 关键字
    private suspend fun searchTeamByKeyword(
        arguments: Map<String, *>
    ): NimResult<Map<String, Any?>?> {
        return suspendCancellableCoroutine { cont ->
            val keyword = arguments["keyword"] as String?
            teamService.searchTeamByKeyword(
                keyword,
                { it ->
                    cont.resume(
                        NimResult(
                            code = 0,
                            data = mapOf("teamList" to it.map { team -> team.toMap() })
                        )
                    )
                },
                { error ->
                    cont.resume(
                        if (error != null) {
                            NimResult(code = error.code, errorDetails = error.desc)
                        } else {
                            NimResult(code = -1, errorDetails = "searchTeamByKeyword failed!")
                        }
                    )
                }
            )
        }
    }

    // 根据关键字搜索群成员
    // Params:
    // searchOption – 搜索参数
    private suspend fun searchTeamMembers(
        arguments: Map<String, *>
    ): NimResult<Map<String, Any?>?> {
        return suspendCancellableCoroutine { cont ->
            val searchOption = arguments["searchOption"] as Map<String, *>

            val keyword = searchOption["keyword"] as String
            val teamId = searchOption["teamId"] as String?
            val nextToken = searchOption["nextToken"] as String?
            val limit = searchOption["limit"] as Int?
            val teamType = V2NIMTeamType.typeOfValue(searchOption["teamType"] as Int)
            val order = searchOption["order"] as Int?
            val search = V2NIMTeamMemberSearchOption.V2NIMTeamMemberSearchOptionBuilder.builder(keyword, teamType, nextToken)
            search.withTeamId(teamId)
            if (limit != null) {
                search.withLimit(limit)
            }

            order?.let { search.withOrder(V2NIMSortOrder.typeOfValue(it)) }

            teamService.searchTeamMembers(
                search.build(),
                { it ->
                    cont.resume(
                        NimResult(
                            code = 0,
                            data = it.toMap()
                        )
                    )
                },
                { error ->
                    cont.resume(
                        if (error != null) {
                            NimResult(code = error.code, errorDetails = error.desc)
                        } else {
                            NimResult(code = -1, errorDetails = "searchTeamByKeyword failed!")
                        }
                    )
                }
            )
        }
    }

    private fun convertToCreateTeamParam(arguments: Map<String, *>?): V2NIMCreateTeamParams {
        val teamParam = V2NIMCreateTeamParams()
        if (arguments == null) {
            return teamParam
        }
        teamParam.name = arguments["name"] as String?
        teamParam.teamType = (arguments["teamType"] as Int?)?.let { V2NIMTeamType.typeOfValue(it) }
        (arguments["memberLimit"] as Int?).let {
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
}
