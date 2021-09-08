// Copyright (c) 2021 NetEase, Inc.  All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

enum QueryDirection { QUERY_OLD, QUERY_NEW }

enum SearchOrder {
  // 从新消息往旧消息查
  DESC,

  //从旧消息往新消息查
  ASC
}

enum NIMUnreadCountQueryType {
  /// 所有类型
  all,

  /// 仅通知消息
  notifyOnly,

  /// 仅免打扰消息
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
