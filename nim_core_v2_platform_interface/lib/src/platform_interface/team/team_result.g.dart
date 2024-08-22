// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NIMTeamMemberListResult _$NIMTeamMemberListResultFromJson(
        Map<String, dynamic> json) =>
    NIMTeamMemberListResult(
      finished: json['finished'] as bool,
      nextToken: json['nextToken'] as String?,
      memberList: _teamMemberListFromJsonList(json['memberList'] as List?),
    );

Map<String, dynamic> _$NIMTeamMemberListResultToJson(
        NIMTeamMemberListResult instance) =>
    <String, dynamic>{
      'finished': instance.finished,
      'nextToken': instance.nextToken,
      'memberList': instance.memberList,
    };

NIMTeamJoinActionInfoResult _$NIMTeamJoinActionInfoResultFromJson(
        Map<String, dynamic> json) =>
    NIMTeamJoinActionInfoResult(
      infos: _teamJoinActionInfoFromJson(json['infos'] as List?),
      offset: (json['offset'] as num).toInt(),
      finished: json['finished'] as bool,
    );

Map<String, dynamic> _$NIMTeamJoinActionInfoResultToJson(
        NIMTeamJoinActionInfoResult instance) =>
    <String, dynamic>{
      'infos': instance.infos,
      'offset': instance.offset,
      'finished': instance.finished,
    };

NIMCreateTeamResult _$NIMCreateTeamResultFromJson(Map<String, dynamic> json) =>
    NIMCreateTeamResult(
      team: _nimTeamFromJson(json['team'] as Map?),
      failedList: (json['failedList'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$NIMCreateTeamResultToJson(
        NIMCreateTeamResult instance) =>
    <String, dynamic>{
      'team': instance.team,
      'failedList': instance.failedList,
    };

NIMTeamMemberSearchResult _$NIMTeamMemberSearchResultFromJson(
        Map<String, dynamic> json) =>
    NIMTeamMemberSearchResult(
      teamMemberList:
          _teamMemberListFromJsonList(json['teamMemberList'] as List?),
      pageToken: json['pageToken'] as String,
      finished: json['finished'] as bool,
    );

Map<String, dynamic> _$NIMTeamMemberSearchResultToJson(
        NIMTeamMemberSearchResult instance) =>
    <String, dynamic>{
      'teamMemberList': instance.teamMemberList,
      'pageToken': instance.pageToken,
      'finished': instance.finished,
    };
