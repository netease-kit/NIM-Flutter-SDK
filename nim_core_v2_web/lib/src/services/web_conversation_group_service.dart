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

/// Web 端会话分组服务实现
/// 对应 NIM Web SDK V2NIMConversationGroupService
class WebConversationGroupService extends ConversationServiceGroupPlatform {
  JSObject? _jsService;

  // 事件 StreamController
  final _conversationGroupCreatedController =
      StreamController<V2NIMConversationGroup>.broadcast();
  final _conversationGroupDeletedController =
      StreamController<String>.broadcast();
  final _conversationGroupChangedController =
      StreamController<V2NIMConversationGroup>.broadcast();
  final _conversationsAddedToGroupController =
      StreamController<ConversationsAddedEvent>.broadcast();
  final _conversationsRemovedFromGroupController =
      StreamController<ConversationsRemovedEvent>.broadcast();

  // JS callback 引用
  JSFunction? _onConversationGroupCreatedJS;
  JSFunction? _onConversationGroupDeletedJS;
  JSFunction? _onConversationGroupChangedJS;
  JSFunction? _onConversationsAddedToGroupJS;
  JSFunction? _onConversationsRemovedFromGroupJS;

  WebConversationGroupService() {
    WebInitializeService.registerOnInit(_onNimInit);
    WebInitializeService.registerOnRelease(_onNimRelease);
  }

  void _onNimInit(JSV2NIM nim) {
    _removeListeners();
    final svc =
        (nim as JSObject).getProperty('V2NIMConversationGroupService'.toJS);
    if (svc != null && svc.isA<JSObject>()) {
      _jsService = svc as JSObject;
      _setupListeners();
    }
  }

  void _onNimRelease() {
    _removeListeners();
    _jsService = null;
  }

  void _setupListeners() {
    final service = _jsService;
    if (service == null) return;

    _onConversationGroupCreatedJS = ((JSObject group) {
      final map = jsObjectToMap(group);
      _conversationGroupCreatedController
          .add(V2NIMConversationGroup.fromJson(map));
    }).toJS;

    _onConversationGroupDeletedJS = ((JSString groupId) {
      _conversationGroupDeletedController.add(groupId.toDart);
    }).toJS;

    _onConversationGroupChangedJS = ((JSObject group) {
      final map = jsObjectToMap(group);
      _conversationGroupChangedController
          .add(V2NIMConversationGroup.fromJson(map));
    }).toJS;

    _onConversationsAddedToGroupJS =
        ((JSString groupId, JSArray conversations) {
      final convList = conversations.toDart
          .where((item) => item != null && item.isA<JSObject>())
          .map((item) {
        final m = jsObjectToMap(item! as JSObject);
        return NIMConversation.fromJson(m);
      }).toList();
      _conversationsAddedToGroupController.add(
        ConversationsAddedEvent(
          groupId: groupId.toDart,
          conversations: convList,
        ),
      );
    }).toJS;

    _onConversationsRemovedFromGroupJS =
        ((JSString groupId, JSArray conversationIds) {
      final ids = conversationIds.toDart
          .map(
            (item) => item != null && item.isA<JSString>()
                ? (item as JSString).toDart
                : '',
          )
          .where((s) => s.isNotEmpty)
          .toList();
      _conversationsRemovedFromGroupController.add(
        ConversationsRemovedEvent(
          groupId: groupId.toDart,
          conversationIds: ids,
        ),
      );
    }).toJS;

    final on_ = service.getProperty('on'.toJS) as JSFunction;
    on_.callAsFunction(
      service,
      'onConversationGroupCreated'.toJS,
      _onConversationGroupCreatedJS!,
    );
    on_.callAsFunction(
      service,
      'onConversationGroupDeleted'.toJS,
      _onConversationGroupDeletedJS!,
    );
    on_.callAsFunction(
      service,
      'onConversationGroupChanged'.toJS,
      _onConversationGroupChangedJS!,
    );
    on_.callAsFunction(
      service,
      'onConversationsAddedToGroup'.toJS,
      _onConversationsAddedToGroupJS!,
    );
    on_.callAsFunction(
      service,
      'onConversationsRemovedFromGroup'.toJS,
      _onConversationsRemovedFromGroupJS!,
    );
  }

  void _removeListeners() {
    final service = _jsService;
    if (service == null) return;

    final off_ = service.getProperty('off'.toJS) as JSFunction;
    if (_onConversationGroupCreatedJS != null) {
      off_.callAsFunction(
        service,
        'onConversationGroupCreated'.toJS,
        _onConversationGroupCreatedJS!,
      );
    }
    if (_onConversationGroupDeletedJS != null) {
      off_.callAsFunction(
        service,
        'onConversationGroupDeleted'.toJS,
        _onConversationGroupDeletedJS!,
      );
    }
    if (_onConversationGroupChangedJS != null) {
      off_.callAsFunction(
        service,
        'onConversationGroupChanged'.toJS,
        _onConversationGroupChangedJS!,
      );
    }
    if (_onConversationsAddedToGroupJS != null) {
      off_.callAsFunction(
        service,
        'onConversationsAddedToGroup'.toJS,
        _onConversationsAddedToGroupJS!,
      );
    }
    if (_onConversationsRemovedFromGroupJS != null) {
      off_.callAsFunction(
        service,
        'onConversationsRemovedFromGroup'.toJS,
        _onConversationsRemovedFromGroupJS!,
      );
    }
  }

  @override
  String get serviceName => 'V2NIMConversationGroupService';

  @override
  Future<dynamic> onEvent(String method, dynamic arguments) async => null;

  /// 调用 JS 服务方法并返回 Promise 结果
  Future<JSAny?> _callJSAsync(String methodName, List<JSAny?> args) async {
    return _callJSAsyncWithArgs(methodName, args.toJS);
  }

  Future<JSAny?> _callJSAsyncWithArgs(
    String methodName,
    JSArray<JSAny?> args,
  ) async {
    final service = _jsService;
    if (service == null) throw Exception('NIM SDK not initialized');

    final method = service.getProperty(methodName.toJS) as JSFunction;
    final applyMethod = method.getProperty('apply'.toJS) as JSFunction;
    final result = applyMethod.callAsFunction(method, service, args);
    if (result != null && result.isA<JSPromise>()) {
      return await (result as JSPromise).toDart;
    }
    return result;
  }

  // ====== Stream getters ======

  @override
  Stream<V2NIMConversationGroup> get onConversationGroupCreated =>
      _conversationGroupCreatedController.stream;

  @override
  Stream<String> get onConversationGroupDeleted =>
      _conversationGroupDeletedController.stream;

  @override
  Stream<V2NIMConversationGroup> get onConversationGroupChanged =>
      _conversationGroupChangedController.stream;

  @override
  Stream<ConversationsAddedEvent> get onConversationsAddedToGroup =>
      _conversationsAddedToGroupController.stream;

  @override
  Stream<ConversationsRemovedEvent> get onConversationsRemovedFromGroup =>
      _conversationsRemovedFromGroupController.stream;

  // ====== API 方法实现 ======

  @override
  Future<NIMResult<V2NIMConversationGroupResult>> createConversationGroup(
    String name,
    String? serverExtension,
    List<String> conversationIds,
  ) async {
    try {
      // Web SDK: createConversationGroup(name, serverExtension?, conversationIds?)
      // 位置参数，serverExtension 在 conversationIds 之前
      final args = JSArray<JSAny?>();
      args.setProperty('0'.toJS, name.toJS);
      if (serverExtension != null) {
        args.setProperty('1'.toJS, serverExtension.toJS);
      }
      if (conversationIds.isNotEmpty) {
        // 索引 1 未赋值时是 JS undefined，不能用 Dart null 占位。
        args.setProperty('2'.toJS, conversationIds.jsify() as JSAny);
      }
      final result =
          await _callJSAsyncWithArgs('createConversationGroup', args);
      if (result != null && result.isA<JSObject>()) {
        // V2NIMConversationGroupResult 内含 failedList: V2NIMConversationOperationResult[]
        // V2NIMError 继承自 JS 原生 Error，jsObjectToMap 会把它变成 NativeError 导致崩溃。
        // 必须用 getProperty 手动逐字段提取，绕过 dartify() 对 Error 对象的通用处理。
        final groupResult = _parseConversationGroupResult(result as JSObject);
        return NIMResult<V2NIMConversationGroupResult>(0, groupResult, null);
      }
      return NIMResult<V2NIMConversationGroupResult>.fromMap({
        'code': -1,
        'errorDetails': 'createConversationGroup returned null',
      });
    } catch (e) {
      return convertJSErrorToNIMResult<V2NIMConversationGroupResult>(e);
    }
  }

  @override
  Future<NIMResult<void>> deleteConversationGroup(String groupId) async {
    try {
      await _callJSAsync('deleteConversationGroup', [groupId.toJS]);
      return NIMResult<void>.fromMap({'code': 0});
    } catch (e) {
      return convertJSErrorToNIMResult<void>(e);
    }
  }

  @override
  Future<NIMResult<void>> updateConversationGroup(
    String groupId,
    String? name,
    String? serverExtension,
  ) async {
    try {
      // Web SDK: updateConversationGroup(groupId, name?, serverExtension?)
      final args = JSArray<JSAny?>();
      args.setProperty('0'.toJS, groupId.toJS);
      if (name != null) {
        args.setProperty('1'.toJS, name.toJS);
      }
      if (serverExtension != null) {
        // 索引 1 未赋值时是 JS undefined，不能用 Dart null 占位。
        args.setProperty('2'.toJS, serverExtension.toJS);
      }
      await _callJSAsyncWithArgs('updateConversationGroup', args);
      return NIMResult<void>.fromMap({'code': 0});
    } catch (e) {
      return convertJSErrorToNIMResult<void>(e);
    }
  }

  @override
  Future<NIMResult<List<V2NIMConversationOperationResult>>>
      addConversationsToGroup(
    String groupId,
    List<String> conversationIds,
  ) async {
    try {
      final jsIds = conversationIds.jsify();
      final result = await _callJSAsync('addConversationsToGroup', [
        groupId.toJS,
        jsIds as JSAny,
      ]);
      if (result != null && result.isA<JSArray>()) {
        final jsList = (result as JSArray).toDart;
        final results = jsList
            .where((item) => item != null && item.isA<JSObject>())
            .map((item) => _parseV2OperationResult(item! as JSObject))
            .toList();
        return NIMResult<List<V2NIMConversationOperationResult>>(
            0, results, null);
      }
      return NIMResult<List<V2NIMConversationOperationResult>>(0, [], null);
    } catch (e) {
      return convertJSErrorToNIMResult<List<V2NIMConversationOperationResult>>(
          e);
    }
  }

  @override
  Future<NIMResult<List<V2NIMConversationOperationResult>>>
      removeConversationsFromGroup(
    String groupId,
    List<String> conversationIds,
  ) async {
    try {
      final jsIds = conversationIds.jsify();
      final result = await _callJSAsync('removeConversationsFromGroup', [
        groupId.toJS,
        jsIds as JSAny,
      ]);
      if (result != null && result.isA<JSArray>()) {
        final jsList = (result as JSArray).toDart;
        final results = jsList
            .where((item) => item != null && item.isA<JSObject>())
            .map((item) => _parseV2OperationResult(item! as JSObject))
            .toList();
        return NIMResult<List<V2NIMConversationOperationResult>>(
            0, results, null);
      }
      return NIMResult<List<V2NIMConversationOperationResult>>(0, [], null);
    } catch (e) {
      return convertJSErrorToNIMResult<List<V2NIMConversationOperationResult>>(
          e);
    }
  }

  @override
  Future<NIMResult<V2NIMConversationGroup>> getConversationGroup(
    String groupId,
  ) async {
    try {
      final result = await _callJSAsync('getConversationGroup', [groupId.toJS]);
      if (result != null && result.isA<JSObject>()) {
        final map = jsObjectToMap(result as JSObject);
        return NIMResult<V2NIMConversationGroup>.fromMap(
          {'code': 0, 'data': map},
          convert: (data) =>
              V2NIMConversationGroup.fromJson(data as Map<String, dynamic>),
        );
      }
      return NIMResult<V2NIMConversationGroup>.fromMap({
        'code': -1,
        'errorDetails': 'getConversationGroup returned null',
      });
    } catch (e) {
      return convertJSErrorToNIMResult<V2NIMConversationGroup>(e);
    }
  }

  @override
  Future<NIMResult<List<V2NIMConversationGroup>>>
      getConversationGroupList() async {
    try {
      final result = await _callJSAsync('getConversationGroupList', []);
      if (result != null && result.isA<JSArray>()) {
        final jsList = (result as JSArray).toDart;
        final groups = jsList
            .where((item) => item != null && item.isA<JSObject>())
            .map((item) {
          final map = jsObjectToMap(item! as JSObject);
          return V2NIMConversationGroup.fromJson(map);
        }).toList();
        return NIMResult<List<V2NIMConversationGroup>>(0, groups, null);
      }
      return NIMResult<List<V2NIMConversationGroup>>(0, [], null);
    } catch (e) {
      return convertJSErrorToNIMResult<List<V2NIMConversationGroup>>(e);
    }
  }

  @override
  Future<NIMResult<List<V2NIMConversationGroup>>> getConversationGroupListByIds(
      List<String> groupIds) async {
    try {
      final jsIds = groupIds.jsify();
      final result =
          await _callJSAsync('getConversationGroupListByIds', [jsIds as JSAny]);
      if (result != null && result.isA<JSArray>()) {
        final jsList = (result as JSArray).toDart;
        final groups = jsList
            .where((item) => item != null && item.isA<JSObject>())
            .map((item) {
          final map = jsObjectToMap(item! as JSObject);
          return V2NIMConversationGroup.fromJson(map);
        }).toList();
        return NIMResult<List<V2NIMConversationGroup>>(0, groups, null);
      }
      return NIMResult<List<V2NIMConversationGroup>>(0, [], null);
    } catch (e) {
      return convertJSErrorToNIMResult<List<V2NIMConversationGroup>>(e);
    }
  }

  // ====== 内部辅助方法 ======

  /// 解析 V2NIMConversationGroupResult JS 对象
  ///
  /// 不能使用 jsObjectToMap 通用转换，因为内部的 failedList 包含
  /// V2NIMError（继承自 JS 原生 Error），dartify() 无法枚举其原型链属性，
  /// 会返回 NativeError 而非 Map，导致 fromJson 崩溃。
  /// 必须用 getProperty 逐字段手动提取。
  V2NIMConversationGroupResult _parseConversationGroupResult(
      JSObject jsResult) {
    // 提取 group 字段（V2NIMConversationGroup 无 V2NIMError，可安全使用 jsObjectToMap）
    V2NIMConversationGroup? group;
    final groupJs = jsResult.getProperty('group'.toJS);
    if (groupJs != null &&
        !groupJs.isUndefinedOrNull &&
        groupJs.isA<JSObject>()) {
      final groupMap = jsObjectToMap(groupJs as JSObject);
      group = V2NIMConversationGroup.fromJson(groupMap);
    }

    // 提取 failedList 字段（每项含 V2NIMError，必须手动解析）
    List<V2NIMConversationOperationResult> failedList = [];
    final failedJs = jsResult.getProperty('failedList'.toJS);
    if (failedJs != null &&
        !failedJs.isUndefinedOrNull &&
        failedJs.isA<JSArray>()) {
      final jsList = (failedJs as JSArray).toDart;
      failedList = jsList
          .where((item) => item != null && item.isA<JSObject>())
          .map((item) => _parseV2OperationResult(item! as JSObject))
          .toList();
    }

    return V2NIMConversationGroupResult(group: group, failedList: failedList);
  }

  /// 解析 V2NIMConversationOperationResult JS 对象
  /// V2NIMError 继承自原生 JS Error，需手动提取 code/desc
  V2NIMConversationOperationResult _parseV2OperationResult(JSObject jsItem) {
    final conversationIdJs = jsItem.getProperty('conversationId'.toJS);
    final conversationId =
        conversationIdJs != null && conversationIdJs.isA<JSString>()
            ? (conversationIdJs as JSString).toDart
            : '';

    NIMError? nimError;
    final errorJs = jsItem.getProperty('error'.toJS);
    if (errorJs != null &&
        !errorJs.isUndefinedOrNull &&
        errorJs.isA<JSObject>()) {
      final errorObj = errorJs as JSObject;
      final codeJs = errorObj.getProperty('code'.toJS);
      final descJs = errorObj.getProperty('desc'.toJS);
      final code = codeJs != null && codeJs.isA<JSNumber>()
          ? (codeJs as JSNumber).toDartInt
          : -1;
      final desc = descJs != null && descJs.isA<JSString>()
          ? (descJs as JSString).toDart
          : null;
      nimError = NIMError.fromJson({'code': code, 'desc': desc});
    }

    return V2NIMConversationOperationResult(
      conversationId: conversationId,
      error: nimError,
    );
  }
}
