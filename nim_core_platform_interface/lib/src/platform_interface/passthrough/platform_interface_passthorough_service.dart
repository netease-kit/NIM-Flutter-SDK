// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:nim_core_platform_interface/nim_core_platform_interface.dart';
import 'package:nim_core_platform_interface/src/method_channel/method_channel_passthough_service.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

abstract class PassThroughServicePlatform extends Service {
  PassThroughServicePlatform() : super(token: _token);

  static final Object _token = Object();

  static PassThroughServicePlatform _instance =
      MethodChannelPassThroughService();

  static PassThroughServicePlatform get instance => _instance;

  static set instance(PassThroughServicePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<NIMResult<NIMPassThroughProxyData>> httpProxy(
    NIMPassThroughProxyData passThroughProxyData,
  ) async {
    throw UnimplementedError('httpProxy() is not implemented');
  }

  //ignore: close_sinks
  final StreamController<NIMPassThroughNotifyData> onPassThroughNotifyData =
      StreamController<NIMPassThroughNotifyData>.broadcast();
}
