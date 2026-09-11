// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMNotificationConfig {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMNotificationConfig {
    let attach = V2NIMNotificationConfig()

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
    keyPaths[#keyPath(V2NIMNotificationConfig.offlineEnabled)] = offlineEnabled
    keyPaths[#keyPath(V2NIMNotificationConfig.unreadEnabled)] = unreadEnabled
    return keyPaths
  }
}
