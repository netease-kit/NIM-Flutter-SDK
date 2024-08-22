/*
 * Copyright (c) 2022 NetEase, Inc. All rights reserved.
 * Use of this source code is governed by a MIT license that can be
 * found in the LICENSE file.
 */

package com.netease.nimflutter.services

import android.content.Context
import com.netease.nimflutter.FLTService
import com.netease.nimflutter.LocalError.createMessageFailed
import com.netease.nimflutter.NimCore
import com.netease.nimflutter.NimResult
import com.netease.nimflutter.toMap
import com.netease.nimflutter.toMessage
import com.netease.nimlib.sdk.v2.message.V2NIMMessage
import com.netease.nimlib.sdk.v2.message.V2NIMMessageCreator
import com.netease.nimlib.sdk.v2.message.model.V2NIMMessageCallDuration
import kotlin.coroutines.resume
import kotlinx.coroutines.suspendCancellableCoroutine

class FLTMessageCreatorService(
    applicationContext: Context,
    nimCore: NimCore
) : FLTService(applicationContext, nimCore) {
    override val serviceName: String = "MessageCreatorService"

    init {
        nimCore.onInitialized {
            registerFlutterMethodCalls(
                "createTextMessage" to this::createTextMessage,
                "createImageMessage" to this::createImageMessage,
                "createAudioMessage" to this::createAudioMessage,
                "createVideoMessage" to this::createVideoMessage,
                "createFileMessage" to this::createFileMessage,
                "createLocationMessage" to this::createLocationMessage,
                "createCustomMessage" to this::createCustomMessage,
                "createTipsMessage" to this::createTipsMessage,
                "createCallMessage" to this::createCallMessage,
                "createForwardMessage" to this::createForwardMessage
            )
        }
    }

    private suspend fun createTextMessage(arguments: Map<String, *>): NimResult<Map<String, Any?>?> {
        return suspendCancellableCoroutine { cont ->
            val text = arguments["text"] as? String
            val message: V2NIMMessage? = V2NIMMessageCreator.createTextMessage(text)
            if (message == null) {
                cont.resume(
                    NimResult(
                        code = createMessageFailed,
                        errorDetails = "create Message failed"
                    )
                )
            } else {
                cont.resume(NimResult(0, data = message.toMap()))
            }
        }
    }

    private suspend fun createImageMessage(arguments: Map<String, *>): NimResult<Map<String, Any?>?> {
        return suspendCancellableCoroutine { cont ->
            val imagePath = arguments["imagePath"] as? String
            val name = arguments["name"] as? String
            val sceneName = arguments["sceneName"] as? String
            val height = arguments["height"] as? Int
            val width = arguments["width"] as? Int
            val message: V2NIMMessage? = V2NIMMessageCreator.createImageMessage(
                imagePath,
                name,
                sceneName,
                width,
                height
            )
            if (message == null) {
                cont.resume(
                    NimResult(
                        code = createMessageFailed,
                        errorDetails = "create Message failed"
                    )
                )
            } else {
                cont.resume(NimResult(0, data = message.toMap()))
            }
        }
    }

    private suspend fun createAudioMessage(arguments: Map<String, *>): NimResult<Map<String, Any?>?> {
        return suspendCancellableCoroutine { cont ->
            val audioPath = arguments["audioPath"] as? String
            val name = arguments["name"] as? String
            val sceneName = arguments["sceneName"] as? String
            val duration = arguments["duration"] as? Int ?: 0
            val message: V2NIMMessage? = V2NIMMessageCreator.createAudioMessage(
                audioPath,
                name,
                sceneName,
                duration
            )
            if (message == null) {
                cont.resume(
                    NimResult(
                        code = createMessageFailed,
                        errorDetails = "create Message failed"
                    )
                )
            } else {
                cont.resume(NimResult(0, data = message.toMap()))
            }
        }
    }

    private suspend fun createVideoMessage(arguments: Map<String, *>): NimResult<Map<String, Any?>?> {
        return suspendCancellableCoroutine { cont ->
            val videoPath = arguments["videoPath"] as? String
            val name = arguments["name"] as? String
            val sceneName = arguments["sceneName"] as? String
            val duration = arguments["duration"] as? Int ?: 0
            val height = arguments["height"] as? Int
            val width = arguments["width"] as? Int
            val message: V2NIMMessage? = V2NIMMessageCreator.createVideoMessage(
                videoPath,
                name,
                sceneName,
                duration,
                width,
                height
            )
            if (message == null) {
                cont.resume(
                    NimResult(
                        code = createMessageFailed,
                        errorDetails = "create Message failed"
                    )
                )
            } else {
                cont.resume(NimResult(0, data = message.toMap()))
            }
        }
    }

    private suspend fun createFileMessage(arguments: Map<String, *>): NimResult<Map<String, Any?>?> {
        return suspendCancellableCoroutine { cont ->
            val filePath = arguments["filePath"] as? String
            val name = arguments["name"] as? String
            val sceneName = arguments["sceneName"] as? String
            val message: V2NIMMessage? = V2NIMMessageCreator.createFileMessage(filePath, name, sceneName)
            if (message == null) {
                cont.resume(
                    NimResult(
                        code = createMessageFailed,
                        errorDetails = "create Message failed"
                    )
                )
            } else {
                cont.resume(NimResult(0, data = message.toMap()))
            }
        }
    }

    private suspend fun createLocationMessage(arguments: Map<String, *>): NimResult<Map<String, Any?>?> {
        return suspendCancellableCoroutine { cont ->
            val latitude = arguments["latitude"] as? Double ?: 0.0
            val longitude = arguments["longitude"] as? Double ?: 0.0
            val address = arguments["address"] as? String
            val message: V2NIMMessage? = V2NIMMessageCreator.createLocationMessage(latitude, longitude, address)
            if (message == null) {
                cont.resume(
                    NimResult(
                        code = createMessageFailed,
                        errorDetails = "create Message failed"
                    )
                )
            } else {
                cont.resume(NimResult(0, data = message.toMap()))
            }
        }
    }

    private suspend fun createCustomMessage(arguments: Map<String, *>): NimResult<Map<String, Any?>?> {
        return suspendCancellableCoroutine { cont ->
            val text = arguments["text"] as? String
            val rawAttachment = arguments["rawAttachment"] as? String
            val message: V2NIMMessage? = V2NIMMessageCreator.createCustomMessage(text, rawAttachment)
            if (message == null) {
                cont.resume(
                    NimResult(
                        code = createMessageFailed,
                        errorDetails = "create Message failed"
                    )
                )
            } else {
                cont.resume(NimResult(0, data = message.toMap()))
            }
        }
    }

    private suspend fun createTipsMessage(arguments: Map<String, *>): NimResult<Map<String, Any?>?> {
        return suspendCancellableCoroutine { cont ->
            val text = arguments["text"] as? String
            val message: V2NIMMessage? = V2NIMMessageCreator.createTipsMessage(text)
            if (message == null) {
                cont.resume(
                    NimResult(
                        code = createMessageFailed,
                        errorDetails = "create Message failed"
                    )
                )
            } else {
                cont.resume(NimResult(0, data = message.toMap()))
            }
        }
    }

    private suspend fun createCallMessage(arguments: Map<String, *>): NimResult<Map<String, Any?>?> {
        return suspendCancellableCoroutine { cont ->
            val type = arguments["type"] as? Int ?: 0
            val channelId = arguments["channelId"] as? String
            val status = arguments["status"] as? Int ?: 0
            val text = arguments["text"] as? String
            val durationMap = arguments["durations"] as? List<Map<String, *>>
            val durations = mutableListOf<V2NIMMessageCallDuration>()
            if (durationMap?.isNotEmpty() == true) {
                durationMap.forEach {
                    val accountId = it["accountId"] as? String
                    val duration = it["duration"] as? Int ?: 0
                    durations.add(V2NIMMessageCallDuration(accountId, duration))
                }
            }
            val message: V2NIMMessage? = V2NIMMessageCreator.createCallMessage(
                type,
                channelId,
                status,
                durations,
                text
            )
            if (message == null) {
                cont.resume(
                    NimResult(
                        code = createMessageFailed,
                        errorDetails = "create Message failed"
                    )
                )
            } else {
                cont.resume(NimResult(0, data = message.toMap()))
            }
        }
    }

    private suspend fun createForwardMessage(arguments: Map<String, *>): NimResult<Map<String, Any?>?> {
        return suspendCancellableCoroutine { cont ->
            val messageMap = arguments["message"] as Map<String, *>?
            val message = messageMap?.toMessage()
            val messageResult: V2NIMMessage? = V2NIMMessageCreator.createForwardMessage(message)
            if (messageResult == null) {
                cont.resume(
                    NimResult(
                        code = createMessageFailed,
                        errorDetails = "create Message failed"
                    )
                )
            } else {
                cont.resume(NimResult(0, data = messageResult.toMap()))
            }
        }
    }
}
