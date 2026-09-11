// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMMessageSearchParams {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMMessageSearchParams {
    let attach = V2NIMMessageSearchParams()

    if let keyword = arguments["keyword"] as? String {
      attach.keyword = keyword
    }

    let beginTime = arguments["beginTime"] as? Double
    attach.beginTime = TimeInterval((beginTime ?? 0) / 1000)

    let endTime = arguments["endTime"] as? Double
    attach.endTime = TimeInterval((endTime ?? 0) / 1000)

    if let conversationLimit = arguments["conversationLimit"] as? UInt {
      attach.conversationLimit = conversationLimit
    }

    if let messageLimit = arguments["messageLimit"] as? UInt {
      attach.messageLimit = messageLimit
    }

    if let order = arguments["sortOrder"] as? Int,
       let sortOrder = V2NIMSortOrder(rawValue: order) {
      attach.sortOrder = sortOrder
    }

    if let p2pAccountIds = arguments["p2pAccountIds"] as? [String] {
      attach.p2pAccountIds = p2pAccountIds
    }

    if let teamIds = arguments["teamIds"] as? [String] {
      attach.teamIds = teamIds
    }

    if let senderAccountIds = arguments["senderAccountIds"] as? [String] {
      attach.senderAccountIds = senderAccountIds
    }

    if let messageTypes = arguments["messageTypes"] as? [Int] {
      var types = [Int]()
      for type in messageTypes {
        if let _ = V2NIMMessageType(rawValue: type) {
          types.append(type)
        }
      }
      attach.messageTypes = types
    }

    if let messageSubtypes = arguments["messageSubtypes"] as? [Int] {
      attach.messageSubtypes = messageSubtypes
    }

    return attach
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMMessageSearchParams.keyword)] = keyword
    keyPaths[#keyPath(V2NIMMessageSearchParams.beginTime)] = beginTime * 1000
    keyPaths[#keyPath(V2NIMMessageSearchParams.endTime)] = endTime * 1000
    keyPaths[#keyPath(V2NIMMessageSearchParams.conversationLimit)] = conversationLimit
    keyPaths[#keyPath(V2NIMMessageSearchParams.messageLimit)] = messageLimit
    keyPaths[#keyPath(V2NIMMessageSearchParams.sortOrder)] = sortOrder.rawValue
    keyPaths[#keyPath(V2NIMMessageSearchParams.p2pAccountIds)] = p2pAccountIds
    keyPaths[#keyPath(V2NIMMessageSearchParams.teamIds)] = teamIds
    keyPaths[#keyPath(V2NIMMessageSearchParams.senderAccountIds)] = senderAccountIds
    keyPaths[#keyPath(V2NIMMessageSearchParams.messageTypes)] = messageTypes
    keyPaths[#keyPath(V2NIMMessageSearchParams.messageSubtypes)] = messageSubtypes
    return keyPaths
  }
}
