// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:json_annotation/json_annotation.dart';

part 'nim_base_v2.g.dart';

///错误信息
@JsonSerializable(explicitToJson: true)
class NIMError {
  int? code;

  String? desc;

  @JsonKey(fromJson: _getMap)
  Map<String, dynamic>? detail;

  NIMError({this.code, this.desc, this.detail});

  Map<String, dynamic> toJson() => _$NIMErrorToJson(this);

  factory NIMError.fromJson(Map<String, dynamic> map) =>
      _$NIMErrorFromJson(map);
}

Map<String, dynamic>? _getMap(Map? map) {
  if (map != null) {
    return map.cast<String, dynamic>();
  }
  return null;
}
