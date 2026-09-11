// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:nim_core_v2_platform_interface/nim_core_v2_platform_interface.dart';

class MethodChannelV2NIMTopicService extends V2NIMTopicServicePlatform {
  @override
  String get serviceName => 'TopicService';

  @override
  Future<dynamic> onEvent(String method, dynamic arguments) {
    switch (method) {
      case 'onTopicAdded':
        V2NIMTopicServicePlatform.instance.onTopicAdded.add(
          V2NIMTopic.fromJson(Map<String, dynamic>.from(arguments as Map)),
        );
        break;
      case 'onTopicsRemoved':
        final topics = (arguments['topics'] as List<dynamic>?)
            ?.map((e) =>
                V2NIMTopicRefer.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList();
        if (topics != null) {
          V2NIMTopicServicePlatform.instance.onTopicsRemoved.add(topics);
        }
        break;
      case 'onTopicUpdated':
        V2NIMTopicServicePlatform.instance.onTopicUpdated.add(
          V2NIMTopic.fromJson(Map<String, dynamic>.from(arguments as Map)),
        );
        break;
      default:
        throw UnimplementedError('$method has not been implemented');
    }
    return Future.value(null);
  }

  @override
  Future<NIMResult<void>> removeTopics(V2NIMRemoveTopicsParams params) async {
    return NIMResult<void>.fromMap(
      await invokeMethod('removeTopics',
          arguments: {'params': params.toJson()}),
    );
  }

  @override
  Future<NIMResult<V2NIMTopic>> updateTopic(
      V2NIMUpdateTopicParams params) async {
    return NIMResult<V2NIMTopic>.fromMap(
      await invokeMethod('updateTopic', arguments: {'params': params.toJson()}),
      convert: (json) => V2NIMTopic.fromJson(json),
    );
  }

  @override
  Future<NIMResult<NIMSendMessageResult>> sendTopicMessage({
    required NIMMessage message,
    required String conversationId,
    V2NIMTopic? topic,
    V2NIMSendTopicMessageParams? params,
  }) async {
    return NIMResult<NIMSendMessageResult>.fromMap(
      await invokeMethod('sendTopicMessage', arguments: {
        'message': message.toJson(),
        'conversationId': conversationId,
        'topic': topic?.toJson(),
        'params': params?.toJson(),
      }),
      convert: (json) => NIMSendMessageResult.fromJson(json),
    );
  }

  @override
  Future<NIMResult<NIMSendMessageResult>> replyTopicMessage({
    required NIMMessage message,
    required NIMMessage replyMessage,
    required V2NIMTopic topic,
    NIMSendMessageParams? params,
  }) async {
    return NIMResult<NIMSendMessageResult>.fromMap(
      await invokeMethod('replyTopicMessage', arguments: {
        'message': message.toJson(),
        'replyMessage': replyMessage.toJson(),
        'topic': topic.toJson(),
        'params': params?.toJson(),
      }),
      convert: (json) => NIMSendMessageResult.fromJson(json),
    );
  }

  @override
  Future<NIMResult<V2NIMTopic>> getTopicByRefer(
      V2NIMTopicRefer topicRefer) async {
    return NIMResult<V2NIMTopic>.fromMap(
      await invokeMethod(
        'getTopicByRefer',
        arguments: {'topicRefer': topicRefer.toJson()},
      ),
      convert: (json) => V2NIMTopic.fromJson(json),
    );
  }

  @override
  Future<NIMResult<V2NIMTopicListResult>> getTopicListByOption(
      V2NIMTopicListOption option) async {
    return NIMResult<V2NIMTopicListResult>.fromMap(
      await invokeMethod(
        'getTopicListByOption',
        arguments: {'option': option.toJson()},
      ),
      convert: (json) => V2NIMTopicListResult.fromJson(json),
    );
  }

  @override
  Future<NIMResult<V2NIMTopicMessageListResult>> getTopicMessageList(
      V2NIMTopicMessageListOption option) async {
    return NIMResult<V2NIMTopicMessageListResult>.fromMap(
      await invokeMethod(
        'getTopicMessageList',
        arguments: {'option': option.toJson()},
      ),
      convert: (json) => V2NIMTopicMessageListResult.fromJson(json),
    );
  }
}
