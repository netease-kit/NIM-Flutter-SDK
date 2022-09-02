// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:convert';

import 'package:nim_core/nim_core.dart';
import 'package:netease_auto_test_kit/netease_auto_test_kit.dart';

import 'method_name_value.dart';

class HandleStickTopSessionCase extends HandleBaseCase {
  HandleStickTopSessionCase();

  @override
  Future<ResultBean?> handle(event) async {
    super.handle(event);
    var inputParams = Map<String, dynamic>();
    if (params != null && params!.length > 0) {
      inputParams = jsonDecode(params![0]) as Map<String, dynamic>;
    }

    switch (methodName) {
      case addStickTopSession:
        {
          NIMResult<void> result =
              await NimCore.instance.messageService.addStickTopSession(
            inputParams['sessionId'],
            NIMSessionType.p2p,
            inputParams['ext'],
          );
          handleCaseResult =
              ResultBean(code: result.code, data: null, message: methodName);
          break;
        }
      case updateStickTopSession:
        {
          final result =
              await NimCore.instance.messageService.updateStickTopSession(
            inputParams['sessionId'],
            NIMSessionType.p2p,
            inputParams['ext'],
          );
          handleCaseResult =
              ResultBean(code: result.code, message: methodName, data: null);
          break;
        }
      case queryStickTopSession:
        {
          final result =
              await NimCore.instance.messageService.queryStickTopSession();
          handleCaseResult =
              ResultBean(code: result.code, message: methodName, data: null);
          break;
        }
      case removeStickTopSession:
        {
          final result = await NimCore.instance.messageService
              .removeStickTopSession(inputParams['sessionId'],
                  NIMSessionType.p2p, inputParams['ext']);
          handleCaseResult =
              ResultBean(code: result.code, message: methodName, data: null);
          break;
        }
    }
    return handleCaseResult;
  }
}
