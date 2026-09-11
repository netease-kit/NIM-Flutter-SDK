// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMChatroomKickedInfo {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMChatroomKickedInfo {
    let info = V2NIMChatroomKickedInfo()

    if let kickedReason = arguments["kickedReason"] as? Int,
       let kickedReason = V2NIMChatroomKickedReason(rawValue: kickedReason) {
      info.setValue(kickedReason.rawValue,
                    forKeyPath: #keyPath(V2NIMChatroomKickedInfo.kickedReason))
    }

    if let serverExtension = arguments["serverExtension"] as? String {
      info.setValue(serverExtension,
                    forKeyPath: #keyPath(V2NIMChatroomKickedInfo.serverExtension))
    }

    return info
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(kickedReason)] = kickedReason.rawValue
    keyPaths[#keyPath(serverExtension)] = serverExtension
    return keyPaths
  }
}
