// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:nim_core_platform_interface/nim_core_platform_interface.dart';
import 'package:nim_core_platform_interface/src/method_channel/method_channel_initialize_service.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

abstract class InitializeServicePlatform extends Service {
  InitializeServicePlatform() : super(token: _token);

  static final Object _token = Object();

  static InitializeServicePlatform _instance = MethodChannelInitializeService();

  static InitializeServicePlatform get instance => _instance;

  static set instance(InitializeServicePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<NIMResult<void>> initialize(NIMSDKOptions options,
      [Map<String, dynamic>? extras]);

  Future<NIMResult<void>> releaseDesktop();
}
