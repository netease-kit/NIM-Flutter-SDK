/*
 * Copyright (c) 2022 NetEase, Inc. All rights reserved.
 * Use of this source code is governed by a MIT license that can be
 * found in the LICENSE file.
 */

package com.netease.nimflutter.extension

import com.netease.nimlib.sdk.v2.conversation.V2NIMConversationGroupResult
import com.netease.nimlib.sdk.v2.conversation.model.V2NIMConversationGroup
import com.netease.nimlib.sdk.v2.conversation.result.V2NIMConversationOperationResult

fun V2NIMConversationGroup.toMap(): Map<String, Any?> {
    return mapOf(
        "groupId" to groupId,
        "name" to name,
        "serverExtension" to serverExtension,
        "createTime" to createTime,
        "updateTime" to updateTime
    )
}

fun V2NIMConversationOperationResult.toMap(): Map<String, Any?> {
    return mapOf(
        "conversationId" to conversationId,
        "error" to error.toMap()
    )
}

fun V2NIMConversationGroupResult.toMap(): Map<String, Any?> {
    return mapOf(
        "group" to group.toMap(),
        "failedList" to failedList.map { it.toMap() }
    )
}
