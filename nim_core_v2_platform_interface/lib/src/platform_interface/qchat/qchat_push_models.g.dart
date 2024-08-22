// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qchat_push_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QChatPushConfig _$QChatPushConfigFromJson(Map<String, dynamic> json) =>
    QChatPushConfig(
      pushMsgType:
          $enumDecodeNullable(_$QChatPushMsgTypeEnumMap, json['pushMsgType']),
      isNoDisturbOpen: json['isNoDisturbOpen'] as bool?,
      isPushShowNoDetail: json['isPushShowNoDetail'] as bool,
      startNoDisturbTime: json['startNoDisturbTime'] as String?,
      stopNoDisturbTime: json['stopNoDisturbTime'] as String?,
    );

Map<String, dynamic> _$QChatPushConfigToJson(QChatPushConfig instance) =>
    <String, dynamic>{
      'isPushShowNoDetail': instance.isPushShowNoDetail,
      'isNoDisturbOpen': instance.isNoDisturbOpen,
      'startNoDisturbTime': instance.startNoDisturbTime,
      'stopNoDisturbTime': instance.stopNoDisturbTime,
      'pushMsgType': _$QChatPushMsgTypeEnumMap[instance.pushMsgType],
    };

const _$QChatPushMsgTypeEnumMap = {
  QChatPushMsgType.all: 'all',
  QChatPushMsgType.highMidLevel: 'highMidLevel',
  QChatPushMsgType.highLevel: 'highLevel',
  QChatPushMsgType.none: 'none',
  QChatPushMsgType.inherit: 'inherit',
};
