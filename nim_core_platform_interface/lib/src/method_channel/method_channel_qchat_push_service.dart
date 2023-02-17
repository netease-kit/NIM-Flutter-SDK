// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:nim_core_platform_interface/nim_core_platform_interface.dart';

class MethodChannelQChatPushService extends QChatPushServicePlatform {
  @override
  Future onEvent(String method, arguments) {
    return Future.value();
  }

  @override
  String get serviceName => 'QChatPushService';

  @override
  Future<NIMResult<void>> enableAndroid(bool enable) async {
    return NIMResult<void>.fromMap(
        await invokeMethod('enableAndroid', arguments: {"enable": enable}));
  }

  @override
  Future<NIMResult<QChatPushConfig>> getPushConfig() async {
    return NIMResult<QChatPushConfig>.fromMap(
        await invokeMethod('getPushConfig'),
        convert: (json) => QChatPushConfig.fromJson(json));
  }

  @override
  Future<NIMResult<bool>> isEnableAndroid() async {
    return NIMResult<bool>.fromMap(await invokeMethod('isEnableAndroid'));
  }

  @override
  Future<NIMResult<bool>> isPushConfigExistAndroid() async {
    return NIMResult<bool>.fromMap(
        await invokeMethod('isPushConfigExistAndroid'));
  }

  @override
  Future<NIMResult<void>> setPushConfig(QChatPushConfig param) async {
    return NIMResult<void>.fromMap(
        await invokeMethod('setPushConfig', arguments: param.toJson()));
  }
}
