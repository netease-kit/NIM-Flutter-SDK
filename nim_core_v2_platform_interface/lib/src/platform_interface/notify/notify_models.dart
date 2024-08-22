// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:nim_core_v2_platform_interface/nim_core_v2_platform_interface.dart';
import 'package:json_annotation/json_annotation.dart';

part 'notify_models.g.dart';

///通知发送相关参数
@JsonSerializable(explicitToJson: true)
class NIMSendCustomNotificationParams {
  /// 通知相关配置，具体参见每一个字段定义
  @JsonKey(fromJson: _nimNIMNotificationConfig)
  NIMNotificationConfig? notificationConfig;

  /// 离线推送配置相关
  @JsonKey(fromJson: _nimNIMNotificationPushConfig)
  NIMNotificationPushConfig? pushConfig;

  /// 反垃圾相关配置
  @JsonKey(fromJson: _nimNIMNotificationAntispamConfig)
  NIMNotificationAntispamConfig? antispamConfig;

  /// 路由抄送相关配置
  @JsonKey(fromJson: _nimNIMNotificationRouteConfig)
  NIMNotificationRouteConfig? routeConfig;

  NIMSendCustomNotificationParams({
    this.notificationConfig,
    this.pushConfig,
    this.antispamConfig,
    this.routeConfig,
  });

  Map<String, dynamic> toJson() =>
      _$NIMSendCustomNotificationParamsToJson(this);

  factory NIMSendCustomNotificationParams.fromJson(Map<String, dynamic> map) =>
      _$NIMSendCustomNotificationParamsFromJson(map);
}

NIMNotificationRouteConfig? _nimNIMNotificationRouteConfig(Map? map) {
  if (map != null) {
    return NIMNotificationRouteConfig.fromJson(map.cast<String, dynamic>());
  }
  return null;
}

NIMNotificationAntispamConfig? _nimNIMNotificationAntispamConfig(Map? map) {
  if (map != null) {
    return NIMNotificationAntispamConfig.fromJson(map.cast<String, dynamic>());
  }
  return null;
}

NIMNotificationConfig? _nimNIMNotificationConfig(Map? map) {
  if (map != null) {
    return NIMNotificationConfig.fromJson(map.cast<String, dynamic>());
  }
  return null;
}

NIMNotificationPushConfig? _nimNIMNotificationPushConfig(Map? map) {
  if (map != null) {
    return NIMNotificationPushConfig.fromJson(map.cast<String, dynamic>());
  }
  return null;
}

@JsonSerializable(explicitToJson: true)
class NIMCustomNotification {
  String? senderId;

  String? receiverId;

  NIMConversationType? conversationType;

  int timestamp;

  String? content;

  @JsonKey(fromJson: _nimNIMNotificationConfig)
  NIMNotificationConfig? notificationConfig;

  @JsonKey(fromJson: _nimNIMNotificationPushConfig)
  NIMNotificationPushConfig? pushConfig;

  @JsonKey(fromJson: _nimNIMNotificationAntispamConfig)
  NIMNotificationAntispamConfig? antispamConfig;

  @JsonKey(fromJson: _nimNIMNotificationRouteConfig)
  NIMNotificationRouteConfig? routeConfig;

  NIMCustomNotification({
    this.senderId,
    this.receiverId,
    this.conversationType,
    required this.timestamp,
    this.content,
    this.notificationConfig,
    this.pushConfig,
    this.antispamConfig,
    this.routeConfig,
  });

  Map<String, dynamic> toJson() => _$NIMCustomNotificationToJson(this);

  factory NIMCustomNotification.fromJson(Map<String, dynamic> map) =>
      _$NIMCustomNotificationFromJson(map);
}

///全员广播通知
@JsonSerializable(explicitToJson: true)
class NIMBroadcastNotification {
  int id;

  String? senderId;

  int timestamp;

  String? content;

  NIMBroadcastNotification({
    required this.id,
    this.senderId,
    required this.timestamp,
    this.content,
  });

  Map<String, dynamic> toJson() => _$NIMBroadcastNotificationToJson(this);

  factory NIMBroadcastNotification.fromJson(Map<String, dynamic> map) =>
      _$NIMBroadcastNotificationFromJson(map);
}
