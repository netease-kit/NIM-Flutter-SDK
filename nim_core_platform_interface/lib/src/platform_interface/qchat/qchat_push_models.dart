// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:json_annotation/json_annotation.dart';
import 'package:nim_core_platform_interface/nim_core_platform_interface.dart';

part 'qchat_push_models.g.dart';

@JsonSerializable(explicitToJson: true)
class QChatPushConfig {
  /// 推送是否不显示详情

  bool isPushShowNoDetail;

  /// 是否开启免打扰

  bool? isNoDisturbOpen;

  /// 免打扰开始时间，格式 HH:mm

  String? startNoDisturbTime;

  /// 免打扰结束时间，格式 HH:mm

  String? stopNoDisturbTime;

  /// 消息推送类型选项

  QChatPushMsgType? pushMsgType;

  QChatPushConfig(
      {this.pushMsgType,
      this.isNoDisturbOpen,
      required this.isPushShowNoDetail,
      this.startNoDisturbTime,
      this.stopNoDisturbTime});

  factory QChatPushConfig.fromJson(Map<String, dynamic> json) =>
      _$QChatPushConfigFromJson(json);

  Map<String, dynamic> toJson() => _$QChatPushConfigToJson(this);
}
