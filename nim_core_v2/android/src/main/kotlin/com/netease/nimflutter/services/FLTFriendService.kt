/*
 * Copyright (c) 2022 NetEase, Inc. All rights reserved.
 * Use of this source code is governed by a MIT license that can be
 * found in the LICENSE file.
 */

package com.netease.nimflutter.services

import android.content.Context
import com.netease.nimflutter.FLTService
import com.netease.nimflutter.LocalError.paramErrorCode
import com.netease.nimflutter.NimCore
import com.netease.nimflutter.NimResult
import com.netease.nimflutter.toMap
import com.netease.nimflutter.toV2NIMFriendAddApplication
import com.netease.nimlib.sdk.NIMClient
import com.netease.nimlib.sdk.v2.friend.V2NIMFriend
import com.netease.nimlib.sdk.v2.friend.V2NIMFriendAddApplication
import com.netease.nimlib.sdk.v2.friend.V2NIMFriendListener
import com.netease.nimlib.sdk.v2.friend.V2NIMFriendService
import com.netease.nimlib.sdk.v2.friend.enums.V2NIMFriendAddApplicationStatus
import com.netease.nimlib.sdk.v2.friend.enums.V2NIMFriendAddMode
import com.netease.nimlib.sdk.v2.friend.enums.V2NIMFriendDeletionType
import com.netease.nimlib.sdk.v2.friend.option.V2NIMFriendAddApplicationQueryOption.V2NIMFriendAddApplicationQueryOptionBuilder
import com.netease.nimlib.sdk.v2.friend.option.V2NIMFriendSearchOption
import com.netease.nimlib.sdk.v2.friend.param.V2NIMFriendAddParams
import com.netease.nimlib.sdk.v2.friend.param.V2NIMFriendDeleteParams
import com.netease.nimlib.sdk.v2.friend.param.V2NIMFriendSetParams
import com.netease.yunxin.kit.alog.ALog
import kotlin.coroutines.resume
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.channels.awaitClose
import kotlinx.coroutines.channels.onFailure
import kotlinx.coroutines.flow.callbackFlow
import kotlinx.coroutines.flow.launchIn
import kotlinx.coroutines.flow.onEach
import kotlinx.coroutines.suspendCancellableCoroutine

/**
 * Flutter 好友服务
 *
 */
class FLTFriendService(
    applicationContext: Context,
    nimCore: NimCore
) : FLTService(applicationContext, nimCore) {
    override val serviceName: String = "FriendService"

    init {
        nimCore.onInitialized {
            friendListener()
            registerFlutterMethodCalls(
                "addFriend" to this::addFriend,
                "deleteFriend" to this::deleteFriend,
                "acceptAddApplication" to this::acceptAddApplication,
                "rejectAddApplication" to this::rejectAddApplication,
                "setFriendInfo" to this::setFriendInfo,
                "getFriendList" to this::getFriendList,
                "getFriendByIds" to this::getFriendByIds,
                "checkFriend" to this::checkFriend,
                "getAddApplicationList" to this::getAddApplicationList,
                "getAddApplicationUnreadCount" to this::getAddApplicationUnreadCount,
                "setAddApplicationRead" to this::setAddApplicationRead,
                "searchFriendByOption" to this::searchFriendByOption
            )
        }
    }

    @ExperimentalCoroutinesApi
    private fun friendListener() {
        callbackFlow<Pair<String, Map<String, Any?>?>> {
            val listener = object : V2NIMFriendListener {
                override fun onFriendAdded(friendInfo: V2NIMFriend?) {
                    ALog.i(serviceName, "onFriendAdded: $friendInfo")
                    trySend(
                        Pair<String, Map<String, Any?>?>(
                            "onFriendAdded",
                            friendInfo?.toMap()
                        )
                    ).onFailure {
                        ALog.i(serviceName, "send onFriendAdded fail: ${it?.message}")
                    }
                }

                override fun onFriendDeleted(
                    accountId: String?,
                    deletionType: V2NIMFriendDeletionType?
                ) {
                    ALog.i(serviceName, "onFriendDeleted: $accountId")
                    trySend(
                        Pair<String, Map<String, Any?>?>(
                            "onFriendDeleted",
                            mapOf(
                                "accountId" to accountId,
                                "deletionType" to deletionType?.value
                            )
                        )
                    ).onFailure {
                        ALog.i(serviceName, "send onFriendDeleted fail: ${it?.message}")
                    }
                }

                override fun onFriendAddApplication(applicationInfo: V2NIMFriendAddApplication?) {
                    ALog.i(serviceName, "onFriendAddApplication: ${applicationInfo?.applicantAccountId}")
                    trySend(
                        Pair<String, Map<String, Any?>?>(
                            "onFriendAddApplication",
                            applicationInfo?.toMap()
                        )
                    ).onFailure {
                        ALog.i(serviceName, "send onFriendAddApplication fail: ${it?.message}")
                    }
                }

                override fun onFriendAddRejected(rejectionInfo: V2NIMFriendAddApplication?) {
                    ALog.i(serviceName, "onFriendAddRejected: $rejectionInfo")
                    trySend(
                        Pair<String, Map<String, Any?>?>(
                            "onFriendAddRejected",
                            rejectionInfo?.toMap()
                        )
                    ).onFailure {
                        ALog.i(serviceName, "send onFriendAddRejected fail: ${it?.message}")
                    }
                }

                override fun onFriendInfoChanged(friendInfo: V2NIMFriend?) {
                    ALog.i(serviceName, "onFriendInfoChanged: $friendInfo")
                    trySend(
                        Pair<String, Map<String, Any?>?>(
                            "onFriendInfoChanged",
                            friendInfo?.toMap()
                        )
                    ).onFailure {
                        ALog.i(serviceName, "send onFriendInfoChanged fail: ${it?.message}")
                    }
                }
            }
            NIMClient.getService(V2NIMFriendService::class.java).apply {
                this.addFriendListener(listener)
                awaitClose {
                    this.removeFriendListener(listener)
                }
            }
        }.onEach { event ->
            notifyEvent(
                method = event.first,
                arguments = event.second as Map<String, Any?>
            )
        }.launchIn(nimCore.lifeCycleScope)
    }

    private suspend fun addFriend(arguments: Map<String, *>): NimResult<Void> {
        val accountId = arguments["accountId"] as? String
        val params = arguments["params"] as? Map<String, *>
        return suspendCancellableCoroutine { cont ->
            var addParams: V2NIMFriendAddParams? = null
            if (params?.isNotEmpty() == true) {
                val mode = V2NIMFriendAddMode.typeOfValue((params["addMode"] as? Int ?: 1).toByte())
                addParams = V2NIMFriendAddParams.V2NIMFriendAddParamsBuilder.builder(
                    mode
                ).withPostscript(params["postscript"] as? String)
                    .build()
            }
            NIMClient.getService(V2NIMFriendService::class.java).addFriend(
                accountId,
                addParams,
                {
                    cont.resume(NimResult(0, data = it))
                },
                {
                    cont.resume(NimResult(it.code, errorDetails = it.desc))
                }
            )
        }
    }

    private suspend fun deleteFriend(arguments: Map<String, *>): NimResult<Void> {
        val accountId = arguments["accountId"] as? String
        val params = arguments["params"] as? Map<String, *>
        if (accountId?.isEmpty() == true) {
            return NimResult(code = paramErrorCode, errorDetails = "accountId is empty")
        }
        return suspendCancellableCoroutine { cont ->
            var deleteParams: V2NIMFriendDeleteParams? = null
            if (params?.isNotEmpty() == true) {
                deleteParams = V2NIMFriendDeleteParams.V2NIMFriendDeleteParamsBuilder.builder().withDeleteAlias(params["deleteAlias"] as? Boolean ?: false)
                    .build()
            }
            NIMClient.getService(V2NIMFriendService::class.java).deleteFriend(
                accountId,
                deleteParams,
                {
                    cont.resume(NimResult(0, data = it))
                },
                {
                    cont.resume(NimResult(it.code, errorDetails = it.desc))
                }
            )
        }
    }

    private suspend fun acceptAddApplication(arguments: Map<String, *>): NimResult<Void> {
        val applicationMap = arguments["application"] as? Map<String, *>
        val application = applicationMap?.toV2NIMFriendAddApplication()
        ALog.d(serviceName, "acceptAddApplication: ${application?.applicantAccountId}")
        return suspendCancellableCoroutine { cont ->
            NIMClient.getService(V2NIMFriendService::class.java).acceptAddApplication(
                application,
                {
                    cont.resume(NimResult(0, data = it))
                },
                {
                    cont.resume(NimResult(it.code, errorDetails = it.desc))
                }
            )
        }
    }

    private suspend fun rejectAddApplication(arguments: Map<String, *>): NimResult<Void> {
        val postscript = arguments["postscript"] as? String
        val applicationMap = arguments["application"] as? Map<String, *>
        if (applicationMap?.isEmpty() == true) {
            return NimResult(code = paramErrorCode, errorDetails = "application is empty")
        }
        return suspendCancellableCoroutine { cont ->
            NIMClient.getService(V2NIMFriendService::class.java).rejectAddApplication(
                applicationMap!!.toV2NIMFriendAddApplication(),
                postscript,
                {
                    cont.resume(NimResult(0, data = it))
                },
                {
                    cont.resume(NimResult(it.code, errorDetails = it.desc))
                }
            )
        }
    }

    private suspend fun setFriendInfo(arguments: Map<String, *>): NimResult<Void> {
        val accountId = arguments["accountId"] as? String
        val paramsMap = arguments["params"] as? Map<String, *>
//        if (accountId?.isEmpty() == true) {
//            return NimResult(code = paramErrorCode, errorDetails = "accountId is empty")
//        }
        return suspendCancellableCoroutine { cont ->
            var paramsBuilder = V2NIMFriendSetParams.V2NIMFriendSetParamsBuilder.builder()
            if (paramsMap?.isNotEmpty() == true) {
                if (paramsMap.containsKey("alias")) {
                    paramsBuilder = paramsBuilder.withAlias(paramsMap["alias"] as? String)
                }
                if (paramsMap.containsKey("serverExtension")) {
                    paramsBuilder = paramsBuilder.withServerExtension(paramsMap["serverExtension"] as? String)
                }
            }
            val params = paramsBuilder.build()
            NIMClient.getService(V2NIMFriendService::class.java).setFriendInfo(
                accountId,
                params,
                {
                    cont.resume(NimResult(0, data = it))
                },
                {
                    cont.resume(NimResult(it.code, errorDetails = it.desc))
                }
            )
        }
    }

    private suspend fun getFriendList(arguments: Map<String, *>): NimResult<Map<String, Any?>?> {
        return suspendCancellableCoroutine { cont ->
            NIMClient.getService(V2NIMFriendService::class.java).getFriendList(
                {
                    cont.resume(
                        NimResult(
                            0,
                            data = mapOf(
                                "friendList" to it.map { friend -> friend.toMap() }.toList()
                            )
                        )
                    )
                },
                {
                    cont.resume(NimResult(it.code, errorDetails = it.desc))
                }
            )
        }
    }

    private suspend fun getFriendByIds(arguments: Map<String, *>): NimResult<Map<String, Any?>?> {
        val accountIds = arguments["accountIds"] as? List<String>
//        if (accountIds?.isEmpty() == true) {
//            return NimResult(code = paramErrorCode, errorDetails = "accountIds is empty")
//        }
        return suspendCancellableCoroutine { cont ->
            NIMClient.getService(V2NIMFriendService::class.java).getFriendByIds(
                accountIds,
                {
                    cont.resume(
                        NimResult(
                            0,
                            data = mapOf(
                                "friendList" to it.map { friend -> friend.toMap() }.toList()
                            )
                        )
                    )
                },
                {
                    cont.resume(NimResult(it.code, errorDetails = it.desc))
                }
            )
        }
    }

    private suspend fun checkFriend(arguments: Map<String, *>): NimResult<Map<String, Any?>?> {
        val accountIds = arguments["accountIds"] as? List<String>
        return suspendCancellableCoroutine { cont ->
            NIMClient.getService(V2NIMFriendService::class.java).checkFriend(
                accountIds,
                {
                    cont.resume(NimResult(0, data = mapOf("result" to it)))
                },
                {
                    cont.resume(NimResult(it.code, errorDetails = it.desc))
                }
            )
        }
    }

    private suspend fun getAddApplicationList(arguments: Map<String, *>): NimResult<Map<String, Any?>?> {
        var optionMap = arguments["option"] as? Map<String, *>
        if (optionMap?.isEmpty() == true) {
            return NimResult(code = paramErrorCode, errorDetails = "option is empty")
        }
        return suspendCancellableCoroutine { cont ->
            val option = V2NIMFriendAddApplicationQueryOptionBuilder.builder().withLimit(
                optionMap!!["limit"] as? Int ?: 50
            ).withOffset(
                (optionMap["offset"] as? Int ?: 0).toLong()
            ).withStatus(
                (optionMap["status"] as? List<Int>)?.map {
                        status ->
                    V2NIMFriendAddApplicationStatus.typeOfValue(status)
                }?.toList() ?: emptyList()
            ).build()
            NIMClient.getService(V2NIMFriendService::class.java).getAddApplicationList(
                option,
                {
                    cont.resume(
                        NimResult(
                            0,
                            data = mapOf(
                                "infos" to it.infos.map { application -> application.toMap() }.toList(),
                                "offset" to it.offset,
                                "finished" to it.isFinished
                            )
                        )
                    )
                },
                {
                    cont.resume(NimResult(it.code, errorDetails = it.desc))
                }
            )
        }
    }

    private suspend fun getAddApplicationUnreadCount(arguments: Map<String, *>): NimResult<Int> {
        return suspendCancellableCoroutine { cont ->
            NIMClient.getService(V2NIMFriendService::class.java).getAddApplicationUnreadCount(
                {
                    cont.resume(NimResult(0, data = it))
                },
                {
                    cont.resume(NimResult(it.code, errorDetails = it.desc))
                }
            )
        }
    }

    private suspend fun setAddApplicationRead(arguments: Map<String, *>): NimResult<Void> {
        return suspendCancellableCoroutine { cont ->
            NIMClient.getService(V2NIMFriendService::class.java).setAddApplicationRead(
                {
                    cont.resume(NimResult(0, data = it))
                },
                {
                    cont.resume(NimResult(it.code, errorDetails = it.desc))
                }
            )
        }
    }

    private suspend fun searchFriendByOption(arguments: Map<String, *>): NimResult<Map<String, Any?>?> {
        val optionMap = arguments["friendSearchOption"] as? Map<String, *>
        if (optionMap?.isEmpty() == true) {
            return NimResult(code = paramErrorCode, errorDetails = "option is empty")
        }
        return suspendCancellableCoroutine { cont ->
            val option = V2NIMFriendSearchOption.V2NIMFriendSearchOptionBuilder.builder(
                optionMap!!["keyword"] as? String ?: ""
            ).withSearchAlias(
                optionMap["searchAlias"] as? Boolean ?: true
            ).withSearchAccountId(
                optionMap["searchAccountId"] as? Boolean ?: true
            ).build()
            NIMClient.getService(V2NIMFriendService::class.java).searchFriendByOption(
                option,
                {
                    cont.resume(
                        NimResult(
                            0,
                            data = mapOf(
                                "friendList" to it.map { friend -> friend.toMap() }.toList()
                            )
                        )
                    )
                },
                {
                    cont.resume(NimResult(it.code, errorDetails = it.desc))
                }
            )
        }
    }
}
