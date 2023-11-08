// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qchat_server_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QChatCreateServerParam _$QChatCreateServerParamFromJson(
        Map<String, dynamic> json) =>
    QChatCreateServerParam(
      json['name'] as String,
    )
      ..antiSpamConfig = antiSpamConfigFromJson(json['antiSpamConfig'] as Map?)
      ..icon = json['icon'] as String?
      ..custom = json['custom'] as String?
      ..inviteMode = $enumDecode(_$QChatInviteModeEnumMap, json['inviteMode'])
      ..applyJoinMode =
          $enumDecode(_$QChatApplyJoinModeEnumMap, json['applyJoinMode'])
      ..searchType = json['searchType'] as int?
      ..searchEnable = json['searchEnable'] as bool?;

Map<String, dynamic> _$QChatCreateServerParamToJson(
        QChatCreateServerParam instance) =>
    <String, dynamic>{
      'antiSpamConfig': instance.antiSpamConfig?.toJson(),
      'name': instance.name,
      'icon': instance.icon,
      'custom': instance.custom,
      'inviteMode': _$QChatInviteModeEnumMap[instance.inviteMode]!,
      'applyJoinMode': _$QChatApplyJoinModeEnumMap[instance.applyJoinMode]!,
      'searchType': instance.searchType,
      'searchEnable': instance.searchEnable,
    };

const _$QChatInviteModeEnumMap = {
  QChatInviteMode.agreeNeed: 'agreeNeed',
  QChatInviteMode.agreeNeedNot: 'agreeNeedNot',
};

const _$QChatApplyJoinModeEnumMap = {
  QChatApplyJoinMode.agreeNeedNot: 'agreeNeedNot',
  QChatApplyJoinMode.agreeNeed: 'agreeNeed',
};

QChatCreateServerResult _$QChatCreateServerResultFromJson(
        Map<String, dynamic> json) =>
    QChatCreateServerResult(
      serverFromJsonNullable(json['server'] as Map?),
    );

Map<String, dynamic> _$QChatCreateServerResultToJson(
        QChatCreateServerResult instance) =>
    <String, dynamic>{
      'server': instance.server?.toJson(),
    };

QChatServer _$QChatServerFromJson(Map<String, dynamic> json) => QChatServer()
  ..serverId = json['serverId'] as int?
  ..name = json['name'] as String?
  ..icon = json['icon'] as String?
  ..custom = json['custom'] as String?
  ..owner = json['owner'] as String?
  ..memberNumber = json['memberNumber'] as int?
  ..inviteMode =
      $enumDecodeNullable(_$QChatInviteModeEnumMap, json['inviteMode'])
  ..applyMode =
      $enumDecodeNullable(_$QChatApplyJoinModeEnumMap, json['applyMode'])
  ..valid = json['valid'] as bool?
  ..createTime = json['createTime'] as int?
  ..updateTime = json['updateTime'] as int?
  ..channelNum = json['channelNum'] as int?
  ..channelCategoryNum = json['channelCategoryNum'] as int?
  ..searchType = json['searchType'] as int?
  ..searchEnable = json['searchEnable'] as bool?
  ..reorderWeight = json['reorderWeight'] as int?;

Map<String, dynamic> _$QChatServerToJson(QChatServer instance) =>
    <String, dynamic>{
      'serverId': instance.serverId,
      'name': instance.name,
      'icon': instance.icon,
      'custom': instance.custom,
      'owner': instance.owner,
      'memberNumber': instance.memberNumber,
      'inviteMode': _$QChatInviteModeEnumMap[instance.inviteMode],
      'applyMode': _$QChatApplyJoinModeEnumMap[instance.applyMode],
      'valid': instance.valid,
      'createTime': instance.createTime,
      'updateTime': instance.updateTime,
      'channelNum': instance.channelNum,
      'channelCategoryNum': instance.channelCategoryNum,
      'searchType': instance.searchType,
      'searchEnable': instance.searchEnable,
      'reorderWeight': instance.reorderWeight,
    };

QChatGetServersParam _$QChatGetServersParamFromJson(
        Map<String, dynamic> json) =>
    QChatGetServersParam(
      (json['serverIds'] as List<dynamic>).map((e) => e as int).toList(),
    );

Map<String, dynamic> _$QChatGetServersParamToJson(
        QChatGetServersParam instance) =>
    <String, dynamic>{
      'serverIds': instance.serverIds,
    };

QChatGetServersResult _$QChatGetServersResultFromJson(
        Map<String, dynamic> json) =>
    QChatGetServersResult(
      _serverListFromJsonNullable(json['servers'] as List?),
    );

Map<String, dynamic> _$QChatGetServersResultToJson(
        QChatGetServersResult instance) =>
    <String, dynamic>{
      'servers': instance.servers,
    };

QChatGetServersByPageParam _$QChatGetServersByPageParamFromJson(
        Map<String, dynamic> json) =>
    QChatGetServersByPageParam(
      json['timeTag'] as int,
      json['limit'] as int,
    );

Map<String, dynamic> _$QChatGetServersByPageParamToJson(
        QChatGetServersByPageParam instance) =>
    <String, dynamic>{
      'timeTag': instance.timeTag,
      'limit': instance.limit,
    };

QChatGetServersByPageResult _$QChatGetServersByPageResultFromJson(
        Map<String, dynamic> json) =>
    QChatGetServersByPageResult(
      json['hasMore'] as bool?,
      json['nextTimeTag'] as int?,
      _serverListFromJsonNullable(json['servers'] as List?),
    );

Map<String, dynamic> _$QChatGetServersByPageResultToJson(
        QChatGetServersByPageResult instance) =>
    <String, dynamic>{
      'hasMore': instance.hasMore,
      'nextTimeTag': instance.nextTimeTag,
      'servers': instance.servers?.map((e) => e.toJson()).toList(),
    };

QChatUpdateServerParam _$QChatUpdateServerParamFromJson(
        Map<String, dynamic> json) =>
    QChatUpdateServerParam(
      json['serverId'] as int,
    )
      ..antiSpamConfig = antiSpamConfigFromJson(json['antiSpamConfig'] as Map?)
      ..name = json['name'] as String?
      ..icon = json['icon'] as String?
      ..custom = json['custom'] as String?
      ..inviteMode =
          $enumDecodeNullable(_$QChatInviteModeEnumMap, json['inviteMode'])
      ..applyMode =
          $enumDecodeNullable(_$QChatApplyJoinModeEnumMap, json['applyMode'])
      ..searchType = json['searchType'] as int?
      ..searchEnable = json['searchEnable'] as bool?;

Map<String, dynamic> _$QChatUpdateServerParamToJson(
        QChatUpdateServerParam instance) =>
    <String, dynamic>{
      'antiSpamConfig': instance.antiSpamConfig?.toJson(),
      'serverId': instance.serverId,
      'name': instance.name,
      'icon': instance.icon,
      'custom': instance.custom,
      'inviteMode': _$QChatInviteModeEnumMap[instance.inviteMode],
      'applyMode': _$QChatApplyJoinModeEnumMap[instance.applyMode],
      'searchType': instance.searchType,
      'searchEnable': instance.searchEnable,
    };

QChatUpdateServerResult _$QChatUpdateServerResultFromJson(
        Map<String, dynamic> json) =>
    QChatUpdateServerResult(
      serverFromJsonNullable(json['server'] as Map?),
    );

Map<String, dynamic> _$QChatUpdateServerResultToJson(
        QChatUpdateServerResult instance) =>
    <String, dynamic>{
      'server': instance.server?.toJson(),
    };

QChatDeleteServerParam _$QChatDeleteServerParamFromJson(
        Map<String, dynamic> json) =>
    QChatDeleteServerParam(
      json['serverId'] as int,
    );

Map<String, dynamic> _$QChatDeleteServerParamToJson(
        QChatDeleteServerParam instance) =>
    <String, dynamic>{
      'serverId': instance.serverId,
    };

QChatSubscribeServerParam _$QChatSubscribeServerParamFromJson(
        Map<String, dynamic> json) =>
    QChatSubscribeServerParam(
      $enumDecode(_$QChatSubscribeTypeEnumMap, json['type']),
      $enumDecode(_$QChatSubscribeOperateTypeEnumMap, json['operateType']),
      (json['serverIds'] as List<dynamic>).map((e) => e as int).toList(),
    );

Map<String, dynamic> _$QChatSubscribeServerParamToJson(
        QChatSubscribeServerParam instance) =>
    <String, dynamic>{
      'type': _$QChatSubscribeTypeEnumMap[instance.type]!,
      'operateType': _$QChatSubscribeOperateTypeEnumMap[instance.operateType]!,
      'serverIds': instance.serverIds,
    };

const _$QChatSubscribeTypeEnumMap = {
  QChatSubscribeType.channelMsg: 'channelMsg',
  QChatSubscribeType.channelMsgUnreadCount: 'channelMsgUnreadCount',
  QChatSubscribeType.channelMsgUnreadStatus: 'channelMsgUnreadStatus',
  QChatSubscribeType.serverMsg: 'serverMsg',
  QChatSubscribeType.channelMsgTyping: 'channelMsgTyping',
};

const _$QChatSubscribeOperateTypeEnumMap = {
  QChatSubscribeOperateType.sub: 'sub',
  QChatSubscribeOperateType.unSub: 'unSub',
};

QChatSubscribeServerResult _$QChatSubscribeServerResultFromJson(
        Map<String, dynamic> json) =>
    QChatSubscribeServerResult(
      (json['failedList'] as List<dynamic>?)?.map((e) => e as int).toList(),
    );

Map<String, dynamic> _$QChatSubscribeServerResultToJson(
        QChatSubscribeServerResult instance) =>
    <String, dynamic>{
      'failedList': instance.failedList,
    };

QChatInviteServerMembersParam _$QChatInviteServerMembersParamFromJson(
        Map<String, dynamic> json) =>
    QChatInviteServerMembersParam(
      json['serverId'] as int,
      (json['accids'] as List<dynamic>).map((e) => e as String).toList(),
    )
      ..ttl = json['ttl'] as int?
      ..postscript = json['postscript'] as String;

Map<String, dynamic> _$QChatInviteServerMembersParamToJson(
        QChatInviteServerMembersParam instance) =>
    <String, dynamic>{
      'ttl': instance.ttl,
      'serverId': instance.serverId,
      'accids': instance.accids,
      'postscript': instance.postscript,
    };

QChatInviteServerMembersResult _$QChatInviteServerMembersResultFromJson(
        Map<String, dynamic> json) =>
    QChatInviteServerMembersResult(
      failedAccids: (json['failedAccids'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      bannedAccids: (json['bannedAccids'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      inviteServerMemberInfo: _applyServerMemberInfoFromJson(
          json['inviteServerMemberInfo'] as Map?),
    );

Map<String, dynamic> _$QChatInviteServerMembersResultToJson(
        QChatInviteServerMembersResult instance) =>
    <String, dynamic>{
      'inviteServerMemberInfo': instance.inviteServerMemberInfo?.toJson(),
      'failedAccids': instance.failedAccids,
      'bannedAccids': instance.bannedAccids,
    };

QChatAcceptServerInviteParam _$QChatAcceptServerInviteParamFromJson(
        Map<String, dynamic> json) =>
    QChatAcceptServerInviteParam(
      json['serverId'] as int,
      json['accid'] as String,
      json['requestId'] as int,
    );

Map<String, dynamic> _$QChatAcceptServerInviteParamToJson(
        QChatAcceptServerInviteParam instance) =>
    <String, dynamic>{
      'requestId': instance.requestId,
      'serverId': instance.serverId,
      'accid': instance.accid,
    };

QChatRejectServerInviteParam _$QChatRejectServerInviteParamFromJson(
        Map<String, dynamic> json) =>
    QChatRejectServerInviteParam(
      json['serverId'] as int,
      json['accid'] as String,
      json['requestId'] as int,
    )..postscript = json['postscript'] as String;

Map<String, dynamic> _$QChatRejectServerInviteParamToJson(
        QChatRejectServerInviteParam instance) =>
    <String, dynamic>{
      'requestId': instance.requestId,
      'serverId': instance.serverId,
      'accid': instance.accid,
      'postscript': instance.postscript,
    };

QChatGenerateInviteCodeParam _$QChatGenerateInviteCodeParamFromJson(
        Map<String, dynamic> json) =>
    QChatGenerateInviteCodeParam(
      json['serverId'] as int,
    )..ttl = json['ttl'] as int?;

Map<String, dynamic> _$QChatGenerateInviteCodeParamToJson(
        QChatGenerateInviteCodeParam instance) =>
    <String, dynamic>{
      'serverId': instance.serverId,
      'ttl': instance.ttl,
    };

QChatGenerateInviteCodeResult _$QChatGenerateInviteCodeResultFromJson(
        Map<String, dynamic> json) =>
    QChatGenerateInviteCodeResult(
      json['serverId'] as int?,
      json['requestId'] as int?,
      json['inviteCode'] as String?,
      json['expireTime'] as int?,
    );

Map<String, dynamic> _$QChatGenerateInviteCodeResultToJson(
        QChatGenerateInviteCodeResult instance) =>
    <String, dynamic>{
      'serverId': instance.serverId,
      'requestId': instance.requestId,
      'inviteCode': instance.inviteCode,
      'expireTime': instance.expireTime,
    };

QChatJoinByInviteCodeParam _$QChatJoinByInviteCodeParamFromJson(
        Map<String, dynamic> json) =>
    QChatJoinByInviteCodeParam(
      json['serverId'] as int?,
      json['inviteCode'] as String?,
    )..postscript = json['postscript'] as String?;

Map<String, dynamic> _$QChatJoinByInviteCodeParamToJson(
        QChatJoinByInviteCodeParam instance) =>
    <String, dynamic>{
      'serverId': instance.serverId,
      'inviteCode': instance.inviteCode,
      'postscript': instance.postscript,
    };

QChatApplyServerJoinParam _$QChatApplyServerJoinParamFromJson(
        Map<String, dynamic> json) =>
    QChatApplyServerJoinParam(
      json['serverId'] as int,
    )
      ..ttl = json['ttl'] as int?
      ..postscript = json['postscript'] as String;

Map<String, dynamic> _$QChatApplyServerJoinParamToJson(
        QChatApplyServerJoinParam instance) =>
    <String, dynamic>{
      'ttl': instance.ttl,
      'serverId': instance.serverId,
      'postscript': instance.postscript,
    };

QChatApplyServerJoinResult _$QChatApplyServerJoinResultFromJson(
        Map<String, dynamic> json) =>
    QChatApplyServerJoinResult(
      _applyServerMemberInfoFromJson(json['applyServerMemberInfo'] as Map?),
    );

Map<String, dynamic> _$QChatApplyServerJoinResultToJson(
        QChatApplyServerJoinResult instance) =>
    <String, dynamic>{
      'applyServerMemberInfo': instance.applyServerMemberInfo?.toJson(),
    };

QChatInviteApplyServerMemberInfo _$QChatInviteApplyServerMemberInfoFromJson(
        Map<String, dynamic> json) =>
    QChatInviteApplyServerMemberInfo(
      json['requestId'] as int?,
      json['expireTime'] as int?,
    );

Map<String, dynamic> _$QChatInviteApplyServerMemberInfoToJson(
        QChatInviteApplyServerMemberInfo instance) =>
    <String, dynamic>{
      'requestId': instance.requestId,
      'expireTime': instance.expireTime,
    };

QChatAcceptServerApplyParam _$QChatAcceptServerApplyParamFromJson(
        Map<String, dynamic> json) =>
    QChatAcceptServerApplyParam(
      json['serverId'] as int,
      json['accid'] as String,
      json['requestId'] as int,
    );

Map<String, dynamic> _$QChatAcceptServerApplyParamToJson(
        QChatAcceptServerApplyParam instance) =>
    <String, dynamic>{
      'requestId': instance.requestId,
      'serverId': instance.serverId,
      'accid': instance.accid,
    };

QChatRejectServerApplyParam _$QChatRejectServerApplyParamFromJson(
        Map<String, dynamic> json) =>
    QChatRejectServerApplyParam(
      json['serverId'] as int,
      json['accid'] as String,
      json['requestId'] as int,
    )..postscript = json['postscript'] as String;

Map<String, dynamic> _$QChatRejectServerApplyParamToJson(
        QChatRejectServerApplyParam instance) =>
    <String, dynamic>{
      'requestId': instance.requestId,
      'serverId': instance.serverId,
      'accid': instance.accid,
      'postscript': instance.postscript,
    };

QChatKickServerMembersParam _$QChatKickServerMembersParamFromJson(
        Map<String, dynamic> json) =>
    QChatKickServerMembersParam(
      json['serverId'] as int,
      (json['accids'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$QChatKickServerMembersParamToJson(
        QChatKickServerMembersParam instance) =>
    <String, dynamic>{
      'serverId': instance.serverId,
      'accids': instance.accids,
    };

QChatLeaveServerParam _$QChatLeaveServerParamFromJson(
        Map<String, dynamic> json) =>
    QChatLeaveServerParam(
      json['serverId'] as int,
    );

Map<String, dynamic> _$QChatLeaveServerParamToJson(
        QChatLeaveServerParam instance) =>
    <String, dynamic>{
      'serverId': instance.serverId,
    };

QChatUpdateMyMemberInfoParam _$QChatUpdateMyMemberInfoParamFromJson(
        Map<String, dynamic> json) =>
    QChatUpdateMyMemberInfoParam(
      json['serverId'] as int,
    )
      ..antiSpamConfig = antiSpamConfigFromJson(json['antiSpamConfig'] as Map?)
      ..nick = json['nick'] as String?
      ..avatar = json['avatar'] as String?
      ..custom = json['custom'] as String?;

Map<String, dynamic> _$QChatUpdateMyMemberInfoParamToJson(
        QChatUpdateMyMemberInfoParam instance) =>
    <String, dynamic>{
      'antiSpamConfig': instance.antiSpamConfig?.toJson(),
      'serverId': instance.serverId,
      'nick': instance.nick,
      'avatar': instance.avatar,
      'custom': instance.custom,
    };

QChatUpdateMyMemberInfoResult _$QChatUpdateMyMemberInfoResultFromJson(
        Map<String, dynamic> json) =>
    QChatUpdateMyMemberInfoResult(
      memberFromJson(json['member'] as Map?),
    );

Map<String, dynamic> _$QChatUpdateMyMemberInfoResultToJson(
        QChatUpdateMyMemberInfoResult instance) =>
    <String, dynamic>{
      'member': instance.member?.toJson(),
    };

QChatGetServerMembersParam _$QChatGetServerMembersParamFromJson(
        Map<String, dynamic> json) =>
    QChatGetServerMembersParam(
      _serverIdAccidPairListFromMap(json['serverIdAccidPairList'] as List),
    );

Map<String, dynamic> _$QChatGetServerMembersParamToJson(
        QChatGetServerMembersParam instance) =>
    <String, dynamic>{
      'serverIdAccidPairList':
          instance.serverIdAccidPairList.map((e) => e.toJson()).toList(),
    };

QChatGetServerMembersResult _$QChatGetServerMembersResultFromJson(
        Map<String, dynamic> json) =>
    QChatGetServerMembersResult(
      _memberListFromJson(json['serverMembers'] as List?),
    );

Map<String, dynamic> _$QChatGetServerMembersResultToJson(
        QChatGetServerMembersResult instance) =>
    <String, dynamic>{
      'serverMembers': instance.serverMembers?.map((e) => e.toJson()).toList(),
    };

QChatServerMember _$QChatServerMemberFromJson(Map<String, dynamic> json) =>
    QChatServerMember(
      valid: json['valid'] as bool? ?? false,
    )
      ..serverId = json['serverId'] as int?
      ..accid = json['accid'] as String?
      ..nick = json['nick'] as String?
      ..avatar = json['avatar'] as String?
      ..custom = json['custom'] as String?
      ..type = $enumDecodeNullable(_$QChatMemberTypeEnumMap, json['type'])
      ..joinTime = json['joinTime'] as int?
      ..inviter = json['inviter'] as String?
      ..createTime = json['createTime'] as int?
      ..updateTime = json['updateTime'] as int?;

Map<String, dynamic> _$QChatServerMemberToJson(QChatServerMember instance) =>
    <String, dynamic>{
      'serverId': instance.serverId,
      'accid': instance.accid,
      'nick': instance.nick,
      'avatar': instance.avatar,
      'custom': instance.custom,
      'type': _$QChatMemberTypeEnumMap[instance.type],
      'joinTime': instance.joinTime,
      'inviter': instance.inviter,
      'valid': instance.valid,
      'createTime': instance.createTime,
      'updateTime': instance.updateTime,
    };

const _$QChatMemberTypeEnumMap = {
  QChatMemberType.normal: 'normal',
  QChatMemberType.owner: 'owner',
};

QChatGetServerMembersByPageParam _$QChatGetServerMembersByPageParamFromJson(
        Map<String, dynamic> json) =>
    QChatGetServerMembersByPageParam(
      json['serverId'] as int,
      json['timeTag'] as int,
      json['limit'] as int,
    );

Map<String, dynamic> _$QChatGetServerMembersByPageParamToJson(
        QChatGetServerMembersByPageParam instance) =>
    <String, dynamic>{
      'serverId': instance.serverId,
      'timeTag': instance.timeTag,
      'limit': instance.limit,
    };

QChatGetServerMembersByPageResult _$QChatGetServerMembersByPageResultFromJson(
        Map<String, dynamic> json) =>
    QChatGetServerMembersByPageResult(
      json['hasMore'] as bool?,
      json['nextTimeTag'] as int?,
      _memberListFromJson(json['serverMembers'] as List?),
    );

Map<String, dynamic> _$QChatGetServerMembersByPageResultToJson(
        QChatGetServerMembersByPageResult instance) =>
    <String, dynamic>{
      'hasMore': instance.hasMore,
      'nextTimeTag': instance.nextTimeTag,
      'serverMembers': instance.serverMembers?.map((e) => e.toJson()).toList(),
    };

QChatSearchServerByPageParam _$QChatSearchServerByPageParamFromJson(
        Map<String, dynamic> json) =>
    QChatSearchServerByPageParam(
      json['keyword'] as String,
      json['asc'] as bool?,
      $enumDecode(_$QChatSearchServerTypeEnumEnumMap, json['searchType']),
      startTime: json['startTime'] as int?,
      endTime: json['endTime'] as int?,
      limit: json['limit'] as int?,
      serverTypes: (json['serverTypes'] as List<dynamic>?)
          ?.map((e) => e as int?)
          .toList(),
      sort:
          $enumDecodeNullable(_$QChatServerSearchSortEnumEnumMap, json['sort']),
      cursor: json['cursor'] as String?,
    );

Map<String, dynamic> _$QChatSearchServerByPageParamToJson(
        QChatSearchServerByPageParam instance) =>
    <String, dynamic>{
      'keyword': instance.keyword,
      'asc': instance.asc,
      'searchType': _$QChatSearchServerTypeEnumEnumMap[instance.searchType]!,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'limit': instance.limit,
      'serverTypes': instance.serverTypes,
      'sort': _$QChatServerSearchSortEnumEnumMap[instance.sort],
      'cursor': instance.cursor,
    };

const _$QChatSearchServerTypeEnumEnumMap = {
  QChatSearchServerTypeEnum.undefined: 'undefined',
  QChatSearchServerTypeEnum.square: 'square',
  QChatSearchServerTypeEnum.personal: 'personal',
};

const _$QChatServerSearchSortEnumEnumMap = {
  QChatServerSearchSortEnum.reorderWeight: 'reorderWeight',
  QChatServerSearchSortEnum.createTime: 'createTime',
  QChatServerSearchSortEnum.totalMember: 'totalMember',
};

QChatSearchServerByPageResult _$QChatSearchServerByPageResultFromJson(
        Map<String, dynamic> json) =>
    QChatSearchServerByPageResult(
      _serverListFromJsonNullable(json['servers'] as List?),
      json['hasMore'] as bool?,
      json['nextTimeTag'] as int?,
      json['cursor'] as String?,
    );

Map<String, dynamic> _$QChatSearchServerByPageResultToJson(
        QChatSearchServerByPageResult instance) =>
    <String, dynamic>{
      'hasMore': instance.hasMore,
      'nextTimeTag': instance.nextTimeTag,
      'cursor': instance.cursor,
      'servers': instance.servers?.map((e) => e.toJson()).toList(),
    };

PairIntWithString _$PairIntWithStringFromJson(Map<String, dynamic> json) =>
    PairIntWithString(
      json['first'] as int?,
      json['second'] as String?,
    );

Map<String, dynamic> _$PairIntWithStringToJson(PairIntWithString instance) =>
    <String, dynamic>{
      'first': instance.first,
      'second': instance.second,
    };

QChatUpdateServerMemberInfoParam _$QChatUpdateServerMemberInfoParamFromJson(
        Map<String, dynamic> json) =>
    QChatUpdateServerMemberInfoParam(
      json['serverId'] as int,
      json['accid'] as String,
      nick: json['nick'] as String?,
      avatar: json['avatar'] as String?,
    )..antiSpamConfig = antiSpamConfigFromJson(json['antiSpamConfig'] as Map?);

Map<String, dynamic> _$QChatUpdateServerMemberInfoParamToJson(
        QChatUpdateServerMemberInfoParam instance) =>
    <String, dynamic>{
      'antiSpamConfig': instance.antiSpamConfig?.toJson(),
      'serverId': instance.serverId,
      'accid': instance.accid,
      'nick': instance.nick,
      'avatar': instance.avatar,
    };

QChatUpdateServerMemberInfoResult _$QChatUpdateServerMemberInfoResultFromJson(
        Map<String, dynamic> json) =>
    QChatUpdateServerMemberInfoResult(
      memberFromJson(json['member'] as Map?),
    );

Map<String, dynamic> _$QChatUpdateServerMemberInfoResultToJson(
        QChatUpdateServerMemberInfoResult instance) =>
    <String, dynamic>{
      'member': instance.member?.toJson(),
    };

QChatBanServerMemberParam _$QChatBanServerMemberParamFromJson(
        Map<String, dynamic> json) =>
    QChatBanServerMemberParam(
      json['serverId'] as int?,
      json['targetAccid'] as String?,
      json['customExt'] as String?,
    );

Map<String, dynamic> _$QChatBanServerMemberParamToJson(
        QChatBanServerMemberParam instance) =>
    <String, dynamic>{
      'serverId': instance.serverId,
      'targetAccid': instance.targetAccid,
      'customExt': instance.customExt,
    };

QChatUnbanServerMemberParam _$QChatUnbanServerMemberParamFromJson(
        Map<String, dynamic> json) =>
    QChatUnbanServerMemberParam(
      json['serverId'] as int?,
      json['targetAccid'] as String?,
      json['customExt'] as String?,
    );

Map<String, dynamic> _$QChatUnbanServerMemberParamToJson(
        QChatUnbanServerMemberParam instance) =>
    <String, dynamic>{
      'serverId': instance.serverId,
      'targetAccid': instance.targetAccid,
      'customExt': instance.customExt,
    };

QChatGetBannedServerMembersByPageParam
    _$QChatGetBannedServerMembersByPageParamFromJson(
            Map<String, dynamic> json) =>
        QChatGetBannedServerMembersByPageParam(
          json['serverId'] as int,
          json['timeTag'] as int,
          json['limit'] as int?,
        );

Map<String, dynamic> _$QChatGetBannedServerMembersByPageParamToJson(
        QChatGetBannedServerMembersByPageParam instance) =>
    <String, dynamic>{
      'serverId': instance.serverId,
      'timeTag': instance.timeTag,
      'limit': instance.limit,
    };

QChatGetBannedServerMembersByPageResult
    _$QChatGetBannedServerMembersByPageResultFromJson(
            Map<String, dynamic> json) =>
        QChatGetBannedServerMembersByPageResult(
          json['hasMore'] as bool?,
          json['nextTimeTag'] as int?,
          _serverMemberBanInfoListNullable(
              json['serverMemberBanInfoList'] as List?),
        );

Map<String, dynamic> _$QChatGetBannedServerMembersByPageResultToJson(
        QChatGetBannedServerMembersByPageResult instance) =>
    <String, dynamic>{
      'hasMore': instance.hasMore,
      'nextTimeTag': instance.nextTimeTag,
      'serverMemberBanInfoList':
          instance.serverMemberBanInfoList?.map((e) => e.toJson()).toList(),
    };

QChatBannedServerMember _$QChatBannedServerMemberFromJson(
        Map<String, dynamic> json) =>
    QChatBannedServerMember()
      ..serverId = json['serverId'] as int?
      ..accid = json['accid'] as String?
      ..custom = json['custom'] as String?
      ..banTime = json['banTime'] as int?
      ..isValid = json['isValid'] as bool?
      ..createTime = json['createTime'] as int?
      ..updateTime = json['updateTime'] as int?;

Map<String, dynamic> _$QChatBannedServerMemberToJson(
        QChatBannedServerMember instance) =>
    <String, dynamic>{
      'serverId': instance.serverId,
      'accid': instance.accid,
      'custom': instance.custom,
      'banTime': instance.banTime,
      'isValid': instance.isValid,
      'createTime': instance.createTime,
      'updateTime': instance.updateTime,
    };

QChatUpdateUserServerPushConfigParam
    _$QChatUpdateUserServerPushConfigParamFromJson(Map<String, dynamic> json) =>
        QChatUpdateUserServerPushConfigParam(
          json['serverId'] as int,
          $enumDecode(_$QChatPushMsgTypeEnumMap, json['pushMsgType']),
        );

Map<String, dynamic> _$QChatUpdateUserServerPushConfigParamToJson(
        QChatUpdateUserServerPushConfigParam instance) =>
    <String, dynamic>{
      'pushMsgType': _$QChatPushMsgTypeEnumMap[instance.pushMsgType]!,
      'serverId': instance.serverId,
    };

const _$QChatPushMsgTypeEnumMap = {
  QChatPushMsgType.all: 'all',
  QChatPushMsgType.highMidLevel: 'highMidLevel',
  QChatPushMsgType.highLevel: 'highLevel',
  QChatPushMsgType.none: 'none',
  QChatPushMsgType.inherit: 'inherit',
};

QChatGetUserServerPushConfigsParam _$QChatGetUserServerPushConfigsParamFromJson(
        Map<String, dynamic> json) =>
    QChatGetUserServerPushConfigsParam(
      (json['serverIdList'] as List<dynamic>).map((e) => e as int).toList(),
    );

Map<String, dynamic> _$QChatGetUserServerPushConfigsParamToJson(
        QChatGetUserServerPushConfigsParam instance) =>
    <String, dynamic>{
      'serverIdList': instance.serverIdList,
    };

QChatGetUserPushConfigsResult _$QChatGetUserPushConfigsResultFromJson(
        Map<String, dynamic> json) =>
    QChatGetUserPushConfigsResult(
      _userPushConfigsNullable(json['userPushConfigs'] as List?),
    );

Map<String, dynamic> _$QChatGetUserPushConfigsResultToJson(
        QChatGetUserPushConfigsResult instance) =>
    <String, dynamic>{
      'userPushConfigs':
          instance.userPushConfigs?.map((e) => e.toJson()).toList(),
    };

QChatUserPushConfig _$QChatUserPushConfigFromJson(Map<String, dynamic> json) =>
    QChatUserPushConfig()
      ..serverId = json['serverId'] as int?
      ..channelId = json['channelId'] as int?
      ..channelCategoryId = json['channelCategoryId'] as int?
      ..dimension =
          $enumDecodeNullable(_$QChatDimensionEnumMap, json['dimension'])
      ..pushMsgType =
          $enumDecodeNullable(_$QChatPushMsgTypeEnumMap, json['pushMsgType']);

Map<String, dynamic> _$QChatUserPushConfigToJson(
        QChatUserPushConfig instance) =>
    <String, dynamic>{
      'serverId': instance.serverId,
      'channelId': instance.channelId,
      'channelCategoryId': instance.channelCategoryId,
      'dimension': _$QChatDimensionEnumMap[instance.dimension],
      'pushMsgType': _$QChatPushMsgTypeEnumMap[instance.pushMsgType],
    };

const _$QChatDimensionEnumMap = {
  QChatDimension.channel: 'channel',
  QChatDimension.server: 'server',
  QChatDimension.channelCategory: 'channelCategory',
};

QChatSearchServerMemberByPageParam _$QChatSearchServerMemberByPageParamFromJson(
        Map<String, dynamic> json) =>
    QChatSearchServerMemberByPageParam(
      json['keyword'] as String,
      json['serverId'] as int,
      json['limit'] as int?,
    );

Map<String, dynamic> _$QChatSearchServerMemberByPageParamToJson(
        QChatSearchServerMemberByPageParam instance) =>
    <String, dynamic>{
      'keyword': instance.keyword,
      'serverId': instance.serverId,
      'limit': instance.limit,
    };

QChatSearchServerMemberByPageResult
    _$QChatSearchServerMemberByPageResultFromJson(Map<String, dynamic> json) =>
        QChatSearchServerMemberByPageResult(
          _memberListFromJson(json['members'] as List?),
        );

Map<String, dynamic> _$QChatSearchServerMemberByPageResultToJson(
        QChatSearchServerMemberByPageResult instance) =>
    <String, dynamic>{
      'members': instance.members?.map((e) => e.toJson()).toList(),
    };

QChatGetInviteApplyRecordOfServerParam
    _$QChatGetInviteApplyRecordOfServerParamFromJson(
            Map<String, dynamic> json) =>
        QChatGetInviteApplyRecordOfServerParam(
          json['serverId'] as int,
          fromTime: json['fromTime'] as int?,
          toTime: json['toTime'] as int?,
          reverse: json['reverse'] as bool?,
          limit: json['limit'] as int?,
          excludeRecordId: json['excludeRecordId'] as int?,
        );

Map<String, dynamic> _$QChatGetInviteApplyRecordOfServerParamToJson(
        QChatGetInviteApplyRecordOfServerParam instance) =>
    <String, dynamic>{
      'serverId': instance.serverId,
      'fromTime': instance.fromTime,
      'toTime': instance.toTime,
      'reverse': instance.reverse,
      'limit': instance.limit,
      'excludeRecordId': instance.excludeRecordId,
    };

QChatGetInviteApplyRecordOfServerResult
    _$QChatGetInviteApplyRecordOfServerResultFromJson(
            Map<String, dynamic> json) =>
        QChatGetInviteApplyRecordOfServerResult(
          _recordsNullable(json['records'] as List?),
        );

Map<String, dynamic> _$QChatGetInviteApplyRecordOfServerResultToJson(
        QChatGetInviteApplyRecordOfServerResult instance) =>
    <String, dynamic>{
      'records': instance.records?.map((e) => e.toJson()).toList(),
    };

QChatInviteApplyRecord _$QChatInviteApplyRecordFromJson(
        Map<String, dynamic> json) =>
    QChatInviteApplyRecord()
      ..accid = json['accid'] as String?
      ..type =
          $enumDecodeNullable(_$QChatInviteApplyRecordTypeEnumMap, json['type'])
      ..serverId = json['serverId'] as int?
      ..status = $enumDecodeNullable(
          _$QChatInviteApplyRecordStatusEnumMap, json['status'])
      ..requestId = json['requestId'] as int?
      ..createTime = json['createTime'] as int?
      ..updateTime = json['updateTime'] as int?
      ..expireTime = json['expireTime'] as int?
      ..data = _applyRecordDataNullable(json['data'] as Map?)
      ..recordId = json['recordId'] as int?;

Map<String, dynamic> _$QChatInviteApplyRecordToJson(
        QChatInviteApplyRecord instance) =>
    <String, dynamic>{
      'accid': instance.accid,
      'type': _$QChatInviteApplyRecordTypeEnumMap[instance.type],
      'serverId': instance.serverId,
      'status': _$QChatInviteApplyRecordStatusEnumMap[instance.status],
      'requestId': instance.requestId,
      'createTime': instance.createTime,
      'updateTime': instance.updateTime,
      'expireTime': instance.expireTime,
      'data': instance.data?.toJson(),
      'recordId': instance.recordId,
    };

const _$QChatInviteApplyRecordTypeEnumMap = {
  QChatInviteApplyRecordType.apply: 'apply',
  QChatInviteApplyRecordType.invite: 'invite',
  QChatInviteApplyRecordType.beInvited: 'beInvited',
  QChatInviteApplyRecordType.generateInviteCode: 'generateInviteCode',
  QChatInviteApplyRecordType.joinByInviteCode: 'joinByInviteCode',
};

const _$QChatInviteApplyRecordStatusEnumMap = {
  QChatInviteApplyRecordStatus.initial: 'initial',
  QChatInviteApplyRecordStatus.accept: 'accept',
  QChatInviteApplyRecordStatus.reject: 'reject',
  QChatInviteApplyRecordStatus.acceptByOther: 'acceptByOther',
  QChatInviteApplyRecordStatus.rejectByOther: 'rejectByOther',
  QChatInviteApplyRecordStatus.autoJoin: 'autoJoin',
  QChatInviteApplyRecordStatus.expired: 'expired',
};

QChatInviteApplyRecordData _$QChatInviteApplyRecordDataFromJson(
        Map<String, dynamic> json) =>
    QChatInviteApplyRecordData()
      ..applyPostscript = json['applyPostscript'] as String?
      ..updateAccid = json['updateAccid'] as String?
      ..updatePostscript = json['updatePostscript'] as String?
      ..invitePostscript = json['invitePostscript'] as String?
      ..inviteCode = json['inviteCode'] as String?
      ..invitedUserCount = json['invitedUserCount'] as int?
      ..invitedUsers = _invitedUsersNullable(json['invitedUsers'] as List?);

Map<String, dynamic> _$QChatInviteApplyRecordDataToJson(
        QChatInviteApplyRecordData instance) =>
    <String, dynamic>{
      'applyPostscript': instance.applyPostscript,
      'updateAccid': instance.updateAccid,
      'updatePostscript': instance.updatePostscript,
      'invitePostscript': instance.invitePostscript,
      'inviteCode': instance.inviteCode,
      'invitedUserCount': instance.invitedUserCount,
      'invitedUsers': instance.invitedUsers?.map((e) => e.toJson()).toList(),
    };

QChatInvitedUserInfo _$QChatInvitedUserInfoFromJson(
        Map<String, dynamic> json) =>
    QChatInvitedUserInfo()
      ..accid = json['accid'] as String?
      ..status = $enumDecodeNullable(
          _$QChatInviteApplyRecordStatusEnumMap, json['status'])
      ..updatePostscript = json['updatePostscript'] as String?
      ..updateTime = json['updateTime'] as int?;

Map<String, dynamic> _$QChatInvitedUserInfoToJson(
        QChatInvitedUserInfo instance) =>
    <String, dynamic>{
      'accid': instance.accid,
      'status': _$QChatInviteApplyRecordStatusEnumMap[instance.status],
      'updatePostscript': instance.updatePostscript,
      'updateTime': instance.updateTime,
    };

QChatGetInviteApplyRecordOfSelfParam
    _$QChatGetInviteApplyRecordOfSelfParamFromJson(Map<String, dynamic> json) =>
        QChatGetInviteApplyRecordOfSelfParam(
          fromTime: json['fromTime'] as int?,
          toTime: json['toTime'] as int?,
          reverse: json['reverse'] as bool?,
          limit: json['limit'] as int?,
          excludeRecordId: json['excludeRecordId'] as int?,
        );

Map<String, dynamic> _$QChatGetInviteApplyRecordOfSelfParamToJson(
        QChatGetInviteApplyRecordOfSelfParam instance) =>
    <String, dynamic>{
      'fromTime': instance.fromTime,
      'toTime': instance.toTime,
      'reverse': instance.reverse,
      'limit': instance.limit,
      'excludeRecordId': instance.excludeRecordId,
    };

QChatGetInviteApplyRecordOfSelfResult
    _$QChatGetInviteApplyRecordOfSelfResultFromJson(
            Map<String, dynamic> json) =>
        QChatGetInviteApplyRecordOfSelfResult(
          _recordsNullable(json['records'] as List?),
        );

Map<String, dynamic> _$QChatGetInviteApplyRecordOfSelfResultToJson(
        QChatGetInviteApplyRecordOfSelfResult instance) =>
    <String, dynamic>{
      'records': instance.records?.map((e) => e.toJson()).toList(),
    };

QChatServerMarkReadParam _$QChatServerMarkReadParamFromJson(
        Map<String, dynamic> json) =>
    QChatServerMarkReadParam(
      (json['serverIds'] as List<dynamic>).map((e) => e as int).toList(),
    );

Map<String, dynamic> _$QChatServerMarkReadParamToJson(
        QChatServerMarkReadParam instance) =>
    <String, dynamic>{
      'serverIds': instance.serverIds,
    };

QChatServerMarkReadResult _$QChatServerMarkReadResultFromJson(
        Map<String, dynamic> json) =>
    QChatServerMarkReadResult(
      (json['successServerIds'] as List<dynamic>?)
          ?.map((e) => e as int)
          .toList(),
      (json['failedServerIds'] as List<dynamic>?)
          ?.map((e) => e as int)
          .toList(),
      json['timestamp'] as int?,
    );

Map<String, dynamic> _$QChatServerMarkReadResultToJson(
        QChatServerMarkReadResult instance) =>
    <String, dynamic>{
      'successServerIds': instance.successServerIds,
      'failedServerIds': instance.failedServerIds,
      'timestamp': instance.timestamp,
    };

QChatSubscribeAllChannelParam _$QChatSubscribeAllChannelParamFromJson(
        Map<String, dynamic> json) =>
    QChatSubscribeAllChannelParam(
      $enumDecode(_$QChatSubscribeTypeEnumMap, json['type']),
      (json['serverIds'] as List<dynamic>).map((e) => e as int).toList(),
    );

Map<String, dynamic> _$QChatSubscribeAllChannelParamToJson(
        QChatSubscribeAllChannelParam instance) =>
    <String, dynamic>{
      'type': _$QChatSubscribeTypeEnumMap[instance.type]!,
      'serverIds': instance.serverIds,
    };

QChatSubscribeAllChannelResult _$QChatSubscribeAllChannelResultFromJson(
        Map<String, dynamic> json) =>
    QChatSubscribeAllChannelResult(
      _unreadInfoListNullable(json['unreadInfoList'] as List?),
      _failedListNullable(json['failedList'] as List?),
    );

Map<String, dynamic> _$QChatSubscribeAllChannelResultToJson(
        QChatSubscribeAllChannelResult instance) =>
    <String, dynamic>{
      'unreadInfoList':
          instance.unreadInfoList?.map((e) => e.toJson()).toList(),
      'failedList': instance.failedList,
    };

QChatSubscribeServerAsVisitorParam _$QChatSubscribeServerAsVisitorParamFromJson(
        Map<String, dynamic> json) =>
    QChatSubscribeServerAsVisitorParam(
      $enumDecode(_$QChatSubscribeOperateTypeEnumMap, json['operateType']),
      (json['serverIds'] as List<dynamic>).map((e) => e as int).toList(),
    );

Map<String, dynamic> _$QChatSubscribeServerAsVisitorParamToJson(
        QChatSubscribeServerAsVisitorParam instance) =>
    <String, dynamic>{
      'operateType': _$QChatSubscribeOperateTypeEnumMap[instance.operateType]!,
      'serverIds': instance.serverIds,
    };

QChatSubscribeServerAsVisitorResult
    _$QChatSubscribeServerAsVisitorResultFromJson(Map<String, dynamic> json) =>
        QChatSubscribeServerAsVisitorResult(
          _failedListNullable(json['failedList'] as List?),
        );

Map<String, dynamic> _$QChatSubscribeServerAsVisitorResultToJson(
        QChatSubscribeServerAsVisitorResult instance) =>
    <String, dynamic>{
      'failedList': instance.failedList,
    };

QChatEnterServerAsVisitorParam _$QChatEnterServerAsVisitorParamFromJson(
        Map<String, dynamic> json) =>
    QChatEnterServerAsVisitorParam(
      (json['serverIds'] as List<dynamic>).map((e) => e as int).toList(),
    );

Map<String, dynamic> _$QChatEnterServerAsVisitorParamToJson(
        QChatEnterServerAsVisitorParam instance) =>
    <String, dynamic>{
      'serverIds': instance.serverIds,
    };

QChatEnterServerAsVisitorResult _$QChatEnterServerAsVisitorResultFromJson(
        Map<String, dynamic> json) =>
    QChatEnterServerAsVisitorResult(
      _failedListNullable(json['failedList'] as List?),
    );

Map<String, dynamic> _$QChatEnterServerAsVisitorResultToJson(
        QChatEnterServerAsVisitorResult instance) =>
    <String, dynamic>{
      'failedList': instance.failedList,
    };

QChatLeaveServerAsVisitorParam _$QChatLeaveServerAsVisitorParamFromJson(
        Map<String, dynamic> json) =>
    QChatLeaveServerAsVisitorParam(
      (json['serverIds'] as List<dynamic>).map((e) => e as int).toList(),
    );

Map<String, dynamic> _$QChatLeaveServerAsVisitorParamToJson(
        QChatLeaveServerAsVisitorParam instance) =>
    <String, dynamic>{
      'serverIds': instance.serverIds,
    };

QChatLeaveServerAsVisitorResult _$QChatLeaveServerAsVisitorResultFromJson(
        Map<String, dynamic> json) =>
    QChatLeaveServerAsVisitorResult(
      _failedListNullable(json['failedList'] as List?),
    );

Map<String, dynamic> _$QChatLeaveServerAsVisitorResultToJson(
        QChatLeaveServerAsVisitorResult instance) =>
    <String, dynamic>{
      'failedList': instance.failedList,
    };
