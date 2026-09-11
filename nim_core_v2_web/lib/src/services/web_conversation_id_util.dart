// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:nim_core_v2_platform_interface/nim_core_v2_platform_interface.dart';

import '../converters/error_converter.dart';
import '../js_interop/nim_sdk.dart';
import 'web_initialize_service.dart';

/// Web 端会话 ID 工具实现
class WebConversationIdUtil extends ConversationIdUtilPlatform {
  JSObject? _jsUtil;

  WebConversationIdUtil() {
    WebInitializeService.registerOnInit(_onNimInit);
    WebInitializeService.registerOnRelease(_onNimRelease);
  }

  void _onNimInit(JSV2NIM nim) {
    final util = (nim as JSObject).getProperty('V2NIMConversationIdUtil'.toJS);
    if (util != null && util.isA<JSObject>()) {
      _jsUtil = util as JSObject;
    }
  }

  void _onNimRelease() {
    _jsUtil = null;
  }

  @override
  String get serviceName => 'ConversationIdUtil';
  @override
  Future<dynamic> onEvent(String method, dynamic arguments) async => null;

  @override
  Future<NIMResult<String>> p2pConversationId(String accountId) async {
    final u = _jsUtil;
    if (u == null)
      return NIMResult<String>.fromMap({
        'code': -1,
        'errorDetails': 'NIM SDK not initialized',
      });
    try {
      final method = u.getProperty('p2pConversationId'.toJS) as JSFunction;
      final result = method.callAsFunction(u, accountId.toJS);
      if (result != null && result.isA<JSString>()) {
        return NIMResult<String>(0, (result as JSString).toDart, null);
      }
      return NIMResult<String>.fromMap({
        'code': -1,
        'errorDetails': 'p2pConversationId returned null',
      });
    } catch (e) {
      return convertJSErrorToNIMResult<String>(e);
    }
  }

  @override
  Future<NIMResult<String>> teamConversationId(String teamId) async {
    final u = _jsUtil;
    if (u == null)
      return NIMResult<String>.fromMap({
        'code': -1,
        'errorDetails': 'NIM SDK not initialized',
      });
    try {
      final method = u.getProperty('teamConversationId'.toJS) as JSFunction;
      final result = method.callAsFunction(u, teamId.toJS);
      if (result != null && result.isA<JSString>()) {
        return NIMResult<String>(0, (result as JSString).toDart, null);
      }
      return NIMResult<String>.fromMap({
        'code': -1,
        'errorDetails': 'teamConversationId returned null',
      });
    } catch (e) {
      return convertJSErrorToNIMResult<String>(e);
    }
  }

  @override
  Future<NIMResult<String>> superTeamConversationId(String superTeamId) async {
    final u = _jsUtil;
    if (u == null)
      return NIMResult<String>.fromMap({
        'code': -1,
        'errorDetails': 'NIM SDK not initialized',
      });
    try {
      final method =
          u.getProperty('superTeamConversationId'.toJS) as JSFunction;
      final result = method.callAsFunction(u, superTeamId.toJS);
      if (result != null && result.isA<JSString>()) {
        return NIMResult<String>(0, (result as JSString).toDart, null);
      }
      return NIMResult<String>.fromMap({
        'code': -1,
        'errorDetails': 'superTeamConversationId returned null',
      });
    } catch (e) {
      return convertJSErrorToNIMResult<String>(e);
    }
  }

  @override
  Future<NIMResult<NIMConversationType>> conversationType(
    String conversationId,
  ) async {
    final u = _jsUtil;
    if (u == null)
      return NIMResult<NIMConversationType>.fromMap({
        'code': -1,
        'errorDetails': 'NIM SDK not initialized',
      });
    try {
      final method = u.getProperty('parseConversationType'.toJS) as JSFunction;
      final result = method.callAsFunction(u, conversationId.toJS);
      if (result != null && result.isA<JSNumber>()) {
        final typeInt = (result as JSNumber).toDartInt;
        final type = NIMConversationType.values[typeInt];
        return NIMResult<NIMConversationType>.fromMap({
          'code': 0,
          'data': {'conversationType': typeInt},
        }, convert: (d) => type);
      }
      return NIMResult<NIMConversationType>.fromMap({
        'code': -1,
        'errorDetails': 'parseConversationType returned null',
      });
    } catch (e) {
      return convertJSErrorToNIMResult<NIMConversationType>(e);
    }
  }

  @override
  Future<NIMResult<String>> conversationTargetId(String conversationId) async {
    final u = _jsUtil;
    if (u == null)
      return NIMResult<String>.fromMap({
        'code': -1,
        'errorDetails': 'NIM SDK not initialized',
      });
    try {
      final method =
          u.getProperty('parseConversationTargetId'.toJS) as JSFunction;
      final result = method.callAsFunction(u, conversationId.toJS);
      if (result != null && result.isA<JSString>()) {
        return NIMResult<String>(0, (result as JSString).toDart, null);
      }
      return NIMResult<String>.fromMap({
        'code': -1,
        'errorDetails': 'parseConversationTargetId returned null',
      });
    } catch (e) {
      return convertJSErrorToNIMResult<String>(e);
    }
  }
}
