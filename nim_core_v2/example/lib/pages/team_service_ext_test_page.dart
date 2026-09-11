// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nim_core_v2/nim_core.dart';

import '../widgets/test_case_tile.dart';

const _kTestTeamId = '35079835747';
const _kCurrentAccount = '334665458163968';

class TeamServiceExtTestPage extends StatelessWidget {
  const TeamServiceExtTestPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('TeamService 扩展测试')),
      body: ListView(
        children: [
          // ─── searchTeams ───────────────────────────────────────────────────
          TestCaseTile(
            title: '1. searchTeams - 按关键词搜索群',
            description: '传入关键词，验证返回群列表。仅 Android/iOS/macOS/Windows 支持。',
            onRun: () async {
              if (kIsWeb) throw Exception('当前平台（Web）不支持此接口');
              final result = await NimCore.instance.teamService
                  .searchTeams(NIMTeamSearchParams(keywordList: ['测试']));
              if (!result.isSuccess) {
                throw Exception(
                    'code=${result.code}, msg=${result.errorDetails}');
              }
              final teams = result.data ?? [];
              print('[searchTeams] keyword=测试, count=${teams.length}');
              for (final t in teams) {
                print('  -> teamId=${t.teamId}, name=${t.name}');
              }
            },
          ),
          TestCaseTile(
            title: '2. searchTeams - 空关键词返回所有群',
            description: '传入空字符串，预期返回加入的所有群列表。',
            onRun: () async {
              if (kIsWeb) throw Exception('当前平台（Web）不支持此接口');
              final result = await NimCore.instance.teamService
                  .searchTeams(NIMTeamSearchParams(keywordList: ['']));
              if (!result.isSuccess) {
                throw Exception(
                    'code=${result.code}, msg=${result.errorDetails}');
              }
              final teams = result.data ?? [];
              print('[searchTeams] keyword="", count=${teams.length}');
            },
          ),
          TestCaseTile(
            title: '3. searchTeams - 无匹配关键词返回空列表',
            description: '传入不可能匹配到的随机字符串',
            onRun: () async {
              if (kIsWeb) throw Exception('当前平台（Web）不支持此接口');
              final result = await NimCore.instance.teamService.searchTeams(
                  NIMTeamSearchParams(keywordList: ['zzzzzz_nomatch_xyzabc']));
              if (!result.isSuccess) {
                throw Exception(
                    'code=${result.code}, msg=${result.errorDetails}');
              }
              final teams = result.data ?? [];
              print('[searchTeams] no-match, count=${teams.length}');
            },
          ),
          // ─── getOwnerTeamList ──────────────────────────────────────────────
          TestCaseTile(
            title: '4. getOwnerTeamList - 获取我创建的全量群',
            description: '传 teamTypes: null，验证所有返回群的 ownerAccountId 为当前账号',
            onRun: () async {
              final result = await NimCore.instance.teamService
                  .getOwnerTeamList(teamTypes: null);
              if (!result.isSuccess) {
                throw Exception(
                    'code=${result.code}, msg=${result.errorDetails}');
              }
              final teams = result.data ?? [];
              print('[getOwnerTeamList] count=${teams.length}');
              for (final t in teams) {
                print('  -> teamId=${t.teamId}, owner=${t.ownerAccountId}');
                if (t.ownerAccountId != _kCurrentAccount) {
                  throw Exception(
                      '群 ${t.teamId} 的 ownerAccountId=${t.ownerAccountId} 不等于当前账号');
                }
              }
            },
          ),
          TestCaseTile(
            title: '5. getOwnerTeamList - 按高级群类型筛选',
            description: '传 teamTypes: [NIMTeamType.normal]，验证返回群类型',
            onRun: () async {
              final result = await NimCore.instance.teamService
                  .getOwnerTeamList(teamTypes: [NIMTeamType.typeNormal]);
              if (!result.isSuccess) {
                throw Exception(
                    'code=${result.code}, msg=${result.errorDetails}');
              }
              final teams = result.data ?? [];
              print('[getOwnerTeamList] normal, count=${teams.length}');
              for (final t in teams) {
                if (t.teamType != NIMTeamType.typeNormal) {
                  throw Exception(
                      '群 ${t.teamId} 类型=${t.teamType} 不是 typeNormal');
                }
              }
            },
          ),
          // ─── getManagerTeamList ────────────────────────────────────────────
          TestCaseTile(
            title: '6. getManagerTeamList - 获取我管理的全量群',
            description: '传 teamTypes: null，验证返回列表',
            onRun: () async {
              final result = await NimCore.instance.teamService
                  .getManagerTeamList(teamTypes: null);
              if (!result.isSuccess) {
                throw Exception(
                    'code=${result.code}, msg=${result.errorDetails}');
              }
              final teams = result.data ?? [];
              print('[getManagerTeamList] count=${teams.length}');
              for (final t in teams) {
                print('  -> teamId=${t.teamId}, name=${t.name}');
              }
            },
          ),
          TestCaseTile(
            title: '7. getManagerTeamList - 按高级群类型筛选',
            description: '传 teamTypes: [NIMTeamType.normal]，验证返回群类型',
            onRun: () async {
              final result = await NimCore.instance.teamService
                  .getManagerTeamList(teamTypes: [NIMTeamType.typeNormal]);
              if (!result.isSuccess) {
                throw Exception(
                    'code=${result.code}, msg=${result.errorDetails}');
              }
              final teams = result.data ?? [];
              print('[getManagerTeamList] normal, count=${teams.length}');
            },
          ),
          // ─── getTeamInfoFromCloud ──────────────────────────────────────────
          TestCaseTile(
            title: '8. getTeamInfoFromCloud - 从云端获取群信息',
            description: '传入已知 teamId=$_kTestTeamId，验证返回 NIMTeam 对象字段',
            onRun: () async {
              final result =
                  await NimCore.instance.teamService.getTeamInfoFromCloud(
                teamId: _kTestTeamId,
                teamType: NIMTeamType.typeNormal,
              );
              if (!result.isSuccess) {
                throw Exception(
                    'code=${result.code}, msg=${result.errorDetails}');
              }
              final team = result.data;
              if (team == null) throw Exception('返回 NIMTeam 为 null');
              if (team.teamId != _kTestTeamId) {
                throw Exception('返回 teamId=${team.teamId} 与入参不符');
              }
              print(
                  '[getTeamInfoFromCloud] teamId=${team.teamId}, name=${team.name}');
            },
          ),
          TestCaseTile(
            title: '9. getTeamInfoFromCloud - 不存在的 teamId',
            description: '传入不存在的 teamId，预期接口返回失败',
            onRun: () async {
              final result =
                  await NimCore.instance.teamService.getTeamInfoFromCloud(
                teamId: '999999999999',
                teamType: NIMTeamType.typeNormal,
              );
              if (result.isSuccess) {
                throw Exception('预期失败但接口返回成功，data=${result.data?.toJson()}');
              }
              print(
                  '[getTeamInfoFromCloud] invalid teamId, code=${result.code}');
            },
          ),
          // ─── clearAllTeamJoinActionInfoEx ──────────────────────────────────
          TestCaseTile(
            title: '10. clearAllTeamJoinActionInfoEx - 清除全量群申请记录 ⚠️',
            description: '⚠️ 警告：此操作会清除所有群申请记录！Android/iOS/Web 支持。',
            onRun: () async {
              final result = await NimCore.instance.teamService
                  .clearAllTeamJoinActionInfoEx(
                      NIMTeamClearJoinActionInfoOption());
              if (!result.isSuccess) {
                throw Exception(
                    'code=${result.code}, msg=${result.errorDetails}');
              }
              print('[clearAllTeamJoinActionInfoEx] success');
            },
          ),
        ],
      ),
    );
  }
}
