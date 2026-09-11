// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMMessageListOption {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMMessageListOption {
    let attach = V2NIMMessageListOption()

    if let conversationId = arguments["conversationId"] as? String {
      attach.conversationId = conversationId
    }

    if let messageTypes = arguments["messageTypes"] as? [Int] {
      attach.messageTypes = messageTypes
    }

    let beginTime = arguments["beginTime"] as? Double
    attach.beginTime = TimeInterval((beginTime ?? 0) / 1000)

    let endTime = arguments["endTime"] as? Double
    attach.endTime = TimeInterval((endTime ?? 0) / 1000)

    if let limit = arguments["limit"] as? Int {
      attach.limit = limit
    }

    if let anchorMessage = arguments["anchorMessage"] as? [String: Any] {
      attach.anchorMessage = V2NIMMessage.fromDict(anchorMessage)
    }

    if let dir = arguments["direction"] as? Int,
       let direction = V2NIMQueryDirection(rawValue: dir) {
      attach.direction = direction
    }

    if let strictMode = arguments["strictMode"] as? Bool {
      attach.strictMode = strictMode
    }

    if let onlyQueryLocal = arguments["onlyQueryLocal"] as? Bool {
      attach.onlyQueryLocal = onlyQueryLocal
    }

    return attach
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMMessageListOption.conversationId)] = conversationId
    keyPaths[#keyPath(V2NIMMessageListOption.messageTypes)] = messageTypes
    keyPaths[#keyPath(V2NIMMessageListOption.beginTime)] = beginTime * 1000
    keyPaths[#keyPath(V2NIMMessageListOption.endTime)] = endTime * 1000
    keyPaths[#keyPath(V2NIMMessageListOption.limit)] = limit
    keyPaths[#keyPath(V2NIMMessageListOption.anchorMessage)] = anchorMessage?.toDic()
    keyPaths[#keyPath(V2NIMMessageListOption.direction)] = direction.rawValue
    keyPaths[#keyPath(V2NIMMessageListOption.strictMode)] = strictMode
    return keyPaths
  }
}
