// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMChatroomUpdateParams {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMChatroomUpdateParams {
    let params = V2NIMChatroomUpdateParams()

    if let roomName = arguments["roomName"] as? String {
      params.roomName = roomName
    }

    if let announcement = arguments["announcement"] as? String {
      params.announcement = announcement
    }

    if let liveUrl = arguments["liveUrl"] as? String {
      params.liveUrl = liveUrl
    }

    if let serverExtension = arguments["serverExtension"] as? String {
      params.serverExtension = serverExtension
    }

    if let notificationEnabled = arguments["notificationEnabled"] as? Bool {
      params.notificationEnabled = notificationEnabled
    }

    if let notificationExtension = arguments["notificationExtension"] as? String {
      params.notificationExtension = notificationExtension
    }

    return params
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(roomName)] = roomName
    keyPaths[#keyPath(announcement)] = announcement
    keyPaths[#keyPath(liveUrl)] = liveUrl
    keyPaths[#keyPath(serverExtension)] = serverExtension
    keyPaths[#keyPath(notificationEnabled)] = notificationEnabled
    keyPaths[#keyPath(notificationExtension)] = notificationExtension
    return keyPaths
  }
}
