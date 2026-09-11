// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:json_annotation/json_annotation.dart';

part 'message_insert_params.g.dart';

/// 消息插入相关参数
@JsonSerializable(explicitToJson: true)
class V2NIMMessageInsertParams {
  /// 会话ID
  String conversationId;

  /// 消息发送者账号，传空表示当前用户。
  String? senderId;

  /// 指定插入消息时间戳（毫秒），传0则SDK使用当前NTP时间插入，默认0。
  int createTime;

  /// 是否需要更新会话的最后一条信息，true：需要，false：不需要，默认true。
  bool lastMessageUpdateEnabled;

  V2NIMMessageInsertParams({
    required this.conversationId,
    this.senderId,
    this.createTime = 0,
    this.lastMessageUpdateEnabled = true,
  });

  factory V2NIMMessageInsertParams.fromJson(Map<String, dynamic> json) =>
      _$V2NIMMessageInsertParamsFromJson(json);

  Map<String, dynamic> toJson() => _$V2NIMMessageInsertParamsToJson(this);
}
