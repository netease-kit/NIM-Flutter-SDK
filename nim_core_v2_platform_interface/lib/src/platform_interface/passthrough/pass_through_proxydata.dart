// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:json_annotation/json_annotation.dart';

part 'pass_through_proxydata.g.dart';

@JsonSerializable()
class NIMPassThroughProxyData {
  /// 映射一个视频云upstream host，不传用默认配置
  final String? zone;

  /// url中除了host的path
  final String? path;

  /// 选填，数字常量(1-get, 2-post, 3-put, 4-delete)，默认post，
  ///[PassThroughMethod]
  @JsonKey(defaultValue: PassThroughMethod.POST)
  final int method;

  /// json格式
  final String? header;

  /// 格式自定，透传， post时，body不能为空
  String? body;

  NIMPassThroughProxyData({
    this.zone,
    this.path,
    this.method = PassThroughMethod.POST,
    this.header,
    this.body,
  });

  factory NIMPassThroughProxyData.fromMap(Map<String, dynamic> map) =>
      _$NIMPassThroughProxyDataFromJson(map);

  Map<String, dynamic> toMap() => _$NIMPassThroughProxyDataToJson(this);
}

class PassThroughMethod {
  static const GET = 1;

  static const POST = 2;

  static const PUT = 3;

  static const DELETE = 4;
}
