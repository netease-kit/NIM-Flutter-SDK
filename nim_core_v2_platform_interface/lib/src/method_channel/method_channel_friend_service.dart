// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:nim_core_v2_platform_interface/src/platform_interface/friend/platform_interface_friend_service.dart';
import 'package:nim_core_v2_platform_interface/src/platform_interface/nim_base.dart';

import 'package:nim_core_v2_platform_interface/src/platform_interface/friend/friend_models.dart';

class MethodChannelFriendService extends FriendServicePlatform {
  // ignore: close_sinks
  final _friendAddedController = StreamController<NIMFriend>.broadcast();

  final _friendDeletedController =
      StreamController<NIMFriendDeletion>.broadcast();

  final _friendInfoChangedController = StreamController<NIMFriend>.broadcast();

  final _friendAddApplicationController =
      StreamController<NIMFriendAddApplication>.broadcast();

  final _friendAddRejectedController =
      StreamController<NIMFriendAddApplication>.broadcast();

  @override
  Future onEvent(String method, arguments) {
    switch (method) {
      case 'onFriendAdded':
        assert(arguments is Map);
        _friendAddedController.add(
            NIMFriend.fromJson(Map<String, dynamic>.from(arguments as Map)));
        break;
      case 'onFriendDeleted':
        assert(arguments is Map);
        _friendDeletedController.add(NIMFriendDeletion.fromJson(
            Map<String, dynamic>.from(arguments as Map)));
        break;
      case 'onFriendInfoChanged':
        assert(arguments is Map);
        _friendInfoChangedController.add(
            NIMFriend.fromJson(Map<String, dynamic>.from(arguments as Map)));
        break;
      case 'onFriendAddApplication':
        assert(arguments is Map);
        _friendAddApplicationController.add(NIMFriendAddApplication.fromJson(
            Map<String, dynamic>.from(arguments as Map)));
        break;
      case 'onFriendAddRejected':
        assert(arguments is Map);
        _friendAddRejectedController.add(NIMFriendAddApplication.fromJson(
            Map<String, dynamic>.from(arguments as Map)));
        break;
      default:
        throw UnimplementedError();
    }
    return Future.value();
  }

  @override
  String get serviceName => 'FriendService';

  /// 添加好友
  /// 调用此方法后，系统会向对端发送一条系统通知。
  /// 通知类型：FRIEND_ADD
  /// 调用此接口后：
  /// - 如果 addMode 是 ADD：本端和对端SDK会触发：onFriendAdded
  /// - 如果 addMode 是 APPLY：对端SDK会触发：onFriendAddApplication
  Future<NIMResult<void>> addFriend(
      String accountId, NIMFriendAddParams? params) async {
    return NIMResult.fromMap(
      await invokeMethod(
        'addFriend',
        arguments: {
          'accountId': accountId,
          'params': params?.toJson(),
        },
      ),
    );
  }

  /// 删除好友
  /// 调用此方法后，系统会向对端发送一条系统通知。
  /// 通知类型：FRIEND_DELETE
  /// 调用此接口后，本端和对端SDK都会触发：onFriendDeleted
  Future<NIMResult<void>> deleteFriend(
      String accountId, NIMFriendDeleteParams? params) async {
    return NIMResult.fromMap(
      await invokeMethod(
        'deleteFriend',
        arguments: {
          'accountId': accountId,
          'params': params?.toJson(),
        },
      ),
    );
  }

  /// 接受好友申请
  /// 调用此方法后，会向对端发送一条系统通知。
  /// 通知类型：FRIEND_ADD
  /// 调用此接口后，本端SDK会触发：onFriendAdded
  Future<NIMResult<void>> acceptAddApplication(
      NIMFriendAddApplication application) async {
    return NIMResult.fromMap(
      await invokeMethod(
        'acceptAddApplication',
        arguments: {
          'application': application.toJson(),
        },
      ),
    );
  }

  /// 拒绝添加好友申请
  /// 调用此方法后，会向对端发送一条系统通知。
  /// 通知类型：FRIEND_ADD
  /// 调用此接口后，对端SDK会触发：onFriendAddRejected
  Future<NIMResult<void>> rejectAddApplication(
      NIMFriendAddApplication application, String postscript) async {
    return NIMResult.fromMap(
      await invokeMethod(
        'rejectAddApplication',
        arguments: {
          'application': application.toJson(),
          'postscript': postscript,
        },
      ),
    );
  }

  /// 设置好友信息
  /// 调用此接口后，本端SDK会触发：onFriendsInfoChanged
  Future<NIMResult<void>> setFriendInfo(
      String accountId, NIMFriendSetParams params) async {
    return NIMResult.fromMap(
      await invokeMethod(
        'setFriendInfo',
        arguments: {
          'accountId': accountId,
          'params': params.toJson(),
        },
      ),
    );
  }

  /// 获取好友列表
  /// 本地查询，登录后开始同步好友信息，建议同步完成后拉取一次。
  Future<NIMResult<List<NIMFriend>>> getFriendList() async {
    return NIMResult.fromMap(
        await invokeMethod(
          'getFriendList',
        ),
        convert: (json) => (json['friendList'] as List<dynamic>?)
            ?.map((e) => NIMFriend.fromJson((e as Map).cast<String, dynamic>()))
            .toList());
  }

  /// 根据账号ID获取好友信息
  /// 只返回存在的好友信息，返回顺序与输入顺序一致。
  Future<NIMResult<List<NIMFriend>>> getFriendByIds(
      List<String> accountIds) async {
    return NIMResult.fromMap(
        await invokeMethod(
          'getFriendByIds',
          arguments: {
            'accountIds': accountIds,
          },
        ),
        convert: (json) => (json['friendList'] as List<dynamic>?)
            ?.map((e) => NIMFriend.fromJson((e as Map).cast<String, dynamic>()))
            .toList());
  }

  /// 根据账号ID检查好友状态
  Future<NIMResult<Map<String, bool>>> checkFriend(
      List<String> accountIds) async {
    return NIMResult.fromMap(
        await invokeMethod(
          'checkFriend',
          arguments: {
            'accountIds': accountIds,
          },
        ),
        convert: (json) => (json['result'] as Map?)?.cast<String, bool>());
  }

  /// 获取申请添加好友信息列表
  /// 查询verifyType等于3的数据，从新到旧排序。
  Future<NIMResult<NIMFriendAddApplicationResult>> getAddApplicationList(
      NIMFriendAddApplicationQueryOption option) async {
    return NIMResult.fromMap(
        await invokeMethod(
          'getAddApplicationList',
          arguments: {
            'option': option.toJson(),
          },
        ),
        convert: (json) => NIMFriendAddApplicationResult.fromJson(json));
  }

  /// 获取好友申请未读数量
  /// 统计所有未处理且未读的申请数量。
  Future<NIMResult<int>> getAddApplicationUnreadCount() async {
    return NIMResult.fromMap(await invokeMethod(
      'getAddApplicationUnreadCount',
    ));
  }

  /// 设置好友申请已读
  /// 调用此方法后，所有历史未读数据将标记为已读。
  Future<NIMResult<void>> setAddApplicationRead() async {
    return NIMResult.fromMap(
      await invokeMethod(
        'setAddApplicationRead',
      ),
    );
  }

  /// 根据关键字搜索好友信息
  Future<NIMResult<List<NIMFriend>>> searchFriendByOption(
      NIMFriendSearchOption friendSearchOption) async {
    return NIMResult.fromMap(
        await invokeMethod(
          'searchFriendByOption',
          arguments: {
            'friendSearchOption': friendSearchOption.toJson(),
          },
        ),
        convert: (json) => (json['friendList'] as List<dynamic>?)
            ?.map((e) => NIMFriend.fromJson(Map<String, dynamic>.from(e)))
            .toList());
  }

  @override
  Stream<NIMFriendAddApplication> get onFriendAddApplication =>
      _friendAddApplicationController.stream;

  @override
  Stream<NIMFriendAddApplication> get onFriendAddRejected =>
      _friendAddRejectedController.stream;

  @override
  Stream<NIMFriend> get onFriendAdded => _friendAddedController.stream;

  @override
  Stream<NIMFriendDeletion> get onFriendDeleted =>
      _friendDeletedController.stream;

  @override
  Stream<NIMFriend> get onFriendInfoChanged =>
      _friendInfoChangedController.stream;
}
