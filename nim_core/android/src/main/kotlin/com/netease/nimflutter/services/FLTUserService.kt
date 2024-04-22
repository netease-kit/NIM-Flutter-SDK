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
import com.netease.nimflutter.ResultCallback
import com.netease.nimflutter.SafeResult
import com.netease.nimflutter.toMap
import com.netease.nimlib.sdk.NIMClient
import com.netease.nimlib.sdk.Observer
import com.netease.nimlib.sdk.RequestCallback
import com.netease.nimlib.sdk.friend.FriendService
import com.netease.nimlib.sdk.friend.FriendServiceObserve
import com.netease.nimlib.sdk.friend.constant.FriendFieldEnum
import com.netease.nimlib.sdk.friend.constant.VerifyType
import com.netease.nimlib.sdk.friend.model.AddFriendData
import com.netease.nimlib.sdk.friend.model.BlackListChangedNotify
import com.netease.nimlib.sdk.friend.model.Friend
import com.netease.nimlib.sdk.friend.model.FriendChangedNotify
import com.netease.nimlib.sdk.friend.model.MuteListChangedNotify
import com.netease.nimlib.sdk.uinfo.UserService
import com.netease.nimlib.sdk.uinfo.UserServiceObserve
import com.netease.nimlib.sdk.uinfo.constant.GenderEnum
import com.netease.nimlib.sdk.uinfo.constant.UserInfoFieldEnum
import com.netease.nimlib.sdk.uinfo.model.NimUserInfo
import com.netease.yunxin.kit.alog.ALog

class FLTUserService(
    applicationContext: Context,
    nimCore: NimCore
) : FLTService(applicationContext, nimCore) {

    private val tag = "FLTUserService"

    override val serviceName = "UserService"

    override fun onMethodCalled(method: String, arguments: Map<String, *>, safeResult: SafeResult) {
        when (method) {
            // 获取指定用户资料（本地）
            "getUserInfo" -> getUserInfo(arguments, ResultCallback(safeResult))
            "getUserInfoList" -> getUserInfoList(arguments, ResultCallback(safeResult))
            "getAllUserInfo" -> getAllUserInfo(ResultCallback(safeResult))
            // 批量获取用户资料（云端）
            "fetchUserInfoList" -> fetchUserInfoList(arguments, ResultCallback(safeResult))
            // 更新当前账号的信息
            "updateMyUserInfo" -> updateMyUserInfo(arguments, ResultCallback(safeResult))
            // 根据昵称查找账号
            "searchUserIdListByNick" -> searchUserIdListByNick(
                arguments,
                ResultCallback(safeResult)
            )
            // 根据关键字查找用户信息
            "searchUserInfoListByKeyword" -> searchUserInfoListByKeyword(
                arguments,
                ResultCallback(safeResult)
            )
            // 获取所有好友信息
            "getFriendList" -> getFriendList(ResultCallback(safeResult))
            "getFriend" -> getFriend(arguments, ResultCallback(safeResult))
            "getFriendAccounts" -> getFriendAccounts(ResultCallback(safeResult))
            "searchAccountByAlias" -> searchAccountByAlias(arguments, ResultCallback(safeResult))
            "searchFriendsByKeyword" -> searchFriendsByKeyword(
                arguments,
                ResultCallback(safeResult)
            )
            "addFriend" -> addFriend(arguments, ResultCallback(safeResult))
            "ackAddFriend" -> ackAddFriend(arguments, ResultCallback(safeResult))
            "deleteFriend" -> deleteFriend(arguments, ResultCallback(safeResult))
            "isMyFriend" -> isMyFriend(arguments, ResultCallback(safeResult))
            "updateFriend" -> updateFriend(arguments, ResultCallback(safeResult))

            "getBlackList" -> getBlackList(ResultCallback(safeResult))
            "addToBlackList" -> addToBlackList(arguments, ResultCallback(safeResult))
            "removeFromBlackList" -> removeFromBlackList(arguments, ResultCallback(safeResult))
            "isInBlackList" -> isInBlackList(arguments, ResultCallback(safeResult))

            "getMuteList" -> getMuteList(ResultCallback(safeResult))
            "setMute" -> setMute(arguments, ResultCallback(safeResult))
            "isMute" -> isMute(arguments, ResultCallback(safeResult))
            "getCurrentAccount" -> getCurrentAccount(ResultCallback(safeResult))
            else -> safeResult.notImplemented()
        }
    }

    /**
     * 获取指定用户资料（本地）
     */
    @OptIn(ExperimentalStdlibApi::class)
    private fun getUserInfo(
        arguments: Map<String, *>,
        resultCallback: ResultCallback<NimUserInfo>
    ) {
        val userId = arguments["userId"] as? String
        if (TextUtils.isEmpty(userId)) {
            resultCallback.result(
                NimResult(code = -1, errorDetails = "getUserInfo but the userId is empty!")
            )
        } else {
            val userInfo = NIMClient.getService(UserService::class.java).getUserInfo(userId)
            resultCallback.result(NimResult(code = 0, userInfo) { it.toMap() })
        }
    }

    /**
     * 从本地数据库中批量获取用户资料
     */
    @OptIn(ExperimentalStdlibApi::class)
    private fun getUserInfoList(
        arguments: Map<String, *>,
        resultCallback: ResultCallback<List<NimUserInfo?>>
    ) {
        val userIdList = arguments["userIdList"] as? List<String>
        if (userIdList.isNullOrEmpty()) {
            resultCallback.result(
                NimResult(code = -1, errorDetails = "getUserInfoList but the userIds is empty!")
            )
        } else {
            var userInfo = NIMClient.getService(UserService::class.java).getUserInfoList(userIdList)
            resultCallback.result(
                NimResult(
                    code = 0,
                    userInfo
                ) {
                    mutableMapOf(
                        "userInfoList" to it.map { it1 -> it1?.toMap() }
                            .toList()
                    )
                }
            )
        }
    }

    /**
     * 获取本地数据库中所有用户资料
     */
    @OptIn(ExperimentalStdlibApi::class)
    private fun getAllUserInfo(resultCallback: ResultCallback<List<NimUserInfo?>>) {
        var userInfo = NIMClient.getService(UserService::class.java).getAllUserInfo()
        resultCallback.result(
            NimResult(
                code = 0,
                userInfo
            ) {
                mutableMapOf(
                    "userInfoList" to it.map { it1 -> it1?.toMap() }
                        .toList()
                )
            }
        )
    }

    /**
     * 批量获取用户资料（云端）
     */
    @Suppress("UNCHECKED_CAST")
    @OptIn(ExperimentalStdlibApi::class)
    private fun fetchUserInfoList(
        arguments: Map<String, *>,
        resultCallback: ResultCallback<List<NimUserInfo?>>
    ) {
        val userIdList = arguments["userIdList"] as? List<String>
        if (userIdList.isNullOrEmpty()) {
            resultCallback.result(
                NimResult(code = -1, errorDetails = "fetchUserInfos but the userIds is empty!")
            )
        } else {
            NIMClient.getService(UserService::class.java).fetchUserInfo(userIdList)
                .setCallback(object : RequestCallback<List<NimUserInfo?>?> {
                    override fun onSuccess(param: List<NimUserInfo?>?) {
                        ALog.d(tag, "fetchUserInfo onSuccess")
                        resultCallback.result(
                            NimResult(
                                code = 0,
                                param
                            ) {
                                mutableMapOf(
                                    "userInfoList" to it.map { it1 -> it1?.toMap() }
                                        .toList()
                                )
                            }
                        )
                    }

                    override fun onFailed(code: Int) {
                        onFailed("fetchUserInfo", code, resultCallback)
                    }

                    override fun onException(exception: Throwable?) {
                        onException("fetchUserInfo", exception, resultCallback)
                    }
                })
        }
    }

    /**
     * 更新当前账号的信息
     */
    private fun updateMyUserInfo(
        arguments: Map<String, *>,
        resultCallback: ResultCallback<List<NimUserInfo?>>
    ) {
        val fields: HashMap<UserInfoFieldEnum, Any?> = HashMap()
        val nick = arguments["nick"] as? String
        if (nick != null) {
            fields[UserInfoFieldEnum.Name] = nick
        }
        val avatar = arguments["avatar"] as? String
        if (!TextUtils.isEmpty(avatar)) {
            fields[UserInfoFieldEnum.AVATAR] = avatar
        }
        val birthday = arguments["birthday"] as? String
        if (!TextUtils.isEmpty(birthday)) {
            fields[UserInfoFieldEnum.BIRTHDAY] = birthday
        }
        val email = arguments["email"] as? String
        if (!TextUtils.isEmpty(email)) {
            fields[UserInfoFieldEnum.EMAIL] = email
        }
        val genderStr = arguments["gender"] as? String
        if (!TextUtils.isEmpty(genderStr)) {
            val gender = when (genderStr) {
                "male" -> GenderEnum.MALE
                "female" -> GenderEnum.FEMALE
                else -> {
                    GenderEnum.UNKNOWN
                }
            }
            fields[UserInfoFieldEnum.GENDER] = gender.value
        }
        val mobile = arguments["mobile"] as? String
        if (!TextUtils.isEmpty(mobile)) {
            fields[UserInfoFieldEnum.MOBILE] = mobile
        }
        val signature = arguments["signature"] as? String
        if (!TextUtils.isEmpty(signature)) {
            fields[UserInfoFieldEnum.SIGNATURE] = signature
        }
        val extension = arguments["extension"] as? String
        if (!TextUtils.isEmpty(extension)) {
            fields[UserInfoFieldEnum.EXTEND] = extension
        }

        NIMClient.getService(UserService::class.java).updateUserInfo(fields).setCallback(object :
            RequestCallback<Void> {
            override fun onSuccess(param: Void?) {
                ALog.d(tag, "updateMyUserInfo onSuccess")
                resultCallback.result(NimResult(code = 0))
            }

            override fun onFailed(code: Int) {
                onFailed("updateMyUserInfo", code, resultCallback)
            }

            override fun onException(exception: Throwable?) {
                onException("updateMyUserInfo", exception, resultCallback)
            }
        })
    }

    /**
     * 根据昵称查找账号
     */
    private fun searchUserIdListByNick(
        arguments: Map<String, *>,
        resultCallback: ResultCallback<List<String?>>
    ) {
        val nick = arguments["nick"] as? String
        if (TextUtils.isEmpty(nick)) {
            resultCallback.result(
                NimResult(
                    code = -1,
                    errorDetails = "searchUserIdByNick by " + "nick is empty"
                )
            )
        } else {
            NIMClient.getService(UserService::class.java).searchAccountByName(nick)
                .setCallback(object : RequestCallback<List<String?>?> {
                    override fun onSuccess(param: List<String?>?) {
                        ALog.d(tag, "searchUserIdByNick onSuccess")
                        resultCallback.result(
                            NimResult(code = 0, param) {
                                mutableMapOf("userIdList" to it.map { it1 -> it1 }.toList())
                            }
                        )
                    }

                    override fun onFailed(code: Int) {
                        onFailed("searchUserIdListByNick", code, resultCallback)
                    }

                    override fun onException(exception: Throwable?) {
                        onException("searchUserIdListByNick", exception, resultCallback)
                    }
                })
        }
    }

    /**
     * 根据关键字查找用户信息
     */
    @OptIn(ExperimentalStdlibApi::class)
    private fun searchUserInfoListByKeyword(
        arguments: Map<String, *>,
        resultCallback: ResultCallback<List<NimUserInfo?>>
    ) {
        val keyword = arguments["keyword"] as? String
        if (TextUtils.isEmpty(keyword)) {
            resultCallback.result(
                NimResult(
                    code = -1,
                    errorDetails = "searchUserInfoByKeyword " + "but keyword is empty"
                )
            )
        } else {
            NIMClient.getService(UserService::class.java).searchUserInfosByKeyword(keyword)
                .setCallback(object : RequestCallback<List<NimUserInfo?>?> {
                    override fun onSuccess(param: List<NimUserInfo?>?) {
                        ALog.d(tag, "searchUserInfoListByKeyword onSuccess")
                        resultCallback.result(
                            NimResult(code = 0, param) {
                                mutableMapOf(
                                    "userInfoList" to it.map { it1 -> it1?.toMap() }
                                        .toList()
                                )
                            }
                        )
                    }

                    override fun onFailed(code: Int) {
                        onFailed("searchUserInfoListByKeyword", code, resultCallback)
                    }

                    override fun onException(exception: Throwable?) {
                        onException("searchUserInfoListByKeyword", exception, resultCallback)
                    }
                })
        }
    }

    /**
     * 获取所有好友信息
     */
    private fun getFriendList(
        resultCallback: ResultCallback<List<Friend?>>
    ) {
        val friends = NIMClient.getService(FriendService::class.java).friends
        println("$tag getFriendList result = $friends")
        resultCallback.result(
            NimResult(code = 0, friends) {
                mutableMapOf("friendList" to it.map { it1 -> it1?.toMap() }.toList())
            }
        )
    }

    /**
     * 获取指定好友资料（本地）
     */
    private fun getFriend(
        arguments: Map<String, *>,
        resultCallback: ResultCallback<Friend>
    ) {
        val userId = arguments["userId"] as? String
        if (TextUtils.isEmpty(userId)) {
            resultCallback.result(
                NimResult(code = -1, errorDetails = "getFriend but the userId is empty!")
            )
        } else {
            val userInfo =
                NIMClient.getService(FriendService::class.java).getFriendByAccount(userId)
            resultCallback.result(NimResult(code = 0, userInfo) { it.toMap() })
        }
    }

    /**
     * 获取所有的好友帐号
     */
    private fun getFriendAccounts(
        resultCallback: ResultCallback<List<String>>
    ) {
        val blackList = NIMClient.getService(FriendService::class.java).friendAccounts
        resultCallback.result(
            NimResult(code = 0, blackList) {
                mutableMapOf("userIdList" to it)
            }
        )
    }

    /**
     * 根据备注反查账号
     */
    private fun searchAccountByAlias(
        arguments: Map<String, *>,
        resultCallback: ResultCallback<List<String?>>
    ) {
        val alias = arguments["alias"] as? String
        NIMClient.getService(FriendService::class.java).searchAccountByAlias(alias)
            .setCallback(object : RequestCallback<List<String?>?> {
                override fun onSuccess(param: List<String?>?) {
                    ALog.d(tag, "searchAccountByAlias onSuccess")
                    resultCallback.result(
                        NimResult(code = 0, param) {
                            mutableMapOf("userIdList" to it.map { it1 -> it1 }.toList())
                        }
                    )
                }

                override fun onFailed(code: Int) {
                    onFailed("searchAccountByAlias onFailed", code, resultCallback)
                }

                override fun onException(exception: Throwable?) {
                    onException("searchAccountByAlias onException", exception, resultCallback)
                }
            })
    }

    /**
     * 搜索与关键字匹配的所有好友
     */
    private fun searchFriendsByKeyword(
        arguments: Map<String, *>,
        resultCallback: ResultCallback<List<Friend?>>
    ) {
        val keyword = arguments["keyword"] as? String
        NIMClient.getService(FriendService::class.java).searchFriendsByKeyword(keyword)
            .setCallback(object : RequestCallback<List<Friend?>?> {
                override fun onSuccess(param: List<Friend?>?) {
                    ALog.d(tag, "searchFriendsByKeyword onSuccess")
                    resultCallback.result(
                        NimResult(code = 0, param) {
                            mutableMapOf("friendList" to it.map { it1 -> it1?.toMap() }.toList())
                        }
                    )
                }

                override fun onFailed(code: Int) {
                    onFailed("searchFriendsByKeyword onFailed", code, resultCallback)
                }

                override fun onException(exception: Throwable?) {
                    onException("searchFriendsByKeyword onException", exception, resultCallback)
                }
            })
    }

    /**
     * 获取黑名单列表
     */
    private fun getBlackList(
        resultCallback: ResultCallback<List<String>>
    ) {
        val blackList = NIMClient.getService(FriendService::class.java).blackList
        resultCallback.result(
            NimResult(code = 0, blackList) {
                mutableMapOf("userIdList" to it)
            }
        )
    }

    /**
     * 获取免打扰列表
     */
    private fun getMuteList(
        resultCallback: ResultCallback<List<String>>
    ) {
        val muteList = NIMClient.getService(FriendService::class.java).muteList
        resultCallback.result(
            NimResult(code = 0, muteList) {
                mutableMapOf("userIdList" to it)
            }
        )
    }

    /**
     * 添加用户到黑名单
     */
    private fun addToBlackList(
        arguments: Map<String, *>,
        resultCallback: ResultCallback<Void>
    ) {
        val userId = arguments["userId"] as? String
        NIMClient.getService(FriendService::class.java).addToBlackList(userId)
            .setCallback(object : RequestCallback<Void> {
                override fun onSuccess(param: Void?) {
                    ALog.d(tag, "addToBlackList onSuccess")
                    resultCallback.result(NimResult(code = 0))
                }

                override fun onFailed(code: Int) {
                    onFailed("addToBlackList", code, resultCallback)
                }

                override fun onException(exception: Throwable?) {
                    onException("addToBlackList", exception, resultCallback)
                }
            })
    }

    /**
     * 添加用户到黑名单
     */
    private fun setMute(
        arguments: Map<String, *>,
        resultCallback: ResultCallback<Void>
    ) {
        val userId = arguments["userId"] as? String
        val isMute = arguments["isMute"] as? Boolean ?: true
        NIMClient.getService(FriendService::class.java).setMessageNotify(userId, !isMute)
            .setCallback(object : RequestCallback<Void> {
                override fun onSuccess(param: Void?) {
                    ALog.d(tag, "setMute onSuccess")
                    resultCallback.result(NimResult(code = 0))
                }

                override fun onFailed(code: Int) {
                    onFailed("setMute", code, resultCallback)
                }

                override fun onException(exception: Throwable?) {
                    onException("setMute", exception, resultCallback)
                }
            })
    }

    /**
     * 添加用户到黑名单
     */
    private fun isMute(
        arguments: Map<String, *>,
        resultCallback: ResultCallback<Boolean>
    ) {
        val userId = arguments["userId"] as? String
        val isNotify = NIMClient.getService(FriendService::class.java).isNeedMessageNotify(userId)
        ALog.d(tag, "userId = $userId isMute = ${!isNotify}")
        resultCallback.result(NimResult(code = 0, !isNotify))
    }

    private fun getCurrentAccount(
        resultCallback: ResultCallback<String>
    ) {
        val account = NIMClient.getCurrentAccount()
        ALog.d(tag, "account = $account")
        resultCallback.result(NimResult(code = 0, account))
    }

    /**
     * 将用户从黑名单移除
     */
    private fun removeFromBlackList(
        arguments: Map<String, *>,
        resultCallback: ResultCallback<Void>
    ) {
        val userId = arguments["userId"] as? String
        NIMClient.getService(FriendService::class.java).removeFromBlackList(userId)
            .setCallback(object : RequestCallback<Void> {
                override fun onSuccess(param: Void?) {
                    ALog.d(tag, "removeFromBlackList onSuccess")
                    resultCallback.result(NimResult(code = 0))
                }

                override fun onFailed(code: Int) {
                    onFailed("removeFromBlackList", code, resultCallback)
                }

                override fun onException(exception: Throwable?) {
                    onException("removeFromBlackList", exception, resultCallback)
                }
            })
    }

    /**
     * 判断是否已拉黑
     */
    private fun isInBlackList(
        arguments: Map<String, *>,
        resultCallback: ResultCallback<Boolean>
    ) {
        val userId = arguments["userId"] as? String
        val isInBlackList = NIMClient.getService(FriendService::class.java).isInBlackList(userId)

        ALog.d(tag, "user = $userId isInBlackList = $isInBlackList")
        resultCallback.result(NimResult(code = 0, isInBlackList))
    }

    /**
     * 申请添加好友
     */
    private fun addFriend(
        arguments: Map<String, *>,
        resultCallback: ResultCallback<Void>
    ) {
        val userId = arguments["userId"] as? String
        val message = arguments["message"] as? String
        val verifyType = arguments["verifyType"] as? Int
        var verifyTypeEnum = VerifyType.DIRECT_ADD
        when (verifyType) {
            0 -> verifyTypeEnum = VerifyType.DIRECT_ADD
            1 -> verifyTypeEnum = VerifyType.VERIFY_REQUEST
        }
        val addFriendData = AddFriendData(userId, verifyTypeEnum, message)

        NIMClient.getService(FriendService::class.java).addFriend(addFriendData)
            .setCallback(object : RequestCallback<Void> {
                override fun onSuccess(param: Void?) {
                    println("$tag addFriend onSuccess")
                    ALog.d(tag, "addFriend onSuccess")
                    resultCallback.result(NimResult(code = 0))
                }

                override fun onFailed(code: Int) {
                    onFailed("addFriend", code, resultCallback)
                }

                override fun onException(exception: Throwable?) {
                    onException("addFriend", exception, resultCallback)
                }
            })
    }

    /**
     * 回应好友申请
     */
    private fun ackAddFriend(
        arguments: Map<String, *>,
        resultCallback: ResultCallback<Void>
    ) {
        val userId = arguments["userId"] as? String
        val isAgree = arguments["isAgree"] as? Boolean ?: false

        NIMClient.getService(FriendService::class.java).ackAddFriendRequest(userId, isAgree)
            .setCallback(object : RequestCallback<Void> {
                override fun onSuccess(param: Void?) {
                    println("$tag ackAddFriend onSuccess")
                    ALog.d(tag, "ackAddFriend onSuccess")
                    resultCallback.result(NimResult(code = 0))
                }

                override fun onFailed(code: Int) {
                    onFailed("ackAddFriend", code, resultCallback)
                }

                override fun onException(exception: Throwable?) {
                    onException("ackAddFriend", exception, resultCallback)
                }
            })
    }

    /**
     * 删除好友
     */
    private fun deleteFriend(
        arguments: Map<String, *>,
        resultCallback: ResultCallback<Void>
    ) {
        val userId = arguments["userId"] as? String
        val includeAlias = arguments["includeAlias"] as? Boolean ?: true

        NIMClient.getService(FriendService::class.java).deleteFriend(userId, includeAlias)
            .setCallback(object : RequestCallback<Void> {
                override fun onSuccess(param: Void?) {
                    ALog.d(tag, "deleteFriend onSuccess")
                    resultCallback.result(NimResult(code = 0))
                }

                override fun onFailed(code: Int) {
                    onFailed("deleteFriend", code, resultCallback)
                }

                override fun onException(exception: Throwable?) {
                    onException("deleteFriend", exception, resultCallback)
                }
            })
    }

    /**
     * 判断是否已拉黑
     */
    private fun isMyFriend(
        arguments: Map<String, *>,
        resultCallback: ResultCallback<Boolean>
    ) {
        val userId = arguments["userId"] as? String
        val isMyFriend = NIMClient.getService(FriendService::class.java).isMyFriend(userId)

        ALog.d(tag, "user = $userId isMyFriend = $isMyFriend")
        resultCallback.result(NimResult(code = 0, isMyFriend))
    }

    /**
     * 修改好友资料
     */
    private fun updateFriend(
        arguments: Map<String, *>,
        resultCallback: ResultCallback<Void>
    ) {
        val userId = arguments["userId"] as? String
        val alias = arguments["alias"] as? String ?: ""

        val fields = HashMap<FriendFieldEnum, Any>()
        fields[FriendFieldEnum.ALIAS] = alias

        NIMClient.getService(FriendService::class.java).updateFriendFields(userId, fields)
            .setCallback(object : RequestCallback<Void> {
                override fun onSuccess(param: Void?) {
                    ALog.d(tag, "updateFriend onSuccess")
                    resultCallback.result(NimResult(code = 0))
                }

                override fun onFailed(code: Int) {
                    onFailed("updateFriend", code, resultCallback)
                }

                override fun onException(exception: Throwable?) {
                    onException("updateFriend", exception, resultCallback)
                }
            })
    }

    @OptIn(ExperimentalStdlibApi::class)
    private val userInfoChangedObserver =
        Observer<List<NimUserInfo>> { userInfoListChangeNotify ->
            notifyEvent(
                "onUserInfoChanged",
                mutableMapOf(
                    "changedUserInfoList" to userInfoListChangeNotify.map { it.toMap() }
                        .toList()
                )
            )
        }

    private val friendChangedObserver =
        Observer<FriendChangedNotify> { friendChangedNotify ->
            val addedOrUpdatedFriends = friendChangedNotify.addedOrUpdatedFriends // 新增的好友
            val deletedFriendAccounts = friendChangedNotify.deletedFriends // 删除好友或者被解除好友

            notifyEvent(
                "onFriendAddedOrUpdated",
                mutableMapOf(
                    "addedOrUpdatedFriendList" to addedOrUpdatedFriends.map { it.toMap() }
                        .toList()
                )
            )

            notifyEvent(
                "onFriendAccountDeleted",
                mutableMapOf(
                    "deletedFriendAccountList" to deletedFriendAccounts.map { it.toString() }
                        .toList()
                )
            )
        }

    private val blackListChangedObserve =
        Observer<BlackListChangedNotify> { _ ->
            val map = HashMap<String, Any?>()
            notifyEvent("onBlackListChanged", map)
        }

    private val muteListChangedObserve =
        Observer<MuteListChangedNotify> {
            notifyEvent("onMuteListChanged", it.toMap() as MutableMap<String, Any?>)
        }

    init {
        nimCore.onInitialized {
            NIMClient.getService(UserServiceObserve::class.java)
                .observeUserInfoUpdate(userInfoChangedObserver, true)
            NIMClient.getService(FriendServiceObserve::class.java)
                .observeFriendChangedNotify(friendChangedObserver, true)
            NIMClient.getService(FriendServiceObserve::class.java)
                .observeBlackListChangedNotify(blackListChangedObserve, true)
            NIMClient.getService(FriendServiceObserve::class.java)
                .observeMuteListChangedNotify(muteListChangedObserve, true)
        }
    }
}
