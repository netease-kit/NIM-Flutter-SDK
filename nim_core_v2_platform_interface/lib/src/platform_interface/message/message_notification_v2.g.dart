// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_notification_v2.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NIMNotificationPushConfig _$NIMNotificationPushConfigFromJson(
        Map<String, dynamic> json) =>
    NIMNotificationPushConfig(
      pushEnabled: json['pushEnabled'] as bool?,
      pushNickEnabled: json['pushNickEnabled'] as bool?,
      pushContent: json['pushContent'] as String?,
      pushPayload: json['pushPayload'] as String?,
      forcePush: json['forcePush'] as bool?,
      forcePushContent: json['forcePushContent'] as String?,
      forcePushAccountIds: (json['forcePushAccountIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$NIMNotificationPushConfigToJson(
        NIMNotificationPushConfig instance) =>
    <String, dynamic>{
      'pushEnabled': instance.pushEnabled,
      'pushNickEnabled': instance.pushNickEnabled,
      'pushContent': instance.pushContent,
      'pushPayload': instance.pushPayload,
      'forcePush': instance.forcePush,
      'forcePushContent': instance.forcePushContent,
      'forcePushAccountIds': instance.forcePushAccountIds,
    };

NIMNotificationAntispamConfig _$NIMNotificationAntispamConfigFromJson(
        Map<String, dynamic> json) =>
    NIMNotificationAntispamConfig(
      antispamEnabled: json['antispamEnabled'] as bool?,
      antispamCustomNotification: json['antispamCustomNotification'] as String?,
    );

Map<String, dynamic> _$NIMNotificationAntispamConfigToJson(
        NIMNotificationAntispamConfig instance) =>
    <String, dynamic>{
      'antispamEnabled': instance.antispamEnabled,
      'antispamCustomNotification': instance.antispamCustomNotification,
    };

NIMNotificationConfig _$NIMNotificationConfigFromJson(
        Map<String, dynamic> json) =>
    NIMNotificationConfig(
      offlineEnabled: json['offlineEnabled'] as bool?,
      unreadEnabled: json['unreadEnabled'] as bool?,
    );

Map<String, dynamic> _$NIMNotificationConfigToJson(
        NIMNotificationConfig instance) =>
    <String, dynamic>{
      'offlineEnabled': instance.offlineEnabled,
      'unreadEnabled': instance.unreadEnabled,
    };

NIMNotificationRouteConfig _$NIMNotificationRouteConfigFromJson(
        Map<String, dynamic> json) =>
    NIMNotificationRouteConfig(
      routeEnabled: json['routeEnabled'] as bool?,
      routeEnvironment: json['routeEnvironment'] as String?,
    );

Map<String, dynamic> _$NIMNotificationRouteConfigToJson(
        NIMNotificationRouteConfig instance) =>
    <String, dynamic>{
      'routeEnabled': instance.routeEnabled,
      'routeEnvironment': instance.routeEnvironment,
    };

NIMClearHistoryNotification _$NIMClearHistoryNotificationFromJson(
        Map<String, dynamic> json) =>
    NIMClearHistoryNotification(
      conversationId: json['conversationId'] as String?,
      deleteTime: (json['deleteTime'] as num?)?.toDouble(),
      serverExtension: json['serverExtension'] as String?,
    );

Map<String, dynamic> _$NIMClearHistoryNotificationToJson(
        NIMClearHistoryNotification instance) =>
    <String, dynamic>{
      'conversationId': instance.conversationId,
      'deleteTime': instance.deleteTime,
      'serverExtension': instance.serverExtension,
    };
