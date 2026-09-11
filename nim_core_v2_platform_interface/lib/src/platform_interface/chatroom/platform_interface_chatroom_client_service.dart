// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:nim_core_v2_platform_interface/nim_core_v2_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import '../../method_channel/method_channel_chatroom_client_service.dart';

abstract class ChatroomClientPlatform extends Service {
  ChatroomClientPlatform() : super(token: _token);

  static final Object _token = Object();

  static ChatroomClientPlatform _instance =
      MethodChannelChatroomClientService();

  static ChatroomClientPlatform get instance => _instance;

  static set instance(ChatroomClientPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  ///聊天室状态变更
  Stream<V2NIMChatroomStatusInfo> get onChatroomStatus;

  ///进入聊天室成功
  Stream<int> get onChatroomEntered;

  ///退出聊天室
  Stream<ChatRoomExitInfo> get onChatroomExited;

  ///自己被踢出聊天室
  Stream<V2NIMChatroomKickedInfoEvent> get onChatroomKicked;

  /// token提供者
  V2NIMChatroomTokenProvider? tokenProvider;

  ///登录扩展信息
  V2NIMChatroomLoginExtensionProvider? extensionProvider;

  ///链接地址提供者
  V2NIMChatroomLinkProvider? linkProvider;

  /// PC初始化聊天室，仅供PC端使用。PC端`ChatroomClient`必须要先初始化，才能使用
  Future<NIMResult<void>> init(NIMSDKOptions options) {
    throw UnimplementedError('init() is not implemented');
  }

  /// PC释放聊天室，仅供PC端使用。
  Future<NIMResult<void>> uninit() {
    throw UnimplementedError('uninit() is not implemented');
  }

  /// 构造一个新的聊天室实例
  Future<NIMResult<int>> newInstance() {
    throw UnimplementedError('newInstance() is not implemented');
  }

  /// 通过identityId（唯一标识）获取之前已经创建的V2NIMChatroomClient
  Future<NIMResult<int>> getInstance(int instanceId) {
    throw UnimplementedError('getInstance() is not implemented');
  }

  /// 获取当前已经存在的聊天室实例列表
  Future<NIMResult<List<int>>> getInstanceList() {
    throw UnimplementedError('getInstanceList() is not implemented');
  }

  /// 进入聊天室
  Future<NIMResult<V2NIMChatroomEnterResult>> enter(
      int instanceId, String roomId, V2NIMChatroomEnterParams enterParams) {
    throw UnimplementedError('enter() is not implemented');
  }

  /// 退出聊天室
  Future<NIMResult<void>> exit(int instanceId) {
    throw UnimplementedError('exit() is not implemented');
  }

  /// getChatroomInfo
  Future<NIMResult<V2NIMChatroomInfo>> getChatroomInfo(int instanceId) {
    throw UnimplementedError('getChatroomInfo() is not implemented');
  }

  /// 添加聊天室实例监听器
  Future<NIMResult<void>> addChatroomClientListener(int instanceId) {
    throw UnimplementedError('addChatroomClientListener() is not implemented');
  }

  /// 移除聊天室实例监听器
  Future<NIMResult<void>> removeChatroomClientListener(int instanceId) {
    throw UnimplementedError(
        'removeChatroomClientListener() is not implemented');
  }

  /// 销毁指定聊天室实例
  Future<NIMResult<void>> destroyInstance(int instanceId) {
    throw UnimplementedError('destroyInstance() is not implemented');
  }

  /// 销毁当前的所有聊天室实例
  Future<NIMResult<void>> destroyAll() {
    throw UnimplementedError('destroyAll() is not implemented');
  }
}

///  * token提供回调
/// authtype==1，客户侧动态token签算提供类
/// authtype==0， 默认静态token
typedef V2NIMChatroomTokenProvider = Future<String> Function(
    int instanceId, String roomId, String accountId);

/// 在部分场景下，客户可能需要传输一些业务相关数据，则可采用该回调传输业务相关数据
typedef V2NIMChatroomLoginExtensionProvider = Future<String> Function(
    int instanceId, String roomId, String accountId);

/// 获取聊天室link地址
typedef V2NIMChatroomLinkProvider = Future<List<String>> Function(
    int instanceId, String roomId, String accountId);
