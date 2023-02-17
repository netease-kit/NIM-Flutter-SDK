// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

part of nim_core;

///圈组推送配置
///仅支持Android 和 iOS
@HawkEntryPoint()
class QChatPushService {
  factory QChatPushService() {
    if (_singleton == null) {
      _singleton = QChatPushService._();
    }
    return _singleton!;
  }

  QChatPushService._();

  static QChatPushService? _singleton;

  QChatPushServicePlatform _platform = QChatPushServicePlatform.instance;

  /// 开启/关闭圈组第三方推送服务(仅Android)
  /// [enable] true 开启，SDK 需要与云信服务器做确认；false 关闭，SDK 也需要通知云信服务器。
  /// 只有与服务器交互完成后才算成功，如果出错，会有具体的错误代码。

  Future<NIMResult<void>> enableAndroid(bool enable) {
    return _platform.enableAndroid(enable);
  }

  /// 是否开启了圈组第三方推送服务(仅Android)
  Future<NIMResult<bool>> isEnableAndroid() {
    return _platform.isEnableAndroid();
  }

  /// 设置圈组推送配置

  Future<NIMResult<void>> setPushConfig(QChatPushConfig param) {
    return _platform.setPushConfig(param);
  }

  /// 获取圈组推送设置

  Future<NIMResult<QChatPushConfig>> getPushConfig() {
    return _platform.getPushConfig();
  }

  /// 圈组是否存在推送配置。(仅Android)

  Future<NIMResult<bool>> isPushConfigExistAndroid() {
    return _platform.isPushConfigExistAndroid();
  }
}
