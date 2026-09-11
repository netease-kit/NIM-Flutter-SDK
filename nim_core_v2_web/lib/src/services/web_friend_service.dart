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

/// Web 端好友服务实现
class WebFriendService extends FriendServicePlatform {
  JSObject? _jsService;
  final Map<String, JSFunction> _jsCallbacks = {};

  final _friendAddedController = StreamController<NIMFriend>.broadcast();
  final _friendDeletedController =
      StreamController<NIMFriendDeletion>.broadcast();
  final _friendInfoChangedController = StreamController<NIMFriend>.broadcast();
  final _friendAddApplicationController =
      StreamController<NIMFriendAddApplication>.broadcast();
  final _friendAddRejectedController =
      StreamController<NIMFriendAddApplication>.broadcast();

  WebFriendService() {
    WebInitializeService.registerOnInit(_onNimInit);
    WebInitializeService.registerOnRelease(_onNimRelease);
  }

  void _onNimInit(JSV2NIM nim) {
    // 先清除旧监听，防止 SDK 重初始化或 initialize() 多次调用时，
    // 旧的 JSFunction 仍挂在 JS 层导致事件回调翻倍
    _removeListeners();
    final svc = (nim as JSObject).getProperty('V2NIMFriendService'.toJS);
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
      'onFriendAdded',
      ((JSObject friend) {
        _friendAddedController.add(NIMFriend.fromJson(jsObjectToMap(friend)));
      }).toJS,
    );

    _on(
      'onFriendDeleted',
      ((JSString accountId, JSNumber deletionType) {
        _friendDeletedController.add(
          NIMFriendDeletion.fromJson({
            'accountId': accountId.toDart,
            'deletionType': deletionType.toDartInt,
          }),
        );
      }).toJS,
    );

    _on(
      'onFriendInfoChanged',
      ((JSObject friend) {
        _friendInfoChangedController.add(
          NIMFriend.fromJson(jsObjectToMap(friend)),
        );
      }).toJS,
    );

    _on(
      'onFriendAddApplication',
      ((JSObject application) {
        _friendAddApplicationController.add(
          NIMFriendAddApplication.fromJson(jsObjectToMap(application)),
        );
      }).toJS,
    );

    _on(
      'onFriendAddRejected',
      ((JSObject rejection) {
        _friendAddRejectedController.add(
          NIMFriendAddApplication.fromJson(jsObjectToMap(rejection)),
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
  String get serviceName => 'FriendService';
  @override
  Future<dynamic> onEvent(String method, dynamic arguments) async => null;

  @override
  Stream<NIMFriend> get onFriendAdded => _friendAddedController.stream;
  @override
  Stream<NIMFriendDeletion> get onFriendDeleted =>
      _friendDeletedController.stream;
  @override
  Stream<NIMFriend> get onFriendInfoChanged =>
      _friendInfoChangedController.stream;
  @override
  Stream<NIMFriendAddApplication> get onFriendAddApplication =>
      _friendAddApplicationController.stream;
  @override
  Stream<NIMFriendAddApplication> get onFriendAddRejected =>
      _friendAddRejectedController.stream;

  @override
  Future<NIMResult<void>> addFriend(
    String accountId,
    NIMFriendAddParams? params,
  ) async {
    try {
      await _callJSAsync('addFriend', [
        accountId.toJS,
        params != null ? dartMapToJsObject(params.toJson()) : null,
      ]);
      return NIMResult<void>.fromMap({'code': 0});
    } catch (e) {
      return convertJSErrorToNIMResult<void>(e);
    }
  }

  @override
  Future<NIMResult<void>> deleteFriend(
    String accountId,
    NIMFriendDeleteParams? params,
  ) async {
    try {
      await _callJSAsync('deleteFriend', [
        accountId.toJS,
        params != null ? dartMapToJsObject(params.toJson()) : null,
      ]);
      return NIMResult<void>.fromMap({'code': 0});
    } catch (e) {
      return convertJSErrorToNIMResult<void>(e);
    }
  }

  @override
  Future<NIMResult<void>> acceptAddApplication(
    NIMFriendAddApplication application,
  ) async {
    try {
      await _callJSAsync('acceptAddApplication', [
        dartMapToJsObject(application.toJson()),
      ]);
      return NIMResult<void>.fromMap({'code': 0});
    } catch (e) {
      return convertJSErrorToNIMResult<void>(e);
    }
  }

  @override
  Future<NIMResult<void>> rejectAddApplication(
    NIMFriendAddApplication application,
    String postscript,
  ) async {
    try {
      await _callJSAsync('rejectAddApplication', [
        dartMapToJsObject(application.toJson()),
        postscript.toJS,
      ]);
      return NIMResult<void>.fromMap({'code': 0});
    } catch (e) {
      return convertJSErrorToNIMResult<void>(e);
    }
  }

  @override
  Future<NIMResult<void>> setFriendInfo(
    String accountId,
    NIMFriendSetParams params,
  ) async {
    try {
      await _callJSAsync('setFriendInfo', [
        accountId.toJS,
        dartMapToJsObject(params.toJson()),
      ]);
      return NIMResult<void>.fromMap({'code': 0});
    } catch (e) {
      return convertJSErrorToNIMResult<void>(e);
    }
  }

  @override
  Future<NIMResult<List<NIMFriend>>> getFriendList() async {
    try {
      final result = await _callJSAsync('getFriendList', []);
      if (result != null && result.isA<JSArray>()) {
        final list = jsArrayToMapList(result as JSArray);
        return NIMResult<List<NIMFriend>>.fromMap(
          {
            'code': 0,
            'data': {'friendList': list},
          },
          convert: (d) => ((d as Map)['friendList'] as List)
              .map(
                (e) => NIMFriend.fromJson(
                  (e as Map).cast<String, dynamic>(),
                ),
              )
              .toList(),
        );
      }
      return NIMResult<List<NIMFriend>>.fromMap({
        'code': 0,
        'data': {'friendList': []},
      }, convert: (_) => <NIMFriend>[]);
    } catch (e) {
      return convertJSErrorToNIMResult<List<NIMFriend>>(e);
    }
  }

  @override
  Future<NIMResult<List<NIMFriend>>> getFriendByIds(
    List<String> accountIds,
  ) async {
    try {
      final result = await _callJSAsync('getFriendByIds', [
        accountIds.jsify() as JSAny,
      ]);
      if (result != null && result.isA<JSArray>()) {
        final list = jsArrayToMapList(result as JSArray);
        return NIMResult<List<NIMFriend>>.fromMap(
          {
            'code': 0,
            'data': {'friendList': list},
          },
          convert: (d) => ((d as Map)['friendList'] as List)
              .map(
                (e) => NIMFriend.fromJson(
                  (e as Map).cast<String, dynamic>(),
                ),
              )
              .toList(),
        );
      }
      return NIMResult<List<NIMFriend>>.fromMap({
        'code': 0,
        'data': {'friendList': []},
      }, convert: (_) => <NIMFriend>[]);
    } catch (e) {
      return convertJSErrorToNIMResult<List<NIMFriend>>(e);
    }
  }

  @override
  Future<NIMResult<Map<String, bool>>> checkFriend(
    List<String> accountIds,
  ) async {
    try {
      final result = await _callJSAsync('checkFriend', [
        accountIds.jsify() as JSAny,
      ]);
      if (result != null && result.isA<JSObject>()) {
        final map = jsObjectToMap(result as JSObject);
        final checkMap = map.map((k, v) => MapEntry(k, v == true));
        return NIMResult<Map<String, bool>>.fromMap({
          'code': 0,
          'data': checkMap,
        }, convert: (d) => (d as Map).cast<String, bool>());
      }
      return NIMResult<Map<String, bool>>.fromMap({
        'code': 0,
        'data': {},
      }, convert: (_) => <String, bool>{});
    } catch (e) {
      return convertJSErrorToNIMResult<Map<String, bool>>(e);
    }
  }

  @override
  Future<NIMResult<NIMFriendAddApplicationResult>> getAddApplicationList(
    NIMFriendAddApplicationQueryOption option,
  ) async {
    try {
      final result = await _callJSAsync('getAddApplicationList', [
        dartMapToJsObject(option.toJson()),
      ]);
      if (result != null && result.isA<JSObject>()) {
        return NIMResult<NIMFriendAddApplicationResult>.fromMap(
          {'code': 0, 'data': jsObjectToMap(result as JSObject)},
          convert: (d) => NIMFriendAddApplicationResult.fromJson(
            d as Map<String, dynamic>,
          ),
        );
      }
      return NIMResult<NIMFriendAddApplicationResult>.fromMap({
        'code': -1,
        'errorDetails': 'getAddApplicationList returned null',
      });
    } catch (e) {
      return convertJSErrorToNIMResult<NIMFriendAddApplicationResult>(e);
    }
  }

  @override
  Future<NIMResult<int>> getAddApplicationUnreadCount() async {
    try {
      final result = await _callJSAsync('getAddApplicationUnreadCount', []);
      final count = result != null && result.isA<JSNumber>()
          ? (result as JSNumber).toDartInt
          : 0;
      return NIMResult<int>(0, count, null);
    } catch (e) {
      return convertJSErrorToNIMResult<int>(e);
    }
  }

  @override
  Future<NIMResult<void>> setAddApplicationRead() async {
    try {
      await _callJSAsync('setAddApplicationRead', []);
      return NIMResult<void>.fromMap({'code': 0});
    } catch (e) {
      return convertJSErrorToNIMResult<void>(e);
    }
  }

  @override
  Future<NIMResult<void>> clearAllAddApplication() async {
    try {
      await _callJSAsync('clearAllAddApplication', []);
      return NIMResult<void>.fromMap({'code': 0});
    } catch (e) {
      return convertJSErrorToNIMResult<void>(e);
    }
  }

  @override
  Future<NIMResult<void>> clearAllAddApplicationEx(
    NIMFriendClearAddApplicationOption option,
  ) async {
    try {
      await _callJSAsync('clearAllAddApplicationEx', [
        dartMapToJsObject(option.toJson()),
      ]);
      return NIMResult<void>.fromMap({'code': 0});
    } catch (e) {
      return convertJSErrorToNIMResult<void>(e);
    }
  }

  @override
  Future<NIMResult<List<NIMFriend>>> searchFriendByOption(
    NIMFriendSearchOption friendSearchOption,
  ) async {
    try {
      final result = await _callJSAsync('searchFriendByOption', [
        dartMapToJsObject(friendSearchOption.toJson()),
      ]);
      if (result != null && result.isA<JSArray>()) {
        final list = jsArrayToMapList(result as JSArray);
        return NIMResult<List<NIMFriend>>.fromMap(
          {
            'code': 0,
            'data': {'friendList': list},
          },
          convert: (d) => ((d as Map)['friendList'] as List)
              .map(
                (e) => NIMFriend.fromJson(
                  (e as Map).cast<String, dynamic>(),
                ),
              )
              .toList(),
        );
      }
      return NIMResult<List<NIMFriend>>.fromMap({
        'code': 0,
        'data': {'friendList': []},
      }, convert: (_) => <NIMFriend>[]);
    } catch (e) {
      return convertJSErrorToNIMResult<List<NIMFriend>>(e);
    }
  }
}
