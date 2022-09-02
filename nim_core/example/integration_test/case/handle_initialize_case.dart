// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:convert';
import 'dart:io';

import 'package:nim_core/nim_core.dart';
import 'package:netease_auto_test_kit/netease_auto_test_kit.dart';

import 'method_name_value.dart';

class HandleInitializeCase extends HandleBaseCase {
  HandleInitializeCase();

  @override
  Future<ResultBean?> handle(event) async {
    super.handle(event);
    switch (methodName) {
      case initialize:
        Map map = jsonDecode(params![0]);
        Map optionsMap = map.entries.first.value;
        final result = await NimCore.instance.initialize(Platform.isAndroid
            ? NIMAndroidSDKOptions.fromMap(optionsMap)
            : Platform.isIOS
                ? NIMIOSSDKOptions.fromMap(optionsMap)
                : Platform.isWindows
                    ? NIMWINDOWSSDKOptions.fromMap(optionsMap)
                    : NIMMACOSSDKOptions.fromMap(optionsMap));
        print('=========>>initialize: ${result.code}');
        handleCaseResult = ResultBean(
          code: result.code,
          data: result.toMap(),
          message: result.errorDetails,
        );
        break;
    }

    return handleCaseResult;
  }
}
