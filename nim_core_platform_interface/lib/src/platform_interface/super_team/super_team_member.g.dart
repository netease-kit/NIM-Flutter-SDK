// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'super_team_member.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NIMSuperTeamMember _$NIMSuperTeamMemberFromJson(Map<String, dynamic> json) {
  return NIMSuperTeamMember(
    id: json['id'] as String?,
    account: json['account'] as String?,
    type: _$enumDecodeNullable(_$TeamMemberTypeEnumMap, json['type']),
    teamNick: json['teamNick'] as String?,
    isInTeam: json['isInTeam'] as bool,
    extension: castPlatformMapToDartMap(json['extension'] as Map?),
    isMute: json['isMute'] as bool,
    joinTime: json['joinTime'] as int,
    invitorAccid: json['invitorAccid'] as String?,
  );
}

Map<String, dynamic> _$NIMSuperTeamMemberToJson(NIMSuperTeamMember instance) =>
    <String, dynamic>{
      'id': instance.id,
      'account': instance.account,
      'type': _$TeamMemberTypeEnumMap[instance.type],
      'teamNick': instance.teamNick,
      'isInTeam': instance.isInTeam,
      'extension': instance.extension,
      'isMute': instance.isMute,
      'joinTime': instance.joinTime,
      'invitorAccid': instance.invitorAccid,
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

const _$TeamMemberTypeEnumMap = {
  TeamMemberType.normal: 'normal',
  TeamMemberType.owner: 'owner',
  TeamMemberType.manager: 'manager',
  TeamMemberType.apply: 'apply',
};
