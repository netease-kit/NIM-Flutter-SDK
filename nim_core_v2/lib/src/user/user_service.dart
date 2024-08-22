// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

part of nim_core_v2;

/// 用户服务
@HawkEntryPoint()
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

  /// 用户资料变更通知
  @HawkApi(ignore: true)
  Stream<List<NIMUserInfo>> get onUserProfileChanged =>
      UserServicePlatform.instance.onUserProfileChanged.stream;

  /// 加入黑名单通知
  @HawkApi(ignore: true)
  Stream<NIMUserInfo> onBlockListAdded =
      UserServicePlatform.instance.onBlockListAdded.stream;

  /// 移除黑名单通知
  @HawkApi(ignore: true)
  Stream<String> onBlockListRemoved =
      UserServicePlatform.instance.onBlockListRemoved.stream;

  /// 根据用户账号列表获取用户资料 单次最大值150 只返回ID存在的用户，
  //  错误ID不返回 返回顺序以传入序为准（可以不做强制校验）
  //  先查询本地缓存，本地缺失或不足，再查询云端
  Future<NIMResult<List<NIMUserInfo>>> getUserList(List<String> userId) async {
    return _platform.getUserList(userId);
  }

  /// 根据用户账号列表从服务器获取用户资料 单次最大值150 只返回ID存在的用户，
  //  错误ID不返回 返回顺序以传入序为准（可以不做强制校验） 直接查询云端
  //  如果是协议错， 则整体返回错， 否则返回部分成功
  //  如果查询数据后，本地成员数据有更新， 则触发用户信息更新回调
  Future<NIMResult<List<NIMUserInfo>>> getUserListFromCloud(
      List<String> userId) async {
    return _platform.getUserListFromCloud(userId);
  }

  /// 更新自己的用户资料
  //  调用该Api后， SDK会抛出： onUserProfileChanged
  Future<NIMResult<void>> updateSelfUserProfile(
      NIMUserUpdateParam param) async {
    return _platform.updateSelfUserProfile(param);
  }

  /// 添加用户到黑名单中
  Future<NIMResult<void>> addUserToBlockList(String userId) async {
    return _platform.addUserToBlockList(userId);
  }

  /// 从黑名单中移除用户
  Future<NIMResult<void>> removeUserFromBlockList(String userId) async {
    return _platform.removeUserFromBlockList(userId);
  }

  /// 获取黑名单列表
  Future<NIMResult<List<String>>> getBlockList() async {
    return _platform.getBlockList();
  }

  /// 根据关键字搜索用户信息
  Future<NIMResult<List<NIMUserInfo>>> searchUserByOption(
      NIMUserSearchOption userSearchOption) async {
    return _platform.searchUserByOption(userSearchOption);
  }
}
