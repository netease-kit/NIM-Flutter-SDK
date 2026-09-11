// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:nim_core_v2_platform_interface/nim_core_v2_platform_interface.dart';

/// Web 端统计服务实现
///
/// Web 平台不支持本地数据库，因此 getDatabaseInfos 返回空列表。
class WebStatisticsService extends StatisticsServicePlatform {
  @override
  String get serviceName => 'StatisticsService';

  @override
  Future<dynamic> onEvent(String method, dynamic arguments) async => null;

  @override
  Future<NIMResult<List<NIMDatabaseInfo>>> getDatabaseInfos() async {
    return NIMResult<List<NIMDatabaseInfo>>.failure(
      code: 199414,
      message: 'getDatabaseInfos is not supported on Web platform',
    );
  }
}
