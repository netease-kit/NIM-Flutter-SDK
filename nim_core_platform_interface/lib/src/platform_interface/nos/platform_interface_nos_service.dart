// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:nim_core_platform_interface/nim_core_platform_interface.dart';
import 'package:nim_core_platform_interface/src/method_channel/method_channel_nos_service.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

abstract class NOSServicePlatform extends Service {
  NOSServicePlatform() : super(token: _token);

  static final Object _token = Object();

  static NOSServicePlatform _instance = MethodChannelNOSService();

  static NOSServicePlatform get instance => _instance;

  static set instance(NOSServicePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  // ignore: close_sinks
  final StreamController<double> onNOSTransferProgress =
      StreamController<double>.broadcast();

  // ignore: close_sinks
  final StreamController<NIMNOSTransferStatus> onNOSTransferStatus =
      StreamController<NIMNOSTransferStatus>.broadcast();

  Future<NIMResult<String>> upload(
      {required String filePath, String? mimeType, String? sceneKey}) async {
    throw UnimplementedError('upload() is not implemented');
  }

  Future<NIMResult<void>> download(
      {required String url, required String path}) async {
    throw UnimplementedError('download() is not implemented');
  }
}
