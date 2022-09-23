// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'robot_message_attachment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NIMRobotAttachment _$NIMRobotAttachmentFromJson(Map<String, dynamic> json) {
  return NIMRobotAttachment(
    isRobotSend: json['isRobotSend'] as bool,
    fromRobotAccount: json['fromRobotAccount'] as String,
    responseForMessageId: json['responseForMessageId'] as String?,
    response: json['response'] as String?,
    requestType:
        _$enumDecodeNullable(_$NIMRobotMessageTypeEnumMap, json['requestType']),
    requestContent: json['requestContent'] as String?,
    requestTarget: json['requestTarget'] as String?,
    requestParams: json['requestParams'] as String?,
  );
}

Map<String, dynamic> _$NIMRobotAttachmentToJson(NIMRobotAttachment instance) =>
    <String, dynamic>{
      'isRobotSend': instance.isRobotSend,
      'fromRobotAccount': instance.fromRobotAccount,
      'responseForMessageId': instance.responseForMessageId,
      'response': instance.response,
      'requestType': _$NIMRobotMessageTypeEnumMap[instance.requestType],
      'requestContent': instance.requestContent,
      'requestTarget': instance.requestTarget,
      'requestParams': instance.requestParams,
    };

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

K? _$enumDecodeNullable<K, V>(
  Map<K, V> enumValues,
  dynamic source, {
  K? unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<K, V>(enumValues, source, unknownValue: unknownValue);
}

const _$NIMRobotMessageTypeEnumMap = {
  NIMRobotMessageType.welcome: 'welcome',
  NIMRobotMessageType.text: 'text',
  NIMRobotMessageType.link: 'link',
};
