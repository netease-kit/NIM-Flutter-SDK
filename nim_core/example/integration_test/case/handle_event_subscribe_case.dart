// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:convert';

import 'package:nim_core/nim_core.dart';
import 'package:netease_auto_test_kit/netease_auto_test_kit.dart';

import 'method_name_value.dart';

class HandleEventSubscribeCase extends HandleBaseCase {
  HandleEventSubscribeCase();

  @override
  Future<ResultBean?> handle(event) async {
    super.handle(event);

    var inputParams = Map<String, dynamic>();
    if (params != null && params!.length > 0) {
      inputParams = jsonDecode(params![0]) as Map<String, dynamic>;
    }

    switch (methodName) {
      case registerEventSubscribe:
        var publish = inputParams['publishers'] as List<dynamic>;
        List<String> publisherList = publish.map((e) => e.toString()).toList();
        EventSubscribeRequest request = EventSubscribeRequest(
            eventType: inputParams['eventType'],
            expiry: inputParams['expiry'],
            syncCurrentValue: inputParams['syncCurrentValue'],
            publishers: publisherList);
        final result = await NimCore.instance.eventSubscribeService
            .registerEventSubscribe(request);
        print(
            '=========>>eventSubscribeService:${result.code}：${result.errorDetails}');
        handleCaseResult = ResultBean(
            code: result.code, data: result.toMap(), message: methodName);
        break;
      case batchUnSubscribeEvent:
        var publish = inputParams['publishers'] as List<dynamic>;
        List<String> publisherList = publish.map((e) => e.toString()).toList();
        EventSubscribeRequest request = EventSubscribeRequest(
            eventType: inputParams['eventType'],
            expiry: inputParams['expiry'],
            syncCurrentValue: inputParams['syncCurrentValue'],
            publishers: publisherList);
        final result = await NimCore.instance.eventSubscribeService
            .batchUnSubscribeEvent(request);
        print(
            '=========>>eventSubscribeService:${result.code}：${result.errorDetails}');
        handleCaseResult = ResultBean(
            code: result.code, data: result.toMap(), message: methodName);
        break;
      case unregisterEventSubscribe:
        var publish = inputParams['publishers'] as List<dynamic>;
        List<String> publisherList = publish.map((e) => e.toString()).toList();
        EventSubscribeRequest request = EventSubscribeRequest(
            eventType: inputParams['eventType'],
            expiry: inputParams['expiry'],
            syncCurrentValue: inputParams['syncCurrentValue'],
            publishers: publisherList);
        final result = await NimCore.instance.eventSubscribeService
            .unregisterEventSubscribe(request);
        print(
            '=========>>eventSubscribeService:${result.code}：${result.errorDetails}');
        handleCaseResult = ResultBean(
            code: result.code, data: result.toMap(), message: methodName);
        break;
      case publishEvent:
        Event event = Event.fromMap(inputParams);
        final result =
            await NimCore.instance.eventSubscribeService.publishEvent(event);
        print(
            '=========>>eventSubscribeService:${result.code}：${result.errorDetails}');
        handleCaseResult = ResultBean(
            code: result.code, data: result.toMap(), message: methodName);
        break;
      case querySubscribeEvent:
        var publish = inputParams['publishers'] as List<dynamic>;
        List<String> publisherList = publish.map((e) => e.toString()).toList();
        EventSubscribeRequest request = EventSubscribeRequest(
            eventType: inputParams['eventType'],
            expiry: inputParams['expiry'],
            syncCurrentValue: inputParams['syncCurrentValue'],
            publishers: publisherList);
        final result = await NimCore.instance.eventSubscribeService
            .querySubscribeEvent(request);
        print(
            '=========>>eventSubscribeService:${result.code}：${result.errorDetails}');
        handleCaseResult = ResultBean(
            code: result.code, data: result.toMap(), message: methodName);
        break;
    }

    return handleCaseResult;
  }
}
