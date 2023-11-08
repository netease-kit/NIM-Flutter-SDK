// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

enum QueryDirection {
  /// 查询比锚点时间更早的消息
  QUERY_OLD,

  /// 查询比锚点时间更晚的消
  QUERY_NEW
}

enum SearchOrder {
  /// 从新消息往旧消息查
  DESC,

  /// 从旧消息往新消息查
  ASC
}

enum NIMUnreadCountQueryType {
  /// 所有类型
  all,

  /// 仅通知消息, pc端暂不支持
  notifyOnly,

  /// 仅免打扰消息，pc端暂不支持
  noDisturbOnly,
}

enum NIMSessionDeleteType {
  ///
  local,

  ///
  remote,

  ///
  localAndRemote,
}

String sessionDeleteTypeToString(NIMSessionDeleteType type) {
  if (type == NIMSessionDeleteType.local) return 'local';
  if (type == NIMSessionDeleteType.remote) return 'remote';
  return 'localAndRemote';
}

enum NIMGetMessageDirection {
  ///从时间戳大到时间戳小
  forward,

  ///从时间戳小到时间戳大
  backward
}
