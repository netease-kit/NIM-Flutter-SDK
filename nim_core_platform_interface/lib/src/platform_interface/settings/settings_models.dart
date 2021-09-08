// Copyright (c) 2021 NetEase, Inc.  All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

/// 免打扰配置
class NIMPushNoDisturbConfig {
  /// 开关
  final bool enable;

  /// 开始时间，格式为：HH:mm
  final String startTime;

  /// 结束时间，格式为：HH:mm
  final String endTime;

  NIMPushNoDisturbConfig({
    required this.enable,
    required this.startTime,
    required this.endTime,
  });

  factory NIMPushNoDisturbConfig.fromMap(Map<String, dynamic> map) {
    return NIMPushNoDisturbConfig(
      enable: map['enable'] as bool,
      startTime: map['startTime'] as String,
      endTime: map['endTime'] as String,
    );
  }

  Map<String, dynamic> toMap() => {
        'enable': enable,
        'startTime': startTime,
        'endTime': endTime,
      };
}
