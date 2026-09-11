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
import '../js_interop/nim_sdk.dart';
import 'web_initialize_service.dart';

/// Web 端存储服务实现
class WebStorageService extends StorageServicePlatform {
  JSObject? _jsService;

  final _uploadProgressController =
      StreamController<NIMUploadFileProgress>.broadcast();
  final _downloadProgressController =
      StreamController<NIMDownloadFileProgress>.broadcast();
  final _attachmentProgressController =
      StreamController<NIMDownloadMessageAttachmentProgress>.broadcast();

  WebStorageService() {
    WebInitializeService.registerOnInit(_onNimInit);
    WebInitializeService.registerOnRelease(_onNimRelease);
  }

  void _onNimInit(JSV2NIM nim) {
    final svc = (nim as JSObject).getProperty('V2NIMStorageService'.toJS);
    if (svc != null && svc.isA<JSObject>()) {
      _jsService = svc as JSObject;
    }
  }

  void _onNimRelease() {
    _jsService = null;
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
  String get serviceName => 'StorageService';
  @override
  Future<dynamic> onEvent(String method, dynamic arguments) async => null;

  @override
  Stream<NIMUploadFileProgress> get onFileUploadProgress =>
      _uploadProgressController.stream;

  @override
  Stream<NIMDownloadFileProgress> get onFileDownloadProgress =>
      _downloadProgressController.stream;

  @override
  Stream<NIMDownloadMessageAttachmentProgress>
      get onMessageAttachmentDownloadProgress =>
          _attachmentProgressController.stream;

  @override
  Future<NIMResult<NIMStorageScene>> addCustomStorageScene(
    String sceneName,
    int expireTime, {
    int? instanceId,
  }) async {
    final s = _jsService;
    if (s == null)
      return NIMResult<NIMStorageScene>.fromMap({
        'code': -1,
        'errorDetails': 'NIM SDK not initialized',
      });
    try {
      final method = s.getProperty('addCustomStorageScene'.toJS) as JSFunction;
      final result = method.callAsFunction(s, sceneName.toJS, expireTime.toJS);
      if (result != null && result.isA<JSObject>()) {
        final map = jsObjectToMap(result as JSObject);
        return NIMResult<NIMStorageScene>.fromMap({
          'code': 0,
          'data': map,
        }, convert: (d) => NIMStorageScene.fromJson(d as Map<String, dynamic>));
      }
      return NIMResult<NIMStorageScene>.fromMap({
        'code': -1,
        'errorDetails': 'addCustomStorageScene returned null',
      });
    } catch (e) {
      return convertJSErrorToNIMResult<NIMStorageScene>(e);
    }
  }

  @override
  Future<NIMResult<NIMUploadFileTask>> createUploadFileTask(
    NIMUploadFileParams fileParams, {
    html.File? fileObj,
    int? instanceId,
  }) async {
    final s = _jsService;
    if (s == null)
      return NIMResult<NIMUploadFileTask>.fromMap({
        'code': -1,
        'errorDetails': 'NIM SDK not initialized',
      });
    try {
      final paramsMap = fileParams.toJson();
      if (fileObj != null) {
        paramsMap['fileObj'] = fileObj;
      }
      final method = s.getProperty('createUploadFileTask'.toJS) as JSFunction;
      final jsParams = dartMapToJsObject(paramsMap);
      final result = method.callAsFunction(s, jsParams);
      if (result != null && result.isA<JSObject>()) {
        final map = jsObjectToMap(result as JSObject);
        return NIMResult<NIMUploadFileTask>.fromMap(
          {'code': 0, 'data': map},
          convert: (d) => NIMUploadFileTask.fromJson(d as Map<String, dynamic>),
        );
      }
      return NIMResult<NIMUploadFileTask>.fromMap({
        'code': -1,
        'errorDetails': 'createUploadFileTask returned null',
      });
    } catch (e) {
      return convertJSErrorToNIMResult<NIMUploadFileTask>(e);
    }
  }

  @override
  Future<NIMResult<String>> uploadFile(
    NIMUploadFileTask fileTask, {
    html.File? fileObj,
    int? instanceId,
  }) async {
    final s = _jsService;
    if (s == null)
      return NIMResult<String>.fromMap({
        'code': -1,
        'errorDetails': 'NIM SDK not initialized',
      });
    try {
      final taskMap = fileTask.toJson();
      if (fileObj != null) {
        if (taskMap['uploadParams'] is Map) {
          (taskMap['uploadParams'] as Map)['fileObj'] = fileObj;
        }
      }
      final jsTask = dartMapToJsObject(taskMap);

      // 上传进度回调
      final progressCb = ((JSNumber progress) {
        _uploadProgressController.add(
          NIMUploadFileProgress.fromJson({
            'taskId': fileTask.taskId ?? '',
            'progress': progress.toDartInt,
          }),
        );
      }).toJS;

      final method = s.getProperty('uploadFile'.toJS) as JSFunction;
      final applyFn = method.getProperty('apply'.toJS) as JSFunction;
      final r = applyFn.callAsFunction(method, s, [jsTask, progressCb].toJS);
      String? url;
      if (r != null && r.isA<JSPromise>()) {
        final result = await (r as JSPromise).toDart;
        if (result != null && result.isA<JSString>()) {
          url = (result as JSString).toDart;
        }
      }
      return NIMResult<String>(0, url ?? '', null);
    } catch (e) {
      return convertJSErrorToNIMResult<String>(e);
    }
  }

  @override
  Future<NIMResult<void>> cancelUploadFile(
    NIMUploadFileTask fileTask, {
    int? instanceId,
  }) async {
    try {
      final jsTask = dartMapToJsObject(fileTask.toJson());
      await _callJSAsync('cancelUploadFile', [jsTask]);
      return NIMResult<void>.fromMap({'code': 0});
    } catch (e) {
      return convertJSErrorToNIMResult<void>(e);
    }
  }

  @override
  Future<NIMResult<List<NIMStorageScene>>> getStorageSceneList({
    int? instanceId,
  }) async {
    final s = _jsService;
    if (s == null)
      return NIMResult<List<NIMStorageScene>>.fromMap({
        'code': -1,
        'errorDetails': 'NIM SDK not initialized',
      });
    try {
      final method = s.getProperty('getStorageSceneList'.toJS) as JSFunction;
      final result = method.callAsFunction(s);
      if (result != null && result.isA<JSArray>()) {
        final arr = (result as JSArray).toDart;
        final list = arr
            .where((i) => i != null && i.isA<JSObject>())
            .map(
              (i) => NIMStorageScene.fromJson(
                jsObjectToMap(i! as JSObject) as Map<String, dynamic>,
              ),
            )
            .toList();
        return NIMResult<List<NIMStorageScene>>.fromMap({
          'code': 0,
          'data': {'sceneList': list.map((s) => s.toJson()).toList()},
        }, convert: (d) => list);
      }
      return NIMResult<List<NIMStorageScene>>.fromMap({
        'code': 0,
        'data': {'sceneList': []},
      }, convert: (_) => <NIMStorageScene>[]);
    } catch (e) {
      return convertJSErrorToNIMResult<List<NIMStorageScene>>(e);
    }
  }

  @override
  Future<NIMResult<String>> shortUrlToLong(
    String url, {
    int? instanceId,
  }) async {
    try {
      final result = await _callJSAsync('shortUrlToLong', [url.toJS]);
      String longUrl = '';
      if (result != null && result.isA<JSString>()) {
        longUrl = (result as JSString).toDart;
      }
      return NIMResult<String>(0, longUrl, null);
    } catch (e) {
      return convertJSErrorToNIMResult<String>(e);
    }
  }

  @override
  Future<NIMResult<String>> downloadFile(
    String url,
    String filePath, {
    int? instanceId,
  }) async {
    return NIMResult<String>.fromMap({
      'code': -1,
      'errorDetails': 'downloadFile is not supported on Web',
    });
  }

  @override
  Future<NIMResult<String>> downloadAttachment(
    NIMDownloadMessageAttachmentParams downloadParam, {
    int? instanceId,
  }) async {
    return NIMResult<String>.fromMap({
      'code': -1,
      'errorDetails': 'downloadAttachment is not supported on Web',
    });
  }

  @override
  Future<NIMResult<NIMGetMediaResourceInfoResult>> getImageThumbUrl(
    NIMMessageAttachment attachment,
    NIMSize thumbSize, {
    int? instanceId,
  }) async {
    try {
      final jsAttachment = dartMapToJsObject(attachment.toJson());
      final jsThumbSize = dartMapToJsObject(thumbSize.toJson());
      final result = await _callJSAsync('getImageThumbUrl', [
        jsAttachment,
        jsThumbSize,
      ]);
      if (result != null && result.isA<JSObject>()) {
        final map = jsObjectToMap(result as JSObject);
        return NIMResult<NIMGetMediaResourceInfoResult>.fromMap(
          {'code': 0, 'data': map},
          convert: (d) => NIMGetMediaResourceInfoResult.fromJson(
            d as Map<String, dynamic>,
          ),
        );
      }
      return NIMResult<NIMGetMediaResourceInfoResult>.fromMap({
        'code': -1,
        'errorDetails': 'getImageThumbUrl returned null',
      });
    } catch (e) {
      return convertJSErrorToNIMResult<NIMGetMediaResourceInfoResult>(e);
    }
  }

  @override
  Future<NIMResult<NIMGetMediaResourceInfoResult>> getVideoCoverUrl(
    NIMMessageAttachment attachment,
    NIMSize thumbSize, {
    int? instanceId,
  }) async {
    try {
      final jsAttachment = dartMapToJsObject(attachment.toJson());
      final jsThumbSize = dartMapToJsObject(thumbSize.toJson());
      final result = await _callJSAsync('getVideoCoverUrl', [
        jsAttachment,
        jsThumbSize,
      ]);
      if (result != null && result.isA<JSObject>()) {
        final map = jsObjectToMap(result as JSObject);
        return NIMResult<NIMGetMediaResourceInfoResult>.fromMap(
          {'code': 0, 'data': map},
          convert: (d) => NIMGetMediaResourceInfoResult.fromJson(
            d as Map<String, dynamic>,
          ),
        );
      }
      return NIMResult<NIMGetMediaResourceInfoResult>.fromMap({
        'code': -1,
        'errorDetails': 'getVideoCoverUrl returned null',
      });
    } catch (e) {
      return convertJSErrorToNIMResult<NIMGetMediaResourceInfoResult>(e);
    }
  }

  @override
  Future<NIMResult<String>> imageThumbUrl(
    String url,
    int thumbSize, {
    int? instanceId,
  }) async {
    return NIMResult<String>.fromMap({
      'code': -1,
      'errorDetails': 'imageThumbUrl is not supported on Web',
    });
  }

  @override
  Future<NIMResult<String>> videoCoverUrl(
    String url,
    int offset,
    int? thumbSize,
    String? type, {
    int? instanceId,
  }) async {
    return NIMResult<String>.fromMap({
      'code': -1,
      'errorDetails': 'videoCoverUrl is not supported on Web',
    });
  }
}
