// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:json_annotation/json_annotation.dart';

import 'package:nim_core_v2_platform_interface/nim_core_v2_platform_interface.dart';

part 'chatroom_queue.g.dart';

///聊天室队列元素类
@JsonSerializable(explicitToJson: true)
class V2NIMChatroomQueueElement {
  /// 队列元素的Key，长度字节
  /// 必填字段
  String? key;

  /// 队列元素的Value
  /// 必填字段
  String? value;

  /// 该元素所属于的账号
  /// 选填字段
  String? accountId;

  /// 该元素所属于的账号的昵称
  /// 选填字段
  String? nick;

  /// 其他的扩展字段(保留字段，目前无用)
  /// 选填字段
  /// JSON结构
  String? extension;

  V2NIMChatroomQueueElement({
    this.key,
    this.value,
    this.accountId,
    this.nick,
    this.extension,
  });

  factory V2NIMChatroomQueueElement.fromJson(Map<String, dynamic> json) =>
      _$V2NIMChatroomQueueElementFromJson(json);

  Map<String, dynamic> toJson() => _$V2NIMChatroomQueueElementToJson(this);
}

V2NIMChatroomQueueElement? V2NIMChatroomQueueElementFromJson(Map? map) {
  if (map != null) {
    return V2NIMChatroomQueueElement.fromJson(map.cast<String, dynamic>());
  }
  return null;
}

///聊天室队列变更类型
enum V2NIMChatroomQueueChangeType {
  /// 未知
  @JsonValue(0)
  V2NIM_CHATROOM_QUEUE_CHANGE_TYPE_UNKNOWN,

  /// 新增队列元素
  @JsonValue(1)
  V2NIM_CHATROOM_QUEUE_CHANGE_TYPE_OFFER,

  /// 移除队列元素
  @JsonValue(2)
  V2NIM_CHATROOM_QUEUE_CHANGE_TYPE_POLL,

  /// 清空所有元素
  @JsonValue(3)
  V2NIM_CHATROOM_QUEUE_CHANGE_TYPE_DROP,

  /// 部分清理
  @JsonValue(4)
  V2NIM_CHATROOM_QUEUE_CHANGE_TYPE_PARTCLEAR,

  /// 批量更新
  @JsonValue(5)
  V2NIM_CHATROOM_QUEUE_CHANGE_TYPE_BATCH_UPDATE,

  /// 批量添加
  @JsonValue(6)
  V2NIM_CHATROOM_QUEUE_CHANGE_TYPE_BATCH_OFFER
}

///聊天室队列新增或者更新队列元素参数
@JsonSerializable(explicitToJson: true)
class V2NIMChatroomQueueOfferParams {
  /// 元素的唯一key
  /// 长度限制: 128字节
  /// 如果队列key不存在,则追加到队尾,否则更新相应元素
  final String elementKey;

  /// 元素的值
  /// 长度限制: 4096字节
  final String elementValue;

  /// 元素是否瞬态的
  /// true: 当前元素所属的成员退出或者掉线时,同步删除
  /// false: 元素保留
  bool transient = false;

  /// 元素属于的账号,默认为当前操作者
  /// 管理员操作,可以指定元素属于的合法账号
  String? elementOwnerAccountId;

  V2NIMChatroomQueueOfferParams({
    required this.elementKey,
    required this.elementValue,
    this.transient = false,
    this.elementOwnerAccountId,
  });

  factory V2NIMChatroomQueueOfferParams.fromJson(Map<String, dynamic> json) =>
      _$V2NIMChatroomQueueOfferParamsFromJson(json);

  Map<String, dynamic> toJson() => _$V2NIMChatroomQueueOfferParamsToJson(this);
}

@JsonSerializable(explicitToJson: true)
class queueVoidEvent {
  int instanceId;

  queueVoidEvent({
    required this.instanceId,
  });

  factory queueVoidEvent.fromJson(Map<String, dynamic> json) =>
      _$queueVoidEventFromJson(json);

  Map<String, dynamic> toJson() => _$queueVoidEventToJson(this);
}

@JsonSerializable(explicitToJson: true)
class onChatroomQueueOfferedEvent {
  int instanceId;

  @JsonKey(fromJson: V2NIMChatroomQueueElementFromJson)
  V2NIMChatroomQueueElement? element;

  onChatroomQueueOfferedEvent({
    required this.instanceId,
    required this.element,
  });

  factory onChatroomQueueOfferedEvent.fromJson(Map<String, dynamic> json) =>
      _$onChatroomQueueOfferedEventFromJson(json);

  Map<String, dynamic> toJson() => _$onChatroomQueueOfferedEventToJson(this);
}

@JsonSerializable(explicitToJson: true)
class onChatroomQueuePartClearedEvent {
  int instanceId;

  @JsonKey(fromJson: V2NIMChatroomQueueElementListFromJson)
  List<V2NIMChatroomQueueElement>? elements;

  onChatroomQueuePartClearedEvent({
    required this.instanceId,
    this.elements,
  });

  factory onChatroomQueuePartClearedEvent.fromJson(Map<String, dynamic> json) =>
      _$onChatroomQueuePartClearedEventFromJson(json);

  Map<String, dynamic> toJson() =>
      _$onChatroomQueuePartClearedEventToJson(this);
}

@JsonSerializable(explicitToJson: true)
class onChatroomQueueBatchOfferedEvent {
  int instanceId;

  @JsonKey(fromJson: V2NIMChatroomQueueElementListFromJson)
  List<V2NIMChatroomQueueElement>? elements;

  onChatroomQueueBatchOfferedEvent({
    required this.instanceId,
    this.elements,
  });

  factory onChatroomQueueBatchOfferedEvent.fromJson(
          Map<String, dynamic> json) =>
      _$onChatroomQueueBatchOfferedEventFromJson(json);

  Map<String, dynamic> toJson() =>
      _$onChatroomQueueBatchOfferedEventToJson(this);
}

@JsonSerializable(explicitToJson: true)
class onChatroomQueueBatchUpdatedEvent {
  int instanceId;

  @JsonKey(fromJson: V2NIMChatroomQueueElementListFromJson)
  List<V2NIMChatroomQueueElement>? elements;

  onChatroomQueueBatchUpdatedEvent({
    required this.instanceId,
    this.elements,
  });

  factory onChatroomQueueBatchUpdatedEvent.fromJson(
          Map<String, dynamic> json) =>
      _$onChatroomQueueBatchUpdatedEventFromJson(json);

  Map<String, dynamic> toJson() =>
      _$onChatroomQueueBatchUpdatedEventToJson(this);
}

@JsonSerializable(explicitToJson: true)
class onChatroomQueuePolledEvent {
  int instanceId;

  @JsonKey(fromJson: V2NIMChatroomQueueElementFromJson)
  V2NIMChatroomQueueElement? element;

  onChatroomQueuePolledEvent({
    required this.instanceId,
    this.element,
  });
  factory onChatroomQueuePolledEvent.fromJson(Map<String, dynamic> json) =>
      _$onChatroomQueuePolledEventFromJson(json);

  Map<String, dynamic> toJson() => _$onChatroomQueuePolledEventToJson(this);
}
