// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:nim_core_v2_platform_interface/src/platform_interface/login/login_models.dart';
import 'package:nim_core_v2_platform_interface/src/platform_interface/login/platform_interface_login_service.dart';
import 'package:nim_core_v2_platform_interface/src/platform_interface/nim_base.dart';
import 'package:nim_core_v2_platform_interface/src/platform_interface/nim_base_v2.dart';

class MethodChannelLoginService extends LoginServicePlatform {
  @override
  void registerWebAPI() {
    super.registerWebAPI();
  }

  // ignore: close_sinks
  final _loginStatusController = StreamController<NIMLoginStatus>.broadcast();

  // ignore: close_sinks
  final _loginFailedController = StreamController<NIMError>.broadcast();

  // ignore: close_sinks
  final _connectFailedController = StreamController<NIMError>.broadcast();

  final _kickedOfflineController =
      StreamController<NIMKickedOfflineDetail>.broadcast();

  final _loginClientsChangeController =
      StreamController<NIMLoginClientChangeEvent>.broadcast();

  final _dataSyncController = StreamController<NIMDataSyncDetail>.broadcast();

  final _disConnectedController = StreamController<NIMError>.broadcast();

  final _connectStatusController =
      StreamController<NIMConnectStatus>.broadcast();

  @override
  Future onEvent(String method, arguments) {
    switch (method) {
      case 'onLoginStatus':
        assert(arguments is Map);
        _loginStatusController.add(
            NIMLoginStatusClass.fromJson(Map<String, dynamic>.from(arguments))
                .status);
        break;
      case 'onLoginFailed':
        assert(arguments is Map);
        _loginFailedController
            .add(NIMError.fromJson(Map<String, dynamic>.from(arguments)));
        break;
      case 'onConnectFailed':
        assert(arguments is Map);
        _connectFailedController
            .add(NIMError.fromJson(Map<String, dynamic>.from(arguments)));
        break;
      case 'onKickedOffline':
        assert(arguments is Map);
        _kickedOfflineController.add(NIMKickedOfflineDetail.fromJson(
            Map<String, dynamic>.from(arguments)));
        break;
      case 'onLoginClientChanged':
        assert(arguments is Map);
        _loginClientsChangeController.add(NIMLoginClientChangeEvent.fromJson(
            Map<String, dynamic>.from(arguments)));
        break;
      case 'onDataSync':
        assert(arguments is Map);
        _dataSyncController.add(
            NIMDataSyncDetail.fromJson(Map<String, dynamic>.from(arguments)));
        break;
      case 'onDisconnected':
        assert(arguments is Map);
        _disConnectedController
            .add(NIMError.fromJson(Map<String, dynamic>.from(arguments)));
        break;
      case 'onConnectStatus':
        assert(arguments is Map);
        _connectStatusController.add(
            NIMConnectStatusClass.fromJson(Map<String, dynamic>.from(arguments))
                .status);
        break;
      case 'getToken':
        return onGetToken(arguments);
      case 'getLoginExtension':
        return onGetLoginExtension(arguments);
      case 'getReconnectDelay':
        return onGetReconnectDelay(arguments);
      default:
        throw UnimplementedError();
    }
    return Future.value();
  }

  @override
  String get serviceName => 'LoginService';

  /// 登录
  /// [accountId] 账号
  /// [token] token
  /// [option] 设置
  Future<NIMResult<void>> login(
      String accountId, String token, NIMLoginOption option) async {
    return NIMResult.fromMap(
      await invokeMethod(
        'login',
        arguments: {
          'accountId': accountId,
          'token': token,
          'option': option.toJson(),
        },
      ),
    );
  }

  /// 登出
  Future<NIMResult<void>> logout() async {
    return NIMResult.fromMap(
      await invokeMethod(
        'logout',
      ),
    );
  }

  /// 获取当前登录用户
  /// 返回当前登录用户账号
  Future<NIMResult<String?>> getLoginUser() async {
    return NIMResult.fromMap(
      await invokeMethod('getLoginUser'),
    );
  }

  /// 获取登录状态
  /// 返回当前登录状态
  Future<NIMResult<NIMLoginStatus>> getLoginStatus() async {
    return NIMResult.fromMap(
        await invokeMethod(
          'getLoginStatus',
        ),
        convert: (json) => NIMLoginStatusClass.fromJson(json).status);
  }

  /// 获取登录客户端列表
  /// 返回当前登录客户端列表
  Future<NIMResult<List<NIMLoginClient>>> getLoginClients() async {
    return NIMResult.fromMap(await invokeMethod('getLoginClients'),
        convert: (json) => (json['loginClient'] as List<dynamic>?)
            ?.map((e) => NIMLoginClient.fromJson(Map<String, dynamic>.from(e)))
            .toList());
  }

  /// 踢掉登录客户端下线
  Future<NIMResult<void>> kickOffline(NIMLoginClient client) async {
    return NIMResult.fromMap(
      await invokeMethod('kickOffline', arguments: {
        'client': client.toJson(),
      }),
    );
  }

  /// 获取被踢下线原因
  /// 返回被踢下线原因
  Future<NIMResult<NIMKickedOfflineDetail?>> getKickedOfflineDetail() async {
    return NIMResult.fromMap(await invokeMethod('getKickedOfflineDetail'),
        convert: (json) => NIMKickedOfflineDetail.fromJson(json));
  }

  /// 获取连接状态
  /// 返回当前连接状态
  Future<NIMResult<NIMConnectStatus>> getConnectStatus() async {
    return NIMResult.fromMap(await invokeMethod('getConnectStatus'),
        convert: (json) => NIMConnectStatusClass.fromJson(json).status);
  }

  /// 获取当前数据同步项
  /// 返回当前数据同步项
  Future<NIMResult<List<NIMDataSyncDetail>>> getDataSync() async {
    return NIMResult.fromMap(await invokeMethod('getDataSync'),
        convert: (json) => (json['dataSync'] as List<dynamic>?)
            ?.map(
                (e) => NIMDataSyncDetail.fromJson(Map<String, dynamic>.from(e)))
            .toList());
  }

  /// 获取聊天室link地址
  /// 需要IM处于登录状态
  Future<NIMResult<List<String>?>> getChatroomLinkAddress(String roomId) async {
    return NIMResult.fromMap(
      await invokeMethod('getChatroomLinkAddress', arguments: {
        'roomId': roomId,
      }),
      convert: (json) => (json['linkAddress'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );
  }

  Future<NIMResult<void>> setReconnectDelayProvider(
      NIMReconnectDelayProvider? provider) async {
    reconnectDelayProvider = provider;
    return NIMResult.fromMap(
      await invokeMethod('setReconnectDelayProvider'),
    );
  }

  @override
  Stream<NIMError> get onLoginFailed => _loginFailedController.stream;

  @override
  Stream<NIMLoginStatus> get onLoginStatus => _loginStatusController.stream;

  @override
  Stream<NIMError> get onConnectFailed => _connectFailedController.stream;

  @override
  Stream<NIMConnectStatus> get onConnectStatus =>
      _connectStatusController.stream;

  @override
  Stream<NIMDataSyncDetail> get onDataSync => _dataSyncController.stream;

  @override
  Stream<NIMError> get onDisconnected => _disConnectedController.stream;

  @override
  Stream<NIMKickedOfflineDetail> get onKickedOffline =>
      _kickedOfflineController.stream;

  @override
  Stream<NIMLoginClientChangeEvent> get onLoginClientChanged =>
      _loginClientsChangeController.stream;

  Future<String?> onGetToken(arguments) async {
    assert(arguments is Map);
    final flutterTokenProvider = tokenProvider;
    final account = arguments['accountId'] as String?;
    assert(account != null);
    if (flutterTokenProvider == null || account == null) return null;
    return await flutterTokenProvider(account);
  }

  Future<String?> onGetLoginExtension(arguments) async {
    assert(arguments is Map);
    final flutterLoginExtensionProvider = loginExtensionProvider;
    final account = arguments['accountId'] as String?;
    assert(account != null);
    if (flutterLoginExtensionProvider == null || account == null) return null;
    return await flutterLoginExtensionProvider(account);
  }

  Future<int?> onGetReconnectDelay(arguments) async {
    assert(arguments is Map);
    final flutterReconnectDelayProvider = reconnectDelayProvider;
    final account = arguments['delay'] as int?;
    assert(account != null);
    if (flutterReconnectDelayProvider == null || account == null) return null;
    return await flutterReconnectDelayProvider(account);
  }
}
