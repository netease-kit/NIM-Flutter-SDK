// Copyright (c) 2021 NetEase, Inc.  All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:nim_core_platform_interface/src/platform_interface/initialize/nim_sdk_options.dart';
import 'package:nim_core_platform_interface/src/platform_interface/initialize/platform_interface_initialize_service.dart';
import 'package:nim_core_platform_interface/src/platform_interface/nim_base.dart';

class MethodChannelInitializeService extends InitializeServicePlatform {
  @override
  Future<NIMResult<void>> initialize(NIMSDKOptions options) async {
    return NIMResult.fromMap(
      await invokeMethod(
        'initialize',
        arguments: options.toMap(),
      ),
    );
  }

  @override
  Future onEvent(String method, arguments) {
    throw UnimplementedError();
  }

  @override
  String get serviceName => 'InitializeService';
}
