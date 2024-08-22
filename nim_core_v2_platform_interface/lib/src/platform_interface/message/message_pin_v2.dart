// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:nim_core_v2_platform_interface/nim_core_v2_platform_interface.dart';

part "message_pin_v2.g.dart";

@JsonSerializable(explicitToJson: true)
class NIMMessagePin {
  /// 被Pin的消息关键信息
  @JsonKey(fromJson: nimMessageReferFromJson)
  NIMMessageRefer? messageRefer;

  /// 操作者ID
  String? operatorId;

  /// 扩展字段，最大512字节
  String? serverExtension;

  /// 创建时间
  int? createTime;

  /// 更新时间
  int? updateTime;

  NIMMessagePin(
      {this.messageRefer,
      this.operatorId,
      this.serverExtension,
      this.createTime,
      this.updateTime});

  factory NIMMessagePin.fromJson(Map<String, dynamic> map) =>
      _$NIMMessagePinFromJson(map);

  Map<String, dynamic> toJson() => _$NIMMessagePinToJson(this);
}

@JsonSerializable(explicitToJson: true)
class NIMMessagePinNotification {
  /// 被Pin的消息关键信息
  @JsonKey(fromJson: _nimMessagePinFromJson)
  NIMMessagePin? pin;

  /// 消息PIN状态
  NIMMessagePinState? pinState;

  NIMMessagePinNotification({this.pin, this.pinState});

  factory NIMMessagePinNotification.fromJson(Map<String, dynamic> map) =>
      _$NIMMessagePinNotificationFromJson(map);

  Map<String, dynamic> toJson() => _$NIMMessagePinNotificationToJson(this);
}

NIMMessagePin? _nimMessagePinFromJson(Map? map) {
  if (map != null) {
    return NIMMessagePin.fromJson(map.cast<String, dynamic>());
  }
  return null;
}
