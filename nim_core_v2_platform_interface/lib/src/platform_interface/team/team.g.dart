// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NIMTeam _$NIMTeamFromJson(Map<String, dynamic> json) => NIMTeam(
      teamId: json['teamId'] as String,
      teamType: $enumDecode(_$NIMTeamTypeEnumMap, json['teamType']),
      name: json['name'] as String,
      ownerAccountId: json['ownerAccountId'] as String,
      memberLimit: (json['memberLimit'] as num).toInt(),
      memberCount: (json['memberCount'] as num).toInt(),
      createTime: (json['createTime'] as num).toInt(),
      updateTime: (json['updateTime'] as num).toInt(),
      intro: json['intro'] as String?,
      announcement: json['announcement'] as String?,
      avatar: json['avatar'] as String?,
      serverExtension: json['serverExtension'] as String?,
      customerExtension: json['customerExtension'] as String?,
      joinMode: $enumDecode(_$NIMTeamJoinModeEnumMap, json['joinMode']),
      agreeMode: $enumDecode(_$NIMTeamAgreeModeEnumMap, json['agreeMode']),
      inviteMode: $enumDecode(_$NIMTeamInviteModeEnumMap, json['inviteMode']),
      updateInfoMode:
          $enumDecode(_$NIMTeamUpdateInfoModeEnumMap, json['updateInfoMode']),
      updateExtensionMode: $enumDecode(
          _$NIMTeamUpdateExtensionModeEnumMap, json['updateExtensionMode']),
      chatBannedMode:
          $enumDecode(_$NIMTeamChatBannedModeEnumMap, json['chatBannedMode']),
      isValidTeam: json['isValidTeam'] as bool,
    );

Map<String, dynamic> _$NIMTeamToJson(NIMTeam instance) => <String, dynamic>{
      'teamId': instance.teamId,
      'teamType': _$NIMTeamTypeEnumMap[instance.teamType]!,
      'name': instance.name,
      'ownerAccountId': instance.ownerAccountId,
      'memberLimit': instance.memberLimit,
      'memberCount': instance.memberCount,
      'createTime': instance.createTime,
      'updateTime': instance.updateTime,
      'intro': instance.intro,
      'announcement': instance.announcement,
      'avatar': instance.avatar,
      'serverExtension': instance.serverExtension,
      'customerExtension': instance.customerExtension,
      'joinMode': _$NIMTeamJoinModeEnumMap[instance.joinMode]!,
      'agreeMode': _$NIMTeamAgreeModeEnumMap[instance.agreeMode]!,
      'inviteMode': _$NIMTeamInviteModeEnumMap[instance.inviteMode]!,
      'updateInfoMode':
          _$NIMTeamUpdateInfoModeEnumMap[instance.updateInfoMode]!,
      'updateExtensionMode':
          _$NIMTeamUpdateExtensionModeEnumMap[instance.updateExtensionMode]!,
      'chatBannedMode':
          _$NIMTeamChatBannedModeEnumMap[instance.chatBannedMode]!,
      'isValidTeam': instance.isValidTeam,
    };

const _$NIMTeamTypeEnumMap = {
  NIMTeamType.typeInvalid: 0,
  NIMTeamType.typeNormal: 1,
  NIMTeamType.typeSuper: 2,
};

const _$NIMTeamJoinModeEnumMap = {
  NIMTeamJoinMode.joinModeFree: 0,
  NIMTeamJoinMode.joinModeApply: 1,
  NIMTeamJoinMode.joinModeInvite: 2,
};

const _$NIMTeamAgreeModeEnumMap = {
  NIMTeamAgreeMode.agreeModeAuth: 0,
  NIMTeamAgreeMode.agreeModeNoAuth: 1,
};

const _$NIMTeamInviteModeEnumMap = {
  NIMTeamInviteMode.inviteModeManager: 0,
  NIMTeamInviteMode.inviteModeAll: 1,
};

const _$NIMTeamUpdateInfoModeEnumMap = {
  NIMTeamUpdateInfoMode.updateInfoModeManager: 0,
  NIMTeamUpdateInfoMode.updateInfoModeAll: 1,
};

const _$NIMTeamUpdateExtensionModeEnumMap = {
  NIMTeamUpdateExtensionMode.updateExtensionModeManager: 0,
  NIMTeamUpdateExtensionMode.updateExtensionModeAll: 1,
};

const _$NIMTeamChatBannedModeEnumMap = {
  NIMTeamChatBannedMode.chatBannedModeNone: 0,
  NIMTeamChatBannedMode.chatBannedModeBannedNormal: 1,
  NIMTeamChatBannedMode.chatBannedModeBannedAll: 2,
};

TeamLeftReuslt _$TeamLeftReusltFromJson(Map<String, dynamic> json) =>
    TeamLeftReuslt(
      team: _nimTeamFromJson(json['team'] as Map),
      isKicked: json['isKicked'] as bool,
    );

Map<String, dynamic> _$TeamLeftReusltToJson(TeamLeftReuslt instance) =>
    <String, dynamic>{
      'team': instance.team,
      'isKicked': instance.isKicked,
    };

NIMTeamTypeClass _$NIMTeamTypeClassFromJson(Map<String, dynamic> json) =>
    NIMTeamTypeClass(
      $enumDecode(_$NIMTeamTypeEnumMap, json['type']),
    );

Map<String, dynamic> _$NIMTeamTypeClassToJson(NIMTeamTypeClass instance) =>
    <String, dynamic>{
      'type': _$NIMTeamTypeEnumMap[instance.type]!,
    };

NIMTeamChatBannedModeClass _$NIMTeamChatBannedModeClassFromJson(
        Map<String, dynamic> json) =>
    NIMTeamChatBannedModeClass(
      $enumDecode(_$NIMTeamChatBannedModeEnumMap, json['mode']),
    );

Map<String, dynamic> _$NIMTeamChatBannedModeClassToJson(
        NIMTeamChatBannedModeClass instance) =>
    <String, dynamic>{
      'mode': _$NIMTeamChatBannedModeEnumMap[instance.mode]!,
    };
