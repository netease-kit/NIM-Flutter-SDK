// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMChatroomQueueElement {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMChatroomQueueElement {
    let element = V2NIMChatroomQueueElement()

    if let key = arguments["key"] as? String {
      element.key = key
    }

    if let value = arguments["value"] as? String {
      element.value = value
    }

    if let accountId = arguments["accountId"] as? String {
      element.accountId = accountId
    }

    if let nick = arguments["nick"] as? String {
      element.nick = nick
    }

    if let ext = arguments["extension"] as? String {
      element.extension = ext
    }

    return element
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(key)] = key
    keyPaths[#keyPath(value)] = value
    keyPaths[#keyPath(accountId)] = accountId
    keyPaths[#keyPath(nick)] = nick
    keyPaths[#keyPath(V2NIMChatroomQueueElement.extension)] = self.extension
    return keyPaths
  }
}
