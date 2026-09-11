// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:nim_core_v2_platform_interface/nim_core_v2_platform_interface.dart';

import '../converters/enum_converter.dart';
import '../converters/error_converter.dart';
import '../converters/js_dart_converter.dart';
import '../js_interop/nim_sdk.dart';
import 'web_initialize_service.dart';

/// Web 端信令服务实现
class WebSignallingService extends SignallingServicePlatform {
  JSObject? _jsService;
  final Map<String, JSFunction> _jsCallbacks = {};

  final _onlineEventController =
      StreamController<NIMSignallingEvent>.broadcast();
  final _offlineEventController =
      StreamController<List<NIMSignallingEvent>>.broadcast();
  final _multiClientEventController =
      StreamController<NIMSignallingEvent>.broadcast();
  final _syncRoomInfoListController =
      StreamController<List<NIMSignallingRoomInfo>>.broadcast();

  WebSignallingService() {
    WebInitializeService.registerOnInit(_onNimInit);
    WebInitializeService.registerOnRelease(_onNimRelease);
  }

  void _onNimInit(JSV2NIM nim) {
    _removeListeners();
    final svc = (nim as JSObject).getProperty('V2NIMSignallingService'.toJS);
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
      'onOnlineEvent',
      ((JSObject jsEvent) {
        try {
          final map = jsObjectToMap(jsEvent) as Map<String, dynamic>;
          _onlineEventController.add(NIMSignallingEvent.fromJson(map));
        } catch (e) {
          // ignore
        }
      }).toJS,
    );

    _on(
      'onOfflineEvent',
      ((JSArray jsEvents) {
        try {
          final list = jsEvents.toDart
              .where((i) => i != null && i.isA<JSObject>())
              .map(
                (i) => NIMSignallingEvent.fromJson(
                  jsObjectToMap(i! as JSObject) as Map<String, dynamic>,
                ),
              )
              .toList();
          _offlineEventController.add(list);
        } catch (e) {
          // ignore
        }
      }).toJS,
    );

    _on(
      'onMultiClientEvent',
      ((JSObject jsEvent) {
        try {
          final map = jsObjectToMap(jsEvent) as Map<String, dynamic>;
          _multiClientEventController.add(NIMSignallingEvent.fromJson(map));
        } catch (e) {
          // ignore
        }
      }).toJS,
    );

    _on(
      'onSyncRoomInfoList',
      ((JSArray jsRoomList) {
        try {
          final list = jsRoomList.toDart
              .where((i) => i != null && i.isA<JSObject>())
              .map(
                (i) => NIMSignallingRoomInfo.fromJson(
                  jsObjectToMap(i! as JSObject) as Map<String, dynamic>,
                ),
              )
              .toList();
          _syncRoomInfoListController.add(list);
        } catch (e) {
          // ignore
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
  String get serviceName => 'SignallingService';
  @override
  Future<dynamic> onEvent(String method, dynamic arguments) async => null;

  @override
  Stream<NIMSignallingEvent> get onOnlineEvent => _onlineEventController.stream;

  @override
  Stream<List<NIMSignallingEvent>> get onOfflineEvent =>
      _offlineEventController.stream;

  @override
  Stream<NIMSignallingEvent> get onMultiClientEvent =>
      _multiClientEventController.stream;

  @override
  Stream<List<NIMSignallingRoomInfo>> get onSyncRoomInfoList =>
      _syncRoomInfoListController.stream;

  @override
  Future<NIMResult<NIMSignallingCallResult>> call(
    NIMSignallingCallParams params,
  ) async {
    try {
      final jsParams = dartMapToJsObject(params.toJson());
      final result = await _callJSAsync('call', [jsParams]);
      if (result != null && result.isA<JSObject>()) {
        final map = jsObjectToMap(result as JSObject) as Map<String, dynamic>;
        return NIMResult<NIMSignallingCallResult>.fromMap(
          {'code': 0, 'data': map},
          convert: (d) =>
              NIMSignallingCallResult.fromJson(d as Map<String, dynamic>),
        );
      }
      return NIMResult<NIMSignallingCallResult>.fromMap({
        'code': -1,
        'errorDetails': 'call returned null',
      });
    } catch (e) {
      return convertJSErrorToNIMResult<NIMSignallingCallResult>(e);
    }
  }

  @override
  Future<NIMResult<NIMSignallingCallSetupResult>> callSetup(
    NIMSignallingCallSetupParams params,
  ) async {
    try {
      final jsParams = dartMapToJsObject(params.toJson());
      final result = await _callJSAsync('callSetup', [jsParams]);
      if (result != null && result.isA<JSObject>()) {
        final map = jsObjectToMap(result as JSObject) as Map<String, dynamic>;
        return NIMResult<NIMSignallingCallSetupResult>.fromMap(
          {'code': 0, 'data': map},
          convert: (d) => NIMSignallingCallSetupResult.fromJson(
            d as Map<String, dynamic>,
          ),
        );
      }
      return NIMResult<NIMSignallingCallSetupResult>.fromMap({
        'code': -1,
        'errorDetails': 'callSetup returned null',
      });
    } catch (e) {
      return convertJSErrorToNIMResult<NIMSignallingCallSetupResult>(e);
    }
  }

  @override
  Future<NIMResult<NIMSignallingChannelInfo>> createRoom(
    NIMSignallingChannelType channelType,
    String? channelName,
    String? channelExtension,
  ) async {
    try {
      // channelName/channelExtension 是 Web SDK 位置型可选参数
      // channelName 为 null 则 channelExtension 也跳过
      final result = await _callJSAsync('createRoom', [
        nimSignallingChannelTypeToValue(channelType).toJS,
        if (channelName != null) channelName.toJS,
        if (channelName != null && channelExtension != null)
          channelExtension.toJS,
      ]);
      if (result != null && result.isA<JSObject>()) {
        final map = jsObjectToMap(result as JSObject) as Map<String, dynamic>;
        return NIMResult<NIMSignallingChannelInfo>.fromMap(
          {'code': 0, 'data': map},
          convert: (d) =>
              NIMSignallingChannelInfo.fromJson(d as Map<String, dynamic>),
        );
      }
      return NIMResult<NIMSignallingChannelInfo>.fromMap({
        'code': -1,
        'errorDetails': 'createRoom returned null',
      });
    } catch (e) {
      return convertJSErrorToNIMResult<NIMSignallingChannelInfo>(e);
    }
  }

  @override
  Future<NIMResult<void>> closeRoom(
    String channelId,
    bool? offlineEnabled,
    String? serverExtension,
  ) async {
    try {
      // offlineEnabled/serverExtension 是 Web SDK 位置型可选参数
      // offlineEnabled 为 null 则 serverExtension 也跳过
      await _callJSAsync('closeRoom', [
        channelId.toJS,
        if (offlineEnabled != null) offlineEnabled.toJS,
        if (offlineEnabled != null && serverExtension != null)
          serverExtension.toJS,
      ]);
      return NIMResult<void>.fromMap({'code': 0});
    } catch (e) {
      return convertJSErrorToNIMResult<void>(e);
    }
  }

  @override
  Future<NIMResult<V2NIMSignallingJoinResult>> joinRoom(
    NIMSignallingJoinParams params,
  ) async {
    try {
      final jsParams = dartMapToJsObject(params.toJson());
      final result = await _callJSAsync('joinRoom', [jsParams]);
      if (result != null && result.isA<JSObject>()) {
        final map = jsObjectToMap(result as JSObject) as Map<String, dynamic>;
        return NIMResult<V2NIMSignallingJoinResult>.fromMap(
          {'code': 0, 'data': map},
          convert: (d) =>
              V2NIMSignallingJoinResult.fromJson(d as Map<String, dynamic>),
        );
      }
      return NIMResult<V2NIMSignallingJoinResult>.fromMap({
        'code': -1,
        'errorDetails': 'joinRoom returned null',
      });
    } catch (e) {
      return convertJSErrorToNIMResult<V2NIMSignallingJoinResult>(e);
    }
  }

  @override
  Future<NIMResult<void>> leaveRoom(
    String channelId,
    bool? offlineEnabled,
    String? serverExtension,
  ) async {
    try {
      // offlineEnabled/serverExtension 是 Web SDK 位置型可选参数
      // offlineEnabled 为 null 则 serverExtension 也跳过
      await _callJSAsync('leaveRoom', [
        channelId.toJS,
        if (offlineEnabled != null) offlineEnabled.toJS,
        if (offlineEnabled != null && serverExtension != null)
          serverExtension.toJS,
      ]);
      return NIMResult<void>.fromMap({'code': 0});
    } catch (e) {
      return convertJSErrorToNIMResult<void>(e);
    }
  }

  @override
  Future<NIMResult<void>> invite(NIMSignallingInviteParams params) async {
    try {
      final jsParams = dartMapToJsObject(params.toJson());
      await _callJSAsync('invite', [jsParams]);
      return NIMResult<void>.fromMap({'code': 0});
    } catch (e) {
      return convertJSErrorToNIMResult<void>(e);
    }
  }

  @override
  Future<NIMResult<void>> cancelInvite(
    NIMSignallingCancelInviteParams params,
  ) async {
    try {
      final jsParams = dartMapToJsObject(params.toJson());
      await _callJSAsync('cancelInvite', [jsParams]);
      return NIMResult<void>.fromMap({'code': 0});
    } catch (e) {
      return convertJSErrorToNIMResult<void>(e);
    }
  }

  @override
  Future<NIMResult<void>> rejectInvite(
    NIMSignallingRejectInviteParams params,
  ) async {
    try {
      final jsParams = dartMapToJsObject(params.toJson());
      await _callJSAsync('rejectInvite', [jsParams]);
      return NIMResult<void>.fromMap({'code': 0});
    } catch (e) {
      return convertJSErrorToNIMResult<void>(e);
    }
  }

  @override
  Future<NIMResult<void>> acceptInvite(
    NIMSignallingAcceptInviteParams params,
  ) async {
    try {
      final jsParams = dartMapToJsObject(params.toJson());
      await _callJSAsync('acceptInvite', [jsParams]);
      return NIMResult<void>.fromMap({'code': 0});
    } catch (e) {
      return convertJSErrorToNIMResult<void>(e);
    }
  }

  @override
  Future<NIMResult<void>> sendControl(
    String channelId,
    String receiverAccountId,
    String? serverExtension,
  ) async {
    try {
      // serverExtension 是 Web SDK 可选参数，为 null 时必须省略，不能传 null
      final args = serverExtension != null
          ? [channelId.toJS, receiverAccountId.toJS, serverExtension.toJS]
          : [channelId.toJS, receiverAccountId.toJS];
      await _callJSAsync('sendControl', args);
      return NIMResult<void>.fromMap({'code': 0});
    } catch (e) {
      return convertJSErrorToNIMResult<void>(e);
    }
  }

  @override
  Future<NIMResult<NIMSignallingRoomInfo>> getRoomInfoByChannelName(
    String channelName,
  ) async {
    try {
      final result = await _callJSAsync('getRoomInfoByChannelName', [
        channelName.toJS,
      ]);
      if (result != null && result.isA<JSObject>()) {
        final map = jsObjectToMap(result as JSObject) as Map<String, dynamic>;
        return NIMResult<NIMSignallingRoomInfo>.fromMap(
          {'code': 0, 'data': map},
          convert: (d) =>
              NIMSignallingRoomInfo.fromJson(d as Map<String, dynamic>),
        );
      }
      return NIMResult<NIMSignallingRoomInfo>.fromMap({
        'code': -1,
        'errorDetails': 'getRoomInfoByChannelName returned null',
      });
    } catch (e) {
      return convertJSErrorToNIMResult<NIMSignallingRoomInfo>(e);
    }
  }
}
