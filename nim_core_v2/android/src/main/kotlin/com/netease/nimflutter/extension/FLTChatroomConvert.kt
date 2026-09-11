/*
 * Copyright (c) 2022 NetEase, Inc. All rights reserved.
 * Use of this source code is governed by a MIT license that can be
 * found in the LICENSE file.
 */

package com.netease.nimflutter.extension

import com.netease.nimlib.sdk.v2.chatroom.config.V2NIMChatroomLocationConfig
import com.netease.nimlib.sdk.v2.chatroom.config.V2NIMChatroomMessageConfig
import com.netease.nimlib.sdk.v2.chatroom.config.V2NIMChatroomTagConfig
import com.netease.nimlib.sdk.v2.chatroom.config.V2NIMUserInfoConfig
import com.netease.nimlib.sdk.v2.chatroom.enums.V2NIMChatroomMemberRole
import com.netease.nimlib.sdk.v2.chatroom.model.V2NIMChatroomMessage
import com.netease.nimlib.sdk.v2.chatroom.model.V2NIMChatroomQueueElement
import com.netease.nimlib.sdk.v2.chatroom.model.V2NIMLocationInfo
import com.netease.nimlib.sdk.v2.chatroom.option.V2NIMChatroomLoginOption
import com.netease.nimlib.sdk.v2.chatroom.option.V2NIMChatroomMemberQueryOption
import com.netease.nimlib.sdk.v2.chatroom.option.V2NIMChatroomMessageListOption
import com.netease.nimlib.sdk.v2.chatroom.option.V2NIMChatroomTagMemberOption
import com.netease.nimlib.sdk.v2.chatroom.option.V2NIMChatroomTagMessageOption
import com.netease.nimlib.sdk.v2.chatroom.params.V2NIMChatroomEnterParams
import com.netease.nimlib.sdk.v2.chatroom.params.V2NIMChatroomMemberRoleUpdateParams
import com.netease.nimlib.sdk.v2.chatroom.params.V2NIMChatroomQueueOfferParams
import com.netease.nimlib.sdk.v2.chatroom.params.V2NIMChatroomSelfMemberUpdateParams
import com.netease.nimlib.sdk.v2.chatroom.params.V2NIMChatroomTagTempChatBannedParams
import com.netease.nimlib.sdk.v2.chatroom.params.V2NIMChatroomTagsUpdateParams
import com.netease.nimlib.sdk.v2.chatroom.params.V2NIMChatroomUpdateParams
import com.netease.nimlib.sdk.v2.chatroom.params.V2NIMSendChatroomMessageParams
import com.netease.nimlib.sdk.v2.chatroom.provider.V2NIMChatroomLinkProvider
import com.netease.nimlib.sdk.v2.message.enums.V2NIMMessageAttachmentUploadState
import com.netease.nimlib.sdk.v2.message.enums.V2NIMMessageQueryDirection
import com.netease.nimlib.sdk.v2.message.enums.V2NIMMessageSendingState
import com.netease.nimlib.sdk.v2.message.enums.V2NIMMessageType
import com.netease.nimlib.v2.chatroom.builder.V2NIMChatroomMessageBuilder

fun convertToV2NIMSendChatroomMessageParams(params: Map<String, *>): V2NIMSendChatroomMessageParams {
    val msgParams = V2NIMSendChatroomMessageParams()
    if (params.containsKey("notifyTargetTags")) {
        msgParams.notifyTargetTags = params["notifyTargetTags"] as? String
    }
    if (params.containsKey("clientAntispamReplace")) {
        msgParams.clientAntispamReplace = params["clientAntispamReplace"] as? String
    }

    if (params.containsKey("clientAntispamEnabled")) {
        msgParams.isClientAntispamEnabled = (params["clientAntispamEnabled"] as? Boolean) ?: false
    }
    if (params.containsKey("receiverIds")) {
        msgParams.receiverIds = (params["receiverIds"] as? List<String>)
    }

    if (params.containsKey("locationInfo")) {
        msgParams.locationInfo = (params["locationInfo"] as? Map<String, *>)?.let { info ->
            V2NIMLocationInfo().apply {
                val distancex = info["x"] as? Double?
                if (distancex != null) {
                    this.x = distancex
                }
                val distancey = info["y"] as? Double?
                if (distancey != null) {
                    this.y = distancey
                }
                val distancez = info["z"] as? Double?
                if (distancez != null) {
                    this.z = distancez
                }
            }
        }
    }

    if (params.containsKey("antispamConfig")) {
        msgParams.antispamConfig = (params["antispamConfig"] as? Map<String, *>)?.let { info ->
            info.toMessageAntispamConfig()
        }
    }

    if (params.containsKey("routeConfig")) {
        msgParams.routeConfig = (params["routeConfig"] as? Map<String, *>)?.let { info ->
            info.toMessageRouteConfig()
        }
    }

    if (params.containsKey("messageConfig")) {
        msgParams.messageConfig = (params["messageConfig"] as? Map<String, *>)?.let { info ->
            convertToV2NIMChatroomMessageConfig(info)
        }
    }

    return msgParams
}

fun convertToV2NIMChatroomMemberQueryOption(option: Map<String, *>): V2NIMChatroomMemberQueryOption {
    val queryOption = V2NIMChatroomMemberQueryOption()
    if (option.containsKey("limit")) {
        val limit = option["limit"] as? Int?
        if (limit != null) {
            queryOption.limit = limit
        }
    }
    if (option.containsKey("pageToken")) {
        queryOption.pageToken = option["pageToken"] as String?
    }

    if (option.containsKey("onlyOnline")) {
        val onlyOnline = option["onlyOnline"] as Boolean?
        if (onlyOnline != null) {
            queryOption.isOnlyOnline = onlyOnline
        }
    }

    if (option.containsKey("onlyChatBanned")) {
        val onlyChatBanned = option["onlyChatBanned"] as Boolean?
        if (onlyChatBanned != null) {
            queryOption.isOnlyChatBanned = onlyChatBanned
        }
    }

    if (option.containsKey("onlyBlocked")) {
        val onlyBlocked = option["onlyBlocked"] as Boolean?
        if (onlyBlocked != null) {
            queryOption.isOnlyBlocked = onlyBlocked
        }
    }

    if (option.containsKey("memberRoles")) {
        val memberRoles = (option["memberRoles"] as? List<Int>)?.map {
            V2NIMChatroomMemberRole.typeOfValue(it)
        }
        if (memberRoles != null) {
            queryOption.memberRoles = memberRoles
        }
    }
    return queryOption
}

fun convertToV2NIMChatroomTagMessageOption(map: Map<String, *>): V2NIMChatroomTagMessageOption {
    return V2NIMChatroomTagMessageOption().apply {
        tags = (map["tags"] as? List<*>)?.filterIsInstance<String>()?.takeIf { it.isNotEmpty() }
        messageTypes = (map["messageTypes"] as? List<Int>)?.map { item ->
            V2NIMMessageType.typeOfValue(item)
        }?.toList()

        beginTime = when (val value = map["beginTime"]) {
            is Number -> value.toLong()
            is String -> value.toLongOrNull() ?: 0
            else -> 0
        }
        endTime = when (val value = map["endTime"]) {
            is Number -> value.toLong()
            is String -> value.toLongOrNull() ?: 0
            else -> 0
        }

        limit = when (val value = map["limit"]) {
            is Int -> value
            is Number -> value.toInt().takeIf { it > 0 }
            else -> null
        }?.takeIf { it > 0 }

        direction = when (val value = map["direction"]) {
            is Int -> try {
                V2NIMMessageQueryDirection.typeOfValue(value)
            } catch (e: IllegalArgumentException) {
                null
            }

            is V2NIMMessageQueryDirection -> value
            else -> null
        }
    }
}

fun convertToRoleUpdateParams(option: Map<String, *>): V2NIMChatroomMemberRoleUpdateParams {
    val queryOption = V2NIMChatroomMemberRoleUpdateParams()
    if (option.containsKey("memberLevel")) {
        val memberLevel = option["memberLevel"] as? Int?
        if (memberLevel != null) {
            queryOption.memberLevel = memberLevel
        }
    }
    if (option.containsKey("notificationExtension")) {
        queryOption.notificationExtension = option["notificationExtension"] as? String?
    }

    if (option.containsKey("memberRole")) {
        val memberRole = option["memberRole"] as? Int?
        if (memberRole != null) {
            queryOption.memberRole = V2NIMChatroomMemberRole.typeOfValue(memberRole)
        }
    }

    return queryOption
}

fun convertToChatroomMessageListOption(option: Map<String, *>): V2NIMChatroomMessageListOption {
    val queryOption = V2NIMChatroomMessageListOption()
    if (option.containsKey("limit")) {
        val limit = option["limit"] as? Int?
        if (limit != null) {
            queryOption.limit = limit
        }
    }
    if (option.containsKey("beginTime")) {
        var beginTime = option["beginTime"] as? Long?
        if (beginTime == null) {
            beginTime = (option["beginTime"] as? Int? ?: 0).toLong()
        }
        queryOption.beginTime = beginTime
    }

    if (option.containsKey("direction")) {
        val direction = option["direction"] as? Int?
        if (direction != null) {
            queryOption.direction = V2NIMMessageQueryDirection.typeOfValue(direction)
        }
    }

    if (option.containsKey("messageTypes")) {
        val messageTypes = (option["messageTypes"] as? List<Int>)?.map {
            V2NIMMessageType.typeOfValue(it)
        }

        queryOption.messageTypes = messageTypes
    }
    return queryOption
}

fun convertToChatroomLocationConfig(params: Map<String, *>): V2NIMChatroomLocationConfig {
    val config = V2NIMChatroomLocationConfig()
    if (params.containsKey("distance")) {
        val distance = params["distance"] as? Double?
        if (distance != null) {
            config.distance = distance
        }
    }
    if (params.containsKey("locationInfo")) {
        config.locationInfo = (params["locationInfo"] as? Map<String, *>?)?.let { info ->
            V2NIMLocationInfo().apply {
                val distancex = info["x"] as? Double?
                if (distancex != null) {
                    this.x = distancex
                }
                val distancey = info["y"] as? Double?
                if (distancey != null) {
                    this.y = distancey
                }
                val distancez = info["z"] as? Double?
                if (distancez != null) {
                    this.z = distancez
                }
            }
        }
    }
    return config
}

fun convertToChatroomUpdateParams(params: Map<String, *>): V2NIMChatroomUpdateParams {
    val updateParams = V2NIMChatroomUpdateParams()
    if (params.containsKey("roomName")) {
        updateParams.roomName = params["roomName"] as String?
    }
    if (params.containsKey("announcement")) {
        updateParams.announcement = params["announcement"] as String?
    }
    if (params.containsKey("liveUrl")) {
        updateParams.liveUrl = params["liveUrl"] as String?
    }
    if (params.containsKey("serverExtension")) {
        updateParams.serverExtension = params["serverExtension"] as String?
    }
    if (params.containsKey("notificationExtension")) {
        updateParams.notificationExtension = params["notificationExtension"] as String?
    }
    if (params.containsKey("notificationEnabled")) {
        val notificationEnabled = params["notificationEnabled"] as? Boolean?
        if (notificationEnabled != null) {
            updateParams.isNotificationEnabled = notificationEnabled
        }
    }
    return updateParams
}

fun convertToChatroomSelfMemberUpdateParams(params: Map<String, *>): V2NIMChatroomSelfMemberUpdateParams {
    val updateParams = V2NIMChatroomSelfMemberUpdateParams()
    if (params.containsKey("roomNick")) {
        updateParams.roomNick = params["roomNick"] as String?
    }
    if (params.containsKey("roomAvatar")) {
        updateParams.roomAvatar = params["roomAvatar"] as String?
    }
    if (params.containsKey("serverExtension")) {
        updateParams.serverExtension = params["serverExtension"] as String?
    }
    if (params.containsKey("notificationExtension")) {
        updateParams.notificationExtension = params["notificationExtension"] as String?
    }
    if (params.containsKey("notificationEnabled")) {
        val notificationEnabled = params["notificationEnabled"] as? Boolean?
        if (notificationEnabled != null) {
            updateParams.isNotificationEnabled = notificationEnabled
        }
    }
    if (params.containsKey("persistence")) {
        val persistence = params["persistence"] as? Boolean?
        if (persistence != null) {
            updateParams.isPersistence = persistence
        }
    }
    return updateParams
}

fun convertToChatroomTagTempChatBannedParams(params: Map<String, *>): V2NIMChatroomTagTempChatBannedParams {
    val updateParams = V2NIMChatroomTagTempChatBannedParams()
    if (params.containsKey("notifyTargetTags")) {
        updateParams.notifyTargetTags = params["notifyTargetTags"] as String?
    }
    if (params.containsKey("targetTag")) {
        updateParams.targetTag = params["targetTag"] as String?
    }
    if (params.containsKey("notificationExtension")) {
        updateParams.notificationExtension = params["notificationExtension"] as String?
    }
    if (params.containsKey("notificationEnabled")) {
        val notificationEnabled = params["notificationEnabled"] as? Boolean?
        if (notificationEnabled != null) {
            updateParams.isNotificationEnabled = notificationEnabled
        }
    }
    var duration = params["duration"] as? Int?
    if (duration != null) {
        updateParams.duration = duration
    }
    return updateParams
}

fun convertToChatroomTagMemberOption(option: Map<String, *>): V2NIMChatroomTagMemberOption {
    val queryOption = V2NIMChatroomTagMemberOption()
    if (option.containsKey("limit")) {
        val limit = option["limit"] as? Int?
        if (limit != null) {
            queryOption.limit = limit
        }
    }
    if (option.containsKey("pageToken")) {
        queryOption.pageToken = option["pageToken"] as String?
    }
    if (option.containsKey("tag")) {
        queryOption.tag = option["tag"] as String?
    }
    return queryOption
}

fun convertToChatroomTagsUpdateParams(params: Map<String, *>): V2NIMChatroomTagsUpdateParams {
    val updateParams = V2NIMChatroomTagsUpdateParams()
    if (params.containsKey("tags")) {
        updateParams.tags = params["tags"] as List<String>?
    }
    if (params.containsKey("notifyTargetTags")) {
        updateParams.notifyTargetTags = params["notifyTargetTags"] as String?
    }

    if (params.containsKey("notificationEnabled")) {
        val notificationEnabled = params["notificationEnabled"] as? Boolean?
        if (notificationEnabled != null) {
            updateParams.isNotificationEnabled = notificationEnabled
        }
    }
    return updateParams
}
fun convertToV2NIMChatroomMessageConfig(params: Map<String, *>): V2NIMChatroomMessageConfig {
    val updateParams = V2NIMChatroomMessageConfig()
    if (params.containsKey("highPriority")) {
        val highPriority = params["highPriority"] as? Boolean?
        if (highPriority != null) {
            updateParams.isHighPriority = highPriority
        }
    }
    if (params.containsKey("historyEnabled")) {
        val historyEnabled = params["historyEnabled"] as? Boolean?
        if (historyEnabled != null) {
            updateParams.isHistoryEnabled = historyEnabled
        }
    }
    return updateParams
}

fun convertToV2NIMChatroomEnterParams(
    params: Map<String, *>,
    linkProvider: V2NIMChatroomLinkProvider,
    loginOption: V2NIMChatroomLoginOption?
): V2NIMChatroomEnterParams {
    val enterParam = V2NIMChatroomEnterParams.V2NIMChatroomEnterParamsBuilder.builder(linkProvider)
    if (params.containsKey("anonymousMode")) {
        enterParam.withAnonymousMode((params["anonymousMode"] as? Boolean) ?: false)
    }
    if (loginOption != null) {
        enterParam.withLoginOption(loginOption)
    }

    if (params.containsKey("accountId")) {
        enterParam.withAccountId(params["accountId"] as? String)
    }
    if (params.containsKey("token")) {
        enterParam.withToken(params["token"] as? String)
    }
    if (params.containsKey("roomNick")) {
        enterParam.withRoomNick(params["roomNick"] as? String)
    }
    if (params.containsKey("roomAvatar")) {
        enterParam.withRoomAvatar(params["roomAvatar"] as? String)
    }
    if (params.containsKey("timeout")) {
        var timeout = params["timeout"] as? Int?
        if (timeout != null) {
            enterParam.withTimeout(timeout)
        }
    }
    if (params.containsKey("serverExtension")) {
        enterParam.withServerExtension(params["serverExtension"] as? String)
    }
    if (params.containsKey("notificationExtension")) {
        enterParam.withNotificationExtension(params["notificationExtension"] as? String)
    }
    if (params.containsKey("tagConfig")) {
        val tagConfig = (params["tagConfig"] as? Map<String, *>)?.let { convertToV2NIMChatroomTagConfig(it) }
        enterParam.withTagConfig(tagConfig)
    }

    if (params.containsKey("locationConfig")) {
        val locationConfig = (params["locationConfig"] as? Map<String, *>)?.let { convertToChatroomLocationConfig(it) }
        enterParam.withLocationConfig(locationConfig)
    }
    if (params.containsKey("antispamConfig")) {
        val antispamConfig = (params["antispamConfig"] as? Map<String, *>)?.let { convertV2NIMAntispamConfig(it) }
        enterParam.withAntispamConfig(antispamConfig)
    }

    return enterParam.build()
}
fun convertToV2NIMChatroomTagConfig(params: Map<String, *>): V2NIMChatroomTagConfig {
    val tagConfigBuilder = V2NIMChatroomTagConfig.V2NIMChatroomTagConfigBuilder.builder()
    if (params.containsKey("tags")) {
        tagConfigBuilder.withTags(params["tags"] as? List<String>)
    }
    if (params.containsKey("notifyTargetTags")) {
        tagConfigBuilder.withNotifyTargetTags(params["notifyTargetTags"] as? String)
    }

    return tagConfigBuilder.build()
}

fun convertToV2NIMUserInfoConfig(params: Map<String, *>): V2NIMUserInfoConfig {
    val userConfig = V2NIMUserInfoConfig()
    if (params.containsKey("senderNick")) {
        userConfig.senderNick = params["senderNick"] as? String
    }

    if (params.containsKey("senderAvatar")) {
        userConfig.senderAvatar = params["senderAvatar"] as? String
    }

    if (params.containsKey("senderExtension")) {
        userConfig.senderExtension = params["senderExtension"] as? String
    }

    if (params.containsKey("userInfoTimestamp")) {
        var userInfoTimestamp = params["userInfoTimestamp"] as? Long?
        if (userInfoTimestamp == null) {
            userInfoTimestamp = (params["userInfoTimestamp"] as? Int? ?: 0).toLong()
        }
        userConfig.userInfoTimestamp = userInfoTimestamp
    }

    return userConfig
}

fun convertToV2NIMChatroomMessage(params: Map<String, *>): V2NIMChatroomMessage {
    val chatroomMessage =
        V2NIMChatroomMessageBuilder
            .builder()
            .senderId(params["senderId"] as? String)
            .roomId(params["roomId"] as? String)
            .messageClientId(params["messageClientId"] as? String)
            .senderClientType((params["senderClientType"] as? Int) ?: 0)
            .createTime(params["createTime"] as? Long ?: 0)
            .isSelf(params["isSelf"] as? Boolean ?: false)
            .attachmentUploadState(
                V2NIMMessageAttachmentUploadState.typeOfValue(params["attachmentUploadState"] as? Int ?: 0)
            ).sendingState(
                V2NIMMessageSendingState.typeOfValue(params["sendingState"] as? Int ?: 0)
            ).messageType(
                V2NIMMessageType.typeOfValue(params["messageType"] as? Int ?: 0)
            ).subType(params["subType"] as? Int ?: 0)
            .text(params["text"] as? String)
            .attachment((params["attachment"] as? Map<String, Any?>)?.toMessageAttachment())
            .serverExtension(params["serverExtension"] as? String)
            .callbackExtension(params["callbackExtension"] as? String)
            .messageConfig((params["messageConfig"] as? Map<String, Any?>)?.let { convertToV2NIMChatroomMessageConfig(it) })
            .userInfoConfig((params["userInfoConfig"] as? Map<String, Any?>)?.let { convertToV2NIMUserInfoConfig(it) })
            .routeConfig((params["routeConfig"] as? Map<String, Any?>)?.toMessageRouteConfig())
            .antispamConfig((params["antispamConfig"] as? Map<String, Any?>)?.toMessageAntispamConfig())
            .locationInfo(
                (params["locationInfo"] as? Map<String, Any?>)?.let { info ->
                    V2NIMLocationInfo().apply {
                        val distancex = info["x"] as? Double?
                        if (distancex != null) {
                            this.x = distancex
                        }
                        val distancey = info["y"] as? Double?
                        if (distancey != null) {
                            this.y = distancey
                        }
                        val distancez = info["z"] as? Double?
                        if (distancez != null) {
                            this.z = distancez
                        }
                    }
                }
            )
            .notifyTargetTags(params["notifyTargetTags"] as? String)
            .build()

    return chatroomMessage
}

fun convertToV2NIMChatroomQueueOfferParams(params: Map<String, *>): V2NIMChatroomQueueOfferParams? {
    val elementKey = params["elementKey"] as? String

    val elementValue = params["elementValue"] as? String
    if (elementKey == null || elementValue == null) {
        return null
    }
    val queueOfferParams = V2NIMChatroomQueueOfferParams(
        elementKey,
        elementValue
    )
    if (params.containsKey("transient")) {
        queueOfferParams.isTransient = params["transient"] as? Boolean ?: false
    }
    if (params.containsKey("elementOwnerAccountId")) {
        queueOfferParams.elementOwnerAccountId = params["elementOwnerAccountId"] as? String
    }
    return queueOfferParams
}

fun convertToV2NIMChatroomQueueElement(params: Map<String, *>): V2NIMChatroomQueueElement? {
    val key = params["key"] as? String

    val value = params["value"] as? String
    if (key == null || value == null) {
        return null
    }
    val queueElement = V2NIMChatroomQueueElement(key, value)
    if (params.containsKey("accountId")) {
        queueElement.accountId = params["accountId"] as? String
    }

    if (params.containsKey("nick")) {
        queueElement.nick = params["nick"] as? String
    }

    if (params.containsKey("extension")) {
        queueElement.extension = params["extension"] as? String
    }
    return queueElement
}
