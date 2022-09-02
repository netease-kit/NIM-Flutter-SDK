// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_team_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NIMCreateTeamResult _$NIMCreateTeamResultFromJson(Map<String, dynamic> json) {
  return NIMCreateTeamResult(
    team: teamFromMap(json['team'] as Map?),
    failedInviteAccounts: (json['failedInviteAccounts'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
  );
}

Map<String, dynamic> _$NIMCreateTeamResultToJson(NIMCreateTeamResult instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('team', teamToMap(instance.team));
  val['failedInviteAccounts'] = instance.failedInviteAccounts;
  return val;
}
