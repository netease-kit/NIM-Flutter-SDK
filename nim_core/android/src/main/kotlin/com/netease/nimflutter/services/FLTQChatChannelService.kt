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
import com.netease.nimflutter.toMap
import com.netease.nimflutter.toQChatCreateChannelParamParam
import com.netease.nimflutter.toQChatDeleteChannelParam
import com.netease.nimflutter.toQChatGetChannelMembersByPageParam
import com.netease.nimflutter.toQChatGetChannelUnreadInfosParam
import com.netease.nimflutter.toQChatGetChannelsByPageParam
import com.netease.nimflutter.toQChatGetChannelsParam
import com.netease.nimflutter.toQChatSearchChannelByPageParam
import com.netease.nimflutter.toQChatSearchChannelMembersParam
import com.netease.nimflutter.toQChatSubscribeChannelParam
import com.netease.nimflutter.toQChatUpdateChannelParam
import com.netease.nimlib.sdk.NIMClient
import com.netease.nimlib.sdk.qchat.QChatChannelService
import com.netease.nimlib.sdk.qchat.result.QChatCreateChannelResult
import com.netease.nimlib.sdk.qchat.result.QChatGetChannelMembersByPageResult
import com.netease.nimlib.sdk.qchat.result.QChatGetChannelUnreadInfosResult
import com.netease.nimlib.sdk.qchat.result.QChatGetChannelsByPageResult
import com.netease.nimlib.sdk.qchat.result.QChatGetChannelsResult
import com.netease.nimlib.sdk.qchat.result.QChatSearchChannelByPageResult
import com.netease.nimlib.sdk.qchat.result.QChatSearchChannelMembersResult
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
                "searchChannelMembers" to ::searchChannelMembers
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
}
