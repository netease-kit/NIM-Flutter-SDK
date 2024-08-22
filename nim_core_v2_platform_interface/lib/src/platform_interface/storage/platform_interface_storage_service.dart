// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:async';
import 'package:nim_core_v2_platform_interface/nim_core_v2_platform_interface.dart';
import 'package:nim_core_v2_platform_interface/src/method_channel/method_channel_storage_service.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:universal_html/html.dart' as html;

abstract class StorageServicePlatform extends Service {
  StorageServicePlatform() : super(token: _token);

  static final Object _token = Object();

  static StorageServicePlatform _instance = MethodChannelStorageService();

  static StorageServicePlatform get instance => _instance;

  static set instance(StorageServicePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// 文件上传进度
  Stream<NIMUploadFileProgress> get onFileUploadProgress;

  /// 文件下载进度
  Stream<NIMDownloadFileProgress> get onFileDownloadProgress;

  /// 消息附件下载进度
  Stream<NIMDownloadMessageAttachmentProgress>
      get onMessageAttachmentDownloadProgress;

  /// 添加自定义存储场景
  ///
  /// [sceneName] 自定义存储场景
  /// [expireTime] 过期时间，单位秒
  ///   0表示永远不过期
  ///   否则以该时间为过期时间 NIMStorageScene
  Future<NIMResult<NIMStorageScene>> addCustomStorageScene(
      String sceneName, int expireTime) {
    throw UnimplementedError('addCustomStorageScene() is not implemented');
  }

  /// 创建文件上传任务
  ///
  /// [fileParams] 文件上传的相关参数
  /// 返回文件上传任务
  Future<NIMResult<NIMUploadFileTask>> createUploadFileTask(
    NIMUploadFileParams fileParams, {
    html.File? fileObj,
  }) {
    throw UnimplementedError('createUploadFileTask() is not implemented');
  }

  /// 文件上传
  ///
  /// [fileTask] 文件上传任务
  Future<NIMResult<String>> uploadFile(
    NIMUploadFileTask fileTask, {
    html.File? fileObj,
  }) {
    throw UnimplementedError('uploadFile() is not implemented');
  }

  /// 取消文件上传
  ///
  /// [fileTask] 文件上传任务
  Future<NIMResult<void>> cancelUploadFile(NIMUploadFileTask fileTask) {
    throw UnimplementedError('cancelUploadFile() is not implemented');
  }

  /// 查询存储场景列表
  ///
  /// 返回存储场景列表
  Future<NIMResult<List<NIMStorageScene>>> getStorageSceneList() {
    throw UnimplementedError('getStorageSceneList() is not implemented');
  }

  /// 短连接转长连接
  ///
  /// [url] 短连接url
  Future<NIMResult<String>> shortUrlToLong(String url) {
    throw UnimplementedError('shortUrlToLong() is not implemented');
  }

  /// 下载文件
  ///
  /// [url] 文件url
  /// [filePath] 文件保存路径
  Future<NIMResult<String>> downloadFile(String url, String filePath) {
    throw UnimplementedError('downloadFile() is not implemented');
  }

  /// 下载消息附件
  ///
  /// [downloadParam] 下载参数
  Future<NIMResult<String>> downloadAttachment(
      NIMDownloadMessageAttachmentParams downloadParam) {
    throw UnimplementedError('downloadAttachment() is not implemented');
  }

  /// 获取图片消息中的图片缩略图
  /// 传入短链自动获取长链地址并携带缩略图相关 URL 查询参数
  /// 旧的下载地址会做新的 CDN 加速域名地址替换
  /// 开启自定义鉴权会返回对应的鉴权信息
  ///
  /// [attachment] 消息附件
  /// [thumbSize] 缩略图尺寸
  /// 参见 [NIMGetMediaResourceInfoResult]
  Future<NIMResult<NIMGetMediaResourceInfoResult>> getImageThumbUrl(
      NIMMessageAttachment attachment, NIMSize thumbSize) {
    throw UnimplementedError('getImageThumbUrl() is not implemented');
  }

  /// 获取视频消息中的视频封面
  /// 传入短链自动获取长链地址并携带视频封面相关 URL 查询参数
  /// 旧的下载地址会做新的 CDN 加速域名地址替换
  /// 开启自定义鉴权会返回对应的鉴权信息
  ///
  /// [attachment] 消息附件
  /// [thumbSize] 缩略图尺寸
  /// 参见 [NIMGetMediaResourceInfoResult]
  Future<NIMResult<NIMGetMediaResourceInfoResult>> getVideoCoverUrl(
      NIMMessageAttachment attachment, NIMSize thumbSize) {
    throw UnimplementedError('getVideoCoverUrl() is not implemented');
  }

  /// 生成图片缩略链接
  /// [url] 图片原始链接
  /// [thumbSize] 缩放的尺寸
  ///  返回图片缩略链接
  Future<NIMResult<String>> imageThumbUrl(String url, int thumbSize) {
    throw UnimplementedError('imageThumbUrl() is not implemented');
  }

  /// 生成视频封面图链接
  ///  [url] 视频原始链接
  ///  [offset] 从第几秒开始截
  ///  返回视频封面图链接
  Future<NIMResult<String>> videoCoverUrl(String url, int offset) {
    throw UnimplementedError('videoCoverUrl() is not implemented');
  }
}
