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
import com.netease.nimflutter.toMap
import com.netease.nimflutter.toQChatAddChannelRoleParam
import com.netease.nimflutter.toQChatAddMemberRoleParam
import com.netease.nimflutter.toQChatAddMembersToServerRoleParam
import com.netease.nimflutter.toQChatCheckPermissionParam
import com.netease.nimflutter.toQChatCheckPermissionsParam
import com.netease.nimflutter.toQChatCreateServerRoleParam
import com.netease.nimflutter.toQChatDeleteServerRoleParam
import com.netease.nimflutter.toQChatGetChannelRolesParam
import com.netease.nimflutter.toQChatGetExistingAccidsInServerRoleParam
import com.netease.nimflutter.toQChatGetExistingAccidsOfMemberRolesParam
import com.netease.nimflutter.toQChatGetExistingChannelRolesByServerRoleIdsParam
import com.netease.nimflutter.toQChatGetExistingServerRolesByAccidsParam
import com.netease.nimflutter.toQChatGetMemberRolesParam
import com.netease.nimflutter.toQChatGetMembersFromServerRoleParam
import com.netease.nimflutter.toQChatGetServerRolesByAccidParam
import com.netease.nimflutter.toQChatGetServerRolesParam
import com.netease.nimflutter.toQChatRemoveChannelRoleParam
import com.netease.nimflutter.toQChatRemoveMemberRoleParam
import com.netease.nimflutter.toQChatRemoveMembersFromServerRoleParam
import com.netease.nimflutter.toQChatUpdateChannelRoleParam
import com.netease.nimflutter.toQChatUpdateMemberRoleParam
import com.netease.nimflutter.toQChatUpdateServerRoleParam
import com.netease.nimflutter.toQChatUpdateServerRolePrioritiesParam
import com.netease.nimlib.sdk.NIMClient
import com.netease.nimlib.sdk.qchat.QChatRoleService
import com.netease.nimlib.sdk.qchat.result.QChatAddChannelRoleResult
import com.netease.nimlib.sdk.qchat.result.QChatAddMemberRoleResult
import com.netease.nimlib.sdk.qchat.result.QChatAddMembersToServerRoleResult
import com.netease.nimlib.sdk.qchat.result.QChatCheckPermissionResult
import com.netease.nimlib.sdk.qchat.result.QChatCheckPermissionsResult
import com.netease.nimlib.sdk.qchat.result.QChatCreateServerRoleResult
import com.netease.nimlib.sdk.qchat.result.QChatGetChannelRolesResult
import com.netease.nimlib.sdk.qchat.result.QChatGetExistingAccidsInServerRoleResult
import com.netease.nimlib.sdk.qchat.result.QChatGetExistingAccidsOfMemberRolesResult
import com.netease.nimlib.sdk.qchat.result.QChatGetExistingChannelRolesByServerRoleIdsResult
import com.netease.nimlib.sdk.qchat.result.QChatGetExistingServerRolesByAccidsResult
import com.netease.nimlib.sdk.qchat.result.QChatGetMemberRolesResult
import com.netease.nimlib.sdk.qchat.result.QChatGetMembersFromServerRoleResult
import com.netease.nimlib.sdk.qchat.result.QChatGetServerRolesByAccidResult
import com.netease.nimlib.sdk.qchat.result.QChatGetServerRolesResult
import com.netease.nimlib.sdk.qchat.result.QChatRemoveMembersFromServerRoleResult
import com.netease.nimlib.sdk.qchat.result.QChatUpdateChannelRoleResult
import com.netease.nimlib.sdk.qchat.result.QChatUpdateMemberRoleResult
import com.netease.nimlib.sdk.qchat.result.QChatUpdateServerRolePrioritiesResult
import com.netease.nimlib.sdk.qchat.result.QChatUpdateServerRoleResult
import kotlinx.coroutines.suspendCancellableCoroutine

class FLTQChatRoleService(
    applicationContext: Context,
    nimCore: NimCore
) : FLTService(applicationContext, nimCore) {

    override val serviceName = "QChatRoleService"

    private val qChatRoleService: QChatRoleService by lazy {
        NIMClient.getService(QChatRoleService::class.java)
    }

    init {
        nimCore.onInitialized {
            registerFlutterMethodCalls(
                "createServerRole" to ::createServerRole,
                "deleteServerRole" to ::deleteServerRole,
                "updateServerRole" to ::updateServerRole,
                "updateServerRolePriorities" to ::updateServerRolePriorities,
                "getServerRoles" to ::getServerRoles,
                "addChannelRole" to ::addChannelRole,
                "removeChannelRole" to ::removeChannelRole,
                "updateChannelRole" to ::updateChannelRole,
                "getChannelRoles" to ::getChannelRoles,
                "addMembersToServerRole" to ::addMembersToServerRole,
                "removeMembersFromServerRole" to ::removeMembersFromServerRole,
                "getMembersFromServerRole" to ::getMembersFromServerRole,
                "getServerRolesByAccid" to ::getServerRolesByAccid,
                "getExistingServerRolesByAccids" to ::getExistingServerRolesByAccids,
                "getExistingAccidsInServerRole" to ::getExistingAccidsInServerRole,
                "getExistingChannelRolesByServerRoleIds" to ::getExistingChannelRolesByServerRoleIds,
                "getExistingAccidsOfMemberRoles" to ::getExistingAccidsOfMemberRoles,
                "addMemberRole" to ::addMemberRole,
                "removeMemberRole" to ::removeMemberRole,
                "updateMemberRole" to ::updateMemberRole,
                "getMemberRoles" to ::getMemberRoles,
                "checkPermission" to ::checkPermission,
                "checkPermissions" to ::checkPermissions
            )
        }
    }

    private suspend fun createServerRole(arguments: Map<String, *>): NimResult<QChatCreateServerRoleResult> {
        return suspendCancellableCoroutine { cont ->
            qChatRoleService.createServerRole(
                arguments.toQChatCreateServerRoleParam()
            ).setCallback(
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

    private suspend fun deleteServerRole(arguments: Map<String, *>): NimResult<Nothing> {
        return suspendCancellableCoroutine { cont ->
            qChatRoleService.deleteServerRole(
                arguments.toQChatDeleteServerRoleParam()
            ).setCallback(
                NimResultContinuationCallbackOfNothing(cont)
            )
        }
    }

    private suspend fun updateServerRole(arguments: Map<String, *>): NimResult<QChatUpdateServerRoleResult> {
        return suspendCancellableCoroutine { cont ->
            qChatRoleService.updateServerRole(
                arguments.toQChatUpdateServerRoleParam()
            ).setCallback(
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

    private suspend fun updateServerRolePriorities(arguments: Map<String, *>): NimResult<QChatUpdateServerRolePrioritiesResult> {
        return suspendCancellableCoroutine { cont ->
            qChatRoleService.updateServerRolePriorities(
                arguments.toQChatUpdateServerRolePrioritiesParam()
            ).setCallback(
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

    private suspend fun getServerRoles(arguments: Map<String, *>): NimResult<QChatGetServerRolesResult> {
        return suspendCancellableCoroutine { cont ->
            qChatRoleService.getServerRoles(
                arguments.toQChatGetServerRolesParam()
            ).setCallback(
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

    private suspend fun addChannelRole(arguments: Map<String, *>): NimResult<QChatAddChannelRoleResult> {
        return suspendCancellableCoroutine { cont ->
            qChatRoleService.addChannelRole(
                arguments.toQChatAddChannelRoleParam()
            ).setCallback(
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

    private suspend fun removeChannelRole(arguments: Map<String, *>): NimResult<Nothing> {
        return suspendCancellableCoroutine { cont ->
            qChatRoleService.removeChannelRole(
                arguments.toQChatRemoveChannelRoleParam()
            ).setCallback(
                NimResultContinuationCallbackOfNothing(cont)
            )
        }
    }

    private suspend fun updateChannelRole(arguments: Map<String, *>): NimResult<QChatUpdateChannelRoleResult> {
        return suspendCancellableCoroutine { cont ->
            qChatRoleService.updateChannelRole(
                arguments.toQChatUpdateChannelRoleParam()
            ).setCallback(
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

    private suspend fun getChannelRoles(arguments: Map<String, *>): NimResult<QChatGetChannelRolesResult> {
        return suspendCancellableCoroutine { cont ->
            qChatRoleService.getChannelRoles(
                arguments.toQChatGetChannelRolesParam()
            ).setCallback(
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

    private suspend fun addMembersToServerRole(arguments: Map<String, *>): NimResult<QChatAddMembersToServerRoleResult> {
        return suspendCancellableCoroutine { cont ->
            qChatRoleService.addMembersToServerRole(
                arguments.toQChatAddMembersToServerRoleParam()
            ).setCallback(
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

    private suspend fun removeMembersFromServerRole(arguments: Map<String, *>): NimResult<QChatRemoveMembersFromServerRoleResult> {
        return suspendCancellableCoroutine { cont ->
            qChatRoleService.removeMembersFromServerRole(
                arguments.toQChatRemoveMembersFromServerRoleParam()
            ).setCallback(
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

    private suspend fun getMembersFromServerRole(arguments: Map<String, *>): NimResult<QChatGetMembersFromServerRoleResult> {
        return suspendCancellableCoroutine { cont ->
            qChatRoleService.getMembersFromServerRole(
                arguments.toQChatGetMembersFromServerRoleParam()
            ).setCallback(
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

    private suspend fun getServerRolesByAccid(arguments: Map<String, *>): NimResult<QChatGetServerRolesByAccidResult> {
        return suspendCancellableCoroutine { cont ->
            qChatRoleService.getServerRolesByAccid(
                arguments.toQChatGetServerRolesByAccidParam()
            ).setCallback(
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

    private suspend fun getExistingServerRolesByAccids(arguments: Map<String, *>): NimResult<QChatGetExistingServerRolesByAccidsResult> {
        return suspendCancellableCoroutine { cont ->
            qChatRoleService.getExistingServerRolesByAccids(
                arguments.toQChatGetExistingServerRolesByAccidsParam()
            ).setCallback(
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

    private suspend fun getExistingAccidsInServerRole(arguments: Map<String, *>): NimResult<QChatGetExistingAccidsInServerRoleResult> {
        return suspendCancellableCoroutine { cont ->
            qChatRoleService.getExistingAccidsInServerRole(
                arguments.toQChatGetExistingAccidsInServerRoleParam()
            ).setCallback(
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

    private suspend fun getExistingChannelRolesByServerRoleIds(arguments: Map<String, *>): NimResult<QChatGetExistingChannelRolesByServerRoleIdsResult> {
        return suspendCancellableCoroutine { cont ->
            qChatRoleService.getExistingChannelRolesByServerRoleIds(
                arguments.toQChatGetExistingChannelRolesByServerRoleIdsParam()
            ).setCallback(
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

    private suspend fun getExistingAccidsOfMemberRoles(arguments: Map<String, *>): NimResult<QChatGetExistingAccidsOfMemberRolesResult> {
        return suspendCancellableCoroutine { cont ->
            qChatRoleService.getExistingAccidsOfMemberRoles(
                arguments.toQChatGetExistingAccidsOfMemberRolesParam()
            ).setCallback(
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

    private suspend fun addMemberRole(arguments: Map<String, *>): NimResult<QChatAddMemberRoleResult> {
        return suspendCancellableCoroutine { cont ->
            qChatRoleService.addMemberRole(
                arguments.toQChatAddMemberRoleParam()
            ).setCallback(
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
    private suspend fun removeMemberRole(arguments: Map<String, *>): NimResult<Nothing> {
        return suspendCancellableCoroutine { cont ->
            qChatRoleService.removeMemberRole(
                arguments.toQChatRemoveMemberRoleParam()
            ).setCallback(
                NimResultContinuationCallbackOfNothing(cont)
            )
        }
    }
    private suspend fun updateMemberRole(arguments: Map<String, *>): NimResult<QChatUpdateMemberRoleResult> {
        return suspendCancellableCoroutine { cont ->
            qChatRoleService.updateMemberRole(
                arguments.toQChatUpdateMemberRoleParam()
            ).setCallback(
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
    private suspend fun getMemberRoles(arguments: Map<String, *>): NimResult<QChatGetMemberRolesResult> {
        return suspendCancellableCoroutine { cont ->
            qChatRoleService.getMemberRoles(
                arguments.toQChatGetMemberRolesParam()
            ).setCallback(
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
    private suspend fun checkPermission(arguments: Map<String, *>): NimResult<QChatCheckPermissionResult> {
        return suspendCancellableCoroutine { cont ->
            qChatRoleService.checkPermission(
                arguments.toQChatCheckPermissionParam()
            ).setCallback(
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

    private suspend fun checkPermissions(arguments: Map<String, *>): NimResult<QChatCheckPermissionsResult> {
        return suspendCancellableCoroutine { cont ->
            qChatRoleService.checkPermissions(
                arguments.toQChatCheckPermissionsParam()
            ).setCallback(
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
}
