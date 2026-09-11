// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMUserInfoConfig {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMUserInfoConfig {
    let config = V2NIMUserInfoConfig()

    if let userInfoTimestamp = arguments["userInfoTimestamp"] as? Int {
      config.userInfoTimestamp = TimeInterval(userInfoTimestamp / 1000)
    }

    if let senderNick = arguments["senderNick"] as? String {
      config.senderNick = senderNick
    }

    if let senderAvatar = arguments["senderAvatar"] as? String {
      config.senderAvatar = senderAvatar
    }

    if let senderExtension = arguments["senderExtension"] as? String {
      config.senderExtension = senderExtension
    }

    return config
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(userInfoTimestamp)] = userInfoTimestamp * 1000
    keyPaths[#keyPath(senderNick)] = senderNick
    keyPaths[#keyPath(senderAvatar)] = senderAvatar
    keyPaths[#keyPath(senderExtension)] = senderExtension
    return keyPaths
  }
}
