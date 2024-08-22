// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:json_annotation/json_annotation.dart';

part 'antispam_config.g.dart';

/// 反垃圾配置
@JsonSerializable()
class NIMAntispamConfig {
  /// 指定易盾业务ID，而不使用云信后台配置的安全通
  String? antispamBusinessId;

  //构造函数
  NIMAntispamConfig({
    this.antispamBusinessId,
  });

  factory NIMAntispamConfig.fromJson(Map<String, dynamic> map) =>
      _$NIMAntispamConfigFromJson(map);

  Map<String, dynamic> toJson() => _$NIMAntispamConfigToJson(this);
}
