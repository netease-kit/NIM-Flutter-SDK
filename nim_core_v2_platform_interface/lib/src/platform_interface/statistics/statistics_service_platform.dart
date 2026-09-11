// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import '../../../nim_core_v2_platform_interface.dart';
import '../../method_channel/method_channel_statistics_service.dart';

export 'statistics_models.dart';

abstract class StatisticsServicePlatform extends Service {
  StatisticsServicePlatform() : super(token: _token);

  static final Object _token = Object();

  static StatisticsServicePlatform _instance = MethodChannelStatisticsService();

  static StatisticsServicePlatform get instance => _instance;

  static set instance(StatisticsServicePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// 获取当前登录用户所有数据库信息
  Future<NIMResult<List<NIMDatabaseInfo>>> getDatabaseInfos() {
    throw UnimplementedError('getDatabaseInfos() has not been implemented.');
  }
}
