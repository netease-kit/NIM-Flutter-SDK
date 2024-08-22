// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:convert';
import 'package:universal_io/io.dart';

import 'package:json_annotation/json_annotation.dart';
import 'package:nim_core_v2_platform_interface/nim_core_v2_platform_interface.dart';

import 'team_enum.dart';

part 'team_member.g.dart';

@JsonSerializable()
class NIMTeamMemberRoleClass {
  /// 群组成员角色
  final NIMTeamMemberRole role;

  NIMTeamMemberRoleClass(this.role);

  factory NIMTeamMemberRoleClass.fromJson(Map<String, dynamic> map) =>
      _$NIMTeamMemberRoleClassFromJson(map);

  Map<String, dynamic> toJson() => _$NIMTeamMemberRoleClassToJson(this);

  /// Convert type to string value
  int toValue() {
    return _$NIMTeamMemberRoleEnumMap[role]!;
  }
}

/// 群组成员
@JsonSerializable()
class NIMTeamMember {
  /// 群组id
  String teamId;

  /// 群组类型
  NIMTeamType teamType;

  /// 群组成员账号id
  String accountId;

  /// 群组成员类型
  NIMTeamMemberRole memberRole;

  /// 群组昵称
  String? teamNick;

  /// 服务端扩展字段
  String? serverExtension;

  /// 入群时间
  int joinTime;

  /// 成员信息更新时间
  int? updateTime;

  /// 是否在群中，YES 在群组中，NO 不在群组中
  bool inTeam;

  /// 聊天是否被禁言，YES 被禁言，NO 未禁言
  bool? chatBanned;

  /// 构造函数
  NIMTeamMember({
    required this.teamId,
    required this.teamType,
    required this.accountId,
    required this.memberRole,
    this.teamNick,
    this.serverExtension,
    required this.joinTime,
    this.updateTime,
    required this.inTeam,
    this.chatBanned,
  });

  factory NIMTeamMember.fromJson(Map<String, dynamic> map) =>
      _$NIMTeamMemberFromJson(map);

  Map<String, dynamic> toJson() => _$NIMTeamMemberToJson(this);
}

/// 群组成员列表查询结果
List<NIMTeamMember> _teamMemberListFromJsonList(List<dynamic> members) {
  return members
      .map((e) => NIMTeamMember.fromJson((e as Map).cast<String, dynamic>()))
      .toList();
}

@JsonSerializable()
class TeamMemberKickedResult {
  /// 被踢出群成员列表
  @JsonKey(fromJson: _teamMemberListFromJsonList)
  List<NIMTeamMember> teamMembers;

  /// 操作账号id
  String operatorAccountId;

  TeamMemberKickedResult({
    required this.teamMembers,
    required this.operatorAccountId,
  });

  factory TeamMemberKickedResult.fromJson(Map<String, dynamic> map) =>
      _$TeamMemberKickedResultFromJson(map);

  Map<String, dynamic> toJson() => _$TeamMemberKickedResultToJson(this);
}
