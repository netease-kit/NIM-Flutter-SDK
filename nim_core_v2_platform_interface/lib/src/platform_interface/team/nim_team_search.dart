// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:json_annotation/json_annotation.dart';
import 'package:nim_core_v2_platform_interface/src/platform_interface/team/team_enum.dart';

part 'nim_team_search.g.dart';

/// 关键词匹配类型
enum NIMTeamKeywordMatchType {
  /// 单词全匹配（默认）
  @JsonValue(0)
  single,

  /// 多词任意匹配
  @JsonValue(1)
  multiple,
}

/// 群信息搜索参数
@JsonSerializable()
class NIMTeamSearchParams {
  /// 搜索关键词列表，至少包含一个关键词
  List<String> keywordList;

  /// 关键词匹配类型，默认 single（全词匹配）
  NIMTeamKeywordMatchType? keywordMatchType;

  /// 要搜索的群类型列表，为 null 或空表示搜索所有类型
  List<NIMTeamType>? teamTypes;

  /// 分页 token，云端搜索使用，首次传空字符串或 null
  String? nextToken;

  /// 每页返回结果数量
  int? limit;

  NIMTeamSearchParams({
    required this.keywordList,
    this.keywordMatchType,
    this.teamTypes,
    this.nextToken,
    this.limit,
  });

  factory NIMTeamSearchParams.fromJson(Map<String, dynamic> map) =>
      _$NIMTeamSearchParamsFromJson(map);

  Map<String, dynamic> toJson() => _$NIMTeamSearchParamsToJson(this);
}

/// 群引用，包含群 ID 和群类型
@JsonSerializable()
class NIMTeamRefer {
  /// 群 ID
  String teamId;

  /// 群类型
  NIMTeamType teamType;

  NIMTeamRefer({
    required this.teamId,
    required this.teamType,
  });

  factory NIMTeamRefer.fromJson(Map<String, dynamic> map) =>
      _$NIMTeamReferFromJson(map);

  Map<String, dynamic> toJson() => _$NIMTeamReferToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NIMTeamRefer &&
          runtimeType == other.runtimeType &&
          teamId == other.teamId &&
          teamType == other.teamType;

  @override
  int get hashCode => teamId.hashCode ^ teamType.hashCode;

  @override
  toString() => '$teamId|${_$NIMTeamTypeEnumMap[teamType]}';
}

NIMTeamRefer _nimTeamReferFromJson(Map map) =>
    NIMTeamRefer.fromJson(map.cast<String, dynamic>());

/// 群成员搜索参数（全文搜索，跨多个群）
@JsonSerializable(explicitToJson: true)
class NIMSearchTeamMemberParams {
  /// 搜索关键词列表，至少包含一个关键词
  List<String> keywordList;

  /// 关键词匹配类型，默认 single（全词匹配）
  NIMTeamKeywordMatchType? keywordMatchType;

  /// 限定搜索的群列表，为 null 表示搜索所有群
  @JsonKey(fromJson: _nimTeamReferListFromJson)
  List<NIMTeamRefer>? teamRefers;

  /// 是否搜索账号 ID，默认 false
  bool? searchAccountId;

  /// 是否搜索群昵称，默认 true
  bool? searchTeamNick;

  /// 分页 token，首次传空字符串或 null
  String? nextToken;

  /// 每页返回结果数量
  int? limit;

  NIMSearchTeamMemberParams({
    required this.keywordList,
    this.keywordMatchType,
    this.teamRefers,
    this.searchAccountId,
    this.searchTeamNick,
    this.nextToken,
    this.limit,
  });

  factory NIMSearchTeamMemberParams.fromJson(Map<String, dynamic> map) =>
      _$NIMSearchTeamMemberParamsFromJson(map);

  Map<String, dynamic> toJson() => _$NIMSearchTeamMemberParamsToJson(this);
}

List<NIMTeamRefer>? _nimTeamReferListFromJson(List<dynamic>? list) {
  return list
      ?.map((e) => NIMTeamRefer.fromJson((e as Map).cast<String, dynamic>()))
      .toList();
}
