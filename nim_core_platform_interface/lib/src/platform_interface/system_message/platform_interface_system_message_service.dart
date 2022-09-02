// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:nim_core_platform_interface/nim_core_platform_interface.dart';
import 'package:nim_core_platform_interface/src/method_channel/method_channel_system_message_service.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

abstract class SystemMessageServicePlatform extends Service {
  SystemMessageServicePlatform() : super(token: _token);

  static final Object _token = Object();

  static SystemMessageServicePlatform _instance =
      MethodChannelSystemMessageService();

  static SystemMessageServicePlatform get instance => _instance;

  static set instance(SystemMessageServicePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  //监听系统通知
  // ignore: close_sinks
  final StreamController<SystemMessage> onReceiveSystemMessage =
      StreamController<SystemMessage>.broadcast();

  //监听总未读数变更
  // ignore: close_sinks
  final StreamController<int> onUnreadCountChange =
      StreamController<int>.broadcast();

  //接收自定义系统通知
  // ignore: close_sinks
  final StreamController<CustomNotification> onCustomNotification =
      StreamController<CustomNotification>.broadcast();

  Future<NIMResult<List<SystemMessage>>> querySystemMessagesAndroid(
      int offset, int limit) async {
    throw UnimplementedError('querySystemMessagesAndroid() is not implemented');
  }

  Future<NIMResult<List<SystemMessage>>> querySystemMessagesIOSAndDesktop(
      SystemMessage? systemMessage, int limit) async {
    throw UnimplementedError(
        'querySystemMessagesIOSAndDesktop() is not implemented');
  }

  Future<NIMResult<List<SystemMessage>>> querySystemMessageByTypeAndroid(
      List<SystemMessageType> types, int offset, int limit) async {
    throw UnimplementedError(
        'querySystemMessageByTypeAndroid() is not implemented');
  }

  Future<NIMResult<List<SystemMessage>>> querySystemMessageByTypeIOSAndDesktop(
      SystemMessage? systemMessage,
      List<SystemMessageType> types,
      int limit) async {
    throw UnimplementedError(
        'querySystemMessageByTypeIOSAndDesktop() is not implemented');
  }

  //获取未读系统通知
  Future<NIMResult<List<SystemMessage>>> querySystemMessageUnread() async {
    throw UnimplementedError('querySystemMessageUnread() is not implemented');
  }

  //查询未读数总和
  Future<NIMResult<int>> querySystemMessageUnreadCount() async {
    throw UnimplementedError(
        'querySystemMessageUnreadCount() is not implemented');
  }

  //指定类型的未读数总和
  Future<NIMResult<int>> querySystemMessageUnreadCountByType(
      List<SystemMessageType> types) async {
    throw UnimplementedError(
        'querySystemMessageUnreadCount() is not implemented');
  }

  //标记所有通知为已读
  Future<NIMResult<void>> resetSystemMessageUnreadCount() async {
    throw UnimplementedError(
        'resetSystemMessageUnreadCount() is not implemented');
  }

  //标记指定类型通知为已读
  Future<NIMResult<void>> resetSystemMessageUnreadCountByType(
      List<SystemMessageType> types) async {
    throw UnimplementedError(
        'resetSystemMessageUnreadCountByType() is not implemented');
  }

  //标记单条通知为已读
  // TODO: iOS入参为readonly，无法常规设值
  Future<NIMResult<void>> setSystemMessageRead(int messageId) async {
    throw UnimplementedError('setSystemMessageRead() is not implemented');
  }

  //删除所有系统通知
  Future<NIMResult<void>> clearSystemMessages() async {
    throw UnimplementedError('clearSystemMessages() is not implemented');
  }

  //删除指定类型系统通知
  Future<NIMResult<void>> clearSystemMessagesByType(
      List<SystemMessageType> types) async {
    throw UnimplementedError('clearSystemMessagesByType() is not implemented');
  }

  //删除单条系统通知
  // TODO: iOS入参为readonly，无法常规设值
  Future<NIMResult<void>> deleteSystemMessage(int messageId) async {
    throw UnimplementedError('deleteSystemMessage() is not implemented');
  }

  //更改通知处理状态
  // TODO: iOS无法实现
  Future<NIMResult<void>> setSystemMessageStatus(
      int messageId, SystemMessageStatus status) async {
    throw UnimplementedError('setSystemMessageStatus() is not implemented');
  }

  //发送自定义系统通知
  Future<NIMResult<void>> sendCustomNotification(
      CustomNotification notification) async {
    throw UnimplementedError('sendCustomNotification() is not implemented');
  }
}
