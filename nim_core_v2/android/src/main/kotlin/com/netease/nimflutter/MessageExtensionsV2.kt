/*
 * Copyright (c) 2022 NetEase, Inc. All rights reserved.
 * Use of this source code is governed by a MIT license that can be
 * found in the LICENSE file.
 */

package com.netease.nimflutter

import com.netease.nimlib.sdk.v2.ai.enums.V2NIMAIModelRoleType
import com.netease.nimlib.sdk.v2.ai.params.V2NIMAIModelCallContent
import com.netease.nimlib.sdk.v2.ai.params.V2NIMAIModelCallMessage
import com.netease.nimlib.sdk.v2.ai.params.V2NIMAIModelConfigParams
import com.netease.nimlib.sdk.v2.conversation.enums.V2NIMConversationType
import com.netease.nimlib.sdk.v2.message.V2NIMClearHistoryNotification
import com.netease.nimlib.sdk.v2.message.V2NIMCollection
import com.netease.nimlib.sdk.v2.message.V2NIMMessage
import com.netease.nimlib.sdk.v2.message.V2NIMMessageDeletedNotification
import com.netease.nimlib.sdk.v2.message.V2NIMMessagePin
import com.netease.nimlib.sdk.v2.message.V2NIMMessagePinNotification
import com.netease.nimlib.sdk.v2.message.V2NIMMessageQuickComment
import com.netease.nimlib.sdk.v2.message.V2NIMMessageQuickCommentNotification
import com.netease.nimlib.sdk.v2.message.V2NIMMessageRefer
import com.netease.nimlib.sdk.v2.message.V2NIMMessageReferBuilder
import com.netease.nimlib.sdk.v2.message.V2NIMMessageRevokeNotification
import com.netease.nimlib.sdk.v2.message.V2NIMP2PMessageReadReceipt
import com.netease.nimlib.sdk.v2.message.V2NIMTeamMessageReadReceipt
import com.netease.nimlib.sdk.v2.message.V2NIMTeamMessageReadReceiptDetail
import com.netease.nimlib.sdk.v2.message.attachment.V2NIMMessageAttachment
import com.netease.nimlib.sdk.v2.message.attachment.V2NIMMessageAudioAttachment
import com.netease.nimlib.sdk.v2.message.attachment.V2NIMMessageCallAttachment
import com.netease.nimlib.sdk.v2.message.attachment.V2NIMMessageFileAttachment
import com.netease.nimlib.sdk.v2.message.attachment.V2NIMMessageImageAttachment
import com.netease.nimlib.sdk.v2.message.attachment.V2NIMMessageLocationAttachment
import com.netease.nimlib.sdk.v2.message.attachment.V2NIMMessageNotificationAttachment
import com.netease.nimlib.sdk.v2.message.attachment.V2NIMMessageVideoAttachment
import com.netease.nimlib.sdk.v2.message.config.V2NIMMessageAIConfig
import com.netease.nimlib.sdk.v2.message.config.V2NIMMessageAntispamConfig
import com.netease.nimlib.sdk.v2.message.config.V2NIMMessageAntispamConfig.V2NIMMessageAntispamConfigBuilder
import com.netease.nimlib.sdk.v2.message.config.V2NIMMessageConfig
import com.netease.nimlib.sdk.v2.message.config.V2NIMMessageConfig.V2NIMMessageConfigBuilder
import com.netease.nimlib.sdk.v2.message.config.V2NIMMessagePushConfig
import com.netease.nimlib.sdk.v2.message.config.V2NIMMessagePushConfig.V2NIMMessagePushConfigBuilder
import com.netease.nimlib.sdk.v2.message.config.V2NIMMessageQuickCommentPushConfig
import com.netease.nimlib.sdk.v2.message.config.V2NIMMessageQuickCommentPushConfig.V2NIMMessageQuickCommentPushConfigBuilder
import com.netease.nimlib.sdk.v2.message.config.V2NIMMessageRobotConfig
import com.netease.nimlib.sdk.v2.message.config.V2NIMMessageRobotConfig.V2NIMMessageRobotConfigBuilder
import com.netease.nimlib.sdk.v2.message.config.V2NIMMessageRouteConfig
import com.netease.nimlib.sdk.v2.message.config.V2NIMMessageRouteConfig.V2NIMMessageRouteConfigBuilder
import com.netease.nimlib.sdk.v2.message.enums.V2NIMMessageAIStatus
import com.netease.nimlib.sdk.v2.message.enums.V2NIMMessageAttachmentUploadState
import com.netease.nimlib.sdk.v2.message.enums.V2NIMMessageQueryDirection
import com.netease.nimlib.sdk.v2.message.enums.V2NIMMessageSendingState
import com.netease.nimlib.sdk.v2.message.enums.V2NIMMessageType
import com.netease.nimlib.sdk.v2.message.enums.V2NIMQueryDirection
import com.netease.nimlib.sdk.v2.message.enums.V2NIMSortOrder
import com.netease.nimlib.sdk.v2.message.model.V2NIMMessageCallDuration
import com.netease.nimlib.sdk.v2.message.model.V2NIMMessageStatus
import com.netease.nimlib.sdk.v2.message.option.V2NIMClearHistoryMessageOption
import com.netease.nimlib.sdk.v2.message.option.V2NIMClearHistoryMessageOption.V2NIMClearHistoryMessageOptionBuilder
import com.netease.nimlib.sdk.v2.message.option.V2NIMCollectionOption
import com.netease.nimlib.sdk.v2.message.option.V2NIMCollectionOption.V2NIMCollectionOptionBuilder
import com.netease.nimlib.sdk.v2.message.option.V2NIMMessageListOption
import com.netease.nimlib.sdk.v2.message.option.V2NIMMessageListOption.V2NIMMessageListOptionBuilder
import com.netease.nimlib.sdk.v2.message.option.V2NIMThreadMessageListOption
import com.netease.nimlib.sdk.v2.message.params.V2NIMAddCollectionParams
import com.netease.nimlib.sdk.v2.message.params.V2NIMAddCollectionParams.V2NIMAddCollectionParamsBuilder
import com.netease.nimlib.sdk.v2.message.params.V2NIMMessageAIConfigParams
import com.netease.nimlib.sdk.v2.message.params.V2NIMMessageRevokeParams
import com.netease.nimlib.sdk.v2.message.params.V2NIMMessageRevokeParams.V2NIMMessageRevokeParamsBuilder
import com.netease.nimlib.sdk.v2.message.params.V2NIMMessageSearchParams
import com.netease.nimlib.sdk.v2.message.params.V2NIMMessageSearchParams.V2NIMMessageSearchParamsBuilder
import com.netease.nimlib.sdk.v2.message.params.V2NIMSendMessageParams
import com.netease.nimlib.sdk.v2.message.params.V2NIMSendMessageParams.V2NIMSendMessageParamsBuilder
import com.netease.nimlib.sdk.v2.message.params.V2NIMVoiceToTextParams
import com.netease.nimlib.sdk.v2.message.params.V2NIMVoiceToTextParams.V2NIMVoiceToTextParamsBuilder
import com.netease.nimlib.sdk.v2.message.result.V2NIMClientAntispamResult
import com.netease.nimlib.sdk.v2.message.result.V2NIMSendMessageResult
import com.netease.nimlib.sdk.v2.message.result.V2NIMThreadMessageListResult
import com.netease.nimlib.sdk.v2.notification.config.V2NIMNotificationAntispamConfig
import com.netease.nimlib.sdk.v2.notification.config.V2NIMNotificationAntispamConfig.V2NIMNotificationAntispamConfigBuilder
import com.netease.nimlib.sdk.v2.notification.config.V2NIMNotificationConfig
import com.netease.nimlib.sdk.v2.notification.config.V2NIMNotificationConfig.V2NIMNotificationConfigBuilder
import com.netease.nimlib.sdk.v2.notification.config.V2NIMNotificationPushConfig
import com.netease.nimlib.sdk.v2.notification.config.V2NIMNotificationPushConfig.V2NIMNotificationPushConfigBuilder
import com.netease.nimlib.sdk.v2.notification.config.V2NIMNotificationRouteConfig
import com.netease.nimlib.sdk.v2.notification.config.V2NIMNotificationRouteConfig.V2NIMNotificationRouteConfigBuilder
import com.netease.nimlib.sdk.v2.notification.params.V2NIMSendCustomNotificationParams
import com.netease.nimlib.sdk.v2.notification.params.V2NIMSendCustomNotificationParams.V2NIMSendCustomNotificationParamsBuilder
import com.netease.nimlib.sdk.v2.team.model.V2NIMUpdatedTeamInfo
import com.netease.nimlib.v2.builder.V2NIMCollectionBuilder
import com.netease.nimlib.v2.builder.V2NIMMessageAttachmentBuilder
import com.netease.nimlib.v2.builder.V2NIMMessageBuilder

fun Map<String, *>.toMessageRefer(): V2NIMMessageRefer =
    V2NIMMessageReferBuilder
        .builder()
        .withSenderId(this["senderId"] as? String)
        .withReceiverId(this["receiverId"] as? String)
        .withMessageClientId(this["messageClientId"] as? String)
        .withMessageServerId(this["messageServerId"] as? String)
        .withConversationType(V2NIMConversationType.typeOfValue(this["conversationType"] as? Int ?: 0))
        .withConversationId(this["conversationId"] as? String)
        .withCreateTime(this["createTime"] as? Long ?: 0)
        .build()

fun V2NIMMessageRefer.toMap(): Map<String, Any?> =
    mapOf(
        "senderId" to this.senderId,
        "receiverId" to this.receiverId,
        "messageClientId" to this.messageClientId,
        "messageServerId" to this.messageServerId,
        "conversationType" to this.conversationType?.value,
        "conversationId" to this.conversationId,
        "createTime" to this.createTime
    )

fun Map<String, *>.toMessage(): V2NIMMessage =
    V2NIMMessageBuilder
        .builder()
        .senderId(this["senderId"] as? String)
        .receiverId(this["receiverId"] as? String)
        .messageClientId(this["messageClientId"] as? String)
        .messageServerId(this["messageServerId"] as? String)
        .conversationType(V2NIMConversationType.typeOfValue(this["conversationType"] as? Int ?: 0))
        .conversationId(this["conversationId"] as? String)
        .createTime(this["createTime"] as? Long ?: 0)
        .isSelf(this["isSelf"] as? Boolean ?: false)
        .attachmentUploadState(
            V2NIMMessageAttachmentUploadState.typeOfValue(this["attachmentUploadState"] as? Int ?: 0)
        ).sendingState(
            V2NIMMessageSendingState.typeOfValue(this["sendingState"] as? Int ?: 0)
        ).messageType(
            V2NIMMessageType.typeOfValue(this["messageType"] as? Int ?: 0)
        ).subType(this["subType"] as? Int ?: 0)
        .text(this["text"] as? String)
        .attachment((this["attachment"] as? Map<String, Any?>)?.toMessageAttachment())
        .serverExtension(this["serverExtension"] as? String)
        .localExtension(this["localExtension"] as? String)
        .callbackExtension(this["callbackExtension"] as? String)
        .messageConfig((this["messageConfig"] as? Map<String, Any?>)?.toMessageConfig())
        .pushConfig((this["pushConfig"] as? Map<String, Any?>)?.toMessagePushConfig())
        .routeConfig((this["routeConfig"] as? Map<String, Any?>)?.toMessageRouteConfig())
        .antispamConfig((this["antispamConfig"] as? Map<String, Any?>)?.toMessageAntispamConfig())
        .robotConfig((this["robotConfig"] as? Map<String, Any?>)?.toMessageRobotConfig())
        .threadRoot((this["threadRoot"] as? Map<String, Any?>)?.toMessageRefer())
        .threadReply((this["threadReply"] as? Map<String, Any?>)?.toMessageRefer())
        .aiConfig((this["aiConfig"] as? Map<String, Any?>)?.toMessageAIConfig())
        .messageStatus(getMessageStatusErrorCode(this), getMessageStatusReadReceiptSen(this))
        .build()

fun V2NIMMessage.toMap(): Map<String, Any?> =
    mapOf(
        "isSelf" to this.isSelf,
        "attachmentUploadState" to this.attachmentUploadState?.value,
        "sendingState" to this.sendingState?.value,
        "messageType" to this.messageType?.value,
        "subType" to this.subType,
        "text" to this.text,
        "attachment" to this.attachmentToMap(),
        "serverExtension" to this.serverExtension,
        "localExtension" to this.localExtension,
        "callbackExtension" to this.callbackExtension,
        "messageConfig" to this.messageConfig?.toMap(),
        "pushConfig" to this.pushConfig?.toMap(),
        "routeConfig" to this.routeConfig?.toMap(),
        "antispamConfig" to this.antispamConfig?.toMap(),
        "robotConfig" to this.robotConfig?.toMap(),
        "threadRoot" to this.threadRoot?.toMap(),
        "threadReply" to this.threadReply?.toMap(),
        "aiConfig" to this.aiConfig?.toMap(),
        "messageStatus" to this.messageStatus?.toMap(),
        "senderId" to this.senderId,
        "receiverId" to this.receiverId,
        "messageClientId" to this.messageClientId,
        "messageServerId" to this.messageServerId,
        "conversationType" to this.conversationType?.value,
        "conversationId" to this.conversationId,
        "createTime" to this.createTime
    )

fun getMessageStatusErrorCode(arguments: Map<String, *>): Int {
    val messageStatus = arguments["messageStatus"] as? Map<String, Any?>
    return messageStatus?.get("errorCode") as? Int ?: 0
}

fun getMessageStatusReadReceiptSen(arguments: Map<String, *>): Boolean {
    val messageStatus = arguments["messageStatus"] as? Map<String, Any?>
    return messageStatus?.get("readReceiptSen") as? Boolean ?: false
}

fun V2NIMMessageStatus.toMap(): Map<String, Any?> =
    mapOf(
        "errorCode" to this.errorCode,
        "readReceiptSen" to this.readReceiptSent
    )

fun Map<String, *>.toMessageAIConfig(): V2NIMMessageAIConfig =
    V2NIMMessageAIConfig().apply {
        this.accountId = this@toMessageAIConfig["accountId"] as? String
        this.aiStatus = V2NIMMessageAIStatus.typeOfValue(this@toMessageAIConfig["aiStatus"] as? Int ?: 0)
    }

fun V2NIMMessageAIConfig.toMap(): Map<String, Any?> =
    mapOf(
        "accountId" to this.accountId,
        "aiStatus" to this.aiStatus?.value
    )

fun Map<String, *>.toMessageRobotConfig(): V2NIMMessageRobotConfig =
    V2NIMMessageRobotConfigBuilder
        .builder()
        .withAccountId(this["accountId"] as? String)
        .withTopic(this["topic"] as? String)
        .withFunction(this["function"] as? String)
        .withCustomContent(this["customContent"] as? String)
        .build()

fun V2NIMMessageRobotConfig.toMap(): Map<String, Any?> =
    mapOf(
        "accountId" to this.accountId,
        "topic" to this.topic,
        "function" to this.function,
        "customContent" to this.customContent
    )

fun Map<String, *>.toMessageAntispamConfig(): V2NIMMessageAntispamConfig =
    V2NIMMessageAntispamConfigBuilder
        .builder()
        .withAntispamEnabled(this["antispamEnabled"] as? Boolean ?: true)
        .withAntispamCustomMessage(this["antispamCustomMessage"] as? String)
        .withAntispamCheating(this["antispamCheating"] as? String)
        .withAntispamExtension(this["antispamExtension"] as? String)
        .build()

fun V2NIMMessageAntispamConfig.toMap(): Map<String, Any?> =
    mapOf(
        "antispamEnabled" to this.isAntispamEnabled,
        "antispamBusinessId" to this.antispamBusinessId,
        "antispamCustomMessage" to this.antispamCustomMessage,
        "antispamCheating" to this.antispamCheating,
        "antispamExtension" to this.antispamExtension
    )

fun Map<String, *>.toMessageRouteConfig(): V2NIMMessageRouteConfig =
    V2NIMMessageRouteConfigBuilder
        .builder()
        .withRouteEnabled(this["routeEnabled"] as? Boolean ?: true)
        .withRouteEnvironment(this["routeEnvironment"] as? String)
        .build()

fun V2NIMMessageRouteConfig.toMap(): Map<String, Any?> =
    mapOf(
        "routeEnabled" to this.isRouteEnabled,
        "routeEnvironment" to this.routeEnvironment
    )

fun Map<String, *>.toMessagePushConfig(): V2NIMMessagePushConfig =
    V2NIMMessagePushConfigBuilder
        .builder()
        .withPushEnabled(this["pushEnabled"] as? Boolean ?: true)
        .withPushNickEnabled(this["pushNickEnabled"] as? Boolean ?: true)
        .withContent(this["pushContent"] as? String)
        .withPayload(this["pushPayload"] as? String)
        .withForcePush(this["forcePush"] as? Boolean ?: false)
        .withForcePushContent(this["forcePushContent"] as? String)
        .withForcePushAccountIds(this["forcePushAccountIds"] as? List<String>)
        .build()

fun V2NIMMessagePushConfig.toMap(): Map<String, Any?> =
    mapOf(
        "pushEnabled" to this.isPushEnabled,
        "pushNickEnabled" to this.isPushNickEnabled,
        "pushContent" to this.pushContent,
        "pushPayload" to this.pushPayload,
        "forcePush" to this.isForcePush,
        "forcePushContent" to this.forcePushContent,
        "forcePushAccountIds" to this.forcePushAccountIds
    )

fun Map<String, *>.toMessageConfig(): V2NIMMessageConfig =
    V2NIMMessageConfigBuilder
        .builder()
        .withReadReceiptEnabled(this["readReceiptEnabled"] as? Boolean ?: false)
        .withLastMessageUpdateEnabled(this["lastMessageUpdateEnabled"] as? Boolean ?: true)
        .withHistoryEnabled(this["historyEnabled"] as? Boolean ?: true)
        .withRoamingEnabled(this["roamingEnabled"] as? Boolean ?: true)
        .withOnlineSyncEnabled(this["onlineSyncEnabled"] as? Boolean ?: true)
        .withOfflineEnabled(this["offlineEnabled"] as? Boolean ?: true)
        .withUnreadEnabled(this["unreadEnabled"] as? Boolean ?: true)
        .build()

fun V2NIMMessageConfig.toMap(): Map<String, Any?> =
    mapOf(
        "readReceiptEnabled" to this.isReadReceiptEnabled,
        "lastMessageUpdateEnabled" to this.isLastMessageUpdateEnabled,
        "historyEnabled" to this.isHistoryEnabled,
        "roamingEnabled" to this.isRoamingEnabled,
        "onlineSyncEnabled" to this.isOnlineSyncEnabled,
        "offlineEnabled" to this.isOfflineEnabled,
        "unreadEnabled" to this.isUnreadEnabled
    )

fun Map<String, *>.toMessageAttachment(): V2NIMMessageAttachment =
    V2NIMMessageAttachmentBuilder
        .builder(
            V2NIMMessageType.typeOfValue(this["nimCoreMessageType"] as? Int ?: 0),
            this["raw"] as? String
        ).build()

fun V2NIMMessage.attachmentToMap(): Map<String, Any?>? {
    when (messageType) {
        V2NIMMessageType.V2NIM_MESSAGE_TYPE_FILE -> {
            val att = attachment as V2NIMMessageFileAttachment
            return att.toMap()
        }

        V2NIMMessageType.V2NIM_MESSAGE_TYPE_IMAGE -> {
            val att = attachment as V2NIMMessageImageAttachment
            return att.toMap()
        }

        V2NIMMessageType.V2NIM_MESSAGE_TYPE_AUDIO -> {
            val att = attachment as V2NIMMessageAudioAttachment
            return att.toMap()
        }

        V2NIMMessageType.V2NIM_MESSAGE_TYPE_VIDEO -> {
            val att = attachment as V2NIMMessageVideoAttachment
            return att.toMap()
        }

        V2NIMMessageType.V2NIM_MESSAGE_TYPE_LOCATION -> {
            val att = attachment as V2NIMMessageLocationAttachment
            return att.toMap()
        }

        V2NIMMessageType.V2NIM_MESSAGE_TYPE_NOTIFICATION -> {
            val att = attachment as V2NIMMessageNotificationAttachment
            return att.toMap()
        }

        V2NIMMessageType.V2NIM_MESSAGE_TYPE_CALL -> {
            val att = attachment as V2NIMMessageCallAttachment
            return att.toMap()
        }

        else -> {
            return attachment?.toMap()
        }
    }
}

fun V2NIMMessageAttachment.toMap(): Map<String, Any?> =
    mapOf(
        "raw" to this.raw
    )

fun V2NIMMessageFileAttachment.toMap(): Map<String, Any?> =
    mapOf(
        "raw" to this.raw,
        "nimCoreMessageType" to V2NIMMessageType.V2NIM_MESSAGE_TYPE_FILE.value,
        "path" to this.path,
        "size" to this.size,
        "md5" to this.md5,
        "url" to this.url,
        "ext" to this.ext,
        "name" to this.name,
        "sceneName" to this.sceneName,
        "uploadState" to this.uploadState?.value
    )

fun V2NIMMessageImageAttachment.toMap(): Map<String, Any?> =
    mapOf(
        "raw" to this.raw,
        "nimCoreMessageType" to V2NIMMessageType.V2NIM_MESSAGE_TYPE_IMAGE.value,
        "path" to this.path,
        "size" to this.size,
        "md5" to this.md5,
        "url" to this.url,
        "ext" to this.ext,
        "name" to this.name,
        "sceneName" to this.sceneName,
        "uploadState" to this.uploadState?.value,
        "width" to this.width,
        "height" to this.height
    )

fun V2NIMMessageAudioAttachment.toMap(): Map<String, Any?> =
    mapOf(
        "raw" to this.raw,
        "nimCoreMessageType" to V2NIMMessageType.V2NIM_MESSAGE_TYPE_AUDIO.value,
        "path" to this.path,
        "size" to this.size,
        "md5" to this.md5,
        "url" to this.url,
        "ext" to this.ext,
        "name" to this.name,
        "sceneName" to this.sceneName,
        "uploadState" to this.uploadState?.value,
        "duration" to this.duration
    )

fun V2NIMMessageVideoAttachment.toMap(): Map<String, Any?> =
    mapOf(
        "raw" to this.raw,
        "nimCoreMessageType" to V2NIMMessageType.V2NIM_MESSAGE_TYPE_VIDEO.value,
        "path" to this.path,
        "size" to this.size,
        "md5" to this.md5,
        "url" to this.url,
        "ext" to this.ext,
        "name" to this.name,
        "sceneName" to this.sceneName,
        "uploadState" to this.uploadState?.value,
        "duration" to this.duration,
        "width" to this.width,
        "height" to this.height
    )

fun V2NIMMessageLocationAttachment.toMap(): Map<String, Any?> =
    mapOf(
        "raw" to this.raw,
        "nimCoreMessageType" to V2NIMMessageType.V2NIM_MESSAGE_TYPE_LOCATION.value,
        "latitude" to this.latitude,
        "longitude" to this.longitude,
        "address" to this.address
    )

fun V2NIMMessageNotificationAttachment.toMap(): Map<String, Any?> =
    mapOf(
        "raw" to this.raw,
        "nimCoreMessageType" to V2NIMMessageType.V2NIM_MESSAGE_TYPE_NOTIFICATION.value,
        "type" to this.type?.value,
        "serverExtension" to this.serverExtension,
        "targetIds" to this.targetIds,
        "chatBanned" to this.isChatBanned,
        "updatedTeamInfo" to this.updatedTeamInfo?.toMap()
    )

fun V2NIMUpdatedTeamInfo.toMap(): Map<String, Any?> =
    mapOf(
        "name" to this.name,
        "memberLimit" to this.memberLimit,
        "intro" to this.intro,
        "announcement" to this.announcement,
        "avatar" to this.avatar,
        "serverExtension" to this.serverExtension,
        "joinMode" to this.joinMode?.value,
        "agreeMode" to this.agreeMode?.value,
        "inviteMode" to this.inviteMode?.value,
        "updateInfoMode" to this.updateInfoMode?.value,
        "updateExtensionMode" to this.updateExtensionMode?.value,
        "chatBannedMode" to this.chatBannedMode?.value
    )

fun Map<String, *>.toMessageCallDuration(): V2NIMMessageCallDuration =
    V2NIMMessageCallDuration().apply {
        this.accountId = this@toMessageCallDuration["accountId"] as? String
        this.duration = this@toMessageCallDuration["duration"] as? Int ?: 0
    }

fun V2NIMMessageCallDuration.toMap(): Map<String, Any?> =
    mapOf(
        "accountId" to this.accountId,
        "duration" to this.duration
    )

fun V2NIMMessageCallAttachment.toMap(): Map<String, Any?> =
    mapOf(
        "raw" to this.raw,
        "nimCoreMessageType" to V2NIMMessageType.V2NIM_MESSAGE_TYPE_CALL?.value,
        "type" to this.type,
        "channelId" to this.channelId,
        "status" to this.status,
        "durations" to this.durations.map { it?.toMap() }
    )

fun Map<String, *>.toMessageAIConfigParams(): V2NIMMessageAIConfigParams =
    V2NIMMessageAIConfigParams(this["accountId"] as? String).apply {
        this.content = (this@toMessageAIConfigParams["content"] as? Map<String, *>)?.toAIModelCallContent()
        this.messages = (this@toMessageAIConfigParams["messages"] as? List<Map<String, *>?>)?.map { it?.toAIModelCallMessage() }
        this.promptVariables = this@toMessageAIConfigParams["promptVariables"] as? String
        this.modelConfigParams = (this@toMessageAIConfigParams["modelConfigParams"] as? Map<String, *>)?.toAIModelConfigParams()
    }

fun V2NIMMessageAIConfigParams.toMap(): Map<String, Any?> =
    mapOf(
        "accountId" to this.accountId,
        "content" to this.content?.toMap(),
        "messages" to this.messages.map { it?.toMap() },
        "promptVariables" to this.promptVariables,
        "modelConfigParams" to this.modelConfigParams?.toMap()
    )

fun Map<String, *>.toAIModelCallContent(): V2NIMAIModelCallContent =
    V2NIMAIModelCallContent().apply {
        this.msg = this@toAIModelCallContent["msg"] as? String
        this.type = this@toAIModelCallContent["type"] as? Int
    }

fun V2NIMAIModelCallContent.toMap(): Map<String, Any?> =
    mapOf(
        "msg" to this.msg,
        "type" to this.type
    )

fun aiModelRoleTypeFromInt(value: Int): V2NIMAIModelRoleType {
    if (value == 0) {
        return V2NIMAIModelRoleType.V2NIM_AI_MODEL_ROLE_TYPE_SYSTEM
    } else if (value == 1) {
        return V2NIMAIModelRoleType.V2NIM_AI_MODEL_ROLE_TYPE_USER
    } else if (value == 2) {
        return V2NIMAIModelRoleType.V2NIM_AI_MODEL_ROLE_TYPE_ASSISTANT
    } else {
        return V2NIMAIModelRoleType.V2NIM_AI_MODEL_ROLE_TYPE_SYSTEM
    }
}

fun aiModelRoleTypeToInt(value: V2NIMAIModelRoleType): Int {
    if (value == V2NIMAIModelRoleType.V2NIM_AI_MODEL_ROLE_TYPE_SYSTEM) {
        return 0
    } else if (value == V2NIMAIModelRoleType.V2NIM_AI_MODEL_ROLE_TYPE_USER) {
        return 1
    } else if (value == V2NIMAIModelRoleType.V2NIM_AI_MODEL_ROLE_TYPE_ASSISTANT) {
        return 2
    } else {
        return 0
    }
}

fun Map<String, *>.toAIModelCallMessage(): V2NIMAIModelCallMessage =
    V2NIMAIModelCallMessage().apply {
        this.role = aiModelRoleTypeFromInt(this@toAIModelCallMessage["role"] as? Int ?: 0)
        this.msg = this@toAIModelCallMessage["msg"] as? String
        this.type = this@toAIModelCallMessage["type"] as? Int
    }

fun V2NIMAIModelCallMessage.toMap(): Map<String, Any?> =
    mapOf(
        "role" to aiModelRoleTypeToInt(this.role),
        "msg" to this.msg,
        "type" to this.type
    )

fun Map<String, *>.toAIModelConfigParams(): V2NIMAIModelConfigParams =
    V2NIMAIModelConfigParams().apply {
        this.prompt = this@toAIModelConfigParams["prompt"] as? String
        this.maxTokens = this@toAIModelConfigParams["maxTokens"] as? Int
        this.topP = this@toAIModelConfigParams["topP"] as? Double
        this.temperature = this@toAIModelConfigParams["temperature"] as? Double
    }

fun V2NIMAIModelConfigParams.toMap(): Map<String, Any?> =
    mapOf(
        "prompt" to this.prompt,
        "maxTokens" to this.maxTokens,
        "topP" to this.topP,
        "temperature" to this.temperature
    )

fun Map<String, *>.toSendMessageParams(): V2NIMSendMessageParams =
    V2NIMSendMessageParamsBuilder
        .builder()
        .withMessageConfig((this["messageConfig"] as? Map<String, *>)?.toMessageConfig())
        .withRouteConfig((this["routeConfig"] as? Map<String, *>)?.toMessageRouteConfig())
        .withPushConfig((this["pushConfig"] as? Map<String, *>)?.toMessagePushConfig())
        .withAntispamConfig((this["antispamConfig"] as? Map<String, *>)?.toMessageAntispamConfig())
        .withRobotConfig((this["robotConfig"] as? Map<String, *>)?.toMessageRobotConfig())
        .withAIConfig((this["aiConfig"] as? Map<String, *>)?.toMessageAIConfigParams())
        .withClientAntispamEnabled(this["clientAntispamEnabled"] as? Boolean ?: false)
        .withClientAntispamReplace(this["clientAntispamReplace"] as? String)
        .build()

fun V2NIMSendMessageParams.toMap(): Map<String, Any?> =
    mapOf(
        "messageConfig" to this.messageConfig?.toMap(),
        "routeConfig" to this.routeConfig?.toMap(),
        "pushConfig" to this.pushConfig?.toMap(),
        "antispamConfig" to this.antispamConfig?.toMap(),
        "robotConfig" to this.robotConfig?.toMap(),
        "aiConfig" to this.aiConfig?.toMap(),
        "clientAntispamEnabled" to this.isClientAntispamEnabled,
        "clientAntispamReplace" to this.clientAntispamReplace
    )

fun V2NIMSendMessageResult.toMap(): Map<String, Any?> =
    mapOf(
        "message" to this.message?.toMap(),
        "antispamResult" to this.antispamResult,
        "clientAntispamResult" to this.clientAntispamResult?.toMap()
    )

fun V2NIMClientAntispamResult.toMap(): Map<String, Any?> =
    mapOf(
        "operateType" to this.operateType?.value,
        "replacedText" to this.replacedText
    )

fun Map<String, *>.toMessageListOption(): V2NIMMessageListOption =
    V2NIMMessageListOptionBuilder
        .builder(this["conversationId"] as? String)
        .withMessageTypes((this["messageTypes"] as? List<Int>)?.map { V2NIMMessageType.typeOfValue(it) })
        .withBeginTime(this["beginTime"] as? Long ?: 0)
        .withEndTime(this["endTime"] as? Long ?: 0)
        .withLimit(this["limit"] as? Int ?: 50)
        .withAnchorMessage((this["anchorMessage"] as? Map<String, *>)?.toMessage())
        .withDirection(V2NIMMessageQueryDirection.typeOfValue(this["direction"] as? Int ?: 0))
        .withStrictMode(this["strictMode"] as? Boolean ?: false)
        .build()

fun V2NIMMessageListOption.toMap(): Map<String, Any?> =
    mapOf(
        "conversationId" to this.conversationId,
        "messageTypes" to this.messageTypes.map { it?.value },
        "beginTime" to this.beginTime,
        "endTime" to this.endTime,
        "limit" to this.limit,
        "anchorMessage" to this.anchorMessage?.toMap(),
        "direction" to this.direction?.value,
        "strictMode" to this.isStrictMode
    )

fun Map<String, *>.toClearHistoryMessageOption(): V2NIMClearHistoryMessageOption =
    V2NIMClearHistoryMessageOptionBuilder
        .builder(this["conversationId"] as String)
        .withDeleteRoam(this["deleteRoam"] as? Boolean ?: true)
        .withOnlineSync(this["onlineSync"] as? Boolean ?: false)
        .withExtension(this["serverExtension"] as? String)
        .build()

fun V2NIMClearHistoryMessageOption.toMap(): Map<String, Any?> =
    mapOf(
        "conversationId" to this.conversationId,
        "deleteRoam" to this.isDeleteRoam,
        "onlineSync" to this.isOnlineSync,
        "serverExtension" to this.serverExtension
    )

fun V2NIMMessageDeletedNotification.toMap(): Map<String, Any?> =
    mapOf(
        "messageRefer" to this.messageRefer?.toMap(),
        "deleteTime" to this.deleteTime,
        "serverExtension" to this.serverExtension
    )

fun V2NIMMessagePin.toMap(): Map<String, Any?> =
    mapOf(
        "messageRefer" to this.messageRefer?.toMap(),
        "operatorId" to this.operatorId,
        "serverExtension" to this.serverExtension,
        "createTime" to this.createTime,
        "updateTime" to this.updateTime
    )

fun V2NIMMessagePinNotification.toMap(): Map<String, Any?> =
    mapOf(
        "pin" to this.pin?.toMap(),
        "pinState" to this.pinState?.value
    )

fun V2NIMMessageQuickComment.toMap(): Map<String, Any?> =
    mapOf(
        "messageRefer" to this.messageRefer?.toMap(),
        "operatorId" to this.operatorId,
        "index" to this.index,
        "createTime" to this.createTime,
        "serverExtension" to this.serverExtension
    )

fun V2NIMMessageQuickCommentNotification.toMap(): Map<String, Any?> =
    mapOf(
        "operationType" to this.operationType?.value,
        "quickComment" to this.quickComment?.toMap()
    )

fun Map<String, *>.toMessageQuickCommentPushConfig(): V2NIMMessageQuickCommentPushConfig =
    V2NIMMessageQuickCommentPushConfigBuilder
        .builder()
        .withPushEnabled(this["pushEnabled"] as? Boolean ?: true)
        .withNeedBadge(this["needBadge"] as? Boolean ?: true)
        .withPushTitle(this["pushTitle"] as? String)
        .withPushContent(this["pushContent"] as? String)
        .withPushPayload(this["pushPayload"] as? String)
        .build()

fun V2NIMMessageQuickCommentPushConfig.toMap(): Map<String, Any?> =
    mapOf(
        "pushEnabled" to this.pushEnabled,
        "needBadge" to this.needBadge,
        "pushTitle" to this.pushTitle,
        "pushContent" to this.pushContent,
        "pushPayload" to this.pushPayload
    )

fun V2NIMMessageRevokeNotification.toMap(): Map<String, Any?> =
    mapOf(
        "messageRefer" to this.messageRefer?.toMap(),
        "serverExtension" to this.serverExtension,
        "revokeAccountId" to this.revokeAccountId,
        "postscript" to this.postscript,
        "revokeType" to this.revokeType?.value,
        "callbackExtension" to this.callbackExtension
    )

fun Map<String, *>.toMessageRevokeParams(): V2NIMMessageRevokeParams =
    V2NIMMessageRevokeParamsBuilder
        .builder()
        .withPostscript(this["postscript"] as? String)
        .withExtension(this["serverExtension"] as? String)
        .withPushContent(this["pushContent"] as? String)
        .withPushPayload(this["pushPayload"] as? String)
        .withEnv(this["env"] as? String)
        .build()

fun V2NIMMessageRevokeParams.toMap(): Map<String, Any?> =
    mapOf(
        "postscript" to this.postscript,
        "serverExtension" to this.serverExtension,
        "pushContent" to this.pushContent,
        "pushPayload" to this.pushPayload,
        "env" to this.env
    )

fun Map<String, *>.toMessageSearchParams(): V2NIMMessageSearchParams =
    V2NIMMessageSearchParamsBuilder
        .builder(this["keyword"] as? String)
        .withBeginTime(this["beginTime"] as? Long ?: 0)
        .withEndTime(this["endTime"] as? Long ?: 0)
        .withConversationLimit(this["conversationLimit"] as? Int ?: 0)
        .withMessageLimit(this["messageLimit"] as? Int ?: 10)
        .withSortOrder(V2NIMSortOrder.typeOfValue(this["sortOrder"] as? Int ?: 0))
        .withP2pAccountIds(this["p2pAccountIds"] as? List<String>)
        .withTeamIds(this["teamIds"] as? List<String>)
        .withSenderAccountIds(this["senderAccountIds"] as? List<String>)
        .withMessageTypes((this["messageTypes"] as? List<Int>)?.map { V2NIMMessageType.typeOfValue(it) })
        .withMessageSubtypes(this["messageSubtypes"] as? List<Int>)
        .build()

fun V2NIMMessageSearchParams.toMap(): Map<String, Any?> =
    mapOf(
        "keyword" to this.keyword,
        "beginTime" to this.beginTime,
        "endTime" to this.endTime,
        "conversationLimit" to this.conversationLimit,
        "messageLimit" to this.messageLimit,
        "sortOrder" to this.sortOrder,
        "p2pAccountIds" to this.p2pAccountIds,
        "teamIds" to this.teamIds,
        "senderAccountIds" to this.senderAccountIds,
        "messageTypes" to this.messageTypes.map { it?.value },
        "messageSubtypes" to this.messageSubtypes
    )

fun Map<String, *>.toNotificationAntispamConfig(): V2NIMNotificationAntispamConfig =
    V2NIMNotificationAntispamConfigBuilder
        .builder()
        .withAntispamEnabled(this["antispamEnabled"] as? Boolean ?: true)
        .withAntispamCustomNotification(this["antispamCustomNotification"] as? String)
        .build()

fun V2NIMNotificationAntispamConfig.toMap(): Map<String, Any?> =
    mapOf(
        "antispamEnabled" to this.isAntispamEnabled,
        "antispamCustomNotification" to this.antispamCustomNotification
    )

fun Map<String, *>.toNotificationConfig(): V2NIMNotificationConfig =
    V2NIMNotificationConfigBuilder
        .builder()
        .withOfflineEnabled(this["offlineEnabled"] as? Boolean ?: true)
        .withUnreadEnabled(this["unreadEnabled"] as? Boolean ?: true)
        .build()

fun V2NIMNotificationConfig.toMap(): Map<String, Any?> =
    mapOf(
        "offlineEnabled" to this.isOfflineEnabled,
        "unreadEnabled" to this.isUnreadEnabled
    )

fun Map<String, *>.toNotificationPushConfig(): V2NIMNotificationPushConfig =
    V2NIMNotificationPushConfigBuilder
        .builder()
        .withPushEnabled(this["pushEnabled"] as? Boolean ?: true)
        .withPushNickEnabled(this["pushNickEnabled"] as? Boolean ?: true)
        .withPushContent(this["pushContent"] as? String)
        .withPushPayload(this["pushPayload"] as? String)
        .withForcePush(this["forcePush"] as? Boolean ?: false)
        .withForcePushContent(this["forcePushContent"] as? String)
        .withForcePushAccountIds(this["forcePushAccountIds"] as? List<String>)
        .build()

fun V2NIMNotificationPushConfig.toMap(): Map<String, Any?> =
    mapOf(
        "pushEnabled" to this.isPushEnabled,
        "pushNickEnabled" to this.isPushNickEnabled,
        "pushContent" to this.pushContent,
        "pushPayload" to this.pushPayload,
        "forcePush" to this.isForcePush,
        "forcePushContent" to this.forcePushContent,
        "forcePushAccountIds" to this.forcePushAccountIds
    )

fun Map<String, *>.toNotificationRouteConfig(): V2NIMNotificationRouteConfig =
    V2NIMNotificationRouteConfigBuilder
        .builder()
        .withRouteEnabled(this["routeEnabled"] as? Boolean ?: true)
        .withRouteEnvironment(this["routeEnvironment"] as? String)
        .build()

fun V2NIMNotificationRouteConfig.toMap(): Map<String, Any?> =
    mapOf(
        "routeEnabled" to this.isRouteEnabled,
        "routeEnvironment" to this.routeEnvironment
    )

fun V2NIMP2PMessageReadReceipt.toMap(): Map<String, Any?> =
    mapOf(
        "conversationId" to this.conversationId,
        "timestamp" to this.timestamp
    )

fun Map<String, *>.toSendCustomNotificationParams(): V2NIMSendCustomNotificationParams =
    V2NIMSendCustomNotificationParamsBuilder
        .builder()
        .withNotificationConfig((this["notificationConfig"] as? Map<String, *>)?.toNotificationConfig())
        .withPushConfig((this["pushConfig"] as? Map<String, *>)?.toNotificationPushConfig())
        .withAntispamConfig((this["antispamConfig"] as? Map<String, *>)?.toNotificationAntispamConfig())
        .withRouteConfig((this["routeConfig"] as? Map<String, *>)?.toNotificationRouteConfig())
        .build()

fun V2NIMSendCustomNotificationParams.toMap(): Map<String, Any?> =
    mapOf(
        "notificationConfig" to this.notificationConfig?.toMap(),
        "pushConfig" to this.pushConfig?.toMap(),
        "antispamConfig" to this.antispamConfig?.toMap(),
        "routeConfig" to this.routeConfig?.toMap()
    )

fun V2NIMTeamMessageReadReceipt.toMap(): Map<String, Any?> =
    mapOf(
        "conversationId" to this.conversationId,
        "messageServerId" to this.messageServerId,
        "messageClientId" to this.messageClientId,
        "readCount" to this.readCount,
        "unreadCount" to this.unreadCount,
        "latestReadAccount" to this.latestReadAccount
    )

fun V2NIMTeamMessageReadReceiptDetail.toMap(): Map<String, Any?> =
    mapOf(
        "readReceipt" to this.readReceipt?.toMap(),
        "readAccountList" to this.readAccountList,
        "unreadAccountList" to this.unreadAccountList
    )

fun Map<String, *>.toThreadMessageListOption(): V2NIMThreadMessageListOption =
    V2NIMThreadMessageListOption().apply {
        this.messageRefer = (this@toThreadMessageListOption["messageRefer"] as? Map<String, *>)?.toMessageRefer()
        this.beginTime = this@toThreadMessageListOption["beginTime"] as? Long ?: 0
        this.endTime = this@toThreadMessageListOption["endTime"] as? Long ?: 0
        this.excludeMessageServerId = this@toThreadMessageListOption["excludeMessageServerId"] as? String
        this.limit = this@toThreadMessageListOption["limit"] as? Int ?: 50
        this.direction = V2NIMQueryDirection.typeOfValue(this@toThreadMessageListOption["direction"] as? Int ?: 0)
    }

fun V2NIMThreadMessageListOption.toMap(): Map<String, Any?> =
    mapOf(
        "messageRefer" to this.messageRefer?.toMap(),
        "beginTime" to this.beginTime,
        "endTime" to this.endTime,
        "excludeMessageServerId" to this.excludeMessageServerId,
        "limit" to this.limit,
        "direction" to this.direction?.value
    )

fun V2NIMThreadMessageListResult.toMap(): Map<String, Any?> =
    mapOf(
        "message" to this.message?.toMap(),
        "timestamp" to this.timestamp,
        "replyCount" to this.replyCount,
        "replyList" to this.replyList.map { it?.toMap() }
    )

fun Map<String, *>.toVoiceToTextParams(): V2NIMVoiceToTextParams =
    V2NIMVoiceToTextParamsBuilder
        .builder((this["duration"] as? Int ?: 0).toLong())
        .withVoicePath(this["voicePath"] as? String)
        .withVoiceUrl(this["voiceUrl"] as? String)
        .withMimeType(this["mimeType"] as? String)
        .withSampleRate(this["sampleRate"] as? String)
        .withSceneName(this["sceneName"] as? String)
        .build()

fun V2NIMVoiceToTextParams.toMap(): Map<String, Any?> =
    mapOf(
        "voicePath" to this.voicePath,
        "voiceUrl" to this.voiceUrl,
        "mimeType" to this.mimeType,
        "sampleRate" to this.sampleRate,
        "duration" to this.duration,
        "sceneName" to this.sceneName
    )

fun Map<String, *>.toCollection(): V2NIMCollection =
    V2NIMCollectionBuilder
        .builder()
        .setCollectionId(this["collectionId"] as? String)
        .setCollectionType(this["collectionType"] as? Int ?: 0)
        .setCollectionData(this["collectionData"] as? String)
        .setServerExtension(this["serverExtension"] as? String)
        .setCreateTime(this["createTime"] as? Long ?: 0)
        .setUpdateTime(this["updateTime"] as? Long ?: 0)
        .setUniqueId(this["uniqueId"] as? String)
        .build()

fun V2NIMCollection.toMap(): Map<String, Any?> =
    mapOf(
        "collectionId" to this.collectionId,
        "collectionType" to this.collectionType,
        "collectionData" to this.collectionData,
        "serverExtension" to this.serverExtension,
        "createTime" to this.createTime,
        "updateTime" to this.updateTime,
        "uniqueId" to this.uniqueId
    )

fun Map<String, *>.toAddCollectionParams(): V2NIMAddCollectionParams =
    V2NIMAddCollectionParamsBuilder
        .builder(
            this["collectionType"] as? Int ?: 0,
            this["collectionData"] as? String
        ).withServerExtension(this["serverExtension"] as? String)
        .withUniqueId(this["uniqueId"] as? String)
        .build()

fun V2NIMAddCollectionParams.toMap(): Map<String, Any?> =
    mapOf(
        "collectionType" to this.collectionType,
        "collectionData" to this.collectionData,
        "serverExtension" to this.serverExtension,
        "uniqueId" to this.uniqueId
    )

fun Map<String, *>.toCollectionOption(): V2NIMCollectionOption =
    V2NIMCollectionOptionBuilder
        .builder()
        .withBeginTime(this["beginTime"] as? Long ?: 0)
        .withEndTime(this["endTime"] as? Long ?: 0)
        .withDirection(V2NIMQueryDirection.typeOfValue(this["direction"] as? Int ?: 0))
        .withAnchorCollection((this["anchorCollection"] as? Map<String, *>)?.toCollection())
        .withLimit(this["limit"] as? Int ?: 0)
        .withCollectionType(this["collectionType"] as? Int ?: 0)
        .build()

fun V2NIMCollectionOption.toMap(): Map<String, Any?> =
    mapOf(
        "beginTime" to this.beginTime,
        "endTime" to this.endTime,
        "direction" to this.direction?.value,
        "anchorCollection" to this.anchorCollection?.toMap(),
        "limit" to this.limit,
        "collectionType" to this.collectionType
    )

fun V2NIMClearHistoryNotification.toMap(): Map<String, Any?> =
    mapOf(
        "conversationId" to this.conversationId,
        "deleteTime" to this.deleteTime,
        "serverExtension" to this.serverExtension
    )
