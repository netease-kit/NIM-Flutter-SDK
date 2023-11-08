// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

/// 免打扰配置
class NIMPushNoDisturbConfig {
  /// 开关
  final bool enable;

  /// 开始时间，格式为：HH:mm
  final String? startTime;

  /// 结束时间，格式为：HH:mm
  final String? endTime;

  NIMPushNoDisturbConfig({
    required this.enable,
    this.startTime,
    this.endTime,
  });

  factory NIMPushNoDisturbConfig.fromMap(Map<String, dynamic> map) {
    return NIMPushNoDisturbConfig(
      enable: map['enable'] as bool,
      startTime: map['startTime'] as String?,
      endTime: map['endTime'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'enable': enable,
        'startTime': startTime,
        'endTime': endTime,
      };
}

///
/// sdk 本地文件缓存类型
///
enum NIMDirCacheFileType {
  /// 图片
  image,

  /// 视频
  video,

  /// 缩略图
  thumb,

  /// 语音
  audio,

  /// 日志
  log,

  /// 其他文件
  other
}

String stringifyDirCacheFileTypeName(NIMDirCacheFileType type) {
  switch (type) {
    case NIMDirCacheFileType.image:
      return 'image';
    case NIMDirCacheFileType.video:
      return 'video';
    case NIMDirCacheFileType.thumb:
      return 'thumb';
    case NIMDirCacheFileType.audio:
      return 'audio';
    case NIMDirCacheFileType.log:
      return 'log';
    case NIMDirCacheFileType.other:
      return 'other';
  }
}

NIMDirCacheFileType enumifyDirCacheFileTypeName(String type) {
  switch (type) {
    case 'image':
      return NIMDirCacheFileType.image;
    case 'video':
      return NIMDirCacheFileType.video;
    case 'thumb':
      return NIMDirCacheFileType.thumb;
    case 'audio':
      return NIMDirCacheFileType.audio;
    case 'log':
      return NIMDirCacheFileType.log;
    case 'other':
      return NIMDirCacheFileType.other;
  }

  return NIMDirCacheFileType.other;
}

class NIMResourceQueryOption {
  ///查询的缓存文件类型，类型为文件后缀的集合。 默认为 nil ，不分类型查询所有文件缓存。
  List<String>? extensions;

  ///当前时间往前多少时间之前所有的消息,默认为 7 天之前。
  int? timeInterval;

  NIMResourceQueryOption({this.extensions, this.timeInterval});

  factory NIMResourceQueryOption.fromMap(Map<String, dynamic> map) =>
      NIMResourceQueryOption(
        extensions: (map['extensions'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList(),
        timeInterval: map['timeInterval'] as int?,
      );

  Map<String, dynamic> toMap() => {
        'extensions': extensions,
        'timeInterval': timeInterval,
      };
}

class NIMCacheQueryResult {
  ///文件路径
  String? path;

  ///文件的大小，单位为 bytes
  int fileLength;

  ///文件的创建日期
  int? creationDate;

  NIMCacheQueryResult({this.path, required this.fileLength, this.creationDate});

  factory NIMCacheQueryResult.fromMap(Map<String, dynamic> map) =>
      NIMCacheQueryResult(
        path: map['path'] as String?,
        fileLength: map['fileLength'] as int,
        creationDate: map['creationDate'] as int?,
      );

  Map<String, dynamic> toMap() => {
        'path': path,
        'fileLength': fileLength,
        'creationDate': creationDate,
      };
}
