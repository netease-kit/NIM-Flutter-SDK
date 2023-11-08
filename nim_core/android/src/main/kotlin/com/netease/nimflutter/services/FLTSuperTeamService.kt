/*
 * Copyright (c) 2022 NetEase, Inc. All rights reserved.
 * Use of this source code is governed by a MIT license that can be
 * found in the LICENSE file.
 */

package com.netease.nimflutter.services

import android.content.Context
import com.netease.nimflutter.FLTService
import com.netease.nimflutter.NimCore
import com.netease.nimflutter.NimResult
import com.netease.nimflutter.NimResultContinuationCallback
import com.netease.nimflutter.NimResultContinuationCallbackOfNothing
import com.netease.nimflutter.stringToTeamFieldEnumTypeMap
import com.netease.nimflutter.stringToTeamMessageNotifyTypeEnumMap
import com.netease.nimflutter.toMap
import com.netease.nimlib.sdk.NIMClient
import com.netease.nimlib.sdk.Observer
import com.netease.nimlib.sdk.superteam.SuperTeam
import com.netease.nimlib.sdk.superteam.SuperTeamMember
import com.netease.nimlib.sdk.superteam.SuperTeamService
import com.netease.nimlib.sdk.superteam.SuperTeamServiceObserver
import com.netease.nimlib.sdk.team.constant.TeamBeInviteModeEnum
import com.netease.nimlib.sdk.team.constant.TeamExtensionUpdateModeEnum
import com.netease.nimlib.sdk.team.constant.TeamFieldEnum
import com.netease.nimlib.sdk.team.constant.TeamInviteModeEnum
import com.netease.nimlib.sdk.team.constant.TeamUpdateModeEnum
import com.netease.nimlib.sdk.team.constant.VerifyTypeEnum
import com.netease.yunxin.kit.alog.ALog
import java.io.Serializable
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.channels.awaitClose
import kotlinx.coroutines.channels.onFailure
import kotlinx.coroutines.flow.callbackFlow
import kotlinx.coroutines.flow.launchIn
import kotlinx.coroutines.flow.onEach
import kotlinx.coroutines.suspendCancellableCoroutine
import org.json.JSONObject

class FLTSuperTeamService(
    applicationContext: Context,
    nimCore: NimCore
) : FLTService(applicationContext, nimCore) {

    private val tag = "SuperTeamService"

    private val superTeamService: SuperTeamService by lazy {
        NIMClient.getService(SuperTeamService::class.java)
    }
    override val serviceName = "SuperTeamService"

    init {
        registerFlutterMethodCalls(
            "queryTeamList" to ::queryTeamList,
            "queryTeamListById" to ::queryTeamListById,
            "queryTeam" to ::queryTeam,
            "searchTeam" to ::searchTeam,
            "applyJoinTeam" to ::applyJoinTeam,
            "passApply" to ::passApply,
            "rejectApply" to ::rejectApply,
            "addMembers" to ::addMembers,
            "acceptInvite" to ::acceptInvite,
            "declineInvite" to ::declineInvite,
            "removeMembers" to ::removeMembers,
            "quitTeam" to ::quitTeam,
            "queryMemberList" to ::queryMemberList,
            "queryTeamMember" to ::queryTeamMember,
            "queryMemberListByPage" to ::queryMemberListByPage,
            "updateMemberNick" to ::updateMemberNick,
            "updateMyTeamNick" to ::updateMyTeamNick,
            "updateMyMemberExtension" to ::updateMyMemberExtension,
            "transferTeam" to ::transferTeam,
            "addManagers" to ::addManagers,
            "removeManagers" to ::removeManagers,
            "muteTeamMember" to ::muteTeamMember,
            "muteAllTeamMember" to ::muteAllTeamMember,
            "queryMutedTeamMembers" to ::queryMutedTeamMembers,
            "updateTeamFields" to ::updateTeamFields,
            "muteTeam" to ::muteTeam,
            "searchTeamIdByName" to ::searchTeamIdByName,
            "searchTeamsByKeyword" to ::searchTeamsByKeyword
        )

        nimCore.onInitialized {
            observeSuperTeamMemberUpdateEvent()
            observeSuperTeamMemberRemoveEvent()
            observeSuperTeamUpdateEvent()
            observeSuperTeamRemoveEvent()
        }
    }

    @ExperimentalCoroutinesApi
    private fun observeSuperTeamMemberUpdateEvent() {
        callbackFlow<List<SuperTeamMember>> {
            val observer = Observer<List<SuperTeamMember>> { event ->
                ALog.i(serviceName, "observeSuperTeamMemberUpdateEvent: $event")
                trySend(event).onFailure {
                    ALog.i(serviceName, "send kick out event fail: ${it?.message}")
                }
            }
            NIMClient.getService(SuperTeamServiceObserver::class.java).apply {
                observeMemberUpdate(observer, true)
                awaitClose {
                    observeMemberUpdate(observer, false)
                }
            }
        }.onEach { event ->
            notifyEvent(
                method = "onSuperTeamMemberUpdate",
                arguments = hashMapOf(
                    "teamMemberList" to event.map { it.toMap() }.toList()
                )
            )
        }.launchIn(nimCore.lifeCycleScope)
    }

    @ExperimentalCoroutinesApi
    private fun observeSuperTeamMemberRemoveEvent() {
        callbackFlow<List<SuperTeamMember>> {
            val observer = Observer<List<SuperTeamMember>> { event ->
                ALog.i(serviceName, "observeSuperTeamMemberRemoveEvent: $event")
                trySend(event).onFailure {
                    ALog.i(serviceName, "send kick out event fail: ${it?.message}")
                }
            }
            NIMClient.getService(SuperTeamServiceObserver::class.java).apply {
                observeMemberRemove(observer, true)
                awaitClose {
                    observeMemberRemove(observer, false)
                }
            }
        }.onEach { event ->
            notifyEvent(
                method = "onSuperTeamMemberRemove",
                arguments = hashMapOf(
                    "teamMemberList" to event.map { it.toMap() }.toList()
                )
            )
        }.launchIn(nimCore.lifeCycleScope)
    }

    @ExperimentalCoroutinesApi
    private fun observeSuperTeamUpdateEvent() {
        callbackFlow<List<SuperTeam>> {
            val observer = Observer<List<SuperTeam>> { event ->
                ALog.i(serviceName, "observeSuperTeamMemberRemoveEvent: $event")
                trySend(event).onFailure {
                    ALog.i(serviceName, "send kick out event fail: ${it?.message}")
                }
            }
            NIMClient.getService(SuperTeamServiceObserver::class.java).apply {
                observeTeamUpdate(observer, true)
                awaitClose {
                    observeTeamUpdate(observer, false)
                }
            }
        }.onEach { event ->
            notifyEvent(
                method = "onSuperTeamUpdate",
                arguments = hashMapOf(
                    "teamList" to event.map { it.toMap() }.toList()
                )
            )
        }.launchIn(nimCore.lifeCycleScope)
    }

    @ExperimentalCoroutinesApi
    private fun observeSuperTeamRemoveEvent() {
        callbackFlow<SuperTeam> {
            val observer = Observer<SuperTeam> { event ->
                ALog.i(serviceName, "observeSuperTeamMemberRemoveEvent: $event")
                trySend(event).onFailure {
                    ALog.i(serviceName, "send kick out event fail: ${it?.message}")
                }
            }
            NIMClient.getService(SuperTeamServiceObserver::class.java).apply {
                observeTeamRemove(observer, true)
                awaitClose {
                    observeTeamRemove(observer, false)
                }
            }
        }.onEach { event ->
            notifyEvent(
                method = "onSuperTeamRemove",
                arguments = hashMapOf(
                    "team" to event.toMap()
                )
            )
        }.launchIn(nimCore.lifeCycleScope)
    }

    private suspend fun queryTeamList(arguments: Map<String, *>): NimResult<List<SuperTeam>?> {
        return suspendCancellableCoroutine { cont ->
            superTeamService.queryTeamList()
                .setCallback(
                    NimResultContinuationCallback(cont) { result ->
                        NimResult(
                            code = 0,
                            data = result,
                            convert = { mapOf("teamList" to it?.map { msg -> msg.toMap() }?.toList()) }
                        )
                    }
                )
        }
    }

    private suspend fun queryTeamListById(arguments: Map<String, *>): NimResult<List<SuperTeam>?> {
        return suspendCancellableCoroutine { cont ->
            val teamIdList = arguments["teamIdList"] as List<String>
            superTeamService.queryTeamListById(teamIdList)
                .setCallback(
                    NimResultContinuationCallback(cont) { result ->
                        NimResult(
                            code = 0,
                            data = result,
                            convert = { mapOf("teamList" to it?.map { msg -> msg.toMap() }?.toList()) }
                        )
                    }
                )
        }
    }

    private suspend fun queryTeam(arguments: Map<String, *>): NimResult<SuperTeam> {
        val teamId = arguments["teamId"] as? String
        return suspendCancellableCoroutine { cont ->
            superTeamService.queryTeam(teamId)
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

    private suspend fun searchTeam(arguments: Map<String, *>): NimResult<SuperTeam> {
        val teamId = arguments["teamId"] as? String
        return suspendCancellableCoroutine { cont ->
            superTeamService.searchTeam(teamId)
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

    private suspend fun applyJoinTeam(arguments: Map<String, *>): NimResult<SuperTeam> {
        val teamId = arguments["teamId"] as? String
        val postscript = arguments["postscript"] as? String
        return suspendCancellableCoroutine { cont ->
            superTeamService.applyJoinTeam(teamId, postscript)
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
            superTeamService.passApply(teamId, account)
                .setCallback(NimResultContinuationCallbackOfNothing(cont))
        }
    }

    private suspend fun rejectApply(arguments: Map<String, *>): NimResult<Nothing> {
        val teamId = arguments["teamId"] as? String
        val account = arguments["account"] as? String
        val reason = arguments["reason"] as? String
        return suspendCancellableCoroutine { cont ->
            superTeamService.rejectApply(teamId, account, reason)
                .setCallback(NimResultContinuationCallbackOfNothing(cont))
        }
    }

    private suspend fun addMembers(arguments: Map<String, *>): NimResult<List<String>?> {
        val teamId = arguments["teamId"] as? String
        val accountList = arguments["accountList"] as? List<String>
        val msg = arguments["msg"] as? String
        return suspendCancellableCoroutine { cont ->
            superTeamService.addMembers(teamId, accountList, msg)
                .setCallback(
                    NimResultContinuationCallback(cont) { result ->
                        NimResult(
                            code = 0,
                            data = result,
                            convert = { mapOf("teamMemberList" to it?.toList()) }
                        )
                    }
                )
        }
    }

    private suspend fun acceptInvite(arguments: Map<String, *>): NimResult<Nothing> {
        val teamId = arguments["teamId"] as? String
        val inviter = arguments["inviter"] as? String
        return suspendCancellableCoroutine { cont ->
            superTeamService.acceptInvite(teamId, inviter)
                .setCallback(NimResultContinuationCallbackOfNothing(cont))
        }
    }

    private suspend fun declineInvite(arguments: Map<String, *>): NimResult<Nothing> {
        val teamId = arguments["teamId"] as? String
        val inviter = arguments["inviter"] as? String
        val reason = arguments["reason"] as? String
        return suspendCancellableCoroutine { cont ->
            superTeamService.declineInvite(teamId, inviter, reason)
                .setCallback(NimResultContinuationCallbackOfNothing(cont))
        }
    }

    @Suppress("UNCHECKED_CAST")
    private suspend fun removeMembers(arguments: Map<String, *>): NimResult<Nothing> {
        val teamId = arguments["teamId"] as? String
        val members = arguments["members"] as? List<String>
        return suspendCancellableCoroutine { cont ->
            superTeamService.removeMembers(teamId, members)
                .setCallback(NimResultContinuationCallbackOfNothing(cont))
        }
    }

    private suspend fun quitTeam(arguments: Map<String, *>): NimResult<Nothing> {
        val teamId = arguments["teamId"] as? String
        return suspendCancellableCoroutine { cont ->
            superTeamService.quitTeam(teamId)
                .setCallback(NimResultContinuationCallbackOfNothing(cont))
        }
    }

    private suspend fun queryMemberList(arguments: Map<String, *>): NimResult<List<SuperTeamMember>?> {
        val teamId = arguments["teamId"] as? String
        return suspendCancellableCoroutine { cont ->
            superTeamService.queryMemberList(teamId)
                .setCallback(
                    NimResultContinuationCallback(cont) { result ->
                        NimResult(
                            code = 0,
                            data = result,
                            convert = {
                                mapOf("teamMemberList" to it?.map { msg -> msg.toMap() }?.toList())
                            }
                        )
                    }
                )
        }
    }

    private suspend fun queryTeamMember(arguments: Map<String, *>): NimResult<SuperTeamMember> {
        val teamId = arguments["teamId"] as? String
        val account = arguments["account"] as? String
        return suspendCancellableCoroutine { cont ->
            superTeamService.queryTeamMember(teamId, account)
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

    private suspend fun queryMemberListByPage(arguments: Map<String, *>): NimResult<List<SuperTeamMember>> {
        val teamId = arguments["teamId"] as? String
        val offset = (arguments.getOrDefault("offset") { 0 } as Number).toInt()
        val limit = (arguments.getOrDefault("limit") { 0 } as Number).toInt()
        return suspendCancellableCoroutine { cont ->
            superTeamService.queryMemberListByPage(teamId, offset, limit)
                .setCallback(
                    NimResultContinuationCallback(cont) { result ->
                        NimResult(
                            code = 0,
                            data = result,
                            convert = {
                                mapOf(
                                    "teamMemberList" to it.map { msg -> msg.toMap() }
                                        .toList()
                                )
                            }
                        )
                    }
                )
        }
    }

    private suspend fun updateMemberNick(arguments: Map<String, *>): NimResult<Nothing> {
        val teamId = arguments["teamId"] as? String
        val account = arguments["account"] as? String
        val nick = arguments["nick"] as? String
        return suspendCancellableCoroutine { cont ->
            superTeamService.updateMemberNick(teamId, account, nick)
                .setCallback(NimResultContinuationCallbackOfNothing(cont))
        }
    }

    private suspend fun updateMyTeamNick(arguments: Map<String, *>): NimResult<Nothing> {
        val teamId = arguments["teamId"] as? String
        val nick = arguments["nick"] as? String
        return suspendCancellableCoroutine { cont ->
            superTeamService.updateMyTeamNick(teamId, nick)
                .setCallback(NimResultContinuationCallbackOfNothing(cont))
        }
    }

    @Suppress("UNCHECKED_CAST")
    private suspend fun updateMyMemberExtension(arguments: Map<String, *>): NimResult<Nothing> {
        val teamId = arguments["teamId"] as? String
        val extensionMap = arguments["extension"] as? Map<String, *>
        return suspendCancellableCoroutine { cont ->
            superTeamService.updateMyMemberExtension(
                teamId,
                extensionMap?.run {
                    var result: String? = null
                    try {
                        result = JSONObject(this).toString()
                    } catch (exception: Exception) {
                        exception.printStackTrace()
                    }
                    result
                }
            ).setCallback(NimResultContinuationCallbackOfNothing(cont))
        }
    }

    private suspend fun transferTeam(arguments: Map<String, *>): NimResult<List<SuperTeamMember>?> {
        val teamId = arguments["teamId"] as? String
        val account = arguments["account"] as? String
        val quit = arguments["quit"] as Boolean
        return suspendCancellableCoroutine { cont ->
            superTeamService.transferTeam(teamId, account, quit)
                .setCallback(
                    NimResultContinuationCallback(cont) { result ->
                        NimResult(
                            code = 0,
                            data = result,
                            convert = {
                                mapOf("teamMemberList" to it?.map { msg -> msg.toMap() }?.toList())
                            }
                        )
                    }
                )
        }
    }

    @Suppress("UNCHECKED_CAST")
    private suspend fun addManagers(arguments: Map<String, *>): NimResult<List<SuperTeamMember>?> {
        val teamId = arguments["teamId"] as? String
        val accountList = arguments["accountList"] as? List<String>
        return suspendCancellableCoroutine { cont ->
            superTeamService.addManagers(teamId, accountList)
                .setCallback(
                    NimResultContinuationCallback(cont) { result ->
                        NimResult(
                            code = 0,
                            data = result,
                            convert = {
                                mapOf("teamMemberList" to it?.map { msg -> msg.toMap() }?.toList())
                            }
                        )
                    }
                )
        }
    }

    @Suppress("UNCHECKED_CAST")
    private suspend fun removeManagers(arguments: Map<String, *>): NimResult<List<SuperTeamMember>?> {
        val teamId = arguments["teamId"] as? String
        val accountList = arguments["accountList"] as? List<String>
        return suspendCancellableCoroutine { cont ->
            superTeamService.removeManagers(teamId, accountList)
                .setCallback(
                    NimResultContinuationCallback(cont) { result ->
                        NimResult(
                            code = 0,
                            data = result,
                            convert = {
                                mapOf("teamMemberList" to it?.map { msg -> msg.toMap() }?.toList())
                            }
                        )
                    }
                )
        }
    }

    private suspend fun muteTeamMember(arguments: Map<String, *>): NimResult<Nothing> {
        val teamId = arguments["teamId"] as? String
        val accountList = arguments["accountList"] as? ArrayList<String>
        val mute = arguments["mute"] as Boolean
        return if (accountList?.isNotEmpty() == true) {
            suspendCancellableCoroutine { cont ->
                superTeamService.muteTeamMembers(teamId, accountList, mute)
                    .setCallback(NimResultContinuationCallbackOfNothing(cont))
            }
        } else {
            NimResult(code = 414, errorDetails = "error params")
        }
    }

    private suspend fun muteAllTeamMember(arguments: Map<String, *>): NimResult<Nothing> {
        val teamId = arguments["teamId"] as? String
        val mute = arguments["mute"] as Boolean
        return suspendCancellableCoroutine { cont ->
            superTeamService.muteAllTeamMember(teamId, mute)
                .setCallback(NimResultContinuationCallbackOfNothing(cont))
        }
    }

    private suspend fun queryMutedTeamMembers(arguments: Map<String, *>): NimResult<List<SuperTeamMember>?> {
        val teamId = arguments["teamId"] as? String
        return if (teamId.isNullOrEmpty()) {
            NimResult(code = -1, null)
        } else {
            val members = superTeamService.queryMutedTeamMembers(teamId)
            NimResult(
                code = 0,
                data = members,
                convert = {
                    mapOf(
                        "teamMemberList" to members
                            ?.map { msg -> msg.toMap() }?.toList()
                    )
                }
            )
        }
    }

    private suspend fun updateTeam(arguments: Map<String, *>): NimResult<Nothing> {
        val teamId = arguments["teamId"] as? String
        val field = stringToTeamFieldEnumTypeMap(arguments["field"] as? String)
        val value = arguments["value"] as String
        return suspendCancellableCoroutine { cont ->
            superTeamService.updateTeam(teamId, field, value)
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
        return suspendCancellableCoroutine { cont ->
            superTeamService.updateTeamFields(teamId, newFields)
                .setCallback(NimResultContinuationCallbackOfNothing(cont))
        }
    }

    private suspend fun muteTeam(arguments: Map<String, *>): NimResult<Nothing> {
        val teamId = arguments["teamId"] as? String
        val notifyType = stringToTeamMessageNotifyTypeEnumMap(arguments["notifyType"] as? String)
        return suspendCancellableCoroutine { cont ->
            superTeamService.muteTeam(teamId, notifyType)
                .setCallback(NimResultContinuationCallbackOfNothing(cont))
        }
    }

    private suspend fun searchTeamIdByName(arguments: Map<String, *>): NimResult<List<String>?> {
        val name = arguments["name"] as? String
        return suspendCancellableCoroutine { cont ->
            superTeamService.searchTeamIdByName(name)
                .setCallback(
                    NimResultContinuationCallback(cont) { result ->
                        NimResult(
                            code = 0,
                            data = result,
                            convert = { mapOf("teamNameList" to it?.toList()) }
                        )
                    }
                )
        }
    }

    private suspend fun searchTeamsByKeyword(arguments: Map<String, *>): NimResult<List<SuperTeam>?> {
        val keyword = arguments["keyword"] as? String
        return suspendCancellableCoroutine { cont ->
            superTeamService.searchTeamsByKeyword(keyword)
                .setCallback(
                    NimResultContinuationCallback(cont) { result ->
                        NimResult(
                            code = 0,
                            data = result,
                            convert = { mapOf("teamList" to it?.map { msg -> msg.toMap() }?.toList()) }
                        )
                    }
                )
        }
    }
}
