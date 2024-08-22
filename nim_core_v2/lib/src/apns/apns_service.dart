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

  Future<NIMResult<void>> updateApnsToken(Uint8List token) async {
    return _platform.updateApnsToken(token);
  }

  Future<NIMResult<void>> updateApnsTokenWithCustomKey(
      Uint8List token, String key) async {
    return _platform.updateApnsTokenWithCustomKey(token, key);
  }

  Future<NIMResult<void>> updatePushKitToken(Uint8List token) async {
    return _platform.updatePushKitToken(token);
  }

  Future<NIMResult<NIMPushNotificationSetting>> currentSetting() async {
    return _platform.currentSetting();
  }

  Future<NIMResult<void>> updateApnsSetting(
      NIMPushNotificationSetting setting) async {
    return _platform.updateApnsSetting(setting);
  }

  Future<NIMResult<NIMPushNotificationMultiportConfig>>
      currentMultiportConfig() async {
    return _platform.currentMultiportConfig();
  }

  Future<NIMResult<void>> updateApnsMultiportConfig(
      NIMPushNotificationMultiportConfig config) async {
    return _platform.updateApnsMultiportConfig(config);
  }

  @override
  Future<NIMResult<void>> registerBadgeCount(int count) async {
    return _platform.registerBadgeCount(count);
  }
}
