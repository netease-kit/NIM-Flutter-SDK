/*
 * Copyright (c) 2022 NetEase, Inc. All rights reserved.
 * Use of this source code is governed by a MIT license that can be
 * found in the LICENSE file.
 */

package com.netease.nimflutter.services

import android.content.Context
import com.netease.nimflutter.FLTConstant
import com.netease.nimflutter.FLTService
import com.netease.nimflutter.NimCore
import com.netease.nimflutter.NimResult
import com.netease.nimflutter.extension.toMap
import com.netease.nimlib.sdk.NIMClient
import com.netease.nimlib.sdk.v2.avsignalling.V2NIMSignallingListener
import com.netease.nimlib.sdk.v2.avsignalling.V2NIMSignallingService
import com.netease.nimlib.sdk.v2.avsignalling.config.V2NIMSignallingConfig
import com.netease.nimlib.sdk.v2.avsignalling.config.V2NIMSignallingPushConfig
import com.netease.nimlib.sdk.v2.avsignalling.config.V2NIMSignallingRtcConfig
import com.netease.nimlib.sdk.v2.avsignalling.enums.V2NIMSignallingChannelType
import com.netease.nimlib.sdk.v2.avsignalling.model.V2NIMSignallingEvent
import com.netease.nimlib.sdk.v2.avsignalling.model.V2NIMSignallingRoomInfo
import com.netease.nimlib.sdk.v2.avsignalling.params.V2NIMSignallingAcceptInviteParams
import com.netease.nimlib.sdk.v2.avsignalling.params.V2NIMSignallingCallParams
import com.netease.nimlib.sdk.v2.avsignalling.params.V2NIMSignallingCallSetupParams
import com.netease.nimlib.sdk.v2.avsignalling.params.V2NIMSignallingCancelInviteParams
import com.netease.nimlib.sdk.v2.avsignalling.params.V2NIMSignallingInviteParams
import com.netease.nimlib.sdk.v2.avsignalling.params.V2NIMSignallingJoinParams
import com.netease.nimlib.sdk.v2.avsignalling.params.V2NIMSignallingRejectInviteParams
import com.netease.yunxin.kit.alog.ALog
import kotlin.coroutines.resume
import kotlinx.coroutines.suspendCancellableCoroutine

class FLTSignallingService(
    applicationContext: Context,
    nimCore: NimCore
) : FLTService(applicationContext, nimCore) {

    override val serviceName = "SignallingService"

    private val logTag = "FLTSignallingService"

    private val signallingService: V2NIMSignallingService by lazy {
        NIMClient.getService(V2NIMSignallingService::class.java)
    }

    init {
        nimCore.onInitialized {
            signallingService.addSignallingListener(signallingListener)
            registerFlutterMethodCalls(
                "call" to ::call,
                "callSetup" to ::callSetup,
                "createRoom" to ::createRoom,
                "closeRoom" to ::closeRoom,
                "joinRoom" to ::joinRoom,
                "leaveRoom" to ::leaveRoom,
                "invite" to ::invite,
                "cancelInvite" to ::cancelInvite,
                "rejectInvite" to ::rejectInvite,
                "acceptInvite" to ::acceptInvite,
                "sendControl" to ::sendControl,
                "getRoomInfoByChannelName" to ::getRoomInfoByChannelName
            )
        }
    }

    private suspend fun call(arguments: Map<String, *>): NimResult<Map<String, Any?>?> {
        return suspendCancellableCoroutine { cont ->
            val paramsMap = arguments["params"] as? Map<String, Any?>
            if (paramsMap == null) {
                cont.resume(
                    NimResult(
                        code = FLTConstant.paramErrorCode,
                        errorDetails = "params is null"
                    )
                )
            } else {
                val channelType =
                    if (paramsMap["channelType"] as? Int == null) 0 else paramsMap["channelType"] as Int
                val calleeAccountId = paramsMap["calleeAccountId"] as? String
                val requestId = paramsMap["requestId"] as? String
                val channelName = paramsMap["channelName"] as? String
                val channelExtension = paramsMap["channelExtension"] as? String
                val serverExtension = paramsMap["serverExtension"] as? String

                val callParams = V2NIMSignallingCallParams(calleeAccountId, requestId, V2NIMSignallingChannelType.typeOfValue(channelType))

                if (channelName != null) {
                    callParams.channelName = channelName
                }
                if (channelExtension != null) {
                    callParams.channelExtension = channelExtension
                }
                if (serverExtension != null) {
                    callParams.serverExtension = serverExtension
                }

                if (paramsMap.containsKey("signallingConfig")) {
                    val signallingConfig = paramsMap["signallingConfig"] as? Map<String, Any?>
                    if (signallingConfig != null) {
                        callParams.signallingConfig = v2NIMSignallingConfigFromMap(signallingConfig)
                    }
                }

                if (paramsMap.containsKey("pushConfig")) {
                    val pushConfig = paramsMap["pushConfig"] as? Map<String, Any?>
                    if (pushConfig != null) {
                        callParams.pushConfig = v2NIMSignallingPushConfigFromMap(pushConfig)
                    }
                }

                if (paramsMap.containsKey("rtcConfig")) {
                    val rtcConfig = paramsMap["rtcConfig"] as? Map<String, Any?>
                    if (rtcConfig != null) {
                        callParams.rtcConfig = v2NIMSignallingRtcConfigFromMap(rtcConfig)
                    }
                }

                signallingService.call(
                    callParams,
                    { result ->
                        cont.resume(
                            NimResult(
                                code = 0,
                                data = result.toMap()
                            )
                        )
                    },
                    { error ->
                        cont.resume(
                            if (error != null) {
                                NimResult(code = error.code, errorDetails = error.desc)
                            } else {
                                NimResult(
                                    code = -1,
                                    errorDetails = "call failed!"
                                )
                            }
                        )
                    }
                )
            }
        }
    }

    private suspend fun callSetup(arguments: Map<String, *>): NimResult<Map<String, Any?>?> {
        return suspendCancellableCoroutine { cont ->
            val paramsMap = arguments["params"] as? Map<String, Any?>
            if (paramsMap == null) {
                cont.resume(
                    NimResult(
                        code = FLTConstant.paramErrorCode,
                        errorDetails = "params is null"
                    )
                )
            } else {
                val channelId = paramsMap["channelId"] as? String
                val callerAccountId = paramsMap["callerAccountId"] as? String
                val requestId = paramsMap["requestId"] as? String
                val serverExtension = paramsMap["serverExtension"] as? String

                val callParams = V2NIMSignallingCallSetupParams(channelId, callerAccountId, requestId)

                if (serverExtension != null) {
                    callParams.serverExtension = serverExtension
                }

                if (paramsMap.containsKey("signallingConfig")) {
                    val signallingConfig = paramsMap["signallingConfig"] as? Map<String, Any?>
                    if (signallingConfig != null) {
                        callParams.signallingConfig = v2NIMSignallingConfigFromMap(signallingConfig)
                    }
                }

                if (paramsMap.containsKey("rtcConfig")) {
                    val rtcConfig = paramsMap["rtcConfig"] as? Map<String, Any?>
                    if (rtcConfig != null) {
                        callParams.rtcConfig = v2NIMSignallingRtcConfigFromMap(rtcConfig)
                    }
                }
                signallingService.callSetup(
                    callParams,
                    { result ->
                        cont.resume(
                            NimResult(
                                code = 0,
                                data = result.toMap()
                            )
                        )
                    },
                    { error ->
                        cont.resume(
                            if (error != null) {
                                NimResult(code = error.code, errorDetails = error.desc)
                            } else {
                                NimResult(
                                    code = -1,
                                    errorDetails = "publishCustomUserStatus failed!"
                                )
                            }
                        )
                    }
                )
            }
        }
    }

    private suspend fun createRoom(arguments: Map<String, *>): NimResult<Map<String, Any?>?> {
        return suspendCancellableCoroutine { cont ->

            val channelType =
                if (arguments["channelType"] as? Int == null) 0 else arguments["channelType"] as Int
            val channelName = arguments["channelName"] as? String
            val channelExtension = arguments["channelExtension"] as? String
            signallingService.createRoom(
                V2NIMSignallingChannelType.typeOfValue(channelType),
                channelName,
                channelExtension,
                { result ->
                    cont.resume(
                        NimResult(
                            code = 0,
                            data = result.toMap()
                        )
                    )
                },
                { error ->
                    cont.resume(
                        if (error != null) {
                            NimResult(code = error.code, errorDetails = error.desc)
                        } else {
                            NimResult(
                                code = -1,
                                errorDetails = "createRoom failed!"
                            )
                        }
                    )
                }
            )
        }
    }

    private suspend fun closeRoom(arguments: Map<String, *>): NimResult<Nothing> {
        return suspendCancellableCoroutine { cont ->
            val channelId = arguments["channelId"] as String
            val offlineEnabled = if (arguments["offlineEnabled"] as? Boolean == null) false else arguments["offlineEnabled"] as Boolean
            val serverExtension = arguments["serverExtension"] as? String
            signallingService.closeRoom(
                channelId,
                offlineEnabled,
                serverExtension,
                {
                    cont.resume(NimResult.SUCCESS)
                },
                { error ->
                    cont.resume(
                        if (error != null) {
                            NimResult(code = error.code, errorDetails = error.desc)
                        } else {
                            NimResult(
                                code = -1,
                                errorDetails = "closeRoom failed!"
                            )
                        }
                    )
                }
            )
        }
    }

    private suspend fun joinRoom(arguments: Map<String, *>): NimResult<Map<String, Any?>?> {
        return suspendCancellableCoroutine { cont ->
            val paramsMap = arguments["params"] as? Map<String, Any?>
            if (paramsMap == null) {
                cont.resume(
                    NimResult(
                        code = FLTConstant.paramErrorCode,
                        errorDetails = "params is null"
                    )
                )
            } else {
                val channelId = paramsMap["channelId"] as? String
                val serverExtension = paramsMap["serverExtension"] as? String

                val callParams = V2NIMSignallingJoinParams(channelId)

                if (serverExtension != null) {
                    callParams.serverExtension = serverExtension
                }

                if (paramsMap.containsKey("signallingConfig")) {
                    val signallingConfig = paramsMap["signallingConfig"] as? Map<String, Any?>
                    if (signallingConfig != null) {
                        callParams.signallingConfig = v2NIMSignallingConfigFromMap(signallingConfig)
                    }
                }

                if (paramsMap.containsKey("rtcConfig")) {
                    val rtcConfig = paramsMap["rtcConfig"] as? Map<String, Any?>
                    if (rtcConfig != null) {
                        callParams.rtcConfig = v2NIMSignallingRtcConfigFromMap(rtcConfig)
                    }
                }
                signallingService.joinRoom(
                    callParams,
                    { result ->
                        cont.resume(
                            NimResult(
                                code = 0,
                                data = result.toMap()
                            )
                        )
                    },
                    { error ->
                        cont.resume(
                            if (error != null) {
                                NimResult(code = error.code, errorDetails = error.desc)
                            } else {
                                NimResult(
                                    code = -1,
                                    errorDetails = "createRoom failed!"
                                )
                            }
                        )
                    }
                )
            }
        }
    }

    private suspend fun leaveRoom(arguments: Map<String, *>): NimResult<Nothing> {
        return suspendCancellableCoroutine { cont ->
            val channelId = arguments["channelId"] as String
            val serverExtension = arguments["serverExtension"] as? String
            val offlineEnabled = if (arguments["offlineEnabled"] as? Boolean == null) false else arguments["offlineEnabled"] as Boolean
            signallingService.leaveRoom(
                channelId,
                offlineEnabled,
                serverExtension,
                {
                    cont.resume(NimResult.SUCCESS)
                },
                { error ->
                    cont.resume(
                        if (error != null) {
                            NimResult(code = error.code, errorDetails = error.desc)
                        } else {
                            NimResult(
                                code = -1,
                                errorDetails = "closeRoom failed!"
                            )
                        }
                    )
                }
            )
        }
    }

    private suspend fun invite(arguments: Map<String, *>): NimResult<Nothing> {
        return suspendCancellableCoroutine { cont ->
            val paramsMap = arguments["params"] as? Map<String, Any?>
            if (paramsMap == null) {
                cont.resume(
                    NimResult(
                        code = FLTConstant.paramErrorCode,
                        errorDetails = "params is null"
                    )
                )
            } else {
                val channelId = paramsMap["channelId"] as? String
                val requestId = paramsMap["requestId"] as? String
                val serverExtension = paramsMap["serverExtension"] as? String
                val inviteeAccountId = paramsMap["inviteeAccountId"] as? String

                val callParams = V2NIMSignallingInviteParams(channelId, inviteeAccountId, requestId)

                if (serverExtension != null) {
                    callParams.serverExtension = serverExtension
                }

                if (paramsMap.containsKey("signallingConfig")) {
                    val signallingConfig = paramsMap["signallingConfig"] as? Map<String, Any?>
                    if (signallingConfig != null) {
                        callParams.signallingConfig = v2NIMSignallingConfigFromMap(signallingConfig)
                    }
                }

                if (paramsMap.containsKey("pushConfig")) {
                    val pushConfig = paramsMap["pushConfig"] as? Map<String, Any?>
                    if (pushConfig != null) {
                        callParams.pushConfig = v2NIMSignallingPushConfigFromMap(pushConfig)
                    }
                }
                signallingService.invite(
                    callParams,
                    {
                        cont.resume(NimResult.SUCCESS)
                    },
                    { error ->
                        cont.resume(
                            if (error != null) {
                                NimResult(code = error.code, errorDetails = error.desc)
                            } else {
                                NimResult(
                                    code = -1,
                                    errorDetails = "closeRoom failed!"
                                )
                            }
                        )
                    }
                )
            }
        }
    }

    private suspend fun cancelInvite(arguments: Map<String, *>): NimResult<Nothing> {
        return suspendCancellableCoroutine { cont ->
            val paramsMap = arguments["params"] as? Map<String, Any?>
            if (paramsMap == null) {
                cont.resume(
                    NimResult(
                        code = FLTConstant.paramErrorCode,
                        errorDetails = "params is null"
                    )
                )
            } else {
                val channelId = paramsMap["channelId"] as String
                val inviteeAccountId = paramsMap["inviteeAccountId"] as String
                val offlineEnabled = paramsMap["offlineEnabled"] as? Boolean
                val serverExtension = paramsMap["serverExtension"] as? String
                val requestId = paramsMap["requestId"] as String
                val inviteParam = V2NIMSignallingCancelInviteParams(channelId, inviteeAccountId, requestId)
                if (offlineEnabled != null) {
                    inviteParam.isOfflineEnabled = offlineEnabled
                }

                if (serverExtension != null) {
                    inviteParam.serverExtension = serverExtension
                }

                signallingService.cancelInvite(
                    inviteParam,
                    {
                        cont.resume(NimResult.SUCCESS)
                    },
                    { error ->
                        cont.resume(
                            if (error != null) {
                                NimResult(code = error.code, errorDetails = error.desc)
                            } else {
                                NimResult(
                                    code = -1,
                                    errorDetails = "closeRoom failed!"
                                )
                            }
                        )
                    }
                )
            }
        }
    }

    private suspend fun rejectInvite(arguments: Map<String, *>): NimResult<Nothing> {
        return suspendCancellableCoroutine { cont ->
            val paramsMap = arguments["params"] as? Map<String, Any?>
            if (paramsMap == null) {
                cont.resume(
                    NimResult(
                        code = FLTConstant.paramErrorCode,
                        errorDetails = "params is null"
                    )
                )
            } else {
                val channelId = paramsMap["channelId"] as String
                val inviterAccountId = paramsMap["inviterAccountId"] as String
                val offlineEnabled = paramsMap["offlineEnabled"] as? Boolean
                val serverExtension = paramsMap["serverExtension"] as? String
                val requestId = paramsMap["requestId"] as String
                val rejectInviteParams = V2NIMSignallingRejectInviteParams(channelId, inviterAccountId, requestId)
                if (offlineEnabled != null) {
                    rejectInviteParams.isOfflineEnabled = offlineEnabled
                }
                if (serverExtension != null) {
                    rejectInviteParams.serverExtension = serverExtension
                }
                signallingService.rejectInvite(
                    rejectInviteParams,
                    {
                        cont.resume(NimResult.SUCCESS)
                    },
                    { error ->
                        cont.resume(
                            if (error != null) {
                                NimResult(code = error.code, errorDetails = error.desc)
                            } else {
                                NimResult(
                                    code = -1,
                                    errorDetails = "rejectInvite failed!"
                                )
                            }
                        )
                    }
                )
            }
        }
    }

    private suspend fun acceptInvite(arguments: Map<String, *>): NimResult<Nothing> {
        return suspendCancellableCoroutine { cont ->
            val paramsMap = arguments["params"] as? Map<String, Any?>
            if (paramsMap == null) {
                cont.resume(
                    NimResult(
                        code = FLTConstant.paramErrorCode,
                        errorDetails = "params is null"
                    )
                )
            } else {
                val channelId = paramsMap["channelId"] as String
                val inviterAccountId = paramsMap["inviterAccountId"] as String
                val offlineEnabled = paramsMap["offlineEnabled"] as? Boolean
                val serverExtension = paramsMap["serverExtension"] as? String
                val requestId = paramsMap["requestId"] as String
                val acceptInviteParams = V2NIMSignallingAcceptInviteParams(channelId, inviterAccountId, requestId)
                if (offlineEnabled != null) {
                    acceptInviteParams.isOfflineEnabled = offlineEnabled
                }
                if (serverExtension != null) {
                    acceptInviteParams.serverExtension = serverExtension
                }
                signallingService.acceptInvite(
                    acceptInviteParams,
                    {
                        cont.resume(NimResult.SUCCESS)
                    },
                    { error ->
                        cont.resume(
                            if (error != null) {
                                NimResult(code = error.code, errorDetails = error.desc)
                            } else {
                                NimResult(
                                    code = -1,
                                    errorDetails = "acceptInvite failed!"
                                )
                            }
                        )
                    }
                )
            }
        }
    }

    private suspend fun sendControl(arguments: Map<String, *>): NimResult<Nothing> {
        return suspendCancellableCoroutine { cont ->
            val channelId = arguments["channelId"] as String
            val receiverAccountId = arguments["receiverAccountId"] as? String
            val serverExtension = arguments["serverExtension"] as? String
            signallingService.sendControl(channelId, receiverAccountId, serverExtension, {
                cont.resume(NimResult.SUCCESS)
            }, { error ->
                cont.resume(
                    if (error != null) {
                        NimResult(code = error.code, errorDetails = error.desc)
                    } else {
                        NimResult(
                            code = -1,
                            errorDetails = "sendControl failed!"
                        )
                    }
                )
            })
        }
    }

    private suspend fun getRoomInfoByChannelName(arguments: Map<String, *>): NimResult<Map<String, Any?>?> {
        return suspendCancellableCoroutine { cont ->
            val channelName = arguments["channelName"] as String
            signallingService.getRoomInfoByChannelName(
                channelName,
                { result ->
                    cont.resume(
                        NimResult(
                            code = 0,
                            data = result.toMap()
                        )
                    )
                },
                { error ->
                    cont.resume(
                        if (error != null) {
                            NimResult(code = error.code, errorDetails = error.desc)
                        } else {
                            NimResult(
                                code = -1,
                                errorDetails = "getRoomInfoByChannelName failed!"
                            )
                        }
                    )
                }
            )
        }
    }

    private val signallingListener = object : V2NIMSignallingListener {
        override fun onOnlineEvent(event: V2NIMSignallingEvent?) {
            ALog.i(
                "FLTSignallingService",
                "onOnlineEvent"
            )
            if (event != null) {
                notifyEvent(
                    "onOnlineEvent",
                    event.toMap()
                )
            } else {
                notifyEvent(
                    "onOnlineEvent",
                    mapOf()
                )
            }
        }

        override fun onOfflineEvent(events: MutableList<V2NIMSignallingEvent>?) {
            ALog.i(
                "FLTSignallingService",
                "onOfflineEvent"
            )
            notifyEvent(
                "onOfflineEvent",
                mutableMapOf(
                    "offlineEvents" to events?.map {
                        it.toMap()
                    }?.toList()
                )
            )
        }

        override fun onMultiClientEvent(event: V2NIMSignallingEvent?) {
            ALog.i(
                "FLTSignallingService",
                "onMultiClientEvent"
            )
            if (event != null) {
                notifyEvent(
                    "onMultiClientEvent",
                    event.toMap()
                )
            } else {
                notifyEvent(
                    "onMultiClientEvent",
                    mapOf()
                )
            }
        }

        override fun onSyncRoomInfoList(channelRooms: MutableList<V2NIMSignallingRoomInfo>?) {
            ALog.i(
                "FLTSignallingService",
                "onSyncRoomInfoList"
            )
            notifyEvent(
                "onSyncRoomInfoList",
                mutableMapOf(
                    "syncRoomInfoList" to channelRooms?.map {
                        it.toMap()
                    }?.toList()
                )
            )
        }
    }

    private fun v2NIMSignallingConfigFromMap(config: Map<String, Any?>): V2NIMSignallingConfig {
        val offlineEnabled =
            if (config["offlineEnabled"] as? Boolean == null) {
                true
            } else {
                config["offlineEnabled"] as Boolean
            }

        val unreadEnabled =
            if (config["unreadEnabled"] as? Boolean == null) {
                true
            } else {
                config["unreadEnabled"] as Boolean
            }

        val selfUid = (config.getOrElse("selfUid") { 0L } as Number).toLong()

        return V2NIMSignallingConfig(offlineEnabled, unreadEnabled, selfUid)
    }

    private fun v2NIMSignallingPushConfigFromMap(config: Map<String, Any?>): V2NIMSignallingPushConfig {
        val pushEnabled =
            if (config["pushEnabled"] as? Boolean == null) {
                true
            } else {
                config["pushEnabled"] as Boolean
            }
        val pushTitle = config["pushTitle"] as? String
        val pushContent = config["pushContent"] as? String
        val pushPayload = config["pushPayload"] as? String

        return V2NIMSignallingPushConfig(pushEnabled, pushTitle, pushContent, pushPayload)
    }

    private fun v2NIMSignallingRtcConfigFromMap(config: Map<String, Any?>): V2NIMSignallingRtcConfig {
        val rtcTokenTtl = (config.getOrElse("rtcTokenTtl") { 0L } as Number).toLong()
        val rtcChannelName = config["rtcChannelName"] as? String
        val rtcParams = config["rtcParams"] as? String
        return V2NIMSignallingRtcConfig(rtcChannelName, rtcTokenTtl, rtcParams)
    }
}
