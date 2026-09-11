// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

part of nim_core_v2;

@HawkEntryPoint()
class V2NIMTopicService {
  factory V2NIMTopicService() {
    if (_singleton == null) {
      _singleton = V2NIMTopicService._();
    }
    return _singleton!;
  }

  V2NIMTopicService._();

  static V2NIMTopicService? _singleton;

  V2NIMTopicServicePlatform get _platform => V2NIMTopicServicePlatform.instance;

  /// 话题创建回调
  @HawkApi(ignore: true)
  Stream<V2NIMTopic> get onTopicAdded => _platform.onTopicAdded.stream;

  /// 话题删除回调
  @HawkApi(ignore: true)
  Stream<List<V2NIMTopicRefer>> get onTopicsRemoved =>
      _platform.onTopicsRemoved.stream;

  /// 话题更新回调
  @HawkApi(ignore: true)
  Stream<V2NIMTopic> get onTopicUpdated => _platform.onTopicUpdated.stream;

  /// 批量删除话题
  Future<NIMResult<void>> removeTopics(V2NIMRemoveTopicsParams params) {
    return _platform.removeTopics(params);
  }

  /// 更新话题
  Future<NIMResult<V2NIMTopic>> updateTopic(V2NIMUpdateTopicParams params) {
    return _platform.updateTopic(params);
  }

  /// 发送话题消息
  Future<NIMResult<NIMSendMessageResult>> sendTopicMessage({
    required NIMMessage message,
    required String conversationId,
    V2NIMTopic? topic,
    V2NIMSendTopicMessageParams? params,
  }) {
    return _platform.sendTopicMessage(
      message: message,
      conversationId: conversationId,
      topic: topic,
      params: params,
    );
  }

  /// 回复话题消息
  Future<NIMResult<NIMSendMessageResult>> replyTopicMessage({
    required NIMMessage message,
    required NIMMessage replyMessage,
    required V2NIMTopic topic,
    NIMSendMessageParams? params,
  }) {
    return _platform.replyTopicMessage(
      message: message,
      replyMessage: replyMessage,
      topic: topic,
      params: params,
    );
  }

  /// 通过话题引用查询话题
  Future<NIMResult<V2NIMTopic>> getTopicByRefer(V2NIMTopicRefer topicRefer) {
    return _platform.getTopicByRefer(topicRefer);
  }

  /// 查询话题列表
  Future<NIMResult<V2NIMTopicListResult>> getTopicListByOption(
      V2NIMTopicListOption option) {
    return _platform.getTopicListByOption(option);
  }

  /// 查询话题消息列表
  Future<NIMResult<V2NIMTopicMessageListResult>> getTopicMessageList(
      V2NIMTopicMessageListOption option) {
    return _platform.getTopicMessageList(option);
  }
}
