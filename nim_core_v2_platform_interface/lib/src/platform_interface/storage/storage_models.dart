// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:json_annotation/json_annotation.dart';

import '../../../nim_core_v2_platform_interface.dart';

part 'storage_models.g.dart';

///文件存储场景
@JsonSerializable(explicitToJson: true)
class NIMStorageScene {
  ///返回场景名
  final String? sceneName;

  ///返回过期时间， 单位秒
  ///  0表示永远不过期
  /// 否则以该时间为过期时间
  final int? expireTime;

  NIMStorageScene({
    this.sceneName,
    this.expireTime,
  });

  factory NIMStorageScene.fromJson(Map<String, dynamic> json) =>
      _$NIMStorageSceneFromJson(json);

  Map<String, dynamic> toJson() => _$NIMStorageSceneToJson(this);
}

///文件上传任务定义
@JsonSerializable(explicitToJson: true)
class NIMUploadFileTask {
  String? taskId;

  @JsonKey(fromJson: _nimUploadFileParamsFromJson)
  NIMUploadFileParams? uploadParams;

  NIMUploadFileTask({
    this.taskId,
    this.uploadParams,
  });

  factory NIMUploadFileTask.fromJson(Map<String, dynamic> json) =>
      _$NIMUploadFileTaskFromJson(json);

  Map<String, dynamic> toJson() => _$NIMUploadFileTaskToJson(this);
}

NIMUploadFileParams? _nimUploadFileParamsFromJson(Map? map) {
  if (map != null) {
    return NIMUploadFileParams.fromJson(map.cast<String, dynamic>());
  }
  return null;
}

@JsonSerializable(explicitToJson: true)
class NIMUploadFileParams {
  ///文件地址
  String? filePath;

  ///场景名
  /// 自定义场景使用之前， 需要先调用V2NIMStorageService.addCustomStorageScene新增自定义场景值
  /// 默认使用{@link V2NIMStorageSceneConfig#DEFAULT_PROFILE}对应的场景名
  final String? sceneName;

  NIMUploadFileParams({this.filePath, this.sceneName});

  factory NIMUploadFileParams.fromJson(Map<String, dynamic> json) =>
      _$NIMUploadFileParamsFromJson(json);

  Map<String, dynamic> toJson() => _$NIMUploadFileParamsToJson(this);
}

@JsonSerializable(explicitToJson: true)

///文件上传回调
class NIMUploadFileProgress {
  ///id
  String? taskId;

  ///进度
  int? progress;

  NIMUploadFileProgress({this.taskId, this.progress});

  factory NIMUploadFileProgress.fromJson(Map<String, dynamic> json) =>
      _$NIMUploadFileProgressFromJson(json);

  Map<String, dynamic> toJson() => _$NIMUploadFileProgressToJson(this);
}

@JsonSerializable(explicitToJson: true)
class NIMDownloadFileProgress {
  ///url
  String? url;

  ///进度
  int? progress;

  NIMDownloadFileProgress({this.url, this.progress});

  factory NIMDownloadFileProgress.fromJson(Map<String, dynamic> json) =>
      _$NIMDownloadFileProgressFromJson(json);

  Map<String, dynamic> toJson() => _$NIMDownloadFileProgressToJson(this);
}

@JsonSerializable(explicitToJson: true)
class NIMDownloadMessageAttachmentProgress {
  ///消息附件下载参数
  @JsonKey(fromJson: _nimDownloadMessageAttachmentParamsFromJson)
  NIMDownloadMessageAttachmentParams? downloadParam;

  ///进度
  int? progress;

  NIMDownloadMessageAttachmentProgress({this.downloadParam, this.progress});

  factory NIMDownloadMessageAttachmentProgress.fromJson(
          Map<String, dynamic> json) =>
      _$NIMDownloadMessageAttachmentProgressFromJson(json);

  Map<String, dynamic> toJson() =>
      _$NIMDownloadMessageAttachmentProgressToJson(this);
}

NIMDownloadMessageAttachmentParams? _nimDownloadMessageAttachmentParamsFromJson(
    Map? map) {
  if (map != null) {
    return NIMDownloadMessageAttachmentParams.fromJson(
        map.cast<String, dynamic>());
  }
  return null;
}

@JsonSerializable(explicitToJson: true)
class NIMSize {
  ///宽
  int? width;

  ///高
  int? height;

  NIMSize({this.width, this.height});

  factory NIMSize.fromJson(Map<String, dynamic> json) =>
      _$NIMSizeFromJson(json);

  Map<String, dynamic> toJson() => _$NIMSizeToJson(this);
}

@JsonSerializable(explicitToJson: true)
class NIMGetMediaResourceInfoResult {
  ///url
  String? url;

  ///鉴权信息
  @JsonKey(fromJson: _getAuthHeaders)
  Map<String, String>? authHeaders;

  NIMGetMediaResourceInfoResult({this.url, this.authHeaders});

  factory NIMGetMediaResourceInfoResult.fromJson(Map<String, dynamic> json) =>
      _$NIMGetMediaResourceInfoResultFromJson(json);

  Map<String, dynamic> toJson() => _$NIMGetMediaResourceInfoResultToJson(this);
}

Map<String, String>? _getAuthHeaders(Map? map) {
  if (map != null) {
    return map.cast<String, dynamic>().map(
          (k, e) => MapEntry(k, e as String),
        );
  }
  return null;
}

enum NIMDownloadAttachmentType {
  ///原始资源，支持全部有附件的类型
  @JsonValue(0)
  nimDownloadAttachmentTypeSource,

  ///图片缩略图，仅支持图片类附件
  @JsonValue(1)
  nimDownloadAttachmentTypeThumbnail,

  ///视频封面，仅支持视频类附件
  @JsonValue(2)
  nimDownloadAttachmentTypeVideoCover,
}

NIMMessageAttachment _nimMessageAttachmentFromJson(Map? map) {
  if (map != null) {
    return NIMMessageAttachment.fromJson(map.cast<String, dynamic>());
  }
  return NIMMessageAttachment();
}

NIMSize _nimSizeFromJson(Map? map) {
  if (map != null) {
    return NIMSize.fromJson(map.cast<String, dynamic>());
  }
  return NIMSize();
}

@JsonSerializable(explicitToJson: true)
class NIMDownloadMessageAttachmentParams {
  ///要下载的附件
  @JsonKey(fromJson: _nimMessageAttachmentFromJson)
  NIMMessageAttachment attachment;

  ///下载附件的类型，如原始文件、缩略图、视频封面
  NIMDownloadAttachmentType type;

  /// 缩略图大小或视频封面大小
  /// 如果下载的是缩略图或者视频封面，通过该参数指定缩略图大小或视频封面大小
  @JsonKey(fromJson: _nimSizeFromJson)
  NIMSize thumbSize;

  ///消息的端侧ID
  ///可选参数，如果指定了该参数将下载完成后的本地附件保存路径更新到消息数据库中，下一次查询时将直接返回对应的路径
  String? messageClientId;

  /// 附件保存路径，如未指定 SDK 将下载到登录用户缓存目录，如指定该参数则以指定的路径为准
  String? saveAs;

  NIMDownloadMessageAttachmentParams(
      {required this.attachment,
      required this.type,
      required this.thumbSize,
      this.messageClientId,
      this.saveAs});

  factory NIMDownloadMessageAttachmentParams.fromJson(
          Map<String, dynamic> json) =>
      _$NIMDownloadMessageAttachmentParamsFromJson(json);

  Map<String, dynamic> toJson() =>
      _$NIMDownloadMessageAttachmentParamsToJson(this);
}
