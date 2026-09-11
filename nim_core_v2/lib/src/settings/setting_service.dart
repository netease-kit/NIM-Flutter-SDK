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

  /// 获取会话消息免打扰状态
  ///
  ///  [conversationId] 会话id
  Future<NIMResult<bool>> getConversationMuteStatus(
      String conversationId) async {
    return _platform.getConversationMuteStatus(conversationId);
  }

  /// 设置群组消息免打扰模式
  ///
  ///  [teamId] 群组Id
  ///  [teamType] 群组类型
  ///  [muteMode] 群组消息免打扰模式
  Future<NIMResult<void>> setTeamMessageMuteMode(String teamId,
      NIMTeamType teamType, NIMTeamMessageMuteMode muteMode) async {
    return _platform.setTeamMessageMuteMode(teamId, teamType, muteMode);
  }

  /// 获取群消息免打扰模式
  ///
  /// [teamId] 群组id
  /// [teamType] 群组类型
  Future<NIMResult<NIMTeamMessageMuteMode?>> getTeamMessageMuteMode(
      String teamId, NIMTeamType teamType) async {
    return _platform.getTeamMessageMuteMode(teamId, teamType);
  }

  /// 设置点对点消息免打扰模式
  ///
  /// [accountId] 账号Id
  /// [muteMode] 点对点消息免打扰模式
  Future<NIMResult<void>> setP2PMessageMuteMode(
      String accountId, NIMP2PMessageMuteMode muteMode) async {
    return _platform.setP2PMessageMuteMode(accountId, muteMode);
  }

  /// 获取点对点消息免打扰模式
  ///
  /// [accountId] 账号id
  Future<NIMResult<NIMP2PMessageMuteMode>> getP2PMessageMuteMode(
      String accountId) async {
    return _platform.getP2PMessageMuteMode(accountId);
  }

  /// 获取点对点消息免打扰列表
  ///
  /// 返回状态为[NIMP2PMessageMuteMode.p2pMessageMuteModeOn]的用户
  Future<NIMResult<List<String>>> getP2PMessageMuteList() async {
    return _platform.getP2PMessageMuteList();
  }

  /// 设置当桌面端在线时，移动端是否需要推送
  /// 运行在移动端时， 需要调用该接口
  ///
  /// [need] 桌面端在线时，移动端是否需要推送 true： 需要 false：不需要
  Future<NIMResult<void>> setPushMobileOnDesktopOnline(bool need) async {
    return _platform.setPushMobileOnDesktopOnline(need);
  }

  /// 获取当桌面端在线时，移动端是否需要推送配置
  /// 返回 桌面端在线时，移动端是否需要推送,  true： 需要， false：不需要
  Future<NIMResult<bool>> getPushMobileOnDesktopOnline() {
    return _platform.getPushMobileOnDesktopOnline();
  }

  /// 设置Apns免打扰与详情显示
  ///
  /// [config] 免打扰与详情配置参数
  Future<NIMResult<void>> setDndConfig(NIMDndConfig config) async {
    return _platform.setDndConfig(config);
  }

  /// 读取免打扰与详情显示。web 不支持
  ///
  /// [config] 免打扰与详情配置参数
  Future<NIMResult<NIMDndConfig>> getDndConfig() async {
    return _platform.getDndConfig();
  }

  /// 更新通知栏设置，仅支持Android平台
  Future<NIMResult<void>> updateNotificationConfigAndroid(
      NIMStatusBarNotificationConfig config) async {
    return _platform.updateNotificationConfigAndroid(config);
  }

  /// 配置消息提醒，仅支持 Android 平台，iOS平台请关闭通知权限。
  /// 配置 [updateNotificationConfigAndroid] 才能生效
  ///
  /// [enableRegularNotification] - 普通消息提醒开关
  /// [enableRevokeMessageNotification] - 消息撤回是否提醒
  Future<NIMResult<void>> enableNotificationAndroid({
    required bool enableRegularNotification,
    required bool enableRevokeMessageNotification,
  }) {
    return _platform.enableNotificationAndroid(
      enableRegularNotification: enableRegularNotification,
      enableRevokeMessageNotification: enableRevokeMessageNotification,
    );
  }

  /// 群组消息免打扰回调
  @HawkApi(ignore: true)
  Stream<TeamMuteModeChangedResult> get onTeamMessageMuteModeChanged =>
      _platform.onTeamMessageMuteModeChanged.stream;

  /// 点对点消息免打扰回调
  @HawkApi(ignore: true)
  Stream<P2PMuteModeChangedResult> get onP2PMessageMuteModeChanged =>
      _platform.onP2PMessageMuteModeChanged.stream;

  ///当桌面端在线时，移动端是否需要推送，在线回调
  @HawkApi(ignore: true)
  Stream<bool> get onPushMobileOnDesktopOnline =>
      _platform.onPushMobileOnDesktopOnline.stream;
}
