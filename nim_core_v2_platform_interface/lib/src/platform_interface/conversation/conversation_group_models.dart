// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:json_annotation/json_annotation.dart';

import '../../../nim_core_v2_platform_interface.dart';

part 'conversation_group_models.g.dart';

///会话分组实现类
@JsonSerializable(explicitToJson: true)
class V2NIMConversationGroup {
  /// 会话分组id
  String groupId;

  /// 会话分组名称
  String? name;

  /// 服务端扩展字段，最大1024字节
  String? serverExtension;

  /// 会话分组创建时间
  int? createTime;

  /// 会话分组更新时间
  int? updateTime;

  V2NIMConversationGroup({
    required this.groupId,
    this.name,
    this.serverExtension,
    this.createTime,
    this.updateTime,
  });

  factory V2NIMConversationGroup.fromJson(Map<String, dynamic> map) =>
      _$V2NIMConversationGroupFromJson(map);

  Map<String, dynamic> toJson() => _$V2NIMConversationGroupToJson(this);
}

NIMError? _nimErrorFromJson(Map? map) {
  if (map != null) {
    return NIMError.fromJson(map.cast<String, dynamic>());
  } else {
    return null;
  }
}

@JsonSerializable(explicitToJson: true)
class V2NIMConversationOperationResult {
  ///会话ID
  String conversationId;

  ///   会话操作结果code
  @JsonKey(fromJson: _nimErrorFromJson)
  NIMError? error;

  V2NIMConversationOperationResult({
    required this.conversationId,
    this.error,
  });

  factory V2NIMConversationOperationResult.fromJson(Map<String, dynamic> map) =>
      _$V2NIMConversationOperationResultFromJson(map);

  Map<String, dynamic> toJson() =>
      _$V2NIMConversationOperationResultToJson(this);
}

V2NIMConversationGroup? V2NIMConversationGroupFromJson(Map? map) {
  if (map != null) {
    return V2NIMConversationGroup.fromJson(map.cast<String, dynamic>());
  } else {
    return null;
  }
}

List<V2NIMConversationOperationResult>?
    V2NIMConversationOperationResultListFromJson(List? list) {
  return list
      ?.map((e) => V2NIMConversationOperationResult.fromJson(
          (e as Map).cast<String, dynamic>()))
      .toList();
}

@JsonSerializable(explicitToJson: true)
class V2NIMConversationGroupResult {
  ///会话分组
  @JsonKey(fromJson: V2NIMConversationGroupFromJson)
  V2NIMConversationGroup? group;

  /// 创建分组时，失败的会话列表
  @JsonKey(fromJson: V2NIMConversationOperationResultListFromJson)
  List<V2NIMConversationOperationResult>? failedList;

  V2NIMConversationGroupResult({this.failedList, this.group});

  factory V2NIMConversationGroupResult.fromJson(Map<String, dynamic> map) =>
      _$V2NIMConversationGroupResultFromJson(map);

  Map<String, dynamic> toJson() => _$V2NIMConversationGroupResultToJson(this);
}

List<NIMConversation>? NIMConversationListFromJson(List? list) {
  return list
      ?.map((e) => NIMConversation.fromJson((e as Map).cast<String, dynamic>()))
      .toList();
}

///会话添加到分组回调 的回调事件
@JsonSerializable(explicitToJson: true)
class ConversationsAddedEvent {
  ///分组ID
  String groupId;

  ///会话列表
  @JsonKey(fromJson: NIMConversationListFromJson)
  List<NIMConversation>? conversations;

  ConversationsAddedEvent({
    required this.groupId,
    this.conversations,
  });

  factory ConversationsAddedEvent.fromJson(Map<String, dynamic> map) =>
      _$ConversationsAddedEventFromJson(map);

  Map<String, dynamic> toJson() => _$ConversationsAddedEventToJson(this);
}

///会话从分组移除回调事件
@JsonSerializable(explicitToJson: true)
class ConversationsRemovedEvent {
  ///分组ID
  String groupId;

  ///会话列表
  List<String> conversationIds;

  ConversationsRemovedEvent({
    required this.groupId,
    required this.conversationIds,
  });

  factory ConversationsRemovedEvent.fromJson(Map<String, dynamic> map) =>
      _$ConversationsRemovedEventFromJson(map);

  Map<String, dynamic> toJson() => _$ConversationsRemovedEventToJson(this);
}
