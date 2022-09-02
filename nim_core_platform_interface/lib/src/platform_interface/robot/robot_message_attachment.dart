// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:json_annotation/json_annotation.dart';
import 'package:nim_core_platform_interface/nim_core_platform_interface.dart';

part 'robot_message_attachment.g.dart';

/// 机器人消息附件
@JsonSerializable()
class NIMRobotAttachment extends NIMMessageAttachment {
  final bool isRobotSend;
  final String fromRobotAccount;

  final String? responseForMessageId;
  final String? response;

  final NIMRobotMessageType? requestType;
  final String? requestContent;
  final String? requestTarget;
  final String? requestParams;

  NIMRobotAttachment(
      {this.isRobotSend = true,
      required this.fromRobotAccount,
      this.responseForMessageId,
      this.response,
      this.requestType,
      this.requestContent,
      this.requestTarget,
      this.requestParams});

  factory NIMRobotAttachment.fromMap(Map<String, dynamic> map) =>
      _$NIMRobotAttachmentFromJson(map);

  @override
  Map<String, dynamic> toMap() => _$NIMRobotAttachmentToJson(this);
}
