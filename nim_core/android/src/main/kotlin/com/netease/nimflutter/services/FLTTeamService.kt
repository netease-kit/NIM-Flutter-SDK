/*
 * Copyright (c) 2022 NetEase, Inc. All rights reserved.
 * Use of this source code is governed by a MIT license that can be
 * found in the LICENSE file.
 */

package com.netease.nimflutter.services

import android.content.Context
import android.text.TextUtils
import com.netease.nimflutter.FLTService
import com.netease.nimflutter.NimCore
import com.netease.nimflutter.NimResult
import com.netease.nimflutter.NimResultContinuationCallback
import com.netease.nimflutter.NimResultContinuationCallbackOfNothing
import com.netease.nimflutter.stringToTeamBeInviteModeEnumMap
import com.netease.nimflutter.stringToTeamExtensionUpdateModeEnumMap
import com.netease.nimflutter.stringToTeamFieldEnumTypeMap
import com.netease.nimflutter.stringToTeamInviteModeEnumMap
import com.netease.nimflutter.stringToTeamTypeEnumMap
import com.netease.nimflutter.stringToTeamUpdateModeEnumMap
import com.netease.nimflutter.stringToVerifyTypeEnumMap
import com.netease.nimflutter.toMap
import com.netease.nimlib.sdk.NIMClient
import com.netease.nimlib.sdk.Observer
import com.netease.nimlib.sdk.RequestCallback
import com.netease.nimlib.sdk.team.TeamService
import com.netease.nimlib.sdk.team.TeamServiceObserver
import com.netease.nimlib.sdk.team.constant.TeamBeInviteModeEnum
import com.netease.nimlib.sdk.team.constant.TeamExtensionUpdateModeEnum
import com.netease.nimlib.sdk.team.constant.TeamFieldEnum
import com.netease.nimlib.sdk.team.constant.TeamInviteModeEnum
import com.netease.nimlib.sdk.team.constant.TeamMessageNotifyTypeEnum
import com.netease.nimlib.sdk.team.constant.TeamTypeEnum
import com.netease.nimlib.sdk.team.constant.TeamUpdateModeEnum
import com.netease.nimlib.sdk.team.constant.VerifyTypeEnum
import com.netease.nimlib.sdk.team.model.CreateTeamResult
import com.netease.nimlib.sdk.team.model.Team
import com.netease.nimlib.sdk.team.model.TeamMember
import com.netease.yunxin.kit.alog.ALog
import java.io.Serializable
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.channels.awaitClose
import kotlinx.coroutines.channels.onFailure
import kotlinx.coroutines.flow.callbackFlow
import kotlinx.coroutines.flow.launchIn
import kotlinx.coroutines.flow.onEach
import kotlinx.coroutines.suspendCancellableCoroutine

class FLTTeamService(
    applicationContext: Context,
    nimCore: NimCore
) : FLTService(applicationContext, nimCore) {

    private val tag = "FLTTeamService"
    private val teamService: TeamService by lazy {
        NIMClient.getService(TeamService::class.java)
    }

    override val serviceName = "TeamService"

    init {
        registerFlutterMethodCalls(
            "createTeam" to ::createTeam,
            "queryTeamList" to ::queryTeamList,
            "queryTeam" to ::queryTeam,
            "searchTeam" to ::searchTeam,
            "dismissTeam" to ::dismissTeam,
            "applyJoinTeam" to ::applyJoinTeam,
            "passApply" to ::passApply,
            "rejectApply" to ::rejectApply,
            "addMembersEx" to ::addMembersEx,
            "acceptInvite" to ::acceptInvite,
            "declineInvite" to ::declineInvite,
            "getMemberInvitor" to ::getMemberInvitor,
            "removeMembers" to ::removeMembers,
            "quitTeam" to ::quitTeam,
            "queryMemberList" to ::queryMemberList,
            "queryTeamMember" to ::queryTeamMember,
            "updateMemberNick" to ::updateMemberNick,
            "transferTeam" to ::transferTeam,
            "addManagers" to ::addManagers,
            "removeManagers" to ::removeManagers,
            "muteTeamMember" to ::muteTeamMember,
            "muteAllTeamMember" to ::muteAllTeamMember,
            "queryMutedTeamMembers" to ::queryMutedTeamMembers,
            "updateTeam" to ::updateTeam,
            "updateTeamFields" to ::updateTeamFields,
            "muteTeam" to ::muteTeam,
            "searchTeamIdByName" to ::searchTeamIdByName,
            "searchTeamsByKeyword" to ::searchTeamsByKeyword,
            "updateMyMemberExtension" to ::updateMyMemberExtension,
            "updateMyTeamNick" to ::updateMyTeamNick
        )

        nimCore.onInitialized {
            observeTeamUpdateEvent()
            observeTeamRemoveEvent()
            observeTeamMemberUpdate()
            observeTeamMemberRemove()
        }
    }

    @ExperimentalCoroutinesApi
    private fun observeTeamUpdateEvent() {
        callbackFlow<List<Team>> {
            val observer = Observer<List<Team>> { event ->
                ALog.i(serviceName, "observeTeamUpdate: $event")
                trySend(event).onFailure {
                    ALog.i(serviceName, "send kick out event fail: ${it?.message}")
                }
            }
            NIMClient.getService(TeamServiceObserver::class.java).apply {
                observeTeamUpdate(observer, true)
                awaitClose {
                    observeTeamUpdate(observer, false)
                }
            }
        }.onEach { event ->
            notifyEvent(
                method = "onTeamListUpdate",
                arguments = hashMapOf(
                    "teamList" to event.map { it.toMap() }.toList()
                )
            )
        }.launchIn(nimCore.lifeCycleScope)
    }

    @ExperimentalCoroutinesApi
    private fun observeTeamRemoveEvent() {
        callbackFlow<Team> {
            val observer = Observer<Team> { event ->
                ALog.i(serviceName, "observeTeamUpdate: $event")
                trySend(event).onFailure {
                    ALog.i(serviceName, "send kick out event fail: ${it?.message}")
                }
            }
            NIMClient.getService(TeamServiceObserver::class.java).apply {
                observeTeamRemove(observer, true)
                awaitClose {
                    observeTeamRemove(observer, false)
                }
            }
        }.onEach { event ->
            notifyEvent(
                method = "onTeamListRemove",
                arguments = hashMapOf(
                    "team" to event.toMap()
                )
            )
        }.launchIn(nimCore.lifeCycleScope)
    }

    @ExperimentalCoroutinesApi
    private fun observeTeamMemberUpdate() {
        callbackFlow<List<TeamMember>> {
            val observer = Observer<List<TeamMember>> { event ->
                ALog.i(serviceName, "observeTeamMemberUpdate: $event")
                trySend(event).onFailure {
                    ALog.i(serviceName, "send kick out event fail: ${it?.message}")
                }
            }
            NIMClient.getService(TeamServiceObserver::class.java).apply {
                observeMemberUpdate(observer, true)
                awaitClose {
                    observeMemberUpdate(observer, false)
                }
            }
        }.onEach { event ->
            notifyEvent(
                method = "onTeamMemberUpdate",
                arguments = hashMapOf(
                    "teamMemberList" to event.map { it.toMap() }.toList()
                )
            )
        }.launchIn(nimCore.lifeCycleScope)
    }

    @ExperimentalCoroutinesApi
    private fun observeTeamMemberRemove() {
        callbackFlow<List<TeamMember>> {
            val observer = Observer<List<TeamMember>> { event ->
                ALog.i(serviceName, "observeTeamMemberRemove: $event")
                trySend(event).onFailure {
                    ALog.i(serviceName, "send kick out event fail: ${it?.message}")
                }
            }
            NIMClient.getService(TeamServiceObserver::class.java).apply {
                observeMemberRemove(observer, true)
                awaitClose {
                    observeMemberRemove(observer, false)
                }
            }
        }.onEach { event ->
            notifyEvent(
                method = "onTeamMemberRemove",
                arguments = hashMapOf(
                    "teamMemberList" to event.map { it.toMap() }.toList()
                )
            )
        }.launchIn(nimCore.lifeCycleScope)
    }

    private suspend fun createTeam(arguments: Map<String, *>): NimResult<CreateTeamResult> {
        val options = arguments["createTeamOptions"] as? Map<*, *>
        val newFields = mutableMapOf<TeamFieldEnum, Serializable>()
        var type = TeamTypeEnum.Normal
        var postscript: String? = null

        options?.filterValues { it != null }?.forEach {
            when (it.key) {
                "extensionUpdateMode" ->
                    newFields[TeamFieldEnum.TeamExtensionUpdateMode] =
                        stringToTeamExtensionUpdateModeEnumMap(it.value as String)
                "maxMemberCount" -> newFields[TeamFieldEnum.MaxMemberCount] = it.value as Int
                "verifyType" -> newFields[TeamFieldEnum.VerifyType] =
                    stringToVerifyTypeEnumMap(it.value as String)
                "inviteMode" -> newFields[TeamFieldEnum.InviteMode] =
                    stringToTeamInviteModeEnumMap(it.value as String)
                "beInviteMode" -> newFields[TeamFieldEnum.BeInviteMode] =
                    stringToTeamBeInviteModeEnumMap(it.value as String)
                "updateInfoMode" -> newFields[TeamFieldEnum.TeamUpdateMode] =
                    stringToTeamUpdateModeEnumMap(it.value as String)
                "avatarUrl" -> newFields[TeamFieldEnum.ICON] = it.value as String
                "name", "introduce", "announcement", "extension" ->
                    newFields[stringToTeamFieldEnumTypeMap(it.key as String)] = it.value as String
                "teamType" -> type = stringToTeamTypeEnumMap(it.value as String)
                "postscript" -> postscript = it.value as String
                else -> {
                    ALog.i(serviceName, "createTeam fields not found key: ${it.key}")
                }
            }
        }

        val members = arguments["members"] as? List<String>?
        return suspendCancellableCoroutine { cont ->
            teamService.run {
                ALog.i(serviceName, "createTeam fields newFields: $newFields ")
                createTeam(newFields, type, postscript, members)
                    .setCallback(object : RequestCallback<CreateTeamResult> {
                        override fun onSuccess(param: CreateTeamResult?) {
                            cont.resumeWith(
                                Result.success(
                                    NimResult(
                                        code = 0,
                                        data = param,
                                        convert = { it.toMap() }
                                    )
                                )
                            )
                        }

                        override fun onFailed(code: Int) =
                            cont.resumeWith(Result.success(NimResult(code = code)))

                        override fun onException(exception: Throwable?) =
                            cont.resumeWith(Result.success(NimResult.failure(exception)))
                    })
            }
        }
    }

    private suspend fun queryTeamList(arguments: Map<String, *>): NimResult<List<Team>?> {
        return suspendCancellableCoroutine { cont ->
            teamService.queryTeamList()
                .setCallback(object : RequestCallback<List<Team>?> {
                    override fun onSuccess(param: List<Team>?) =
                        cont.resumeWith(
                            Result.success(
                                NimResult(
                                    code = 0,
                                    data = param ?: listOf(),
                                    convert = {
                                        mapOf(
                                            "teamList" to it?.map { msg -> msg.toMap() }
                                                ?.toList()
                                        )
                                    }
                                )
                            )
                        )

                    override fun onFailed(code: Int) =
                        cont.resumeWith(Result.success(NimResult(code = code)))

                    override fun onException(exception: Throwable?) =
                        cont.resumeWith(Result.success(NimResult.failure(exception)))
                })
        }
    }

    private suspend fun queryTeam(arguments: Map<String, *>): NimResult<Team> {
        val teamId = arguments["teamId"] as? String
        return suspendCancellableCoroutine { cont ->
            teamService.queryTeam(teamId)
                .setCallback(object : RequestCallback<Team> {
                    override fun onSuccess(param: Team) =
                        cont.resumeWith(
                            Result.success(
                                NimResult(
                                    code = 0,
                                    data = param,
                                    convert = { it.toMap() }
                                )
                            )
                        )

                    override fun onFailed(code: Int) =
                        cont.resumeWith(Result.success(NimResult(code = code)))

                    override fun onException(exception: Throwable?) =
                        cont.resumeWith(Result.success(NimResult.failure(exception)))
                })
        }
    }

    private suspend fun searchTeam(arguments: Map<String, *>): NimResult<Team> {
        val teamId = arguments["teamId"] as? String
        return suspendCancellableCoroutine { cont ->
            teamService.searchTeam(teamId)
                .setCallback(object : RequestCallback<Team> {
                    override fun onSuccess(param: Team) =
                        cont.resumeWith(
                            Result.success(
                                NimResult(
                                    code = 0,
                                    data = param,
                                    convert = { it.toMap() }
                                )
                            )
                        )

                    override fun onFailed(code: Int) =
                        cont.resumeWith(Result.success(NimResult(code = code)))

                    override fun onException(exception: Throwable?) =
                        cont.resumeWith(Result.success(NimResult.failure(exception)))
                })
        }
    }

    private suspend fun dismissTeam(arguments: Map<String, *>): NimResult<Nothing> {
        val teamId = arguments["teamId"] as? String
        if (TextUtils.isEmpty(teamId)) {
            return NimResult(
                code = 414,
                errorDetails = "parameter is error"
            )
        }
        return suspendCancellableCoroutine { cont ->
            teamService.dismissTeam(teamId)
                .setCallback(NimResultContinuationCallbackOfNothing(cont))
        }
    }

    private suspend fun applyJoinTeam(arguments: Map<String, *>): NimResult<Team> {
        val teamId = arguments["teamId"] as? String
        val postscript = arguments["postscript"] as? String
        return suspendCancellableCoroutine { cont ->
            teamService.applyJoinTeam(teamId, postscript)
                .setCallback(
                    NimResultContinuationCallback(cont) { result ->
                        NimResult(
                            code = 0,
                            data = result,
                            convert = { it.toMap() }
                        )
                    }
                )
        }
    }

    private suspend fun passApply(arguments: Map<String, *>): NimResult<Nothing> {
        val teamId = arguments["teamId"] as? String
        val account = arguments["account"] as? String
        return suspendCancellableCoroutine { cont ->
            teamService.passApply(teamId, account)
                .setCallback(NimResultContinuationCallbackOfNothing(cont))
        }
    }

    private suspend fun rejectApply(arguments: Map<String, *>): NimResult<Nothing> {
        val teamId = arguments["teamId"] as? String
        val account = arguments["account"] as? String
        val reason = arguments["reason"] as? String
        return suspendCancellableCoroutine { cont ->
            teamService.rejectApply(teamId, account, reason)
                .setCallback(NimResultContinuationCallbackOfNothing(cont))
        }
    }

    private suspend fun addMembersEx(arguments: Map<String, *>): NimResult<List<String>?> {
        val teamId = arguments["teamId"] as? String
        val accounts = arguments["accounts"] as? List<String>
        val msg = arguments["msg"] as? String
        val customInfo = arguments["customInfo"] as? String
        return suspendCancellableCoroutine { cont ->
            teamService.addMembersEx(teamId, accounts, msg, customInfo)
                .setCallback(object : RequestCallback<List<String>?> {
                    override fun onSuccess(param: List<String>?) =
                        cont.resumeWith(
                            Result.success(
                                NimResult(
                                    code = 0,
                                    data = param ?: listOf(),
                                    convert = { mapOf("teamMemberExList" to it?.toList()) }
                                )
                            )
                        )

                    override fun onFailed(code: Int) =
                        cont.resumeWith(Result.success(NimResult(code = code)))

                    override fun onException(exception: Throwable?) =
                        cont.resumeWith(Result.success(NimResult.failure(exception)))
                })
        }
    }

    private suspend fun acceptInvite(arguments: Map<String, *>): NimResult<Nothing> {
        val teamId = arguments["teamId"] as? String
        val inviter = arguments["inviter"] as? String
        return suspendCancellableCoroutine { cont ->
            teamService.acceptInvite(teamId, inviter)
                .setCallback(NimResultContinuationCallbackOfNothing(cont))
        }
    }

    private suspend fun declineInvite(arguments: Map<String, *>): NimResult<Nothing> {
        val teamId = arguments["teamId"] as? String
        val inviter = arguments["inviter"] as? String
        val reason = arguments["reason"] as? String
        return suspendCancellableCoroutine { cont ->
            teamService.declineInvite(teamId, inviter, reason)
                .setCallback(NimResultContinuationCallbackOfNothing(cont))
        }
    }

    @Suppress("UNCHECKED_CAST")
    private suspend fun getMemberInvitor(arguments: Map<String, *>): NimResult<Map<String, String>> {
        val teamId = arguments["teamId"] as? String
        val accids = arguments["accids"] as? List<String>
        return suspendCancellableCoroutine { cont ->
            teamService.getMemberInvitor(teamId, accids)
                .setCallback(object : RequestCallback<Map<String, String>> {
                    override fun onSuccess(param: Map<String, String>) =
                        cont.resumeWith(Result.success(NimResult(code = 0, data = param)))

                    override fun onFailed(code: Int) =
                        cont.resumeWith(Result.success(NimResult(code = code)))

                    override fun onException(exception: Throwable?) =
                        cont.resumeWith(Result.success(NimResult.failure(exception)))
                })
        }
    }

    @Suppress("UNCHECKED_CAST")
    private suspend fun removeMembers(arguments: Map<String, *>): NimResult<Nothing> {
        val teamId = arguments["teamId"] as? String
        val members = arguments["members"] as? List<String>
        if (members.isNullOrEmpty() || TextUtils.isEmpty(teamId)) {
            return NimResult(
                code = 414,
                errorDetails = "parameter is error"
            )
        }
        return suspendCancellableCoroutine { cont ->
            teamService.removeMembers(teamId, members)
                .setCallback(NimResultContinuationCallbackOfNothing(cont))
        }
    }

    private suspend fun quitTeam(arguments: Map<String, *>): NimResult<Nothing> {
        val teamId = arguments["teamId"] as? String
        return suspendCancellableCoroutine { cont ->
            teamService.quitTeam(teamId)
                .setCallback(NimResultContinuationCallbackOfNothing(cont))
        }
    }

    private suspend fun queryMemberList(arguments: Map<String, *>): NimResult<List<TeamMember>?> {
        val teamId = arguments["teamId"] as? String
        if (teamId != null && teamId.length > 0) {
            return suspendCancellableCoroutine { cont ->
                teamService.queryMemberList(teamId)
                    .setCallback(object : RequestCallback<List<TeamMember>?> {
                        override fun onSuccess(param: List<TeamMember>?) =
                            cont.resumeWith(
                                Result.success(
                                    NimResult(
                                        code = 0,
                                        data = param ?: listOf(),
                                        convert = {
                                            mapOf(
                                                "teamMemberList" to it?.map { msg -> msg.toMap() }
                                                    ?.toList()
                                            )
                                        }
                                    )
                                )
                            )

                        override fun onFailed(code: Int) =
                            cont.resumeWith(Result.success(NimResult(code = code)))

                        override fun onException(exception: Throwable?) =
                            cont.resumeWith(Result.success(NimResult.failure(exception)))
                    })
            }
        }
        return NimResult(
            code = 414,
            errorDetails = "parameter is error"
        )
    }

    private suspend fun queryTeamMember(arguments: Map<String, *>): NimResult<TeamMember> {
        val teamId = arguments["teamId"] as? String
        val account = arguments["account"] as? String
        return suspendCancellableCoroutine { cont ->
            teamService.queryTeamMember(teamId, account)
                .setCallback(object : RequestCallback<TeamMember> {
                    override fun onSuccess(param: TeamMember?) =
                        cont.resumeWith(
                            Result.success(
                                NimResult(
                                    code = 0,
                                    data = param,
                                    convert = { it.toMap() }
                                )
                            )
                        )

                    override fun onFailed(code: Int) =
                        cont.resumeWith(Result.success(NimResult(code = code)))

                    override fun onException(exception: Throwable?) =
                        cont.resumeWith(Result.success(NimResult.failure(exception)))
                })
        }
    }

    private suspend fun updateMemberNick(arguments: Map<String, *>): NimResult<Nothing> {
        val teamId = arguments["teamId"] as? String
        val account = arguments["account"] as? String
        val nick = arguments["nick"] as? String
        return suspendCancellableCoroutine { cont ->
            teamService.updateMemberNick(teamId, account, nick)
                .setCallback(NimResultContinuationCallbackOfNothing(cont))
        }
    }

    private suspend fun transferTeam(arguments: Map<String, *>): NimResult<List<TeamMember>?> {
        val teamId = arguments["teamId"] as? String
        val account = arguments["account"] as? String
        val quit = arguments["quit"] as Boolean
        return suspendCancellableCoroutine { cont ->
            teamService.transferTeam(teamId, account, quit)
                .setCallback(object : RequestCallback<List<TeamMember>?> {
                    override fun onSuccess(param: List<TeamMember>?) =
                        cont.resumeWith(
                            Result.success(
                                NimResult(
                                    code = 0,
                                    data = param ?: listOf(),
                                    convert = {
                                        mapOf(
                                            "teamMemberList" to it?.map { msg -> msg.toMap() }
                                                ?.toList()
                                        )
                                    }
                                )
                            )
                        )

                    override fun onFailed(code: Int) =
                        cont.resumeWith(Result.success(NimResult(code = code)))

                    override fun onException(exception: Throwable?) =
                        cont.resumeWith(Result.success(NimResult.failure(exception)))
                })
        }
    }

    @Suppress("UNCHECKED_CAST")
    private suspend fun addManagers(arguments: Map<String, *>): NimResult<List<TeamMember>?> {
        val teamId = arguments["teamId"] as? String
        val accounts = arguments["accounts"] as? List<String>
        if (accounts.isNullOrEmpty() || TextUtils.isEmpty(teamId)) {
            return NimResult(
                code = 414,
                errorDetails = "parameter is error"
            )
        }
        return suspendCancellableCoroutine { cont ->
            teamService.addManagers(teamId, accounts)
                .setCallback(object : RequestCallback<List<TeamMember>?> {
                    override fun onSuccess(param: List<TeamMember>?) =
                        cont.resumeWith(
                            Result.success(
                                NimResult(
                                    code = 0,
                                    data = param ?: listOf(),
                                    convert = {
                                        mapOf(
                                            "teamMemberList" to it?.map { msg -> msg.toMap() }
                                                ?.toList()
                                        )
                                    }
                                )
                            )
                        )

                    override fun onFailed(code: Int) =
                        cont.resumeWith(Result.success(NimResult(code = code)))

                    override fun onException(exception: Throwable?) =
                        cont.resumeWith(Result.success(NimResult.failure(exception)))
                })
        }
    }

    @Suppress("UNCHECKED_CAST")
    private suspend fun removeManagers(arguments: Map<String, *>): NimResult<List<TeamMember>?> {
        val teamId = arguments["teamId"] as? String
        val accounts = arguments["managers"] as? List<String>
        if (accounts.isNullOrEmpty() || TextUtils.isEmpty(teamId)) {
            return NimResult(
                code = 414,
                errorDetails = "parameter is error"
            )
        }

        return suspendCancellableCoroutine { cont ->
            teamService.removeManagers(teamId, accounts)
                .setCallback(object : RequestCallback<List<TeamMember>?> {
                    override fun onSuccess(param: List<TeamMember>?) =
                        cont.resumeWith(
                            Result.success(
                                NimResult(
                                    code = 0,
                                    data = param ?: listOf(),
                                    convert = {
                                        mapOf(
                                            "teamMemberList" to it?.map { msg -> msg.toMap() }
                                                ?.toList()
                                        )
                                    }
                                )
                            )
                        )

                    override fun onFailed(code: Int) =
                        cont.resumeWith(Result.success(NimResult(code = code)))

                    override fun onException(exception: Throwable?) =
                        cont.resumeWith(Result.success(NimResult.failure(exception)))
                })
        }
    }

    private suspend fun muteTeamMember(arguments: Map<String, *>): NimResult<Nothing> {
        val teamId = arguments["teamId"] as? String
        val account = arguments["account"] as? String
        val mute = arguments["mute"] as Boolean
        return suspendCancellableCoroutine { cont ->
            teamService.muteTeamMember(teamId, account, mute)
                .setCallback(NimResultContinuationCallbackOfNothing(cont))
        }
    }

    private suspend fun muteAllTeamMember(arguments: Map<String, *>): NimResult<Nothing> {
        val teamId = arguments["teamId"] as? String
        val mute = arguments["mute"] as Boolean
        return suspendCancellableCoroutine { cont ->
            teamService.muteAllTeamMember(teamId, mute)
                .setCallback(NimResultContinuationCallbackOfNothing(cont))
        }
    }

    private suspend fun queryMutedTeamMembers(arguments: Map<String, *>): NimResult<List<TeamMember>?> {
        val teamId = arguments["teamId"] as? String
        return if (TextUtils.isEmpty(teamId)) {
            NimResult(code = 414, null, "parameter is error")
        } else {
            NimResult(
                code = 0,
                data = teamService.queryMutedTeamMembers(teamId),
                convert = {
                    mapOf(
                        "teamMemberList" to it
                            ?.map { msg -> msg.toMap() }?.toList()
                    )
                }
            )
        }
    }

    @Suppress("UNCHECKED_CAST")
    private suspend fun updateMyMemberExtension(arguments: Map<String, *>): NimResult<Nothing> {
        val teamId = arguments["teamId"] as? String
        val extension = arguments["extension"] as? Map<String, Any?>
        return suspendCancellableCoroutine { cont ->
            teamService.updateMyMemberExtension(teamId, extension)
                .setCallback(NimResultContinuationCallbackOfNothing(cont))
        }
    }

    private suspend fun updateTeam(arguments: Map<String, *>): NimResult<Nothing> {
        val teamId = arguments["teamId"] as? String
        val field = stringToTeamFieldEnumTypeMap(arguments["field"] as? String)
        val value = arguments["value"] as String
        return suspendCancellableCoroutine { cont ->
            teamService.updateTeam(teamId, field, value)
                .setCallback(NimResultContinuationCallbackOfNothing(cont))
        }
    }

    private suspend fun updateTeamFields(arguments: Map<String, *>): NimResult<Nothing> {
        val teamId = arguments["teamId"] as? String
        val request = arguments["request"] as Map<String, *>?
        val newFields = mutableMapOf<TeamFieldEnum, Serializable?>()
        request?.forEach { (key, value) ->
            if (key == "announcement" || key == "name" || key == "icon" || key == "introduce" ||
                key == "extension"
            ) {
                newFields[stringToTeamFieldEnumTypeMap(key)] = value as String?
            } else if (key == "verifyType") {
                newFields[TeamFieldEnum.VerifyType] = VerifyTypeEnum.typeOfValue(value as Int)
            } else if (key == "beInviteMode") {
                newFields[TeamFieldEnum.BeInviteMode] =
                    TeamBeInviteModeEnum.typeOfValue(value as Int)
            } else if (key == "inviteMode") {
                newFields[TeamFieldEnum.InviteMode] = TeamInviteModeEnum.typeOfValue(value as Int)
            } else if (key == "teamExtensionUpdateMode") {
                newFields[TeamFieldEnum.TeamExtensionUpdateMode] =
                    TeamExtensionUpdateModeEnum.typeOfValue(value as Int)
            } else if (key == "teamUpdateMode") {
                newFields[TeamFieldEnum.TeamUpdateMode] =
                    TeamUpdateModeEnum.typeOfValue(value as Int)
            } else if (key == "maxMemberCount") {
                newFields[TeamFieldEnum.MaxMemberCount] = value as Int
            }
        }
        if (request.isNullOrEmpty() || TextUtils.isEmpty(teamId) || newFields.isNullOrEmpty()) {
            return NimResult(code = 414, null, "parameter is error")
        }
        return suspendCancellableCoroutine { cont ->
            teamService.updateTeamFields(teamId, newFields)
                .setCallback(NimResultContinuationCallbackOfNothing(cont))
        }
    }

    private suspend fun muteTeam(arguments: Map<String, *>): NimResult<Nothing> {
        val teamId = arguments["teamId"] as? String
        val notifyType = when (arguments["notifyType"] as? String) {
            "manager" -> TeamMessageNotifyTypeEnum.Manager
            "mute" -> TeamMessageNotifyTypeEnum.Mute
            else -> TeamMessageNotifyTypeEnum.All
        }
        return suspendCancellableCoroutine { cont ->
            teamService.muteTeam(teamId, notifyType)
                .setCallback(NimResultContinuationCallbackOfNothing(cont))
        }
    }

    private suspend fun searchTeamIdByName(arguments: Map<String, *>): NimResult<List<String>?> {
        val name = arguments["name"] as? String
        return suspendCancellableCoroutine { cont ->
            teamService.searchTeamIdByName(name)
                .setCallback(object : RequestCallback<List<String>?> {
                    override fun onSuccess(param: List<String>?) =
                        cont.resumeWith(
                            Result.success(
                                NimResult(
                                    code = 0,
                                    data = param ?: listOf(),
                                    convert = { mapOf("teamNameList" to it?.toList()) }
                                )
                            )
                        )

                    override fun onFailed(code: Int) =
                        cont.resumeWith(Result.success(NimResult(code = code)))

                    override fun onException(exception: Throwable?) =
                        cont.resumeWith(Result.success(NimResult.failure(exception)))
                })
        }
    }

    private suspend fun searchTeamsByKeyword(arguments: Map<String, *>): NimResult<List<Team>?> {
        val keyword = arguments["keyword"] as? String
        return suspendCancellableCoroutine { cont ->
            teamService.searchTeamsByKeyword(keyword)
                .setCallback(object : RequestCallback<List<Team>?> {
                    override fun onSuccess(param: List<Team>?) =
                        cont.resumeWith(
                            Result.success(
                                NimResult(
                                    code = 0,
                                    data = param ?: listOf(),
                                    convert = {
                                        mapOf(
                                            "teamList" to it?.map { msg -> msg.toMap() }
                                                ?.toList()
                                        )
                                    }
                                )
                            )
                        )

                    override fun onFailed(code: Int) =
                        cont.resumeWith(Result.success(NimResult(code = code)))

                    override fun onException(exception: Throwable?) =
                        cont.resumeWith(Result.success(NimResult.failure(exception)))
                })
        }
    }

    private suspend fun updateMyTeamNick(arguments: Map<String, *>): NimResult<Nothing> {
        val teamId = arguments["teamId"] as? String
        val nick = arguments["nick"] as? String
        return suspendCancellableCoroutine { cont ->
            teamService.updateMyTeamNick(teamId, nick)
                .setCallback(NimResultContinuationCallbackOfNothing(cont))
        }
    }
}
