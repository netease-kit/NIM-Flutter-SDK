// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:convert';
import 'dart:io';

import 'package:nim_core/nim_core.dart';
import 'package:netease_auto_test_kit/netease_auto_test_kit.dart';

import 'method_name_value.dart';

class HandleSettingsCase extends HandleBaseCase {
  HandleSettingsCase();

  @override
  Future<ResultBean?> handle(event) async {
    super.handle(event);
    var inputParams = Map<String, dynamic>();
    if (params != null && params!.length > 0) {
      inputParams = jsonDecode(params![0]) as Map<String, dynamic>;
    }

    switch (methodName) {
      case enableMobilePushWhenPCOnline:
        {
          NIMResult<void> result = await NimCore.instance.settingsService
              .enableMobilePushWhenPCOnline(enable: inputParams['enable']);
          handleCaseResult =
              ResultBean(code: result.code, data: null, message: methodName);
          break;
        }
      case isMobilePushEnabledWhenPCOnline:
        {
          NIMResult<bool> result = await NimCore.instance.settingsService
              .isMobilePushEnabledWhenPCOnline();
          handleCaseResult = ResultBean(
              code: result.code, data: result.data, message: methodName);

          break;
        }
      case setPushNoDisturbConfig:
        {
          NIMResult<void> result = await NimCore.instance.settingsService
              .setPushNoDisturbConfig(
                  NIMPushNoDisturbConfig.fromMap(inputParams));
          handleCaseResult = ResultBean(
              code: result.code, message: methodName, data: result.toMap());

          break;
        }
      case getPushNoDisturbConfig:
        {
          NIMResult<NIMPushNoDisturbConfig> result =
              await NimCore.instance.settingsService.getPushNoDisturbConfig();
          handleCaseResult = ResultBean(
              code: result.code,
              message: methodName,
              data: result.data?.toMap());
          break;
        }
      case isPushShowDetailEnabled:
        {
          NIMResult<bool> result =
              await NimCore.instance.settingsService.isPushShowDetailEnabled();
          handleCaseResult = ResultBean(
              code: result.code, message: methodName, data: result.data);
          break;
        }
      case enablePushShowDetail:
        {
          NIMResult<void> result = await NimCore.instance.settingsService
              .enablePushShowDetail(inputParams['enable']);
          handleCaseResult = ResultBean(
              code: result.code, message: methodName, data: result.toMap());
          break;
        }
      case updateAPNSToken:
        {
          NIMResult<void> result = await NimCore.instance.settingsService
              .updateAPNSToken(inputParams['token'], "自定义");
          handleCaseResult = ResultBean(
              code: result.code, message: methodName, data: result.toMap());
          break;
        }
      case getSizeOfDirCache:
        {
          var fileTypesTmp = inputParams['fileTypes'] as List<dynamic>;
          NIMResult<int> result = await NimCore.instance.settingsService
              .getSizeOfDirCache(
                  fileTypesTmp
                      .map((e) => enumifyDirCacheFileTypeName(e))
                      .toList(),
                  inputParams['startTime'] as int,
                  inputParams['endTime'] as int);
          handleCaseResult = ResultBean(
              code: result.code, message: methodName, data: result.toMap());
          break;
        }
      case clearDirCache:
        {
          var fileTypesTmp = inputParams['fileTypes'] as List<dynamic>;
          NIMResult<void> result = await NimCore.instance.settingsService
              .clearDirCache(
                  fileTypesTmp
                      .map((e) => enumifyDirCacheFileTypeName(e))
                      .toList(),
                  inputParams['startTime'] as int,
                  inputParams['endTime'] as int);
          handleCaseResult = ResultBean(
              code: result.code, message: methodName, data: result.toMap());
          break;
        }
      case uploadLogs:
        {
          NIMResult<String> result = await NimCore.instance.settingsService
              .uploadLogs(comment: inputParams['comment']);
          handleCaseResult = ResultBean(
              code: result.code, message: methodName, data: result.toMap());
          break;
        }
      case archiveLogs:
        {
          if (Platform.isWindows || Platform.isMacOS) {
            handleCaseResult =
                ResultBean.success(message: "desktop default success");
            break;
          }
          NIMResult<String> result =
              await NimCore.instance.settingsService.archiveLogs();
          handleCaseResult = ResultBean(
              code: result.code, message: methodName, data: result.data);
          break;
        }
    }
    return handleCaseResult;
  }
}
