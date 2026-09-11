// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:nim_core_v2_platform_interface/nim_core_v2_platform_interface.dart';

import '../converters/error_converter.dart';
import '../converters/js_dart_converter.dart';
import '../js_interop/nim_sdk.dart';
import 'web_initialize_service.dart';

/// Web 端登录服务实现
class WebLoginService extends LoginServicePlatform {
  JSV2NIMLoginServiceJS? _jsService;

  // 事件 StreamController
  final _loginStatusController = StreamController<NIMLoginStatus>.broadcast();
  final _loginFailedController = StreamController<NIMError>.broadcast();
  final _kickedOfflineController =
      StreamController<NIMKickedOfflineDetail>.broadcast();
  final _loginClientChangedController =
      StreamController<NIMLoginClientChangeEvent>.broadcast();
  final _connectStatusController =
      StreamController<NIMConnectStatus>.broadcast();
  final _disconnectedController = StreamController<NIMError>.broadcast();
  final _connectFailedController = StreamController<NIMError>.broadcast();
  final _dataSyncController = StreamController<NIMDataSyncDetail>.broadcast();

  // 保存 JS callback 引用以便 off 注销
  JSFunction? _onLoginStatusJS;
  JSFunction? _onLoginFailedJS;
  JSFunction? _onKickedOfflineJS;
  JSFunction? _onLoginClientChangedJS;
  JSFunction? _onConnectStatusJS;
  JSFunction? _onDisconnectedJS;
  JSFunction? _onConnectFailedJS;
  JSFunction? _onDataSyncJS;

  WebLoginService() {
    WebInitializeService.registerOnInit(_onNimInit);
    WebInitializeService.registerOnRelease(_onNimRelease);
  }

  void _onNimInit(JSV2NIM nim) {
    _removeListeners();
    _jsService = nim.V2NIMLoginService;
    _setupListeners();
  }

  void _onNimRelease() {
    _removeListeners();
    _jsService = null;
  }

  void _setupListeners() {
    final service = _jsService;
    if (service == null) return;

    _onLoginStatusJS = ((JSNumber status) {
      final statusValue = status.toDartInt;
      _loginStatusController.add(
        NIMLoginStatusClass.fromJson({'status': statusValue}).status,
      );
    }).toJS;

    _onLoginFailedJS = ((JSObject error) {
      final map = jsObjectToMap(error);
      _loginFailedController.add(NIMError.fromJson(map));
    }).toJS;

    _onKickedOfflineJS = ((JSObject detail) {
      final map = jsObjectToMap(detail);
      _kickedOfflineController.add(NIMKickedOfflineDetail.fromJson(map));
    }).toJS;

    _onLoginClientChangedJS = ((JSNumber change, JSArray clients) {
      final changeValue = change.toDartInt;
      final clientList = jsArrayToMapList(clients);
      _loginClientChangedController.add(
        NIMLoginClientChangeEvent.fromJson({
          'change': changeValue,
          'clients': clientList,
        }),
      );
    }).toJS;

    _onConnectStatusJS = ((JSNumber status) {
      final statusValue = status.toDartInt;
      _connectStatusController.add(
        NIMConnectStatusClass.fromJson({'status': statusValue}).status,
      );
    }).toJS;

    _onDisconnectedJS = ((JSObject error) {
      final map = jsObjectToMap(error);
      _disconnectedController.add(NIMError.fromJson(map));
    }).toJS;

    _onConnectFailedJS = ((JSObject error) {
      final map = jsObjectToMap(error);
      _connectFailedController.add(NIMError.fromJson(map));
    }).toJS;

    _onDataSyncJS = ((JSNumber type, JSNumber state, [JSObject? error]) {
      _dataSyncController.add(
        NIMDataSyncDetail.fromJson({
          'type': type.toDartInt,
          'state': state.toDartInt,
        }),
      );
    }).toJS;

    service.on('onLoginStatus'.toJS, _onLoginStatusJS!);
    service.on('onLoginFailed'.toJS, _onLoginFailedJS!);
    service.on('onKickedOffline'.toJS, _onKickedOfflineJS!);
    service.on('onLoginClientChanged'.toJS, _onLoginClientChangedJS!);
    service.on('onConnectStatus'.toJS, _onConnectStatusJS!);
    service.on('onDisconnected'.toJS, _onDisconnectedJS!);
    service.on('onConnectFailed'.toJS, _onConnectFailedJS!);
    service.on('onDataSync'.toJS, _onDataSyncJS!);
  }

  void _removeListeners() {
    final service = _jsService;
    if (service == null) return;

    if (_onLoginStatusJS != null) {
      service.off('onLoginStatus'.toJS, _onLoginStatusJS!);
    }
    if (_onLoginFailedJS != null) {
      service.off('onLoginFailed'.toJS, _onLoginFailedJS!);
    }
    if (_onKickedOfflineJS != null) {
      service.off('onKickedOffline'.toJS, _onKickedOfflineJS!);
    }
    if (_onLoginClientChangedJS != null) {
      service.off('onLoginClientChanged'.toJS, _onLoginClientChangedJS!);
    }
    if (_onConnectStatusJS != null) {
      service.off('onConnectStatus'.toJS, _onConnectStatusJS!);
    }
    if (_onDisconnectedJS != null) {
      service.off('onDisconnected'.toJS, _onDisconnectedJS!);
    }
    if (_onConnectFailedJS != null) {
      service.off('onConnectFailed'.toJS, _onConnectFailedJS!);
    }
    if (_onDataSyncJS != null) {
      service.off('onDataSync'.toJS, _onDataSyncJS!);
    }
  }

  @override
  String get serviceName => 'LoginService';

  @override
  Future<dynamic> onEvent(String method, dynamic arguments) async {
    return null;
  }

  // Stream getters
  @override
  Stream<NIMLoginStatus> get onLoginStatus => _loginStatusController.stream;

  @override
  Stream<NIMError> get onLoginFailed => _loginFailedController.stream;

  @override
  Stream<NIMKickedOfflineDetail> get onKickedOffline =>
      _kickedOfflineController.stream;

  @override
  Stream<NIMLoginClientChangeEvent> get onLoginClientChanged =>
      _loginClientChangedController.stream;

  @override
  Stream<NIMConnectStatus> get onConnectStatus =>
      _connectStatusController.stream;

  @override
  Stream<NIMError> get onDisconnected => _disconnectedController.stream;

  @override
  Stream<NIMError> get onConnectFailed => _connectFailedController.stream;

  @override
  Stream<NIMDataSyncDetail> get onDataSync => _dataSyncController.stream;

  // API 方法实现

  @override
  Future<NIMResult<void>> login(
    String accountId,
    String token,
    NIMLoginOption option,
  ) async {
    final service = _jsService;
    if (service == null) {
      return NIMResult<void>.fromMap({
        'code': -1,
        'errorDetails': 'NIM SDK not initialized',
      });
    }

    try {
      // 构建 login option JS 对象
      final optionMap = option.toJson();
      // tokenProvider/extensionProvider 是 native method-channel 使用的
      // bool 标记；Web SDK 这里要求 provider 字段必须是 function。
      optionMap.remove('tokenProvider');
      optionMap.remove('extensionProvider');

      // 注入 tokenProvider（如果设置了）
      if (tokenProvider != null) {
        optionMap['tokenProvider'] = ((JSString jsAccountId) {
          return tokenProvider!(jsAccountId.toDart).then((token) {
            return token.toJS;
          }).toJS;
        }).toJS;
      }

      // 注入 loginExtensionProvider（如果设置了）
      if (loginExtensionProvider != null) {
        optionMap['loginExtensionProvider'] = ((JSString jsAccountId) {
          return loginExtensionProvider!(jsAccountId.toDart).then((ext) {
            return (ext ?? '').toJS;
          }).toJS;
        }).toJS;
      }

      final jsOption = dartMapToJsObject(optionMap);

      // 调用 JS SDK login
      final loginMethod = service.getProperty('login'.toJS) as JSFunction;
      final result = loginMethod.callAsFunction(
        service,
        accountId.toJS,
        token.toJS,
        jsOption,
      );

      if (result != null && result.isA<JSPromise>()) {
        await (result as JSPromise).toDart;
      }

      return NIMResult<void>.fromMap({'code': 0});
    } catch (e) {
      return convertJSErrorToNIMResult<void>(e);
    }
  }

  @override
  Future<NIMResult<void>> logout() async {
    final service = _jsService;
    if (service == null) {
      return NIMResult<void>.fromMap({'code': 0});
    }

    try {
      final logoutMethod = service.getProperty('logout'.toJS) as JSFunction;
      final result = logoutMethod.callAsFunction(service);
      if (result != null && result.isA<JSPromise>()) {
        await (result as JSPromise).toDart;
      }
      return NIMResult<void>.fromMap({'code': 0});
    } catch (e) {
      return convertJSErrorToNIMResult<void>(e);
    }
  }

  @override
  Future<NIMResult<String?>> getLoginUser() async {
    final service = _jsService;
    if (service == null) {
      return NIMResult<String?>.fromMap({'code': 0, 'data': null});
    }

    try {
      final method = service.getProperty('getLoginUser'.toJS) as JSFunction;
      final result = method.callAsFunction(service);
      final user = result != null && result.isA<JSString>()
          ? (result as JSString).toDart
          : null;
      return NIMResult<String?>(0, user, null);
    } catch (e) {
      return convertJSErrorToNIMResult<String?>(e);
    }
  }

  @override
  Future<NIMResult<NIMLoginStatus>> getLoginStatus() async {
    final service = _jsService;
    if (service == null) {
      return NIMResult<NIMLoginStatus>.fromMap(
        {
          'code': 0,
          'data': {'status': 0},
        },
        convert: (map) {
          return NIMLoginStatusClass.fromJson(
            map as Map<String, dynamic>,
          ).status;
        },
      );
    }

    try {
      final method = service.getProperty('getLoginStatus'.toJS) as JSFunction;
      final result = method.callAsFunction(service);
      final status = result != null && result.isA<JSNumber>()
          ? (result as JSNumber).toDartInt
          : 0;
      return NIMResult<NIMLoginStatus>.fromMap(
        {
          'code': 0,
          'data': {'status': status},
        },
        convert: (map) {
          return NIMLoginStatusClass.fromJson(
            map as Map<String, dynamic>,
          ).status;
        },
      );
    } catch (e) {
      return convertJSErrorToNIMResult<NIMLoginStatus>(e);
    }
  }

  @override
  Future<NIMResult<List<NIMLoginClient>>> getLoginClients() async {
    final service = _jsService;
    if (service == null) {
      return NIMResult<List<NIMLoginClient>>.fromMap({
        'code': 0,
        'data': {'loginClient': []},
      }, convert: (map) => <NIMLoginClient>[]);
    }

    try {
      final method = service.getProperty('getLoginClients'.toJS) as JSFunction;
      final result = method.callAsFunction(service);
      if (result != null && result.isA<JSArray>()) {
        final mapList = jsArrayToMapList(result as JSArray);
        final clients = mapList.map((m) => NIMLoginClient.fromJson(m)).toList();
        return NIMResult<List<NIMLoginClient>>.fromMap(
          {
            'code': 0,
            'data': {'loginClient': clients.map((c) => c.toJson()).toList()},
          },
          convert: (map) {
            final list = (map as Map<String, dynamic>)['loginClient'] as List;
            return list
                .map(
                  (e) => NIMLoginClient.fromJson(
                    (e as Map).cast<String, dynamic>(),
                  ),
                )
                .toList();
          },
        );
      }
      return NIMResult<List<NIMLoginClient>>.fromMap({
        'code': 0,
        'data': {'loginClient': []},
      }, convert: (map) => <NIMLoginClient>[]);
    } catch (e) {
      return convertJSErrorToNIMResult<List<NIMLoginClient>>(e);
    }
  }

  @override
  Future<NIMResult<NIMLoginClient>> getCurrentLoginClient() async {
    // Web SDK 不直接支持此方法，返回未实现错误
    throw UnimplementedError('getCurrentLoginClient() is not supported on Web');
  }

  @override
  Future<NIMResult<void>> kickOffline(NIMLoginClient client) async {
    final service = _jsService;
    if (service == null) {
      return NIMResult<void>.fromMap({
        'code': -1,
        'errorDetails': 'NIM SDK not initialized',
      });
    }

    try {
      final jsClient = dartMapToJsObject(client.toJson());
      final method = service.getProperty('kickOffline'.toJS) as JSFunction;
      final result = method.callAsFunction(service, jsClient);
      if (result != null && result.isA<JSPromise>()) {
        await (result as JSPromise).toDart;
      }
      return NIMResult<void>.fromMap({'code': 0});
    } catch (e) {
      return convertJSErrorToNIMResult<void>(e);
    }
  }

  @override
  Future<NIMResult<NIMKickedOfflineDetail?>> getKickedOfflineDetail() async {
    final service = _jsService;
    if (service == null) {
      return NIMResult<NIMKickedOfflineDetail?>.fromMap({
        'code': 0,
        'data': null,
      });
    }

    try {
      final method =
          service.getProperty('getKickedOfflineDetail'.toJS) as JSFunction;
      final result = method.callAsFunction(service);
      if (result != null && result.isA<JSObject>()) {
        final map = jsObjectToMap(result as JSObject);
        final detail = NIMKickedOfflineDetail.fromJson(map);
        return NIMResult<NIMKickedOfflineDetail?>.fromMap(
          {'code': 0, 'data': detail.toJson()},
          convert: (map) {
            return NIMKickedOfflineDetail.fromJson(map as Map<String, dynamic>);
          },
        );
      }
      return NIMResult<NIMKickedOfflineDetail?>.fromMap({
        'code': 0,
        'data': null,
      });
    } catch (e) {
      return convertJSErrorToNIMResult<NIMKickedOfflineDetail?>(e);
    }
  }

  @override
  Future<NIMResult<NIMConnectStatus>> getConnectStatus() async {
    final service = _jsService;
    if (service == null) {
      return NIMResult<NIMConnectStatus>.fromMap(
        {
          'code': 0,
          'data': {'status': 0},
        },
        convert: (map) {
          return NIMConnectStatusClass.fromJson(
            map as Map<String, dynamic>,
          ).status;
        },
      );
    }

    try {
      final method = service.getProperty('getConnectStatus'.toJS) as JSFunction;
      final result = method.callAsFunction(service);
      final status = result != null && result.isA<JSNumber>()
          ? (result as JSNumber).toDartInt
          : 0;
      return NIMResult<NIMConnectStatus>.fromMap(
        {
          'code': 0,
          'data': {'status': status},
        },
        convert: (map) {
          return NIMConnectStatusClass.fromJson(
            map as Map<String, dynamic>,
          ).status;
        },
      );
    } catch (e) {
      return convertJSErrorToNIMResult<NIMConnectStatus>(e);
    }
  }

  @override
  Future<NIMResult<List<NIMDataSyncDetail>>> getDataSync() async {
    final service = _jsService;
    if (service == null) {
      return NIMResult<List<NIMDataSyncDetail>>.fromMap({
        'code': 0,
        'data': {'dataSync': []},
      }, convert: (map) => <NIMDataSyncDetail>[]);
    }

    try {
      final method = service.getProperty('getDataSync'.toJS) as JSFunction;
      final result = method.callAsFunction(service);
      if (result != null && result.isA<JSArray>()) {
        final mapList = jsArrayToMapList(result as JSArray);
        final syncDetails =
            mapList.map((m) => NIMDataSyncDetail.fromJson(m)).toList();
        return NIMResult<List<NIMDataSyncDetail>>.fromMap(
          {
            'code': 0,
            'data': {'dataSync': syncDetails.map((d) => d.toJson()).toList()},
          },
          convert: (map) {
            final list = (map as Map<String, dynamic>)['dataSync'] as List;
            return list
                .map(
                  (e) => NIMDataSyncDetail.fromJson(
                    (e as Map).cast<String, dynamic>(),
                  ),
                )
                .toList();
          },
        );
      }
      return NIMResult<List<NIMDataSyncDetail>>.fromMap({
        'code': 0,
        'data': {'dataSync': []},
      }, convert: (map) => <NIMDataSyncDetail>[]);
    } catch (e) {
      return convertJSErrorToNIMResult<List<NIMDataSyncDetail>>(e);
    }
  }

  @override
  Future<NIMResult<List<String>?>> getChatroomLinkAddress(String roomId) async {
    final service = _jsService;
    if (service == null) {
      return NIMResult<List<String>?>.fromMap({
        'code': -1,
        'errorDetails': 'NIM SDK not initialized',
      });
    }

    try {
      final method =
          service.getProperty('getChatroomLinkAddress'.toJS) as JSFunction;
      final result = method.callAsFunction(service, roomId.toJS, false.toJS);
      if (result != null && result.isA<JSPromise>()) {
        final jsResult = await (result as JSPromise).toDart;
        if (jsResult != null && jsResult.isA<JSArray>()) {
          final dartList = (jsResult as JSArray).toDart;
          final addresses = dartList
              .map(
                (item) => item != null && item.isA<JSString>()
                    ? (item as JSString).toDart
                    : '',
              )
              .toList();
          return NIMResult<List<String>?>.fromMap(
            {
              'code': 0,
              'data': {'linkAddress': addresses},
            },
            convert: (map) {
              return ((map as Map<String, dynamic>)['linkAddress'] as List)
                  .cast<String>();
            },
          );
        }
      }
      return NIMResult<List<String>?>.fromMap({'code': 0, 'data': null});
    } catch (e) {
      return convertJSErrorToNIMResult<List<String>?>(e);
    }
  }

  @override
  Future<NIMResult<void>> setReconnectDelayProvider(
    NIMReconnectDelayProvider? provider,
  ) async {
    reconnectDelayProvider = provider;

    final service = _jsService;
    if (service == null || provider == null) {
      return NIMResult<void>.fromMap({'code': 0});
    }

    try {
      final jsProvider = ((JSNumber delay) {
        return provider(delay.toDartInt).then((result) {
          return result.toJS;
        }).toJS;
      }).toJS;

      final method =
          service.getProperty('setReconnectDelayProvider'.toJS) as JSFunction;
      method.callAsFunction(service, jsProvider);
      return NIMResult<void>.fromMap({'code': 0});
    } catch (e) {
      return convertJSErrorToNIMResult<void>(e);
    }
  }
}
