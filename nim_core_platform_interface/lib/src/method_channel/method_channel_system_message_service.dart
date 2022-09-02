// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import '../../nim_core_platform_interface.dart';

class MethodChannelSystemMessageService extends SystemMessageServicePlatform {
  @override
  String get serviceName => 'SystemMessageService';

  @override
  Future onEvent(String method, arguments) {
    Map<String, dynamic> paramMap = Map<String, dynamic>.from(arguments);
    switch (method) {
      case 'onReceiveSystemMsg':
        _onReceiveSystemMsg(paramMap);
        break;
      case 'onUnreadCountChange':
        _onUnreadCountChange(paramMap);
        break;
      case 'onCustomNotification':
        _onCustomNotification(paramMap);
        break;
      default:
        break;
    }
    return Future.value(null);
  }

  _onReceiveSystemMsg(Map<String, dynamic> param) {
    SystemMessageServicePlatform.instance.onReceiveSystemMessage
        .add(SystemMessage.fromMap(param));
  }

  _onUnreadCountChange(Map<String, dynamic> param) {
    SystemMessageServicePlatform.instance.onUnreadCountChange
        .add(param["result"] as int);
  }

  _onCustomNotification(Map<String, dynamic> param) {
    SystemMessageServicePlatform.instance.onCustomNotification
        .add(CustomNotification.fromMap(param));
  }

  NIMResult<List<SystemMessage>> notifyMessageListResult(
      Map<String, dynamic> replyMap) {
    return NIMResult.fromMap(replyMap, convert: (map) {
      var messageList = map['systemMessageList'] as List<dynamic>;
      return messageList
          .map((e) => SystemMessage.fromMap(Map<String, dynamic>.from(e)))
          .toList();
    });
  }

  @override
  Future<NIMResult<List<SystemMessage>>> querySystemMessagesAndroid(
      int offset, int limit) async {
    Map<String, dynamic> arguments = Map();
    arguments["limit"] = limit;
    arguments["offset"] = offset;
    Map<String, dynamic> replyMap =
        await invokeMethod('querySystemMessagesAndroid', arguments: arguments);
    return notifyMessageListResult(replyMap);
  }

  @override
  Future<NIMResult<List<SystemMessage>>> querySystemMessagesIOSAndDesktop(
      SystemMessage? systemMessage, int limit) async {
    Map<String, dynamic> arguments = Map();
    arguments["limit"] = limit;
    arguments["systemMessage"] = systemMessage?.toMap();
    Map<String, dynamic> replyMap = await invokeMethod(
        'querySystemMessagesIOSAndDesktop',
        arguments: arguments);
    return notifyMessageListResult(replyMap);
  }

  @override
  Future<NIMResult<List<SystemMessage>>> querySystemMessageByTypeAndroid(
      List<SystemMessageType> types, int offset, int limit) async {
    Map<String, dynamic> arguments = Map();
    arguments["systemMessageTypeList"] = types
        .map((e) => SystemMessageTypeConverter(type: e).toValue())
        .toList();
    arguments["offset"] = offset;
    arguments["limit"] = limit;
    Map<String, dynamic> replyMap = await invokeMethod(
        'querySystemMessageByTypeAndroid',
        arguments: arguments);
    return notifyMessageListResult(replyMap);
  }

  @override
  Future<NIMResult<List<SystemMessage>>> querySystemMessageByTypeIOSAndDesktop(
      SystemMessage? systemMessage,
      List<SystemMessageType> types,
      int limit) async {
    Map<String, dynamic> arguments = Map();
    arguments["systemMessageTypeList"] = types
        .map((e) => SystemMessageTypeConverter(type: e).toValue())
        .toList();
    arguments["systemMessage"] = systemMessage?.toMap();
    arguments["limit"] = limit;
    Map<String, dynamic> replyMap = await invokeMethod(
        'querySystemMessageByTypeIOSAndDesktop',
        arguments: arguments);
    return notifyMessageListResult(replyMap);
  }

  @override
  Future<NIMResult<List<SystemMessage>>> querySystemMessageUnread() async {
    Map<String, dynamic> replyMap =
        await invokeMethod('querySystemMessageUnread');
    return notifyMessageListResult(replyMap);
  }

  @override
  Future<NIMResult<int>> querySystemMessageUnreadCount() async {
    Map<String, dynamic> replyMap =
        await invokeMethod('querySystemMessageUnreadCount');
    return NIMResult.fromMap(replyMap);
  }

  @override
  Future<NIMResult<int>> querySystemMessageUnreadCountByType(
      List<SystemMessageType> types) async {
    Map<String, dynamic> arguments = Map();
    arguments["systemMessageTypeList"] = types
        .map((e) => SystemMessageTypeConverter(type: e).toValue())
        .toList();
    Map<String, dynamic> replyMap = await invokeMethod(
        'querySystemMessageUnreadCountByType',
        arguments: arguments);
    return NIMResult.fromMap(replyMap);
  }

  @override
  Future<NIMResult<void>> resetSystemMessageUnreadCount() async {
    Map<String, dynamic> replyMap =
        await invokeMethod('resetSystemMessageUnreadCount');
    return NIMResult.fromMap(replyMap);
  }

  @override
  Future<NIMResult<void>> resetSystemMessageUnreadCountByType(
      List<SystemMessageType> types) async {
    Map<String, dynamic> arguments = Map();
    arguments["systemMessageTypeList"] = types
        .map((e) => SystemMessageTypeConverter(type: e).toValue())
        .toList();
    Map<String, dynamic> replyMap = await invokeMethod(
        'resetSystemMessageUnreadCountByType',
        arguments: arguments);
    return NIMResult.fromMap(replyMap);
  }

  @override
  Future<NIMResult<void>> setSystemMessageRead(int messageId) async {
    Map<String, dynamic> arguments = Map();
    arguments["messageId"] = messageId;
    Map<String, dynamic> replyMap =
        await invokeMethod('setSystemMessageRead', arguments: arguments);
    return NIMResult.fromMap(replyMap);
  }

  @override
  Future<NIMResult<void>> clearSystemMessages() async {
    Map<String, dynamic> replyMap = await invokeMethod('clearSystemMessages');
    return NIMResult.fromMap(replyMap);
  }

  @override
  Future<NIMResult<void>> clearSystemMessagesByType(
      List<SystemMessageType> types) async {
    Map<String, dynamic> arguments = Map();
    arguments["systemMessageTypeList"] = types
        .map((e) => SystemMessageTypeConverter(type: e).toValue())
        .toList();
    Map<String, dynamic> replyMap =
        await invokeMethod('clearSystemMessagesByType', arguments: arguments);
    return NIMResult.fromMap(replyMap);
  }

  @override
  Future<NIMResult<void>> deleteSystemMessage(int messageId) async {
    Map<String, dynamic> arguments = Map();
    arguments["messageId"] = messageId;
    Map<String, dynamic> replyMap =
        await invokeMethod('deleteSystemMessage', arguments: arguments);
    return NIMResult.fromMap(replyMap);
  }

  @override
  Future<NIMResult<void>> setSystemMessageStatus(
      int messageId, SystemMessageStatus status) async {
    Map<String, dynamic> arguments = Map();
    arguments["systemMessageStatus"] =
        SystemMessageStatusConverter(status: status).toValue();
    arguments["messageId"] = messageId;
    Map<String, dynamic> replyMap =
        await invokeMethod('setSystemMessageStatus', arguments: arguments);
    return NIMResult.fromMap(replyMap);
  }

  @override
  Future<NIMResult<void>> sendCustomNotification(
      CustomNotification notification) async {
    Map<String, dynamic> arguments = Map();
    arguments["customNotification"] = notification.toMap();
    Map<String, dynamic> replyMap =
        await invokeMethod('sendCustomNotification', arguments: arguments);
    return NIMResult.fromMap(replyMap);
  }
}
