// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:nim_core_v2_platform_interface/nim_core_v2_platform_interface.dart';

class MethodChannelChatroomClientService extends ChatroomClientPlatform {
  ///聊天室状态变更
  final _onChatroomStatusController =
      StreamController<V2NIMChatroomStatusInfo>.broadcast();

  ///进入聊天室成功
  final _onChatroomEnteredController = StreamController<int>.broadcast();

  ///退出聊天室
  final _onChatroomExitedController =
      StreamController<ChatRoomExitInfo>.broadcast();

  ///自己被踢出聊天室
  final _onChatroomKickedController =
      StreamController<V2NIMChatroomKickedInfoEvent>.broadcast();

  @override
  Future onEvent(String method, arguments) {
    switch (method) {
      case 'getToken':
        return onGetToken(arguments);
      case 'getLoginExtension':
        return onGetLoginExtension(arguments);
      case 'getLinkAddress':
        return onGetLinkAddress(arguments);
      case 'onChatroomStatus':
        assert(arguments is Map);
        _onChatroomStatusController.add(V2NIMChatroomStatusInfo.fromJson(
            Map<String, dynamic>.from(arguments)));
        break;
      case 'onChatroomEntered':
        assert(arguments is Map);
        _onChatroomEnteredController
            .add(Map<String, dynamic>.from(arguments)['instanceId'] as int);
        break;
      case 'onChatroomExited':
        assert(arguments is Map);
        _onChatroomExitedController.add(
            ChatRoomExitInfo.fromJson(Map<String, dynamic>.from(arguments)));
        break;
      case 'onChatroomKicked':
        assert(arguments is Map);
        _onChatroomKickedController.add(V2NIMChatroomKickedInfoEvent.fromJson(
            Map<String, dynamic>.from(arguments)));
        break;
      default:
        throw UnimplementedError();
    }
    return Future.value();
  }

  @override
  String get serviceName => 'V2NIMChatroomClient';

  /// PC初始化聊天室
  @override
  Future<NIMResult<void>> init(NIMSDKOptions options) async {
    return NIMResult.fromMap(
        await invokeMethod('init', arguments: options.toMap()));
  }

  /// PC释放聊天室
  @override
  Future<NIMResult<void>> uninit() async {
    return NIMResult.fromMap(await invokeMethod('uninit'));
  }

  @override
  Future<NIMResult<int>> newInstance() async {
    return NIMResult.fromMap(
        await invokeMethod(
          'newInstance',
        ),
        convert: (json) =>
            Map<String, dynamic>.from(json)['instanceId'] as int);
  }

  /// 通过identityId（唯一标识）获取之前已经创建的V2NIMChatroomClient
  Future<NIMResult<int>> getInstance(int instanceId) async {
    return NIMResult.fromMap(
        await invokeMethod('getInstance',
            arguments: {'instanceId': instanceId}),
        convert: (json) =>
            Map<String, dynamic>.from(json)['instanceId'] as int);
  }

  /// 获取当前已经存在的聊天室实例列表
  Future<NIMResult<List<int>>> getInstanceList() async {
    return NIMResult.fromMap(await invokeMethod('getInstanceList'),
        convert: (json) => List<int>.from(json['instanceList']));
  }

  /// 进入聊天室
  Future<NIMResult<V2NIMChatroomEnterResult>> enter(int instanceId,
      String roomId, V2NIMChatroomEnterParams enterParams) async {
    return NIMResult.fromMap(
        await invokeMethod('enter', arguments: {
          'instanceId': instanceId,
          'roomId': roomId,
          'enterParams': enterParams.toJson()
        }),
        convert: (json) => V2NIMChatroomEnterResult.fromJson(json));
  }

  /// 退出聊天室
  Future<NIMResult<void>> exit(int instanceId) async {
    return NIMResult.fromMap(
        await invokeMethod('exit', arguments: {'instanceId': instanceId}));
  }

  /// getChatroomInfo
  Future<NIMResult<V2NIMChatroomInfo>> getChatroomInfo(int instanceId) async {
    return NIMResult.fromMap(
        await invokeMethod('getChatroomInfo',
            arguments: {'instanceId': instanceId}),
        convert: (json) => V2NIMChatroomInfo.fromJson(json));
  }

  /// 添加聊天室实例监听器
  Future<NIMResult<void>> addChatroomClientListener(int instanceId) async {
    return NIMResult.fromMap(await invokeMethod('addChatroomClientListener',
        arguments: {'instanceId': instanceId}));
  }

  /// 移除聊天室实例监听器
  Future<NIMResult<void>> removeChatroomClientListener(int instanceId) async {
    return NIMResult.fromMap(await invokeMethod('removeChatroomClientListener',
        arguments: {'instanceId': instanceId}));
  }

  /// 销毁指定聊天室实例
  Future<NIMResult<void>> destroyInstance(int instanceId) async {
    return NIMResult.fromMap(await invokeMethod('destroyInstance',
        arguments: {'instanceId': instanceId}));
  }

  /// 销毁当前的所有聊天室实例
  Future<NIMResult<void>> destroyAll() async {
    return NIMResult.fromMap(await invokeMethod('destroyAll'));
  }

  Future<String?> onGetToken(arguments) async {
    assert(arguments is Map);
    final flutterTokenProvider = tokenProvider;
    final account = arguments['accountId'] as String?;
    final roomId = arguments['roomId'] as String?;
    final instanceId = arguments['instanceId'] as int?;
    assert(account != null && roomId != null && instanceId != null);
    if (flutterTokenProvider == null ||
        account == null ||
        roomId == null ||
        instanceId == null) return null;
    return await flutterTokenProvider(instanceId, roomId, account);
  }

  Future<String?> onGetLoginExtension(arguments) async {
    assert(arguments is Map);
    final flutterExtension = extensionProvider;
    final account = arguments['accountId'] as String?;
    final roomId = arguments['roomId'] as String?;
    final instanceId = arguments['instanceId'] as int?;
    assert(account != null && roomId != null && instanceId != null);
    if (flutterExtension == null ||
        account == null ||
        roomId == null ||
        instanceId == null) return null;
    return await flutterExtension(instanceId, roomId, account);
  }

  Future<List<String>?> onGetLinkAddress(arguments) async {
    assert(arguments is Map);
    final flutterLinkProvider = linkProvider;
    final account = arguments['accountId'] as String?;
    final roomId = arguments['roomId'] as String?;
    final instanceId = arguments['instanceId'] as int?;
    assert(account != null && roomId != null && instanceId != null);
    if (flutterLinkProvider == null ||
        account == null ||
        roomId == null ||
        instanceId == null) return null;
    final links = await flutterLinkProvider(instanceId, roomId, account);
    return links;
  }

  @override
  Stream<int> get onChatroomEntered => _onChatroomEnteredController.stream;

  @override
  Stream<ChatRoomExitInfo> get onChatroomExited =>
      _onChatroomExitedController.stream;

  @override
  Stream<V2NIMChatroomKickedInfoEvent> get onChatroomKicked =>
      _onChatroomKickedController.stream;

  @override
  Stream<V2NIMChatroomStatusInfo> get onChatroomStatus =>
      _onChatroomStatusController.stream;
}
