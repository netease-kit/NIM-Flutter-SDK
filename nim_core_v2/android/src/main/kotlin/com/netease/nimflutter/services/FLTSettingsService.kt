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
import com.netease.nimflutter.toMap
import com.netease.nimlib.sdk.NIMClient
import com.netease.nimlib.sdk.v2.setting.V2NIMDndConfig.V2NIMDndConfigBuilder
import com.netease.nimlib.sdk.v2.setting.V2NIMSettingListener
import com.netease.nimlib.sdk.v2.setting.V2NIMSettingService
import com.netease.nimlib.sdk.v2.setting.enums.V2NIMP2PMessageMuteMode
import com.netease.nimlib.sdk.v2.setting.enums.V2NIMTeamMessageMuteMode
import com.netease.nimlib.sdk.v2.team.enums.V2NIMTeamType
import com.netease.yunxin.kit.alog.ALog
import kotlin.coroutines.resume
import kotlinx.coroutines.suspendCancellableCoroutine

class FLTSettingsService(
    applicationContext: Context,
    nimCore: NimCore
) : FLTService(applicationContext, nimCore) {
    private val settingService: V2NIMSettingService by lazy {
        NIMClient.getService(V2NIMSettingService::class.java)
    }

    override val serviceName = "SettingsService"

    init {
        nimCore.onInitialized {
            settingService.addSettingListener(settingListener)
        }
        registerFlutterMethodCalls(
            "getConversationMuteStatus" to this::getConversationMuteStatus,
            "getP2PMessageMuteMode" to this::getP2PMessageMuteMode,
            "getDndConfig" to this::getDndConfig,
            "getP2PMessageMuteList" to this::getP2PMessageMuteList,
            "getTeamMessageMuteMode" to this::getTeamMessageMuteMode,
            "setDndConfig" to this::setDndConfig,
            "setP2PMessageMuteMode" to this::setP2PMessageMuteMode,
            "setPushMobileOnDesktopOnline" to this::setPushMobileOnDesktopOnline,
            "setTeamMessageMuteMode" to this::setTeamMessageMuteMode
        )
    }

    // 获取会话消息免打扰状态
    // Params:
    // conversationId – 会话id
    private suspend fun getConversationMuteStatus(arguments: Map<String, *>): NimResult<Boolean> {
        return suspendCancellableCoroutine { cont ->
            val conversationId = arguments["conversationId"] as String?
            if (conversationId == null) {
                cont.resume(
                    NimResult(
                        code = -1,
                        errorDetails = "getConversationMuteStatus param is invalid"
                    )
                )
            } else {
                val muteStatus = settingService.getConversationMuteStatus(conversationId)
                cont.resume(
                    NimResult(
                        code = 0,
                        data = muteStatus
                    )
                )
            }
        }
    }

    // 获取群消息提醒模式
    // Params:
    // teamId – 群组id teamType – 群组类型
    private suspend fun getTeamMessageMuteMode(arguments: Map<String, *>): NimResult<Map<String, Any?>?> {
        return suspendCancellableCoroutine { cont ->
            val teamId = arguments["teamId"] as String?
            val teamType = arguments["teamType"] as Int?

            if (teamId == null || teamType == null) {
                cont.resume(
                    NimResult(
                        code = -1,
                        errorDetails = "getConversationMuteStatus param is invalid"
                    )
                )
            } else {
                val muteStatus =
                    settingService.getTeamMessageMuteMode(
                        teamId,
                        V2NIMTeamType.typeOfValue(teamType)
                    )
                cont.resume(
                    NimResult(
                        code = 0,
                        data = mapOf("muteMode" to muteStatus?.value)
                    )
                )
            }
        }
    }

    // 设置群消息免打扰模式
    // Params:
    // teamId – 群组id
    // teamType – 群组类型
    // muteMode – 设置的消息提醒模式
    private suspend fun setTeamMessageMuteMode(arguments: Map<String, *>): NimResult<Nothing> {
        return suspendCancellableCoroutine { cont ->
            val teamId = arguments["teamId"] as String?
            val teamType = arguments["teamType"] as Int?
            val muteMode = arguments["muteMode"] as Int?

            if (teamId == null || teamType == null ||
                muteMode == null
            ) {
                cont.resume(
                    NimResult(
                        code = -1,
                        errorDetails = "getConversationMuteStatus param is invalid"
                    )
                )
            } else {
                settingService.setTeamMessageMuteMode(
                    teamId,
                    V2NIMTeamType.typeOfValue(teamType),
                    V2NIMTeamMessageMuteMode.typeOfValue(muteMode),
                    {
                        cont.resume(NimResult.SUCCESS)
                    },
                    { error ->
                        cont.resume(
                            if (error != null) {
                                NimResult(code = error.code, errorDetails = error.desc)
                            } else {
                                NimResult(code = -1, errorDetails = "updateTeamInfo failed!")
                            }
                        )
                    }
                )
            }
        }
    }

    // 设置P2P消息免打扰模式
    // Params:
    // accountId
    // muteMode
    private suspend fun setP2PMessageMuteMode(arguments: Map<String, *>): NimResult<Nothing> {
        return suspendCancellableCoroutine { cont ->
            val accountId = arguments["accountId"] as String?
            val muteMode = arguments["muteMode"] as Int?

            if (accountId == null ||
                muteMode == null
            ) {
                cont.resume(
                    NimResult(
                        code = -1,
                        errorDetails = "setP2PMessageMuteMode param is invalid"
                    )
                )
            } else {
                settingService.setP2PMessageMuteMode(
                    accountId,
                    V2NIMP2PMessageMuteMode.typeOfValue(muteMode),
                    {
                        cont.resume(NimResult.SUCCESS)
                    },
                    { error ->
                        cont.resume(
                            if (error != null) {
                                NimResult(code = error.code, errorDetails = error.desc)
                            } else {
                                NimResult(code = -1, errorDetails = "setP2PMessageMuteMode failed!")
                            }
                        )
                    }
                )
            }
        }
    }

    // 获取P2P消息免打扰模式
    // Params:
    // accountId 账号ID
    private suspend fun getP2PMessageMuteMode(arguments: Map<String, *>): NimResult<Map<String, Any?>?> {
        return suspendCancellableCoroutine { cont ->
            val accountId = arguments["accountId"] as String?

            if (accountId == null) {
                cont.resume(
                    NimResult(
                        code = -1,
                        errorDetails = "getP2PMessageMuteMode param is invalid"
                    )
                )
            } else {
                val muteStatus = settingService.getP2PMessageMuteMode(accountId)
                cont.resume(
                    NimResult(
                        code = 0,
                        data = mapOf("muteMode" to muteStatus.value)
                    )
                )
            }
        }
    }

    // 获取点对点消息免打扰列表 返回V2NIMP2PMessageMuteMode状态为V2NIM_P2P_MESSAGE_MUTE_MODE_ON的用户
    private suspend fun getP2PMessageMuteList(arguments: Map<String, *>): NimResult<Map<String, Any?>?> {
        return suspendCancellableCoroutine { cont ->
            settingService.getP2PMessageMuteList(
                {
                    cont.resume(
                        NimResult(
                            code = 0,
                            data = mapOf("muteList" to it)
                        )
                    )
                },
                { error ->
                    cont.resume(
                        if (error != null) {
                            NimResult(code = error.code, errorDetails = error.desc)
                        } else {
                            NimResult(code = -1, errorDetails = "getP2PMessageMuteList failed!")
                        }
                    )
                }
            )
        }
    }

    // 设置当桌面端在线时，移动端是否需要推送 运行在移动端时， 需要调用该接口
    // Params:
    // need – 免打扰与详情配置参数 桌面端在线时，移动端是否需要推送 true： 需要 fasle：不需要
    private suspend fun setPushMobileOnDesktopOnline(arguments: Map<String, *>): NimResult<Nothing> {
        return suspendCancellableCoroutine { cont ->
            val need = arguments["need"] as Boolean?

            if (need == null) {
                cont.resume(
                    NimResult(
                        code = -1,
                        errorDetails = "setPushMobileOnDesktopOnline param is invalid"
                    )
                )
            } else {
                settingService.setPushMobileOnDesktopOnline(
                    need,
                    {
                        cont.resume(NimResult.SUCCESS)
                    },
                    { error ->
                        cont.resume(
                            if (error != null) {
                                NimResult(code = error.code, errorDetails = error.desc)
                            } else {
                                NimResult(code = -1, errorDetails = "setPushMobileOnDesktopOnline failed!")
                            }
                        )
                    }
                )
            }
        }
    }

    // 设置Apns免打扰与详情显示
    // Params:
    // config – 免打扰与详情配置参数 success – 请求成功的回调 failure – 请求失败的回调
    private suspend fun setDndConfig(arguments: Map<String, *>): NimResult<Nothing> {
        return suspendCancellableCoroutine { cont ->
            val config = arguments["config"] as Map<String, *>?
            if (config == null) {
                cont.resume(
                    NimResult(
                        code = -1,
                        errorDetails = "setDndConfig param is invalid"
                    )
                )
            } else {
                val showDetail = config["showDetail"] as Boolean?
                val dndOn = config["dndOn"] as Boolean?
                val fromH = if (config["fromH"] as Int? == null) 0 else config["fromH"] as Int
                val fromM = if (config["fromM"] as Int? == null) 0 else config["fromM"] as Int
                val toM = if (config["toM"] as Int? == null) 0 else config["toM"] as Int
                val toH = if (config["toH"] as Int? == null) 0 else config["toH"] as Int
                val dndConfig = V2NIMDndConfigBuilder.builder(fromH, fromM, toH, toM)
                showDetail?.let { dndConfig.withShowDetail(it) }
                dndOn?.let { dndConfig.withDndOn(it) }
                settingService.setDndConfig(
                    dndConfig.build(),
                    {
                        cont.resume(NimResult.SUCCESS)
                    },
                    { error ->
                        cont.resume(
                            if (error != null) {
                                NimResult(code = error.code, errorDetails = error.desc)
                            } else {
                                NimResult(code = -1, errorDetails = "setDndConfig failed!")
                            }
                        )
                    }
                )
            }
        }
    }

    // 获取Apns免打扰与详情显示
    // Returns:
    // 免打扰与详情配置参数
    private suspend fun getDndConfig(arguments: Map<String, *>): NimResult<Map<String, Any?>?> {
        return suspendCancellableCoroutine { cont ->
            val config = settingService.dndConfig
            cont.resume(
                NimResult(
                    code = 0,
                    data = config?.toMap()
                )
            )
        }
    }

    private val settingListener =
        object : V2NIMSettingListener {
            override fun onTeamMessageMuteModeChanged(
                teamId: String,
                teamType: V2NIMTeamType,
                muteMode: V2NIMTeamMessageMuteMode
            ) {
                ALog.i(
                    "FLTSettingsService",
                    "onTeamMessageMuteModeChanged",
                    "teamId:$teamId," +
                        "muteModel:${muteMode.value}"
                )
                notifyEvent("onTeamMessageMuteModeChanged", mapOf("teamType" to teamType.value, "teamId" to teamId, "muteMode" to muteMode.value))
            }

            override fun onP2PMessageMuteModeChanged(
                accountId: String?,
                muteMode: V2NIMP2PMessageMuteMode?
            ) {
                ALog.i(
                    "FLTSettingsService",
                    "onP2PMessageMuteModeChanged",
                    "teamId:$accountId," +
                        "muteModel:${muteMode?.value}"
                )
                notifyEvent(
                    "onP2PMessageMuteModeChanged",
                    mapOf(
                        "accountId" to accountId,
                        "muteMode" to muteMode?.value
                    )
                )
            }
        }
}
