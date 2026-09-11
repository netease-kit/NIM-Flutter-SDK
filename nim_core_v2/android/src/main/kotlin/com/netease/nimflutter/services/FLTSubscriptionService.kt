/*
 * Copyright (c) 2022 NetEase, Inc. All rights reserved.
 * Use of this source code is governed by a MIT license that can be
 * found in the LICENSE file.
 */

package com.netease.nimflutter.services

import android.content.Context
import android.text.TextUtils
import com.netease.nimflutter.FLTConstant
import com.netease.nimflutter.FLTService
import com.netease.nimflutter.NimCore
import com.netease.nimflutter.NimResult
import com.netease.nimflutter.extension.toMap
import com.netease.nimlib.sdk.NIMClient
import com.netease.nimlib.sdk.v2.subscription.V2NIMSubscribeListener
import com.netease.nimlib.sdk.v2.subscription.V2NIMSubscriptionService
import com.netease.nimlib.sdk.v2.subscription.option.V2NIMSubscribeUserStatusOption
import com.netease.nimlib.sdk.v2.subscription.option.V2NIMUnsubscribeUserStatusOption
import com.netease.nimlib.sdk.v2.subscription.params.V2NIMCustomUserStatusParams
import com.netease.yunxin.kit.alog.ALog
import kotlin.coroutines.resume
import kotlinx.coroutines.suspendCancellableCoroutine

class FLTSubscriptionService(
    applicationContext: Context,
    nimCore: NimCore
) : FLTService(applicationContext, nimCore) {
    private val subscriptionService: V2NIMSubscriptionService by lazy {
        NIMClient.getService(V2NIMSubscriptionService::class.java)
    }

    override val serviceName = "SubscriptionService"

    init {
        nimCore.onInitialized {
            subscriptionService.addSubscribeListener(subscriptionListener)
        }
        registerFlutterMethodCalls(
            "subscribeUserStatus" to this::subscribeUserStatus,
            "unsubscribeUserStatus" to this::unsubscribeUserStatus,
            "publishCustomUserStatus" to this::publishCustomUserStatus,
            "queryUserStatusSubscriptions" to this::queryUserStatusSubscriptions
        )
    }

    // 订阅用户状态，包括在线状态，或自定义状态 单次订阅人数最多100，
    // 如果有较多人数需要调用，需多次调用该接口 如果同一账号多端重复订阅，
    // 订阅有效期会默认后一次覆盖前一次时长 总订阅人数最多3000， 被订阅人数3000，
    // 为了性能考虑， 在线状态事件订阅是单向的，双方需要各自订阅。
    // 如果接口整体失败，则返回调用错误码 如果部分账号失败，则返回失败账号列表 订阅接口后，
    // 有成员在线状态变更会触发回调：onUserStatusChanged
    // Params:
    // option –
    // 订阅请求参数 success – 成功回调, 返回订阅失败的账号列表 failure – 失败回调
    private suspend fun subscribeUserStatus(arguments: Map<String, *>): NimResult<Map<String, Any?>?> {
        return suspendCancellableCoroutine { cont ->

            val optionMap = arguments["option"] as? Map<String, Any?>
            if (optionMap == null) {
                cont.resume(NimResult(code = FLTConstant.paramErrorCode, errorDetails = "optionParam is null"))
            } else {
                val duration = (optionMap.getOrElse("duration") { null } as? Number)?.toLong()
                val immediateSync =
                    if (optionMap["immediateSync"] as? Boolean == null) {
                        false
                    } else {
                        optionMap["immediateSync"] as Boolean
                    }
                val accountIds = optionMap["accountIds"] as? List<String>
                val options = V2NIMSubscribeUserStatusOption(accountIds)
                if (duration != null) {
                    options.duration = duration
                }
                options.isImmediateSync = immediateSync
                subscriptionService.subscribeUserStatus(
                    options,
                    { result ->
                        cont.resume(
                            NimResult(
                                code = 0,
                                data =
                                mutableMapOf(
                                    "accountIds" to
                                        result
                                )
                            )
                        )
                    },
                    { error ->
                        cont.resume(
                            if (error != null) {
                                NimResult(code = error.code, errorDetails = error.desc)
                            } else {
                                NimResult(
                                    code = -1,
                                    errorDetails = "subscribeUserStatus failed!"
                                )
                            }
                        )
                    }
                )
            }
        }
    }

    private suspend fun unsubscribeUserStatus(arguments: Map<String, *>): NimResult<Map<String, Any?>?> {
        return suspendCancellableCoroutine { cont ->

            val optionMap = arguments["option"] as? Map<String, Any?>
            if (optionMap == null) {
                cont.resume(
                    NimResult(
                        code = FLTConstant.paramErrorCode,
                        errorDetails = "option param is null"
                    )
                )
            } else {
                val accountIds: List<String?>? = optionMap["accountIds"] as? List<String?>
                val safeAccountIds = accountIds ?: emptyList()
                val options = V2NIMUnsubscribeUserStatusOption(safeAccountIds)

                ALog.d("unsubscribeUserStatus", ",accountSize:" + safeAccountIds.size)
                subscriptionService.unsubscribeUserStatus(
                    options,
                    { result ->
                        if (result == null) {
                            cont.resume(
                                NimResult(
                                    code = 0,
                                    data =
                                    mutableMapOf(
                                        "accountIds" to
                                            emptyList<String>()
                                    )
                                )
                            )
                        } else {
                            cont.resume(
                                NimResult(
                                    code = 0,
                                    data =
                                    mutableMapOf(
                                        "accountIds" to
                                            result
                                    )
                                )
                            )
                        }
                    },
                    { error ->
                        cont.resume(
                            if (error != null) {
                                NimResult(code = error.code, errorDetails = error.desc)
                            } else {
                                NimResult(
                                    code = -1,
                                    errorDetails = "unsubscribeUserStatus failed!"
                                )
                            }
                        )
                    }
                )
            }
        }
    }

    private suspend fun publishCustomUserStatus(arguments: Map<String, *>): NimResult<Map<String, Any?>?> {
        return suspendCancellableCoroutine { cont ->

            val paramsMap = arguments["params"] as? Map<String, Any?>
            if (paramsMap == null) {
                cont.resume(
                    NimResult(
                        code = FLTConstant.paramErrorCode,
                        errorDetails = "params is null"
                    )
                )
            } else {
                val duration = (paramsMap.getOrElse("duration") { 0L } as Number).toLong()

                val statusType =
                    if (paramsMap["statusType"] as? Int == null) 0 else paramsMap["statusType"] as Int

                val extension = paramsMap["extension"] as? String

                val onlineOnly =
                    if (paramsMap["onlineOnly"] as? Boolean == null) {
                        true
                    } else {
                        paramsMap["onlineOnly"] as Boolean
                    }

                val multiSync =
                    if (paramsMap["multiSync"] as? Boolean == null) {
                        false
                    } else {
                        paramsMap["multiSync"] as Boolean
                    }

                val builder = V2NIMCustomUserStatusParams.Builder(statusType, duration)
                if (!TextUtils.isEmpty(extension)) {
                    builder.extension(extension)
                }
                builder.onlineOnly(onlineOnly)
                builder.multiSync(multiSync)

                val statusParams = builder.build()
                subscriptionService.publishCustomUserStatus(
                    statusParams,
                    { result ->
                        cont.resume(
                            NimResult(
                                code = 0,
                                data = result.toMap()
                            )
                        )
                    },
                    { error ->
                        cont.resume(
                            if (error != null) {
                                NimResult(code = error.code, errorDetails = error.desc)
                            } else {
                                NimResult(
                                    code = -1,
                                    errorDetails = "publishCustomUserStatus failed!"
                                )
                            }
                        )
                    }
                )
            }
        }
    }

    private suspend fun queryUserStatusSubscriptions(arguments: Map<String, *>): NimResult<Map<String, Any?>?> {
        return suspendCancellableCoroutine { cont ->

            val accountIds = arguments["accountIds"] as? List<String>

            subscriptionService.queryUserStatusSubscriptions(
                accountIds,
                { result ->
                    cont.resume(
                        NimResult(
                            code = 0,
                            data =
                            mutableMapOf(
                                "subscribeResultList" to
                                    result.map { it.toMap() }
                                        .toList()
                            )
                        )
                    )
                },
                { error ->
                    cont.resume(
                        if (error != null) {
                            NimResult(code = error.code, errorDetails = error.desc)
                        } else {
                            NimResult(
                                code = -1,
                                errorDetails = "queryUserStatusSubscriptions failed!"
                            )
                        }
                    )
                }
            )
        }
    }

    private val subscriptionListener =
        V2NIMSubscribeListener { userStatusList ->
            ALog.i(
                "FLTSubscriptionService",
                "onUserStatusChanged",
                "statusSize:${userStatusList.size}"
            )
            notifyEvent(
                "onUserStatusChanged",
                mutableMapOf(
                    "userStatusList" to userStatusList?.map { it.toMap() }
                )
            )
        }
}
