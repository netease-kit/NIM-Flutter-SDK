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
}
