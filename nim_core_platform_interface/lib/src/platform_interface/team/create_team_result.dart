// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:json_annotation/json_annotation.dart';
import 'package:nim_core_platform_interface/src/platform_interface/team/team.dart';

part 'create_team_result.g.dart';

///
@JsonSerializable()
class NIMCreateTeamResult {
  /// 调用者创建的Team
  @JsonKey(
    toJson: teamToMap,
    fromJson: teamFromMap,
    includeIfNull: false,
  )
  final NIMTeam? team;

  /// 邀请成员群数量超限的账号列表
  final List<String>? failedInviteAccounts;

  NIMCreateTeamResult({
    this.team,
    this.failedInviteAccounts,
  });

  factory NIMCreateTeamResult.fromMap(Map<String, dynamic> map) =>
      _$NIMCreateTeamResultFromJson(map);

  Map<String, dynamic> toMap() => _$NIMCreateTeamResultToJson(this);
}

Map? teamToMap(NIMTeam? nimTeam) => nimTeam?.toMap();

NIMTeam? teamFromMap(Map? map) =>
    map == null ? null : NIMTeam.fromMap(map.cast<String, dynamic>());
