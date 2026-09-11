// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMMessageConfig {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMMessageConfig {
    let attach = V2NIMMessageConfig()

    if let readReceiptEnabled = arguments["readReceiptEnabled"] as? Bool {
      attach.readReceiptEnabled = readReceiptEnabled
    }

    if let lastMessageUpdateEnabled = arguments["lastMessageUpdateEnabled"] as? Bool {
      attach.lastMessageUpdateEnabled = lastMessageUpdateEnabled
    }

    if let historyEnabled = arguments["historyEnabled"] as? Bool {
      attach.historyEnabled = historyEnabled
    }

    if let roamingEnabled = arguments["roamingEnabled"] as? Bool {
      attach.roamingEnabled = roamingEnabled
    }

    if let onlineSyncEnabled = arguments["onlineSyncEnabled"] as? Bool {
      attach.onlineSyncEnabled = onlineSyncEnabled
    }

    if let offlineEnabled = arguments["offlineEnabled"] as? Bool {
      attach.offlineEnabled = offlineEnabled
    }

    if let unreadEnabled = arguments["unreadEnabled"] as? Bool {
      attach.unreadEnabled = unreadEnabled
    }

    return attach
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMMessageConfig.readReceiptEnabled)] = readReceiptEnabled
    keyPaths[#keyPath(V2NIMMessageConfig.lastMessageUpdateEnabled)] = lastMessageUpdateEnabled
    keyPaths[#keyPath(V2NIMMessageConfig.historyEnabled)] = historyEnabled
    keyPaths[#keyPath(V2NIMMessageConfig.roamingEnabled)] = roamingEnabled
    keyPaths[#keyPath(V2NIMMessageConfig.onlineSyncEnabled)] = onlineSyncEnabled
    keyPaths[#keyPath(V2NIMMessageConfig.offlineEnabled)] = offlineEnabled
    keyPaths[#keyPath(V2NIMMessageConfig.unreadEnabled)] = unreadEnabled
    return keyPaths
  }
}
