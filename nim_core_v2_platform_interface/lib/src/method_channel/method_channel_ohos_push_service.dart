// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:nim_core_v2_platform_interface/nim_core_v2_platform_interface.dart';

class MethodChannelOhosPushService extends OhosPushServicePlatform {
  @override
  String get serviceName => 'PushService';

  @override
  Future<dynamic> onEvent(String method, dynamic arguments) {
    return Future.value();
  }

  @override
  Future<NIMResult<void>> enable(bool enable) async {
    return NIMResult<void>.fromMap(
      await invokeMethod('enable', arguments: {'enable': enable}),
    );
  }

  @override
  Future<NIMResult<bool>> isEnable() async {
    return NIMResult<bool>.fromMap(await invokeMethod('isEnable'));
  }
}
