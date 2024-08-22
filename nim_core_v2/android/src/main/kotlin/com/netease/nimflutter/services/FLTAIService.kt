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
import com.netease.nimflutter.toAIModelCallMessage
import com.netease.nimflutter.toAIModelConfigParams
import com.netease.nimflutter.toMap
import com.netease.nimlib.sdk.NIMClient
import com.netease.nimlib.sdk.v2.ai.V2NIMAIListener
import com.netease.nimlib.sdk.v2.ai.V2NIMAIService
import com.netease.nimlib.sdk.v2.ai.config.V2NIMAIModelConfig
import com.netease.nimlib.sdk.v2.ai.config.V2NIMProxyAICallAntispamConfig
import com.netease.nimlib.sdk.v2.ai.model.V2NIMAIUser
import com.netease.nimlib.sdk.v2.ai.params.V2NIMAIModelCallContent
import com.netease.nimlib.sdk.v2.ai.params.V2NIMProxyAIModelCallParams
import com.netease.nimlib.sdk.v2.ai.result.V2NIMAIModelCallResult
import com.netease.yunxin.kit.alog.ALog
import kotlin.coroutines.resume
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.channels.awaitClose
import kotlinx.coroutines.channels.onFailure
import kotlinx.coroutines.flow.callbackFlow
import kotlinx.coroutines.flow.launchIn
import kotlinx.coroutines.flow.onEach
import kotlinx.coroutines.suspendCancellableCoroutine

class FLTAIService(
    applicationContext: Context,
    nimCore: NimCore
) : FLTService(applicationContext, nimCore) {
    override val serviceName: String = "AIService"

    init {
        nimCore.onInitialized {
            aiListener()
            registerFlutterMethodCalls(
                "getAIUserList" to this::getAIUserList,
                "proxyAIModelCall" to this::proxyAIModelCall
            )
        }
    }

    private suspend fun getAIUserList(arguments: Map<String, *>): NimResult<Map<String, Any?>?> {
        return suspendCancellableCoroutine { cont ->
            NIMClient.getService(V2NIMAIService::class.java).getAIUserList(
                {
                    cont.resume(
                        NimResult(
                            0,
                            data = mapOf(
                                "userList" to it.map { aiUser -> aiUser.toMap() }.toList()
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

    private suspend fun proxyAIModelCall(arguments: Map<String, *>): NimResult<Void> {
        val paramsMap = arguments["params"] as Map<String, *>?
            ?: return NimResult(paramErrorCode, errorDetails = "params is null")
        val params = getParamsFromMap(paramsMap)
        return suspendCancellableCoroutine { cont ->
            NIMClient.getService(V2NIMAIService::class.java).proxyAIModelCall(
                params,
                {
                    cont.resume(
                        NimResult(
                            0,
                            it
                        )
                    )
                },
                {
                    cont.resume(NimResult(it.code, errorDetails = it.desc))
                }
            )
        }
    }

    private fun getParamsFromMap(paramsMap: Map<String, *>): V2NIMProxyAIModelCallParams {
        val accountId = paramsMap["accountId"] as String?
        val requestId = paramsMap["requestId"] as String?
        val contentMap = paramsMap["content"] as Map<String, *>?
        val content = V2NIMAIModelCallContent()
        contentMap?.let {
            content.msg = it["msg"] as String?
            content.type = it["type"] as Int?
        }
        val params = V2NIMProxyAIModelCallParams(accountId, requestId, content)
        params.promptVariables = paramsMap["promptVariables"] as String?
        params.messages = (paramsMap["messages"] as? List<Map<String, *>>)?.map { it.toAIModelCallMessage() }
        params.modelConfigParams = (paramsMap["modelConfigParams"] as? Map<String, *>?)?.toAIModelConfigParams()
        params.antispamConfig = (paramsMap["antispamConfig"] as? Map<String, *>?)?.toNIMProxyAICallAntispamConfig()
        return params
    }

    private fun Map<String, *>.toNIMProxyAICallAntispamConfig(): V2NIMProxyAICallAntispamConfig {
        val antispamConfig = V2NIMProxyAICallAntispamConfig()
        (this["antispamEnabled"] as? Boolean?)?.let { antispamConfig.isAntispamEnabled = it }
        antispamConfig.antispamBusinessId = this["antispamBusinessId"] as? String?
        return antispamConfig
    }

    @ExperimentalCoroutinesApi
    private fun aiListener() {
        callbackFlow<Pair<String, Map<String, Any?>?>> {
            val listener = object : V2NIMAIListener {
                override fun onProxyAIModelCall(result: V2NIMAIModelCallResult?) {
                    ALog.i(serviceName, "onProxyAIModelCall: $result")
                    trySend(
                        Pair<String, Map<String, Any?>?>(
                            "onProxyAIModelCall",
                            result?.toMap()
                        )
                    ).onFailure {
                        ALog.i(serviceName, "send onProxyAIModelCall fail: ${it?.message}")
                    }
                }
            }
            NIMClient.getService(V2NIMAIService::class.java).apply {
                this.addAIListener(listener)
                awaitClose {
                    this.removeAIListener(listener)
                }
            }
        }.onEach { event ->
            notifyEvent(
                method = event.first,
                arguments = event.second as Map<String, Any?>
            )
        }.launchIn(nimCore.lifeCycleScope)
    }

    fun V2NIMAIModelCallResult.toMap(): Map<String, Any?> {
        return mapOf(
            "code" to this.code,
            "accountId" to this.accountId,
            "requestId" to this.requestId,
            "content" to this.content.toMap()
        )
    }

    fun V2NIMAIUser.toMap(): Map<String, Any?> =
        mapOf(
            "accountId" to accountId,
            "name" to name,
            "avatar" to avatar,
            "sign" to sign,
            "gender" to gender,
            "email" to email,
            "birthday" to birthday,
            "mobile" to mobile,
            "serverExtension" to serverExtension,
            "createTime" to createTime,
            "updateTime" to updateTime,
            "modelType" to modelType.value,
            "modelConfig" to modelConfig?.toMap()
        )

    fun V2NIMAIModelConfig.toMap(): Map<String, Any?> =
        mapOf(
            "model" to model,
            "prompt" to prompt,
            "promptKeys" to promptKeys,
            "maxTokens" to maxTokens,
            "topP" to topP,
            "temperature" to temperature
        )
}
