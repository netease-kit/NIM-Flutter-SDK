// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

part of nim_core;

class AuthService {
  factory AuthService() {
    if (_singleton == null) {
      _singleton = AuthService._();
    }
    return _singleton!;
  }

  AuthService._();

  static AuthService? _singleton;

  AuthServicePlatform get _platform => AuthServicePlatform.instance;

  /// 登录状态事件流
  Stream<NIMAuthStatusEvent> get authStatus => _platform.authStatus;

  /// 多端登录事件流
  Stream<List<NIMOnlineClient>> get onlineClients => _platform.onlineClients;

  /// 获取动态登录token提供者
  get dynamicTokenProvider => _platform.dynamicTokenProvider;

  /// 设置动态登录token提供者
  set dynamicTokenProvider(dynamicTokenProvider) =>
      _platform.dynamicTokenProvider = dynamicTokenProvider;

  /// 踢掉其他在线端
  /// [NIMOnlineClient] 可以从 [onlineClients] 事件监听中获取
  Future<NIMResult<void>> kickOutOtherOnlineClient(NIMOnlineClient client) =>
      _platform.kickOutOtherOnlineClient(client);

  /// 登录接口。sdk会自动连接服务器，传递用户信息，返回登录结果。
  Future<NIMResult<void>> login(NIMLoginInfo loginInfo) {
    final info;
    final sdkOptions = NimCore.instance.sdkOptions;
    if (sdkOptions != null && loginInfo.customClientType == null) {
      info = NIMLoginInfo(
        account: loginInfo.account,
        token: loginInfo.token,
        authType: loginInfo.authType,
        loginExt: loginInfo.loginExt,
        customClientType: sdkOptions.customClientType,
      );
    } else {
      info = loginInfo;
    }
    return _platform.login(info);
  }

  ///注销登录
  Future<NIMResult<void>> logout() async {
    return _platform.logout();
  }
}
