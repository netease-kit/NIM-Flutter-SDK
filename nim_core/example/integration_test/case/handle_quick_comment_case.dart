// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:convert';

import 'package:nim_core/nim_core.dart';
import 'package:netease_auto_test_kit/netease_auto_test_kit.dart';

import 'method_name_value.dart';

class HandleQuickCommentCase extends HandleBaseCase {
  HandleQuickCommentCase();

  NIMMessage? _cacheMessage;

  @override
  Future<ResultBean?> handle(event) async {
    super.handle(event);
    var inputParams = Map<String, dynamic>();
    if (params != null && params!.length > 0) {
      inputParams = jsonDecode(params![0]) as Map<String, dynamic>;
    }

    switch (methodName) {
      case addQuickComment:
        {
          // 先发送然后comment
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
                .addQuickComment(
                    ret.data!,
                    inputParams['replyType'],
                    inputParams['ext'],
                    inputParams['needPush'],
                    inputParams['needBadge'],
                    inputParams['pushTitle'],
                    inputParams['pushContent'],
                    Map<String, Object>());
            handleCaseResult =
                ResultBean(code: result.code, data: null, message: methodName);
          } else {
            handleCaseResult = ResultBean(
                code: -1, data: 'send message failed', message: methodName);
          }
          break;
        }
      case removeQuickComment:
        {
          if (_cacheMessage != null) {
            final result = await NimCore.instance.messageService
                .removeQuickComment(
                    _cacheMessage!,
                    inputParams['replyType'],
                    inputParams['ext'],
                    inputParams['needPush'],
                    inputParams['needBadge'],
                    inputParams['pushTitle'],
                    inputParams['pushContent'],
                    Map<String, Object>());
            handleCaseResult =
                ResultBean(code: result.code, message: methodName, data: null);
          } else {
            handleCaseResult = ResultBean(
                code: -1, data: 'send message failed', message: methodName);
          }
          break;
        }
      case queryQuickComment:
        {
          if (_cacheMessage != null) {
            final result = await NimCore.instance.messageService
                .queryQuickComment([_cacheMessage!]);
            handleCaseResult =
                ResultBean(code: result.code, message: methodName, data: null);
          } else {
            handleCaseResult = ResultBean(
                code: -1, data: 'send message failed', message: methodName);
          }
          break;
        }
    }
    return handleCaseResult;
  }
}
