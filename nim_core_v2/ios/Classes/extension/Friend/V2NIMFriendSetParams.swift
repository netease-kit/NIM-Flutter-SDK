// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMFriendSetParams {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMFriendSetParams {
    let params = V2NIMFriendSetParams()

    if let alias = arguments[#keyPath(V2NIMFriendSetParams.alias)] as? String {
      params.alias = alias
    }

    if let serverExtension = arguments[#keyPath(V2NIMFriendSetParams.serverExtension)] as? String {
      params.serverExtension = serverExtension
    }

    return params
  }
}
