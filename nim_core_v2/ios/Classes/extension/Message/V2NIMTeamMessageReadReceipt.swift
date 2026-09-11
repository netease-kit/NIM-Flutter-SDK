// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMTeamMessageReadReceipt {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMTeamMessageReadReceipt {
    let attach = V2NIMTeamMessageReadReceipt()

    if let conversationId = arguments["conversationId"] as? String {
      attach.setValue(conversationId,
                      forKeyPath: #keyPath(V2NIMTeamMessageReadReceipt.conversationId))
    }

    if let messageServerId = arguments["messageServerId"] as? String {
      attach.setValue(messageServerId,
                      forKeyPath: #keyPath(V2NIMTeamMessageReadReceipt.messageServerId))
    }

    if let messageClientId = arguments["messageClientId"] as? String {
      attach.setValue(messageClientId,
                      forKeyPath: #keyPath(V2NIMTeamMessageReadReceipt.messageClientId))
    }

    if let readCount = arguments["readCount"] as? Int {
      attach.setValue(readCount,
                      forKeyPath: #keyPath(V2NIMTeamMessageReadReceipt.readCount))
    }

    if let unreadCount = arguments["unreadCount"] as? Int {
      attach.setValue(unreadCount,
                      forKeyPath: #keyPath(V2NIMTeamMessageReadReceipt.unreadCount))
    }

    if let latestReadAccount = arguments["latestReadAccount"] as? String {
      attach.setValue(latestReadAccount,
                      forKeyPath: #keyPath(V2NIMTeamMessageReadReceipt.latestReadAccount))
    }

    return attach
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMTeamMessageReadReceipt.conversationId)] = conversationId
    keyPaths[#keyPath(V2NIMTeamMessageReadReceipt.messageServerId)] = messageServerId
    keyPaths[#keyPath(V2NIMTeamMessageReadReceipt.messageClientId)] = messageClientId
    keyPaths[#keyPath(V2NIMTeamMessageReadReceipt.readCount)] = readCount
    keyPaths[#keyPath(V2NIMTeamMessageReadReceipt.unreadCount)] = unreadCount
    keyPaths[#keyPath(V2NIMTeamMessageReadReceipt.latestReadAccount)] = latestReadAccount
    return keyPaths
  }
}
