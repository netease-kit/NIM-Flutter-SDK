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
import com.netease.nimflutter.convertV2NIMSendCustomNotificationParams
import com.netease.nimflutter.toMap
import com.netease.nimlib.sdk.NIMClient
import com.netease.nimlib.sdk.v2.notification.V2NIMBroadcastNotification
import com.netease.nimlib.sdk.v2.notification.V2NIMCustomNotification
import com.netease.nimlib.sdk.v2.notification.V2NIMNotificationListener
import com.netease.nimlib.sdk.v2.notification.V2NIMNotificationService
import kotlin.coroutines.resume
import kotlinx.coroutines.suspendCancellableCoroutine

class FLTNotificationService(
    applicationContext: Context,
    nimCore: NimCore
) : FLTService(applicationContext, nimCore) {
    private val tag = "FLTNotifyService"

    override val serviceName = "NotificationService"

    private val notifyListener =
        object : V2NIMNotificationListener {
            override fun onReceiveCustomNotifications(customNotifications: MutableList<V2NIMCustomNotification>?) {
                notifyEvent(
                    "onReceiveCustomNotifications",
                    mapOf("customNotifications" to customNotifications?.map { it.toMap() })
                )
            }

            override fun onReceiveBroadcastNotifications(broadcastNotifications: MutableList<V2NIMBroadcastNotification>?) {
                notifyEvent(
                    "onReceiveBroadcastNotifications",
                    mapOf("broadcastNotifications" to broadcastNotifications?.map { it.toMap() })
                )
            }
        }

    init {
        nimCore.onInitialized {
            NIMClient.getService(V2NIMNotificationService::class.java)
                .addNotificationListener(notifyListener)
        }
        registerFlutterMethodCalls(
            "sendCustomNotification" to ::sendCustomNotification
        )
    }

    private suspend fun sendCustomNotification(arguments: Map<String, *>): NimResult<Nothing> {
        return suspendCancellableCoroutine { cont ->
            val conversationId = arguments["conversationId"] as String
            val content = arguments["content"] as String
            val paramMap = arguments["params"] as Map<String, Any>?
            val notificationParam =
                if (paramMap != null) {
                    convertV2NIMSendCustomNotificationParams(paramMap)
                } else {
                    null
                }
            NIMClient.getService(V2NIMNotificationService::class.java)
                .sendCustomNotification(conversationId, content, notificationParam, { result ->
                    cont.resume(
                        NimResult.SUCCESS
                    )
                }, { error ->
                    cont.resume(
                        if (error != null) {
                            NimResult(code = error.code, errorDetails = error.desc)
                        } else {
                            NimResult(code = -1, errorDetails = "sendCustomNotification failed!")
                        }
                    )
                })
        }
    }
}
