// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qchat_channel_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QChatCreateChannelParam _$QChatCreateChannelParamFromJson(
        Map<String, dynamic> json) =>
    QChatCreateChannelParam(
      serverId: json['serverId'] as int,
      name: json['name'] as String,
      type: $enumDecode(_$QChatChannelTypeEnumMap, json['type']),
      custom: json['custom'] as String?,
      topic: json['topic'] as String?,
      visitorMode:
          $enumDecodeNullable(_$QChatVisitorModeEnumMap, json['visitorMode']),
      viewMode:
          $enumDecodeNullable(_$QChatChannelModeEnumMap, json['viewMode']),
    )..antiSpamConfig = antiSpamConfigFromJson(json['antiSpamConfig'] as Map?);

Map<String, dynamic> _$QChatCreateChannelParamToJson(
        QChatCreateChannelParam instance) =>
    <String, dynamic>{
      'antiSpamConfig': instance.antiSpamConfig?.toJson(),
      'serverId': instance.serverId,
      'name': instance.name,
      'type': _$QChatChannelTypeEnumMap[instance.type]!,
      'topic': instance.topic,
      'custom': instance.custom,
      'viewMode': _$QChatChannelModeEnumMap[instance.viewMode],
      'visitorMode': _$QChatVisitorModeEnumMap[instance.visitorMode],
    };

const _$QChatChannelTypeEnumMap = {
  QChatChannelType.messageChannel: 'messageChannel',
  QChatChannelType.RTCChannel: 'RTCChannel',
  QChatChannelType.customChannel: 'customChannel',
};

const _$QChatVisitorModeEnumMap = {
  QChatVisitorMode.visible: 'visible',
  QChatVisitorMode.invisible: 'invisible',
  QChatVisitorMode.follow: 'follow',
};

const _$QChatChannelModeEnumMap = {
  QChatChannelMode.public: 'public',
  QChatChannelMode.private: 'private',
};

QChatCreateChannelResult _$QChatCreateChannelResultFromJson(
        Map<String, dynamic> json) =>
    QChatCreateChannelResult(
      qChatChannelFromJson(json['channel'] as Map?),
    );

Map<String, dynamic> _$QChatCreateChannelResultToJson(
        QChatCreateChannelResult instance) =>
    <String, dynamic>{
      'channel': instance.channel?.toJson(),
    };

QChatChannel _$QChatChannelFromJson(Map<String, dynamic> json) => QChatChannel(
      channelId: json['channelId'] as int,
      serverId: json['serverId'] as int,
      viewMode:
          $enumDecodeNullable(_$QChatChannelModeEnumMap, json['viewMode']),
      syncMode:
          $enumDecodeNullable(_$QChatChannelSyncModeEnumMap, json['syncMode']),
      categoryId: json['categoryId'] as int?,
      topic: json['topic'] as String?,
      custom: json['custom'] as String?,
      name: json['name'] as String?,
      type: $enumDecodeNullable(_$QChatChannelTypeEnumMap, json['type']),
      createTime: json['createTime'] as int?,
      reorderWeight: json['reorderWeight'] as int?,
      owner: json['owner'] as String?,
      updateTime: json['updateTime'] as int?,
      visitorMode:
          $enumDecodeNullable(_$QChatVisitorModeEnumMap, json['visitorMode']),
      valid: json['valid'] as bool?,
    );

Map<String, dynamic> _$QChatChannelToJson(QChatChannel instance) =>
    <String, dynamic>{
      'channelId': instance.channelId,
      'serverId': instance.serverId,
      'name': instance.name,
      'topic': instance.topic,
      'custom': instance.custom,
      'type': _$QChatChannelTypeEnumMap[instance.type],
      'valid': instance.valid,
      'createTime': instance.createTime,
      'updateTime': instance.updateTime,
      'owner': instance.owner,
      'viewMode': _$QChatChannelModeEnumMap[instance.viewMode],
      'categoryId': instance.categoryId,
      'syncMode': _$QChatChannelSyncModeEnumMap[instance.syncMode],
      'visitorMode': _$QChatVisitorModeEnumMap[instance.visitorMode],
      'reorderWeight': instance.reorderWeight,
    };

const _$QChatChannelSyncModeEnumMap = {
  QChatChannelSyncMode.none: 'none',
  QChatChannelSyncMode.sync: 'sync',
};

QChatDeleteChannelParam _$QChatDeleteChannelParamFromJson(
        Map<String, dynamic> json) =>
    QChatDeleteChannelParam(
      json['channelId'] as int,
    );

Map<String, dynamic> _$QChatDeleteChannelParamToJson(
        QChatDeleteChannelParam instance) =>
    <String, dynamic>{
      'channelId': instance.channelId,
    };

QChatUpdateChannelResult _$QChatUpdateChannelResultFromJson(
        Map<String, dynamic> json) =>
    QChatUpdateChannelResult(
      qChatChannelFromJson(json['channel'] as Map?),
    );

Map<String, dynamic> _$QChatUpdateChannelResultToJson(
        QChatUpdateChannelResult instance) =>
    <String, dynamic>{
      'channel': instance.channel?.toJson(),
    };

QChatUpdateChannelParam _$QChatUpdateChannelParamFromJson(
        Map<String, dynamic> json) =>
    QChatUpdateChannelParam(
      channelId: json['channelId'] as int,
      custom: json['custom'] as String?,
      topic: json['topic'] as String?,
      viewMode:
          $enumDecodeNullable(_$QChatChannelModeEnumMap, json['viewMode']),
      visitorMode:
          $enumDecodeNullable(_$QChatVisitorModeEnumMap, json['visitorMode']),
      name: json['name'] as String?,
    )..antiSpamConfig = antiSpamConfigFromJson(json['antiSpamConfig'] as Map?);

Map<String, dynamic> _$QChatUpdateChannelParamToJson(
        QChatUpdateChannelParam instance) =>
    <String, dynamic>{
      'antiSpamConfig': instance.antiSpamConfig?.toJson(),
      'channelId': instance.channelId,
      'name': instance.name,
      'topic': instance.topic,
      'custom': instance.custom,
      'viewMode': _$QChatChannelModeEnumMap[instance.viewMode],
      'visitorMode': _$QChatVisitorModeEnumMap[instance.visitorMode],
    };

QChatGetChannelsParam _$QChatGetChannelsParamFromJson(
        Map<String, dynamic> json) =>
    QChatGetChannelsParam(
      (json['channelIds'] as List<dynamic>).map((e) => e as int).toList(),
    );

Map<String, dynamic> _$QChatGetChannelsParamToJson(
        QChatGetChannelsParam instance) =>
    <String, dynamic>{
      'channelIds': instance.channelIds,
    };

QChatGetChannelsResult _$QChatGetChannelsResultFromJson(
        Map<String, dynamic> json) =>
    QChatGetChannelsResult(
      _qChatChannelListFromJson(json['channels'] as List?),
    );

Map<String, dynamic> _$QChatGetChannelsResultToJson(
        QChatGetChannelsResult instance) =>
    <String, dynamic>{
      'channels': instance.channels?.map((e) => e.toJson()).toList(),
    };

QChatGetChannelsByPageParam _$QChatGetChannelsByPageParamFromJson(
        Map<String, dynamic> json) =>
    QChatGetChannelsByPageParam(
      serverId: json['serverId'] as int,
      timeTag: json['timeTag'] as int,
      limit: json['limit'] as int,
    );

Map<String, dynamic> _$QChatGetChannelsByPageParamToJson(
        QChatGetChannelsByPageParam instance) =>
    <String, dynamic>{
      'serverId': instance.serverId,
      'timeTag': instance.timeTag,
      'limit': instance.limit,
    };

QChatGetChannelsByPageResult _$QChatGetChannelsByPageResultFromJson(
        Map<String, dynamic> json) =>
    QChatGetChannelsByPageResult(
      json['hasMore'] as bool?,
      json['nextTimeTag'] as int?,
      channels: _qChatChannelListFromJson(json['channels'] as List?),
    );

Map<String, dynamic> _$QChatGetChannelsByPageResultToJson(
        QChatGetChannelsByPageResult instance) =>
    <String, dynamic>{
      'hasMore': instance.hasMore,
      'nextTimeTag': instance.nextTimeTag,
      'channels': instance.channels?.map((e) => e.toJson()).toList(),
    };

QChatGetChannelMembersByPageParam _$QChatGetChannelMembersByPageParamFromJson(
        Map<String, dynamic> json) =>
    QChatGetChannelMembersByPageParam(
      serverId: json['serverId'] as int,
      channelId: json['channelId'] as int,
      timeTag: json['timeTag'] as int,
      limit: json['limit'] as int?,
    );

Map<String, dynamic> _$QChatGetChannelMembersByPageParamToJson(
        QChatGetChannelMembersByPageParam instance) =>
    <String, dynamic>{
      'serverId': instance.serverId,
      'channelId': instance.channelId,
      'timeTag': instance.timeTag,
      'limit': instance.limit,
    };

QChatGetChannelMembersByPageResult _$QChatGetChannelMembersByPageResultFromJson(
        Map<String, dynamic> json) =>
    QChatGetChannelMembersByPageResult(
      json['hasMore'] as bool?,
      json['nextTimeTag'] as int?,
      members: _qChatServerMemberListFromJson(json['members'] as List?),
    );

Map<String, dynamic> _$QChatGetChannelMembersByPageResultToJson(
        QChatGetChannelMembersByPageResult instance) =>
    <String, dynamic>{
      'hasMore': instance.hasMore,
      'nextTimeTag': instance.nextTimeTag,
      'members': instance.members?.map((e) => e.toJson()).toList(),
    };

QChatGetChannelUnreadInfosParam _$QChatGetChannelUnreadInfosParamFromJson(
        Map<String, dynamic> json) =>
    QChatGetChannelUnreadInfosParam(
      _qChatChannelIdInfoListFromJson(json['channelIdInfos'] as List),
    );

Map<String, dynamic> _$QChatGetChannelUnreadInfosParamToJson(
        QChatGetChannelUnreadInfosParam instance) =>
    <String, dynamic>{
      'channelIdInfos': instance.channelIdInfos.map((e) => e.toJson()).toList(),
    };

QChatChannelIdInfo _$QChatChannelIdInfoFromJson(Map<String, dynamic> json) =>
    QChatChannelIdInfo(
      serverId: json['serverId'] as int,
      channelId: json['channelId'] as int,
    );

Map<String, dynamic> _$QChatChannelIdInfoToJson(QChatChannelIdInfo instance) =>
    <String, dynamic>{
      'serverId': instance.serverId,
      'channelId': instance.channelId,
    };

QChatSubscribeChannelParam _$QChatSubscribeChannelParamFromJson(
        Map<String, dynamic> json) =>
    QChatSubscribeChannelParam(
      type: $enumDecode(_$QChatSubscribeTypeEnumMap, json['type']),
      operateType:
          $enumDecode(_$QChatSubscribeOperateTypeEnumMap, json['operateType']),
      channelIdInfos:
          _qChatChannelIdInfoListFromJson(json['channelIdInfos'] as List),
    );

Map<String, dynamic> _$QChatSubscribeChannelParamToJson(
        QChatSubscribeChannelParam instance) =>
    <String, dynamic>{
      'type': _$QChatSubscribeTypeEnumMap[instance.type]!,
      'operateType': _$QChatSubscribeOperateTypeEnumMap[instance.operateType]!,
      'channelIdInfos': instance.channelIdInfos.map((e) => e.toJson()).toList(),
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

QChatSearchChannelByPageParam _$QChatSearchChannelByPageParamFromJson(
        Map<String, dynamic> json) =>
    QChatSearchChannelByPageParam(
      serverId: json['serverId'] as int?,
      limit: json['limit'] as int?,
      asc: json['asc'] as bool? ?? true,
      endTime: json['endTime'] as int?,
      keyword: json['keyword'] as String,
      startTime: json['startTime'] as int?,
      cursor: json['cursor'] as String?,
      sort: $enumDecodeNullable(
          _$QChatChannelSearchSortEnumEnumMap, json['sort']),
    );

Map<String, dynamic> _$QChatSearchChannelByPageParamToJson(
        QChatSearchChannelByPageParam instance) =>
    <String, dynamic>{
      'keyword': instance.keyword,
      'asc': instance.asc,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'limit': instance.limit,
      'serverId': instance.serverId,
      'sort': _$QChatChannelSearchSortEnumEnumMap[instance.sort],
      'cursor': instance.cursor,
    };

const _$QChatChannelSearchSortEnumEnumMap = {
  QChatChannelSearchSortEnum.ReorderWeight: 'ReorderWeight',
  QChatChannelSearchSortEnum.CreateTime: 'CreateTime',
};

QChatSearchChannelMembersParam _$QChatSearchChannelMembersParamFromJson(
        Map<String, dynamic> json) =>
    QChatSearchChannelMembersParam(
      keyword: json['keyword'] as String,
      limit: json['limit'] as int?,
      serverId: json['serverId'] as int,
      channelId: json['channelId'] as int,
    );

Map<String, dynamic> _$QChatSearchChannelMembersParamToJson(
        QChatSearchChannelMembersParam instance) =>
    <String, dynamic>{
      'serverId': instance.serverId,
      'channelId': instance.channelId,
      'keyword': instance.keyword,
      'limit': instance.limit,
    };

QChatGetChannelUnreadInfosResult _$QChatGetChannelUnreadInfosResultFromJson(
        Map<String, dynamic> json) =>
    QChatGetChannelUnreadInfosResult(
      qChatUnreadInfListFromJson(json['unreadInfoList'] as List?),
    );

Map<String, dynamic> _$QChatGetChannelUnreadInfosResultToJson(
        QChatGetChannelUnreadInfosResult instance) =>
    <String, dynamic>{
      'unreadInfoList':
          instance.unreadInfoList?.map((e) => e.toJson()).toList(),
    };

QChatSubscribeChannelResult _$QChatSubscribeChannelResultFromJson(
        Map<String, dynamic> json) =>
    QChatSubscribeChannelResult(
      unreadInfoList:
          qChatUnreadInfListFromJson(json['unreadInfoList'] as List?),
      failedList: _qChatChannelIdInfoListFromJson(json['failedList'] as List),
    );

Map<String, dynamic> _$QChatSubscribeChannelResultToJson(
        QChatSubscribeChannelResult instance) =>
    <String, dynamic>{
      'unreadInfoList':
          instance.unreadInfoList?.map((e) => e.toJson()).toList(),
      'failedList': instance.failedList?.map((e) => e.toJson()).toList(),
    };

QChatSearchChannelByPageResult _$QChatSearchChannelByPageResultFromJson(
        Map<String, dynamic> json) =>
    QChatSearchChannelByPageResult(
      json['hasMore'] as bool?,
      json['nextTimeTag'] as int?,
      channels: _qChatChannelListFromJson(json['channels'] as List?),
      cursor: json['cursor'] as String?,
    );

Map<String, dynamic> _$QChatSearchChannelByPageResultToJson(
        QChatSearchChannelByPageResult instance) =>
    <String, dynamic>{
      'hasMore': instance.hasMore,
      'nextTimeTag': instance.nextTimeTag,
      'cursor': instance.cursor,
      'channels': instance.channels?.map((e) => e.toJson()).toList(),
    };

QChatSearchChannelMembersResult _$QChatSearchChannelMembersResultFromJson(
        Map<String, dynamic> json) =>
    QChatSearchChannelMembersResult(
      _qChatChannelMemberFromJson(json['members'] as List?),
    );

Map<String, dynamic> _$QChatSearchChannelMembersResultToJson(
        QChatSearchChannelMembersResult instance) =>
    <String, dynamic>{
      'members': instance.members?.map((e) => e.toJson()).toList(),
    };

QChatChannelMember _$QChatChannelMemberFromJson(Map<String, dynamic> json) =>
    QChatChannelMember(
      serverId: json['serverId'] as int?,
      channelId: json['channelId'] as int?,
      updateTime: json['updateTime'] as int?,
      createTime: json['createTime'] as int?,
      accid: json['accid'] as String?,
      avatar: json['avatar'] as String?,
      nick: json['nick'] as String?,
    );

Map<String, dynamic> _$QChatChannelMemberToJson(QChatChannelMember instance) =>
    <String, dynamic>{
      'serverId': instance.serverId,
      'channelId': instance.channelId,
      'avatar': instance.avatar,
      'accid': instance.accid,
      'nick': instance.nick,
      'createTime': instance.createTime,
      'updateTime': instance.updateTime,
    };

QChatUpdateChannelBlackWhiteRolesParam
    _$QChatUpdateChannelBlackWhiteRolesParamFromJson(
            Map<String, dynamic> json) =>
        QChatUpdateChannelBlackWhiteRolesParam(
          channelId: json['channelId'] as int,
          serverId: json['serverId'] as int,
          type: $enumDecode(_$QChatChannelBlackWhiteTypeEnumMap, json['type']),
          roleId: json['roleId'] as int,
          operateType: $enumDecode(
              _$QChatChannelBlackWhiteOperateTypeEnumMap, json['operateType']),
        );

Map<String, dynamic> _$QChatUpdateChannelBlackWhiteRolesParamToJson(
        QChatUpdateChannelBlackWhiteRolesParam instance) =>
    <String, dynamic>{
      'serverId': instance.serverId,
      'channelId': instance.channelId,
      'type': _$QChatChannelBlackWhiteTypeEnumMap[instance.type]!,
      'operateType':
          _$QChatChannelBlackWhiteOperateTypeEnumMap[instance.operateType]!,
      'roleId': instance.roleId,
    };

const _$QChatChannelBlackWhiteTypeEnumMap = {
  QChatChannelBlackWhiteType.white: 'white',
  QChatChannelBlackWhiteType.black: 'black',
};

const _$QChatChannelBlackWhiteOperateTypeEnumMap = {
  QChatChannelBlackWhiteOperateType.add: 'add',
  QChatChannelBlackWhiteOperateType.remove: 'remove',
};

QChatGetChannelBlackWhiteRolesByPageParam
    _$QChatGetChannelBlackWhiteRolesByPageParamFromJson(
            Map<String, dynamic> json) =>
        QChatGetChannelBlackWhiteRolesByPageParam(
          type: $enumDecode(_$QChatChannelBlackWhiteTypeEnumMap, json['type']),
          serverId: json['serverId'] as int,
          channelId: json['channelId'] as int,
          timeTag: json['timeTag'] as int,
          limit: json['limit'] as int?,
        );

Map<String, dynamic> _$QChatGetChannelBlackWhiteRolesByPageParamToJson(
        QChatGetChannelBlackWhiteRolesByPageParam instance) =>
    <String, dynamic>{
      'serverId': instance.serverId,
      'channelId': instance.channelId,
      'type': _$QChatChannelBlackWhiteTypeEnumMap[instance.type]!,
      'timeTag': instance.timeTag,
      'limit': instance.limit,
    };

QChatGetChannelBlackWhiteRolesByPageResult
    _$QChatGetChannelBlackWhiteRolesByPageResultFromJson(
            Map<String, dynamic> json) =>
        QChatGetChannelBlackWhiteRolesByPageResult(
          roleList: serverRoleListFromJsonNullable(json['roleList'] as List?),
        );

Map<String, dynamic> _$QChatGetChannelBlackWhiteRolesByPageResultToJson(
        QChatGetChannelBlackWhiteRolesByPageResult instance) =>
    <String, dynamic>{
      'roleList': instance.roleList?.map((e) => e.toJson()).toList(),
    };

QChatGetExistingChannelBlackWhiteRolesParam
    _$QChatGetExistingChannelBlackWhiteRolesParamFromJson(
            Map<String, dynamic> json) =>
        QChatGetExistingChannelBlackWhiteRolesParam(
          channelId: json['channelId'] as int,
          serverId: json['serverId'] as int,
          type: $enumDecode(_$QChatChannelBlackWhiteTypeEnumMap, json['type']),
          roleIds:
              (json['roleIds'] as List<dynamic>).map((e) => e as int).toList(),
        );

Map<String, dynamic> _$QChatGetExistingChannelBlackWhiteRolesParamToJson(
        QChatGetExistingChannelBlackWhiteRolesParam instance) =>
    <String, dynamic>{
      'serverId': instance.serverId,
      'channelId': instance.channelId,
      'type': _$QChatChannelBlackWhiteTypeEnumMap[instance.type]!,
      'roleIds': instance.roleIds,
    };

QChatGetExistingChannelBlackWhiteRolesResult
    _$QChatGetExistingChannelBlackWhiteRolesResultFromJson(
            Map<String, dynamic> json) =>
        QChatGetExistingChannelBlackWhiteRolesResult(
          roleList: serverRoleListFromJsonNullable(json['roleList'] as List?),
        );

Map<String, dynamic> _$QChatGetExistingChannelBlackWhiteRolesResultToJson(
        QChatGetExistingChannelBlackWhiteRolesResult instance) =>
    <String, dynamic>{
      'roleList': instance.roleList?.map((e) => e.toJson()).toList(),
    };

QChatUpdateChannelBlackWhiteMembersParam
    _$QChatUpdateChannelBlackWhiteMembersParamFromJson(
            Map<String, dynamic> json) =>
        QChatUpdateChannelBlackWhiteMembersParam(
          type: $enumDecode(_$QChatChannelBlackWhiteTypeEnumMap, json['type']),
          serverId: json['serverId'] as int,
          channelId: json['channelId'] as int,
          operateType: $enumDecode(
              _$QChatChannelBlackWhiteOperateTypeEnumMap, json['operateType']),
          toAccids: (json['toAccids'] as List<dynamic>)
              .map((e) => e as String)
              .toList(),
        );

Map<String, dynamic> _$QChatUpdateChannelBlackWhiteMembersParamToJson(
        QChatUpdateChannelBlackWhiteMembersParam instance) =>
    <String, dynamic>{
      'serverId': instance.serverId,
      'channelId': instance.channelId,
      'type': _$QChatChannelBlackWhiteTypeEnumMap[instance.type]!,
      'operateType':
          _$QChatChannelBlackWhiteOperateTypeEnumMap[instance.operateType]!,
      'toAccids': instance.toAccids,
    };

QChatGetChannelBlackWhiteMembersByPageParam
    _$QChatGetChannelBlackWhiteMembersByPageParamFromJson(
            Map<String, dynamic> json) =>
        QChatGetChannelBlackWhiteMembersByPageParam(
          channelId: json['channelId'] as int,
          serverId: json['serverId'] as int,
          type: $enumDecode(_$QChatChannelBlackWhiteTypeEnumMap, json['type']),
          timeTag: json['timeTag'] as int,
          limit: json['limit'] as int?,
        );

Map<String, dynamic> _$QChatGetChannelBlackWhiteMembersByPageParamToJson(
        QChatGetChannelBlackWhiteMembersByPageParam instance) =>
    <String, dynamic>{
      'serverId': instance.serverId,
      'channelId': instance.channelId,
      'type': _$QChatChannelBlackWhiteTypeEnumMap[instance.type]!,
      'timeTag': instance.timeTag,
      'limit': instance.limit,
    };

QChatGetChannelBlackWhiteMembersByPageResult
    _$QChatGetChannelBlackWhiteMembersByPageResultFromJson(
            Map<String, dynamic> json) =>
        QChatGetChannelBlackWhiteMembersByPageResult(
          memberList:
              _qChatServerMemberListFromJson(json['memberList'] as List?),
        );

Map<String, dynamic> _$QChatGetChannelBlackWhiteMembersByPageResultToJson(
        QChatGetChannelBlackWhiteMembersByPageResult instance) =>
    <String, dynamic>{
      'memberList': instance.memberList?.map((e) => e.toJson()).toList(),
    };

QChatGetExistingChannelBlackWhiteMembersParam
    _$QChatGetExistingChannelBlackWhiteMembersParamFromJson(
            Map<String, dynamic> json) =>
        QChatGetExistingChannelBlackWhiteMembersParam(
          type: $enumDecode(_$QChatChannelBlackWhiteTypeEnumMap, json['type']),
          serverId: json['serverId'] as int,
          channelId: json['channelId'] as int,
          accids: (json['accids'] as List<dynamic>)
              .map((e) => e as String)
              .toList(),
        );

Map<String, dynamic> _$QChatGetExistingChannelBlackWhiteMembersParamToJson(
        QChatGetExistingChannelBlackWhiteMembersParam instance) =>
    <String, dynamic>{
      'serverId': instance.serverId,
      'channelId': instance.channelId,
      'type': _$QChatChannelBlackWhiteTypeEnumMap[instance.type]!,
      'accids': instance.accids,
    };

QChatGetExistingChannelBlackWhiteMembersResult
    _$QChatGetExistingChannelBlackWhiteMembersResultFromJson(
            Map<String, dynamic> json) =>
        QChatGetExistingChannelBlackWhiteMembersResult(
          memberList:
              _qChatServerMemberListFromJson(json['memberList'] as List?),
        );

Map<String, dynamic> _$QChatGetExistingChannelBlackWhiteMembersResultToJson(
        QChatGetExistingChannelBlackWhiteMembersResult instance) =>
    <String, dynamic>{
      'memberList': instance.memberList?.map((e) => e.toJson()).toList(),
    };

QChatUpdateUserChannelPushConfigParam
    _$QChatUpdateUserChannelPushConfigParamFromJson(
            Map<String, dynamic> json) =>
        QChatUpdateUserChannelPushConfigParam(
          pushMsgType:
              $enumDecode(_$QChatPushMsgTypeEnumMap, json['pushMsgType']),
          channelId: json['channelId'] as int,
          serverId: json['serverId'] as int,
        );

Map<String, dynamic> _$QChatUpdateUserChannelPushConfigParamToJson(
        QChatUpdateUserChannelPushConfigParam instance) =>
    <String, dynamic>{
      'pushMsgType': _$QChatPushMsgTypeEnumMap[instance.pushMsgType]!,
      'serverId': instance.serverId,
      'channelId': instance.channelId,
    };

const _$QChatPushMsgTypeEnumMap = {
  QChatPushMsgType.all: 'all',
  QChatPushMsgType.highMidLevel: 'highMidLevel',
  QChatPushMsgType.highLevel: 'highLevel',
  QChatPushMsgType.none: 'none',
  QChatPushMsgType.inherit: 'inherit',
};

QChatGetUserChannelPushConfigsParam
    _$QChatGetUserChannelPushConfigsParamFromJson(Map<String, dynamic> json) =>
        QChatGetUserChannelPushConfigsParam(
          (json['channelIdInfos'] as List<dynamic>)
              .map(
                  (e) => QChatChannelIdInfo.fromJson(e as Map<String, dynamic>))
              .toList(),
        );

Map<String, dynamic> _$QChatGetUserChannelPushConfigsParamToJson(
        QChatGetUserChannelPushConfigsParam instance) =>
    <String, dynamic>{
      'channelIdInfos': instance.channelIdInfos.map((e) => e.toJson()).toList(),
    };

QChatGetChannelCategoriesByPageParam
    _$QChatGetChannelCategoriesByPageParamFromJson(Map<String, dynamic> json) =>
        QChatGetChannelCategoriesByPageParam(
          serverId: json['serverId'] as int,
          timeTag: json['timeTag'] as int,
          limit: json['limit'] as int?,
        );

Map<String, dynamic> _$QChatGetChannelCategoriesByPageParamToJson(
        QChatGetChannelCategoriesByPageParam instance) =>
    <String, dynamic>{
      'serverId': instance.serverId,
      'timeTag': instance.timeTag,
      'limit': instance.limit,
    };

QChatGetChannelCategoriesByPageResult
    _$QChatGetChannelCategoriesByPageResultFromJson(
            Map<String, dynamic> json) =>
        QChatGetChannelCategoriesByPageResult(
          categories:
              _qChatChannelCategoryFromJson(json['categories'] as List?),
        );

Map<String, dynamic> _$QChatGetChannelCategoriesByPageResultToJson(
        QChatGetChannelCategoriesByPageResult instance) =>
    <String, dynamic>{
      'categories': instance.categories?.map((e) => e.toJson()).toList(),
    };

QChatSubscribeChannelAsVisitorParam
    _$QChatSubscribeChannelAsVisitorParamFromJson(Map<String, dynamic> json) =>
        QChatSubscribeChannelAsVisitorParam(
          operateType: $enumDecode(
              _$QChatSubscribeOperateTypeEnumMap, json['operateType']),
          channelIdInfos:
              _qChatChannelIdInfoListFromJson(json['channelIdInfos'] as List),
        );

Map<String, dynamic> _$QChatSubscribeChannelAsVisitorParamToJson(
        QChatSubscribeChannelAsVisitorParam instance) =>
    <String, dynamic>{
      'operateType': _$QChatSubscribeOperateTypeEnumMap[instance.operateType]!,
      'channelIdInfos': instance.channelIdInfos.map((e) => e.toJson()).toList(),
    };

QChatSubscribeChannelAsVisitorResult
    _$QChatSubscribeChannelAsVisitorResultFromJson(Map<String, dynamic> json) =>
        QChatSubscribeChannelAsVisitorResult(
          failedList:
              _qChatChannelIdInfoListFromJson(json['failedList'] as List),
        );

Map<String, dynamic> _$QChatSubscribeChannelAsVisitorResultToJson(
        QChatSubscribeChannelAsVisitorResult instance) =>
    <String, dynamic>{
      'failedList': instance.failedList?.map((e) => e.toJson()).toList(),
    };
