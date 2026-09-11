// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMFriendDeleteParams {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMFriendDeleteParams {
    let params = V2NIMFriendDeleteParams()

    if let deleteAlias = arguments[#keyPath(V2NIMFriendDeleteParams.deleteAlias)] as? Bool {
      params.deleteAlias = deleteAlias
    }

    return params
  }
}
