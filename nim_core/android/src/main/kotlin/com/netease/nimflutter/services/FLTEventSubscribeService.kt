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
import com.netease.nimflutter.ResultCallback
import com.netease.nimflutter.SafeResult
import com.netease.nimflutter.convertToEvent
import com.netease.nimflutter.toMap
import com.netease.nimlib.sdk.NIMClient
import com.netease.nimlib.sdk.Observer
import com.netease.nimlib.sdk.RequestCallbackWrapper
import com.netease.nimlib.sdk.ResponseCode
import com.netease.nimlib.sdk.event.EventSubscribeService
import com.netease.nimlib.sdk.event.EventSubscribeServiceObserver
import com.netease.nimlib.sdk.event.model.Event
import com.netease.nimlib.sdk.event.model.EventSubscribeRequest
import com.netease.nimlib.sdk.event.model.EventSubscribeResult

class FLTEventSubscribeService(
    applicationContext: Context,
    nimCore: NimCore
) : FLTService(applicationContext, nimCore) {

    private val onEventObserver =
        Observer { eventList: List<Event> ->
            run {
                notifyEvent(
                    "observeEventChanged",
                    mutableMapOf("eventList" to eventList.map { it.toMap() }.toList())
                )
            }
        }

    init {
        nimCore.onInitialized {
            NIMClient.getService(EventSubscribeServiceObserver::class.java)
                .observeEventChanged(onEventObserver, true)
        }
    }

    override val serviceName = "EventSubscribeService"

    override fun onMethodCalled(method: String, arguments: Map<String, *>, safeResult: SafeResult) {
        when (method) {
            "registerEventSubscribe" -> registerEventSubscribe(
                arguments,
                ResultCallback(safeResult)
            )
            "unregisterEventSubscribe" -> unregisterEventSubscribe(
                arguments,
                ResultCallback(safeResult)
            )
            "batchUnSubscribeEvent" -> batchUnSubscribeEvent(arguments, ResultCallback(safeResult))
            "publishEvent" -> publishEvent(arguments, ResultCallback(safeResult))
            "querySubscribeEvent" -> querySubscribeEvent(arguments, ResultCallback(safeResult))
            else -> safeResult.notImplemented()
        }
    }

    private fun registerEventSubscribe(
        arguments: Map<String, *>,
        resultCallback: ResultCallback<List<String>>
    ) {
        var eventSubscribeRequest = convertToEventSubscribeRequest(arguments)
        if (eventSubscribeRequest.eventType > 0) {
            NIMClient.getService(EventSubscribeService::class.java)
                .subscribeEvent(eventSubscribeRequest).setCallback(
                    object : RequestCallbackWrapper<List<String>>() {
                        override fun onResult(
                            code: Int,
                            result: List<String>?,
                            exception: Throwable?
                        ) {
                            // result代表部分订阅失败的用户id
                            resultCallback.result(
                                NimResult(code = 0, data = result) {
                                    mutableMapOf("resultList" to it)
                                }
                            )
                        }
                    }
                )
        } else {
            resultCallback.result(
                NimResult(
                    code = -1,
                    errorDetails = "eventType must be greater than 0"
                )
            )
        }
    }

    private fun unregisterEventSubscribe(
        arguments: Map<String, *>,
        resultCallback: ResultCallback<Void>
    ) {
        var eventSubscribeRequest = convertToEventSubscribeRequest(arguments)
        if (eventSubscribeRequest.eventType > 0) {
            NIMClient.getService(EventSubscribeService::class.java)
                .unSubscribeEvent(eventSubscribeRequest)
            resultCallback.result(NimResult(code = 0))
        } else {
            resultCallback.result(
                NimResult(
                    code = -1,
                    errorDetails = "eventType must be greater than 0"
                )
            )
        }
    }

    private fun batchUnSubscribeEvent(
        arguments: Map<String, *>,
        resultCallback: ResultCallback<Void>
    ) {
        var eventSubscribeRequest = convertToEventSubscribeRequest(arguments)
        if (eventSubscribeRequest.eventType > 0) {
            NIMClient.getService(EventSubscribeService::class.java)
                .batchUnSubscribeEvent(eventSubscribeRequest)
            resultCallback.result(NimResult(code = 0))
        } else {
            resultCallback.result(
                NimResult(
                    code = -1,
                    errorDetails = "eventType must be greater than 0"
                )
            )
        }
    }

    private fun publishEvent(arguments: Map<String, *>, resultCallback: ResultCallback<Void>) {
        var event = convertToEvent(arguments)
        if (event.eventType > 0) {
            NIMClient.getService(EventSubscribeService::class.java).publishEvent(event)
            resultCallback.result(NimResult(code = 0))
        } else {
            resultCallback.result(
                NimResult(
                    code = -1,
                    errorDetails = "eventType must be greater than 0"
                )
            )
        }
    }

    private fun querySubscribeEvent(
        arguments: Map<String, *>,
        resultCallback: ResultCallback<List<EventSubscribeResult>>
    ) {
        var eventSubscribeRequest = convertToEventSubscribeRequest(arguments)
        if (eventSubscribeRequest.eventType > 0) {
            NIMClient.getService(EventSubscribeService::class.java)
                .querySubscribeEvent(eventSubscribeRequest).setCallback(
                    object : RequestCallbackWrapper<List<EventSubscribeResult>>() {
                        override fun onResult(
                            code: Int,
                            result: List<EventSubscribeResult>?,
                            exception: Throwable?
                        ) {
                            // result代表部分订阅失败的用户id
                            if (code == ResponseCode.RES_SUCCESS.toInt()) {
                                resultCallback.result(
                                    NimResult(
                                        0,
                                        data = result,
                                        convert = { list ->
                                            mutableMapOf(
                                                "eventSubscribeResultList" to list.map { it.toMap() }
                                                    .toList()
                                            )
                                        }
                                    )
                                )
                            } else {
                                resultCallback.result(
                                    NimResult(
                                        code = -1,
                                        errorDetails = "query error"
                                    )
                                )
                            }
                        }
                    }
                )
        }
    }

    private fun convertToEventSubscribeRequest(arguments: Map<String, *>): EventSubscribeRequest {
        var request = EventSubscribeRequest()
        if (arguments != null) {
            request.eventType = (arguments["eventType"] as Number).toInt()
            request.expiry = (arguments.getOrElse("expiry") { 0L } as Number).toLong()
            request.isSyncCurrentValue =
                arguments.getOrElse("syncCurrentValue") { false } as Boolean
            request.publishers = arguments["publishers"] as List<String>
        }
        return request
    }
}
