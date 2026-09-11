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
import com.netease.nimlib.sdk.NIMClient
import com.netease.nimlib.sdk.v2.statistics.V2NIMStatisticsService
import com.netease.yunxin.kit.alog.ALog
import kotlin.coroutines.resume
import kotlinx.coroutines.suspendCancellableCoroutine

/**
 * flutter 统计信息组件
 *
 * @constructor
 *
 * @param applicationContext
 * @param nimCore
 */
class FLTStatisticsService(
    applicationContext: Context,
    nimCore: NimCore
) : FLTService(applicationContext, nimCore) {

    private val tag = "FLTStatisticsService"

    override val serviceName = "StatisticsService"

    init {
        nimCore.onInitialized {
            registerFlutterMethodCalls(
                "getDatabaseInfos" to ::getDatabaseInfos
            )
        }
    }

    private suspend fun getDatabaseInfos(arguments: Map<String, *>): NimResult<Map<String, Any?>?> {
        return suspendCancellableCoroutine { cont ->
            NIMClient.getService(V2NIMStatisticsService::class.java).getDatabaseInfos(
                { databaseInfoList ->
                    val result = databaseInfoList?.map { info ->
                        mapOf(
                            "path" to info.path,
                            "name" to info.name,
                            "size" to info.size
                        )
                    } ?: emptyList<Map<String, Any?>>()
                    ALog.i(tag, "getDatabaseInfos success, count=${result.size}")
                    cont.resume(
                        NimResult(
                            0,
                            data = mapOf("databaseInfoList" to result)
                        )
                    )
                },
                { error ->
                    ALog.e(tag, "getDatabaseInfos error: code=${error.code}, desc=${error.desc}")
                    cont.resume(NimResult(error.code, errorDetails = error.desc))
                }
            )
        }
    }
}
