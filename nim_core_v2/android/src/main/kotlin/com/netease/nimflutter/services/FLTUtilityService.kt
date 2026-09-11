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
import com.netease.nimlib.sdk.NIMClient
import com.netease.nimlib.sdk.v2.utility.V2NIMUtilityService
import com.netease.nimlib.sdk.v2.utility.option.V2NIMExportMessageOption
import com.netease.nimlib.sdk.v2.utility.option.V2NIMImportMessageOption
import kotlin.coroutines.resume
import kotlinx.coroutines.suspendCancellableCoroutine

/**
 * flutter 工具类服务（消息迁移）
 *
 * @constructor
 *
 * @param applicationContext
 * @param nimCore
 */
class FLTUtilityService(
    applicationContext: Context,
    nimCore: NimCore
) : FLTService(applicationContext, nimCore) {

    private val tag = "FLTUtilityService"

    override val serviceName = "UtilityService"

    init {
        nimCore.onInitialized {
            registerFlutterMethodCalls(
                "exportMessagesToPath" to ::exportMessagesToPath,
                "importMessagesFromPath" to ::importMessagesFromPath,
                "cancelMigrateMessages" to ::cancelMigrateMessages
            )
        }
    }

    private suspend fun exportMessagesToPath(arguments: Map<String, *>): NimResult<String> {
        val optionMap = arguments["option"] as? Map<String, *>
            ?: return NimResult(paramErrorCode, errorDetails = "option is required")
        val filePath = optionMap["path"] as? String
            ?: return NimResult(paramErrorCode, errorDetails = "option.filePath is required")
        val exportOption = V2NIMExportMessageOption(filePath)
        return suspendCancellableCoroutine { cont ->
            NIMClient.getService(V2NIMUtilityService::class.java).exportMessagesToPath(
                exportOption,
                { exportedPath ->
                    cont.resume(NimResult(0, data = exportedPath))
                },
                { error ->
                    cont.resume(NimResult(error.code, errorDetails = error.desc))
                },
                { progress ->
                    notifyEvent(
                        "onMessagesProgress",
                        mapOf(
                            "progress" to progress
                        )
                    )
                }
            )
        }
    }

    private suspend fun importMessagesFromPath(arguments: Map<String, *>): NimResult<Void> {
        val optionMap = arguments["option"] as? Map<String, *>
            ?: return NimResult(paramErrorCode, errorDetails = "option is required")
        val filePath = optionMap["path"] as? String
            ?: return NimResult(paramErrorCode, errorDetails = "option.filePath is required")
        val importOption = V2NIMImportMessageOption(filePath)
        return suspendCancellableCoroutine { cont ->
            NIMClient.getService(V2NIMUtilityService::class.java).importMessagesFromPath(
                importOption,
                {
                    cont.resume(NimResult(0, data = null))
                },
                { error ->
                    cont.resume(NimResult(error.code, errorDetails = error.desc))
                },
                { progress ->
                    notifyEvent(
                        "onMessagesProgress",
                        mapOf(
                            "progress" to progress
                        )
                    )
                }
            )
        }
    }

    private suspend fun cancelMigrateMessages(arguments: Map<String, *>): NimResult<Void> {
        NIMClient.getService(V2NIMUtilityService::class.java).cancelMigrateMessages()
        return NimResult(0, data = null)
    }
}
