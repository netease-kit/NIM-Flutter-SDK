/*
 * Copyright (c) 2022 NetEase, Inc. All rights reserved.
 * Use of this source code is governed by a MIT license that can be
 * found in the LICENSE file.
 */

package com.netease.nimflutter

import com.netease.nimlib.sdk.v2.friend.V2NIMFriend
import com.netease.nimlib.sdk.v2.friend.V2NIMFriendAddApplication
import com.netease.nimlib.sdk.v2.friend.enums.V2NIMFriendAddApplicationStatus
import com.netease.nimlib.v2.builder.V2NIMFriendAddApplicationBuilder

fun V2NIMFriend.toMap(): Map<String, Any?> {
    return mapOf(
        "accountId" to this.accountId,
        "alias" to this.alias,
        "serverExtension" to this.serverExtension,
        "customerExtension" to this.customerExtension,
        "createTime" to this.createTime,
        "updateTime" to this.updateTime,
        "userProfile" to this.userProfile?.toMap()
    )
}

fun V2NIMFriendAddApplication.toMap(): Map<String, Any?> {
    return mapOf(
        "applicantAccountId" to this.applicantAccountId,
        "recipientAccountId" to this.recipientAccountId,
        "operatorAccountId" to this.operatorAccountId,
        "postscript" to this.postscript,
        "status" to this.status.value,
        "timestamp" to this.timestamp,
        "read" to this.isRead
    )
}

fun Map<String, *>.toV2NIMFriendAddApplication(): V2NIMFriendAddApplication {
    val applicationBuilder = V2NIMFriendAddApplicationBuilder.builder()
    (this["applicantAccountId"] as? String?)?.let {
        applicationBuilder.setApplicantAccountId(it)
    }
    (this["recipientAccountId"] as? String?)?.let {
        applicationBuilder.setRecipientAccountId(it)
    }
    (this["operatorAccountId"] as? String?)?.let {
        applicationBuilder.setOperatorAccountId(it)
    }
    (this["postscript"] as? String?)?.let {
        applicationBuilder.setPostscript(it)
    }
    (this["status"] as? Int?)?.let {
        applicationBuilder.setStatus(V2NIMFriendAddApplicationStatus.typeOfValue(it))
    }
    (this["timestamp"] as? Long?)?.let {
        applicationBuilder.setTimestamp(it)
    }
    (this["read"] as? Boolean?)?.let {
        applicationBuilder.setRead(it)
    }
    return applicationBuilder.build()
}
