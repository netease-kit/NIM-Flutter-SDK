// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:convert';
import 'dart:io';

import 'package:nim_core/nim_core.dart';
import 'package:netease_auto_test_kit/netease_auto_test_kit.dart';

import 'method_name_value.dart';

class HandleSystemMessageCase extends HandleBaseCase {
  HandleSystemMessageCase();

  @override
  Future<ResultBean?> handle(event) async {
    super.handle(event);

    var inputParams = Map<String, dynamic>();
    if (params != null && params!.length > 0) {
      inputParams = jsonDecode(params![0]) as Map<String, dynamic>;
    }
    switch (methodName) {
      case querySystemMessagesIOSAndDesktop:
        {
          if (Platform.isAndroid) {
            handleCaseResult =
                ResultBean(code: 0, data: 'default succ', message: methodName);
          } else {
            NIMResult<List<SystemMessage>> result = await NimCore
                .instance.systemMessageService
                .querySystemMessagesIOSAndDesktop(
                    // 不处理锚点消息
                    // SystemMessage.fromMap(inputParams['message']),
                    null,
                    inputParams['limit']);
            handleCaseResult = ResultBean(
                code: result.code,
                data: result.data?.map((e) => e.toMap()).toList(),
                message: methodName);
          }
          break;
        }
      case querySystemMessagesAndroid:
        {
          if (Platform.isAndroid) {
            NIMResult<List<SystemMessage>> result = await NimCore
                .instance.systemMessageService
                .querySystemMessagesAndroid(
                    inputParams['offset'], inputParams['limit']);
            handleCaseResult = ResultBean(
                code: result.code,
                data: result.data?.map((e) => e.toMap()).toList(),
                message: methodName);
          } else {
            handleCaseResult =
                ResultBean(code: 0, data: 'default succ', message: methodName);
          }
          break;
        }
      case querySystemMessageByTypeIOSAndDesktop:
        {
          if (Platform.isAndroid) {
            handleCaseResult =
                ResultBean(code: 0, data: 'default succ', message: methodName);
          } else {
            var paramList = inputParams['types'] as List<dynamic>;
            List<SystemMessageType> systemMessageTypeList = paramList
                .map((e) => SystemMessageTypeConverter().fromValue(e as String))
                .toList();
            NIMResult<List<SystemMessage>> result = await NimCore
                .instance.systemMessageService
                .querySystemMessageByTypeIOSAndDesktop(
                    // 不处理锚点消息
                    // SystemMessage.fromMap(inputParams['message']),
                    null,
                    systemMessageTypeList,
                    inputParams['limit']);
            handleCaseResult = ResultBean(
                code: result.code,
                data: result.data?.map((e) => e.toString()).toList(),
                message: methodName);
          }
          break;
        }
      case querySystemMessageByTypeAndroid:
        {
          if (Platform.isAndroid) {
            var paramList = inputParams['types'] as List<dynamic>;
            List<SystemMessageType> systemMessageTypeList = paramList
                .map((e) => SystemMessageTypeConverter().fromValue(e as String))
                .toList();
            NIMResult<List<SystemMessage>> result = await NimCore
                .instance.systemMessageService
                .querySystemMessageByTypeAndroid(systemMessageTypeList,
                    inputParams['offset'], inputParams['limit']);
            handleCaseResult = ResultBean(
                code: result.code,
                data: result.data?.map((e) => e.toString()).toList(),
                message: methodName);
          } else {
            handleCaseResult =
                ResultBean(code: 0, data: 'default succ', message: methodName);
          }
          break;
        }
      case querySystemMessageUnread:
        {
          NIMResult<List<SystemMessage>> result = await NimCore
              .instance.systemMessageService
              .querySystemMessageUnread();
          handleCaseResult = ResultBean(
              code: result.code,
              data: result.data?.map((e) => e.toString()).toList(),
              message: methodName);
          break;
        }
      case querySystemMessageUnreadCount:
        {
          NIMResult<int> result = await NimCore.instance.systemMessageService
              .querySystemMessageUnreadCount();
          handleCaseResult = ResultBean(
              code: result.code, data: result.data, message: methodName);
          break;
        }
      case querySystemMessageUnreadCountByType:
        {
          var paramList = inputParams['systemMessageTypeList'] as List<dynamic>;
          List<SystemMessageType> systemMessageTypeList = paramList
              .map((e) => SystemMessageTypeConverter().fromValue(e as String))
              .toList();
          NIMResult<int> result = await NimCore.instance.systemMessageService
              .querySystemMessageUnreadCountByType(systemMessageTypeList);
          handleCaseResult = ResultBean(
              code: result.code, data: result.data, message: methodName);
          break;
        }
      case resetSystemMessageUnreadCount:
        {
          NIMResult<void> result = await NimCore.instance.systemMessageService
              .resetSystemMessageUnreadCount();
          handleCaseResult = ResultBean(
              code: result.code, data: result.toMap(), message: methodName);
          break;
        }
      case resetSystemMessageUnreadCountByType:
        {
          var paramList = inputParams['systemMessageTypeList'] as List<dynamic>;
          List<SystemMessageType> systemMessageTypeList = paramList
              .map((e) => SystemMessageTypeConverter().fromValue(e as String))
              .toList();
          NIMResult<void> result = await NimCore.instance.systemMessageService
              .resetSystemMessageUnreadCountByType(systemMessageTypeList);
          handleCaseResult = ResultBean(
              code: result.code, data: result.toMap(), message: methodName);
          break;
        }
      case setSystemMessageRead:
        {
          NIMResult<void> result = await NimCore.instance.systemMessageService
              .setSystemMessageRead(inputParams['messageId']);
          handleCaseResult = ResultBean(
              code: result.code, data: result.toMap(), message: methodName);
          break;
        }
      case clearSystemMessages:
        {
          NIMResult<void> result =
              await NimCore.instance.systemMessageService.clearSystemMessages();
          handleCaseResult = ResultBean(
              code: result.code, data: result.toMap(), message: methodName);
          break;
        }
      case clearSystemMessagesByType:
        {
          var paramList = inputParams['systemMessageTypeList'] as List<dynamic>;
          List<SystemMessageType> systemMessageTypeList = paramList
              .map((e) => SystemMessageTypeConverter().fromValue(e as String))
              .toList();
          NIMResult<void> result = await NimCore.instance.systemMessageService
              .clearSystemMessagesByType(systemMessageTypeList);
          handleCaseResult = ResultBean(
              code: result.code, data: result.toMap(), message: methodName);
          break;
        }
      case deleteSystemMessage:
        {
          NIMResult<void> result = await NimCore.instance.systemMessageService
              .deleteSystemMessage(inputParams['messageId'] as int);
          handleCaseResult = ResultBean(
              code: result.code, data: result.toMap(), message: methodName);
          break;
        }
      case setSystemMessageStatus:
        {
          NIMResult<void> result = await NimCore.instance.systemMessageService
              .setSystemMessageStatus(
                  inputParams['messageId'] as int,
                  SystemMessageStatusConverter()
                      .fromValue(inputParams['systemMessageStatus'] as String));
          handleCaseResult = ResultBean(
              code: result.code, data: result.toMap(), message: methodName);
          break;
        }
      case sendCustomNotification:
        {
          NIMResult<void> result = await NimCore.instance.systemMessageService
              .sendCustomNotification(CustomNotification.fromMap(inputParams));
          handleCaseResult = ResultBean(
              code: result.code, data: result.toMap(), message: methodName);
          break;
        }
    }
    return handleCaseResult;
  }
}
