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

/// Web 端 AI 服务实现
class WebAIService extends AIServicePlatform {
  JSObject? _jsService;
  final Map<String, JSFunction> _jsCallbacks = {};

  final _proxyAIModelCallController =
      StreamController<NIMAIModelCallResult>.broadcast();
  final _proxyAIModelStreamCallController =
      StreamController<NIMAIModelStreamCallResult>.broadcast();

  WebAIService() {
    WebInitializeService.registerOnInit(_onNimInit);
    WebInitializeService.registerOnRelease(_onNimRelease);
  }

  void _onNimInit(JSV2NIM nim) {
    _removeListeners();
    final svc = (nim as JSObject).getProperty('V2NIMAIService'.toJS);
    if (svc != null && svc.isA<JSObject>()) {
      _jsService = svc as JSObject;
      _setupListeners();
    }
  }

  void _onNimRelease() {
    _removeListeners();
    _jsService = null;
  }

  void _on(String event, JSFunction cb) {
    final s = _jsService;
    if (s == null) return;
    _jsCallbacks[event] = cb;
    (s.getProperty('on'.toJS) as JSFunction).callAsFunction(s, event.toJS, cb);
  }

  void _setupListeners() {
    _on(
      'onProxyAIModelCall',
      ((JSObject jsData) {
        try {
          final map = jsObjectToMap(jsData) as Map<String, dynamic>;
          _proxyAIModelCallController.add(NIMAIModelCallResult.fromJson(map));
        } catch (e) {
          // ignore parsing errors
        }
      }).toJS,
    );

    // Web SDK 可能不支持流式回调，但仍注册以保持接口一致
    _on(
      'onProxyAIModelStreamCall',
      ((JSObject jsData) {
        try {
          final map = jsObjectToMap(jsData) as Map<String, dynamic>;
          _proxyAIModelStreamCallController.add(
            NIMAIModelStreamCallResult.fromJson(map),
          );
        } catch (e) {
          // ignore parsing errors
        }
      }).toJS,
    );
  }

  void _removeListeners() {
    final s = _jsService;
    if (s == null) return;
    final off = s.getProperty('off'.toJS) as JSFunction;
    _jsCallbacks.forEach((e, cb) {
      off.callAsFunction(s, e.toJS, cb);
    });
    _jsCallbacks.clear();
  }

  Future<JSAny?> _callJSAsync(String m, List<JSAny?> args) async {
    final s = _jsService;
    if (s == null) throw Exception('NIM SDK not initialized');
    final method = s.getProperty(m.toJS) as JSFunction;
    final apply = method.getProperty('apply'.toJS) as JSFunction;
    final r = apply.callAsFunction(method, s, args.toJS);
    if (r != null && r.isA<JSPromise>()) return await (r as JSPromise).toDart;
    return r;
  }

  @override
  String get serviceName => 'AIService';
  @override
  Future<dynamic> onEvent(String method, dynamic arguments) async => null;

  @override
  Stream<NIMAIModelCallResult> get onProxyAIModelCall =>
      _proxyAIModelCallController.stream;

  @override
  Stream<NIMAIModelStreamCallResult> get onProxyAIModelStreamCall =>
      _proxyAIModelStreamCallController.stream;

  @override
  Future<NIMResult<List<NIMAIUser>>> getAIUserList() async {
    try {
      final result = await _callJSAsync('getAIUserList', []);
      if (result != null && result.isA<JSArray>()) {
        final arr = (result as JSArray).toDart;
        final list = arr
            .where((i) => i != null && i.isA<JSObject>())
            .map(
              (i) => NIMAIUser.fromJson(
                jsObjectToMap(i! as JSObject) as Map<String, dynamic>,
              ),
            )
            .toList();
        return NIMResult<List<NIMAIUser>>.fromMap({
          'code': 0,
          'data': {'userList': list.map((u) => u.toJson()).toList()},
        }, convert: (d) => list);
      }
      return NIMResult<List<NIMAIUser>>.fromMap({
        'code': 0,
        'data': {'userList': []},
      }, convert: (_) => <NIMAIUser>[]);
    } catch (e) {
      return convertJSErrorToNIMResult<List<NIMAIUser>>(e);
    }
  }

  @override
  Future<NIMResult<void>> proxyAIModelCall(
    NIMProxyAIModelCallParams params,
  ) async {
    try {
      final paramsMap = params.toJson();
      // 将 messages 中的 role 转为 JS SDK 识别的格式
      final jsParams = dartMapToJsObject(paramsMap);
      await _callJSAsync('proxyAIModelCall', [jsParams]);
      return NIMResult<void>.fromMap({'code': 0});
    } catch (e) {
      return convertJSErrorToNIMResult<void>(e);
    }
  }

  @override
  Future<NIMResult<void>> stopAIModelStreamCall(
    NIMAIModelStreamCallStopParams params,
  ) async {
    try {
      final jsParams = dartMapToJsObject(params.toJson());
      await _callJSAsync('stopAIModelStreamCall', [jsParams]);
      return NIMResult<void>.fromMap({'code': 0});
    } catch (e) {
      return convertJSErrorToNIMResult<void>(e);
    }
  }

  @override
  Future<NIMResult<V2NIMCreateUserAIBotResult>> createUserAIBot(
    V2NIMCreateUserAIBotParams params,
  ) async {
    try {
      final result = await _callJSAsync(
        'createUserAIBot',
        [dartMapToJsObject(params.toJson())],
      );
      return _resultFromJSObject(
        result,
        (json) => V2NIMCreateUserAIBotResult.fromJson(json),
        'createUserAIBot',
      );
    } catch (e) {
      return convertJSErrorToNIMResult<V2NIMCreateUserAIBotResult>(e);
    }
  }

  @override
  Future<NIMResult<void>> deleteUserAIBot(
    V2NIMDeleteUserAIBotParams params,
  ) {
    return wrapJSPromiseVoid(() async {
      await _callJSAsync(
        'deleteUserAIBot',
        [dartMapToJsObject(params.toJson())],
      );
    });
  }

  @override
  Future<NIMResult<void>> updateUserAIBot(
    V2NIMUpdateUserAIBotParams params,
  ) {
    return wrapJSPromiseVoid(() async {
      await _callJSAsync(
        'updateUserAIBot',
        [dartMapToJsObject(params.toJson())],
      );
    });
  }

  @override
  Future<NIMResult<V2NIMUserAIBot>> getUserAIBot(
    V2NIMGetUserAIBotParams params,
  ) async {
    try {
      final result = await _callJSAsync(
        'getUserAIBot',
        [dartMapToJsObject(params.toJson())],
      );
      return _resultFromJSObject(
        result,
        (json) => V2NIMUserAIBot.fromJson(json),
        'getUserAIBot',
      );
    } catch (e) {
      return convertJSErrorToNIMResult<V2NIMUserAIBot>(e);
    }
  }

  @override
  Future<NIMResult<V2NIMGetUserAIBotListResult>> getUserAIBotList(
    V2NIMGetUserAIBotListParams? params,
  ) async {
    try {
      final result = await _callJSAsync(
        'getUserAIBotList',
        [if (params != null) dartMapToJsObject(params.toJson()) else null],
      );
      return _resultFromJSObject(
        result,
        (json) => V2NIMGetUserAIBotListResult.fromJson(json),
        'getUserAIBotList',
      );
    } catch (e) {
      return convertJSErrorToNIMResult<V2NIMGetUserAIBotListResult>(e);
    }
  }

  @override
  Future<NIMResult<void>> bindUserAIBotToQrCode(
    V2NIMBindUserAIBotToQrCodeParams params,
  ) {
    return wrapJSPromiseVoid(() async {
      await _callJSAsync(
        'bindUserAIBotToQrCode',
        [dartMapToJsObject(params.toJson())],
      );
    });
  }

  @override
  Future<NIMResult<V2NIMRefreshUserAIBotTokenResult>> refreshUserAIBotToken(
    V2NIMRefreshUserAIBotTokenParams params,
  ) async {
    try {
      final result = await _callJSAsync(
        'refreshUserAIBotToken',
        [dartMapToJsObject(params.toJson())],
      );
      return _resultFromJSObject(
        result,
        (json) => V2NIMRefreshUserAIBotTokenResult.fromJson(json),
        'refreshUserAIBotToken',
      );
    } catch (e) {
      return convertJSErrorToNIMResult<V2NIMRefreshUserAIBotTokenResult>(e);
    }
  }

  NIMResult<T> _resultFromJSObject<T>(
    JSAny? result,
    T Function(Map<String, dynamic>) convert,
    String methodName,
  ) {
    if (result != null && result.isA<JSObject>()) {
      return NIMResult<T>.fromMap(
        {'code': 0, 'data': jsObjectToMap(result as JSObject)},
        convert: convert,
      );
    }
    return NIMResult<T>.fromMap({
      'code': -1,
      'errorDetails': '$methodName returned null',
    });
  }
}
