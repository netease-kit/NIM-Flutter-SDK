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
import com.netease.nimflutter.NimResultCallback
import com.netease.nimflutter.ResultCallback
import com.netease.nimflutter.SafeResult
import com.netease.nimflutter.convertToCustomNotification
import com.netease.nimflutter.stringToSystemMessageStatus
import com.netease.nimflutter.stringToSystemMessageType
import com.netease.nimflutter.toMap
import com.netease.nimlib.sdk.NIMClient
import com.netease.nimlib.sdk.Observer
import com.netease.nimlib.sdk.RequestCallback
import com.netease.nimlib.sdk.msg.MsgService
import com.netease.nimlib.sdk.msg.MsgServiceObserve
import com.netease.nimlib.sdk.msg.SystemMessageObserver
import com.netease.nimlib.sdk.msg.SystemMessageService
import com.netease.nimlib.sdk.msg.model.CustomNotification
import com.netease.nimlib.sdk.msg.model.SystemMessage

class FLTSystemMessageService(
    applicationContext: Context,
    nimCore: NimCore
) : FLTService(applicationContext, nimCore) {

    override val serviceName = "SystemMessageService"

    private val observeReceiveSystemMsg = Observer { systemMessage: SystemMessage ->
        println("FLTSystemMessageService onReceiveSystemMsg = $systemMessage")
        run {
            notifyEvent("onReceiveSystemMsg", systemMessage.toMap() as MutableMap<String, Any?>)
        }
    }

    private val observeUnreadCountChange = Observer { unreadCount: Int ->
        run {
            notifyEvent("onUnreadCountChange", mutableMapOf("result" to unreadCount))
        }
    }

    private val observeCustomNotification = Observer { notification: CustomNotification ->
        run {
            notifyEvent("onCustomNotification", notification.toMap() as MutableMap<String, Any?>)
        }
    }

    init {
        nimCore.onInitialized {
            NIMClient.getService(SystemMessageObserver::class.java)
                .observeReceiveSystemMsg(observeReceiveSystemMsg, true)
            NIMClient.getService(SystemMessageObserver::class.java)
                .observeUnreadCountChange(observeUnreadCountChange, true)
            NIMClient.getService((MsgServiceObserve::class.java))
                .observeCustomNotification(observeCustomNotification, true)
        }
    }

    override fun onMethodCalled(method: String, arguments: Map<String, *>, safeResult: SafeResult) {
        when (method) {
            "querySystemMessagesAndroid" -> querySystemMessagesAndroid(
                arguments,
                ResultCallback(safeResult)
            )
            "querySystemMessageByTypeAndroid" -> querySystemMessageByTypeAndroid(
                arguments,
                ResultCallback(safeResult)
            )
            "querySystemMessageUnread" -> querySystemMessageUnread(
                arguments,
                ResultCallback(safeResult)
            )
            "querySystemMessageUnreadCount" -> querySystemMessageUnreadCount(
                arguments,
                ResultCallback(safeResult)
            )
            "querySystemMessageUnreadCountByType" -> querySystemMessageUnreadCountByType(
                arguments,
                ResultCallback(safeResult)
            )
            "resetSystemMessageUnreadCount" -> resetSystemMessageUnreadCount(
                arguments,
                ResultCallback(safeResult)
            )
            "resetSystemMessageUnreadCountByType" -> resetSystemMessageUnreadCountByType(
                arguments,
                ResultCallback(safeResult)
            )
            "setSystemMessageRead" -> setSystemMessageRead(arguments, ResultCallback(safeResult))
            "clearSystemMessages" -> clearSystemMessages(arguments, ResultCallback(safeResult))
            "clearSystemMessagesByType" -> clearSystemMessagesByType(
                arguments,
                ResultCallback(safeResult)
            )
            "deleteSystemMessage" -> deleteSystemMessage(arguments, ResultCallback(safeResult))
            "setSystemMessageStatus" -> setSystemMessageStatus(
                arguments,
                ResultCallback(safeResult)
            )
            "sendCustomNotification" -> sendCustomNotification(
                arguments,
                ResultCallback(safeResult)
            )
            else -> safeResult.notImplemented()
        }
    }

    inner class QueryCallback(resultCallback: ResultCallback<List<SystemMessage>>) :
        RequestCallback<List<SystemMessage>> {
        var callback: ResultCallback<List<SystemMessage>> = resultCallback
        override fun onSuccess(param: List<SystemMessage>) {
            callback.result(
                NimResult(code = 0, param, convert = {
                    mutableMapOf(
                        "systemMessageList" to param.map { it.toMap() }
                            .toList()
                    )
                })
            )
        }

        override fun onFailed(code: Int) {
            callback.result(
                NimResult(
                    code = -1,
                    errorDetails = "query message fail"
                )
            )
        }

        override fun onException(exception: Throwable?) {
            callback.result(
                NimResult(
                    code = -1,
                    errorDetails = "query message exception $exception"
                )
            )
        }
    }

    private fun querySystemMessagesAndroid(
        arguments: Map<String, *>,
        resultCallback: ResultCallback<List<SystemMessage>>
    ) {
        val limit = (arguments.getOrElse("limit") { 100 } as Number).toInt()
        val offset = (arguments.getOrElse("offset") { 0 } as Number).toInt()
        NIMClient.getService(SystemMessageService::class.java).querySystemMessages(offset, limit)
            .setCallback(QueryCallback(resultCallback))
    }

    private fun querySystemMessageByTypeAndroid(
        arguments: Map<String, *>,
        resultCallback: ResultCallback<List<SystemMessage>>
    ) {
        val systemMessageTypeList =
            (arguments["systemMessageTypeList"] as List<String>).map { stringToSystemMessageType(it) }
                .toList()
        val limit = (arguments.getOrElse("limit") { 100 } as Number).toInt()
        val offset = (arguments.getOrElse("offset") { 0 } as Number).toInt()
        NIMClient.getService(SystemMessageService::class.java)
            .querySystemMessageByType(systemMessageTypeList, offset, limit)
            .setCallback(QueryCallback(resultCallback))
    }

    private fun querySystemMessageUnread(
        arguments: Map<String, *>,
        resultCallback: ResultCallback<List<SystemMessage>>
    ) {
        NIMClient.getService(SystemMessageService::class.java).querySystemMessageUnread()
            .setCallback(QueryCallback(resultCallback))
    }

    private fun querySystemMessageUnreadCount(
        arguments: Map<String, *>,
        resultCallback: ResultCallback<Int>
    ) {
        var result = NIMClient.getService(SystemMessageService::class.java)
            .querySystemMessageUnreadCountBlock()
        resultCallback.result(NimResult(code = 0, result))
    }

    private fun querySystemMessageUnreadCountByType(
        arguments: Map<String, *>,
        resultCallback: ResultCallback<Int>
    ) {
        val systemMessageTypeList =
            (arguments["systemMessageTypeList"] as List<String>).map { stringToSystemMessageType(it) }
                .toList()
        var result = NIMClient.getService(SystemMessageService::class.java)
            .querySystemMessageUnreadCountByType(systemMessageTypeList)
        resultCallback.result(NimResult(code = 0, result))
    }

    private fun resetSystemMessageUnreadCount(
        arguments: Map<String, *>,
        resultCallback: ResultCallback<Void>
    ) {
        NIMClient.getService(SystemMessageService::class.java).resetSystemMessageUnreadCount()
        resultCallback.result(NimResult(code = 0))
    }

    private fun resetSystemMessageUnreadCountByType(
        arguments: Map<String, *>,
        resultCallback: ResultCallback<List<SystemMessage>>
    ) {
        val systemMessageTypeList =
            (arguments["systemMessageTypeList"] as List<String>).map { stringToSystemMessageType(it) }
                .toList()
        NIMClient.getService(SystemMessageService::class.java)
            .resetSystemMessageUnreadCountByType(systemMessageTypeList)
        resultCallback.result(NimResult(code = 0))
    }

    private fun setSystemMessageRead(
        arguments: Map<String, *>,
        resultCallback: ResultCallback<List<SystemMessage>>
    ) {
        val messageId = (arguments.getOrElse("messageId") { 0L } as Number).toLong()
        NIMClient.getService(SystemMessageService::class.java).setSystemMessageRead(messageId)
        resultCallback.result(NimResult(code = 0))
    }

    private fun clearSystemMessages(
        arguments: Map<String, *>,
        resultCallback: ResultCallback<List<SystemMessage>>
    ) {
        NIMClient.getService(SystemMessageService::class.java).clearSystemMessages()
        resultCallback.result(NimResult(code = 0))
    }

    private fun clearSystemMessagesByType(
        arguments: Map<String, *>,
        resultCallback: ResultCallback<List<SystemMessage>>
    ) {
        val systemMessageTypeList =
            (arguments["systemMessageTypeList"] as List<String>).map { stringToSystemMessageType(it) }
                .toList()
        NIMClient.getService(SystemMessageService::class.java)
            .clearSystemMessagesByType(systemMessageTypeList)
        resultCallback.result(NimResult(code = 0))
    }

    private fun deleteSystemMessage(
        arguments: Map<String, *>,
        resultCallback: ResultCallback<List<SystemMessage>>
    ) {
        val messageId = (arguments.getOrElse("messageId") { 0L } as Number).toLong()
        NIMClient.getService(SystemMessageService::class.java).deleteSystemMessage(messageId)
        resultCallback.result(NimResult(code = 0))
    }

    private fun setSystemMessageStatus(
        arguments: Map<String, *>,
        resultCallback: ResultCallback<Void>
    ) {
        val messageId = (arguments.getOrElse("messageId") { 0L } as Number).toLong()
        val systemMessageStatus =
            stringToSystemMessageStatus(arguments["systemMessageStatus"] as String)
        NIMClient.getService(SystemMessageService::class.java)
            .setSystemMessageStatus(messageId, systemMessageStatus)
        resultCallback.result(NimResult(code = 0))
    }

    private fun sendCustomNotification(
        arguments: Map<String, *>,
        resultCallback: ResultCallback<Void>
    ) {
        val customNotification =
            convertToCustomNotification(arguments["customNotification"] as Map<String, Any?>)
        NIMClient.getService(MsgService::class.java).sendCustomNotification(customNotification).setCallback(NimResultCallback(resultCallback))
    }
}
