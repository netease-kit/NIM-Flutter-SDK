// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_insert_params.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

V2NIMMessageInsertParams _$V2NIMMessageInsertParamsFromJson(
        Map<String, dynamic> json) =>
    V2NIMMessageInsertParams(
      conversationId: json['conversationId'] as String,
      senderId: json['senderId'] as String?,
      createTime: (json['createTime'] as num?)?.toInt() ?? 0,
      lastMessageUpdateEnabled:
          json['lastMessageUpdateEnabled'] as bool? ?? true,
    );

Map<String, dynamic> _$V2NIMMessageInsertParamsToJson(
        V2NIMMessageInsertParams instance) =>
    <String, dynamic>{
      'conversationId': instance.conversationId,
      'senderId': instance.senderId,
      'createTime': instance.createTime,
      'lastMessageUpdateEnabled': instance.lastMessageUpdateEnabled,
    };
