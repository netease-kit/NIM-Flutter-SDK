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
import com.netease.nimflutter.extension.toMap
import com.netease.nimflutter.extension.toV2NIMChatroomMessage
import com.netease.nimflutter.toMap
import com.netease.nimlib.sdk.v2.chatroom.V2NIMChatroomMessageCreator
import com.netease.nimlib.sdk.v2.chatroom.model.V2NIMChatroomMessage
import com.netease.nimlib.sdk.v2.message.V2NIMMessageAttachmentCreator
import com.netease.nimlib.sdk.v2.message.attachment.V2NIMMessageCustomAttachment
import kotlin.coroutines.resume
import kotlinx.coroutines.suspendCancellableCoroutine

class FLTChatroomMessageCreatorService(
    applicationContext: Context,
    nimCore: NimCore
) : FLTService(applicationContext, nimCore) {
    override val serviceName: String = "V2NIMChatroomMessageCreator"

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
                "createCustomMessageWithAttachment" to this::createCustomMessageWithAttachment,
                "createCustomMessageWithAttachmentAndSubType" to this::createCustomMessageWithAttachmentAndSubType,
                "createForwardMessage" to this::createForwardMessage
            )
        }
    }

    private suspend fun createTextMessage(arguments: Map<String, *>): NimResult<Map<String, Any?>?> {
        return suspendCancellableCoroutine { cont ->
            val text = arguments["text"] as? String
            val message: V2NIMChatroomMessage? = V2NIMChatroomMessageCreator.createTextMessage(text)
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
            val message: V2NIMChatroomMessage? = V2NIMChatroomMessageCreator.createImageMessage(
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
            val message: V2NIMChatroomMessage? = V2NIMChatroomMessageCreator.createAudioMessage(
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
            val message: V2NIMChatroomMessage? = V2NIMChatroomMessageCreator.createVideoMessage(
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
            val message: V2NIMChatroomMessage? = V2NIMChatroomMessageCreator.createFileMessage(filePath, name, sceneName)
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
            val message: V2NIMChatroomMessage? = V2NIMChatroomMessageCreator.createLocationMessage(latitude, longitude, address)
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
            val rawAttachment = arguments["rawAttachment"] as? String
            val message: V2NIMChatroomMessage? = V2NIMChatroomMessageCreator.createCustomMessage(rawAttachment)
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

    private suspend fun createCustomMessageWithAttachment(arguments: Map<String, *>): NimResult<Map<String, Any?>?> {
        return suspendCancellableCoroutine { cont ->
            val rawAttachment = arguments["rawAttachment"] as? String
            val attachment = V2NIMMessageAttachmentCreator.createCustomMessageAttachment(rawAttachment) as? V2NIMMessageCustomAttachment
            val message: V2NIMChatroomMessage? = V2NIMChatroomMessageCreator.createCustomMessageWithAttachment(attachment)
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

    private suspend fun createCustomMessageWithAttachmentAndSubType(arguments: Map<String, *>): NimResult<Map<String, Any?>?> {
        return suspendCancellableCoroutine { cont ->
            val rawAttachment = arguments["attachment"] as? String
            val subType = arguments["subType"] as? Int
            if (subType == null) {
                cont.resume(
                    NimResult(
                        code = createMessageFailed,
                        errorDetails = "create CustomMessageWithAttachmentAndType subtype is null"
                    )
                )
            } else {
                val attachment = V2NIMMessageAttachmentCreator.createCustomMessageAttachment(rawAttachment) as? V2NIMMessageCustomAttachment
                val message: V2NIMChatroomMessage? = V2NIMChatroomMessageCreator.createCustomMessageWithAttachment(attachment, subType)
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
    }

    private suspend fun createTipsMessage(arguments: Map<String, *>): NimResult<Map<String, Any?>?> {
        return suspendCancellableCoroutine { cont ->
            val text = arguments["text"] as? String
            val message: V2NIMChatroomMessage? = V2NIMChatroomMessageCreator.createTipsMessage(text)
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
            val message = messageMap?.toV2NIMChatroomMessage()
            val messageResult: V2NIMChatroomMessage? = V2NIMChatroomMessageCreator.createForwardMessage(message)
            if (messageResult == null) {
                cont.resume(NimResult(0, data = mapOf()))
            } else {
                cont.resume(NimResult(0, data = messageResult.toMap()))
            }
        }
    }
}
