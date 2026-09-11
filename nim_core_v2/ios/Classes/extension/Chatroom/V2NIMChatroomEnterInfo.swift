// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMChatroomEnterInfo {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMChatroomEnterInfo {
    let info = V2NIMChatroomEnterInfo()

    if let roomNick = arguments["roomNick"] as? String {
      info.setValue(roomNick,
                    forKeyPath: #keyPath(V2NIMChatroomEnterInfo.roomNick))
    }

    if let roomAvatar = arguments["roomAvatar"] as? String {
      info.setValue(roomAvatar,
                    forKeyPath: #keyPath(V2NIMChatroomEnterInfo.roomAvatar))
    }

    if let enterTime = arguments["enterTime"] as? Int {
      info.setValue(enterTime / 1000,
                    forKeyPath: #keyPath(V2NIMChatroomEnterInfo.enterTime))
    }

    if let clientType = arguments["clientType"] as? Int {
      info.setValue(clientType,
                    forKeyPath: #keyPath(V2NIMChatroomEnterInfo.clientType))
    }

    return info
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(roomNick)] = roomNick
    keyPaths[#keyPath(roomAvatar)] = roomAvatar
    keyPaths[#keyPath(enterTime)] = enterTime * 1000
    keyPaths[#keyPath(clientType)] = clientType
    return keyPaths
  }
}
