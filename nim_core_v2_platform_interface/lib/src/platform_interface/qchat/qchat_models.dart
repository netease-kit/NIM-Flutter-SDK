// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:json_annotation/json_annotation.dart';
import 'package:nim_core_v2_platform_interface/nim_core_v2_platform_interface.dart';

part 'qchat_models.g.dart';

@JsonSerializable(explicitToJson: true)
class QChatLoginParam {
  QChatLoginParam();

  factory QChatLoginParam.fromJson(Map<String, dynamic> json) =>
      _$QChatLoginParamFromJson(json);

  Map<String, dynamic> toJson() => _$QChatLoginParamToJson(this);

  @override
  String toString() {
    return 'QChatLoginParam{}';
  }
}

@JsonSerializable(explicitToJson: true)
class QChatLoginResult {
  /// 其他登录客户端信息
  @JsonKey(fromJson: _otherClientsFromJson)
  final List<QChatClient> otherClients;

  QChatLoginResult(this.otherClients);

  factory QChatLoginResult.fromJson(Map<String, dynamic> json) =>
      _$QChatLoginResultFromJson(json);

  Map<String, dynamic> toJson() => _$QChatLoginResultToJson(this);

  @override
  String toString() {
    return 'QChatLoginResult{otherClients: $otherClients}';
  }
}

List<QChatClient> _otherClientsFromJson(List<dynamic> dataList) {
  return dataList
      .map((e) => QChatClient.fromJson((e as Map).cast<String, dynamic>()))
      .toList();
}

@JsonSerializable()
class QChatClient {
  /// 客户端类型 [NIMClientType]
  NIMClientType? clientType;

  /// 客户端的操作系统信息
  String? os;

  /// 登录时间
  int? loginTime;

  /// 客户端设备Id
  String? deviceId;

  /// 自定义customTag
  String? customTag;

  /// 自定义ClientType
  int? customClientType;

  QChatClient();

  factory QChatClient.fromJson(Map<String, dynamic> json) =>
      _$QChatClientFromJson(json);

  Map<String, dynamic> toJson() => _$QChatClientToJson(this);

  @override
  String toString() {
    return 'QChatClient{clientType: $clientType, os: $os, loginTime: $loginTime, deviceId: $deviceId, customTag: $customTag, customClientType: $customClientType}';
  }
}

@JsonSerializable()
class QChatKickOtherClientsParam {
  /// 需要踢掉的端的设备号列表
  final List<String> deviceIds;

  QChatKickOtherClientsParam(this.deviceIds);

  factory QChatKickOtherClientsParam.fromJson(Map<String, dynamic> json) =>
      _$QChatKickOtherClientsParamFromJson(json);

  Map<String, dynamic> toJson() => _$QChatKickOtherClientsParamToJson(this);

  @override
  String toString() {
    return 'QChatKickOtherClientsParam{deviceIds: $deviceIds}';
  }
}

@JsonSerializable()
class QChatKickOtherClientsResult {
  /// 被成功踢掉的客户端的deviceId列表
  List<String> _clientIds = [];

  QChatKickOtherClientsResult(List<String>? clientIds) {
    if (clientIds != null) {
      this._clientIds = [...clientIds];
    }
  }

  factory QChatKickOtherClientsResult.fromJson(Map<String, dynamic> json) =>
      _$QChatKickOtherClientsResultFromJson(json);

  Map<String, dynamic> toJson() => _$QChatKickOtherClientsResultToJson(this);

  /// 获取被成功踢掉的客户端的deviceId列表
  List<String> get clientIds => _clientIds;

  @override
  String toString() {
    return 'QChatKickOtherClientsResult{_clientIds: $_clientIds}';
  }
}

/// 消息内容类型
enum QChatNIMMessageType {
  /// 未定义
  undef,

  /// 文本类型消息
  text,

  /// 图片类型消息
  image,

  /// 声音类型消息
  audio,

  /// 视频类型消息
  video,

  /// 位置类型消息
  location,

  /// 文件类型消息
  file,

  /// 音视频通话
  avchat,

  /// 通知类型消息
  notification,

  /// 提醒类型消息
  tip,

  /// Robot
  robot,

  /// G2话单消息
  netcall,

  /// Custom
  custom,

  /// 七鱼接入方自定义的消息
  appCustom,

  /// 七鱼类型的 custom 消息
  qiyuCustom,
}

enum QChatNIMMessageStatus {
  /// 草稿
  draft,

  /// 正在发送中
  sending,

  /// 发送成功
  success,

  /// 发送失败
  fail,

  /// 消息已读
  /// 发送消息时表示对方已看过该消息
  /// 接收消息时表示自己已读过，一般仅用于音频消息
  read,

  /// 未读状态
  unread
}
