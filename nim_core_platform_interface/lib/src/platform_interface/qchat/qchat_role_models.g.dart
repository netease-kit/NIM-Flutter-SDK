// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qchat_role_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QChatCreateServerRoleParam _$QChatCreateServerRoleParamFromJson(
        Map<String, dynamic> json) =>
    QChatCreateServerRoleParam(
      json['serverId'] as int,
      json['name'] as String,
      $enumDecode(_$QChatRoleTypeEnumMap, json['type']),
      icon: json['icon'] as String?,
      extension: json['extension'] as String?,
      priority: json['priority'] as int?,
    )..antiSpamConfig = antiSpamConfigFromJson(json['antiSpamConfig'] as Map?);

Map<String, dynamic> _$QChatCreateServerRoleParamToJson(
        QChatCreateServerRoleParam instance) =>
    <String, dynamic>{
      'antiSpamConfig': instance.antiSpamConfig?.toJson(),
      'serverId': instance.serverId,
      'name': instance.name,
      'type': _$QChatRoleTypeEnumMap[instance.type]!,
      'icon': instance.icon,
      'extension': instance.extension,
      'priority': instance.priority,
    };

const _$QChatRoleTypeEnumMap = {
  QChatRoleType.everyone: 'everyone',
  QChatRoleType.custom: 'custom',
};

QChatCreateServerRoleResult _$QChatCreateServerRoleResultFromJson(
        Map<String, dynamic> json) =>
    QChatCreateServerRoleResult(
      role: _serverRoleFromJsonNullable(json['role'] as Map?),
    );

Map<String, dynamic> _$QChatCreateServerRoleResultToJson(
        QChatCreateServerRoleResult instance) =>
    <String, dynamic>{
      'role': instance.role?.toJson(),
    };

QChatServerRole _$QChatServerRoleFromJson(Map<String, dynamic> json) =>
    QChatServerRole()
      ..serverId = json['serverId'] as int?
      ..roleId = json['roleId'] as int?
      ..name = json['name'] as String?
      ..icon = json['icon'] as String?
      ..extension = json['extension'] as String?
      ..resourceAuths =
          resourceAuthsFromJsonNullable(json['resourceAuths'] as Map?)
      ..type = $enumDecodeNullable(_$QChatRoleTypeEnumMap, json['type'])
      ..memberCount = json['memberCount'] as int?
      ..priority = json['priority'] as int?
      ..createTime = json['createTime'] as int?
      ..updateTime = json['updateTime'] as int?;

Map<String, dynamic> _$QChatServerRoleToJson(QChatServerRole instance) =>
    <String, dynamic>{
      'serverId': instance.serverId,
      'roleId': instance.roleId,
      'name': instance.name,
      'icon': instance.icon,
      'extension': instance.extension,
      'resourceAuths': instance.resourceAuths?.map((k, e) => MapEntry(
          _$QChatRoleResourceEnumMap[k]!, _$QChatRoleOptionEnumMap[e]!)),
      'type': _$QChatRoleTypeEnumMap[instance.type],
      'memberCount': instance.memberCount,
      'priority': instance.priority,
      'createTime': instance.createTime,
      'updateTime': instance.updateTime,
    };

const _$QChatRoleOptionEnumMap = {
  QChatRoleOption.allow: 'allow',
  QChatRoleOption.deny: 'deny',
  QChatRoleOption.inherit: 'inherit',
};

const _$QChatRoleResourceEnumMap = {
  QChatRoleResource.manageServer: 'manageServer',
  QChatRoleResource.manageChannel: 'manageChannel',
  QChatRoleResource.manageRole: 'manageRole',
  QChatRoleResource.sendMsg: 'sendMsg',
  QChatRoleResource.accountInfoSelf: 'accountInfoSelf',
  QChatRoleResource.inviteServer: 'inviteServer',
  QChatRoleResource.kickServer: 'kickServer',
  QChatRoleResource.accountInfoOther: 'accountInfoOther',
  QChatRoleResource.recallMsg: 'recallMsg',
  QChatRoleResource.deleteMsg: 'deleteMsg',
  QChatRoleResource.remindOther: 'remindOther',
  QChatRoleResource.remindEveryone: 'remindEveryone',
  QChatRoleResource.manageBlackWhiteList: 'manageBlackWhiteList',
  QChatRoleResource.banServerMember: 'banServerMember',
  QChatRoleResource.rtcChannelConnect: 'rtcChannelConnect',
  QChatRoleResource.rtcChannelDisconnectOther: 'rtcChannelDisconnectOther',
  QChatRoleResource.rtcChannelOpenMicrophone: 'rtcChannelOpenMicrophone',
  QChatRoleResource.rtcChannelOpenCamera: 'rtcChannelOpenCamera',
  QChatRoleResource.rtcChannelOpenCloseOtherMicrophone:
      'rtcChannelOpenCloseOtherMicrophone',
  QChatRoleResource.rtcChannelOpenCloseOtherCamera:
      'rtcChannelOpenCloseOtherCamera',
  QChatRoleResource.rtcChannelOpenCloseEveryoneMicrophone:
      'rtcChannelOpenCloseEveryoneMicrophone',
  QChatRoleResource.rtcChannelOpenCloseEveryoneCamera:
      'rtcChannelOpenCloseEveryoneCamera',
  QChatRoleResource.rtcChannelOpenScreenShare: 'rtcChannelOpenScreenShare',
  QChatRoleResource.rtcChannelCloseOtherScreenShare:
      'rtcChannelCloseOtherScreenShare',
  QChatRoleResource.serverApplyHandle: 'serverApplyHandle',
  QChatRoleResource.inviteApplyHistoryQuery: 'inviteApplyHistoryQuery',
  QChatRoleResource.mentionedRole: 'mentionedRole',
};

QChatDeleteServerRoleParam _$QChatDeleteServerRoleParamFromJson(
        Map<String, dynamic> json) =>
    QChatDeleteServerRoleParam(
      json['serverId'] as int,
      json['roleId'] as int,
    );

Map<String, dynamic> _$QChatDeleteServerRoleParamToJson(
        QChatDeleteServerRoleParam instance) =>
    <String, dynamic>{
      'serverId': instance.serverId,
      'roleId': instance.roleId,
    };

QChatUpdateServerRoleParam _$QChatUpdateServerRoleParamFromJson(
        Map<String, dynamic> json) =>
    QChatUpdateServerRoleParam(
      json['serverId'] as int,
      json['roleId'] as int,
      name: json['name'] as String?,
      icon: json['icon'] as String?,
      ext: json['ext'] as String?,
      resourceAuths: (json['resourceAuths'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry($enumDecode(_$QChatRoleResourceEnumMap, k),
            $enumDecode(_$QChatRoleOptionEnumMap, e)),
      ),
      priority: json['priority'] as int?,
    )..antiSpamConfig = antiSpamConfigFromJson(json['antiSpamConfig'] as Map?);

Map<String, dynamic> _$QChatUpdateServerRoleParamToJson(
        QChatUpdateServerRoleParam instance) =>
    <String, dynamic>{
      'antiSpamConfig': instance.antiSpamConfig?.toJson(),
      'serverId': instance.serverId,
      'roleId': instance.roleId,
      'name': instance.name,
      'icon': instance.icon,
      'ext': instance.ext,
      'resourceAuths': instance.resourceAuths?.map((k, e) => MapEntry(
          _$QChatRoleResourceEnumMap[k]!, _$QChatRoleOptionEnumMap[e]!)),
      'priority': instance.priority,
    };

QChatUpdateServerRoleResult _$QChatUpdateServerRoleResultFromJson(
        Map<String, dynamic> json) =>
    QChatUpdateServerRoleResult(
      _serverRoleFromJsonNullable(json['role'] as Map?),
    );

Map<String, dynamic> _$QChatUpdateServerRoleResultToJson(
        QChatUpdateServerRoleResult instance) =>
    <String, dynamic>{
      'role': instance.role?.toJson(),
    };

QChatUpdateServerRolePrioritiesParam
    _$QChatUpdateServerRolePrioritiesParamFromJson(Map<String, dynamic> json) =>
        QChatUpdateServerRolePrioritiesParam(
          json['serverId'] as int,
          (json['roleIdPriorityMap'] as Map<String, dynamic>).map(
            (k, e) => MapEntry(int.parse(k), e as int),
          ),
        );

Map<String, dynamic> _$QChatUpdateServerRolePrioritiesParamToJson(
        QChatUpdateServerRolePrioritiesParam instance) =>
    <String, dynamic>{
      'serverId': instance.serverId,
      'roleIdPriorityMap':
          instance.roleIdPriorityMap.map((k, e) => MapEntry(k.toString(), e)),
    };

QChatUpdateServerRolePrioritiesResult
    _$QChatUpdateServerRolePrioritiesResultFromJson(
            Map<String, dynamic> json) =>
        QChatUpdateServerRolePrioritiesResult(
          json['roleIdPriorityMap'] == null
              ? {}
              : _roleIdPriorityMapFromJsonNullable(
                  json['roleIdPriorityMap'] as Map?),
        );

Map<String, dynamic> _$QChatUpdateServerRolePrioritiesResultToJson(
        QChatUpdateServerRolePrioritiesResult instance) =>
    <String, dynamic>{
      'roleIdPriorityMap':
          instance.roleIdPriorityMap.map((k, e) => MapEntry(k.toString(), e)),
    };

QChatGetServerRolesParam _$QChatGetServerRolesParamFromJson(
        Map<String, dynamic> json) =>
    QChatGetServerRolesParam(
      json['serverId'] as int,
      json['priority'] as int,
      json['limit'] as int,
      channelId: json['channelId'] as int?,
      categoryId: json['categoryId'] as int?,
    );

Map<String, dynamic> _$QChatGetServerRolesParamToJson(
        QChatGetServerRolesParam instance) =>
    <String, dynamic>{
      'serverId': instance.serverId,
      'priority': instance.priority,
      'limit': instance.limit,
      'channelId': instance.channelId,
      'categoryId': instance.categoryId,
    };

QChatGetServerRolesResult _$QChatGetServerRolesResultFromJson(
        Map<String, dynamic> json) =>
    QChatGetServerRolesResult(
      roleList: json['roleList'] == null
          ? []
          : serverRoleListFromJsonNullable(json['roleList'] as List?),
      isMemberSet:
          (json['isMemberSet'] as List<dynamic>?)?.map((e) => e as int).toSet(),
    );

Map<String, dynamic> _$QChatGetServerRolesResultToJson(
        QChatGetServerRolesResult instance) =>
    <String, dynamic>{
      'roleList': instance.roleList.map((e) => e.toJson()).toList(),
      'isMemberSet': instance.isMemberSet.toList(),
    };

QChatAddChannelRoleParam _$QChatAddChannelRoleParamFromJson(
        Map<String, dynamic> json) =>
    QChatAddChannelRoleParam(
      json['serverId'] as int,
      json['serverRoleId'] as int,
      json['channelId'] as int,
    );

Map<String, dynamic> _$QChatAddChannelRoleParamToJson(
        QChatAddChannelRoleParam instance) =>
    <String, dynamic>{
      'serverId': instance.serverId,
      'serverRoleId': instance.serverRoleId,
      'channelId': instance.channelId,
    };

QChatAddChannelRoleResult _$QChatAddChannelRoleResultFromJson(
        Map<String, dynamic> json) =>
    QChatAddChannelRoleResult(
      _channelRoleFromJsonNullable(json['role'] as Map?),
    );

Map<String, dynamic> _$QChatAddChannelRoleResultToJson(
        QChatAddChannelRoleResult instance) =>
    <String, dynamic>{
      'role': instance.role?.toJson(),
    };

QChatChannelRole _$QChatChannelRoleFromJson(Map<String, dynamic> json) =>
    QChatChannelRole()
      ..serverId = json['serverId'] as int?
      ..roleId = json['roleId'] as int?
      ..parentRoleId = json['parentRoleId'] as int?
      ..channelId = json['channelId'] as int?
      ..name = json['name'] as String?
      ..icon = json['icon'] as String?
      ..ext = json['ext'] as String?
      ..resourceAuths =
          resourceAuthsFromJsonNullable(json['resourceAuths'] as Map?)
      ..type = $enumDecodeNullable(_$QChatRoleTypeEnumMap, json['type'])
      ..createTime = json['createTime'] as int?
      ..updateTime = json['updateTime'] as int?;

Map<String, dynamic> _$QChatChannelRoleToJson(QChatChannelRole instance) =>
    <String, dynamic>{
      'serverId': instance.serverId,
      'roleId': instance.roleId,
      'parentRoleId': instance.parentRoleId,
      'channelId': instance.channelId,
      'name': instance.name,
      'icon': instance.icon,
      'ext': instance.ext,
      'resourceAuths': instance.resourceAuths?.map((k, e) => MapEntry(
          _$QChatRoleResourceEnumMap[k]!, _$QChatRoleOptionEnumMap[e]!)),
      'type': _$QChatRoleTypeEnumMap[instance.type],
      'createTime': instance.createTime,
      'updateTime': instance.updateTime,
    };

QChatRemoveChannelRoleParam _$QChatRemoveChannelRoleParamFromJson(
        Map<String, dynamic> json) =>
    QChatRemoveChannelRoleParam(
      json['serverId'] as int,
      json['channelId'] as int,
      json['roleId'] as int,
    );

Map<String, dynamic> _$QChatRemoveChannelRoleParamToJson(
        QChatRemoveChannelRoleParam instance) =>
    <String, dynamic>{
      'serverId': instance.serverId,
      'channelId': instance.channelId,
      'roleId': instance.roleId,
    };

QChatUpdateChannelRoleParam _$QChatUpdateChannelRoleParamFromJson(
        Map<String, dynamic> json) =>
    QChatUpdateChannelRoleParam(
      json['serverId'] as int,
      json['channelId'] as int,
      json['roleId'] as int,
      (json['resourceAuths'] as Map<String, dynamic>).map(
        (k, e) => MapEntry($enumDecode(_$QChatRoleResourceEnumMap, k),
            $enumDecode(_$QChatRoleOptionEnumMap, e)),
      ),
    );

Map<String, dynamic> _$QChatUpdateChannelRoleParamToJson(
        QChatUpdateChannelRoleParam instance) =>
    <String, dynamic>{
      'serverId': instance.serverId,
      'channelId': instance.channelId,
      'roleId': instance.roleId,
      'resourceAuths': instance.resourceAuths.map((k, e) => MapEntry(
          _$QChatRoleResourceEnumMap[k]!, _$QChatRoleOptionEnumMap[e]!)),
    };

QChatUpdateChannelRoleResult _$QChatUpdateChannelRoleResultFromJson(
        Map<String, dynamic> json) =>
    QChatUpdateChannelRoleResult(
      _channelRoleFromJsonNullable(json['role'] as Map?),
    );

Map<String, dynamic> _$QChatUpdateChannelRoleResultToJson(
        QChatUpdateChannelRoleResult instance) =>
    <String, dynamic>{
      'role': instance.role?.toJson(),
    };

QChatGetChannelRolesParam _$QChatGetChannelRolesParamFromJson(
        Map<String, dynamic> json) =>
    QChatGetChannelRolesParam(
      json['serverId'] as int,
      json['channelId'] as int,
      json['timeTag'] as int,
      json['limit'] as int,
    );

Map<String, dynamic> _$QChatGetChannelRolesParamToJson(
        QChatGetChannelRolesParam instance) =>
    <String, dynamic>{
      'serverId': instance.serverId,
      'channelId': instance.channelId,
      'timeTag': instance.timeTag,
      'limit': instance.limit,
    };

QChatGetChannelRolesResult _$QChatGetChannelRolesResultFromJson(
        Map<String, dynamic> json) =>
    QChatGetChannelRolesResult(
      _channelRoleListFromJsonNullable(json['roleList'] as List?),
    );

Map<String, dynamic> _$QChatGetChannelRolesResultToJson(
        QChatGetChannelRolesResult instance) =>
    <String, dynamic>{
      'roleList': instance.roleList?.map((e) => e.toJson()).toList(),
    };

QChatAddMembersToServerRoleParam _$QChatAddMembersToServerRoleParamFromJson(
        Map<String, dynamic> json) =>
    QChatAddMembersToServerRoleParam(
      json['serverId'] as int,
      json['roleId'] as int,
      (json['accids'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$QChatAddMembersToServerRoleParamToJson(
        QChatAddMembersToServerRoleParam instance) =>
    <String, dynamic>{
      'serverId': instance.serverId,
      'roleId': instance.roleId,
      'accids': instance.accids,
    };

QChatAddMembersToServerRoleResult _$QChatAddMembersToServerRoleResultFromJson(
        Map<String, dynamic> json) =>
    QChatAddMembersToServerRoleResult(
      (json['successAccids'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      (json['failedAccids'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$QChatAddMembersToServerRoleResultToJson(
        QChatAddMembersToServerRoleResult instance) =>
    <String, dynamic>{
      'successAccids': instance.successAccids,
      'failedAccids': instance.failedAccids,
    };

QChatRemoveMembersFromServerRoleParam
    _$QChatRemoveMembersFromServerRoleParamFromJson(
            Map<String, dynamic> json) =>
        QChatRemoveMembersFromServerRoleParam(
          json['serverId'] as int,
          json['roleId'] as int,
          (json['accids'] as List<dynamic>).map((e) => e as String).toList(),
        );

Map<String, dynamic> _$QChatRemoveMembersFromServerRoleParamToJson(
        QChatRemoveMembersFromServerRoleParam instance) =>
    <String, dynamic>{
      'serverId': instance.serverId,
      'roleId': instance.roleId,
      'accids': instance.accids,
    };

QChatRemoveMembersFromServerRoleResult
    _$QChatRemoveMembersFromServerRoleResultFromJson(
            Map<String, dynamic> json) =>
        QChatRemoveMembersFromServerRoleResult(
          (json['successAccids'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList(),
          (json['failedAccids'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList(),
        );

Map<String, dynamic> _$QChatRemoveMembersFromServerRoleResultToJson(
        QChatRemoveMembersFromServerRoleResult instance) =>
    <String, dynamic>{
      'successAccids': instance.successAccids,
      'failedAccids': instance.failedAccids,
    };

QChatGetMembersFromServerRoleParam _$QChatGetMembersFromServerRoleParamFromJson(
        Map<String, dynamic> json) =>
    QChatGetMembersFromServerRoleParam(
      json['serverId'] as int,
      json['roleId'] as int,
      json['timeTag'] as int,
      json['limit'] as int,
      accid: json['accid'] as String?,
    );

Map<String, dynamic> _$QChatGetMembersFromServerRoleParamToJson(
        QChatGetMembersFromServerRoleParam instance) =>
    <String, dynamic>{
      'serverId': instance.serverId,
      'roleId': instance.roleId,
      'timeTag': instance.timeTag,
      'limit': instance.limit,
      'accid': instance.accid,
    };

QChatGetMembersFromServerRoleResult
    _$QChatGetMembersFromServerRoleResultFromJson(Map<String, dynamic> json) =>
        QChatGetMembersFromServerRoleResult(
          _serverRoleMemberListFromJsonNullable(
              json['roleMemberList'] as List?),
        );

Map<String, dynamic> _$QChatGetMembersFromServerRoleResultToJson(
        QChatGetMembersFromServerRoleResult instance) =>
    <String, dynamic>{
      'roleMemberList':
          instance.roleMemberList?.map((e) => e.toJson()).toList(),
    };

QChatServerRoleMember _$QChatServerRoleMemberFromJson(
        Map<String, dynamic> json) =>
    QChatServerRoleMember()
      ..serverId = json['serverId'] as int?
      ..roleId = json['roleId'] as int?
      ..accid = json['accid'] as String?
      ..createTime = json['createTime'] as int?
      ..updateTime = json['updateTime'] as int?
      ..nick = json['nick'] as String?
      ..avatar = json['avatar'] as String?
      ..custom = json['custom'] as String?
      ..type = $enumDecodeNullable(_$QChatMemberTypeEnumMap, json['type'])
      ..jointime = json['jointime'] as int?
      ..inviter = json['inviter'] as String?;

Map<String, dynamic> _$QChatServerRoleMemberToJson(
        QChatServerRoleMember instance) =>
    <String, dynamic>{
      'serverId': instance.serverId,
      'roleId': instance.roleId,
      'accid': instance.accid,
      'createTime': instance.createTime,
      'updateTime': instance.updateTime,
      'nick': instance.nick,
      'avatar': instance.avatar,
      'custom': instance.custom,
      'type': _$QChatMemberTypeEnumMap[instance.type],
      'jointime': instance.jointime,
      'inviter': instance.inviter,
    };

const _$QChatMemberTypeEnumMap = {
  QChatMemberType.normal: 'normal',
  QChatMemberType.owner: 'owner',
};

QChatGetServerRolesByAccidParam _$QChatGetServerRolesByAccidParamFromJson(
        Map<String, dynamic> json) =>
    QChatGetServerRolesByAccidParam(
      json['serverId'] as int,
      json['accid'] as String,
      json['timeTag'] as int,
      json['limit'] as int,
    );

Map<String, dynamic> _$QChatGetServerRolesByAccidParamToJson(
        QChatGetServerRolesByAccidParam instance) =>
    <String, dynamic>{
      'serverId': instance.serverId,
      'accid': instance.accid,
      'timeTag': instance.timeTag,
      'limit': instance.limit,
    };

QChatGetServerRolesByAccidResult _$QChatGetServerRolesByAccidResultFromJson(
        Map<String, dynamic> json) =>
    QChatGetServerRolesByAccidResult(
      serverRoleListFromJsonNullable(json['roleList'] as List?),
    );

Map<String, dynamic> _$QChatGetServerRolesByAccidResultToJson(
        QChatGetServerRolesByAccidResult instance) =>
    <String, dynamic>{
      'roleList': instance.roleList?.map((e) => e.toJson()).toList(),
    };

QChatGetExistingServerRolesByAccidsParam
    _$QChatGetExistingServerRolesByAccidsParamFromJson(
            Map<String, dynamic> json) =>
        QChatGetExistingServerRolesByAccidsParam(
          json['serverId'] as int,
          (json['accids'] as List<dynamic>).map((e) => e as String).toList(),
        );

Map<String, dynamic> _$QChatGetExistingServerRolesByAccidsParamToJson(
        QChatGetExistingServerRolesByAccidsParam instance) =>
    <String, dynamic>{
      'serverId': instance.serverId,
      'accids': instance.accids,
    };

QChatGetExistingServerRolesByAccidsResult
    _$QChatGetExistingServerRolesByAccidsResultFromJson(
            Map<String, dynamic> json) =>
        QChatGetExistingServerRolesByAccidsResult(
          _accidServerRolesMapFromJsonNullable(
              json['accidServerRolesMap'] as Map?),
        );

Map<String, dynamic> _$QChatGetExistingServerRolesByAccidsResultToJson(
        QChatGetExistingServerRolesByAccidsResult instance) =>
    <String, dynamic>{
      'accidServerRolesMap': instance.accidServerRolesMap
          ?.map((k, e) => MapEntry(k, e?.map((e) => e.toJson()).toList())),
    };

QChatGetExistingAccidsInServerRoleParam
    _$QChatGetExistingAccidsInServerRoleParamFromJson(
            Map<String, dynamic> json) =>
        QChatGetExistingAccidsInServerRoleParam(
          json['serverId'] as int,
          json['roleId'] as int,
          (json['accids'] as List<dynamic>).map((e) => e as String).toList(),
        );

Map<String, dynamic> _$QChatGetExistingAccidsInServerRoleParamToJson(
        QChatGetExistingAccidsInServerRoleParam instance) =>
    <String, dynamic>{
      'serverId': instance.serverId,
      'roleId': instance.roleId,
      'accids': instance.accids,
    };

QChatGetExistingAccidsInServerRoleResult
    _$QChatGetExistingAccidsInServerRoleResultFromJson(
            Map<String, dynamic> json) =>
        QChatGetExistingAccidsInServerRoleResult(
          (json['accidList'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList(),
        );

Map<String, dynamic> _$QChatGetExistingAccidsInServerRoleResultToJson(
        QChatGetExistingAccidsInServerRoleResult instance) =>
    <String, dynamic>{
      'accidList': instance.accidList,
    };

QChatGetExistingChannelRolesByServerRoleIdsParam
    _$QChatGetExistingChannelRolesByServerRoleIdsParamFromJson(
            Map<String, dynamic> json) =>
        QChatGetExistingChannelRolesByServerRoleIdsParam(
          json['serverId'] as int,
          json['channelId'] as int,
          (json['roleIds'] as List<dynamic>).map((e) => e as int).toList(),
        );

Map<String, dynamic> _$QChatGetExistingChannelRolesByServerRoleIdsParamToJson(
        QChatGetExistingChannelRolesByServerRoleIdsParam instance) =>
    <String, dynamic>{
      'serverId': instance.serverId,
      'channelId': instance.channelId,
      'roleIds': instance.roleIds,
    };

QChatGetExistingChannelRolesByServerRoleIdsResult
    _$QChatGetExistingChannelRolesByServerRoleIdsResultFromJson(
            Map<String, dynamic> json) =>
        QChatGetExistingChannelRolesByServerRoleIdsResult(
          _channelRoleListFromJsonNullable(json['roleList'] as List?),
        );

Map<String, dynamic> _$QChatGetExistingChannelRolesByServerRoleIdsResultToJson(
        QChatGetExistingChannelRolesByServerRoleIdsResult instance) =>
    <String, dynamic>{
      'roleList': instance.roleList?.map((e) => e.toJson()).toList(),
    };

QChatGetExistingAccidsOfMemberRolesParam
    _$QChatGetExistingAccidsOfMemberRolesParamFromJson(
            Map<String, dynamic> json) =>
        QChatGetExistingAccidsOfMemberRolesParam(
          json['serverId'] as int,
          json['channelId'] as int,
          (json['accids'] as List<dynamic>).map((e) => e as String).toList(),
        );

Map<String, dynamic> _$QChatGetExistingAccidsOfMemberRolesParamToJson(
        QChatGetExistingAccidsOfMemberRolesParam instance) =>
    <String, dynamic>{
      'serverId': instance.serverId,
      'channelId': instance.channelId,
      'accids': instance.accids,
    };

QChatGetExistingAccidsOfMemberRolesResult
    _$QChatGetExistingAccidsOfMemberRolesResultFromJson(
            Map<String, dynamic> json) =>
        QChatGetExistingAccidsOfMemberRolesResult(
          (json['accidList'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList(),
        );

Map<String, dynamic> _$QChatGetExistingAccidsOfMemberRolesResultToJson(
        QChatGetExistingAccidsOfMemberRolesResult instance) =>
    <String, dynamic>{
      'accidList': instance.accidList,
    };

QChatAddMemberRoleParam _$QChatAddMemberRoleParamFromJson(
        Map<String, dynamic> json) =>
    QChatAddMemberRoleParam(
      json['serverId'] as int,
      json['channelId'] as int,
      json['accid'] as String,
    );

Map<String, dynamic> _$QChatAddMemberRoleParamToJson(
        QChatAddMemberRoleParam instance) =>
    <String, dynamic>{
      'serverId': instance.serverId,
      'channelId': instance.channelId,
      'accid': instance.accid,
    };

QChatAddMemberRoleResult _$QChatAddMemberRoleResultFromJson(
        Map<String, dynamic> json) =>
    QChatAddMemberRoleResult(
      _roleFromJsonNullable(json['role'] as Map?),
    );

Map<String, dynamic> _$QChatAddMemberRoleResultToJson(
        QChatAddMemberRoleResult instance) =>
    <String, dynamic>{
      'role': instance.role?.toJson(),
    };

QChatMemberRole _$QChatMemberRoleFromJson(Map<String, dynamic> json) =>
    QChatMemberRole()
      ..serverId = json['serverId'] as int?
      ..id = json['id'] as int?
      ..accid = json['accid'] as String?
      ..channelId = json['channelId'] as int?
      ..resourceAuths =
          resourceAuthsFromJsonNullable(json['resourceAuths'] as Map?)
      ..createTime = json['createTime'] as int?
      ..updateTime = json['updateTime'] as int?
      ..nick = json['nick'] as String?
      ..avatar = json['avatar'] as String?
      ..custom = json['custom'] as String?
      ..type = $enumDecodeNullable(_$QChatMemberTypeEnumMap, json['type'])
      ..joinTime = json['joinTime'] as int?
      ..inviter = json['inviter'] as String?;

Map<String, dynamic> _$QChatMemberRoleToJson(QChatMemberRole instance) =>
    <String, dynamic>{
      'serverId': instance.serverId,
      'id': instance.id,
      'accid': instance.accid,
      'channelId': instance.channelId,
      'resourceAuths': instance.resourceAuths?.map((k, e) => MapEntry(
          _$QChatRoleResourceEnumMap[k]!, _$QChatRoleOptionEnumMap[e]!)),
      'createTime': instance.createTime,
      'updateTime': instance.updateTime,
      'nick': instance.nick,
      'avatar': instance.avatar,
      'custom': instance.custom,
      'type': _$QChatMemberTypeEnumMap[instance.type],
      'joinTime': instance.joinTime,
      'inviter': instance.inviter,
    };

QChatRemoveMemberRoleParam _$QChatRemoveMemberRoleParamFromJson(
        Map<String, dynamic> json) =>
    QChatRemoveMemberRoleParam(
      json['serverId'] as int,
      json['channelId'] as int,
      json['accid'] as String,
    );

Map<String, dynamic> _$QChatRemoveMemberRoleParamToJson(
        QChatRemoveMemberRoleParam instance) =>
    <String, dynamic>{
      'serverId': instance.serverId,
      'channelId': instance.channelId,
      'accid': instance.accid,
    };

QChatUpdateMemberRoleParam _$QChatUpdateMemberRoleParamFromJson(
        Map<String, dynamic> json) =>
    QChatUpdateMemberRoleParam(
      json['serverId'] as int,
      json['channelId'] as int,
      json['accid'] as String,
      (json['resourceAuths'] as Map<String, dynamic>).map(
        (k, e) => MapEntry($enumDecode(_$QChatRoleResourceEnumMap, k),
            $enumDecode(_$QChatRoleOptionEnumMap, e)),
      ),
    );

Map<String, dynamic> _$QChatUpdateMemberRoleParamToJson(
        QChatUpdateMemberRoleParam instance) =>
    <String, dynamic>{
      'serverId': instance.serverId,
      'channelId': instance.channelId,
      'accid': instance.accid,
      'resourceAuths': instance.resourceAuths.map((k, e) => MapEntry(
          _$QChatRoleResourceEnumMap[k]!, _$QChatRoleOptionEnumMap[e]!)),
    };

QChatUpdateMemberRoleResult _$QChatUpdateMemberRoleResultFromJson(
        Map<String, dynamic> json) =>
    QChatUpdateMemberRoleResult(
      _roleFromJsonNullable(json['role'] as Map?),
    );

Map<String, dynamic> _$QChatUpdateMemberRoleResultToJson(
        QChatUpdateMemberRoleResult instance) =>
    <String, dynamic>{
      'role': instance.role?.toJson(),
    };

QChatGetMemberRolesParam _$QChatGetMemberRolesParamFromJson(
        Map<String, dynamic> json) =>
    QChatGetMemberRolesParam(
      json['serverId'] as int,
      json['channelId'] as int,
      json['timeTag'] as int,
      json['limit'] as int,
    );

Map<String, dynamic> _$QChatGetMemberRolesParamToJson(
        QChatGetMemberRolesParam instance) =>
    <String, dynamic>{
      'serverId': instance.serverId,
      'channelId': instance.channelId,
      'timeTag': instance.timeTag,
      'limit': instance.limit,
    };

QChatGetMemberRolesResult _$QChatGetMemberRolesResultFromJson(
        Map<String, dynamic> json) =>
    QChatGetMemberRolesResult(
      _memberRoleListFromJsonNullable(json['roleList'] as List?),
    );

Map<String, dynamic> _$QChatGetMemberRolesResultToJson(
        QChatGetMemberRolesResult instance) =>
    <String, dynamic>{
      'roleList': instance.roleList?.map((e) => e.toJson()).toList(),
    };

QChatCheckPermissionParam _$QChatCheckPermissionParamFromJson(
        Map<String, dynamic> json) =>
    QChatCheckPermissionParam(
      json['serverId'] as int,
      $enumDecode(_$QChatRoleResourceEnumMap, json['permission']),
      json['channelId'] as int?,
    );

Map<String, dynamic> _$QChatCheckPermissionParamToJson(
        QChatCheckPermissionParam instance) =>
    <String, dynamic>{
      'serverId': instance.serverId,
      'channelId': instance.channelId,
      'permission': _$QChatRoleResourceEnumMap[instance.permission]!,
    };

QChatCheckPermissionResult _$QChatCheckPermissionResultFromJson(
        Map<String, dynamic> json) =>
    QChatCheckPermissionResult(
      json['hasPermission'] as bool?,
    );

Map<String, dynamic> _$QChatCheckPermissionResultToJson(
        QChatCheckPermissionResult instance) =>
    <String, dynamic>{
      'hasPermission': instance.hasPermission,
    };

QChatCheckPermissionsParam _$QChatCheckPermissionsParamFromJson(
        Map<String, dynamic> json) =>
    QChatCheckPermissionsParam(
      json['serverId'] as int,
      (json['permissions'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$QChatRoleResourceEnumMap, e))
          .toList(),
      json['channelId'] as int?,
    );

Map<String, dynamic> _$QChatCheckPermissionsParamToJson(
        QChatCheckPermissionsParam instance) =>
    <String, dynamic>{
      'serverId': instance.serverId,
      'channelId': instance.channelId,
      'permissions': instance.permissions
          ?.map((e) => _$QChatRoleResourceEnumMap[e]!)
          .toList(),
    };

QChatCheckPermissionsResult _$QChatCheckPermissionsResultFromJson(
        Map<String, dynamic> json) =>
    QChatCheckPermissionsResult(
      resourceAuthsFromJsonNullable(json['permissions'] as Map?),
    );

Map<String, dynamic> _$QChatCheckPermissionsResultToJson(
        QChatCheckPermissionsResult instance) =>
    <String, dynamic>{
      'permissions': instance.permissions?.map((k, e) => MapEntry(
          _$QChatRoleResourceEnumMap[k]!, _$QChatRoleOptionEnumMap[e]!)),
    };
