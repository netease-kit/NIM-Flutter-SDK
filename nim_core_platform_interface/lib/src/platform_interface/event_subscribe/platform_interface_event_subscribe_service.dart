// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:nim_core_platform_interface/src/method_channel/method_channel_event_subscribe_service.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import '../../../nim_core_platform_interface.dart';

abstract class EventSubscribeServicePlatform extends Service {
  EventSubscribeServicePlatform() : super(token: _token);
  static final Object _token = Object();

  static EventSubscribeServicePlatform _instance =
      MethodChannelEventSubscribeService();

  static EventSubscribeServicePlatform get instance => _instance;

  static set instance(EventSubscribeServicePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  ///监听所订阅的事件
  //ignore: close_sinks
  final StreamController<List<Event>> eventSubscribeStream =
      StreamController<List<Event>>.broadcast();

  ///订阅指定账号的在线状态事件
  Future<NIMResult<List<String>>> registerEventSubscribe(
      EventSubscribeRequest request) async {
    throw UnimplementedError('registerEventSubscribe() is not implemented');
  }

  ///取消指定事件的全部订阅关系,只需填写事件类型
  Future<NIMResult<void>> batchUnSubscribeEvent(
      EventSubscribeRequest request) async {
    throw UnimplementedError('batchUnSubscribeEvent() is not implemented');
  }

  ///取消订阅指定账号的在线状态事件,只需填写事件类型和事件发布者账号集合
  Future<NIMResult<void>> unregisterEventSubscribe(
      EventSubscribeRequest request) async {
    throw UnimplementedError('unregisterEventSubscribe() is not implemented');
  }

  ///向订阅者发布事件
  Future<NIMResult<void>> publishEvent(Event event) async {
    throw UnimplementedError('publishEvent() is not implemented');
  }

  ///查询事件订阅，用于查询某种事件的订阅关系
  Future<NIMResult<List<EventSubscribeResult>>> querySubscribeEvent(
      EventSubscribeRequest request) async {
    throw UnimplementedError('querySubscribeEvent() is not implemented');
  }
}
