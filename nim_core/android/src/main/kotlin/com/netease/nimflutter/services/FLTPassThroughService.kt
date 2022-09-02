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
import com.netease.nimflutter.toMap
import com.netease.nimlib.sdk.NIMClient
import com.netease.nimlib.sdk.Observer
import com.netease.nimlib.sdk.RequestCallback
import com.netease.nimlib.sdk.passthrough.PassthroughService
import com.netease.nimlib.sdk.passthrough.PassthroughServiceObserve
import com.netease.nimlib.sdk.passthrough.model.PassthroughNotifyData
import com.netease.nimlib.sdk.passthrough.model.PassthroughProxyData
import com.netease.yunxin.kit.alog.ALog
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.channels.awaitClose
import kotlinx.coroutines.channels.onFailure
import kotlinx.coroutines.flow.callbackFlow
import kotlinx.coroutines.flow.launchIn
import kotlinx.coroutines.flow.onEach
import kotlinx.coroutines.suspendCancellableCoroutine

class FLTPassThroughService(
    applicationContext: Context,
    nimCore: NimCore
) : FLTService(applicationContext, nimCore) {

    private val tag = "FLTPassThroughService"

    override val serviceName = "PassThroughService"
    private val passThroughService: PassthroughService by lazy {
        NIMClient.getService(PassthroughService::class.java)
    }

    init {
        registerFlutterMethodCalls(
            "httpProxy" to ::httpProxy
        )
        nimCore.onInitialized {
            observePassthroughServiceEvent()
        }
    }

    @ExperimentalCoroutinesApi
    private fun observePassthroughServiceEvent() {
        callbackFlow<PassthroughNotifyData> {
            val observer = Observer<PassthroughNotifyData> { event ->
                ALog.i(serviceName, "observePassthroughServiceEvent: $event")
                trySend(event).onFailure {
                    ALog.i(serviceName, "send kick out event fail: ${it?.message}")
                }
            }
            NIMClient.getService(PassthroughServiceObserve::class.java).apply {
                observePassthroughNotify(observer, true)
                awaitClose {
                    observePassthroughNotify(observer, false)
                }
            }
        }.onEach { event ->
            notifyEvent(
                method = "onPassthrough",
                arguments = mapOf(
                    "passthroughNotifyData" to event.toMap()
                )
            )
        }.launchIn(nimCore.lifeCycleScope)
    }

    private suspend fun httpProxy(arguments: Map<String, *>): NimResult<PassthroughProxyData> {
        val options = arguments["passThroughProxyData"] as? Map<*, *>
        val zone = options?.get("zone") as String?
        val path = options?.get("path") as String?
        val method = options?.get("method") as Int?
        val header = options?.get("header") as String?
        val body = options?.get("body") as String?
        val passThroughProxyData =
            method?.let { PassthroughProxyData(zone, path, it, header, body) }
        return suspendCancellableCoroutine { cont ->
            passThroughService.httpProxy(passThroughProxyData)
                .setCallback(object : RequestCallback<PassthroughProxyData> {
                    override fun onSuccess(param: PassthroughProxyData) =
                        cont.resumeWith(
                            Result.success(
                                NimResult(
                                    code = 0,
                                    data = param,
                                    convert = { it.toMap() }
                                )
                            )
                        )

                    override fun onFailed(code: Int) =
                        cont.resumeWith(Result.success(NimResult(code = code)))

                    override fun onException(exception: Throwable?) =
                        cont.resumeWith(Result.success(NimResult.failure(exception)))
                })
        }
    }
}
