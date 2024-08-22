// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_member.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NIMTeamMemberRoleClass _$NIMTeamMemberRoleClassFromJson(
        Map<String, dynamic> json) =>
    NIMTeamMemberRoleClass(
      $enumDecode(_$NIMTeamMemberRoleEnumMap, json['role']),
    );

Map<String, dynamic> _$NIMTeamMemberRoleClassToJson(
        NIMTeamMemberRoleClass instance) =>
    <String, dynamic>{
      'role': _$NIMTeamMemberRoleEnumMap[instance.role]!,
    };

const _$NIMTeamMemberRoleEnumMap = {
  NIMTeamMemberRole.memberRoleNormal: 0,
  NIMTeamMemberRole.memberRoleOwner: 1,
  NIMTeamMemberRole.memberRoleManager: 2,
};

NIMTeamMember _$NIMTeamMemberFromJson(Map<String, dynamic> json) =>
    NIMTeamMember(
      teamId: json['teamId'] as String,
      teamType: $enumDecode(_$NIMTeamTypeEnumMap, json['teamType']),
      accountId: json['accountId'] as String,
      memberRole: $enumDecode(_$NIMTeamMemberRoleEnumMap, json['memberRole']),
      teamNick: json['teamNick'] as String?,
      serverExtension: json['serverExtension'] as String?,
      joinTime: (json['joinTime'] as num).toInt(),
      updateTime: (json['updateTime'] as num?)?.toInt(),
      inTeam: json['inTeam'] as bool,
      chatBanned: json['chatBanned'] as bool?,
    );

Map<String, dynamic> _$NIMTeamMemberToJson(NIMTeamMember instance) =>
    <String, dynamic>{
      'teamId': instance.teamId,
      'teamType': _$NIMTeamTypeEnumMap[instance.teamType]!,
      'accountId': instance.accountId,
      'memberRole': _$NIMTeamMemberRoleEnumMap[instance.memberRole]!,
      'teamNick': instance.teamNick,
      'serverExtension': instance.serverExtension,
      'joinTime': instance.joinTime,
      'updateTime': instance.updateTime,
      'inTeam': instance.inTeam,
      'chatBanned': instance.chatBanned,
    };

const _$NIMTeamTypeEnumMap = {
  NIMTeamType.typeInvalid: 0,
  NIMTeamType.typeNormal: 1,
  NIMTeamType.typeSuper: 2,
};

TeamMemberKickedResult _$TeamMemberKickedResultFromJson(
        Map<String, dynamic> json) =>
    TeamMemberKickedResult(
      teamMembers: _teamMemberListFromJsonList(json['teamMembers'] as List),
      operatorAccountId: json['operatorAccountId'] as String,
    );

Map<String, dynamic> _$TeamMemberKickedResultToJson(
        TeamMemberKickedResult instance) =>
    <String, dynamic>{
      'teamMembers': instance.teamMembers,
      'operatorAccountId': instance.operatorAccountId,
    };
