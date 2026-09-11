/*
 * Copyright (c) 2022 NetEase, Inc. All rights reserved.
 * Use of this source code is governed by a MIT license that can be
 * found in the LICENSE file.
 */

package com.netease.nimflutter.extension

import com.netease.nimlib.sdk.v2.avsignalling.config.V2NIMSignallingPushConfig
import com.netease.nimlib.sdk.v2.avsignalling.model.V2NIMSignallingChannelInfo
import com.netease.nimlib.sdk.v2.avsignalling.model.V2NIMSignallingEvent
import com.netease.nimlib.sdk.v2.avsignalling.model.V2NIMSignallingMember
import com.netease.nimlib.sdk.v2.avsignalling.model.V2NIMSignallingRoomInfo
import com.netease.nimlib.sdk.v2.avsignalling.model.V2NIMSignallingRtcInfo
import com.netease.nimlib.sdk.v2.avsignalling.result.V2NIMSignallingCallResult
import com.netease.nimlib.sdk.v2.avsignalling.result.V2NIMSignallingCallSetupResult
import com.netease.nimlib.sdk.v2.avsignalling.result.V2NIMSignallingJoinResult

fun V2NIMSignallingChannelInfo.toMap(): Map<String, Any?> {
    return mapOf(
        "channelName" to this.channelName,
        "channelId" to this.channelId,
        "channelType" to this.channelType?.value,
        "createTime" to this.createTime,
        "expireTime" to this.expireTime,
        "channelExtension" to this.channelExtension,
        "creatorAccountId" to this.creatorAccountId
    )
}
fun V2NIMSignallingMember.toMap(): Map<String, Any?> {
    return mapOf(
        "accountId" to this.accountId,
        "uid" to this.uid,
        "deviceId" to this.deviceId,
        "expireTime" to this.expireTime,
        "joinTime" to this.joinTime
    )
}

fun V2NIMSignallingRoomInfo.toMap(): Map<String, Any?> {
    return mapOf(
        "channelInfo" to this.channelInfo.toMap(),
        "members" to this.members.map {
            it.toMap()
        }
    )
}
fun V2NIMSignallingRtcInfo.toMap(): Map<String, Any?> {
    return mapOf(
        "rtcParams" to this.rtcParams,
        "rtcToken" to this.rtcToken,
        "rtcTokenTtl" to this.rtcTokenTtl
    )
}

fun V2NIMSignallingCallResult.toMap(): Map<String, Any?> {
    return mapOf(
        "rtcInfo" to this.rtcInfo.toMap(),
        "roomInfo" to this.roomInfo.toMap(),
        "callStatus" to this.callStatus
    )
}

fun V2NIMSignallingCallSetupResult.toMap(): Map<String, Any?> {
    return mapOf(
        "rtcInfo" to this.rtcInfo.toMap(),
        "roomInfo" to this.roomInfo.toMap(),
        "callStatus" to this.callStatus
    )
}

fun V2NIMSignallingPushConfig.toMap(): Map<String, Any?> {
    return mapOf(
        "pushEnabled" to this.isPushEnabled,
        "pushTitle" to this.pushTitle,
        "pushContent" to this.pushContent,
        "pushPayload" to this.pushPayload
    )
}

fun V2NIMSignallingEvent.toMap(): Map<String, Any?> {
    return mapOf(
        "eventType" to this.eventType.value,
        "channelInfo" to this.channelInfo?.toMap(),
        "operatorAccountId" to this.operatorAccountId,
        "serverExtension" to this.serverExtension,
        "time" to this.time,
        "inviteeAccountId" to this.inviteeAccountId,
        "inviterAccountId" to this.inviterAccountId,
        "requestId" to this.requestId,
        "pushConfig" to this.pushConfig?.toMap(),
        "unreadEnabled" to this.isUnreadEnabled,
        "member" to this.member?.toMap()
    )
}

fun V2NIMSignallingJoinResult.toMap(): Map<String, Any?> {
    return mapOf(
        "roomInfo" to roomInfo.toMap(),
        "rtcInfo" to rtcInfo.toMap()
    )
}
