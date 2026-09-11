// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMChatroomQueueNotificationAttachment {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDictionary(_ arguments: [String: Any]) -> V2NIMChatroomQueueNotificationAttachment {
    let attach = V2NIMChatroomQueueNotificationAttachment()

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

    if let elementsDic = arguments["elements"] as? [[String: Any]] {
      let elements = elementsDic.map { V2NIMChatroomQueueElement.fromDic($0) }
      attach.setValue(elements, forKeyPath: #keyPath(V2NIMChatroomQueueNotificationAttachment.elements))
    }

    if let queueChangeType = arguments["queueChangeType"] as? Int,
       let queueChangeType = V2NIMChatroomQueueChangeType(rawValue: queueChangeType) {
      attach.setValue(queueChangeType.rawValue, forKeyPath: #keyPath(V2NIMChatroomQueueNotificationAttachment.queueChangeType))
    }

    return attach
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  override public func toDic() -> [String: Any] {
    var keyPaths = super.toDic()
    keyPaths[#keyPath(elements)] = elements.map { $0.toDic() }
    keyPaths[#keyPath(queueChangeType)] = queueChangeType.rawValue
    return keyPaths
  }
}
