// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:json_annotation/json_annotation.dart';
import 'package:nim_core_v2_platform_interface/nim_core_v2_platform_interface.dart';

part 'topic_models.g.dart';

@JsonSerializable(explicitToJson: true)
class V2NIMTopicRefer {
  /// 话题所属会话 id
  String? conversationId;

  /// 话题 id
  int? topicId;

  /// 话题创建时间
  int? createTime;

  V2NIMTopicRefer({this.conversationId, this.topicId, this.createTime});

  factory V2NIMTopicRefer.fromJson(Map<String, dynamic> map) =>
      _$V2NIMTopicReferFromJson(map);

  Map<String, dynamic> toJson() => _$V2NIMTopicReferToJson(this);
}

@JsonSerializable(explicitToJson: true)
class V2NIMTopic extends V2NIMTopicRefer {
  /// 话题名称
  String? topicName;

  /// 话题根消息客户端 id
  String? messageClientId;

  /// 话题根消息服务端 id
  String? messageServerId;

  /// 话题根消息时间
  int? messageTime;

  /// 服务端扩展字段
  String? serverExtension;

  /// 话题更新时间
  int? updateTime;

  ///iOS 独有的通信字段
  String? data;

  V2NIMTopic({
    super.conversationId,
    super.topicId,
    super.createTime,
    this.topicName,
    this.messageClientId,
    this.messageServerId,
    this.messageTime,
    this.serverExtension,
    this.updateTime,
    this.data,
  });

  @override
  factory V2NIMTopic.fromJson(Map<String, dynamic> map) =>
      _$V2NIMTopicFromJson(map);

  @override
  Map<String, dynamic> toJson() => _$V2NIMTopicToJson(this);
}

@JsonSerializable(explicitToJson: true)
class V2NIMUpdateTopicParams {
  /// 待更新的话题
  @JsonKey(fromJson: nimTopicFromJson)
  V2NIMTopic? topic;

  /// 话题名称
  String? topicName;

  /// 服务端扩展字段
  String? serverExtension;

  V2NIMUpdateTopicParams({this.topic, this.topicName, this.serverExtension});

  factory V2NIMUpdateTopicParams.fromJson(Map<String, dynamic> map) =>
      _$V2NIMUpdateTopicParamsFromJson(map);

  Map<String, dynamic> toJson() => _$V2NIMUpdateTopicParamsToJson(this);
}

@JsonSerializable(explicitToJson: true)
class V2NIMRemoveTopicsParams {
  /// 待删除话题列表
  @JsonKey(fromJson: nimTopicListFromJson)
  List<V2NIMTopic>? topicList;

  V2NIMRemoveTopicsParams({this.topicList});

  factory V2NIMRemoveTopicsParams.fromJson(Map<String, dynamic> map) =>
      _$V2NIMRemoveTopicsParamsFromJson(map);

  Map<String, dynamic> toJson() => _$V2NIMRemoveTopicsParamsToJson(this);
}

@JsonSerializable(explicitToJson: true)
class V2NIMCreateTopicParams {
  /// 话题名称
  String? topicName;

  /// 服务端扩展字段
  String? serverExtension;

  V2NIMCreateTopicParams({this.topicName, this.serverExtension});

  factory V2NIMCreateTopicParams.fromJson(Map<String, dynamic> map) =>
      _$V2NIMCreateTopicParamsFromJson(map);

  Map<String, dynamic> toJson() => _$V2NIMCreateTopicParamsToJson(this);
}

@JsonSerializable(explicitToJson: true)
class V2NIMSendTopicMessageParams {
  /// 原有消息发送参数
  @JsonKey(fromJson: nimSendMessageParamsFromJson)
  NIMSendMessageParams? sendMessageParams;

  /// 创建话题参数，仅在新建话题发送时生效
  @JsonKey(fromJson: nimCreateTopicParamsFromJson)
  V2NIMCreateTopicParams? createTopicParams;

  V2NIMSendTopicMessageParams({this.sendMessageParams, this.createTopicParams});

  factory V2NIMSendTopicMessageParams.fromJson(Map<String, dynamic> map) =>
      _$V2NIMSendTopicMessageParamsFromJson(map);

  Map<String, dynamic> toJson() => _$V2NIMSendTopicMessageParamsToJson(this);
}

@JsonSerializable(explicitToJson: true)
class V2NIMTopicListOption {
  /// 会话 id
  String? conversationId;

  /// 查询开始时间
  int? beginTime;

  /// 查询结束时间
  int? endTime;

  /// 分页 token
  String? nextToken;

  /// 分页大小
  int? limit;

  /// 查询方向
  NIMQueryDirection? direction;

  V2NIMTopicListOption({
    this.conversationId,
    this.beginTime,
    this.endTime,
    this.nextToken,
    this.limit,
    this.direction,
  });

  factory V2NIMTopicListOption.fromJson(Map<String, dynamic> map) =>
      _$V2NIMTopicListOptionFromJson(map);

  Map<String, dynamic> toJson() => _$V2NIMTopicListOptionToJson(this);
}

@JsonSerializable(explicitToJson: true)
class V2NIMTopicListResult {
  /// 话题列表
  @JsonKey(fromJson: nimTopicListFromJson)
  List<V2NIMTopic>? topicList;

  /// 下一页 token
  String? nextToken;

  /// 是否还有更多数据
  bool? hasMore;

  V2NIMTopicListResult({this.topicList, this.nextToken, this.hasMore});

  factory V2NIMTopicListResult.fromJson(Map<String, dynamic> map) =>
      _$V2NIMTopicListResultFromJson(map);

  Map<String, dynamic> toJson() => _$V2NIMTopicListResultToJson(this);
}

@JsonSerializable(explicitToJson: true)
class V2NIMTopicMessageListOption {
  /// 目标话题
  @JsonKey(fromJson: nimTopicFromJson)
  V2NIMTopic? topic;

  /// 查询开始时间
  int? beginTime;

  /// 查询结束时间
  int? endTime;

  /// 锚点消息
  @JsonKey(fromJson: nimMessageFromJson)
  NIMMessage? anchorMessage;

  /// 分页大小
  int? limit;

  /// 查询方向
  NIMQueryDirection? direction;

  /// 排序方式
  NIMSortOrder? sortOrder;

  V2NIMTopicMessageListOption({
    this.topic,
    this.beginTime,
    this.endTime,
    this.anchorMessage,
    this.limit,
    this.direction,
    this.sortOrder,
  });

  factory V2NIMTopicMessageListOption.fromJson(Map<String, dynamic> map) =>
      _$V2NIMTopicMessageListOptionFromJson(map);

  Map<String, dynamic> toJson() => _$V2NIMTopicMessageListOptionToJson(this);
}

@JsonSerializable(explicitToJson: true)
class V2NIMTopicMessageListResult {
  /// 回复消息列表
  @JsonKey(fromJson: nimMessageListFromJson)
  List<NIMMessage>? replyList;

  /// 是否还有更多数据
  bool? hasMore;

  /// 返回结果中的锚点消息
  @JsonKey(fromJson: nimMessageFromJson)
  NIMMessage? anchorMessage;

  V2NIMTopicMessageListResult({
    this.replyList,
    this.hasMore,
    this.anchorMessage,
  });

  factory V2NIMTopicMessageListResult.fromJson(Map<String, dynamic> map) =>
      _$V2NIMTopicMessageListResultFromJson(map);

  Map<String, dynamic> toJson() => _$V2NIMTopicMessageListResultToJson(this);
}

V2NIMTopic? nimTopicFromJson(Map? map) {
  if (map != null) {
    return V2NIMTopic.fromJson(map.cast<String, dynamic>());
  }
  return null;
}

V2NIMTopicRefer? nimTopicReferFromJson(Map? map) {
  if (map != null) {
    return V2NIMTopicRefer.fromJson(map.cast<String, dynamic>());
  }
  return null;
}

V2NIMCreateTopicParams? nimCreateTopicParamsFromJson(Map? map) {
  if (map != null) {
    return V2NIMCreateTopicParams.fromJson(map.cast<String, dynamic>());
  }
  return null;
}

NIMSendMessageParams? nimSendMessageParamsFromJson(Map? map) {
  if (map != null) {
    return NIMSendMessageParams.fromJson(map.cast<String, dynamic>());
  }
  return null;
}

List<V2NIMTopic>? nimTopicListFromJson(List<dynamic>? list) {
  return list
      ?.map((e) => V2NIMTopic.fromJson((e as Map).cast<String, dynamic>()))
      .toList();
}

List<V2NIMTopicRefer>? nimTopicReferListFromJson(List<dynamic>? list) {
  return list
      ?.map((e) => V2NIMTopicRefer.fromJson((e as Map).cast<String, dynamic>()))
      .toList();
}

List<NIMMessage>? nimMessageListFromJson(List<dynamic>? list) {
  return list
      ?.map((e) => NIMMessage.fromJson((e as Map).cast<String, dynamic>()))
      .toList();
}
