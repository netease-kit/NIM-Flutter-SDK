/*
 * Copyright (c) 2022 NetEase, Inc. All rights reserved.
 * Use of this source code is governed by a MIT license that can be
 * found in the LICENSE file.
 */

package com.netease.nimflutter

import com.netease.nimlib.sdk.v2.common.V2NIMAntispamConfig
import com.netease.nimlib.sdk.v2.conversation.params.V2NIMConversationUpdate
import com.netease.nimlib.sdk.v2.message.enums.V2NIMQueryDirection
import com.netease.nimlib.sdk.v2.notification.params.V2NIMSendCustomNotificationParams
import com.netease.nimlib.sdk.v2.storage.V2NIMUploadFileParams
import com.netease.nimlib.sdk.v2.storage.V2NIMUploadFileTask
import com.netease.nimlib.sdk.v2.storage.enums.V2NIMDownloadAttachmentType
import com.netease.nimlib.sdk.v2.storage.model.V2NIMSize
import com.netease.nimlib.sdk.v2.storage.params.V2NIMDownloadMessageAttachmentParams
import com.netease.nimlib.sdk.v2.team.enums.V2NIMTeamAgreeMode
import com.netease.nimlib.sdk.v2.team.enums.V2NIMTeamInviteMode
import com.netease.nimlib.sdk.v2.team.enums.V2NIMTeamJoinActionStatus
import com.netease.nimlib.sdk.v2.team.enums.V2NIMTeamJoinActionType
import com.netease.nimlib.sdk.v2.team.enums.V2NIMTeamJoinMode
import com.netease.nimlib.sdk.v2.team.enums.V2NIMTeamMemberRoleQueryType
import com.netease.nimlib.sdk.v2.team.enums.V2NIMTeamUpdateExtensionMode
import com.netease.nimlib.sdk.v2.team.enums.V2NIMTeamUpdateInfoMode
import com.netease.nimlib.sdk.v2.team.option.V2NIMTeamJoinActionInfoQueryOption
import com.netease.nimlib.sdk.v2.team.option.V2NIMTeamMemberQueryOption
import com.netease.nimlib.sdk.v2.team.params.V2NIMUpdateSelfMemberInfoParams
import com.netease.nimlib.sdk.v2.team.params.V2NIMUpdateTeamInfoParams

fun convertV2NIMAntispamConfig(arguments: Map<String, Any?>): V2NIMAntispamConfig {
    return V2NIMAntispamConfig().apply {
        this.antispamBusinessId = arguments["antispamBusinessId"] as String?
    }
}

fun convertV2NIMUpdateTeamInfoParams(arguments: Map<String, Any?>): V2NIMUpdateTeamInfoParams {
    return V2NIMUpdateTeamInfoParams().apply {
        this.name = arguments["name"] as String?
        (arguments["memberLimit"] as Int?)?.let {
            this.memberLimit = it
        }
        this.intro = arguments["intro"] as String?
        this.announcement = arguments["announcement"] as String?
        this.avatar = arguments["avatar"] as String?
        this.serverExtension = arguments["serverExtension"] as String?
        (arguments["joinMode"] as Int?)?.let { this.joinMode = V2NIMTeamJoinMode.typeOfValue(it) }
        (arguments["agreeMode"] as Int?)?.let { this.agreeMode = V2NIMTeamAgreeMode.typeOfValue(it) }

        (arguments["inviteMode"] as Int?)?.let {
            this.inviteMode =
                V2NIMTeamInviteMode.typeOfValue(
                    it
                )
        }

        (
            arguments["updateInfoMode"] as
                Int?
            )?.let { this.updateInfoMode = V2NIMTeamUpdateInfoMode.typeOfValue(it) }

        (arguments["updateExtensionMode"] as Int?)?.let {
            this.updateExtensionMode =
                V2NIMTeamUpdateExtensionMode.typeOfValue(
                    it
                )
        }
    }
}

fun convertV2NIMConversationUpdate(arguments: Map<String, Any?>?): V2NIMConversationUpdate {
    return V2NIMConversationUpdate().apply {
        this.serverExtension = arguments?.get("serverExtension") as String?
    }
}

fun convertV2NIMUpdateSelfMemberInfoParams(arguments: Map<String, Any?>): V2NIMUpdateSelfMemberInfoParams {
    return V2NIMUpdateSelfMemberInfoParams().apply {
        this.teamNick = arguments["teamNick"] as String?
        this.serverExtension = arguments["serverExtension"] as String?
    }
}

fun convertV2NIMTeamMemberQueryOption(arguments: Map<String, Any?>): V2NIMTeamMemberQueryOption {
    return V2NIMTeamMemberQueryOption().apply {
        (arguments["onlyChatBanned"] as Boolean?)?.let {
            this.isOnlyChatBanned = it
        }
        (arguments["limit"] as Int?)?.let {
            this.limit = it
        }
        this.nextToken = arguments["nextToken"] as String?

        (
            arguments["roleQueryType"]
                as Int?
            )?.let {
            this.roleQueryType =
                V2NIMTeamMemberRoleQueryType.typeOfValue(
                    it
                )
        }
        (arguments["direction"] as Int?)?.let { this.direction = V2NIMQueryDirection.typeOfValue(it) }
    }
}

fun convertV2NIMTeamJoinActionInfoQueryOption(arguments: Map<String, Any?>): V2NIMTeamJoinActionInfoQueryOption {
    return V2NIMTeamJoinActionInfoQueryOption().apply {
        this.limit = (arguments["limit"] as? Int?) ?: 0
        this.offset = ((arguments["offset"] as? Int?) ?: 0).toLong()
        this.status =
            (arguments["status"] as List<Int>?)?.map {
                V2NIMTeamJoinActionStatus
                    .typeOfValue(it)
            }
        this.types = (arguments["types"] as List<Int>?)?.map { V2NIMTeamJoinActionType.typeOfValue(it) }
    }
}

fun convertV2NIMUploadFileParams(arguments: Map<String, Any?>?): V2NIMUploadFileParams {
    if (arguments == null) {
        return V2NIMUploadFileParams(null, null)
    }
    return V2NIMUploadFileParams(arguments["filePath"] as String?, arguments["sceneName"] as String?)
}

fun convertV2NIMUploadFileTask(arguments: Map<String, Any?>): V2NIMUploadFileTask {
    return V2NIMUploadFileTask(
        arguments["taskId"] as String?,
        convertV2NIMUploadFileParams
        (arguments["uploadParams"] as Map<String, Any?>?)
    )
}

fun convertV2NIMDownloadMessageAttachmentParams(arguments: Map<String, Any?>?): V2NIMDownloadMessageAttachmentParams? {
    if (arguments == null) {
        return null
    }
    val attachment = (arguments["attachment"] as Map<String, *>?)?.toMessageAttachment()
    val type = (arguments["type"] as Int?)?.let { V2NIMDownloadAttachmentType.typeOfValue(it) }
    val clientId = arguments["messageClientId"] as String?
    val saveAs = arguments["saveAs"] as String?
    val thumbSize =
        (arguments["thumbSize"] as Map<String, Any?>?)?.let {
            convertV2NIMSize(it)
        }
    if (attachment != null) {
        val builder =
            V2NIMDownloadMessageAttachmentParams
                .V2NIMDownloadMessageAttachmentParamsBuilder(attachment)
        builder.messageClientId(clientId)
        builder.saveAs(saveAs)
        builder.thumbSize(thumbSize)
        builder.type(type)
        return builder.build()
    }
    return null
}

fun convertV2NIMSize(arguments: Map<String, *>): V2NIMSize {
    return V2NIMSize().apply {
        var widthValue = arguments["width"] as? Long?
        if (widthValue == null) {
            widthValue = (arguments["width"] as? Int? ?: 0).toLong()
        }
        this.width = widthValue

        var heightValue = arguments["height"] as? Long?
        if (heightValue == null) {
            heightValue = (arguments["height"] as? Int? ?: 0).toLong()
        }
        this.height = heightValue
    }
}

fun convertV2NIMSendCustomNotificationParams(arguments: Map<String, Any?>): V2NIMSendCustomNotificationParams {
    val paramsBuilder =
        V2NIMSendCustomNotificationParams
            .V2NIMSendCustomNotificationParamsBuilder.builder()
    (arguments["notificationConfig"] as Map<String, *>)?.let {
        paramsBuilder.withNotificationConfig(it.toNotificationConfig())
    }
    (arguments["antispamConfig"] as Map<String, *>)?.let {
        paramsBuilder.withAntispamConfig(it.toNotificationAntispamConfig())
    }
    (arguments["pushConfig"] as Map<String, *>)?.let {
        paramsBuilder.withPushConfig(it.toNotificationPushConfig())
    }
    (arguments["routeConfig"] as Map<String, *>)?.let {
        paramsBuilder.withRouteConfig(it.toNotificationRouteConfig())
    }
    return paramsBuilder.build()
}
