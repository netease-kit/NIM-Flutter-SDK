// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

part of nim_core_v2;

class V2NIMChatroomClient {
  int instanceId;

  ///聊天室的Service 示例
  V2NIMChatroomService? _chatroomService;

  ///聊天室的存储服务
  StorageService? _storageService;

  ///聊天室队列服务
  V2NIMChatroomQueueService? _chatroomQueueService;

  V2NIMChatroomClient({required this.instanceId});

  static Map<int, V2NIMChatroomClient> chatroomClientMap = {};

  static ChatroomClientPlatform get _platform =>
      ChatroomClientPlatform.instance;

  ///聊天室状态变更
  @HawkApi(ignore: true)
  final _onChatroomStatusController =
      StreamController<V2NIMChatroomStatusInfo>.broadcast();

  ///进入聊天室成功
  @HawkApi(ignore: true)
  final _onChatroomEnteredController = StreamController<void>.broadcast();

  ///退出聊天室
  @HawkApi(ignore: true)
  final _onChatroomExitedController = StreamController<NIMError?>.broadcast();

  ///自己被踢出聊天室
  @HawkApi(ignore: true)
  final _onChatroomKickedController =
      StreamController<V2NIMChatroomKickedInfo>.broadcast();

  ///聊天室状态变更
  @HawkApi(ignore: true)
  Stream<V2NIMChatroomStatusInfo> get onChatroomStatus =>
      _onChatroomStatusController.stream;

  ///进入聊天室成功
  @HawkApi(ignore: true)
  Stream<void> get onChatroomEntered => _onChatroomEnteredController.stream;

  ///退出聊天室
  @HawkApi(ignore: true)
  Stream<NIMError?> get onChatroomExited => _onChatroomExitedController.stream;

  ///自己被踢出聊天室
  @HawkApi(ignore: true)
  Stream<V2NIMChatroomKickedInfo> get onChatroomKicked =>
      _onChatroomKickedController.stream;

  /// token提供者
  @HawkApi(ignore: true)
  V2NIMChatroomTokenProvider? get tokenProvider => _platform.tokenProvider;

  @HawkApi(ignore: true)
  set tokenProvider(V2NIMChatroomTokenProvider? tokenProvider) =>
      _platform.tokenProvider = tokenProvider;

  ///登录扩展信息
  @HawkApi(ignore: true)
  V2NIMChatroomLoginExtensionProvider? get extensionProvider =>
      _platform.extensionProvider;

  ///设置登录扩展信息
  @HawkApi(ignore: true)
  set extensionProvider(
          V2NIMChatroomLoginExtensionProvider? extensionProvider) =>
      _platform.extensionProvider = extensionProvider;

  ///链接地址提供者
  @HawkApi(ignore: true)
  V2NIMChatroomLinkProvider? get linkProvider => _platform.linkProvider;

  @HawkApi(ignore: true)
  set linkProvider(V2NIMChatroomLinkProvider? linkProvider) =>
      _platform.linkProvider = linkProvider;

  @HawkApi(ignore: true)
  List<StreamSubscription> _listeners = [];

  /// PC初始化
  static Future<NIMResult<void>> init(NIMSDKOptions options) {
    return _platform.init(options);
  }

  /// PC初始化
  static Future<NIMResult<void>> uninit() {
    return _platform.uninit();
  }

  /// 构造一个新的聊天室实例
  static Future<NIMResult<V2NIMChatroomClient?>> newInstance() async {
    final instance = await _platform.newInstance();
    if (instance.isSuccess && instance.data != null) {
      var client = V2NIMChatroomClient(instanceId: instance.data!);
      chatroomClientMap[client.instanceId] = client;
      return NIMResult.success(data: client);
    } else {
      return NIMResult.failure(
          code: instance.code, message: instance.errorDetails);
    }
  }

  /// 通过identityId（唯一标识）获取之前已经创建的V2NIMChatroomClient
  static Future<NIMResult<V2NIMChatroomClient?>> getInstance(
      int instanceId) async {
    if (chatroomClientMap.containsKey(instanceId)) {
      return NIMResult.success(
        data: chatroomClientMap[instanceId],
      );
    }
    final instance = await _platform.getInstance(instanceId);
    if (instance.isSuccess && instance.data != null) {
      var client = V2NIMChatroomClient(instanceId: instance.data!);
      chatroomClientMap[client.instanceId] = client;
      return NIMResult.success(data: client);
    } else {
      return NIMResult.failure(
          code: instance.code, message: instance.errorDetails);
    }
  }

  /// 获取当前已经存在的聊天室实例列表
  static Future<NIMResult<List<V2NIMChatroomClient>?>> getInstanceList() async {
    final instance = await _platform.getInstanceList();
    if (instance.isSuccess && instance.data != null) {
      final list = instance.data!
          .map((e) => V2NIMChatroomClient(instanceId: e))
          .toList();
      return NIMResult.success(data: list);
    } else {
      return NIMResult.failure(
          code: instance.code, message: instance.errorDetails);
    }
  }

  /// 获取V2NIMChatroomClient对象的identityId（唯一标识）
  int? getInstanceId() {
    return instanceId;
  }

  /// 进入聊天室
  Future<NIMResult<V2NIMChatroomEnterResult>> enter(
      String roomId, V2NIMChatroomEnterParams enterParams) {
    return _platform.enter(instanceId, roomId, enterParams);
  }

  /// 退出聊天室
  Future<NIMResult<void>> exit() {
    return _platform.exit(instanceId);
  }

  /// getChatroomInfo
  Future<NIMResult<V2NIMChatroomInfo>> getChatroomInfo() {
    return _platform.getChatroomInfo(instanceId);
  }

  /// 获取聊天室服务， 后续相关操作均在服务中实现
  V2NIMChatroomService getChatroomService() {
    if (_chatroomService == null) {
      _chatroomService = V2NIMChatroomService(instanceId);
    }
    return _chatroomService!;
  }

  /// 获取聊天室存储服务， 后续相关操作均在服务中实现
  StorageService getStorageService() {
    if (_storageService == null) {
      _storageService = StorageService(instanceId: instanceId);
    }
    return _storageService!;
  }

  /// 获取聊天室队列服务， 后续相关操作均在服务中实现
  V2NIMChatroomQueueService getChatroomQueueService() {
    if (_chatroomQueueService == null) {
      _chatroomQueueService = V2NIMChatroomQueueService(instanceId);
    }
    return _chatroomQueueService!;
  }

  /// 添加聊天室实例监听器
  Future<NIMResult<void>> addChatroomClientListener() {
    return _platform.addChatroomClientListener(instanceId).then((result) {
      _listeners.addAll([
        _platform.onChatroomEntered.listen((event) {
          if (event == instanceId) {
            _onChatroomEnteredController.add(null);
          }
        }),
        _platform.onChatroomExited.listen((event) {
          if (event.instanceId == instanceId) {
            _onChatroomExitedController.add(event.error);
          }
        }),
        _platform.onChatroomKicked.listen((event) {
          if (event.instanceId == instanceId && event.kickedInfo != null) {
            _onChatroomKickedController.add(event.kickedInfo!);
          }
        }),
        _platform.onChatroomStatus.listen((event) {
          if (event.instanceId == instanceId) {
            _onChatroomStatusController.add(event);
          }
        })
      ]);

      return result;
    });
  }

  /// 移除聊天室实例监听器
  Future<NIMResult<void>> removeChatroomClientListener() {
    return _platform.removeChatroomClientListener(instanceId).then((result) {
      _listeners.forEach((e) => e.cancel());
      return result;
    });
  }

  /// 销毁指定聊天室实例
  static Future<NIMResult<void>> destroyInstance(int instanceId) {
    return _platform.destroyInstance(instanceId).then((result) {
      if (result.isSuccess) {
        chatroomClientMap.remove(instanceId);
      }
      return result;
    });
  }

  /// 销毁当前的所有聊天室实例
  static Future<NIMResult<void>> destroyAll() {
    return _platform.destroyAll().then((result) {
      if (result.isSuccess) {
        chatroomClientMap.clear();
      }
      return result;
    });
  }
}
