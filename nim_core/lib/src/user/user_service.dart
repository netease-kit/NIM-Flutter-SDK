// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

part of nim_core;

class UserService {
  factory UserService() {
    if (_singleton == null) {
      _singleton = UserService._();
    }
    return _singleton!;
  }

  UserService._();

  static UserService? _singleton;

  UserServicePlatform get _platform => UserServicePlatform.instance;

  Stream<List<NIMUser>> get onUserInfoChange =>
      UserServicePlatform.instance.onUserInfoChange.stream;

  Stream<List<NIMFriend>> onFriendAddedOrUpdated =
      UserServicePlatform.instance.onFriendAddedOrUpdated.stream;

  Stream<List<String>> onFriendDeleted =
      UserServicePlatform.instance.onFriendDeleted.stream;

  Stream<void> onBlackListChanged =
      UserServicePlatform.instance.onBlackListChanged.stream;

  Stream<NIMMuteListChangedNotify> onMuteListChanged =
      UserServicePlatform.instance.onMuteListChanged.stream;

  /// 从本地数据库中获取用户资料
  /// 通过用户账号[userId]查询并返回该用户的资料
  Future<NIMResult<NIMUser>> getUserInfo(String userId) async {
    return _platform.getUserInfo(userId);
  }

  /// 从本地数据库中批量获取用户资料
  /// 通过用户账号列表[userIdList]查询并返回所有用户的资料列表
  Future<NIMResult<List<NIMUser>>> getUserInfoListAndroid(
      List<String> userIdList) async {
    return _platform.getUserInfoListAndroid(userIdList);
  }

  /// 从本地数据库中批量获取用户资料
  Future<NIMResult<List<NIMUser>>> getAllUserInfoAndroid() async {
    return _platform.getAllUserInfoAndroid();
  }

  /// 从云端获取用户资料（每次最多获取150个用户，如果量大，上层请自行分批获取）
  /// 通过用户账号列表[userIdList]查询并返回所有用户的资料列表
  Future<NIMResult<List<NIMUser>>> fetchUserInfoList(
      List<String> userIdList) async {
    return _platform.fetchUserInfoList(userIdList);
  }

  /// 更新本人用户资料
  /// 修改为[user]提供的内容
  Future<NIMResult<void>> updateMyUserInfo(NIMUser user) async {
    return _platform.updateMyUserInfo(user);
  }

  /// 根据昵称反查账号列表
  /// 通过昵称[nick]反查账号列表
  Future<NIMResult<List<String>>> searchUserIdListByNick(String nick) async {
    return _platform.searchUserIdListByNick(nick);
  }

  /// 搜索与关键字匹配的所有用户
  /// 通过关键字[keyword],返回与之匹配的所有的用户列表
  Future<NIMResult<List<NIMUser>>> searchUserInfoListByKeyword(
      String keyword) async {
    return _platform.searchUserInfoListByKeyword(keyword);
  }

  /// 添加好友
  Future<NIMResult<void>> addFriend(
      {required String userId,
      String? message,
      required NIMVerifyType verifyType}) async {
    return _platform.addFriend(userId, message, verifyType);
  }

  /// 确认添加好友, idServer仅为web端系统消息的id
  Future<NIMResult<void>> ackAddFriend(
      {required String userId, bool isAgree = true, String? idServer}) async {
    return _platform.ackAddFriend(userId, isAgree, idServer);
  }

  /// 获取好友列表
  Future<NIMResult<List<NIMFriend>>> getFriendList() async {
    return _platform.getFriendList();
  }

  /// 获取好友
  Future<NIMResult<NIMFriend>> getFriend(String userId) async {
    return _platform.getFriend(userId);
  }

  ///获取所有的好友帐号
  Future<NIMResult<List<String>>> getFriendAccountsAndroid() async {
    return _platform.getFriendAccountsAndroid();
  }

  ///根据备注反查账号
  Future<NIMResult<List<String>>> searchAccountByAliasAndroid(
      String alias) async {
    return _platform.searchAccountByAliasAndroid(alias);
  }

  ///搜索与关键字匹配的所有好友
  Future<NIMResult<List<NIMFriend>>> searchFriendsByKeywordAndroid(
      String keyword) async {
    return _platform.searchFriendsByKeywordAndroid(keyword);
  }

  /// 删除好友
  Future<NIMResult<void>> deleteFriend(
      {required String userId, bool includeAlias = true}) async {
    return _platform.deleteFriend(userId, includeAlias);
  }

  Future<NIMResult<bool>> isMyFriend(String userId) async {
    return _platform.isMyFriend(userId);
  }

  Future<NIMResult<void>> updateFriend(
      {required String userId, required String alias}) async {
    return _platform.updateFriend(userId, alias);
  }

  Future<NIMResult<List<String>>> getBlackList() async {
    return _platform.getBlackList();
  }

  Future<NIMResult<void>> addToBlackList(String userId) async {
    return _platform.addToBlackList(userId);
  }

  Future<NIMResult<void>> removeFromBlackList(String userId) async {
    return _platform.removeFromBlackList(userId);
  }

  Future<NIMResult<bool>> isInBlackList(String userId) async {
    return _platform.isInBlackList(userId);
  }

  Future<NIMResult<List<String>>> getMuteList() async {
    return _platform.getMuteList();
  }

  Future<NIMResult<void>> setMute(
      {required String userId, required isMute}) async {
    return _platform.setMute(userId, isMute);
  }

  Future<NIMResult<bool>> isMute(String userId) async {
    return _platform.isMute(userId);
  }

  ///获取当前登录的帐号
  ///如果未登录返回为空或者null
  Future<NIMResult<String?>> getCurrentAccount() async {
    return _platform.getCurrentAccount();
  }
}
