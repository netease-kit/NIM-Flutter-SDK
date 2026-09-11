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
import 'web_message_creator_service.dart';

/// Web 端消息服务实现
class WebMessageService extends MessageServicePlatform {
  JSObject? _jsService;
  JSObject? _jsConverterService;
  WebMessageCreatorService? _creatorService;

  // JS callback 引用
  JSFunction? _onReceiveMessagesModifiedJS;
  JSFunction? _onReceiveMessagesJS;
  JSFunction? _onSendMessageJS;
  JSFunction? _onMessageRevokeNotificationsJS;
  JSFunction? _onMessageDeletedNotificationsJS;
  JSFunction? _onMessagePinNotificationJS;
  JSFunction? _onMessageQuickCommentNotificationJS;
  JSFunction? _onReceiveP2PMessageReadReceiptsJS;
  JSFunction? _onReceiveTeamMessageReadReceiptsJS;
  JSFunction? _onClearHistoryNotificationsJS;

  WebMessageService() {
    WebInitializeService.registerOnInit(_onNimInit);
    WebInitializeService.registerOnRelease(_onNimRelease);
  }

  /// 设置 MessageCreatorService 引用，用于获取缓存的 JS 消息
  void setCreatorService(WebMessageCreatorService creator) {
    _creatorService = creator;
  }

  void _onNimInit(JSV2NIM nim) {
    _removeListeners();
    final svc = (nim as JSObject).getProperty('V2NIMMessageService'.toJS);
    if (svc != null && svc.isA<JSObject>()) {
      _jsService = svc as JSObject;
      _setupListeners();
    }
    final converter = (nim as JSObject).getProperty(
      'V2NIMMessageConverter'.toJS,
    );
    if (converter != null && converter.isA<JSObject>()) {
      _jsConverterService = converter as JSObject;
    }
  }

  void _onNimRelease() {
    _removeListeners();
    _jsService = null;
    _jsConverterService = null;
  }

  void _setupListeners() {
    final service = _jsService;
    if (service == null) return;

    _onReceiveMessagesModifiedJS = ((JSArray messages) {
      final msgList = formatV2MessageList(messages);
      final nimMessages = msgList.map((m) => NIMMessage.fromJson(m)).toList();
      onReceiveMessagesModified.add(nimMessages);
    }).toJS;

    _onReceiveMessagesJS = ((JSArray messages) {
      final msgList = formatV2MessageList(messages);
      final nimMessages = msgList.map((m) => NIMMessage.fromJson(m)).toList();
      onReceiveMessages.add(nimMessages);
    }).toJS;

    _onSendMessageJS = ((JSObject message) {
      final map = formatV2Message(message);
      onSendMessage.add(NIMMessage.fromJson(map));
    }).toJS;

    _onMessageRevokeNotificationsJS = ((JSArray notifications) {
      final list = jsArrayToMapList(notifications);
      onMessageRevokeNotifications.add(
        list.map((m) => NIMMessageRevokeNotification.fromJson(m)).toList(),
      );
    }).toJS;

    _onMessageDeletedNotificationsJS = ((JSArray notifications) {
      final list = jsArrayToMapList(notifications);
      onMessageDeletedNotifications.add(
        list.map((m) => NIMMessageDeletedNotification.fromJson(m)).toList(),
      );
    }).toJS;

    _onMessagePinNotificationJS = ((JSObject notification) {
      final map = formatV2MessagePin(jsObjectToMap(notification));
      onMessagePinNotification.add(NIMMessagePinNotification.fromJson(map));
    }).toJS;

    _onMessageQuickCommentNotificationJS = ((JSObject notification) {
      final map = formatV2QuickComment(jsObjectToMap(notification));
      onMessageQuickCommentNotification.add(
        NIMMessageQuickCommentNotification.fromJson(map),
      );
    }).toJS;

    _onReceiveP2PMessageReadReceiptsJS = ((JSArray receipts) {
      final list = jsArrayToMapList(receipts);
      onReceiveP2PMessageReadReceipts.add(
        list.map((m) => NIMP2PMessageReadReceipt.fromJson(m)).toList(),
      );
    }).toJS;

    _onReceiveTeamMessageReadReceiptsJS = ((JSArray receipts) {
      final list = jsArrayToMapList(receipts);
      onReceiveTeamMessageReadReceipts.add(
        list.map((m) => NIMTeamMessageReadReceipt.fromJson(m)).toList(),
      );
    }).toJS;

    _onClearHistoryNotificationsJS = ((JSArray notifications) {
      final list = jsArrayToMapList(notifications);
      onClearHistoryNotifications.add(
        list
            .map((m) => NIMClearHistoryNotification.fromJson(
                formatV2ClearHistoryNotification(m)))
            .toList(),
      );
    }).toJS;

    final on_ = service.getProperty('on'.toJS) as JSFunction;
    on_.callAsFunction(
      service,
      'onReceiveMessagesModified'.toJS,
      _onReceiveMessagesModifiedJS!,
    );
    on_.callAsFunction(
      service,
      'onReceiveMessages'.toJS,
      _onReceiveMessagesJS!,
    );
    on_.callAsFunction(service, 'onSendMessage'.toJS, _onSendMessageJS!);
    on_.callAsFunction(
      service,
      'onMessageRevokeNotifications'.toJS,
      _onMessageRevokeNotificationsJS!,
    );
    on_.callAsFunction(
      service,
      'onMessageDeletedNotifications'.toJS,
      _onMessageDeletedNotificationsJS!,
    );
    on_.callAsFunction(
      service,
      'onMessagePinNotification'.toJS,
      _onMessagePinNotificationJS!,
    );
    on_.callAsFunction(
      service,
      'onMessageQuickCommentNotification'.toJS,
      _onMessageQuickCommentNotificationJS!,
    );
    on_.callAsFunction(
      service,
      'onReceiveP2PMessageReadReceipts'.toJS,
      _onReceiveP2PMessageReadReceiptsJS!,
    );
    on_.callAsFunction(
      service,
      'onReceiveTeamMessageReadReceipts'.toJS,
      _onReceiveTeamMessageReadReceiptsJS!,
    );
    on_.callAsFunction(
      service,
      'onClearHistoryNotifications'.toJS,
      _onClearHistoryNotificationsJS!,
    );
  }

  @override
  String get serviceName => 'MessageService';

  void _removeListeners() {
    final service = _jsService;
    if (service == null) return;

    final off_ = service.getProperty('off'.toJS) as JSFunction;
    if (_onReceiveMessagesModifiedJS != null) {
      off_.callAsFunction(
        service,
        'onReceiveMessagesModified'.toJS,
        _onReceiveMessagesModifiedJS!,
      );
    }
    if (_onReceiveMessagesJS != null) {
      off_.callAsFunction(
        service,
        'onReceiveMessages'.toJS,
        _onReceiveMessagesJS!,
      );
    }
    if (_onSendMessageJS != null) {
      off_.callAsFunction(service, 'onSendMessage'.toJS, _onSendMessageJS!);
    }
    if (_onMessageRevokeNotificationsJS != null) {
      off_.callAsFunction(
        service,
        'onMessageRevokeNotifications'.toJS,
        _onMessageRevokeNotificationsJS!,
      );
    }
    if (_onMessageDeletedNotificationsJS != null) {
      off_.callAsFunction(
        service,
        'onMessageDeletedNotifications'.toJS,
        _onMessageDeletedNotificationsJS!,
      );
    }
    if (_onMessagePinNotificationJS != null) {
      off_.callAsFunction(
        service,
        'onMessagePinNotification'.toJS,
        _onMessagePinNotificationJS!,
      );
    }
    if (_onMessageQuickCommentNotificationJS != null) {
      off_.callAsFunction(
        service,
        'onMessageQuickCommentNotification'.toJS,
        _onMessageQuickCommentNotificationJS!,
      );
    }
    if (_onReceiveP2PMessageReadReceiptsJS != null) {
      off_.callAsFunction(
        service,
        'onReceiveP2PMessageReadReceipts'.toJS,
        _onReceiveP2PMessageReadReceiptsJS!,
      );
    }
    if (_onReceiveTeamMessageReadReceiptsJS != null) {
      off_.callAsFunction(
        service,
        'onReceiveTeamMessageReadReceipts'.toJS,
        _onReceiveTeamMessageReadReceiptsJS!,
      );
    }
    if (_onClearHistoryNotificationsJS != null) {
      off_.callAsFunction(
        service,
        'onClearHistoryNotifications'.toJS,
        _onClearHistoryNotificationsJS!,
      );
    }
  }

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

  /// 构建 AI Config 的 JS 对象
  /// 对应 TS 中 formatAIModelRoleType 逻辑：
  /// Dart 侧 role 枚举值为 int (0=system, 1=user, 2=assistant)
  /// JS SDK 期望的是 V2NIMConst 枚举字符串，需要转换
  JSObject? _buildAIConfigJS(NIMSendMessageParams? params) {
    if (params?.aiConfig == null) return null;
    final aiMap = params!.aiConfig!.toJson();

    // 处理 messages 中的 role 字段
    final messages = aiMap['messages'];
    if (messages is List && messages.isNotEmpty) {
      // JS SDK 的 V2NIMAIModelRoleType 枚举使用字符串常量
      // 但 NIM Web SDK 也接受数字，与 Dart 侧定义一致
      // 因此直接传递 int 值即可
    }

    return dartMapToJsObject(aiMap);
  }

  @override
  Future<dynamic> onEvent(String method, dynamic arguments) async {
    return null;
  }

  // ====== API 方法实现 ======

  @override
  Future<NIMResult<NIMSendMessageResult>> sendMessage({
    required NIMMessage message,
    required String conversationId,
    NIMSendMessageParams? params,
  }) async {
    final service = _jsService;
    if (service == null) {
      return NIMResult<NIMSendMessageResult>.fromMap({
        'code': -1,
        'errorDetails': 'NIM SDK not initialized',
      });
    }

    try {
      final messageClientId = message.messageClientId;
      // 从 CreatorService 缓存中获取原始 JS 消息对象
      final cachedJsMsg = _creatorService?.getCachedJSMessage(
        messageClientId ?? '',
      );

      final JSAny jsMessage;
      if (cachedJsMsg != null) {
        jsMessage = cachedJsMsg;
        // 将 Dart 侧在消息创建后、发送前设置的属性同步到缓存的 JS 对象。
        // 如 serverExtension（@消息的 aitMap）、text 等字段是在
        // MessageCreator.createXxxMessage() 之后设置的，
        // 缓存的 JS 对象不包含这些后设属性，需要手动同步。
        if (message.serverExtension != null) {
          (jsMessage as JSObject)['serverExtension'] =
              message.serverExtension!.toJS;
        }
        if (message.text != null) {
          (jsMessage as JSObject)['text'] = message.text!.toJS;
        }
      } else {
        jsMessage = dartMapToJsObject(message.toJson());
      }

      // 构建发送参数
      JSAny? jsParams;
      if (params != null) {
        final paramsMap = params.toJson();
        // 处理 aiConfig
        if (params.aiConfig != null) {
          paramsMap['aiConfig'] = params.aiConfig!.toJson();
        }
        jsParams = dartMapToJsObject(paramsMap);
      }

      // 构建进度回调
      final jsProgressCallback = ((JSNumber percentage) {
        onSendMessageProgress.add(
          NIMSendMessageProgress(
            messageClientId: messageClientId ?? '',
            progress: percentage.toDartInt,
          ),
        );
      }).toJS;

      final result = await _callJSAsync('sendMessage', [
        jsMessage,
        conversationId.toJS,
        jsParams,
        jsProgressCallback,
      ]);

      // 清除消息缓存
      if (messageClientId != null) {
        _creatorService?.removeCachedJSMessage(messageClientId);
      }

      if (result != null && result.isA<JSObject>()) {
        final resultMap = jsObjectToMap(result as JSObject);
        // 格式化返回的消息
        final msg = resultMap['message'];
        if (msg is Map<String, dynamic>) {
          _injectMessageType(msg);
        }
        return NIMResult<NIMSendMessageResult>.fromMap(
          {'code': 0, 'data': resultMap},
          convert: (data) {
            return NIMSendMessageResult.fromJson(data as Map<String, dynamic>);
          },
        );
      }

      return NIMResult<NIMSendMessageResult>.fromMap({
        'code': -1,
        'errorDetails': 'sendMessage returned null',
      });
    } catch (e) {
      return convertJSErrorToNIMResult<NIMSendMessageResult>(e);
    }
  }

  @override
  Future<NIMResult<NIMSendMessageResult>> replyMessage({
    required NIMMessage message,
    required NIMMessage replyMessage,
    NIMSendMessageParams? params,
  }) async {
    final service = _jsService;
    if (service == null) {
      return NIMResult<NIMSendMessageResult>.fromMap({
        'code': -1,
        'errorDetails': 'NIM SDK not initialized',
      });
    }

    try {
      final messageClientId = message.messageClientId;
      final cachedJsMsg = _creatorService?.getCachedJSMessage(
        messageClientId ?? '',
      );

      JSAny jsMessage;
      if (cachedJsMsg != null) {
        jsMessage = cachedJsMsg;
        // 同步 Dart 侧后设的属性到缓存的 JS 对象（同 sendMessage）
        if (message.serverExtension != null) {
          (jsMessage as JSObject)['serverExtension'] =
              message.serverExtension!.toJS;
        }
        if (message.text != null) {
          (jsMessage as JSObject)['text'] = message.text!.toJS;
        }
      } else {
        jsMessage = dartMapToJsObject(message.toJson());
      }
      final JSAny jsReplyMessage = dartMapToJsObject(replyMessage.toJson());

      JSAny? jsParams;
      if (params != null) {
        jsParams = dartMapToJsObject(params.toJson());
      }

      final jsProgressCallback = ((JSNumber percentage) {
        onSendMessageProgress.add(
          NIMSendMessageProgress(
            messageClientId: messageClientId ?? '',
            progress: percentage.toDartInt,
          ),
        );
      }).toJS;

      final result = await _callJSAsync('replyMessage', [
        jsMessage,
        jsReplyMessage,
        jsParams,
        jsProgressCallback,
      ]);

      if (messageClientId != null) {
        _creatorService?.removeCachedJSMessage(messageClientId);
      }

      if (result != null && result.isA<JSObject>()) {
        final resultMap = jsObjectToMap(result as JSObject);
        final msg = resultMap['message'];
        if (msg is Map<String, dynamic>) {
          _injectMessageType(msg);
        }
        return NIMResult<NIMSendMessageResult>.fromMap(
          {'code': 0, 'data': resultMap},
          convert: (data) {
            return NIMSendMessageResult.fromJson(data as Map<String, dynamic>);
          },
        );
      }

      return NIMResult<NIMSendMessageResult>.fromMap({
        'code': -1,
        'errorDetails': 'replyMessage returned null',
      });
    } catch (e) {
      return convertJSErrorToNIMResult<NIMSendMessageResult>(e);
    }
  }

  @override
  Future<NIMResult<List<NIMMessage>>> getMessageList({
    required NIMMessageListOption option,
  }) async {
    try {
      final jsOption = dartMapToJsObject(option.toJson());
      final result = await _callJSAsync('getMessageList', [jsOption]);
      if (result != null && result.isA<JSArray>()) {
        final msgList = formatV2MessageList(result as JSArray);
        final messages = msgList.map((m) => NIMMessage.fromJson(m)).toList();
        return NIMResult<List<NIMMessage>>.fromMap(
          {
            'code': 0,
            'data': {'messageList': messages.map((m) => m.toJson()).toList()},
          },
          convert: (data) {
            final list = (data as Map<String, dynamic>)['messageList'] as List;
            return list
                .map(
                  (e) =>
                      NIMMessage.fromJson((e as Map).cast<String, dynamic>()),
                )
                .toList();
          },
        );
      }
      return NIMResult<List<NIMMessage>>.fromMap({
        'code': 0,
        'data': {'messageList': []},
      }, convert: (data) => <NIMMessage>[]);
    } catch (e) {
      return convertJSErrorToNIMResult<List<NIMMessage>>(e);
    }
  }

  @override
  Future<NIMResult<List<NIMMessage>>> getMessageListByIds({
    required List<String> messageClientIds,
  }) async {
    // Web SDK 不支持此方法
    return NIMResult<List<NIMMessage>>.fromMap({
      'code': -1,
      'errorDetails': 'getMessageListByIds is not supported on Web',
    });
  }

  @override
  Future<NIMResult<List<NIMMessage>>> getMessageListByRefers({
    required List<NIMMessageRefer> messageRefers,
  }) async {
    try {
      final jsRefers = messageRefers.map((r) => r.toJson()).toList().jsify();
      final result = await _callJSAsync('getMessageListByRefers', [
        jsRefers as JSAny,
      ]);
      if (result != null && result.isA<JSArray>()) {
        final msgList = formatV2MessageList(result as JSArray);
        final messages = msgList.map((m) => NIMMessage.fromJson(m)).toList();
        return NIMResult<List<NIMMessage>>.fromMap(
          {
            'code': 0,
            'data': {'messageList': messages.map((m) => m.toJson()).toList()},
          },
          convert: (data) {
            final list = (data as Map<String, dynamic>)['messageList'] as List;
            return list
                .map(
                  (e) =>
                      NIMMessage.fromJson((e as Map).cast<String, dynamic>()),
                )
                .toList();
          },
        );
      }
      return NIMResult<List<NIMMessage>>.fromMap({
        'code': 0,
        'data': {'messageList': []},
      }, convert: (data) => <NIMMessage>[]);
    } catch (e) {
      return convertJSErrorToNIMResult<List<NIMMessage>>(e);
    }
  }

  @override
  Future<NIMResult<List<NIMMessage>>> searchCloudMessages({
    required NIMMessageSearchParams params,
  }) async {
    try {
      final jsParams = dartMapToJsObject(params.toJson());
      final result = await _callJSAsync('searchCloudMessages', [jsParams]);
      if (result != null && result.isA<JSArray>()) {
        final msgList = formatV2MessageList(result as JSArray);
        final messages = msgList.map((m) => NIMMessage.fromJson(m)).toList();
        return NIMResult<List<NIMMessage>>.fromMap(
          {
            'code': 0,
            'data': {'messageList': messages.map((m) => m.toJson()).toList()},
          },
          convert: (data) {
            final list = (data as Map<String, dynamic>)['messageList'] as List;
            return list
                .map(
                  (e) =>
                      NIMMessage.fromJson((e as Map).cast<String, dynamic>()),
                )
                .toList();
          },
        );
      }
      return NIMResult<List<NIMMessage>>.fromMap({
        'code': 0,
        'data': {'messageList': []},
      }, convert: (data) => <NIMMessage>[]);
    } catch (e) {
      return convertJSErrorToNIMResult<List<NIMMessage>>(e);
    }
  }

  @override
  Future<NIMResult<NIMMessageSearchResult>> searchCloudMessagesEx(
    NIMMessageSearchExParams params,
  ) async {
    try {
      final jsParams = dartMapToJsObject(params.toJson());
      final result = await _callJSAsync('searchCloudMessagesEx', [jsParams]);
      if (result != null && result.isA<JSObject>()) {
        final resultMap =
            formatV2SearchResult(jsObjectToMap(result as JSObject));
        return NIMResult<NIMMessageSearchResult>.fromMap(
          {'code': 0, 'data': resultMap},
          convert: (data) =>
              NIMMessageSearchResult.fromJson(data as Map<String, dynamic>),
        );
      }
      return NIMResult<NIMMessageSearchResult>.fromMap({'code': 0});
    } catch (e) {
      return convertJSErrorToNIMResult<NIMMessageSearchResult>(e);
    }
  }

  @override
  Future<NIMResult<NIMThreadMessageListResult>> getLocalThreadMessageList({
    required NIMMessageRefer messageRefer,
  }) async {
    return NIMResult<NIMThreadMessageListResult>.fromMap({
      'code': -1,
      'errorDetails': 'getLocalThreadMessageList is not supported on Web',
    });
  }

  @override
  Future<NIMResult<NIMThreadMessageListResult>> getThreadMessageList({
    required NIMThreadMessageListOption threadMessageListOption,
  }) async {
    try {
      final jsOption = dartMapToJsObject(threadMessageListOption.toJson());
      final result = await _callJSAsync('getThreadMessageList', [jsOption]);
      if (result != null && result.isA<JSObject>()) {
        final resultMap = jsObjectToMap(result as JSObject);
        // 格式化嵌套的 message 字段
        final msg = resultMap['message'];
        if (msg is Map<String, dynamic>) {
          _injectMessageType(msg);
        }
        return NIMResult<NIMThreadMessageListResult>.fromMap(
          {'code': 0, 'data': resultMap},
          convert: (data) {
            return NIMThreadMessageListResult.fromJson(
              data as Map<String, dynamic>,
            );
          },
        );
      }
      return NIMResult<NIMThreadMessageListResult>.fromMap({
        'code': -1,
        'errorDetails': 'getThreadMessageList returned null',
      });
    } catch (e) {
      return convertJSErrorToNIMResult<NIMThreadMessageListResult>(e);
    }
  }

  @override
  Future<NIMResult<NIMMessage>> insertMessageToLocal({
    required NIMMessage message,
    required String conversationId,
    String? senderId,
    int? createTime,
  }) async {
    return NIMResult<NIMMessage>.fromMap({
      'code': -1,
      'errorDetails': 'insertMessageToLocal is not supported on Web',
    });
  }

  @override
  Future<NIMResult<NIMMessage>> insertMessageToLocalEx({
    required NIMMessage message,
    required V2NIMMessageInsertParams params,
  }) async {
    return NIMResult<NIMMessage>.fromMap({
      'code': 199414,
      'errorDetails': 'insertMessageToLocalEx is not supported on Web',
    });
  }

  @override
  Future<NIMResult<NIMMessage>> updateMessageLocalExtension({
    required NIMMessage message,
    required String localExtension,
  }) async {
    return NIMResult<NIMMessage>.fromMap({
      'code': -1,
      'errorDetails': 'updateMessageLocalExtension is not supported on Web',
    });
  }

  @override
  Future<NIMResult<void>> revokeMessage({
    required NIMMessage message,
    NIMMessageRevokeParams? revokeParams,
  }) async {
    try {
      final jsMessage = dartMapToJsObject(message.toJson());
      // revokeParams 是 Web SDK 可选参数，为 null 时必须省略，不能传 null
      final List<JSAny?> args = [jsMessage];
      if (revokeParams != null) {
        args.add(dartMapToJsObject(revokeParams.toJson()));
      }
      await _callJSAsync('revokeMessage', args);
      return NIMResult<void>.fromMap({'code': 0});
    } catch (e) {
      return convertJSErrorToNIMResult<void>(e);
    }
  }

  @override
  Future<NIMResult<void>> pinMessage({
    required NIMMessage message,
    String? serverExtension,
  }) async {
    try {
      final jsMessage = dartMapToJsObject(message.toJson());
      // serverExtension 是 Web SDK 可选参数，为 null 时必须省略，不能传 null
      final args = serverExtension != null
          ? [jsMessage, serverExtension.toJS]
          : [jsMessage];
      await _callJSAsync('pinMessage', args);
      return NIMResult<void>.fromMap({'code': 0});
    } catch (e) {
      return convertJSErrorToNIMResult<void>(e);
    }
  }

  @override
  Future<NIMResult<void>> unpinMessage({
    required NIMMessageRefer messageRefer,
    String? serverExtension,
  }) async {
    try {
      final jsRefer = dartMapToJsObject(messageRefer.toJson());
      // serverExtension 是 Web SDK 可选参数，为 null 时必须省略，不能传 null
      final args =
          serverExtension != null ? [jsRefer, serverExtension.toJS] : [jsRefer];
      await _callJSAsync('unpinMessage', args);
      return NIMResult<void>.fromMap({'code': 0});
    } catch (e) {
      return convertJSErrorToNIMResult<void>(e);
    }
  }

  @override
  Future<NIMResult<void>> updatePinMessage({
    required NIMMessage message,
    String? serverExtension,
  }) async {
    try {
      final jsMessage = dartMapToJsObject(message.toJson());
      // serverExtension 是 Web SDK 可选参数，为 null 时必须省略，不能传 null
      final args = serverExtension != null
          ? [jsMessage, serverExtension.toJS]
          : [jsMessage];
      await _callJSAsync('updatePinMessage', args);
      return NIMResult<void>.fromMap({'code': 0});
    } catch (e) {
      return convertJSErrorToNIMResult<void>(e);
    }
  }

  @override
  Future<NIMResult<List<NIMMessagePin>>> getPinnedMessageList({
    required String conversationId,
  }) async {
    try {
      final result = await _callJSAsync('getPinnedMessageList', [
        conversationId.toJS,
      ]);
      if (result != null && result.isA<JSArray>()) {
        final list = jsArrayToMapList(result as JSArray);
        final pins = list
            .map((m) => NIMMessagePin.fromJson(formatV2MessagePin(m)))
            .toList();
        return NIMResult<List<NIMMessagePin>>.fromMap(
          {
            'code': 0,
            'data': {'pinMessages': pins.map((p) => p.toJson()).toList()},
          },
          convert: (data) {
            final l = (data as Map<String, dynamic>)['pinMessages'] as List;
            return l
                .map(
                  (e) => NIMMessagePin.fromJson(
                    (e as Map).cast<String, dynamic>(),
                  ),
                )
                .toList();
          },
        );
      }
      return NIMResult<List<NIMMessagePin>>.fromMap({
        'code': 0,
        'data': {'pinMessages': []},
      }, convert: (data) => <NIMMessagePin>[]);
    } catch (e) {
      return convertJSErrorToNIMResult<List<NIMMessagePin>>(e);
    }
  }

  @override
  Future<NIMResult<void>> addQuickComment({
    required NIMMessage message,
    required int index,
    String? serverExtension,
    NIMMessageQuickCommentPushConfig? pushConfig,
  }) async {
    try {
      final jsMessage = dartMapToJsObject(message.toJson());
      JSAny? jsPushConfig;
      if (pushConfig != null) {
        jsPushConfig = dartMapToJsObject(pushConfig.toJson());
      }
      // serverExtension 和 jsPushConfig 均为 Web SDK 可选参数，为 null 时必须省略
      final List<JSAny?> args = [jsMessage, index.toJS];
      if (serverExtension != null) args.add(serverExtension.toJS);
      if (jsPushConfig != null) args.add(jsPushConfig);
      await _callJSAsync('addQuickComment', args);
      return NIMResult<void>.fromMap({'code': 0});
    } catch (e) {
      return convertJSErrorToNIMResult<void>(e);
    }
  }

  @override
  Future<NIMResult<void>> removeQuickComment({
    required NIMMessageRefer messageRefer,
    required int index,
    String? serverExtension,
  }) async {
    try {
      final jsRefer = dartMapToJsObject(messageRefer.toJson());
      // serverExtension 是 Web SDK 可选参数，为 null 时必须省略，不能传 null
      final args = serverExtension != null
          ? [jsRefer, index.toJS, serverExtension.toJS]
          : [jsRefer, index.toJS];
      await _callJSAsync('removeQuickComment', args);
      return NIMResult<void>.fromMap({'code': 0});
    } catch (e) {
      return convertJSErrorToNIMResult<void>(e);
    }
  }

  @override
  Future<NIMResult<Map<String, List<NIMMessageQuickComment>?>>>
      getQuickCommentList({required List<NIMMessage> messages}) async {
    try {
      final jsMessages = messages.map((m) => m.toJson()).toList().jsify();
      final result = await _callJSAsync('getQuickCommentList', [
        jsMessages as JSAny,
      ]);
      if (result != null && result.isA<JSObject>()) {
        final resultMap = jsObjectToMap(result as JSObject);
        final Map<String, List<NIMMessageQuickComment>?> commentMap = {};
        resultMap.forEach((key, value) {
          if (value is List) {
            commentMap[key] = value
                .map(
                  (item) => NIMMessageQuickComment.fromJson(
                    formatV2QuickComment((item as Map).cast<String, dynamic>()),
                  ),
                )
                .toList();
          } else {
            commentMap[key] = null;
          }
        });
        return NIMResult<Map<String, List<NIMMessageQuickComment>?>>.fromMap({
          'code': 0,
          'data': resultMap,
        }, convert: (data) => commentMap);
      }
      return NIMResult<Map<String, List<NIMMessageQuickComment>?>>.fromMap({
        'code': 0,
        'data': {},
      }, convert: (data) => <String, List<NIMMessageQuickComment>?>{});
    } catch (e) {
      return convertJSErrorToNIMResult<
          Map<String, List<NIMMessageQuickComment>?>>(e);
    }
  }

  @override
  Future<NIMResult<void>> deleteMessage({
    required NIMMessage message,
    String? serverExtension,
    bool? onlyDeleteLocal,
  }) async {
    try {
      final jsMessage = dartMapToJsObject(message.toJson());
      // serverExtension 是 Web SDK 可选参数，为 null 时必须省略，不能传 null
      final args = serverExtension != null
          ? [jsMessage, serverExtension.toJS]
          : [jsMessage];
      await _callJSAsync('deleteMessage', args);
      return NIMResult<void>.fromMap({'code': 0});
    } catch (e) {
      return convertJSErrorToNIMResult<void>(e);
    }
  }

  @override
  Future<NIMResult<void>> deleteMessages({
    required List<NIMMessage> messages,
    String? serverExtension,
    bool? onlyDeleteLocal,
  }) async {
    try {
      final jsMessages = messages.map((m) => m.toJson()).toList().jsify();
      // serverExtension 是 Web SDK 可选参数，为 null 时必须省略，不能传 null
      final List<JSAny?> args = [jsMessages as JSAny];
      if (serverExtension != null) args.add(serverExtension.toJS);
      await _callJSAsync('deleteMessages', args);
      return NIMResult<void>.fromMap({'code': 0});
    } catch (e) {
      return convertJSErrorToNIMResult<void>(e);
    }
  }

  @override
  Future<NIMResult<void>> clearHistoryMessage({
    required NIMClearHistoryMessageOption option,
  }) async {
    try {
      final jsOption = dartMapToJsObject(option.toJson());
      await _callJSAsync('clearHistoryMessage', [jsOption]);
      return NIMResult<void>.fromMap({'code': 0});
    } catch (e) {
      return convertJSErrorToNIMResult<void>(e);
    }
  }

  @override
  Future<NIMResult<void>> sendP2PMessageReceipt({
    required NIMMessage message,
  }) async {
    try {
      final jsMessage = dartMapToJsObject(message.toJson());
      await _callJSAsync('sendP2PMessageReceipt', [jsMessage]);
      return NIMResult<void>.fromMap({'code': 0});
    } catch (e) {
      return convertJSErrorToNIMResult<void>(e);
    }
  }

  @override
  Future<NIMResult<NIMP2PMessageReadReceipt>> getP2PMessageReceipt({
    required String conversationId,
  }) async {
    try {
      final result = await _callJSAsync('getP2PMessageReceipt', [
        conversationId.toJS,
      ]);
      if (result != null && result.isA<JSObject>()) {
        final map = jsObjectToMap(result as JSObject);
        return NIMResult<NIMP2PMessageReadReceipt>.fromMap(
          {'code': 0, 'data': map},
          convert: (data) {
            return NIMP2PMessageReadReceipt.fromJson(
              data as Map<String, dynamic>,
            );
          },
        );
      }
      return NIMResult<NIMP2PMessageReadReceipt>.fromMap({
        'code': -1,
        'errorDetails': 'getP2PMessageReceipt returned null',
      });
    } catch (e) {
      return convertJSErrorToNIMResult<NIMP2PMessageReadReceipt>(e);
    }
  }

  @override
  Future<NIMResult<bool>> isPeerRead({required NIMMessage message}) async {
    final service = _jsService;
    if (service == null) {
      return NIMResult<bool>.fromMap({
        'code': -1,
        'errorDetails': 'NIM SDK not initialized',
      });
    }

    try {
      final jsMessage = dartMapToJsObject(message.toJson());
      final method = service.getProperty('isPeerRead'.toJS) as JSFunction;
      final result = method.callAsFunction(service, jsMessage);
      final isRead = result != null && result.isA<JSBoolean>()
          ? (result as JSBoolean).toDart
          : false;
      return NIMResult<bool>(0, isRead, null);
    } catch (e) {
      return convertJSErrorToNIMResult<bool>(e);
    }
  }

  @override
  Future<NIMResult<void>> sendTeamMessageReceipts({
    required List<NIMMessage> messages,
  }) async {
    try {
      final jsMessages = messages.map((m) => m.toJson()).toList().jsify();
      await _callJSAsync('sendTeamMessageReceipts', [jsMessages as JSAny]);
      return NIMResult<void>.fromMap({'code': 0});
    } catch (e) {
      return convertJSErrorToNIMResult<void>(e);
    }
  }

  @override
  Future<NIMResult<List<NIMTeamMessageReadReceipt>>> getTeamMessageReceipts({
    required List<NIMMessage> messages,
  }) async {
    try {
      final jsMessages = messages.map((m) => m.toJson()).toList().jsify();
      final result = await _callJSAsync('getTeamMessageReceipts', [
        jsMessages as JSAny,
      ]);
      if (result != null && result.isA<JSArray>()) {
        final list = jsArrayToMapList(result as JSArray);
        final receipts =
            list.map((m) => NIMTeamMessageReadReceipt.fromJson(m)).toList();
        return NIMResult<List<NIMTeamMessageReadReceipt>>.fromMap(
          {
            'code': 0,
            'data': {'readReceipts': receipts.map((r) => r.toJson()).toList()},
          },
          convert: (data) {
            final l = (data as Map<String, dynamic>)['readReceipts'] as List;
            return l
                .map(
                  (e) => NIMTeamMessageReadReceipt.fromJson(
                    (e as Map).cast<String, dynamic>(),
                  ),
                )
                .toList();
          },
        );
      }
      return NIMResult<List<NIMTeamMessageReadReceipt>>.fromMap({
        'code': 0,
        'data': {'readReceipts': []},
      }, convert: (data) => <NIMTeamMessageReadReceipt>[]);
    } catch (e) {
      return convertJSErrorToNIMResult<List<NIMTeamMessageReadReceipt>>(e);
    }
  }

  @override
  Future<NIMResult<NIMTeamMessageReadReceiptDetail>>
      getTeamMessageReceiptDetail({
    required NIMMessage message,
    Set<String>? memberAccountIds,
  }) async {
    try {
      final jsMessage = dartMapToJsObject(message.toJson());
      // memberAccountIds 是 Web SDK 可选参数，为 null/空 时必须省略，不能传 null
      final List<JSAny?> args = [jsMessage];
      if (memberAccountIds != null && memberAccountIds.isNotEmpty) {
        args.add(memberAccountIds.toList().jsify());
      }
      final result = await _callJSAsync('getTeamMessageReceiptDetail', args);
      if (result != null && result.isA<JSObject>()) {
        final map = jsObjectToMap(result as JSObject);
        return NIMResult<NIMTeamMessageReadReceiptDetail>.fromMap(
          {'code': 0, 'data': map},
          convert: (data) {
            return NIMTeamMessageReadReceiptDetail.fromJson(
              data as Map<String, dynamic>,
            );
          },
        );
      }
      return NIMResult<NIMTeamMessageReadReceiptDetail>.fromMap({
        'code': -1,
        'errorDetails': 'getTeamMessageReceiptDetail returned null',
      });
    } catch (e) {
      return convertJSErrorToNIMResult<NIMTeamMessageReadReceiptDetail>(e);
    }
  }

  @override
  Future<NIMResult<NIMCollection>> addCollection({
    required NIMAddCollectionParams params,
  }) async {
    try {
      final jsParams = dartMapToJsObject(params.toJson());
      final result = await _callJSAsync('addCollection', [jsParams]);
      if (result != null && result.isA<JSObject>()) {
        final map = jsObjectToMap(result as JSObject);
        return NIMResult<NIMCollection>.fromMap(
          {'code': 0, 'data': map},
          convert: (data) {
            return NIMCollection.fromJson(data as Map<String, dynamic>);
          },
        );
      }
      return NIMResult<NIMCollection>.fromMap({
        'code': -1,
        'errorDetails': 'addCollection returned null',
      });
    } catch (e) {
      return convertJSErrorToNIMResult<NIMCollection>(e);
    }
  }

  @override
  Future<NIMResult<int>> removeCollections({
    required List<NIMCollection> collections,
  }) async {
    try {
      final jsCollections = collections.map((c) => c.toJson()).toList().jsify();
      final result = await _callJSAsync('removeCollections', [
        jsCollections as JSAny,
      ]);
      final count = result != null && result.isA<JSNumber>()
          ? (result as JSNumber).toDartInt
          : 0;
      return NIMResult<int>(0, count, null);
    } catch (e) {
      return convertJSErrorToNIMResult<int>(e);
    }
  }

  @override
  Future<NIMResult<NIMCollection>> updateCollectionExtension({
    required NIMCollection collection,
    String? serverExtension,
  }) async {
    try {
      final jsCollection = dartMapToJsObject(collection.toJson());
      // serverExtension 是 Web SDK 的可选参数（serverExtension?: string）
      // 当不传时必须省略该参数，而非传 null，否则 JS 侧会报错
      final args = serverExtension != null
          ? [jsCollection, serverExtension.toJS]
          : [jsCollection];
      final result = await _callJSAsync('updateCollectionExtension', args);
      if (result != null && result.isA<JSObject>()) {
        final map = jsObjectToMap(result as JSObject);
        return NIMResult<NIMCollection>.fromMap(
          {'code': 0, 'data': map},
          convert: (data) {
            return NIMCollection.fromJson(data as Map<String, dynamic>);
          },
        );
      }
      return NIMResult<NIMCollection>.fromMap({
        'code': -1,
        'errorDetails': 'updateCollectionExtension returned null',
      });
    } catch (e) {
      return convertJSErrorToNIMResult<NIMCollection>(e);
    }
  }

  @override
  Future<NIMResult<List<NIMCollection>>> getCollectionListByOption({
    required NIMCollectionOption option,
  }) async {
    try {
      final jsOption = dartMapToJsObject(option.toJson());
      final result = await _callJSAsync('getCollectionListByOption', [
        jsOption,
      ]);
      if (result != null && result.isA<JSArray>()) {
        final list = jsArrayToMapList(result as JSArray);
        final collections = list.map((m) => NIMCollection.fromJson(m)).toList();
        return NIMResult<List<NIMCollection>>.fromMap(
          {
            'code': 0,
            'data': {
              'collections': collections.map((c) => c.toJson()).toList(),
            },
          },
          convert: (data) {
            final l = (data as Map<String, dynamic>)['collections'] as List;
            return l
                .map(
                  (e) => NIMCollection.fromJson(
                    (e as Map).cast<String, dynamic>(),
                  ),
                )
                .toList();
          },
        );
      }
      return NIMResult<List<NIMCollection>>.fromMap({
        'code': 0,
        'data': {'collections': []},
      }, convert: (data) => <NIMCollection>[]);
    } catch (e) {
      return convertJSErrorToNIMResult<List<NIMCollection>>(e);
    }
  }

  @override
  Future<NIMResult<String>> voiceToText({
    required NIMVoiceToTextParams params,
  }) async {
    try {
      final jsParams = dartMapToJsObject(params.toJson());
      final result = await _callJSAsync('voiceToText', [jsParams]);
      final text = result != null && result.isA<JSString>()
          ? (result as JSString).toDart
          : '';
      return NIMResult<String>(0, text, null);
    } catch (e) {
      return convertJSErrorToNIMResult<String>(e);
    }
  }

  @override
  Future<NIMResult<void>> cancelMessageAttachmentUpload({
    required NIMMessage message,
  }) async {
    try {
      final jsMessage = dartMapToJsObject(message.toJson());
      await _callJSAsync('cancelMessageAttachmentUpload', [jsMessage]);
      return NIMResult<void>.fromMap({'code': 0});
    } catch (e) {
      return convertJSErrorToNIMResult<void>(e);
    }
  }

  @override
  Future<NIMResult<NIMTextTranslationResult>> translateText({
    required NIMTextTranslateParams params,
    NIMTranslatorConfig? config,
  }) async {
    try {
      final jsParams = dartMapToJsObject(params.toJson());
      final jsConfig =
          config != null ? dartMapToJsObject(config.toJson()) : null;
      final result = await _callJSAsync('translateText', [
        jsParams,
        if (jsConfig != null) jsConfig,
      ]);
      final resultMap = result != null && result.isA<JSObject>()
          ? jsObjectToMap(result as JSObject)
          : <String, dynamic>{};
      return NIMResult<NIMTextTranslationResult>.fromMap(
        {'code': 0, 'data': resultMap},
        convert: (data) =>
            NIMTextTranslationResult.fromJson((data as Map).cast()),
      );
    } catch (e) {
      return convertJSErrorToNIMResult<NIMTextTranslationResult>(e);
    }
  }

  @override
  Future<NIMResult<void>> regenAIMessage(
    NIMMessage message,
    NIMMessageAIRegenParams params,
  ) async {
    try {
      final jsMessage = dartMapToJsObject(message.toJson());
      final jsParams = dartMapToJsObject(params.toJson());
      await _callJSAsync('regenAIMessage', [jsMessage, jsParams]);
      return NIMResult<void>.fromMap({'code': 0});
    } catch (e) {
      return convertJSErrorToNIMResult<void>(e);
    }
  }

  @override
  Future<NIMResult<NIMModifyMessageResult>> modifyMessage(
    NIMMessage message,
    NIMModifyMessageParams params,
  ) async {
    try {
      final jsMessage = dartMapToJsObject(message.toJson());
      final jsParams = dartMapToJsObject(params.toJson());
      final result = await _callJSAsync('modifyMessage', [jsMessage, jsParams]);
      if (result != null && result.isA<JSObject>()) {
        final map = jsObjectToMap(result as JSObject) as Map<String, dynamic>;
        return NIMResult<NIMModifyMessageResult>.fromMap({
          'code': 0,
          'data': map,
        }, convert: (d) => NIMModifyMessageResult.fromJson(d));
      }
      return NIMResult<NIMModifyMessageResult>.fromMap({'code': 0});
    } catch (e) {
      return convertJSErrorToNIMResult<NIMModifyMessageResult>(e);
    }
  }

  @override
  Future<NIMResult<void>> stopAIStreamMessage(
    NIMMessage message,
    NIMMessageAIStreamStopParams params,
  ) async {
    try {
      final jsMessage = dartMapToJsObject(message.toJson());
      final jsParams = dartMapToJsObject(params.toJson());
      await _callJSAsync('stopAIStreamMessage', [jsMessage, jsParams]);
      return NIMResult<void>.fromMap({'code': 0});
    } catch (e) {
      return convertJSErrorToNIMResult<void>(e);
    }
  }

  @override
  Future<NIMResult<void>> setMessageFilter(NIMMessageFilter? filter) async {
    shouldIgnore = filter;
    return NIMResult<void>.fromMap({'code': 0});
  }

  @override
  Future<NIMResult<NIMMessageListResult>> getMessageListEx(
    NIMMessageListOption option,
  ) async {
    try {
      final jsOption = dartMapToJsObject(option.toJson());
      final result = await _callJSAsync('getMessageList', [jsOption]);
      final List<NIMMessage> messages = [];
      if (result != null && result.isA<JSArray>()) {
        final arr = (result as JSArray).toDart;
        for (final item in arr) {
          if (item != null && item.isA<JSObject>()) {
            final map = jsObjectToMap(item as JSObject) as Map<String, dynamic>;
            messages.add(NIMMessage.fromJson(map));
          }
        }
      }
      final listResult = NIMMessageListResult(messages: messages);
      return NIMResult<NIMMessageListResult>.fromMap({
        'code': 0,
        'data': listResult.toJson(),
      }, convert: (_) => listResult);
    } catch (e) {
      return convertJSErrorToNIMResult<NIMMessageListResult>(e);
    }
  }

  @override
  Future<NIMResult<NIMCollectionListResult>> getCollectionListExByOption(
    NIMCollectionOption option,
  ) async {
    try {
      final jsOption = dartMapToJsObject(option.toJson());
      final result = await _callJSAsync('getCollectionListExByOption', [
        jsOption,
      ]);
      if (result != null && result.isA<JSObject>()) {
        final map = jsObjectToMap(result as JSObject) as Map<String, dynamic>;
        return NIMResult<NIMCollectionListResult>.fromMap({
          'code': 0,
          'data': map,
        }, convert: (d) => NIMCollectionListResult.fromJson(d));
      }
      return NIMResult<NIMCollectionListResult>.fromMap({'code': 0});
    } catch (e) {
      return convertJSErrorToNIMResult<NIMCollectionListResult>(e);
    }
  }

  @override
  Future<NIMResult<void>> clearRoamingMessage({
    required List<String> conversationIds,
  }) async {
    try {
      final jsIds = conversationIds.map((id) => id.toJS).toList().toJS;
      await _callJSAsync('clearRoamingMessage', [jsIds]);
      return NIMResult<void>.fromMap({'code': 0});
    } catch (e) {
      return convertJSErrorToNIMResult<void>(e);
    }
  }

  @override
  Future<NIMResult<String>> messageSerialization(NIMMessage message) async {
    final converter = _jsConverterService;
    if (converter == null) {
      return NIMResult<String>.failure(
        code: NIMResultCode.fail,
        message: 'NIM SDK not initialized or V2NIMMessageConverter unavailable',
      );
    }
    try {
      // V2NIMMessageConverter.messageSerialization 是同步方法
      // JS 签名: messageSerialization(message: V2NIMMessage): string
      final jsMessage = dartMapToJsObject(message.toJson());
      final method =
          converter.getProperty('messageSerialization'.toJS) as JSFunction;
      final result = method.callAsFunction(converter, jsMessage);
      if (result != null && result.isA<JSString>()) {
        return NIMResult<String>.success(data: (result as JSString).toDart);
      }
      return NIMResult<String>.failure(
        code: NIMResultCode.fail,
        message: 'messageSerialization returned unexpected result',
      );
    } catch (e) {
      return convertJSErrorToNIMResult<String>(e);
    }
  }

  @override
  Future<NIMResult<NIMMessage>> messageDeserialization(String msg) async {
    final converter = _jsConverterService;
    if (converter == null) {
      return NIMResult<NIMMessage>.failure(
        code: NIMResultCode.fail,
        message: 'NIM SDK not initialized or V2NIMMessageConverter unavailable',
      );
    }
    try {
      // V2NIMMessageConverter.messageDeserialization 是同步方法
      // JS 签名: messageDeserialization(msg: string): V2NIMMessage
      final method =
          converter.getProperty('messageDeserialization'.toJS) as JSFunction;
      final result = method.callAsFunction(converter, msg.toJS);
      if (result != null && result.isA<JSObject>()) {
        final msgMap = formatV2Message(result as JSObject);
        return NIMResult<NIMMessage>.success(data: NIMMessage.fromJson(msgMap));
      }
      return NIMResult<NIMMessage>.failure(
        code: NIMResultCode.fail,
        message: 'messageDeserialization returned unexpected result',
      );
    } catch (e) {
      return convertJSErrorToNIMResult<NIMMessage>(e);
    }
  }

  @override
  Future<NIMResult<NIMMessageSearchResult>> searchLocalMessages(
    NIMMessageSearchExParams params,
  ) async {
    return NIMResult<NIMMessageSearchResult>.failure(
      code: NIMResultCode.fail,
      message: 'Web platform does not support this API',
    );
  }

  @override
  Future<NIMResult<NIMMessage>> updateLocalMessage(
    NIMMessage message,
    NIMUpdateLocalMessageParams params,
  ) async {
    return NIMResult<NIMMessage>.failure(
      code: NIMResultCode.fail,
      message: 'Web platform does not support this API',
    );
  }

  @override
  Future<NIMResult<void>> clearLocalMessage(
    NIMClearLocalMessageParams? params,
  ) async {
    return NIMResult<void>.failure(
      code: NIMResultCode.fail,
      message: 'Web platform does not support this API',
    );
  }

  /// 在消息的 attachment 中注入 nimCoreMessageType
  void _injectMessageType(Map<String, dynamic> messageMap) {
    final attachment = messageMap['attachment'];
    if (attachment is Map<String, dynamic>) {
      attachment['nimCoreMessageType'] = messageMap['messageType'];
    }
  }
}
