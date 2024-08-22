// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

part of nim_core_v2;

@HawkEntryPoint()
class NotificationService {
  factory NotificationService() {
    if (_singleton == null) {
      _singleton = NotificationService._();
    }
    return _singleton!;
  }

  NotificationService._();

  static NotificationService? _singleton;

  NotificationServicePlatform get _platform =>
      NotificationServicePlatform.instance;

  ///收到自定义通知
  @HawkApi(ignore: true)
  Stream<List<NIMCustomNotification>> get onReceiveCustomNotifications =>
      _platform.onReceiveCustomNotifications;

  ///收到全员广播通知
  @HawkApi(ignore: true)
  Stream<List<NIMBroadcastNotification>> get onReceiveBroadcastNotifications =>
      _platform.onReceiveBroadcastNotifications;

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
    return _platform.sendCustomNotification(conversationId, content, params);
  }
}
