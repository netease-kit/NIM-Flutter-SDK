// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import 'friend_service_ext_test_page.dart';
import 'message_service_ext_test_page.dart';
import 'ohos_push_service_test_page.dart';
import 'statistics_service_test_page.dart';
import 'team_member_service_ext_test_page.dart';
import 'team_service_ext_test_page.dart';
import 'utility_service_test_page.dart';

/// 所有 10.9.6 接口测试页的总入口
class TestMainPage extends StatelessWidget {
  const TestMainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final entries = <_TestEntry>[
      _TestEntry(
        icon: '🛠️',
        title: 'UtilityService 测试',
        subtitle: '消息导入导出、迁移取消、进度监听',
        builder: (_) => const UtilityServiceTestPage(),
      ),
      _TestEntry(
        icon: '📊',
        title: '统计服务测试',
        subtitle: '获取数据库信息列表',
        builder: (_) => const StatisticsServiceTestPage(),
      ),
      _TestEntry(
        icon: '👥',
        title: 'TeamService 扩展测试',
        subtitle: '搜索群、获取我管理的群、从云端获取群信息等',
        builder: (_) => const TeamServiceExtTestPage(),
      ),
      _TestEntry(
        icon: '🔍',
        title: 'TeamMember 搜索测试',
        subtitle: 'searchTeamMembersEx 关键词/空词/limit 测试',
        builder: (_) => const TeamMemberServiceExtTestPage(),
      ),
      _TestEntry(
        icon: '💬',
        title: 'MessageService 扩展测试',
        subtitle: '本地插入消息、清除本地消息、文本翻译',
        builder: (_) => const MessageServiceExtTestPage(),
      ),
      _TestEntry(
        icon: '🤝',
        title: 'FriendService 扩展测试',
        subtitle: '清除好友申请记录',
        builder: (_) => const FriendServiceExtTestPage(),
      ),
      _TestEntry(
        icon: '📣',
        title: 'OhosPushService 测试',
        subtitle: '鸿蒙第三方推送开关查询、开启、关闭',
        builder: (_) => const OhosPushServiceTestPage(),
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('📋 接口测试')),
      body: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: entries.length,
        separatorBuilder: (_, __) => const SizedBox(height: 4),
        itemBuilder: (context, index) {
          final entry = entries[index];
          return Card(
            child: ListTile(
              leading: Text(entry.icon, style: const TextStyle(fontSize: 28)),
              title: Text(entry.title,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle:
                  Text(entry.subtitle, style: const TextStyle(fontSize: 12)),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: entry.builder),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _TestEntry {
  final String icon;
  final String title;
  final String subtitle;
  final WidgetBuilder builder;

  const _TestEntry({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.builder,
  });
}
