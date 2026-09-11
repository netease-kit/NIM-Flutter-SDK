// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:nim_core_v2_platform_interface/nim_core_v2_platform_interface.dart';
import 'package:nim_core_v2_platform_interface/src/method_channel/method_channel_utility_service.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

abstract class V2NIMUtilityServicePlatform extends Service {
  V2NIMUtilityServicePlatform() : super(token: _token);

  static final Object _token = Object();

  static V2NIMUtilityServicePlatform _instance = MethodChannelUtilityService();

  static V2NIMUtilityServicePlatform get instance => _instance;

  static set instance(V2NIMUtilityServicePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// 导出/导入消息进度事件（0–100）
  final StreamController<int> onMessagesProgress =
      StreamController<int>.broadcast();

  /// 导出消息到指定路径
  Future<NIMResult<String>> exportMessagesToPath(
      NIMExportMessageOption option) async {
    throw UnimplementedError(
        'exportMessagesToPath() has not been implemented.');
  }

  /// 从指定路径导入消息
  Future<NIMResult<void>> importMessagesFromPath(
      NIMImportMessageOption option) async {
    throw UnimplementedError(
        'importMessagesFromPath() has not been implemented.');
  }

  /// 取消正在进行的消息迁移
  Future<NIMResult<void>> cancelMigrateMessages() async {
    throw UnimplementedError(
        'cancelMigrateMessages() has not been implemented.');
  }
}
