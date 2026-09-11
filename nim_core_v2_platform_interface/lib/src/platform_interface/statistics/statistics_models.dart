// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:json_annotation/json_annotation.dart';

part 'statistics_models.g.dart';

/// 数据库信息
@JsonSerializable()
class NIMDatabaseInfo {
  /// 数据库文件路径
  @JsonKey(name: 'path')
  final String? path;

  /// 数据库文件名称
  @JsonKey(name: 'name')
  final String? name;

  /// 数据库文件大小，单位字节
  @JsonKey(name: 'size')
  final int? size;

  NIMDatabaseInfo({
    this.path,
    this.name,
    this.size,
  });

  factory NIMDatabaseInfo.fromJson(Map<String, dynamic> json) =>
      _$NIMDatabaseInfoFromJson(json);

  Map<String, dynamic> toJson() => _$NIMDatabaseInfoToJson(this);
}
