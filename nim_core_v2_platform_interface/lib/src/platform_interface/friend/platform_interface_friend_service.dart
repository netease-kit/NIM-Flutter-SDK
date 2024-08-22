// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:nim_core_v2_platform_interface/nim_core_v2_platform_interface.dart';
import 'package:nim_core_v2_platform_interface/src/method_channel/method_channel_friend_service.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

abstract class FriendServicePlatform extends Service {
  FriendServicePlatform() : super(token: _token);

  static final Object _token = Object();

  static FriendServicePlatform _instance = MethodChannelFriendService();

  static FriendServicePlatform get instance => _instance;

  static set instance(FriendServicePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// 已添加好友
  /// 触发条件， 本端直接添加好友，多端同步
  Stream<NIMFriend> get onFriendAdded;

  /// 删除好友通知
  /// 触发条件：本端删除好友，多端同步 ， 对方删除你（nimFriendDeletionTypeByFriend）
  Stream<NIMFriendDeletion> get onFriendDeleted;

  /// 好友信息变更
  /// 触发条件：本端修改好友信息，多端同步
  Stream<NIMFriend> get onFriendInfoChanged;

  /// 好友添加申请回调
  Stream<NIMFriendAddApplication> get onFriendAddApplication;

  /// 好友添加申请被拒绝回调
  Stream<NIMFriendAddApplication> get onFriendAddRejected;

  /// 添加好友
  /// 调用此方法后，系统会向对端发送一条系统通知。
  /// 通知类型：FRIEND_ADD
  /// 调用此接口后：
  /// - 如果 addMode 是 ADD：本端和对端SDK会触发：onFriendAdded
  /// - 如果 addMode 是 APPLY：对端SDK会触发：onFriendAddApplication
  Future<NIMResult<void>> addFriend(
      String accountId, NIMFriendAddParams? params) async {
    throw UnimplementedError('addFriend() is not implemented');
  }

  /// 删除好友
  /// 调用此方法后，系统会向对端发送一条系统通知。
  /// 通知类型：FRIEND_DELETE
  /// 调用此接口后，本端和对端SDK都会触发：onFriendDeleted
  Future<NIMResult<void>> deleteFriend(
      String accountId, NIMFriendDeleteParams? params) async {
    throw UnimplementedError('deleteFriend() is not implemented');
  }

  /// 接受好友申请
  /// 调用此方法后，会向对端发送一条系统通知。
  /// 通知类型：FRIEND_ADD
  /// 调用此接口后，本端SDK会触发：onFriendAdded
  Future<NIMResult<void>> acceptAddApplication(
      NIMFriendAddApplication application) async {
    throw UnimplementedError('acceptAddApplication() is not implemented');
  }

  /// 拒绝添加好友申请
  /// 调用此方法后，会向对端发送一条系统通知。
  /// 通知类型：FRIEND_ADD
  /// 调用此接口后，对端SDK会触发：onFriendAddRejected
  Future<NIMResult<void>> rejectAddApplication(
      NIMFriendAddApplication application, String postscript) async {
    throw UnimplementedError('rejectAddApplication() is not implemented');
  }

  /// 设置好友信息
  /// 调用此接口后，本端SDK会触发：onFriendsInfoChanged
  Future<NIMResult<void>> setFriendInfo(
      String accountId, NIMFriendSetParams params) async {
    throw UnimplementedError('setFriendInfo() is not implemented');
  }

  /// 获取好友列表
  /// 本地查询，登录后开始同步好友信息，建议同步完成后拉取一次。
  Future<NIMResult<List<NIMFriend>>> getFriendList() async {
    throw UnimplementedError('getFriendList() is not implemented');
  }

  /// 根据账号ID获取好友信息
  /// 只返回存在的好友信息，返回顺序与输入顺序一致。
  Future<NIMResult<List<NIMFriend>>> getFriendByIds(
      List<String> accountIds) async {
    throw UnimplementedError('getFriendByIds() is not implemented');
  }

  /// 根据账号ID检查好友状态
  Future<NIMResult<Map<String, bool>>> checkFriend(
      List<String> accountIds) async {
    throw UnimplementedError('checkFriend() is not implemented');
  }

  /// 获取申请添加好友信息列表
  /// 查询verifyType等于3的数据，从新到旧排序。
  Future<NIMResult<NIMFriendAddApplicationResult>> getAddApplicationList(
      NIMFriendAddApplicationQueryOption option) async {
    throw UnimplementedError('getAddApplicationList() is not implemented');
  }

  /// 获取好友申请未读数量
  /// 统计所有未处理且未读的申请数量。
  Future<NIMResult<int>> getAddApplicationUnreadCount() async {
    throw UnimplementedError(
        'getAddApplicationUnreadCount() is not implemented');
  }

  /// 设置好友申请已读
  /// 调用此方法后，所有历史未读数据将标记为已读。
  Future<NIMResult<void>> setAddApplicationRead() async {
    throw UnimplementedError('setAddApplicationRead() is not implemented');
  }

  /// 根据关键字搜索好友信息
  Future<NIMResult<List<NIMFriend>>> searchFriendByOption(
      NIMFriendSearchOption friendSearchOption) async {
    throw UnimplementedError('searchFriendByOption() is not implemented');
  }
}
