// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:convert';

import 'package:nim_core/nim_core.dart';
import 'package:netease_auto_test_kit/netease_auto_test_kit.dart';

import 'method_name_value.dart';

class HandlePinCase extends HandleBaseCase {
  HandlePinCase();

  NIMMessage? _cacheMessage;

  @override
  Future<ResultBean?> handle(event) async {
    super.handle(event);
    var inputParams = Map<String, dynamic>();
    if (params != null && params!.length > 0) {
      inputParams = jsonDecode(params![0]) as Map<String, dynamic>;
    }

    switch (methodName) {
      case addMessagePin:
        {
          // 先发送然后pin
          NIMResult<NIMMessage> retCreateMsg =
              await MessageBuilder.createTextMessage(
                  sessionId: inputParams['toAccount'] as String,
                  sessionType: NIMSessionType.p2p,
                  text: inputParams['text'] as String);
          var message = retCreateMsg.data;
          assert(message != null);
          NIMResult<NIMMessage> ret = await NimCore.instance.messageService
              .sendMessage(message: message!);
          if (ret.isSuccess) {
            _cacheMessage = ret.data;
            NIMResult<void> result = await NimCore.instance.messageService
                .addMessagePin(ret.data!, inputParams['ext']);
            handleCaseResult = ResultBean(
                code: result.code, data: result.toMap(), message: methodName);
          } else {
            handleCaseResult = ResultBean(
                code: -1, data: 'send message failed', message: methodName);
          }
          break;
        }
      case updateMessagePin:
        {
          if (_cacheMessage != null) {
            final result = await NimCore.instance.messageService
                .updateMessagePin(_cacheMessage!, inputParams['ext']);
            handleCaseResult = ResultBean(
                code: result.code, message: methodName, data: result.toMap());
          } else {
            handleCaseResult = ResultBean(
                code: -1, data: 'send message failed', message: methodName);
          }
          break;
        }
      case removeMessagePin:
        {
          if (_cacheMessage != null) {
            final result = await NimCore.instance.messageService
                .removeMessagePin(_cacheMessage!, inputParams['ext']);
            handleCaseResult = ResultBean(
                code: result.code, message: methodName, data: result.toMap());
          } else {
            handleCaseResult = ResultBean(
                code: -1, data: 'send message failed', message: methodName);
          }
          break;
        }
      case queryMessagePinForSession:
        {
          final result = await NimCore.instance.messageService
              .queryMessagePinForSession(
                  inputParams['sessionId'], NIMSessionType.p2p);
          handleCaseResult = ResultBean(
              code: result.code, message: methodName, data: result.toMap());
          break;
        }
    }
    return handleCaseResult;
  }
}