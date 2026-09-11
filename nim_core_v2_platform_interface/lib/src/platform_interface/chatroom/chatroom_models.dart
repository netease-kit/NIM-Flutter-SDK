// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:nim_core_v2_platform_interface/nim_core_v2_platform_interface.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chatroom_models.g.dart';

///进入聊天室回包结果
@JsonSerializable(explicitToJson: true)
class V2NIMChatroomEnterResult {
  ///  聊天室信息
  @JsonKey(fromJson: v2NIMChatroomInfoFromJson)
  V2NIMChatroomInfo? chatroom;

  ///  自己的聊天室成员信息
  @JsonKey(fromJson: v2NIMChatroomMemberFromJson)
  V2NIMChatroomMember? selfMember;

  V2NIMChatroomEnterResult({this.chatroom, this.selfMember});

  Map<String, dynamic> toJson() => _$V2NIMChatroomEnterResultToJson(this);

  factory V2NIMChatroomEnterResult.fromJson(Map<String, dynamic> json) =>
      _$V2NIMChatroomEnterResultFromJson(json);
}

V2NIMChatroomInfo? v2NIMChatroomInfoFromJson(Map? map) {
  if (map != null) {
    return V2NIMChatroomInfo.fromJson(map.cast<String, dynamic>());
  }
  return null;
}

///加入聊天室登录相关参数
@JsonSerializable(explicitToJson: true)
class V2NIMChatroomEnterParams {
  /// 是否匿名模式
  /// 匿名模式不能发消息， 只能收消息
  bool anonymousMode = false;

  /// 账号ID
  /// 如果是匿名， 可以不填，内部生成账号
  /// 规则：nimanon_ UUID.randomUUID().toString(), 建议全局缓存一个
  /// 否则必须是合法的账号
  String? accountId;

  /// 静态token
  /// 快速使用接口， 方便用户使用，可以不填
  String? token;

  /// 进入聊天室后显示的昵称
  /// 如果填写则使用填写的内容
  /// 否则使用账号对应相关信息
  /// 如果是匿名模式，默认昵称为账号名称
  String? roomNick;

  /// 进入聊天室后显示的头像
  /// 如果填写则使用填写的内容
  /// 否则使用账号对应相关信息
  /// 如果为匿名模式，默认头像为空，如果需要头像，上传可以采用：SDK-API存储服务设计文档 uploadFile
  String? roomAvatar;

  /// 进入方法超时时间
  /// 超过该时间如果没有进入成功， 则返回失败
  int? timeout;

  ///认证模式
  NIMLoginAuthType? authType;

  /// 用户扩展字段，建议使用json格式
  String? serverExtension;

  /// 通知扩展字段，进入聊天室通知开发者扩展字段
  String? notificationExtension;

  /// 进入聊天室标签信息配置
  @JsonKey(fromJson: V2NIMChatroomTagConfigFromJson)
  V2NIMChatroomTagConfig? tagConfig;

  /// 进入聊天室空间位置信息配置
  @JsonKey(fromJson: V2NIMChatroomLocationConfigFromJson)
  V2NIMChatroomLocationConfig? locationConfig;

  /// 用户资料反垃圾检测
  /// 如果不审核，该配置不需要配置
  /// 如果开启了安全通，默认采用安全通，该配置不需要配置
  /// 如果需要审核，且直接对接易盾，则配置该配置
  @JsonKey(fromJson: NIMAntispamConfigFromJson)
  NIMAntispamConfig? antispamConfig;

  V2NIMChatroomEnterParams(
      {this.accountId,
      this.serverExtension,
      this.anonymousMode = false,
      this.antispamConfig,
      this.authType,
      this.locationConfig,
      this.notificationExtension,
      this.roomAvatar,
      this.roomNick,
      this.tagConfig,
      this.timeout,
      this.token});

  Map<String, dynamic> toJson() => _$V2NIMChatroomEnterParamsToJson(this);

  factory V2NIMChatroomEnterParams.fromJson(Map<String, dynamic> json) =>
      _$V2NIMChatroomEnterParamsFromJson(json);
}

V2NIMChatroomTagConfig? V2NIMChatroomTagConfigFromJson(Map? map) {
  if (map != null) {
    return V2NIMChatroomTagConfig.fromJson(map.cast<String, dynamic>());
  }
  return null;
}

V2NIMChatroomLocationConfig? V2NIMChatroomLocationConfigFromJson(Map? map) {
  if (map != null) {
    return V2NIMChatroomLocationConfig.fromJson(map.cast<String, dynamic>());
  }
  return null;
}

///聊天室标签配置
@JsonSerializable(explicitToJson: true)
class V2NIMChatroomTagConfig {
  ///登录标签

  List<String>? tags;

  /// 登录登出通知标签， 标签表达式

  String? notifyTargetTags;

  V2NIMChatroomTagConfig({this.notifyTargetTags, this.tags});
  Map<String, dynamic> toJson() => _$V2NIMChatroomTagConfigToJson(this);

  factory V2NIMChatroomTagConfig.fromJson(Map<String, dynamic> json) =>
      _$V2NIMChatroomTagConfigFromJson(json);
}

///聊天室位置信息配置
@JsonSerializable(explicitToJson: true)
class V2NIMChatroomLocationConfig {
  /// 空间坐标信息
  @JsonKey(fromJson: V2NIMLocationInfoFromJson)
  V2NIMLocationInfo? locationInfo;

  /// 订阅的消息的距离
  double? distance;

  V2NIMChatroomLocationConfig({this.distance, this.locationInfo});

  Map<String, dynamic> toJson() => _$V2NIMChatroomLocationConfigToJson(this);

  factory V2NIMChatroomLocationConfig.fromJson(Map<String, dynamic> json) =>
      _$V2NIMChatroomLocationConfigFromJson(json);
}

///聊天室信息
@JsonSerializable(explicitToJson: true)
class V2NIMChatroomInfo {
  /// 聊天室ID
  String? roomId;

  /// 聊天室名称
  String? roomName;

  /// 聊天室公告
  String? announcement;

  /// 聊天室直播地址
  String? liveUrl;

  /// 聊天室是否有效
  bool? isValidRoom;

  /// 聊天室扩展字段
  String? serverExtension;

  /// 聊天室队列操作权限模式
  V2NIMChatroomQueueLevelMode? queueLevelMode;

  /// 聊天室创建者ID
  String? creatorAccountId;

  /// 聊天室当前在线用户数量
  int? onlineUserCount;

  /// 聊天室禁言状态
  bool? chatBanned;

  V2NIMChatroomInfo(
      {this.serverExtension,
      this.announcement,
      this.chatBanned,
      this.creatorAccountId,
      this.liveUrl,
      this.onlineUserCount,
      this.queueLevelMode,
      this.roomId,
      this.roomName,
      this.isValidRoom});

  Map<String, dynamic> toJson() => _$V2NIMChatroomInfoToJson(this);

  factory V2NIMChatroomInfo.fromJson(Map<String, dynamic> json) =>
      _$V2NIMChatroomInfoFromJson(json);
}

///聊天室队列操作权限
enum V2NIMChatroomQueueLevelMode {
  /// 所有人都有权限操作
  @JsonValue(0)
  V2NIM_CHATROOM_QUEUE_LEVEL_MODE_ANY,

  ///只有创建者/管理员才能操作
  @JsonValue(1)
  V2NIM_CHATROOM_QUEUE_LEVEL_MODE_MANAGER
}

///聊天室状态信息
@JsonSerializable(explicitToJson: true)
class V2NIMChatroomStatusInfo {
  /// 聊天室实例ID
  int? instanceId;

  /// 聊天室状态
  V2NIMChatroomStatus status;

  /// 错误信息
  @JsonKey(fromJson: NIMErrorFromJson)
  NIMError? error;

  V2NIMChatroomStatusInfo({required this.status, this.error});

  Map<String, dynamic> toJson() => _$V2NIMChatroomStatusInfoToJson(this);

  factory V2NIMChatroomStatusInfo.fromJson(Map<String, dynamic> json) =>
      _$V2NIMChatroomStatusInfoFromJson(json);
}

NIMError? NIMErrorFromJson(Map? map) {
  if (map != null) {
    return NIMError.fromJson(map.cast<String, dynamic>());
  }
  return null;
}

/// 聊天室状态
enum V2NIMChatroomStatus {
  /// 聊天室断开连接
  @JsonValue(0)
  V2NIM_CHATROOM_STATUS_DISCONNECTED,

  /// 聊天室等待重连
  @JsonValue(1)
  V2NIM_CHATROOM_STATUS_WAITING,

  /// 聊天室连接过程中
  @JsonValue(2)
  V2NIM_CHATROOM_STATUS_CONNECTING,

  /// 聊天室已连接
  @JsonValue(3)
  V2NIM_CHATROOM_STATUS_CONNECTED,

  /// 聊天室进入中
  @JsonValue(4)
  V2NIM_CHATROOM_STATUS_ENTERING,

  /// 聊天室已进入
  @JsonValue(5)
  V2NIM_CHATROOM_STATUS_ENTERED,

  /// 聊天室已退出
  @JsonValue(6)
  V2NIM_CHATROOM_STATUS_EXITED,
}

///被踢出聊天室事件
@JsonSerializable(explicitToJson: true)
class V2NIMChatroomKickedInfoEvent {
  ///聊天室实例ID
  int? instanceId;

  @JsonKey(fromJson: V2NIMChatroomKickedInfoFromJson)
  V2NIMChatroomKickedInfo? kickedInfo;

  V2NIMChatroomKickedInfoEvent({this.instanceId, this.kickedInfo});

  Map<String, dynamic> toJson() => _$V2NIMChatroomKickedInfoEventToJson(this);

  factory V2NIMChatroomKickedInfoEvent.fromJson(Map<String, dynamic> json) =>
      _$V2NIMChatroomKickedInfoEventFromJson(json);
}

V2NIMChatroomKickedInfo? V2NIMChatroomKickedInfoFromJson(Map? map) {
  if (map != null) {
    return V2NIMChatroomKickedInfo.fromJson(map.cast<String, dynamic>());
  }
  return null;
}

///被踢出聊天室信息
@JsonSerializable(explicitToJson: true)
class V2NIMChatroomKickedInfo {
  ///被踢出聊天室原因
  V2NIMChatroomKickedReason? kickedReason;

  ///被踢原因扩展字段
  String? serverExtension;

  V2NIMChatroomKickedInfo(this.serverExtension, this.kickedReason);

  Map<String, dynamic> toJson() => _$V2NIMChatroomKickedInfoToJson(this);

  factory V2NIMChatroomKickedInfo.fromJson(Map<String, dynamic> json) =>
      _$V2NIMChatroomKickedInfoFromJson(json);
}

@JsonSerializable(explicitToJson: true)
class ChatRoomExitInfo {
  ///聊天室实例ID
  int? instanceId;

  ///错误信息
  @JsonKey(fromJson: NIMErrorFromJson)
  NIMError? error;

  ChatRoomExitInfo({this.instanceId, this.error});

  Map<String, dynamic> toJson() => _$ChatRoomExitInfoToJson(this);

  factory ChatRoomExitInfo.fromJson(Map<String, dynamic> json) =>
      _$ChatRoomExitInfoFromJson(json);
}

/// 聊天室被踢原因
enum V2NIMChatroomKickedReason {
  /// 未知
  @JsonValue(-1)
  V2NIM_CHATROOM_KICKED_REASON_UNKNOWN,

  /// 聊天室解散
  @JsonValue(1)
  V2NIM_CHATROOM_KICKED_REASON_CHATROOM_INVALID,

  /// 被管理员踢出
  @JsonValue(2)
  V2NIM_CHATROOM_KICKED_REASON_BY_MANAGER,

  /// 多端被踢
  @JsonValue(3)
  V2NIM_CHATROOM_KICKED_REASON_BY_CONFLICT_LOGIN,

  /// 静默被踢
  @JsonValue(4)
  V2NIM_CHATROOM_KICKED_REASON_SILENTLY,

  /// 加黑被踢
  @JsonValue(5)
  V2NIM_CHATROOM_KICKED_REASON_BE_BLOCKED,
}
