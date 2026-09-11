// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:nim_core_v2/nim_core.dart';

import '../widgets/test_case_tile.dart';

class FriendServiceExtTestPage extends StatelessWidget {
  const FriendServiceExtTestPage({Key? key}) : super(key: key);

  bool _checkPlatform() {
    return true;
  }

  Future<void> _runClearAllAddApplicationEx(
    NIMFriendClearAddApplicationOption option,
    String tag,
  ) async {
    final result =
        await NimCore.instance.friendService.clearAllAddApplicationEx(option);
    if (!result.isSuccess) {
      throw Exception('code=${result.code}, msg=${result.errorDetails}');
    }
    print('[clearAllAddApplicationEx] $tag 成功');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FriendService 扩展测试')),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          // ──────────────────────────────────────────
          // clearAllAddApplicationEx — 按 type 分类
          // ──────────────────────────────────────────
          const _SectionHeader('clearAllAddApplicationEx — 按申请类型清除'),
          TestCaseTile(
            title: '1. 清除全部好友申请（不指定 type） ⚠️',
            description: '不传 type，清除所有类型的好友申请记录。\n',
            onRun: () async {
              _checkPlatform();
              await _runClearAllAddApplicationEx(
                NIMFriendClearAddApplicationOption(),
                '全部（type=null）',
              );
            },
          ),
          TestCaseTile(
            title: '2. 清除全部好友申请（type=all） ⚠️',
            description: 'type=all(3)，明确指定清除所有类型的好友申请记录。\n',
            onRun: () async {
              _checkPlatform();
              await _runClearAllAddApplicationEx(
                NIMFriendClearAddApplicationOption(
                  type: NIMFriendAddApplicationType
                      .nimFriendAddApplicationTypeAll,
                ),
                '全部（type=all）',
              );
            },
          ),
          TestCaseTile(
            title: '3. 清除收到的好友申请（type=toSelf） ⚠️',
            description: 'type=toSelf(2)，仅清除我收到的好友申请记录。\n',
            onRun: () async {
              _checkPlatform();
              await _runClearAllAddApplicationEx(
                NIMFriendClearAddApplicationOption(
                  type: NIMFriendAddApplicationType
                      .nimFriendAddApplicationTypeToSelf,
                ),
                '收到的（type=toSelf）',
              );
            },
          ),
          TestCaseTile(
            title: '4. 清除发出的好友申请（type=fromSelf） ⚠️',
            description: 'type=fromSelf(1)，仅清除我发出的好友申请记录。\n',
            onRun: () async {
              _checkPlatform();
              await _runClearAllAddApplicationEx(
                NIMFriendClearAddApplicationOption(
                  type: NIMFriendAddApplicationType
                      .nimFriendAddApplicationTypeFromSelf,
                ),
                '发出的（type=fromSelf）',
              );
            },
          ),
          TestCaseTile(
            title: '5. 兼容老版本模式（type=legacy） ⚠️',
            description: 'type=legacy(0)，兼容老版本的清除模式。\n',
            onRun: () async {
              _checkPlatform();
              await _runClearAllAddApplicationEx(
                NIMFriendClearAddApplicationOption(
                  type: NIMFriendAddApplicationType
                      .nimFriendAddApplicationTypeLegacy,
                ),
                '兼容老版本（type=legacy）',
              );
            },
          ),

          // ──────────────────────────────────────────
          // clearAllAddApplicationEx — 按时间戳过滤
          // ──────────────────────────────────────────
          const _SectionHeader('clearAllAddApplicationEx — 按时间戳过滤'),
          TestCaseTile(
            title: '6. 清除 1 小时前的全部申请（仅 timestamp） ⚠️',
            description: '不指定 type，清除 1 小时前的所有好友申请记录。\n',
            onRun: () async {
              _checkPlatform();
              final oneHourAgo =
                  DateTime.now().subtract(const Duration(hours: 1));
              await _runClearAllAddApplicationEx(
                NIMFriendClearAddApplicationOption(
                  timestamp: oneHourAgo.millisecondsSinceEpoch,
                ),
                '1小时前（type=null）',
              );
            },
          ),
          TestCaseTile(
            title: '7. 清除 24 小时前的全部申请（仅 timestamp） ⚠️',
            description: '不指定 type，清除 24 小时前的所有好友申请记录。\n',
            onRun: () async {
              _checkPlatform();
              final oneDayAgo =
                  DateTime.now().subtract(const Duration(hours: 24));
              await _runClearAllAddApplicationEx(
                NIMFriendClearAddApplicationOption(
                  timestamp: oneDayAgo.millisecondsSinceEpoch,
                ),
                '24小时前（type=null）',
              );
            },
          ),

          // ──────────────────────────────────────────
          // clearAllAddApplicationEx — type + timestamp 组合
          // ──────────────────────────────────────────
          const _SectionHeader(
              'clearAllAddApplicationEx — 组合过滤（type + timestamp）'),
          TestCaseTile(
            title: '8. 清除 1 小时前收到的申请（toSelf + timestamp） ⚠️',
            description: 'type=toSelf，清除 1 小时前我收到的好友申请记录。\n',
            onRun: () async {
              _checkPlatform();
              final oneHourAgo =
                  DateTime.now().subtract(const Duration(hours: 1));
              await _runClearAllAddApplicationEx(
                NIMFriendClearAddApplicationOption(
                  type: NIMFriendAddApplicationType
                      .nimFriendAddApplicationTypeToSelf,
                  timestamp: oneHourAgo.millisecondsSinceEpoch,
                ),
                'toSelf + 1小时前',
              );
            },
          ),
          TestCaseTile(
            title: '9. 清除 1 小时前发出的申请（fromSelf + timestamp） ⚠️',
            description: 'type=fromSelf，清除 1 小时前我发出的好友申请记录。\n',
            onRun: () async {
              _checkPlatform();
              final oneHourAgo =
                  DateTime.now().subtract(const Duration(hours: 1));
              await _runClearAllAddApplicationEx(
                NIMFriendClearAddApplicationOption(
                  type: NIMFriendAddApplicationType
                      .nimFriendAddApplicationTypeFromSelf,
                  timestamp: oneHourAgo.millisecondsSinceEpoch,
                ),
                'fromSelf + 1小时前',
              );
            },
          ),
          TestCaseTile(
            title: '10. 清除 1 小时前所有类型申请（all + timestamp） ⚠️',
            description: 'type=all，清除 1 小时前所有类型的好友申请记录。\n',
            onRun: () async {
              _checkPlatform();
              final oneHourAgo =
                  DateTime.now().subtract(const Duration(hours: 1));
              await _runClearAllAddApplicationEx(
                NIMFriendClearAddApplicationOption(
                  type: NIMFriendAddApplicationType
                      .nimFriendAddApplicationTypeAll,
                  timestamp: oneHourAgo.millisecondsSinceEpoch,
                ),
                'all + 1小时前',
              );
            },
          ),
        ],
      ),
    );
  }
}

/// 分组标题
class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 16, 12, 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}
