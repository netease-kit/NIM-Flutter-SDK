/*
 * Copyright (c) 2022 NetEase, Inc. All rights reserved.
 * Use of this source code is governed by a MIT license that can be
 * found in the LICENSE file.
 */

package com.netease.nimflutter.services

import android.content.Context
import com.netease.nimflutter.FLTConstant
import com.netease.nimflutter.FLTService
import com.netease.nimflutter.NimCore
import com.netease.nimflutter.NimResult
import com.netease.nimflutter.toMap
import com.netease.nimlib.sdk.NIMClient
import com.netease.nimlib.sdk.v2.user.V2NIMUser
import com.netease.nimlib.sdk.v2.user.V2NIMUserListener
import com.netease.nimlib.sdk.v2.user.V2NIMUserService
import com.netease.nimlib.sdk.v2.user.option.V2NIMUserSearchOption
import com.netease.nimlib.sdk.v2.user.params.V2NIMUserUpdateParams.V2NIMUserUpdateParamsBuilder
import kotlin.coroutines.resume
import kotlinx.coroutines.suspendCancellableCoroutine

class FLTUserService(
    applicationContext: Context,
    nimCore: NimCore
) : FLTService(applicationContext, nimCore) {
    private val tag = "FLTUserService"
    override val serviceName = "UserService"

    /**
     * 根据用户账号列表获取用户资料 单次最大值150 只返回ID存在的用户，
     * 错误ID不返回 返回顺序以传入序为准（可以不做强制校验）
     * 先查询本地缓存，本地缺失或不足，再查询云端
     */
    private suspend fun getUserList(
        arguments: Map<String, *>
    ): NimResult<Map<String, Any?>?> {
        return suspendCancellableCoroutine { cont ->
            val userIdList = arguments["userIdList"] as? List<String>
            if (userIdList == null) {
                cont.resume(
                    NimResult(code = FLTConstant.paramErrorCode, errorDetails = "getUserInfoList but the userIds is empty!")
                )
            } else {
                NIMClient.getService(V2NIMUserService::class.java).getUserList(
                    userIdList,
                    { result ->
                        cont.resume(
                            NimResult(
                                code = 0,
                                data = mutableMapOf("userInfoList" to result.map { it?.toMap() })
                            )
                        )
                    }
                ) { error ->
                    cont.resume(
                        if (error != null) {
                            NimResult(code = error.code, errorDetails = error.desc)
                        } else {
                            NimResult(code = -1, errorDetails = "getUserInfoList failed!")
                        }
                    )
                }
            }
        }
    }

    /**
     * 根据用户账号列表从服务器获取用户资料 单次最大值150 只返回ID存在的用户，
     * 错误ID不返回 返回顺序以传入序为准（可以不做强制校验） 直接查询云端
     * 如果是协议错， 则整体返回错， 否则返回部分成功
     * 如果查询数据后，本地成员数据有更新， 则触发用户信息更新回调
     */
    private suspend fun getUserListFromCloud(
        arguments: Map<String, *>
    ): NimResult<Map<String, Any?>?> {
        return suspendCancellableCoroutine { cont ->
            val userIdList = arguments["userIdList"] as? List<String>
            if (userIdList == null) {
                cont.resume(
                    NimResult(
                        code = FLTConstant.paramErrorCode,
                        errorDetails = "getUserListFromCloud but the userIds is empty!"
                    )
                )
            } else {
                NIMClient.getService(V2NIMUserService::class.java).getUserListFromCloud(
                    userIdList,
                    { result ->
                        cont.resume(
                            NimResult(
                                code = 0,
                                data =
                                mutableMapOf(
                                    "userInfoList" to result.map { it?.toMap() }
                                )
                            )
                        )
                    }
                ) { error ->
                    cont.resume(
                        if (error != null) {
                            NimResult(code = error.code, errorDetails = error.desc)
                        } else {
                            NimResult(code = -1, errorDetails = "getUserListFromCloud failed!")
                        }
                    )
                }
            }
        }
    }

    /**
     * 更新自己的用户资料
     * 调用该Api后， SDK会抛出： onUserProfileChanged
     */
    private suspend fun updateSelfUserProfile(
        arguments: Map<String, *>
    ): NimResult<Nothing> {
        return suspendCancellableCoroutine { cont ->
            val updateParam = arguments["updateParam"] as Map<String, *>?
            if (updateParam == null) {
                cont.resume(NimResult(code = FLTConstant.paramErrorCode, errorDetails = "updateParam is null"))
            } else {
                val name = updateParam["name"] as? String
                val avatar = updateParam["avatar"] as? String
                val sign = updateParam["sign"] as? String
                val email = updateParam["email"] as? String
                val birth = updateParam["birthday"] as? String
                val mobile = updateParam["mobile"] as? String
                val gender = updateParam["gender"] as? Int
                val extension = updateParam["serverExtension"] as? String
                val param = V2NIMUserUpdateParamsBuilder.builder()
                if (name != null) {
                    param.withName(name)
                }
                if (avatar != null) {
                    param.withAvatar(avatar)
                }
                if (sign != null) {
                    param.withSign(sign)
                }
                if (email != null) {
                    param.withEmail(email)
                }
                if (birth != null) {
                    param.withBirthday(birth)
                }
                if (mobile != null) {
                    param.withMobile(mobile)
                }
                if (gender != null) {
                    param.withGender(gender)
                }
                if (extension != null) {
                    param.withServerExtension(extension)
                }

                NIMClient.getService(V2NIMUserService::class.java).updateSelfUserProfile(
                    param.build(),
                    {
                        cont.resume(NimResult.SUCCESS)
                    }
                ) { error ->
                    cont.resume(
                        if (error != null) {
                            NimResult(code = error.code, errorDetails = error.desc)
                        } else {
                            NimResult(code = -1, errorDetails = "updateSelfUserProfile failed!")
                        }
                    )
                }
            }
        }
    }

    /**
     * 添加用户到黑名单中
     */
    private suspend fun addUserToBlockList(
        arguments: Map<String, *>
    ): NimResult<Nothing> {
        return suspendCancellableCoroutine { cont ->
            val userId = arguments["userId"] as? String
            if (userId == null) {
                cont.resume(
                    NimResult(
                        code = FLTConstant.paramErrorCode,
                        errorDetails = "addUserToBlockList but the userId is empty!"
                    )
                )
            } else {
                NIMClient.getService(V2NIMUserService::class.java).addUserToBlockList(
                    userId,
                    {
                        cont.resume(NimResult.SUCCESS)
                    }
                ) { error ->
                    cont.resume(
                        if (error != null) {
                            NimResult(code = error.code, errorDetails = error.desc)
                        } else {
                            NimResult(code = -1, errorDetails = "addUserToBlockList failed!")
                        }
                    )
                }
            }
        }
    }

    /**
     * 从黑名单中移除用户
     */
    private suspend fun removeUserFromBlockList(
        arguments: Map<String, *>
    ): NimResult<Nothing> {
        return suspendCancellableCoroutine { cont ->
            val userId = arguments["userId"] as? String
            if (userId == null) {
                cont.resume(
                    NimResult(
                        code = FLTConstant.paramErrorCode,
                        errorDetails = "removeUserFromBlockList but the userId is empty!"
                    )
                )
            } else {
                NIMClient.getService(V2NIMUserService::class.java).removeUserFromBlockList(
                    userId,
                    {
                        cont.resume(NimResult.SUCCESS)
                    }
                ) { error ->
                    cont.resume(
                        if (error != null) {
                            NimResult(code = error.code, errorDetails = error.desc)
                        } else {
                            NimResult(code = -1, errorDetails = "removeUserFromBlockList failed!")
                        }
                    )
                }
            }
        }
    }

    /**
     * 获取黑名单列表
     */
    private suspend fun getBlockList(
        arguments: Map<String, *>
    ): NimResult<Map<String, Any?>?> {
        return suspendCancellableCoroutine { cont ->
            NIMClient.getService(V2NIMUserService::class.java).getBlockList(
                { result ->
                    cont.resume(NimResult(code = 0, data = mutableMapOf("userIdList" to result)))
                }
            ) { error ->
                cont.resume(
                    if (error != null) {
                        NimResult(code = error.code, errorDetails = error.desc)
                    } else {
                        NimResult(code = -1, errorDetails = "getBlockList failed!")
                    }
                )
            }
        }
    }

    /**
     * 根据关键字搜索用户信息
     * Params:
     * userSearchOption – 用户搜索相关参数
     */
    private suspend fun searchUserByOption(
        arguments: Map<String, *>
    ): NimResult<Map<String, Any?>?> {
        return suspendCancellableCoroutine { cont ->
            val userSearchOption = arguments["userSearchOption"] as? Map<String, *>
            val keyword = userSearchOption?.get("keyword") as? String
            if (keyword == null) {
                cont.resume(
                    NimResult(
                        code = FLTConstant.paramErrorCode,
                        errorDetails = "searchUserByOption but the keyword is empty!"
                    )
                )
            } else {
                val searchName = userSearchOption?.get("searchName") as? Boolean
                val searchAccountId = userSearchOption?.get("searchAccountId") as? Boolean
                val searchMobile = userSearchOption?.get("searchMobile") as? Boolean
                val searchOption =
                    V2NIMUserSearchOption.V2NIMUserSearchOptionBuilder.builder(keyword)
                if (searchName != null) {
                    searchOption.withSearchName(searchName)
                }
                if (searchAccountId != null) {
                    searchOption.withSearchAccountId(searchAccountId)
                }
                if (searchMobile != null) {
                    searchOption.withSearchMobile(searchMobile)
                }
                NIMClient.getService(V2NIMUserService::class.java).searchUserByOption(
                    searchOption.build(),
                    { result ->
                        cont.resume(
                            NimResult(
                                code = 0,
                                data =
                                mutableMapOf(
                                    "userInfoList" to result.map { it?.toMap() }
                                )
                            )
                        )
                    }
                ) { error ->
                    cont.resume(
                        if (error != null) {
                            NimResult(code = error.code, errorDetails = error.desc)
                        } else {
                            NimResult(code = -1, errorDetails = "searchUserByOption failed!")
                        }
                    )
                }
            }
        }
    }

    init {
        nimCore.onInitialized {
            NIMClient.getService(V2NIMUserService::class.java).addUserListener(userListener)
        }
        registerFlutterMethodCalls(
            "getUserList" to ::getUserList,
            "getUserListFromCloud" to ::getUserListFromCloud,
            "updateSelfUserProfile" to ::updateSelfUserProfile,
            "addUserToBlockList" to ::addUserToBlockList,
            "removeUserFromBlockList" to ::removeUserFromBlockList,
            "getBlockList" to ::getBlockList,
            "searchUserByOption" to ::searchUserByOption
        )
    }

    private val userListener =
        object : V2NIMUserListener {
            override fun onUserProfileChanged(users: MutableList<V2NIMUser>?) {
                notifyEvent(
                    "onUserProfileChanged",
                    mutableMapOf(
                        "userInfoList" to
                            users?.map { it.toMap() }
                                ?.toList()
                    )
                )
            }

            override fun onBlockListAdded(user: V2NIMUser?) {
                if (user != null) {
                    notifyEvent("onBlockListAdded", user!!.toMap())
                } else {
                    notifyEvent("onBlockListAdded", mutableMapOf())
                }
            }

            override fun onBlockListRemoved(accountId: String?) {
                notifyEvent(
                    "onBlockListRemoved",
                    mutableMapOf(
                        "userId" to accountId
                    )
                )
            }
        }
}
