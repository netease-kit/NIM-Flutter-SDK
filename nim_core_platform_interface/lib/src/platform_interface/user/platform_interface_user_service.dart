// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:nim_core_platform_interface/nim_core_platform_interface.dart';
import 'package:nim_core_platform_interface/src/method_channel/method_channel_user_service.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

abstract class UserServicePlatform extends Service {
  UserServicePlatform() : super(token: _token);

  static final Object _token = Object();

  static UserServicePlatform _instance = MethodChannelUserService();

  static UserServicePlatform get instance => _instance;

  static set instance(UserServicePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  // ignore: close_sinks
  final StreamController<List<NIMUser>> onUserInfoChange =
      StreamController<List<NIMUser>>.broadcast();

  // ignore: close_sinks
  final StreamController<List<NIMFriend>> onFriendAddedOrUpdated =
      StreamController<List<NIMFriend>>.broadcast();

  // ignore: close_sinks
  final StreamController<List<String>> onFriendDeleted =
      StreamController<List<String>>.broadcast();

  // ignore: close_sinks
  final StreamController<void> onBlackListChanged =
      StreamController<void>.broadcast();

  // ignore: close_sinks
  final StreamController<NIMMuteListChangedNotify> onMuteListChanged =
      StreamController<NIMMuteListChangedNotify>.broadcast();

  Future<NIMResult<NIMUser>> getUserInfo(String userId) async {
    throw UnimplementedError('getUserInfo() is not implemented');
  }

  Future<NIMResult<List<NIMUser>>> getUserInfoListAndroid(
      List<String> userId) async {
    throw UnimplementedError('getUserInfoListAndroid() is not implemented');
  }

  Future<NIMResult<List<NIMUser>>> getAllUserInfoAndroid() async {
    throw UnimplementedError('getAllUserInfoAndroid() is not implemented');
  }

  Future<NIMResult<List<NIMUser>>> fetchUserInfoList(
      List<String> userId) async {
    throw UnimplementedError('fetchUserInfoList() is not implemented');
  }

  Future<NIMResult<void>> updateMyUserInfo(NIMUser user) async {
    throw UnimplementedError('updateMyUserInfo() is not implemented');
  }

  Future<NIMResult<List<String>>> searchUserIdListByNick(String nick) async {
    throw UnimplementedError('searchUserIdListByNick() is not implemented');
  }

  Future<NIMResult<List<NIMUser>>> searchUserInfoListByKeyword(
      String keyword) async {
    throw UnimplementedError(
        'searchUserInfoListByKeyword() is not implemented');
  }

  Future<NIMResult<void>> addFriend(
      String userId, String? message, NIMVerifyType verifyType) async {
    throw UnimplementedError('addFriend() is not implemented');
  }

  Future<NIMResult<void>> ackAddFriend(
      String userId, bool isAgree, String? idServer) async {
    throw UnimplementedError('ackAddFriend() is not implemented');
  }

  Future<NIMResult<List<NIMFriend>>> getFriendList() async {
    throw UnimplementedError('getFriendList() is not implemented');
  }

  Future<NIMResult<NIMFriend>> getFriend(String userId) async {
    throw UnimplementedError('getFriend() is not implemented');
  }

  Future<NIMResult<List<String>>> getFriendAccountsAndroid() async {
    throw UnimplementedError('getFriendAccountsAndroid() is not implemented');
  }

  Future<NIMResult<List<String>>> searchAccountByAliasAndroid(
      String alias) async {
    throw UnimplementedError(
        'searchAccountByAliasAndroid() is not implemented');
  }

  Future<NIMResult<List<NIMFriend>>> searchFriendsByKeywordAndroid(
      String keyword) async {
    throw UnimplementedError(
        'searchFriendsByKeywordAndroid() is not implemented');
  }

  Future<NIMResult<void>> deleteFriend(String userId, bool includeAlias) async {
    throw UnimplementedError('deleteFriend() is not implemented');
  }

  Future<NIMResult<bool>> isMyFriend(String userId) async {
    throw UnimplementedError('isMyFriend() is not implemented');
  }

  Future<NIMResult<void>> updateFriend(String userId, String alias) async {
    throw UnimplementedError('updateFriend() is not implemented');
  }

  Future<NIMResult<List<String>>> getBlackList() async {
    throw UnimplementedError('getBlackList() is not implemented');
  }

  Future<NIMResult<void>> addToBlackList(String userId) async {
    throw UnimplementedError('addToBlackList() is not implemented');
  }

  Future<NIMResult<void>> removeFromBlackList(String userId) async {
    throw UnimplementedError('removeFromBlackList() is not implemented');
  }

  Future<NIMResult<bool>> isInBlackList(String userId) async {
    throw UnimplementedError('isInBlackList() is not implemented');
  }

  Future<NIMResult<List<String>>> getMuteList() async {
    throw UnimplementedError('getMuteList() is not implemented');
  }

  Future<NIMResult<void>> setMute(String userId, isMute) async {
    throw UnimplementedError('setMute() is not implemented');
  }

  Future<NIMResult<bool>> isMute(String userId) async {
    throw UnimplementedError('isMute() is not implemented');
  }

  Future<NIMResult<String?>> getCurrentAccount() async {
    throw UnimplementedError('getCurrentAccount() is not implemented');
  }
}
