/*
 * Copyright (c) 2022 NetEase, Inc. All rights reserved.
 * Use of this source code is governed by a MIT license that can be
 * found in the LICENSE file.
 */

package com.netease.nimflutter.services

import android.content.Context
import com.netease.nimflutter.FLTService
import com.netease.nimflutter.LocalError.paramErrorCode
import com.netease.nimflutter.NimCore
import com.netease.nimflutter.NimResult
import com.netease.nimflutter.toAddCollectionParams
import com.netease.nimflutter.toClearHistoryMessageOption
import com.netease.nimflutter.toCollection
import com.netease.nimflutter.toCollectionOption
import com.netease.nimflutter.toMap
import com.netease.nimflutter.toMessage
import com.netease.nimflutter.toMessageListOption
import com.netease.nimflutter.toMessageQuickCommentPushConfig
import com.netease.nimflutter.toMessageRefer
import com.netease.nimflutter.toMessageRevokeParams
import com.netease.nimflutter.toMessageSearchParams
import com.netease.nimflutter.toSendMessageParams
import com.netease.nimflutter.toThreadMessageListOption
import com.netease.nimflutter.toVoiceToTextParams
import com.netease.nimlib.sdk.NIMClient
import com.netease.nimlib.sdk.v2.message.V2NIMClearHistoryNotification
import com.netease.nimlib.sdk.v2.message.V2NIMMessage
import com.netease.nimlib.sdk.v2.message.V2NIMMessageDeletedNotification
import com.netease.nimlib.sdk.v2.message.V2NIMMessageListener
import com.netease.nimlib.sdk.v2.message.V2NIMMessagePinNotification
import com.netease.nimlib.sdk.v2.message.V2NIMMessageQuickCommentNotification
import com.netease.nimlib.sdk.v2.message.V2NIMMessageRevokeNotification
import com.netease.nimlib.sdk.v2.message.V2NIMMessageService
import com.netease.nimlib.sdk.v2.message.V2NIMP2PMessageReadReceipt
import com.netease.nimlib.sdk.v2.message.V2NIMTeamMessageReadReceipt
import com.netease.yunxin.kit.alog.ALog
import kotlin.coroutines.resume
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.channels.awaitClose
import kotlinx.coroutines.channels.onFailure
import kotlinx.coroutines.flow.callbackFlow
import kotlinx.coroutines.flow.launchIn
import kotlinx.coroutines.flow.onEach
import kotlinx.coroutines.suspendCancellableCoroutine

/**
 * flutter 消息组件
 *
 * @constructor
 *
 * @param applicationContext
 * @param nimCore
 */
class FLTMessageService(
    applicationContext: Context,
    nimCore: NimCore
) : FLTService(applicationContext, nimCore) {
    private val tag = "FLTMessageService"

    override val serviceName = "MessageService"

    init {
        nimCore.onInitialized {
            messageListener()
            registerFlutterMethodCalls(
                "sendMessage" to ::sendMessage,
                "replyMessage" to ::replyMessage,
                "revokeMessage" to ::revokeMessage,
                "getMessageList" to ::getMessageList,
                "getMessageListByIds" to ::getMessageListByIds,
                "getMessageListByRefers" to ::getMessageListByRefers,
                "deleteMessage" to ::deleteMessage,
                "deleteMessages" to ::deleteMessages,
                "clearHistoryMessage" to ::clearHistoryMessage,
                "updateMessageLocalExtension" to ::updateMessageLocalExtension,
                "insertMessageToLocal" to ::insertMessageToLocal,
                "pinMessage" to ::pinMessage,
                "unpinMessage" to ::unpinMessage,
                "updatePinMessage" to ::updatePinMessage,
                "getPinnedMessageList" to ::getPinnedMessageList,
                "addQuickComment" to ::addQuickComment,
                "removeQuickComment" to ::removeQuickComment,
                "getQuickCommentList" to ::getQuickCommentList,
                "addCollection" to ::addCollection,
                "removeCollections" to ::removeCollections,
                "updateCollectionExtension" to ::updateCollectionExtension,
                "getCollectionListByOption" to ::getCollectionListByOption,
                "sendP2PMessageReceipt" to ::sendP2PMessageReceipt,
                "getP2PMessageReceipt" to ::getP2PMessageReceipt,
                "isPeerRead" to ::isPeerRead,
                "sendTeamMessageReceipts" to ::sendTeamMessageReceipts,
                "getTeamMessageReceipts" to ::getTeamMessageReceipts,
                "getTeamMessageReceiptDetail" to ::getTeamMessageReceiptDetail,
                "voiceToText" to ::voiceToText,
                "cancelMessageAttachmentUpload" to ::cancelMessageAttachmentUpload,
                "searchCloudMessages" to ::searchCloudMessages,
                "getLocalThreadMessageList" to ::getLocalThreadMessageList,
                "getThreadMessageList" to ::getThreadMessageList
            )
        }
    }

    @ExperimentalCoroutinesApi
    private fun messageListener() {
        callbackFlow<Pair<String, Map<String, Any?>?>> {
            val listener =
                object : V2NIMMessageListener {
                    override fun onSendMessage(message: V2NIMMessage?) {
                        ALog.i(
                            serviceName,
                            "onSendMessage: " +
                                "messageClientId ${message?.messageClientId}, " +
                                "text ${message?.text}"
                        )
                        trySend(
                            Pair<String, Map<String, Any?>?>(
                                "onSendMessage",
                                message?.toMap()
                            )
                        ).onFailure {
                            ALog.i(serviceName, "send sent messages fail: ${it?.message}")
                        }
                    }

                    override fun onReceiveMessagesModified(messages: MutableList<V2NIMMessage>?) {
                        ALog.i(
                            serviceName,
                            "onReceiveMessageModified: " +
                                "count ${messages?.size}, " +
                                "first messageClientId ${messages?.first()?.messageClientId}"
                        )
                        trySend(
                            Pair<String, Map<String, Any?>>(
                                "onReceiveMessageModified",
                                mapOf(
                                    "messages" to messages?.map { it.toMap() }
                                )
                            )
                        ).onFailure {
                            ALog.i(serviceName, "send received message modified fail: ${it?.message}")
                        }
                    }

                    override fun onReceiveMessages(messages: MutableList<V2NIMMessage>?) {
                        ALog.i(
                            serviceName,
                            "onReceiveMessages: " +
                                "count ${messages?.size}, " +
                                "first messageClientId ${messages?.first()?.messageClientId}"
                        )
                        trySend(
                            Pair<String, Map<String, Any?>>(
                                "onReceiveMessages",
                                mapOf(
                                    "messages" to messages?.map { it.toMap() }
                                )
                            )
                        ).onFailure {
                            ALog.i(serviceName, "send received messages fail: ${it?.message}")
                        }
                    }

                    override fun onReceiveP2PMessageReadReceipts(readReceipts: MutableList<V2NIMP2PMessageReadReceipt>?) {
                        ALog.i(
                            serviceName,
                            "onReceiveP2PMessageReadReceipts: " +
                                "count ${readReceipts?.size}, " +
                                "first conversationId ${readReceipts?.first()?.conversationId}"
                        )
                        trySend(
                            Pair<String, Map<String, Any?>>(
                                "onReceiveP2PMessageReadReceipts",
                                mapOf(
                                    "p2pMessageReadReceipts" to readReceipts?.map { it.toMap() }
                                )
                            )
                        ).onFailure {
                            ALog.i(serviceName, "send p2p messageReadReceipts fail: ${it?.message}")
                        }
                    }

                    override fun onReceiveTeamMessageReadReceipts(readReceipts: MutableList<V2NIMTeamMessageReadReceipt>?) {
                        ALog.i(
                            serviceName,
                            "onReceiveTeamMessageReadReceipts: " +
                                "count ${readReceipts?.size}, " +
                                "first conversationId ${readReceipts?.first()?.conversationId}"
                        )
                        trySend(
                            Pair<String, Map<String, Any?>>(
                                "onReceiveTeamMessageReadReceipts",
                                mapOf(
                                    "teamMessageReadReceipts" to readReceipts?.map { it.toMap() }
                                )
                            )
                        ).onFailure {
                            ALog.i(serviceName, "send team messageReadReceipts fail: ${it?.message}")
                        }
                    }

                    override fun onMessageRevokeNotifications(revokeNotifications: MutableList<V2NIMMessageRevokeNotification>?) {
                        ALog.i(
                            serviceName,
                            "onMessageRevokeNotifications: " +
                                "count ${revokeNotifications?.size}, " +
                                "first messageClientId ${revokeNotifications?.first()?.messageRefer?.messageClientId}"
                        )
                        trySend(
                            Pair<String, Map<String, Any?>>(
                                "onMessageRevokeNotifications",
                                mapOf(
                                    "revokeNotifications" to revokeNotifications?.map { it.toMap() }
                                )
                            )
                        ).onFailure {
                            ALog.i(serviceName, "send revoke notifications fail: ${it?.message}")
                        }
                    }

                    override fun onMessagePinNotification(pinNotification: V2NIMMessagePinNotification?) {
                        ALog.i(
                            serviceName,
                            "onMessagePinNotification: " +
                                "messageClientId ${pinNotification?.pin?.messageRefer?.messageClientId}, " +
                                "operatorId ${pinNotification?.pin?.operatorId}, " +
                                "pinState ${pinNotification?.pinState?.value}"
                        )
                        trySend(
                            Pair<String, Map<String, Any?>?>(
                                "onMessagePinNotification",
                                pinNotification?.toMap()
                            )
                        ).onFailure {
                            ALog.i(serviceName, "send pin notifications fail: ${it?.message}")
                        }
                    }

                    override fun onMessageQuickCommentNotification(quickCommentNotification: V2NIMMessageQuickCommentNotification?) {
                        ALog.i(
                            serviceName,
                            "onMessageQuickCommentNotification: " +
                                "messageClientId ${quickCommentNotification?.quickComment?.messageRefer?.messageClientId}, " +
                                "operatorId ${quickCommentNotification?.quickComment?.operatorId}, " +
                                "index ${quickCommentNotification?.quickComment?.index}, " +
                                "state ${quickCommentNotification?.operationType?.value}"
                        )
                        trySend(
                            Pair<String, Map<String, Any?>?>(
                                "onMessageQuickCommentNotification",
                                quickCommentNotification?.toMap()
                            )
                        ).onFailure {
                            ALog.i(serviceName, "send quickComment notifications fail: ${it?.message}")
                        }
                    }

                    override fun onMessageDeletedNotifications(messageDeletedNotifications: MutableList<V2NIMMessageDeletedNotification>?) {
                        ALog.i(
                            serviceName,
                            "onMessageDeletedNotifications: " +
                                "count ${messageDeletedNotifications?.size}, " +
                                "first messageClientId ${messageDeletedNotifications?.first()?.messageRefer?.messageClientId}"
                        )
                        trySend(
                            Pair<String, Map<String, Any?>>(
                                "onMessageDeletedNotifications",
                                mapOf(
                                    "deletedNotifications" to messageDeletedNotifications?.map { it.toMap() }
                                )
                            )
                        ).onFailure {
                            ALog.i(serviceName, "send delete notifications fail: ${it?.message}")
                        }
                    }

                    override fun onClearHistoryNotifications(clearHistoryNotifications: MutableList<V2NIMClearHistoryNotification>?) {
                        ALog.i(
                            serviceName,
                            "onClearHistoryNotifications: " +
                                "count ${clearHistoryNotifications?.size}, " +
                                "first conversationId ${clearHistoryNotifications?.first()?.conversationId}"
                        )
                        trySend(
                            Pair<String, Map<String, Any?>>(
                                "onClearHistoryNotifications",
                                mapOf(
                                    "clearHistoryNotifications" to clearHistoryNotifications?.map { it.toMap() }
                                )
                            )
                        ).onFailure {
                            ALog.i(serviceName, "send clear history notifications fail: ${it?.message}")
                        }
                    }
                }
            NIMClient.getService(V2NIMMessageService::class.java).apply {
                this.addMessageListener(listener)
                awaitClose {
                    this.removeMessageListener(listener)
                }
            }
        }.onEach { event ->
            notifyEvent(
                method = event.first,
                arguments = event.second as Map<String, Any?>
            )
        }.launchIn(nimCore.lifeCycleScope)
    }

    private suspend fun sendMessage(arguments: Map<String, *>): NimResult<Map<String, Any?>?> {
        val messageMap = arguments["message"] as Map<String, *>?
        if (messageMap?.isEmpty() == true) {
            return NimResult(code = paramErrorCode, errorDetails = "message is empty")
        }

        val conversationId = arguments["conversationId"] as String? ?: return NimResult(code = paramErrorCode, errorDetails = "conversationId is empty")

        val message = messageMap?.toMessage()
        val paramsMap = arguments["params"] as Map<String, *>?
        return suspendCancellableCoroutine { cont ->
            NIMClient.getService(V2NIMMessageService::class.java).sendMessage(
                message,
                conversationId,
                paramsMap?.toSendMessageParams(),
                {
                    cont.resume(NimResult(0, data = it?.toMap()))
                },
                {
                    cont.resume(NimResult(it.code, errorDetails = it.desc))
                },
                {
                    notifyEvent(
                        "onSendMessageProgress",
                        mapOf(
                            "messageClientId" to message?.messageClientId,
                            "progress" to it
                        )
                    )
                }
            )
        }
    }

    private suspend fun replyMessage(arguments: Map<String, *>): NimResult<Map<String, Any?>?> {
        val messageMap = arguments["message"] as Map<String, *>?
        if (messageMap?.isEmpty() == true) {
            return NimResult(code = paramErrorCode, errorDetails = "message is empty")
        }

        val replyMessageMap = arguments["replyMessage"] as Map<String, *>?
        if (replyMessageMap?.isEmpty() == true) {
            return NimResult(code = paramErrorCode, errorDetails = "replyMessage is empty")
        }

        val message = messageMap?.toMessage()
        val paramsMap = arguments["params"] as Map<String, *>?
        return suspendCancellableCoroutine { cont ->
            NIMClient.getService(V2NIMMessageService::class.java).replyMessage(
                message,
                replyMessageMap?.toMessage(),
                paramsMap?.toSendMessageParams(),
                {
                    cont.resume(NimResult(0, data = it?.toMap()))
                },
                {
                    cont.resume(NimResult(it.code, errorDetails = it.desc))
                },
                {
                    notifyEvent(
                        "onSendMessageProgress",
                        mapOf(
                            "messageClientId" to message?.messageClientId,
                            "progress" to it
                        )
                    )
                }
            )
        }
    }

    private suspend fun revokeMessage(arguments: Map<String, *>): NimResult<Void> {
        val messageMap = arguments["message"] as Map<String, *>?
        if (messageMap?.isEmpty() == true) {
            return NimResult(code = paramErrorCode, errorDetails = "message is empty")
        }

        val paramsMap = arguments["params"] as Map<String, *>?
        return suspendCancellableCoroutine { cont ->
            NIMClient.getService(V2NIMMessageService::class.java).revokeMessage(
                messageMap?.toMessage(),
                paramsMap?.toMessageRevokeParams(),
                {
                    cont.resume(NimResult(0, data = null))
                },
                {
                    cont.resume(NimResult(it.code, errorDetails = it.desc))
                }
            )
        }
    }

    private suspend fun getMessageList(arguments: Map<String, *>): NimResult<Map<String, Any?>?> {
        val optionMap = arguments["option"] as Map<String, *>?
        if (optionMap?.isEmpty() == true) {
            return NimResult(code = paramErrorCode, errorDetails = "option is empty")
        }

        return suspendCancellableCoroutine { cont ->
            NIMClient.getService(V2NIMMessageService::class.java).getMessageList(
                optionMap?.toMessageListOption(),
                { messages ->
                    cont.resume(
                        NimResult(
                            0,
                            data =
                            mapOf(
                                "messages" to messages.map { it?.toMap() }
                            )
                        )
                    )
                },
                {
                    cont.resume(NimResult(it.code, errorDetails = it.desc))
                }
            )
        }
    }

    private suspend fun getMessageListByIds(arguments: Map<String, *>): NimResult<Map<String, Any?>?> {
        val messageClientIds = arguments["messageClientIds"] as List<String>?
        return suspendCancellableCoroutine { cont ->
            NIMClient.getService(V2NIMMessageService::class.java).getMessageListByIds(
                messageClientIds,
                { messages ->
                    cont.resume(
                        NimResult(
                            0,
                            data =
                            mapOf(
                                "messages" to messages.map { it?.toMap() }
                            )
                        )
                    )
                },
                {
                    cont.resume(NimResult(it.code, errorDetails = it.desc))
                }
            )
        }
    }

    private suspend fun getMessageListByRefers(arguments: Map<String, *>): NimResult<Map<String, Any?>?> {
        val messageRefers = arguments["messageRefers"] as List<Map<String, *>?>?
        return suspendCancellableCoroutine { cont ->
            NIMClient.getService(V2NIMMessageService::class.java).getMessageListByRefers(
                messageRefers?.map { it?.toMessageRefer() },
                { messages ->
                    cont.resume(
                        NimResult(
                            0,
                            data =
                            mapOf(
                                "messages" to messages.map { it?.toMap() }
                            )
                        )
                    )
                },
                {
                    cont.resume(NimResult(it.code, errorDetails = it.desc))
                }
            )
        }
    }

    private suspend fun deleteMessage(arguments: Map<String, *>): NimResult<Void> {
        val messageMap = arguments["message"] as Map<String, *>?
        if (messageMap?.isEmpty() == true) {
            return NimResult(code = paramErrorCode, errorDetails = "message is empty")
        }

        val serverExtension = arguments["serverExtension"] as String?
        val onlyDeleteLocal = arguments["onlyDeleteLocal"] as Boolean? ?: true
        return suspendCancellableCoroutine { cont ->
            NIMClient.getService(V2NIMMessageService::class.java).deleteMessage(
                messageMap?.toMessage(),
                serverExtension,
                onlyDeleteLocal,
                {
                    cont.resume(NimResult(0, data = null))
                },
                {
                    cont.resume(NimResult(it.code, errorDetails = it.desc))
                }
            )
        }
    }

    private suspend fun deleteMessages(arguments: Map<String, *>): NimResult<Void> {
        val messagesMap = arguments["messages"] as List<Map<String, *>?>?
        val serverExtension = arguments["serverExtension"] as String?
        val onlyDeleteLocal = arguments["onlyDeleteLocal"] as Boolean? ?: true
        return suspendCancellableCoroutine { cont ->
            NIMClient.getService(V2NIMMessageService::class.java).deleteMessages(
                messagesMap?.map { it?.toMessage() },
                serverExtension,
                onlyDeleteLocal,
                {
                    cont.resume(NimResult(0, data = null))
                },
                {
                    cont.resume(NimResult(it.code, errorDetails = it.desc))
                }
            )
        }
    }

    private suspend fun clearHistoryMessage(arguments: Map<String, *>): NimResult<Void> {
        val optionMap = arguments["option"] as Map<String, *>?
        if (optionMap?.isEmpty() == true) {
            return NimResult(code = paramErrorCode, errorDetails = "option is empty")
        }

        return suspendCancellableCoroutine { cont ->
            NIMClient.getService(V2NIMMessageService::class.java).clearHistoryMessage(
                optionMap?.toClearHistoryMessageOption(),
                {
                    cont.resume(NimResult(0, data = null))
                },
                {
                    cont.resume(NimResult(it.code, errorDetails = it.desc))
                }
            )
        }
    }

    private suspend fun updateMessageLocalExtension(arguments: Map<String, *>): NimResult<Map<String, Any?>?> {
        val messageMap = arguments["message"] as Map<String, *>?
        if (messageMap?.isEmpty() == true) {
            return NimResult(code = paramErrorCode, errorDetails = "message is empty")
        }

        val localExtension = arguments["localExtension"] as String? ?: return NimResult(code = paramErrorCode, errorDetails = "localExtension is null")

        return suspendCancellableCoroutine { cont ->
            NIMClient.getService(V2NIMMessageService::class.java).updateMessageLocalExtension(
                messageMap?.toMessage(),
                localExtension,
                {
                    cont.resume(NimResult(0, data = it?.toMap()))
                },
                {
                    cont.resume(NimResult(it.code, errorDetails = it.desc))
                }
            )
        }
    }

    private suspend fun insertMessageToLocal(arguments: Map<String, *>): NimResult<Map<String, Any?>?> {
        val messageMap = arguments["message"] as Map<String, *>?
        if (messageMap?.isEmpty() == true) {
            return NimResult(code = paramErrorCode, errorDetails = "message is empty")
        }

        val conversationId = arguments["conversationId"] as String? ?: return NimResult(code = paramErrorCode, errorDetails = "conversationId is empty")

        val senderId = arguments["senderId"] as String?
        val createTime = arguments["createTime"] as? Long? ?: 0
        return suspendCancellableCoroutine { cont ->
            NIMClient.getService(V2NIMMessageService::class.java).insertMessageToLocal(
                messageMap?.toMessage(),
                conversationId,
                senderId,
                createTime,
                {
                    cont.resume(NimResult(0, data = it?.toMap()))
                },
                {
                    cont.resume(NimResult(it.code, errorDetails = it.desc))
                }
            )
        }
    }

    private suspend fun pinMessage(arguments: Map<String, *>): NimResult<Void> {
        val messageMap = arguments["message"] as Map<String, *>?
        if (messageMap?.isEmpty() == true) {
            return NimResult(code = paramErrorCode, errorDetails = "message is empty")
        }

        val serverExtension = arguments["serverExtension"] as String?
        return suspendCancellableCoroutine { cont ->
            NIMClient.getService(V2NIMMessageService::class.java).pinMessage(
                messageMap?.toMessage(),
                serverExtension,
                {
                    cont.resume(NimResult(0, data = null))
                },
                {
                    cont.resume(NimResult(it.code, errorDetails = it.desc))
                }
            )
        }
    }

    private suspend fun unpinMessage(arguments: Map<String, *>): NimResult<Void> {
        val messageRefer = arguments["messageRefer"] as Map<String, *>?
        if (messageRefer?.isEmpty() == true) {
            return NimResult(code = paramErrorCode, errorDetails = "messageRefer is empty")
        }

        val serverExtension = arguments["serverExtension"] as String?
        return suspendCancellableCoroutine { cont ->
            NIMClient.getService(V2NIMMessageService::class.java).unpinMessage(
                messageRefer?.toMessageRefer(),
                serverExtension,
                {
                    cont.resume(NimResult(0, data = null))
                },
                {
                    cont.resume(NimResult(it.code, errorDetails = it.desc))
                }
            )
        }
    }

    private suspend fun updatePinMessage(arguments: Map<String, *>): NimResult<Void> {
        val messageMap = arguments["message"] as Map<String, *>?
        if (messageMap?.isEmpty() == true) {
            return NimResult(code = paramErrorCode, errorDetails = "message is empty")
        }

        val serverExtension = arguments["serverExtension"] as String?
        return suspendCancellableCoroutine { cont ->
            NIMClient.getService(V2NIMMessageService::class.java).updatePinMessage(
                messageMap?.toMessage(),
                serverExtension,
                {
                    cont.resume(NimResult(0, data = null))
                },
                {
                    cont.resume(NimResult(it.code, errorDetails = it.desc))
                }
            )
        }
    }

    private suspend fun getPinnedMessageList(arguments: Map<String, *>): NimResult<Map<String, Any?>?> {
        val conversationId = arguments["conversationId"] as String? ?: return NimResult(code = paramErrorCode, errorDetails = "conversationId is empty")

        return suspendCancellableCoroutine { cont ->
            NIMClient.getService(V2NIMMessageService::class.java).getPinnedMessageList(
                conversationId,
                { messagePins ->
                    cont.resume(
                        NimResult(
                            0,
                            data =
                            mapOf(
                                "pinMessages" to messagePins.map { it?.toMap() }
                            )
                        )
                    )
                },
                {
                    cont.resume(NimResult(it.code, errorDetails = it.desc))
                }
            )
        }
    }

    private suspend fun addQuickComment(arguments: Map<String, *>): NimResult<Void> {
        val messageMap = arguments["message"] as Map<String, *>?
        if (messageMap?.isEmpty() == true) {
            return NimResult(code = paramErrorCode, errorDetails = "message is empty")
        }

        var index = arguments["index"] as? Long?
        if (index == null) {
            index = (arguments["index"] as? Int? ?: 0).toLong()
        }

        val serverExtension = arguments["serverExtension"] as String?
        val pushConfigMap = arguments["pushConfig"] as Map<String, *>?
        return suspendCancellableCoroutine { cont ->
            NIMClient.getService(V2NIMMessageService::class.java).addQuickComment(
                messageMap?.toMessage(),
                index,
                serverExtension,
                pushConfigMap?.toMessageQuickCommentPushConfig(),
                {
                    cont.resume(NimResult(0, data = null))
                },
                {
                    cont.resume(NimResult(it.code, errorDetails = it.desc))
                }
            )
        }
    }

    private suspend fun removeQuickComment(arguments: Map<String, *>): NimResult<Void> {
        val messageReferMap = arguments["messageRefer"] as Map<String, *>?
        if (messageReferMap?.isEmpty() == true) {
            return NimResult(code = paramErrorCode, errorDetails = "messageRefer is empty")
        }

        var index = arguments["index"] as? Long?
        if (index == null) {
            index = (arguments["index"] as? Int? ?: 0).toLong()
        }

        val serverExtension = arguments["serverExtension"] as String?
        return suspendCancellableCoroutine { cont ->
            NIMClient.getService(V2NIMMessageService::class.java).removeQuickComment(
                messageReferMap?.toMessageRefer(),
                index,
                serverExtension,
                {
                    cont.resume(NimResult(0, data = null))
                },
                {
                    cont.resume(NimResult(it.code, errorDetails = it.desc))
                }
            )
        }
    }

    private suspend fun getQuickCommentList(arguments: Map<String, *>): NimResult<Map<String, Any?>?> {
        val messagesMap = arguments["messages"] as List<Map<String, *>?>?
        return suspendCancellableCoroutine { cont ->
            NIMClient.getService(V2NIMMessageService::class.java).getQuickCommentList(
                messagesMap?.map { it?.toMessage() },
                { quickCommentList ->
                    cont.resume(
                        NimResult(
                            0,
                            data = quickCommentList.mapValues { (_, list) ->
                                list.map {
                                    it.toMap()
                                }.toList()
                            }
                        )
                    )
                },
                {
                    cont.resume(NimResult(it.code, errorDetails = it.desc))
                }
            )
        }
    }

    private suspend fun addCollection(arguments: Map<String, *>): NimResult<Map<String, Any?>?> {
        val params = arguments["params"] as Map<String, *>?
        if (params?.isEmpty() == true) {
            return NimResult(code = paramErrorCode, errorDetails = "params is empty")
        }

        return suspendCancellableCoroutine { cont ->
            NIMClient.getService(V2NIMMessageService::class.java).addCollection(
                params?.toAddCollectionParams(),
                {
                    cont.resume(NimResult(0, data = it?.toMap()))
                },
                {
                    cont.resume(NimResult(it.code, errorDetails = it.desc))
                }
            )
        }
    }

    private suspend fun removeCollections(arguments: Map<String, *>): NimResult<Int> {
        val collections = arguments["collections"] as List<Map<String, *>?>?
        return suspendCancellableCoroutine { cont ->
            NIMClient.getService(V2NIMMessageService::class.java).removeCollections(
                collections?.map { it?.toCollection() },
                {
                    cont.resume(NimResult(0, it))
                },
                {
                    cont.resume(NimResult(it.code, errorDetails = it.desc))
                }
            )
        }
    }

    private suspend fun updateCollectionExtension(arguments: Map<String, *>): NimResult<Map<String, Any?>?> {
        val collection = arguments["collection"] as Map<String, *>?
        if (collection?.isEmpty() == true) {
            return NimResult(code = paramErrorCode, errorDetails = "collection is empty")
        }

        val serverExtension = arguments["serverExtension"] as String?
        return suspendCancellableCoroutine { cont ->
            NIMClient.getService(V2NIMMessageService::class.java).updateCollectionExtension(
                collection?.toCollection(),
                serverExtension,
                {
                    cont.resume(NimResult(0, data = it?.toMap()))
                },
                {
                    cont.resume(NimResult(it.code, errorDetails = it.desc))
                }
            )
        }
    }

    private suspend fun getCollectionListByOption(arguments: Map<String, *>): NimResult<Map<String, Any?>?> {
        val option = arguments["option"] as Map<String, *>?
        if (option?.isEmpty() == true) {
            return NimResult(code = paramErrorCode, errorDetails = "option is empty")
        }

        return suspendCancellableCoroutine { cont ->
            NIMClient.getService(V2NIMMessageService::class.java).getCollectionListByOption(
                option?.toCollectionOption(),
                { collections ->
                    cont.resume(
                        NimResult(
                            0,
                            data =
                            mapOf(
                                "collections" to collections.map { it?.toMap() }
                            )
                        )
                    )
                },
                {
                    cont.resume(NimResult(it.code, errorDetails = it.desc))
                }
            )
        }
    }

    private suspend fun sendP2PMessageReceipt(arguments: Map<String, *>): NimResult<Void> {
        val messageMap = arguments["message"] as Map<String, *>?
        if (messageMap?.isEmpty() == true) {
            return NimResult(code = paramErrorCode, errorDetails = "message is empty")
        }

        return suspendCancellableCoroutine { cont ->
            NIMClient.getService(V2NIMMessageService::class.java).sendP2PMessageReceipt(
                messageMap?.toMessage(),
                {
                    cont.resume(NimResult(0, data = null))
                },
                {
                    cont.resume(NimResult(it.code, errorDetails = it.desc))
                }
            )
        }
    }

    private suspend fun getP2PMessageReceipt(arguments: Map<String, *>): NimResult<Map<String, Any?>?> {
        val conversationId = arguments["conversationId"] as String? ?: return NimResult(code = paramErrorCode, errorDetails = "conversationId is empty")

        return suspendCancellableCoroutine { cont ->
            NIMClient.getService(V2NIMMessageService::class.java).getP2PMessageReceipt(
                conversationId,
                {
                    cont.resume(NimResult(0, data = it?.toMap()))
                },
                {
                    cont.resume(NimResult(it.code, errorDetails = it.desc))
                }
            )
        }
    }

    private suspend fun isPeerRead(arguments: Map<String, *>): NimResult<Boolean> {
        val messageMap = arguments["message"] as Map<String, *>?
        if (messageMap?.isEmpty() == true) {
            return NimResult(code = paramErrorCode, errorDetails = "message is empty")
        }

        return suspendCancellableCoroutine { cont ->
            NIMClient
                .getService(V2NIMMessageService::class.java)
                .isPeerRead(
                    messageMap?.toMessage()
                ).let {
                    cont.resume(NimResult(0, data = it))
                }
        }
    }

    private suspend fun sendTeamMessageReceipts(arguments: Map<String, *>): NimResult<Void> {
        val messagesMap = arguments["messages"] as List<Map<String, *>?>?
        return suspendCancellableCoroutine { cont ->
            NIMClient.getService(V2NIMMessageService::class.java).sendTeamMessageReceipts(
                messagesMap?.map { it?.toMessage() },
                {
                    cont.resume(NimResult(0, data = null))
                },
                {
                    cont.resume(NimResult(it.code, errorDetails = it.desc))
                }
            )
        }
    }

    private suspend fun getTeamMessageReceipts(arguments: Map<String, *>): NimResult<Map<String, Any?>?> {
        val messagesMap = arguments["messages"] as List<Map<String, *>?>?
        return suspendCancellableCoroutine { cont ->
            NIMClient.getService(V2NIMMessageService::class.java).getTeamMessageReceipts(
                messagesMap?.map { it?.toMessage() },
                { readReceipts ->
                    cont.resume(
                        NimResult(
                            0,
                            data =
                            mapOf(
                                "readReceipts" to readReceipts.map { it?.toMap() }
                            )
                        )
                    )
                },
                {
                    cont.resume(NimResult(it.code, errorDetails = it.desc))
                }
            )
        }
    }

    private suspend fun getTeamMessageReceiptDetail(arguments: Map<String, *>): NimResult<Map<String, Any?>?> {
        val messageMap = arguments["message"] as Map<String, *>?
        if (messageMap?.isEmpty() == true) {
            return NimResult(code = paramErrorCode, errorDetails = "message is empty")
        }

        val memberAccountIds = arguments["memberAccountIds"] as List<String>?
        return suspendCancellableCoroutine { cont ->
            NIMClient.getService(V2NIMMessageService::class.java).getTeamMessageReceiptDetail(
                messageMap?.toMessage(),
                memberAccountIds?.toSet(),
                {
                    cont.resume(NimResult(0, data = it?.toMap()))
                },
                {
                    cont.resume(NimResult(it.code, errorDetails = it.desc))
                }
            )
        }
    }

    private suspend fun voiceToText(arguments: Map<String, *>): NimResult<String> {
        val params = arguments["params"] as Map<String, *>?
        if (params?.isEmpty() == true) {
            return NimResult(code = paramErrorCode, errorDetails = "params is empty")
        }

        return suspendCancellableCoroutine { cont ->
            NIMClient.getService(V2NIMMessageService::class.java).voiceToText(
                params?.toVoiceToTextParams(),
                {
                    cont.resume(NimResult(0, data = it))
                },
                {
                    cont.resume(NimResult(it.code, errorDetails = it.desc))
                }
            )
        }
    }

    private suspend fun cancelMessageAttachmentUpload(arguments: Map<String, *>): NimResult<Void> {
        val messageMap = arguments["message"] as Map<String, *>?
        if (messageMap?.isEmpty() == true) {
            return NimResult(code = paramErrorCode, errorDetails = "message is empty")
        }

        return suspendCancellableCoroutine { cont ->
            NIMClient.getService(V2NIMMessageService::class.java).cancelMessageAttachmentUpload(
                messageMap?.toMessage(),
                {
                    cont.resume(NimResult(0, data = null))
                },
                {
                    cont.resume(NimResult(it.code, errorDetails = it.desc))
                }
            )
        }
    }

    private suspend fun searchCloudMessages(arguments: Map<String, *>): NimResult<Map<String, Any?>?> {
        val params = arguments["params"] as Map<String, *>?
        if (params?.isEmpty() == true) {
            return NimResult(code = paramErrorCode, errorDetails = "params is empty")
        }

        return suspendCancellableCoroutine { cont ->
            NIMClient.getService(V2NIMMessageService::class.java).searchCloudMessages(
                params?.toMessageSearchParams(),
                { messages ->
                    cont.resume(
                        NimResult(
                            0,
                            data =
                            mapOf(
                                "messages" to messages.map { it?.toMap() }
                            )
                        )
                    )
                },
                {
                    cont.resume(NimResult(it.code, errorDetails = it.desc))
                }
            )
        }
    }

    private suspend fun getLocalThreadMessageList(arguments: Map<String, *>): NimResult<Map<String, Any?>?> {
        val messageReferMap = arguments["messageRefer"] as Map<String, *>?
        if (messageReferMap?.isEmpty() == true) {
            return NimResult(code = paramErrorCode, errorDetails = "messageRefer is empty")
        }

        return suspendCancellableCoroutine { cont ->
            NIMClient.getService(V2NIMMessageService::class.java).getLocalThreadMessageList(
                messageReferMap?.toMessageRefer(),
                {
                    cont.resume(NimResult(0, data = it?.toMap()))
                },
                {
                    cont.resume(NimResult(it.code, errorDetails = it.desc))
                }
            )
        }
    }

    private suspend fun getThreadMessageList(arguments: Map<String, *>): NimResult<Map<String, Any?>?> {
        val option = arguments["option"] as Map<String, *>?
        if (option?.isEmpty() == true) {
            return NimResult(code = paramErrorCode, errorDetails = "option is empty")
        }

        return suspendCancellableCoroutine { cont ->
            NIMClient.getService(V2NIMMessageService::class.java).getThreadMessageList(
                option?.toThreadMessageListOption(),
                {
                    cont.resume(NimResult(0, data = it?.toMap()))
                },
                {
                    cont.resume(NimResult(it.code, errorDetails = it.desc))
                }
            )
        }
    }
}
