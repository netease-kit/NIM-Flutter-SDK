// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:nim_core_v2_platform_interface/src/platform_interface/mixpush/mixpush.dart';
import 'package:nim_core_v2_platform_interface/src/platform_interface/mixpush/platform_interface_mixpush_service.dart';
import 'package:nim_core_v2_platform_interface/src/utils/log.dart';

class MethodChannelMixPushService extends MixPushServicePlatform {
  final StreamController<NIMMixPushToken> _onMixPushTokenController =
      StreamController<NIMMixPushToken>.broadcast();

  @override
  String get serviceName => 'MixPushService';

  @override
  Stream<NIMMixPushToken> get onMixPushToken =>
      _onMixPushTokenController.stream;

  @override
  Future<dynamic> onEvent(String method, dynamic arguments) {
    Log.i(serviceName,
        'MethodChannelMixPushService onEvent method = $method arguments = ${arguments.toString()}');

    switch (method) {
      case 'onManuallyProvidePushToken':
        return _handleManuallyProvidePushToken(arguments);
      case 'onMixPushToken':
        _handleOnMixPushToken(arguments);
        return Future.value(null);
      default:
        return Future.value(null);
    }
  }

  void _handleOnMixPushToken(dynamic arguments) {
    final args = arguments as Map<dynamic, dynamic>?;
    if (args != null) {
      final token = NIMMixPushToken.fromMap(Map<String, dynamic>.from(args));
      Log.i(serviceName, 'onMixPushToken: ${token.toMap()}');
      _onMixPushTokenController.add(token);
    }
  }

  Future<Map<String, dynamic>?> _handleManuallyProvidePushToken(
      dynamic arguments) async {
    final args = arguments as Map<dynamic, dynamic>?;
    final suggestedPushTypeValue = args?['suggestedPushType'] as int? ?? 0;
    final suggestedPushType = NIMPushType.fromValue(suggestedPushTypeValue);

    Log.i(serviceName,
        'onManuallyProvidePushToken called with suggestedPushType: $suggestedPushType');

    final callback = onManuallyProvidePushToken;
    if (callback != null) {
      final result = callback(suggestedPushType);
      if (result != null) {
        Log.i(serviceName,
            'onManuallyProvidePushToken returning: ${result.toMap()}');
        return result.toMap();
      }
    }

    Log.i(serviceName, 'onManuallyProvidePushToken returning null');
    return null;
  }

  @override
  Future<void> registerManuallyProvidePushTokenCallback(
      ManuallyProvidePushTokenCallback? callback) async {
    if (callback != null) {
      Log.i(serviceName, 'registerManuallyProvidePushTokenCallback');
      // 先保存回调，再调用原生注册
      onManuallyProvidePushToken = callback;
      await invokeMethod('registerManuallyProvidePushTokenCallback');
    } else {
      Log.i(serviceName, 'unregisterManuallyProvidePushTokenCallback');
      // 传 null 表示取消回调
      onManuallyProvidePushToken = null;
      await invokeMethod('unregisterManuallyProvidePushTokenCallback');
    }
  }
}
