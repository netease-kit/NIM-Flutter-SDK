// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMChatroomMessageListOption {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMChatroomMessageListOption {
    let option = V2NIMChatroomMessageListOption()

    if let direction = arguments["direction"] as? Int,
       let direction = V2NIMQueryDirection(rawValue: direction) {
      option.direction = direction
    }

    if let messageTypes = arguments["messageTypes"] as? [Int] {
      option.messageTypes = messageTypes
    }

    if let beginTime = arguments["beginTime"] as? Int {
      option.beginTime = TimeInterval(beginTime / 1000)
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
    keyPaths[#keyPath(direction)] = direction.rawValue
    keyPaths[#keyPath(beginTime)] = beginTime * 1000
    keyPaths[#keyPath(limit)] = limit

    if let messageTypes = messageTypes {
      var messageTypeList = [Int]()
      for messageType in messageTypes {
        if let messageType = messageType as? V2NIMMessageType {
          messageTypeList.append(messageType.rawValue)
        }
      }
      keyPaths[#keyPath(V2NIMChatroomMessageListOption.messageTypes)] = messageTypeList
    }
    return keyPaths
  }
}
