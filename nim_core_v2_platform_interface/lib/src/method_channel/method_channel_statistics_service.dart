// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import '../../nim_core_v2_platform_interface.dart';

class MethodChannelStatisticsService extends StatisticsServicePlatform {
  @override
  Future onEvent(String method, arguments) {
    throw UnimplementedError();
  }

  @override
  String get serviceName => 'StatisticsService';

  /// 获取当前登录用户所有数据库信息
  @override
  Future<NIMResult<List<NIMDatabaseInfo>>> getDatabaseInfos() async {
    return NIMResult.fromMap(
      await invokeMethod('getDatabaseInfos'),
      convert: (json) => (json['databaseInfoList'] as List<dynamic>?)
          ?.map((e) =>
              NIMDatabaseInfo.fromJson((e as Map).cast<String, dynamic>()))
          .toList(),
    );
  }
}
