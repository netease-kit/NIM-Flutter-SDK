// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:typed_data';

import 'package:flutter/foundation.dart';
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
    if (kIsWeb) {
      return NIMResult.fromMap(
        await invokeMethod(
          'enableMobilePushWhenPCOnline',
          arguments: {
            'enable': enable,
          },
        ),
      );
    }
    return NIMResult(-1, null, 'Support Mobile platform only');
  }

  @override
  Future<NIMResult<bool>> isMobilePushEnabledWhenPCOnline() async {
    return NIMResult(-1, null, 'Support Mobile platform only');
  }

  @override
  Future<NIMResult<void>> enableNotificationAndroid({
    required bool enableRegularNotification,
    required bool enableRevokeMessageNotification,
  }) async {
    return NIMResult(-1, null, 'Support Android platform only');
  }

  Future<NIMResult<void>> updateNotificationConfigAndroid(
      NIMStatusBarNotificationConfig config) async {
    return NIMResult(-1, null, 'Support Android platform only');
  }

  Future<NIMResult<void>> enablePushServiceAndroid(bool enable) async {
    return NIMResult.fromMap(
      await invokeMethod(
        'enablePushService',
        arguments: {
          'enable': enable,
        },
      ),
    );
  }

  Future<NIMResult<bool>> isPushServiceEnabledAndroid() async {
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

  /// 更新iOS deviceToken
  @override
  Future<NIMResult<void>> updateAPNSTokenIOS(
      Uint8List token, String? customContentKey) async {
    return NIMResult(-1, null, 'Support iOS platform only');
  }

  @override
  Future<NIMResult<String>> archiveLogs() async {
    return NIMResult(-1, null, 'Support mobile platform only');
  }

  @override
  Future<NIMResult<String>> uploadLogs({
    String? chatroomId,
    String? comment,
    bool partial = true,
  }) async {
    return NIMResult.fromMap(await invokeMethod(
      'uploadLogs',
      arguments: {
        'chatroomId': chatroomId ?? '',
        'comment': comment ?? '',
        'partial': partial,
      },
    ));
  }

  @override
  Future<NIMResult<void>> clearDirCache(
      List<NIMDirCacheFileType> fileTypes, int startTime, int endTime) async {
    return NIMResult.fromMap(
      await invokeMethod(
        'clearDirCache',
        arguments: {
          'fileTypes':
              fileTypes.map((e) => stringifyDirCacheFileTypeName(e)).toList(),
          'startTime': startTime,
          'endTime': endTime,
        },
      ),
    );
  }

  @override
  Future<NIMResult<int>> getSizeOfDirCache(
      List<NIMDirCacheFileType> fileTypes, int startTime, int endTime) async {
    return NIMResult.fromMap(
      await invokeMethod(
        'getSizeOfDirCache',
        arguments: {
          'fileTypes':
              fileTypes.map((e) => stringifyDirCacheFileTypeName(e)).toList(),
          'startTime': startTime,
          'endTime': endTime,
        },
      ),
    );
  }

  @override
  Future<NIMResult<int>> removeResourceFiles(
      NIMResourceQueryOption option) async {
    return NIMResult(-1, null, 'Support mobile platform only');
  }

  @override
  Future<NIMResult<List<NIMCacheQueryResult>>> searchResourceFiles(
      NIMResourceQueryOption option) async {
    return NIMResult(-1, null, 'Support mobile platform only');
  }

  @override
  Future<NIMResult<void>> registerBadgeCount(int count) async {
    return NIMResult(-1, null, 'Support mobile platform only');
  }
}
