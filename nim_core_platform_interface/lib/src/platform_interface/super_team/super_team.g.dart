// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'super_team.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NIMSuperTeam _$NIMSuperTeamFromJson(Map<String, dynamic> json) {
  return NIMSuperTeam(
    id: json['id'] as String?,
    name: json['name'] as String?,
    icon: json['icon'] as String?,
    type: _$enumDecode(_$NIMTeamTypeEnumEnumMap, json['type']),
    announcement: json['announcement'] as String?,
    introduce: json['introduce'] as String?,
    creator: json['creator'] as String?,
    memberCount: json['memberCount'] as int,
    memberLimit: json['memberLimit'] as int,
    verifyType: _$enumDecode(_$NIMVerifyTypeEnumEnumMap, json['verifyType']),
    createTime: json['createTime'] as num,
    isMyTeam: json['isMyTeam'] as bool?,
    extension: json['extension'] as String?,
    extServer: json['extServer'] as String?,
    messageNotifyType: _$enumDecode(
        _$NIMTeamMessageNotifyTypeEnumEnumMap, json['messageNotifyType']),
    teamInviteMode:
        _$enumDecode(_$NIMTeamInviteModeEnumEnumMap, json['teamInviteMode']),
    teamBeInviteModeEnum: _$enumDecode(
        _$NIMTeamBeInviteModeEnumEnumMap, json['teamBeInviteModeEnum']),
    teamUpdateMode:
        _$enumDecode(_$NIMTeamUpdateModeEnumEnumMap, json['teamUpdateMode']),
    teamExtensionUpdateMode: _$enumDecode(
        _$NIMTeamExtensionUpdateModeEnumEnumMap,
        json['teamExtensionUpdateMode']),
    isAllMute: json['isAllMute'] as bool?,
    muteMode: _$enumDecode(_$NIMTeamAllMuteModeEnumEnumMap, json['muteMode']),
  );
}

Map<String, dynamic> _$NIMSuperTeamToJson(NIMSuperTeam instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'icon': instance.icon,
      'type': _$NIMTeamTypeEnumEnumMap[instance.type],
      'announcement': instance.announcement,
      'introduce': instance.introduce,
      'creator': instance.creator,
      'memberCount': instance.memberCount,
      'memberLimit': instance.memberLimit,
      'verifyType': _$NIMVerifyTypeEnumEnumMap[instance.verifyType],
      'createTime': instance.createTime,
      'isMyTeam': instance.isMyTeam,
      'extension': instance.extension,
      'extServer': instance.extServer,
      'messageNotifyType':
          _$NIMTeamMessageNotifyTypeEnumEnumMap[instance.messageNotifyType],
      'teamInviteMode': _$NIMTeamInviteModeEnumEnumMap[instance.teamInviteMode],
      'teamBeInviteModeEnum':
          _$NIMTeamBeInviteModeEnumEnumMap[instance.teamBeInviteModeEnum],
      'teamUpdateMode': _$NIMTeamUpdateModeEnumEnumMap[instance.teamUpdateMode],
      'teamExtensionUpdateMode': _$NIMTeamExtensionUpdateModeEnumEnumMap[
          instance.teamExtensionUpdateMode],
      'isAllMute': instance.isAllMute,
      'muteMode': _$NIMTeamAllMuteModeEnumEnumMap[instance.muteMode],
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

const _$NIMTeamMessageNotifyTypeEnumEnumMap = {
  NIMTeamMessageNotifyTypeEnum.all: 'all',
  NIMTeamMessageNotifyTypeEnum.manager: 'manager',
  NIMTeamMessageNotifyTypeEnum.mute: 'mute',
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

const _$NIMTeamAllMuteModeEnumEnumMap = {
  NIMTeamAllMuteModeEnum.cancel: 'cancel',
  NIMTeamAllMuteModeEnum.muteNormal: 'muteNormal',
  NIMTeamAllMuteModeEnum.muteAll: 'muteAll',
};
