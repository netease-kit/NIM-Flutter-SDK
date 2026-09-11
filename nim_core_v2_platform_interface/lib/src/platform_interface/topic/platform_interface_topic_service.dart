// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:nim_core_v2_platform_interface/nim_core_v2_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import '../../method_channel/method_channel_topic_service.dart';

abstract class V2NIMTopicServicePlatform extends Service {
  V2NIMTopicServicePlatform() : super(token: _token);

  static final Object _token = Object();

  static V2NIMTopicServicePlatform _instance = MethodChannelV2NIMTopicService();

  static V2NIMTopicServicePlatform get instance => _instance;

  static set instance(V2NIMTopicServicePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  final StreamController<V2NIMTopic> onTopicAdded =
      StreamController<V2NIMTopic>.broadcast();

  final StreamController<List<V2NIMTopicRefer>> onTopicsRemoved =
      StreamController<List<V2NIMTopicRefer>>.broadcast();

  final StreamController<V2NIMTopic> onTopicUpdated =
      StreamController<V2NIMTopic>.broadcast();

  /// 批量删除话题
  Future<NIMResult<void>> removeTopics(V2NIMRemoveTopicsParams params) {
    throw UnimplementedError('removeTopics() is not implemented');
  }

  /// 更新话题
  Future<NIMResult<V2NIMTopic>> updateTopic(V2NIMUpdateTopicParams params) {
    throw UnimplementedError('updateTopic() is not implemented');
  }

  /// 发送话题消息
  Future<NIMResult<NIMSendMessageResult>> sendTopicMessage({
    required NIMMessage message,
    required String conversationId,
    V2NIMTopic? topic,
    V2NIMSendTopicMessageParams? params,
  }) {
    throw UnimplementedError('sendTopicMessage() is not implemented');
  }

  /// 回复话题消息
  Future<NIMResult<NIMSendMessageResult>> replyTopicMessage({
    required NIMMessage message,
    required NIMMessage replyMessage,
    required V2NIMTopic topic,
    NIMSendMessageParams? params,
  }) {
    throw UnimplementedError('replyTopicMessage() is not implemented');
  }

  /// 通过话题引用查询话题
  Future<NIMResult<V2NIMTopic>> getTopicByRefer(V2NIMTopicRefer topicRefer) {
    throw UnimplementedError('getTopicByRefer() is not implemented');
  }

  /// 查询话题列表
  Future<NIMResult<V2NIMTopicListResult>> getTopicListByOption(
      V2NIMTopicListOption option) {
    throw UnimplementedError('getTopicListByOption() is not implemented');
  }

  /// 查询话题消息列表
  Future<NIMResult<V2NIMTopicMessageListResult>> getTopicMessageList(
      V2NIMTopicMessageListOption option) {
    throw UnimplementedError('getTopicMessageList() is not implemented');
  }
}
