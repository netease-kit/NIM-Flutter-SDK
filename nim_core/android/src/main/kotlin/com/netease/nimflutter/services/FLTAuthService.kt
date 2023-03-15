/*
 * Copyright (c) 2022 NetEase, Inc. All rights reserved.
 * Use of this source code is governed by a MIT license that can be
 * found in the LICENSE file.
 */

package com.netease.nimflutter.services

import android.content.Context
import com.netease.nimflutter.FLTService
import com.netease.nimflutter.MethodChannelSuspendResult
import com.netease.nimflutter.NimCore
import com.netease.nimflutter.NimResult
import com.netease.nimflutter.NimResultCallback
import com.netease.nimflutter.ResultCallback
import com.netease.nimflutter.SafeResult
import com.netease.nimflutter.dartNameOfStatusCode
import com.netease.nimflutter.stringFromClientTypeEnum
import com.netease.nimflutter.stringToClientTypeEnum
import com.netease.nimlib.sdk.NIMClient
import com.netease.nimlib.sdk.Observer
import com.netease.nimlib.sdk.StatusCode
import com.netease.nimlib.sdk.auth.AuthProvider
import com.netease.nimlib.sdk.auth.AuthService
import com.netease.nimlib.sdk.auth.AuthServiceObserver
import com.netease.nimlib.sdk.auth.LoginInfo
import com.netease.nimlib.sdk.auth.OnlineClient
import com.netease.nimlib.sdk.auth.constant.LoginSyncStatus
import com.netease.yunxin.kit.alog.ALog
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.channels.awaitClose
import kotlinx.coroutines.channels.onFailure
import kotlinx.coroutines.flow.callbackFlow
import kotlinx.coroutines.flow.launchIn
import kotlinx.coroutines.flow.onEach
import kotlinx.coroutines.runBlocking
import kotlinx.coroutines.suspendCancellableCoroutine

object LoginInfoFactory {
    private const val authTypeDefault = 0
    private const val authTypeDynamic = 1
    private const val authTypeThirdParty = 2

    fun fromMap(arguments: Map<String, *>): LoginInfo = run {
        val account = arguments["account"] as String?
        val token = arguments["token"] as String?
        val loginExt = arguments["loginExt"] as String?
        val customClientType = arguments["customClientType"] as Int?
        when (arguments.getOrElse("authType") { authTypeDefault } as Int) {
            authTypeDynamic -> LoginInfo.LoginInfoBuilder.loginInfoDynamic(account, token)
            authTypeThirdParty -> LoginInfo.LoginInfoBuilder.loginInfoThirdParty(
                account,
                token,
                loginExt
            )
            else -> LoginInfo.LoginInfoBuilder.loginInfoDefault(account, token)
        }.withCustomClientType(customClientType ?: 0).build()
    }

    fun toMap(loginInfo: LoginInfo) = mapOf(
        "account" to loginInfo.account,
        "token" to loginInfo.token,
        "loginExt" to loginInfo.loginExt,
        "customClientType" to loginInfo.customClientType,
        "authType" to loginInfo.authType
    )
}

class FLTAuthService(
    applicationContext: Context,
    nimCore: NimCore
) : FLTService(applicationContext, nimCore), AuthProvider {

    private var onlineClients: List<OnlineClient> = listOf()

    override val serviceName: String = "AuthService"

    init {
        nimCore.onInitialized {
            nimCore.sdkOptions?.authProvider = this
            observeOnlineStatus()
            observeOnlineClients()
            observeLoginSyncDataStatus()
        }
    }

    override fun onMethodCalled(method: String, arguments: Map<String, *>, safeResult: SafeResult) {
        when (method) {
            "login" -> login(arguments, safeResult)
            "logout" -> {
                NIMClient.getService(AuthService::class.java).logout()
                ResultCallback<Nothing>(safeResult).result(NimResult.SUCCESS)
            }
            "kickOutOtherOnlineClient" -> {
                kickOutOtherOnlineClient(arguments, safeResult)
            }
        }
    }

    private fun login(arguments: Map<String, *>, safeResult: SafeResult) {
        NIMClient.getService(AuthService::class.java).login(LoginInfoFactory.fromMap(arguments))
            .setCallback(
                NimResultCallback<LoginInfo>(safeResult) {
                    NimResult(
                        code = 0,
                        data = it,
                        convert = { it -> LoginInfoFactory.toMap(it) }
                    )
                }
            )
    }

    @ExperimentalCoroutinesApi
    private fun observeOnlineStatus() {
        callbackFlow<StatusCode> {
            val observer = Observer<StatusCode> { status ->
                ALog.i(serviceName, "onAuthStatusChanged: $status")
                trySend(status).onFailure {
                    ALog.i(serviceName, "send online status fail: ${it?.message}")
                }
            }
            NIMClient.getService(AuthServiceObserver::class.java).apply {
                observeOnlineStatus(observer, true)
                awaitClose {
                    observeOnlineStatus(observer, false)
                }
            }
        }.onEach { status ->
            NIMClient.getService(AuthService::class.java).let {
                notifyEvent(
                    method = "onAuthStatusChanged",
                    arguments = hashMapOf(
                        "status" to dartNameOfStatusCode(status),
                        "clientType" to it.kickedClientType,
                        "customClientType" to it.kickedCustomClientType
                    )
                )
            }
        }.launchIn(nimCore.lifeCycleScope)
    }

    @ExperimentalCoroutinesApi
    private fun observeLoginSyncDataStatus() {
        callbackFlow<LoginSyncStatus> {
            val observer = Observer<LoginSyncStatus> { status ->
                ALog.i(serviceName, "onDataSyncStatusChanged: $status")
                if (status != LoginSyncStatus.NO_BEGIN) {
                    trySend(status).onFailure {
                        ALog.i(serviceName, "send data sync status fail: ${it?.message}")
                    }
                }
            }
            NIMClient.getService(AuthServiceObserver::class.java).apply {
                observeLoginSyncDataStatus(observer, true)
                awaitClose {
                    observeLoginSyncDataStatus(observer, false)
                }
            }
        }.onEach { status ->
            notifyEvent(
                method = "onAuthStatusChanged",
                arguments = hashMapOf(
                    "status" to dartNameOfDataSyncStatus(status)
                )
            )
        }.launchIn(nimCore.lifeCycleScope)
    }

    private fun dartNameOfDataSyncStatus(status: LoginSyncStatus) = when (status) {
        LoginSyncStatus.BEGIN_SYNC -> "dataSyncStart"
        LoginSyncStatus.SYNC_COMPLETED -> "dataSyncFinish"
        else -> throw IllegalStateException()
    }

    @ExperimentalCoroutinesApi
    private fun observeOnlineClients() {
        callbackFlow<List<OnlineClient>> {
            val observer = Observer<List<OnlineClient>?> { clients ->
                trySend(clients ?: listOf()).onFailure {
                    ALog.i(serviceName, "send online clients fail: ${it?.message}")
                }
            }
            NIMClient.getService(AuthServiceObserver::class.java).apply {
                observeOtherClients(observer, true)
                awaitClose {
                    observeOtherClients(observer, false)
                }
            }
        }.onEach { clients ->
            ALog.i(
                serviceName,
                "onOnlineClientsUpdated: ${clients.size} ${clients.joinToString { "${it.os}#${it.clientType}" }}"
            )
            onlineClients = clients
            notifyEvent(
                method = "onOnlineClientsUpdated",
                arguments = hashMapOf(
                    "clients" to clients.map { client -> client.toMap() }
                        .toList()
                )
            )
        }.launchIn(nimCore.lifeCycleScope)
    }

    private fun kickOutOtherOnlineClient(
        arguments: Map<String, *>,
        safeResult: SafeResult
    ) {
        onlineClients.firstOrNull {
            stringToClientTypeEnum(arguments["clientType"] as? String) == it.clientType &&
                arguments["customTag"] == it.customTag &&
                arguments["loginTime"] == it.loginTime &&
                arguments["os"] == it.os
        }?.let { client ->
            ALog.i(serviceName, "kickOutOtherOnlineClient: ${client.os}#${client.clientType}")
            NIMClient.getService(AuthService::class.java).kickOtherClient(client)
                .setCallback(NimResultCallback<Void>(safeResult))
        } ?: safeResult.success(NimResult.FAILURE.toMap())
    }

    override fun getToken(account: String?): String? =
        if (account != null) {
            runBlocking {
                suspendCancellableCoroutine<Any?> { continuation ->
                    notifyEvent(
                        method = "getDynamicToken",
                        arguments = mapOf("account" to account),
                        callback = MethodChannelSuspendResult(continuation)
                    )
                } as? String
            }
        } else {
            null
        }
}

fun OnlineClient.toMap() = mapOf(
    "os" to os,
    "loginTime" to loginTime,
    "customTag" to customTag,
    "clientType" to stringFromClientTypeEnum(clientType)
)
