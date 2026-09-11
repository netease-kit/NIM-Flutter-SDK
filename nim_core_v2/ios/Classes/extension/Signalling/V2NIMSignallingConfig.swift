// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMSignallingConfig {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMSignallingConfig {
    let config = V2NIMSignallingConfig()

    if let offlineEnabled = arguments["offlineEnabled"] as? Bool {
      config.offlineEnabled = offlineEnabled
    }

    if let unreadEnabled = arguments["unreadEnabled"] as? Bool {
      config.unreadEnabled = unreadEnabled
    }

    if let selfUid = arguments["selfUid"] as? Int {
      config.selfUid = selfUid
    }

    return config
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMSignallingConfig.offlineEnabled)] = offlineEnabled
    keyPaths[#keyPath(V2NIMSignallingConfig.unreadEnabled)] = unreadEnabled
    keyPaths[#keyPath(V2NIMSignallingConfig.selfUid)] = selfUid
    return keyPaths
  }
}
