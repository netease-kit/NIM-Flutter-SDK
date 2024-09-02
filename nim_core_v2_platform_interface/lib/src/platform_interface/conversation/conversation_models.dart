// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.
import 'package:json_annotation/json_annotation.dart';

import '../../../nim_core_v2_platform_interface.dart';
part 'conversation_models.g.dart';

@JsonSerializable(explicitToJson: true)
class NIMConversation {
  /// 会话ID
  String conversationId;

  // 会话类型
  NIMConversationType type;

  // 会话名字
  String? name;

  // 会话头像
  String? avatar;

  // 会话否免打扰 true表示免打扰，false表示非免打扰
  bool mute;

  // 会话是否置顶 true表示置顶，false表示非置顶
  bool stickTop;

  // 获取会话分组id
  List<String>? groupIds;

  // 本地扩展字段
  String? localExtension;

  //获取服务端扩展信息,最大1024字节
  String? serverExtension;

  //获取会话中最新的消息
  @JsonKey(fromJson: _nimLastMessageFromJson)
  NIMLastMessage? lastMessage;

// 会话的未读消息计数
  int? unreadCount;

  int? sortOrder;

  // 会话创建时间
  int createTime;

  // 会话更新时间
  int updateTime;

  NIMConversation(
      {required this.conversationId,
      required this.type,
      this.name,
      this.avatar,
      required this.mute,
      required this.stickTop,
      this.groupIds,
      this.localExtension,
      this.serverExtension,
      this.lastMessage,
      this.unreadCount,
      this.sortOrder,
      required this.createTime,
      required this.updateTime});

  Map<String, dynamic> toJson() => _$NIMConversationToJson(this);
  factory NIMConversation.fromJson(Map<String, dynamic> map) =>
      _$NIMConversationFromJson(map);
}

NIMLastMessage? _nimLastMessageFromJson(Map? map) {
  if (map != null) {
    return NIMLastMessage.fromJson(map.cast<String, dynamic>());
  }
  return null;
}

@JsonSerializable(explicitToJson: true)
class NIMLastMessage {
  //会话最新一条消息状态
  NIMLastMessageState? lastMessageState;

  // 最后一条消息的引用
  @JsonKey(fromJson: _nimMessageReferFromJson)
  NIMMessageRefer? messageRefer;

  //消息类型，状态为消息时有效
  NIMMessageType? messageType;

  //消息子类型，0：表示没有子类型，状态为消息时有效
  int? subType;

  // 消息发送状态，状态为消息时有效
  NIMMessageSendingState? sendingState;

  //撤回时为撤回附言 消息时消息文本内容
  String? text;

//消息附件，状态为消息时有效
  @JsonKey(fromJson: _nimMessageAttachmentFromJson)
  NIMMessageAttachment? attachment;

// 消息撤回者账号，状态为撤回时有效
  String? revokeAccountId;

  //消息撤回类型，状态为撤回时有效
  NIMMessageRevokeType? revokeType;

  //消息服务端扩展
  String? serverExtension;

  //第三方回调扩展字段， 透传字段
  String? callbackExtension;

// 消息发送者名称
  String? senderName;

  NIMLastMessage(
      {this.lastMessageState,
      this.messageRefer,
      this.messageType,
      this.subType,
      this.sendingState,
      this.text,
      this.attachment,
      this.revokeAccountId,
      this.revokeType,
      this.serverExtension,
      this.callbackExtension,
      this.senderName});

  Map<String, dynamic> toJson() => _$NIMLastMessageToJson(this);
  factory NIMLastMessage.fromJson(Map<String, dynamic> map) =>
      _$NIMLastMessageFromJson(map);
}

NIMMessageRefer? _nimMessageReferFromJson(Map? map) {
  if (map != null) {
    return NIMMessageRefer.fromJson(map.cast<String, dynamic>());
  } else {
    return null;
  }
}

NIMMessageAttachment? _nimMessageAttachmentFromJson(Map? map) {
  if (map != null) {
    return NIMMessageAttachment.fromJson(map.cast<String, dynamic>());
  } else {
    return null;
  }
}

@JsonSerializable(explicitToJson: true)
class NIMConversationResult {
  @JsonKey(fromJson: _conversationListFromJson)
  List<NIMConversation>? conversationList;
  int offset;
  bool finished;
  NIMConversationResult(
      {this.conversationList, required this.offset, required this.finished});

  Map<String, dynamic> toJson() => _$NIMConversationResultToJson(this);
  factory NIMConversationResult.fromJson(Map<String, dynamic> map) =>
      _$NIMConversationResultFromJson(map);
}

List<NIMConversation>? _conversationListFromJson(List? list) {
  return list
      ?.map((e) => NIMConversation.fromJson((e as Map).cast<String, dynamic>()))
      .toList();
}

@JsonSerializable(explicitToJson: true)
class NIMConversationFilter {
  List<NIMConversationType>? conversationTypes;
  String? conversationGroupId;
  bool? ignoreMuted;
  NIMConversationFilter(
      {this.conversationTypes, this.conversationGroupId, this.ignoreMuted});
  Map<String, dynamic> toJson() => _$NIMConversationFilterToJson(this);
  factory NIMConversationFilter.fromJson(Map<String, dynamic> map) =>
      _$NIMConversationFilterFromJson(map);
}

@JsonSerializable(explicitToJson: true)
class UnreadChangeFilterResult {
  @JsonKey(fromJson: _nimConversationFilterFromJson)
  NIMConversationFilter? conversationFilter;
  int? unreadCount;
  UnreadChangeFilterResult(
      {required this.conversationFilter, required this.unreadCount});
  Map<String, dynamic> toJson() => _$UnreadChangeFilterResultToJson(this);
  factory UnreadChangeFilterResult.fromJson(Map<String, dynamic> map) =>
      _$UnreadChangeFilterResultFromJson(map);
}

NIMConversationFilter? _nimConversationFilterFromJson(Map? map) {
  if (map != null) {
    return NIMConversationFilter.fromJson(map.cast<String, dynamic>());
  } else {
    return null;
  }
}

@JsonSerializable(explicitToJson: true)
class ReadTimeUpdateResult {
  String conversationId;
  int readTime;
  ReadTimeUpdateResult({required this.conversationId, required this.readTime});
  Map<String, dynamic> toJson() => _$ReadTimeUpdateResultToJson(this);
  factory ReadTimeUpdateResult.fromJson(Map<String, dynamic> map) =>
      _$ReadTimeUpdateResultFromJson(map);
}

@JsonSerializable(explicitToJson: true)
class NIMConversationOperationResult {
  String? conversationId;
  @JsonKey(fromJson: _nimErrorFromJson)
  NIMError? error;
  NIMConversationOperationResult({this.conversationId, this.error});

  Map<String, dynamic> toJson() => _$NIMConversationOperationResultToJson(this);
  factory NIMConversationOperationResult.fromJson(Map<String, dynamic> map) =>
      _$NIMConversationOperationResultFromJson(map);
}

NIMError? _nimErrorFromJson(Map? map) {
  if (map != null) {
    return NIMError.fromJson(map.cast<String, dynamic>());
  } else {
    return null;
  }
}

@JsonSerializable(explicitToJson: true)
class NIMConversationTypeClass {
  NIMConversationType conversationType;
  NIMConversationTypeClass({
    required this.conversationType,
  });

  factory NIMConversationTypeClass.fromJson(Map<String, dynamic> map) =>
      _$NIMConversationTypeClassFromJson(map);

  Map<String, dynamic> toJson() => _$NIMConversationTypeClassToJson(this);

  /// 转换成 int
  int toValue() {
    return _$NIMConversationTypeEnumMap[conversationType]!;
  }

  /// 从 int 转换成枚举
  static NIMConversationType fromEnumInt(int enumInt) {
    return _$NIMConversationTypeEnumMap.entries
        .firstWhere((element) => element.value == enumInt)
        .key;
  }
}

enum NIMLastMessageState {
  //默认
  @JsonValue(0)
  defaultState,
  //已撤回
  @JsonValue(1)
  revoke,
  //客户端填充消息
  @JsonValue(2)
  clientFill
}

enum NIMConversationType {
  @JsonValue(0)
  unknown,

  /// 个人会话
  @JsonValue(1)
  p2p,

  /// 群组会话
  @JsonValue(2)
  team,

  /// 超大群组会话
  @JsonValue(3)
  superTeam,
}

@JsonSerializable(explicitToJson: true)
class NIMConversationOption {
  List<NIMConversationType> conversationTypes;
  bool onlyUnread;
  List<String> conversationGroupIds;

  NIMConversationOption(
      {required this.conversationTypes,
      required this.onlyUnread,
      required this.conversationGroupIds});
  Map<String, dynamic> toJson() => _$NIMConversationOptionToJson(this);
  factory NIMConversationOption.fromJson(Map<String, dynamic> map) =>
      _$NIMConversationOptionFromJson(map);
}

@JsonSerializable(explicitToJson: true)
class NIMConversationUpdate {
  String serverExtension;
  NIMConversationUpdate({required this.serverExtension});
  Map<String, dynamic> toJson() => _$NIMConversationUpdateToJson(this);
  factory NIMConversationUpdate.fromJson(Map<String, dynamic> map) =>
      _$NIMConversationUpdateFromJson(map);
}
