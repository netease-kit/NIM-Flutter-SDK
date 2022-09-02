// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:nim_core_platform_interface/nim_core_platform_interface.dart';
import 'package:nim_core_platform_interface/src/method_channel/method_channel_auth_service.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

abstract class AuthServicePlatform extends Service {
  AuthServicePlatform() : super(token: _token);

  static final Object _token = Object();

  static AuthServicePlatform _instance = MethodChannelAuthService();

  static AuthServicePlatform get instance => _instance;

  /// 动态token提供者。当登录模式为[NIMAuthType.authTypeDynamic]时，需要设置该提供者。
  NIMDynamicTokenProvider? dynamicTokenProvider;

  static set instance(AuthServicePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// 登录状态变更事件。
  /// 包含 [NIMAuthStatusEvent] 与 [NIMKickOutByOtherClientEvent]
  Stream<NIMAuthStatusEvent> get authStatus;

  /// 在线客户端列表变更事件
  /// [NIMOnlineClient]
  Stream<List<NIMOnlineClient>> get onlineClients;

  /// 踢掉其他在线端
  Future<NIMResult<void>> kickOutOtherOnlineClient(NIMOnlineClient client);

  /// 登录
  Future<NIMResult<void>> login(NIMLoginInfo loginInfo) async {
    throw UnimplementedError('login() is not implemented');
  }

  /// 登出
  Future<NIMResult<void>> logout() async {
    throw UnimplementedError('logout() is not implemented');
  }
}

typedef NIMDynamicTokenProvider = Future<String> Function(String account);
