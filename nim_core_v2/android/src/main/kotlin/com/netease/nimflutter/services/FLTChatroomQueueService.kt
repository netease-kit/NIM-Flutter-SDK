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
import com.netease.nimflutter.extension.convertToV2NIMChatroomQueueElement
import com.netease.nimflutter.extension.convertToV2NIMChatroomQueueOfferParams
import com.netease.nimflutter.extension.toMap
import com.netease.nimflutter.impl.ChatroomQueueListenerImpl
import com.netease.nimlib.sdk.v2.chatroom.V2NIMChatroomClient
import com.netease.nimlib.sdk.v2.chatroom.V2NIMChatroomQueueListener
import com.netease.nimlib.sdk.v2.chatroom.model.V2NIMChatroomQueueElement
import kotlin.coroutines.resume
import kotlinx.coroutines.suspendCancellableCoroutine

class FLTChatroomQueueService(
    applicationContext: Context,
    nimCore: NimCore
) : FLTService(applicationContext, nimCore) {
    private val tag = "FLTChatroomQueueService"
    override val serviceName = "V2NIMChatroomQueueService"
    private val clientListMap = mutableMapOf<Int, V2NIMChatroomQueueListener>()

    init {
        nimCore.onInitialized {
            registerFlutterMethodCalls(
                "addQueueListener" to ::addQueueListener,
                "removeChatroomListener" to ::removeQueueListener,
                "queueOffer" to ::queueOffer,
                "queuePoll" to ::queuePoll,
                "queueList" to ::queueList,
                "queuePeek" to ::queuePeek,
                "queueDrop" to ::queueDrop,
                "queueInit" to ::queueInit,
                "queueBatchUpdate" to ::queueBatchUpdate
            )
        }
    }

    private suspend fun queueOffer(arguments: Map<String, *>): NimResult<Map<String, Any?>> {
        val params = arguments["offerParams"] as? Map<String, *>
        val instanceId = arguments["instanceId"] as? Int
        if (params == null || instanceId == null) {
            return NimResult(code = FLTConstant.paramErrorCode, errorDetails = "Invalid queue params")
        }
        val chatroomQueueService = V2NIMChatroomClient.getInstance(instanceId)?.chatroomQueueService
        if (chatroomQueueService == null) {
            return NimResult(code = FLTConstant.chatRoomInstanceErrorCode, errorDetails = "Invalid chatroomService instanceId")
        }
        return suspendCancellableCoroutine { cont ->
            val queryOption = convertToV2NIMChatroomQueueOfferParams(params)
            chatroomQueueService.queueOffer(
                queryOption,
                { result ->
                    cont.resume(NimResult(code = 0))
                },
                { error ->
                    cont.resume(NimResult(code = error?.code ?: -1, errorDetails = error?.desc))
                }
            )
        }
    }

    private suspend fun queuePoll(arguments: Map<String, *>): NimResult<Map<String, Any?>> {
        val elementKey = arguments["elementKey"] as? String
        val instanceId = arguments["instanceId"] as? Int
        if (elementKey == null || instanceId == null) {
            return NimResult(code = FLTConstant.paramErrorCode, errorDetails = "Invalid queue params")
        }
        val chatroomQueueService = V2NIMChatroomClient.getInstance(instanceId)?.chatroomQueueService
        if (chatroomQueueService == null) {
            return NimResult(code = FLTConstant.chatRoomInstanceErrorCode, errorDetails = "Invalid chatroomService instanceId")
        }
        return suspendCancellableCoroutine { cont ->
            chatroomQueueService.queuePoll(
                elementKey,
                { result ->
                    cont.resume(NimResult(code = 0, data = result.toMap()))
                },
                { error ->
                    cont.resume(NimResult(code = error?.code ?: -1, errorDetails = error?.desc))
                }
            )
        }
    }

    private suspend fun queueList(arguments: Map<String, *>): NimResult<Map<String, Any?>> {
        val instanceId = arguments["instanceId"] as? Int
        if (instanceId == null) {
            return NimResult(code = FLTConstant.paramErrorCode, errorDetails = "Invalid queue params")
        }
        val chatroomQueueService = V2NIMChatroomClient.getInstance(instanceId)?.chatroomQueueService
        if (chatroomQueueService == null) {
            return NimResult(code = FLTConstant.chatRoomInstanceErrorCode, errorDetails = "Invalid chatroomService instanceId")
        }
        return suspendCancellableCoroutine { cont ->
            chatroomQueueService.queueList(
                { result ->
                    cont.resume(
                        NimResult(
                            code = 0,
                            data = mapOf(
                                "elements" to result.map { it.toMap() }.toList()
                            )
                        )
                    )
                },
                { error ->
                    cont.resume(NimResult(code = error?.code ?: -1, errorDetails = error?.desc))
                }
            )
        }
    }

    private suspend fun queuePeek(arguments: Map<String, *>): NimResult<Map<String, Any?>> {
        val instanceId = arguments["instanceId"] as? Int
        if (instanceId == null) {
            return NimResult(code = FLTConstant.paramErrorCode, errorDetails = "Invalid queue params")
        }
        val chatroomQueueService = V2NIMChatroomClient.getInstance(instanceId)?.chatroomQueueService
        if (chatroomQueueService == null) {
            return NimResult(code = FLTConstant.chatRoomInstanceErrorCode, errorDetails = "Invalid chatroomService instanceId")
        }
        return suspendCancellableCoroutine { cont ->
            chatroomQueueService.queuePeek(
                { result ->
                    cont.resume(NimResult(code = 0, data = result.toMap()))
                },
                { error ->
                    cont.resume(NimResult(code = error?.code ?: -1, errorDetails = error?.desc))
                }
            )
        }
    }

    private suspend fun queueDrop(arguments: Map<String, *>): NimResult<Map<String, Any?>> {
        val instanceId = arguments["instanceId"] as? Int
        if (instanceId == null) {
            return NimResult(code = FLTConstant.paramErrorCode, errorDetails = "Invalid queue params")
        }
        val chatroomQueueService = V2NIMChatroomClient.getInstance(instanceId)?.chatroomQueueService
        if (chatroomQueueService == null) {
            return NimResult(code = FLTConstant.chatRoomInstanceErrorCode, errorDetails = "Invalid chatroomService instanceId")
        }
        return suspendCancellableCoroutine { cont ->
            chatroomQueueService.queueDrop(
                { result ->
                    cont.resume(NimResult(code = 0))
                },
                { error ->
                    cont.resume(NimResult(code = error?.code ?: -1, errorDetails = error?.desc))
                }
            )
        }
    }

    private suspend fun queueInit(arguments: Map<String, *>): NimResult<Map<String, Any?>> {
        val size = arguments["size"] as? Int
        val instanceId = arguments["instanceId"] as? Int
        if (size == null || instanceId == null) {
            return NimResult(code = FLTConstant.paramErrorCode, errorDetails = "Invalid queue params")
        }
        val chatroomQueueService = V2NIMChatroomClient.getInstance(instanceId)?.chatroomQueueService
        if (chatroomQueueService == null) {
            return NimResult(code = FLTConstant.chatRoomInstanceErrorCode, errorDetails = "Invalid chatroomService instanceId")
        }
        return suspendCancellableCoroutine { cont ->
            chatroomQueueService.queueInit(
                size,
                { result ->
                    cont.resume(NimResult(code = 0))
                },
                { error ->
                    cont.resume(NimResult(code = error?.code ?: -1, errorDetails = error?.desc))
                }
            )
        }
    }

    private suspend fun queueBatchUpdate(arguments: Map<String, *>): NimResult<Map<String, Any?>> {
        val instanceId = arguments["instanceId"] as? Int
        if (instanceId == null) {
            return NimResult(code = FLTConstant.paramErrorCode, errorDetails = "Invalid queue params")
        }
        val notificationEnabled = arguments["notificationEnabled"] as? Boolean ?: true
        val notificationExtension = arguments["notificationExtension"] as? String
        val elementsMap = arguments["elements"] as? List<Map<String, *>>
        var elements: List<V2NIMChatroomQueueElement>? = null
        if (elementsMap != null) {
            elements = elementsMap.map { convertToV2NIMChatroomQueueElement(it) }.filterNotNull().toList()
        }
        val chatroomQueueService = V2NIMChatroomClient.getInstance(instanceId)?.chatroomQueueService
        if (chatroomQueueService == null) {
            return NimResult(code = FLTConstant.chatRoomInstanceErrorCode, errorDetails = "Invalid chatroomService instanceId")
        }
        return suspendCancellableCoroutine { cont ->
            chatroomQueueService.queueBatchUpdate(
                elements,
                notificationEnabled,
                notificationExtension,
                { result ->
                    cont.resume(
                        NimResult(
                            code = 0,
                            data = mapOf(
                                "notExistKeys" to result
                            )
                        )
                    )
                },
                { error ->
                    cont.resume(NimResult(code = error?.code ?: -1, errorDetails = error?.desc))
                }
            )
        }
    }

    private suspend fun addQueueListener(arguments: Map<String, *>): NimResult<Nothing> {
        val instanceId = arguments["instanceId"] as Int
        val chatroomQueueService = V2NIMChatroomClient.getInstance(instanceId)?.chatroomQueueService
        if (chatroomQueueService == null) {
            return NimResult(code = FLTConstant.chatRoomInstanceErrorCode, errorDetails = "Invalid chatroomService instanceId")
        }
        if (!this.clientListMap.containsKey(instanceId)) {
            val listener = ChatroomQueueListenerImpl(this.serviceName, nimCore, instanceId)
            this.clientListMap[instanceId] = listener
            chatroomQueueService.addQueueListener(listener)
        }
        return NimResult.SUCCESS
    }

    private suspend fun removeQueueListener(arguments: Map<String, *>): NimResult<Nothing> {
        val instanceId = arguments["instanceId"] as Int
        val chatroomQueueService = V2NIMChatroomClient.getInstance(instanceId)?.chatroomQueueService
        if (chatroomQueueService == null) {
            return NimResult(code = FLTConstant.chatRoomInstanceErrorCode, errorDetails = "Invalid chatroomService instanceId")
        }
        if (this.clientListMap.containsKey(instanceId)) {
            val listener = this.clientListMap.remove(instanceId)
            chatroomQueueService.removeQueueListener(listener)
        }
        return NimResult.SUCCESS
    }
}
