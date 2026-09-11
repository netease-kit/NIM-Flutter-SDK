// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nim_core_v2/nim_core.dart';
import 'package:universal_io/io.dart';

import '../widgets/test_case_tile.dart';

class OhosPushServiceTestPage extends StatefulWidget {
  const OhosPushServiceTestPage({Key? key}) : super(key: key);

  @override
  State<OhosPushServiceTestPage> createState() =>
      _OhosPushServiceTestPageState();
}

class _OhosPushServiceTestPageState extends State<OhosPushServiceTestPage> {
  bool? _latestEnableState;

  void _checkPlatform() {
    if (kIsWeb) {
      throw Exception('当前平台不支持此接口（仅 HarmonyOS）');
    }
  }

  Future<bool> _queryEnableState() async {
    _checkPlatform();
    final result = await NimCore.instance.ohosPushService.isEnable();
    if (!result.isSuccess) {
      throw Exception('code=${result.code}, msg=${result.errorDetails}');
    }
    final enabled = result.data;
    if (enabled == null) {
      throw Exception('isEnable 返回值为空');
    }
    setState(() => _latestEnableState = enabled);
    print('[OhosPushService] isEnable=$enabled');
    return enabled;
  }

  Future<void> _setEnableState(bool enable) async {
    _checkPlatform();
    final result = await NimCore.instance.ohosPushService.enable(enable);
    if (!result.isSuccess) {
      throw Exception('code=${result.code}, msg=${result.errorDetails}');
    }
    final enabled = await _queryEnableState();
    if (enabled != enable) {
      throw Exception('设置后状态不一致，expected=$enable, actual=$enabled');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('OhosPushService 测试')),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              '当前推送开关状态: ${_latestEnableState == null ? "未查询" : (_latestEnableState! ? "开启" : "关闭")}',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),
          TestCaseTile(
            title: '1. isEnable - 查询第三方推送开关',
            description: '调用 OhosPushService.isEnable，验证返回布尔值。仅 HarmonyOS 支持。',
            onRun: () async {
              await _queryEnableState();
            },
          ),
          TestCaseTile(
            title: '2. enable(true) - 开启第三方推送',
            description: '调用 OhosPushService.enable(true)，随后查询状态应为开启。',
            onRun: () async {
              await _setEnableState(true);
            },
          ),
          TestCaseTile(
            title: '3. enable(false) - 关闭第三方推送',
            description: '调用 OhosPushService.enable(false)，随后查询状态应为关闭。',
            onRun: () async {
              await _setEnableState(false);
            },
          ),
        ],
      ),
    );
  }
}
