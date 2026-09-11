// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMClearHistoryMessageOption {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMClearHistoryMessageOption {
    let attach = V2NIMClearHistoryMessageOption()

    if let conversationId = arguments["conversationId"] as? String {
      attach.conversationId = conversationId
    }

    if let deleteRoam = arguments["deleteRoam"] as? Bool {
      attach.deleteRoam = deleteRoam
    }

    if let onlineSync = arguments["onlineSync"] as? Bool {
      attach.onlineSync = onlineSync
    }

    if let serverExtension = arguments["serverExtension"] as? String {
      attach.serverExtension = serverExtension
    }

    if let clearModeInt = arguments["clearMode"] as? UInt,
       let clearMode = V2NIMClearHistoryMode(rawValue: clearModeInt) {
      attach.clearMode = clearMode
    }

    return attach
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMClearHistoryMessageOption.conversationId)] = conversationId
    keyPaths[#keyPath(V2NIMClearHistoryMessageOption.deleteRoam)] = deleteRoam
    keyPaths[#keyPath(V2NIMClearHistoryMessageOption.onlineSync)] = onlineSync
    keyPaths[#keyPath(V2NIMClearHistoryMessageOption.serverExtension)] = serverExtension
    keyPaths[#keyPath(V2NIMClearHistoryMessageOption.clearMode)] = clearMode.rawValue
    return keyPaths
  }
}
