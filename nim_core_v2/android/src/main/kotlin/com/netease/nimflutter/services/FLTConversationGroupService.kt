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
import com.netease.nimflutter.extension.toMap
import com.netease.nimlib.sdk.NIMClient
import com.netease.nimlib.sdk.v2.conversation.V2NIMConversationGroupListener
import com.netease.nimlib.sdk.v2.conversation.V2NIMConversationGroupService
import com.netease.nimlib.sdk.v2.conversation.model.V2NIMConversation
import com.netease.nimlib.sdk.v2.conversation.model.V2NIMConversationGroup
import com.netease.yunxin.kit.alog.ALog
import kotlin.coroutines.resume
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.channels.awaitClose
import kotlinx.coroutines.channels.onFailure
import kotlinx.coroutines.flow.callbackFlow
import kotlinx.coroutines.flow.launchIn
import kotlinx.coroutines.flow.onEach
import kotlinx.coroutines.suspendCancellableCoroutine

class FLTConversationGroupService(
    applicationContext: Context,
    nimCore: NimCore
) : FLTService(applicationContext, nimCore) {
    private val tag = "FLTConversationGroupService"
    override val serviceName = "V2NIMConversationGroupService"

    init {
        nimCore.onInitialized {
            conversationGroupListener()
            registerFlutterMethodCalls(
                "createConversationGroup" to ::createConversationGroup,
                "deleteConversationGroup" to ::deleteConversationGroup,
                "updateConversationGroup" to ::updateConversationGroup,
                "addConversationsToGroup" to ::addConversationsToGroup,
                "removeConversationsFromGroup" to ::removeConversationsFromGroup,
                "getConversationGroup" to ::getConversationGroup,
                "getConversationGroupList" to ::getConversationGroupList,
                "getConversationGroupListByIds" to ::getConversationGroupListByIds
            )
        }
    }

    @ExperimentalCoroutinesApi
    private fun conversationGroupListener() {
        callbackFlow<Pair<String, Map<String, Any?>?>> {
            val listener = object : V2NIMConversationGroupListener {
                override fun onConversationGroupCreated(conversationGroup: V2NIMConversationGroup?) {
                    ALog.i(serviceName, "onConversationGroupCreated: ${conversationGroup?.name}")
                    trySend(
                        Pair<String, Map<String, Any?>?>(
                            "onConversationGroupCreated",
                            conversationGroup?.toMap()
                        )
                    ).onFailure {
                        ALog.i(serviceName, "send onConversationGroupCreated fail: ${it?.message}")
                    }
                }

                override fun onConversationGroupDeleted(groupId: String?) {
                    ALog.i(serviceName, "onConversationGroupDeleted: $groupId")
                    trySend(
                        Pair<String, Map<String, Any?>?>(
                            "onConversationGroupDeleted",
                            mapOf(
                                "groupId" to groupId
                            )
                        )
                    ).onFailure {
                        ALog.i(serviceName, "send onConversationGroupDeleted fail: ${it?.message}")
                    }
                }

                override fun onConversationGroupChanged(conversationGroup: V2NIMConversationGroup?) {
                    ALog.i(serviceName, "onConversationGroupChanged: ${conversationGroup?.name}")
                    trySend(
                        Pair<String, Map<String, Any?>?>(
                            "onConversationGroupChanged",
                            conversationGroup?.toMap()
                        )
                    ).onFailure {
                        ALog.i(serviceName, "send onConversationGroupChanged fail: ${it?.message}")
                    }
                }

                override fun onConversationsAddedToGroup(groupId: String?, conversations: MutableList<V2NIMConversation>?) {
                    ALog.i(serviceName, "onConversationsAddedToGroup: $conversations")
                    trySend(
                        Pair<String, Map<String, Any?>?>(
                            "onConversationsAddedToGroup",
                            mapOf(
                                "groupId" to groupId,
                                "conversations" to conversations?.map { it.toMap() }
                            )
                        )
                    ).onFailure {
                        ALog.i(serviceName, "send onConversationsAddedToGroup fail: ${it?.message}")
                    }
                }

                override fun onConversationsRemovedFromGroup(groupId: String?, conversationIds: MutableList<String>?) {
                    ALog.i(serviceName, "onConversationsRemovedFromGroup: $conversationIds")
                    trySend(
                        Pair<String, Map<String, Any?>?>(
                            "onConversationsRemovedFromGroup",
                            mapOf(
                                "groupId" to groupId,
                                "conversationIds" to conversationIds
                            )
                        )
                    ).onFailure {
                        ALog.i(serviceName, "send onConversationsRemovedFromGroup fail: ${it?.message}")
                    }
                }
            }

            NIMClient.getService(V2NIMConversationGroupService::class.java).apply {
                this.addConversationGroupListener(listener)
                awaitClose {
                    this.removeConversationGroupListener(listener)
                }
            }
        }.onEach { event ->
            notifyEvent(
                method = event.first,
                arguments = event.second as Map<String, Any?>
            )
        }.launchIn(nimCore.lifeCycleScope)
    }

    private suspend fun createConversationGroup(arguments: Map<String, *>): NimResult<Map<String, Any?>?> {
        return suspendCancellableCoroutine { cont ->
            val name = arguments["name"] as? String
            val serverExtension = arguments["serverExtension"] as? String
            val conversationIds = arguments["conversationIds"] as? List<String>

            if (name == null) {
                cont.resume(NimResult(code = FLTConstant.paramErrorCode, errorDetails = "createConversationGroup name is empty!"))
            } else {
                NIMClient.getService(V2NIMConversationGroupService::class.java)
                    .createConversationGroup(
                        name,
                        serverExtension,
                        conversationIds,
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
                                    NimResult(code = -1, errorDetails = "createConversationGroup failed!")
                                }
                            )
                        }
                    )
            }
        }
    }

    private suspend fun deleteConversationGroup(arguments: Map<String, *>): NimResult<Nothing> {
        return suspendCancellableCoroutine { cont ->
            val groupId = arguments["groupId"] as? String

            if (groupId == null) {
                cont.resume(NimResult(code = FLTConstant.paramErrorCode, errorDetails = "deleteConversationGroup groupId is empty!"))
            } else {
                NIMClient.getService(V2NIMConversationGroupService::class.java)
                    .deleteConversationGroup(
                        groupId,
                        {
                            cont.resume(
                                NimResult.SUCCESS
                            )
                        },
                        { error ->
                            cont.resume(
                                if (error != null) {
                                    NimResult(code = error.code, errorDetails = error.desc)
                                } else {
                                    NimResult(code = -1, errorDetails = "deleteConversationGroup failed!")
                                }
                            )
                        }
                    )
            }
        }
    }

    private suspend fun updateConversationGroup(arguments: Map<String, *>): NimResult<Nothing> {
        return suspendCancellableCoroutine { cont ->
            val groupId = arguments["groupId"] as? String
            val name = arguments["name"] as? String
            val serverExtension = arguments["serverExtension"] as? String
            if (groupId == null) {
                cont.resume(NimResult(code = FLTConstant.paramErrorCode, errorDetails = "updateConversationGroup groupId is empty!"))
            } else {
                NIMClient.getService(V2NIMConversationGroupService::class.java)
                    .updateConversationGroup(
                        groupId,
                        name,
                        serverExtension,
                        {
                            cont.resume(
                                NimResult.SUCCESS
                            )
                        },
                        { error ->
                            cont.resume(
                                if (error != null) {
                                    NimResult(code = error.code, errorDetails = error.desc)
                                } else {
                                    NimResult(code = -1, errorDetails = "createConversationGroup failed!")
                                }
                            )
                        }
                    )
            }
        }
    }

    private suspend fun addConversationsToGroup(arguments: Map<String, *>): NimResult<Map<String, Any?>?> {
        return suspendCancellableCoroutine { cont ->
            val groupId = arguments["groupId"] as? String
            val conversationIds = arguments["conversationIds"] as? List<String>

            if (groupId == null || conversationIds == null) {
                cont.resume(NimResult(code = FLTConstant.paramErrorCode, errorDetails = "addConversationsToGroup name or conversationIds is empty!"))
            } else {
                NIMClient.getService(V2NIMConversationGroupService::class.java)
                    .addConversationsToGroup(
                        groupId,
                        conversationIds,
                        { result ->
                            cont.resume(
                                NimResult(
                                    code = 0,
                                    data =
                                    mutableMapOf(
                                        "conversationOperationResults" to
                                            result.map { it.toMap() }
                                    )
                                )
                            )
                        },
                        { error ->
                            cont.resume(
                                if (error != null) {
                                    NimResult(code = error.code, errorDetails = error.desc)
                                } else {
                                    NimResult(code = -1, errorDetails = "addConversationsToGroup failed!")
                                }
                            )
                        }
                    )
            }
        }
    }

    private suspend fun removeConversationsFromGroup(arguments: Map<String, *>): NimResult<Map<String, Any?>?> {
        return suspendCancellableCoroutine { cont ->
            val groupId = arguments["groupId"] as? String
            val conversationIds = arguments["conversationIds"] as? List<String>

            if (groupId == null || conversationIds == null) {
                cont.resume(NimResult(code = FLTConstant.paramErrorCode, errorDetails = "removeConversationsFromGroup name or conversationIds is empty!"))
            } else {
                NIMClient.getService(V2NIMConversationGroupService::class.java)
                    .removeConversationsFromGroup(
                        groupId,
                        conversationIds,
                        { result ->
                            cont.resume(
                                NimResult(
                                    code = 0,
                                    data =
                                    mutableMapOf(
                                        "conversationOperationResults" to
                                            result.map { it.toMap() }
                                    )
                                )
                            )
                        },
                        { error ->
                            cont.resume(
                                if (error != null) {
                                    NimResult(code = error.code, errorDetails = error.desc)
                                } else {
                                    NimResult(code = -1, errorDetails = "removeConversationsFromGroup failed!")
                                }
                            )
                        }
                    )
            }
        }
    }

    private suspend fun getConversationGroup(arguments: Map<String, *>): NimResult<Map<String, Any?>?> {
        return suspendCancellableCoroutine { cont ->
            val groupId = arguments["groupId"] as? String

            if (groupId == null) {
                cont.resume(NimResult(code = FLTConstant.paramErrorCode, errorDetails = "getConversationGroup name is empty!"))
            } else {
                NIMClient.getService(V2NIMConversationGroupService::class.java)
                    .getConversationGroup(
                        groupId,
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
                                    NimResult(code = -1, errorDetails = "getConversationGroup failed!")
                                }
                            )
                        }
                    )
            }
        }
    }

    private suspend fun getConversationGroupList(arguments: Map<String, *>): NimResult<Map<String, Any?>?> {
        return suspendCancellableCoroutine { cont ->
            NIMClient.getService(V2NIMConversationGroupService::class.java)
                .getConversationGroupList(
                    { result ->
                        cont.resume(
                            NimResult(
                                code = 0,
                                data =
                                mutableMapOf(
                                    "conversationGroups" to result.map { it.toMap() }
                                )
                            )
                        )
                    },
                    { error ->
                        cont.resume(
                            if (error != null) {
                                NimResult(code = error.code, errorDetails = error.desc)
                            } else {
                                NimResult(code = -1, errorDetails = "getConversationGroupList failed!")
                            }
                        )
                    }
                )
        }
    }

    private suspend fun getConversationGroupListByIds(arguments: Map<String, *>): NimResult<Map<String, Any?>?> {
        return suspendCancellableCoroutine { cont ->

            val groupIds = arguments["groupIds"] as? List<String>

            if (groupIds == null) {
                cont.resume(NimResult(code = FLTConstant.paramErrorCode, errorDetails = "getConversationGroupListByIds groupIds is empty!"))
            } else {
                NIMClient.getService(V2NIMConversationGroupService::class.java)
                    .getConversationGroupListByIds(
                        groupIds,
                        { result ->
                            cont.resume(
                                NimResult(
                                    code = 0,
                                    data =
                                    mutableMapOf(
                                        "conversationGroups" to result.map { it.toMap() }
                                    )
                                )
                            )
                        },
                        { error ->
                            cont.resume(
                                if (error != null) {
                                    NimResult(code = error.code, errorDetails = error.desc)
                                } else {
                                    NimResult(code = -1, errorDetails = "getConversationGroupListByIds failed!")
                                }
                            )
                        }
                    )
            }
        }
    }
}
