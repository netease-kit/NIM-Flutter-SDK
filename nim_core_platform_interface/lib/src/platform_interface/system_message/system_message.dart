// Copyright (c) 2021 NetEase, Inc.  All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:nim_core_platform_interface/src/utils/converter.dart';

class SystemMessage {
  final int? messageId;

  final SystemMessageType? type;

  final String? fromAccount;

  final String? targetId;

  final int? time;

  final SystemMessageStatus? status;

  final String? content;

  final String? attach;

  late Object? attachObject;

  final bool? unread;

  final String? customInfo;

  SystemMessage(
      {this.messageId,
      this.type,
      this.fromAccount,
      this.targetId,
      this.time,
      this.status,
      this.content,
      this.attach,
      this.attachObject,
      this.unread,
      this.customInfo});

  factory SystemMessage.fromMap(Map<String, dynamic> param) {
    return SystemMessage(
      messageId: param["messageId"] as int?,
      type: SystemMessageTypeConverter().fromValue(param["type"] as String?),
      fromAccount: param["fromAccount"] as String?,
      targetId: param["targetId"] as String?,
      time: param["time"] as int?,
      status:
          SystemMessageStatusConverter().fromValue(param["status"] as String),
      content: param["content"] as String?,
      attach: param["attach"] as String?,
      unread: param["unread"] as bool?,
      customInfo: param["customInfo"] as String?,
    );
  }
}

enum SystemMessageType {
  undefined,
  applyJoinTeam,
  rejectTeamApply,
  teamInvite,
  declineTeamInvite,
  addFriend,
  superTeamApply,
  superTeamApplyReject,
  superTeamInvite,
  superTeamInviteReject
}

enum SystemMessageStatus {
  init,
  passed,
  declined,
  ignored,
  expired,
  extension1,
  extension2,
  extension3,
  extension4,
  extension5
}
