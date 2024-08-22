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
import com.netease.nimflutter.convertV2NIMConversationUpdate
import com.netease.nimflutter.toMap
import com.netease.nimlib.sdk.NIMClient
import com.netease.nimlib.sdk.v2.V2NIMError
import com.netease.nimlib.sdk.v2.conversation.V2NIMConversationListener
import com.netease.nimlib.sdk.v2.conversation.V2NIMConversationService
import com.netease.nimlib.sdk.v2.conversation.enums.V2NIMConversationType
import com.netease.nimlib.sdk.v2.conversation.model.V2NIMConversation
import com.netease.nimlib.sdk.v2.conversation.option.V2NIMConversationOption
import com.netease.nimlib.sdk.v2.conversation.params.V2NIMConversationFilter
import com.netease.yunxin.kit.alog.ALog
import kotlin.coroutines.resume
import kotlinx.coroutines.suspendCancellableCoroutine

class FLTConversationService(
    applicationContext: Context,
    nimCore: NimCore
) : FLTService(applicationContext, nimCore) {
    private val tag = "FLTConversationService"
    override val serviceName = "ConversationService"

    init {
        nimCore.onInitialized {
            NIMClient.getService(V2NIMConversationService::class.java)
                .addConversationListener(conversationListener)
        }

        registerFlutterMethodCalls(
            "getConversationList" to ::getConversationList,
            // 根据查询参数获取会话列表
            "getConversationListByOption" to ::getConversationListByOption,
            // 获取会话列表，通过会话id
            "getConversation" to ::getConversation,
            // 根据会话id获取会话列表
            "getConversationListByIds" to ::getConversationListByIds,
            // 创建会话
            "createConversation" to ::createConversation,
            // 删除会话
            "deleteConversation" to ::deleteConversation,
            // 删除会话列表
            "deleteConversationListByIds" to ::deleteConversationListByIds,
            // 置顶会话
            "stickTopConversation" to ::stickTopConversation,
            // 更新会话
            "updateConversation" to ::updateConversation,
            // 更新会话本地扩展字段
            "updateConversationLocalExtension" to ::updateConversationLocalExtension,
            // 获取会话总未读数
            "getTotalUnreadCount" to ::getTotalUnreadCount,
            // 根据会话id获取会话未读数
            "getUnreadCountByIds" to ::getUnreadCountByIds,
            // 根据过滤条件获取相应的未读数
            "getUnreadCountByFilter" to ::getUnreadCountByFilter,
            // 清空会话未读数
            "clearTotalUnreadCount" to ::clearTotalUnreadCount,
            // 根据会话id清空会话未读数
            "clearUnreadCountByIds" to ::clearUnreadCountByIds,
            // 根据会话分组清空相应会话的未读数
            "clearUnreadCountByGroupId" to ::clearUnreadCountByGroupId,
            // 根据会话id清空会话未读数
            "clearUnreadCountByTypes" to ::clearUnreadCountByTypes,
            // 订阅指定过滤条件的会话未读数
            "subscribeUnreadCountByFilter" to ::subscribeUnreadCountByFilter,
            // 取消订阅指定过滤条件的会话未读数
            "unsubscribeUnreadCountByFilter" to ::unsubscribeUnreadCountByFilter,
            // 获取会话已读时间戳
            "getConversationReadTime" to ::getConversationReadTime,
            // 标记会话已读时间戳
            "markConversationRead" to ::markConversationRead
        )
    }

    /**
     * 获取会话列表
     * Params:
     * offset – 分页偏移，首次传0，后续拉取采用上一次返回的offset
     * limit – 分页拉取数量，不建议超过100;
     */
    private suspend fun getConversationList(
        arguments: Map<String, *>
    ): NimResult<Map<String, Any?>?> {
        return suspendCancellableCoroutine { cont ->
            val offset =
                if (arguments["offset"] as? Long == null) 0 else arguments["offset"] as Long
            val limit = if (arguments["limit"] as? Int == null) 100 else arguments["limit"] as Int
            NIMClient.getService(V2NIMConversationService::class.java)
                .getConversationList(
                    offset,
                    limit,
                    { result ->
                        cont.resume(
                            NimResult(
                                code = 0,
                                data =
                                mutableMapOf(
                                    "conversationList" to
                                        result.conversationList.map { it.toMap() }
                                            .toList(),
                                    "offset" to result.offset,
                                    "finished" to result.isFinished
                                )
                            )
                        )
                    },
                    { error ->
                        cont.resume(
                            if (error != null) {
                                NimResult(code = error.code, errorDetails = error.desc)
                            } else {
                                NimResult(code = -1, errorDetails = "getConversationList failed!")
                            }
                        )
                    }
                )
        }
    }

    /**
     * 根据查询参数获取会话列表
     * Params:
     * offset – 分页偏移，首次传0，后续拉取采用上一次返回的offset
     * limit – 分页拉取数量，不建议超过100;
     * option – 查询选项 success – 成功回调 failure – 失败回调
     */
    private suspend fun getConversationListByOption(
        arguments: Map<String, *>
    ): NimResult<Map<String, Any?>?> {
        return suspendCancellableCoroutine { cont ->
            val offset =
                if (arguments["offset"] as? Long == null) 0 else arguments["offset"] as Long
            val limit = if (arguments["limit"] as? Int == null) 100 else arguments["limit"] as Int
            val option = arguments["option"] as? Map<String, *>
            var conversationOption: V2NIMConversationOption? = null
            if (option != null) {
                conversationOption = createConversationOptionFromMap(option)
            }

            NIMClient.getService(V2NIMConversationService::class.java)
                .getConversationListByOption(
                    offset,
                    limit,
                    conversationOption,
                    { result ->
                        cont.resume(
                            NimResult(
                                code = 0,
                                data =
                                mutableMapOf(
                                    "conversationList" to
                                        result.conversationList.map { it.toMap() }
                                            .toList(),
                                    "offset" to result.offset,
                                    "finished" to result.isFinished
                                )
                            )
                        )
                    },
                    { error ->
                        cont.resume(
                            if (error != null) {
                                NimResult(code = error.code, errorDetails = error.desc)
                            } else {
                                NimResult(
                                    code = -1,
                                    errorDetails = "getConversationListByOption failed!"
                                )
                            }
                        )
                    }
                )
        }
    }

    /**
     * 获取会话列表，通过会话id
     * Params:
     * conversationId – 会话id
     */
    private suspend fun getConversation(arguments: Map<String, *>): NimResult<Map<String, Any?>?> {
        return suspendCancellableCoroutine { cont ->
            val conversationId = arguments["conversationId"] as? String
            if (conversationId == null) {
                cont.resume(
                    NimResult(
                        code = FLTConstant.paramErrorCode,
                        errorDetails = "getConversation param is null"
                    )
                )
            } else {
                NIMClient.getService(V2NIMConversationService::class.java)
                    .getConversation(
                        conversationId,
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
                                    NimResult(code = -1, errorDetails = "getConversation failed!")
                                }
                            )
                        }
                    )
            }
        }
    }

    /**
     * 根据会话id获取会话列表
     * Params:
     * conversationIds – 会话id列表
     */
    private suspend fun getConversationListByIds(
        arguments: Map<String, *>
    ): NimResult<
        Map<
            String,
            Any?
            >?
        > {
        return suspendCancellableCoroutine { cont ->
            val conversationIds = arguments["conversationIdList"] as? List<String>
            if (conversationIds == null) {
                cont.resume(
                    NimResult(
                        code = FLTConstant.paramErrorCode,
                        errorDetails = "getConversationListByIds param is null"
                    )
                )
            } else {
                NIMClient.getService(V2NIMConversationService::class.java)
                    .getConversationListByIds(
                        conversationIds,
                        { result ->
                            cont.resume(
                                NimResult(
                                    code = 0,
                                    data =
                                    mutableMapOf(
                                        "conversationList" to
                                            result.map { it?.toMap() }
                                                .toList()
                                    )
                                )
                            )
                        },
                        { error ->
                            cont.resume(
                                if (error != null) {
                                    NimResult(code = error.code, errorDetails = error.desc)
                                } else {
                                    NimResult(
                                        code = -1,
                                        errorDetails = "getConversationListByIds failed!"
                                    )
                                }
                            )
                        }
                    )
            }
        }
    }

    /**
     * 创建会话
     * Params:
     * conversationId – 会话id
     */
    private suspend fun createConversation(arguments: Map<String, *>): NimResult<Map<String, Any?>?> {
        return suspendCancellableCoroutine { cont ->
            val conversationId = arguments["conversationId"] as? String
            if (conversationId == null) {
                cont.resume(
                    NimResult(
                        code = FLTConstant.paramErrorCode,
                        errorDetails = "createConversation param is null"
                    )
                )
            } else {
                NIMClient.getService(V2NIMConversationService::class.java)
                    .createConversation(
                        conversationId,
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
                                    NimResult(code = -1, errorDetails = "createConversation failed!")
                                }
                            )
                        }
                    )
            }
        }
    }

    /**
     * 删除会话
     * Params:
     * conversationId – 会话id
     */
    private suspend fun deleteConversation(arguments: Map<String, *>): NimResult<Nothing> {
        return suspendCancellableCoroutine { cont ->
            val conversationId = arguments["conversationId"] as? String
            val clearMsg =
                if (arguments["clearMessage"] as? Boolean == null) false else arguments["clearMessage"] as Boolean
            if (conversationId == null) {
                cont.resume(
                    NimResult(
                        code = FLTConstant.paramErrorCode,
                        errorDetails = "deleteConversation param is null"
                    )
                )
            } else {
                NIMClient.getService(V2NIMConversationService::class.java)
                    .deleteConversation(
                        conversationId,
                        clearMsg,
                        {
                            cont.resume(NimResult.SUCCESS)
                        },
                        { error ->
                            cont.resume(
                                if (error != null) {
                                    NimResult(code = error.code, errorDetails = error.desc)
                                } else {
                                    NimResult(code = -1, errorDetails = "deleteConversation failed!")
                                }
                            )
                        }
                    )
            }
        }
    }

    /**
     * 删除会话列表
     * Params:
     * conversationIds – 会话id列表
     */
    private suspend fun deleteConversationListByIds(
        arguments: Map<String, *>
    ): NimResult<Map<String, Any?>?> {
        return suspendCancellableCoroutine { cont ->
            val conversationIdList = arguments["conversationIdList"] as List<String>?
            val clearMsg =
                if (arguments["clearMessage"] as? Boolean == null) false else arguments["clearMessage"] as Boolean
            if (conversationIdList == null) {
                cont.resume(
                    NimResult(
                        code = FLTConstant.paramErrorCode,
                        errorDetails = "deleteConversationListByIds param is null"
                    )
                )
            } else {
                NIMClient.getService(V2NIMConversationService::class.java)
                    .deleteConversationListByIds(
                        conversationIdList,
                        clearMsg,
                        { result ->
                            cont.resume(
                                NimResult(
                                    code = 0,
                                    data =
                                    mutableMapOf(
                                        "conversationOperationResult" to
                                            result.map {
                                                mutableMapOf(
                                                    "conversationId" to it.conversationId,
                                                    "error" to
                                                        it.error.detail
                                                )
                                            }.toList()
                                    )
                                )
                            )
                        },
                        { error ->
                            cont.resume(
                                if (error != null) {
                                    NimResult(code = error.code, errorDetails = error.desc)
                                } else {
                                    NimResult(
                                        code = -1,
                                        errorDetails = "deleteConversationListByIds failed!"
                                    )
                                }
                            )
                        }
                    )
            }
        }
    }

    /**
     * 删除会话
     * Params:
     * conversationId – 会话id
     */
    private suspend fun stickTopConversation(
        arguments: Map<String, *>
    ): NimResult<Nothing> {
        return suspendCancellableCoroutine { cont ->
            val conversationId = arguments["conversationId"] as? String
            val stickTop = arguments["stickTop"] as? Boolean
            if (conversationId == null || stickTop == null) {
                cont.resume(
                    NimResult(
                        code = FLTConstant.paramErrorCode,
                        errorDetails = "stickTopConversation param is null"
                    )
                )
            } else {
                NIMClient.getService(V2NIMConversationService::class.java)
                    .stickTopConversation(
                        conversationId,
                        stickTop,
                        {
                            cont.resume(NimResult.SUCCESS)
                        },
                        { error ->
                            cont.resume(
                                if (error != null) {
                                    NimResult(code = error.code, errorDetails = error.desc)
                                } else {
                                    NimResult(code = -1, errorDetails = "stickTopConversation failed!")
                                }
                            )
                        }
                    )
            }
        }
    }

    /**
     * 更新会话
     * Params:
     * conversationId – 会话id
     */
    private suspend fun updateConversation(
        arguments: Map<String, *>
    ): NimResult<Nothing> {
        return suspendCancellableCoroutine { cont ->
            val conversationId = arguments["conversationId"] as? String
            val serverExtension = arguments["updateInfo"] as? Map<String, Any?>
            if (conversationId == null) {
                cont.resume(
                    NimResult(
                        code = FLTConstant.paramErrorCode,
                        errorDetails = "updateConversation param is null"
                    )
                )
            } else {
                val update = convertV2NIMConversationUpdate(serverExtension)
                NIMClient.getService(V2NIMConversationService::class.java)
                    .updateConversation(
                        conversationId,
                        update,
                        {
                            cont.resume(NimResult.SUCCESS)
                        },
                        { error ->
                            cont.resume(
                                if (error != null) {
                                    NimResult(code = error.code, errorDetails = error.desc)
                                } else {
                                    NimResult(code = -1, errorDetails = "updateConversation failed!")
                                }
                            )
                        }
                    )
            }
        }
    }

    /**
     * 更新会话本地扩展字段
     * Params:
     * conversationId – 会话id
     */
    private suspend fun updateConversationLocalExtension(
        arguments: Map<String, *>
    ): NimResult<Nothing> {
        return suspendCancellableCoroutine { cont ->
            val conversationId = arguments["conversationId"] as? String
            val localExtension = arguments["localExtension"] as? String
            if (conversationId == null) {
                cont.resume(
                    NimResult(
                        code = FLTConstant.paramErrorCode,
                        errorDetails = "updateConversationLocalExtension param is null"
                    )
                )
            } else {
                NIMClient.getService(V2NIMConversationService::class.java)
                    .updateConversationLocalExtension(
                        conversationId,
                        localExtension,
                        {
                            cont.resume(NimResult.SUCCESS)
                        },
                        { error ->
                            cont.resume(
                                if (error != null) {
                                    NimResult(code = error.code, errorDetails = error.desc)
                                } else {
                                    NimResult(
                                        code = -1,
                                        errorDetails = "updateConversationLocalExtension failed!"
                                    )
                                }
                            )
                        }
                    )
            }
        }
    }

    /**
     * 获取会话总未读数
     * Returns:会话总未读数
     */
    private suspend fun getTotalUnreadCount(arguments: Map<String, *>): NimResult<Int?> {
        val unreadCount =
            NIMClient.getService(V2NIMConversationService::class.java)
                .totalUnreadCount
        return NimResult(code = 0, data = unreadCount)
    }

    /**
     * 根据会话id获取会话未读数
     * Params:
     * conversationIds – 会话id列表
     */

    private suspend fun getUnreadCountByIds(arguments: Map<String, *>): NimResult<Int?> {
        return suspendCancellableCoroutine { cont ->
            val conversationIdList = arguments["conversationIdList"] as? List<String>
            if (conversationIdList == null) {
                cont.resume(
                    NimResult(
                        code = FLTConstant.paramErrorCode,
                        errorDetails = "getUnreadCountByIds param is null"
                    )
                )
            } else {
                NIMClient.getService(V2NIMConversationService::class.java)
                    .getUnreadCountByIds(
                        conversationIdList,
                        { result ->
                            cont.resume(
                                NimResult(
                                    code = 0,
                                    result
                                )
                            )
                        },
                        { error ->
                            cont.resume(
                                if (error != null) {
                                    NimResult(code = error.code, errorDetails = error.desc)
                                } else {
                                    NimResult(code = -1, errorDetails = "getUnreadCountByIds failed!")
                                }
                            )
                        }
                    )
            }
        }
    }

    /**
     * 根据过滤条件获取相应的未读数
     * Params:
     * filter – 查询选项
     */
    private suspend fun getUnreadCountByFilter(
        arguments: Map<String, *>
    ): NimResult<Int?> {
        return suspendCancellableCoroutine { cont ->
            val conversationFilter = createConversationFilterFromMap(arguments)
            NIMClient.getService(V2NIMConversationService::class.java)
                .getUnreadCountByFilter(
                    conversationFilter,
                    { result ->
                        cont.resume(
                            NimResult(
                                code = 0,
                                result
                            )
                        )
                    },
                    { error ->
                        cont.resume(
                            if (error != null) {
                                NimResult(code = error.code, errorDetails = error.desc)
                            } else {
                                NimResult(code = -1, errorDetails = "getUnreadCountByFilter failed!")
                            }
                        )
                    }
                )
        }
    }

    /**
     * 清空会话未读数
     */
    private suspend fun clearTotalUnreadCount(
        arguments: Map<String, *>
    ): NimResult<Nothing> {
        return suspendCancellableCoroutine { cont ->
            NIMClient.getService(V2NIMConversationService::class.java)
                .clearTotalUnreadCount(
                    {
                        cont.resume(NimResult.SUCCESS)
                    },
                    { error ->
                        cont.resume(
                            if (error != null) {
                                NimResult(code = error.code, errorDetails = error.desc)
                            } else {
                                NimResult(code = -1, errorDetails = "clearTotalUnreadCount failed!")
                            }
                        )
                    }
                )
        }
    }

    /**
     * 根据会话id清空会话未读数
     * Params:
     * conversationIds – 会话id列表
     */
    private suspend fun clearUnreadCountByIds(
        arguments: Map<String, *>
    ): NimResult<Map<String, Any?>?> {
        return suspendCancellableCoroutine { cont ->
            val conversationIdList = arguments["conversationIdList"] as? List<String>
            if (conversationIdList == null) {
                cont.resume(
                    NimResult(
                        code = FLTConstant.paramErrorCode,
                        errorDetails = "clearUnreadCountByIds param is null"
                    )
                )
            } else {
                NIMClient.getService(V2NIMConversationService::class.java)
                    .clearUnreadCountByIds(
                        conversationIdList,
                        { result ->
                            cont.resume(
                                NimResult(
                                    code = 0,
                                    data =
                                    mutableMapOf(
                                        "conversationOperationResult" to
                                            result.map {
                                                mutableMapOf(
                                                    "conversationId" to it.conversationId,
                                                    "error" to
                                                        it.error.detail
                                                )
                                            }
                                    )
                                )
                            )
                        },
                        { error ->
                            cont.resume(
                                if (error != null) {
                                    NimResult(code = error.code, errorDetails = error.desc)
                                } else {
                                    NimResult(code = -1, errorDetails = "clearUnreadCountByIds failed!")
                                }
                            )
                        }
                    )
            }
        }
    }

    /**
     * 根据会话分组清空相应会话的未读数
     * Params:
     * groupId – 会话分组id
     */
    private suspend fun clearUnreadCountByGroupId(
        arguments: Map<String, *>
    ): NimResult<Nothing> {
        return suspendCancellableCoroutine { cont ->
            val groupId = arguments["groupId"] as? String
            if (groupId == null) {
                cont.resume(
                    NimResult(
                        code = FLTConstant.paramErrorCode,
                        errorDetails = "clearUnreadCountByGroupId param is null"
                    )
                )
            } else {
                NIMClient.getService(V2NIMConversationService::class.java)
                    .clearUnreadCountByGroupId(
                        groupId,
                        {
                            cont.resume(NimResult.SUCCESS)
                        },
                        { error ->
                            cont.resume(
                                if (error != null) {
                                    NimResult(code = error.code, errorDetails = error.desc)
                                } else {
                                    NimResult(
                                        code = -1,
                                        errorDetails = "clearUnreadCountByGroupId failed!"
                                    )
                                }
                            )
                        }
                    )
            }
        }
    }

    /**
     * 根据会话id清空会话未读数
     * Params:
     * conversationIds – 会话id列表
     */
    private suspend fun clearUnreadCountByTypes(
        arguments: Map<String, *>
    ): NimResult<Nothing> {
        return suspendCancellableCoroutine { cont ->
            val conversationTypes = arguments["conversationTypeList"] as? List<Int>
            if (conversationTypes.isNullOrEmpty()) {
                cont.resume(
                    NimResult(
                        code = FLTConstant.paramErrorCode,
                        errorDetails = "clearUnreadCountByTypes param is null"
                    )
                )
            } else {
                val conversationTypeList = mutableListOf<V2NIMConversationType>()
                if (conversationTypes != null) {
                    for (type in conversationTypes) {
                        V2NIMConversationType.typeOfValue(type)
                            ?.let { conversationTypeList.add(it) }
                    }
                }
                NIMClient.getService(V2NIMConversationService::class.java)
                    .clearUnreadCountByTypes(
                        conversationTypeList,
                        {
                            cont.resume(NimResult.SUCCESS)
                        },
                        { error ->
                            cont.resume(
                                if (error != null) {
                                    NimResult(code = error.code, errorDetails = error.desc)
                                } else {
                                    NimResult(
                                        code = -1,
                                        errorDetails = "clearUnreadCountByTypes failed!"
                                    )
                                }
                            )
                        }
                    )
            }
        }
    }

    /**
     * 订阅指定过滤条件的会话未读数
     * Params:
     * filter – 过滤条件
     */
    private suspend fun subscribeUnreadCountByFilter(
        arguments: Map<String, *>
    ): NimResult<Map<String, Any?>?> {
        val filter =
            arguments["filter"] as? Map<String, *>
                ?: return NimResult(code = FLTConstant.paramErrorCode, errorDetails = "filter is null")
        val conversationFilter = createConversationFilterFromMap(filter)
        val result =
            NIMClient.getService(V2NIMConversationService::class.java)
                .subscribeUnreadCountByFilter(conversationFilter)
        if (result != null) {
            return NimResult(code = result.code, errorDetails = result.desc)
        }
        return NimResult(code = 0, mapOf())
    }

    /**
     * 取消订阅指定过滤条件的会话未读数
     * Params:
     * filter – 过滤条件
     */
    private suspend fun unsubscribeUnreadCountByFilter(
        arguments: Map<String, *>
    ): NimResult<Map<String, Any?>?> {
        val filter =
            arguments["filter"] as? Map<String, *>
                ?: return NimResult(code = FLTConstant.paramErrorCode, errorDetails = "filter is null")
        val conversationFilter = createConversationFilterFromMap(filter)

        val result =
            NIMClient.getService(V2NIMConversationService::class.java)
                .unsubscribeUnreadCountByFilter(conversationFilter)
        if (result != null) {
            return NimResult(code = result.code, errorDetails = result.desc)
        }
        return NimResult(code = 0, mapOf())
    }

    /**
     * 获取会话已读时间戳 当前只支持P2P，高级群， 超大群
     * Params:
     * conversationId – 会话ID
     */
    private suspend fun getConversationReadTime(
        arguments: Map<String, *>
    ): NimResult<Long?> {
        return suspendCancellableCoroutine { cont ->
            val conversationId = arguments["conversationId"] as? String
            if (conversationId == null) {
                cont.resume(
                    NimResult(
                        code = FLTConstant.paramErrorCode,
                        errorDetails = "conversationId is null"
                    )
                )
            } else {
                NIMClient.getService(V2NIMConversationService::class.java)
                    .getConversationReadTime(
                        conversationId,
                        { result ->
                            cont.resume(
                                NimResult(
                                    code = 0,
                                    result
                                )
                            )
                        },
                        { error ->
                            cont.resume(
                                if (error != null) {
                                    NimResult(code = error.code, errorDetails = error.desc)
                                } else {
                                    NimResult(
                                        code = -1,
                                        errorDetails = "getConversationReadTime failed!"
                                    )
                                }
                            )
                        }
                    )
            }
        }
    }

    /**
     * 标记会话已读时间戳 当前只支持P2P，高级群， 超大群
     * Params:
     * conversationId – 会话ID
     */
    private suspend fun markConversationRead(
        arguments: Map<String, *>
    ): NimResult<Long?> {
        return suspendCancellableCoroutine { cont ->
            val conversationId = arguments["conversationId"] as? String
            if (conversationId == null) {
                cont.resume(
                    NimResult(
                        code = FLTConstant.paramErrorCode,
                        errorDetails = "conversationId is null"
                    )
                )
            } else {
                NIMClient.getService(V2NIMConversationService::class.java)
                    .markConversationRead(
                        conversationId,
                        { result ->
                            cont.resume(
                                NimResult(
                                    code = 0,
                                    result
                                )
                            )
                        },
                        { error ->
                            cont.resume(
                                if (error != null) {
                                    NimResult(code = error.code, errorDetails = error.desc)
                                } else {
                                    NimResult(code = -1, errorDetails = "markConversationRead failed!")
                                }
                            )
                        }
                    )
            }
        }
    }

    private val conversationListener =
        object : V2NIMConversationListener {
            override fun onSyncStarted() {
                ALog.i(tag, "onSyncStarted")
                notifyEvent("onSyncStarted", mapOf())
            }

            override fun onSyncFinished() {
                ALog.i(tag, "onSyncFinished")
                notifyEvent("onSyncFinished", mapOf())
            }

            override fun onSyncFailed(error: V2NIMError?) {
                ALog.i(tag, "onSyncFailed")
                notifyEvent("onSyncFailed", mapOf("error" to error?.toMap()))
            }

            override fun onConversationCreated(conversation: V2NIMConversation?) {
                ALog.i(tag, "onConversationCreated")
                conversation?.toMap()?.let { notifyEvent("onConversationCreated", it) }
            }

            override fun onConversationDeleted(conversationIds: MutableList<String>?) {
                ALog.i(tag, "onConversationDeleted")
                notifyEvent("onConversationDeleted", mapOf("conversationIdList" to conversationIds))
            }

            override fun onConversationChanged(conversationList: MutableList<V2NIMConversation>?) {
                ALog.i(tag, "onConversationChanged")
                notifyEvent(
                    "onConversationChanged",
                    mapOf("conversationList" to conversationList?.map { it.toMap() })
                )
            }

            override fun onTotalUnreadCountChanged(unreadCount: Int) {
                ALog.i(tag, "onTotalUnreadCountChanged")
                notifyEvent("onTotalUnreadCountChanged", mapOf("unreadCount" to unreadCount))
            }

            override fun onUnreadCountChangedByFilter(
                filter: V2NIMConversationFilter?,
                unreadCount: Int
            ) {
                ALog.i(tag, "onUnreadCountChangedByFilter")
                notifyEvent(
                    "onUnreadCountChangedByFilter",
                    mapOf(
                        "conversationFilter" to filter?.toMap(),
                        "unreadCount" to unreadCount
                    )
                )
            }

            override fun onConversationReadTimeUpdated(
                conversationId: String?,
                readTime: Long
            ) {
                ALog.i(tag, "onConversationReadTimeUpdated")
                notifyEvent(
                    "onConversationReadTimeUpdated",
                    mapOf(
                        "conversationId" to conversationId,
                        "readTime" to readTime
                    )
                )
            }
        }

    private fun createConversationOptionFromMap(option: Map<String, Any?>): V2NIMConversationOption {
        val onlyRead =
            if (option["onlyUnread"] as? Boolean == null) false else option["onlyUnread"] as Boolean
        val conversationGroupIds = option["conversationGroupIdList"] as? List<String>
        val conversationTypes = option["conversationTypes"] as? List<Int>
        val conversationTypeList = mutableListOf<V2NIMConversationType>()
        if (conversationTypes != null) {
            for (type in conversationTypes) {
                V2NIMConversationType.typeOfValue(type)?.let { conversationTypeList.add(it) }
            }
        }
        return V2NIMConversationOption(conversationTypeList, onlyRead, conversationGroupIds)
    }

    private fun createConversationFilterFromMap(option: Map<String, Any?>): V2NIMConversationFilter {
        val ignoreMuted =
            if (option["ignoreMuted"] as? Boolean == null) false else option["ignoreMuted"] as Boolean
        val groupParam = option["conversationGroupId"] as? String
        val conversationGroupId = if (groupParam.isNullOrEmpty()) null else groupParam
        val conversationTypes = option["conversationTypes"] as? List<Int>
        val conversationTypeList = mutableListOf<V2NIMConversationType>()
        if (conversationTypes != null) {
            for (type in conversationTypes) {
                V2NIMConversationType.typeOfValue(type)?.let { conversationTypeList.add(it) }
            }
        }
        return V2NIMConversationFilter(conversationTypeList, conversationGroupId, ignoreMuted)
    }
}
