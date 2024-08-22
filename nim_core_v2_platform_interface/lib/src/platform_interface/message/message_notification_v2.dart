// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:nim_core_v2_platform_interface/nim_core_v2_platform_interface.dart';

part "message_notification_v2.g.dart";

/// 通知推送相关配置
@JsonSerializable(explicitToJson: true)
class NIMNotificationPushConfig {
  /// 是否需要推送通知。true：需要, false：不需要
  bool? pushEnabled;

  /// 是否需要推送通知发送者昵称。true：需要, false：不需要
  bool? pushNickEnabled;

  /// 推送文案
  String? pushContent;

  /// 推送数据
  String? pushPayload;

  /// 忽略用户通知提醒相关设置，只通知类型有效
  bool? forcePush;

  /// 强制推送文案，只通知类型有效
  String? forcePushContent;

  /// 强制推送目标账号列表，只通知类型有效
  List<String>? forcePushAccountIds;

  NIMNotificationPushConfig(
      {this.pushEnabled,
      this.pushNickEnabled,
      this.pushContent,
      this.pushPayload,
      this.forcePush,
      this.forcePushContent,
      this.forcePushAccountIds});

  factory NIMNotificationPushConfig.fromJson(Map<String, dynamic> map) =>
      _$NIMNotificationPushConfigFromJson(map);

  Map<String, dynamic> toJson() => _$NIMNotificationPushConfigToJson(this);
}

@JsonSerializable(explicitToJson: true)
class NIMNotificationAntispamConfig {
  /// 指定是否需要过安全通（对于已开通安全通的用户有效，默认通知都会走安全通，如果对单条通知设置 enable 为false，则此通知不会走安全通）。true：需要，false：不需要.该字段为true，其他字段才生效
  bool? antispamEnabled;

  /// 开发者自定义的反垃圾字段， content 必须是 json 格式，长度不超过 5000 字节，格式如下
  /// { "type": 1, //1:文本，2：图片，3视频 "data": "" //文本内容or图片地址or视频地址 }
  String? antispamCustomNotification;

  NIMNotificationAntispamConfig(
      {this.antispamEnabled, this.antispamCustomNotification});

  factory NIMNotificationAntispamConfig.fromJson(Map<String, dynamic> map) =>
      _$NIMNotificationAntispamConfigFromJson(map);

  Map<String, dynamic> toJson() => _$NIMNotificationAntispamConfigToJson(this);
}

/// 通知相关配置
@JsonSerializable(explicitToJson: true)
class NIMNotificationConfig {
  /// 是否需要存离线通知
  /// true：需要 false：不需要，只有在线用户会收到
  bool? offlineEnabled;

  /// 是否需要计通知未读
  /// 与会话未读无关
  /// true：需要
  /// false：不需要
  bool? unreadEnabled;

  NIMNotificationConfig({this.offlineEnabled, this.unreadEnabled});

  factory NIMNotificationConfig.fromJson(Map<String, dynamic> map) =>
      _$NIMNotificationConfigFromJson(map);

  Map<String, dynamic> toJson() => _$NIMNotificationConfigToJson(this);
}

/// 路由抄送相关配置
@JsonSerializable(explicitToJson: true)
class NIMNotificationRouteConfig {
  /// 是否需要路由通知。（抄送）true：需要。false：不需要
  bool? routeEnabled;

  /// 环境变量，用于指向不同的抄送，第三方回调等配置
  String? routeEnvironment;

  NIMNotificationRouteConfig({this.routeEnabled, this.routeEnvironment});

  factory NIMNotificationRouteConfig.fromJson(Map<String, dynamic> map) =>
      _$NIMNotificationRouteConfigFromJson(map);

  Map<String, dynamic> toJson() => _$NIMNotificationRouteConfigToJson(this);
}

@JsonSerializable(explicitToJson: true)
class NIMClearHistoryNotification {
  /// 被清空的会话ID
  String? conversationId;

  /// 被删除的时间
  double? deleteTime;

  /// 被删除时填入的扩展字段
  String? serverExtension;

  NIMClearHistoryNotification(
      {this.conversationId, this.deleteTime, this.serverExtension});

  factory NIMClearHistoryNotification.fromJson(Map<String, dynamic> map) =>
      _$NIMClearHistoryNotificationFromJson(map);

  Map<String, dynamic> toJson() => _$NIMClearHistoryNotificationToJson(this);
}
