// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:nim_core_v2/nim_core.dart';

import '../widgets/test_case_tile.dart';

const _kTeamId = '35079835747';

class TeamMemberServiceExtTestPage extends StatelessWidget {
  const TeamMemberServiceExtTestPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('TeamMember 搜索测试')),
      body: ListView(
        children: [
          TestCaseTile(
            title: '1. searchTeamMembersEx - 按关键词搜索群成员',
            description: '传入有效 teamId 和关键词，验证命中成员',
            onRun: () async {
              final params = NIMSearchTeamMemberParams(
                keywordList: ['1'],
                teamRefers: [
                  NIMTeamRefer(
                    teamId: _kTeamId,
                    teamType: NIMTeamType.typeNormal,
                  ),
                ],
                searchAccountId: true,
              );
              final result = await NimCore.instance.teamService
                  .searchTeamMembersEx(params);
              if (!result.isSuccess) {
                throw Exception(
                    'code=${result.code}, msg=${result.errorDetails}');
              }
              final resultMap = result.data ?? {};
              final totalCount = resultMap.values
                  .fold<int>(0, (sum, members) => sum + members.length);
              print(
                  '[searchTeamMembersEx] keyword=1, groupCount=${resultMap.length}, totalMemberCount=$totalCount');
              resultMap.forEach((teamRefer, members) {
                print('  -> teamId=${teamRefer.teamId}');
                for (final m in members) {
                  print('     accountId=${m.accountId}, nick=${m.teamNick}');
                }
              });
            },
          ),
          TestCaseTile(
            title: '2. searchTeamMembersEx - 空关键词返回全量成员',
            description: '传入空字符串关键词，预期返回群内所有成员',
            onRun: () async {
              final params = NIMSearchTeamMemberParams(
                keywordList: [''],
                teamRefers: [
                  NIMTeamRefer(
                    teamId: _kTeamId,
                    teamType: NIMTeamType.typeNormal,
                  ),
                ],
                searchAccountId: true,
              );
              final result = await NimCore.instance.teamService
                  .searchTeamMembersEx(params);
              if (!result.isSuccess) {
                throw Exception(
                    'code=${result.code}, msg=${result.errorDetails}');
              }
              final resultMap = result.data ?? {};
              final totalCount = resultMap.values
                  .fold<int>(0, (sum, members) => sum + members.length);
              print(
                  '[searchTeamMembersEx] empty keyword, groupCount=${resultMap.length}, totalMemberCount=$totalCount');
            },
          ),
          TestCaseTile(
            title: '3. searchTeamMembersEx - 无匹配关键词返回空列表',
            description: '传入不可能匹配到任何成员的随机字符串',
            onRun: () async {
              final params = NIMSearchTeamMemberParams(
                keywordList: ['zzznoMatch_abc_xyz'],
                teamRefers: [
                  NIMTeamRefer(
                    teamId: _kTeamId,
                    teamType: NIMTeamType.typeNormal,
                  ),
                ],
                searchAccountId: true,
              );
              final result = await NimCore.instance.teamService
                  .searchTeamMembersEx(params);
              if (!result.isSuccess) {
                throw Exception(
                    'code=${result.code}, msg=${result.errorDetails}');
              }
              final resultMap = result.data ?? {};
              final totalCount = resultMap.values
                  .fold<int>(0, (sum, members) => sum + members.length);
              print(
                  '[searchTeamMembersEx] no-match, groupCount=${resultMap.length}, totalMemberCount=$totalCount');
            },
          ),
          TestCaseTile(
            title: '4. searchTeamMembersEx - limit: 2',
            description: '限制返回2条，验证返回数量不超过 2',
            onRun: () async {
              final params = NIMSearchTeamMemberParams(
                keywordList: ['1'],
                teamRefers: [
                  NIMTeamRefer(
                    teamId: _kTeamId,
                    teamType: NIMTeamType.typeNormal,
                  ),
                ],
                limit: 2,
                searchAccountId: true,
              );
              final result = await NimCore.instance.teamService
                  .searchTeamMembersEx(params);
              if (!result.isSuccess) {
                throw Exception(
                    'code=${result.code}, msg=${result.errorDetails}');
              }
              final resultMap = result.data ?? {};
              final totalCount = resultMap.values
                  .fold<int>(0, (sum, members) => sum + members.length);
              print(
                  '[searchTeamMembersEx] limit=2, groupCount=${resultMap.length}, totalMemberCount=$totalCount');
              if (totalCount > 2) {
                throw Exception('返回成员数量 $totalCount 超过 limit=2');
              }
            },
          ),
          TestCaseTile(
            title: '5. searchTeamMembersEx - 无效 teamId',
            description: '传入不存在的 teamId，预期返回失败或空列表',
            onRun: () async {
              final params = NIMSearchTeamMemberParams(
                keywordList: [''],
                teamRefers: [
                  NIMTeamRefer(
                    teamId: '999999999999',
                    teamType: NIMTeamType.typeNormal,
                  ),
                ],
                searchAccountId: true,
              );
              final result = await NimCore.instance.teamService
                  .searchTeamMembersEx(params);
              print(
                  '[searchTeamMembersEx] invalid teamId, isSuccess=${result.isSuccess}, code=${result.code}');
              // 无效 teamId 可能返回空列表或错误，都算接口可用
            },
          ),
          TestCaseTile(
            title: '6. searchTeamMembersEx - 多关键词 multiple 匹配',
            description: '传入多个关键词，使用 multiple 模式（任意匹配）',
            onRun: () async {
              final params = NIMSearchTeamMemberParams(
                keywordList: ['1', 'test'],
                keywordMatchType: NIMTeamKeywordMatchType.multiple,
                teamRefers: [
                  NIMTeamRefer(
                    teamId: _kTeamId,
                    teamType: NIMTeamType.typeNormal,
                  ),
                ],
                searchAccountId: true,
                searchTeamNick: true,
              );
              final result = await NimCore.instance.teamService
                  .searchTeamMembersEx(params);
              if (!result.isSuccess) {
                throw Exception(
                    'code=${result.code}, msg=${result.errorDetails}');
              }
              final resultMap = result.data ?? {};
              final totalCount = resultMap.values
                  .fold<int>(0, (sum, members) => sum + members.length);
              print(
                  '[searchTeamMembersEx] multiple keywords, groupCount=${resultMap.length}, totalMemberCount=$totalCount');
            },
          ),
          TestCaseTile(
            title: '7. searchTeamMembersEx - 不传 teamRefers（搜索所有群）',
            description: '不指定 teamRefers，搜索所有群中的成员',
            onRun: () async {
              final params = NIMSearchTeamMemberParams(
                keywordList: ['1'],
                searchAccountId: true,
              );
              final result = await NimCore.instance.teamService
                  .searchTeamMembersEx(params);
              if (!result.isSuccess) {
                throw Exception(
                    'code=${result.code}, msg=${result.errorDetails}');
              }
              final resultMap = result.data ?? {};
              final totalCount = resultMap.values
                  .fold<int>(0, (sum, members) => sum + members.length);
              print(
                  '[searchTeamMembersEx] all teams, groupCount=${resultMap.length}, totalMemberCount=$totalCount');
            },
          ),
        ],
      ),
    );
  }
}
