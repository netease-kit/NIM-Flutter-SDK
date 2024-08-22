/*
 * Copyright (c) 2022 NetEase, Inc. All rights reserved.
 * Use of this source code is governed by a MIT license that can be
 * found in the LICENSE file.
 */

package com.netease.nimflutter.services

import android.content.Context
import com.netease.nimflutter.FLTConstant.paramErrorCode
import com.netease.nimflutter.FLTService
import com.netease.nimflutter.MethodChannelSuspendResult
import com.netease.nimflutter.NimCore
import com.netease.nimflutter.NimResult
import com.netease.nimflutter.nimProviderTimeout
import com.netease.nimflutter.toLoginOptions
import com.netease.nimflutter.toMap
import com.netease.nimflutter.toNIMLoginClient
import com.netease.nimlib.sdk.NIMClient
import com.netease.nimlib.sdk.v2.V2NIMError
import com.netease.nimlib.sdk.v2.auth.V2NIMLoginDetailListener
import com.netease.nimlib.sdk.v2.auth.V2NIMLoginExtensionProvider
import com.netease.nimlib.sdk.v2.auth.V2NIMLoginListener
import com.netease.nimlib.sdk.v2.auth.V2NIMLoginService
import com.netease.nimlib.sdk.v2.auth.V2NIMTokenProvider
import com.netease.nimlib.sdk.v2.auth.enums.V2NIMConnectStatus
import com.netease.nimlib.sdk.v2.auth.enums.V2NIMDataSyncState
import com.netease.nimlib.sdk.v2.auth.enums.V2NIMDataSyncType
import com.netease.nimlib.sdk.v2.auth.enums.V2NIMLoginClientChange
import com.netease.nimlib.sdk.v2.auth.enums.V2NIMLoginStatus
import com.netease.nimlib.sdk.v2.auth.model.V2NIMKickedOfflineDetail
import com.netease.nimlib.sdk.v2.auth.model.V2NIMLoginClient
import com.netease.nimlib.sdk.v2.auth.option.V2NIMLoginOption
import com.netease.yunxin.kit.alog.ALog
import kotlin.coroutines.resume
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.channels.awaitClose
import kotlinx.coroutines.channels.onFailure
import kotlinx.coroutines.flow.callbackFlow
import kotlinx.coroutines.flow.launchIn
import kotlinx.coroutines.flow.onEach
import kotlinx.coroutines.runBlocking
import kotlinx.coroutines.suspendCancellableCoroutine
import kotlinx.coroutines.withTimeoutOrNull

/**
 * flutter 登录组件
 *
 * @constructor
 *
 * @param applicationContext
 * @param nimCore
 */
class FLTLoginService(
    applicationContext: Context,
    nimCore: NimCore
) : FLTService(applicationContext, nimCore) {

    override val serviceName: String = "LoginService"

    init {
        nimCore.onInitialized {
            loginListener()
            loginDetailListener()
            registerFlutterMethodCalls(
                "login" to this::login,
                "logout" to this::logout,
                "getLoginUser" to this::getLoginUser,
                "getLoginStatus" to this::getLoginStatus,
                "getLoginClients" to this::getLoginClients,
                "kickOffline" to this::kickOffline,
                "getKickedOfflineDetail" to this::getKickedOfflineDetail,
                "getConnectStatus" to this::getConnectStatus,
                "getDataSync" to this::getDataSync,
                "getChatroomLinkAddress" to this::getChatroomLinkAddress,
                "setReconnectDelayProvider" to this::setReconnectDelayProvider
            )
        }
    }

    @ExperimentalCoroutinesApi
    private fun loginListener() {
        callbackFlow<Pair<String, Map<String, Any?>?>> {
            val listener = object : V2NIMLoginListener {
                override fun onLoginStatus(status: V2NIMLoginStatus?) {
                    ALog.i(serviceName, "onLoginStatus: $status")
                    trySend(
                        Pair<String, Map<String, Any?>>(
                            "onLoginStatus",
                            mapOf(
                                "status" to
                                    status?.value
                            )
                        )
                    ).onFailure {
                        ALog.i(serviceName, "send login status fail: ${it?.message}")
                    }
                }

                override fun onLoginFailed(error: V2NIMError?) {
                    ALog.i(serviceName, "onLoginFailed: $error")
                    trySend(Pair<String, Map<String, Any?>?>("onLoginFailed", error?.toMap())).onFailure {
                        ALog.i(serviceName, "send login failed fail: ${it?.message}")
                    }
                }

                override fun onKickedOffline(detail: V2NIMKickedOfflineDetail?) {
                    ALog.i(serviceName, "onKickedOffline: $detail")
                    trySend(Pair<String, Map<String, Any?>?>("onKickedOffline", detail?.toMap())).onFailure {
                        ALog.i(serviceName, "send kicked offline fail: ${it?.message}")
                    }
                }

                override fun onLoginClientChanged(
                    change: V2NIMLoginClientChange?,
                    clients: MutableList<V2NIMLoginClient>?
                ) {
                    ALog.i(serviceName, "onLoginClientsChange: $change")
                    trySend(
                        Pair<String, Map<String, Any?>?>(
                            "onLoginClientChanged",
                            mapOf(
                                "change" to change?.value,
                                "clients" to clients?.map { it.toMap() }?.toList()
                            )
                        )
                    ).onFailure {
                        ALog.i(serviceName, "send login client changed fail: ${it?.message}")
                    }
                }
            }
            NIMClient.getService(V2NIMLoginService::class.java).apply {
                this.addLoginListener(listener)
                awaitClose {
                    this.removeLoginListener(listener)
                }
            }
        }.onEach { event ->
            notifyEvent(
                method = event.first,
                arguments = event.second as Map<String, Any?>
            )
        }.launchIn(nimCore.lifeCycleScope)
    }

    @ExperimentalCoroutinesApi
    private fun loginDetailListener() {
        callbackFlow<Pair<String, Map<String, Any?>?>> {
            val listener = object : V2NIMLoginDetailListener {
                override fun onConnectStatus(status: V2NIMConnectStatus?) {
                    ALog.i(serviceName, "onConnectStatus: $status")
                    trySend(
                        Pair<String, Map<String, Any?>>(
                            "onConnectStatus",
                            mapOf(
                                "status" to
                                    status?.value
                            )
                        )
                    ).onFailure {
                        ALog.i(serviceName, "send connect status fail: ${it?.message}")
                    }
                }

                override fun onDisconnected(error: V2NIMError?) {
                    ALog.i(serviceName, "onDisconnected: $error")
                    trySend(Pair<String, Map<String, Any?>?>("onDisconnected", error?.toMap())).onFailure {
                        ALog.i(serviceName, "send disconnected fail: ${it?.message}")
                    }
                }

                override fun onConnectFailed(error: V2NIMError?) {
                    ALog.i(serviceName, "onConnectFailed: $error")
                    trySend(Pair<String, Map<String, Any?>?>("onConnectFailed", error?.toMap())).onFailure {
                        ALog.i(serviceName, "send connect failed fail: ${it?.message}")
                    }
                }

                override fun onDataSync(
                    type: V2NIMDataSyncType?,
                    state: V2NIMDataSyncState?,
                    error: V2NIMError?
                ) {
                    ALog.i(serviceName, "onDataSync: $type")
                    trySend(
                        Pair<String, Map<String, Any?>?>(
                            "onDataSync",
                            mapOf(
                                "type" to if (type != null) type.value else null,
                                "state" to if (state != null) state.value else null,
                                "error" to error?.toMap()
                            )
                        )
                    ).onFailure {
                        ALog.i(serviceName, "send data sync fail: ${it?.message}")
                    }
                }
            }
            NIMClient.getService(V2NIMLoginService::class.java).apply {
                this.addLoginDetailListener(listener)
                awaitClose {
                    this.removeLoginDetailListener(listener)
                }
            }
        }.onEach { event ->
            notifyEvent(
                method = event.first,
                arguments = event.second as Map<String, Any?>
            )
        }.launchIn(nimCore.lifeCycleScope)
    }

    private val loginExtensionProvider =
        V2NIMLoginExtensionProvider { accountId ->
            if (accountId != null) {
                runBlocking {
                    withTimeoutOrNull(nimProviderTimeout) {
                        suspendCancellableCoroutine<Any?> { continuation ->
                            notifyEvent(
                                method = "getLoginExtension",
                                arguments = mapOf("accountId" to accountId),
                                callback = MethodChannelSuspendResult(continuation)
                            )
                        } as? String?
                    }
                }
            } else {
                null
            }
        }

    private val loginTokenProvider = V2NIMTokenProvider { accountId ->
        if (accountId != null) {
            runBlocking {
                withTimeoutOrNull(nimProviderTimeout) {
                    suspendCancellableCoroutine<Any?> { continuation ->
                        notifyEvent(
                            method = "getToken",
                            arguments = mapOf("accountId" to accountId),
                            callback = MethodChannelSuspendResult(continuation)
                        )
                    } as? String?
                }
            }
        } else {
            null
        }
    }

    private suspend fun login(arguments: Map<String, *>): NimResult<Void> {
        val accountId = arguments["accountId"] as String?
        val token = arguments["token"] as String?
        if (accountId?.isEmpty() == true || token?.isEmpty() == true) {
            return NimResult(code = paramErrorCode, errorDetails = "accountId or token is empty")
        }
        return suspendCancellableCoroutine { cont ->
            val optionMap = arguments["option"] as Map<String, *>?
            val option = optionMap?.toLoginOptions() ?: V2NIMLoginOption()
            option.tokenProvider = loginTokenProvider
            option.loginExtensionProvider = loginExtensionProvider
            NIMClient.getService(V2NIMLoginService::class.java).login(
                accountId,
                token,
                option,
                {
                    cont.resume(NimResult(0, data = it))
                },
                {
                    cont.resume(NimResult(it.code, errorDetails = it.desc))
                }
            )
        }
    }

    private suspend fun logout(arguments: Map<String, *>): NimResult<Void> {
        return suspendCancellableCoroutine { cont ->
            NIMClient.getService(V2NIMLoginService::class.java).logout(
                {
                    cont.resume(NimResult(0, data = it))
                },
                {
                    cont.resume(NimResult(it.code, errorDetails = it.desc))
                }
            )
        }
    }

    private suspend fun getLoginUser(arguments: Map<String, *>): NimResult<String?> {
        return suspendCancellableCoroutine { cont ->
            NIMClient.getService(V2NIMLoginService::class.java).loginUser.let {
                cont.resume(NimResult(0, data = it))
            }
        }
    }

    private suspend fun getLoginStatus(arguments: Map<String, *>): NimResult<Map<String, Any?>?> {
        return suspendCancellableCoroutine { cont ->
            NIMClient.getService(V2NIMLoginService::class.java).loginStatus.let {
                cont.resume(
                    NimResult(
                        0,
                        data = mapOf<String, Any>(
                            "status" to it.value
                        )
                    )
                )
            }
        }
    }

    private suspend fun getLoginClients(arguments: Map<String, *>): NimResult<Map<String, Any?>?> {
        return suspendCancellableCoroutine { cont ->
            NIMClient.getService(V2NIMLoginService::class.java).loginClients.let { clients ->
                cont.resume(
                    NimResult(
                        0,
                        data = mapOf<String, Any>(
                            "loginClient" to clients.map { it.toMap() }.toList()
                        )
                    )
                )
            }
        }
    }

    private suspend fun kickOffline(arguments: Map<String, *>): NimResult<Void> {
        val clientMap = arguments["client"] as Map<String, *>?
        val client = clientMap?.toNIMLoginClient()
            ?: return NimResult(
                paramErrorCode,
                errorDetails = "client is null"
            )
        return suspendCancellableCoroutine { cont ->
            NIMClient.getService(V2NIMLoginService::class.java).kickOffline(
                client,
                {
                    cont.resume(NimResult(0, data = it))
                },
                {
                    cont.resume(NimResult(it.code, errorDetails = it.desc))
                }
            )
        }
    }

    private suspend fun getKickedOfflineDetail(arguments: Map<String, *>): NimResult<Map<String, Any?>?> {
        return suspendCancellableCoroutine { cont ->
            val detail = NIMClient.getService(V2NIMLoginService::class.java).kickedOfflineDetail
            cont.resume(NimResult(0, data = detail?.toMap()))
        }
    }

    private suspend fun getConnectStatus(arguments: Map<String, *>): NimResult<Map<String, Any?>?> {
        return suspendCancellableCoroutine { cont ->
            val status = NIMClient.getService(V2NIMLoginService::class.java).connectStatus
            cont.resume(NimResult(0, data = mapOf("status" to status.value)))
        }
    }

    private suspend fun getDataSync(arguments: Map<String, *>): NimResult<Map<String, Any?>?> {
        return suspendCancellableCoroutine { cont ->
            val dataSync = NIMClient.getService(V2NIMLoginService::class.java).dataSync
            cont.resume(
                NimResult(
                    0,
                    data = mapOf(
                        "dataSync" to dataSync?.map {
                            it.toMap()
                        }?.toList()
                    )
                )
            )
        }
    }

    private suspend fun getChatroomLinkAddress(arguments: Map<String, *>): NimResult<Map<String, Any?>?> {
        val roomId = arguments["roomId"] as String?
        if (roomId?.isEmpty() == true) {
            return NimResult(
                paramErrorCode,
                errorDetails = "roomId is empty"
            )
        }
        return suspendCancellableCoroutine { cont ->
            NIMClient.getService(V2NIMLoginService::class.java).getChatroomLinkAddress(
                roomId,
                {
                    cont.resume(NimResult(0, data = mapOf("linkAddress" to it)))
                },
                {
                    cont.resume(NimResult(it.code, errorDetails = it.desc))
                }
            )
        }
    }

    private suspend fun setReconnectDelayProvider(arguments: Map<String, *>): NimResult<Void> {
        NIMClient.getService(V2NIMLoginService::class.java).setReconnectDelayProvider {
            runBlocking {
                withTimeoutOrNull(nimProviderTimeout) {
                    val a = suspendCancellableCoroutine<Any?> { continuation ->
                        notifyEvent(
                            method = "getReconnectDelay",
                            arguments = mapOf("delay" to it),
                            callback = MethodChannelSuspendResult(continuation)
                        )
                    } as? Int?
                    a?.toLong()
                } ?: 0
            }
        }
        return NimResult(0)
    }
}
