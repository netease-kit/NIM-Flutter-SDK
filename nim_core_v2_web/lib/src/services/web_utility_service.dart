// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:nim_core_v2_platform_interface/nim_core_v2_platform_interface.dart';

/// Web 端工具类服务实现
///
/// Web 平台不支持本地消息迁移功能，所有接口统一返回错误码 199414。
class WebUtilityService extends V2NIMUtilityServicePlatform {
  @override
  String get serviceName => 'V2NIMUtilityService';

  @override
  Future<dynamic> onEvent(String method, dynamic arguments) async => null;

  @override
  Future<NIMResult<String>> exportMessagesToPath(
      NIMExportMessageOption option) async {
    return NIMResult<String>.failure(
      code: 199414,
      message: 'exportMessagesToPath is not supported on Web platform',
    );
  }

  @override
  Future<NIMResult<void>> importMessagesFromPath(
      NIMImportMessageOption option) async {
    return NIMResult<void>.failure(
      code: 199414,
      message: 'importMessagesFromPath is not supported on Web platform',
    );
  }

  @override
  Future<NIMResult<void>> cancelMigrateMessages() async {
    return NIMResult<void>.failure(
      code: 199414,
      message: 'cancelMigrateMessages is not supported on Web platform',
    );
  }
}
