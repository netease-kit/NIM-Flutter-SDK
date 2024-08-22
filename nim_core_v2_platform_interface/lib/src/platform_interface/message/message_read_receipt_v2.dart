// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:nim_core_v2_platform_interface/nim_core_v2_platform_interface.dart';

part "message_read_receipt_v2.g.dart";

/// 点对点消息已读回执
@JsonSerializable(explicitToJson: true)
class NIMP2PMessageReadReceipt {
  /// 会话ID
  String? conversationId;

  /// 最后一条已读消息的时间， 比该时间早的消息都可以认为已读
  int? timestamp;

  NIMP2PMessageReadReceipt({this.conversationId, this.timestamp});

  factory NIMP2PMessageReadReceipt.fromJson(Map<String, dynamic> map) =>
      _$NIMP2PMessageReadReceiptFromJson(map);

  Map<String, dynamic> toJson() => _$NIMP2PMessageReadReceiptToJson(this);
}

/// 群消息已读回执
@JsonSerializable(explicitToJson: true)
class NIMTeamMessageReadReceipt {
  /// 会话ID
  String? conversationId;

  /// 消息ID， 群消息中，已读的消息ID
  String? messageServerId;

  /// 消息客户端ID， 群消息中，已读的消息ID
  String? messageClientId;

  /// 群消息已读人数
  int? readCount;

  /// 群消息未读人数
  int? unreadCount;

  /// 群消息最新已读账号
  String? latestReadAccount;

  NIMTeamMessageReadReceipt(
      {this.conversationId,
      this.messageServerId,
      this.messageClientId,
      this.readCount,
      this.unreadCount,
      this.latestReadAccount});

  factory NIMTeamMessageReadReceipt.fromJson(Map<String, dynamic> map) =>
      _$NIMTeamMessageReadReceiptFromJson(map);

  Map<String, dynamic> toJson() => _$NIMTeamMessageReadReceiptToJson(this);
}

/// 群消息已读回执详情
@JsonSerializable(explicitToJson: true)
class NIMTeamMessageReadReceiptDetail {
  /// 群消息已读回执
  @JsonKey(fromJson: _nimTeamMessageReadReceiptFromJson)
  NIMTeamMessageReadReceipt? readReceipt;

  /// 已读账号列表
  List<String?>? readAccountList;

  /// 未读账号列表
  List<String?>? unreadAccountList;

  NIMTeamMessageReadReceiptDetail(
      {this.readReceipt, this.readAccountList, this.unreadAccountList});

  factory NIMTeamMessageReadReceiptDetail.fromJson(Map<String, dynamic> map) =>
      _$NIMTeamMessageReadReceiptDetailFromJson(map);

  Map<String, dynamic> toJson() =>
      _$NIMTeamMessageReadReceiptDetailToJson(this);
}

NIMTeamMessageReadReceipt? _nimTeamMessageReadReceiptFromJson(Map? map) {
  if (map != null) {
    return NIMTeamMessageReadReceipt.fromJson(map.cast<String, dynamic>());
  }
  return null;
}
