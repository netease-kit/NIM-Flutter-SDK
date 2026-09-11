// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:nim_core_v2_platform_interface/nim_core_v2_platform_interface.dart';
import 'package:universal_html/html.dart' as html;

import '../converters/error_converter.dart';
import '../converters/js_dart_converter.dart';
import '../converters/message_converter.dart';
import '../js_interop/nim_sdk.dart';
import 'web_initialize_service.dart';

/// Web 端消息创建服务实现
/// 缓存原始 JS 消息对象，供 WebMessageService.sendMessage 使用
class WebMessageCreatorService extends MessageCreatorServicePlatform {
  /// 缓存原始 JS 消息对象，key 为 messageClientId
  final Map<String, JSObject> _jsMessageCache = {};

  JSObject? _jsCreator;

  WebMessageCreatorService() {
    WebInitializeService.registerOnInit(_onNimInit);
    WebInitializeService.registerOnRelease(_onNimRelease);
  }

  void _onNimInit(JSV2NIM nim) {
    // V2NIMMessageCreator 是 NIM 实例上的属性
    final creator = (nim as JSObject).getProperty('V2NIMMessageCreator'.toJS);
    if (creator != null && creator.isA<JSObject>()) {
      _jsCreator = creator as JSObject;
    }
  }

  void _onNimRelease() {
    _jsMessageCache.clear();
    _jsCreator = null;
  }

  /// 获取缓存的 JS 消息对象
  JSObject? getCachedJSMessage(String messageClientId) {
    return _jsMessageCache[messageClientId];
  }

  /// 移除缓存的 JS 消息对象
  void removeCachedJSMessage(String messageClientId) {
    _jsMessageCache.remove(messageClientId);
  }

  @override
  String get serviceName => 'MessageCreatorService';

  @override
  Future<dynamic> onEvent(String method, dynamic arguments) async {
    return null;
  }

  /// 通用的创建消息方法
  NIMResult<NIMMessage> _createAndCache(String methodName, List<JSAny?> args) {
    final creator = _jsCreator;
    if (creator == null) {
      return NIMResult<NIMMessage>.fromMap({
        'code': -1,
        'errorDetails': 'NIM SDK not initialized',
      });
    }

    try {
      final method = creator.getProperty(methodName.toJS) as JSFunction;
      // 使用 Function.prototype.apply 传递变长参数
      final jsArgsArray = args.toJS;
      final applyMethod = method.getProperty('apply'.toJS) as JSFunction;
      final jsMsg = applyMethod.callAsFunction(method, creator, jsArgsArray);
      if (jsMsg == null || !jsMsg.isA<JSObject>()) {
        return NIMResult<NIMMessage>.fromMap({
          'code': -1,
          'errorDetails': '$methodName returned null',
        });
      }

      final jsObject = jsMsg as JSObject;
      final map = formatV2Message(jsObject);

      // 获取 messageClientId 并缓存原始 JS 消息对象
      final clientId = map['messageClientId'] as String?;
      if (clientId != null) {
        _jsMessageCache[clientId] = jsObject;
      }

      return NIMResult<NIMMessage>.fromMap(
        {'code': 0, 'data': map},
        convert: (data) {
          return NIMMessage.fromJson(data as Map<String, dynamic>);
        },
      );
    } catch (e) {
      return convertJSErrorToNIMResult<NIMMessage>(e);
    }
  }

  @override
  Future<NIMResult<NIMMessage>> createTextMessage(String text) async {
    return _createAndCache('createTextMessage', [text.toJS]);
  }

  @override
  Future<NIMResult<NIMMessage>> createImageMessage(
    String imagePath,
    String? name,
    String? sceneName,
    int width,
    int height, {
    html.File? imageObj,
  }) async {
    // Web 端使用 File 对象或路径
    final JSAny fileArg =
        imageObj != null ? (imageObj as dynamic) as JSAny : imagePath.toJS;
    // name/sceneName 是 Web SDK 位置型可选参数（param?: string）
    // 只要 name 有值就传，name 为 null 则 sceneName 也跳过
    // width/height 是必选参数，始终传递
    return _createAndCache('createImageMessage', [
      fileArg,
      if (name != null) name.toJS,
      if (name != null && sceneName != null) sceneName.toJS,
      width.toJS,
      height.toJS,
    ]);
  }

  @override
  Future<NIMResult<NIMMessage>> createAudioMessage(
    String audioPath,
    String? name,
    String? sceneName,
    int duration, {
    html.File? audioObj,
  }) async {
    final JSAny fileArg =
        audioObj != null ? (audioObj as dynamic) as JSAny : audioPath.toJS;
    // name/sceneName 是 Web SDK 位置型可选参数（param?: string）
    // 只要 name 有值就传，name 为 null 则 sceneName 也跳过
    return _createAndCache('createAudioMessage', [
      fileArg,
      if (name != null) name.toJS,
      if (name != null && sceneName != null) sceneName.toJS,
      duration.toJS,
    ]);
  }

  @override
  Future<NIMResult<NIMMessage>> createVideoMessage(
    String videoPath,
    String? name,
    String? sceneName,
    int duration,
    int width,
    int height, {
    html.File? videoObj,
  }) async {
    final JSAny fileArg =
        videoObj != null ? (videoObj as dynamic) as JSAny : videoPath.toJS;
    // name/sceneName 是 Web SDK 位置型可选参数（param?: string）
    // 只要 name 有值就传，name 为 null 则 sceneName 也跳过
    return _createAndCache('createVideoMessage', [
      fileArg,
      if (name != null) name.toJS,
      if (name != null && sceneName != null) sceneName.toJS,
      duration.toJS,
      width.toJS,
      height.toJS,
    ]);
  }

  @override
  Future<NIMResult<NIMMessage>> createFileMessage(
    String filePath,
    String? name,
    String? sceneName, {
    html.File? fileObj,
  }) async {
    final JSAny fileArg =
        fileObj != null ? (fileObj as dynamic) as JSAny : filePath.toJS;
    // name/sceneName 是 Web SDK 位置型可选参数（param?: string）
    // 只要 name 有值就传，name 为 null 则 sceneName 也跳过
    return _createAndCache('createFileMessage', [
      fileArg,
      if (name != null) name.toJS,
      if (name != null && sceneName != null) sceneName.toJS,
    ]);
  }

  @override
  Future<NIMResult<NIMMessage>> createLocationMessage(
    double latitude,
    double longitude,
    String address,
  ) async {
    return _createAndCache('createLocationMessage', [
      latitude.toJS,
      longitude.toJS,
      address.toJS,
    ]);
  }

  @override
  Future<NIMResult<NIMMessage>> createCustomMessage(
    String text,
    String rawAttachment,
  ) async {
    return _createAndCache('createCustomMessage', [
      text.toJS,
      rawAttachment.toJS,
    ]);
  }

  @override
  Future<NIMResult<NIMMessage>> createTipsMessage(String text) async {
    return _createAndCache('createTipsMessage', [text.toJS]);
  }

  @override
  Future<NIMResult<NIMMessage?>> createForwardMessage(
    NIMMessage message,
  ) async {
    final creator = _jsCreator;
    if (creator == null) {
      return NIMResult<NIMMessage?>.fromMap({
        'code': -1,
        'errorDetails': 'NIM SDK not initialized',
      });
    }

    try {
      // 尝试从缓存中获取原始 JS 消息
      final cachedJsMsg = _jsMessageCache[message.messageClientId];
      final JSAny jsMessageArg;
      if (cachedJsMsg != null) {
        jsMessageArg = cachedJsMsg;
      } else {
        jsMessageArg = dartMapToJsObject(message.toJson());
      }

      final method =
          creator.getProperty('createForwardMessage'.toJS) as JSFunction;
      final jsMsg = method.callAsFunction(creator, jsMessageArg);
      if (jsMsg == null || !jsMsg.isA<JSObject>()) {
        return NIMResult<NIMMessage?>.fromMap({
          'code': 199001,
          'errorDetails': 'createForwardMessage failed',
        });
      }

      final jsObject = jsMsg as JSObject;
      final map = formatV2Message(jsObject);
      final clientId = map['messageClientId'] as String?;
      if (clientId != null) {
        _jsMessageCache[clientId] = jsObject;
      }

      return NIMResult<NIMMessage?>.fromMap(
        {'code': 0, 'data': map},
        convert: (data) {
          return NIMMessage.fromJson(data as Map<String, dynamic>);
        },
      );
    } catch (e) {
      return convertJSErrorToNIMResult<NIMMessage?>(e);
    }
  }

  @override
  Future<NIMResult<NIMMessage>> createCallMessage(
    int type,
    String channelId,
    int status,
    List<NIMMessageCallDuration>? durations,
    String? text,
  ) async {
    final JSAny? jsDurations = durations != null
        ? durations.map((d) => d.toJson()).toList().jsify()
        : null;
    // jsDurations 和 text 均为 Web SDK 位置型可选参数
    // jsDurations 为 null 则 text 也跳过（因为是顺序参数）
    return _createAndCache('createCallMessage', [
      type.toJS,
      channelId.toJS,
      status.toJS,
      if (jsDurations != null) jsDurations,
      if (jsDurations != null && text != null) text.toJS,
    ]);
  }
}
