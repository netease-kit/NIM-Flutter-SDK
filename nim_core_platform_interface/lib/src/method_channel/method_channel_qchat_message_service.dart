// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:nim_core_platform_interface/nim_core_platform_interface.dart';

class MethodChannelQChatMessageService extends QChatMessageServicePlatform {
  @override
  Future onEvent(String method, arguments) {
    return Future.value();
  }

  @override
  String get serviceName => 'QChatMessageService';

  @override
  Future<NIMResult<QChatDeleteMessageResult>> deleteMessage(
      QChatDeleteMessageParam param) async {
    return NIMResult<QChatDeleteMessageResult>.fromMap(
        await invokeMethod('deleteMessage', arguments: param.toJson()),
        convert: (json) => QChatDeleteMessageResult.fromJson(json));
  }

  @override
  Future<NIMResult<void>> downloadAttachment(
      QChatDownloadAttachmentParam param) async {
    return NIMResult<void>.fromMap(
        await invokeMethod('downloadAttachment', arguments: param.toJson()));
  }

  @override
  Future<NIMResult<QChatGetMessageHistoryResult>> getMessageHistory(
      QChatGetMessageHistoryParam param) async {
    return NIMResult<QChatGetMessageHistoryResult>.fromMap(
        await invokeMethod('getMessageHistory', arguments: param.toJson()),
        convert: (json) => QChatGetMessageHistoryResult.fromJson(json));
  }

  @override
  Future<NIMResult<QChatGetMessageHistoryResult>> getMessageHistoryByIds(
      QChatGetMessageHistoryByIdsParam param) async {
    return NIMResult<QChatGetMessageHistoryResult>.fromMap(
        await invokeMethod('getMessageHistoryByIds', arguments: param.toJson()),
        convert: (json) => QChatGetMessageHistoryResult.fromJson(json));
  }

  @override
  Future<NIMResult<void>> markMessageRead(
      QChatMarkMessageReadParam param) async {
    return NIMResult<void>.fromMap(
        await invokeMethod('markMessageRead', arguments: param.toJson()));
  }

  @override
  Future<NIMResult<void>> markSystemNotificationsRead(
      QChatMarkSystemNotificationsReadParam param) async {
    return NIMResult<void>.fromMap(await invokeMethod(
        'markSystemNotificationsRead',
        arguments: param.toJson()));
  }

  @override
  Future<NIMResult<QChatSendMessageResult>> resendMessage(
      QChatResendMessageParam param) async {
    return NIMResult<QChatSendMessageResult>.fromMap(
        await invokeMethod('resendMessage', arguments: param.toJson()),
        convert: (json) => QChatSendMessageResult.fromJson(json));
  }

  @override
  Future<NIMResult<QChatSendSystemNotificationResult>> resendSystemNotification(
      QChatResendSystemNotificationParam param) async {
    return NIMResult<QChatSendSystemNotificationResult>.fromMap(
        await invokeMethod('resendSystemNotification',
            arguments: param.toJson()),
        convert: (json) => QChatSendSystemNotificationResult.fromJson(json));
  }

  @override
  Future<NIMResult<QChatRevokeMessageResult>> revokeMessage(
      QChatRevokeMessageParam param) async {
    return NIMResult<QChatRevokeMessageResult>.fromMap(
        await invokeMethod('revokeMessage', arguments: param.toJson()),
        convert: (json) => QChatRevokeMessageResult.fromJson(json));
  }

  @override
  Future<NIMResult<QChatSendMessageResult>> sendMessage(
      QChatSendMessageParam param) async {
    return NIMResult<QChatSendMessageResult>.fromMap(
        await invokeMethod('sendMessage', arguments: param.toJson()),
        convert: (json) => QChatSendMessageResult.fromJson(json));
  }

  @override
  Future<NIMResult<QChatSendSystemNotificationResult>> sendSystemNotification(
      QChatSendSystemNotificationParam param) async {
    return NIMResult<QChatSendSystemNotificationResult>.fromMap(
        await invokeMethod('sendSystemNotification', arguments: param.toJson()),
        convert: (json) => QChatSendSystemNotificationResult.fromJson(json));
  }

  @override
  Future<NIMResult<QChatUpdateMessageResult>> updateMessage(
      QChatUpdateMessageParam param) async {
    return NIMResult<QChatUpdateMessageResult>.fromMap(
        await invokeMethod('updateMessage', arguments: param.toJson()),
        convert: (json) => QChatUpdateMessageResult.fromJson(json));
  }

  @override
  Future<NIMResult<QChatUpdateSystemNotificationResult>>
      updateSystemNotification(QChatUpdateSystemNotificationParam param) async {
    return NIMResult<QChatUpdateSystemNotificationResult>.fromMap(
        await invokeMethod('updateSystemNotification',
            arguments: param.toJson()),
        convert: (json) => QChatUpdateSystemNotificationResult.fromJson(json));
  }

  @override
  Future<NIMResult<void>> addQuickComment(
      QChatAddQuickCommentParam param) async {
    return NIMResult<void>.fromMap(
        await invokeMethod('addQuickComment', arguments: param.toJson()));
  }

  @override
  Future<NIMResult<void>> clearMessageCache() async {
    return NIMResult<void>.fromMap(await invokeMethod('clearMessageCache'));
  }

  @override
  Future<NIMResult<void>> clearMsgNotifyAndroid() async {
    return NIMResult<void>.fromMap(await invokeMethod('clearMsgNotifyAndroid'));
  }

  @override
  Future<NIMResult<QChatGetLastMessageOfChannelsResult>>
      getLastMessageOfChannels(QChatGetLastMessageOfChannelsParam param) async {
    return NIMResult<QChatGetLastMessageOfChannelsResult>.fromMap(
        await invokeMethod('getLastMessageOfChannels',
            arguments: param.toJson()),
        convert: (json) => QChatGetLastMessageOfChannelsResult.fromJson(json));
  }

  @override
  Future<NIMResult<List<QChatMessageCache>?>> getMessageCache(
      int qchatServerId, int qchatChannelId) async {
    return NIMResult<List<QChatMessageCache>>.fromMap(
        await invokeMethod('getMessageCache', arguments: <String, dynamic>{
          "qchatServerId": qchatServerId,
          "qchatChannelId": qchatChannelId
        }),
        convert: (json) => (json['messageCacheList'] as List<dynamic>?)
            ?.map(
                (e) => QChatMessageCache.fromJson(Map<String, dynamic>.from(e)))
            .toList());
  }

  @override
  Future<NIMResult<QChatGetMessageThreadInfosResult>> getMessageThreadInfos(
      QChatGetMessageThreadInfosParam param) async {
    return NIMResult<QChatGetMessageThreadInfosResult>.fromMap(
        await invokeMethod('getMessageThreadInfos', arguments: param.toJson()),
        convert: (json) => QChatGetMessageThreadInfosResult.fromJson(json));
  }

  @override
  Future<NIMResult<QChatGetQuickCommentsResult>> getQuickComments(
      QChatGetQuickCommentsParam param) async {
    return NIMResult<QChatGetQuickCommentsResult>.fromMap(
        await invokeMethod('getQuickComments', arguments: param.toJson()),
        convert: (json) => QChatGetQuickCommentsResult.fromJson(json));
  }

  @override
  Future<NIMResult<QChatGetReferMessagesResult>> getReferMessages(
      QChatGetReferMessagesParam param) async {
    return NIMResult<QChatGetReferMessagesResult>.fromMap(
        await invokeMethod('getReferMessages', arguments: param.toJson()),
        convert: (json) => QChatGetReferMessagesResult.fromJson(json));
  }

  @override
  Future<NIMResult<QChatGetThreadMessagesResult>> getThreadMessages(
      QChatGetThreadMessagesParam param) async {
    return NIMResult<QChatGetThreadMessagesResult>.fromMap(
        await invokeMethod('getThreadMessages', arguments: param.toJson()),
        convert: (json) => QChatGetThreadMessagesResult.fromJson(json));
  }

  @override
  Future<NIMResult<void>> removeQuickComment(
      QChatRemoveQuickCommentParam param) async {
    return NIMResult<void>.fromMap(
        await invokeMethod('removeQuickComment', arguments: param.toJson()));
  }

  @override
  Future<NIMResult<QChatSendMessageResult>> replyMessage(
      QChatReplyMessageParam param) async {
    return NIMResult<QChatSendMessageResult>.fromMap(
        await invokeMethod('replyMessage', arguments: param.toJson()),
        convert: (json) => QChatSendMessageResult.fromJson(json));
  }

  @override
  Future<NIMResult<QChatSearchMsgByPageResult>> searchMsgByPage(
      QChatSearchMsgByPageParam param) async {
    return NIMResult<QChatSearchMsgByPageResult>.fromMap(
        await invokeMethod('searchMsgByPage', arguments: param.toJson()),
        convert: (json) => QChatSearchMsgByPageResult.fromJson(json));
  }

  @override
  Future<NIMResult<QChatAreMentionedMeMessagesResult>> areMentionedMeMessages(
      QChatAreMentionedMeMessagesParam param) async {
    return NIMResult<QChatAreMentionedMeMessagesResult>.fromMap(
        await invokeMethod('areMentionedMeMessages', arguments: param.toJson()),
        convert: (json) => QChatAreMentionedMeMessagesResult.fromJson(json));
  }

  @override
  Future<NIMResult<QChatGetMentionedMeMessagesResult>> getMentionedMeMessages(
      QChatGetMentionedMeMessagesParam param) async {
    return NIMResult<QChatGetMentionedMeMessagesResult>.fromMap(
        await invokeMethod('getMentionedMeMessages', arguments: param.toJson()),
        convert: (json) => QChatGetMentionedMeMessagesResult.fromJson(json));
  }

  @override
  Future<NIMResult<QChatSendTypingEventResult>> sendTypingEvent(
      QChatSendTypingEventParam param) async {
    return NIMResult<QChatSendTypingEventResult>.fromMap(
        await invokeMethod('sendTypingEvent', arguments: param.toJson()),
        convert: (json) => QChatSendTypingEventResult.fromJson(json));
  }
}
