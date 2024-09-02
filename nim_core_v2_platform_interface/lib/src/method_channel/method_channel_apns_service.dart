// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:typed_data';
import 'package:nim_core_v2_platform_interface/nim_core_v2_platform_interface.dart';

class MethodChannelAPNSService extends APNSServicePlatform {
  @override
  Future<void> updateAPNSOptions(Map<String, dynamic> options) async {
    return Future.value();
  }

  @override
  Future onEvent(String method, arguments) {
    // TODO: implement onEvent
    throw UnimplementedError();
  }

  @override
  String get serviceName => "APNSService";

  Future<NIMResult<void>> updateApnsToken(Uint8List token) async {
    return NIMResult.fromMap(
        await invokeMethod('updateApnsToken', arguments: {'token': token}));
  }

  Future<NIMResult<void>> updateApnsTokenWithCustomKey(
      Uint8List token, String key) async {
    return NIMResult.fromMap(await invokeMethod('updateApnsTokenWithCustomKey',
        arguments: {'token': token, 'key': key}));
  }

  Future<NIMResult<void>> updatePushKitToken(Uint8List token) async {
    return NIMResult.fromMap(
        await invokeMethod('updatePushKitToken', arguments: {'token': token}));
  }

  Future<NIMResult<NIMPushNotificationSetting>> currentSetting() async {
    return NIMResult.fromMap(await invokeMethod('currentSetting'));
  }

  Future<NIMResult<void>> updateApnsSetting(
      NIMPushNotificationSetting setting) async {
    return NIMResult.fromMap(await invokeMethod('updateApnsSetting',
        arguments: {'setting': setting}));
  }

  Future<NIMResult<NIMPushNotificationMultiportConfig>>
      currentMultiportConfig() async {
    return NIMResult.fromMap(await invokeMethod('currentMultiportConfig'));
  }

  Future<NIMResult<void>> updateApnsMultiportConfig(
      NIMPushNotificationMultiportConfig config) async {
    return NIMResult.fromMap(await invokeMethod('updateApnsMultiportConfig',
        arguments: {'config': config}));
  }

  @override
  Future<NIMResult<void>> registerBadgeCount(int count) async {
    return NIMResult.fromMap(
        await invokeMethod('registerBadgeCount', arguments: {'count': count}));
  }
}
