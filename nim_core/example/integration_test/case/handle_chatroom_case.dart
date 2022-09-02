// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:convert';

import 'package:nim_core/nim_core.dart';
import 'package:netease_auto_test_kit/netease_auto_test_kit.dart';

import 'method_name_value.dart';

class HandleChatroomCase extends HandleBaseCase {
  HandleChatroomCase();

  @override
  Future<ResultBean?> handle(event) async {
    super.handle(event);
    var handled = false;
    var result;
    if (className != 'ChatroomService') {
      return null;
    }
    switch (methodName) {
      case enterChatroom:
        {
          _addChatroomObserver();
          Map map = jsonDecode(params![0])['enterRequest'];
          final ret = await NimCore.instance.chatroomService.enterChatroom(
              NIMChatroomEnterRequest.fromMap(map.cast<String, dynamic>()));
          result = ret;
          handled = true;
          break;
        }
      case fetchChatroomMembers:
        {
          final result = await NimCore.instance.chatroomService
              .fetchChatroomMembers(
                  roomId: jsonDecode(params![0])['roomId'],
                  queryType: NIMChatroomMemberQueryType.allNormalMember,
                  limit: 10);
          handleCaseResult = ResultBean(
              code: result.code,
              message: methodName,
              data: result.data?.map((e) => e.toString()).toList());
          break;
        }
      case fetchChatroomQueue:
        {
          final result = await NimCore.instance.chatroomService
              .fetchChatroomQueue(jsonDecode(params![0])['roomId']);
          handleCaseResult = ResultBean(
              code: result.code,
              message: methodName,
              data: result.data?.map((e) => e.toMap()).toList());
          break;
        }
      case sendChatroomMessage:
        {
          Map map = jsonDecode(params![0])['message'];
          final result = await NimCore.instance.chatroomService
              .sendChatroomMessage(
                  NIMChatroomMessage.fromMap(map.cast<String, dynamic>()));
          handleCaseResult = ResultBean(
              code: result.code,
              message: methodName,
              data: result.data?.toMap());
          break;
        }
      case updateChatroomMyMemberInfo:
        {
          Map map = jsonDecode(params![1])['request'];
          final result = await NimCore.instance.chatroomService
              .updateChatroomMyMemberInfo(
                  roomId: jsonDecode(params![0])['roomId'],
                  request: NIMChatroomUpdateMyMemberInfoRequest.fromMap(
                      map.cast<String, dynamic>()),
                  needNotify: true);
          handleCaseResult =
              ResultBean(code: result.code, message: methodName, data: result);
          break;
        }
      case sendchatroomCustomMessage:
        {
          Map map = jsonDecode(params![0])['message'];
          final result = await NimCore.instance.chatroomService
              .sendChatroomMessage(
                  NIMChatroomMessage.fromMap(map.cast<String, dynamic>()));
          handleCaseResult = ResultBean(
              code: result.code,
              message: methodName,
              data: result.data?.toMap());
          break;
        }
    }
    if (handled) {
      print('ChatroomServiceTest#$methodName result: ${result.code}');
      handleCaseResult = ResultBean(
        code: result.code,
        data: result.toMap(),
        message: result.errorDetails,
      );
    }
    return handleCaseResult;
  }

  _addChatroomObserver() {
    NimCore.instance.chatroomService.onMessageReceived.listen((event) {
      print('Test_Observer onMessageReceived');
      print(event.map((e) => e.toMap()).toList());
    });
  }
}
