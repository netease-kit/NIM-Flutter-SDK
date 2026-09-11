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
import com.netease.nimflutter.extension.toAIModelCallMessage
import com.netease.nimflutter.extension.toAIModelConfigParams
import com.netease.nimflutter.extension.toMap
import com.netease.nimflutter.toMap
import com.netease.nimlib.sdk.NIMClient
import com.netease.nimlib.sdk.v2.ai.V2NIMAIListener
import com.netease.nimlib.sdk.v2.ai.V2NIMAIService
import com.netease.nimlib.sdk.v2.ai.config.V2NIMAIModelConfig
import com.netease.nimlib.sdk.v2.ai.config.V2NIMProxyAICallAntispamConfig
import com.netease.nimlib.sdk.v2.ai.model.V2NIMAIUser
import com.netease.nimlib.sdk.v2.ai.model.V2NIMUserAIBot
import com.netease.nimlib.sdk.v2.ai.params.V2NIMAIModelCallContent
import com.netease.nimlib.sdk.v2.ai.params.V2NIMAIModelStreamCallStopParams
import com.netease.nimlib.sdk.v2.ai.params.V2NIMBindUserAIBotToQrCodeParams
import com.netease.nimlib.sdk.v2.ai.params.V2NIMCreateUserAIBotParams
import com.netease.nimlib.sdk.v2.ai.params.V2NIMDeleteUserAIBotParams
import com.netease.nimlib.sdk.v2.ai.params.V2NIMGetUserAIBotListParams
import com.netease.nimlib.sdk.v2.ai.params.V2NIMGetUserAIBotParams
import com.netease.nimlib.sdk.v2.ai.params.V2NIMProxyAIModelCallParams
import com.netease.nimlib.sdk.v2.ai.params.V2NIMRefreshUserAIBotTokenParams
import com.netease.nimlib.sdk.v2.ai.params.V2NIMUpdateUserAIBotParams
import com.netease.nimlib.sdk.v2.ai.result.V2NIMAIModelCallResult
import com.netease.nimlib.sdk.v2.ai.result.V2NIMAIModelStreamCallResult
import com.netease.nimlib.sdk.v2.ai.result.V2NIMCreateUserAIBotResult
import com.netease.nimlib.sdk.v2.ai.result.V2NIMGetUserAIBotListResult
import com.netease.nimlib.sdk.v2.ai.result.V2NIMRefreshUserAIBotTokenResult
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
                "proxyAIModelCall" to this::proxyAIModelCall,
                "stopAIModelStreamCall" to this::stopAIModelStreamCall,
                "createUserAIBot" to this::createUserAIBot,
                "deleteUserAIBot" to this::deleteUserAIBot,
                "updateUserAIBot" to this::updateUserAIBot,
                "getUserAIBot" to this::getUserAIBot,
                "getUserAIBotList" to this::getUserAIBotList,
                "bindUserAIBotToQrCode" to this::bindUserAIBotToQrCode,
                "refreshUserAIBotToken" to this::refreshUserAIBotToken
            )
        }
    }

    private val aiService: V2NIMAIService
        get() = NIMClient.getService(V2NIMAIService::class.java)

    private suspend fun getAIUserList(arguments: Map<String, *>): NimResult<Map<String, Any?>?> {
        return suspendCancellableCoroutine { cont ->
            aiService.getAIUserList(
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

    private suspend fun stopAIModelStreamCall(arguments: Map<String, *>): NimResult<Void> {
        val paramsMap = arguments["params"] as Map<String, *>?
            ?: return NimResult(paramErrorCode, errorDetails = "params is null")
        val params = getV2NIMAIModelStreamCallStopParamsFromMap(paramsMap)
        return suspendCancellableCoroutine { cont ->
            aiService.stopAIModelStreamCall(
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

    private suspend fun proxyAIModelCall(arguments: Map<String, *>): NimResult<Void> {
        val paramsMap = arguments["params"] as Map<String, *>?
            ?: return NimResult(paramErrorCode, errorDetails = "params is null")
        val params = getParamsFromMap(paramsMap)
        return suspendCancellableCoroutine { cont ->
            aiService.proxyAIModelCall(
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

    private suspend fun createUserAIBot(arguments: Map<String, *>): NimResult<Map<String, Any?>?> {
        val paramsMap = arguments["params"] as? Map<String, *>
            ?: return NimResult(paramErrorCode, errorDetails = "params is null")
        return suspendCancellableCoroutine { cont ->
            aiService.createUserAIBot(
                paramsMap.toCreateUserAIBotParams(),
                { cont.resume(NimResult(0, it?.toMap())) },
                { cont.resume(NimResult(it.code, errorDetails = it.desc)) }
            )
        }
    }

    private suspend fun deleteUserAIBot(arguments: Map<String, *>): NimResult<Void> {
        val paramsMap = arguments["params"] as? Map<String, *>
            ?: return NimResult(paramErrorCode, errorDetails = "params is null")
        return suspendCancellableCoroutine { cont ->
            aiService.deleteUserAIBot(
                paramsMap.toDeleteUserAIBotParams(),
                { cont.resume(NimResult(0, it)) },
                { cont.resume(NimResult(it.code, errorDetails = it.desc)) }
            )
        }
    }

    private suspend fun updateUserAIBot(arguments: Map<String, *>): NimResult<Void> {
        val paramsMap = arguments["params"] as? Map<String, *>
            ?: return NimResult(paramErrorCode, errorDetails = "params is null")
        return suspendCancellableCoroutine { cont ->
            aiService.updateUserAIBot(
                paramsMap.toUpdateUserAIBotParams(),
                { cont.resume(NimResult(0, it)) },
                { cont.resume(NimResult(it.code, errorDetails = it.desc)) }
            )
        }
    }

    private suspend fun getUserAIBot(arguments: Map<String, *>): NimResult<Map<String, Any?>?> {
        val paramsMap = arguments["params"] as? Map<String, *>
            ?: return NimResult(paramErrorCode, errorDetails = "params is null")
        return suspendCancellableCoroutine { cont ->
            aiService.getUserAIBot(
                paramsMap.toGetUserAIBotParams(),
                { cont.resume(NimResult(0, it?.toMap())) },
                { cont.resume(NimResult(it.code, errorDetails = it.desc)) }
            )
        }
    }

    private suspend fun getUserAIBotList(arguments: Map<String, *>): NimResult<Map<String, Any?>?> {
        val paramsMap = arguments["params"] as? Map<String, *>
        return suspendCancellableCoroutine { cont ->
            aiService.getUserAIBotList(
                paramsMap?.toGetUserAIBotListParams(),
                { cont.resume(NimResult(0, it?.toMap())) },
                { cont.resume(NimResult(it.code, errorDetails = it.desc)) }
            )
        }
    }

    private suspend fun bindUserAIBotToQrCode(arguments: Map<String, *>): NimResult<Void> {
        val paramsMap = arguments["params"] as? Map<String, *>
            ?: return NimResult(paramErrorCode, errorDetails = "params is null")
        return suspendCancellableCoroutine { cont ->
            aiService.bindUserAIBotToQrCode(
                paramsMap.toBindUserAIBotToQrCodeParams(),
                { cont.resume(NimResult(0, it)) },
                { cont.resume(NimResult(it.code, errorDetails = it.desc)) }
            )
        }
    }

    private suspend fun refreshUserAIBotToken(arguments: Map<String, *>): NimResult<Map<String, Any?>?> {
        val paramsMap = arguments["params"] as? Map<String, *>
            ?: return NimResult(paramErrorCode, errorDetails = "params is null")
        return suspendCancellableCoroutine { cont ->
            aiService.refreshUserAIBotToken(
                paramsMap.toRefreshUserAIBotTokenParams(),
                { cont.resume(NimResult(0, it?.toMap())) },
                { cont.resume(NimResult(it.code, errorDetails = it.desc)) }
            )
        }
    }

    private fun getV2NIMAIModelStreamCallStopParamsFromMap(paramsMap: Map<String, *>): V2NIMAIModelStreamCallStopParams {
        val accountId = paramsMap["accountId"] as String?
        val requestId = paramsMap["requestId"] as String?
        val params = V2NIMAIModelStreamCallStopParams(accountId, requestId)
        return params
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
        params.isAIStream = paramsMap["aiStream"] as Boolean? ?: false
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
                        ALog.e(serviceName, "send onProxyAIModelCall fail: ${it?.message}")
                    }
                }

                override fun onProxyAIModelStreamCall(result: V2NIMAIModelStreamCallResult?) {
                    ALog.i(serviceName, "onProxyAIModelStreamCall: $result")
                    trySend(
                        Pair<String, Map<String, Any?>?>(
                            "onProxyAIModelStreamCall",
                            result?.toMap()
                        )
                    ).onFailure {
                        ALog.e(serviceName, "send onProxyAIModelStreamCall fail: ${it?.message}")
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
            "content" to this.content?.toMap(),
            "timestamp" to this.timestamp,
            "aiRAGs" to this.airaGs?.map { it.toMap() }?.toList(),
            "aiStream" to this.isAIStream,
            "aiStreamStatus" to this.aiStreamStatus.value
        )
    }

    fun V2NIMAIModelStreamCallResult.toMap(): Map<String, Any?> {
        return mapOf(
            "code" to this.code,
            "accountId" to this.accountId,
            "requestId" to this.requestId,
            "content" to this.content?.toMap(),
            "aiRAGs" to this.airaGs?.map { it.toMap() }?.toList(),
            "timestamp" to this.timestamp
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
            "aiModelType" to aiModelType,
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

    private fun Map<String, *>.toCreateUserAIBotParams(): V2NIMCreateUserAIBotParams =
        V2NIMCreateUserAIBotParams().apply {
            accid = this@toCreateUserAIBotParams["accid"] as? String
            name = this@toCreateUserAIBotParams["name"] as? String
            icon = this@toCreateUserAIBotParams["icon"] as? String
            sign = this@toCreateUserAIBotParams["sign"] as? String
            ex = this@toCreateUserAIBotParams["ex"] as? String
        }

    private fun Map<String, *>.toUpdateUserAIBotParams(): V2NIMUpdateUserAIBotParams =
        V2NIMUpdateUserAIBotParams().apply {
            accid = this@toUpdateUserAIBotParams["accid"] as? String
            name = this@toUpdateUserAIBotParams["name"] as? String
            icon = this@toUpdateUserAIBotParams["icon"] as? String
            sign = this@toUpdateUserAIBotParams["sign"] as? String
            ex = this@toUpdateUserAIBotParams["ex"] as? String
        }

    private fun Map<String, *>.toDeleteUserAIBotParams(): V2NIMDeleteUserAIBotParams =
        V2NIMDeleteUserAIBotParams().apply {
            accid = this@toDeleteUserAIBotParams["accid"] as? String
        }

    private fun Map<String, *>.toGetUserAIBotParams(): V2NIMGetUserAIBotParams =
        V2NIMGetUserAIBotParams().apply {
            accid = this@toGetUserAIBotParams["accid"] as? String
        }

    private fun Map<String, *>.toGetUserAIBotListParams(): V2NIMGetUserAIBotListParams =
        V2NIMGetUserAIBotListParams().apply {
            pageToken = this@toGetUserAIBotListParams["pageToken"] as? String
            limit = (this@toGetUserAIBotListParams["limit"] as? Number)?.toInt() ?: 0
        }

    private fun Map<String, *>.toBindUserAIBotToQrCodeParams(): V2NIMBindUserAIBotToQrCodeParams =
        V2NIMBindUserAIBotToQrCodeParams().apply {
            accid = this@toBindUserAIBotToQrCodeParams["accid"] as? String
            token = this@toBindUserAIBotToQrCodeParams["token"] as? String
            qrCode = this@toBindUserAIBotToQrCodeParams["qrCode"] as? String
        }

    private fun Map<String, *>.toRefreshUserAIBotTokenParams(): V2NIMRefreshUserAIBotTokenParams =
        V2NIMRefreshUserAIBotTokenParams().apply {
            accid = this@toRefreshUserAIBotTokenParams["accid"] as? String
        }

    private fun V2NIMUserAIBot.toMap(): Map<String, Any?> =
        mapOf(
            "accid" to accid,
            "appid" to appid,
            "name" to name,
            "icon" to icon,
            "sign" to sign,
            "gender" to gender,
            "email" to email,
            "birth" to birth,
            "mobile" to mobile,
            "ex" to ex,
            "type" to type,
            "modelConfig" to modelConfig,
            "yunxinConfig" to yunxinConfig,
            "validFlag" to validFlag,
            "createTime" to createTime,
            "updateTime" to updateTime,
            "business" to business,
            "level" to level,
            "ownerid" to ownerid,
            "token" to token
        )

    private fun V2NIMCreateUserAIBotResult.toMap(): Map<String, Any?> =
        mapOf("token" to token)

    private fun V2NIMGetUserAIBotListResult.toMap(): Map<String, Any?> =
        mapOf(
            "bots" to bots?.map { it.toMap() },
            "hasMore" to hasMore(),
            "nextToken" to nextToken
        )

    private fun V2NIMRefreshUserAIBotTokenResult.toMap(): Map<String, Any?> =
        mapOf("token" to token)
}
