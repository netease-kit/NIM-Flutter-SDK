// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMChatroomInfo {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMChatroomInfo {
    let info = V2NIMChatroomInfo()

    if let roomId = arguments["roomId"] as? String {
      info.setValue(roomId,
                    forKeyPath: #keyPath(V2NIMChatroomInfo.roomId))
    }

    if let roomName = arguments["roomName"] as? String {
      info.setValue(roomName,
                    forKeyPath: #keyPath(V2NIMChatroomInfo.roomName))
    }

    if let announcement = arguments["announcement"] as? String {
      info.setValue(announcement,
                    forKeyPath: #keyPath(V2NIMChatroomInfo.announcement))
    }

    if let liveUrl = arguments["liveUrl"] as? String {
      info.setValue(liveUrl,
                    forKeyPath: #keyPath(V2NIMChatroomInfo.liveUrl))
    }

    if let isValidRoom = arguments["isValidRoom"] as? Bool {
      info.setValue(isValidRoom,
                    forKeyPath: #keyPath(V2NIMChatroomInfo.isValidRoom))
    }

    if let serverExtension = arguments["serverExtension"] as? String {
      info.setValue(serverExtension,
                    forKeyPath: #keyPath(V2NIMChatroomInfo.serverExtension))
    }

    if let queueLevelMode = arguments["queueLevelMode"] as? Int,
       let queueLevelMode = V2NIMChatroomQueueLevelMode(rawValue: queueLevelMode) {
      info.setValue(queueLevelMode.rawValue,
                    forKeyPath: #keyPath(V2NIMChatroomInfo.queueLevelMode))
    }

    if let creatorAccountId = arguments["creatorAccountId"] as? String {
      info.setValue(creatorAccountId,
                    forKeyPath: #keyPath(V2NIMChatroomInfo.creatorAccountId))
    }

    if let onlineUserCount = arguments["onlineUserCount"] as? Int {
      info.setValue(onlineUserCount,
                    forKeyPath: #keyPath(V2NIMChatroomInfo.onlineUserCount))
    }

    if let chatBanned = arguments["chatBanned"] as? Bool {
      info.setValue(chatBanned,
                    forKeyPath: #keyPath(V2NIMChatroomInfo.chatBanned))
    }

    return info
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(roomId)] = roomId
    keyPaths[#keyPath(roomName)] = roomName
    keyPaths[#keyPath(announcement)] = announcement
    keyPaths[#keyPath(liveUrl)] = liveUrl
    keyPaths[#keyPath(isValidRoom)] = isValidRoom
    keyPaths[#keyPath(serverExtension)] = serverExtension
    keyPaths[#keyPath(queueLevelMode)] = queueLevelMode.rawValue
    keyPaths[#keyPath(creatorAccountId)] = creatorAccountId
    keyPaths[#keyPath(onlineUserCount)] = onlineUserCount
    keyPaths[#keyPath(chatBanned)] = chatBanned
    return keyPaths
  }
}
