// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

part of nim_core_v2;

/// 统计服务，提供数据统计相关功能
@HawkEntryPoint()
class StatisticsService {
  factory StatisticsService() {
    if (_singleton == null) {
      _singleton = StatisticsService._();
    }
    return _singleton!;
  }

  StatisticsService._();

  static StatisticsService? _singleton;

  StatisticsServicePlatform get _platform => StatisticsServicePlatform.instance;

  /// 获取当前登录用户所有数据库信息
  Future<NIMResult<List<NIMDatabaseInfo>>> getDatabaseInfos() async {
    return _platform.getDatabaseInfos();
  }
}
