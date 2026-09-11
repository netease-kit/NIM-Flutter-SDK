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
import com.netease.nimflutter.extension.toMap
import com.netease.nimflutter.extension.toMessage
import com.netease.nimflutter.extension.toSendMessageParams
import com.netease.nimlib.sdk.NIMClient
import com.netease.nimlib.sdk.v2.message.enums.V2NIMQueryDirection
import com.netease.nimlib.sdk.v2.message.enums.V2NIMSortOrder
import com.netease.nimlib.sdk.v2.topic.V2NIMTopic
import com.netease.nimlib.sdk.v2.topic.V2NIMTopicListener
import com.netease.nimlib.sdk.v2.topic.V2NIMTopicRefer
import com.netease.nimlib.sdk.v2.topic.V2NIMTopicService
import com.netease.nimlib.sdk.v2.topic.option.V2NIMTopicListOption
import com.netease.nimlib.sdk.v2.topic.option.V2NIMTopicMessageListOption
import com.netease.nimlib.sdk.v2.topic.params.V2NIMCreateTopicParams
import com.netease.nimlib.sdk.v2.topic.params.V2NIMRemoveTopicsParams
import com.netease.nimlib.sdk.v2.topic.params.V2NIMSendTopicMessageParams
import com.netease.nimlib.sdk.v2.topic.params.V2NIMUpdateTopicParams
import com.netease.nimlib.sdk.v2.topic.result.V2NIMTopicListResult
import com.netease.nimlib.sdk.v2.topic.result.V2NIMTopicMessageListResult
import com.netease.yunxin.kit.alog.ALog
import java.io.Serializable
import kotlin.coroutines.resume
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.channels.awaitClose
import kotlinx.coroutines.channels.onFailure
import kotlinx.coroutines.flow.callbackFlow
import kotlinx.coroutines.flow.launchIn
import kotlinx.coroutines.flow.onEach
import kotlinx.coroutines.suspendCancellableCoroutine

class FLTTopicService(
    applicationContext: Context,
    nimCore: NimCore
) : FLTService(applicationContext, nimCore) {
    override val serviceName = "TopicService"

    init {
        nimCore.onInitialized {
            topicListener()
            registerFlutterMethodCalls(
                "removeTopics" to ::removeTopics,
                "updateTopic" to ::updateTopic,
                "sendTopicMessage" to ::sendTopicMessage,
                "replyTopicMessage" to ::replyTopicMessage,
                "getTopicByRefer" to ::getTopicByRefer,
                "getTopicListByOption" to ::getTopicListByOption,
                "getTopicMessageList" to ::getTopicMessageList
            )
        }
    }

    private val topicService: V2NIMTopicService
        get() = NIMClient.getService(V2NIMTopicService::class.java)

    private suspend fun removeTopics(arguments: Map<String, *>): NimResult<Void> {
        val paramsMap = arguments["params"] as? Map<String, *>
            ?: return NimResult(paramErrorCode, errorDetails = "params is null")
        return suspendCancellableCoroutine { cont ->
            topicService.removeTopics(
                paramsMap.toRemoveTopicsParams(),
                { cont.resume(NimResult(0, it)) },
                { cont.resume(NimResult(it.code, errorDetails = it.desc)) }
            )
        }
    }

    private suspend fun updateTopic(arguments: Map<String, *>): NimResult<V2NIMTopic> {
        val paramsMap = arguments["params"] as? Map<String, *>
            ?: return NimResult(paramErrorCode, errorDetails = "params is null")
        return suspendCancellableCoroutine { cont ->
            topicService.updateTopic(
                paramsMap.toUpdateTopicParams(),
                { cont.resume(NimResult(0, data = it, convert = ::topicToMap)) },
                { cont.resume(NimResult(it.code, errorDetails = it.desc)) }
            )
        }
    }

    private suspend fun sendTopicMessage(arguments: Map<String, *>): NimResult<Map<String, Any?>?> {
        val messageMap = arguments["message"] as? Map<String, *>
            ?: return NimResult(paramErrorCode, errorDetails = "message is null")
        val conversationId = arguments["conversationId"] as? String
            ?: return NimResult(paramErrorCode, errorDetails = "conversationId is null")
        return suspendCancellableCoroutine { cont ->
            topicService.sendTopicMessage(
                messageMap.toMessage(),
                conversationId,
                (arguments["topic"] as? Map<String, *>)?.toTopic(),
                (arguments["params"] as? Map<String, *>)?.toSendTopicMessageParams(),
                { cont.resume(NimResult(0, data = it?.toMap())) },
                { cont.resume(NimResult(it.code, errorDetails = it.desc)) },
                null
            )
        }
    }

    private suspend fun replyTopicMessage(arguments: Map<String, *>): NimResult<Map<String, Any?>?> {
        val messageMap = arguments["message"] as? Map<String, *>
            ?: return NimResult(paramErrorCode, errorDetails = "message is null")
        val replyMessageMap = arguments["replyMessage"] as? Map<String, *>
            ?: return NimResult(paramErrorCode, errorDetails = "replyMessage is null")
        val topicMap = arguments["topic"] as? Map<String, *>
            ?: return NimResult(paramErrorCode, errorDetails = "topic is null")
        return suspendCancellableCoroutine { cont ->
            topicService.replyTopicMessage(
                messageMap.toMessage(),
                replyMessageMap.toMessage(),
                topicMap.toTopic(),
                (arguments["params"] as? Map<String, *>)?.toSendMessageParams(),
                { cont.resume(NimResult(0, data = it?.toMap())) },
                { cont.resume(NimResult(it.code, errorDetails = it.desc)) },
                null
            )
        }
    }

    private suspend fun getTopicByRefer(arguments: Map<String, *>): NimResult<V2NIMTopic> {
        val topicReferMap = arguments["topicRefer"] as? Map<String, *>
            ?: return NimResult(paramErrorCode, errorDetails = "topicRefer is null")
        return suspendCancellableCoroutine { cont ->
            topicService.getTopicByRefer(
                topicReferMap.toTopicRefer(),
                { cont.resume(NimResult(0, data = it, convert = ::topicToMap)) },
                { cont.resume(NimResult(it.code, errorDetails = it.desc)) }
            )
        }
    }

    private suspend fun getTopicListByOption(arguments: Map<String, *>): NimResult<V2NIMTopicListResult> {
        val optionMap = arguments["option"] as? Map<String, *>
            ?: return NimResult(paramErrorCode, errorDetails = "option is null")
        return suspendCancellableCoroutine { cont ->
            topicService.getTopicListByOption(
                optionMap.toTopicListOption(),
                { cont.resume(NimResult(0, data = it, convert = ::topicListResultToMap)) },
                { cont.resume(NimResult(it.code, errorDetails = it.desc)) }
            )
        }
    }

    private suspend fun getTopicMessageList(arguments: Map<String, *>): NimResult<V2NIMTopicMessageListResult> {
        val optionMap = arguments["option"] as? Map<String, *>
            ?: return NimResult(paramErrorCode, errorDetails = "option is null")
        return suspendCancellableCoroutine { cont ->
            topicService.getTopicMessageList(
                optionMap.toTopicMessageListOption(),
                { cont.resume(NimResult(0, data = it, convert = ::topicMessageListResultToMap)) },
                { cont.resume(NimResult(it.code, errorDetails = it.desc)) }
            )
        }
    }

    @OptIn(ExperimentalCoroutinesApi::class)
    private fun topicListener() {
        callbackFlow<Pair<String, Map<String, Any?>>> {
            val listener = object : V2NIMTopicListener {
                override fun onTopicAdded(topic: V2NIMTopic?) {
                    trySend("onTopicAdded" to (topic?.let(::topicToMap) ?: mapOf())).onFailure {
                        ALog.e(serviceName, "send onTopicAdded fail: ${it?.message}")
                    }
                }

                override fun onTopicsRemoved(topics: MutableList<V2NIMTopicRefer>?) {
                    trySend(
                        "onTopicsRemoved" to mapOf(
                            "topics" to topics?.map(::topicReferToMap)
                        )
                    ).onFailure {
                        ALog.e(serviceName, "send onTopicsRemoved fail: ${it?.message}")
                    }
                }

                override fun onTopicUpdated(topic: V2NIMTopic?) {
                    trySend("onTopicUpdated" to (topic?.let(::topicToMap) ?: mapOf())).onFailure {
                        ALog.e(serviceName, "send onTopicUpdated fail: ${it?.message}")
                    }
                }
            }
            topicService.addTopicListener(listener)
            awaitClose { topicService.removeTopicListener(listener) }
        }.onEach { event ->
            notifyEvent(event.first, event.second)
        }.launchIn(nimCore.lifeCycleScope)
    }
}

private fun Map<String, *>.toTopicRefer(): V2NIMTopicRefer {
    val map = this
    return object : V2NIMTopicRefer, Serializable {
        override fun getConversationId(): String? = map["conversationId"] as? String
        override fun getTopicId(): Long = map["topicId"].toLongValue()
        override fun getCreateTime(): Long = map["createTime"].toLongValue()
    }
}

private fun Map<String, *>.toTopic(): V2NIMTopic {
    val map = this
    return object : V2NIMTopic, Serializable {
        override fun getConversationId(): String? = map["conversationId"] as? String
        override fun getTopicId(): Long = map["topicId"].toLongValue()
        override fun getCreateTime(): Long = map["createTime"].toLongValue()
        override fun getTopicName(): String? = map["topicName"] as? String
        override fun getMessageClientId(): String? = map["messageClientId"] as? String
        override fun getMessageServerId(): String? = map["messageServerId"] as? String
        override fun getMessageTime(): Long = map["messageTime"].toLongValue()
        override fun getServerExtension(): String? = map["serverExtension"] as? String
        override fun getUpdateTime(): Long = map["updateTime"].toLongValue()
    }
}

private fun Map<String, *>.toUpdateTopicParams(): V2NIMUpdateTopicParams =
    V2NIMUpdateTopicParams(
        (this["topic"] as? Map<String, *>)?.toTopic(),
        this["topicName"] as? String,
        this["serverExtension"] as? String
    )

private fun Map<String, *>.toRemoveTopicsParams(): V2NIMRemoveTopicsParams =
    V2NIMRemoveTopicsParams(
        (this["topicList"] as? List<Map<String, *>>)?.map { it.toTopic() } ?: emptyList()
    )

private fun Map<String, *>.toCreateTopicParams(): V2NIMCreateTopicParams =
    V2NIMCreateTopicParams(this["topicName"] as? String, this["serverExtension"] as? String)

private fun Map<String, *>.toSendTopicMessageParams(): V2NIMSendTopicMessageParams =
    V2NIMSendTopicMessageParams(
        (this["sendMessageParams"] as? Map<String, *>)?.toSendMessageParams(),
        (this["createTopicParams"] as? Map<String, *>)?.toCreateTopicParams()
    )

private fun Map<String, *>.toTopicListOption(): V2NIMTopicListOption =
    V2NIMTopicListOption(
        this["conversationId"] as? String,
        this["beginTime"].toLongValue(),
        this["endTime"].toLongValue(),
        this["nextToken"] as? String,
        this["limit"].toIntValue(30),
        V2NIMQueryDirection.typeOfValue(this["direction"].toIntValue(0))
    )

private fun Map<String, *>.toTopicMessageListOption(): V2NIMTopicMessageListOption =
    V2NIMTopicMessageListOption(
        (this["topic"] as? Map<String, *>)?.toTopic(),
        this["beginTime"].toLongValue(),
        this["endTime"].toLongValue(),
        (this["anchorMessage"] as? Map<String, *>)?.toMessage(),
        this["limit"].toIntValue(100),
        V2NIMQueryDirection.typeOfValue(this["direction"].toIntValue(0)),
        V2NIMSortOrder.typeOfValue(this["sortOrder"].toIntValue(1))
    )

private fun topicReferToMap(topicRefer: V2NIMTopicRefer): Map<String, Any?> {
    if (topicRefer is V2NIMTopic) {
        return topicToMap(topicRefer)
    }
    return mapOf(
        "conversationId" to topicRefer.conversationId,
        "topicId" to topicRefer.topicId,
        "createTime" to topicRefer.createTime
    )
}

private fun topicToMap(topic: V2NIMTopic): Map<String, Any?> =
    mapOf(
        "conversationId" to topic.conversationId,
        "topicId" to topic.topicId,
        "createTime" to topic.createTime,
        "topicName" to topic.topicName,
        "messageClientId" to topic.messageClientId,
        "messageServerId" to topic.messageServerId,
        "messageTime" to topic.messageTime,
        "serverExtension" to topic.serverExtension,
        "updateTime" to topic.updateTime
    )

private fun topicListResultToMap(result: V2NIMTopicListResult): Map<String, Any?> =
    mapOf(
        "topicList" to result.topicList?.map(::topicToMap),
        "nextToken" to result.nextToken,
        "hasMore" to result.hasMore()
    )

private fun topicMessageListResultToMap(result: V2NIMTopicMessageListResult): Map<String, Any?> =
    mapOf(
        "replyList" to result.replyList?.map { it.toMap() },
        "hasMore" to result.hasMore(),
        "anchorMessage" to result.anchorMessage?.toMap()
    )

private fun Any?.toLongValue(defaultValue: Long = 0L): Long =
    when (this) {
        is Long -> this
        is Int -> this.toLong()
        is Double -> this.toLong()
        is Float -> this.toLong()
        else -> defaultValue
    }

private fun Any?.toIntValue(defaultValue: Int = 0): Int =
    when (this) {
        is Int -> this
        is Long -> this.toInt()
        is Double -> this.toInt()
        is Float -> this.toInt()
        else -> defaultValue
    }
