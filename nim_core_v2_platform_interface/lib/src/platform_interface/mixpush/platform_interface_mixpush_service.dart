// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:nim_core_v2_platform_interface/src/method_channel/method_channel_mixpush_service.dart';
import 'package:nim_core_v2_platform_interface/src/platform_interface/mixpush/mixpush.dart';
import 'package:nim_core_v2_platform_interface/src/platform_interface/service.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

/// 手动提供推送 Token 的回调类型
/// [suggestedPushType] 建议的推送类型，可以不严格遵循
/// 返回 [NIMMixPushToken] 包含推送类型和 token，返回 null 表示不提供
typedef ManuallyProvidePushTokenCallback = NIMMixPushToken? Function(
    NIMPushType suggestedPushType);

abstract class MixPushServicePlatform extends Service {
  MixPushServicePlatform() : super(token: _token);

  static final Object _token = Object();

  static MixPushServicePlatform _instance = MethodChannelMixPushService();

  static MixPushServicePlatform get instance => _instance;

  static set instance(MixPushServicePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// 手动提供推送 Token 的回调（内部使用）
  ManuallyProvidePushTokenCallback? onManuallyProvidePushToken;

  /// 推送 Token 变化事件流
  /// 当推送 Token 发生变化时触发
  Stream<NIMMixPushToken> get onMixPushToken;

  /// 注册/取消手动提供推送 Token 的回调
  ///
  /// [callback] 当 SDK 需要推送 Token 时会调用此回调
  /// - 传入有效回调：注册回调
  /// - 传入 `null`：取消回调
  Future<void> registerManuallyProvidePushTokenCallback(
      ManuallyProvidePushTokenCallback? callback);
}
