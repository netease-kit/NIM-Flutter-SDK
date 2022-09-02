// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:nim_core_platform_interface/nim_core_platform_interface.dart';

class MethodChannelEventSubscribeService extends EventSubscribeServicePlatform {
  @override
  String get serviceName => 'EventSubscribeService';

  @override
  Future onEvent(String method, arguments) {
    Map<String, dynamic> paramMap = Map<String, dynamic>.from(arguments);
    switch (method) {
      case 'observeEventChanged':
        _observeEventChanged(paramMap);
        break;
      default:
        break;
    }
    return Future.value(null);
  }

  _observeEventChanged(Map<String, dynamic> paramMap) {
    var paramList = paramMap['eventList'] as List<dynamic>?;
    List<Event>? eventList = paramList
        ?.map((e) => Event.fromMap(Map<String, dynamic>.from(e)))
        .toList();
    if (eventList != null)
      EventSubscribeServicePlatform.instance.eventSubscribeStream
          .add(eventList);
  }

  @override
  Future<NIMResult<List<String>>> registerEventSubscribe(
      EventSubscribeRequest request) async {
    Map<String, dynamic> replyMap = await invokeMethod('registerEventSubscribe',
        arguments: request.toMap());
    return NIMResult.fromMap(replyMap, convert: (map) {
      var resultList = map['resultList'] as List<dynamic>?;
      return resultList?.map((e) => e as String).toList();
    });
  }

  @override
  Future<NIMResult<void>> batchUnSubscribeEvent(
      EventSubscribeRequest request) async {
    Map<String, dynamic> replyMap =
        await invokeMethod('batchUnSubscribeEvent', arguments: request.toMap());
    return NIMResult.fromMap(replyMap);
  }

  @override
  Future<NIMResult<void>> unregisterEventSubscribe(
      EventSubscribeRequest request) async {
    Map<String, dynamic> replyMap = await invokeMethod(
        'unregisterEventSubscribe',
        arguments: request.toMap());
    return NIMResult.fromMap(replyMap);
  }

  @override
  Future<NIMResult<void>> publishEvent(Event event) async {
    Map<String, dynamic> replyMap =
        await invokeMethod('publishEvent', arguments: event.toMap());
    return NIMResult.fromMap(replyMap);
  }

  @override
  Future<NIMResult<List<EventSubscribeResult>>> querySubscribeEvent(
      EventSubscribeRequest request) async {
    Map<String, dynamic> replyMap =
        await invokeMethod('querySubscribeEvent', arguments: request.toMap());

    return NIMResult.fromMap(replyMap, convert: (map) {
      var eventSubscribeResultList =
          map['eventSubscribeResultList'] as List<dynamic>;
      return eventSubscribeResultList
          .map(
              (e) => EventSubscribeResult.fromMap(Map<String, dynamic>.from(e)))
          .toList();
    });
  }
}
