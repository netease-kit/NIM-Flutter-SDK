/*
 * Copyright (c) 2022 NetEase, Inc. All rights reserved.
 * Use of this source code is governed by a MIT license that can be
 * found in the LICENSE file.
 */

package com.netease.nimflutter

import com.netease.nimlib.sdk.v2.V2NIMError
import com.netease.nimlib.sdk.v2.auth.enums.V2NIMDataSyncLevel
import com.netease.nimlib.sdk.v2.auth.enums.V2NIMLoginAuthType
import com.netease.nimlib.sdk.v2.auth.enums.V2NIMLoginClientType
import com.netease.nimlib.sdk.v2.auth.model.V2NIMDataSyncDetail
import com.netease.nimlib.sdk.v2.auth.model.V2NIMKickedOfflineDetail
import com.netease.nimlib.sdk.v2.auth.model.V2NIMLoginClient
import com.netease.nimlib.sdk.v2.auth.option.V2NIMLoginOption
import com.netease.nimlib.v2.builder.V2NIMLoginClientBuilder

fun V2NIMError.toMap(): Map<String, Any?> {
    return mapOf(
        "code" to this.code,
        "desc" to this.desc,
        "detail" to this.detail
    )
}

fun V2NIMKickedOfflineDetail.toMap(): Map<String, Any?> {
    return mapOf(
        "clientType" to this.clientType.value,
        "reason" to this.reason.value,
        "reasonDesc" to this.reasonDesc,
        "customClientType" to this.customClientType
    )
}

fun V2NIMLoginClient.toMap(): Map<String, Any?> {
    return mapOf(
        "type" to this.type.value,
        "clientId" to this.clientId,
        "os" to this.os,
        "customClientType" to this.customClientType,
        "customTag" to this.customTag,
        "timestamp" to this.timestamp
    )
}

fun Map<String, *>.toNIMLoginClient(): V2NIMLoginClient {
    return V2NIMLoginClientBuilder.builder().setClientId(
        this@toNIMLoginClient["clientId"] as? String ?: ""
    ).setCustomClientType(
        this@toNIMLoginClient["customClientType"] as? Int ?: -1
    ).setCustomTag(
        this@toNIMLoginClient["customTag"] as? String ?: ""
    ).setOs(
        this@toNIMLoginClient["os"] as? String ?: ""
    ).setTimestamp(
        this@toNIMLoginClient["timestamp"] as? Long ?: 0
    ).setType(
        V2NIMLoginClientType.typeOfValue(this@toNIMLoginClient["type"] as? Int ?: 0)
    ).build()
}

fun Map<String, *>.toLoginOptions(): V2NIMLoginOption {
    return V2NIMLoginOption().apply {
        this.retryCount = this@toLoginOptions["retryCount"] as? Int
        this.timeout = this@toLoginOptions["timeout"] as? Long
        this.forceMode = this@toLoginOptions["forceMode"] as? Boolean
        this.authType = V2NIMLoginAuthType.typeOfValue(this@toLoginOptions["authType"] as? Int ?: 0)
        this.syncLevel = V2NIMDataSyncLevel.typeOfValue(this@toLoginOptions["syncLevel"] as? Int ?: 0)
    }
}

fun V2NIMDataSyncDetail.toMap(): Map<String, Any?> {
    return mapOf(
        "type" to this.type.value,
        "state" to this.state.value
    )
}
