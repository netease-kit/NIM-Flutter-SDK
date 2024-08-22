// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

part of nim_core_v2;

/// 好友服务
@HawkEntryPoint()
class FriendService {
  factory FriendService() {
    if (_singleton == null) {
      _singleton = FriendService._();
    }
    return _singleton!;
  }

  FriendService._();

  static FriendService? _singleton;

  FriendServicePlatform get _platform => FriendServicePlatform.instance;

  /// 已添加好友
  /// 触发条件， 本端直接添加好友，多端同步
  @HawkApi(ignore: true)
  Stream<NIMFriend> get onFriendAdded => _platform.onFriendAdded;

  /// 删除好友通知
  /// 触发条件：本端删除好友，多端同步 ， 对方删除你（nimFriendDeletionTypeByFriend）
  @HawkApi(ignore: true)
  Stream<NIMFriendDeletion> get onFriendDeleted => _platform.onFriendDeleted;

  /// 好友信息变更
  /// 触发条件：本端修改好友信息，多端同步
  @HawkApi(ignore: true)
  Stream<NIMFriend> get onFriendInfoChanged => _platform.onFriendInfoChanged;

  /// 好友添加申请回调
  @HawkApi(ignore: true)
  Stream<NIMFriendAddApplication> get onFriendAddApplication =>
      _platform.onFriendAddApplication;

  /// 好友添加申请被拒绝回调
  @HawkApi(ignore: true)
  Stream<NIMFriendAddApplication> get onFriendAddRejected =>
      _platform.onFriendAddRejected;

  /// 添加好友
  /// 调用此方法后，系统会向对端发送一条系统通知。
  /// 通知类型：FRIEND_ADD
  /// 调用此接口后：
  /// - 如果 addMode 是 ADD：本端和对端SDK会触发：onFriendAdded
  /// - 如果 addMode 是 APPLY：对端SDK会触发：onFriendAddApplication
  Future<NIMResult<void>> addFriend(
      String accountId, NIMFriendAddParams? params) async {
    return _platform.addFriend(accountId, params);
  }

  /// 删除好友
  /// 调用此方法后，系统会向对端发送一条系统通知。
  /// 通知类型：FRIEND_DELETE
  /// 调用此接口后，本端和对端SDK都会触发：onFriendDeleted
  Future<NIMResult<void>> deleteFriend(
      String accountId, NIMFriendDeleteParams? params) async {
    return _platform.deleteFriend(accountId, params);
  }

  /// 接受好友申请
  /// 调用此方法后，会向对端发送一条系统通知。
  /// 通知类型：FRIEND_ADD
  /// 调用此接口后，本端SDK会触发：onFriendAdded
  Future<NIMResult<void>> acceptAddApplication(
      NIMFriendAddApplication application) async {
    return _platform.acceptAddApplication(application);
  }

  /// 拒绝添加好友申请
  /// 调用此方法后，会向对端发送一条系统通知。
  /// 通知类型：FRIEND_ADD
  /// 调用此接口后，对端SDK会触发：onFriendAddRejected
  Future<NIMResult<void>> rejectAddApplication(
      NIMFriendAddApplication application, String postscript) async {
    return _platform.rejectAddApplication(application, postscript);
  }

  /// 设置好友信息
  /// 调用此接口后，本端SDK会触发：onFriendsInfoChanged
  Future<NIMResult<void>> setFriendInfo(
      String accountId, NIMFriendSetParams params) async {
    return _platform.setFriendInfo(accountId, params);
  }

  /// 获取好友列表
  /// 本地查询，登录后开始同步好友信息，建议同步完成后拉取一次。
  Future<NIMResult<List<NIMFriend>>> getFriendList() async {
    return _platform.getFriendList();
  }

  /// 根据账号ID获取好友信息
  /// 只返回存在的好友信息，返回顺序与输入顺序一致。
  Future<NIMResult<List<NIMFriend>>> getFriendByIds(
      List<String> accountIds) async {
    return _platform.getFriendByIds(accountIds);
  }

  /// 根据账号ID检查好友状态
  Future<NIMResult<Map<String, bool>>> checkFriend(
      List<String> accountIds) async {
    return _platform.checkFriend(accountIds);
  }

  /// 获取申请添加好友信息列表
  /// 查询verifyType等于3的数据，从新到旧排序。
  Future<NIMResult<NIMFriendAddApplicationResult>> getAddApplicationList(
      NIMFriendAddApplicationQueryOption option) async {
    return _platform.getAddApplicationList(option);
  }

  /// 获取好友申请未读数量
  /// 统计所有未处理且未读的申请数量。
  Future<NIMResult<int>> getAddApplicationUnreadCount() async {
    return _platform.getAddApplicationUnreadCount();
  }

  /// 设置好友申请已读
  /// 调用此方法后，所有历史未读数据将标记为已读。
  Future<NIMResult<void>> setAddApplicationRead() async {
    return _platform.setAddApplicationRead();
  }

  /// 根据关键字搜索好友信息
  Future<NIMResult<List<NIMFriend>>> searchFriendByOption(
      NIMFriendSearchOption friendSearchOption) async {
    return _platform.searchFriendByOption(friendSearchOption);
  }
}
