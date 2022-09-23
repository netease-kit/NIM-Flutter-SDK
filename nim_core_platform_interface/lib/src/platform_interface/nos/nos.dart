// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:json_annotation/json_annotation.dart';

part 'nos.g.dart';

/// 文件上传进度
@JsonSerializable()
class NIMNOSTransferProgress {
  final String key;
  final int? transferred;
  final int? total;

  NIMNOSTransferProgress({required this.key, this.transferred, this.total});

  factory NIMNOSTransferProgress.fromMap(Map<String, dynamic> map) =>
      _$NIMNOSTransferProgressFromJson(map);

  Map<String, dynamic> toMap() => _$NIMNOSTransferProgressToJson(this);
}

@JsonSerializable()
class NIMNOSTransferStatus {
  final NIMNOSTransferType? transferType;
  final String? path;
  final String? md5;
  final String? url;
  final int? size;
  final NIMNosTransferStatus? status;
  final String? extension;

  NIMNOSTransferStatus(
      {this.transferType,
      this.path,
      this.md5,
      this.url,
      this.size,
      this.status,
      this.extension});

  factory NIMNOSTransferStatus.fromMap(Map<String, dynamic> map) =>
      _$NIMNOSTransferStatusFromJson(map);

  Map<String, dynamic> toMap() => _$NIMNOSTransferStatusToJson(this);
}

/// 传输类型
enum NIMNOSTransferType {
  upload,
  download,
}

/// 传输状态
enum NIMNosTransferStatus {
  def,
  transferring,
  transferred,
  fail,
}
