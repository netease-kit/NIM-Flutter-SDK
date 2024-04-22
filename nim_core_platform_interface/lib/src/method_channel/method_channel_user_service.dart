// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:nim_core_platform_interface/nim_core_platform_interface.dart';

class MethodChannelUserService extends UserServicePlatform {
  @override
  Future<NIMResult<NIMUser>> getUserInfo(String userId) async {
    Map<String, String> argument = {'userId': userId};
    Map<String, dynamic> replyMap =
        await invokeMethod('getUserInfo', arguments: argument);
    return NIMResult.fromMap(replyMap, convert: (map) => NIMUser.fromMap(map));
  }

  @override
  Future<NIMResult<List<NIMUser>>> getUserInfoListAndroid(
      List<String> userIdList) async {
    Map<String, dynamic> argument = {
      'userIdList': userIdList.map((e) => e.toString()).toList()
    };
    Map<String, dynamic> replyMap =
        await invokeMethod('getUserInfoList', arguments: argument);
    return NIMResult.fromMap(replyMap, convert: (map) {
      var userInfoList = map['userInfoList'] as List<dynamic>?;
      return userInfoList?.map((e) {
        return NIMUser.fromMap(Map<String, dynamic>.from(e));
      }).toList();
    });
  }

  @override
  Future<NIMResult<List<NIMUser>>> getAllUserInfoAndroid() async {
    Map<String, dynamic> replyMap = await invokeMethod('getAllUserInfo');
    return NIMResult.fromMap(replyMap, convert: (map) {
      var userInfoList = map['userInfoList'] as List<dynamic>?;
      return userInfoList?.map((e) {
        return NIMUser.fromMap(Map<String, dynamic>.from(e));
      }).toList();
    });
  }

  @override
  Future<NIMResult<List<NIMUser>>> fetchUserInfoList(
      List<String> userIdList) async {
    Map<String, dynamic> argument = {'userIdList': userIdList};
    Map<String, dynamic> replyMap =
        await invokeMethod('fetchUserInfoList', arguments: argument);
    return NIMResult.fromMap(replyMap, convert: (map) {
      var userInfoList = map['userInfoList'] as List<dynamic>?;
      return userInfoList?.map((e) {
        return NIMUser.fromMap(Map<String, dynamic>.from(e));
      }).toList();
    });
  }

  @override
  Future<NIMResult<void>> updateMyUserInfo(NIMUser user) async {
    Map<String, dynamic> argument = user.toMap();
    Map<String, dynamic> replyMap =
        await invokeMethod('updateMyUserInfo', arguments: argument);
    return NIMResult.fromMap(replyMap);
  }

  @override
  Future<NIMResult<List<String>>> searchUserIdListByNick(String nick) async {
    Map<String, dynamic> argument = {'nick': nick};
    Map<String, dynamic> resultMap =
        await invokeMethod('searchUserIdListByNick', arguments: argument);
    return NIMResult.fromMap(resultMap, convert: (map) {
      var userIdList = map['userIdList'] as List<dynamic>?;
      return userIdList?.map((e) => e as String).toList();
    });
  }

  @override
  Future<NIMResult<List<NIMUser>>> searchUserInfoListByKeyword(
      String keyword) async {
    Map<String, dynamic> argument = {'keyword': keyword};
    Map<String, dynamic> resultMap =
        await invokeMethod('searchUserInfoListByKeyword', arguments: argument);
    return NIMResult.fromMap(resultMap, convert: (map) {
      var userList = map['userInfoList'] as List<dynamic>?;
      return userList
          ?.map((e) => NIMUser.fromMap(Map<String, dynamic>.from(e)))
          .toList();
    });
  }

  @override
  Future<NIMResult<void>> addFriend(
      String userId, String? message, NIMVerifyType verifyType) async {
    Map<String, dynamic> argument = {
      'userId': userId,
      'message': message,
      'verifyType': verifyType.index
    };
    Map<String, dynamic> replyMap =
        await invokeMethod('addFriend', arguments: argument);
    return NIMResult.fromMap(replyMap);
  }

  @override
  Future<NIMResult<void>> ackAddFriend(
      String userId, bool isAgree, String? idServer) async {
    Map<String, dynamic> argument = {
      'userId': userId,
      'isAgree': isAgree,
      'idServer': idServer
    };
    Map<String, dynamic> replyMap =
        await invokeMethod('ackAddFriend', arguments: argument);
    return NIMResult.fromMap(replyMap);
  }

  @override
  Future<NIMResult<List<NIMFriend>>> getFriendList() async {
    Map<String, dynamic> resultMap = await invokeMethod('getFriendList');
    return NIMResult.fromMap(resultMap, convert: (map) {
      var friendList = map['friendList'] as List<dynamic>?;
      return friendList
          ?.map((e) => NIMFriend.fromMap(Map<String, dynamic>.from(e)))
          .toList();
    });
  }

  @override
  Future<NIMResult<NIMFriend>> getFriend(String userId) async {
    Map<String, String> argument = {'userId': userId};
    Map<String, dynamic> replyMap =
        await invokeMethod('getFriend', arguments: argument);
    return NIMResult.fromMap(replyMap,
        convert: (map) => NIMFriend.fromMap(map));
  }

  @override
  Future<NIMResult<List<String>>> getFriendAccountsAndroid() async {
    Map<String, dynamic> resultMap = await invokeMethod('getFriendAccounts');
    return NIMResult.fromMap(resultMap, convert: (map) {
      var userIdList = map['userIdList'] as List<dynamic>?;
      return userIdList?.map((e) => e as String).toList();
    });
  }

  @override
  Future<NIMResult<List<String>>> searchAccountByAliasAndroid(
      String alias) async {
    Map<String, String> argument = {'alias': alias};
    Map<String, dynamic> resultMap =
        await invokeMethod('searchAccountByAlias', arguments: argument);
    return NIMResult.fromMap(resultMap, convert: (map) {
      var userIdList = map['userIdList'] as List<dynamic>?;
      return userIdList?.map((e) => e as String).toList();
    });
  }

  @override
  Future<NIMResult<List<NIMFriend>>> searchFriendsByKeywordAndroid(
      String keyword) async {
    Map<String, String> argument = {'keyword': keyword};
    Map<String, dynamic> resultMap =
        await invokeMethod('searchFriendsByKeyword', arguments: argument);
    return NIMResult.fromMap(resultMap, convert: (map) {
      var friendList = map['friendList'] as List<dynamic>?;
      return friendList
          ?.map((e) => NIMFriend.fromMap(Map<String, dynamic>.from(e)))
          .toList();
    });
  }

  @override
  Future<NIMResult<void>> deleteFriend(String userId, bool includeAlias) async {
    Map<String, dynamic> argument = {
      'userId': userId,
      'includeAlias': includeAlias
    };
    Map<String, dynamic> replyMap =
        await invokeMethod('deleteFriend', arguments: argument);
    return NIMResult.fromMap(replyMap);
  }

  @override
  Future<NIMResult<bool>> isMyFriend(String userId) async {
    Map<String, dynamic> argument = {'userId': userId};
    Map<String, dynamic> replyMap =
        await invokeMethod('isMyFriend', arguments: argument);
    return NIMResult.fromMap(replyMap);
  }

  @override
  Future<NIMResult<void>> updateFriend(String userId, String alias) async {
    Map<String, dynamic> argument = {'userId': userId, 'alias': alias};
    Map<String, dynamic> replyMap =
        await invokeMethod('updateFriend', arguments: argument);
    return NIMResult.fromMap(replyMap);
  }

  @override
  Future<NIMResult<List<String>>> getBlackList() async {
    Map<String, dynamic> resultMap = await invokeMethod('getBlackList');
    return NIMResult.fromMap(resultMap, convert: (map) {
      var userIdList = map['userIdList'] as List<dynamic>?;
      return userIdList?.map((e) => e as String).toList();
    });
  }

  @override
  Future<NIMResult<void>> addToBlackList(String userId) async {
    Map<String, dynamic> argument = {'userId': userId};
    Map<String, dynamic> replyMap =
        await invokeMethod('addToBlackList', arguments: argument);
    return NIMResult.fromMap(replyMap);
  }

  @override
  Future<NIMResult<void>> removeFromBlackList(String userId) async {
    Map<String, dynamic> argument = {'userId': userId};
    Map<String, dynamic> replyMap =
        await invokeMethod('removeFromBlackList', arguments: argument);
    return NIMResult.fromMap(replyMap);
  }

  @override
  Future<NIMResult<bool>> isInBlackList(String userId) async {
    Map<String, dynamic> argument = {'userId': userId};
    Map<String, dynamic> replyMap =
        await invokeMethod('isInBlackList', arguments: argument);
    return NIMResult.fromMap(replyMap);
  }

  @override
  Future<NIMResult<List<String>>> getMuteList() async {
    Map<String, dynamic> resultMap = await invokeMethod('getMuteList');
    return NIMResult.fromMap(resultMap, convert: (map) {
      var userIdList = map['userIdList'] as List<dynamic>?;
      return userIdList?.map((e) => e as String).toList();
    });
  }

  @override
  Future<NIMResult<void>> setMute(String userId, isMute) async {
    Map<String, dynamic> argument = {'userId': userId, 'isMute': isMute};
    Map<String, dynamic> replyMap =
        await invokeMethod('setMute', arguments: argument);
    return NIMResult.fromMap(replyMap);
  }

  @override
  Future<NIMResult<bool>> isMute(String userId) async {
    Map<String, dynamic> argument = {'userId': userId};
    Map<String, dynamic> replyMap =
        await invokeMethod('isMute', arguments: argument);
    return NIMResult.fromMap(replyMap);
  }

  @override
  Future<NIMResult<String?>> getCurrentAccount() async {
    Map<String, dynamic> replyMap = await invokeMethod('getCurrentAccount');
    return NIMResult.fromMap(replyMap);
  }

  @override
  String get serviceName => "UserService";

  @override
  Future onEvent(String method, arguments) {
    switch (method) {
      case 'onUserInfoChanged':
        var userList = arguments['changedUserInfoList'] as List<dynamic>?;
        List<NIMUser>? list = userList
            ?.map((e) => NIMUser.fromMap(Map<String, dynamic>.from(e)))
            .toList();
        if (list != null)
          UserServicePlatform.instance.onUserInfoChange.add(list);
        break;

      case 'onFriendAddedOrUpdated':
        var messageList =
            arguments['addedOrUpdatedFriendList'] as List<dynamic>?;
        List<NIMFriend>? list = messageList
            ?.map((e) => NIMFriend.fromMap(Map<String, dynamic>.from(e)))
            .toList();
        if (list != null)
          UserServicePlatform.instance.onFriendAddedOrUpdated.add(list);
        break;

      case 'onFriendAccountDeleted':
        var messageList =
            (arguments['deletedFriendAccountList'] as List<dynamic>)
                .map((e) => e.toString())
                .toList();
        UserServicePlatform.instance.onFriendDeleted.add(messageList);
        break;

      case 'onBlackListChanged':
        UserServicePlatform.instance.onBlackListChanged.add(null);
        break;

      case 'onMuteListChanged':
        var muteListChanged = NIMMuteListChangedNotify.fromMap(
            Map<String, dynamic>.from(arguments));
        UserServicePlatform.instance.onMuteListChanged.add(muteListChanged);
        break;
    }
    return Future.value(null);
  }
}
