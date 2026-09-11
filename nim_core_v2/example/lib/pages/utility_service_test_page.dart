// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nim_core_v2/nim_core.dart';
import 'package:path_provider/path_provider.dart';
import 'package:universal_io/io.dart';

import '../widgets/test_case_tile.dart';

class UtilityServiceTestPage extends StatefulWidget {
  const UtilityServiceTestPage({Key? key}) : super(key: key);

  @override
  State<UtilityServiceTestPage> createState() => _UtilityServiceTestPageState();
}

class _UtilityServiceTestPageState extends State<UtilityServiceTestPage> {
  String? _exportedPath;
  int? _latestProgress;
  StreamSubscription<int>? _progressSub;

  @override
  void dispose() {
    _progressSub?.cancel();
    super.dispose();
  }

  bool _checkPlatform() {
    if (kIsWeb || (!Platform.isAndroid && !Platform.isIOS)) {
      throw Exception('当前平台不支持此接口（仅 Android/iOS）');
    }
    return true;
  }

  Future<String> _getExportPath() async {
    final dir = await getApplicationDocumentsDirectory();
    return '${dir.path}/nim_export_test.db';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('UtilityService 测试')),
      body: ListView(
        children: [
          // 进度显示区
          if (_latestProgress != null)
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text('最新导出进度: $_latestProgress%',
                  style: const TextStyle(color: Colors.blue)),
            ),
          // 已导出路径显示
          if (_exportedPath != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text('已导出路径: $_exportedPath',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600])),
            ),
          TestCaseTile(
            title: '1. exportMessagesToPath - 导出消息到文件',
            description: '前置：需要账号有历史消息。仅 Android/iOS 支持。',
            onRun: () async {
              _checkPlatform();
              final path = await _getExportPath();
              final result = await NimCore.instance.utilityService
                  .exportMessagesToPath(NIMExportMessageOption(path: path));
              if (!result.isSuccess) {
                throw Exception(
                    'code=${result.code}, msg=${result.errorDetails}');
              }
              final exportedPath = result.data;
              if (exportedPath == null || exportedPath.isEmpty) {
                throw Exception('返回路径为空');
              }
              setState(() => _exportedPath = exportedPath);
            },
          ),
          TestCaseTile(
            title: '2. importMessagesFromPath - 从文件导入消息',
            description: '前置：请先运行"导出消息"用例。仅 Android/iOS 支持。',
            onRun: () async {
              _checkPlatform();
              if (_exportedPath == null) {
                throw Exception('请先执行 exportMessagesToPath 用例，获取导出文件路径');
              }
              final result = await NimCore.instance.utilityService
                  .importMessagesFromPath(
                      NIMImportMessageOption(path: _exportedPath!));
              if (!result.isSuccess) {
                throw Exception(
                    'code=${result.code}, msg=${result.errorDetails}');
              }
            },
          ),
          TestCaseTile(
            title: '3. cancelMigrateMessages - 取消消息迁移',
            description: '先触发导出任务，立即调用取消。仅 Android/iOS 支持。',
            onRun: () async {
              _checkPlatform();
              final path = await _getExportPath();
              // 发起导出，立即取消
              NimCore.instance.utilityService
                  .exportMessagesToPath(NIMExportMessageOption(path: path));
              final cancelResult =
                  await NimCore.instance.utilityService.cancelMigrateMessages();
              print(
                  '[cancelMigrateMessages] result: ${cancelResult.isSuccess}, code=${cancelResult.code}');
              // 取消接口只要能调用返回即认为通过（允许无任务时返回特定错误码）
            },
          ),
          TestCaseTile(
            title: '4. onMessagesProgress - 监听导出进度事件',
            description: '订阅进度事件流，触发导出后观察进度回调。仅 Android/iOS 支持。',
            onRun: () async {
              _checkPlatform();
              _progressSub?.cancel();
              final completer = Completer<void>();
              _progressSub = NimCore.instance.utilityService.onMessagesProgress
                  .listen((progress) {
                setState(() => _latestProgress = progress);
                print('[onMessagesProgress] progress: $progress');
                if (!completer.isCompleted) completer.complete();
              });
              final path = await _getExportPath();
              NimCore.instance.utilityService
                  .exportMessagesToPath(NIMExportMessageOption(path: path));
              // 等最多5秒收到进度回调
              await completer.future.timeout(const Duration(seconds: 5),
                  onTimeout: () => throw Exception('5秒内未收到进度回调'));
            },
          ),
          TestCaseTile(
            title: '5. exportMessagesToPath - 无效路径失败验证',
            description: '传入空字符串路径，预期接口返回失败。',
            onRun: () async {
              _checkPlatform();
              final result = await NimCore.instance.utilityService
                  .exportMessagesToPath(NIMExportMessageOption(path: ''));
              if (result.isSuccess) {
                throw Exception('预期失败但接口返回成功');
              }
              print('[exportMessagesToPath invalid] code=${result.code}');
            },
          ),
        ],
      ),
    );
  }
}
