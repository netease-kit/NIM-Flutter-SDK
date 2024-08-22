/*
 * Copyright (c) 2022 NetEase, Inc. All rights reserved.
 * Use of this source code is governed by a MIT license that can be
 * found in the LICENSE file.
 */

package com.netease.nimflutter.services

import android.content.Context
import android.text.TextUtils
import com.netease.nimflutter.FLTService
import com.netease.nimflutter.NimCore
import com.netease.nimflutter.NimResult
import com.netease.nimlib.sdk.msg.constant.SessionTypeEnum
import com.netease.nimlib.sdk.v2.conversation.enums.V2NIMConversationType
import com.netease.nimlib.sdk.v2.utils.V2NIMConversationIdUtil

class FLTConversationIdUtil(
    applicationContext: Context,
    nimCore: NimCore
) : FLTService(applicationContext, nimCore) {
    private val tag = "FLTConversationIdUtil"
    override val serviceName = "ConversationIdUtil"

    init {
        registerFlutterMethodCalls(
            "conversationId" to ::conversationId,
            "p2pConversationId" to ::p2pConversationId,
            "teamConversationId" to ::teamConversationId,
            "superTeamConversationId" to ::superTeamConversationId,
            "conversationType" to ::conversationType,
            "conversationTargetId" to ::conversationTargetId,
            "isConversationIdValid" to ::isConversationIdValid,
            "sessionTypeV1" to ::sessionTypeV1
        )
    }

    private suspend fun conversationId(
        arguments: Map<String, *>
    ): NimResult<String> {
        val targetId = arguments["targetId"] as? String
        val type =
            (arguments["conversationType"] as? Int)?.let {
                V2NIMConversationType.typeOfValue(it)
            }

        val sessionId = arguments["sessionId"] as? String
        val sessionType =
            (arguments["sessionType"] as? Int)?.let {
                SessionTypeEnum.typeOfValue(it)
            }
        return if (!TextUtils.isEmpty(targetId) && type != null) {
            NimResult(code = 0, data = V2NIMConversationIdUtil.conversationId(targetId, type))
        } else if (!TextUtils.isEmpty(sessionId) && sessionType != null) {
            NimResult(code = 0, data = V2NIMConversationIdUtil.conversationId(sessionId, sessionType))
        } else {
            NimResult(code = -1, data = "Invalid arguments")
        }
    }

    private suspend fun p2pConversationId(
        arguments: Map<String, *>
    ): NimResult<String> {
        val accountId = arguments["accountId"] as? String
        val conversationId = V2NIMConversationIdUtil.p2pConversationId(accountId)
        return NimResult(code = 0, data = conversationId)
    }

    private suspend fun teamConversationId(
        arguments: Map<String, *>
    ): NimResult<String> {
        val teamId = arguments["teamId"] as? String
        return NimResult(code = 0, data = V2NIMConversationIdUtil.teamConversationId(teamId))
    }

    private suspend fun superTeamConversationId(
        arguments: Map<String, *>
    ): NimResult<String> {
        val superTeamId = arguments["superTeamId"] as? String
        return NimResult(code = 0, data = V2NIMConversationIdUtil.superTeamConversationId(superTeamId))
    }

    private suspend fun conversationType(
        arguments: Map<String, *>
    ): NimResult<Map<String, Any?>?> {
        val conversationId = arguments["conversationId"] as? String
        val type = V2NIMConversationIdUtil.conversationType(conversationId)
        return NimResult(code = 0, data = mapOf("conversationType" to type.value))
    }

    private suspend fun conversationTargetId(
        arguments: Map<String, *>
    ): NimResult<String> {
        val conversationId = arguments["conversationId"] as? String
        val targetId = V2NIMConversationIdUtil.conversationTargetId(conversationId)
        return NimResult(code = 0, data = targetId)
    }

    private suspend fun isConversationIdValid(
        arguments: Map<String, *>
    ): NimResult<Boolean> {
        val conversationId = arguments["conversationId"] as? String
        return NimResult(code = 0, data = V2NIMConversationIdUtil.isConversationIdValid(conversationId))
    }

    private suspend fun sessionTypeV1(
        arguments: Map<String, *>
    ): NimResult<Map<String, Any?>?> {
        val type =
            (arguments["conversationType"] as? Int)?.let {
                V2NIMConversationType.typeOfValue(it)
            }
        val sessionType = V2NIMConversationIdUtil.sessionTypeV1(type)
        return NimResult(code = 0, data = mapOf("SessionType" to sessionType?.value))
    }
}
