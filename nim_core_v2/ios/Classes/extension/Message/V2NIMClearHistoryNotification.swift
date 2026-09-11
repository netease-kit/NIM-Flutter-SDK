// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMClearHistoryNotification {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMClearHistoryNotification {
    let attach = V2NIMClearHistoryNotification()

    if let conversationId = arguments["conversationId"] as? String {
      attach.setValue(conversationId,
                      forKeyPath: #keyPath(V2NIMClearHistoryNotification.conversationId))
    }

    if let deleteTime = arguments["deleteTime"] as? Double {
      attach.setValue(TimeInterval(deleteTime / 1000),
                      forKeyPath: #keyPath(V2NIMClearHistoryNotification.deleteTime))
    }

    if let serverExtension = arguments["serverExtension"] as? String {
      attach.setValue(serverExtension,
                      forKeyPath: #keyPath(V2NIMClearHistoryNotification.serverExtension))
    }

    return attach
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMClearHistoryNotification.conversationId)] = conversationId
    keyPaths[#keyPath(V2NIMClearHistoryNotification.deleteTime)] = deleteTime * 1000
    keyPaths[#keyPath(V2NIMClearHistoryNotification.serverExtension)] = serverExtension
    return keyPaths
  }
}
