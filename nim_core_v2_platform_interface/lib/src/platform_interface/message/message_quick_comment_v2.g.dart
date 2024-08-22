// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_quick_comment_v2.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NIMMessageQuickComment _$NIMMessageQuickCommentFromJson(
        Map<String, dynamic> json) =>
    NIMMessageQuickComment(
      messageRefer: nimMessageReferFromJson(json['messageRefer'] as Map?),
      operatorId: json['operatorId'] as String?,
      index: (json['index'] as num?)?.toInt(),
      createTime: (json['createTime'] as num?)?.toInt(),
      serverExtension: json['serverExtension'] as String?,
    );

Map<String, dynamic> _$NIMMessageQuickCommentToJson(
        NIMMessageQuickComment instance) =>
    <String, dynamic>{
      'messageRefer': instance.messageRefer?.toJson(),
      'operatorId': instance.operatorId,
      'index': instance.index,
      'createTime': instance.createTime,
      'serverExtension': instance.serverExtension,
    };

NIMMessageQuickCommentNotification _$NIMMessageQuickCommentNotificationFromJson(
        Map<String, dynamic> json) =>
    NIMMessageQuickCommentNotification(
      operationType: $enumDecodeNullable(
          _$NIMMessageQuickCommentTypeEnumMap, json['operationType']),
      quickComment:
          _nimMessageQuickCommentFromJson(json['quickComment'] as Map?),
    );

Map<String, dynamic> _$NIMMessageQuickCommentNotificationToJson(
        NIMMessageQuickCommentNotification instance) =>
    <String, dynamic>{
      'operationType':
          _$NIMMessageQuickCommentTypeEnumMap[instance.operationType],
      'quickComment': instance.quickComment?.toJson(),
    };

const _$NIMMessageQuickCommentTypeEnumMap = {
  NIMMessageQuickCommentType.add: 1,
  NIMMessageQuickCommentType.remove: 2,
};

NIMMessageQuickCommentPushConfig _$NIMMessageQuickCommentPushConfigFromJson(
        Map<String, dynamic> json) =>
    NIMMessageQuickCommentPushConfig(
      pushEnabled: json['pushEnabled'] as bool?,
      needBadge: json['needBadge'] as bool?,
      pushTitle: json['pushTitle'] as String?,
      pushContent: json['pushContent'] as String?,
      pushPayload: json['pushPayload'] as String?,
    );

Map<String, dynamic> _$NIMMessageQuickCommentPushConfigToJson(
        NIMMessageQuickCommentPushConfig instance) =>
    <String, dynamic>{
      'pushEnabled': instance.pushEnabled,
      'needBadge': instance.needBadge,
      'pushTitle': instance.pushTitle,
      'pushContent': instance.pushContent,
      'pushPayload': instance.pushPayload,
    };
