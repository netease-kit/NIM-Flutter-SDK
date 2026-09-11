// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMChatroomChatBannedNotificationAttachment {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDictionary(_ arguments: [String: Any]) -> V2NIMChatroomChatBannedNotificationAttachment {
    let attach = V2NIMChatroomChatBannedNotificationAttachment()

    if let type = arguments["type"] as? Int,
       let type = V2NIMChatroomMessageNotificationType(rawValue: type) {
      attach.setValue(type.rawValue, forKeyPath: #keyPath(V2NIMChatroomNotificationAttachment.type))
    }

    if let targetIds = arguments["targetIds"] as? [String] {
      attach.setValue(targetIds, forKeyPath: #keyPath(V2NIMChatroomNotificationAttachment.targetIds))
    }

    if let targetNicks = arguments["targetNicks"] as? [String] {
      attach.setValue(targetNicks, forKeyPath: #keyPath(V2NIMChatroomNotificationAttachment.targetNicks))
    }

    if let targetTag = arguments["targetTag"] as? String {
      attach.setValue(targetTag, forKeyPath: #keyPath(V2NIMChatroomNotificationAttachment.targetTag))
    }

    if let operatorId = arguments["operatorId"] as? String {
      attach.setValue(operatorId, forKeyPath: #keyPath(V2NIMChatroomNotificationAttachment.operatorId))
    }

    if let operatorNick = arguments["operatorNick"] as? String {
      attach.setValue(operatorNick, forKeyPath: #keyPath(V2NIMChatroomNotificationAttachment.operatorNick))
    }

    if let notificationExtension = arguments["notificationExtension"] as? String {
      attach.setValue(notificationExtension, forKeyPath: #keyPath(V2NIMChatroomNotificationAttachment.notificationExtension))
    }

    if let tags = arguments["tags"] as? [String] {
      attach.setValue(tags, forKeyPath: #keyPath(V2NIMChatroomNotificationAttachment.tags))
    }

    if let chatBanned = arguments["chatBanned"] as? Bool {
      attach.setValue(chatBanned, forKeyPath: #keyPath(V2NIMChatroomChatBannedNotificationAttachment.chatBanned))
    }

    if let tempChatBanned = arguments["tempChatBanned"] as? Bool {
      attach.setValue(tempChatBanned, forKeyPath: #keyPath(V2NIMChatroomChatBannedNotificationAttachment.tempChatBanned))
    }

    if let tempChatBannedDuration = arguments["tempChatBannedDuration"] as? Int {
      attach.setValue(TimeInterval(tempChatBannedDuration / 1000), forKeyPath: #keyPath(V2NIMChatroomChatBannedNotificationAttachment.tempChatBannedDuration))
    }

    return attach
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  override public func toDic() -> [String: Any] {
    var keyPaths = super.toDic()
    keyPaths[#keyPath(chatBanned)] = chatBanned
    keyPaths[#keyPath(tempChatBanned)] = tempChatBanned
    keyPaths[#keyPath(tempChatBannedDuration)] = tempChatBannedDuration * 1000
    return keyPaths
  }
}
