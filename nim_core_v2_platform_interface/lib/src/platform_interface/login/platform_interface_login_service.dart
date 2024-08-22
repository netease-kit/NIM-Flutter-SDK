// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:nim_core_v2_platform_interface/nim_core_v2_platform_interface.dart';
import 'package:nim_core_v2_platform_interface/src/method_channel/method_channel_login_service.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

abstract class LoginServicePlatform extends Service {
  LoginServicePlatform() : super(token: _token);

  static final Object _token = Object();

  static LoginServicePlatform _instance = MethodChannelLoginService();

  static LoginServicePlatform get instance => _instance;

  static set instance(LoginServicePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// 登录状态变更事件
  Stream<NIMLoginStatus> get onLoginStatus;

  /// 登录失败
  Stream<NIMError> get onLoginFailed;

  /// 被踢下线
  Stream<NIMKickedOfflineDetail> get onKickedOffline;

  /// 登录客户端列表变更
  Stream<NIMLoginClientChangeEvent> get onLoginClientChanged;

  /// 连接状态变更
  Stream<NIMConnectStatus> get onConnectStatus;

  /// 链接断开
  Stream<NIMError> get onDisconnected;

  ///链接失败
  Stream<NIMError> get onConnectFailed;

  ///数据同步
  Stream<NIMDataSyncDetail> get onDataSync;

  /// token提供者
  NIMTokenProvider? tokenProvider;

  /// 提供登录扩展信息
  NIMLoginExtensionProvider? loginExtensionProvider;

  /// 重连延时回调，<0 无效
  NIMReconnectDelayProvider? reconnectDelayProvider;

  /// 登录
  /// [accountId] 账号
  /// [token] token
  /// [option] 设置
  Future<NIMResult<void>> login(
      String accountId, String token, NIMLoginOption option) async {
    throw UnimplementedError('login() is not implemented');
  }

  /// 登出
  Future<NIMResult<void>> logout() async {
    throw UnimplementedError('logout() is not implemented');
  }

  /// 获取当前登录用户
  /// 返回当前登录用户账号
  Future<NIMResult<String?>> getLoginUser() {
    throw UnimplementedError('getLoginUser() is not implemented');
  }

  /// 获取登录状态
  /// 返回当前登录状态
  Future<NIMResult<NIMLoginStatus>> getLoginStatus() {
    throw UnimplementedError('getLoginStatus() is not implemented');
  }

  /// 获取登录客户端列表
  /// 返回当前登录客户端列表
  Future<NIMResult<List<NIMLoginClient>>> getLoginClients() {
    throw UnimplementedError('getLoginClients() is not implemented');
  }

  /// 踢掉登录客户端下线
  Future<NIMResult<void>> kickOffline(NIMLoginClient client) {
    throw UnimplementedError('kickOffline() is not implemented');
  }

  /// 获取被踢下线原因
  /// 返回被踢下线原因
  Future<NIMResult<NIMKickedOfflineDetail?>> getKickedOfflineDetail() {
    throw UnimplementedError('getKickedOfflineDetail() is not implemented');
  }

  /// 获取连接状态
  /// 返回当前连接状态
  Future<NIMResult<NIMConnectStatus>> getConnectStatus() {
    throw UnimplementedError('getConnectStatus() is not implemented');
  }

  /// 获取当前数据同步项
  /// 返回当前数据同步项
  Future<NIMResult<List<NIMDataSyncDetail>>> getDataSync() {
    throw UnimplementedError('getDataSync() is not implemented');
  }

  /// 获取聊天室link地址
  /// 需要IM处于登录状态
  Future<NIMResult<List<String>?>> getChatroomLinkAddress(String roomId) {
    throw UnimplementedError('getChatroomLinkAddress() is not implemented');
  }

  Future<NIMResult<void>> setReconnectDelayProvider(
      NIMReconnectDelayProvider? provider) async {
    throw UnimplementedError('setReconnectDelayProvider() is not implemented');
  }
}

/// 提供动态token
typedef NIMTokenProvider = Future<String> Function(String account);

/// 提供登录扩展信息
typedef NIMLoginExtensionProvider = Future<String?> Function(String account);

/// 重连延时回调接口
typedef NIMReconnectDelayProvider = Future<int> Function(int delay);
