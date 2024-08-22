// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dnd_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NIMDndConfig _$NIMDndConfigFromJson(Map<String, dynamic> json) => NIMDndConfig(
      showDetail: json['showDetail'] as bool?,
      dndOn: json['dndOn'] as bool?,
      fromH: (json['fromH'] as num?)?.toInt(),
      fromM: (json['fromM'] as num?)?.toInt(),
      toH: (json['toH'] as num?)?.toInt(),
      toM: (json['toM'] as num?)?.toInt(),
    );

Map<String, dynamic> _$NIMDndConfigToJson(NIMDndConfig instance) =>
    <String, dynamic>{
      'showDetail': instance.showDetail,
      'dndOn': instance.dndOn,
      'fromH': instance.fromH,
      'fromM': instance.fromM,
      'toH': instance.toH,
      'toM': instance.toM,
    };

SettingEnumClass _$SettingEnumClassFromJson(Map<String, dynamic> json) =>
    SettingEnumClass(
      teamMessageMuteMode: $enumDecode(
          _$NIMTeamMessageMuteModeEnumMap, json['teamMessageMuteMode']),
      p2pMessageMuteMode: $enumDecode(
          _$NIMP2PMessageMuteModeEnumMap, json['p2pMessageMuteMode']),
    );

Map<String, dynamic> _$SettingEnumClassToJson(SettingEnumClass instance) =>
    <String, dynamic>{
      'teamMessageMuteMode':
          _$NIMTeamMessageMuteModeEnumMap[instance.teamMessageMuteMode]!,
      'p2pMessageMuteMode':
          _$NIMP2PMessageMuteModeEnumMap[instance.p2pMessageMuteMode]!,
    };

const _$NIMTeamMessageMuteModeEnumMap = {
  NIMTeamMessageMuteMode.teamMessageMuteModeOff: 0,
  NIMTeamMessageMuteMode.teamMessageMuteModeOn: 1,
  NIMTeamMessageMuteMode.teamMessageMuteModeManagerOff: 2,
};

const _$NIMP2PMessageMuteModeEnumMap = {
  NIMP2PMessageMuteMode.p2pMessageMuteModeOff: 0,
  NIMP2PMessageMuteMode.p2pMessageMuteModeOn: 1,
};

TeamMuteModeChangedResult _$TeamMuteModeChangedResultFromJson(
        Map<String, dynamic> json) =>
    TeamMuteModeChangedResult(
      teamId: json['teamId'] as String,
      teamType: $enumDecode(_$NIMTeamTypeEnumMap, json['teamType']),
      muteMode: $enumDecode(_$NIMTeamMessageMuteModeEnumMap, json['muteMode']),
    );

Map<String, dynamic> _$TeamMuteModeChangedResultToJson(
        TeamMuteModeChangedResult instance) =>
    <String, dynamic>{
      'teamId': instance.teamId,
      'teamType': _$NIMTeamTypeEnumMap[instance.teamType]!,
      'muteMode': _$NIMTeamMessageMuteModeEnumMap[instance.muteMode]!,
    };

const _$NIMTeamTypeEnumMap = {
  NIMTeamType.typeInvalid: 0,
  NIMTeamType.typeNormal: 1,
  NIMTeamType.typeSuper: 2,
};

P2PMuteModeChangedResult _$P2PMuteModeChangedResultFromJson(
        Map<String, dynamic> json) =>
    P2PMuteModeChangedResult(
      accountId: json['accountId'] as String,
      muteMode: $enumDecode(_$NIMP2PMessageMuteModeEnumMap, json['muteMode']),
    );

Map<String, dynamic> _$P2PMuteModeChangedResultToJson(
        P2PMuteModeChangedResult instance) =>
    <String, dynamic>{
      'accountId': instance.accountId,
      'muteMode': _$NIMP2PMessageMuteModeEnumMap[instance.muteMode]!,
    };

NIMP2PMessageMuteModeClass _$NIMP2PMessageMuteModeClassFromJson(
        Map<String, dynamic> json) =>
    NIMP2PMessageMuteModeClass(
      muteMode: $enumDecode(_$NIMP2PMessageMuteModeEnumMap, json['muteMode']),
    );

Map<String, dynamic> _$NIMP2PMessageMuteModeClassToJson(
        NIMP2PMessageMuteModeClass instance) =>
    <String, dynamic>{
      'muteMode': _$NIMP2PMessageMuteModeEnumMap[instance.muteMode]!,
    };

NIMTeamMessageMuteModeClass _$NIMTeamMessageMuteModeClassFromJson(
        Map<String, dynamic> json) =>
    NIMTeamMessageMuteModeClass(
      muteMode: $enumDecode(_$NIMTeamMessageMuteModeEnumMap, json['muteMode']),
    );

Map<String, dynamic> _$NIMTeamMessageMuteModeClassToJson(
        NIMTeamMessageMuteModeClass instance) =>
    <String, dynamic>{
      'muteMode': _$NIMTeamMessageMuteModeEnumMap[instance.muteMode]!,
    };
