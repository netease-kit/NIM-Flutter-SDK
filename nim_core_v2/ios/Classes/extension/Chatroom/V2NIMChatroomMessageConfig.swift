// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMChatroomMessageConfig {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMChatroomMessageConfig {
    let config = V2NIMChatroomMessageConfig()

    if let historyEnabled = arguments["historyEnabled"] as? Bool {
      config.historyEnabled = historyEnabled
    }

    if let highPriority = arguments["highPriority"] as? Bool {
      config.highPriority = highPriority
    }

    return config
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(historyEnabled)] = historyEnabled
    keyPaths[#keyPath(highPriority)] = highPriority
    return keyPaths
  }
}
