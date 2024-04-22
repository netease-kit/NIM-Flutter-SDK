// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'talk_ext.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NIMCollectInfo _$NIMCollectInfoFromJson(Map<String, dynamic> json) {
  return NIMCollectInfo(
    id: json['id'] as int,
    type: json['type'] as int,
    data: json['data'] as String,
    ext: json['ext'] as String?,
    uniqueId: json['uniqueId'] as String?,
    createTime: (json['createTime'] as num).toDouble(),
    updateTime: (json['updateTime'] as num).toDouble(),
  );
}

Map<String, dynamic> _$NIMCollectInfoToJson(NIMCollectInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'data': instance.data,
      'ext': instance.ext,
      'uniqueId': instance.uniqueId,
      'createTime': instance.createTime,
      'updateTime': instance.updateTime,
    };

NIMMessagePin _$NIMMessagePinFromJson(Map<String, dynamic> json) {
  return NIMMessagePin(
    sessionId: json['sessionId'] as String,
    sessionType: _$enumDecode(_$NIMSessionTypeEnumMap, json['sessionType']),
    messageFromAccount: json['messageFromAccount'] as String?,
    messageToAccount: json['messageToAccount'] as String?,
    messageUuid: json['messageUuid'] as String?,
    messageId: json['messageId'] as String? ?? '-1',
    pinId: json['pinId'] as String? ?? '-1',
    messageServerId: json['messageServerId'] as int?,
    pinOperatorAccount: json['pinOperatorAccount'] as String?,
    pinExt: json['pinExt'] as String?,
    pinCreateTime: json['pinCreateTime'] as int? ?? 0,
    pinUpdateTime: json['pinUpdateTime'] as int? ?? 0,
    messageTime: json['messageTime'] as int? ?? 0,
  );
}

Map<String, dynamic> _$NIMMessagePinToJson(NIMMessagePin instance) =>
    <String, dynamic>{
      'sessionId': instance.sessionId,
      'sessionType': _$NIMSessionTypeEnumMap[instance.sessionType],
      'messageFromAccount': instance.messageFromAccount,
      'messageToAccount': instance.messageToAccount,
      'messageId': instance.messageId,
      'messageUuid': instance.messageUuid,
      'pinId': instance.pinId,
      'messageServerId': instance.messageServerId,
      'pinOperatorAccount': instance.pinOperatorAccount,
      'pinExt': instance.pinExt,
      'pinCreateTime': instance.pinCreateTime,
      'pinUpdateTime': instance.pinUpdateTime,
      'messageTime': instance.messageTime,
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

const _$NIMSessionTypeEnumMap = {
  NIMSessionType.none: 'none',
  NIMSessionType.p2p: 'p2p',
  NIMSessionType.team: 'team',
  NIMSessionType.superTeam: 'superTeam',
  NIMSessionType.system: 'system',
  NIMSessionType.ysf: 'ysf',
  NIMSessionType.chatRoom: 'chatRoom',
};
