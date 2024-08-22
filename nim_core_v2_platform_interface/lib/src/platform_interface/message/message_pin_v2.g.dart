// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_pin_v2.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NIMMessagePin _$NIMMessagePinFromJson(Map<String, dynamic> json) =>
    NIMMessagePin(
      messageRefer: nimMessageReferFromJson(json['messageRefer'] as Map?),
      operatorId: json['operatorId'] as String?,
      serverExtension: json['serverExtension'] as String?,
      createTime: (json['createTime'] as num?)?.toInt(),
      updateTime: (json['updateTime'] as num?)?.toInt(),
    );

Map<String, dynamic> _$NIMMessagePinToJson(NIMMessagePin instance) =>
    <String, dynamic>{
      'messageRefer': instance.messageRefer?.toJson(),
      'operatorId': instance.operatorId,
      'serverExtension': instance.serverExtension,
      'createTime': instance.createTime,
      'updateTime': instance.updateTime,
    };

NIMMessagePinNotification _$NIMMessagePinNotificationFromJson(
        Map<String, dynamic> json) =>
    NIMMessagePinNotification(
      pin: _nimMessagePinFromJson(json['pin'] as Map?),
      pinState:
          $enumDecodeNullable(_$NIMMessagePinStateEnumMap, json['pinState']),
    );

Map<String, dynamic> _$NIMMessagePinNotificationToJson(
        NIMMessagePinNotification instance) =>
    <String, dynamic>{
      'pin': instance.pin?.toJson(),
      'pinState': _$NIMMessagePinStateEnumMap[instance.pinState],
    };

const _$NIMMessagePinStateEnumMap = {
  NIMMessagePinState.notPinned: 0,
  NIMMessagePinState.pinned: 1,
  NIMMessagePinState.updated: 2,
};
