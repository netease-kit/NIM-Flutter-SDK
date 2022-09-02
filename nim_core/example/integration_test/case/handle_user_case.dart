// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:convert';

import 'package:nim_core/nim_core.dart';
import 'package:netease_auto_test_kit/netease_auto_test_kit.dart';

import 'method_name_value.dart';

class HandleUserCase extends HandleBaseCase {
  HandleUserCase();

  @override
  Future<ResultBean?> handle(event) async {
    super.handle(event);

    var inputParams = Map<String, dynamic>();
    if (params != null && params!.length > 0) {
      inputParams = jsonDecode(params![0]) as Map<String, dynamic>;
    }
    switch (methodName) {
      case getUserInfo:
        NIMResult<NIMUser> result = await NimCore.instance.userService
            .getUserInfo(inputParams['userId'] as String);
        handleCaseResult = ResultBean(
            code: result.code, data: result.data?.toMap(), message: methodName);
        break;
      case fetchUserInfoList:
        NIMResult<List<NIMUser>> result = await NimCore.instance.userService
            .fetchUserInfoList([inputParams['userId'] as String]);
        handleCaseResult = ResultBean(
            code: result.code,
            data: result.data?.map((e) => e.toMap()).toList(),
            message: methodName);
        break;
      case updateMyUserInfo:
        NIMUser user = NIMUser();
        user.nick = inputParams['nick'];
        NIMResult<void> result =
            await NimCore.instance.userService.updateMyUserInfo(user);
        handleCaseResult = ResultBean(
            code: result.code, data: user.toMap(), message: methodName);
        break;
      case searchUserIdListByNick:
        NIMResult<List<String>> result = await NimCore.instance.userService
            .searchUserIdListByNick(inputParams['nick']);
        handleCaseResult = ResultBean(
            code: result.code, data: result.data, message: methodName);
        break;
      case searchUserInfoListByKeyword:
        NIMResult<List<NIMUser>> result = await NimCore.instance.userService
            .searchUserInfoListByKeyword(inputParams['keyword']);
        handleCaseResult = ResultBean(
            code: result.code,
            data: result.data?.map((e) => e.toMap()).toList(),
            message: methodName);
        break;
      case getFriendList:
        NIMResult<List<NIMFriend>> result =
            await NimCore.instance.userService.getFriendList();
        handleCaseResult = ResultBean(
            code: result.code,
            data: result.data?.map((e) => e.toMap()).toList(),
            message: methodName);
        break;
      case addFriend:
        NIMResult<void> result = await NimCore.instance.userService.addFriend(
            userId: inputParams['userId'],
            verifyType:
                NIMVerifyType.values.elementAt(inputParams['verifyType'] ?? 0));
        handleCaseResult =
            ResultBean(code: result.code, data: null, message: methodName);
        break;
      case ackAddFriend:
        NIMResult<void> result = await NimCore.instance.userService
            .ackAddFriend(
                userId: inputParams['userId'], isAgree: inputParams['isAgree']);
        handleCaseResult =
            ResultBean(code: result.code, data: null, message: methodName);
        break;
      case deleteFriend:
        NIMResult<void> result = await NimCore.instance.userService
            .deleteFriend(
                userId: inputParams['userId'],
                includeAlias: inputParams['includeAlias']);
        handleCaseResult =
            ResultBean(code: result.code, data: null, message: methodName);
        break;
      case updateFriend:
        NIMResult<void> result = await NimCore.instance.userService
            .updateFriend(
                userId: inputParams['userId'], alias: inputParams['alias']);
        handleCaseResult =
            ResultBean(code: result.code, data: null, message: methodName);
        break;
      case isMyFriend:
        NIMResult<bool> result = await NimCore.instance.userService
            .isMyFriend(inputParams['userId']);
        handleCaseResult = ResultBean(
            code: result.code, data: result.data, message: methodName);
        break;
      case getBlackList:
        NIMResult<List<String>> result =
            await NimCore.instance.userService.getBlackList();
        handleCaseResult = ResultBean(
            code: result.code, data: result.data, message: methodName);
        break;
      case addToBlackList:
        NIMResult<void> result = await NimCore.instance.userService
            .addToBlackList(inputParams['userId']);
        handleCaseResult =
            ResultBean(code: result.code, data: null, message: methodName);
        break;
      case removeFromBlackList:
        NIMResult<void> result = await NimCore.instance.userService
            .removeFromBlackList(inputParams['userId']);
        handleCaseResult =
            ResultBean(code: result.code, data: null, message: methodName);
        break;
      case isInBlackList:
        NIMResult<bool> result = await NimCore.instance.userService
            .isInBlackList(inputParams['userId']);
        handleCaseResult = ResultBean(
            code: result.code, data: result.data, message: methodName);
        break;
      case getMuteList:
        NIMResult<List<String>> result =
            await NimCore.instance.userService.getMuteList();
        handleCaseResult = ResultBean(
            code: result.code, data: result.data, message: methodName);
        break;
      case setMute:
        NIMResult<void> result = await NimCore.instance.userService.setMute(
            userId: inputParams['userId'], isMute: inputParams['isMute']);
        handleCaseResult =
            ResultBean(code: result.code, data: null, message: methodName);
        break;
      case isMute:
        NIMResult<bool> result =
            await NimCore.instance.userService.isMute(inputParams['userId']);
        handleCaseResult = ResultBean(
            code: result.code, data: result.data, message: methodName);
        break;
      default:
        break;
    }
    return handleCaseResult;
  }
}
