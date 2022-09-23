// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:json_annotation/json_annotation.dart';

part 'pass_through_notifydata.g.dart';

@JsonSerializable()
class NIMPassThroughNotifyData {
  final String? fromAccid;

  /// 透传内容
  final String? body;

  /// 发送时间时间戳
  final int? time;

  NIMPassThroughNotifyData({this.fromAccid, this.body, this.time});

  factory NIMPassThroughNotifyData.fromMap(Map<String, dynamic> map) =>
      _$NIMPassThroughNotifyDataFromJson(map);

  Map<String, dynamic> toMap() => _$NIMPassThroughNotifyDataToJson(this);
}
