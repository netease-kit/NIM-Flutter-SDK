// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:convert';

import 'package:nim_core/nim_core.dart';
import 'package:netease_auto_test_kit/netease_auto_test_kit.dart';

import 'method_name_value.dart';

class HandleMySessionCase extends HandleBaseCase {
  HandleMySessionCase();

  @override
  Future<ResultBean?> handle(event) async {
    super.handle(event);
    var inputParams = Map<String, dynamic>();
    if (params != null && params!.length > 0) {
      inputParams = jsonDecode(params![0]) as Map<String, dynamic>;
    }

    switch (methodName) {
      case queryMySessionList:
        {
          NIMResult<void> result = await NimCore.instance.messageService
              .queryMySessionList(
                  inputParams['minTimestamp'],
                  inputParams['maxTimestamp'],
                  inputParams['needLastMsg'],
                  inputParams['limit'],
                  inputParams['hasMore']);
          handleCaseResult =
              ResultBean(code: result.code, data: null, message: methodName);
          break;
        }
      case queryMySession:
        {
          final result = await NimCore.instance.messageService
              .queryMySession(inputParams['sessionId'], NIMSessionType.p2p);
          handleCaseResult =
              ResultBean(code: result.code, message: methodName, data: null);
          break;
        }
      case updateMySession:
        {
          final result = await NimCore.instance.messageService.updateMySession(
              inputParams['sessionId'], NIMSessionType.p2p, inputParams['ext']);
          handleCaseResult =
              ResultBean(code: result.code, message: methodName, data: null);
          break;
        }
      case deleteMySession:
        {
          final result = await NimCore.instance.messageService.deleteMySession([
            NIMMySessionKey(
                sessionId: inputParams['sessionId'],
                sessionType: NIMSessionType.p2p)
          ]);
          handleCaseResult =
              ResultBean(code: result.code, message: methodName, data: null);
          break;
        }
    }
    return handleCaseResult;
  }
}
