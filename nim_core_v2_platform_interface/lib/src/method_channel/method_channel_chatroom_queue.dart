// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:convert';

import 'package:nim_core_v2_platform_interface/nim_core_v2_platform_interface.dart';

class MethodChannelChatroomQueue extends ChatroomQueuePlatform {
  @override
  Future onEvent(String method, arguments) {
    switch (method) {
      case 'onChatroomQueueBatchOffered':
        assert(arguments is Map);
        var event = onChatroomQueueBatchOfferedEvent
            .fromJson(Map<String, dynamic>.from(arguments));
        _onChatroomQueueBatchOfferedController.add(event);
        break;
      case 'onChatroomQueueBatchUpdated':
        assert(arguments is Map);
        var event = onChatroomQueueBatchUpdatedEvent
            .fromJson(Map<String, dynamic>.from(arguments));
        _onChatroomQueueBatchUpdatedController.add(event);
        break;
      case 'onChatroomQueueDropped':
        assert(arguments is Map);
        var event =
            queueVoidEvent.fromJson(Map<String, dynamic>.from(arguments));
        _onChatroomQueueDroppedController.add(event);
        break;
      case 'onChatroomQueueOffered':
        assert(arguments is Map);
        var event = onChatroomQueueOfferedEvent
            .fromJson(Map<String, dynamic>.from(arguments));
        _onChatroomQueueOfferedController.add(event);
        break;
      case 'onChatroomQueuePartCleared':
        assert(arguments is Map);
        var event = onChatroomQueuePartClearedEvent
            .fromJson(Map<String, dynamic>.from(arguments));
        _onChatroomQueuePartClearedController.add(event);
        break;
      case 'onChatroomQueuePolled':
        assert(arguments is Map);
        var event = onChatroomQueuePolledEvent
            .fromJson(Map<String, dynamic>.from(arguments));
        _onChatroomQueuePolledController.add(event);
        break;
      default:
        throw UnimplementedError();
    }
    return Future.value();
  }

  @override
  String get serviceName => 'V2NIMChatroomQueueService';

  final _onChatroomQueueBatchOfferedController =
      StreamController<onChatroomQueueBatchOfferedEvent>.broadcast();

  @override
  Stream<onChatroomQueueBatchOfferedEvent> get onChatroomQueueBatchOffered =>
      _onChatroomQueueBatchOfferedController.stream;

  final _onChatroomQueueBatchUpdatedController =
      StreamController<onChatroomQueueBatchUpdatedEvent>.broadcast();
  @override
  Stream<onChatroomQueueBatchUpdatedEvent> get onChatroomQueueBatchUpdated =>
      _onChatroomQueueBatchUpdatedController.stream;

  final _onChatroomQueueDroppedController =
      StreamController<queueVoidEvent>.broadcast();

  @override
  Stream<queueVoidEvent> get onChatroomQueueDropped =>
      _onChatroomQueueDroppedController.stream;

  final _onChatroomQueueOfferedController =
      StreamController<onChatroomQueueOfferedEvent>.broadcast();
  @override
  Stream<onChatroomQueueOfferedEvent> get onChatroomQueueOffered =>
      _onChatroomQueueOfferedController.stream;

  final _onChatroomQueuePartClearedController =
      StreamController<onChatroomQueuePartClearedEvent>.broadcast();
  @override
  Stream<onChatroomQueuePartClearedEvent> get onChatroomQueuePartCleared =>
      _onChatroomQueuePartClearedController.stream;

  final _onChatroomQueuePolledController =
      StreamController<onChatroomQueuePolledEvent>.broadcast();
  @override
  Stream<onChatroomQueuePolledEvent> get onChatroomQueuePolled =>
      _onChatroomQueuePolledController.stream;

  /// 聊天室队列新增或更新元素
  ///  [offerParams] 新增或更新元素参数
  Future<NIMResult<void>> queueOffer(
      int instanceId, V2NIMChatroomQueueOfferParams offerParams) async {
    return NIMResult.fromMap(await invokeMethod('queueOffer', arguments: {
      'instanceId': instanceId,
      'offerParams': offerParams.toJson()
    }));
  }

  /// 取出头元素或者指定的元素
  /// 仅管理员和创建者可以操作
  /// [elementKey] 如果为空表示取出头元素，如果不为空，取出指定的元素
  Future<NIMResult<V2NIMChatroomQueueElement>> queuePoll(
      int instanceId, String elementKey) async {
    return NIMResult.fromMap(
        await invokeMethod('queuePoll',
            arguments: {'instanceId': instanceId, 'elementKey': elementKey}),
        convert: (json) => V2NIMChatroomQueueElement.fromJson(json));
  }

  /// 排序列出所有元素
  Future<NIMResult<List<V2NIMChatroomQueueElement>>> queueList(
      int instanceId) async {
    return NIMResult.fromMap(
        await invokeMethod('queueList', arguments: {'instanceId': instanceId}),
        convert: (json) => (json['elements'] as List<dynamic>?)
            ?.map((e) => V2NIMChatroomQueueElement.fromJson(
                (e as Map).cast<String, dynamic>()))
            .toList());
  }

  /// 查看队头元素，不删除
  Future<NIMResult<V2NIMChatroomQueueElement>> queuePeek(int instanceId) async {
    return NIMResult.fromMap(
        await invokeMethod('queuePeek', arguments: {'instanceId': instanceId}),
        convert: (json) => V2NIMChatroomQueueElement.fromJson(json));
  }

  /// 清空队列
  /// 仅管理员/创建者可以操作
  Future<NIMResult<void>> queueDrop(int instanceId) async {
    return NIMResult.fromMap(
        await invokeMethod('queueDrop', arguments: {'instanceId': instanceId}));
  }

  /// 初始化队列
  ///  [size] 初始化队列的长度，长度限制：0~1000，超过返回参数错误
  Future<NIMResult<void>> queueInit(int instanceId, int size) async {
    return NIMResult.fromMap(await invokeMethod('queueInit',
        arguments: {'instanceId': instanceId, 'size': size}));
  }

  /// 批量更新队列元素
  ///  [elements] 批量更新元素，size为空，size==0，size>100，返回参数错误
  ///  [notificationEnabled] 是否发送广播通知，默认为true
  ///  [notificationExtension] 本次操作生成的通知中的扩展字段，长度限制：2048字节
  Future<NIMResult<List<String>?>> queueBatchUpdate(
      int instanceId,
      List<V2NIMChatroomQueueElement> elements,
      bool notificationEnabled,
      String? notificationExtension) async {
    return NIMResult.fromMap(
        await invokeMethod('queueBatchUpdate', arguments: {
          'instanceId': instanceId,
          'elements': elements.map((e) => e.toJson()).toList(),
          'notificationEnabled': notificationEnabled,
          'notificationExtension': notificationExtension
        }),
        convert: (json) => (json['notExistKeys'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList());
  }

  /// 添加聊天室队列监听器
  Future<NIMResult<void>> addQueueListener(int instanceId) async {
    return NIMResult.fromMap(await invokeMethod('addQueueListener',
        arguments: {'instanceId': instanceId}));
  }

  /// 移除聊天室队列监听器
  Future<NIMResult<void>> removeQueueListener(int instanceId) async {
    return NIMResult.fromMap(await invokeMethod('removeQueueListener',
        arguments: {'instanceId': instanceId}));
  }
}
