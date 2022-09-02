// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:io';

import 'package:netease_auto_test_kit/netease_auto_test_kit.dart';

import 'case/handle_audio_recorder_case.dart';
import 'case/handle_chatroom_case.dart';
import 'case/handle_collect_case.dart';
import 'case/handle_event_subscribe_case.dart';
import 'case/handle_history_message_case.dart';
import 'case/handle_initialize_case.dart';
import 'case/handle_login_case.dart';
import 'case/handle_message_case.dart';
import 'case/handle_my_session_case.dart';
import 'case/handle_pin_case.dart';
import 'case/handle_quick_comment_case.dart';
import 'case/handle_settings_case.dart';
import 'case/handle_stick_top_session_case.dart';
import 'case/handle_system_message_case.dart';
import 'case/handle_team_case.dart';
import 'case/handle_user_case.dart';

final caseList = [
  HandleInitializeCase(),
  HandleSystemMessageCase(),
  HandleUserCase(),
  HandleLoginCase(),
  HandleTeamCase(),
  HandleEventSubscribeCase(),
  HandleHistoryMessageCase(),
  HandleChatroomCase(),
  HandleMessageCase(),
  HandleMySessionCase(),
  HandleQuickCommentCase(),
  HandleStickTopSessionCase(),
  HandleCollectCase(),
  HandlePinCase(),
  HandleSettingsCase(),
  HandleAudioRecorderCase(),
  // HandleSendMessageCase()
];

/// 配置case用例地址： https://g.hz.netease.com/yunxin-app/kit_automation_test/-/tree/release/integration_case
/// case模板，模板代码的class需要在 [nim_core_test.dart] 中注册。
/// 执行结果通过返回[handleCaseResult] ,做期望值匹配
/// 执行方式,请不要在本地执行：在packages/nim_core/nim_core/example目录下
/// flutter drive --driver=test_driver/integration_test.dart --target=integration_test/main_test.dart  --keep-app-running

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group(
    'im flutter',
    () => test('im flutter test', () async {
      if (Platform.isAndroid || Platform.isIOS) {
        await IntegratedPermissionHelper.requestPermissions(
            IntegratedConfig.permissions);
      }
      await IntegratedManager.instance.init(
          // localHost: '10.242.148.84',
          isDispatch: true,
          //默认设备配置内部调度
          applicationName: 'nimflutter',
          /*  platform: 'flutter',*/
          version: '1.0.0',
          /*  deviceIdMap: 'your case need devices', */
          /* tag: 'lcd/dev', */
          /* selectPartNameList: ['nim_collect'],*/
          packageId: Platform.isAndroid
              ? 'com.netease.nimflutter.nim_core_example'
              : 'com.netease.nimflutter.nimCoreExample',
          caseList: caseList);
    }, timeout: Timeout(Duration(minutes: 15))),
  );
}
