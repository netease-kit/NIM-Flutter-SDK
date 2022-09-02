// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:json_annotation/json_annotation.dart';
import 'package:nim_core_platform_interface/nim_core_platform_interface.dart';

class RecentSessionList {
  @JsonKey(defaultValue: false)
  final bool hasMore;

  final List<RecentSession>? sessionList;

  RecentSessionList({required this.hasMore, this.sessionList});

  factory RecentSessionList.fromMap(Map<String, dynamic> param) {
    return RecentSessionList(
      hasMore: param['hasMore'] as bool,
      sessionList: (param['sessionList'] as List<dynamic>?)
          ?.map(
              (e) => RecentSession.fromMap(Map<String, dynamic>.from(e as Map)))
          .toList(),
    );
  }
}

class RecentSession {
  final String sessionId;
  final int? updateTime;
  final String? ext;
  final String? lastMsg;
  final int? lastMsgType;
  final NIMSession? recentSession;
  final NIMSessionType? sessionType;
  final String? sessionTypePair;
  final NIMRevokeMessage? revokeNotification;

  RecentSession(
      {required this.sessionId,
      this.updateTime,
      this.ext,
      this.lastMsg,
      this.lastMsgType,
      this.recentSession,
      this.sessionType,
      this.sessionTypePair,
      this.revokeNotification});

  factory RecentSession.fromMap(Map<String, dynamic> param) {
    return RecentSession(
      sessionId: param['sessionId'] as String,
      updateTime: param['updateTime'] as int,
      ext: param['ext'] as String?,
      lastMsg: param['lastMsg'] as String?,
      lastMsgType: param['lastMsgType'] as int?,
      recentSession: NIMSession.fromMap(
          Map<String, dynamic>.from(param['recentSession'] as Map)),
      sessionType: NIMSessionTypeConverter().fromValue(param['sessionType']),
      sessionTypePair: param['sessionTypePair'] as String?,
      revokeNotification: param['revokeNotification'] == null
          ? null
          : NIMRevokeMessage.fromMap(
              Map<String, dynamic>.from(param['revokeNotification'] as Map)),
    );
  }
}
