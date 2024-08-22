// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:nim_core_v2_platform_interface/nim_core_v2_platform_interface.dart';

part "message_quick_comment_v2.g.dart";

@JsonSerializable(explicitToJson: true)
class NIMMessageQuickComment {
  /// 快捷评论消息引用
  @JsonKey(fromJson: nimMessageReferFromJson)
  NIMMessageRefer? messageRefer;

  /// 操作者 ID
  String? operatorId;

  ///评论类型
  int? index;

  ///评论时间
  int? createTime;

  /// 扩展字段
  String? serverExtension;

  NIMMessageQuickComment(
      {this.messageRefer,
      this.operatorId,
      this.index,
      this.createTime,
      this.serverExtension});

  factory NIMMessageQuickComment.fromJson(Map<String, dynamic> map) =>
      _$NIMMessageQuickCommentFromJson(map);

  Map<String, dynamic> toJson() => _$NIMMessageQuickCommentToJson(this);
}

/// 消息快捷评论通知
@JsonSerializable(explicitToJson: true)
class NIMMessageQuickCommentNotification {
  /// 消息快捷评论状态
  NIMMessageQuickCommentType? operationType;

  /// 消息相关的快捷评论
  @JsonKey(fromJson: _nimMessageQuickCommentFromJson)
  NIMMessageQuickComment? quickComment;

  NIMMessageQuickCommentNotification({this.operationType, this.quickComment});

  factory NIMMessageQuickCommentNotification.fromJson(
          Map<String, dynamic> map) =>
      _$NIMMessageQuickCommentNotificationFromJson(map);

  Map<String, dynamic> toJson() =>
      _$NIMMessageQuickCommentNotificationToJson(this);
}

NIMMessageQuickComment? _nimMessageQuickCommentFromJson(Map? map) {
  if (map != null) {
    return NIMMessageQuickComment.fromJson(map.cast<String, dynamic>());
  }
  return null;
}

/// 消息快捷评论推送配置
@JsonSerializable(explicitToJson: true)
class NIMMessageQuickCommentPushConfig {
  /// 是否需要推送
  bool? pushEnabled;

  /// 是否需要角标
  bool? needBadge;

  /// 推送标题
  String? pushTitle;

  ///推送内容
  String? pushContent;

  /// 推送数据
  String? pushPayload;

  NIMMessageQuickCommentPushConfig(
      {this.pushEnabled,
      this.needBadge,
      this.pushTitle,
      this.pushContent,
      this.pushPayload});

  factory NIMMessageQuickCommentPushConfig.fromJson(Map<String, dynamic> map) =>
      _$NIMMessageQuickCommentPushConfigFromJson(map);

  Map<String, dynamic> toJson() =>
      _$NIMMessageQuickCommentPushConfigToJson(this);
}
