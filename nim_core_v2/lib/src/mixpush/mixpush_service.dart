// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

part of nim_core_v2;

/// 混合推送服务
/// 仅 Android 平台支持
@HawkEntryPoint()
class MixPushService {
  factory MixPushService() {
    if (_singleton == null) {
      _singleton = MixPushService._();
    }
    return _singleton!;
  }

  MixPushService._();

  static MixPushService? _singleton;

  MixPushServicePlatform get _platform => MixPushServicePlatform.instance;

  /// 推送 Token 变化事件流
  ///
  /// 当推送 Token 发生变化时触发，可用于监听 Token 更新
  ///
  /// 使用示例:
  /// ```dart
  /// NimCore.instance.mixPushService.onMixPushToken.listen((token) {
  ///   print('Push token changed: ${token.token}');
  ///   print('Push type: ${token.pushType}');
  /// });
  /// ```
  @HawkApi(ignore: true)
  Stream<NIMMixPushToken> get onMixPushToken => _platform.onMixPushToken;

  /// 注册手动提供推送 Token 的回调
  ///
  /// **前置条件**：初始化时需设置 `NIMMixPushConfig.manualProvidePushToken = true`
  ///
  /// 注册后，当 SDK 需要推送 Token 时会调用传入的 [callback]
  ///
  /// [callback] 回调函数，参数为建议的推送类型，返回值为推送 Token 信息
  /// - [suggestedPushType] 建议的推送类型，可以不严格遵循
  /// - 返回 [NIMMixPushToken] 包含推送类型和 token，返回 null 表示不提供
  ///
  /// 使用示例:
  /// ```dart
  /// // 1. 初始化时开启手动提供 Token 模式
  /// await NimCore.instance.initialize(
  ///   NIMAndroidSDKOptions(
  ///     appKey: 'your_app_key',
  ///     mixPushConfig: NIMMixPushConfig(
  ///       manualProvidePushToken: true,  // 必须设置为 true
  ///     ),
  ///   ),
  /// );
  ///
  /// // 2. 注册回调
  /// await NimCore.instance.mixPushService.registerManuallyProvidePushTokenCallback(
  ///   (suggestedPushType) {
  ///     // 根据 suggestedPushType 返回对应的 token
  ///     return NIMMixPushToken(
  ///       pushType: NIMPushType.xiaomi,
  ///       token: 'your_push_token_here',
  ///     );
  ///   },
  /// );
  /// ```
  /// 注册/取消手动提供推送 Token 的回调
  ///
  /// **前置条件**：初始化时需设置 `NIMMixPushConfig.manualProvidePushToken = true`
  ///
  /// [callback] 回调函数，参数为建议的推送类型，返回值为推送 Token 信息
  /// - 传入有效回调：注册回调
  /// - 传入 `null`：取消回调
  ///
  /// 使用示例:
  /// ```dart
  /// // 注册回调
  /// await NimCore.instance.mixPushService.registerManuallyProvidePushTokenCallback(
  ///   (suggestedPushType) {
  ///     return NIMMixPushToken(
  ///       pushType: NIMPushType.xiaomi,
  ///       token: 'your_push_token_here',
  ///     );
  ///   },
  /// );
  ///
  /// // 取消回调
  /// await NimCore.instance.mixPushService.registerManuallyProvidePushTokenCallback(null);
  /// ```
  Future<NIMResult<void>> registerManuallyProvidePushTokenCallback(
      NIMMixPushToken? Function(NIMPushType suggestedPushType)?
          callback) async {
    await _platform.registerManuallyProvidePushTokenCallback(callback);
    return NIMResult.success();
  }
}
