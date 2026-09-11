// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMFriendAddApplicationQueryOption {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMFriendAddApplicationQueryOption {
    let option = V2NIMFriendAddApplicationQueryOption()

    if let offset = arguments[#keyPath(V2NIMFriendAddApplicationQueryOption.offset)] as? Int {
      option.offset = UInt(offset)
    }

    if let limit = arguments[#keyPath(V2NIMFriendAddApplicationQueryOption.limit)] as? Int {
      option.limit = UInt(limit)
    }

    if let status = arguments[#keyPath(V2NIMFriendAddApplicationQueryOption.status)] as? [Int] {
      option.status = status.map { NSNumber(value: $0) }
    }

    return option
  }
}
