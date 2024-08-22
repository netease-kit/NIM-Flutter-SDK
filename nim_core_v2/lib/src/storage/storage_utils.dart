// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

part of nim_core_v2;

/// 存储工具类
@HawkEntryPoint()
class StorageUtil {
  factory StorageUtil() {
    if (_singleton == null) {
      _singleton = StorageUtil._();
    }
    return _singleton!;
  }

  StorageUtil._();

  static StorageUtil? _singleton;

  StorageServicePlatform get _platform => StorageServicePlatform.instance;

  /// 生成图片缩略链接
  /// [url] 图片原始链接
  /// [thumbSize] 缩放的尺寸
  ///  返回图片缩略链接
  /// web 端不支持
  Future<NIMResult<String>> imageThumbUrl(String url, int thumbSize) {
    return _platform.imageThumbUrl(url, thumbSize);
  }

  /// 生成视频封面图链接
  ///  [url] 视频原始链接
  ///  [offset] 从第几秒开始截
  ///  返回视频封面图链接
  /// web 端不支持
  Future<NIMResult<String>> videoCoverUrl(String url, int offset) {
    return _platform.videoCoverUrl(url, offset);
  }
}
