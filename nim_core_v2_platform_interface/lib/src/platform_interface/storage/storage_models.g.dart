// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'storage_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NIMStorageScene _$NIMStorageSceneFromJson(Map<String, dynamic> json) =>
    NIMStorageScene(
      sceneName: json['sceneName'] as String?,
      expireTime: (json['expireTime'] as num?)?.toInt(),
    );

Map<String, dynamic> _$NIMStorageSceneToJson(NIMStorageScene instance) =>
    <String, dynamic>{
      'sceneName': instance.sceneName,
      'expireTime': instance.expireTime,
    };

NIMUploadFileTask _$NIMUploadFileTaskFromJson(Map<String, dynamic> json) =>
    NIMUploadFileTask(
      taskId: json['taskId'] as String?,
      uploadParams: _nimUploadFileParamsFromJson(json['uploadParams'] as Map?),
    );

Map<String, dynamic> _$NIMUploadFileTaskToJson(NIMUploadFileTask instance) =>
    <String, dynamic>{
      'taskId': instance.taskId,
      'uploadParams': instance.uploadParams?.toJson(),
    };

NIMUploadFileParams _$NIMUploadFileParamsFromJson(Map<String, dynamic> json) =>
    NIMUploadFileParams(
      filePath: json['filePath'] as String?,
      sceneName: json['sceneName'] as String?,
    );

Map<String, dynamic> _$NIMUploadFileParamsToJson(
        NIMUploadFileParams instance) =>
    <String, dynamic>{
      'filePath': instance.filePath,
      'sceneName': instance.sceneName,
    };

NIMUploadFileProgress _$NIMUploadFileProgressFromJson(
        Map<String, dynamic> json) =>
    NIMUploadFileProgress(
      taskId: json['taskId'] as String?,
      progress: (json['progress'] as num?)?.toInt(),
    );

Map<String, dynamic> _$NIMUploadFileProgressToJson(
        NIMUploadFileProgress instance) =>
    <String, dynamic>{
      'taskId': instance.taskId,
      'progress': instance.progress,
    };

NIMDownloadFileProgress _$NIMDownloadFileProgressFromJson(
        Map<String, dynamic> json) =>
    NIMDownloadFileProgress(
      url: json['url'] as String?,
      progress: (json['progress'] as num?)?.toInt(),
    );

Map<String, dynamic> _$NIMDownloadFileProgressToJson(
        NIMDownloadFileProgress instance) =>
    <String, dynamic>{
      'url': instance.url,
      'progress': instance.progress,
    };

NIMDownloadMessageAttachmentProgress
    _$NIMDownloadMessageAttachmentProgressFromJson(Map<String, dynamic> json) =>
        NIMDownloadMessageAttachmentProgress(
          downloadParam: _nimDownloadMessageAttachmentParamsFromJson(
              json['downloadParam'] as Map?),
          progress: (json['progress'] as num?)?.toInt(),
        );

Map<String, dynamic> _$NIMDownloadMessageAttachmentProgressToJson(
        NIMDownloadMessageAttachmentProgress instance) =>
    <String, dynamic>{
      'downloadParam': instance.downloadParam?.toJson(),
      'progress': instance.progress,
    };

NIMSize _$NIMSizeFromJson(Map<String, dynamic> json) => NIMSize(
      width: (json['width'] as num?)?.toInt(),
      height: (json['height'] as num?)?.toInt(),
    );

Map<String, dynamic> _$NIMSizeToJson(NIMSize instance) => <String, dynamic>{
      'width': instance.width,
      'height': instance.height,
    };

NIMGetMediaResourceInfoResult _$NIMGetMediaResourceInfoResultFromJson(
        Map<String, dynamic> json) =>
    NIMGetMediaResourceInfoResult(
      url: json['url'] as String?,
      authHeaders: _getAuthHeaders(json['authHeaders'] as Map?),
    );

Map<String, dynamic> _$NIMGetMediaResourceInfoResultToJson(
        NIMGetMediaResourceInfoResult instance) =>
    <String, dynamic>{
      'url': instance.url,
      'authHeaders': instance.authHeaders,
    };

NIMDownloadMessageAttachmentParams _$NIMDownloadMessageAttachmentParamsFromJson(
        Map<String, dynamic> json) =>
    NIMDownloadMessageAttachmentParams(
      attachment: _nimMessageAttachmentFromJson(json['attachment'] as Map?),
      type: $enumDecode(_$NIMDownloadAttachmentTypeEnumMap, json['type']),
      thumbSize: _nimSizeFromJson(json['thumbSize'] as Map?),
      messageClientId: json['messageClientId'] as String?,
      saveAs: json['saveAs'] as String?,
    );

Map<String, dynamic> _$NIMDownloadMessageAttachmentParamsToJson(
        NIMDownloadMessageAttachmentParams instance) =>
    <String, dynamic>{
      'attachment': instance.attachment.toJson(),
      'type': _$NIMDownloadAttachmentTypeEnumMap[instance.type]!,
      'thumbSize': instance.thumbSize.toJson(),
      'messageClientId': instance.messageClientId,
      'saveAs': instance.saveAs,
    };

const _$NIMDownloadAttachmentTypeEnumMap = {
  NIMDownloadAttachmentType.nimDownloadAttachmentTypeSource: 0,
  NIMDownloadAttachmentType.nimDownloadAttachmentTypeThumbnail: 1,
  NIMDownloadAttachmentType.nimDownloadAttachmentTypeVideoCover: 2,
};
