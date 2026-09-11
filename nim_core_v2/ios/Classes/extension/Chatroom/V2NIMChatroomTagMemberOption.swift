// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMChatroomTagMemberOption {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMChatroomTagMemberOption {
    let option = V2NIMChatroomTagMemberOption()

    if let tag = arguments["tag"] as? String {
      option.tag = tag
    }

    if let pageToken = arguments["pageToken"] as? String {
      option.pageToken = pageToken
    }

    if let limit = arguments["limit"] as? Int {
      option.limit = limit
    }

    return option
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(tag)] = tag
    keyPaths[#keyPath(pageToken)] = pageToken
    keyPaths[#keyPath(limit)] = limit
    return keyPaths
  }
}
