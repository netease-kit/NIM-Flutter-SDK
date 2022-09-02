// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:nim_core_platform_interface/nim_core_platform_interface.dart';

class NIMStickTopSessionInfo {
  final String sessionId;
  final NIMSessionType? sessionType;
  final String? ext;
  final int? createTime;
  final int? updateTime;

  NIMStickTopSessionInfo(
      {required this.sessionId,
      this.sessionType,
      this.ext,
      this.createTime,
      this.updateTime});

  factory NIMStickTopSessionInfo.fromMap(Map<String, dynamic> param) {
    return NIMStickTopSessionInfo(
      sessionId: param['sessionId'] as String,
      sessionType:
          NIMSessionTypeConverter().fromValue(param['sessionType'] as String),
      ext: param['ext'] as String?,
      createTime: param['createTime'] as int?,
      updateTime: param['updateTime'] as int?,
    );
  }

  @override
  String toString() {
    return 'NIMStickTopSessionInfo{sessionId: $sessionId, sessionType: $sessionType, ext: $ext, createTime: $createTime, updateTime: $updateTime}';
  }
}
