// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

part of nim_core_v2;

@HawkEntryPoint()
class SettingsService {
  factory SettingsService() {
    if (_singleton == null) {
      _singleton = SettingsService._();
    }
    return _singleton!;
  }

  SettingsService._();

  static SettingsService? _singleton;

  SettingsServicePlatform get _platform => SettingsServicePlatform.instance;

  /**
   *  获取会话消息免打扰状态
   *  @param conversationId 会话id
   */
  Future<NIMResult<bool>> getConversationMuteStatus(
      String conversationId) async {
    return _platform.getConversationMuteStatus(conversationId);
  }

  /**
   *  设置群组消息免打扰模式
   *  @param teamId 群组Id
   *  @param teamType 群组类型
   *  @param muteMode 群组消息免打扰模式
   */
  Future<NIMResult<void>> setTeamMessageMuteMode(String teamId,
      NIMTeamType teamType, NIMTeamMessageMuteMode muteMode) async {
    return _platform.setTeamMessageMuteMode(teamId, teamType, muteMode);
  }

  /**
   *  获取群消息免打扰模式
   *
   *  @param teamId 群组id
   *  @param teamType 群组类型
   */
  Future<NIMResult<NIMTeamMessageMuteMode?>> getTeamMessageMuteMode(
      String teamId, NIMTeamType teamType) async {
    return _platform.getTeamMessageMuteMode(teamId, teamType);
  }

  /**
   *  设置点对点消息免打扰模式
   *
   *  @param accountId 账号Id
   *  @param muteMode 点对点消息免打扰模式
   */
  Future<NIMResult<void>> setP2PMessageMuteMode(
      String accountId, NIMP2PMessageMuteMode muteMode) async {
    return _platform.setP2PMessageMuteMode(accountId, muteMode);
  }

  /**
   *  获取点对点消息免打扰模式
   *
   *  @param accountId 账号id
   */
  Future<NIMResult<NIMP2PMessageMuteMode>> getP2PMessageMuteMode(
      String accountId) async {
    return _platform.getP2PMessageMuteMode(accountId);
  }

  /**
   *  获取点对点消息免打扰列表
   *
   *  @param success 返回V2NIMP2PMessageMuteMode状态为V2NIM_P2P_MESSAGE_MUTE_MODE_ON的用户
   */
  Future<NIMResult<List<String>>> getP2PMessageMuteList() async {
    return _platform.getP2PMessageMuteList();
  }

  /**
   *  设置当桌面端在线时，移动端是否需要推送
   *  运行在移动端时， 需要调用该接口
   *
   *  @param need 桌面端在线时，移动端是否需要推送 true： 需要 fasle：不需要
   */
  Future<NIMResult<void>> setPushMobileOnDesktopOnline(bool need) async {
    return _platform.setPushMobileOnDesktopOnline(need);
  }

  /**
   *  设置Apns免打扰与详情显示
   *
   *  @param config 免打扰与详情配置参数
   */
  Future<NIMResult<void>> setDndConfig(NIMDndConfig config) async {
    return _platform.setDndConfig(config);
  }

  /**
   *  读取免打扰与详情显示。web 不支持
   *
   *  @param config 免打扰与详情配置参数
   */
  Future<NIMResult<NIMDndConfig>> getDndConfig() async {
    return _platform.getDndConfig();
  }

  /**
   *  群组消息免打扰回调
   *
   *  @param teamId 群组id
   *  @param teamType 群组类型
   *  @param muteMode 群组免打扰模式
   */
  @HawkApi(ignore: true)
  Stream<TeamMuteModeChangedResult> get onTeamMessageMuteModeChanged =>
      _platform.onTeamMessageMuteModeChanged.stream;

  /**
   *  点对点消息免打扰回调
   *
   *  @param accountId 账号id
   *  @param muteMode 用户免打扰模式
   */
  @HawkApi(ignore: true)
  Stream<P2PMuteModeChangedResult> get onP2PMessageMuteModeChanged =>
      _platform.onP2PMessageMuteModeChanged.stream;
}
