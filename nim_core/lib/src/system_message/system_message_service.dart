// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:nim_core_platform_interface/nim_core_platform_interface.dart';

class SystemMessageService {
  factory SystemMessageService() {
    if (_singleton == null) {
      _singleton = SystemMessageService._();
    }
    return _singleton!;
  }

  SystemMessageService._();

  static SystemMessageService? _singleton;

  SystemMessageServicePlatform get _platform =>
      SystemMessageServicePlatform.instance;

  ///系统消息接收
  Stream<SystemMessage> get onReceiveSystemMsg =>
      SystemMessageServicePlatform.instance.onReceiveSystemMessage.stream;

  ///系统消息未读数变化
  Stream<int> get onUnreadCountChange =>
      SystemMessageServicePlatform.instance.onUnreadCountChange.stream;

  ///自定义通知接收
  Stream<CustomNotification> get onCustomNotification =>
      SystemMessageServicePlatform.instance.onCustomNotification.stream;

  ///查询系统通知消息列表 Android
  Future<NIMResult<List<SystemMessage>>> querySystemMessagesAndroid(
      int offset, int limit) async {
    return _platform.querySystemMessagesAndroid(offset, limit);
  }

  ///查询系统通知消息列表 IOS 和 PC
  Future<NIMResult<List<SystemMessage>>> querySystemMessagesIOSAndDesktop(
      SystemMessage? systemMessage, int limit) async {
    return _platform.querySystemMessagesIOSAndDesktop(systemMessage, limit);
  }

  ///根据类型查询系统通知列表 Android
  Future<NIMResult<List<SystemMessage>>> querySystemMessageByTypeAndroid(
      List<SystemMessageType> types, int offset, int limit) async {
    return _platform.querySystemMessageByTypeAndroid(types, offset, limit);
  }

  ///根据类型查询系统通知列表 ios 和 PC
  Future<NIMResult<List<SystemMessage>>> querySystemMessageByTypeIOSAndDesktop(
      SystemMessage? systemMessage,
      List<SystemMessageType> types,
      int limit) async {
    return _platform.querySystemMessageByTypeIOSAndDesktop(
        systemMessage, types, limit);
  }

  ///获取未读系统通知
  Future<NIMResult<List<SystemMessage>>> querySystemMessageUnread() async {
    return _platform.querySystemMessageUnread();
  }

  ///查询未读数总和
  Future<NIMResult<int>> querySystemMessageUnreadCount() async {
    return _platform.querySystemMessageUnreadCount();
  }

  ///指定类型的未读数总和
  Future<NIMResult<int>> querySystemMessageUnreadCountByType(
      List<SystemMessageType> types) async {
    return _platform.querySystemMessageUnreadCountByType(types);
  }

  ///标记所有通知为已读
  Future<NIMResult<void>> resetSystemMessageUnreadCount() async {
    return _platform.resetSystemMessageUnreadCount();
  }

  ///标记指定类型通知为已读
  Future<NIMResult<void>> resetSystemMessageUnreadCountByType(
      List<SystemMessageType> types) async {
    return _platform.resetSystemMessageUnreadCountByType(types);
  }

  ///标记单条通知为已读
  Future<NIMResult<void>> setSystemMessageRead(int messageId) async {
    return _platform.setSystemMessageRead(messageId);
  }

  ///删除所有系统通知
  Future<NIMResult<void>> clearSystemMessages() async {
    return _platform.clearSystemMessages();
  }

  ///删除指定类型系统通知
  Future<NIMResult<void>> clearSystemMessagesByType(
      List<SystemMessageType> types) async {
    return _platform.clearSystemMessagesByType(types);
  }

  ///删除单条系统通知
  Future<NIMResult<void>> deleteSystemMessage(int messageId) async {
    return _platform.deleteSystemMessage(messageId);
  }

  ///更改通知处理状态
  Future<NIMResult<void>> setSystemMessageStatus(
      int messageId, SystemMessageStatus status) async {
    return _platform.setSystemMessageStatus(messageId, status);
  }

  ///发送自定义系统通知
  Future<NIMResult<void>> sendCustomNotification(
      CustomNotification notification) async {
    return _platform.sendCustomNotification(notification);
  }
}
