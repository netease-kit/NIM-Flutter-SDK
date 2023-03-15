// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

part of nim_core;

class NOSService {
  factory NOSService() {
    if (_singleton == null) {
      _singleton = NOSService._();
    }
    return _singleton!;
  }

  NOSService._();

  Stream<NIMNOSTransferStatus> onNOSTransferStatus =
      NOSServicePlatform.instance.onNOSTransferStatus.stream;

  Stream<double> onNOSTransferProgress =
      NOSServicePlatform.instance.onNOSTransferProgress.stream;

  static NOSService? _singleton;

  NOSServicePlatform get _platform => NOSServicePlatform.instance;

  /// nos上传
  /// web 端[filePath] 传base64
  Future<NIMResult<String>> upload(
      {required String filePath, String? mimeType, String? sceneKey}) async {
    return _platform.upload(
        filePath: filePath, mimeType: mimeType, sceneKey: sceneKey);
  }

  /// nos下载
  Future<NIMResult<void>> download(
      {required String url, required String path}) async {
    return _platform.download(url: url, path: path);
  }
}
