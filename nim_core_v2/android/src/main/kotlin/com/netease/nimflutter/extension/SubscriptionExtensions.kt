/*
 * Copyright (c) 2022 NetEase, Inc. All rights reserved.
 * Use of this source code is governed by a MIT license that can be
 * found in the LICENSE file.
 */

package com.netease.nimflutter.extension

import com.netease.nimlib.sdk.v2.subscription.model.V2NIMUserStatus
import com.netease.nimlib.sdk.v2.subscription.result.V2NIMCustomUserStatusPublishResult
import com.netease.nimlib.sdk.v2.subscription.result.V2NIMUserStatusSubscribeResult

fun V2NIMUserStatus.toMap(): Map<String, Any?> {
    return mapOf(
        "accountId" to accountId,
        "statusType" to statusType,
        "clientType" to clientType.value,
        "publishTime" to publishTime,
        "uniqueId" to uniqueId,
        "extension" to extension,
        "serverExtension" to serverExtension
    )
}

fun V2NIMCustomUserStatusPublishResult.toMap(): Map<String, Any?> {
    return mapOf(
        "publishTime" to publishTime,
        "uniqueId" to uniqueId,
        "serverId" to serverId
    )
}

fun V2NIMUserStatusSubscribeResult.toMap(): Map<String, Any?> {
    return mapOf(
        "accountId" to accountId,
        "duration" to duration,
        "subscribeTime" to subscribeTime
    )
}
