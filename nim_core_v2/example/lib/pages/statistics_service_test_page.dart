// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:nim_core_v2/nim_core.dart';

import '../widgets/test_case_tile.dart';

class StatisticsServiceTestPage extends StatelessWidget {
  const StatisticsServiceTestPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('统计服务测试')),
      body: ListView(
        children: [
          TestCaseTile(
            title: '1. getDatabaseInfos - 获取数据库信息列表',
            description: '验证返回列表非空，检查每个 NIMDatabaseInfo 的 path/name/size 字段',
            onRun: () async {
              final result =
                  await NimCore.instance.statisticsService.getDatabaseInfos();
              if (!result.isSuccess) {
                throw Exception(
                    'code=${result.code}, msg=${result.errorDetails}');
              }
              final list = result.data;
              if (list == null || list.isEmpty) {
                throw Exception('返回数据库列表为空');
              }
              for (final info in list) {
                print(
                    '[getDatabaseInfos] name=${info.name}, path=${info.path}, size=${info.size}');
                if (info.name == null || info.name!.isEmpty) {
                  throw Exception('NIMDatabaseInfo.name 为空');
                }
                if (info.path == null || info.path!.isEmpty) {
                  throw Exception('NIMDatabaseInfo.path 为空');
                }
                if (info.size == null || info.size! < 0) {
                  throw Exception('NIMDatabaseInfo.size 异常: ${info.size}');
                }
              }
            },
          ),
          TestCaseTile(
            title: '2. getDatabaseInfos - 数据结构完整性验证',
            description: '逐个检查返回列表中每条数据库信息的字段类型',
            onRun: () async {
              final result =
                  await NimCore.instance.statisticsService.getDatabaseInfos();
              if (!result.isSuccess) {
                throw Exception(
                    'code=${result.code}, msg=${result.errorDetails}');
              }
              final list = result.data ?? [];
              print('[getDatabaseInfos] 共 ${list.length} 个数据库');
              for (int i = 0; i < list.length; i++) {
                final info = list[i];
                print('[getDatabaseInfos] [$i] ${info.toJson()}');
              }
            },
          ),
        ],
      ),
    );
  }
}
