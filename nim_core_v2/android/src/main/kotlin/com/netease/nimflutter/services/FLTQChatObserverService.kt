/*
 * Copyright (c) 2022 NetEase, Inc. All rights reserved.
 * Use of this source code is governed by a MIT license that can be
 * found in the LICENSE file.
 */

package com.netease.nimflutter.services

import android.content.Context
import com.netease.nimflutter.FLTService
import com.netease.nimflutter.NimCore
import com.netease.nimflutter.stringFromQChatKickOutReason
import com.netease.nimflutter.stringFromQChatMultiSpotNotifyType
import com.netease.nimflutter.toMap
import com.netease.nimlib.sdk.NIMClient
import com.netease.nimlib.sdk.Observer
import com.netease.nimlib.sdk.msg.model.AttachmentProgress
import com.netease.nimlib.sdk.qchat.QChatServiceObserver
import com.netease.nimlib.sdk.qchat.event.QChatKickedOutEvent
import com.netease.nimlib.sdk.qchat.event.QChatMessageDeleteEvent
import com.netease.nimlib.sdk.qchat.event.QChatMessageRevokeEvent
import com.netease.nimlib.sdk.qchat.event.QChatMessageUpdateEvent
import com.netease.nimlib.sdk.qchat.event.QChatMultiSpotLoginEvent
import com.netease.nimlib.sdk.qchat.event.QChatServerUnreadInfoChangedEvent
import com.netease.nimlib.sdk.qchat.event.QChatStatusChangeEvent
import com.netease.nimlib.sdk.qchat.event.QChatSystemNotificationUpdateEvent
import com.netease.nimlib.sdk.qchat.event.QChatUnreadInfoChangedEvent
import com.netease.nimlib.sdk.qchat.model.QChatMessage
import com.netease.nimlib.sdk.qchat.model.QChatServerUnreadInfo
import com.netease.nimlib.sdk.qchat.model.QChatSystemNotification
import com.netease.nimlib.sdk.qchat.model.QChatTypingEvent

class FLTQChatObserverService(
    applicationContext: Context,
    nimCore: NimCore
) : FLTService(applicationContext, nimCore) {

    override val serviceName = "QChatObserver"

    init {
        nimCore.onInitialized {
            NIMClient.getService(QChatServiceObserver::class.java).apply {
                observeStatusChange(statusChanged, true)
                observeMultiSpotLogin(multiSpotLogin, true)
                observeKickedOut(onKickedOut, true)
                observeReceiveMessage(onReceiveMessage, true)
                observeMessageUpdate(onMessageUpdate, true)
                observeMessageRevoke(onMessageRevoke, true)
                observeMessageDelete(onMessageDelete, true)
                observeUnreadInfoChanged(onUnreadInfoChanged, true)
                observeMessageStatusChange(onMessageStatusChange, true)
                observeAttachmentProgress(onAttachmentProgress, true)
                observeReceiveSystemNotification(onReceiveSystemNotification, true)
                observeSystemNotificationUpdate(onSystemNotificationUpdate, true)
                observeServerUnreadInfoChanged(serverUnreadInfoChanged, true)
                observeReceiveTypingEvent(onReceiveTypingEvent, true)
            }
        }
    }

    private val statusChanged = Observer<QChatStatusChangeEvent> { event ->
        run {
            notifyEvent("onStatusChange", event.toMap() as MutableMap<String, Any?>)
        }
    }

    private val multiSpotLogin = Observer<QChatMultiSpotLoginEvent> { event ->
        run {
            notifyEvent("onMultiSpotLogin", event.toMap() as MutableMap<String, Any?>)
        }
    }

    private fun QChatMultiSpotLoginEvent.toMap() = mapOf<String, Any?>(
        "notifyType" to stringFromQChatMultiSpotNotifyType(notifyType),
        "otherClient" to otherClient?.toMap()
    )

    private val onKickedOut = Observer<QChatKickedOutEvent> { event ->
        run {
            notifyEvent("onKickedOut", event.toMap() as MutableMap<String, Any?>)
        }
    }

    private fun QChatKickedOutEvent.toMap() = mapOf<String, Any?>(
        "clientType" to clientType,
        "kickReason" to stringFromQChatKickOutReason(kickReason),
        "extension" to extension,
        "customClientType" to customClientType
    )

    private val onReceiveMessage = Observer<List<QChatMessage>> { event ->
        run {
            notifyEvent(
                "onReceiveMessage",
                mutableMapOf("eventList" to event.map { it.toMap() }.toList())
            )
        }
    }

    private val onMessageUpdate = Observer<QChatMessageUpdateEvent> { event ->
        run {
            notifyEvent(
                "onMessageUpdate",
                event.toMap() as MutableMap<String, Any?>
            )
        }
    }

    fun QChatMessageUpdateEvent.toMap() = mapOf<String, Any?>(
        "msgUpdateInfo" to msgUpdateInfo?.toMap(),
        "message" to message?.toMap()
    )

    private val onMessageRevoke = Observer<QChatMessageRevokeEvent> { event ->
        run {
            notifyEvent(
                "onMessageRevoke",
                event.toMap() as MutableMap<String, Any?>
            )
        }
    }

    fun QChatMessageRevokeEvent.toMap() = mapOf<String, Any?>(
        "msgUpdateInfo" to msgUpdateInfo?.toMap(),
        "message" to message?.toMap()
    )

    private val onMessageDelete = Observer<QChatMessageDeleteEvent> { event ->
        run {
            notifyEvent(
                "onMessageDelete",
                event.toMap() as MutableMap<String, Any?>
            )
        }
    }

    fun QChatMessageDeleteEvent.toMap() = mapOf<String, Any?>(
        "msgUpdateInfo" to msgUpdateInfo?.toMap(),
        "message" to message?.toMap()
    )

    private val onUnreadInfoChanged = Observer<QChatUnreadInfoChangedEvent> { event ->
        run {
            notifyEvent(
                "onUnreadInfoChanged",
                event.toMap() as MutableMap<String, Any?>
            )
        }
    }

    fun QChatUnreadInfoChangedEvent.toMap() = mapOf<String, Any?>(
        "unreadInfos" to unreadInfos?.map { e -> e.toMap() }?.toList(),
        "lastUnreadInfos" to lastUnreadInfos?.map { e -> e.toMap() }?.toList()
    )

    private val onMessageStatusChange = Observer<QChatMessage> { event ->
        run {
            notifyEvent(
                "onMessageStatusChange",
                event.toMap() as MutableMap<String, Any?>
            )
        }
    }

    private val onAttachmentProgress = Observer<AttachmentProgress> { event ->
        run {
            notifyEvent(
                "onAttachmentProgress",
                event.toMap() as MutableMap<String, Any?>
            )
        }
    }

    private val onReceiveSystemNotification = Observer<List<QChatSystemNotification>> { event ->
        run {
            notifyEvent(
                "onReceiveSystemNotification",
                mutableMapOf("eventList" to event.map { it.toMap() }.toList())
            )
        }
    }

    private val onSystemNotificationUpdate = Observer<QChatSystemNotificationUpdateEvent> { event ->
        run {
            notifyEvent(
                "onSystemNotificationUpdate",
                event.toMap() as MutableMap<String, Any?>
            )
        }
    }

    fun QChatSystemNotificationUpdateEvent.toMap() = mapOf<String, Any?>(
        "msgUpdateInfo" to msgUpdateInfo?.toMap(),
        "systemNotification" to systemNotification?.toMap()
    )

    private val serverUnreadInfoChanged = Observer<QChatServerUnreadInfoChangedEvent> { event ->
        run {
            notifyEvent(
                "serverUnreadInfoChanged",
                event.toMap() as MutableMap<String, Any?>
            )
        }
    }

    fun QChatServerUnreadInfoChangedEvent.toMap() = mapOf<String, Any?>(
        "serverUnreadInfos" to serverUnreadInfos?.map { it.toMap() }?.toList()
    )

    fun QChatServerUnreadInfo.toMap() = mapOf<String, Any?>(
        "serverId" to serverId,
        "unreadCount" to unreadCount,
        "mentionedCount" to mentionedCount,
        "maxCount" to maxCount
    )

    private val onReceiveTypingEvent = Observer<QChatTypingEvent> { event ->
        notifyEvent("onReceiveTypingEvent", event.toMap())
    }

    fun QChatTypingEvent.toMap() = mapOf<String, Any?>(
        "serverId" to serverId,
        "channelId" to channelId,
        "fromAccount" to fromAccount,
        "fromNick" to fromNick,
        "time" to time,
        "extension" to extension
    )
}
