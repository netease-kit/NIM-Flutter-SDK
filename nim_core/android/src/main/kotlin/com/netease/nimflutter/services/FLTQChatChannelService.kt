/*
 * Copyright (c) 2022 NetEase, Inc. All rights reserved.
 * Use of this source code is governed by a MIT license that can be
 * found in the LICENSE file.
 */

package com.netease.nimflutter.services

import android.content.Context
import com.netease.nimflutter.FLTService
import com.netease.nimflutter.NimCore
import com.netease.nimflutter.NimResult
import com.netease.nimflutter.NimResultContinuationCallback
import com.netease.nimflutter.NimResultContinuationCallbackOfNothing
import com.netease.nimflutter.stringToQChatChannelBlackWhiteType
import com.netease.nimflutter.stringToQChatSubscribeOperateType
import com.netease.nimflutter.toMap
import com.netease.nimflutter.toQChatChannelIdInfo
import com.netease.nimflutter.toQChatCreateChannelParamParam
import com.netease.nimflutter.toQChatDeleteChannelParam
import com.netease.nimflutter.toQChatGetChannelBlackWhiteRolesByPageParam
import com.netease.nimflutter.toQChatGetChannelMembersByPageParam
import com.netease.nimflutter.toQChatGetChannelUnreadInfosParam
import com.netease.nimflutter.toQChatGetChannelsByPageParam
import com.netease.nimflutter.toQChatGetChannelsParam
import com.netease.nimflutter.toQChatGetExistingChannelBlackWhiteRolesParam
import com.netease.nimflutter.toQChatPushMsgType
import com.netease.nimflutter.toQChatSearchChannelByPageParam
import com.netease.nimflutter.toQChatSearchChannelMembersParam
import com.netease.nimflutter.toQChatSubscribeChannelParam
import com.netease.nimflutter.toQChatUpdateChannelBlackWhiteMembersParam
import com.netease.nimflutter.toQChatUpdateChannelBlackWhiteRolesParam
import com.netease.nimflutter.toQChatUpdateChannelParam
import com.netease.nimlib.sdk.NIMClient
import com.netease.nimlib.sdk.qchat.QChatChannelService
import com.netease.nimlib.sdk.qchat.enums.QChatSubscribeOperateType
import com.netease.nimlib.sdk.qchat.param.QChatGetChannelBlackWhiteMembersByPageParam
import com.netease.nimlib.sdk.qchat.param.QChatGetChannelCategoriesByPageParam
import com.netease.nimlib.sdk.qchat.param.QChatGetExistingChannelBlackWhiteMembersParam
import com.netease.nimlib.sdk.qchat.param.QChatGetUserChannelPushConfigsParam
import com.netease.nimlib.sdk.qchat.param.QChatSubscribeChannelAsVisitorParam
import com.netease.nimlib.sdk.qchat.param.QChatUpdateUserChannelPushConfigParam
import com.netease.nimlib.sdk.qchat.result.QChatCreateChannelResult
import com.netease.nimlib.sdk.qchat.result.QChatGetChannelBlackWhiteMembersByPageResult
import com.netease.nimlib.sdk.qchat.result.QChatGetChannelBlackWhiteRolesByPageResult
import com.netease.nimlib.sdk.qchat.result.QChatGetChannelCategoriesByPageResult
import com.netease.nimlib.sdk.qchat.result.QChatGetChannelMembersByPageResult
import com.netease.nimlib.sdk.qchat.result.QChatGetChannelUnreadInfosResult
import com.netease.nimlib.sdk.qchat.result.QChatGetChannelsByPageResult
import com.netease.nimlib.sdk.qchat.result.QChatGetChannelsResult
import com.netease.nimlib.sdk.qchat.result.QChatGetExistingChannelBlackWhiteMembersResult
import com.netease.nimlib.sdk.qchat.result.QChatGetExistingChannelBlackWhiteRolesResult
import com.netease.nimlib.sdk.qchat.result.QChatGetUserPushConfigsResult
import com.netease.nimlib.sdk.qchat.result.QChatSearchChannelByPageResult
import com.netease.nimlib.sdk.qchat.result.QChatSearchChannelMembersResult
import com.netease.nimlib.sdk.qchat.result.QChatSubscribeChannelAsVisitorResult
import com.netease.nimlib.sdk.qchat.result.QChatSubscribeChannelResult
import com.netease.nimlib.sdk.qchat.result.QChatUpdateChannelResult
import kotlinx.coroutines.suspendCancellableCoroutine

class FLTQChatChannelService(
    applicationContext: Context,
    nimCore: NimCore
) : FLTService(applicationContext, nimCore) {

    override val serviceName = "QChatChannelService"

    private val qChatChannelService: QChatChannelService by lazy {
        NIMClient.getService(QChatChannelService::class.java)
    }

    init {
        nimCore.onInitialized {
            registerFlutterMethodCalls(
                "createChannel" to ::createChannel,
                "deleteChannel" to ::deleteChannel,
                "updateChannel" to ::updateChannel,
                "getChannels" to ::getChannels,
                "getChannelsByPage" to ::getChannelsByPage,
                "getChannelMembersByPage" to ::getChannelMembersByPage,
                "getChannelUnreadInfos" to ::getChannelUnreadInfos,
                "subscribeChannel" to ::subscribeChannel,
                "searchChannelByPage" to ::searchChannelByPage,
                "searchChannelMembers" to ::searchChannelMembers,
                "updateChannelBlackWhiteRoles" to ::updateChannelBlackWhiteRoles,
                "getChannelBlackWhiteRolesByPage" to ::getChannelBlackWhiteRolesByPage,
                "getExistingChannelBlackWhiteRoles" to ::getExistingChannelBlackWhiteRoles,
                "updateChannelBlackWhiteMembers" to ::updateChannelBlackWhiteMembers,
                "getChannelBlackWhiteMembersByPage" to ::getChannelBlackWhiteMembersByPage,
                "getExistingChannelBlackWhiteMembers" to ::getExistingChannelBlackWhiteMembers,
                "updateUserChannelPushConfig" to ::updateUserChannelPushConfig,
                "getUserChannelPushConfigs" to ::getUserChannelPushConfigs,
                "getChannelCategoriesByPage" to ::getChannelCategoriesByPage,
                "subscribeAsVisitor" to ::subscribeAsVisitor
            )
        }
    }

    private suspend fun createChannel(arguments: Map<String, *>): NimResult<QChatCreateChannelResult> {
        return suspendCancellableCoroutine { cont ->
            qChatChannelService.createChannel(
                arguments.toQChatCreateChannelParamParam()
            ).setCallback(
                NimResultContinuationCallback(cont) { result ->
                    NimResult(
                        code = 0,
                        data = result,
                        convert = { it.toMap() }
                    )
                }
            )
        }
    }

    private suspend fun deleteChannel(arguments: Map<String, *>): NimResult<Nothing> {
        return suspendCancellableCoroutine { cont ->
            qChatChannelService.deleteChannel(
                arguments.toQChatDeleteChannelParam()
            ).setCallback(
                NimResultContinuationCallbackOfNothing(cont)
            )
        }
    }

    private suspend fun updateChannel(arguments: Map<String, *>): NimResult<QChatUpdateChannelResult> {
        return suspendCancellableCoroutine { cont ->
            qChatChannelService.updateChannel(
                arguments.toQChatUpdateChannelParam()
            ).setCallback(
                NimResultContinuationCallback(cont) { result ->
                    NimResult(
                        code = 0,
                        data = result,
                        convert = { it.toMap() }
                    )
                }
            )
        }
    }

    private suspend fun getChannels(arguments: Map<String, *>): NimResult<QChatGetChannelsResult> {
        return suspendCancellableCoroutine { cont ->
            qChatChannelService.getChannels(
                arguments.toQChatGetChannelsParam()
            ).setCallback(
                NimResultContinuationCallback(cont) { result ->
                    NimResult(
                        code = 0,
                        data = result,
                        convert = { it.toMap() }
                    )
                }
            )
        }
    }

    private suspend fun getChannelsByPage(arguments: Map<String, *>): NimResult<QChatGetChannelsByPageResult> {
        return suspendCancellableCoroutine { cont ->
            qChatChannelService.getChannelsByPage(
                arguments.toQChatGetChannelsByPageParam()
            ).setCallback(
                NimResultContinuationCallback(cont) { result ->
                    NimResult(
                        code = 0,
                        data = result,
                        convert = { it.toMap() }
                    )
                }
            )
        }
    }

    private suspend fun getChannelMembersByPage(arguments: Map<String, *>): NimResult<QChatGetChannelMembersByPageResult> {
        return suspendCancellableCoroutine { cont ->
            qChatChannelService.getChannelMembersByPage(
                arguments.toQChatGetChannelMembersByPageParam()
            ).setCallback(
                NimResultContinuationCallback(cont) { result ->
                    NimResult(
                        code = 0,
                        data = result,
                        convert = { it.toMap() }
                    )
                }
            )
        }
    }

    private suspend fun getChannelUnreadInfos(arguments: Map<String, *>): NimResult<QChatGetChannelUnreadInfosResult> {
        return suspendCancellableCoroutine { cont ->
            qChatChannelService.getChannelUnreadInfos(
                arguments.toQChatGetChannelUnreadInfosParam()
            ).setCallback(
                NimResultContinuationCallback(cont) { result ->
                    NimResult(
                        code = 0,
                        data = result,
                        convert = { it.toMap() }
                    )
                }
            )
        }
    }

    private suspend fun subscribeChannel(arguments: Map<String, *>): NimResult<QChatSubscribeChannelResult> {
        return suspendCancellableCoroutine { cont ->
            qChatChannelService.subscribeChannel(
                arguments.toQChatSubscribeChannelParam()
            ).setCallback(
                NimResultContinuationCallback(cont) { result ->
                    NimResult(
                        code = 0,
                        data = result,
                        convert = { it.toMap() }
                    )
                }
            )
        }
    }

    private suspend fun searchChannelByPage(arguments: Map<String, *>): NimResult<QChatSearchChannelByPageResult> {
        return suspendCancellableCoroutine { cont ->
            qChatChannelService.searchChannelByPage(
                arguments.toQChatSearchChannelByPageParam()
            ).setCallback(
                NimResultContinuationCallback(cont) { result ->
                    NimResult(
                        code = 0,
                        data = result,
                        convert = { it.toMap() }
                    )
                }
            )
        }
    }

    private suspend fun searchChannelMembers(arguments: Map<String, *>): NimResult<QChatSearchChannelMembersResult> {
        return suspendCancellableCoroutine { cont ->
            qChatChannelService.searchChannelMembers(
                arguments.toQChatSearchChannelMembersParam()
            ).setCallback(
                NimResultContinuationCallback(cont) { result ->
                    NimResult(
                        code = 0,
                        data = result,
                        convert = { it.toMap() }
                    )
                }
            )
        }
    }

    private suspend fun updateChannelBlackWhiteRoles(arguments: Map<String, *>): NimResult<Nothing> {
        return suspendCancellableCoroutine { cont ->
            qChatChannelService.updateChannelBlackWhiteRoles(
                arguments.toQChatUpdateChannelBlackWhiteRolesParam()
            ).setCallback(
                NimResultContinuationCallbackOfNothing(cont)
            )
        }
    }

    private suspend fun getChannelBlackWhiteRolesByPage(arguments: Map<String, *>): NimResult<QChatGetChannelBlackWhiteRolesByPageResult> {
        return suspendCancellableCoroutine { cont ->
            qChatChannelService.getChannelBlackWhiteRolesByPage(
                arguments.toQChatGetChannelBlackWhiteRolesByPageParam()
            ).setCallback(
                NimResultContinuationCallback(cont) { result ->
                    NimResult(
                        code = 0,
                        data = result,
                        convert = { it.toMap() }
                    )
                }
            )
        }
    }

    private suspend fun getExistingChannelBlackWhiteRoles(arguments: Map<String, *>): NimResult<QChatGetExistingChannelBlackWhiteRolesResult> {
        return suspendCancellableCoroutine { cont ->
            qChatChannelService.getExistingChannelBlackWhiteRoles(
                arguments.toQChatGetExistingChannelBlackWhiteRolesParam()
            ).setCallback(
                NimResultContinuationCallback(cont) { result ->
                    NimResult(
                        code = 0,
                        data = result,
                        convert = { it.toMap() }
                    )
                }
            )
        }
    }

    private suspend fun updateChannelBlackWhiteMembers(arguments: Map<String, *>): NimResult<Nothing> {
        return suspendCancellableCoroutine { cont ->
            qChatChannelService.updateChannelBlackWhiteMembers(
                arguments.toQChatUpdateChannelBlackWhiteMembersParam()
            ).setCallback(
                NimResultContinuationCallbackOfNothing(cont)
            )
        }
    }

    private suspend fun getChannelBlackWhiteMembersByPage(arguments: Map<String, *>): NimResult<QChatGetChannelBlackWhiteMembersByPageResult> {
        return suspendCancellableCoroutine { cont ->
            qChatChannelService.getChannelBlackWhiteMembersByPage(
                arguments.toQChatGetChannelBlackWhiteMembersByPageParam()
            ).setCallback(
                NimResultContinuationCallback(cont) { result ->
                    NimResult(
                        code = 0,
                        data = result,
                        convert = { it.toMap() }
                    )
                }
            )
        }
    }

    private fun Map<String, *>.toQChatGetChannelBlackWhiteMembersByPageParam(): QChatGetChannelBlackWhiteMembersByPageParam {
        val serverId = (this["serverId"] as Number).toLong()
        val channelId = (this["channelId"] as Number).toLong()
        val type = stringToQChatChannelBlackWhiteType(this["type"] as String)!!
        val timeTag = (this["timeTag"] as Number).toLong()
        val param = QChatGetChannelBlackWhiteMembersByPageParam(serverId, channelId, type, timeTag)
        (this["limit"] as Number?)?.toInt()?.let {
            param.limit = it
        }
        return param
    }

    fun QChatGetChannelBlackWhiteMembersByPageResult.toMap() = mapOf<String, Any?>(
        "memberList" to memberList?.map { it.toMap() }?.toList(),
        "hasMore" to isHasMore,
        "nextTimeTag" to nextTimeTag
    )

    private suspend fun getExistingChannelBlackWhiteMembers(arguments: Map<String, *>): NimResult<QChatGetExistingChannelBlackWhiteMembersResult> {
        return suspendCancellableCoroutine { cont ->
            qChatChannelService.getExistingChannelBlackWhiteMembers(
                arguments.toQChatGetExistingChannelBlackWhiteMembersParam()
            ).setCallback(
                NimResultContinuationCallback(cont) { result ->
                    NimResult(
                        code = 0,
                        data = result,
                        convert = { it.toMap() }
                    )
                }
            )
        }
    }

    @Suppress("UNCHECKED_CAST")
    private fun Map<String, *>.toQChatGetExistingChannelBlackWhiteMembersParam(): QChatGetExistingChannelBlackWhiteMembersParam {
        val serverId = (this["serverId"] as Number).toLong()
        val channelId = (this["channelId"] as Number).toLong()
        val type = stringToQChatChannelBlackWhiteType(this["type"] as String)!!
        val accids = (this["accids"] as List<String>)
        return QChatGetExistingChannelBlackWhiteMembersParam(serverId, channelId, type, accids)
    }

    fun QChatGetExistingChannelBlackWhiteMembersResult.toMap() = mapOf<String, Any?>(
        "memberList" to memberList?.map { it.toMap() }?.toList()
    )

    private suspend fun updateUserChannelPushConfig(arguments: Map<String, *>): NimResult<Nothing> {
        return suspendCancellableCoroutine { cont ->
            qChatChannelService.updateUserChannelPushConfig(
                arguments.toQChatUpdateUserChannelPushConfigParam()
            ).setCallback(
                NimResultContinuationCallbackOfNothing(cont)
            )
        }
    }

    private fun Map<String, *>.toQChatUpdateUserChannelPushConfigParam(): QChatUpdateUserChannelPushConfigParam {
        val serverId = (this["serverId"] as Number).toLong()
        val channelId = (this["channelId"] as Number).toLong()
        val type = (this["pushMsgType"] as String).toQChatPushMsgType()!!
        return QChatUpdateUserChannelPushConfigParam(serverId, channelId, type)
    }

    private suspend fun getUserChannelPushConfigs(arguments: Map<String, *>): NimResult<QChatGetUserPushConfigsResult> {
        return suspendCancellableCoroutine { cont ->
            qChatChannelService.getUserChannelPushConfigs(
                arguments.toQChatGetUserChannelPushConfigsParam()
            ).setCallback(
                NimResultContinuationCallback(cont) { result ->
                    NimResult(
                        code = 0,
                        data = result,
                        convert = { it.toMap() }
                    )
                }
            )
        }
    }

    @Suppress("UNCHECKED_CAST")
    private fun Map<String, *>.toQChatGetUserChannelPushConfigsParam(): QChatGetUserChannelPushConfigsParam {
        val channelIdInfos =
            (this["channelIdInfos"] as List<Map<String, *>?>).map { it?.toQChatChannelIdInfo() }
        return QChatGetUserChannelPushConfigsParam(channelIdInfos)
    }

    private suspend fun getChannelCategoriesByPage(arguments: Map<String, *>): NimResult<QChatGetChannelCategoriesByPageResult> {
        return suspendCancellableCoroutine { cont ->
            qChatChannelService.getChannelCategoriesByPage(
                arguments.toQChatGetChannelCategoriesByPageParam()
            ).setCallback(
                NimResultContinuationCallback(cont) { result ->
                    NimResult(
                        code = 0,
                        data = result,
                        convert = { it.toMap() }
                    )
                }
            )
        }
    }

    fun QChatGetChannelCategoriesByPageResult.toMap() = mapOf<String, Any?>(
        "categories" to categories?.map { it.toMap() }?.toList(),
        "hasMore" to isHasMore,
        "nextTimeTag" to nextTimeTag
    )

    private fun Map<String, *>.toQChatGetChannelCategoriesByPageParam(): QChatGetChannelCategoriesByPageParam {
        val serverId = (this["serverId"] as Number).toLong()
        val timeTag = (this["timeTag"] as Number).toLong()
        val param = QChatGetChannelCategoriesByPageParam(serverId, timeTag)
        (this["limit"] as Number?)?.toInt()?.let {
            param.limit = it
        }
        return param
    }

    private suspend fun subscribeAsVisitor(arguments: Map<String, *>): NimResult<QChatSubscribeChannelAsVisitorResult> {
        return suspendCancellableCoroutine { cont ->
            qChatChannelService.subscribeAsVisitor(
                arguments.toQChatSubscribeChannelAsVisitorParam()
            ).setCallback(
                NimResultContinuationCallback(cont) { result ->
                    NimResult(
                        code = 0,
                        data = result,
                        convert = { it.toMap() }
                    )
                }
            )
        }
    }

    @Suppress("UNCHECKED_CAST")
    private fun Map<String, *>.toQChatSubscribeChannelAsVisitorParam(): QChatSubscribeChannelAsVisitorParam {
        val operateType = stringToQChatSubscribeOperateType(this["operateType"] as String?)
        val channelIdInfos = (this["channelIdInfos"] as List<Map<String, *>?>).map {
            it?.toQChatChannelIdInfo()
        }
        return QChatSubscribeChannelAsVisitorParam(operateType ?: QChatSubscribeOperateType.SUB, channelIdInfos)
    }

    private fun QChatSubscribeChannelAsVisitorResult.toMap() = mapOf<String, Any?>(
        "failedList" to failedList?.map { it.toMap() }?.toList()
    )
}
