// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:nim_core_v2_platform_interface/nim_core_v2_platform_interface.dart';

import '../converters/error_converter.dart';
import '../converters/js_dart_converter.dart';
import '../converters/message_converter.dart';
import '../js_interop/nim_sdk.dart';
import 'web_initialize_service.dart';

/// Web 端本地会话服务实现
/// 对应 NIM Web SDK V2NIMLocalConversationService
class WebLocalConversationService extends LocalConversationServicePlatform {
  JSObject? _jsService;

  // 事件 StreamController
  final _syncStartedController = StreamController<void>.broadcast();
  final _syncFinishedController = StreamController<void>.broadcast();
  final _syncFailedController = StreamController<void>.broadcast();
  final _conversationCreatedController =
      StreamController<NIMConversation>.broadcast();
  final _conversationDeletedController =
      StreamController<List<String>>.broadcast();
  final _conversationChangedController =
      StreamController<List<NIMConversation>>.broadcast();
  final _totalUnreadCountChangedController = StreamController<int>.broadcast();
  final _unreadCountChangedByFilterController =
      StreamController<UnreadChangeFilterResult>.broadcast();
  final _conversationReadTimeUpdatedController =
      StreamController<ReadTimeUpdateResult>.broadcast();

  // JS callback 引用（用于注销时传入相同引用）
  JSFunction? _onSyncStartedJS;
  JSFunction? _onSyncFinishedJS;
  JSFunction? _onSyncFailedJS;
  JSFunction? _onConversationCreatedJS;
  JSFunction? _onConversationDeletedJS;
  JSFunction? _onConversationChangedJS;
  JSFunction? _onTotalUnreadCountChangedJS;
  JSFunction? _onUnreadCountChangedByFilterJS;
  JSFunction? _onConversationReadTimeUpdatedJS;

  WebLocalConversationService() {
    WebInitializeService.registerOnInit(_onNimInit);
    WebInitializeService.registerOnRelease(_onNimRelease);
  }

  void _onNimInit(JSV2NIM nim) {
    _removeListeners();
    final svc =
        (nim as JSObject).getProperty('V2NIMLocalConversationService'.toJS);
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

    _onSyncStartedJS = (() {
      _syncStartedController.add(null);
    }).toJS;

    _onSyncFinishedJS = (() {
      _syncFinishedController.add(null);
    }).toJS;

    _onSyncFailedJS = ((JSObject error) {
      _syncFailedController.add(null);
    }).toJS;

    _onConversationCreatedJS = ((JSObject conversation) {
      final map = formatV2ConversationLastMessage(conversation);
      _conversationCreatedController.add(NIMConversation.fromJson(map));
    }).toJS;

    _onConversationDeletedJS = ((JSArray conversationIds) {
      final ids = conversationIds.toDart
          .map(
            (item) => item != null && item.isA<JSString>()
                ? (item as JSString).toDart
                : '',
          )
          .where((s) => s.isNotEmpty)
          .toList();
      _conversationDeletedController.add(ids);
    }).toJS;

    _onConversationChangedJS = ((JSArray conversationList) {
      final list = formatV2ConversationList(conversationList);
      final conversations =
          list.map((m) => NIMConversation.fromJson(m)).toList();
      _conversationChangedController.add(conversations);
    }).toJS;

    _onTotalUnreadCountChangedJS = ((JSNumber unreadCount) {
      _totalUnreadCountChangedController.add(unreadCount.toDartInt);
    }).toJS;

    _onUnreadCountChangedByFilterJS = ((JSObject filter, JSNumber unreadCount) {
      final filterMap = jsObjectToMap(filter);
      _unreadCountChangedByFilterController.add(
        UnreadChangeFilterResult.fromJson({
          'unreadCount': unreadCount.toDartInt,
          'conversationFilter': filterMap,
        }),
      );
    }).toJS;

    _onConversationReadTimeUpdatedJS =
        ((JSString conversationId, JSNumber readTime) {
      _conversationReadTimeUpdatedController.add(
        ReadTimeUpdateResult.fromJson({
          'conversationId': conversationId.toDart,
          'readTime': readTime.toDartInt,
        }),
      );
    }).toJS;

    final on_ = service.getProperty('on'.toJS) as JSFunction;
    on_.callAsFunction(service, 'onSyncStarted'.toJS, _onSyncStartedJS!);
    on_.callAsFunction(service, 'onSyncFinished'.toJS, _onSyncFinishedJS!);
    on_.callAsFunction(service, 'onSyncFailed'.toJS, _onSyncFailedJS!);
    on_.callAsFunction(
      service,
      'onConversationCreated'.toJS,
      _onConversationCreatedJS!,
    );
    on_.callAsFunction(
      service,
      'onConversationDeleted'.toJS,
      _onConversationDeletedJS!,
    );
    on_.callAsFunction(
      service,
      'onConversationChanged'.toJS,
      _onConversationChangedJS!,
    );
    on_.callAsFunction(
      service,
      'onTotalUnreadCountChanged'.toJS,
      _onTotalUnreadCountChangedJS!,
    );
    on_.callAsFunction(
      service,
      'onUnreadCountChangedByFilter'.toJS,
      _onUnreadCountChangedByFilterJS!,
    );
    on_.callAsFunction(
      service,
      'onConversationReadTimeUpdated'.toJS,
      _onConversationReadTimeUpdatedJS!,
    );
  }

  void _removeListeners() {
    final service = _jsService;
    if (service == null) return;

    final off_ = service.getProperty('off'.toJS) as JSFunction;
    if (_onSyncStartedJS != null) {
      off_.callAsFunction(service, 'onSyncStarted'.toJS, _onSyncStartedJS!);
    }
    if (_onSyncFinishedJS != null) {
      off_.callAsFunction(service, 'onSyncFinished'.toJS, _onSyncFinishedJS!);
    }
    if (_onSyncFailedJS != null) {
      off_.callAsFunction(service, 'onSyncFailed'.toJS, _onSyncFailedJS!);
    }
    if (_onConversationCreatedJS != null) {
      off_.callAsFunction(
        service,
        'onConversationCreated'.toJS,
        _onConversationCreatedJS!,
      );
    }
    if (_onConversationDeletedJS != null) {
      off_.callAsFunction(
        service,
        'onConversationDeleted'.toJS,
        _onConversationDeletedJS!,
      );
    }
    if (_onConversationChangedJS != null) {
      off_.callAsFunction(
        service,
        'onConversationChanged'.toJS,
        _onConversationChangedJS!,
      );
    }
    if (_onTotalUnreadCountChangedJS != null) {
      off_.callAsFunction(
        service,
        'onTotalUnreadCountChanged'.toJS,
        _onTotalUnreadCountChangedJS!,
      );
    }
    if (_onUnreadCountChangedByFilterJS != null) {
      off_.callAsFunction(
        service,
        'onUnreadCountChangedByFilter'.toJS,
        _onUnreadCountChangedByFilterJS!,
      );
    }
    if (_onConversationReadTimeUpdatedJS != null) {
      off_.callAsFunction(
        service,
        'onConversationReadTimeUpdated'.toJS,
        _onConversationReadTimeUpdatedJS!,
      );
    }
  }

  @override
  String get serviceName => 'V2NIMLocalConversationService';

  @override
  Future<dynamic> onEvent(String method, dynamic arguments) async => null;

  /// 调用 JS 服务方法并返回 Promise 结果
  Future<JSAny?> _callJSAsync(String methodName, List<JSAny?> args) async {
    final service = _jsService;
    if (service == null) throw Exception('NIM SDK not initialized');

    final method = service.getProperty(methodName.toJS) as JSFunction;
    final applyMethod = method.getProperty('apply'.toJS) as JSFunction;
    final result = applyMethod.callAsFunction(method, service, args.toJS);
    if (result != null && result.isA<JSPromise>()) {
      return await (result as JSPromise).toDart;
    }
    return result;
  }

  // ====== Stream getters ======

  @override
  Stream<void> get onSyncStarted => _syncStartedController.stream;

  @override
  Stream<void> get onSyncFinished => _syncFinishedController.stream;

  @override
  Stream<void> get onSyncFailed => _syncFailedController.stream;

  @override
  Stream<NIMConversation> get onConversationCreated =>
      _conversationCreatedController.stream;

  @override
  Stream<List<String>> get onConversationDeleted =>
      _conversationDeletedController.stream;

  @override
  Stream<List<NIMConversation>> get onConversationChanged =>
      _conversationChangedController.stream;

  @override
  Stream<int> get onTotalUnreadCountChanged =>
      _totalUnreadCountChangedController.stream;

  @override
  Stream<UnreadChangeFilterResult> get onUnreadCountChangedByFilter =>
      _unreadCountChangedByFilterController.stream;

  @override
  Stream<ReadTimeUpdateResult> get onConversationReadTimeUpdated =>
      _conversationReadTimeUpdatedController.stream;

  // ====== API 方法实现 ======

  @override
  Future<NIMResult<NIMConversationResult>> getConversationList(
    int offset,
    int limit,
  ) async {
    try {
      final result = await _callJSAsync('getConversationList', [
        offset.toJS,
        limit.toJS,
      ]);
      if (result != null && result.isA<JSObject>()) {
        final resultMap = jsObjectToMap(result as JSObject);
        final convList = resultMap['conversationList'];
        if (convList is List) {
          resultMap['conversationList'] = convList.map((item) {
            if (item is Map<String, dynamic>) {
              _formatLastMessage(item);
            }
            return item;
          }).toList();
        }
        return NIMResult<NIMConversationResult>.fromMap(
          {'code': 0, 'data': resultMap},
          convert: (data) =>
              NIMConversationResult.fromJson(data as Map<String, dynamic>),
        );
      }
      return NIMResult<NIMConversationResult>.fromMap({
        'code': -1,
        'errorDetails': 'getConversationList returned null',
      });
    } catch (e) {
      return convertJSErrorToNIMResult<NIMConversationResult>(e);
    }
  }

  @override
  Future<NIMResult<NIMConversationResult>> getConversationListByOption(
    int offset,
    int limit,
    NIMConversationOption? option,
  ) async {
    try {
      final args = <JSAny?>[offset.toJS, limit.toJS];
      if (option != null) {
        args.add(dartMapToJsObject(option.toJson()));
      }
      final result = await _callJSAsync('getConversationListByOption', args);
      if (result != null && result.isA<JSObject>()) {
        final resultMap = jsObjectToMap(result as JSObject);
        final convList = resultMap['conversationList'];
        if (convList is List) {
          resultMap['conversationList'] = convList.map((item) {
            if (item is Map<String, dynamic>) {
              _formatLastMessage(item);
            }
            return item;
          }).toList();
        }
        return NIMResult<NIMConversationResult>.fromMap(
          {'code': 0, 'data': resultMap},
          convert: (data) =>
              NIMConversationResult.fromJson(data as Map<String, dynamic>),
        );
      }
      return NIMResult<NIMConversationResult>.fromMap({
        'code': -1,
        'errorDetails': 'getConversationListByOption returned null',
      });
    } catch (e) {
      return convertJSErrorToNIMResult<NIMConversationResult>(e);
    }
  }

  @override
  Future<NIMResult<NIMConversation>> getConversation(
    String conversationId,
  ) async {
    try {
      final result =
          await _callJSAsync('getConversation', [conversationId.toJS]);
      if (result != null && result.isA<JSObject>()) {
        final map = formatV2ConversationLastMessage(result as JSObject);
        return NIMResult<NIMConversation>.fromMap(
          {'code': 0, 'data': map},
          convert: (data) =>
              NIMConversation.fromJson(data as Map<String, dynamic>),
        );
      }
      return NIMResult<NIMConversation>.fromMap({
        'code': -1,
        'errorDetails': 'getConversation returned null',
      });
    } catch (e) {
      return convertJSErrorToNIMResult<NIMConversation>(e);
    }
  }

  @override
  Future<NIMResult<List<NIMConversation>>> getConversationListByIds(
    List<String> conversationIds,
  ) async {
    try {
      final jsIds = conversationIds.jsify();
      final result =
          await _callJSAsync('getConversationListByIds', [jsIds as JSAny]);
      if (result != null && result.isA<JSArray>()) {
        final list = formatV2ConversationList(result as JSArray);
        final conversations =
            list.map((m) => NIMConversation.fromJson(m)).toList();
        return NIMResult<List<NIMConversation>>(0, conversations, null);
      }
      return NIMResult<List<NIMConversation>>(0, [], null);
    } catch (e) {
      return convertJSErrorToNIMResult<List<NIMConversation>>(e);
    }
  }

  @override
  Future<NIMResult<NIMConversation>> createConversation(
    String conversationId,
  ) async {
    try {
      final result =
          await _callJSAsync('createConversation', [conversationId.toJS]);
      if (result != null && result.isA<JSObject>()) {
        final map = formatV2ConversationLastMessage(result as JSObject);
        return NIMResult<NIMConversation>.fromMap(
          {'code': 0, 'data': map},
          convert: (data) =>
              NIMConversation.fromJson(data as Map<String, dynamic>),
        );
      }
      return NIMResult<NIMConversation>.fromMap({
        'code': -1,
        'errorDetails': 'createConversation returned null',
      });
    } catch (e) {
      return convertJSErrorToNIMResult<NIMConversation>(e);
    }
  }

  @override
  Future<NIMResult<void>> deleteConversation(
    String conversationId,
    bool clearMessage,
  ) async {
    try {
      await _callJSAsync('deleteConversation', [
        conversationId.toJS,
        clearMessage.toJS,
      ]);
      return NIMResult<void>.fromMap({'code': 0});
    } catch (e) {
      return convertJSErrorToNIMResult<void>(e);
    }
  }

  @override
  Future<NIMResult<List<NIMConversationOperationResult>>>
      deleteConversationListByIds(
    List<String> conversationIds,
    bool clearMessage,
  ) async {
    try {
      final jsIds = conversationIds.jsify();
      final result = await _callJSAsync('deleteConversationListByIds', [
        jsIds as JSAny,
        clearMessage.toJS,
      ]);
      if (result != null && result.isA<JSArray>()) {
        final jsList = (result as JSArray).toDart;
        final results = jsList
            .where((item) => item != null && item.isA<JSObject>())
            .map((item) => _parseOperationResult(item! as JSObject))
            .toList();
        return NIMResult<List<NIMConversationOperationResult>>(
            0, results, null);
      }
      return NIMResult<List<NIMConversationOperationResult>>(0, [], null);
    } catch (e) {
      return convertJSErrorToNIMResult<List<NIMConversationOperationResult>>(e);
    }
  }

  @override
  Future<NIMResult<void>> stickTopConversation(
    String conversationId,
    bool stickTop,
  ) async {
    try {
      await _callJSAsync('stickTopConversation', [
        conversationId.toJS,
        stickTop.toJS,
      ]);
      return NIMResult<void>.fromMap({'code': 0});
    } catch (e) {
      return convertJSErrorToNIMResult<void>(e);
    }
  }

  /// Web SDK 不支持本地扩展字段（仅本地数据库，Web 端无此能力）
  @override
  Future<NIMResult<void>> updateConversationLocalExtension(
    String conversationId,
    String localExtension,
  ) async {
    return NIMResult<void>.fromMap({
      'code': -1,
      'errorDetails':
          'updateConversationLocalExtension is not supported on Web',
    });
  }

  @override
  Future<NIMResult<int>> getTotalUnreadCount() async {
    final service = _jsService;
    if (service == null) {
      return NIMResult<int>.fromMap(
          {'code': -1, 'errorDetails': 'NIM SDK not initialized'});
    }
    try {
      final method =
          service.getProperty('getTotalUnreadCount'.toJS) as JSFunction;
      final result = method.callAsFunction(service);
      final count = result != null && result.isA<JSNumber>()
          ? (result as JSNumber).toDartInt
          : 0;
      return NIMResult<int>(0, count, null);
    } catch (e) {
      return convertJSErrorToNIMResult<int>(e);
    }
  }

  @override
  Future<NIMResult<int>> getUnreadCountByIds(
    List<String> conversationIds,
  ) async {
    try {
      final jsIds = conversationIds.jsify();
      final result =
          await _callJSAsync('getUnreadCountByIds', [jsIds as JSAny]);
      final count = result != null && result.isA<JSNumber>()
          ? (result as JSNumber).toDartInt
          : 0;
      return NIMResult<int>(0, count, null);
    } catch (e) {
      return convertJSErrorToNIMResult<int>(e);
    }
  }

  @override
  Future<NIMResult<int>> getUnreadCountByFilter(
    NIMConversationFilter filter,
  ) async {
    try {
      final jsFilter = dartMapToJsObject(filter.toJson());
      final result = await _callJSAsync('getUnreadCountByFilter', [jsFilter]);
      final count = result != null && result.isA<JSNumber>()
          ? (result as JSNumber).toDartInt
          : 0;
      return NIMResult<int>(0, count, null);
    } catch (e) {
      return convertJSErrorToNIMResult<int>(e);
    }
  }

  @override
  Future<NIMResult<void>> clearTotalUnreadCount() async {
    try {
      await _callJSAsync('clearTotalUnreadCount', []);
      return NIMResult<void>.fromMap({'code': 0});
    } catch (e) {
      return convertJSErrorToNIMResult<void>(e);
    }
  }

  @override
  Future<NIMResult<List<NIMConversationOperationResult>>> clearUnreadCountByIds(
    List<String> conversationIds,
  ) async {
    try {
      final jsIds = conversationIds.jsify();
      final result =
          await _callJSAsync('clearUnreadCountByIds', [jsIds as JSAny]);
      if (result != null && result.isA<JSArray>()) {
        final jsList = (result as JSArray).toDart;
        final results = jsList
            .where((item) => item != null && item.isA<JSObject>())
            .map((item) => _parseOperationResult(item! as JSObject))
            .toList();
        return NIMResult<List<NIMConversationOperationResult>>(
            0, results, null);
      }
      return NIMResult<List<NIMConversationOperationResult>>(0, [], null);
    } catch (e) {
      return convertJSErrorToNIMResult<List<NIMConversationOperationResult>>(e);
    }
  }

  @override
  Future<NIMResult<void>> clearUnreadCountByTypes(
    List<NIMConversationType> conversationTypes,
  ) async {
    try {
      final jsTypes = conversationTypes.map((t) => t.index).toList().jsify();
      await _callJSAsync('clearUnreadCountByTypes', [jsTypes as JSAny]);
      return NIMResult<void>.fromMap({'code': 0});
    } catch (e) {
      return convertJSErrorToNIMResult<void>(e);
    }
  }

  @override
  Future<NIMResult<NIMError?>> subscribeUnreadCountByFilter(
    NIMConversationFilter filter,
  ) async {
    final service = _jsService;
    if (service == null) {
      return NIMResult<NIMError?>.fromMap(
          {'code': -1, 'errorDetails': 'NIM SDK not initialized'});
    }
    try {
      final jsFilter = dartMapToJsObject(filter.toJson());
      final method = service.getProperty('subscribeUnreadCountByFilter'.toJS);
      if (method == null || !method.isA<JSFunction>()) {
        return NIMResult<NIMError?>.fromMap({
          'code': -1,
          'errorDetails':
              'subscribeUnreadCountByFilter is not supported on Web',
        });
      }
      (method as JSFunction).callAsFunction(service, jsFilter);
      return NIMResult<NIMError?>(0, null, null);
    } catch (e) {
      return convertJSErrorToNIMResult<NIMError?>(e);
    }
  }

  @override
  Future<NIMResult<NIMError?>> unsubscribeUnreadCountByFilter(
    NIMConversationFilter filter,
  ) async {
    final service = _jsService;
    if (service == null) {
      return NIMResult<NIMError?>.fromMap(
          {'code': -1, 'errorDetails': 'NIM SDK not initialized'});
    }
    try {
      final jsFilter = dartMapToJsObject(filter.toJson());
      final method = service.getProperty('unsubscribeUnreadCountByFilter'.toJS);
      if (method == null || !method.isA<JSFunction>()) {
        return NIMResult<NIMError?>.fromMap({
          'code': -1,
          'errorDetails':
              'unsubscribeUnreadCountByFilter is not supported on Web',
        });
      }
      (method as JSFunction).callAsFunction(service, jsFilter);
      return NIMResult<NIMError?>(0, null, null);
    } catch (e) {
      return convertJSErrorToNIMResult<NIMError?>(e);
    }
  }

  @override
  Future<NIMResult<int>> getConversationReadTime(
    String conversationId,
  ) async {
    try {
      final result =
          await _callJSAsync('getConversationReadTime', [conversationId.toJS]);
      final readTime = result != null && result.isA<JSNumber>()
          ? (result as JSNumber).toDartInt
          : 0;
      return NIMResult<int>(0, readTime, null);
    } catch (e) {
      return convertJSErrorToNIMResult<int>(e);
    }
  }

  @override
  Future<NIMResult<int>> markConversationRead(String conversationId) async {
    try {
      final result =
          await _callJSAsync('markConversationRead', [conversationId.toJS]);
      final readTime = result != null && result.isA<JSNumber>()
          ? (result as JSNumber).toDartInt
          : 0;
      return NIMResult<int>(0, readTime, null);
    } catch (e) {
      return convertJSErrorToNIMResult<int>(e);
    }
  }

  @override
  Future<NIMResult<List<NIMConversation>>> getStickTopConversationList() async {
    try {
      final result = await _callJSAsync('getStickTopConversationList', []);
      if (result != null && result.isA<JSArray>()) {
        final list = formatV2ConversationList(result as JSArray);
        final conversations =
            list.map((m) => NIMConversation.fromJson(m)).toList();
        return NIMResult<List<NIMConversation>>(0, conversations, null);
      }
      return NIMResult<List<NIMConversation>>(0, [], null);
    } catch (e) {
      return convertJSErrorToNIMResult<List<NIMConversation>>(e);
    }
  }

  /// Web SDK 不支持设置当前会话（Web 端无本地当前会话概念）
  @override
  Future<NIMResult<void>> setCurrentConversation(
    String conversationId,
  ) async {
    return NIMResult<void>.fromMap({
      'code': -1,
      'errorDetails': 'setCurrentConversation is not supported on Web',
    });
  }

  // ====== 内部辅助方法 ======

  /// 解析 NIMConversationOperationResult JS 对象
  /// V2NIMError 继承自原生 JS Error，不能用 jsObjectToMap 直接转换，
  /// 需手动通过 getProperty 提取 code/desc
  NIMConversationOperationResult _parseOperationResult(JSObject jsItem) {
    final conversationIdJs = jsItem.getProperty('conversationId'.toJS);
    final conversationId =
        conversationIdJs != null && conversationIdJs.isA<JSString>()
            ? (conversationIdJs as JSString).toDart
            : null;

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

    return NIMConversationOperationResult(
      conversationId: conversationId,
      error: nimError,
    );
  }

  /// 格式化 lastMessage 中的 attachment
  void _formatLastMessage(Map<String, dynamic> conversationMap) {
    final lastMessage = conversationMap['lastMessage'];
    if (lastMessage is Map<String, dynamic>) {
      final attachment = lastMessage['attachment'];
      if (attachment is Map<String, dynamic>) {
        attachment['nimCoreMessageType'] = lastMessage['messageType'];
      }
    }
  }
}
