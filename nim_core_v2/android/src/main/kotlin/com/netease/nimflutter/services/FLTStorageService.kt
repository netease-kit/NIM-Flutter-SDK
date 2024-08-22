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
import com.netease.nimflutter.convertV2NIMDownloadMessageAttachmentParams
import com.netease.nimflutter.convertV2NIMSize
import com.netease.nimflutter.convertV2NIMUploadFileParams
import com.netease.nimflutter.convertV2NIMUploadFileTask
import com.netease.nimflutter.toMap
import com.netease.nimflutter.toMessageAttachment
import com.netease.nimlib.sdk.NIMClient
import com.netease.nimlib.sdk.v2.storage.V2NIMStorageService
import com.netease.nimlib.sdk.v2.storage.V2NIMStorageUtil
import kotlin.coroutines.resume
import kotlinx.coroutines.suspendCancellableCoroutine

class FLTStorageService(
    applicationContext: Context,
    nimCore: NimCore
) : FLTService(applicationContext, nimCore) {
    private val storageService: V2NIMStorageService by lazy {
        NIMClient.getService(V2NIMStorageService::class.java)
    }

    override val serviceName = "StorageService"

    init {
        registerFlutterMethodCalls(
            "addCustomStorageScene" to ::addCustomStorageScene,
            "createUploadFileTask" to ::createUploadFileTask,
            "cancelUploadFile" to ::cancelUploadFile,
            "getStorageSceneList" to ::getStorageSceneList,
            "shortUrlToLong" to ::shortUrlToLong,
            "downloadFile" to ::downloadFile,
            "downloadAttachment" to ::downloadAttachment,
            "uploadFile" to ::uploadFile,
            "getImageThumbUrl" to ::getImageThumbUrl,
            "getVideoCoverUrl" to ::getVideoCoverUrl,
            "imageThumbUrl" to ::imageThumbUrl,
            "videoCoverUrl" to ::videoCoverUrl
        )
    }

    private suspend fun addCustomStorageScene(arguments: Map<String, *>): NimResult<Map<String, Any?>?> {
        return suspendCancellableCoroutine { cont ->
            val sceneName = arguments["sceneName"] as String?
            val expireTime = (arguments["expireTime"] as Number?)?.toLong()

            if (sceneName == null || expireTime == null) {
                cont.resume(
                    NimResult(
                        code = -1,
                        errorDetails = "addCustomStorageScene param is invalid"
                    )
                )
            } else {
                val storageScene =
                    storageService.addCustomStorageScene(
                        sceneName,
                        expireTime
                    )
                cont.resume(
                    NimResult(
                        code = 0,
                        data = storageScene.toMap()
                    )
                )
            }
        }
    }

    private suspend fun createUploadFileTask(arguments: Map<String, *>): NimResult<Map<String, Any?>?> {
        return suspendCancellableCoroutine { cont ->
            val fileParams = arguments["fileParams"] as Map<String, *>?

            if (fileParams == null) {
                cont.resume(
                    NimResult(
                        code = -1,
                        errorDetails = "createUploadFileTask param is invalid"
                    )
                )
            } else {
                val fileParams = convertV2NIMUploadFileParams(fileParams)
                val fileTask =
                    storageService.createUploadFileTask(fileParams)
                cont.resume(
                    NimResult(
                        code = 0,
                        data = fileTask?.toMap()
                    )
                )
            }
        }
    }

    private suspend fun cancelUploadFile(arguments: Map<String, *>): NimResult<Nothing> {
        return suspendCancellableCoroutine { cont ->
            val taskParams = arguments["fileTask"] as Map<String, *>?

            if (taskParams == null) {
                cont.resume(
                    NimResult(
                        code = -1,
                        errorDetails = "cancelUploadFile param is invalid"
                    )
                )
            } else {
                val task = convertV2NIMUploadFileTask(taskParams)
                storageService.cancelUploadFile(
                    task,
                    {
                        cont.resume(
                            NimResult.SUCCESS
                        )
                    },
                    { error ->
                        cont.resume(
                            if (error != null) {
                                NimResult(code = error.code, errorDetails = error.desc)
                            } else {
                                NimResult(code = -1, errorDetails = "cancelUploadFile failed!")
                            }
                        )
                    }
                )
            }
        }
    }

    private suspend fun getStorageSceneList(arguments: Map<String, *>): NimResult<Map<String, Any?>?> {
        return suspendCancellableCoroutine { cont ->
            val fileTask = storageService.storageSceneList
            cont.resume(
                NimResult(
                    code = 0,
                    data =
                    mapOf(
                        "sceneList" to fileTask.map { it?.toMap() }
                    )
                )
            )
        }
    }

    private suspend fun shortUrlToLong(arguments: Map<String, *>): NimResult<String> {
        return suspendCancellableCoroutine { cont ->
            val url = arguments["url"] as String?

            if (url == null) {
                cont.resume(
                    NimResult(
                        code = -1,
                        errorDetails = "shortUrlToLong param is invalid"
                    )
                )
            } else {
                storageService.shortUrlToLong(
                    url,
                    {
                        cont.resume(
                            NimResult(code = 0, data = it)
                        )
                    },
                    { error ->
                        cont.resume(
                            if (error != null) {
                                NimResult(code = error.code, errorDetails = error.desc)
                            } else {
                                NimResult(code = -1, errorDetails = "shortUrlToLong failed!")
                            }
                        )
                    }
                )
            }
        }
    }

    private suspend fun downloadFile(arguments: Map<String, *>): NimResult<String> {
        return suspendCancellableCoroutine { cont ->
            val url = arguments["url"] as String?
            val filePath = arguments["filePath"] as String?
            storageService.downloadFile(
                url,
                filePath,
                {
                    cont.resume(
                        NimResult(code = 0, data = it)
                    )
                },
                { error ->
                    cont.resume(
                        if (error != null) {
                            NimResult(code = error.code, errorDetails = error.desc)
                        } else {
                            NimResult(code = -1, errorDetails = "uploadFile failed!")
                        }
                    )
                },
                {
                    notifyEvent(
                        "onFileDownloadProgress",
                        mapOf(
                            "progress" to it,
                            "url" to url
                        )
                    )
                }
            )
        }
    }

    private suspend fun downloadAttachment(arguments: Map<String, *>): NimResult<String> {
        return suspendCancellableCoroutine { cont ->
            val downloadParam = arguments["downloadParam"] as Map<String, *>?
            val attachment = convertV2NIMDownloadMessageAttachmentParams(downloadParam!!)
            storageService.downloadAttachment(
                attachment,
                {
                    cont.resume(
                        NimResult(code = 0, data = it)
                    )
                },
                { error ->
                    cont.resume(
                        if (error != null) {
                            NimResult(code = error.code, errorDetails = error.desc)
                        } else {
                            NimResult(code = -1, errorDetails = "uploadFile failed!")
                        }
                    )
                },
                {
                    notifyEvent(
                        "onMessageAttachmentDownloadProgress",
                        mapOf(
                            "progress" to it,
                            "downloadParam" to downloadParam
                        )
                    )
                }
            )
        }
    }

    private suspend fun uploadFile(arguments: Map<String, *>): NimResult<String> {
        return suspendCancellableCoroutine { cont ->
            val taskParams = arguments["fileTask"] as Map<String, *>?

            if (taskParams == null) {
                cont.resume(
                    NimResult(
                        code = -1,
                        errorDetails = "uploadFile param is invalid"
                    )
                )
            } else {
                val task = convertV2NIMUploadFileTask(taskParams)
                storageService.uploadFile(
                    task,
                    {
                        cont.resume(
                            NimResult(code = 0, data = it)
                        )
                    },
                    { error ->
                        cont.resume(
                            if (error != null) {
                                NimResult(code = error.code, errorDetails = error.desc)
                            } else {
                                NimResult(code = -1, errorDetails = "uploadFile failed!")
                            }
                        )
                    },
                    {
                        notifyEvent(
                            "onFileUploadProgress",
                            mapOf(
                                "progress" to it,
                                "taskId" to task.taskId
                            )
                        )
                    }
                )
            }
        }
    }

    private suspend fun getImageThumbUrl(arguments: Map<String, *>): NimResult<Map<String, Any?>?> {
        return suspendCancellableCoroutine { cont ->
            val thumbSize = (arguments["thumbSize"] as Map<String, *>?)?.let { convertV2NIMSize(it) }
            val attachment = (arguments["attachment"] as Map<String, *>?)?.toMessageAttachment()
            storageService.getImageThumbUrl(
                attachment,
                thumbSize,
                {
                    cont.resume(
                        NimResult(code = 0, data = it.toMap())
                    )
                },
                { error ->
                    cont.resume(
                        if (error != null) {
                            NimResult(code = error.code, errorDetails = error.desc)
                        } else {
                            NimResult(code = -1, errorDetails = "shortUrlToLong failed!")
                        }
                    )
                }
            )
        }
    }

    private suspend fun getVideoCoverUrl(arguments: Map<String, *>): NimResult<Map<String, Any?>?> {
        return suspendCancellableCoroutine { cont ->
            val thumbSize = (arguments["thumbSize"] as Map<String, *>?)?.let { convertV2NIMSize(it) }
            val attachment = (arguments["attachment"] as Map<String, *>?)?.toMessageAttachment()
            storageService.getVideoCoverUrl(
                attachment,
                thumbSize,
                {
                    cont.resume(
                        NimResult(code = 0, data = it.toMap())
                    )
                },
                { error ->
                    cont.resume(
                        if (error != null) {
                            NimResult(code = error.code, errorDetails = error.desc)
                        } else {
                            NimResult(code = -1, errorDetails = "shortUrlToLong failed!")
                        }
                    )
                }
            )
        }
    }

    private suspend fun imageThumbUrl(arguments: Map<String, *>): NimResult<String> {
        val url = arguments["url"] as String?
        val thumbSize =
            if ((arguments["thumbSize"] as Int?) == null) {
                0
            } else {
                arguments["thumbSize"] as Int
            }
        if (url == null) {
            return NimResult(
                code = -1,
                errorDetails = "imageThumbUrl param is invalid"
            )
        } else {
            val result = V2NIMStorageUtil.imageThumbUrl(url, thumbSize)
            return NimResult(code = 0, data = result)
        }
    }

    private suspend fun videoCoverUrl(arguments: Map<String, *>): NimResult<String> {
        val url = arguments["url"] as String?
        val offset =
            if ((arguments["offset"] as Int?) == null) {
                0
            } else {
                arguments["offset"] as Int
            }
        if (url == null) {
            return NimResult(
                code = -1,
                errorDetails = "videoCoverUrl url  is invalid"
            )
        } else {
            val result = V2NIMStorageUtil.videoCoverUrl(url, offset)
            return NimResult(code = 0, data = result)
        }
    }
}
