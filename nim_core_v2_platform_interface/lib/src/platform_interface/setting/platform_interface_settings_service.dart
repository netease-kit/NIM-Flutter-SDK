// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:async';
import 'package:nim_core_v2_platform_interface/nim_core_v2_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:nim_core_v2_platform_interface/src/method_channel/method_channel_settings_service.dart';

abstract class SettingsServicePlatform extends Service {
  SettingsServicePlatform() : super(token: _token);

  static final Object _token = Object();

  static SettingsServicePlatform _instance = MethodChannelSettingsService();

  static SettingsServicePlatform get instance => _instance;

  static set instance(SettingsServicePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /**
   *  获取会话消息免打扰状态
   *  @param conversationId 会话id
   */
  Future<NIMResult<bool>> getConversationMuteStatus(
      String conversationId) async {
    throw UnimplementedError();
  }

  /**
  *  设置群组消息免打扰模式
  *  @param teamId 群组Id
  *  @param teamType 群组类型
  *  @param muteMode 群组消息免打扰模式
  */
  Future<NIMResult<void>> setTeamMessageMuteMode(String teamId,
      NIMTeamType teamType, NIMTeamMessageMuteMode muteMode) async {
    throw UnimplementedError();
  }

  /**
   *  获取群消息免打扰模式
   *
   *  @param teamId 群组id
   *  @param teamType 群组类型
   */
  Future<NIMResult<NIMTeamMessageMuteMode?>> getTeamMessageMuteMode(
      String teamId, NIMTeamType teamType) async {
    throw UnimplementedError();
  }

  /**
   *  设置点对点消息免打扰模式
   *
   *  @param accountId 账号Id
   *  @param muteMode 点对点消息免打扰模式
   */
  Future<NIMResult<void>> setP2PMessageMuteMode(
      String accountId, NIMP2PMessageMuteMode muteMode) async {
    throw UnimplementedError();
  }

  /**
   *  获取点对点消息免打扰模式
   *
   *  @param accountId 账号id
   */
  Future<NIMResult<NIMP2PMessageMuteMode>> getP2PMessageMuteMode(
      String accountId) async {
    throw UnimplementedError();
  }

  /**
   *  获取点对点消息免打扰列表
   *
   *  @param success 返回V2NIMP2PMessageMuteMode状态为V2NIM_P2P_MESSAGE_MUTE_MODE_ON的用户
   */
  Future<NIMResult<List<String>>> getP2PMessageMuteList() async {
    throw UnimplementedError();
  }

  /**
   *  设置应用前后台状态
   *
   *  @param success 返回V2NIMP2PMessageMuteMode状态为V2NIM_P2P_MESSAGE_MUTE_MODE_ON的用户
   */
  Future<NIMResult<void>> setAppBackground(bool isBackground, int badge) async {
    throw UnimplementedError();
  }

  /**
   *  设置当桌面端在线时，移动端是否需要推送
   *  运行在移动端时， 需要调用该接口
   *
   *  @param need 桌面端在线时，移动端是否需要推送 true： 需要 fasle：不需要
   */
  Future<NIMResult<void>> setPushMobileOnDesktopOnline(bool need) async {
    throw UnimplementedError();
  }

  /**
   *  设置Apns免打扰与详情显示
   *
   *  @param config 免打扰与详情配置参数
   */
  Future<NIMResult<void>> setDndConfig(NIMDndConfig config) async {
    throw UnimplementedError();
  }

  /**
   *  读取免打扰与详情显示
   *
   *  @param config 免打扰与详情配置参数
   */
  Future<NIMResult<NIMDndConfig>> getDndConfig() async {
    throw UnimplementedError();
  }

  /**
   *  群组消息免打扰回调
   *
   *  @param teamId 群组id
   *  @param teamType 群组类型
   *  @param muteMode 群组免打扰模式
   */
  StreamController<TeamMuteModeChangedResult> onTeamMessageMuteModeChanged =
      StreamController.broadcast();

  /**
   *  点对点消息免打扰回调
   *
   *  @param accountId 账号id
   *  @param muteMode 用户免打扰模式
   */
  StreamController<P2PMuteModeChangedResult> onP2PMessageMuteModeChanged =
      StreamController.broadcast();
}
