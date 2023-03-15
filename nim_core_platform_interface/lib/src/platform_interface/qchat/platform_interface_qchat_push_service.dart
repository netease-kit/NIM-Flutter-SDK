// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:nim_core_platform_interface/nim_core_platform_interface.dart';

import 'package:nim_core_platform_interface/src/method_channel/method_channel_qchat_push_service.dart';

abstract class QChatPushServicePlatform extends Service {
  QChatPushServicePlatform() : super(token: _token);

  static final Object _token = Object();

  static QChatPushServicePlatform _instance = MethodChannelQChatPushService();

  static QChatPushServicePlatform get instance => _instance;

  static set instance(QChatPushServicePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// 开启/关闭圈组第三方推送服务(仅Android)
  /// [enable] true 开启，SDK 需要与云信服务器做确认；false 关闭，SDK 也需要通知云信服务器。
  /// 只有与服务器交互完成后才算成功，如果出错，会有具体的错误代码。

  Future<NIMResult<void>> enableAndroid(bool enable);

  /// 是否开启了圈组第三方推送服务(仅Android)
  Future<NIMResult<bool>> isEnableAndroid();

  /// 设置圈组推送配置 (仅Android)

  Future<NIMResult<void>> setPushConfig(QChatPushConfig param);

  /// 获取圈组推送设置 (仅Android)

  Future<NIMResult<QChatPushConfig>> getPushConfig();

  /// 圈组是否存在推送配置。(仅Android)

  Future<NIMResult<bool>> isPushConfigExistAndroid();
}
