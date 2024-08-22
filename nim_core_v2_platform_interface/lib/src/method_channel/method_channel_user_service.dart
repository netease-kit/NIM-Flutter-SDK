// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:nim_core_v2_platform_interface/nim_core_v2_platform_interface.dart';

class MethodChannelUserService extends UserServicePlatform {
  // 从本地数据库中获取用户资料
  @override
  Future<NIMResult<List<NIMUserInfo>>> getUserList(
      List<String> userIdList) async {
    Map<String, dynamic> argument = {'userIdList': userIdList};
    Map<String, dynamic> replyMap =
        await invokeMethod('getUserList', arguments: argument);
    return NIMResult.fromMap(replyMap, convert: (map) {
      var userInfoList = map['userInfoList'] as List<dynamic>?;
      return userInfoList?.map((e) {
        return NIMUserInfo.fromJson(Map<String, dynamic>.from(e));
      }).toList();
    });
  }

  // 从云端获取用户资料（每次最多获取150个用户，如果量大，上层请自行分批获取）
  @override
  Future<NIMResult<List<NIMUserInfo>>> getUserListFromCloud(
      List<String> userIdList) async {
    Map<String, dynamic> argument = {'userIdList': userIdList};
    Map<String, dynamic> replyMap =
        await invokeMethod('getUserListFromCloud', arguments: argument);
    return NIMResult.fromMap(replyMap, convert: (map) {
      var userInfoList = map['userInfoList'] as List<dynamic>?;
      return userInfoList?.map((e) {
        return NIMUserInfo.fromJson(Map<String, dynamic>.from(e));
      }).toList();
    });
  }

  Future<NIMResult<void>> updateSelfUserProfile(
      NIMUserUpdateParam param) async {
    return NIMResult.fromMap(await invokeMethod('updateSelfUserProfile',
        arguments: {'updateParam': param.toJson()}));
  }

  // 添加用户到黑名单
  @override
  Future<NIMResult<void>> addUserToBlockList(String userId) async {
    Map<String, dynamic> argument = {'userId': userId};
    Map<String, dynamic> replyMap =
        await invokeMethod('addUserToBlockList', arguments: argument);
    return NIMResult.fromMap(replyMap);
  }

  // 从黑名单中移除用户
  @override
  Future<NIMResult<void>> removeUserFromBlockList(String userId) async {
    Map<String, dynamic> argument = {'userId': userId};
    Map<String, dynamic> replyMap =
        await invokeMethod('removeUserFromBlockList', arguments: argument);
    return NIMResult.fromMap(replyMap);
  }

  // 获取黑名单列表
  @override
  Future<NIMResult<List<String>>> getBlockList() async {
    Map<String, dynamic> resultMap = await invokeMethod('getBlockList');
    return NIMResult.fromMap(resultMap, convert: (map) {
      var userIdList = map['userIdList'] as List<dynamic>?;
      return userIdList?.map((e) => e as String).toList();
    });
  }

  // 搜索用户
  @override
  Future<NIMResult<List<NIMUserInfo>>> searchUserByOption(
      NIMUserSearchOption userSearchOption) async {
    Map<String, dynamic> resultMap = await invokeMethod('searchUserByOption',
        arguments: {'userSearchOption': userSearchOption.toJson()});
    return NIMResult.fromMap(resultMap, convert: (map) {
      var userInfoList = map['userInfoList'] as List<dynamic>?;
      return userInfoList
          ?.map((e) => NIMUserInfo.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    });
  }

  // 监听事件
  @override
  Future onEvent(String method, arguments) {
    switch (method) {
      // 用户资料更新
      case 'onUserProfileChanged':
        var userList = arguments['userInfoList'] as List<dynamic>?;
        List<NIMUserInfo>? list = userList
            ?.map((e) => NIMUserInfo.fromJson(Map<String, dynamic>.from(e)))
            .toList();
        if (list != null)
          UserServicePlatform.instance.onUserProfileChanged.add(list);
        break;
      // 添加黑名单
      case 'onBlockListAdded':
        var userInfo =
            NIMUserInfo.fromJson((arguments as Map).cast<String, dynamic>());
        UserServicePlatform.instance.onBlockListAdded.add(userInfo);
        break;
      // 移除黑名单
      case 'onBlockListRemoved':
        var userId = arguments["userId"] as String;
        UserServicePlatform.instance.onBlockListRemoved.add(userId);
        break;
    }
    return Future.value(null);
  }

  @override
  String get serviceName => "UserService";
}
