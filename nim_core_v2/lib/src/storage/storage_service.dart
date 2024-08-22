// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

part of nim_core_v2;

/// 存储服务
@HawkEntryPoint()
class StorageService {
  factory StorageService() {
    if (_singleton == null) {
      _singleton = StorageService._();
    }
    return _singleton!;
  }

  StorageService._();

  static StorageService? _singleton;

  StorageServicePlatform get _platform => StorageServicePlatform.instance;

  /// 文件上传进度
  @HawkApi(ignore: true)
  Stream<NIMUploadFileProgress> get onFileUploadProgress =>
      _platform.onFileUploadProgress;

  /// 文件下载进度
  @HawkApi(ignore: true)
  Stream<NIMDownloadFileProgress> get onFileDownloadProgress =>
      _platform.onFileDownloadProgress;

  /// 消息附件下载进度
  @HawkApi(ignore: true)
  Stream<NIMDownloadMessageAttachmentProgress>
      get onMessageAttachmentDownloadProgress =>
          _platform.onMessageAttachmentDownloadProgress;

  /// 添加自定义存储场景
  ///
  /// [sceneName] 自定义存储场景
  /// [expireTime] 过期时间，单位秒
  ///   0表示永远不过期
  ///   否则以该时间为过期时间 NIMStorageScene
  Future<NIMResult<NIMStorageScene>> addCustomStorageScene(
      String sceneName, int expireTime) {
    return _platform.addCustomStorageScene(sceneName, expireTime);
  }

  /// 创建文件上传任务
  ///
  /// [fileParams] 文件上传的相关参数
  /// [fileObj] 文件对象，仅web
  /// 返回文件上传任务
  Future<NIMResult<NIMUploadFileTask>> createUploadFileTask(
    NIMUploadFileParams fileParams, {
    html.File? fileObj,
  }) {
    return _platform.createUploadFileTask(fileParams, fileObj: fileObj);
  }

  /// 文件上传
  ///
  /// [fileTask] 文件上传任务
  /// [fileObj] 文件对象，仅web
  /// 调用后再[onFileUploadProgress] 中监控进度
  Future<NIMResult<String>> uploadFile(
    NIMUploadFileTask fileTask, {
    html.File? fileObj,
  }) {
    return _platform.uploadFile(fileTask, fileObj: fileObj);
  }

  /// 取消文件上传
  ///
  /// [fileTask] 文件上传任务
  Future<NIMResult<void>> cancelUploadFile(NIMUploadFileTask fileTask) {
    return _platform.cancelUploadFile(fileTask);
  }

  /// 查询存储场景列表
  ///
  /// 返回存储场景列表
  Future<NIMResult<List<NIMStorageScene>>> getStorageSceneList() {
    return _platform.getStorageSceneList();
  }

  /// 短连接转长连接
  ///
  /// [url] 短连接url
  Future<NIMResult<String>> shortUrlToLong(String url) {
    return _platform.shortUrlToLong(url);
  }

  /// 下载文件
  ///
  /// [url] 文件url
  /// [filePath] 文件保存路径
  /// 调用后再[onFileDownloadProgress] 中监控进度
  Future<NIMResult<String>> downloadFile(String url, String filePath) {
    return _platform.downloadFile(url, filePath);
  }

  /// 下载消息附件
  ///
  /// [downloadParam] 下载参数
  /// 调用后再[onMessageAttachmentDownloadProgress] 中监控进度
  Future<NIMResult<String>> downloadAttachment(
      NIMDownloadMessageAttachmentParams downloadParam) {
    return _platform.downloadAttachment(downloadParam);
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
    return _platform.getImageThumbUrl(attachment, thumbSize);
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
    return _platform.getVideoCoverUrl(attachment, thumbSize);
  }
}
