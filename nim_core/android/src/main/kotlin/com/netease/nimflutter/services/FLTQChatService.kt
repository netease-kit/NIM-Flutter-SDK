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
import com.netease.nimflutter.NimResultContinuationCallback
import com.netease.nimflutter.NimResultContinuationCallbackOfNothing
import com.netease.nimflutter.toMap
import com.netease.nimflutter.toQChatKickOtherClientsParam
import com.netease.nimflutter.toQChatLoginParam
import com.netease.nimlib.sdk.NIMClient
import com.netease.nimlib.sdk.qchat.QChatService
import com.netease.nimlib.sdk.qchat.result.QChatKickOtherClientsResult
import com.netease.nimlib.sdk.qchat.result.QChatLoginResult
import kotlinx.coroutines.suspendCancellableCoroutine

class FLTQChatService(
    applicationContext: Context,
    nimCore: NimCore
) : FLTService(applicationContext, nimCore) {

    override val serviceName = "QChatService"

    private val qChatService: QChatService by lazy {
        NIMClient.getService(QChatService::class.java)
    }

    init {
        nimCore.onInitialized {
            registerFlutterMethodCalls(
                "login" to ::login,
                "logout" to ::logout,
                "kickOtherClients" to ::kickOtherClients
            )
        }
    }

    @Suppress("UNCHECKED_CAST")
    private suspend fun login(arguments: Map<String, *>): NimResult<QChatLoginResult> {
        return suspendCancellableCoroutine { cont ->
            qChatService.login(
                arguments.toQChatLoginParam()
            ).setCallback(
                NimResultContinuationCallback(cont) { result ->
                    NimResult(
                        code = 0,
                        data = result,
                        convert = { it.toMap() }
                    )
                }
            )
        }
    }

    private suspend fun logout(arguments: Map<String, *>): NimResult<Nothing> {
        return suspendCancellableCoroutine { cont ->
            qChatService.logout().setCallback(
                NimResultContinuationCallbackOfNothing(cont)
            )
        }
    }

    private suspend fun kickOtherClients(arguments: Map<String, *>): NimResult<QChatKickOtherClientsResult> {
        return suspendCancellableCoroutine { cont ->
            qChatService.kickOtherClients(
                arguments.toQChatKickOtherClientsParam()
            ).setCallback(
                NimResultContinuationCallback(cont) { result ->
                    NimResult(
                        code = 0,
                        data = result,
                        convert = { it.toMap() }
                    )
                }
            )
        }
    }
}
