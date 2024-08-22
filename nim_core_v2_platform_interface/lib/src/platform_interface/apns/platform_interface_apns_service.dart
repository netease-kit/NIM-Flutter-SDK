// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:typed_data';

import 'package:nim_core_v2_platform_interface/nim_core_v2_platform_interface.dart';
import 'package:nim_core_v2_platform_interface/src/method_channel/method_channel_apns_service.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

abstract class APNSServicePlatform extends Service {
  APNSServicePlatform() : super(token: _token);

  static final Object _token = Object();

  static APNSServicePlatform _instance = MethodChannelAPNSService();

  static APNSServicePlatform get instance => _instance;

  static set instance(APNSServicePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<NIMResult<void>> updateApnsToken(Uint8List token) async {
    throw UnimplementedError('updateAPNSOptions() has not been implemented.');
  }

  Future<NIMResult<void>> updateApnsTokenWithCustomKey(
      Uint8List token, String key) async {
    throw UnimplementedError('updateAPNSOptions() has not been implemented.');
  }

  Future<NIMResult<void>> updatePushKitToken(Uint8List token) async {
    throw UnimplementedError('updateAPNSOptions() has not been implemented.');
  }

  Future<NIMResult<NIMPushNotificationSetting>> currentSetting() async {
    throw UnimplementedError('updateAPNSOptions() has not been implemented.');
  }

  Future<NIMResult<void>> updateApnsSetting(
      NIMPushNotificationSetting setting) async {
    throw UnimplementedError('updateAPNSOptions() has not been implemented.');
  }

  Future<NIMResult<NIMPushNotificationMultiportConfig>>
      currentMultiportConfig() async {
    throw UnimplementedError('updateAPNSOptions() has not been implemented.');
  }

  Future<NIMResult<void>> updateApnsMultiportConfig(
      NIMPushNotificationMultiportConfig config) async {
    throw UnimplementedError('updateAPNSOptions() has not been implemented.');
  }

  @override
  Future<NIMResult<void>> registerBadgeCount(int count) async {
    throw UnimplementedError('registerBadgeCount() has not been implemented.');
  }
}
