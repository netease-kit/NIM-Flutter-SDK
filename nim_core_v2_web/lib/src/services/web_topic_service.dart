// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:nim_core_v2_platform_interface/nim_core_v2_platform_interface.dart';

import '../converters/error_converter.dart';
import '../converters/js_dart_converter.dart';
import '../converters/message_converter.dart';
import '../js_interop/nim_sdk.dart';
import 'web_initialize_service.dart';

class WebV2NIMTopicService extends V2NIMTopicServicePlatform {
  JSObject? _jsService;
  final Map<String, JSFunction> _jsCallbacks = {};

  WebV2NIMTopicService() {
    WebInitializeService.registerOnInit(_onNimInit);
    WebInitializeService.registerOnRelease(_onNimRelease);
  }

  void _onNimInit(JSV2NIM nim) {
    _removeListeners();
    final nimObject = nim as JSObject;
    final svc = nimObject.getProperty('topicService'.toJS) ??
        nimObject.getProperty('V2NIMTopicService'.toJS);
    if (svc != null && svc.isA<JSObject>()) {
      _jsService = svc as JSObject;
      _setupListeners();
    }
  }

  void _onNimRelease() {
    _removeListeners();
    _jsService = null;
  }

  @override
  String get serviceName => 'TopicService';

  @override
  Future<dynamic> onEvent(String method, dynamic arguments) async => null;

  void _on(String event, JSFunction cb) {
    final service = _jsService;
    if (service == null) return;
    _jsCallbacks[event] = cb;
    (service.getProperty('on'.toJS) as JSFunction)
        .callAsFunction(service, event.toJS, cb);
  }

  void _setupListeners() {
    _on(
      'onTopicAdded',
      ((JSObject jsTopic) {
        onTopicAdded.add(V2NIMTopic.fromJson(jsObjectToMap(jsTopic)));
      }).toJS,
    );
    _on(
      'onTopicsRemoved',
      ((JSArray jsTopics) {
        onTopicsRemoved.add(jsArrayToMapList(jsTopics)
            .map((e) => V2NIMTopicRefer.fromJson(e))
            .toList());
      }).toJS,
    );
    _on(
      'onTopicUpdated',
      ((JSObject jsTopic) {
        onTopicUpdated.add(V2NIMTopic.fromJson(jsObjectToMap(jsTopic)));
      }).toJS,
    );
  }

  void _removeListeners() {
    final service = _jsService;
    if (service == null) return;
    final off = service.getProperty('off'.toJS) as JSFunction;
    _jsCallbacks.forEach((event, cb) {
      off.callAsFunction(service, event.toJS, cb);
    });
    _jsCallbacks.clear();
  }

  Future<JSAny?> _callJSAsync(String methodName, List<JSAny?> args) async {
    final service = _jsService;
    if (service == null) throw Exception('NIM SDK not initialized');
    final method = service.getProperty(methodName.toJS) as JSFunction;
    final apply = method.getProperty('apply'.toJS) as JSFunction;
    final result = apply.callAsFunction(method, service, args.toJS);
    if (result != null && result.isA<JSPromise>()) {
      return await (result as JSPromise).toDart;
    }
    return result;
  }

  @override
  Future<NIMResult<void>> removeTopics(V2NIMRemoveTopicsParams params) {
    return wrapJSPromiseVoid(() async {
      await _callJSAsync('removeTopics', [dartMapToJsObject(params.toJson())]);
    });
  }

  @override
  Future<NIMResult<V2NIMTopic>> updateTopic(
      V2NIMUpdateTopicParams params) async {
    try {
      final result = await _callJSAsync(
          'updateTopic', [dartMapToJsObject(params.toJson())]);
      if (result != null && result.isA<JSObject>()) {
        return NIMResult<V2NIMTopic>.fromMap(
          {'code': 0, 'data': jsObjectToMap(result as JSObject)},
          convert: (data) => V2NIMTopic.fromJson(data),
        );
      }
      return NIMResult<V2NIMTopic>.fromMap({
        'code': -1,
        'errorDetails': 'updateTopic returned null',
      });
    } catch (e) {
      return convertJSErrorToNIMResult<V2NIMTopic>(e);
    }
  }

  @override
  Future<NIMResult<NIMSendMessageResult>> sendTopicMessage({
    required NIMMessage message,
    required String conversationId,
    V2NIMTopic? topic,
    V2NIMSendTopicMessageParams? params,
  }) async {
    try {
      final jsProgressCallback = ((JSNumber percentage) {
        MessageServicePlatform.instance.onSendMessageProgress.add(
          NIMSendMessageProgress(
            messageClientId: message.messageClientId ?? '',
            progress: percentage.toDartInt,
          ),
        );
      }).toJS;
      final result = await _callJSAsync('sendTopicMessage', [
        dartMapToJsObject(message.toJson()),
        conversationId.toJS,
        if (topic != null) dartMapToJsObject(topic.toJson()) else null,
        if (params != null) dartMapToJsObject(params.toJson()) else null,
        jsProgressCallback,
      ]);
      return _sendResultFromJS(result, 'sendTopicMessage');
    } catch (e) {
      return convertJSErrorToNIMResult<NIMSendMessageResult>(e);
    }
  }

  @override
  Future<NIMResult<NIMSendMessageResult>> replyTopicMessage({
    required NIMMessage message,
    required NIMMessage replyMessage,
    required V2NIMTopic topic,
    NIMSendMessageParams? params,
  }) async {
    try {
      final jsProgressCallback = ((JSNumber percentage) {
        MessageServicePlatform.instance.onSendMessageProgress.add(
          NIMSendMessageProgress(
            messageClientId: message.messageClientId ?? '',
            progress: percentage.toDartInt,
          ),
        );
      }).toJS;
      final result = await _callJSAsync('replyTopicMessage', [
        dartMapToJsObject(message.toJson()),
        dartMapToJsObject(replyMessage.toJson()),
        dartMapToJsObject(topic.toJson()),
        if (params != null) dartMapToJsObject(params.toJson()) else null,
        jsProgressCallback,
      ]);
      return _sendResultFromJS(result, 'replyTopicMessage');
    } catch (e) {
      return convertJSErrorToNIMResult<NIMSendMessageResult>(e);
    }
  }

  NIMResult<NIMSendMessageResult> _sendResultFromJS(
      JSAny? result, String methodName) {
    if (result != null && result.isA<JSObject>()) {
      final resultMap = jsObjectToMap(result as JSObject);
      final msg = resultMap['message'];
      if (msg is Map<String, dynamic>) {
        resultMap['message'] = formatV2Message(dartMapToJsObject(msg));
      }
      return NIMResult<NIMSendMessageResult>.fromMap(
        {'code': 0, 'data': resultMap},
        convert: (data) => NIMSendMessageResult.fromJson(data),
      );
    }
    return NIMResult<NIMSendMessageResult>.fromMap({
      'code': -1,
      'errorDetails': '$methodName returned null',
    });
  }

  @override
  Future<NIMResult<V2NIMTopic>> getTopicByRefer(
      V2NIMTopicRefer topicRefer) async {
    try {
      final result = await _callJSAsync(
        'getTopicByRefer',
        [dartMapToJsObject(topicRefer.toJson())],
      );
      if (result != null && result.isA<JSObject>()) {
        return NIMResult<V2NIMTopic>.fromMap(
          {'code': 0, 'data': jsObjectToMap(result as JSObject)},
          convert: (data) => V2NIMTopic.fromJson(data),
        );
      }
      return NIMResult<V2NIMTopic>.fromMap({'code': 0});
    } catch (e) {
      return convertJSErrorToNIMResult<V2NIMTopic>(e);
    }
  }

  @override
  Future<NIMResult<V2NIMTopicListResult>> getTopicListByOption(
      V2NIMTopicListOption option) async {
    try {
      final result = await _callJSAsync(
        'getTopicListByOption',
        [dartMapToJsObject(option.toJson())],
      );
      if (result != null && result.isA<JSObject>()) {
        return NIMResult<V2NIMTopicListResult>.fromMap(
          {'code': 0, 'data': jsObjectToMap(result as JSObject)},
          convert: (data) => V2NIMTopicListResult.fromJson(data),
        );
      }
      return NIMResult<V2NIMTopicListResult>.fromMap({
        'code': -1,
        'errorDetails': 'getTopicListByOption returned null',
      });
    } catch (e) {
      return convertJSErrorToNIMResult<V2NIMTopicListResult>(e);
    }
  }

  @override
  Future<NIMResult<V2NIMTopicMessageListResult>> getTopicMessageList(
      V2NIMTopicMessageListOption option) async {
    try {
      final result = await _callJSAsync(
        'getTopicMessageList',
        [dartMapToJsObject(option.toJson())],
      );
      if (result != null && result.isA<JSObject>()) {
        final map = jsObjectToMap(result as JSObject);
        final replies = map['replyList'];
        if (replies is List) {
          map['replyList'] = replies.map((item) {
            if (item is Map<String, dynamic>) {
              return formatV2Message(dartMapToJsObject(item));
            }
            return item;
          }).toList();
        }
        final anchor = map['anchorMessage'];
        if (anchor is Map<String, dynamic>) {
          map['anchorMessage'] = formatV2Message(dartMapToJsObject(anchor));
        }
        return NIMResult<V2NIMTopicMessageListResult>.fromMap(
          {'code': 0, 'data': map},
          convert: (data) => V2NIMTopicMessageListResult.fromJson(data),
        );
      }
      return NIMResult<V2NIMTopicMessageListResult>.fromMap({
        'code': -1,
        'errorDetails': 'getTopicMessageList returned null',
      });
    } catch (e) {
      return convertJSErrorToNIMResult<V2NIMTopicMessageListResult>(e);
    }
  }
}
