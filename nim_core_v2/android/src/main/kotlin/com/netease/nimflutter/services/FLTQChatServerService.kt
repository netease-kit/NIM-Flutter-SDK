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
import com.netease.nimflutter.NimResultContinuationCallback
import com.netease.nimflutter.NimResultContinuationCallbackOfNothing
import com.netease.nimflutter.toMap
import com.netease.nimflutter.toQChatAcceptServerApplyParam
import com.netease.nimflutter.toQChatAcceptServerInviteParam
import com.netease.nimflutter.toQChatApplyServerJoinParam
import com.netease.nimflutter.toQChatBanServerMemberParam
import com.netease.nimflutter.toQChatCreateServerParam
import com.netease.nimflutter.toQChatDeleteServerParam
import com.netease.nimflutter.toQChatEnterServerAsVisitorParam
import com.netease.nimflutter.toQChatGenerateInviteCodeParam
import com.netease.nimflutter.toQChatGetBannedServerMembersByPageParam
import com.netease.nimflutter.toQChatGetInviteApplyRecordOfSelfParam
import com.netease.nimflutter.toQChatGetInviteApplyRecordOfServerParam
import com.netease.nimflutter.toQChatGetServerMembersByPageParam
import com.netease.nimflutter.toQChatGetServerMembersParam
import com.netease.nimflutter.toQChatGetServersByPageParam
import com.netease.nimflutter.toQChatGetServersParam
import com.netease.nimflutter.toQChatGetUserServerPushConfigsParam
import com.netease.nimflutter.toQChatInviteServerMembersParam
import com.netease.nimflutter.toQChatJoinByInviteCodeParam
import com.netease.nimflutter.toQChatKickServerMembersParam
import com.netease.nimflutter.toQChatLeaveServerAsVisitorParam
import com.netease.nimflutter.toQChatLeaveServerParam
import com.netease.nimflutter.toQChatRejectServerApplyParam
import com.netease.nimflutter.toQChatRejectServerInviteParam
import com.netease.nimflutter.toQChatSearchServerByPageParam
import com.netease.nimflutter.toQChatSearchServerMemberByPageParam
import com.netease.nimflutter.toQChatServerMarkReadParam
import com.netease.nimflutter.toQChatSubscribeAllChannelParam
import com.netease.nimflutter.toQChatSubscribeServerAsVisitorParam
import com.netease.nimflutter.toQChatSubscribeServerParam
import com.netease.nimflutter.toQChatUnbanServerMemberParam
import com.netease.nimflutter.toQChatUpdateMyMemberInfoParam
import com.netease.nimflutter.toQChatUpdateServerMemberInfoParam
import com.netease.nimflutter.toQChatUpdateServerParam
import com.netease.nimflutter.toQChatUpdateUserServerPushConfigParam
import com.netease.nimlib.sdk.NIMClient
import com.netease.nimlib.sdk.qchat.QChatServerService
import com.netease.nimlib.sdk.qchat.result.QChatApplyServerJoinResult
import com.netease.nimlib.sdk.qchat.result.QChatCreateServerResult
import com.netease.nimlib.sdk.qchat.result.QChatEnterServerAsVisitorResult
import com.netease.nimlib.sdk.qchat.result.QChatGenerateInviteCodeResult
import com.netease.nimlib.sdk.qchat.result.QChatGetBannedServerMembersByPageResult
import com.netease.nimlib.sdk.qchat.result.QChatGetInviteApplyRecordOfSelfResult
import com.netease.nimlib.sdk.qchat.result.QChatGetInviteApplyRecordOfServerResult
import com.netease.nimlib.sdk.qchat.result.QChatGetServerMembersByPageResult
import com.netease.nimlib.sdk.qchat.result.QChatGetServerMembersResult
import com.netease.nimlib.sdk.qchat.result.QChatGetServersByPageResult
import com.netease.nimlib.sdk.qchat.result.QChatGetServersResult
import com.netease.nimlib.sdk.qchat.result.QChatGetUserPushConfigsResult
import com.netease.nimlib.sdk.qchat.result.QChatInviteServerMembersResult
import com.netease.nimlib.sdk.qchat.result.QChatLeaveServerAsVisitorResult
import com.netease.nimlib.sdk.qchat.result.QChatSearchServerByPageResult
import com.netease.nimlib.sdk.qchat.result.QChatSearchServerMemberByPageResult
import com.netease.nimlib.sdk.qchat.result.QChatServerMarkReadResult
import com.netease.nimlib.sdk.qchat.result.QChatSubscribeAllChannelResult
import com.netease.nimlib.sdk.qchat.result.QChatSubscribeServerAsVisitorResult
import com.netease.nimlib.sdk.qchat.result.QChatSubscribeServerResult
import com.netease.nimlib.sdk.qchat.result.QChatUpdateMyMemberInfoResult
import com.netease.nimlib.sdk.qchat.result.QChatUpdateServerMemberInfoResult
import com.netease.nimlib.sdk.qchat.result.QChatUpdateServerResult
import kotlinx.coroutines.suspendCancellableCoroutine

class FLTQChatServerService(
    applicationContext: Context,
    nimCore: NimCore
) : FLTService(applicationContext, nimCore) {

    override val serviceName = "QChatServerService"

    private val qChatServerService: QChatServerService by lazy {
        NIMClient.getService(QChatServerService::class.java)
    }

    private val paramErrorCode = 414
    private val paramErrorTip = "参数错误"

    init {
        nimCore.onInitialized {
            registerFlutterMethodCalls(
                "acceptServerApply" to ::acceptServerApply,
                "acceptServerInvite" to ::acceptServerInvite,
                "applyServerJoin" to ::applyServerJoin,
                "createServer" to ::createServer,
                "deleteServer" to ::deleteServer,
                "getServerMembers" to ::getServerMembers,
                "getServerMembersByPage" to ::getServerMembersByPage,
                "getServers" to ::getServers,
                "getServersByPage" to ::getServersByPage,
                "inviteServerMembers" to ::inviteServerMembers,
                "kickServerMembers" to ::kickServerMembers,
                "leaveServer" to ::leaveServer,
                "rejectServerApply" to ::rejectServerApply,
                "rejectServerInvite" to ::rejectServerInvite,
                "updateServer" to ::updateServer,
                "updateMyMemberInfo" to ::updateMyMemberInfo,
                "subscribeServer" to ::subscribeServer,
                "searchServerByPage" to ::searchServerByPage,
                "generateInviteCode" to ::generateInviteCode,
                "joinByInviteCode" to ::joinByInviteCode,
                "updateServerMemberInfo" to ::updateServerMemberInfo,
                "banServerMember" to ::banServerMember,
                "unbanServerMember" to ::unbanServerMember,
                "getBannedServerMembersByPage" to ::getBannedServerMembersByPage,
                "updateUserServerPushConfig" to ::updateUserServerPushConfig,
                "getUserServerPushConfigs" to ::getUserServerPushConfigs,
                "searchServerMemberByPage" to ::searchServerMemberByPage,
                "getInviteApplyRecordOfServer" to ::getInviteApplyRecordOfServer,
                "getInviteApplyRecordOfSelf" to ::getInviteApplyRecordOfSelf,
                "markRead" to ::markRead,
                "subscribeAllChannel" to ::subscribeAllChannel,
                "subscribeAsVisitor" to ::subscribeAsVisitor,
                "enterAsVisitor" to ::enterAsVisitor,
                "leaveAsVisitor" to ::leaveAsVisitor
            )
        }
    }

    private suspend fun acceptServerApply(arguments: Map<String, *>): NimResult<Nothing> {
        return suspendCancellableCoroutine { cont ->
            qChatServerService.acceptServerApply(
                arguments.toQChatAcceptServerApplyParam()
            ).setCallback(
                NimResultContinuationCallbackOfNothing(cont)
            )
        }
    }

    private suspend fun acceptServerInvite(arguments: Map<String, *>): NimResult<Nothing> {
        return suspendCancellableCoroutine { cont ->
            qChatServerService.acceptServerInvite(
                arguments.toQChatAcceptServerInviteParam()
            ).setCallback(
                NimResultContinuationCallbackOfNothing(cont)
            )
        }
    }

    private suspend fun applyServerJoin(arguments: Map<String, *>): NimResult<QChatApplyServerJoinResult> {
        return suspendCancellableCoroutine { cont ->
            qChatServerService.applyServerJoin(
                arguments.toQChatApplyServerJoinParam()
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

    private suspend fun createServer(arguments: Map<String, *>): NimResult<QChatCreateServerResult> {
        return suspendCancellableCoroutine { cont ->
            qChatServerService.createServer(arguments.toQChatCreateServerParam()).setCallback(
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

    private suspend fun deleteServer(arguments: Map<String, *>): NimResult<Nothing> {
        return suspendCancellableCoroutine { cont ->
            qChatServerService.deleteServer(arguments.toQChatDeleteServerParam()).setCallback(
                NimResultContinuationCallbackOfNothing(cont)
            )
        }
    }

    private suspend fun getServerMembers(arguments: Map<String, *>): NimResult<QChatGetServerMembersResult> {
        return suspendCancellableCoroutine { cont ->
            qChatServerService.getServerMembers(arguments.toQChatGetServerMembersParam())
                .setCallback(
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

    private suspend fun getServers(arguments: Map<String, *>): NimResult<QChatGetServersResult> {
        return suspendCancellableCoroutine { cont ->
            qChatServerService.getServers(arguments.toQChatGetServersParam())
                .setCallback(
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

    private suspend fun getServerMembersByPage(arguments: Map<String, *>): NimResult<QChatGetServerMembersByPageResult> {
        return suspendCancellableCoroutine { cont ->
            qChatServerService.getServerMembersByPage(arguments.toQChatGetServerMembersByPageParam())
                .setCallback(
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

    private suspend fun getServersByPage(arguments: Map<String, *>): NimResult<QChatGetServersByPageResult> {
        return suspendCancellableCoroutine { cont ->
            qChatServerService.getServersByPage(arguments.toQChatGetServersByPageParam())
                .setCallback(
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

    private suspend fun inviteServerMembers(arguments: Map<String, *>): NimResult<QChatInviteServerMembersResult> {
        return suspendCancellableCoroutine { cont ->
            qChatServerService.inviteServerMembers(arguments.toQChatInviteServerMembersParam())
                .setCallback(
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

    private suspend fun kickServerMembers(arguments: Map<String, *>): NimResult<Nothing> {
        return suspendCancellableCoroutine { cont ->
            qChatServerService.kickServerMembers(arguments.toQChatKickServerMembersParam())
                .setCallback(
                    NimResultContinuationCallbackOfNothing(cont)
                )
        }
    }

    private suspend fun leaveServer(arguments: Map<String, *>): NimResult<Nothing> {
        return suspendCancellableCoroutine { cont ->
            qChatServerService.leaveServer(arguments.toQChatLeaveServerParam())
                .setCallback(
                    NimResultContinuationCallbackOfNothing(cont)
                )
        }
    }

    private suspend fun rejectServerApply(arguments: Map<String, *>): NimResult<Nothing> {
        return suspendCancellableCoroutine { cont ->
            qChatServerService.rejectServerApply(arguments.toQChatRejectServerApplyParam())
                .setCallback(
                    NimResultContinuationCallbackOfNothing(cont)
                )
        }
    }

    private suspend fun rejectServerInvite(arguments: Map<String, *>): NimResult<Nothing> {
        return suspendCancellableCoroutine { cont ->
            qChatServerService.rejectServerInvite(arguments.toQChatRejectServerInviteParam())
                .setCallback(
                    NimResultContinuationCallbackOfNothing(cont)
                )
        }
    }

    private suspend fun updateServer(arguments: Map<String, *>): NimResult<QChatUpdateServerResult> {
        return suspendCancellableCoroutine { cont ->
            qChatServerService.updateServer(arguments.toQChatUpdateServerParam())
                .setCallback(
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

    private suspend fun updateMyMemberInfo(arguments: Map<String, *>): NimResult<QChatUpdateMyMemberInfoResult> {
        return suspendCancellableCoroutine { cont ->
            qChatServerService.updateMyMemberInfo(arguments.toQChatUpdateMyMemberInfoParam())
                .setCallback(
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

    private suspend fun subscribeServer(arguments: Map<String, *>): NimResult<QChatSubscribeServerResult> {
        return suspendCancellableCoroutine { cont ->
            qChatServerService.subscribeServer(arguments.toQChatSubscribeServerParam())
                .setCallback(
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

    private suspend fun searchServerByPage(arguments: Map<String, *>): NimResult<QChatSearchServerByPageResult> {
        return suspendCancellableCoroutine { cont ->
            qChatServerService.searchServerByPage(arguments.toQChatSearchServerByPageParam())
                .setCallback(
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

    private suspend fun generateInviteCode(arguments: Map<String, *>): NimResult<QChatGenerateInviteCodeResult> {
        return suspendCancellableCoroutine { cont ->
            qChatServerService.generateInviteCode(arguments.toQChatGenerateInviteCodeParam())
                .setCallback(
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

    private suspend fun joinByInviteCode(arguments: Map<String, *>): NimResult<Nothing> {
        return suspendCancellableCoroutine { cont ->
            qChatServerService.joinByInviteCode(arguments.toQChatJoinByInviteCodeParam())
                .setCallback(
                    NimResultContinuationCallbackOfNothing(cont)
                )
        }
    }

    private suspend fun updateServerMemberInfo(arguments: Map<String, *>): NimResult<QChatUpdateServerMemberInfoResult> {
        return suspendCancellableCoroutine { cont ->
            val param = arguments.toQChatUpdateServerMemberInfoParam()
            if (param.serverId <= 0 || TextUtils.isEmpty(param.accid)) {
                cont.resumeWith(
                    Result.success(
                        NimResult(
                            code = paramErrorCode,
                            data = null,
                            errorDetails = paramErrorTip
                        )
                    )
                )
            } else {
                qChatServerService.updateServerMemberInfo(param)
                    .setCallback(
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
    }

    private suspend fun banServerMember(arguments: Map<String, *>): NimResult<Nothing> {
        return suspendCancellableCoroutine { cont ->
            val param = arguments.toQChatBanServerMemberParam()
            if (param.serverId <= 0) {
                cont.resumeWith(
                    Result.success(
                        NimResult(
                            code = paramErrorCode,
                            data = null,
                            errorDetails = paramErrorTip
                        )
                    )
                )
            } else {
                qChatServerService.banServerMember(arguments.toQChatBanServerMemberParam())
                    .setCallback(
                        NimResultContinuationCallbackOfNothing(cont)
                    )
            }
        }
    }

    private suspend fun unbanServerMember(arguments: Map<String, *>): NimResult<Nothing> {
        return suspendCancellableCoroutine { cont ->
            val param = arguments.toQChatUnbanServerMemberParam()
            if (param.serverId <= 0) {
                cont.resumeWith(
                    Result.success(
                        NimResult(
                            code = paramErrorCode,
                            data = null,
                            errorDetails = paramErrorTip
                        )
                    )
                )
            } else {
                qChatServerService.unbanServerMember(arguments.toQChatUnbanServerMemberParam())
                    .setCallback(
                        NimResultContinuationCallbackOfNothing(cont)
                    )
            }
        }
    }

    private suspend fun getBannedServerMembersByPage(arguments: Map<String, *>): NimResult<QChatGetBannedServerMembersByPageResult> {
        return suspendCancellableCoroutine { cont ->
            qChatServerService.getBannedServerMembersByPage(arguments.toQChatGetBannedServerMembersByPageParam())
                .setCallback(
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

    private suspend fun updateUserServerPushConfig(arguments: Map<String, *>): NimResult<Nothing> {
        return suspendCancellableCoroutine { cont ->
            val param = arguments.toQChatUpdateUserServerPushConfigParam()
            if (param.serverId <= 0) {
                cont.resumeWith(
                    Result.success(
                        NimResult(
                            code = paramErrorCode,
                            data = null,
                            errorDetails = paramErrorTip
                        )
                    )
                )
            } else {
                qChatServerService.updateUserServerPushConfig(param)
                    .setCallback(
                        NimResultContinuationCallbackOfNothing(cont)
                    )
            }
        }
    }

    private suspend fun getUserServerPushConfigs(arguments: Map<String, *>): NimResult<QChatGetUserPushConfigsResult> {
        return suspendCancellableCoroutine { cont ->
            val param = arguments.toQChatGetUserServerPushConfigsParam()
            if (!isValidServerIdListNotNull(param.serverIdList)) {
                cont.resumeWith(
                    Result.success(
                        NimResult(
                            code = paramErrorCode,
                            data = null,
                            errorDetails = paramErrorTip
                        )
                    )
                )
            } else {
                qChatServerService.getUserServerPushConfigs(param)
                    .setCallback(
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
    }

    private suspend fun searchServerMemberByPage(arguments: Map<String, *>): NimResult<QChatSearchServerMemberByPageResult> {
        return suspendCancellableCoroutine { cont ->
            qChatServerService.searchServerMemberByPage(arguments.toQChatSearchServerMemberByPageParam())
                .setCallback(
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

    private suspend fun getInviteApplyRecordOfServer(arguments: Map<String, *>): NimResult<QChatGetInviteApplyRecordOfServerResult> {
        return suspendCancellableCoroutine { cont ->
            qChatServerService.getInviteApplyRecordOfServer(arguments.toQChatGetInviteApplyRecordOfServerParam())
                .setCallback(
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

    private suspend fun getInviteApplyRecordOfSelf(arguments: Map<String, *>): NimResult<QChatGetInviteApplyRecordOfSelfResult> {
        return suspendCancellableCoroutine { cont ->
            qChatServerService.getInviteApplyRecordOfSelf(arguments.toQChatGetInviteApplyRecordOfSelfParam())
                .setCallback(
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

    private suspend fun markRead(arguments: Map<String, *>): NimResult<QChatServerMarkReadResult> {
        return suspendCancellableCoroutine { cont ->
            val param = arguments.toQChatServerMarkReadParam()
            if (!isValidServerIdListNotNull(param.serverIds)) {
                cont.resumeWith(
                    Result.success(
                        NimResult(
                            code = paramErrorCode,
                            data = null,
                            errorDetails = paramErrorTip
                        )
                    )
                )
            } else {
                qChatServerService.markRead(param)
                    .setCallback(
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
    }

    private suspend fun subscribeAllChannel(arguments: Map<String, *>): NimResult<QChatSubscribeAllChannelResult> {
        return suspendCancellableCoroutine { cont ->
            qChatServerService.subscribeAllChannel(arguments.toQChatSubscribeAllChannelParam())
                .setCallback(
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

    private fun isValidServerIdListNotNull(serverIdList: List<Long>?): Boolean {
        serverIdList ?: return false
        return serverIdList.isNotEmpty() && serverIdList.all {
            it > 0
        }
    }

    private suspend fun subscribeAsVisitor(arguments: Map<String, *>): NimResult<QChatSubscribeServerAsVisitorResult> {
        return suspendCancellableCoroutine { cont ->
            qChatServerService.subscribeAsVisitor(arguments.toQChatSubscribeServerAsVisitorParam())
                .setCallback(
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

    private suspend fun enterAsVisitor(arguments: Map<String, *>): NimResult<QChatEnterServerAsVisitorResult> {
        return suspendCancellableCoroutine { cont ->
            qChatServerService.enterAsVisitor(arguments.toQChatEnterServerAsVisitorParam())
                .setCallback(
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

    private suspend fun leaveAsVisitor(arguments: Map<String, *>): NimResult<QChatLeaveServerAsVisitorResult> {
        return suspendCancellableCoroutine { cont ->
            qChatServerService.leaveAsVisitor(arguments.toQChatLeaveServerAsVisitorParam())
                .setCallback(
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
}
