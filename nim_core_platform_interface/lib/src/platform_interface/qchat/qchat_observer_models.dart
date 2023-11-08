// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:json_annotation/json_annotation.dart';
import 'package:nim_core_platform_interface/nim_core_platform_interface.dart';

part 'qchat_observer_models.g.dart';

///状态变化事件
@JsonSerializable(explicitToJson: true)
class QChatStatusChangeEvent {
  ///状态码
  NIMAuthStatus status;

  QChatStatusChangeEvent(this.status);

  factory QChatStatusChangeEvent.fromJson(Map<String, dynamic> json) =>
      _$QChatStatusChangeEventFromJson(json);

  Map<String, dynamic> toJson() => _$QChatStatusChangeEventToJson(this);
}

@JsonSerializable(explicitToJson: true)
class QChatMultiSpotLoginEvent {
  /// 多点登陆通知类型
  QChatMultiSpotNotifyType? notifyType;

  ///其他端信息
  @JsonKey(fromJson: qChatClientFromJson)
  QChatClient? otherClient;

  QChatMultiSpotLoginEvent({this.notifyType, this.otherClient});

  factory QChatMultiSpotLoginEvent.fromJson(Map<String, dynamic> json) =>
      _$QChatMultiSpotLoginEventFromJson(json);

  Map<String, dynamic> toJson() => _$QChatMultiSpotLoginEventToJson(this);
}

QChatClient? qChatClientFromJson(Map? map) {
  if (map != null) {
    return QChatClient.fromJson(map.cast<String, dynamic>());
  }
  return null;
}

enum QChatMultiSpotNotifyType {
  /// 通知其他在线端，我上来了
  qchat_in,

  /// 通知其他在线端，我退出
  qchat_out
}

@JsonSerializable(explicitToJson: true)
class QChatKickedOutEvent {
  ///客户端类型

  int? clientType;

  ///被踢原因

  QChatKickOutReason? kickReason;

  ///描述

  String? extension;

  ///自定义客户端类型

  int? customClientType;

  QChatKickedOutEvent(
      {this.extension,
      this.clientType,
      this.customClientType,
      this.kickReason});

  factory QChatKickedOutEvent.fromJson(Map<String, dynamic> json) =>
      _$QChatKickedOutEventFromJson(json);

  Map<String, dynamic> toJson() => _$QChatKickedOutEventToJson(this);
}

enum QChatKickOutReason {
  ///未知（出错情况）
  unknown,

  ///相同类型终端登录时被踢
  kick_by_same_platform,

  ///管理后台禁止登录
  kick_by_server,

  ///被同时在线的其他端踢掉
  kick_by_other_platform,
}

///消息更新事件
@JsonSerializable(explicitToJson: true)
class QChatMessageUpdateEvent {
  ///消息更改信息
  @JsonKey(fromJson: qChatMsgUpdateInfoFromJson)
  QChatMsgUpdateInfo? msgUpdateInfo;

  ///更改后的消息体
  @JsonKey(fromJson: qChatMessageFromJson)
  QChatMessage? message;

  QChatMessageUpdateEvent({this.message, this.msgUpdateInfo});

  factory QChatMessageUpdateEvent.fromJson(Map<String, dynamic> json) =>
      _$QChatMessageUpdateEventFromJson(json);

  Map<String, dynamic> toJson() => _$QChatMessageUpdateEventToJson(this);
}

///消息撤回事件
@JsonSerializable(explicitToJson: true)
class QChatMessageRevokeEvent {
  ///消息更改信息
  @JsonKey(fromJson: qChatMsgUpdateInfoFromJson)
  QChatMsgUpdateInfo? msgUpdateInfo;

  ///更改后的消息体
  @JsonKey(fromJson: qChatMessageFromJson)
  QChatMessage? message;

  QChatMessageRevokeEvent({this.msgUpdateInfo, this.message});

  factory QChatMessageRevokeEvent.fromJson(Map<String, dynamic> json) =>
      _$QChatMessageRevokeEventFromJson(json);

  Map<String, dynamic> toJson() => _$QChatMessageRevokeEventToJson(this);
}

///消息删除事件
@JsonSerializable(explicitToJson: true)
class QChatMessageDeleteEvent {
  ///消息更改信息
  @JsonKey(fromJson: qChatMsgUpdateInfoFromJson)
  QChatMsgUpdateInfo? msgUpdateInfo;

  ///更改后的消息体
  @JsonKey(fromJson: qChatMessageFromJson)
  QChatMessage? message;

  QChatMessageDeleteEvent({this.msgUpdateInfo, this.message});

  factory QChatMessageDeleteEvent.fromJson(Map<String, dynamic> json) =>
      _$QChatMessageDeleteEventFromJson(json);

  Map<String, dynamic> toJson() => _$QChatMessageDeleteEventToJson(this);
}

///未读信息变更事件
@JsonSerializable(explicitToJson: true)
class QChatUnreadInfoChangedEvent {
  ///变更后的未读状态
  @JsonKey(fromJson: qChatUnreadInfListFromJson)
  List<QChatUnreadInfo>? unreadInfos;

  ///上一次通知时的未读状态
  @JsonKey(fromJson: qChatUnreadInfListFromJson)
  List<QChatUnreadInfo>? lastUnreadInfos;

  QChatUnreadInfoChangedEvent({this.lastUnreadInfos, this.unreadInfos});

  factory QChatUnreadInfoChangedEvent.fromJson(Map<String, dynamic> json) =>
      _$QChatUnreadInfoChangedEventFromJson(json);

  Map<String, dynamic> toJson() => _$QChatUnreadInfoChangedEventToJson(this);
}

///附件发送/接收进度通知
@JsonSerializable(explicitToJson: true)
class AttachmentProgress {
  ///消息的id
  final String id;

  ///消息附件文件当前已下载进度
  final double progress;

  AttachmentProgress({required this.id, required this.progress});

  factory AttachmentProgress.fromJson(Map<String, dynamic> json) =>
      _$AttachmentProgressFromJson(json);

  Map<String, dynamic> toJson() => _$AttachmentProgressToJson(this);
}

///系统通知更新事件
@JsonSerializable(explicitToJson: true)
class QChatSystemNotificationUpdateEvent {
  ///获取消息更改信息
  @JsonKey(fromJson: qChatMsgUpdateInfoFromJson)
  QChatMsgUpdateInfo? msgUpdateInfo;

  ///获取更改后的系统通知
  @JsonKey(fromJson: qChatSystemNotificationFromJson)
  QChatSystemNotification? systemNotification;

  QChatSystemNotificationUpdateEvent(
      {this.msgUpdateInfo, this.systemNotification});

  factory QChatSystemNotificationUpdateEvent.fromJson(
          Map<String, dynamic> json) =>
      _$QChatSystemNotificationUpdateEventFromJson(json);

  Map<String, dynamic> toJson() =>
      _$QChatSystemNotificationUpdateEventToJson(this);
}

@JsonSerializable(explicitToJson: true)
class QChatServerUnreadInfoChangedEvent {
  /// 变更后服务器未读状态
  @JsonKey(fromJson: qChatServerUnreadInfoListFromJson)
  List<QChatServerUnreadInfo>? serverUnreadInfos;

  QChatServerUnreadInfoChangedEvent({this.serverUnreadInfos});

  factory QChatServerUnreadInfoChangedEvent.fromJson(
          Map<String, dynamic> json) =>
      _$QChatServerUnreadInfoChangedEventFromJson(json);

  Map<String, dynamic> toJson() =>
      _$QChatServerUnreadInfoChangedEventToJson(this);
}

List<QChatServerUnreadInfo>? qChatServerUnreadInfoListFromJson(
    List<dynamic>? infoList) {
  if (infoList != null) {
    return infoList
        .map((e) =>
            QChatServerUnreadInfo.fromJson((e as Map).cast<String, dynamic>()))
        .toList();
  }
  return null;
}

/// 未读信息
@JsonSerializable(explicitToJson: true)
class QChatServerUnreadInfo {
  /// 获取serverId

  int serverId;

  /// 获取未读数

  int? unreadCount;

  /// 获取@的未读数

  int? mentionedCount;

  /// 获取最大未读数

  int? maxCount;

  QChatServerUnreadInfo(
      {required this.serverId,
      this.unreadCount,
      this.mentionedCount,
      this.maxCount});

  factory QChatServerUnreadInfo.fromJson(Map<String, dynamic> json) =>
      _$QChatServerUnreadInfoFromJson(json);

  Map<String, dynamic> toJson() => _$QChatServerUnreadInfoToJson(this);
}
