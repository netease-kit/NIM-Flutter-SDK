// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:nim_core_platform_interface/nim_core_platform_interface.dart';

class EventSubscribeService {
  factory EventSubscribeService() {
    if (_singleton == null) {
      _singleton = EventSubscribeService._();
    }
    return _singleton!;
  }

  EventSubscribeService._();

  static EventSubscribeService? _singleton;

  EventSubscribeServicePlatform get _platform =>
      EventSubscribeServicePlatform.instance;

  ///事件状态变更
  Stream<List<Event>> get eventSubscribeStream =>
      EventSubscribeServicePlatform.instance.eventSubscribeStream.stream;

  ///订阅指定账号的在线状态事件
  ///返回订阅失败的账号集合，如果数组长度为0则全部成功。如果出错，会有具体的错误代码。
  Future<NIMResult<List<String>>> registerEventSubscribe(
      EventSubscribeRequest request) async {
    return _platform.registerEventSubscribe(request);
  }

  ///取消指定事件的全部订阅关系,只需填写事件类型
  Future<NIMResult<void>> batchUnSubscribeEvent(
      EventSubscribeRequest request) async {
    return _platform.batchUnSubscribeEvent(request);
  }

  ///取消订阅指定账号的在线状态事件,只需填写事件类型和事件发布者账号集合
  Future<NIMResult<void>> unregisterEventSubscribe(
      EventSubscribeRequest request) async {
    return _platform.unregisterEventSubscribe(request);
  }

  ///向订阅者发布事件
  Future<NIMResult<void>> publishEvent(Event event) async {
    return _platform.publishEvent(event);
  }

  ///查询事件订阅，用于查询某种事件的订阅关系
  Future<NIMResult<List<EventSubscribeResult>>> querySubscribeEvent(
      EventSubscribeRequest request) async {
    return _platform.querySubscribeEvent(request);
  }
}
