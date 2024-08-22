// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:nim_core_v2_platform_interface/nim_core_v2_platform_interface.dart';

part "message_thread_v2.g.dart";

@JsonSerializable(explicitToJson: true)
class NIMThreadMessageListResult {
  /// 根消息
  @JsonKey(fromJson: nimMessageFromJson)
  NIMMessage? message;

  /// 获取thread聊天里最后一条消息的时间戳
  int? timestamp;

  /// 获取thread聊天里的总回复数，thread消息不计入总数
  int? replyCount;

  /// 消息回复列表
  @JsonKey(fromJson: _nimMessageListFromJson)
  List<NIMMessage?>? replyList;

  NIMThreadMessageListResult(
      {this.message, this.timestamp, this.replyCount, this.replyList});

  factory NIMThreadMessageListResult.fromJson(Map<String, dynamic> map) =>
      _$NIMThreadMessageListResultFromJson(map);

  Map<String, dynamic> toJson() => _$NIMThreadMessageListResultToJson(this);
}

List<NIMMessage>? _nimMessageListFromJson(List<dynamic>? applicationList) {
  return applicationList
      ?.map((e) => NIMMessage.fromJson((e as Map).cast<String, dynamic>()))
      .toList();
}

@JsonSerializable(explicitToJson: true)
class NIMThreadMessageListOption {
  /// 需要查询的消息引用， 如果该消息为根消息，则参数为当前消息；否则需要获取当前消息的根消息作为输入参数查询；否则查询失败
  @JsonKey(fromJson: nimMessageReferFromJson)
  NIMMessageRefer? messageRefer;

  /// 查询开始时间，小于等于 endTime。
  int? beginTime;

  /// 查询结束时间。默认当前时间+1个小时
  int? endTime;

  /// 锚点消息ServerId, 该消息必须处于端点，暨消息时间必须等于beginTime或endTime
  /// 如果是合法的消息id则表示排除该消息，否则不排除
  String? excludeMessageServerId;

  /// 每次查询条数
  /// 默认50，必须大于 0
  int? limit;

  /// 消息查询方向，如果其它参数都不填
  /// DESC:  按时间从大到小查询
  /// ASC:按时间从小到大查询
  NIMQueryDirection? direction;

  NIMThreadMessageListOption(
      {this.messageRefer,
      this.beginTime,
      this.endTime,
      this.excludeMessageServerId,
      this.limit,
      this.direction});

  factory NIMThreadMessageListOption.fromJson(Map<String, dynamic> map) =>
      _$NIMThreadMessageListOptionFromJson(map);

  Map<String, dynamic> toJson() => _$NIMThreadMessageListOptionToJson(this);
}
