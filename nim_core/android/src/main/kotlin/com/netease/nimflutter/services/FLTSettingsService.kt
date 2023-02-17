/*
 * Copyright (c) 2022 NetEase, Inc. All rights reserved.
 * Use of this source code is governed by a MIT license that can be
 * found in the LICENSE file.
 */

package com.netease.nimflutter.services

import android.content.Context
import com.netease.nimflutter.EnumTypeMappingRegistry
import com.netease.nimflutter.FLTService
import com.netease.nimflutter.NimCore
import com.netease.nimflutter.NimResult
import com.netease.nimflutter.NimResultContinuationCallback
import com.netease.nimflutter.NimResultContinuationCallbackOfNothing
import com.netease.nimflutter.convertToStatusBarNotificationConfig
import com.netease.nimlib.sdk.NIMClient
import com.netease.nimlib.sdk.misc.DirCacheFileType
import com.netease.nimlib.sdk.misc.MiscService
import com.netease.nimlib.sdk.mixpush.MixPushService
import com.netease.nimlib.sdk.settings.SettingsService
import com.netease.nimlib.sdk.settings.model.NoDisturbConfig
import kotlinx.coroutines.suspendCancellableCoroutine

class FLTSettingsService(
    applicationContext: Context,
    nimCore: NimCore
) : FLTService(applicationContext, nimCore) {

    override val serviceName = "SettingsService"

    init {
        registerFlutterMethodCalls(
            "enableMobilePushWhenPCOnline" to ::enableMobilePushWhenPCOnline,
            "isMobilePushEnabledWhenPCOnline" to ::isMobilePushEnabledWhenPCOnline,
            "enableNotification" to ::enableNotification,
            "enablePushService" to ::enablePushService,
            "isPushServiceEnabled" to ::isPushServiceEnabled,
            "getPushNoDisturbConfig" to ::getPushNoDisturbConfig,
            "setPushNoDisturbConfig" to ::setPushNoDisturbConfig,
            "isPushShowDetailEnabled" to ::isPushShowDetailEnabled,
            "enablePushShowDetail" to ::enablePushShowDetail,
            "updateNotificationConfig" to ::updateNotificationConfig,
            "archiveLogs" to ::archiveLogs,
            "uploadLogs" to ::uploadLogs,
            "getSizeOfDirCache" to ::getSizeOfDirCache,
            "clearDirCache" to ::clearDirCache
        )
    }

    private suspend fun enableMobilePushWhenPCOnline(arguments: Map<String, *>): NimResult<Nothing> {
        return suspendCancellableCoroutine { cont ->
            val enable: Boolean by arguments
            NIMClient.getService(SettingsService::class.java)
                .updateMultiportPushConfig(enable.not())
                .setCallback(NimResultContinuationCallbackOfNothing(cont))
        }
    }

    private suspend fun isMobilePushEnabledWhenPCOnline(arguments: Map<String, *>): NimResult<Boolean> {
        val enabled = NIMClient.getService(SettingsService::class.java).isMultiportPushOpen
        return NimResult(
            code = 0,
            data = enabled.not()
        )
    }

    private suspend fun enableNotification(arguments: Map<String, *>): NimResult<Nothing> {
        val enableRegularNotification: Boolean by arguments
        val enableRevokeMessageNotification: Boolean by arguments
        NIMClient.toggleNotification(enableRegularNotification)
        NIMClient.toggleRevokeMessageNotification(enableRevokeMessageNotification)
        return NimResult.SUCCESS
    }

    private suspend fun enablePushService(arguments: Map<String, *>): NimResult<Nothing> {
        return suspendCancellableCoroutine { cont ->
            val enable: Boolean by arguments
            NIMClient.getService(MixPushService::class.java)
                .enable(enable)
                .setCallback(NimResultContinuationCallbackOfNothing(cont))
        }
    }

    private suspend fun isPushServiceEnabled(arguments: Map<String, *>): NimResult<Boolean> {
        return NimResult(
            code = 0,
            data = NIMClient.getService(MixPushService::class.java).isEnable
        )
    }

    private suspend fun getPushNoDisturbConfig(arguments: Map<String, *>): NimResult<NoDisturbConfig> {
        return NimResult(
            code = 0,
            data = NIMClient.getService(MixPushService::class.java).pushNoDisturbConfig,
            convert = {
                mapOf(
                    "enable" to it.isOpen,
                    "startTime" to it.startTimeString,
                    "endTime" to it.stopTimeString
                )
            }
        )
    }

    private suspend fun setPushNoDisturbConfig(arguments: Map<String, *>): NimResult<Nothing> {
        return suspendCancellableCoroutine { cont ->
            val args = arguments.withDefault { null }
            val enable: Boolean by args
            val startTime: String? by args
            val endTime: String? by args
            NIMClient.getService(MixPushService::class.java).setPushNoDisturbConfig(
                enable,
                startTime,
                endTime
            ).setCallback(NimResultContinuationCallbackOfNothing(cont))
        }
    }

    private suspend fun enablePushShowDetail(arguments: Map<String, *>): NimResult<Nothing> {
        return suspendCancellableCoroutine { cont ->
            val enable: Boolean by arguments
            NIMClient.getService(MixPushService::class.java).setPushShowNoDetail(enable.not())
                .setCallback(NimResultContinuationCallbackOfNothing(cont))
        }
    }

    private suspend fun isPushShowDetailEnabled(arguments: Map<String, *>): NimResult<Boolean> {
        return NimResult(
            code = 0,
            data = NIMClient.getService(MixPushService::class.java).isPushShowNoDetail.not()
        )
    }

    private suspend fun updateNotificationConfig(arguments: Map<String, *>): NimResult<Nothing> {
        NIMClient.updateStatusBarNotificationConfig(convertToStatusBarNotificationConfig(arguments))
        return NimResult.SUCCESS
    }

    private suspend fun archiveLogs(arguments: Map<String, *>): NimResult<String> {
        return suspendCancellableCoroutine { cont ->
            NIMClient.getService(MiscService::class.java)
                .zipLogs()
                .setCallback(NimResultContinuationCallback(cont))
        }
    }

    private suspend fun uploadLogs(arguments: Map<String, *>): NimResult<String> {
        val args = arguments.withDefault { null }
        val partial: Boolean by args
        val chatroomId: String? by args
        val comment: String? by args
        return suspendCancellableCoroutine { cont ->
            NIMClient.getService(MiscService::class.java)
                .getSdkLogUpload(partial, chatroomId ?: "", comment ?: "")
                .setCallback(NimResultContinuationCallback(cont))
        }
    }

    private suspend fun getSizeOfDirCache(arguments: Map<String, *>): NimResult<Long> {
        val args = arguments.withDefault { null }
        val fileTypes: List<String> by args
        val dirCacheFileTypes =
            fileTypes.map {
                val dirCacheFileType: DirCacheFileType =
                    EnumTypeMappingRegistry.enumFromValue(it)
                dirCacheFileType
            }.toList()
        val startTime: Number by args
        val endTime: Number by args
        return suspendCancellableCoroutine { cont ->
            NIMClient.getService(MiscService::class.java)
                .getSizeOfDirCache(dirCacheFileTypes, startTime.toLong(), endTime.toLong())
                .setCallback(
                    NimResultContinuationCallback(cont) { size ->
                        NimResult(
                            code = 0,
                            data = size
                        )
                    }
                )
        }
    }

    private suspend fun clearDirCache(arguments: Map<String, *>): NimResult<Nothing> {
        val args = arguments.withDefault { null }
        val fileTypes: List<String> by args
        val dirCacheFileTypes =
            fileTypes.map {
                val dirCacheFileType: DirCacheFileType =
                    EnumTypeMappingRegistry.enumFromValue(it)
                dirCacheFileType
            }.toList()
        val startTime: Number by args
        val endTime: Number by args
        return suspendCancellableCoroutine { cont ->
            NIMClient.getService(MiscService::class.java)
                .clearDirCache(dirCacheFileTypes, startTime.toLong(), endTime.toLong())
                .setCallback(NimResultContinuationCallbackOfNothing(cont))
        }
    }
}
