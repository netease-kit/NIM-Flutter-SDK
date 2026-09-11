// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:json_annotation/json_annotation.dart';
part 'chatroom_member.g.dart';

@JsonSerializable(explicitToJson: true)
class V2NIMChatroomMember {
  /// 聊天室id
  String? roomId;

  /// 成员账号id
  String? accountId;

  /// 成员角色类型
  V2NIMChatroomMemberRole? memberRole;

  /// 成员等级
  int? memberLevel;

  /// 进入聊天室后显示的昵称
  String? roomNick;

  /// 进入聊天室后显示的头像
  String? roomAvatar;

  /// 成员扩展字段
  String? serverExtension;

  /// 是否在线，普通成员， 创建者，管理员有在线离线状态，其他的成员只有在线状态
  bool? isOnline;

  /// 是否在黑名单列表中
  bool? blocked;

  /// 是否禁言
  bool? chatBanned;

  /// 是否临时禁言
  bool? tempChatBanned;

  /// 临时禁言的时长,单位：秒
  int? tempChatBannedDuration;

  /// 登录标签，json array 格式， eg:[''tag1", "tag2"]
  List<String>? tags;

  /// 登录登出通知标签
  String? notifyTargetTags;

  /// 用户进入聊天室的时间点
  int? enterTime;

  /// 普通成员， 创建者，管理员的记录更新时间
  int? updateTime;

  /// 是否有效
  bool? valid;

  /// 多端登录信息
  @JsonKey(fromJson: V2NIMChatroomEnterInfoListFromJson)
  List<V2NIMChatroomEnterInfo>? multiEnterInfo;

  V2NIMChatroomMember(
      {this.roomNick,
      this.roomAvatar,
      this.enterTime,
      this.roomId,
      this.notifyTargetTags,
      this.serverExtension,
      this.memberRole,
      this.accountId,
      this.blocked,
      this.chatBanned,
      this.memberLevel,
      this.multiEnterInfo,
      this.isOnline,
      this.tags,
      this.tempChatBanned,
      this.tempChatBannedDuration,
      this.updateTime,
      this.valid});

  factory V2NIMChatroomMember.fromJson(Map<String, dynamic> json) =>
      _$V2NIMChatroomMemberFromJson(json);

  Map<String, dynamic> toJson() => _$V2NIMChatroomMemberToJson(this);
}

List<V2NIMChatroomEnterInfo>? V2NIMChatroomEnterInfoListFromJson(
    List<dynamic>? enterInfos) {
  return enterInfos
      ?.map((e) =>
          V2NIMChatroomEnterInfo.fromJson((e as Map).cast<String, dynamic>()))
      .toList();
}

V2NIMChatroomMember? v2NIMChatroomMemberFromJson(Map? map) {
  if (map != null) {
    return V2NIMChatroomMember.fromJson(map.cast<String, dynamic>());
  }
  return null;
}

///聊天室成员角色类型
enum V2NIMChatroomMemberRole {
  /// 普通成员
  @JsonValue(0)
  V2NIM_CHATROOM_MEMBER_ROLE_NORMAL,

  /// 创建者
  @JsonValue(1)
  V2NIM_CHATROOM_MEMBER_ROLE_CREATOR,

  /// 管理员
  @JsonValue(2)
  V2NIM_CHATROOM_MEMBER_ROLE_MANAGER,

  /// 普通游客
  @JsonValue(3)
  V2NIM_CHATROOM_MEMBER_ROLE_NORMAL_GUEST,

  /// 匿名游客
  @JsonValue(4)
  V2NIM_CHATROOM_MEMBER_ROLE_ANONYMOUS_GUEST,

  /// 虚构用户
  @JsonValue(5)
  V2NIM_CHATROOM_MEMBER_ROLE_VIRTUAL,
}

///聊天室成员进入信息
@JsonSerializable(explicitToJson: true)
class V2NIMChatroomEnterInfo {
  /// 获取进入聊天室后显示的昵称
  String? roomNick;

  /// 获取进入聊天室后显示的头像
  String? roomAvatar;

  /// 获取用户进入聊天室的时间点
  int? enterTime;

  /// 进入的终端类型
  int? clientType;

  V2NIMChatroomEnterInfo(
      {this.clientType, this.enterTime, this.roomAvatar, this.roomNick});

  factory V2NIMChatroomEnterInfo.fromJson(Map<String, dynamic> json) =>
      _$V2NIMChatroomEnterInfoFromJson(json);

  Map<String, dynamic> toJson() => _$V2NIMChatroomEnterInfoToJson(this);
}
