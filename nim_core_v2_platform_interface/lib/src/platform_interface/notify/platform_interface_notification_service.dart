// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:nim_core_v2_platform_interface/nim_core_v2_platform_interface.dart';
import 'package:nim_core_v2_platform_interface/src/method_channel/method_channel_notification_service.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

abstract class NotificationServicePlatform extends Service {
  NotificationServicePlatform() : super(token: _token);

  static final Object _token = Object();

  static NotificationServicePlatform _instance =
      MethodChannelNotificationService();

  static NotificationServicePlatform get instance => _instance;

  static set instance(NotificationServicePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  ///收到自定义通知
  Stream<List<NIMCustomNotification>> get onReceiveCustomNotifications;

  ///收到全员广播通知
  Stream<List<NIMBroadcastNotification>> get onReceiveBroadcastNotifications;

  ///发送自定义通知， 主要以下MsgType
  ///发送该通知后， 接收端SDK会抛出[onReceiveCustomNotifications]回调
  /// [conversationId] 会话 ID
  /// [content] 通知内容 SystemMsgTag.Attach字段 最大4096
  /// [params] 通知内容 发送通知相关配置参数，可以配置如下参数，具体参见参数定义
  ///     通知相关参数配置
  ///     通知推送参数配置
  ///     通知反垃圾配置
  ///     抄送通知配置
  Future<NIMResult<void>> sendCustomNotification(String conversationId,
      String content, NIMSendCustomNotificationParams params) {
    throw UnimplementedError(
        'sendCustomNotification() has not been implemented.');
  }
}
