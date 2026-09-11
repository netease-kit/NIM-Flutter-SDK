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

/// Web 端订阅服务实现
class WebSubscriptionService extends SubscriptionServicePlatform {
  JSObject? _jsService;
  final Map<String, JSFunction> _jsCallbacks = {};

  final _userStatusChangedController =
      StreamController<List<NIMUserStatus>>.broadcast();

  WebSubscriptionService() {
    WebInitializeService.registerOnInit(_onNimInit);
    WebInitializeService.registerOnRelease(_onNimRelease);
  }

  void _onNimInit(JSV2NIM nim) {
    _removeListeners();
    final svc = (nim as JSObject).getProperty('V2NIMSubscriptionService'.toJS);
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
      'onUserStatusChanged',
      ((JSArray jsUsers) {
        try {
          final list = jsUsers.toDart
              .where((i) => i != null && i.isA<JSObject>())
              .map(
                (i) => NIMUserStatus.fromJson(
                  jsObjectToMap(i! as JSObject) as Map<String, dynamic>,
                ),
              )
              .toList();
          _userStatusChangedController.add(list);
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
  String get serviceName => 'SubscriptionService';
  @override
  Future<dynamic> onEvent(String method, dynamic arguments) async => null;

  @override
  Stream<List<NIMUserStatus>> get onUserStatusChanged =>
      _userStatusChangedController.stream;

  @override
  Future<NIMResult<List<String>>> subscribeUserStatus(
    NIMSubscribeUserStatusOption option,
  ) async {
    try {
      final jsOption = dartMapToJsObject(option.toJson());
      final result = await _callJSAsync('subscribeUserStatus', [jsOption]);
      final accountIds = <String>[];
      if (result != null && result.isA<JSArray>()) {
        for (final i in (result as JSArray).toDart) {
          if (i != null && i.isA<JSString>()) {
            accountIds.add((i as JSString).toDart);
          }
        }
      }
      return NIMResult<List<String>>.fromMap({
        'code': 0,
        'data': {'accountIds': accountIds},
      }, convert: (d) => accountIds);
    } catch (e) {
      return convertJSErrorToNIMResult<List<String>>(e);
    }
  }

  @override
  Future<NIMResult<List<String>>> unsubscribeUserStatus(
    NIMUnsubscribeUserStatusOption option,
  ) async {
    try {
      final jsOption = dartMapToJsObject(option.toJson());
      final result = await _callJSAsync('unsubscribeUserStatus', [jsOption]);
      final accountIds = <String>[];
      if (result != null && result.isA<JSArray>()) {
        for (final i in (result as JSArray).toDart) {
          if (i != null && i.isA<JSString>()) {
            accountIds.add((i as JSString).toDart);
          }
        }
      }
      return NIMResult<List<String>>.fromMap({
        'code': 0,
        'data': {'accountIds': accountIds},
      }, convert: (d) => accountIds);
    } catch (e) {
      return convertJSErrorToNIMResult<List<String>>(e);
    }
  }

  @override
  Future<NIMResult<NIMCustomUserStatusPublishResult>> publishCustomUserStatus(
    NIMCustomUserStatusParams params,
  ) async {
    try {
      final jsParams = dartMapToJsObject(params.toJson());
      final result = await _callJSAsync('publishCustomUserStatus', [jsParams]);
      if (result != null && result.isA<JSObject>()) {
        final map = jsObjectToMap(result as JSObject) as Map<String, dynamic>;
        return NIMResult<NIMCustomUserStatusPublishResult>.fromMap(
          {'code': 0, 'data': map},
          convert: (d) => NIMCustomUserStatusPublishResult.fromJson(
            d as Map<String, dynamic>,
          ),
        );
      }
      return NIMResult<NIMCustomUserStatusPublishResult>.fromMap({
        'code': -1,
        'errorDetails': 'publishCustomUserStatus returned null',
      });
    } catch (e) {
      return convertJSErrorToNIMResult<NIMCustomUserStatusPublishResult>(e);
    }
  }

  @override
  Future<NIMResult<List<NIMUserStatusSubscribeResult>>>
      queryUserStatusSubscriptions(List<String> accountIds) async {
    try {
      final jsAccountIds = accountIds.map((a) => a.toJS).toList().toJS;
      final result = await _callJSAsync('queryUserStatusSubscriptions', [
        jsAccountIds,
      ]);
      if (result != null && result.isA<JSArray>()) {
        final arr = (result as JSArray).toDart;
        final list = arr
            .where((i) => i != null && i.isA<JSObject>())
            .map(
              (i) => NIMUserStatusSubscribeResult.fromJson(
                jsObjectToMap(i! as JSObject) as Map<String, dynamic>,
              ),
            )
            .toList();
        return NIMResult<List<NIMUserStatusSubscribeResult>>.fromMap({
          'code': 0,
          'data': {'subscribeResultList': list.map((s) => s.toJson()).toList()},
        }, convert: (d) => list);
      }
      return NIMResult<List<NIMUserStatusSubscribeResult>>.fromMap({
        'code': 0,
        'data': {'subscribeResultList': []},
      }, convert: (_) => <NIMUserStatusSubscribeResult>[]);
    } catch (e) {
      return convertJSErrorToNIMResult<List<NIMUserStatusSubscribeResult>>(e);
    }
  }
}
