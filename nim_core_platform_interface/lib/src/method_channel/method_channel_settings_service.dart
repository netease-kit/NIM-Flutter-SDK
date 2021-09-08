// Copyright (c) 2021 NetEase, Inc.  All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:nim_core_platform_interface/src/platform_interface/initialize/nim_sdk_android_options.dart';
import 'package:nim_core_platform_interface/src/platform_interface/nim_base.dart';
import 'package:nim_core_platform_interface/src/platform_interface/settings/platform_interface_settings_service.dart';
import 'package:nim_core_platform_interface/src/platform_interface/settings/settings_models.dart';

class MethodChannelSettingsService extends SettingsServicePlatform {
  @override
  Future onEvent(String method, arguments) {
    throw UnimplementedError();
  }

  @override
  String get serviceName => 'SettingsService';

  @override
  Future<NIMResult<void>> enableMobilePushWhenPCOnline(bool enable) async {
    return NIMResult(-1, null, 'Support Mobile platform only');
  }

  @override
  Future<NIMResult<bool>> isMobilePushEnabledWhenPCOnline() async {
    return NIMResult(-1, null, 'Support Mobile platform only');
  }

  @override
  Future<NIMResult<void>> enableNotification({
    required bool enableRegularNotification,
    required bool enableRevokeMessageNotification,
  }) async {
    return NIMResult(-1, null, 'Support Android platform only');
  }

  Future<NIMResult<void>> updateNotificationConfig(
      NIMStatusBarNotificationConfig config) async {
    return NIMResult(-1, null, 'Support Android platform only');
  }

  Future<NIMResult<void>> enablePushService(bool enable) async {
    return NIMResult.fromMap(
      await invokeMethod(
        'enablePushService',
        arguments: {
          'enable': enable,
        },
      ),
    );
  }

  Future<NIMResult<bool>> isPushServiceEnabled() async {
    return NIMResult.fromMap(
      await invokeMethod(
        'isPushServiceEnabled',
      ),
    );
  }

  Future<NIMResult<NIMPushNoDisturbConfig>> getPushNoDisturbConfig() async {
    return NIMResult.fromMap(
      await invokeMethod(
        'getPushNoDisturbConfig',
      ),
      convert: (map) {
        return NIMPushNoDisturbConfig.fromMap(Map<String, dynamic>.from(map));
      },
    );
  }

  Future<NIMResult<void>> setPushNoDisturbConfig(
      NIMPushNoDisturbConfig config) async {
    return NIMResult.fromMap(
      await invokeMethod(
        'setPushNoDisturbConfig',
        arguments: config.toMap(),
      ),
    );
  }

  Future<NIMResult<bool>> isPushShowDetailEnabled() async {
    return NIMResult.fromMap(
      await invokeMethod(
        'isPushShowDetailEnabled',
      ),
    );
  }

  Future<NIMResult<void>> enablePushShowDetail(bool enable) async {
    return NIMResult.fromMap(
      await invokeMethod(
        'enablePushShowDetail',
        arguments: {
          'enable': enable,
        },
      ),
    );
  }
}
