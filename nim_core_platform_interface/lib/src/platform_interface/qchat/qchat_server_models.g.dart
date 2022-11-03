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
