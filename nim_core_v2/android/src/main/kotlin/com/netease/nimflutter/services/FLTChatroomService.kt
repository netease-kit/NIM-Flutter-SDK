/*
 * Copyright (c) 2022 NetEase, Inc. All rights reserved.
 * Use of this source code is governed by a MIT license that can be
 * found in the LICENSE file.
 */

package com.netease.nimflutter.services

import android.content.Context
import com.netease.nimflutter.FLTConstant
import com.netease.nimflutter.FLTService
import com.netease.nimflutter.LocalError.paramErrorCode
import com.netease.nimflutter.NimCore
import com.netease.nimflutter.NimResult
import com.netease.nimflutter.extension.convertToChatroomLocationConfig
import com.netease.nimflutter.extension.convertToChatroomMessageListOption
import com.netease.nimflutter.extension.convertToChatroomSelfMemberUpdateParams
import com.netease.nimflutter.extension.convertToChatroomTagMemberOption
import com.netease.nimflutter.extension.convertToChatroomTagTempChatBannedParams
import com.netease.nimflutter.extension.convertToChatroomTagsUpdateParams
import com.netease.nimflutter.extension.convertToChatroomUpdateParams
import com.netease.nimflutter.extension.convertToRoleUpdateParams
import com.netease.nimflutter.extension.convertToV2NIMChatroomMemberQueryOption
import com.netease.nimflutter.extension.convertToV2NIMChatroomTagMessageOption
import com.netease.nimflutter.extension.convertToV2NIMSendChatroomMessageParams
import com.netease.nimflutter.extension.convertV2NIMAntispamConfig
import com.netease.nimflutter.extension.toMap
import com.netease.nimflutter.extension.toV2NIMChatroomMessage
import com.netease.nimflutter.impl.ChatroomListenerImpl
import com.netease.nimlib.sdk.v2.chatroom.V2NIMChatroomClient
import com.netease.nimlib.sdk.v2.chatroom.V2NIMChatroomListener
import kotlin.coroutines.resume
import kotlinx.coroutines.suspendCancellableCoroutine

class FLTChatroomService(
    applicationContext: Context,
    nimCore: NimCore
) : FLTService(applicationContext, nimCore) {
    private val tag = "FLTChatroomService"
    override val serviceName = "V2NIMChatroomService"
    private val clientListMap = mutableMapOf<Int, V2NIMChatroomListener>()

    init {
        nimCore.onInitialized {
            registerFlutterMethodCalls(
                "sendMessage" to ::sendMessage,
                "cancelMessageAttachmentUpload" to ::cancelMessageAttachmentUpload,
                "getMemberListByOption" to ::getMemberListByOption,
                "getMessageList" to ::getMessageList,
                "updateMemberRole" to ::updateMemberRole,
                "setMemberBlockedStatus" to ::setMemberBlockedStatus,
                "setMemberChatBannedStatus" to ::setMemberChatBannedStatus,
                "setMemberTempChatBanned" to ::setMemberTempChatBanned,
                "updateChatroomInfo" to ::updateChatroomInfo,
                "updateSelfMemberInfo" to ::updateSelfMemberInfo,
                "getMemberByIds" to ::getMemberByIds,
                "kickMember" to ::kickMember,
                "setTempChatBannedByTag" to ::setTempChatBannedByTag,
                "getMemberListByTag" to ::getMemberListByTag,
                "getMemberCountByTag" to ::getMemberCountByTag,
                "updateChatroomLocationInfo" to ::updateChatroomLocationInfo,
                "updateChatroomTags" to ::updateChatroomTags,
                "getMessageListByTag" to ::getMessageListByTag,
                "addChatroomListener" to ::addChatroomListener,
                "removeChatroomListener" to ::removeChatroomListener
            )
        }
    }

    private suspend fun sendMessage(arguments: Map<String, *>): NimResult<Map<String, Any?>> {
        val message = arguments["message"] as? Map<String, *>
        val params = arguments["params"] as? Map<String, *>
        if (message == null || params == null) {
            return NimResult(code = FLTConstant.paramErrorCode, errorDetails = "Invalid parameters")
        }
        val chatroomMessage = message.toV2NIMChatroomMessage()
        val sendParams = convertToV2NIMSendChatroomMessageParams(params)
        val instanceId = arguments["instanceId"] as Int
        val chatroomService = V2NIMChatroomClient.getInstance(instanceId)?.chatroomService
        if (chatroomService == null) {
            return NimResult(code = FLTConstant.chatRoomInstanceErrorCode, errorDetails = "Invalid chatroomService instanceId")
        }
        return suspendCancellableCoroutine { cont ->
            chatroomService.sendMessage(
                chatroomMessage,
                sendParams,
                { result ->
                    cont.resume(NimResult(code = 0, data = result.toMap()))
                },
                { error ->
                    cont.resume(NimResult(code = error?.code ?: -1, errorDetails = error?.desc))
                },
                { progress ->
                    notifyEvent(
                        "onSendMessageProgress",
                        mapOf(
                            "messageClientId" to chatroomMessage.messageClientId,
                            "progress" to progress
                        )
                    )
                }
            )
        }
    }

    private suspend fun getMemberListByOption(arguments: Map<String, *>): NimResult<Map<String, Any?>> {
        val option = arguments["queryOption"] as? Map<String, *>
        if (option == null) {
            return NimResult(code = FLTConstant.paramErrorCode, errorDetails = "Invalid query option")
        }
        val instanceId = arguments["instanceId"] as Int
        val chatroomService = V2NIMChatroomClient.getInstance(instanceId)?.chatroomService
        if (chatroomService == null) {
            return NimResult(code = FLTConstant.chatRoomInstanceErrorCode, errorDetails = "Invalid chatroomService instanceId")
        }
        return suspendCancellableCoroutine { cont ->
            val queryOption = convertToV2NIMChatroomMemberQueryOption(option)
            chatroomService.getMemberListByOption(
                queryOption,
                { result ->
                    cont.resume(NimResult(code = 0, data = result.toMap()))
                },
                { error ->
                    cont.resume(NimResult(code = error?.code ?: -1, errorDetails = error?.desc))
                }
            )
        }
    }

    private suspend fun cancelMessageAttachmentUpload(arguments: Map<String, *>): NimResult<Nothing> {
        val messageParam = arguments["message"] as? Map<String, *>
        val message = messageParam?.toV2NIMChatroomMessage()
        val instanceId = arguments["instanceId"] as Int
        val chatroomService = V2NIMChatroomClient.getInstance(instanceId)?.chatroomService
        if (chatroomService == null) {
            return NimResult(code = FLTConstant.chatRoomInstanceErrorCode, errorDetails = "Invalid chatroomService instanceId")
        }
        return suspendCancellableCoroutine { cont ->
            chatroomService.cancelMessageAttachmentUpload(
                message,
                { cont.resume(NimResult.SUCCESS) },
                { error -> cont.resume(NimResult(code = error?.code ?: -1, errorDetails = error?.desc)) }
            )
        }
    }

    private suspend fun updateMemberRole(arguments: Map<String, *>): NimResult<Nothing> {
        val accountId = arguments["accountId"] as? String
        val params = arguments["updateParams"] as? Map<String, *>
        val updateParams = params?.let { convertToRoleUpdateParams(it) }
        if (accountId.isNullOrEmpty() || params == null) {
            return NimResult(code = paramErrorCode, errorDetails = "message is empty")
        }
        val instanceId = arguments["instanceId"] as Int
        val chatroomService = V2NIMChatroomClient.getInstance(instanceId)?.chatroomService
        if (chatroomService == null) {
            return NimResult(code = FLTConstant.chatRoomInstanceErrorCode, errorDetails = "Invalid chatroomService instanceId")
        }
        return suspendCancellableCoroutine { cont ->
            chatroomService.updateMemberRole(
                accountId,
                updateParams,
                { cont.resume(NimResult.SUCCESS) },
                { error -> cont.resume(NimResult(code = error?.code ?: -1, errorDetails = error?.desc)) }
            )
        }
    }

    private suspend fun getMessageList(arguments: Map<String, *>): NimResult<Map<String, Any?>> {
        val optionParams = arguments["option"] as? Map<String, *>
        val option = optionParams?.let { convertToChatroomMessageListOption(it) }
        val instanceId = arguments["instanceId"] as Int
        val chatroomService = V2NIMChatroomClient.getInstance(instanceId)?.chatroomService
        if (chatroomService == null) {
            return NimResult(code = FLTConstant.chatRoomInstanceErrorCode, errorDetails = "Invalid chatroomService instanceId")
        }
        return suspendCancellableCoroutine { cont ->
            chatroomService.getMessageList(
                option,
                { messages -> cont.resume(NimResult(0, data = mapOf("messageList" to messages.map { it.toMap() }))) },
                { error -> cont.resume(NimResult(code = error?.code ?: -1, errorDetails = error?.desc)) }
            )
        }
    }

    private suspend fun setMemberBlockedStatus(arguments: Map<String, *>): NimResult<Nothing> {
        val accountId = arguments["accountId"] as? String
        val blocked = arguments["blocked"] as Boolean? ?: true
        val notificationExtension = arguments["notificationExtension"] as? String
        val instanceId = arguments["instanceId"] as Int
        val chatroomService = V2NIMChatroomClient.getInstance(instanceId)?.chatroomService
        if (chatroomService == null) {
            return NimResult(code = FLTConstant.chatRoomInstanceErrorCode, errorDetails = "Invalid chatroomService instanceId")
        }
        return suspendCancellableCoroutine { cont ->
            chatroomService.setMemberBlockedStatus(
                accountId,
                blocked,
                notificationExtension,
                { cont.resume(NimResult.SUCCESS) },
                { error -> cont.resume(NimResult(code = error?.code ?: -1, errorDetails = error?.desc)) }
            )
        }
    }

    private suspend fun setMemberChatBannedStatus(arguments: Map<String, *>): NimResult<Nothing> {
        val accountId = arguments["accountId"] as? String
        val chatBanned = arguments["chatBanned"] as? Boolean ?: true
        val notificationExtension = arguments["notificationExtension"] as? String
        val instanceId = arguments["instanceId"] as Int
        val chatroomService = V2NIMChatroomClient.getInstance(instanceId)?.chatroomService
        if (chatroomService == null) {
            return NimResult(code = FLTConstant.chatRoomInstanceErrorCode, errorDetails = "Invalid chatroomService instanceId")
        }
        return suspendCancellableCoroutine { cont ->
            chatroomService.setMemberChatBannedStatus(
                accountId,
                chatBanned,
                notificationExtension,
                { cont.resume(NimResult.SUCCESS) },
                { error -> cont.resume(NimResult(code = error?.code ?: -1, errorDetails = error?.desc)) }
            )
        }
    }

    private suspend fun setMemberTempChatBanned(arguments: Map<String, *>): NimResult<Nothing> {
        val accountId = arguments["accountId"] as? String
        val notificationEnabled = arguments["notificationEnabled"] as? Boolean ?: true
        var tempChatBannedDuration = arguments["tempChatBannedDuration"] as? Long?
        if (tempChatBannedDuration == null) {
            tempChatBannedDuration = (arguments["tempChatBannedDuration"] as? Int? ?: 0).toLong()
        }
        val notificationExtension = arguments["notificationExtension"] as? String
        val instanceId = arguments["instanceId"] as Int
        val chatroomService = V2NIMChatroomClient.getInstance(instanceId)?.chatroomService
        if (chatroomService == null) {
            return NimResult(code = FLTConstant.chatRoomInstanceErrorCode, errorDetails = "Invalid chatroomService instanceId")
        }
        return suspendCancellableCoroutine { cont ->
            chatroomService.setMemberTempChatBanned(
                accountId,
                tempChatBannedDuration,
                notificationEnabled,
                notificationExtension,
                { cont.resume(NimResult.SUCCESS) },
                { error -> cont.resume(NimResult(code = error?.code ?: -1, errorDetails = error?.desc)) }
            )
        }
    }

    private suspend fun updateChatroomInfo(arguments: Map<String, *>): NimResult<Nothing> {
        val params = arguments["updateParams"] as? Map<String, *>
        val config = arguments["antispamConfig"] as? Map<String, *>

        val updateParams = params?.let {
            convertToChatroomUpdateParams(params)
        }

        val antispamConfig = config?.let {
            convertV2NIMAntispamConfig(config)
        }
        val instanceId = arguments["instanceId"] as Int
        val chatroomService = V2NIMChatroomClient.getInstance(instanceId)?.chatroomService
        if (chatroomService == null) {
            return NimResult(code = FLTConstant.chatRoomInstanceErrorCode, errorDetails = "Invalid chatroomService instanceId")
        }
        return suspendCancellableCoroutine { cont ->
            chatroomService.updateChatroomInfo(
                updateParams,
                antispamConfig,
                { cont.resume(NimResult.SUCCESS) },
                { error -> cont.resume(NimResult(code = error?.code ?: -1, errorDetails = error?.desc)) }
            )
        }
    }

    private suspend fun updateSelfMemberInfo(arguments: Map<String, *>): NimResult<Nothing> {
        val params = arguments["updateParams"] as? Map<String, *>
        val config = arguments["antispamConfig"] as? Map<String, *>

        val updateParams = params?.let {
            convertToChatroomSelfMemberUpdateParams(params)
        }
        val antispamConfig = config?.let {
            convertV2NIMAntispamConfig(config)
        }
        val instanceId = arguments["instanceId"] as Int
        val chatroomService = V2NIMChatroomClient.getInstance(instanceId)?.chatroomService
        if (chatroomService == null) {
            return NimResult(code = FLTConstant.chatRoomInstanceErrorCode, errorDetails = "Invalid chatroomService instanceId")
        }
        return suspendCancellableCoroutine { cont ->
            chatroomService.updateSelfMemberInfo(
                updateParams,
                antispamConfig,
                { cont.resume(NimResult.SUCCESS) },
                { error -> cont.resume(NimResult(code = error?.code ?: -1, errorDetails = error?.desc)) }
            )
        }
    }

    private suspend fun getMemberByIds(arguments: Map<String, *>): NimResult<Map<String, Any?>> {
        val accountIds = arguments["accountIds"] as? List<String>
        val instanceId = arguments["instanceId"] as Int
        val chatroomService = V2NIMChatroomClient.getInstance(instanceId)?.chatroomService
        if (chatroomService == null) {
            return NimResult(code = FLTConstant.chatRoomInstanceErrorCode, errorDetails = "Invalid chatroomService instanceId")
        }
        return suspendCancellableCoroutine { cont ->
            chatroomService.getMemberByIds(
                accountIds,
                { result ->
                    cont.resume(NimResult(code = 0, data = mapOf("memberList" to result.map { it.toMap() })))
                },
                { error ->
                    cont.resume(NimResult(code = error?.code ?: -1, errorDetails = error?.desc))
                }
            )
        }
    }

    private suspend fun kickMember(arguments: Map<String, *>): NimResult<Nothing> {
        val accountId = arguments["accountId"] as? String
        val notificationExtension = arguments["notificationExtension"] as? String
        val instanceId = arguments["instanceId"] as Int
        val chatroomService = V2NIMChatroomClient.getInstance(instanceId)?.chatroomService
        if (chatroomService == null) {
            return NimResult(code = FLTConstant.chatRoomInstanceErrorCode, errorDetails = "Invalid chatroomService instanceId")
        }
        return suspendCancellableCoroutine { cont ->
            chatroomService.kickMember(
                accountId,
                notificationExtension,
                { cont.resume(NimResult.SUCCESS) },
                { error -> cont.resume(NimResult(code = error?.code ?: -1, errorDetails = error?.desc)) }
            )
        }
    }

    private suspend fun setTempChatBannedByTag(arguments: Map<String, *>): NimResult<Nothing> {
        val params = arguments["params"] as? Map<String, *>
        val updateParams = params?.let { convertToChatroomTagTempChatBannedParams(it) }
        val instanceId = arguments["instanceId"] as Int
        val chatroomService = V2NIMChatroomClient.getInstance(instanceId)?.chatroomService
        if (chatroomService == null) {
            return NimResult(code = FLTConstant.chatRoomInstanceErrorCode, errorDetails = "Invalid chatroomService instanceId")
        }
        return suspendCancellableCoroutine { cont ->
            chatroomService.setTempChatBannedByTag(
                updateParams,
                { cont.resume(NimResult.SUCCESS) },
                { error -> cont.resume(NimResult(code = error?.code ?: -1, errorDetails = error?.desc)) }
            )
        }
    }

    private suspend fun getMemberListByTag(arguments: Map<String, *>): NimResult<Map<String, Any?>> {
        val option = arguments["option"] as? Map<String, *>
        val instanceId = arguments["instanceId"] as Int
        val chatroomService = V2NIMChatroomClient.getInstance(instanceId)?.chatroomService
        if (chatroomService == null) {
            return NimResult(code = FLTConstant.chatRoomInstanceErrorCode, errorDetails = "Invalid chatroomService instanceId")
        }
        val queryOption = option?.let { convertToChatroomTagMemberOption(it) }
        return suspendCancellableCoroutine { cont ->
            chatroomService.getMemberListByTag(
                queryOption,
                { result ->
                    cont.resume(NimResult(code = 0, data = result.toMap()))
                },
                { error ->
                    cont.resume(NimResult(code = error?.code ?: -1, errorDetails = error?.desc))
                }
            )
        }
    }

    private suspend fun getMemberCountByTag(arguments: Map<String, *>): NimResult<Map<String, Any?>> {
        val tag = arguments["tag"] as? String
        val instanceId = arguments["instanceId"] as Int
        val chatroomService = V2NIMChatroomClient.getInstance(instanceId)?.chatroomService
        if (chatroomService == null) {
            return NimResult(code = FLTConstant.chatRoomInstanceErrorCode, errorDetails = "Invalid chatroomService instanceId")
        }
        return suspendCancellableCoroutine { cont ->
            chatroomService.getMemberCountByTag(
                tag,
                { result ->
                    cont.resume(NimResult(code = 0, data = mapOf("memberCount" to result)))
                },
                { error ->
                    cont.resume(NimResult(code = error?.code ?: -1, errorDetails = error?.desc))
                }
            )
        }
    }

    private suspend fun updateChatroomLocationInfo(arguments: Map<String, *>): NimResult<Nothing> {
        val locationConfig = arguments["locationConfig"] as? Map<String, *>
        val config = locationConfig?.let { convertToChatroomLocationConfig(it) }
        val instanceId = arguments["instanceId"] as Int
        val chatroomService = V2NIMChatroomClient.getInstance(instanceId)?.chatroomService
        if (chatroomService == null) {
            return NimResult(code = FLTConstant.chatRoomInstanceErrorCode, errorDetails = "Invalid chatroomService instanceId")
        }
        return suspendCancellableCoroutine { cont ->

            chatroomService.updateChatroomLocationInfo(
                config,
                { cont.resume(NimResult.SUCCESS) },
                { error -> cont.resume(NimResult(code = error?.code ?: -1, errorDetails = error?.desc)) }
            )
        }
    }

    private suspend fun updateChatroomTags(arguments: Map<String, *>): NimResult<Nothing> {
        val params = arguments["updateParams"] as? Map<String, *>
        val updateParams = params?.let { convertToChatroomTagsUpdateParams(it) }
        val instanceId = arguments["instanceId"] as Int
        val chatroomService = V2NIMChatroomClient.getInstance(instanceId)?.chatroomService
        if (chatroomService == null) {
            return NimResult(code = FLTConstant.chatRoomInstanceErrorCode, errorDetails = "Invalid chatroomService instanceId")
        }
        return suspendCancellableCoroutine { cont ->
            chatroomService.updateChatroomTags(
                updateParams,
                { cont.resume(NimResult.SUCCESS) },
                { error -> cont.resume(NimResult(code = error?.code ?: -1, errorDetails = error?.desc)) }
            )
        }
    }

    private suspend fun getMessageListByTag(arguments: Map<String, *>): NimResult<Map<String, Any?>> {
        val option = arguments["messageOption"] as? Map<String, *>
        val instanceId = arguments["instanceId"] as Int
        val chatroomService = V2NIMChatroomClient.getInstance(instanceId)?.chatroomService
        if (chatroomService == null) {
            return NimResult(code = FLTConstant.chatRoomInstanceErrorCode, errorDetails = "Invalid chatroomService instanceId")
        }
        val queryOption = option?.let { convertToV2NIMChatroomTagMessageOption(it) }
        return suspendCancellableCoroutine { cont ->
            chatroomService.getMessageListByTag(
                queryOption,
                { messages ->
                    cont.resume(NimResult(0, data = mapOf("messageList" to messages.map { it.toMap() })))
                },
                { error ->
                    cont.resume(NimResult(code = error?.code ?: -1, errorDetails = error?.desc))
                }
            )
        }
    }

    private suspend fun addChatroomListener(arguments: Map<String, *>): NimResult<Nothing> {
        val instanceId = arguments["instanceId"] as Int
        val chatroomService = V2NIMChatroomClient.getInstance(instanceId)?.chatroomService
        if (chatroomService == null) {
            return NimResult(code = FLTConstant.chatRoomInstanceErrorCode, errorDetails = "Invalid chatroomService instanceId")
        }
        if (!this.clientListMap.containsKey(instanceId)) {
            val listener = ChatroomListenerImpl(this.serviceName, nimCore, instanceId)
            this.clientListMap[instanceId] = listener
            chatroomService.addChatroomListener(listener)
        }
        return NimResult.SUCCESS
    }

    private suspend fun removeChatroomListener(arguments: Map<String, *>): NimResult<Nothing> {
        val instanceId = arguments["instanceId"] as Int
        val chatroomService = V2NIMChatroomClient.getInstance(instanceId)?.chatroomService
        if (chatroomService == null) {
            return NimResult(code = FLTConstant.chatRoomInstanceErrorCode, errorDetails = "Invalid chatroomService instanceId")
        }
        if (this.clientListMap.containsKey(instanceId)) {
            val listener = this.clientListMap.remove(instanceId)
            chatroomService.removeChatroomListener(listener)
        }
        return NimResult.SUCCESS
    }
}
