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
import com.netease.nimflutter.toQChatDeleteMessageParam
import com.netease.nimflutter.toQChatDownloadAttachmentParam
import com.netease.nimflutter.toQChatGetMessageHistoryByIdsParam
import com.netease.nimflutter.toQChatGetMessageHistoryParam
import com.netease.nimflutter.toQChatMarkMessageReadParam
import com.netease.nimflutter.toQChatMarkSystemNotificationsReadParam
import com.netease.nimflutter.toQChatResendMessageParam
import com.netease.nimflutter.toQChatResendSystemNotificationParam
import com.netease.nimflutter.toQChatRevokeMessageParam
import com.netease.nimflutter.toQChatSendMessageParam
import com.netease.nimflutter.toQChatSendSystemNotificationParam
import com.netease.nimflutter.toQChatUpdateMessageParam
import com.netease.nimflutter.toQChatUpdateSystemNotificationParam
import com.netease.nimlib.sdk.NIMClient
import com.netease.nimlib.sdk.qchat.QChatMessageService
import com.netease.nimlib.sdk.qchat.result.QChatDeleteMessageResult
import com.netease.nimlib.sdk.qchat.result.QChatGetMessageHistoryResult
import com.netease.nimlib.sdk.qchat.result.QChatRevokeMessageResult
import com.netease.nimlib.sdk.qchat.result.QChatSendMessageResult
import com.netease.nimlib.sdk.qchat.result.QChatSendSystemNotificationResult
import com.netease.nimlib.sdk.qchat.result.QChatUpdateMessageResult
import com.netease.nimlib.sdk.qchat.result.QChatUpdateSystemNotificationResult
import kotlinx.coroutines.suspendCancellableCoroutine

class FLTQChatMessageService(
    applicationContext: Context,
    nimCore: NimCore
) : FLTService(applicationContext, nimCore) {

    override val serviceName = "QChatMessageService"

    private val qChatMessageService: QChatMessageService by lazy {
        NIMClient.getService(QChatMessageService::class.java)
    }

    init {
        nimCore.onInitialized {
            registerFlutterMethodCalls(
                "deleteMessage" to ::deleteMessage,
                "getMessageHistory" to ::getMessageHistory,
                "getMessageHistoryByIds" to ::getMessageHistoryByIds,
                "markMessageRead" to ::markMessageRead,
                "markSystemNotificationsRead" to ::markSystemNotificationsRead,
                "revokeMessage" to ::revokeMessage,
                "sendMessage" to ::sendMessage,
                "sendSystemNotification" to ::sendSystemNotification,
                "updateMessage" to ::updateMessage,
                "updateSystemNotification" to ::updateSystemNotification,
                "downloadAttachment" to ::downloadAttachment,
                "resendMessage" to ::resendMessage,
                "resendSystemNotification" to ::resendSystemNotification
            )
        }
    }

    private suspend fun deleteMessage(arguments: Map<String, *>): NimResult<QChatDeleteMessageResult> {
        return suspendCancellableCoroutine { cont ->
            qChatMessageService.deleteMessage(
                arguments.toQChatDeleteMessageParam()
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

    private suspend fun getMessageHistory(arguments: Map<String, *>): NimResult<QChatGetMessageHistoryResult> {
        return suspendCancellableCoroutine { cont ->
            qChatMessageService.getMessageHistory(
                arguments.toQChatGetMessageHistoryParam()
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

    private suspend fun getMessageHistoryByIds(arguments: Map<String, *>): NimResult<QChatGetMessageHistoryResult> {
        return suspendCancellableCoroutine { cont ->
            qChatMessageService.getMessageHistoryByIds(
                arguments.toQChatGetMessageHistoryByIdsParam()
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

    private suspend fun markMessageRead(arguments: Map<String, *>): NimResult<Nothing> {
        return suspendCancellableCoroutine { cont ->
            qChatMessageService.markMessageRead(
                arguments.toQChatMarkMessageReadParam()
            ).setCallback(
                NimResultContinuationCallbackOfNothing(cont)
            )
        }
    }

    private suspend fun markSystemNotificationsRead(arguments: Map<String, *>): NimResult<Nothing> {
        return suspendCancellableCoroutine { cont ->
            qChatMessageService.markSystemNotificationsRead(
                arguments.toQChatMarkSystemNotificationsReadParam()
            ).setCallback(
                NimResultContinuationCallbackOfNothing(cont)
            )
        }
    }

    private suspend fun revokeMessage(arguments: Map<String, *>): NimResult<QChatRevokeMessageResult> {
        return suspendCancellableCoroutine { cont ->
            qChatMessageService.revokeMessage(
                arguments.toQChatRevokeMessageParam()
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

    private suspend fun sendMessage(arguments: Map<String, *>): NimResult<QChatSendMessageResult> {
        return suspendCancellableCoroutine { cont ->
            qChatMessageService.sendMessage(
                arguments.toQChatSendMessageParam()
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

    private suspend fun resendMessage(arguments: Map<String, *>): NimResult<QChatSendMessageResult> {
        return suspendCancellableCoroutine { cont ->
            qChatMessageService.resendMessage(
                arguments.toQChatResendMessageParam()
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

    private suspend fun sendSystemNotification(arguments: Map<String, *>): NimResult<QChatSendSystemNotificationResult> {
        return suspendCancellableCoroutine { cont ->
            qChatMessageService.sendSystemNotification(
                arguments.toQChatSendSystemNotificationParam()
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

    private suspend fun updateMessage(arguments: Map<String, *>): NimResult<QChatUpdateMessageResult> {
        return suspendCancellableCoroutine { cont ->
            qChatMessageService.updateMessage(
                arguments.toQChatUpdateMessageParam()
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

    private suspend fun updateSystemNotification(arguments: Map<String, *>): NimResult<QChatUpdateSystemNotificationResult> {
        return suspendCancellableCoroutine { cont ->
            qChatMessageService.updateSystemNotification(
                arguments.toQChatUpdateSystemNotificationParam()
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

    private suspend fun resendSystemNotification(arguments: Map<String, *>): NimResult<QChatSendSystemNotificationResult> {
        return suspendCancellableCoroutine { cont ->
            qChatMessageService.resendSystemNotification(
                arguments.toQChatResendSystemNotificationParam()
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

    private suspend fun downloadAttachment(arguments: Map<String, *>): NimResult<Nothing> {
        return suspendCancellableCoroutine { cont ->
            qChatMessageService.downloadAttachment(
                arguments.toQChatDownloadAttachmentParam()
            ).setCallback(
                NimResultContinuationCallbackOfNothing(cont)
            )
        }
    }
}
