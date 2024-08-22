// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'team_param.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:nim_core_v2_platform_interface/src/platform_interface/team/team.dart';
import 'package:nim_core_v2_platform_interface/src/platform_interface/team/team_member.dart';

part 'team_result.g.dart';

/// 群组成员列表结果
@JsonSerializable()
class NIMTeamMemberListResult {
  /// 数据是否拉取完毕
  bool finished;

  /// 下一次查询的偏移量
  String? nextToken;

  /// 群组成员列表
  @JsonKey(fromJson: _teamMemberListFromJsonList)
  List<NIMTeamMember>? memberList;

  NIMTeamMemberListResult({
    required this.finished,
    this.nextToken,
    this.memberList,
  });

  factory NIMTeamMemberListResult.fromJson(Map<String, dynamic> map) =>
      _$NIMTeamMemberListResultFromJson(map);

  Map<String, dynamic> toJson() => _$NIMTeamMemberListResultToJson(this);
}

List<NIMTeamJoinActionInfo>? _teamJoinActionInfoFromJson(List<dynamic>? infos) {
  return infos
      ?.map((e) =>
          NIMTeamJoinActionInfo.fromJson((e as Map).cast<String, dynamic>()))
      .toList();
}

/// 群加入相关信息返回内容
@JsonSerializable()
class NIMTeamJoinActionInfoResult {
  /// 查询返回的列表
  @JsonKey(fromJson: _teamJoinActionInfoFromJson)
  List<NIMTeamJoinActionInfo>? infos;

  /// 下一次的偏移量
  int offset;

  /// 查询结束
  bool finished;

  NIMTeamJoinActionInfoResult({
    this.infos,
    required this.offset,
    required this.finished,
  });

  factory NIMTeamJoinActionInfoResult.fromJson(Map<String, dynamic> map) =>
      _$NIMTeamJoinActionInfoResultFromJson(map);

  Map<String, dynamic> toJson() => _$NIMTeamJoinActionInfoResultToJson(this);
}

/// 创建群组结果
@JsonSerializable()
class NIMCreateTeamResult {
  /// 群组信息
  @JsonKey(fromJson: _nimTeamFromJson)
  NIMTeam? team;

  /// 邀请失败账号id列表
  List<String>? failedList;

  NIMCreateTeamResult({this.team, this.failedList});

  factory NIMCreateTeamResult.fromJson(Map<String, dynamic> map) =>
      _$NIMCreateTeamResultFromJson(map);

  Map<String, dynamic> toJson() => _$NIMCreateTeamResultToJson(this);
}

NIMTeam? _nimTeamFromJson(Map? map) {
  if (map == null) return null;
  return NIMTeam.fromJson(map.cast<String, dynamic>());
}

List<NIMTeamMember>? _teamMemberListFromJsonList(List<dynamic>? members) {
  return members
      ?.map((e) => NIMTeamMember.fromJson((e as Map).cast<String, dynamic>()))
      .toList();
}

/// 成员列表搜索结果
@JsonSerializable()
class NIMTeamMemberSearchResult {
  /// 返回列表
  @JsonKey(fromJson: _teamMemberListFromJsonList)
  List<NIMTeamMember>? teamMemberList;

  /// 下次搜索偏移量，finished = true 时，pageToken置为“”
  late String pageToken;

  /// 查询是否结束
  late bool finished;

  NIMTeamMemberSearchResult({
    this.teamMemberList,
    required this.pageToken,
    required this.finished,
  });

  factory NIMTeamMemberSearchResult.fromJson(Map<String, dynamic> map) =>
      _$NIMTeamMemberSearchResultFromJson(map);

  Map<String, dynamic> toJson() => _$NIMTeamMemberSearchResultToJson(this);
}
