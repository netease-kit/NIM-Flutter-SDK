/*
 * Copyright (c) 2022 NetEase, Inc. All rights reserved.
 * Use of this source code is governed by a MIT license that can be
 * found in the LICENSE file.
 */

package com.netease.nimflutter.services

import android.content.Context
import com.netease.nimflutter.FLTConstant
import com.netease.nimflutter.FLTService
import com.netease.nimflutter.MethodChannelSuspendResult
import com.netease.nimflutter.NimCore
import com.netease.nimflutter.NimResult
import com.netease.nimflutter.extension.convertToV2NIMChatroomEnterParams
import com.netease.nimflutter.extension.toMap
import com.netease.nimflutter.impl.ChatroomClientListenerImpl
import com.netease.nimflutter.impl.ChatroomLinkProviderImpl
import com.netease.nimflutter.impl.ChatroomLoginExtensionProviderImpl
import com.netease.nimflutter.impl.ChatroomTokenProviderImpl
import com.netease.nimflutter.toMap
import com.netease.nimlib.sdk.v2.auth.enums.V2NIMLoginAuthType
import com.netease.nimlib.sdk.v2.chatroom.V2NIMChatroomClient
import com.netease.nimlib.sdk.v2.chatroom.V2NIMChatroomClientListener
import com.netease.nimlib.sdk.v2.chatroom.option.V2NIMChatroomLoginOption
import com.netease.nimlib.sdk.v2.chatroom.provider.V2NIMChatroomLinkProvider
import com.netease.nimlib.sdk.v2.chatroom.provider.V2NIMChatroomLoginExtensionProvider
import com.netease.nimlib.sdk.v2.chatroom.provider.V2NIMChatroomTokenProvider
import kotlin.coroutines.resume
import kotlinx.coroutines.runBlocking
import kotlinx.coroutines.suspendCancellableCoroutine
import kotlinx.coroutines.withTimeoutOrNull

class FLTChatroomClientService(
    applicationContext: Context,
    nimCore: NimCore
) : FLTService(applicationContext, nimCore) {
    private val tag = "FLTChatroomClientService"
    override val serviceName = "V2NIMChatroomClient"
    private val clientListMap = mutableMapOf<Int, V2NIMChatroomClientListener>()

    init {
        registerFlutterMethodCalls(
            "newInstance" to ::newInstance,
            "getInstance" to ::getInstance,
            "getInstanceList" to ::getInstanceList,
            "enter" to ::enter,
            "exit" to ::exit,
            "getChatroomInfo" to ::getChatroomInfo,
            "addChatroomClientListener" to ::addChatroomClientListener,
            "removeChatroomClientListener" to ::removeChatroomClientListener,
            "destroyInstance" to ::destroyInstance,
            "destroyAll" to ::destroyAll
        )
    }

    private suspend fun newInstance(arguments: Map<String, *>): NimResult<Map<String, Any?>> {
        val chatroomService = V2NIMChatroomClient.newInstance()
        if (chatroomService == null) {
            return NimResult(code = FLTConstant.chatRoomInstanceErrorCode, errorDetails = "Invalid V2NIMChatroomClient newInstance")
        }
        return NimResult(code = 0, data = mapOf("instanceId" to chatroomService.instanceId))
    }

    private suspend fun getInstance(arguments: Map<String, *>): NimResult<Map<String, Any?>> {
        val instanceId = arguments["instanceId"] as? Int
        if (instanceId == null) {
            return NimResult(code = FLTConstant.paramErrorCode, errorDetails = "Invalid chatroomService instanceId")
        }
        val chatroomService = V2NIMChatroomClient.getInstance(instanceId)
        if (chatroomService == null) {
            return NimResult(code = FLTConstant.chatRoomInstanceErrorCode, errorDetails = "Invalid chatroomService instanceId")
        }
        return NimResult(code = 0, data = mapOf("instanceId" to chatroomService.instanceId))
    }

    private suspend fun getInstanceList(arguments: Map<String, *>): NimResult<Map<String, Any?>> {
        val chatroomServiceList = V2NIMChatroomClient.getInstanceList()
        return NimResult(code = 0, data = mapOf("instanceList" to chatroomServiceList.map { it.instanceId }))
    }

    private suspend fun enter(arguments: Map<String, *>): NimResult<Map<String, Any?>> {
        val instanceId = arguments["instanceId"] as? Int
        if (instanceId == null) {
            return NimResult(code = FLTConstant.paramErrorCode, errorDetails = "Invalid chatroomService instanceId")
        }
        val chatroomService = V2NIMChatroomClient.getInstance(instanceId)
        if (chatroomService == null) {
            return NimResult(code = FLTConstant.chatRoomInstanceErrorCode, errorDetails = "Invalid chatroomService instanceId")
        }
        val roomId = arguments["roomId"] as? String
        val enterParams = (arguments["enterParams"] as? Map<String, *>)?.let {
            val authType = (it["authType"] as? Int) ?: 0
            val loginOption = V2NIMChatroomLoginOption.V2NIMChatroomLoginOptionBuilder.builder()
                .withLoginExtensionProvider(ChatroomLoginExtensionProviderImpl(this.serviceName, this.nimCore, instanceId))
                .withTokenProvider(ChatroomTokenProviderImpl(this.serviceName, this.nimCore, instanceId))
                .withAuthType(V2NIMLoginAuthType.typeOfValue(authType)).build()
            convertToV2NIMChatroomEnterParams(it, ChatroomLinkProviderImpl(this.serviceName, this.nimCore, instanceId), loginOption)
        }
        return suspendCancellableCoroutine { cont ->
            chatroomService.enter(
                roomId,
                enterParams,
                { result ->
                    cont.resume(NimResult(code = 0, data = result.toMap()))
                },
                { error ->
                    cont.resume(NimResult(code = error?.code ?: -1, errorDetails = error?.desc))
                }
            )
        }
    }

    private suspend fun exit(arguments: Map<String, *>): NimResult<Nothing> {
        val instanceId = arguments["instanceId"] as? Int
        if (instanceId == null) {
            return NimResult(code = FLTConstant.paramErrorCode, errorDetails = "Invalid chatroomService instanceId")
        }
        val chatroomService = V2NIMChatroomClient.getInstance(instanceId)
        if (chatroomService == null) {
            return NimResult(code = FLTConstant.chatRoomInstanceErrorCode, errorDetails = "Invalid chatroomService instanceId")
        }
        chatroomService.exit()
        return NimResult.SUCCESS
    }

    private suspend fun getChatroomInfo(arguments: Map<String, *>): NimResult<Map<String, Any?>> {
        val instanceId = arguments["instanceId"] as? Int
        if (instanceId == null) {
            return NimResult(code = FLTConstant.paramErrorCode, errorDetails = "Invalid chatroomService instanceId")
        }
        val chatroomService = V2NIMChatroomClient.getInstance(instanceId)
        if (chatroomService == null) {
            return NimResult(code = FLTConstant.chatRoomInstanceErrorCode, errorDetails = "Invalid chatroomService instanceId")
        }
        val result = chatroomService.getChatroomInfo()
        return NimResult(code = 0, data = result?.toMap())
    }

    private suspend fun addChatroomClientListener(arguments: Map<String, *>): NimResult<Nothing> {
        val instanceId = arguments["instanceId"] as? Int
        if (instanceId == null) {
            return NimResult(code = FLTConstant.paramErrorCode, errorDetails = "Invalid chatroomService instanceId")
        }
        val chatroomService = V2NIMChatroomClient.getInstance(instanceId)
        if (chatroomService == null) {
            return NimResult(code = FLTConstant.chatRoomInstanceErrorCode, errorDetails = "Invalid chatroomService instanceId")
        }
        if (!this.clientListMap.containsKey(instanceId)) {
            val listener = ChatroomClientListenerImpl(this.serviceName, this.nimCore, instanceId)
            chatroomService.addChatroomClientListener(listener)
            this.clientListMap.put(instanceId, listener)
        }
        return NimResult.SUCCESS
    }

    private suspend fun removeChatroomClientListener(arguments: Map<String, *>): NimResult<Nothing> {
        val instanceId = arguments["instanceId"] as? Int
        if (instanceId == null) {
            return NimResult(code = FLTConstant.paramErrorCode, errorDetails = "Invalid chatroomService instanceId")
        }
        val chatroomService = V2NIMChatroomClient.getInstance(instanceId)
        if (chatroomService == null) {
            return NimResult(code = FLTConstant.chatRoomInstanceErrorCode, errorDetails = "Invalid chatroomService instanceId")
        }
        if (this.clientListMap.containsKey(instanceId)) {
            val listener = this.clientListMap[instanceId]
            chatroomService.removeChatroomClientListener(listener)
            this.clientListMap.remove(instanceId)
        }
        return NimResult.SUCCESS
    }

    private suspend fun destroyInstance(arguments: Map<String, *>): NimResult<Nothing> {
        val instanceId = arguments["instanceId"] as? Int
        if (instanceId == null) {
            return NimResult(code = FLTConstant.paramErrorCode, errorDetails = "Invalid chatroomService instanceId")
        }
        V2NIMChatroomClient.destroyInstance(instanceId)
        return NimResult.SUCCESS
    }

    private suspend fun destroyAll(arguments: Map<String, *>): NimResult<Nothing> {
        V2NIMChatroomClient.destroyAll()
        return NimResult.SUCCESS
    }

    // 信息返回超时 500ms
    val chatroomLinkProviderTimeout = 500L
    private val chatroomLinkProvider = V2NIMChatroomLinkProvider { roomId, accountId ->
        runBlocking {
            withTimeoutOrNull(chatroomLinkProviderTimeout) {
                suspendCancellableCoroutine<Any?> { continuation ->
                    notifyEvent(
                        method = "getLinkAddress",
                        arguments = mapOf(
                            "accountId" to accountId,
                            "roomId" to roomId
                        ),
                        callback = MethodChannelSuspendResult(continuation)
                    )
                } as List<String>?
            }
        }
    }

    private val chatroomTokenProvider = V2NIMChatroomTokenProvider { roomId, accountId ->
        runBlocking {
            withTimeoutOrNull(chatroomLinkProviderTimeout) {
                suspendCancellableCoroutine<Any?> { continuation ->
                    notifyEvent(
                        method = "getToken",
                        arguments = mapOf(
                            "account" to accountId,
                            "roomId" to roomId
                        ),
                        callback = MethodChannelSuspendResult(continuation)
                    )
                } as String?
            }
        }
    }
    private val chatroomLoginExtensionProvider = V2NIMChatroomLoginExtensionProvider { roomId, accountId ->
        runBlocking {
            withTimeoutOrNull(chatroomLinkProviderTimeout) {
                suspendCancellableCoroutine<Any?> { continuation ->
                    notifyEvent(
                        method = "getLoginExtension",
                        arguments = mapOf(
                            "account" to accountId,
                            "roomId" to roomId
                        ),
                        callback = MethodChannelSuspendResult(continuation)
                    )
                } as String?
            }
        }
    }
}
