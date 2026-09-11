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

/// Web 端通知服务实现
class WebNotificationService extends NotificationServicePlatform {
  JSObject? _jsService;
  final Map<String, JSFunction> _jsCallbacks = {};

  final _customNotificationsController =
      StreamController<List<NIMCustomNotification>>.broadcast();
  final _broadcastNotificationsController =
      StreamController<List<NIMBroadcastNotification>>.broadcast();

  WebNotificationService() {
    WebInitializeService.registerOnInit(_onNimInit);
    WebInitializeService.registerOnRelease(_onNimRelease);
  }

  void _onNimInit(JSV2NIM nim) {
    _removeListeners();
    final svc = (nim as JSObject).getProperty('V2NIMNotificationService'.toJS);
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
      'onReceiveCustomNotifications',
      ((JSArray jsNotifications) {
        try {
          final list = jsNotifications.toDart
              .where((i) => i != null && i.isA<JSObject>())
              .map((i) {
            final map = jsObjectToMap(i! as JSObject) as Map<String, dynamic>;
            // forcePushAccountIds 可能是 String，需要解析为 List
            final pushConfig = map['pushConfig'];
            if (pushConfig is Map &&
                pushConfig['forcePushAccountIds'] is String) {
              try {
                pushConfig['forcePushAccountIds'] =
                    (pushConfig['forcePushAccountIds'] as String)
                        .split(',')
                        .where((s) => s.isNotEmpty)
                        .toList();
              } catch (_) {}
            }
            return NIMCustomNotification.fromJson(map);
          }).toList();
          _customNotificationsController.add(list);
        } catch (e) {
          // ignore parsing errors
        }
      }).toJS,
    );

    _on(
      'onReceiveBroadcastNotifications',
      ((JSArray jsNotifications) {
        try {
          final list = jsNotifications.toDart
              .where((i) => i != null && i.isA<JSObject>())
              .map(
                (i) => NIMBroadcastNotification.fromJson(
                  jsObjectToMap(i! as JSObject) as Map<String, dynamic>,
                ),
              )
              .toList();
          _broadcastNotificationsController.add(list);
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
  String get serviceName => 'NotificationService';
  @override
  Future<dynamic> onEvent(String method, dynamic arguments) async => null;

  @override
  Stream<List<NIMCustomNotification>> get onReceiveCustomNotifications =>
      _customNotificationsController.stream;

  @override
  Stream<List<NIMBroadcastNotification>> get onReceiveBroadcastNotifications =>
      _broadcastNotificationsController.stream;

  @override
  Future<NIMResult<void>> sendCustomNotification(
    String conversationId,
    String content,
    NIMSendCustomNotificationParams params,
  ) async {
    try {
      final jsParams = dartMapToJsObject(params.toJson());
      await _callJSAsync('sendCustomNotification', [
        conversationId.toJS,
        content.toJS,
        jsParams,
      ]);
      return NIMResult<void>.fromMap({'code': 0});
    } catch (e) {
      return convertJSErrorToNIMResult<void>(e);
    }
  }
}
