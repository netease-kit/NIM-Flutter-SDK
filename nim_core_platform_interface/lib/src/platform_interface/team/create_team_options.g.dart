// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_team_options.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NIMCreateTeamOptions _$NIMCreateTeamOptionsFromJson(Map<String, dynamic> json) {
  return NIMCreateTeamOptions(
    name: json['name'] as String?,
    teamType: _$enumDecodeNullable(_$NIMTeamTypeEnumEnumMap, json['teamType']),
    avatarUrl: json['avatarUrl'] as String?,
    introduce: json['introduce'] as String?,
    announcement: json['announcement'] as String?,
    extension: json['extension'] as String?,
    postscript: json['postscript'] as String?,
    verifyType:
        _$enumDecodeNullable(_$NIMVerifyTypeEnumEnumMap, json['verifyType']),
    inviteMode: _$enumDecodeNullable(
        _$NIMTeamInviteModeEnumEnumMap, json['inviteMode']),
    beInviteMode: _$enumDecodeNullable(
        _$NIMTeamBeInviteModeEnumEnumMap, json['beInviteMode']),
    updateInfoMode: _$enumDecodeNullable(
        _$NIMTeamUpdateModeEnumEnumMap, json['updateInfoMode']),
    extensionUpdateMode: _$enumDecodeNullable(
        _$NIMTeamExtensionUpdateModeEnumEnumMap, json['extensionUpdateMode']),
    maxMemberCount: json['maxMemberCount'] as int?,
  );
}

Map<String, dynamic> _$NIMCreateTeamOptionsToJson(
        NIMCreateTeamOptions instance) =>
    <String, dynamic>{
      'name': instance.name,
      'teamType': _$NIMTeamTypeEnumEnumMap[instance.teamType],
      'avatarUrl': instance.avatarUrl,
      'introduce': instance.introduce,
      'announcement': instance.announcement,
      'extension': instance.extension,
      'postscript': instance.postscript,
      'verifyType': _$NIMVerifyTypeEnumEnumMap[instance.verifyType],
      'inviteMode': _$NIMTeamInviteModeEnumEnumMap[instance.inviteMode],
      'beInviteMode': _$NIMTeamBeInviteModeEnumEnumMap[instance.beInviteMode],
      'updateInfoMode': _$NIMTeamUpdateModeEnumEnumMap[instance.updateInfoMode],
      'extensionUpdateMode':
          _$NIMTeamExtensionUpdateModeEnumEnumMap[instance.extensionUpdateMode],
      'maxMemberCount': instance.maxMemberCount,
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

const _$NIMTeamTypeEnumEnumMap = {
  NIMTeamTypeEnum.advanced: 'advanced',
  NIMTeamTypeEnum.normal: 'normal',
  NIMTeamTypeEnum.superTeam: 'superTeam',
};

const _$NIMVerifyTypeEnumEnumMap = {
  NIMVerifyTypeEnum.free: 'free',
  NIMVerifyTypeEnum.apply: 'apply',
  NIMVerifyTypeEnum.private: 'private',
};

const _$NIMTeamInviteModeEnumEnumMap = {
  NIMTeamInviteModeEnum.manager: 'manager',
  NIMTeamInviteModeEnum.all: 'all',
};

const _$NIMTeamBeInviteModeEnumEnumMap = {
  NIMTeamBeInviteModeEnum.needAuth: 'needAuth',
  NIMTeamBeInviteModeEnum.noAuth: 'noAuth',
};

const _$NIMTeamUpdateModeEnumEnumMap = {
  NIMTeamUpdateModeEnum.manager: 'manager',
  NIMTeamUpdateModeEnum.all: 'all',
};

const _$NIMTeamExtensionUpdateModeEnumEnumMap = {
  NIMTeamExtensionUpdateModeEnum.manager: 'manager',
  NIMTeamExtensionUpdateModeEnum.all: 'all',
};
