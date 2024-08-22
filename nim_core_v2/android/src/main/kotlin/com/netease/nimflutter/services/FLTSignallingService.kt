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
import com.netease.nimflutter.stringToChannelTypeEnum
import com.netease.nimflutter.toMap
import com.netease.nimlib.sdk.NIMClient
import com.netease.nimlib.sdk.Observer
import com.netease.nimlib.sdk.avsignalling.SignallingService
import com.netease.nimlib.sdk.avsignalling.SignallingServiceObserver
import com.netease.nimlib.sdk.avsignalling.builder.CallParamBuilder
import com.netease.nimlib.sdk.avsignalling.builder.InviteParamBuilder
import com.netease.nimlib.sdk.avsignalling.event.ChannelCommonEvent
import com.netease.nimlib.sdk.avsignalling.event.InviteAckEvent
import com.netease.nimlib.sdk.avsignalling.event.MemberUpdateEvent
import com.netease.nimlib.sdk.avsignalling.event.SyncChannelListEvent
import com.netease.nimlib.sdk.avsignalling.model.ChannelBaseInfo
import com.netease.nimlib.sdk.avsignalling.model.ChannelFullInfo
import com.netease.nimlib.sdk.avsignalling.model.SignallingPushConfig
import kotlinx.coroutines.suspendCancellableCoroutine

class FLTSignallingService(
    applicationContext: Context,
    nimCore: NimCore
) : FLTService(applicationContext, nimCore) {

    override val serviceName = "AvSignallingService"

    private val logTag = "FLTSignallingService"

    private val signallingService: SignallingService by lazy {
        NIMClient.getService(SignallingService::class.java)
    }

    init {
        nimCore.onInitialized {
            NIMClient.getService(SignallingServiceObserver::class.java).apply {
                observeOnlineNotification(onlineMessageObserver, true)
                observeOfflineNotification(offlineMessageObserver, true)
                observeMemberUpdateNotification(memberUpdateObserver, true)
                observeOtherClientInviteAckNotification(otherClientInviteAckObserver, true)
                observeSyncChannelListNotification(syncChannelListObserver, true)
            }
            registerFlutterMethodCalls(
                "createChannel" to ::createChannel,
                "closeChannel" to ::closeChannel,
                "joinChannel" to ::joinChannel,
                "leaveChannel" to ::leaveChannel,
                "invite" to ::invite,
                "cancelInvite" to ::cancelInvite,
                "rejectInvite" to ::rejectInvite,
                "acceptInvite" to ::acceptInvite,
                "sendControl" to ::sendControl,
                "queryChannelInfo" to ::queryChannelInfo,
                "call" to ::call
            )
        }
    }

    private val onlineMessageObserver = Observer<ChannelCommonEvent> { event ->
        run {
            notifyEvent("onlineNotification", event.toMap() as MutableMap<String, Any?>)
        }
    }

    private val offlineMessageObserver = Observer<ArrayList<ChannelCommonEvent>> { event ->
        run {
            notifyEvent(
                "offlineNotification",
                mutableMapOf("eventList" to event.map { it.toMap() }.toList())
            )
        }
    }

    private val memberUpdateObserver = Observer<MemberUpdateEvent> { event ->
        run {
            notifyEvent(
                "onMemberUpdateNotification",
                event.toMap() as MutableMap<String, Any?>
            )
        }
    }

    private val otherClientInviteAckObserver = Observer<InviteAckEvent> { event ->
        run {
            notifyEvent(
                "otherClientInviteAckNotification",
                event.toMap() as MutableMap<String, Any?>
            )
        }
    }

    private val syncChannelListObserver = Observer<ArrayList<SyncChannelListEvent>> { event ->
        run {
            notifyEvent(
                "syncChannelListNotification",
                mutableMapOf(
                    "eventList" to event.map { it.toMap() }.toList()
                )
            )
        }
    }

    private suspend fun createChannel(arguments: Map<String, *>): NimResult<ChannelBaseInfo> {
        return suspendCancellableCoroutine { cont ->
            val type = stringToChannelTypeEnum(arguments["type"] as String)
            val channelName = arguments["channelName"] as String?
            val channelExt = arguments["channelExt"] as String?
            signallingService.create(type, channelName, channelExt).setCallback(
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

    private suspend fun closeChannel(arguments: Map<String, *>): NimResult<Nothing> {
        return suspendCancellableCoroutine { cont ->
            val channelId = arguments["channelId"] as String
            val customInfo = arguments["customInfo"] as String?
            val offlineEnabled = arguments["offlineEnabled"] as Boolean
            signallingService.close(channelId, offlineEnabled, customInfo).setCallback(
                NimResultContinuationCallbackOfNothing(cont)
            )
        }
    }

    private suspend fun joinChannel(arguments: Map<String, *>): NimResult<ChannelFullInfo> {
        return suspendCancellableCoroutine { cont ->
            val channelId = arguments["channelId"] as String
            val customInfo = arguments["customInfo"] as String?
            val offlineEnabled = arguments["offlineEnabled"] as Boolean
            val selfUid = (arguments["selfUid"] as Number?)?.toLong()
            signallingService.join(channelId, selfUid ?: 0, customInfo, offlineEnabled).setCallback(
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

    private suspend fun leaveChannel(arguments: Map<String, *>): NimResult<Nothing> {
        return suspendCancellableCoroutine { cont ->
            val channelId = arguments["channelId"] as String
            val customInfo = arguments["customInfo"] as String?
            val offlineEnabled = arguments["offlineEnabled"] as Boolean
            signallingService.leave(channelId, offlineEnabled, customInfo).setCallback(
                NimResultContinuationCallbackOfNothing(cont)
            )
        }
    }

    private suspend fun invite(arguments: Map<String, *>): NimResult<Nothing> {
        return suspendCancellableCoroutine { cont ->
            val inviteParam = getInviteParamFromMap(arguments)
            signallingService.invite(inviteParam).setCallback(
                NimResultContinuationCallbackOfNothing(cont)
            )
        }
    }

    private suspend fun cancelInvite(arguments: Map<String, *>): NimResult<Nothing> {
        return suspendCancellableCoroutine { cont ->
            val inviteParam = getInviteParamFromMap(arguments)
            signallingService.cancelInvite(inviteParam).setCallback(
                NimResultContinuationCallbackOfNothing(cont)
            )
        }
    }

    private suspend fun rejectInvite(arguments: Map<String, *>): NimResult<Nothing> {
        return suspendCancellableCoroutine { cont ->
            val inviteParam = getInviteParamFromMap(arguments)
            signallingService.rejectInvite(inviteParam).setCallback(
                NimResultContinuationCallbackOfNothing(cont)
            )
        }
    }

    private suspend fun acceptInvite(arguments: Map<String, *>): NimResult<Nothing> {
        return suspendCancellableCoroutine { cont ->
            val inviteParam = getInviteParamFromMap(arguments)
            signallingService.acceptInvite(inviteParam).setCallback(
                NimResultContinuationCallbackOfNothing(cont)
            )
        }
    }

    private suspend fun sendControl(arguments: Map<String, *>): NimResult<Nothing> {
        return suspendCancellableCoroutine { cont ->
            val channelId = arguments["channelId"] as String
            val accountId = arguments["accountId"] as String
            val customInfo = arguments["customInfo"] as String?
            signallingService.sendControl(channelId, accountId, customInfo).setCallback(
                NimResultContinuationCallbackOfNothing(cont)
            )
        }
    }

    private suspend fun call(arguments: Map<String, *>): NimResult<ChannelFullInfo> {
        return suspendCancellableCoroutine { cont ->
            val callParam = getCallParamFromMap(arguments)
            signallingService.call(callParam).setCallback(
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

    private suspend fun queryChannelInfo(arguments: Map<String, *>): NimResult<ChannelFullInfo> {
        return suspendCancellableCoroutine { cont ->
            val channelName = arguments["channelName"] as String
            signallingService.queryChannelFullInfo(channelName).setCallback(
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

    private fun getInviteParamFromMap(arguments: Map<String, *>): InviteParamBuilder {
        val inviteParam = InviteParamBuilder(
            arguments["channelId"] as String,
            arguments["accountId"] as String,
            arguments["requestId"] as String
        )
        inviteParam.customInfo(arguments["customInfo"] as String?)
        inviteParam.offlineEnabled((arguments["offlineEnabled"] as Boolean?) ?: false)
        val pushMap = arguments["pushConfig"] as Map<String, *>?
        if (pushMap != null) {
            val pushConfig = getPushConfigFromMap(pushMap)
            inviteParam.pushConfig(pushConfig)
        }
        return inviteParam
    }

    private fun getPushConfigFromMap(pushMap: Map<String, *>): SignallingPushConfig {
        return SignallingPushConfig(
            pushMap["needPush"] as Boolean,
            pushMap["pushTitle"] as String,
            pushMap["pushContent"] as String,
            pushMap["pushPayload"] as Map<String, *>?
        )
    }

    private fun getCallParamFromMap(arguments: Map<String, *>): CallParamBuilder {
        val callParam = CallParamBuilder(
            stringToChannelTypeEnum(arguments["channelType"] as String),
            arguments["accountId"] as String,
            arguments["requestId"] as String
        )
        callParam.channelName(arguments["channelName"] as String?)
        callParam.channelExt(arguments["channelExt"] as String?)
        val selfUid = (arguments["selfUid"] as Number?)?.toLong()
        if (selfUid != null) {
            callParam.selfUid(selfUid)
        }
        callParam.offlineEnabled((arguments["offlineEnable"] as Boolean?) ?: false)
        callParam.customInfo(arguments["customInfo"] as String?)
        val pushMap = arguments["pushConfig"] as Map<String, *>?
        if (pushMap != null) {
            val pushConfig = getPushConfigFromMap(pushMap)
            callParam.pushConfig(pushConfig)
        }
        return callParam
    }
}
