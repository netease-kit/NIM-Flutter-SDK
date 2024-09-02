// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

part of nim_core_v2;

@HawkEntryPoint()
class APNSService {
  factory APNSService() {
    if (_singleton == null) {
      _singleton = APNSService._();
    }
    return _singleton!;
  }

  static APNSService? _singleton;

  APNSService._();

  APNSServicePlatform get _platform => APNSServicePlatform.instance;

  // 上传/更新 DeviceToken 至云信服务器，用于后续的 APNs 推送
  Future<NIMResult<void>> updateApnsToken(Uint8List token) async {
    return _platform.updateApnsToken(token);
  }

  // 上传/更新 DeviceToken 至云信服务器，用于后续的 APNs 推送。该接口可同时设置自定义推送文案（对应云信控制台中的自定义推送文案类型）。
  Future<NIMResult<void>> updateApnsTokenWithCustomKey(
      Uint8List token, String key) async {
    return _platform.updateApnsTokenWithCustomKey(token, key);
  }

  // 上传/更新 PushKit Token 至云信服务器，用于后续的离线推送。目前仅支持 PKPushTypeVoIP 类型。
  Future<NIMResult<void>> updatePushKitToken(Uint8List token) async {
    return _platform.updatePushKitToken(token);
  }

  // 获取当前的推送免打扰设置
  Future<NIMResult<NIMPushNotificationSetting>> currentSetting() async {
    return _platform.currentSetting();
  }

  // 更新推送免打扰设置
  Future<NIMResult<void>> updateApnsSetting(
      NIMPushNotificationSetting setting) async {
    return _platform.updateApnsSetting(setting);
  }

  // 获取当前多端推送策略配置
  Future<NIMResult<NIMPushNotificationMultiportConfig>>
      currentMultiportConfig() async {
    return _platform.currentMultiportConfig();
  }

  // 更推送自定义多端推送策略配置
  Future<NIMResult<void>> updateApnsMultiportConfig(
      NIMPushNotificationMultiportConfig config) async {
    return _platform.updateApnsMultiportConfig(config);
  }

  @override
  Future<NIMResult<void>> registerBadgeCount(int count) async {
    return _platform.registerBadgeCount(count);
  }
}
