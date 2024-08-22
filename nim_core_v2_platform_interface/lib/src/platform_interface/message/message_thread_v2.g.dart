// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_thread_v2.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NIMThreadMessageListResult _$NIMThreadMessageListResultFromJson(
        Map<String, dynamic> json) =>
    NIMThreadMessageListResult(
      message: nimMessageFromJson(json['message'] as Map?),
      timestamp: (json['timestamp'] as num?)?.toInt(),
      replyCount: (json['replyCount'] as num?)?.toInt(),
      replyList: _nimMessageListFromJson(json['replyList'] as List?),
    );

Map<String, dynamic> _$NIMThreadMessageListResultToJson(
        NIMThreadMessageListResult instance) =>
    <String, dynamic>{
      'message': instance.message?.toJson(),
      'timestamp': instance.timestamp,
      'replyCount': instance.replyCount,
      'replyList': instance.replyList?.map((e) => e?.toJson()).toList(),
    };

NIMThreadMessageListOption _$NIMThreadMessageListOptionFromJson(
        Map<String, dynamic> json) =>
    NIMThreadMessageListOption(
      messageRefer: nimMessageReferFromJson(json['messageRefer'] as Map?),
      beginTime: (json['beginTime'] as num?)?.toInt(),
      endTime: (json['endTime'] as num?)?.toInt(),
      excludeMessageServerId: json['excludeMessageServerId'] as String?,
      limit: (json['limit'] as num?)?.toInt(),
      direction:
          $enumDecodeNullable(_$NIMQueryDirectionEnumMap, json['direction']),
    );

Map<String, dynamic> _$NIMThreadMessageListOptionToJson(
        NIMThreadMessageListOption instance) =>
    <String, dynamic>{
      'messageRefer': instance.messageRefer?.toJson(),
      'beginTime': instance.beginTime,
      'endTime': instance.endTime,
      'excludeMessageServerId': instance.excludeMessageServerId,
      'limit': instance.limit,
      'direction': _$NIMQueryDirectionEnumMap[instance.direction],
    };

const _$NIMQueryDirectionEnumMap = {
  NIMQueryDirection.desc: 0,
  NIMQueryDirection.asc: 1,
};
