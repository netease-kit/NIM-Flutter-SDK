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
import com.netease.nimflutter.NimResultContinuationCallbackOfNothing
import com.netease.nimflutter.toQChatPushMsgType
import com.netease.nimflutter.toStr
import com.netease.nimlib.sdk.NIMClient
import com.netease.nimlib.sdk.mixpush.QChatPushService
import com.netease.nimlib.sdk.qchat.model.QChatPushConfig
import com.netease.nimlib.sdk.qchat.param.QChatPushConfigParam
import kotlinx.coroutines.suspendCancellableCoroutine

class FLTQChatPushService(
    applicationContext: Context,
    nimCore: NimCore
) : FLTService(applicationContext, nimCore) {

    override val serviceName = "QChatPushService"

    private val qChatPushService: QChatPushService by lazy {
        NIMClient.getService(QChatPushService::class.java)
    }

    init {
        nimCore.onInitialized {
            registerFlutterMethodCalls(
                "enableAndroid" to ::enable,
                "isEnableAndroid" to ::isEnable,
                "getPushConfig" to ::getPushConfig,
                "setPushConfig" to ::setPushConfig,
                "isPushConfigExistAndroid" to ::isPushConfigExist
            )
        }
    }

    @Suppress("UNCHECKED_CAST")
    private suspend fun enable(arguments: Map<String, *>): NimResult<Nothing> {
        return suspendCancellableCoroutine { cont ->
            qChatPushService.enable(
                arguments["enable"] as Boolean
            ).setCallback(
                NimResultContinuationCallbackOfNothing(cont)
            )
        }
    }

    private suspend fun isEnable(arguments: Map<String, *>): NimResult<Boolean> {
        val isEnable = qChatPushService.isEnable
        return NimResult(0, data = isEnable)
    }

    private suspend fun getPushConfig(arguments: Map<String, *>): NimResult<QChatPushConfig> {
        return NimResult(0, data = qChatPushService.pushConfig, convert = { it.toMap() })
    }

    fun QChatPushConfig.toMap() = mapOf<String, Any?>(
        "isPushShowNoDetail" to isPushShowNoDetail,
        "isNoDisturbOpen" to isNoDisturbOpen,
        "startNoDisturbTime" to startTimeString,
        "stopNoDisturbTime" to stopTimeString,
        "pushMsgType" to pushMsgType.toStr()
    )

    private suspend fun setPushConfig(arguments: Map<String, *>): NimResult<Nothing> {
        return suspendCancellableCoroutine { cont ->
            qChatPushService.setPushConfig(
                arguments.toQChatPushConfigParam()
            ).setCallback(
                NimResultContinuationCallbackOfNothing(cont)
            )
        }
    }

    private fun Map<String, *>.toQChatPushConfigParam(): QChatPushConfigParam {
        val isPushShowNoDetail = this["isPushShowNoDetail"] as Boolean
        val param = QChatPushConfigParam(isPushShowNoDetail)
        (this["isNoDisturbOpen"] as Boolean?).let {
            param.noDisturbOpen = it
        }
        (this["startNoDisturbTime"] as String?).let {
            param.startNoDisturbTime = it
        }
        (this["stopNoDisturbTime"] as String?).let {
            param.stopNoDisturbTime = it
        }
        (this["pushMsgType"] as String?)?.toQChatPushMsgType().let {
            param.pushMsgType = it
        }
        return param
    }

    private suspend fun isPushConfigExist(arguments: Map<String, *>): NimResult<Boolean> {
        val isEnable = qChatPushService.isPushConfigExist
        return NimResult(0, data = isEnable)
    }
}
