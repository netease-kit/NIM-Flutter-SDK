// Copyright (c) 2021 NetEase, Inc.  All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:nim_core_platform_interface/nim_core_platform_interface.dart';
import 'package:nim_core_platform_interface/src/platform_interface/nim_base.dart';
import 'package:nim_core_platform_interface/src/platform_interface/nos/nos.dart';

class MethodChannelNOSService extends NOSServicePlatform {
  Future<NIMResult<NIMUser>> getUserInfo(String userId) async {
    Map<String, String> argument = {'userId': userId};
    Map<String, dynamic> replyMap =
        await invokeMethod('getUserInfo', arguments: argument);
    return NIMResult.fromMap(replyMap, convert: (map) => NIMUser.fromMap(map));
  }

  Future<NIMResult<void>> upload(
      {required String filePath, String? mimeType, String? sceneKey}) async {
    Map<String, dynamic> argument = {
      'filePath': filePath,
      'mimeType': mimeType,
      'sceneKey': sceneKey
    };
    Map<String, dynamic> replyMap =
        await invokeMethod('upload', arguments: argument);
    return NIMResult.fromMap(replyMap);
  }

  @override
  String get serviceName => "NOSService";

  @override
  Future onEvent(String method, arguments) {
    switch (method) {
      case 'onNOSTransferProgress':
        var transferProgress = arguments['progress'] as double;
        NOSServicePlatform.instance.onNOSTransferProgress.add(transferProgress);
        break;

      case 'onNOSTransferStatus':
        var transferStatus = NIMNOSTransferStatus.fromMap(arguments);
        NOSServicePlatform.instance.onNOSTransferStatus.add(transferStatus);
        break;
    }
    return Future.value(null);
  }
}
