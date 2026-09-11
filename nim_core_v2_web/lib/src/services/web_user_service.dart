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

/// Web 端用户服务实现
class WebUserService extends UserServicePlatform {
  JSObject? _jsService;
  final Map<String, JSFunction> _jsCallbacks = {};

  WebUserService() {
    WebInitializeService.registerOnInit(_onNimInit);
    WebInitializeService.registerOnRelease(_onNimRelease);
  }

  void _onNimInit(JSV2NIM nim) {
    _removeListeners();
    final svc = (nim as JSObject).getProperty('V2NIMUserService'.toJS);
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
      'onUserProfileChanged',
      ((JSArray users) {
        final list = jsArrayToMapList(users);
        onUserProfileChanged.add(
          list.map((m) => NIMUserInfo.fromJson(m)).toList(),
        );
      }).toJS,
    );

    _on(
      'onBlockListAdded',
      ((JSObject user) {
        onBlockListAdded.add(NIMUserInfo.fromJson(jsObjectToMap(user)));
      }).toJS,
    );

    _on(
      'onBlockListRemoved',
      ((JSString accountId) {
        onBlockListRemoved.add(accountId.toDart);
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
  String get serviceName => 'UserService';
  @override
  Future<dynamic> onEvent(String method, dynamic arguments) async => null;

  @override
  Future<NIMResult<List<NIMUserInfo>>> getUserList(List<String> userId) async {
    try {
      final result = await _callJSAsync('getUserList', [
        userId.map((s) => s.toJS).toList().toJS,
      ]);
      if (result != null && result.isA<JSArray>()) {
        final list = jsArrayToMapList(result as JSArray);
        return NIMResult<List<NIMUserInfo>>.fromMap(
          {
            'code': 0,
            'data': {'userInfoList': list},
          },
          convert: (d) => ((d as Map)['userInfoList'] as List)
              .map(
                (e) => NIMUserInfo.fromJson(
                  (e as Map).cast<String, dynamic>(),
                ),
              )
              .toList(),
        );
      }
      return NIMResult<List<NIMUserInfo>>.fromMap({
        'code': 0,
        'data': {'userInfoList': []},
      }, convert: (_) => <NIMUserInfo>[]);
    } catch (e) {
      return convertJSErrorToNIMResult<List<NIMUserInfo>>(e);
    }
  }

  @override
  Future<NIMResult<List<NIMUserInfo>>> getUserListFromCloud(
    List<String> userId,
  ) async {
    try {
      final result = await _callJSAsync('getUserListFromCloud', [
        userId.map((s) => s.toJS).toList().toJS,
      ]);
      if (result != null && result.isA<JSArray>()) {
        final list = jsArrayToMapList(result as JSArray);
        return NIMResult<List<NIMUserInfo>>.fromMap(
          {
            'code': 0,
            'data': {'userInfoList': list},
          },
          convert: (d) => ((d as Map)['userInfoList'] as List)
              .map(
                (e) => NIMUserInfo.fromJson(
                  (e as Map).cast<String, dynamic>(),
                ),
              )
              .toList(),
        );
      }
      return NIMResult<List<NIMUserInfo>>.fromMap({
        'code': 0,
        'data': {'userInfoList': []},
      }, convert: (_) => <NIMUserInfo>[]);
    } catch (e) {
      return convertJSErrorToNIMResult<List<NIMUserInfo>>(e);
    }
  }

  @override
  Future<NIMResult<void>> updateSelfUserProfile(
    NIMUserUpdateParam param,
  ) async {
    try {
      await _callJSAsync('updateSelfUserProfile', [
        dartMapToJsObject(param.toJson()),
      ]);
      return NIMResult<void>.fromMap({'code': 0});
    } catch (e) {
      return convertJSErrorToNIMResult<void>(e);
    }
  }

  @override
  Future<NIMResult<void>> addUserToBlockList(String userId) async {
    try {
      await _callJSAsync('addUserToBlockList', [userId.toJS]);
      return NIMResult<void>.fromMap({'code': 0});
    } catch (e) {
      return convertJSErrorToNIMResult<void>(e);
    }
  }

  @override
  Future<NIMResult<void>> removeUserFromBlockList(String userId) async {
    try {
      await _callJSAsync('removeUserFromBlockList', [userId.toJS]);
      return NIMResult<void>.fromMap({'code': 0});
    } catch (e) {
      return convertJSErrorToNIMResult<void>(e);
    }
  }

  @override
  Future<NIMResult<List<String>>> getBlockList() async {
    try {
      final result = await _callJSAsync('getBlockList', []);
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
          'data': {'userIdList': list},
        }, convert: (d) => ((d as Map)['userIdList'] as List).cast<String>());
      }
      return NIMResult<List<String>>.fromMap({
        'code': 0,
        'data': {'userIdList': []},
      }, convert: (_) => <String>[]);
    } catch (e) {
      return convertJSErrorToNIMResult<List<String>>(e);
    }
  }

  @override
  Future<NIMResult<List<NIMUserInfo>>> searchUserByOption(
    NIMUserSearchOption userSearchOption,
  ) async {
    try {
      final result = await _callJSAsync('searchUserByOption', [
        dartMapToJsObject(userSearchOption.toJson()),
      ]);
      if (result != null && result.isA<JSArray>()) {
        final list = jsArrayToMapList(result as JSArray);
        return NIMResult<List<NIMUserInfo>>.fromMap(
          {
            'code': 0,
            'data': {'userInfoList': list},
          },
          convert: (d) => ((d as Map)['userInfoList'] as List)
              .map(
                (e) => NIMUserInfo.fromJson(
                  (e as Map).cast<String, dynamic>(),
                ),
              )
              .toList(),
        );
      }
      return NIMResult<List<NIMUserInfo>>.fromMap({
        'code': 0,
        'data': {'userInfoList': []},
      }, convert: (_) => <NIMUserInfo>[]);
    } catch (e) {
      return convertJSErrorToNIMResult<List<NIMUserInfo>>(e);
    }
  }
}
