// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMChatroomSelfMemberUpdateParams {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMChatroomSelfMemberUpdateParams {
    let params = V2NIMChatroomSelfMemberUpdateParams()

    if let roomNick = arguments["roomNick"] as? String {
      params.roomNick = roomNick
    }

    if let roomAvatar = arguments["roomAvatar"] as? String {
      params.roomAvatar = roomAvatar
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

    if let persistence = arguments["persistence"] as? Bool {
      params.persistence = persistence
    }

    return params
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(roomNick)] = roomNick
    keyPaths[#keyPath(roomAvatar)] = roomAvatar
    keyPaths[#keyPath(serverExtension)] = serverExtension
    keyPaths[#keyPath(notificationEnabled)] = notificationEnabled
    keyPaths[#keyPath(notificationExtension)] = notificationExtension
    keyPaths[#keyPath(persistence)] = persistence
    return keyPaths
  }
}
