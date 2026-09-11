// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMMessageRefer {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMMessageRefer {
    let attach = V2NIMMessageRefer()

    if let senderId = arguments["senderId"] as? String {
      attach.senderId = senderId
    }

    if let receiverId = arguments["receiverId"] as? String {
      attach.receiverId = receiverId
    }

    if let messageClientId = arguments["messageClientId"] as? String {
      attach.messageClientId = messageClientId
    }

    if let messageServerId = arguments["messageServerId"] as? String {
      attach.messageServerId = messageServerId
    }

    if let type = arguments["conversationType"] as? Int,
       let conversationType = V2NIMConversationType(rawValue: type) {
      attach.conversationType = conversationType
    }

    if let conversationId = arguments["conversationId"] as? String {
      attach.conversationId = conversationId
    }

    let createTime = arguments["createTime"] as? Double
    attach.createTime = TimeInterval((createTime ?? 0) / 1000)

    return attach
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMMessageRefer.senderId)] = senderId
    keyPaths[#keyPath(V2NIMMessageRefer.receiverId)] = receiverId
    keyPaths[#keyPath(V2NIMMessageRefer.messageClientId)] = messageClientId
    keyPaths[#keyPath(V2NIMMessageRefer.messageServerId)] = messageServerId
    keyPaths[#keyPath(V2NIMMessageRefer.conversationType)] = conversationType.rawValue
    keyPaths[#keyPath(V2NIMMessageRefer.conversationId)] = conversationId
    keyPaths[#keyPath(V2NIMMessageRefer.createTime)] = createTime * 1000
    return keyPaths
  }
}
