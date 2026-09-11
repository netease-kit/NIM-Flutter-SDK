// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:nim_core_v2_platform_interface/nim_core_v2_platform_interface.dart';

import '../converters/error_converter.dart';
import '../js_interop/nim_sdk.dart';
import 'web_initialize_service.dart';

/// Web 端设置服务实现
class WebSettingsService extends SettingsServicePlatform {
  JSObject? _jsService;
  final Map<String, JSFunction> _jsCallbacks = {};

  WebSettingsService() {
    WebInitializeService.registerOnInit(_onNimInit);
    WebInitializeService.registerOnRelease(_onNimRelease);
  }

  void _onNimInit(JSV2NIM nim) {
    _removeListeners();
    final svc = (nim as JSObject).getProperty('V2NIMSettingService'.toJS);
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
      'onP2PMessageMuteModeChanged',
      ((JSString accountId, JSNumber muteMode) {
        onP2PMessageMuteModeChanged.add(
          P2PMuteModeChangedResult.fromJson({
            'accountId': accountId.toDart,
            'muteMode': muteMode.toDartInt,
          }),
        );
      }).toJS,
    );

    _on(
      'onTeamMessageMuteModeChanged',
      ((JSString teamId, JSNumber teamType, JSNumber muteMode) {
        onTeamMessageMuteModeChanged.add(
          TeamMuteModeChangedResult.fromJson({
            'teamId': teamId.toDart,
            'teamType': teamType.toDartInt,
            'muteMode': muteMode.toDartInt,
          }),
        );
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
  String get serviceName => 'SettingsService';
  @override
  Future<dynamic> onEvent(String method, dynamic arguments) async => null;

  @override
  Future<NIMResult<bool>> getConversationMuteStatus(
    String conversationId,
  ) async {
    final s = _jsService;
    if (s == null)
      return NIMResult<bool>.fromMap({
        'code': -1,
        'errorDetails': 'NIM SDK not initialized',
      });
    try {
      final method =
          s.getProperty('getConversationMuteStatus'.toJS) as JSFunction;
      final result = method.callAsFunction(s, conversationId.toJS);
      final muted = result != null && result.isA<JSBoolean>()
          ? (result as JSBoolean).toDart
          : false;
      return NIMResult<bool>(0, muted, null);
    } catch (e) {
      return convertJSErrorToNIMResult<bool>(e);
    }
  }

  @override
  Future<NIMResult<void>> setTeamMessageMuteMode(
    String teamId,
    NIMTeamType teamType,
    NIMTeamMessageMuteMode muteMode,
  ) async {
    try {
      await _callJSAsync('setTeamMessageMuteMode', [
        teamId.toJS,
        teamType.index.toJS,
        muteMode.index.toJS,
      ]);
      return NIMResult<void>.fromMap({'code': 0});
    } catch (e) {
      return convertJSErrorToNIMResult<void>(e);
    }
  }

  @override
  Future<NIMResult<NIMTeamMessageMuteMode?>> getTeamMessageMuteMode(
    String teamId,
    NIMTeamType teamType,
  ) async {
    final s = _jsService;
    if (s == null)
      return NIMResult<NIMTeamMessageMuteMode?>.fromMap({
        'code': -1,
        'errorDetails': 'NIM SDK not initialized',
      });
    try {
      final method = s.getProperty('getTeamMessageMuteMode'.toJS) as JSFunction;
      final result = method.callAsFunction(s, teamId.toJS, teamType.index.toJS);
      final modeInt = result != null && result.isA<JSNumber>()
          ? (result as JSNumber).toDartInt
          : 0;
      final mode = NIMTeamMessageMuteMode.values[modeInt];
      // NIMResult.fromMap 会将 data 字段强制转换为 Map，不适合传递枚举/int
      // 对于返回枚举值的接口，应直接使用 NIMResult.success 构造结果
      return NIMResult<NIMTeamMessageMuteMode?>.success(data: mode);
    } catch (e) {
      return convertJSErrorToNIMResult<NIMTeamMessageMuteMode?>(e);
    }
  }

  @override
  Future<NIMResult<void>> setP2PMessageMuteMode(
    String accountId,
    NIMP2PMessageMuteMode muteMode,
  ) async {
    try {
      await _callJSAsync('setP2PMessageMuteMode', [
        accountId.toJS,
        muteMode.index.toJS,
      ]);
      return NIMResult<void>.fromMap({'code': 0});
    } catch (e) {
      return convertJSErrorToNIMResult<void>(e);
    }
  }

  @override
  Future<NIMResult<NIMP2PMessageMuteMode>> getP2PMessageMuteMode(
    String accountId,
  ) async {
    final s = _jsService;
    if (s == null)
      return NIMResult<NIMP2PMessageMuteMode>.fromMap({
        'code': -1,
        'errorDetails': 'NIM SDK not initialized',
      });
    try {
      final method = s.getProperty('getP2PMessageMuteMode'.toJS) as JSFunction;
      final result = method.callAsFunction(s, accountId.toJS);
      final modeInt = result != null && result.isA<JSNumber>()
          ? (result as JSNumber).toDartInt
          : 0;
      final mode = NIMP2PMessageMuteMode.values[modeInt];
      // NIMResult.fromMap 会将 data 字段强制转换为 Map，不适合传递枚举/int
      // 对于返回枚举值的接口，应直接使用 NIMResult.success 构造结果
      return NIMResult<NIMP2PMessageMuteMode>.success(data: mode);
    } catch (e) {
      return convertJSErrorToNIMResult<NIMP2PMessageMuteMode>(e);
    }
  }

  @override
  Future<NIMResult<List<String>>> getP2PMessageMuteList() async {
    try {
      final result = await _callJSAsync('getP2PMessageMuteList', []);
      if (result != null && result.isA<JSArray>()) {
        final list = (result as JSArray)
            .toDart
            .map(
              (i) =>
                  i != null && i.isA<JSString>() ? (i as JSString).toDart : '',
            )
            .where((s) => s.isNotEmpty)
            .toList();
        return NIMResult<List<String>>.fromMap({
          'code': 0,
          'data': {'muteList': list},
        }, convert: (d) => ((d as Map)['muteList'] as List).cast<String>());
      }
      return NIMResult<List<String>>.fromMap({
        'code': 0,
        'data': {'muteList': []},
      }, convert: (_) => <String>[]);
    } catch (e) {
      return convertJSErrorToNIMResult<List<String>>(e);
    }
  }

  @override
  Future<NIMResult<void>> setAppBackground(bool isBackground, int badge) async {
    try {
      await _callJSAsync('setAppBackground', [isBackground.toJS, badge.toJS]);
      return NIMResult<void>.fromMap({'code': 0});
    } catch (e) {
      return convertJSErrorToNIMResult<void>(e);
    }
  }

  @override
  Future<NIMResult<void>> setPushMobileOnDesktopOnline(bool need) async {
    try {
      await _callJSAsync('setPushMobileOnDesktopOnline', [need.toJS]);
      return NIMResult<void>.fromMap({'code': 0});
    } catch (e) {
      return convertJSErrorToNIMResult<void>(e);
    }
  }

  @override
  Future<NIMResult<void>> setDndConfig(NIMDndConfig config) async {
    return NIMResult<void>.fromMap({
      'code': -1,
      'errorDetails': 'setDndConfig is not supported on Web',
    });
  }

  @override
  Future<NIMResult<NIMDndConfig>> getDndConfig() async {
    return NIMResult<NIMDndConfig>.fromMap({
      'code': -1,
      'errorDetails': 'getDndConfig is not supported on Web',
    });
  }
}
