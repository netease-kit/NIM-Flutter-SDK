// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:nim_core_v2_platform_interface/nim_core_v2_platform_interface.dart';
import 'package:nim_core_v2_platform_interface/src/method_channel/method_channel_ohos_push_service.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

abstract class OhosPushServicePlatform extends Service {
  OhosPushServicePlatform() : super(token: _token);

  static final Object _token = Object();

  static OhosPushServicePlatform _instance = MethodChannelOhosPushService();

  static OhosPushServicePlatform get instance => _instance;

  static set instance(OhosPushServicePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// 开启/关闭第三方推送服务。
  ///
  /// [enable] true 开启，false 关闭。
  Future<NIMResult<void>> enable(bool enable) {
    throw UnimplementedError('enable() has not been implemented.');
  }

  /// 查询当前是否开启第三方推送服务。
  Future<NIMResult<bool>> isEnable() {
    throw UnimplementedError('isEnable() has not been implemented.');
  }
}
