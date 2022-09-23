// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:json_annotation/json_annotation.dart';

import '../../../nim_core_platform_interface.dart';

part 'super_team_member.g.dart';

///
@JsonSerializable()
class NIMSuperTeamMember {
  /// 获取群组ID
  final String? id;

  /// 群成员帐号
  final String? account;

  /// 群成员帐号
  final TeamMemberType? type;

  /// 获取该用户在这个群内的群昵称
  final String? teamNick;

  /// 是否该用户是否在这个群中
  /// true表示存在；false表示已不在该群中
  final bool isInTeam;

  /// 获取扩展字段
  /// 扩展字段Map
  @JsonKey(fromJson: castPlatformMapToDartMap)
  final Map<String, dynamic>? extension;

  /// 是否被禁言
  /// true表示处于被禁言状态；false表示处于未被禁言状态
  final bool isMute;

  /// 获取群成员入群时间
  final int joinTime;

  /// 获取入群邀请人，为空表示主动加入群
  final String? invitorAccid;

  NIMSuperTeamMember(
      {this.id,
      this.account,
      this.type,
      this.teamNick,
      required this.isInTeam,
      this.extension,
      required this.isMute,
      required this.joinTime,
      this.invitorAccid});

  factory NIMSuperTeamMember.fromMap(Map<String, dynamic> map) =>
      _$NIMSuperTeamMemberFromJson(map);

  Map<String, dynamic> toMap() => _$NIMSuperTeamMemberToJson(this);
}
