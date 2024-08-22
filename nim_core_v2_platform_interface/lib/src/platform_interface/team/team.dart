// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:json_annotation/json_annotation.dart';
import 'package:nim_core_v2_platform_interface/nim_core_v2_platform_interface.dart';

import 'team_enum.dart';
part 'team.g.dart';

@JsonSerializable()
class NIMTeam {
  /// 群组id
  final String teamId;

  /// 群组类型
  final NIMTeamType teamType;

  /// 群组名称
  final String name;

  /// 群组创建者/拥有者账号id
  final String ownerAccountId;

  /// 群组人数上限
  final int memberLimit;

  /// 群组当前人数
  final int memberCount;

  /// 群组创建时间
  final int createTime;

  /// 群组更新时间
  final int updateTime;

  /// 群组介绍
  final String? intro;

  /// 群组公告
  final String? announcement;

  /// 群组头像
  final String? avatar;

  /// 服务端扩展字段
  final String? serverExtension;

  /// 客户自定义扩展
  final String? customerExtension;

  /// 申请入群模式
  final NIMTeamJoinMode joinMode;

  /// 被邀请人同意入群模式
  final NIMTeamAgreeMode agreeMode;

  /// 邀请入群模式
  final NIMTeamInviteMode inviteMode;

  /// 群组资料修改模式
  final NIMTeamUpdateInfoMode updateInfoMode;

  /// 群组扩展字段修改模式
  final NIMTeamUpdateExtensionMode updateExtensionMode;

  /// 群组禁言模式
  final NIMTeamChatBannedMode chatBannedMode;

  /// 是否有效的群， 群存在且我在群组中
  final bool isValidTeam;

  NIMTeam({
    required this.teamId,
    required this.teamType,
    required this.name,
    required this.ownerAccountId,
    required this.memberLimit,
    required this.memberCount,
    required this.createTime,
    required this.updateTime,
    this.intro,
    this.announcement,
    this.avatar,
    this.serverExtension,
    this.customerExtension,
    required this.joinMode,
    required this.agreeMode,
    required this.inviteMode,
    required this.updateInfoMode,
    required this.updateExtensionMode,
    required this.chatBannedMode,
    required this.isValidTeam,
  });

  factory NIMTeam.fromJson(Map<String, dynamic> map) => _$NIMTeamFromJson(map);

  Map<String, dynamic> toJson() => _$NIMTeamToJson(this);
}

NIMTeam _nimTeamFromJson(Map map) {
  return NIMTeam.fromJson(map.cast<String, dynamic>());
}

@JsonSerializable()
class TeamLeftReuslt {
  /// 离开群组的群组id
  @JsonKey(fromJson: _nimTeamFromJson)
  NIMTeam team;

  /// 离开群组的群组类型
  bool isKicked;

  TeamLeftReuslt({
    required this.team,
    required this.isKicked,
  });

  factory TeamLeftReuslt.fromJson(Map<String, dynamic> json) =>
      _$TeamLeftReusltFromJson(json);

  Map<String, dynamic> toJson() => _$TeamLeftReusltToJson(this);
}

@JsonSerializable(explicitToJson: true)
class NIMTeamTypeClass {
  NIMTeamType type;
  NIMTeamTypeClass(this.type);

  Map<String, dynamic> toJson() => _$NIMTeamTypeClassToJson(this);

  /// Convert type to string value
  int toValue() {
    return _$NIMTeamTypeEnumMap[type]!;
  }

  factory NIMTeamTypeClass.fromJson(Map<String, dynamic> map) =>
      _$NIMTeamTypeClassFromJson(map);
}

@JsonSerializable()
class NIMTeamChatBannedModeClass {
  NIMTeamChatBannedMode mode;
  NIMTeamChatBannedModeClass(this.mode);

  Map<String, dynamic> toJson() => _$NIMTeamChatBannedModeClassToJson(this);

  /// Convert type to string value
  int toValue() {
    return _$NIMTeamChatBannedModeEnumMap[mode]!;
  }

  factory NIMTeamChatBannedModeClass.fromJson(Map<String, dynamic> map) =>
      _$NIMTeamChatBannedModeClassFromJson(map);
}
