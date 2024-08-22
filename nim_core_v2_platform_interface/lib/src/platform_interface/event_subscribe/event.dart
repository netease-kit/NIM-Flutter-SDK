// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

class Event {
  ///事件ID，非用户设置字段
  final String? eventId;

  ///事件类型，1-99999 为云信保留类型
  final int? eventType;

  ///事件的状态值
  final int? eventValue;

  /// 事件的扩展字段，最大长度为 256 字节，由事件发布客户端配置
  /// 发布的时候使用
  final String? config;

  ///事件的有效期，范围为 60s 到 7days，数值单位为秒
  final int? expiry;

  ///是否只广播给在线用户，若为 false，事件支持在线广播和登录后同步
  final bool? broadcastOnlineOnly;

  ///是否支持多端同步
  final bool? syncSelfEnable;

  ///事件发布者的云信账号，非用户设置字段
  final String? publisherAccount;

  ///事件发布的时间，非用户设置字段
  final int? publishTime;

  ///事件发布者客户端类型 @see ClientType，非用户设置字段
  final int? publisherClientType;

  ///多端 config 配置
  ///接收时有效
  final String? multiClientConfig;

  ///解析 multiClientConfig 的多端 config 配置 map
  @Deprecated("use multiClientConfig instead")
  final Map<int, String>? multiClientConfigMap;

  ///预定义事件中服务端配置项,仅仅对预留事件有效，非用户设置字段
  @Deprecated("not support since version  1.7.0")
  final String? nimConfig;

  Event(
      {this.eventId,
      required this.eventType,
      required this.eventValue,
      this.config,
      required this.expiry,
      this.broadcastOnlineOnly,
      this.syncSelfEnable,
      this.publisherAccount,
      this.publishTime,
      this.publisherClientType,
      this.multiClientConfig,
      this.multiClientConfigMap,
      this.nimConfig});

  factory Event.fromMap(Map<String, dynamic>? json) {
    return Event(
        eventId: json?['eventId'] as String?,
        eventType: json?['eventType'] as int?,
        eventValue: json?['eventValue'] as int?,
        config: json?['config'] as String?,
        expiry: json?['expiry'] as int?,
        broadcastOnlineOnly: json?['broadcastOnlineOnly'] as bool?,
        syncSelfEnable: json?['syncSelfEnable'] as bool?,
        publisherAccount: json?['publisherAccount'] as String?,
        publishTime: json?['publishTime'] as int?,
        publisherClientType: json?['publisherClientType'] as int?,
        multiClientConfig: json?['multiClientConfig'] as String?,
        multiClientConfigMap:
            (json?['multiClientConfigMap'] as Map?)?.cast<int, String>(),
        nimConfig: json?['nimConfig'] as String?);
  }

  Map<String, dynamic> toMap() => <String, dynamic>{
        if (eventId != null) 'eventId': eventId,
        'eventType': eventType,
        'eventValue': eventValue,
        if (config != null) 'config': config,
        'expiry': expiry,
        if (broadcastOnlineOnly != null)
          'broadcastOnlineOnly': broadcastOnlineOnly,
        if (syncSelfEnable != null) 'syncSelfEnable': syncSelfEnable,
        if (publisherAccount != null) 'publisherAccount': publisherAccount,
        if (publishTime != null) 'publishTime': publishTime,
        if (publisherClientType != null)
          'publisherClientType': publisherClientType,
        if (multiClientConfig != null) 'multiClientConfig': multiClientConfig,
      };
}
