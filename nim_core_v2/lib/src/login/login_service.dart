// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

part of nim_core_v2;

/// 登录服务
@HawkEntryPoint()
class LoginService {
  factory LoginService() {
    if (_singleton == null) {
      _singleton = LoginService._();
    }
    return _singleton!;
  }

  LoginService._();

  static LoginService? _singleton;

  LoginServicePlatform get _platform => LoginServicePlatform.instance;

  /// 登录状态变更事件
  @HawkApi(ignore: true)
  Stream<NIMLoginStatus> get onLoginStatus => _platform.onLoginStatus;

  /// 登录失败
  @HawkApi(ignore: true)
  Stream<NIMError> get onLoginFailed => _platform.onLoginFailed;

  /// 被踢下线
  @HawkApi(ignore: true)
  Stream<NIMKickedOfflineDetail> get onKickedOffline =>
      _platform.onKickedOffline;

  /// 登录客户端列表变更
  @HawkApi(ignore: true)
  Stream<NIMLoginClientChangeEvent> get onLoginClientChanged =>
      _platform.onLoginClientChanged;

  /// 连接状态变更
  @HawkApi(ignore: true)
  Stream<NIMConnectStatus> get onConnectStatus => _platform.onConnectStatus;

  /// 链接断开
  @HawkApi(ignore: true)
  Stream<NIMError> get onDisconnected => _platform.onDisconnected;

  ///链接失败
  @HawkApi(ignore: true)
  Stream<NIMError> get onConnectFailed => _platform.onConnectFailed;

  ///数据同步
  @HawkApi(ignore: true)
  Stream<NIMDataSyncDetail> get onDataSync => _platform.onDataSync;

  /// 获取动态登录token提供者
  @HawkApi(ignore: true)
  get tokenProvider => _platform.tokenProvider;

  /// 设置动态登录token提供者
  @HawkApi(ignore: true)
  set tokenProvider(tokenProvider) => _platform.tokenProvider = tokenProvider;

  /// 提供登录扩展信息
  @HawkApi(ignore: true)
  get loginExtensionProvider => _platform.loginExtensionProvider;

  /// 设置登录扩展信息
  @HawkApi(ignore: true)
  set loginExtensionProvider(loginExtensionProvider) =>
      _platform.loginExtensionProvider = loginExtensionProvider;

  /// 重连延时回调
  /// 在[setReconnectDelayProvider] 中设置
  @HawkApi(ignore: true)
  get reconnectDelayProvider => _platform.reconnectDelayProvider;

  /// 登录
  /// [accountId] 账号
  /// [token] token
  /// [option] 设置
  Future<NIMResult<void>> login(
      String accountId, String token, NIMLoginOption option) async {
    return _platform.login(accountId, token, option);
  }

  /// 登出
  Future<NIMResult<void>> logout() async {
    return _platform.logout();
  }

  /// 获取当前登录用户
  /// 返回当前登录用户账号
  Future<NIMResult<String?>> getLoginUser() {
    return _platform.getLoginUser();
  }

  /// 获取登录状态
  /// 返回当前登录状态
  Future<NIMResult<NIMLoginStatus>> getLoginStatus() {
    return _platform.getLoginStatus();
  }

  /// 获取登录客户端列表
  /// 返回当前登录客户端列表
  Future<NIMResult<List<NIMLoginClient>>> getLoginClients() {
    return _platform.getLoginClients();
  }

  /// 踢掉登录客户端下线
  Future<NIMResult<void>> kickOffline(NIMLoginClient client) {
    return _platform.kickOffline(client);
  }

  /// 获取被踢下线原因
  /// 返回被踢下线原因
  Future<NIMResult<NIMKickedOfflineDetail?>> getKickedOfflineDetail() {
    return _platform.getKickedOfflineDetail();
  }

  /// 获取连接状态
  /// 返回当前连接状态
  Future<NIMResult<NIMConnectStatus>> getConnectStatus() {
    return _platform.getConnectStatus();
  }

  /// 获取当前数据同步项
  /// 返回当前数据同步项
  Future<NIMResult<List<NIMDataSyncDetail>>> getDataSync() {
    return _platform.getDataSync();
  }

  /// 获取聊天室link地址
  /// 需要IM处于登录状态
  Future<NIMResult<List<String>?>> getChatroomLinkAddress(String roomId) {
    return _platform.getChatroomLinkAddress(roomId);
  }

  /// 设置重连延时回调
  /// 调用此接口后再[reconnectDelayProvider]中处理回调
  @HawkApi(ignore: true)
  Future<NIMResult<void>> setReconnectDelayProvider(
      NIMReconnectDelayProvider? provider) {
    return _platform.setReconnectDelayProvider(provider);
  }
}
