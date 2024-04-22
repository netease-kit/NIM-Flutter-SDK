/*
 * Copyright (c) 2022 NetEase, Inc. All rights reserved.
 * Use of this source code is governed by a MIT license that can be
 * found in the LICENSE file.
 */

package com.netease.nimflutter.services

import android.content.Context
import android.text.TextUtils
import android.util.Pair
import com.netease.nimflutter.FLTService
import com.netease.nimflutter.NimCollectInfo
import com.netease.nimflutter.NimCore
import com.netease.nimflutter.NimResult
import com.netease.nimflutter.NimResultCallback
import com.netease.nimflutter.NimResultContinuationCallback
import com.netease.nimflutter.NimResultContinuationCallbackOfNothing
import com.netease.nimflutter.ResultCallback
import com.netease.nimflutter.SafeResult
import com.netease.nimflutter.Utils
import com.netease.nimflutter.convertToMessageKey
import com.netease.nimflutter.convertToQueryDirectionEnum
import com.netease.nimflutter.convertToSearchConfig
import com.netease.nimflutter.convertToSearchOption
import com.netease.nimflutter.stringFromSessionTypeEnum
import com.netease.nimflutter.stringToGetMessageDirectionEnum
import com.netease.nimflutter.stringToMsgTypeEnum
import com.netease.nimflutter.stringToSessionTypeEnum
import com.netease.nimflutter.toMap
import com.netease.nimlib.sdk.NIMClient
import com.netease.nimlib.sdk.Observer
import com.netease.nimlib.sdk.RequestCallback
import com.netease.nimlib.sdk.msg.MessageBuilder
import com.netease.nimlib.sdk.msg.MsgService
import com.netease.nimlib.sdk.msg.MsgServiceObserve
import com.netease.nimlib.sdk.msg.attachment.AudioAttachment
import com.netease.nimlib.sdk.msg.attachment.MsgAttachment
import com.netease.nimlib.sdk.msg.constant.DeleteTypeEnum
import com.netease.nimlib.sdk.msg.constant.MsgStatusEnum
import com.netease.nimlib.sdk.msg.constant.MsgTypeEnum
import com.netease.nimlib.sdk.msg.constant.SessionTypeEnum
import com.netease.nimlib.sdk.msg.model.AttachmentProgress
import com.netease.nimlib.sdk.msg.model.BroadcastMessage
import com.netease.nimlib.sdk.msg.model.CollectInfo
import com.netease.nimlib.sdk.msg.model.CollectInfoPage
import com.netease.nimlib.sdk.msg.model.GetMessagesDynamicallyParam
import com.netease.nimlib.sdk.msg.model.GetMessagesDynamicallyResult
import com.netease.nimlib.sdk.msg.model.HandleQuickCommentOption
import com.netease.nimlib.sdk.msg.model.IMMessage
import com.netease.nimlib.sdk.msg.model.LocalAntiSpamResult
import com.netease.nimlib.sdk.msg.model.MessageKey
import com.netease.nimlib.sdk.msg.model.MessageReceipt
import com.netease.nimlib.sdk.msg.model.MsgFullKeywordSearchConfig
import com.netease.nimlib.sdk.msg.model.MsgPinDbOption
import com.netease.nimlib.sdk.msg.model.MsgPinSyncResponseOption
import com.netease.nimlib.sdk.msg.model.MsgPinSyncResponseOptionWrapper
import com.netease.nimlib.sdk.msg.model.NIMMessage
import com.netease.nimlib.sdk.msg.model.QueryDirectionEnum
import com.netease.nimlib.sdk.msg.model.QuickCommentOptionWrapper
import com.netease.nimlib.sdk.msg.model.RecentContact
import com.netease.nimlib.sdk.msg.model.RecentSession
import com.netease.nimlib.sdk.msg.model.RecentSessionList
import com.netease.nimlib.sdk.msg.model.RevokeMsgNotification
import com.netease.nimlib.sdk.msg.model.SessionAckInfo
import com.netease.nimlib.sdk.msg.model.StickTopSessionInfo
import com.netease.nimlib.sdk.msg.model.TeamMessageReceipt
import com.netease.nimlib.sdk.msg.model.TeamMsgAckInfo
import com.netease.nimlib.sdk.msg.model.ThreadTalkHistory
import com.netease.nimlib.sdk.superteam.SuperTeamService
import com.netease.nimlib.sdk.team.TeamService
import com.netease.yunxin.kit.alog.ALog
import kotlin.coroutines.resume
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.suspendCancellableCoroutine
import kotlinx.coroutines.withContext
import org.json.JSONObject

class FLTMessageService(
    applicationContext: Context,
    nimCore: NimCore
) : FLTService(applicationContext, nimCore) {

    private val tag = "FLTMessageService"

    override val serviceName = "MessageService"

    private val onMessage =
        Observer { messageList: List<IMMessage> ->
            run {
                notifyEvent(
                    "onMessage",
                    mutableMapOf(
                        "messageList" to
                            messageList
                                .map {
                                    if (it.attachment == null && it.msgType == MsgTypeEnum.custom) {
                                        it.attachment =
                                            CustomAttachment(Utils.jsonStringToMap(it.attachStr))
                                    }
                                    it
                                }
                                .map { it.toMap() }
                                .toList()
                    )
                )
            }
        }

    private val msgService by lazy { NIMClient.getService(MsgService::class.java) }

    private val onMessageStatus =
        Observer { message: IMMessage ->
            run {
                notifyEvent("onMessageStatus", message.toMap() as MutableMap<String, Any?>)
            }
        }

    private val onMessageReceipt =
        Observer { messageReceiptList: List<MessageReceipt> ->
            run {
                notifyEvent(
                    "onMessageReceipt",
                    mutableMapOf(
                        "messageReceiptList" to messageReceiptList.map { it.toMap() }
                            .toList()
                    )
                )
            }
        }

    private val onTeamMessageReceipt =
        Observer { teamMessageReceiptList: List<TeamMessageReceipt> ->
            run {
                notifyEvent(
                    "onTeamMessageReceipt",
                    mutableMapOf(
                        "teamMessageReceiptList" to teamMessageReceiptList.map { it.toMap() }
                            .toList()
                    )
                )
            }
        }

    private val attachmentProgress =
        Observer { attachmentProgress: AttachmentProgress ->
            run {
                notifyEvent(
                    "onAttachmentProgress",
                    attachmentProgress.toMap() as MutableMap<String, Any?>
                )
            }
        }

    private val revokeMessageObserver =
        Observer { revokeMsgNotification: RevokeMsgNotification ->
            run {
                notifyEvent(
                    "onMessageRevoked",
                    revokeMsgNotification.toMap() as MutableMap<String, Any?>
                )
            }
        }

    private val broadcastMessageObserver =
        Observer { broadcastMessage: BroadcastMessage ->
            run {
                notifyEvent(
                    "onBroadcastMessage",
                    broadcastMessage.toMap() as MutableMap<String, Any?>
                )
            }
        }

    private val recentContactUpdatedObserver =
        Observer { recentContacts: List<RecentContact> ->
            notifyEvent(
                "onSessionUpdate",
                hashMapOf(
                    "data" to recentContacts.map { it.toMap() }.toList()
                )
            )
        }

    private val recentContactDeleteObserver =
        Observer { recentContact: RecentContact? ->
            notifyEvent(
                "onSessionDelete",
                recentContact?.toMap() ?: emptyMap()
            )
        }

    private val mySessionUpdateObserver =
        Observer { recentSession: RecentSession ->
            notifyEvent(
                "onMySessionUpdate",
                recentSession.toMap()
            )
        }

    private val messagePinAddedObserver =
        Observer { messagePin: MsgPinSyncResponseOption ->
            notifyEvent(
                "onMessagePinAdded",
                messagePin.toMap()
            )
        }

    private val messagePinRemovedObserver =
        Observer { messagePin: MsgPinSyncResponseOption ->
            notifyEvent(
                "onMessagePinRemoved",
                messagePin.toMap()
            )
        }

    private val messagePinUpdatedObserver =
        Observer { messagePin: MsgPinSyncResponseOption ->
            notifyEvent(
                "onMessagePinUpdated",
                messagePin.toMap()
            )
        }

    fun notifyMessagePinEvent(event: String, messagePin: MsgPinSyncResponseOption) {
        notifyEvent(
            event,
            messagePin.toMap()
        )
    }

    private val messagePinSyncTimestamp = hashMapOf<kotlin.Pair<String, SessionTypeEnum>, Long>()

    private val quickCommentAddObserver =
        Observer { handleQuickCommentOption: HandleQuickCommentOption ->
            notifyEvent(
                "onQuickCommentAdd",
                handleQuickCommentOption.toMap()
            )
        }

    private val quickCommentRemoveObserver =
        Observer { handleQuickCommentOption: HandleQuickCommentOption ->
            notifyEvent(
                "onQuickCommentRemove",
                handleQuickCommentOption.toMap()
            )
        }

    private val syncStickTopSessionObserver =
        Observer { stickTopSessionInfoList: List<StickTopSessionInfo> ->
            notifyEvent(
                "onSyncStickTopSession",
                mutableMapOf(
                    "data" to stickTopSessionInfoList.map { it.toMap() }
                        .toList()
                )
            )
        }

    private val stickTopSessionAddObserver =
        Observer { stickTopSessionInfo: StickTopSessionInfo ->
            notifyEvent(
                "onStickTopSessionAdd",
                stickTopSessionInfo.toMap()
            )
        }

    private val stickTopSessionRemoveObserver =
        Observer { stickTopSessionInfo: StickTopSessionInfo ->
            notifyEvent(
                "onStickTopSessionRemove",
                stickTopSessionInfo.toMap()
            )
        }

    private val stickTopSessionUpdateObserver =
        Observer { stickTopSessionInfo: StickTopSessionInfo ->
            notifyEvent(
                "onStickTopSessionUpdate",
                stickTopSessionInfo.toMap()
            )
        }

    private val onMessageListDeleteObserver = Observer { messageList: List<IMMessage> ->
        notifyEvent(
            "onMessagesDelete",
            mutableMapOf(
                "messageList" to messageList.map { it.toMap() }.toList()
            )
        )
    }

    // iOS 没有单条的回调，此处单条批量化处理
    private val onMessageDeleteObserver = Observer { messageList: IMMessage ->
        notifyEvent(
            "onMessagesDelete",
            mutableMapOf(
                "messageList" to listOf(messageList.toMap())
            )
        )
    }

    init {
        nimCore.onInitialized {
            NIMClient.getService(MsgServiceObserve::class.java).apply {
                observeReceiveMessage(onMessage, true)
                observeMsgStatus(onMessageStatus, true)
                observeMessageReceipt(onMessageReceipt, true)
                observeTeamMessageReceipt(onTeamMessageReceipt, true)
                observeAttachmentProgress(attachmentProgress, true)
                observeRevokeMessage(revokeMessageObserver, true)
                observeBroadcastMessage(broadcastMessageObserver, true)
                observeRecentContact(recentContactUpdatedObserver, true)
                observeRecentContactDeleted(recentContactDeleteObserver, true)
                observeAddMsgPin(messagePinAddedObserver, true)
                observeRemoveMsgPin(messagePinRemovedObserver, true)
                observeUpdateMsgPin(messagePinUpdatedObserver, true)
                observeUpdateMySession(mySessionUpdateObserver, true)
                observeAddQuickComment(quickCommentAddObserver, true)
                observeRemoveQuickComment(quickCommentRemoveObserver, true)
                observeSyncStickTopSession(syncStickTopSessionObserver, true)
                observeAddStickTopSession(stickTopSessionAddObserver, true)
                observeRemoveStickTopSession(stickTopSessionRemoveObserver, true)
                observeUpdateStickTopSession(stickTopSessionUpdateObserver, true)
                observeDeleteMsgSelfBatch(onMessageListDeleteObserver, true)
                observeDeleteMsgSelf(onMessageDeleteObserver, true)
            }
            registerFlutterMethodCalls(
                "querySessionList" to ::querySessionList,
                "querySessionListFiltered" to ::querySessionListFiltered,
                "querySession" to ::querySession,
                "createSession" to ::createSession,
                "updateSession" to ::updateSession,
                "updateSessionWithMessage" to ::updateSessionWithMessage,
                "queryTotalUnreadCount" to ::queryTotalUnreadCount,
                "setChattingAccount" to ::setChattingAccount, // iOS无此接口
                "clearSessionUnreadCount" to ::clearSessionUnreadCount,
                "clearAllSessionUnreadCount" to ::clearAllSessionUnreadCount,
                "deleteSession" to ::deleteSession,
                "addCollect" to ::addCollect,
                "removeCollect" to ::removeCollect,
                "updateCollect" to ::updateCollect,
                "queryCollect" to ::queryCollect,
                "addMessagePin" to ::addMessagePin,
                "updateMessagePin" to ::updateMessagePin,
                "removeMessagePin" to ::removeMessagePin,
                "queryMessagePinForSession" to ::queryMessagePinForSession,
                "checkLocalAntiSpam" to ::checkLocalAntiSpam,
                "queryMySessionList" to ::queryMySessionList,
                "queryMySession" to ::queryMySession,
                "updateMySession" to ::updateMySession,
                "deleteMySession" to ::deleteMySession,
                "addQuickComment" to ::addQuickComment,
                "removeQuickComment" to ::removeQuickComment,
                "queryQuickComment" to ::queryQuickComment,
                "addStickTopSession" to ::addStickTopSession,
                "removeStickTopSession" to ::removeStickTopSession,
                "updateStickTopSession" to ::updateStickTopSession,
                "queryStickTopSession" to ::queryStickTopSession,
                "queryRoamMsgHasMoreTime" to ::queryRoamMsgHasMoreTime,
                "updateRoamMsgHasMoreTag" to ::updateRoamMsgHasMoreTag,
                "getMessagesDynamically" to ::getMessagesDynamically,
                "pullHistoryById" to ::pullHistoryById
            )
            msgService.registerCustomAttachmentParser { attachJsonString ->
                CustomAttachment(Utils.jsonStringToMap(attachJsonString))
            }
        }
    }

    override fun onMethodCalled(
        method: String,
        arguments: Map<String, *>,
        safeResult: SafeResult
    ) {
        when (method) {
            "sendMessage" -> sendMessage(arguments, ResultCallback(safeResult))
            "sendMessageReceipt" -> sendMessageReceipt(arguments, ResultCallback(safeResult))
            "sendTeamMessageReceipt" -> sendTeamMessageReceipt(
                arguments,
                ResultCallback(safeResult)
            )
            "refreshTeamMessageReceipt" -> refreshTeamMessageReceipt(
                arguments,
                ResultCallback(safeResult)
            )
            "fetchTeamMessageReceiptDetail" -> fetchTeamMessageReceiptDetail(
                arguments,
                ResultCallback(safeResult)
            )
            "queryTeamMessageReceiptDetail" -> queryTeamMessageReceiptDetail(
                arguments,
                ResultCallback(safeResult)
            )
            "saveMessage" -> saveMessage(arguments, ResultCallback(safeResult))
            "saveMessageToLocalEx" -> saveMessageToLocalEx(arguments, ResultCallback(safeResult))
            "updateMessage" -> updateMessage(arguments, ResultCallback(safeResult))
            "forwardMessage" -> forwardMessage(arguments, ResultCallback(safeResult))
            "voiceToText" -> voiceToText(arguments, ResultCallback(safeResult))
            "createMessage" -> createMessage(arguments, ResultCallback(safeResult))
            "queryMessageList" -> queryMessageList(arguments, ResultCallback(safeResult))
            "queryMessageListEx" -> queryMessageListEx(arguments, ResultCallback(safeResult))
            "queryLastMessage" -> queryLastMessage(arguments, ResultCallback(safeResult))
            "queryMessageListByUuid" -> queryMessageListByUuid(
                arguments,
                ResultCallback(safeResult)
            )
            "deleteChattingHistory" -> deleteChattingHistory(arguments, ResultCallback(safeResult))
            "deleteChattingHistoryList" -> deleteChattingHistoryList(
                arguments,
                ResultCallback(safeResult)
            )
            "clearChattingHistory" -> clearChattingHistory(arguments, ResultCallback(safeResult))
            "clearMsgDatabase" -> clearMsgDatabase(arguments, ResultCallback(safeResult))
            "pullMessageHistoryExType" -> pullMessageHistoryExType(
                arguments,
                ResultCallback(safeResult)
            )
            "pullMessageHistory" -> pullMessageHistory(arguments, ResultCallback(safeResult))
            "clearServerHistory" -> clearServerHistory(arguments, ResultCallback(safeResult))
            "deleteMsgSelf" -> deleteMsgSelf(arguments, ResultCallback(safeResult))
            "deleteMsgListSelf" -> deleteMsgListSelf(arguments, ResultCallback(safeResult))
            "searchMessage" -> searchMessage(arguments, ResultCallback(safeResult))
            "searchAllMessage" -> searchAllMessage(arguments, ResultCallback(safeResult))
            "searchRoamingMsg" -> searchRoamingMsg(arguments, ResultCallback(safeResult))
            "searchCloudMessageHistory" -> searchCloudMessageHistory(
                arguments,
                ResultCallback(safeResult)
            )
            "downloadAttachment" -> downloadAttachment(arguments, ResultCallback(safeResult))
            "cancelUploadAttachment" -> cancelUploadAttachment(
                arguments,
                ResultCallback(safeResult)
            )
            "revokeMessage" -> revokeMessage(arguments, ResultCallback(safeResult))
            "replyMessage" -> replyMessage(arguments, ResultCallback(safeResult))
            "queryReplyCountInThreadTalkBlock" -> queryReplyCountInThreadTalkBlock(
                arguments,
                ResultCallback(safeResult)
            )
            "queryThreadTalkHistory" -> queryThreadTalkHistory(
                arguments,
                ResultCallback(safeResult)
            )
            "convertMessageToJson" -> convertMessageToJson(
                arguments,
                ResultCallback(safeResult)
            )
            "convertJsonToMessage" -> convertJsonToMessage(
                arguments,
                ResultCallback(safeResult)
            )
            else -> safeResult.notImplemented()
        }
    }

    private fun downloadAttachment(
        arguments: Map<String, *>,
        resultCallback: ResultCallback<Void>
    ) {
        val message: IMMessage? = MessageHelper.convertIMMessage(arguments)
        val thumb = arguments["thumb"] as Boolean? ?: false
        if (message == null) {
            resultCallback.result(
                NimResult(code = -1, errorDetails = "download attachment error!")
            )
        } else {
            NIMClient.getService(MsgService::class.java)
                .queryMessageListByUuid(listOf(message.uuid))
                .setCallback(
                    object : RequestCallback<List<IMMessage>> {
                        override fun onSuccess(result: List<IMMessage>?) {
                            val firstMessage = result?.firstOrNull()
                            if (firstMessage != null && TextUtils.equals(firstMessage.uuid, message.uuid)) {
                                NIMClient.getService(MsgService::class.java)
                                    .downloadAttachment(firstMessage, thumb)
                                    .setCallback(NimResultCallback(resultCallback))
                            } else {
                                resultCallback.result(
                                    NimResult(
                                        code = -1,
                                        errorDetails = "download attachment error, query message info is empty or not correct."
                                    )
                                )
                            }
                        }

                        override fun onFailed(code: Int) {
                            resultCallback.result(
                                NimResult(code = code, errorDetails = "download attachment error, query message failed code is $code.")
                            )
                        }

                        override fun onException(exception: Throwable?) {
                            resultCallback.result(
                                NimResult(
                                    code = -1,
                                    errorDetails = "download attachment error, query message exception. exception is $exception."
                                )
                            )
                        }
                    }
                )
        }
    }

    private fun cancelUploadAttachment(
        arguments: Map<String, *>,
        resultCallback: ResultCallback<Void>
    ) {
        val message: IMMessage? = MessageHelper.convertIMMessage(arguments)
        NIMClient.getService(MsgService::class.java).cancelUploadAttachment(message)
            .setCallback(NimResultCallback<Void>(resultCallback))
    }

    private fun revokeMessage(
        arguments: Map<String, *>,
        resultCallback: ResultCallback<Void>
    ) {
        val message: IMMessage? = MessageHelper.convertIMMessage(arguments)
        val customApnsText = arguments["customApnsText"] as String?
        val pushPayload = arguments["pushPayload"] as Map<String, Any>?
        val shouldNotifyBeCount = arguments["shouldNotifyBeCount"] as Boolean? ?: true
        val postscript = arguments["postscript"] as String?
        val attach = arguments["attach"] as String?

        if (message == null) {
            resultCallback.result(
                NimResult(code = -1, errorDetails = "revokeMessage but convertIMMessage error!")
            )
        } else if (message.uuid == null) {
            resultCallback.result(
                NimResult(code = -1, errorDetails = "revokeMessage but message.uuid == null!")
            )
        } else {
            val messageUuidList = ArrayList<String>()
            messageUuidList.add(message.uuid)
            NIMClient.getService(MsgService::class.java).queryMessageListByUuid(messageUuidList)
                .setCallback(object : RequestCallback<List<IMMessage>> {
                    override fun onSuccess(param: List<IMMessage>?) {
                        val queryMessage = param?.firstOrNull()
                        if (queryMessage == null) {
                            resultCallback.result(
                                NimResult(
                                    code = -1,
                                    errorDetails = "revokeMessage but uuid can " +
                                        "not queried!"
                                )
                            )
                        } else {
                            NIMClient.getService(MsgService::class.java).revokeMessage(
                                queryMessage,
                                customApnsText,
                                pushPayload,
                                shouldNotifyBeCount,
                                postscript,
                                attach
                            ).setCallback(NimResultCallback<Void>(resultCallback))
                        }
                    }

                    override fun onFailed(code: Int) {
                        resultCallback.result(
                            NimResult(
                                code = -1,
                                errorDetails = "revokeMessage but " +
                                    "queryMessageListByUuid onFailed code = $code!"
                            )
                        )
                    }

                    override fun onException(exception: Throwable?) {
                        resultCallback.result(
                            NimResult(
                                code = -1,
                                errorDetails = "revokeMessage but " +
                                    "queryMessageListByUuid onException exception = ${exception?.message}!"
                            )
                        )
                    }
                })
        }
    }

    private fun replyMessage(
        arguments: Map<String, *>,
        resultCallback: ResultCallback<Void>
    ) {
        val message: IMMessage? =
            MessageHelper.convertIMMessage(arguments["message"] as Map<String, Any?>?)
        val replyMsg: IMMessage? =
            MessageHelper.convertIMMessage(arguments["replyMsg"] as Map<String, Any?>?)
        val resend = arguments["resend"] as Boolean? ?: false
        NIMClient.getService(MsgService::class.java).replyMessage(message, replyMsg, resend)
            .setCallback(NimResultCallback(resultCallback))
    }

    private fun queryReplyCountInThreadTalkBlock(
        arguments: Map<String, *>,
        resultCallback: ResultCallback<Int>
    ) {
        val message: IMMessage? =
            MessageHelper.convertIMMessage(arguments["message"] as Map<String, Any?>?)
        val replyCount =
            NIMClient.getService(MsgService::class.java).queryReplyCountInThreadTalkBlock(message)
        resultCallback.result(NimResult(code = 0, data = replyCount))
    }

    private fun queryThreadTalkHistory(
        arguments: Map<String, *>,
        resultCallback: ResultCallback<ThreadTalkHistory>
    ) {
        val message: IMMessage? =
            MessageHelper.convertIMMessage(arguments["message"] as Map<String, Any?>?)
        val fromTime = (arguments.getOrDefault("fromTime") { 0 } as Number).toLong()
        val toTime = (arguments["toTime"] as Number).toLong()
        val limit = (arguments["limit"] as Number).toInt()
        val direction = convertToQueryDirectionEnum((arguments["direction"] as Number).toInt())
        val persist = arguments["persist"] as Boolean? ?: false
        NIMClient.getService(MsgService::class.java)
            .queryThreadTalkHistory(message, fromTime, toTime, limit, direction, persist)
            .setCallback(
                NimResultCallback(resultCallback) { param ->
                    NimResult(
                        code = 0,
                        data = param,
                        convert = { it.toMap() }
                    )
                }
            )
    }

    private fun createMessage(
        arguments: Map<String, *>,
        resultCallback: ResultCallback<IMMessage>
    ) {
        val message: IMMessage? = MessageHelper.createMessage(arguments)
        if (message == null) {
            resultCallback.result(
                NimResult(code = -1, errorDetails = "create message error!")
            )
        } else {
            resultCallback.result(
                NimResult(code = 0, message) { it.toMap() }
            )
        }
    }

    private fun convertMessageToJson(
        arguments: Map<String, *>,
        resultCallback: ResultCallback<String>
    ) {
        val message: IMMessage? = MessageHelper.convertIMMessage(arguments)
        if (message == null) {
            resultCallback.result(
                NimResult(code = -1, errorDetails = "convert message error!")
            )
        } else {
            resultCallback.result(
                NimResult(code = 0, MessageBuilder.convertMessageToJson(message))
            )
        }
    }

    private fun convertJsonToMessage(
        arguments: Map<String, *>,
        resultCallback: ResultCallback<IMMessage>
    ) {
        val json: String? = arguments["messageJson"] as String?
        if (json == null) {
            resultCallback.result(
                NimResult(code = -1, errorDetails = "convert json error!")
            )
        } else {
            resultCallback.result(
                NimResult(code = 0, MessageBuilder.createFromJson(json)) {
                    it.toMap()
                }
            )
        }
    }

    // 消息ID会重置
    private fun sendMessage(
        arguments: Map<String, *>,
        resultCallback: ResultCallback<IMMessage>
    ) {
        val message: IMMessage? = MessageHelper.convertIMMessage(arguments)
        val resend = arguments["resend"] as Boolean? ?: false
        if (message == null) {
            resultCallback.result(
                NimResult(code = -1, errorDetails = "create message error!")
            )
        } else {
            val future = if (message.sessionType == SessionTypeEnum.SUPER_TEAM) {
                NIMClient.getService(SuperTeamService::class.java).sendMessage(message, resend)
            } else {
                NIMClient.getService(MsgService::class.java).sendMessage(message, resend)
            }
            if (future == null) {
                ALog.e(tag, "send message error! message = ${getMessageInfo(message)}")
                resultCallback.result(
                    NimResult(
                        code = -2,
                        errorDetails = "send message error! message = ${getMessageInfo(message)}"
                    )
                )
            } else {
                future.setCallback(object : RequestCallback<Void> {
                    override fun onSuccess(param: Void?) {
                        // / 发送成功后，有部分字段会被更新
                        // / 所以需要重新从数据库中查询到对应的消息对象，这样才能获取对应的字段
                        NIMClient.getService(MsgService::class.java)
                            .queryMessageListByUuid(listOf(message.uuid))
                            .setCallback(
                                object : RequestCallback<List<IMMessage>> {
                                    override fun onSuccess(messages: List<IMMessage>?) {
                                        if (messages?.isNotEmpty() == true) {
                                            resultCallback.result(
                                                NimResult(code = 0, messages[0]) { it.toMap() }
                                            )
                                        } else {
                                            ALog.e(
                                                tag,
                                                "find send message is empty"
                                            )
                                            resultCallback.result(
                                                NimResult(
                                                    code = -3,
                                                    errorDetails = "find send message is empty"
                                                )
                                            )
                                        }
                                    }

                                    override fun onFailed(code: Int) {
                                        ALog.e(
                                            tag,
                                            "find message failed! errorCode  = $code message = ${
                                                getMessageInfo(message)
                                            }"
                                        )
                                        resultCallback.result(
                                            NimResult(
                                                code = code,
                                                errorDetails = "find message failed"
                                            )
                                        )
                                    }

                                    override fun onException(exception: Throwable?) {
                                        ALog.e(
                                            tag,
                                            "cannot find send message! message = ${
                                                getMessageInfo(message)
                                            }  exception = $exception"
                                        )
                                        resultCallback.result(
                                            NimResult(
                                                code = -2,
                                                errorDetails = "cannot find send message= ${
                                                    getMessageInfo(message)
                                                }  exception = $exception"
                                            )
                                        )
                                    }
                                }
                            )
                    }

                    override fun onFailed(code: Int) {
                        ALog.e(
                            tag,
                            "send message failed! errorCode = $code message = ${
                                getMessageInfo(message)
                            }"
                        )
                        resultCallback.result(
                            NimResult(code = code, errorDetails = "send message failed!")
                        )
                    }

                    override fun onException(exception: Throwable?) {
                        ALog.e(
                            tag,
                            "send message exception! message = ${getMessageInfo(message)} exception = $exception"
                        )
                        resultCallback.result(
                            NimResult(
                                code = -2,
                                errorDetails = "send message exception：message = ${
                                    getMessageInfo(message)
                                } exception = $exception"
                            )
                        )
                    }
                })
            }
        }
    }

    private fun getMessageInfo(message: IMMessage): String {
        return "uuid = ${message.uuid} serverId = ${message.serverId} sessionId = ${message.sessionId}" +
            " sessionType = ${message.sessionType} msgType = ${message.msgType}"
    }

    private fun sendMessageReceipt(
        arguments: Map<String, *>,
        resultCallback: ResultCallback<Void>
    ) {
        val message: IMMessage? = MessageHelper.convertIMMessage(arguments)
        val sessionId = arguments["sessionId"] as String?
        when {
            message == null -> {
                resultCallback.result(
                    NimResult(
                        code = -1,
                        errorDetails = "sendMessageReceipt but message error!"
                    )
                )
            }
            sessionId == null -> {
                resultCallback.result(
                    NimResult(
                        code = -1,
                        errorDetails = "sendMessageReceipt but sessionId is null!"
                    )
                )
            }
            else -> {
                NIMClient.getService(MsgService::class.java).sendMessageReceipt(sessionId, message)
                    .setCallback(NimResultCallback(resultCallback))
            }
        }
    }

    private fun sendTeamMessageReceipt(
        arguments: Map<String, *>,
        resultCallback: ResultCallback<Void>
    ) {
        when (val message: IMMessage? = MessageHelper.convertIMMessage(arguments)) {
            null -> {
                resultCallback.result(
                    NimResult(
                        code = -1,
                        errorDetails = "sendTeamMessageReceipt but message error!"
                    )
                )
            }
            else -> {
                NIMClient.getService(TeamService::class.java).sendTeamMessageReceipt(message)
                    .setCallback(NimResultCallback(resultCallback))
            }
        }
    }

    private fun refreshTeamMessageReceipt(
        arguments: Map<String, *>,
        resultCallback: ResultCallback<IMMessage>
    ) {
        val messageList: List<IMMessage?> =
            (arguments["messageList"] as List<*>).map { MessageHelper.convertIMMessage(it as Map<String, *>) }
                .toList()
        NIMClient.getService(TeamService::class.java).refreshTeamMessageReceipt(messageList)
        resultCallback.result(NimResult(code = 0))
    }

    private fun fetchTeamMessageReceiptDetail(
        arguments: Map<String, *>,
        resultCallback: ResultCallback<TeamMsgAckInfo>
    ) {
        val message: IMMessage? = MessageHelper.convertIMMessage(arguments)
        val accountList = arguments["accountList"] as List<String>?
        if (message == null) {
            resultCallback.result(
                NimResult(code = -1, errorDetails = "fetchTeamMessageReceiptDetail but message error!")
            )
        } else {
            val future = if (accountList?.isNotEmpty() == true) {
                NIMClient.getService(TeamService::class.java)
                    .fetchTeamMessageReceiptDetail(message, accountList.toSet())
            } else {
                NIMClient.getService(TeamService::class.java)
                    .fetchTeamMessageReceiptDetail(message)
            }
            if (future == null) {
                resultCallback.result(
                    NimResult(code = -2, errorDetails = "fetchTeamMessageReceiptDetail error!")
                )
            } else {
                future.setCallback(
                    NimResultCallback(resultCallback) { data ->
                        NimResult(
                            code = 0,
                            data = data,
                            convert = { it.toMap() }
                        )
                    }
                )
            }
        }
    }

    private fun queryTeamMessageReceiptDetail(
        arguments: Map<String, *>,
        resultCallback: ResultCallback<TeamMsgAckInfo>
    ) {
        val message: IMMessage? = MessageHelper.convertIMMessage(arguments)
        val accountList = arguments["accountList"] as List<String>?
        if (message == null) {
            resultCallback.result(
                NimResult(code = -1, errorDetails = "queryTeamMessageReceiptDetail but message error!")
            )
        } else {
            val receiptDetail = NIMClient.getService(TeamService::class.java)
                .queryTeamMessageReceiptDetailBlock(message, accountList?.toSet())
            resultCallback.result(
                NimResult(code = 0, receiptDetail) { it.toMap() }
            )
        }
    }

    // 本地消息插入
    private fun saveMessage(
        arguments: Map<String, *>,
        resultCallback: ResultCallback<IMMessage>
    ) {
        val message: IMMessage? = MessageHelper.convertIMMessage(arguments)
        val fromAccount = arguments["fromAccount"] as String?
        if (message == null) {
            resultCallback.result(
                NimResult(code = -1, errorDetails = "saveMessage but convertIMMessage error!")
            )
        }
        if (TextUtils.isEmpty(fromAccount)) {
            resultCallback.result(
                NimResult(code = -1, errorDetails = "saveMessage but fromAccount is empty error!")
            )
        } else {
            message?.fromAccount = fromAccount
            val future = NIMClient.getService(MsgService::class.java)
                .saveMessageToLocal(message, true)
            if (future == null) {
                resultCallback.result(
                    NimResult(code = -2, errorDetails = "save message error!")
                )
            } else {
                future.setCallback(object : RequestCallback<Void> {
                    override fun onSuccess(param: Void?) {
                        resultCallback.result(
                            NimResult(code = 0, message) { it.toMap() }
                        )
                    }

                    override fun onFailed(code: Int) {
                        resultCallback.result(
                            NimResult(code = code, errorDetails = "save message failed!")
                        )
                    }

                    override fun onException(exception: Throwable?) {
                        resultCallback.result(
                            NimResult(code = -2, errorDetails = "save message exception：$exception")
                        )
                    }
                })
            }
        }
    }

    // 本地消息插入
    private fun saveMessageToLocalEx(
        arguments: Map<String, *>,
        resultCallback: ResultCallback<IMMessage>
    ) {
        val message: IMMessage? = MessageHelper.convertIMMessage(arguments)
        val time = (arguments["time"] as Number?)?.toLong()
        if (time == null) {
            resultCallback.result(
                NimResult(code = -1, errorDetails = "saveMessageToLocalEx but time is empty error!")
            )
        } else {
            // 保存之前的消息状态变成success，确保查询结果状态是success
            message?.status = MsgStatusEnum.success
            //  由于 iOS 端 notify 字段不支持设置为 false，对齐 iOS
            val future = NIMClient.getService(MsgService::class.java)
                .saveMessageToLocalEx(message, true, time)
            if (future == null) {
                resultCallback.result(
                    NimResult(code = -2, errorDetails = "saveMessageToLocalEx error!")
                )
            } else {
                future.setCallback(object : RequestCallback<Void> {
                    override fun onSuccess(param: Void?) {
                        resultCallback.result(
                            NimResult(code = 0, message) { it.toMap() }
                        )
                    }

                    override fun onFailed(code: Int) {
                        resultCallback.result(
                            NimResult(code = code, errorDetails = "saveMessageToLocalEx failed!")
                        )
                    }

                    override fun onException(exception: Throwable?) {
                        resultCallback.result(
                            NimResult(
                                code = -2,
                                errorDetails = "saveMessageToLocalEx exception：$exception"
                            )
                        )
                    }
                })
            }
        }
    }

    // 更新消息
    private fun updateMessage(
        arguments: Map<String, *>,
        resultCallback: ResultCallback<Void>
    ) {
        val message: IMMessage? = MessageHelper.convertIMMessage(arguments)
        if (message == null) {
            resultCallback.result(
                NimResult(code = -1, errorDetails = "update message error!")
            )
        } else {
            NIMClient.getService(MsgService::class.java).updateIMMessage(message)
            resultCallback.result(NimResult(code = 0))
        }
    }

    // 转发消息
    private fun forwardMessage(
        arguments: Map<String, *>,
        resultCallback: ResultCallback<Void>
    ) {
        val message: IMMessage? = MessageHelper.convertIMMessage(arguments)
        val sessionId = arguments["sessionId"] as String?
        val sessionType = stringToSessionTypeEnum(arguments["sessionType"] as String)
        if (message == null) {
            resultCallback.result(
                NimResult(code = -1, errorDetails = "forward message but message error!")
            )
        }

        if (TextUtils.isEmpty(sessionId)) {
            resultCallback.result(
                NimResult(code = -1, errorDetails = "forward message but sessionId is empty!")
            )
        } else {
            val newMessage = MessageBuilder.createForwardMessage(message, sessionId, sessionType)
            if (message?.needMsgAck() == true) {
                newMessage.setMsgAck()
            }
            NIMClient.getService(MsgService::class.java).sendMessage(newMessage, false)
                .setCallback(NimResultCallback(resultCallback))
        }
    }

    private fun voiceToText(arguments: Map<String, *>, resultCallback: ResultCallback<String>) {
        val message: IMMessage? = MessageHelper.convertIMMessage(arguments)
        val attachment = message?.attachment as AudioAttachment
        if (attachment?.path != null) {
            val future = NIMClient.getService(MsgService::class.java).transVoiceToTextEnableForce(
                attachment.url,
                attachment.path,
                attachment.duration,
                attachment.nosTokenSceneKey,
                false
            )
            future.setCallback(NimResultCallback(resultCallback))
        }
    }

    private fun listMessageRequestCallback(
        resultCallback: ResultCallback<List<IMMessage>>,
        reversed: Boolean = false
    ) =
        NimResultCallback(resultCallback) { data ->
            NimResult(
                code = 0,
                data = data,
                convert = { list ->
                    mutableMapOf(
                        if (reversed) {
                            "messageList" to list.map { it.toMap() }.toList().reversed()
                        } else {
                            "messageList" to list.map { it.toMap() }.toList()
                        }
                    )
                }
            )
        }

    private fun queryMessageListEx(
        arguments: Map<String, *>,
        resultCallback: ResultCallback<List<IMMessage>>
    ) {
        val message: IMMessage? =
            MessageHelper.convertIMMessage(arguments["message"] as Map<String, Any?>?)
        val direction =
            if ((arguments["direction"] as Number).toInt() == 0) QueryDirectionEnum.QUERY_OLD else QueryDirectionEnum.QUERY_NEW
        val limit = (arguments["limit"] as Number).toInt()
        NIMClient.getService(MsgService::class.java)
            .queryMessageListEx(message, direction, limit, true)
            .setCallback(listMessageRequestCallback(resultCallback))
    }

    private suspend fun pullHistoryById(
        arguments: Map<String, *>
    ): NimResult<List<IMMessage>> {
        val msgKeyList = (arguments["msgKeyList"] as List<Map<String, *>>?)?.map { convertToMessageKey(it) }?.toList()
        val persist = arguments["persist"] as Boolean? ?: false
        return suspendCancellableCoroutine { cont ->
            NIMClient.getService(MsgService::class.java).pullHistoryById(msgKeyList, persist)
                .setCallback(
                    NimResultContinuationCallback(cont) { result ->
                        NimResult(
                            code = 0,
                            data = result,
                            convert = { mapOf("messageList" to it.map { e -> e.toMap() }.toList()) }
                        )
                    }
                )
        }
    }

    private fun queryMessageList(
        arguments: Map<String, *>,
        resultCallback: ResultCallback<List<IMMessage>>
    ) {
        val sessionType = stringToSessionTypeEnum(arguments["sessionType"] as String)
        val account = arguments["account"] as String
        val limit = (arguments["limit"] as Number).toInt()
        val offset = (arguments.getOrDefault("offset", 0L) as Number).toLong()
        NIMClient.getService(MsgService::class.java)
            .queryMessageList(account, sessionType, offset, limit)
            .setCallback(listMessageRequestCallback(resultCallback, reversed = true))
    }

    private fun queryLastMessage(
        arguments: Map<String, *>,
        resultCallback: ResultCallback<IMMessage>
    ) {
        val account = arguments["account"] as String
        val sessionType = stringToSessionTypeEnum(arguments["sessionType"] as String)
        var message =
            NIMClient.getService(MsgService::class.java).queryLastMessage(account, sessionType)
        resultCallback.result(NimResult(code = 0, message) { it.toMap() })
    }

    private fun queryMessageListByUuid(
        arguments: Map<String, *>,
        resultCallback: ResultCallback<List<IMMessage>>
    ) {
        val uuidList = arguments["uuidList"] as List<String>
        NIMClient.getService(MsgService::class.java).queryMessageListByUuid(uuidList)
            .setCallback(listMessageRequestCallback(resultCallback))
    }

    private fun deleteChattingHistory(
        arguments: Map<String, *>,
        resultCallback: ResultCallback<String>
    ) {
        val message: IMMessage? =
            MessageHelper.convertIMMessage(arguments["message"] as Map<String, Any?>?)
        val ignore = arguments["ignore"] as Boolean
        NIMClient.getService(MsgService::class.java).deleteChattingHistory(message, ignore)
        resultCallback.result(NimResult(code = 0))
    }

    private fun deleteChattingHistoryList(
        arguments: Map<String, *>,
        resultCallback: ResultCallback<String>
    ) {
        val messageList: List<IMMessage?> =
            (arguments["messageList"] as List<*>).map { MessageHelper.convertIMMessage(it as Map<String, *>) }
                .toList()
        val ignore = arguments["ignore"] as Boolean
        NIMClient.getService(MsgService::class.java).deleteChattingHistory(messageList, ignore)
        resultCallback.result(NimResult(code = 0))
    }

    private fun clearChattingHistory(
        arguments: Map<String, *>,
        resultCallback: ResultCallback<String>
    ) {
        val account = arguments["account"] as String
        val sessionType = stringToSessionTypeEnum(arguments["sessionType"] as String)
        val ignore = arguments["ignore"] as Boolean? ?: false
        NIMClient.getService(MsgService::class.java)
            .clearChattingHistory(account, sessionType, ignore)
        resultCallback.result(NimResult(code = 0))
    }

    private fun clearMsgDatabase(
        arguments: Map<String, *>,
        resultCallback: ResultCallback<String>
    ) {
        val clearRecent = arguments["clearRecent"] as Boolean
        NIMClient.getService(MsgService::class.java).clearMsgDatabase(clearRecent).setCallback(
            object : RequestCallback<Void> {
                override fun onSuccess(result: Void?) {
                    resultCallback.result(NimResult(code = 0))
                }

                override fun onFailed(code: Int) {
                    resultCallback.result(NimResult(code = code))
                }

                override fun onException(exception: Throwable?) {
                    resultCallback.result(NimResult(code = -1, errorDetails = exception?.message))
                }
            }
        )
    }

    private fun pullMessageHistoryExType(
        arguments: Map<String, *>,
        resultCallback: ResultCallback<List<IMMessage>>
    ) {
        val message: IMMessage? =
            MessageHelper.convertIMMessage(arguments["message"] as Map<String, Any?>?)
        val toTime = (arguments["toTime"] as Number).toLong()
        val limit = (arguments["limit"] as Number).toInt()
        val direction = convertToQueryDirectionEnum((arguments["direction"] as Number).toInt())
        val messageTypeList =
            (arguments["messageTypeList"] as List<String>).map { stringToMsgTypeEnum(it) }
                .toTypedArray()
        val persist = arguments["persist"] as Boolean
        NIMClient.getService(MsgService::class.java).pullMessageHistoryExType(
            message,
            toTime,
            limit,
            direction,
            messageTypeList,
            persist,
            false
        ).setCallback(listMessageRequestCallback(resultCallback))
    }

    private fun pullMessageHistory(
        arguments: Map<String, *>,
        resultCallback: ResultCallback<List<IMMessage>>
    ) {
        val message: IMMessage? =
            MessageHelper.convertIMMessage(arguments["message"] as Map<String, Any?>?)
        val limit = (arguments["limit"] as Number).toInt()
        val persist = arguments["persist"] as Boolean
        NIMClient.getService(MsgService::class.java)
            .pullMessageHistory(message, limit, persist, false)
            .setCallback(listMessageRequestCallback(resultCallback))
    }

    private fun clearServerHistory(
        arguments: Map<String, *>,
        resultCallback: ResultCallback<String>
    ) {
        val sessionId = arguments["sessionId"] as String
        val sessionType = stringToSessionTypeEnum(arguments["sessionType"] as String)
        val sync = arguments["sync"] as Boolean
        NIMClient.getService(MsgService::class.java)
            .clearServerHistory(sessionId, sessionType, sync, null)
        resultCallback.result(NimResult(code = 0))
    }

    private fun deleteMsgSelf(arguments: Map<String, *>, resultCallback: ResultCallback<Long>) {
        val message: IMMessage? =
            MessageHelper.convertIMMessage(arguments["message"] as Map<String, Any?>?)
        val ext = arguments["ext"] as String
        NIMClient.getService(MsgService::class.java).deleteMsgSelf(message, ext)
            .setCallback(NimResultCallback(resultCallback))
    }

    private fun deleteMsgListSelf(arguments: Map<String, *>, resultCallback: ResultCallback<Long>) {
        val messageList: List<IMMessage?> =
            (arguments["messageList"] as List<*>).map { MessageHelper.convertIMMessage(it as Map<String, *>) }
                .toList()
        val ext = arguments["ext"] as String
        NIMClient.getService(MsgService::class.java).deleteMsgSelf(messageList, ext)
            .setCallback(NimResultCallback(resultCallback))
    }

    private fun searchMessage(
        arguments: Map<String, *>,
        resultCallback: ResultCallback<List<IMMessage>>
    ) {
        val sessionType = stringToSessionTypeEnum(arguments["sessionType"] as String)
        val sessionId = arguments["sessionId"] as String
        val searchOption = convertToSearchOption(arguments["searchOption"] as Map<String, *>)
        NIMClient.getService(MsgService::class.java)
            .searchMessage(sessionType, sessionId, searchOption)
            .setCallback(listMessageRequestCallback(resultCallback))
    }

    private fun searchAllMessage(
        arguments: Map<String, *>,
        resultCallback: ResultCallback<List<IMMessage>>
    ) {
        val searchOption = convertToSearchOption(arguments["searchOption"] as Map<String, *>)
        NIMClient.getService(MsgService::class.java).searchAllMessage(searchOption)
            .setCallback(listMessageRequestCallback(resultCallback))
    }

    private fun searchRoamingMsg(
        arguments: Map<String, *>,
        resultCallback: ResultCallback<ArrayList<IMMessage>>
    ) {
        val otherAccid = arguments["otherAccid"] as String
        val fromTime = (arguments.getOrDefault("fromTime", 0L) as Number).toLong()
        val endTime = (arguments.getOrDefault("endTime", 0L) as Number).toLong()
        val keyword = arguments["keyword"] as String
        val limit = (arguments.getOrDefault("limit", 100) as Number).toInt()
        val reverse = arguments["reverse"] as Boolean
        NIMClient.getService(MsgService::class.java)
            .searchRoamingMsg(otherAccid, fromTime, endTime, keyword, limit, reverse)
            .setCallback(
                NimResultCallback(resultCallback) { data ->
                    NimResult(
                        code = 0,
                        data = data,
                        convert = { list ->
                            mutableMapOf(
                                "messageList" to list.map { it.toMap() }.toList()
                            )
                        }
                    )
                }
            )
    }

    private fun searchCloudMessageHistory(
        arguments: Map<String, *>,
        resultCallback: ResultCallback<List<IMMessage>>
    ) {
        val searchConfig: MsgFullKeywordSearchConfig =
            convertToSearchConfig(arguments["messageKeywordSearchConfig"] as Map<String, Any?>?)
        NIMClient.getService(MsgService::class.java).pullMessageHistory(searchConfig)
            .setCallback(listMessageRequestCallback(resultCallback))
    }

    private suspend fun querySessionList(arguments: Map<String, *>): NimResult<List<RecentContact>> {
        return suspendCancellableCoroutine { cont ->
            val limit = (arguments.getOrElse("limit") { 0 } as Number).toInt()
            if (limit > 0) { // TODO: iOS 没有条数参数
                msgService.queryRecentContacts(limit)
            } else {
                msgService.queryRecentContacts()
            }.setCallback(
                NimResultContinuationCallback(cont) { result ->
                    NimResult(
                        code = 0,
                        data = result,
                        convert = { data -> mapOf("resultList" to data.map { it.toMap() }.toList()) }
                    )
                }
            )
        }
    }

    private suspend fun querySessionListFiltered(arguments: Map<String, *>): NimResult<List<RecentContact>> {
        return suspendCancellableCoroutine { cont ->
            val filterMessageTypeList: List<String>? by arguments.withDefault { null }
            msgService.queryRecentContacts(
                filterMessageTypeList?.map { stringToMsgTypeEnum(it) }?.toSet() ?: setOf()
            ).setCallback(
                NimResultContinuationCallback(cont) { result ->
                    NimResult(
                        code = 0,
                        data = result,
                        convert = { data ->
                            mapOf("resultList" to data.map { it.toMap() }.toList())
                        }
                    )
                }
            )
        }
    }

    private suspend fun querySession(arguments: Map<String, *>): NimResult<RecentContact> {
        val sessionId: String by arguments
        val sessionType = stringToSessionTypeEnum(arguments["sessionType"] as String)
        val result = withContext(Dispatchers.IO) {
            msgService.queryRecentContact(sessionId, sessionType)
        }
        return NimResult(
            code = 0,
            data = result,
            convert = { it.toMap() }
        )
    }

    private suspend fun createSession(arguments: Map<String, *>): NimResult<RecentContact> {
        val sessionId: String by arguments
        val sessionType = stringToSessionTypeEnum(arguments["sessionType"] as String)
        val tag: Number by arguments
        val time: Number by arguments
        val linkToLastMessage: Boolean by arguments
        return withContext(Dispatchers.IO) {
            msgService.createEmptyRecentContact(
                sessionId,
                sessionType,
                tag.toLong(),
                time.toLong(),
                true,
                linkToLastMessage
            ).let { result ->
                NimResult(
                    code = 0,
                    data = result,
                    convert = { it.toMap() }
                )
            }
        }
    }

    private suspend fun updateSession(arguments: Map<String, *>): NimResult<Nothing> {
        val needNotify: Boolean by arguments
        val session: Map<String, *> by arguments
        val sessionId: String by session
        val sessionType = stringToSessionTypeEnum(session["sessionType"] as String)
        val tag: Number? by session
        val extension: Map<String, Any>? by session
        return withContext(Dispatchers.IO) {
            msgService.queryRecentContact(sessionId, sessionType)?.let {
                tag?.let { e ->
                    it.tag = e.toLong()
                }
                it.extension = extension
                if (needNotify) {
                    msgService.updateRecentAndNotify(it)
                } else {
                    msgService.updateRecent(it)
                }
                NimResult.SUCCESS
            } ?: NimResult.FAILURE
        }
    }

    private suspend fun updateSessionWithMessage(arguments: Map<String, *>): NimResult<Nothing> {
        val needNotify: Boolean by arguments
        val message: Map<String, *> by arguments
        return withContext(Dispatchers.IO) {
            msgService.updateRecentByMessage(MessageHelper.convertIMMessage(message), needNotify)
            NimResult.SUCCESS
        }
    }

    private suspend fun queryTotalUnreadCount(arguments: Map<String, *>): NimResult<Int> {
        val queryType: Int by arguments
        val count = withContext(Dispatchers.IO) {
            val queryTypeAll = 0
            val queryTypeNotifyOnly = 1
            val queryTypeNoDisturbOnly = 2
            when (queryType) {
                queryTypeAll -> {
                    msgService.totalUnreadCount
                }
                else -> {
                    msgService.getTotalUnreadCount(queryType == queryTypeNotifyOnly)
                }
            }
        }
        return NimResult(
            code = 0,
            data = count,
            convert = { mapOf("count" to count) }
        )
    }

    private suspend fun setChattingAccount(arguments: Map<String, *>): NimResult<Nothing> {
        val sessionId: String by arguments
        val sessionType = stringToSessionTypeEnum(arguments["sessionType"] as String)
        msgService.setChattingAccount(sessionId, sessionType)
        return NimResult.SUCCESS
    }

    private suspend fun clearSessionUnreadCount(arguments: Map<String, *>): NimResult<List<SessionAckInfo>> {
        return suspendCancellableCoroutine { cont ->
            val requestList: List<Map<String, String>> by arguments
            msgService.clearUnreadCount(
                requestList.map {
                    val sessionId = it["sessionId"] as String
                    val sessionType = stringToSessionTypeEnum(it["sessionType"] as String)
                    android.util.Pair(sessionId, sessionType)
                }.toList()
            ).setCallback(
                NimResultContinuationCallback(cont) { result ->
                    fun SessionAckInfo.toMap() = mapOf(
                        "sessionId" to sessionId,
                        "sessionType" to stringFromSessionTypeEnum(sessionType)
                    )
                    NimResult(
                        code = 0,
                        data = result,
                        convert = { list -> mapOf("failList" to list.map { it.toMap() }.toList()) }
                    )
                }
            )
        }
    }

    private suspend fun clearAllSessionUnreadCount(arguments: Map<String, *>): NimResult<Nothing> {
        return withContext(Dispatchers.IO) {
            runCatching {
                msgService.clearAllUnreadCount()
                NimResult.SUCCESS
            }
        }.getOrElse { NimResult.FAILURE }
    }

    private suspend fun deleteSession(arguments: Map<String, *>): NimResult<Nothing> {
        val sessionInfo: Map<String, Any> by arguments
        val sessionId: String by sessionInfo
        val sessionType = stringToSessionTypeEnum(sessionInfo["sessionType"] as String)
        val deleteType: String by arguments
        val sendAck: Boolean by arguments
        val deleteTypeEnum =
            when (deleteType) {
                "local" -> DeleteTypeEnum.LOCAL
                "remote" -> DeleteTypeEnum.REMOTE
                else -> DeleteTypeEnum.LOCAL_AND_REMOTE
            }
        val contact = withContext(Dispatchers.IO) {
            msgService.queryRecentContact(sessionId, sessionType)
        }
        val result = suspendCancellableCoroutine<NimResult<Nothing>> { cont ->
            msgService.deleteRecentContact(
                sessionId,
                sessionType,
                deleteTypeEnum,
                sendAck
            ).setCallback(NimResultContinuationCallbackOfNothing(cont))
        }
        // 4个入参的 deleteRecentContact 方法不会触发 recentContactDeleteObserver 回调
        // 需要手动触发一下
        if (result.isSuccess && contact != null && (
                deleteTypeEnum == DeleteTypeEnum.LOCAL ||
                    deleteTypeEnum == DeleteTypeEnum.LOCAL_AND_REMOTE
                )
        ) {
            notifyEvent("onSessionDelete", contact.toMap())
        }
        return result
    }

    private suspend fun addCollect(arguments: Map<String, *>): NimResult<CollectInfo> {
        val args = arguments.withDefault { null }
        val type: Number by args
        val data: String by args
        val ext: String? by args
        val uniqueId: String? by args
        return suspendCancellableCoroutine { cont ->
            msgService.addCollect(
                type.toInt(),
                data,
                ext,
                uniqueId
            ).setCallback(
                NimResultContinuationCallback(cont) { collectInfo ->
                    NimResult(
                        code = 0,
                        data = collectInfo,
                        convert = { it.toMap() }
                    )
                }
            )
        }
    }

    private suspend fun removeCollect(arguments: Map<String, *>): NimResult<Int> {
        val args = arguments.withDefault { null }
        val collects: List<Map<String, *>> by args
        return suspendCancellableCoroutine { cont ->
            msgService.removeCollect(
                collects.map { collect ->
                    val id: Number by collect
                    val createTime: Number by collect
                    Pair(id.toLong(), createTime.toLong())
                }.toList()
            ).setCallback(
                NimResultContinuationCallback(cont) { value ->
                    NimResult(
                        code = 0,
                        data = value
                    )
                }
            )
        }
    }

    private suspend fun updateCollect(arguments: Map<String, *>): NimResult<CollectInfo> {
        val args = arguments.withDefault { null }
        val id: Number by args
        val createTime: Number by args
        val ext: String? by args
        return suspendCancellableCoroutine { cont ->
            msgService.updateCollect(
                id.toLong(),
                createTime.toLong(),
                ext
            ).setCallback(
                NimResultContinuationCallback(cont) { collectInfo ->
                    NimResult(
                        code = 0,
                        data = collectInfo,
                        convert = { it.toMap() }
                    )
                }
            )
        }
    }

    private suspend fun queryCollect(arguments: Map<String, *>): NimResult<CollectInfoPage> {
        val args = arguments.withDefault { null }
        val anchor: Map<String, *>? by args
        val toTime: Number by args
        val limit: Number by args
        val type: Number? by args
        val direction: Number by args
        return suspendCancellableCoroutine { cont ->
            val future = if (type != null) {
                msgService.queryCollect(
                    NimCollectInfo.fromMap(anchor),
                    toTime.toLong(),
                    limit.toInt(),
                    convertToQueryDirectionEnum(direction.toInt()),
                    type!!.toInt(),
                    true
                )
            } else {
                msgService.queryCollect(
                    NimCollectInfo.fromMap(anchor),
                    toTime.toLong(),
                    limit.toInt(),
                    convertToQueryDirectionEnum(direction.toInt())
                )
            }

            future.setCallback(
                NimResultContinuationCallback(cont) { collectInfoPage ->
                    NimResult(
                        code = 0,
                        data = collectInfoPage,
                        convert = { data ->
                            mapOf(
                                "totalCount" to data.total,
                                "collects" to (data.collectList ?: emptyList()).map { it.toMap() }
                                    .toList()
                            )
                        }
                    )
                }
            )
        }
    }

    private suspend fun addMessagePin(arguments: Map<String, *>): NimResult<Long> {
        val args = arguments.withDefault { null }
        val message: Map<String, *> by args
        val ext: String? by args
        return suspendCancellableCoroutine { cont ->
            msgService.addMsgPin(
                MessageHelper.convertIMMessage(message),
                ext
            ).setCallback(NimResultContinuationCallback(cont))
        }
    }

    private suspend fun updateMessagePin(arguments: Map<String, *>): NimResult<Long> {
        val args = arguments.withDefault { null }
        val message: Map<String, *> by args
        val ext: String? by args
        return suspendCancellableCoroutine { cont ->
            msgService.updateMsgPin(
                MessageHelper.convertIMMessage(message),
                ext
            ).setCallback(NimResultContinuationCallback(cont))
        }
    }

    private suspend fun removeMessagePin(arguments: Map<String, *>): NimResult<Long> {
        val args = arguments.withDefault { null }
        val message: Map<String, *> by args
        val ext: String? by args
        return suspendCancellableCoroutine { cont ->
            msgService.removeMsgPin(
                MessageHelper.convertIMMessage(message),
                ext
            ).setCallback(NimResultContinuationCallback(cont))
        }
    }

    private suspend fun queryMessagePinForSession(arguments: Map<String, *>): NimResult<List<MsgPinDbOption>> {
        val args = arguments.withDefault { null }
        val sessionId: String by args
        val sessionType = stringToSessionTypeEnum(args["sessionType"] as String)
        val key = sessionId to sessionType
        val timestamp = messagePinSyncTimestamp.getOrElse(key) { 0 }

        var pinMessageKeys = emptyList<MessageKey>()
        // sync first
        suspendCancellableCoroutine<NimResult<MsgPinSyncResponseOptionWrapper>> { cont ->
            msgService.syncMsgPin(sessionType, sessionId, timestamp)
                .setCallback(
                    NimResultContinuationCallback(cont) {
                        ALog.d(tag, "syncMsgPin size  = ${it?.msgPinInfoList?.size}")
                        messagePinSyncTimestamp[key] = it?.time ?: 0
                        pinMessageKeys = it?.msgPinInfoList?.map { e -> e.key } ?: emptyList()
                        NimResult(code = 0, data = it)
                    }
                )
        }
        // query from db
        return withContext(Dispatchers.IO) {
            val result = msgService.queryMsgPinBlock(sessionId, sessionType)
            val messages = msgService.queryMessageListByUuidBlock(result.map { it.uuid }.toList())
            val localMessageIds = messages.map { it.uuid }.toList()
            val remoteUUIDs = result.filter { !localMessageIds.contains(it.uuid) }.map { it.uuid }
            if (remoteUUIDs.isNotEmpty()) {
                val remoteMsgKey = pinMessageKeys.filter { remoteUUIDs.contains(it.uuid) }.toList()
                suspendCancellableCoroutine<List<NIMMessage>> { cont ->
                    msgService.pullHistoryById(remoteMsgKey, true)
                        .setCallback(
                            object : RequestCallback<List<IMMessage?>?> {
                                override fun onSuccess(param: List<IMMessage?>?) {
                                    param?.let {
                                        messages.addAll(it.filterNotNull())
                                    }
                                    cont.resume(param?.filterNotNull() ?: emptyList())
                                }

                                override fun onFailed(code: Int) {
                                    cont.resume(emptyList())
                                }

                                override fun onException(exception: Throwable) {
                                    cont.resume(emptyList())
                                }
                            }
                        )
                }
            }
            val messageMap = messages.groupBy { it.uuid }
            val pinList = result.map { msgPinDbOption ->
                msgPinDbOption.toMap(sessionType, messageMap[msgPinDbOption.uuid]?.getOrNull(0))
            }.toList()
            NimResult(
                code = 0,
                data = result,
                convert = {
                    mapOf("pinList" to pinList)
                }
            )
        }
    }

    private suspend fun checkLocalAntiSpam(arguments: Map<String, *>): NimResult<LocalAntiSpamResult> {
        val content: String by arguments
        val replacement: String by arguments
        return withContext(Dispatchers.IO) {
            val result = msgService.checkLocalAntiSpam(content, replacement)
            NimResult(
                code = 0,
                data = result,
                convert = {
                    mapOf(
                        "operator" to it.operator,
                        "content" to it.content
                    )
                }
            )
        }
    }

    private suspend fun queryMySessionList(arguments: Map<String, *>): NimResult<RecentSessionList> {
        val minTimestamp = (arguments.getOrElse("minTimestamp") { 0L } as Number).toLong()
        val maxTimestamp = (arguments.getOrElse("maxTimestamp") { 0L } as Number).toLong()
        val needLastMsg = arguments["needLastMsg"] as Int
        val limit = arguments["limit"] as Int
        val hasMore = arguments["hasMore"] as Int
        return suspendCancellableCoroutine { cont ->
            msgService.queryMySessionList(minTimestamp, maxTimestamp, needLastMsg, limit, hasMore)
                .setCallback(
                    NimResultContinuationCallback(cont) { result ->
                        NimResult(
                            code = 0,
                            data = result,
                            convert = { mapOf("mySessionList" to it.toMap()) }
                        )
                    }
                )
        }
    }

    private suspend fun queryMySession(arguments: Map<String, *>): NimResult<RecentSession> {
        val sessionId = arguments["sessionId"] as String
        val sessionType = stringToSessionTypeEnum(arguments["sessionType"] as String)
        return suspendCancellableCoroutine { cont ->
            val arg = when (sessionType) {
                SessionTypeEnum.P2P -> "p2p|$sessionId"
                SessionTypeEnum.Team -> "team|$sessionId"
                SessionTypeEnum.SUPER_TEAM -> "super_team|$sessionId"
                else -> sessionId
            }
            msgService.queryMySession(arg)
                .setCallback(
                    NimResultContinuationCallback(cont) { result ->
                        NimResult(
                            code = 0,
                            data = result,
                            convert = { mapOf("recentSession" to it.toMap()) }
                        )
                    }
                )
        }
    }

    private suspend fun updateMySession(arguments: Map<String, *>): NimResult<Nothing> {
        val sessionId = arguments["sessionId"] as String
        val sessionType = stringToSessionTypeEnum(arguments["sessionType"] as String)
        val ext = arguments["ext"] as String
        return suspendCancellableCoroutine { cont ->
            val arg = when (sessionType) {
                SessionTypeEnum.P2P -> "p2p|$sessionId"
                SessionTypeEnum.Team -> "team|$sessionId"
                SessionTypeEnum.SUPER_TEAM -> "super_team|$sessionId"
                else -> sessionId
            }
            msgService.updateMySession(arg, ext)
                .setCallback(NimResultContinuationCallbackOfNothing(cont))
        }
    }

    private suspend fun deleteMySession(arguments: Map<String, *>): NimResult<Nothing> {
        fun convert(sessionId: String, sessionType: String): String {
            return when (stringToSessionTypeEnum(sessionType)) {
                SessionTypeEnum.P2P -> "p2p|$sessionId"
                SessionTypeEnum.Team -> "team|$sessionId"
                SessionTypeEnum.SUPER_TEAM -> "super_team|$sessionId"
                else -> sessionId
            }
        }

        val sessionList = (arguments["sessionList"] as List<Map<String, *>>)
            .map {
                convert(it["sessionId"] as String, it["sessionType"] as String)
            }
            .toTypedArray()
        return suspendCancellableCoroutine { cont ->
            msgService.deleteMySession(sessionList)
                .setCallback(NimResultContinuationCallbackOfNothing(cont))
        }
    }

    private suspend fun addQuickComment(arguments: Map<String, *>): NimResult<Long> {
        val msg = arguments["msg"] as Map<String, *>
        val replyType = arguments["replyType"] as Number
        val ext = arguments["ext"] as String
        val needPush = arguments["needPush"] as Boolean
        val needBadge = arguments["needBadge"] as Boolean
        val pushTitle = arguments["pushTitle"] as String
        val pushContent = arguments["pushContent"] as String
        val pushPayload = arguments["pushPayload"] as Map<String, *>
        return suspendCancellableCoroutine { cont ->
            msgService.addQuickComment(
                MessageHelper.convertIMMessage(msg),
                replyType.toLong(),
                ext,
                needPush,
                needBadge,
                pushTitle,
                pushContent,
                pushPayload
            )
                .setCallback(
                    NimResultContinuationCallback(cont) { result ->
                        NimResult(
                            code = 0,
                            data = result,
                            convert = { mapOf("result" to it) }
                        )
                    }
                )
        }
    }

    private suspend fun removeQuickComment(arguments: Map<String, *>): NimResult<Long> {
        val msg = arguments["msg"] as Map<String, *>
        val replyType = arguments["replyType"] as Number
        val ext = arguments["ext"] as String
        val needPush = arguments["needPush"] as Boolean
        val needBadge = arguments["needBadge"] as Boolean
        val pushTitle = arguments["pushTitle"] as String
        val pushContent = arguments["pushContent"] as String
        val pushPayload = arguments["pushPayload"] as Map<String, *>
        return suspendCancellableCoroutine { cont ->
            msgService.removeQuickComment(
                MessageHelper.convertIMMessage(msg),
                replyType.toLong(),
                ext,
                needPush,
                needBadge,
                pushTitle,
                pushContent,
                pushPayload
            )
                .setCallback(
                    NimResultContinuationCallback(cont) { result ->
                        NimResult(
                            code = 0,
                            data = result,
                            convert = { mapOf("result" to it) }
                        )
                    }
                )
        }
    }

    private suspend fun queryQuickComment(arguments: Map<String, *>): NimResult<List<QuickCommentOptionWrapper>> {
        val msgList =
            (arguments["msgList"] as List<Map<String, *>>).map { MessageHelper.convertIMMessage(it) }
                .toList()
        return suspendCancellableCoroutine { cont ->
            msgService.queryQuickComment(msgList)
                .setCallback(
                    NimResultContinuationCallback(cont) { result ->
                        NimResult(
                            code = 0,
                            data = result,
                            convert = { data ->
                                mapOf(
                                    "quickCommentOptionWrapperList" to data.map { it.toMap() }
                                        .toList()
                                )
                            }
                        )
                    }
                )
        }
    }

    private suspend fun addStickTopSession(arguments: Map<String, *>): NimResult<StickTopSessionInfo> {
        val sessionId = arguments["sessionId"] as String
        val sessionType = stringToSessionTypeEnum(arguments["sessionType"] as String)
        val ext = arguments["ext"] as String
        return suspendCancellableCoroutine { cont ->
            msgService.addStickTopSession(sessionId, sessionType, ext)
                .setCallback(
                    NimResultContinuationCallback(cont) { result ->
                        NimResult(
                            code = 0,
                            data = result,
                            convert = { mapOf("stickTopSessionInfo" to it.toMap()) }
                        )
                    }
                )
        }
    }

    private suspend fun removeStickTopSession(arguments: Map<String, *>): NimResult<Nothing> {
        val sessionId = arguments["sessionId"] as String
        val sessionType = stringToSessionTypeEnum(arguments["sessionType"] as String)
        val ext = arguments["ext"] as String
        return suspendCancellableCoroutine { cont ->
            msgService.removeStickTopSession(sessionId, sessionType, ext)
                .setCallback(NimResultContinuationCallbackOfNothing(cont))
        }
    }

    private suspend fun updateStickTopSession(arguments: Map<String, *>): NimResult<StickTopSessionInfo> {
        val sessionId = arguments["sessionId"] as String
        val sessionType = stringToSessionTypeEnum(arguments["sessionType"] as String)
        val ext = arguments["ext"] as String
        return suspendCancellableCoroutine { cont ->
            msgService.updateStickTopSession(sessionId, sessionType, ext)
                .setCallback(
                    NimResultContinuationCallback(cont) { result ->
                        NimResult(
                            code = 0,
                            data = result,
                            convert = { mapOf("stickTopSessionInfo" to it.toMap()) }
                        )
                    }
                )
        }
    }

    private suspend fun queryStickTopSession(arguments: Map<String, *>): NimResult<List<StickTopSessionInfo>> {
        val result = msgService.queryStickTopSessionBlock()
        return NimResult(
            code = 0,
            data = result,
            convert = { data ->
                mapOf("stickTopSessionInfoList" to data.map { it.toMap() }.toList())
            }
        )
    }

    private suspend fun queryRoamMsgHasMoreTime(arguments: Map<String, *>): NimResult<Long> {
        val sessionId = arguments["sessionId"] as String
        val sessionType = stringToSessionTypeEnum(arguments["sessionType"] as String)
        return suspendCancellableCoroutine { cont ->
            msgService.queryRoamMsgHasMoreTime(sessionId, sessionType)
                .setCallback(NimResultContinuationCallback(cont))
        }
    }

    private suspend fun updateRoamMsgHasMoreTag(arguments: Map<String, *>): NimResult<Nothing> {
        val newTag = arguments["newTag"] as Map<String, *>
        return withContext(Dispatchers.IO) {
            msgService.updateRoamMsgHasMoreTag(MessageHelper.convertIMMessage(newTag))
            NimResult.SUCCESS
        }
    }

    private suspend fun getMessagesDynamically(arguments: Map<String, *>): NimResult<GetMessagesDynamicallyResult> {
        return suspendCancellableCoroutine { cont ->
            msgService.getMessagesDynamically(arguments.toGetMessagesDynamicallyParam()).setCallback(
                NimResultContinuationCallback(cont) { result ->
                    NimResult(
                        code = 0,
                        data = result,
                        convert = { mapOf("result" to it.toMap()) }
                    )
                }
            )
        }
    }

    private fun GetMessagesDynamicallyResult.toMap() = mapOf<String, Any?>(
        "messages" to messages?.map { it.toMap() }?.toList(),
        "isReliable" to isReliable
    )

    @Suppress("UNCHECKED_CAST")
    private fun Map<String, *>.toGetMessagesDynamicallyParam(): GetMessagesDynamicallyParam {
        val sessionId = this["sessionId"] as String
        val sessionType = stringToSessionTypeEnum(this["sessionType"] as String)
        val param = GetMessagesDynamicallyParam(sessionId, sessionType)
        if (this["fromTime"] as Long? != null) {
            param.fromTime = this["fromTime"] as Long
        }
        if (this["toTime"] as Long? != null) {
            param.toTime = this["toTime"] as Long
        }
        if (this["limit"] as Int? != null) {
            param.limit = this["limit"] as Int
        }
        if (this["anchorServerId"] as Long? != null) {
            param.anchorServerId = this["anchorServerId"] as Long
        }
        if (this["anchorClientId"] as String? != null) {
            param.anchorClientId = this["anchorClientId"] as String
        }
        if (this["direction"] as String? != null) {
            param.direction = stringToGetMessageDirectionEnum(this["direction"] as String)
        }
        return param
    }
}

class CustomAttachment(val attach: Map<String, Any?>) : MsgAttachment {
    override fun toJson(send: Boolean): String {
        return JSONObject(attach).toString()
    }
}
