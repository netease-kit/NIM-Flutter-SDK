// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:nim_core/nim_core.dart';
import 'package:netease_auto_test_kit/netease_auto_test_kit.dart';

import 'method_name_value.dart';

class HandleAudioRecorderCase extends HandleBaseCase {
  HandleAudioRecorderCase();

  @override
  Future<ResultBean?> handle(event) async {
    super.handle(event);

    switch (methodName) {
      case startRecord:
        {
          NIMResult<bool> ret = await NimCore.instance.audioService
              .startRecord(AudioOutputFormat.AAC, 100);
          handleCaseResult =
              ResultBean(code: ret.code, data: ret.data, message: methodName);
          break;
        }
      case stopRecord:
        {
          NIMResult<bool> ret =
              await NimCore.instance.audioService.stopRecord();
          handleCaseResult =
              ResultBean(code: ret.code, data: ret.data, message: methodName);
          break;
        }
      case cancelRecord:
        {
          NIMResult<bool> ret =
              await NimCore.instance.audioService.cancelRecord();
          handleCaseResult =
              ResultBean(code: ret.code, data: ret.data, message: methodName);
          break;
        }
      case isAudioRecording:
        {
          NIMResult<bool> ret =
              await NimCore.instance.audioService.isAudioRecording();
          handleCaseResult =
              ResultBean(code: ret.code, data: ret.data, message: methodName);
          break;
        }
      case getAmplitude:
        {
          NIMResult<int> ret =
              await NimCore.instance.audioService.getAmplitude();
          handleCaseResult =
              ResultBean(code: ret.code, data: ret.data, message: methodName);
          break;
        }
    }
    return handleCaseResult;
  }
}
