// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:core';

import 'package:json_annotation/json_annotation.dart';
import 'package:nim_core_platform_interface/nim_core_platform_interface.dart';

part 'thread_talk_history.g.dart';

/// 请求Thread聊天里的消息列表得到的信息
@JsonSerializable()
class NIMThreadTalkHistory {
  /// 获取Thread消息
  @JsonKey(
    toJson: messageToMap,
    fromJson: messageFromMap,
    includeIfNull: false,
  )
  NIMMessage? thread;

  /// 获取thread聊天里最后一条消息的时间戳
  int? time;

  /// 获取thread聊天里的总回复数，thread消息不计入总数
  @JsonKey(
    toJson: replyListToMap,
    fromJson: replyListFromMap,
    includeIfNull: false,
  )
  List<NIMMessage>? replyList;

  NIMThreadTalkHistory(
      {required this.thread, required this.time, required this.replyList});

  factory NIMThreadTalkHistory.fromMap(Map<String, dynamic> map) =>
      _$NIMThreadTalkHistoryFromJson(map);

  Map<String, dynamic> toMap() => _$NIMThreadTalkHistoryToJson(this);
}

Map? messageToMap(NIMMessage? nimMessage) => nimMessage?.toMap();

NIMMessage? messageFromMap(Map? map) =>
    map == null ? null : NIMMessage.fromMap(map.cast<String, dynamic>());

List<Map?>? replyListToMap(List<NIMMessage>? replyList) =>
    replyList?.map((e) => messageToMap(e)).toList();

List<NIMMessage>? replyListFromMap(List<dynamic>? replyListMap) =>
    replyListMap == null
        ? null
        : replyListMap
            .map((e) => NIMMessage.fromMap(Map<String, dynamic>.from(e)))
            .toList();
