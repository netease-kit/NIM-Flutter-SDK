// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:nim_core_v2_platform_interface/nim_core_v2_platform_interface.dart';
import 'package:universal_html/html.dart' as html;

class MethodChannelStorageService extends StorageServicePlatform {
  /// 文件上传进度
  final _uploadFileProgress =
      StreamController<NIMUploadFileProgress>.broadcast();

  /// 文件下载进度
  final _downloadFileProgress =
      StreamController<NIMDownloadFileProgress>.broadcast();

  /// 消息附件下载进度
  final _messageAttachmentDownloadProgress =
      StreamController<NIMDownloadMessageAttachmentProgress>.broadcast();

  @override
  Future onEvent(String method, arguments) {
    switch (method) {
      case 'onFileDownloadProgress':
        assert(arguments is Map);
        _downloadFileProgress.add(NIMDownloadFileProgress.fromJson(
            Map<String, dynamic>.from(arguments)));
        break;
      case 'onFileUploadProgress':
        assert(arguments is Map);
        _uploadFileProgress.add(NIMUploadFileProgress.fromJson(
            Map<String, dynamic>.from(arguments)));
        break;
      case 'onMessageAttachmentDownloadProgress':
        assert(arguments is Map);
        _messageAttachmentDownloadProgress.add(
            NIMDownloadMessageAttachmentProgress.fromJson(
                Map<String, dynamic>.from(arguments)));
        break;
      default:
        throw UnimplementedError();
    }
    return Future.value();
  }

  @override
  String get serviceName => 'StorageService';

  @override
  Future<NIMResult<NIMStorageScene>> addCustomStorageScene(
      String sceneName, int expireTime) async {
    return NIMResult.fromMap(
      await invokeMethod(
        'addCustomStorageScene',
        arguments: {
          'sceneName': sceneName,
          'expireTime': expireTime,
        },
      ),
      convert: (map) => NIMStorageScene.fromJson(map),
    );
  }

  @override
  Future<NIMResult<void>> cancelUploadFile(NIMUploadFileTask fileTask) async {
    return NIMResult.fromMap(
      await invokeMethod(
        'cancelUploadFile',
        arguments: {'fileTask': fileTask.toJson()},
      ),
    );
  }

  @override
  Future<NIMResult<NIMUploadFileTask>> createUploadFileTask(
    NIMUploadFileParams fileParams, {
    html.File? fileObj,
  }) async {
    return NIMResult.fromMap(
      await invokeMethod(
        'createUploadFileTask',
        arguments: {'fileParams': fileParams.toJson(), 'fileObj': fileObj},
      ),
      convert: (map) => NIMUploadFileTask.fromJson(map),
    );
  }

  @override
  Future<NIMResult<String>> downloadAttachment(
      NIMDownloadMessageAttachmentParams downloadParam) async {
    return NIMResult.fromMap(await invokeMethod(
      'downloadAttachment',
      arguments: {'downloadParam': downloadParam.toJson()},
    ));
  }

  @override
  Future<NIMResult<String>> downloadFile(String url, String filePath) async {
    return NIMResult.fromMap(await invokeMethod(
      'downloadFile',
      arguments: {'url': url, 'filePath': filePath},
    ));
  }

  @override
  Future<NIMResult<NIMGetMediaResourceInfoResult>> getImageThumbUrl(
      NIMMessageAttachment attachment, NIMSize thumbSize) async {
    return NIMResult.fromMap(
      await invokeMethod(
        'getImageThumbUrl',
        arguments: {
          'attachment': attachment.toJson(),
          'thumbSize': thumbSize.toJson()
        },
      ),
      convert: (map) => NIMGetMediaResourceInfoResult.fromJson(
          Map<String, dynamic>.from(map)),
    );
  }

  @override
  Future<NIMResult<List<NIMStorageScene>>> getStorageSceneList() async {
    return NIMResult.fromMap(
      await invokeMethod(
        'getStorageSceneList',
      ),
      convert: (map) {
        return (map['sceneList'] as List<dynamic>?)
            ?.map((e) => NIMStorageScene.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      },
    );
  }

  @override
  Future<NIMResult<NIMGetMediaResourceInfoResult>> getVideoCoverUrl(
      NIMMessageAttachment attachment, NIMSize thumbSize) async {
    return NIMResult.fromMap(
      await invokeMethod(
        'getVideoCoverUrl',
        arguments: {
          'attachment': attachment.toJson(),
          'thumbSize': thumbSize.toJson()
        },
      ),
      convert: (map) => NIMGetMediaResourceInfoResult.fromJson(
          Map<String, dynamic>.from(map)),
    );
  }

  @override
  Future<NIMResult<String>> shortUrlToLong(String url) async {
    return NIMResult.fromMap(
      await invokeMethod(
        'shortUrlToLong',
        arguments: {'url': url},
      ),
    );
  }

  @override
  Future<NIMResult<String>> uploadFile(
    NIMUploadFileTask fileTask, {
    html.File? fileObj,
  }) async {
    return NIMResult.fromMap(
      await invokeMethod(
        'uploadFile',
        arguments: {'fileTask': fileTask.toJson(), 'fileObj': fileObj},
      ),
    );
  }

  /// 生成图片缩略链接
  /// [url] 图片原始链接
  /// [thumbSize] 缩放的尺寸
  ///  返回图片缩略链接
  @override
  Future<NIMResult<String>> imageThumbUrl(String url, int thumbSize) async {
    return NIMResult.fromMap(
      await invokeMethod(
        'imageThumbUrl',
        arguments: {'url': url, 'thumbSize': thumbSize},
      ),
    );
  }

  /// 生成视频封面图链接
  ///  [url] 视频原始链接
  ///  [offset] 从第几秒开始截
  ///  返回视频封面图链接
  Future<NIMResult<String>> videoCoverUrl(String url, int offset) async {
    return NIMResult.fromMap(
      await invokeMethod(
        'videoCoverUrl',
        arguments: {'url': url, 'offset': offset},
      ),
    );
  }

  @override
  Stream<NIMDownloadFileProgress> get onFileDownloadProgress =>
      _downloadFileProgress.stream;

  @override
  Stream<NIMUploadFileProgress> get onFileUploadProgress =>
      _uploadFileProgress.stream;

  @override
  Stream<NIMDownloadMessageAttachmentProgress>
      get onMessageAttachmentDownloadProgress =>
          _messageAttachmentDownloadProgress.stream;
}
