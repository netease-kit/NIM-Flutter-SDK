// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chatroom_member.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

V2NIMChatroomMember _$V2NIMChatroomMemberFromJson(Map<String, dynamic> json) =>
    V2NIMChatroomMember(
      roomNick: json['roomNick'] as String?,
      roomAvatar: json['roomAvatar'] as String?,
      enterTime: (json['enterTime'] as num?)?.toInt(),
      roomId: json['roomId'] as String?,
      notifyTargetTags: json['notifyTargetTags'] as String?,
      serverExtension: json['serverExtension'] as String?,
      memberRole: $enumDecodeNullable(
          _$V2NIMChatroomMemberRoleEnumMap, json['memberRole']),
      accountId: json['accountId'] as String?,
      blocked: json['blocked'] as bool?,
      chatBanned: json['chatBanned'] as bool?,
      memberLevel: (json['memberLevel'] as num?)?.toInt(),
      multiEnterInfo:
          V2NIMChatroomEnterInfoListFromJson(json['multiEnterInfo'] as List?),
      isOnline: json['isOnline'] as bool?,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      tempChatBanned: json['tempChatBanned'] as bool?,
      tempChatBannedDuration: (json['tempChatBannedDuration'] as num?)?.toInt(),
      updateTime: (json['updateTime'] as num?)?.toInt(),
      valid: json['valid'] as bool?,
    );

Map<String, dynamic> _$V2NIMChatroomMemberToJson(
        V2NIMChatroomMember instance) =>
    <String, dynamic>{
      'roomId': instance.roomId,
      'accountId': instance.accountId,
      'memberRole': _$V2NIMChatroomMemberRoleEnumMap[instance.memberRole],
      'memberLevel': instance.memberLevel,
      'roomNick': instance.roomNick,
      'roomAvatar': instance.roomAvatar,
      'serverExtension': instance.serverExtension,
      'isOnline': instance.isOnline,
      'blocked': instance.blocked,
      'chatBanned': instance.chatBanned,
      'tempChatBanned': instance.tempChatBanned,
      'tempChatBannedDuration': instance.tempChatBannedDuration,
      'tags': instance.tags,
      'notifyTargetTags': instance.notifyTargetTags,
      'enterTime': instance.enterTime,
      'updateTime': instance.updateTime,
      'valid': instance.valid,
      'multiEnterInfo':
          instance.multiEnterInfo?.map((e) => e.toJson()).toList(),
    };

const _$V2NIMChatroomMemberRoleEnumMap = {
  V2NIMChatroomMemberRole.V2NIM_CHATROOM_MEMBER_ROLE_NORMAL: 0,
  V2NIMChatroomMemberRole.V2NIM_CHATROOM_MEMBER_ROLE_CREATOR: 1,
  V2NIMChatroomMemberRole.V2NIM_CHATROOM_MEMBER_ROLE_MANAGER: 2,
  V2NIMChatroomMemberRole.V2NIM_CHATROOM_MEMBER_ROLE_NORMAL_GUEST: 3,
  V2NIMChatroomMemberRole.V2NIM_CHATROOM_MEMBER_ROLE_ANONYMOUS_GUEST: 4,
  V2NIMChatroomMemberRole.V2NIM_CHATROOM_MEMBER_ROLE_VIRTUAL: 5,
};

V2NIMChatroomEnterInfo _$V2NIMChatroomEnterInfoFromJson(
        Map<String, dynamic> json) =>
    V2NIMChatroomEnterInfo(
      clientType: (json['clientType'] as num?)?.toInt(),
      enterTime: (json['enterTime'] as num?)?.toInt(),
      roomAvatar: json['roomAvatar'] as String?,
      roomNick: json['roomNick'] as String?,
    );

Map<String, dynamic> _$V2NIMChatroomEnterInfoToJson(
        V2NIMChatroomEnterInfo instance) =>
    <String, dynamic>{
      'roomNick': instance.roomNick,
      'roomAvatar': instance.roomAvatar,
      'enterTime': instance.enterTime,
      'clientType': instance.clientType,
    };
