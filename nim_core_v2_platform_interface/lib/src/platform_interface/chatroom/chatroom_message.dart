// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:json_annotation/json_annotation.dart';
import 'package:nim_core_v2_platform_interface/nim_core_v2_platform_interface.dart';

part 'chatroom_message.g.dart';

/// 聊天室消息
@JsonSerializable(explicitToJson: true)
class V2NIMChatroomMessage {
  /// 客户端消息ID，可以根据该字段确认消息是否重复
  String? messageClientId;

  /// 消息发送者客户端类型
  int? senderClientType;

  /// 消息时间，服务器器时间，在发送成功之前，时间为发送者本地时间
  int? createTime;

  /// 消息发送者账号
  String? senderId;

  /// 聊天室ID
  String? roomId;

  /// 消息发送者是不是自己
  bool? isSelf;

  /// 附件上传状态
  NIMMessageAttachmentUploadState? attachmentUploadState;

  /// 消息发送状态
  NIMMessageSendingState? sendingState;

  /// 消息类型
  NIMMessageType? messageType;

  /// 消息子类型
  int? subType;

  /// 消息内容
  String? text;

  /// 消息附属附件
  @JsonKey(fromJson: nimMessageAttachmentFromJson)
  NIMMessageAttachment? attachment;

  /// 消息服务端扩展,2048， 可扩展
  String? serverExtension;

  /// 第三方回调扩展字段， 透传字段
  String? callbackExtension;

  /// 路由抄送相关配置
  @JsonKey(fromJson: nimMessageRouteConfigFromJson)
  NIMMessageRouteConfig? routeConfig;

  /// 反垃圾相关配置
  @JsonKey(fromJson: nimMessageAntispamConfigFromJson)
  NIMMessageAntispamConfig? antispamConfig;

  /// 消息的目标标签表达式， 标签表达式
  String? notifyTargetTags;

  /// 聊天室消息配置
  @JsonKey(fromJson: V2NIMChatroomMessageConfigFromJson)
  V2NIMChatroomMessageConfig? messageConfig;

  /// 消息发送时用户信息配置
  @JsonKey(fromJson: V2NIMUserInfoConfigFromJson)
  V2NIMUserInfoConfig? userInfoConfig;

  /// 消息空间坐标信息配置
  @JsonKey(fromJson: V2NIMLocationInfoFromJson)
  V2NIMLocationInfo? locationInfo;

  V2NIMChatroomMessage(
      {this.subType,
      this.routeConfig,
      this.antispamConfig,
      this.text,
      this.serverExtension,
      this.attachment,
      this.messageConfig,
      this.messageClientId,
      this.createTime,
      this.senderId,
      this.sendingState,
      this.isSelf,
      this.messageType,
      this.attachmentUploadState,
      this.callbackExtension,
      this.locationInfo,
      this.notifyTargetTags,
      this.roomId,
      this.senderClientType,
      this.userInfoConfig});

  Map<String, dynamic> toJson() => _$V2NIMChatroomMessageToJson(this);

  factory V2NIMChatroomMessage.fromJson(Map<String, dynamic> json) =>
      _$V2NIMChatroomMessageFromJson(json);
}

V2NIMChatroomMessageConfig? V2NIMChatroomMessageConfigFromJson(Map? map) {
  if (map != null) {
    return V2NIMChatroomMessageConfig.fromJson(map.cast<String, dynamic>());
  }
  return null;
}

V2NIMUserInfoConfig? V2NIMUserInfoConfigFromJson(Map? map) {
  if (map != null) {
    return V2NIMUserInfoConfig.fromJson(map.cast<String, dynamic>());
  }
  return null;
}

@JsonSerializable(explicitToJson: true)
class V2NIMChatroomMessageConfig {
  /// 是否需要在服务端保存历史消息
  bool? historyEnabled;

  /// 是否是高优先级消息
  bool? highPriority;

  V2NIMChatroomMessageConfig({this.highPriority, this.historyEnabled});

  Map<String, dynamic> toJson() => _$V2NIMChatroomMessageConfigToJson(this);

  factory V2NIMChatroomMessageConfig.fromJson(Map<String, dynamic> json) =>
      _$V2NIMChatroomMessageConfigFromJson(json);
}

@JsonSerializable(explicitToJson: true)
class V2NIMUserInfoConfig {
  /// 消息发送者用户资料的最后更新时间
  int? userInfoTimestamp;

  /// 消息发送者昵称
  String? senderNick;

  /// 消息发送者头像
  String? senderAvatar;

  /// 消息发送者扩展字段
  String? senderExtension;

  V2NIMUserInfoConfig(
      {this.senderAvatar,
      this.senderExtension,
      this.senderNick,
      this.userInfoTimestamp});

  Map<String, dynamic> toJson() => _$V2NIMUserInfoConfigToJson(this);

  factory V2NIMUserInfoConfig.fromJson(Map<String, dynamic> json) =>
      _$V2NIMUserInfoConfigFromJson(json);
}

V2NIMLocationInfo? V2NIMLocationInfoFromJson(Map? map) {
  if (map != null) {
    return V2NIMLocationInfo.fromJson(map.cast<String, dynamic>());
  }
  return null;
}

@JsonSerializable(explicitToJson: true)
class V2NIMLocationInfo {
  /// 空间坐标X
  double? x;

  /// 空间坐标Y
  double? y;

  /// 空间坐标Z
  double? z;

  V2NIMLocationInfo({this.x, this.y, this.z});

  Map<String, dynamic> toJson() => _$V2NIMLocationInfoToJson(this);

  factory V2NIMLocationInfo.fromJson(Map<String, dynamic> json) =>
      _$V2NIMLocationInfoFromJson(json);
}

///发送聊天室消息相关配置
@JsonSerializable(explicitToJson: true)
class V2NIMSendChatroomMessageParams {
  /// 消息相关配置
  @JsonKey(fromJson: V2NIMChatroomMessageConfigFromJson)
  V2NIMChatroomMessageConfig? messageConfig;

  /// 路由抄送相关配置
  @JsonKey(fromJson: nimMessageRouteConfigFromJson)
  NIMMessageRouteConfig? routeConfig;

  /// 反垃圾相关配置
  @JsonKey(fromJson: nimMessageAntispamConfigFromJson)
  NIMMessageAntispamConfig? antispamConfig;

  /// 是否启用本地反垃圾，默认为false
  bool? clientAntispamEnabled;

  /// 反垃圾命中后替换的文本，clientAntispamEnabled = true 时必传
  String? clientAntispamReplace;

  /// 聊天室定向消息接收者账号ID列表，如果receiverIds不为空，表示为聊天室定向消息，设置该字段后，会忽略消息配置中的history_enabled配置，消息不存历史
  List<String>? receiverIds;

  /// 消息的目标标签表达式
  String? notifyTargetTags;

  /// 位置信息
  @JsonKey(fromJson: V2NIMLocationInfoFromJson)
  V2NIMLocationInfo? locationInfo;

  V2NIMSendChatroomMessageParams(
      {this.messageConfig,
      this.routeConfig,
      this.antispamConfig,
      this.clientAntispamEnabled,
      this.clientAntispamReplace,
      this.locationInfo,
      this.notifyTargetTags,
      this.receiverIds});

  Map<String, dynamic> toJson() => _$V2NIMSendChatroomMessageParamsToJson(this);

  factory V2NIMSendChatroomMessageParams.fromJson(Map<String, dynamic> json) =>
      _$V2NIMSendChatroomMessageParamsFromJson(json);
}

V2NIMChatroomMessage? V2NIMChatroomMessageFromJson(Map? map) {
  if (map != null) {
    return V2NIMChatroomMessage.fromJson(map.cast<String, dynamic>());
  }
  return null;
}

///发送聊天室消息成功回包
@JsonSerializable(explicitToJson: true)
class V2NIMSendChatroomMessageResult {
  /// 获取发送成功后的消息体
  @JsonKey(fromJson: V2NIMChatroomMessageFromJson)
  V2NIMChatroomMessage? message;

  /// 获取云端反垃圾返回的结果
  String? antispamResult;

  /// 获取客户端本地反垃圾结果
  @JsonKey(fromJson: nimClientAntispamResultFromJson)
  NIMClientAntispamResult? clientAntispamResult;

  V2NIMSendChatroomMessageResult(
      {this.message, this.antispamResult, this.clientAntispamResult});

  Map<String, dynamic> toJson() => _$V2NIMSendChatroomMessageResultToJson(this);

  factory V2NIMSendChatroomMessageResult.fromJson(Map<String, dynamic> json) =>
      _$V2NIMSendChatroomMessageResultFromJson(json);
}

/// 分页查询聊天室成员参数
@JsonSerializable(explicitToJson: true)
class V2NIMChatroomMemberQueryOption {
  /// 需要查询的成员类型,如果列表为空，表示查询所有类型的成员
  List<V2NIMChatroomMemberRole>? memberRoles;

  /// 是否只返回黑名单成员
  bool? onlyBlocked;

  /// 是否只返回禁言用户
  bool? onlyChatBanned;

  /// 是否只查询在线成员，只针对固定成员生效，其他类型成员只有在线状态
  bool? onlyOnline;

  /// 偏移量 首次传“”，后续查询传前一次返回的pageToken
  String? pageToken;

  /// 查询数量
  int? limit;

  V2NIMChatroomMemberQueryOption(
      {this.memberRoles,
      this.onlyBlocked,
      this.onlyChatBanned,
      this.onlyOnline,
      this.pageToken,
      this.limit});

  Map<String, dynamic> toJson() => _$V2NIMChatroomMemberQueryOptionToJson(this);

  factory V2NIMChatroomMemberQueryOption.fromJson(Map<String, dynamic> json) =>
      _$V2NIMChatroomMemberQueryOptionFromJson(json);
}

List<V2NIMChatroomMember>? V2NIMChatroomMemberListFromJson(
    List<dynamic>? enterInfos) {
  return enterInfos
      ?.map((e) =>
          V2NIMChatroomMember.fromJson((e as Map).cast<String, dynamic>()))
      .toList();
}

///成员查询返回结构
@JsonSerializable(explicitToJson: true)
class V2NIMChatroomMemberListResult {
  /// 获取下一次拉取偏移量
  String? pageToken;

  /// 数据是否拉取完毕
  bool finished = false;

  /// 查询返回的成员列表
  @JsonKey(fromJson: V2NIMChatroomMemberListFromJson)
  List<V2NIMChatroomMember>? memberList;

  V2NIMChatroomMemberListResult(
      {this.pageToken, this.finished = false, this.memberList});

  Map<String, dynamic> toJson() => _$V2NIMChatroomMemberListResultToJson(this);

  factory V2NIMChatroomMemberListResult.fromJson(Map<String, dynamic> json) =>
      _$V2NIMChatroomMemberListResultFromJson(json);
}

///聊天室消息查询选项
@JsonSerializable(explicitToJson: true)
class V2NIMChatroomMessageListOption {
  /// 消息查询方向, 默认为V2NIMMessageQueryDirection.V2NIM_QUERY_DIRECTION_DESC
  V2NIMMessageQueryDirection direction =
      V2NIMMessageQueryDirection.V2NIM_QUERY_DIRECTION_DESC;

  /// 根据消息类型查询消息，为null或空列表，则表示查询所有消息类型
  List<NIMMessageType>? messageTypes;

  /// 消息查询开始时间，首次传0，单位毫秒
  int? beginTime;

  /// 每次查询条数
  int? limit;

  V2NIMChatroomMessageListOption(
      {this.direction = V2NIMMessageQueryDirection.V2NIM_QUERY_DIRECTION_DESC,
      this.messageTypes,
      this.beginTime,
      this.limit});

  Map<String, dynamic> toJson() => _$V2NIMChatroomMessageListOptionToJson(this);

  factory V2NIMChatroomMessageListOption.fromJson(Map<String, dynamic> json) =>
      _$V2NIMChatroomMessageListOptionFromJson(json);
}

enum V2NIMMessageQueryDirection {
  /// 按时间戳降序查询
  @JsonValue(0)
  V2NIM_QUERY_DIRECTION_DESC,

  /// 按时间戳升序查询
  @JsonValue(1)
  V2NIM_QUERY_DIRECTION_ASC,
}

///聊天室成员角色变更参数
@JsonSerializable(explicitToJson: true)
class V2NIMChatroomMemberRoleUpdateParams {
  /// 设置的成员角色
  V2NIMChatroomMemberRole? memberRole;

  /// 设置的成员等级
  int? memberLevel;

  /// 设置的通知扩展字段
  String? notificationExtension;

  V2NIMChatroomMemberRoleUpdateParams(
      {this.memberRole, this.memberLevel, this.notificationExtension});

  Map<String, dynamic> toJson() =>
      _$V2NIMChatroomMemberRoleUpdateParamsToJson(this);

  factory V2NIMChatroomMemberRoleUpdateParams.fromJson(
          Map<String, dynamic> json) =>
      _$V2NIMChatroomMemberRoleUpdateParamsFromJson(json);
}

///聊天室信息更新参数
@JsonSerializable(explicitToJson: true)
class V2NIMChatroomUpdateParams {
  /// 聊天室名称
  /// 为空表示不更新
  /// 不能为空串"", 返回参数错误
  String? roomName;

  /// 聊天室公告
  /// 为空表示不更新
  String? announcement;

  /// 聊天室直播地址
  String? liveUrl;

  /// 聊天室扩展字段
  /// 为空表示不更新
  /// 长度限制：4096字节
  String? serverExtension;

  /// 是否需要通知
  /// 默认为true
  bool? notificationEnabled;

  /// 本次操作生成的通知中的扩展字段
  String? notificationExtension;

  V2NIMChatroomUpdateParams(
      {this.roomName,
      this.announcement,
      this.liveUrl,
      this.serverExtension,
      this.notificationEnabled,
      this.notificationExtension});

  Map<String, dynamic> toJson() => _$V2NIMChatroomUpdateParamsToJson(this);

  factory V2NIMChatroomUpdateParams.fromJson(Map<String, dynamic> json) =>
      _$V2NIMChatroomUpdateParamsFromJson(json);
}

/// 聊天室更新自己的成员参数
@JsonSerializable(explicitToJson: true)
class V2NIMChatroomSelfMemberUpdateParams {
  /// 聊天室显示的昵称
  /// 为空表示不更新
  /// 不能为空串"", 返回参数错误
  String? roomNick;

  /// 头像
  /// 为空表示不更新
  String? roomAvatar;

  /// 成员扩展字段
  /// 为空表示不更新
  /// 长度限制：4096字节
  String? serverExtension;

  /// 是否需要通知
  /// 默认为true
  bool? notificationEnabled;

  /// 本次操作生成的通知中的扩展字段
  String? notificationExtension;

  /// 更新信息持久化，只针对固定成员身份生效
  bool? persistence;

  V2NIMChatroomSelfMemberUpdateParams(
      {this.roomNick,
      this.roomAvatar,
      this.serverExtension,
      this.notificationEnabled,
      this.notificationExtension,
      this.persistence});

  Map<String, dynamic> toJson() =>
      _$V2NIMChatroomSelfMemberUpdateParamsToJson(this);

  factory V2NIMChatroomSelfMemberUpdateParams.fromJson(
          Map<String, dynamic> json) =>
      _$V2NIMChatroomSelfMemberUpdateParamsFromJson(json);
}

///聊天室标签临时禁言参数
@JsonSerializable(explicitToJson: true)
class V2NIMChatroomTagTempChatBannedParams {
  /// 禁言的tag
  String? targetTag;

  /// 消息的目标标签表达式，标签表达式
  String? notifyTargetTags;

  /// 禁言时长
  int? duration;

  /// 是否需要通知
  /// 默认为true
  bool? notificationEnabled;

  /// 本次操作生成的通知中的扩展字段
  String? notificationExtension;

  V2NIMChatroomTagTempChatBannedParams(
      {this.targetTag,
      this.notifyTargetTags,
      this.duration,
      this.notificationEnabled,
      this.notificationExtension});

  Map<String, dynamic> toJson() =>
      _$V2NIMChatroomTagTempChatBannedParamsToJson(this);

  factory V2NIMChatroomTagTempChatBannedParams.fromJson(
          Map<String, dynamic> json) =>
      _$V2NIMChatroomTagTempChatBannedParamsFromJson(json);
}

///根据tag查询成员参数
@JsonSerializable(explicitToJson: true)
class V2NIMChatroomTagMemberOption {
  /// 查询的tag
  String? tag;

  /// 查询起始时间，倒序查询
  /// 为0，表示从当前时间往前查询
  String? pageToken;

  /// 偏移量
  /// 首次传""，后续查询传前一次返回的pageToken
  int? limit;

  V2NIMChatroomTagMemberOption({this.tag, this.pageToken, this.limit});

  Map<String, dynamic> toJson() => _$V2NIMChatroomTagMemberOptionToJson(this);

  factory V2NIMChatroomTagMemberOption.fromJson(Map<String, dynamic> json) =>
      _$V2NIMChatroomTagMemberOptionFromJson(json);
}

///更新聊天室标签信息
@JsonSerializable(explicitToJson: true)
class V2NIMChatroomTagsUpdateParams {
  /// 标签，可以设置多个，json_array格式
  List<String>? tags;

  /// 消息的目标标签表达式，标签表达式
  String? notifyTargetTags;

  /// 是否需要通知
  /// 默认为true
  bool? notificationEnabled;

  /// 本次操作生成的通知中的扩展字段
  String? notificationExtension;

  V2NIMChatroomTagsUpdateParams(
      {this.tags,
      this.notifyTargetTags,
      this.notificationEnabled,
      this.notificationExtension});

  Map<String, dynamic> toJson() => _$V2NIMChatroomTagsUpdateParamsToJson(this);

  factory V2NIMChatroomTagsUpdateParams.fromJson(Map<String, dynamic> json) =>
      _$V2NIMChatroomTagsUpdateParamsFromJson(json);
}

/// 根据tag查询消息参数
@JsonSerializable(explicitToJson: true)
class V2NIMChatroomTagMessageOption {
  /// 查询的tags，为空，或者size为0，返回参数错误
  List<String>? tags;

  /// 根据消息类型查询消息，为null或空列表，则表示查询所有消息类型
  List<NIMMessageType>? messageTypes;

  /// 消息查询开始时间，首次传0，单位毫秒
  int? beginTime;

  /// 消息查询结束时间，默认当前时间，单位毫秒
  int? endTime;

  /// 每次查询条数，必须大于 0，小于等于0报参数错误
  int? limit;

  /// 消息查询方向，默认为 V2NIMMessageQueryDirection.V2NIM_QUERY_DIRECTION_DESC
  V2NIMMessageQueryDirection? direction;

  V2NIMChatroomTagMessageOption(
      {this.tags,
      this.messageTypes,
      this.beginTime,
      this.endTime,
      this.limit,
      this.direction});

  Map<String, dynamic> toJson() => _$V2NIMChatroomTagMessageOptionToJson(this);

  factory V2NIMChatroomTagMessageOption.fromJson(Map<String, dynamic> json) =>
      _$V2NIMChatroomTagMessageOptionFromJson(json);
}

//成员角色更新
@JsonSerializable(explicitToJson: true)
class ChatroomMemberRoleUpdatedEvent {
  int instanceId;

  V2NIMChatroomMemberRole? previousRole;

  /// 成员信息
  @JsonKey(fromJson: v2NIMChatroomMemberFromJson)
  V2NIMChatroomMember? member;

  ChatroomMemberRoleUpdatedEvent(
      {required this.instanceId, this.previousRole, this.member});

  factory ChatroomMemberRoleUpdatedEvent.fromJson(Map<String, dynamic> json) =>
      _$ChatroomMemberRoleUpdatedEventFromJson(json);

  Map<String, dynamic> toJson() => _$ChatroomMemberRoleUpdatedEventToJson(this);
}

///自己的临时禁言状态变更
@JsonSerializable(explicitToJson: true)
class SelfTempChatBannedUpdatedEvent {
  int instanceId;
  bool tempChatBanned;
  int tempChatBannedDuration;
  SelfTempChatBannedUpdatedEvent(
      {required this.instanceId,
      required this.tempChatBanned,
      required this.tempChatBannedDuration});

  factory SelfTempChatBannedUpdatedEvent.fromJson(Map<String, dynamic> json) =>
      _$SelfTempChatBannedUpdatedEventFromJson(json);

  Map<String, dynamic> toJson() => _$SelfTempChatBannedUpdatedEventToJson(this);
}

///消息撤回回调
@JsonSerializable(explicitToJson: true)
class ChatroomMessageRevokedNotificationEvent {
  int instanceId;
  String? messageClientId;
  int messageTime;
  ChatroomMessageRevokedNotificationEvent(
      {this.messageClientId,
      required this.messageTime,
      required this.instanceId});

  factory ChatroomMessageRevokedNotificationEvent.fromJson(
          Map<String, dynamic> json) =>
      _$ChatroomMessageRevokedNotificationEventFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ChatroomMessageRevokedNotificationEventToJson(this);
}

List<V2NIMChatroomMessage>? V2NIMChatroomMessageListFromJson(
    List<dynamic>? enterInfos) {
  return enterInfos
      ?.map((e) =>
          V2NIMChatroomMessage.fromJson((e as Map).cast<String, dynamic>()))
      .toList();
}

@JsonSerializable(explicitToJson: true)
class ChatroomReceiveMessagesEvent {
  int instanceId;

  @JsonKey(fromJson: V2NIMChatroomMessageListFromJson)
  List<V2NIMChatroomMessage>? messages;

  ChatroomReceiveMessagesEvent({required this.instanceId, this.messages});

  factory ChatroomReceiveMessagesEvent.fromJson(Map<String, dynamic> json) =>
      _$ChatroomReceiveMessagesEventFromJson(json);

  Map<String, dynamic> toJson() => _$ChatroomReceiveMessagesEventToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ChatroomSendMessageEvent {
  int instanceId;
  @JsonKey(fromJson: V2NIMChatroomMessageFromJson)
  V2NIMChatroomMessage? message;
  ChatroomSendMessageEvent({required this.instanceId, this.message});

  factory ChatroomSendMessageEvent.fromJson(Map<String, dynamic> json) =>
      _$ChatroomSendMessageEventFromJson(json);

  Map<String, dynamic> toJson() => _$ChatroomSendMessageEventToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ChatroomMemberEnterEvent {
  int instanceId;

  @JsonKey(fromJson: v2NIMChatroomMemberFromJson)
  V2NIMChatroomMember? member;

  ChatroomMemberEnterEvent({required this.instanceId, this.member});

  factory ChatroomMemberEnterEvent.fromJson(Map<String, dynamic> json) =>
      _$ChatroomMemberEnterEventFromJson(json);

  Map<String, dynamic> toJson() => _$ChatroomMemberEnterEventToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ChatroomMemberExitEvent {
  int instanceId;

  String accountId;

  ChatroomMemberExitEvent({required this.instanceId, required this.accountId});

  factory ChatroomMemberExitEvent.fromJson(Map<String, dynamic> json) =>
      _$ChatroomMemberExitEventFromJson(json);

  Map<String, dynamic> toJson() => _$ChatroomMemberExitEventToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ChatroomMemberInfoUpdatedEvent {
  int instanceId;

  @JsonKey(fromJson: v2NIMChatroomMemberFromJson)
  V2NIMChatroomMember? member;

  ChatroomMemberInfoUpdatedEvent({required this.instanceId, this.member});

  factory ChatroomMemberInfoUpdatedEvent.fromJson(Map<String, dynamic> json) =>
      _$ChatroomMemberInfoUpdatedEventFromJson(json);

  Map<String, dynamic> toJson() => _$ChatroomMemberInfoUpdatedEventToJson(this);
}

@JsonSerializable(explicitToJson: true)
class SelfChatBannedUpdatedEvent {
  int instanceId;

  bool chatBanned;

  SelfChatBannedUpdatedEvent(
      {required this.instanceId, required this.chatBanned});

  factory SelfChatBannedUpdatedEvent.fromJson(Map<String, dynamic> json) =>
      _$SelfChatBannedUpdatedEventFromJson(json);

  Map<String, dynamic> toJson() => _$SelfChatBannedUpdatedEventToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ChatroomInfoUpdatedEvent {
  int instanceId;

  @JsonKey(fromJson: v2NIMChatroomInfoFromJson)
  V2NIMChatroomInfo? info;

  ChatroomInfoUpdatedEvent({required this.instanceId, this.info});

  factory ChatroomInfoUpdatedEvent.fromJson(Map<String, dynamic> json) =>
      _$ChatroomInfoUpdatedEventFromJson(json);

  Map<String, dynamic> toJson() => _$ChatroomInfoUpdatedEventToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ChatroomChatBannedUpdatedEvent {
  int instanceId;

  bool chatBanned;

  ChatroomChatBannedUpdatedEvent(
      {required this.instanceId, required this.chatBanned});

  factory ChatroomChatBannedUpdatedEvent.fromJson(Map<String, dynamic> json) =>
      _$ChatroomChatBannedUpdatedEventFromJson(json);

  Map<String, dynamic> toJson() => _$ChatroomChatBannedUpdatedEventToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ChatroomTagsUpdatedEvent {
  int instanceId;

  List<String> tags;

  ChatroomTagsUpdatedEvent({required this.instanceId, required this.tags});

  factory ChatroomTagsUpdatedEvent.fromJson(Map<String, dynamic> json) =>
      _$ChatroomTagsUpdatedEventFromJson(json);

  Map<String, dynamic> toJson() => _$ChatroomTagsUpdatedEventToJson(this);
}

///聊天室通知消息附件
@JsonSerializable(explicitToJson: true)
class V2NIMChatroomNotificationAttachment extends NIMMessageAttachment {
  /// 获取通知类型
  V2NIMChatroomMessageNotificationType? type;

  /// 获取被操作的成员账号列表
  List<String>? targetIds;

  /// 获取被操作成员的昵称列表
  List<String>? targetNicks;

  /// 获取被操作标签
  String? targetTag;

  /// 获取操作者
  String? operatorId;

  /// 获取操作者昵称
  String? operatorNick;

  /// 获取扩展字段
  String? notificationExtension;

  /// 获取更新后的标签，通知类型： 325存在这个字段
  List<String>? tags;

  V2NIMChatroomNotificationAttachment({
    this.type,
    this.tags,
    this.notificationExtension,
    this.targetIds,
    this.operatorId,
    this.operatorNick,
    this.targetNicks,
    this.targetTag,
  });

  factory V2NIMChatroomNotificationAttachment.fromJson(
      Map<String, dynamic> json) {
    final type = $enumDecodeNullable(
        _$V2NIMChatroomMessageNotificationTypeEnumMap, json['type']);

    switch (type) {
      case V2NIMChatroomMessageNotificationType
            .V2NIM_CHATROOM_MESSAGE_NOTIFICATION_TYPE_MEMBER_ENTER:
        return V2NIMChatroomMemberEnterNotificationAttachment.fromJson(json);
      case V2NIMChatroomMessageNotificationType
            .V2NIM_CHATROOM_MESSAGE_NOTIFICATION_TYPE_MEMBER_CHAT_BANNED_ADDED:
        return V2NIMChatroomChatBannedNotificationAttachment.fromJson(json);
      case V2NIMChatroomMessageNotificationType
            .V2NIM_CHATROOM_MESSAGE_NOTIFICATION_TYPE_MEMBER_CHAT_BANNED_REMOVED:
        return V2NIMChatroomChatBannedNotificationAttachment.fromJson(json);
      case V2NIMChatroomMessageNotificationType
            .V2NIM_CHATROOM_MESSAGE_NOTIFICATION_TYPE_MEMBER_TEMP_CHAT_BANNED_ADDED:
        return V2NIMChatroomChatBannedNotificationAttachment.fromJson(json);
      case V2NIMChatroomMessageNotificationType
            .V2NIM_CHATROOM_MESSAGE_NOTIFICATION_TYPE_MEMBER_TEMP_CHAT_BANNED_REMOVED:
        return V2NIMChatroomChatBannedNotificationAttachment.fromJson(json);
      case V2NIMChatroomMessageNotificationType
            .V2NIM_CHATROOM_MESSAGE_NOTIFICATION_TYPE_TAG_TEMP_CHAT_BANNED_ADDED:
        return V2NIMChatroomChatBannedNotificationAttachment.fromJson(json);
      case V2NIMChatroomMessageNotificationType
            .V2NIM_CHATROOM_MESSAGE_NOTIFICATION_TYPE_TAG_TEMP_CHAT_BANNED_REMOVED:
        return V2NIMChatroomChatBannedNotificationAttachment.fromJson(json);
      case V2NIMChatroomMessageNotificationType
            .V2NIM_CHATROOM_MESSAGE_NOTIFICATION_TYPE_QUEUE_CHANGE:
        return V2NIMChatroomQueueNotificationAttachment.fromJson(json);
      case V2NIMChatroomMessageNotificationType
            .V2NIM_CHATROOM_MESSAGE_NOTIFICATION_TYPE_ROLE_UPDATE:
        return V2NIMChatroomMemberRoleUpdateAttachment.fromJson(json);
      case V2NIMChatroomMessageNotificationType
            .V2NIM_CHATROOM_MESSAGE_NOTIFICATION_TYPE_MESSAGE_REVOKE:
        return V2NIMChatroomMessageRevokeNotificationAttachment.fromJson(json);
      default:
        break;
    }
    return _$V2NIMChatroomNotificationAttachmentFromJson(json);
  }

  Map<String, dynamic> toJson() =>
      _$V2NIMChatroomNotificationAttachmentToJson(this);
}

///聊天室禁言通知附件
@JsonSerializable(explicitToJson: true)
class V2NIMChatroomChatBannedNotificationAttachment
    extends V2NIMChatroomNotificationAttachment {
  /// 获取是否禁言
  /// 是否禁言
  bool? chatBanned;

  /// 获取是否临时禁言
  /// 是否临时禁言
  bool? tempChatBanned;

  /// 获取临时禁言的时长,单位：秒
  /// 临时禁言的时长,单位：秒
  int? tempChatBannedDuration;

  V2NIMChatroomChatBannedNotificationAttachment({
    this.chatBanned,
    this.tempChatBanned,
    this.tempChatBannedDuration,
  });

  factory V2NIMChatroomChatBannedNotificationAttachment.fromJson(
          Map<String, dynamic> json) =>
      _$V2NIMChatroomChatBannedNotificationAttachmentFromJson(json);

  Map<String, dynamic> toJson() =>
      _$V2NIMChatroomChatBannedNotificationAttachmentToJson(this);
}

///聊天室进入通知附件
@JsonSerializable(explicitToJson: true)
class V2NIMChatroomMemberEnterNotificationAttachment
    extends V2NIMChatroomNotificationAttachment {
  /// 获取成员是否被禁言
  /// 管理员，普通成员，普通有客户，相同账号下次再次进入聊天室， 会保留之前设置的状态
  bool? chatBanned;

  /// 获取成员是否被临时禁言
  /// 是否临时禁言
  bool? tempChatBanned;

  /// 获取成员临时禁言时长,单位：秒
  /// 临时禁言的时长,单位：秒
  int? tempChatBannedDuration;

  V2NIMChatroomMemberEnterNotificationAttachment(
      {this.tempChatBannedDuration, this.chatBanned, this.tempChatBanned});

  factory V2NIMChatroomMemberEnterNotificationAttachment.fromJson(
          Map<String, dynamic> json) =>
      _$V2NIMChatroomMemberEnterNotificationAttachmentFromJson(json);

  Map<String, dynamic> toJson() =>
      _$V2NIMChatroomMemberEnterNotificationAttachmentToJson(this);
}

/// 聊天室成员角色变更通知附件
@JsonSerializable(explicitToJson: true)
class V2NIMChatroomMemberRoleUpdateAttachment
    extends V2NIMChatroomNotificationAttachment {
  ///  获取变更前的角色类型
  V2NIMChatroomMemberRole? previousRole;

  /// 获取当前的成员信息
  @JsonKey(fromJson: v2NIMChatroomMemberFromJson)
  V2NIMChatroomMember? currentMember;

  V2NIMChatroomMemberRoleUpdateAttachment({
    this.previousRole,
    this.currentMember,
  });

  factory V2NIMChatroomMemberRoleUpdateAttachment.fromJson(
          Map<String, dynamic> json) =>
      _$V2NIMChatroomMemberRoleUpdateAttachmentFromJson(json);

  Map<String, dynamic> toJson() =>
      _$V2NIMChatroomMemberRoleUpdateAttachmentToJson(this);
}

///聊天室消息撤回通知附件
@JsonSerializable(explicitToJson: true)
class V2NIMChatroomMessageRevokeNotificationAttachment
    extends V2NIMChatroomNotificationAttachment {
  ///  消息撤回 ID
  String? messageClientId;

  ///消息撤回时间
  int? messageTime;

  V2NIMChatroomMessageRevokeNotificationAttachment({
    this.messageClientId,
    this.messageTime,
  });

  factory V2NIMChatroomMessageRevokeNotificationAttachment.fromJson(
          Map<String, dynamic> json) =>
      _$V2NIMChatroomMessageRevokeNotificationAttachmentFromJson(json);

  Map<String, dynamic> toJson() =>
      _$V2NIMChatroomMessageRevokeNotificationAttachmentToJson(this);
}

List<V2NIMChatroomQueueElement>? V2NIMChatroomQueueElementListFromJson(
    List<dynamic>? enterInfos) {
  return enterInfos
      ?.map((e) => V2NIMChatroomQueueElement.fromJson(
          (e as Map).cast<String, dynamic>()))
      .toList();
}

///聊天室队列变更通知附件
@JsonSerializable(explicitToJson: true)
class V2NIMChatroomQueueNotificationAttachment
    extends V2NIMChatroomNotificationAttachment {
  ///获取队列变更的内容
  @JsonKey(fromJson: V2NIMChatroomQueueElementListFromJson)
  List<V2NIMChatroomQueueElement>? elements;

  ///队列更新类型
  V2NIMChatroomQueueChangeType? queueChangeType;

  V2NIMChatroomQueueNotificationAttachment(
      {this.elements, this.queueChangeType});

  factory V2NIMChatroomQueueNotificationAttachment.fromJson(
          Map<String, dynamic> json) =>
      _$V2NIMChatroomQueueNotificationAttachmentFromJson(json);

  Map<String, dynamic> toJson() =>
      _$V2NIMChatroomQueueNotificationAttachmentToJson(this);
}

enum V2NIMChatroomMessageNotificationType {
  /// 成员进入聊天室
  /// 映射event_id: 301
  @JsonValue(0)
  V2NIM_CHATROOM_MESSAGE_NOTIFICATION_TYPE_MEMBER_ENTER,

  /// 成员退出聊天室
  /// 映射event_id: 302
  @JsonValue(1)
  V2NIM_CHATROOM_MESSAGE_NOTIFICATION_TYPE_MEMBER_EXIT,

  /// 成员被加入黑名单
  /// 映射event_id: 303
  /// 自己会直接被踢， 收不到， 只会收到其他人
  @JsonValue(2)
  V2NIM_CHATROOM_MESSAGE_NOTIFICATION_TYPE_MEMBER_BLOCK_ADDED,

  /// 成员被移除黑名单
  /// 映射event_id: 304
  @JsonValue(3)
  V2NIM_CHATROOM_MESSAGE_NOTIFICATION_TYPE_MEMBER_BLOCK_REMOVED,

  /// 成员被禁言
  /// 映射event_id: 305
  @JsonValue(4)
  V2NIM_CHATROOM_MESSAGE_NOTIFICATION_TYPE_MEMBER_CHAT_BANNED_ADDED,

  /// 成员取消禁言
  /// 映射event_id: 306
  @JsonValue(5)
  V2NIM_CHATROOM_MESSAGE_NOTIFICATION_TYPE_MEMBER_CHAT_BANNED_REMOVED,

  /// 聊天室信息更新
  /// 映射event_id: 312
  @JsonValue(6)
  V2NIM_CHATROOM_MESSAGE_NOTIFICATION_TYPE_ROOM_INFO_UPDATED,

  /// 成员被踢
  /// 映射event_id: 313
  @JsonValue(7)
  V2NIM_CHATROOM_MESSAGE_NOTIFICATION_TYPE_MEMBER_KICKED,

  /// 成员临时  /// 映射event_id: 314
  @JsonValue(8)
  V2NIM_CHATROOM_MESSAGE_NOTIFICATION_TYPE_MEMBER_TEMP_CHAT_BANNED_ADDED,

  /// 成员解除临时禁言
  /// 映射event_id: 315
  @JsonValue(9)
  V2NIM_CHATROOM_MESSAGE_NOTIFICATION_TYPE_MEMBER_TEMP_CHAT_BANNED_REMOVED,

  /// 成员信息更新（nick/avatar/extension）
  /// 映射event_id: 316
  @JsonValue(10)
  V2NIM_CHATROOM_MESSAGE_NOTIFICATION_TYPE_MEMBER_INFO_UPDATED,

  /// 队列有变更
  /// 映射event_id: 317
  /// 映射event_id: 320: 麦序队列中有批量变更，发生在元素提交者离开聊天室或者从聊天室异常掉线时
  /// 映射event_id: 324: 麦序队列中有批量添加
  @JsonValue(11)
  V2NIM_CHATROOM_MESSAGE_NOTIFICATION_TYPE_QUEUE_CHANGE,

  /// 聊天室被禁言，仅创建者和管理员可以发消息
  /// 映射event_id: 318
  @JsonValue(12)
  V2NIM_CHATROOM_MESSAGE_NOTIFICATION_TYPE_CHAT_BANNED,

  /// 聊天室解除禁言
  /// 映射event_id: 319
  @JsonValue(13)
  V2NIM_CHATROOM_MESSAGE_NOTIFICATION_TYPE_CHAT_BANNED_REMOVED,

  /// 聊天室新增标签禁言，包括的字段是muteDuration、targetTag、operator、opeNick字段
  /// 映射event_id: 321
  @JsonValue(14)
  V2NIM_CHATROOM_MESSAGE_NOTIFICATION_TYPE_TAG_TEMP_CHAT_BANNED_ADDED,

  /// 聊天室移除标签禁言，包括的字段是muteDuration、targetTag、operator、opeNick字段
  /// 映射event_id: 322
  @JsonValue(15)
  V2NIM_CHATROOM_MESSAGE_NOTIFICATION_TYPE_TAG_TEMP_CHAT_BANNED_REMOVED,

  /// 聊天室消息撤回，包括的字段是operator、target、msgTime、msgId、ext字段
  /// 映射event_id: 323
  @JsonValue(16)
  V2NIM_CHATROOM_MESSAGE_NOTIFICATION_TYPE_MESSAGE_REVOKE,

  /// 聊天室标签更新
  /// 映射event_id: 325
  @JsonValue(17)
  V2NIM_CHATROOM_MESSAGE_NOTIFICATION_TYPE_TAGS_UPDATE,

  /// 聊天室成员角色更新
  /// 映射event_id: 326
  @JsonValue(18)
  V2NIM_CHATROOM_MESSAGE_NOTIFICATION_TYPE_ROLE_UPDATE,
}
