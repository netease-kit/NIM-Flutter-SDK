// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

// import 'dart:io';

// import 'package:flutter_test/flutter_test.dart';
// import 'package:integration_test/integration_test.dart';
// import 'package:hawk/hawk.dart';

// import '../../../nim_core/example/integration_test/main_test.dart';

/// 配置case用例地址： https://g.hz.netease.com/yunxin-app/kit_automation_test/-/tree/release/integration_case
/// case模板，模板代码的class需要在 [nim_core_test.dart] 中注册。
/// 执行结果通过返回[handleCaseResult] ,做期望值匹配
/// 执行方式,请不要在本地执行：在packages/nim_core/nim_core/example目录下
/// flutter drive --driver=test_driver/integration_test.dart --target=integration_test/main_test.dart  --keep-app-running

void main() {
  // IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  // group(
  //   'im flutter',
  //   () => test('im flutter test', () async {
  //     // await IntegratedPermissionHelper.requestPermissions(
  //     //     IntegratedConfig.permissions);
  //     await IntegratedManager.instance.init(
  //         // localHost: '10.242.148.84',
  //         // isDispatch: true, //默认设备配置内部调度
  //         applicationName: 'nimflutter',
  //         // platform: 'flutter',
  //         version: '1.0.0',
  //         // deviceIdMap: 'your case need devices',
  //         // tag: 'release/integration_case',
  //         // selectPartNameList: ['nim_collect'],
  //         packageId:
  //             /*Platform.isAndroid
  //             ? 'com.netease.nimflutter.nim_core_example'
  //             : 'com.netease.nimflutter.nimCoreExample'*/
  //             '',
  //         caseList: caseList);
  //   }, timeout: Timeout(Duration(minutes: 15))),
  // );
}
