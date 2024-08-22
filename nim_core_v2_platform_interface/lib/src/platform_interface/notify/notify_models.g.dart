// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notify_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NIMSendCustomNotificationParams _$NIMSendCustomNotificationParamsFromJson(
        Map<String, dynamic> json) =>
    NIMSendCustomNotificationParams(
      notificationConfig:
          _nimNIMNotificationConfig(json['notificationConfig'] as Map?),
      pushConfig: _nimNIMNotificationPushConfig(json['pushConfig'] as Map?),
      antispamConfig:
          _nimNIMNotificationAntispamConfig(json['antispamConfig'] as Map?),
      routeConfig: _nimNIMNotificationRouteConfig(json['routeConfig'] as Map?),
    );

Map<String, dynamic> _$NIMSendCustomNotificationParamsToJson(
        NIMSendCustomNotificationParams instance) =>
    <String, dynamic>{
      'notificationConfig': instance.notificationConfig?.toJson(),
      'pushConfig': instance.pushConfig?.toJson(),
      'antispamConfig': instance.antispamConfig?.toJson(),
      'routeConfig': instance.routeConfig?.toJson(),
    };

NIMCustomNotification _$NIMCustomNotificationFromJson(
        Map<String, dynamic> json) =>
    NIMCustomNotification(
      senderId: json['senderId'] as String?,
      receiverId: json['receiverId'] as String?,
      conversationType: $enumDecodeNullable(
          _$NIMConversationTypeEnumMap, json['conversationType']),
      timestamp: (json['timestamp'] as num).toInt(),
      content: json['content'] as String?,
      notificationConfig:
          _nimNIMNotificationConfig(json['notificationConfig'] as Map?),
      pushConfig: _nimNIMNotificationPushConfig(json['pushConfig'] as Map?),
      antispamConfig:
          _nimNIMNotificationAntispamConfig(json['antispamConfig'] as Map?),
      routeConfig: _nimNIMNotificationRouteConfig(json['routeConfig'] as Map?),
    );

Map<String, dynamic> _$NIMCustomNotificationToJson(
        NIMCustomNotification instance) =>
    <String, dynamic>{
      'senderId': instance.senderId,
      'receiverId': instance.receiverId,
      'conversationType':
          _$NIMConversationTypeEnumMap[instance.conversationType],
      'timestamp': instance.timestamp,
      'content': instance.content,
      'notificationConfig': instance.notificationConfig?.toJson(),
      'pushConfig': instance.pushConfig?.toJson(),
      'antispamConfig': instance.antispamConfig?.toJson(),
      'routeConfig': instance.routeConfig?.toJson(),
    };

const _$NIMConversationTypeEnumMap = {
  NIMConversationType.unknown: 0,
  NIMConversationType.p2p: 1,
  NIMConversationType.team: 2,
  NIMConversationType.superTeam: 3,
};

NIMBroadcastNotification _$NIMBroadcastNotificationFromJson(
        Map<String, dynamic> json) =>
    NIMBroadcastNotification(
      id: (json['id'] as num).toInt(),
      senderId: json['senderId'] as String?,
      timestamp: (json['timestamp'] as num).toInt(),
      content: json['content'] as String?,
    );

Map<String, dynamic> _$NIMBroadcastNotificationToJson(
        NIMBroadcastNotification instance) =>
    <String, dynamic>{
      'id': instance.id,
      'senderId': instance.senderId,
      'timestamp': instance.timestamp,
      'content': instance.content,
    };
