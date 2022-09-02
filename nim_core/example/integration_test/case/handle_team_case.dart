// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:convert';

import 'package:nim_core/nim_core.dart';
import 'package:netease_auto_test_kit/netease_auto_test_kit.dart';

import 'method_name_value.dart';

/// 配置case用例地址： https://g.hz.netease.com/yunxin-app/kit_automation_test/-/tree/release/integration_case
/// case模板，模板代码的class需要在 [nim_core_test.dart] 中注册。
/// 执行结果通过返回[handleCaseResult] ,做期望值匹配
/// 执行方式,请不要在本地执行：在packages/nim_core/nim_core/example目录下
/// flutter drive --driver=test_driver/integration_test.dart --target=integration_test/main_test.dart  --keep-app-running
class HandleTeamCase extends HandleBaseCase {
  HandleTeamCase();

  @override
  Future<ResultBean?> handle(event) async {
    super.handle(event);
    switch (methodName) {
      case createTeam:
        Map<String, dynamic> options = jsonDecode(params![0]);
        final result = await NimCore.instance.teamService.createTeam(
            createTeamOptions: NIMCreateTeamOptions.fromMap(options),
            members: covertJsonToList(1, 'members'));
        handleCaseResult = ResultBean(
            code: result.code, message: methodName, data: result.data?.toMap());
        break;
      case queryTeamList:
        final result = await NimCore.instance.teamService.queryTeamList();
        handleCaseResult = ResultBean(
            code: result.code,
            message: methodName,
            data: result.data?.map((e) => e.toMap()).toList());
        break;
      case queryTeam:
        final result = await NimCore.instance.teamService
            .queryTeam(jsonDecode(params![0])['teamId']);
        handleCaseResult = ResultBean(
            code: result.code, message: methodName, data: result.data?.toMap());
        break;
      case searchTeam:
        final result = await NimCore.instance.teamService
            .searchTeam(jsonDecode(params![0])['teamId']);
        handleCaseResult = ResultBean(
            code: result.code, message: methodName, data: result.data?.toMap());
        break;
      case dismissTeam:
        final result = await NimCore.instance.teamService
            .dismissTeam(jsonDecode(params![0])['teamId']);
        handleCaseResult =
            ResultBean(code: result.code, message: methodName, data: result);
        handleCaseResult = ResultBean.success();

        break;
      case passApply:
        final result = await NimCore.instance.teamService.passApply(
          jsonDecode(params![0])['teamId'],
          jsonDecode(params![1])['account'],
        );
        handleCaseResult =
            ResultBean(code: result.code, message: methodName, data: result);
        break;
      case addMembersEx:
        final result = await NimCore.instance.teamService.addMembersEx(
          teamId: jsonDecode(params![0])['teamId'],
          accounts: covertJsonToList(1, 'accounts'),
          msg: jsonDecode(params![2])['msg'],
          customInfo: jsonDecode(params![3])['customInfo'],
        );
        handleCaseResult =
            ResultBean(code: result.code, message: methodName, data: result);
        break;
      case acceptInvite:
        final result = await NimCore.instance.teamService.acceptInvite(
          jsonDecode(params![0])['teamId'],
          jsonDecode(params![1])['inviter'],
        );
        handleCaseResult =
            ResultBean(code: result.code, message: methodName, data: result);
        break;
      case getMemberInvitor:
        final result = await NimCore.instance.teamService.getMemberInvitor(
          jsonDecode(params![0])['teamId'],
          covertJsonToList(1, 'accids'),
        );
        handleCaseResult = ResultBean(
            code: result.code,
            message: methodName,
            data: result.data.toString());
        break;
      case removeMembers:
        final result = await NimCore.instance.teamService.removeMembers(
          jsonDecode(params![0])['teamId'],
          covertJsonToList(1, 'accids'),
        );
        handleCaseResult =
            ResultBean(code: result.code, message: methodName, data: result);
        break;
      case quitTeam:
        final result = await NimCore.instance.teamService.quitTeam(
          jsonDecode(params![0])['teamId'],
        );
        handleCaseResult =
            ResultBean(code: result.code, message: methodName, data: result);
        break;
      case queryMemberList:
        final result = await NimCore.instance.teamService.queryMemberList(
          jsonDecode(params![0])['teamId'],
        );
        handleCaseResult = ResultBean(
            code: result.code,
            message: methodName,
            data: result.data?.map((e) => e.toMap()).toList());
        break;
      case queryTeamMember:
        final result = await NimCore.instance.teamService.queryTeamMember(
          jsonDecode(params![0])['teamId'],
          jsonDecode(params![1])['account'],
        );

        print(params?.toList());
        handleCaseResult = ResultBean(
            code: result.code, message: methodName, data: result.data?.toMap());
        break;
      case updateMemberNick:
        final result = await NimCore.instance.teamService.updateMemberNick(
          jsonDecode(params![0])['teamId'],
          jsonDecode(params![1])['account'],
          jsonDecode(params![2])['nick'],
        );
        handleCaseResult =
            ResultBean(code: result.code, message: methodName, data: result);
        break;
      case transferTeam:
        final result = await NimCore.instance.teamService.transferTeam(
          jsonDecode(params![0])['teamId'],
          jsonDecode(params![1])['account'],
          jsonDecode(params![2])['quit'],
        );
        handleCaseResult =
            ResultBean(code: result.code, message: methodName, data: result);
        break;
      case addManagers:
        final result = await NimCore.instance.teamService.addManagers(
          jsonDecode(params![0])['teamId'],
          covertJsonToList(1, 'accounts'),
        );
        handleCaseResult = ResultBean(
            code: result.code,
            message: methodName,
            data: result.data?.map((e) => e.toMap()).toList());
        break;
      case removeManagers:
        final result = await NimCore.instance.teamService.removeManagers(
          jsonDecode(params![0])['teamId'],
          covertJsonToList(1, 'accounts'),
        );
        handleCaseResult = ResultBean(
            code: result.code,
            message: methodName,
            data: result.data?.map((e) => e.toMap()).toList());
        break;
      case muteTeamMember:
        final result = await NimCore.instance.teamService.muteTeamMember(
          jsonDecode(params![0])['teamId'],
          jsonDecode(params![1])['manager'],
          jsonDecode(params![2])['mute'],
        );
        handleCaseResult =
            ResultBean(code: result.code, message: methodName, data: result);
        break;
      case muteAllTeamMember:
        final result = await NimCore.instance.teamService.muteAllTeamMember(
          jsonDecode(params![0])['teamId'],
          jsonDecode(params![1])['mute'],
        );
        handleCaseResult =
            ResultBean(code: result.code, message: methodName, data: result);
        break;
      case queryMutedTeamMembers:
        final result = await NimCore.instance.teamService.queryMutedTeamMembers(
          jsonDecode(params![0])['teamId'],
        );
        handleCaseResult = ResultBean(code: result.code, message: methodName);
        break;
      case updateTeam:
        handleCaseResult =
            ResultBean(code: 0, message: methodName, data: 'default succ');
        break;
      case updateTeamFields:
        NIMTeamUpdateFieldRequest request = NIMTeamUpdateFieldRequest();
        request.setName('更新群名称');
        final result = await NimCore.instance.teamService.updateTeamFields(
          jsonDecode(params![0])['teamId'],
          request,
        );
        handleCaseResult =
            ResultBean(code: result.code, message: methodName, data: result);
        break;
      case muteTeam:
        final result = await NimCore.instance.teamService.muteTeam(
          jsonDecode(params![0])['teamId'],
          enumDecodeNullable(NIMTeamMessageNotifyTypeEnumEnumMap,
              jsonDecode(params![1])['notifyType'] ?? 'all')!,
        );
        handleCaseResult = ResultBean(code: result.code, message: methodName);
        break;
      case searchTeamIdByName:
        final result = await NimCore.instance.teamService.searchTeamIdByName(
          jsonDecode(params![0])['name'],
        );
        handleCaseResult =
            ResultBean(code: result.code, message: methodName, data: result);
        break;
      case searchTeamsByKeyword:
        final result = await NimCore.instance.teamService.searchTeamsByKeyword(
          jsonDecode(params![0])['name'],
        );
        handleCaseResult = ResultBean(
            code: result.code,
            message: methodName,
            data: result.data?.map((e) => e.toMap()).toList());
        break;
      case onTeamListUpdate:
        //ignore: cancel_subscriptions
        final result =
            NimCore.instance.teamService.onTeamListUpdate.listen((event) {
          print('=======onTeamListUpdate event : $event');
        });
        handleCaseResult =
            ResultBean.success(message: methodName, data: result);
        break;
      case onTeamListRemove:
        //ignore: cancel_subscriptions
        final result =
            NimCore.instance.teamService.onTeamListRemove.listen((event) {
          print('=======onTeamListRemove event : $event');
        });
        handleCaseResult =
            ResultBean.success(message: methodName, data: result);
        break;
      default:
        return null;
    }
    return handleCaseResult;
  }

  /// [index] params index,
  /// [key] params key,
  List<String> covertJsonToList(int index, String key) {
    List<String> list = [];
    try {
      final paramsByIndex =
          (jsonDecode(params?[index]) as Map<String, dynamic>?)?[key];
      paramsByIndex?.forEach((element) => list.add(element));
    } on Exception catch (e) {
      print('=========>> index: $index, key: $key,e :$e');
    }
    return list;
  }
}
