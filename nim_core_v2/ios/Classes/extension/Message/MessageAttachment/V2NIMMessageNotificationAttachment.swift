// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMMessageNotificationAttachment {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDict(_ arguments: [String: Any]) -> V2NIMMessageNotificationAttachment {
    let superAttach = super.fromDic(arguments)
    let attach = V2NIMMessageNotificationAttachment()
    attach.raw = superAttach.raw

    if let type = arguments["type"] as? Int,
       let notiType = V2NIMMessageNotificationType(rawValue: type) {
      attach.type = notiType
    }

    if let serverExtension = arguments["serverExtension"] as? String {
      attach.serverExtension = serverExtension
    }

    if let targetIds = arguments["targetIds"] as? [String] {
      attach.targetIds = targetIds
    }

    if let chatBanned = arguments["chatBanned"] as? Bool {
      attach.chatBanned = chatBanned
    }

    if let updatedTeamInfo = arguments["updatedTeamInfo"] as? [String: Any] {
      attach.updatedTeamInfo = V2NIMUpdatedTeamInfo.fromDic(updatedTeamInfo)
    }

    return attach
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  override public func toDic() -> [String: Any] {
    var keyPaths = super.toDic()
    keyPaths[nimCoreMessageType] = V2NIMMessageType.MESSAGE_TYPE_NOTIFICATION.rawValue
    keyPaths[#keyPath(V2NIMMessageNotificationAttachment.type)] = type.rawValue
    keyPaths[#keyPath(V2NIMMessageNotificationAttachment.serverExtension)] = serverExtension
    keyPaths[#keyPath(V2NIMMessageNotificationAttachment.targetIds)] = targetIds
    keyPaths[#keyPath(V2NIMMessageNotificationAttachment.chatBanned)] = chatBanned
    keyPaths[#keyPath(V2NIMMessageNotificationAttachment.updatedTeamInfo)] = updatedTeamInfo?.toDic()
    return keyPaths
  }
}
