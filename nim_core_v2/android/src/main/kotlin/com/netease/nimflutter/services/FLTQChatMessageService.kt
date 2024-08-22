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
import com.netease.nimflutter.stringToMsgTypeEnum
import com.netease.nimflutter.stringToQChatMessageReferType
import com.netease.nimflutter.stringToQChatMessageSearchSortEnum
import com.netease.nimflutter.toMap
import com.netease.nimflutter.toQChatDeleteMessageParam
import com.netease.nimflutter.toQChatDownloadAttachmentParam
import com.netease.nimflutter.toQChatGetMessageHistoryByIdsParam
import com.netease.nimflutter.toQChatGetMessageHistoryParam
import com.netease.nimflutter.toQChatMarkMessageReadParam
import com.netease.nimflutter.toQChatMarkSystemNotificationsReadParam
import com.netease.nimflutter.toQChatMessage
import com.netease.nimflutter.toQChatResendMessageParam
import com.netease.nimflutter.toQChatResendSystemNotificationParam
import com.netease.nimflutter.toQChatRevokeMessageParam
import com.netease.nimflutter.toQChatSendMessageParam
import com.netease.nimflutter.toQChatSendSystemNotificationParam
import com.netease.nimflutter.toQChatUpdateMessageParam
import com.netease.nimflutter.toQChatUpdateSystemNotificationParam
import com.netease.nimlib.sdk.NIMClient
import com.netease.nimlib.sdk.qchat.QChatMessageService
import com.netease.nimlib.sdk.qchat.model.QChatMessageCache
import com.netease.nimlib.sdk.qchat.model.QChatMessageQueryOption
import com.netease.nimlib.sdk.qchat.model.QChatMessageQuickCommentDetail
import com.netease.nimlib.sdk.qchat.model.QChatMessageThreadInfo
import com.netease.nimlib.sdk.qchat.model.QChatQuickCommentDetail
import com.netease.nimlib.sdk.qchat.model.QChatTypingEvent
import com.netease.nimlib.sdk.qchat.param.QChatAddQuickCommentParam
import com.netease.nimlib.sdk.qchat.param.QChatAreMentionedMeMessagesParam
import com.netease.nimlib.sdk.qchat.param.QChatGetLastMessageOfChannelsParam
import com.netease.nimlib.sdk.qchat.param.QChatGetMentionedMeMessagesParam
import com.netease.nimlib.sdk.qchat.param.QChatGetMessageThreadInfosParam
import com.netease.nimlib.sdk.qchat.param.QChatGetQuickCommentsParam
import com.netease.nimlib.sdk.qchat.param.QChatGetReferMessagesParam
import com.netease.nimlib.sdk.qchat.param.QChatGetThreadMessagesParam
import com.netease.nimlib.sdk.qchat.param.QChatRemoveQuickCommentParam
import com.netease.nimlib.sdk.qchat.param.QChatReplyMessageParam
import com.netease.nimlib.sdk.qchat.param.QChatSearchMsgByPageParam
import com.netease.nimlib.sdk.qchat.param.QChatSendTypingEventParam
import com.netease.nimlib.sdk.qchat.result.QChatAreMentionedMeMessagesResult
import com.netease.nimlib.sdk.qchat.result.QChatDeleteMessageResult
import com.netease.nimlib.sdk.qchat.result.QChatGetLastMessageOfChannelsResult
import com.netease.nimlib.sdk.qchat.result.QChatGetMentionedMeMessagesResult
import com.netease.nimlib.sdk.qchat.result.QChatGetMessageHistoryResult
import com.netease.nimlib.sdk.qchat.result.QChatGetMessageThreadInfosResult
import com.netease.nimlib.sdk.qchat.result.QChatGetQuickCommentsResult
import com.netease.nimlib.sdk.qchat.result.QChatGetReferMessagesResult
import com.netease.nimlib.sdk.qchat.result.QChatGetThreadMessagesResult
import com.netease.nimlib.sdk.qchat.result.QChatRevokeMessageResult
import com.netease.nimlib.sdk.qchat.result.QChatSearchMsgByPageResult
import com.netease.nimlib.sdk.qchat.result.QChatSendMessageResult
import com.netease.nimlib.sdk.qchat.result.QChatSendSystemNotificationResult
import com.netease.nimlib.sdk.qchat.result.QChatSendTypingEventResult
import com.netease.nimlib.sdk.qchat.result.QChatUpdateMessageResult
import com.netease.nimlib.sdk.qchat.result.QChatUpdateSystemNotificationResult
import kotlinx.coroutines.suspendCancellableCoroutine

class FLTQChatMessageService(
    applicationContext: Context,
    nimCore: NimCore
) : FLTService(applicationContext, nimCore) {

    override val serviceName = "QChatMessageService"

    private val qChatMessageService: QChatMessageService by lazy {
        NIMClient.getService(QChatMessageService::class.java)
    }

    init {
        nimCore.onInitialized {
            registerFlutterMethodCalls(
                "deleteMessage" to ::deleteMessage,
                "getMessageHistory" to ::getMessageHistory,
                "getMessageHistoryByIds" to ::getMessageHistoryByIds,
                "markMessageRead" to ::markMessageRead,
                "markSystemNotificationsRead" to ::markSystemNotificationsRead,
                "revokeMessage" to ::revokeMessage,
                "sendMessage" to ::sendMessage,
                "sendSystemNotification" to ::sendSystemNotification,
                "updateMessage" to ::updateMessage,
                "updateSystemNotification" to ::updateSystemNotification,
                "downloadAttachment" to ::downloadAttachment,
                "resendMessage" to ::resendMessage,
                "resendSystemNotification" to ::resendSystemNotification,
                "replyMessage" to ::replyMessage,
                "clearMsgNotifyAndroid" to ::clearMsgNotifyAndroid,
                "getReferMessages" to ::getReferMessages,
                "getThreadMessages" to ::getThreadMessages,
                "getMessageThreadInfos" to ::getMessageThreadInfos,
                "addQuickComment" to ::addQuickComment,
                "removeQuickComment" to ::removeQuickComment,
                "getQuickComments" to ::getQuickComments,
                "getMessageCache" to ::getMessageCache,
                "clearMessageCache" to ::clearMessageCache,
                "getLastMessageOfChannels" to ::getLastMessageOfChannels,
                "searchMsgByPage" to ::searchMsgByPage,
                "sendTypingEvent" to ::sendTypingEvent,
                "getMentionedMeMessages" to ::getMentionedMeMessages,
                "areMentionedMeMessages" to ::areMentionedMeMessages
            )
        }
    }

    private suspend fun deleteMessage(arguments: Map<String, *>): NimResult<QChatDeleteMessageResult> {
        return suspendCancellableCoroutine { cont ->
            qChatMessageService.deleteMessage(
                arguments.toQChatDeleteMessageParam()
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

    private suspend fun getMessageHistory(arguments: Map<String, *>): NimResult<QChatGetMessageHistoryResult> {
        return suspendCancellableCoroutine { cont ->
            qChatMessageService.getMessageHistory(
                arguments.toQChatGetMessageHistoryParam()
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

    private suspend fun getMessageHistoryByIds(arguments: Map<String, *>): NimResult<QChatGetMessageHistoryResult> {
        return suspendCancellableCoroutine { cont ->
            qChatMessageService.getMessageHistoryByIds(
                arguments.toQChatGetMessageHistoryByIdsParam()
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

    private suspend fun markMessageRead(arguments: Map<String, *>): NimResult<Nothing> {
        return suspendCancellableCoroutine { cont ->
            qChatMessageService.markMessageRead(
                arguments.toQChatMarkMessageReadParam()
            ).setCallback(
                NimResultContinuationCallbackOfNothing(cont)
            )
        }
    }

    private suspend fun markSystemNotificationsRead(arguments: Map<String, *>): NimResult<Nothing> {
        return suspendCancellableCoroutine { cont ->
            qChatMessageService.markSystemNotificationsRead(
                arguments.toQChatMarkSystemNotificationsReadParam()
            ).setCallback(
                NimResultContinuationCallbackOfNothing(cont)
            )
        }
    }

    private suspend fun revokeMessage(arguments: Map<String, *>): NimResult<QChatRevokeMessageResult> {
        return suspendCancellableCoroutine { cont ->
            qChatMessageService.revokeMessage(
                arguments.toQChatRevokeMessageParam()
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

    private suspend fun sendMessage(arguments: Map<String, *>): NimResult<QChatSendMessageResult> {
        return suspendCancellableCoroutine { cont ->
            qChatMessageService.sendMessage(
                arguments.toQChatSendMessageParam()
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

    private suspend fun resendMessage(arguments: Map<String, *>): NimResult<QChatSendMessageResult> {
        return suspendCancellableCoroutine { cont ->
            qChatMessageService.resendMessage(
                arguments.toQChatResendMessageParam()
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

    private suspend fun sendSystemNotification(arguments: Map<String, *>): NimResult<QChatSendSystemNotificationResult> {
        return suspendCancellableCoroutine { cont ->
            qChatMessageService.sendSystemNotification(
                arguments.toQChatSendSystemNotificationParam()
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

    private suspend fun updateMessage(arguments: Map<String, *>): NimResult<QChatUpdateMessageResult> {
        return suspendCancellableCoroutine { cont ->
            qChatMessageService.updateMessage(
                arguments.toQChatUpdateMessageParam()
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

    private suspend fun updateSystemNotification(arguments: Map<String, *>): NimResult<QChatUpdateSystemNotificationResult> {
        return suspendCancellableCoroutine { cont ->
            qChatMessageService.updateSystemNotification(
                arguments.toQChatUpdateSystemNotificationParam()
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

    private suspend fun resendSystemNotification(arguments: Map<String, *>): NimResult<QChatSendSystemNotificationResult> {
        return suspendCancellableCoroutine { cont ->
            qChatMessageService.resendSystemNotification(
                arguments.toQChatResendSystemNotificationParam()
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

    private suspend fun downloadAttachment(arguments: Map<String, *>): NimResult<Nothing> {
        return suspendCancellableCoroutine { cont ->
            qChatMessageService.downloadAttachment(
                arguments.toQChatDownloadAttachmentParam()
            ).setCallback(
                NimResultContinuationCallbackOfNothing(cont)
            )
        }
    }

    private suspend fun replyMessage(arguments: Map<String, *>): NimResult<QChatSendMessageResult> {
        return suspendCancellableCoroutine { cont ->
            qChatMessageService.replyMessage(
                arguments.toQChatReplyMessageParam()
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

    @Suppress("UNCHECKED_CAST")
    private fun Map<String, *>.toQChatReplyMessageParam(): QChatReplyMessageParam {
        val message = (this["message"] as Map<String, *>).toQChatSendMessageParam()
        val replyMessage = (this["replyMessage"] as Map<String, *>).toQChatMessage()
        return QChatReplyMessageParam(message, replyMessage)
    }

    private suspend fun clearMsgNotifyAndroid(arguments: Map<String, *>): NimResult<Nothing> {
        qChatMessageService.clearMsgNotify()
        return NimResult.SUCCESS
    }

    private suspend fun getReferMessages(arguments: Map<String, *>): NimResult<QChatGetReferMessagesResult> {
        return suspendCancellableCoroutine { cont ->
            qChatMessageService.getReferMessages(
                arguments.toQChatGetReferMessagesParam()
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

    @Suppress("UNCHECKED_CAST")
    private fun Map<String, *>.toQChatGetReferMessagesParam(): QChatGetReferMessagesParam {
        val message = (this["message"] as Map<String, *>).toQChatMessage()
        val referType = stringToQChatMessageReferType(this["referType"] as String)
        return QChatGetReferMessagesParam(message, referType)
    }

    fun QChatGetReferMessagesResult.toMap() = mapOf<String, Any?>(
        "replyMessage" to replyMessage?.toMap(),
        "threadMessage" to threadMessage?.toMap()
    )

    private suspend fun getThreadMessages(arguments: Map<String, *>): NimResult<QChatGetThreadMessagesResult> {
        return suspendCancellableCoroutine { cont ->
            qChatMessageService.getThreadMessages(
                arguments.toQChatGetThreadMessagesParam()
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

    fun QChatGetThreadMessagesResult.toMap() = mapOf<String, Any?>(
        "threadMessage" to threadMessage?.toMap(),
        "threadInfo" to threadInfo?.toMap(),
        "messages" to messages?.map { it.toMap() }?.toList()
    )

    fun QChatMessageThreadInfo.toMap() = mapOf<String, Any?>(
        "total" to total,
        "lastMsgTime" to lastMsgTime
    )

    @Suppress("UNCHECKED_CAST")
    private fun Map<String, *>.toQChatGetThreadMessagesParam(): QChatGetThreadMessagesParam {
        val message = (this["message"] as Map<String, *>).toQChatMessage()
        val messageQueryOption =
            (this["messageQueryOption"] as Map<String, *>?)?.toQChatMessageQueryOption()
        return QChatGetThreadMessagesParam(message, messageQueryOption)
    }

    private fun Map<String, *>.toQChatMessageQueryOption(): QChatMessageQueryOption {
        val option = QChatMessageQueryOption()
        (this["fromTime"] as Number?)?.toLong()?.let {
            option.fromTime = it
        }
        (this["toTime"] as Number?)?.toLong()?.let {
            option.toTime = it
        }
        (this["excludeMessageId"] as Number?)?.toLong()?.let {
            option.excludeMessageId = it
        }
        (this["limit"] as Number?)?.toInt()?.let {
            option.limit = it
        }
        (this["reverse"] as Boolean?)?.let {
            option.isReverse = it
        }
        return option
    }

    private suspend fun getMessageThreadInfos(arguments: Map<String, *>): NimResult<QChatGetMessageThreadInfosResult> {
        return suspendCancellableCoroutine { cont ->
            qChatMessageService.getMessageThreadInfos(
                arguments.toQChatGetMessageThreadInfosParam()
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

    @Suppress("UNCHECKED_CAST")
    private fun Map<String, *>.toQChatGetMessageThreadInfosParam(): QChatGetMessageThreadInfosParam {
        val serverId = (this["serverId"] as Number).toLong()
        val channelId = (this["channelId"] as Number).toLong()
        val msgList =
            (this["msgList"] as List<*>?)?.map { (it as Map<String, *>).toQChatMessage() }?.toList()
        return QChatGetMessageThreadInfosParam(serverId, channelId, msgList)
    }

    fun QChatGetMessageThreadInfosResult.toMap() = mapOf<String, Any?>(
        "messageThreadInfoMap" to messageThreadInfoMap?.mapValues { it.value.toMap() }
    )

    private suspend fun addQuickComment(arguments: Map<String, *>): NimResult<Nothing> {
        return suspendCancellableCoroutine { cont ->
            qChatMessageService.addQuickComment(
                arguments.toQChatAddQuickCommentParam()
            ).setCallback(
                NimResultContinuationCallbackOfNothing(cont)
            )
        }
    }

    @Suppress("UNCHECKED_CAST")
    private fun Map<String, *>.toQChatAddQuickCommentParam(): QChatAddQuickCommentParam {
        val commentMessage = (this["commentMessage"] as Map<String, *>).toQChatMessage()
        val type = (this["type"] as Number).toInt()
        return QChatAddQuickCommentParam(commentMessage, type)
    }

    private suspend fun removeQuickComment(arguments: Map<String, *>): NimResult<Nothing> {
        return suspendCancellableCoroutine { cont ->
            qChatMessageService.removeQuickComment(
                arguments.toQChatRemoveQuickCommentParam()
            ).setCallback(
                NimResultContinuationCallbackOfNothing(cont)
            )
        }
    }

    @Suppress("UNCHECKED_CAST")
    private fun Map<String, *>.toQChatRemoveQuickCommentParam(): QChatRemoveQuickCommentParam {
        val commentMessage = (this["commentMessage"] as Map<String, *>).toQChatMessage()
        val type = (this["type"] as Number).toInt()
        return QChatRemoveQuickCommentParam(commentMessage, type)
    }

    private suspend fun getQuickComments(arguments: Map<String, *>): NimResult<QChatGetQuickCommentsResult> {
        return suspendCancellableCoroutine { cont ->
            qChatMessageService.getQuickComments(
                arguments.toQChatGetQuickCommentsParam()
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

    @Suppress("UNCHECKED_CAST")
    private fun Map<String, *>.toQChatGetQuickCommentsParam(): QChatGetQuickCommentsParam {
        val serverId = (this["serverId"] as Number).toLong()
        val channelId = (this["channelId"] as Number).toLong()
        val msgList =
            (this["msgList"] as List<*>?)?.map { (it as Map<String, *>).toQChatMessage() }?.toList()
        return QChatGetQuickCommentsParam(serverId, channelId, msgList)
    }

    fun QChatGetQuickCommentsResult.toMap() = mapOf<String, Any?>(
        "messageQuickCommentDetailMap" to messageQuickCommentDetailMap?.mapValues { it.value.toMap() }
    )

    fun QChatMessageQuickCommentDetail.toMap() = mapOf<String, Any?>(
        "serverId" to serverId,
        "channelId" to channelId,
        "msgIdServer" to msgIdServer,
        "totalCount" to totalCount,
        "lastUpdateTime" to lastUpdateTime,
        "details" to details?.map { it.toMap() }?.toList()
    )

    fun QChatQuickCommentDetail.toMap() = mapOf<String, Any?>(
        "type" to type,
        "count" to count,
        "hasSelf" to hasSelf(),
        "severalAccids" to severalAccids
    )

    private suspend fun getMessageCache(arguments: Map<String, *>): NimResult<List<QChatMessageCache>> {
        val qchatServerId = (arguments["qchatServerId"] as Number?)?.toLong()
        val qchatChannelId = (arguments["qchatChannelId"] as Number?)?.toLong()
        if (qchatServerId == null || qchatChannelId == null) {
            return NimResult(414, errorDetails = "param error")
        }
        return suspendCancellableCoroutine { cont ->
            qChatMessageService.getMessageCache(
                qchatServerId,
                qchatChannelId
            ).setCallback(
                NimResultContinuationCallback(cont) { result ->
                    NimResult(
                        code = 0,
                        data = result,
                        convert = {
                            mapOf(
                                "messageCacheList" to it.map { cache -> cache.toMap() }
                            )
                        }
                    )
                }
            )
        }
    }

    fun QChatMessageCache.toMap() = mapOf<String, Any?>(
        "message" to message?.toMap(),
        "replyMessage" to replyMessage?.toMap(),
        "threadMessage" to threadMessage?.toMap(),
        "messageQuickCommentDetail" to messageQuickCommentDetail?.toMap()
    )

    private suspend fun clearMessageCache(arguments: Map<String, *>): NimResult<Nothing> {
        qChatMessageService.clearMessageCache()
        return NimResult.SUCCESS
    }

    private suspend fun getLastMessageOfChannels(arguments: Map<String, *>): NimResult<QChatGetLastMessageOfChannelsResult> {
        return suspendCancellableCoroutine { cont ->
            qChatMessageService.getLastMessageOfChannels(
                arguments.toQChatGetLastMessageOfChannelsParam()
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

    @Suppress("UNCHECKED_CAST")
    private fun Map<String, *>.toQChatGetLastMessageOfChannelsParam(): QChatGetLastMessageOfChannelsParam {
        val serverId = (this["serverId"] as Number).toLong()
        val channelIds = (this["channelIds"] as List<*>).map { (it as Number).toLong() }.toList()
        return QChatGetLastMessageOfChannelsParam(serverId, channelIds)
    }

    fun QChatGetLastMessageOfChannelsResult.toMap() = mapOf<String, Any?>(
        "channelMsgMap" to channelMsgMap?.mapValues { it.value.toMap() }
    )

    private suspend fun searchMsgByPage(arguments: Map<String, *>): NimResult<QChatSearchMsgByPageResult> {
        return suspendCancellableCoroutine { cont ->
            qChatMessageService.searchMsgByPage(
                arguments.toQChatSearchMsgByPageParam()
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

    @Suppress("UNCHECKED_CAST")
    private fun Map<String, *>.toQChatSearchMsgByPageParam(): QChatSearchMsgByPageParam {
        val serverId = (this["serverId"] as Number).toLong()
        val msgTypes =
            (this["msgTypes"] as List<*>).map { stringToMsgTypeEnum(it as String) }.toList()
        val param = QChatSearchMsgByPageParam(serverId, msgTypes)
        (this["keyword"] as String?).let {
            param.keyword = it
        }
        (this["fromAccount"] as String?).let {
            param.fromAccount = it
        }
        (this["channelId"] as Number?)?.toLong().let {
            param.channelId = it
        }
        (this["fromTime"] as Number?)?.toLong().let {
            param.fromTime = it
        }
        (this["toTime"] as Number?)?.toLong().let {
            param.toTime = it
        }
        (this["subTypes"] as List<*>?)?.map { (it as Number).toInt() }.let {
            param.subTypes = it
        }
        (this["isIncludeSelf"] as Boolean?).let {
            param.isIncludeSelf = it
        }
        (this["order"] as Boolean?).let {
            param.order = it
        }
        (this["limit"] as Number?)?.toInt().let {
            param.limit = it
        }
        (this["cursor"] as String?).let {
            param.cursor = it
        }
        stringToQChatMessageSearchSortEnum(this["sort"] as String?).let {
            param.sort = it
        }
        return param
    }

    fun QChatSearchMsgByPageResult.toMap() = mapOf<String, Any?>(
        "messages" to messages?.map { it.toMap() }?.toList(),
        "hasMore" to isHasMore,
        "nextTimeTag" to nextTimeTag
    )

    private suspend fun getMentionedMeMessages(arguments: Map<String, *>): NimResult<QChatGetMentionedMeMessagesResult> {
        return suspendCancellableCoroutine { cont ->
            qChatMessageService.getMentionedMeMessages(
                arguments.toQChatGetMentionedMeMessagesParam()
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

    private fun Map<String, *>.toQChatGetMentionedMeMessagesParam(): QChatGetMentionedMeMessagesParam {
        val serverId = (this["serverId"] as Number).toLong()
        val channelId = (this["channelId"] as Number).toLong()
        val param = QChatGetMentionedMeMessagesParam(serverId, channelId)
        (this["limit"] as Number?)?.toInt().let {
            param.limit = it
        }
        (this["timetag"] as Number?)?.toLong().let {
            param.timetag = it
        }
        return param
    }

    fun QChatGetMentionedMeMessagesResult.toMap() = mapOf<String, Any?>(
        "messages" to messages?.map { it.toMap() }?.toList(),
        "hasMore" to isHasMore,
        "nextTimeTag" to nextTimeTag
    )

    private suspend fun areMentionedMeMessages(arguments: Map<String, *>): NimResult<QChatAreMentionedMeMessagesResult> {
        return suspendCancellableCoroutine { cont ->
            qChatMessageService.areMentionedMeMessages(
                arguments.toQChatAreMentionedMeMessagesParam()
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

    @Suppress("UNCHECKED_CAST")
    private fun Map<String, *>.toQChatAreMentionedMeMessagesParam(): QChatAreMentionedMeMessagesParam {
        val messages = (this["messages"] as List<Map<String, *>?>).map { it?.toQChatMessage() }
        return QChatAreMentionedMeMessagesParam(messages)
    }

    fun QChatAreMentionedMeMessagesResult.toMap() = mapOf<String, Any?>(
        "result" to result
    )

    private suspend fun sendTypingEvent(arguments: Map<String, *>): NimResult<QChatSendTypingEventResult> {
        return suspendCancellableCoroutine { cont ->
            qChatMessageService.sendTypingEvent(
                arguments.toQChatSendTypingEventParam()
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

    @Suppress("UNCHECKED_CAST")
    private fun Map<String, *>.toQChatSendTypingEventParam(): QChatSendTypingEventParam {
        val serverId = (this["serverId"] as Number).toLong()
        val channelId = (this["channelId"] as Number).toLong()
        val param = QChatSendTypingEventParam(serverId, channelId)
        (this["extension"] as Map<String, *>?).let {
            param.extension = it
        }
        return param
    }

    fun QChatSendTypingEventResult.toMap() = mapOf<String, Any?>(
        "typingEvent" to typingEvent.toMap()
    )

    fun QChatTypingEvent.toMap() = mapOf<String, Any?>(
        "serverId" to serverId,
        "channelId" to channelId,
        "fromAccount" to fromAccount,
        "fromNick" to fromNick,
        "time" to time,
        "extension" to extension
    )
}
