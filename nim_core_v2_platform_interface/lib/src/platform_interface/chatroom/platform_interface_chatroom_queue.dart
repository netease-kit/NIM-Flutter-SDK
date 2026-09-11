// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:nim_core_v2_platform_interface/nim_core_v2_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import '../../method_channel/method_channel_chatroom_queue.dart';

abstract class ChatroomQueuePlatform extends Service {
  ChatroomQueuePlatform() : super(token: _token);

  static final Object _token = Object();

  static ChatroomQueuePlatform _instance = MethodChannelChatroomQueue();

  static ChatroomQueuePlatform get instance => _instance;

  static set instance(ChatroomQueuePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// 聊天室新增队列元素
  /// @param element 新增的队列内容
  Stream<onChatroomQueueOfferedEvent> get onChatroomQueueOffered;

  /// 聊天室删除队列元素
  /// @param element 删除的队列内容
  Stream<onChatroomQueuePolledEvent> get onChatroomQueuePolled;

  /// 聊天室清空队列元素
  Stream<queueVoidEvent> get onChatroomQueueDropped;

  /// 聊天室清理部分队列元素
  /// @param elements 清理的队列列表
  Stream<onChatroomQueuePartClearedEvent> get onChatroomQueuePartCleared;

  /// 聊天室批量更新元素
  /// @param elements 更新的队列列表
  Stream<onChatroomQueueBatchUpdatedEvent> get onChatroomQueueBatchUpdated;

  /// 聊天室批量新增元素
  /// @param elements 新增的队列列表
  Stream<onChatroomQueueBatchOfferedEvent> get onChatroomQueueBatchOffered;

  /// 聊天室队列新增或更新元素
  ///  [offerParams] 新增或更新元素参数
  Future<NIMResult<void>> queueOffer(
      int instanceId, V2NIMChatroomQueueOfferParams offerParams) async {
    throw UnimplementedError('queueOffer() is not implemented');
  }

  /// 取出头元素或者指定的元素
  /// 仅管理员和创建者可以操作
  /// [elementKey] 如果为空表示取出头元素，如果不为空，取出指定的元素
  Future<NIMResult<V2NIMChatroomQueueElement>> queuePoll(
      int instanceId, String elementKey) async {
    throw UnimplementedError('queuePoll() is not implemented');
  }

  /// 排序列出所有元素
  Future<NIMResult<List<V2NIMChatroomQueueElement>>> queueList(
      int instanceId) async {
    throw UnimplementedError('queueList() is not implemented');
  }

  /// 查看队头元素，不删除
  Future<NIMResult<V2NIMChatroomQueueElement>> queuePeek(int instanceId) async {
    throw UnimplementedError('queuePeek() is not implemented');
  }

  /// 清空队列
  /// 仅管理员/创建者可以操作
  Future<NIMResult<void>> queueDrop(int instanceId) async {
    throw UnimplementedError('queueDrop() is not implemented');
  }

  /// 初始化队列
  ///  [size] 初始化队列的长度，长度限制：0~1000，超过返回参数错误
  Future<NIMResult<void>> queueInit(int instanceId, int size) async {
    throw UnimplementedError('queueInit() is not implemented');
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
    throw UnimplementedError('queueBatchUpdate() is not implemented');
  }

  /// 添加聊天室队列监听器
  Future<NIMResult<void>> addQueueListener(int instanceId) async {
    throw UnimplementedError('addQueueimplementedError() is not implemented');
  }

  /// 移除聊天室队列监听器
  Future<NIMResult<void>> removeQueueListener(int instanceId) async {
    throw UnimplementedError('removeQueueListener() is not implemented');
  }
}
