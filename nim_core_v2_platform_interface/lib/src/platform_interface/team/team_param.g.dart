// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_param.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NIMCreateTeamParams _$NIMCreateTeamParamsFromJson(Map<String, dynamic> json) =>
    NIMCreateTeamParams(
      name: json['name'] as String,
      teamType: $enumDecode(_$NIMTeamTypeEnumMap, json['teamType']),
      memberLimit: (json['memberLimit'] as num?)?.toInt(),
      intro: json['intro'] as String?,
      announcement: json['announcement'] as String?,
      avatar: json['avatar'] as String?,
      serverExtension: json['serverExtension'] as String?,
      joinMode: $enumDecodeNullable(_$NIMTeamJoinModeEnumMap, json['joinMode']),
      agreeMode:
          $enumDecodeNullable(_$NIMTeamAgreeModeEnumMap, json['agreeMode']),
      inviteMode:
          $enumDecodeNullable(_$NIMTeamInviteModeEnumMap, json['inviteMode']),
      updateInfoMode: $enumDecodeNullable(
          _$NIMTeamUpdateInfoModeEnumMap, json['updateInfoMode']),
      updateExtensionMode: $enumDecodeNullable(
          _$NIMTeamUpdateExtensionModeEnumMap, json['updateExtensionMode']),
      chatBannedMode: $enumDecodeNullable(
          _$NIMTeamChatBannedModeEnumMap, json['chatBannedMode']),
    );

Map<String, dynamic> _$NIMCreateTeamParamsToJson(
        NIMCreateTeamParams instance) =>
    <String, dynamic>{
      'name': instance.name,
      'teamType': _$NIMTeamTypeEnumMap[instance.teamType]!,
      'memberLimit': instance.memberLimit,
      'intro': instance.intro,
      'announcement': instance.announcement,
      'avatar': instance.avatar,
      'serverExtension': instance.serverExtension,
      'joinMode': _$NIMTeamJoinModeEnumMap[instance.joinMode],
      'agreeMode': _$NIMTeamAgreeModeEnumMap[instance.agreeMode],
      'inviteMode': _$NIMTeamInviteModeEnumMap[instance.inviteMode],
      'updateInfoMode': _$NIMTeamUpdateInfoModeEnumMap[instance.updateInfoMode],
      'updateExtensionMode':
          _$NIMTeamUpdateExtensionModeEnumMap[instance.updateExtensionMode],
      'chatBannedMode': _$NIMTeamChatBannedModeEnumMap[instance.chatBannedMode],
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

NIMUpdateTeamInfoParams _$NIMUpdateTeamInfoParamsFromJson(
        Map<String, dynamic> json) =>
    NIMUpdateTeamInfoParams(
      name: json['name'] as String?,
      memberLimit: (json['memberLimit'] as num?)?.toInt(),
      intro: json['intro'] as String?,
      announcement: json['announcement'] as String?,
      avatar: json['avatar'] as String?,
      serverExtension: json['serverExtension'] as String?,
      joinMode: $enumDecodeNullable(_$NIMTeamJoinModeEnumMap, json['joinMode']),
      agreeMode:
          $enumDecodeNullable(_$NIMTeamAgreeModeEnumMap, json['agreeMode']),
      inviteMode:
          $enumDecodeNullable(_$NIMTeamInviteModeEnumMap, json['inviteMode']),
      updateInfoMode: $enumDecodeNullable(
          _$NIMTeamUpdateInfoModeEnumMap, json['updateInfoMode']),
      updateExtensionMode: $enumDecodeNullable(
          _$NIMTeamUpdateExtensionModeEnumMap, json['updateExtensionMode']),
    );

Map<String, dynamic> _$NIMUpdateTeamInfoParamsToJson(
        NIMUpdateTeamInfoParams instance) =>
    <String, dynamic>{
      'name': instance.name,
      'memberLimit': instance.memberLimit,
      'intro': instance.intro,
      'announcement': instance.announcement,
      'avatar': instance.avatar,
      'serverExtension': instance.serverExtension,
      'joinMode': _$NIMTeamJoinModeEnumMap[instance.joinMode],
      'agreeMode': _$NIMTeamAgreeModeEnumMap[instance.agreeMode],
      'inviteMode': _$NIMTeamInviteModeEnumMap[instance.inviteMode],
      'updateInfoMode': _$NIMTeamUpdateInfoModeEnumMap[instance.updateInfoMode],
      'updateExtensionMode':
          _$NIMTeamUpdateExtensionModeEnumMap[instance.updateExtensionMode],
    };

NIMUpdatedTeamInfo _$NIMUpdatedTeamInfoFromJson(Map<String, dynamic> json) =>
    NIMUpdatedTeamInfo(
      name: json['name'] as String?,
      memberLimit: (json['memberLimit'] as num?)?.toInt(),
      intro: json['intro'] as String?,
      announcement: json['announcement'] as String?,
      avatar: json['avatar'] as String?,
      serverExtension: json['serverExtension'] as String?,
      joinMode: $enumDecodeNullable(_$NIMTeamJoinModeEnumMap, json['joinMode']),
      agreeMode:
          $enumDecodeNullable(_$NIMTeamAgreeModeEnumMap, json['agreeMode']),
      inviteMode:
          $enumDecodeNullable(_$NIMTeamInviteModeEnumMap, json['inviteMode']),
      updateInfoMode: $enumDecodeNullable(
          _$NIMTeamUpdateInfoModeEnumMap, json['updateInfoMode']),
      updateExtensionMode: $enumDecodeNullable(
          _$NIMTeamUpdateExtensionModeEnumMap, json['updateExtensionMode']),
      chatBannedMode: (json['chatBannedMode'] as num?)?.toInt(),
    );

Map<String, dynamic> _$NIMUpdatedTeamInfoToJson(NIMUpdatedTeamInfo instance) =>
    <String, dynamic>{
      'name': instance.name,
      'memberLimit': instance.memberLimit,
      'intro': instance.intro,
      'announcement': instance.announcement,
      'avatar': instance.avatar,
      'serverExtension': instance.serverExtension,
      'joinMode': _$NIMTeamJoinModeEnumMap[instance.joinMode],
      'agreeMode': _$NIMTeamAgreeModeEnumMap[instance.agreeMode],
      'inviteMode': _$NIMTeamInviteModeEnumMap[instance.inviteMode],
      'updateInfoMode': _$NIMTeamUpdateInfoModeEnumMap[instance.updateInfoMode],
      'updateExtensionMode':
          _$NIMTeamUpdateExtensionModeEnumMap[instance.updateExtensionMode],
      'chatBannedMode': instance.chatBannedMode,
    };

NIMUpdateSelfMemberInfoParams _$NIMUpdateSelfMemberInfoParamsFromJson(
        Map<String, dynamic> json) =>
    NIMUpdateSelfMemberInfoParams(
      teamNick: json['teamNick'] as String?,
      serverExtension: json['serverExtension'] as String?,
    );

Map<String, dynamic> _$NIMUpdateSelfMemberInfoParamsToJson(
        NIMUpdateSelfMemberInfoParams instance) =>
    <String, dynamic>{
      'teamNick': instance.teamNick,
      'serverExtension': instance.serverExtension,
    };

NIMTeamMemberQueryOption _$NIMTeamMemberQueryOptionFromJson(
        Map<String, dynamic> json) =>
    NIMTeamMemberQueryOption(
      roleQueryType: $enumDecode(
          _$NIMTeamMemberRoleQueryTypeEnumMap, json['roleQueryType']),
      onlyChatBanned: json['onlyChatBanned'] as bool?,
      direction:
          $enumDecodeNullable(_$NIMQueryDirectionEnumMap, json['direction']),
      nextToken: json['nextToken'] as String?,
      limit: (json['limit'] as num?)?.toInt(),
    );

Map<String, dynamic> _$NIMTeamMemberQueryOptionToJson(
        NIMTeamMemberQueryOption instance) =>
    <String, dynamic>{
      'roleQueryType':
          _$NIMTeamMemberRoleQueryTypeEnumMap[instance.roleQueryType]!,
      'onlyChatBanned': instance.onlyChatBanned,
      'direction': _$NIMQueryDirectionEnumMap[instance.direction],
      'nextToken': instance.nextToken,
      'limit': instance.limit,
    };

const _$NIMTeamMemberRoleQueryTypeEnumMap = {
  NIMTeamMemberRoleQueryType.memberRoleQueryTypeAll: 0,
  NIMTeamMemberRoleQueryType.memberRoleQueryTypeManager: 1,
  NIMTeamMemberRoleQueryType.memberRoleQueryTypeNormal: 2,
};

const _$NIMQueryDirectionEnumMap = {
  NIMQueryDirection.desc: 0,
  NIMQueryDirection.asc: 1,
};

NIMTeamJoinActionInfo _$NIMTeamJoinActionInfoFromJson(
        Map<String, dynamic> json) =>
    NIMTeamJoinActionInfo(
      actionType:
          $enumDecode(_$NIMTeamJoinActionTypeEnumMap, json['actionType']),
      teamId: json['teamId'] as String,
      teamType: $enumDecode(_$NIMTeamTypeEnumMap, json['teamType']),
      operatorAccountId: json['operatorAccountId'] as String?,
      postscript: json['postscript'] as String?,
      timestamp: (json['timestamp'] as num?)?.toInt(),
      actionStatus:
          $enumDecode(_$NIMTeamJoinActionStatusEnumMap, json['actionStatus']),
    );

Map<String, dynamic> _$NIMTeamJoinActionInfoToJson(
        NIMTeamJoinActionInfo instance) =>
    <String, dynamic>{
      'actionType': _$NIMTeamJoinActionTypeEnumMap[instance.actionType]!,
      'teamId': instance.teamId,
      'teamType': _$NIMTeamTypeEnumMap[instance.teamType]!,
      'operatorAccountId': instance.operatorAccountId,
      'postscript': instance.postscript,
      'timestamp': instance.timestamp,
      'actionStatus': _$NIMTeamJoinActionStatusEnumMap[instance.actionStatus]!,
    };

const _$NIMTeamJoinActionTypeEnumMap = {
  NIMTeamJoinActionType.joinActionTypeApplication: 0,
  NIMTeamJoinActionType.joinActionTypeRejectApplication: 1,
  NIMTeamJoinActionType.joinActionTypeInvitation: 2,
  NIMTeamJoinActionType.joinActionTypeRejectInvitation: 3,
};

const _$NIMTeamJoinActionStatusEnumMap = {
  NIMTeamJoinActionStatus.joinActionStatusInit: 0,
  NIMTeamJoinActionStatus.joinActionStatusAgreed: 1,
  NIMTeamJoinActionStatus.joinActionStatusRejected: 2,
  NIMTeamJoinActionStatus.joinActionStatusExpired: 3,
};

NIMTeamJoinActionInfoQueryOption _$NIMTeamJoinActionInfoQueryOptionFromJson(
        Map<String, dynamic> json) =>
    NIMTeamJoinActionInfoQueryOption(
      types: (json['types'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      offset: (json['offset'] as num?)?.toInt(),
      limit: (json['limit'] as num?)?.toInt() ?? 50,
      status: (json['status'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
    );

Map<String, dynamic> _$NIMTeamJoinActionInfoQueryOptionToJson(
        NIMTeamJoinActionInfoQueryOption instance) =>
    <String, dynamic>{
      'types': instance.types,
      'offset': instance.offset,
      'limit': instance.limit,
      'status': instance.status,
    };

NIMTeamMemberSearchOption _$NIMTeamMemberSearchOptionFromJson(
        Map<String, dynamic> json) =>
    NIMTeamMemberSearchOption(
      keyword: json['keyword'] as String,
      teamType: $enumDecode(_$NIMTeamTypeEnumMap, json['teamType']),
      teamId: json['teamId'] as String?,
      nextToken: json['nextToken'] as String,
      order: $enumDecodeNullable(_$NIMSortOrderEnumMap, json['order']),
      limit: (json['limit'] as num?)?.toInt(),
    );

Map<String, dynamic> _$NIMTeamMemberSearchOptionToJson(
        NIMTeamMemberSearchOption instance) =>
    <String, dynamic>{
      'keyword': instance.keyword,
      'teamType': _$NIMTeamTypeEnumMap[instance.teamType]!,
      'teamId': instance.teamId,
      'nextToken': instance.nextToken,
      'order': _$NIMSortOrderEnumMap[instance.order],
      'limit': instance.limit,
    };

const _$NIMSortOrderEnumMap = {
  NIMSortOrder.sortOrderDesc: 0,
  NIMSortOrder.sortOrderAsc: 1,
};
