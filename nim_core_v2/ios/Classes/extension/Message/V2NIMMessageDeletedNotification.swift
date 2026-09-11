// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMMessageDeletedNotification {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMMessageDeletedNotification {
    let attach = V2NIMMessageDeletedNotification()

    if let messageRefer = arguments["messageRefer"] as? [String: Any] {
      attach.setValue(V2NIMMessageRefer.fromDic(messageRefer),
                      forKeyPath: #keyPath(V2NIMMessageDeletedNotification.serverExtension))
    }

    if let deleteTime = arguments["deleteTime"] as? Double {
      attach.setValue(TimeInterval(deleteTime / 1000),
                      forKeyPath: #keyPath(V2NIMMessageDeletedNotification.deleteTime))
    }

    if let serverExtension = arguments["serverExtension"] as? String {
      attach.setValue(serverExtension,
                      forKeyPath: #keyPath(V2NIMMessageDeletedNotification.serverExtension))
    }

    return attach
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMMessageDeletedNotification.messageRefer)] = messageRefer.toDic()
    keyPaths[#keyPath(V2NIMMessageDeletedNotification.deleteTime)] = deleteTime * 1000
    keyPaths[#keyPath(V2NIMMessageDeletedNotification.serverExtension)] = serverExtension
    return keyPaths
  }
}
