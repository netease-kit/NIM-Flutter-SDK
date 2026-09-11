// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMChatroomNotificationAttachment {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDict(_ arguments: [String: Any]) -> V2NIMChatroomNotificationAttachment {
    let superAttach = V2NIMChatroomNotificationAttachment.fromDic(arguments)
    let attach = V2NIMChatroomNotificationAttachment()
    attach.raw = superAttach.raw

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

    return attach
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  override public func toDic() -> [String: Any] {
    var keyPaths = super.toDic()
    keyPaths[nimCoreMessageType] = 105
    keyPaths[#keyPath(type)] = type.rawValue
    keyPaths[#keyPath(targetIds)] = targetIds
    keyPaths[#keyPath(targetNicks)] = targetNicks
    keyPaths[#keyPath(targetTag)] = targetTag
    keyPaths[#keyPath(operatorId)] = operatorId
    keyPaths[#keyPath(operatorNick)] = operatorNick
    keyPaths[#keyPath(notificationExtension)] = notificationExtension
    keyPaths[#keyPath(tags)] = tags
    return keyPaths
  }
}
