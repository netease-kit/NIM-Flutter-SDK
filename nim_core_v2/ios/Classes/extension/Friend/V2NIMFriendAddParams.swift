// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMFriendAddParams {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMFriendAddParams {
    let params = V2NIMFriendAddParams()

    if let addModelInt = arguments[#keyPath(V2NIMFriendAddParams.addMode)] as? Int {
      params.addMode = V2NIMFriendAddMode(rawValue: addModelInt) ?? V2NIMFriendAddMode.FRIEND_MODE_TYPE_APPLAY
    }

    if let postscript = arguments[#keyPath(V2NIMFriendAddParams.postscript)] as? String {
      params.postscript = postscript
    }

    return params
  }
}
