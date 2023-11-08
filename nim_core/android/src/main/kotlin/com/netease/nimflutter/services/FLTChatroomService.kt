/*
 * Copyright (c) 2022 NetEase, Inc. All rights reserved.
 * Use of this source code is governed by a MIT license that can be
 * found in the LICENSE file.
 */

package com.netease.nimflutter.services

import android.content.Context
import android.text.TextUtils
import com.netease.nimflutter.EnumTypeMappingRegistry
import com.netease.nimflutter.FLTService
import com.netease.nimflutter.LocalError.paramErrorCode
import com.netease.nimflutter.LocalError.paramErrorTip
import com.netease.nimflutter.MethodChannelSuspendResult
import com.netease.nimflutter.NimCore
import com.netease.nimflutter.NimResult
import com.netease.nimflutter.NimResultContinuationCallback
import com.netease.nimflutter.NimResultContinuationCallbackOfNothing
import com.netease.nimflutter.convertToQueryDirectionEnum
import com.netease.nimflutter.stringToMsgTypeEnum
import com.netease.nimflutter.stringToNimNosSceneKeyConstant
import com.netease.nimflutter.toMap
import com.netease.nimlib.sdk.InvocationFuture
import com.netease.nimlib.sdk.NIMClient
import com.netease.nimlib.sdk.Observer
import com.netease.nimlib.sdk.RequestCallback
import com.netease.nimlib.sdk.StatusCode
import com.netease.nimlib.sdk.auth.ChatRoomAuthProvider
import com.netease.nimlib.sdk.chatroom.ChatRoomMessageBuilder
import com.netease.nimlib.sdk.chatroom.ChatRoomService
import com.netease.nimlib.sdk.chatroom.ChatRoomServiceObserver
import com.netease.nimlib.sdk.chatroom.constant.MemberQueryType
import com.netease.nimlib.sdk.chatroom.constant.MemberType
import com.netease.nimlib.sdk.chatroom.model.ChatRoomIndependentCallback
import com.netease.nimlib.sdk.chatroom.model.ChatRoomInfo
import com.netease.nimlib.sdk.chatroom.model.ChatRoomKickOutEvent
import com.netease.nimlib.sdk.chatroom.model.ChatRoomMember
import com.netease.nimlib.sdk.chatroom.model.ChatRoomMemberUpdate
import com.netease.nimlib.sdk.chatroom.model.ChatRoomMessage
import com.netease.nimlib.sdk.chatroom.model.ChatRoomStatusChangeData
import com.netease.nimlib.sdk.chatroom.model.ChatRoomUpdateInfo
import com.netease.nimlib.sdk.chatroom.model.EnterChatRoomData
import com.netease.nimlib.sdk.chatroom.model.EnterChatRoomResultData
import com.netease.nimlib.sdk.chatroom.model.MemberOption
import com.netease.nimlib.sdk.msg.constant.MsgStatusEnum
import com.netease.nimlib.sdk.msg.constant.MsgTypeEnum
import com.netease.nimlib.sdk.msg.model.AttachmentProgress
import com.netease.nimlib.sdk.robot.model.RobotMsgType
import com.netease.nimlib.sdk.util.Entry
import com.netease.yunxin.kit.alog.ALog
import io.flutter.plugin.common.MethodChannel
import java.io.File
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.channels.awaitClose
import kotlinx.coroutines.channels.onFailure
import kotlinx.coroutines.flow.callbackFlow
import kotlinx.coroutines.flow.filter
import kotlinx.coroutines.flow.launchIn
import kotlinx.coroutines.flow.onEach
import kotlinx.coroutines.launch
import kotlinx.coroutines.runBlocking
import kotlinx.coroutines.suspendCancellableCoroutine

class FLTChatroomService(
    applicationContext: Context,
    nimCore: NimCore
) : FLTService(applicationContext, nimCore), ChatRoomAuthProvider {

    override val serviceName = "ChatroomService"

    private val chatroomService: ChatRoomService by lazy {
        NIMClient.getService(ChatRoomService::class.java)
    }

    init {
        registerFlutterMethodCalls(
            "enterChatroom" to ::enterChatroom,
            "exitChatroom" to ::exitChatroom,
            "createMessage" to ::createMessage,
            "sendMessage" to ::sendMessage,
            "downloadAttachment" to ::downloadAttachment,
            "fetchMessageHistory" to ::fetchMessageHistory,
            "fetchChatroomInfo" to ::fetchChatroomInfo,
            "updateChatroomInfo" to ::updateChatroomInfo,
            "fetchChatroomMembers" to ::fetchChatroomMembers,
            "fetchChatroomMembersByAccount" to ::fetchChatroomMembersByAccount,
            "updateChatroomMyMemberInfo" to ::updateChatroomMyMemberInfo,
            "kickChatroomMember" to ::kickChatroomMember,
            "markChatroomMemberBeManager" to ::markChatroomMemberBeManager,
            "markChatroomMemberBeNormal" to ::markChatroomMemberBeNormal,
            "markChatroomMemberInBlackList" to ::markChatroomMemberInBlackList,
            "markChatroomMemberMuted" to ::markChatroomMemberMuted,
            "markChatroomMemberTempMuted" to ::markChatroomMemberTempMuted,
            "fetchChatroomQueue" to ::fetchChatroomQueue,
            "clearChatroomQueue" to ::clearChatroomQueue,
            "batchUpdateChatroomQueue" to ::batchUpdateChatroomQueue,
            "pollChatroomQueueEntry" to ::pollChatroomQueueEntry,
            "updateChatroomQueueEntry" to ::updateChatroomQueueEntry
        )
        nimCore.onInitialized {
            nimCore.sdkOptions?.chatroomAuthProvider = this
            observeOnlineStatusEvent()
            observeKickOutEvent()
            observeChatroomMessage()
            observeChatroomMessageStatus()
            observeChatroomMessageAttachmentProgress()
        }
    }

    private suspend fun enterChatroom(arguments: Map<String, *>): NimResult<EnterChatRoomResultData> {
        val roomId = arguments["roomId"] as String
        return EnterChatRoomData(roomId).apply {
            nick = arguments["nickname"] as? String
            avatar = arguments["avatar"] as? String
            extension = arguments["extension"] as? Map<String, Any?>
            tags = (arguments["tags"] as? List<String>)?.joinToString(
                prefix = "[",
                postfix = "]"
            ) { "\"$it\"" }
            notifyExtension = arguments["notifyExtension"] as? Map<String, Any?>
            notifyTargetTags = arguments["notifyTargetTags"] as? String
            val independentModeConfig = arguments["independentModeConfig"] as? Map<String, Any?>
            if (independentModeConfig != null) {
                appKey = independentModeConfig["appKey"] as String?
                val account = independentModeConfig["account"] as String?
                val token = independentModeConfig["token"] as String?
                val callback = ChatRoomIndependentCallback { id, acc ->
                    if (id != null) {
                        runBlocking {
                            suspendCancellableCoroutine<Any?> { continuation ->
                                notifyEvent(
                                    method = "getIndependentModeLinkAddress",
                                    arguments = mapOf("roomId" to id, "account" to acc),
                                    callback = MethodChannelSuspendResult(continuation)
                                )
                            } as? List<String>
                        }
                    } else {
                        emptyList()
                    }
                }
                setIndependentMode(callback, account, token)
            }
            loginAuthType = arguments["loginAuthType"] as? Int
        }.let {
            suspendCancellableCoroutine { cont ->
                chatroomService.enterChatRoomEx(
                    it,
                    (arguments.getOrElse(key = "retryCount") { 0 } as Number).toInt()
                )
                    .setCallback(
                        NimResultContinuationCallback(cont) { data ->
                            NimResult(code = 0, data) { it.toMap() }
                        }
                    )
            }
        }
    }

    private suspend fun exitChatroom(arguments: Map<String, *>): NimResult<Nothing> {
        val roomId = arguments["roomId"] as? String
        return if (roomId.isNullOrEmpty()) {
            NimResult.FAILURE
        } else {
            chatroomService.exitChatRoom(roomId)
            NimResult.SUCCESS
        }
    }

    @ExperimentalCoroutinesApi
    private fun observeOnlineStatusEvent() {
        callbackFlow<ChatRoomStatusChangeData> {
            val observer = Observer<ChatRoomStatusChangeData> { event ->
                ALog.i(serviceName, "onStatusEvent: ${event.roomId}#${event.status}")
                trySend(event).onFailure {
                    ALog.i(serviceName, "send online status event fail: ${it?.message}")
                }
            }
            NIMClient.getService(ChatRoomServiceObserver::class.java).apply {
                observeOnlineStatus(observer, true)
                awaitClose {
                    observeOnlineStatus(observer, false)
                }
            }
        }.filter {
            it.status in listOf(
                StatusCode.CONNECTING,
                StatusCode.LOGINING,
                StatusCode.LOGINED,
                StatusCode.NET_BROKEN,
                StatusCode.UNLOGIN,
                StatusCode.FORBIDDEN,
                StatusCode.VER_ERROR,
                StatusCode.PWD_ERROR
            )
        }.onEach { event ->
            notifyEvent(
                method = "onStatusChanged",
                arguments = hashMapOf(
                    "roomId" to event.roomId,
                    "code" to chatroomService.getEnterErrorCode(event.roomId),
                    "status" to when (event.status) {
                        StatusCode.CONNECTING,
                        StatusCode.LOGINING -> "connecting"
                        StatusCode.LOGINED -> "connected"
                        StatusCode.NET_BROKEN -> "disconnected"
                        StatusCode.UNLOGIN,
                        StatusCode.FORBIDDEN,
                        StatusCode.VER_ERROR,
                        StatusCode.PWD_ERROR -> "failure"
                        else -> {}
                    }
                )
            )
        }.launchIn(nimCore.lifeCycleScope)
    }

    @ExperimentalCoroutinesApi
    private fun observeKickOutEvent() {
        callbackFlow<ChatRoomKickOutEvent> {
            val observer = Observer<ChatRoomKickOutEvent> { event ->
                ALog.i(serviceName, "onKickOutEvent: ${event.roomId}#${event.reason}")
                trySend(event).onFailure {
                    ALog.i(serviceName, "send kick out event fail: ${it?.message}")
                }
            }
            NIMClient.getService(ChatRoomServiceObserver::class.java).apply {
                observeKickOutEvent(observer, true)
                awaitClose {
                    observeKickOutEvent(observer, false)
                }
            }
        }.onEach { event ->
            notifyEvent(
                method = "onKickOut",
                arguments = hashMapOf(
                    "roomId" to event.roomId,
                    "reason" to when (event.reason) {
                        ChatRoomKickOutEvent.ChatRoomKickOutReason.CHAT_ROOM_INVALID -> "dismissed"
                        ChatRoomKickOutEvent.ChatRoomKickOutReason.KICK_OUT_BY_MANAGER -> "byManager"
                        ChatRoomKickOutEvent.ChatRoomKickOutReason.KICK_OUT_BY_CONFLICT_LOGIN -> "byConflictLogin"
                        ChatRoomKickOutEvent.ChatRoomKickOutReason.BE_BLACKLISTED -> "blacklisted"
                        else -> "unknown"
                    },
                    "extension" to event.extension
                )
            )
        }.launchIn(nimCore.lifeCycleScope)
    }

    private suspend fun createMessage(arguments: Map<String, *>): NimResult<ChatRoomMessage> {
        val args = arguments.withDefault { null }
        val roomId: String by args
        val filePath: String? by args
        val displayName: String? by args
        val duration: Number? by args
        val nosScene = stringToNimNosSceneKeyConstant(arguments["nosScene"] as? String)
        return when (stringToMsgTypeEnum(arguments["messageType"] as? String)) {
            MsgTypeEnum.text -> {
                ChatRoomMessageBuilder.createChatRoomTextMessage(
                    roomId,
                    arguments["text"] as String
                )
            }
            MsgTypeEnum.image -> {
                require(
                    filePath.isNullOrEmpty().not()
                ) { "create message error: file path is empty" }
                ChatRoomMessageBuilder.createChatRoomImageMessage(
                    roomId,
                    File(filePath!!),
                    displayName,
                    nosScene
                )
            }
            MsgTypeEnum.audio -> {
                require(
                    filePath.isNullOrEmpty().not()
                ) { "create message error: file path is empty" }
                ChatRoomMessageBuilder.createChatRoomAudioMessage(
                    roomId,
                    File(filePath!!),
                    duration?.toLong() ?: 0,
                    nosScene
                )
            }
            MsgTypeEnum.video -> {
                require(
                    filePath.isNullOrEmpty().not()
                ) { "create message error: file path is empty" }
                ChatRoomMessageBuilder.createChatRoomVideoMessage(
                    roomId,
                    File(filePath!!),
                    duration?.toLong() ?: 0,
                    arguments["width"] as Int,
                    arguments["height"] as Int,
                    displayName,
                    nosScene
                )
            }
            MsgTypeEnum.file -> {
                require(
                    filePath.isNullOrEmpty().not()
                ) { "create message error: file path is empty" }
                ChatRoomMessageBuilder.createChatRoomFileMessage(
                    roomId,
                    File(filePath!!),
                    displayName,
                    nosScene
                )
            }
            MsgTypeEnum.location -> {
                ChatRoomMessageBuilder.createChatRoomLocationMessage(
                    roomId,
                    (arguments["latitude"] as Number).toDouble(),
                    (arguments["longitude"] as Number).toDouble(),
                    arguments["address"] as String?
                )
            }
            MsgTypeEnum.tip -> {
                ChatRoomMessageBuilder.createTipMessage(roomId)
            }
            MsgTypeEnum.robot -> {
                val text: String? by args
                val content: String? by args
                val target: String? by args
                val params: String? by args
                ChatRoomMessageBuilder.createRobotMessage(
                    roomId,
                    arguments["robotAccount"] as String,
                    text,
                    EnumTypeMappingRegistry.enumFromValueOrDefault(
                        arguments["robotMessageType"],
                        fallback = RobotMsgType.TEXT
                    ),
                    content,
                    target,
                    params
                )
            }
            MsgTypeEnum.custom -> {
                val attachmentArguments = arguments["attachment"] as? Map<String, Any?>
                ChatRoomMessageBuilder.createChatRoomCustomMessage(
                    roomId,
                    if (attachmentArguments != null) {
                        AttachmentHelper.attachmentFromMap(MsgTypeEnum.custom, attachmentArguments)
                    } else {
                        null
                    }
                )
            }
            else -> null
        }.let { message ->
            val success = message != null
            NimResult(
                code = if (success) 0 else -1,
                data = message,
                errorDetails = if (success) null else "create message error!",
                convert = if (success) {
                    { it.toMap() }
                } else {
                    null
                }
            )
        }
    }

    private suspend fun sendMessage(arguments: Map<String, *>): NimResult<ChatRoomMessage> {
        return suspendCancellableCoroutine { cont ->
            val message =
                MessageHelper.convertChatroomMessage(arguments["message"] as Map<String, *>)
            chatroomService.sendMessage(
                message,
                arguments.getOrElse("resend") { false } as Boolean
            ).setCallback(object : RequestCallback<Void> {
                override fun onSuccess(param: Void?) {
                    message.status = MsgStatusEnum.success
                    cont.resumeWith(Result.success(NimResult(code = 0, message) { it.toMap() }))
                }

                override fun onFailed(code: Int) =
                    cont.resumeWith(Result.success(NimResult(code = code)))

                override fun onException(exception: Throwable?) =
                    cont.resumeWith(Result.success(NimResult.failure(exception)))
            })
        }
    }

    @ExperimentalCoroutinesApi
    private fun observeChatroomMessage() {
        callbackFlow<List<ChatRoomMessage>> {
            val observer = Observer<List<ChatRoomMessage>> { messages ->
                ALog.i(serviceName, "onChatroomMessages: ${messages?.size}")
                trySend(messages).onFailure {
                    ALog.i(serviceName, "send message list fail: ${it?.message}")
                }
            }
            NIMClient.getService(ChatRoomServiceObserver::class.java).apply {
                observeReceiveMessage(observer, true)
                awaitClose {
                    observeReceiveMessage(observer, false)
                }
            }
        }.onEach { messages ->
            notifyEvent(
                method = "onMessageReceived",
                arguments = hashMapOf(
                    "messageList" to messages.map { it.toMap() }.toList()
                ),
                callback = object : MethodChannel.Result {
                    override fun success(result: Any?) {
                        // do nothing
                    }

                    override fun error(
                        errorCode: String,
                        errorMessage: String?,
                        errorDetails: Any?
                    ) {
                        ALog.e(
                            serviceName,
                            "onMessageReceived invoke error code = $errorCode errorMessage = $errorMessage errorDetails = $errorDetails"
                        )
                    }

                    override fun notImplemented() {
                        ALog.e(serviceName, "onMessageReceived invoke notImplemented")
                    }
                }
            )
        }.launchIn(nimCore.lifeCycleScope)
    }

    @ExperimentalCoroutinesApi
    private fun observeChatroomMessageStatus() {
        callbackFlow {
            val observer = Observer<ChatRoomMessage> { message ->
                if (message != null) {
                    ALog.i(
                        serviceName,
                        "onChatroomMessagesStatusChanged: ${message.uuid} ${message.status}"
                    )
                    trySend(message).onFailure {
                        ALog.i(serviceName, "send message status fail: ${it?.message}")
                    }
                }
            }
            NIMClient.getService(ChatRoomServiceObserver::class.java).apply {
                observeMsgStatus(observer, true)
                awaitClose {
                    observeMsgStatus(observer, false)
                }
            }
        }.onEach { message ->
            notifyEvent(
                method = "onMessageStatusChanged",
                arguments = message.toMap().toMutableMap()
            )
        }.launchIn(nimCore.lifeCycleScope)
    }

    @ExperimentalCoroutinesApi
    private fun observeChatroomMessageAttachmentProgress() {
        callbackFlow<AttachmentProgress> {
            val observer = Observer<AttachmentProgress> { progress ->
                ALog.i(
                    serviceName,
                    "onChatroomMessageAttachmentProgressUpdate: ${progress.uuid} ${progress.total} ${progress.transferred}"
                )
                trySend(progress).onFailure {
                    ALog.i(serviceName, "send message list fail: ${it?.message}")
                }
            }
            NIMClient.getService(ChatRoomServiceObserver::class.java).apply {
                observeAttachmentProgress(observer, true)
                awaitClose {
                    observeAttachmentProgress(observer, false)
                }
            }
        }.onEach { progress ->
            notifyEvent(
                method = "onMessageAttachmentProgressUpdate",
                arguments = progress.toMap().toMutableMap()
            )
        }.launchIn(nimCore.lifeCycleScope)
    }

    private suspend fun downloadAttachment(
        arguments: Map<String, *>
    ): NimResult<Nothing> {
        return suspendCancellableCoroutine { cont ->
            chatroomService.downloadAttachment(
                MessageHelper.convertChatroomMessage(arguments["message"] as Map<String, *>),
                arguments.getOrElse("thumb") { false } as Boolean
            ).setCallback(NimResultContinuationCallbackOfNothing(cont))
        }
    }

    private suspend fun fetchMessageHistory(
        arguments: Map<String, *>
    ): NimResult<List<ChatRoomMessage>> {
        return suspendCancellableCoroutine { cont ->
            val args = arguments.withDefault { null }
            val roomId: String by args
            val startTime: Long by args
            val limit: Int by args
            val direction = convertToQueryDirectionEnum(arguments["direction"] as Int)
            val messageTypes =
                (arguments["messageTypeList"] as? List<String>)?.map { stringToMsgTypeEnum(it) }
                    ?.toSet()?.toTypedArray()
            if (messageTypes == null || messageTypes.isEmpty()) {
                chatroomService.pullMessageHistoryEx(roomId, startTime, limit, direction)
            } else {
                chatroomService.pullMessageHistoryExType(
                    roomId,
                    startTime,
                    limit,
                    direction,
                    messageTypes
                )
            }.setCallback(
                NimResultContinuationCallback(cont) { data ->
                    NimResult(
                        code = 0,
                        data = data ?: listOf(),
                        convert = { mapOf("messageList" to it.map { msg -> msg.toMap() }.toList()) }
                    )
                }
            )
        }
    }

    private suspend fun fetchChatroomInfo(
        arguments: Map<String, *>
    ): NimResult<ChatRoomInfo> {
        return suspendCancellableCoroutine { cont ->
            val roomId = arguments["roomId"] as String
            chatroomService.fetchRoomInfo(roomId)
                .setCallback(
                    NimResultContinuationCallback(cont) { data ->
                        NimResult(
                            code = if (data != null) 0 else -1,
                            data = data,
                            convert = { it.toMap() }
                        )
                    }
                )
        }
    }

    private suspend fun updateChatroomInfo(
        arguments: Map<String, *>
    ): NimResult<Nothing> {
        return suspendCancellableCoroutine { cont ->
            val args = arguments.withDefault { null }
            val roomId: String by args
            val needNotify: Boolean by args
            val request: Map<String, Any?> by args
            val updateInfo = ChatRoomUpdateInfo().apply {
                name = request["name"] as? String
                announcement = request["announcement"] as? String
                broadcastUrl = request["broadcastUrl"] as? String
                extension = request["extension"] as? Map<String, Any?>
                queueLevel = if ("manager" == request["queueModificationLevel"] as? String) 1 else 0
            }
            chatroomService.updateRoomInfo(
                roomId,
                updateInfo,
                needNotify,
                arguments["notifyExtension"] as? Map<String, Any?>
            )
                .setCallback(NimResultContinuationCallbackOfNothing(cont))
        }
    }

    private suspend fun fetchChatroomMembers(
        arguments: Map<String, *>
    ): NimResult<List<ChatRoomMember>> {
        return suspendCancellableCoroutine { cont ->
            val args = arguments.withDefault { null }
            val roomId: String by args
            val queryType: Int by args
            val limit: Int by args
            val lastMemberAccount: String? by args
            val queryTypes = listOf(
                MemberQueryType.NORMAL,
                MemberQueryType.ONLINE_NORMAL,
                MemberQueryType.GUEST_DESC,
                MemberQueryType.GUEST_ASC
            )

            fun realFetchMembers(lastMember: ChatRoomMember?) {
                ALog.i(
                    serviceName,
                    "real fetchRoomMembers with last member: ${lastMember?.account} ${lastMember?.memberType}"
                )
                val startTime = when (lastMember?.memberType) {
                    null, MemberType.UNKNOWN -> 0
                    MemberType.GUEST, MemberType.ANONYMOUS -> lastMember.enterTime
                    else -> lastMember.updateTime
                }
                chatroomService.fetchRoomMembers(roomId, queryTypes[queryType], startTime, limit)
                    .setCallback(
                        NimResultContinuationCallback(cont) { resultList ->
                            NimResult(
                                code = 0,
                                data = resultList,
                                convert = { list ->
                                    mapOf("memberList" to list.map { it.toMap() }.toList())
                                }
                            )
                        }
                    )
            }
            when {
                lastMemberAccount == null -> {
                    realFetchMembers(null)
                }
                lastMemberAccount?.isEmpty() == true ||
                    lastMemberAccount?.isBlank() == true -> {
                    cont.resumeWith(
                        Result.success(
                            NimResult(code = -1, errorDetails = "last member account empty")
                        )
                    )
                }
                else -> {
                    chatroomService.fetchRoomMembersByIds(roomId, listOf(lastMemberAccount!!))
                        .setCallback(object : RequestCallback<MutableList<ChatRoomMember>> {
                            override fun onSuccess(param: MutableList<ChatRoomMember>?) {
                                val lastMember = param?.firstOrNull()
                                if (lastMember == null) {
                                    cont.resumeWith(
                                        Result.success(
                                            NimResult(
                                                code = -1,
                                                errorDetails = "last member not found"
                                            )
                                        )
                                    )
                                } else {
                                    realFetchMembers(lastMember)
                                }
                            }

                            override fun onFailed(code: Int) =
                                cont.resumeWith(
                                    Result.success(
                                        NimResult(
                                            code = code,
                                            errorDetails = "fetch last member error"
                                        )
                                    )
                                )

                            override fun onException(exception: Throwable?) =
                                cont.resumeWith(
                                    Result.success(
                                        NimResult(
                                            code = -1,
                                            errorDetails = "fetch last member exception: ${exception?.message}"
                                        )
                                    )
                                )
                        })
                }
            }
        }
    }

    private suspend fun fetchChatroomMembersByAccount(
        arguments: Map<String, *>
    ): NimResult<List<ChatRoomMember>> {
        return suspendCancellableCoroutine { cont ->
            val args = arguments.withDefault { null }
            val roomId: String by args
            val accountList: List<String> by args
            chatroomService.fetchRoomMembersByIds(roomId, accountList)
                .setCallback(
                    NimResultContinuationCallback(cont) { resultList ->
                        NimResult(
                            code = 0,
                            data = resultList,
                            convert = { list ->
                                mapOf("memberList" to list.map { it.toMap() }.toList())
                            }
                        )
                    }
                )
        }
    }

    private suspend fun updateChatroomMyMemberInfo(
        arguments: Map<String, *>
    ): NimResult<Nothing> {
        return suspendCancellableCoroutine { cont ->
            val args = arguments.withDefault { null }
            val roomId: String by args
            val request: Map<String, Any?> by args
            val update = ChatRoomMemberUpdate().apply {
                nick = request["nickname"] as String?
                avatar = request["avatar"] as String?
                extension = request["extension"] as Map<String, Any?>?
                isNeedSave = request["needSave"] as Boolean? ?: false
            }
            val needNotify: Boolean by args
            val notifyExtension: Map<String, Any?>? by args
            chatroomService
                .updateMyRoomRole(roomId, update, needNotify, notifyExtension)
                .setCallback(NimResultContinuationCallbackOfNothing(cont))
        }
    }

    private suspend fun kickChatroomMember(
        arguments: Map<String, *>
    ): NimResult<Nothing> {
        return suspendCancellableCoroutine { cont ->
            val args = arguments.withDefault { null }
            val roomId: String by args
            val account: String by args
            val notifyExtension: Map<String, Any?>? by args
            chatroomService.kickMember(roomId, account, notifyExtension)
                .setCallback(NimResultContinuationCallbackOfNothing(cont))
        }
    }

    private suspend fun markChatroomMemberTempMuted(
        arguments: Map<String, *>
    ): NimResult<Nothing> {
        return suspendCancellableCoroutine { cont ->
            val args = arguments.withDefault { null }
            val needNotify: Boolean by args
            val duration: Number by args
            val options: Map<String, Any?> by args
            chatroomService.markChatRoomTempMute(
                needNotify,
                duration.toLong() / 1000,
                memberOptionFromMap(options)
            )
                .setCallback(NimResultContinuationCallbackOfNothing(cont))
        }
    }

    private suspend fun markChatroomMemberBeManager(
        arguments: Map<String, *>
    ): NimResult<ChatRoomMember> {
        return markChatroomMemberWithAction(arguments) { isAdd, option ->
            chatroomService.markChatRoomManager(isAdd, option)
        }
    }

    private suspend fun markChatroomMemberBeNormal(
        arguments: Map<String, *>
    ): NimResult<ChatRoomMember> {
        return markChatroomMemberWithAction(arguments) { isAdd, option ->
            chatroomService.markNormalMember(isAdd, option)
        }
    }

    private suspend fun markChatroomMemberInBlackList(
        arguments: Map<String, *>
    ): NimResult<ChatRoomMember> {
        return markChatroomMemberWithAction(arguments) { isAdd, option ->
            chatroomService.markChatRoomBlackList(isAdd, option)
        }
    }

    private suspend fun markChatroomMemberMuted(
        arguments: Map<String, *>
    ): NimResult<ChatRoomMember> {
        return markChatroomMemberWithAction(arguments) { isAdd, option ->
            chatroomService.markChatRoomMutedList(isAdd, option)
        }
    }

    private suspend fun markChatroomMemberWithAction(
        arguments: Map<String, *>,
        action: (isAdd: Boolean, option: MemberOption) -> InvocationFuture<ChatRoomMember>
    ): NimResult<ChatRoomMember> {
        return suspendCancellableCoroutine { cont ->
            val args = arguments.withDefault { null }
            val isAdd: Boolean by args
            val options: Map<String, Any?> by args
            action(isAdd, memberOptionFromMap(options))
                .setCallback(
                    NimResultContinuationCallback(cont) { data ->
                        NimResult(
                            code = if (data != null) 0 else -1,
                            data = data,
                            convert = { it.toMap() }
                        )
                    }
                )
        }
    }

    private fun memberOptionFromMap(arguments: Map<String, *>): MemberOption {
        val args = arguments.withDefault { null }
        val roomId: String by args
        val account: String by args
        val notifyExtension: Map<String, Any?>? by args
        return MemberOption(roomId, account).apply {
            setNotifyExtension(notifyExtension)
        }
    }

    private suspend fun fetchChatroomQueue(
        arguments: Map<String, *>
    ): NimResult<List<Entry<String, String>>> {
        return suspendCancellableCoroutine { cont ->
            val roomId = arguments["roomId"] as String
            if (TextUtils.isEmpty(roomId)) {
                cont.resumeWith(
                    Result.success(
                        NimResult(
                            code = paramErrorCode,
                            data = null,
                            errorDetails = paramErrorTip
                        )
                    )
                )
            } else {
                chatroomService.fetchQueue(roomId)
                    .setCallback(
                        NimResultContinuationCallback(cont) { data ->
                            NimResult(
                                code = 0,
                                data = data,
                                convert = { entryList ->
                                    mapOf(
                                        "entryList" to
                                            entryList.map {
                                                mapOf(
                                                    "key" to it.key,
                                                    "value" to it.value
                                                )
                                            }.toList()
                                    )
                                }
                            )
                        }
                    )
            }
        }
    }

    private suspend fun clearChatroomQueue(
        arguments: Map<String, *>
    ): NimResult<Nothing> {
        return suspendCancellableCoroutine { cont ->
            val roomId = arguments["roomId"] as String
            chatroomService.dropQueue(roomId)
                .setCallback(NimResultContinuationCallbackOfNothing(cont))
        }
    }

    private suspend fun batchUpdateChatroomQueue(
        arguments: Map<String, *>
    ): NimResult<List<String>> {
        return suspendCancellableCoroutine { cont ->
            val args = arguments.withDefault { null }
            val roomId: String by args
            val entryList: List<Map<String, Any?>> by args
            val needNotify: Boolean by args
            val notifyExtension: Map<String, Any?>? by args
            if (TextUtils.isEmpty(roomId) || entryList.isEmpty()) {
                cont.resumeWith(
                    Result.success(
                        NimResult(
                            code = paramErrorCode,
                            data = null,
                            errorDetails = paramErrorTip
                        )
                    )
                )
            } else {
                chatroomService.batchUpdateQueue(
                    roomId,
                    entryList.map { Entry<String, String>(it["key"] as String, it["value"] as String?) }
                        .toList(),
                    needNotify,
                    notifyExtension
                )
                    .setCallback(
                        NimResultContinuationCallback(cont) { data ->
                            NimResult(
                                code = 0,
                                data = data,
                                convert = { mapOf("missingKeys" to it) }
                            )
                        }
                    )
            }
        }
    }

    private suspend fun pollChatroomQueueEntry(
        arguments: Map<String, *>
    ): NimResult<Entry<String, String>> {
        return suspendCancellableCoroutine { cont ->
            val args = arguments.withDefault { null }
            val roomId: String by args
            val key: String? by args
            if (TextUtils.isEmpty(roomId)) {
                cont.resumeWith(
                    Result.success(
                        NimResult(
                            code = paramErrorCode,
                            data = null,
                            errorDetails = paramErrorTip
                        )
                    )
                )
            } else {
                chatroomService.pollQueue(roomId, key)
                    .setCallback(
                        NimResultContinuationCallback(cont) { data ->
                            NimResult(
                                code = 0,
                                data = data,
                                convert = { mapOf("key" to it.key, "value" to it.value) }
                            )
                        }
                    )
            }
        }
    }

    private suspend fun updateChatroomQueueEntry(
        arguments: Map<String, *>
    ): NimResult<Nothing> {
        return suspendCancellableCoroutine { cont ->
            val args = arguments.withDefault { null }
            val roomId: String by args
            val entry: Map<String, Any?> by args
            val key = entry["key"] as String
            val value = entry["value"] as String?
            val isTransient = arguments.getOrElse("isTransient") { false } as Boolean
            if (TextUtils.isEmpty(roomId)) {
                cont.resumeWith(
                    Result.success(
                        NimResult(
                            code = paramErrorCode,
                            data = null,
                            errorDetails = paramErrorTip
                        )
                    )
                )
            } else {
                chatroomService.updateQueueEx(roomId, key, value, isTransient)
                    .setCallback(NimResultContinuationCallbackOfNothing(cont))
            }
        }
    }

    override fun getToken(account: String?, roomId: String?, appKey: String?): String? {
        return if (account != null && roomId != null) {
            var token: String? = null
            runBlocking {
                launch {
                    token = suspendCancellableCoroutine<Any?> { continuation ->
                        notifyEvent(
                            method = "getChatRoomDynamicToken",
                            arguments = mapOf("account" to account, "roomId" to roomId),
                            callback = MethodChannelSuspendResult(continuation)
                        )
                    } as? String
                }
            }
            token
        } else {
            null
        }
    }
}
