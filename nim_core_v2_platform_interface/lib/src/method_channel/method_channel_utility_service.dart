// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:nim_core_v2_platform_interface/nim_core_v2_platform_interface.dart';

class MethodChannelUtilityService extends V2NIMUtilityServicePlatform {
  @override
  Future onEvent(String method, arguments) {
    switch (method) {
      case 'onMessagesProgress':
        final progress = (arguments as Map?)?['progress'];
        if (progress is int) {
          V2NIMUtilityServicePlatform.instance.onMessagesProgress.add(progress);
        }
        return Future.value();
      default:
        throw UnimplementedError();
    }
  }

  @override
  String get serviceName => 'UtilityService';

  @override
  Future<NIMResult<String>> exportMessagesToPath(
      NIMExportMessageOption option) async {
    return NIMResult<String>.fromMap(await invokeMethod(
      'exportMessagesToPath',
      arguments: {'option': option.toJson()},
    ));
  }

  @override
  Future<NIMResult<void>> importMessagesFromPath(
      NIMImportMessageOption option) async {
    return NIMResult<void>.fromMap(await invokeMethod(
      'importMessagesFromPath',
      arguments: {'option': option.toJson()},
    ));
  }

  @override
  Future<NIMResult<void>> cancelMigrateMessages() async {
    return NIMResult<void>.fromMap(await invokeMethod(
      'cancelMigrateMessages',
    ));
  }
}
