// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMMessageRevokeNotification {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMMessageRevokeNotification {
    let attach = V2NIMMessageRevokeNotification()

    if let messageRefer = arguments["messageRefer"] as? [String: Any] {
      attach.setValue(V2NIMMessageRefer.fromDic(messageRefer),
                      forKeyPath: #keyPath(V2NIMMessageRevokeNotification.messageRefer))
    }

    if let serverExtension = arguments["serverExtension"] as? String {
      attach.setValue(serverExtension,
                      forKeyPath: #keyPath(V2NIMMessageRevokeNotification.serverExtension))
    }

    if let revokeAccountId = arguments["revokeAccountId"] as? String {
      attach.setValue(revokeAccountId,
                      forKeyPath: #keyPath(V2NIMMessageRevokeNotification.revokeAccountId))
    }

    if let postscript = arguments["postscript"] as? String {
      attach.setValue(postscript,
                      forKeyPath: #keyPath(V2NIMMessageRevokeNotification.postscript))
    }

    if let type = arguments["revokeType"] as? UInt,
       let revokeType = V2NIMMessageRevokeType(rawValue: type) {
      attach.setValue(revokeType.rawValue,
                      forKeyPath: #keyPath(V2NIMMessageRevokeNotification.revokeType))
    }

    if let callbackExtension = arguments["callbackExtension"] as? String {
      attach.setValue(callbackExtension,
                      forKeyPath: #keyPath(V2NIMMessageRevokeNotification.callbackExtension))
    }

    return attach
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMMessageRevokeNotification.messageRefer)] = messageRefer?.toDic()
    keyPaths[#keyPath(V2NIMMessageRevokeNotification.serverExtension)] = serverExtension
    keyPaths[#keyPath(V2NIMMessageRevokeNotification.revokeAccountId)] = revokeAccountId
    keyPaths[#keyPath(V2NIMMessageRevokeNotification.postscript)] = postscript
    keyPaths[#keyPath(V2NIMMessageRevokeNotification.revokeType)] = revokeType.rawValue
    keyPaths[#keyPath(V2NIMMessageRevokeNotification.callbackExtension)] = callbackExtension
    return keyPaths
  }
}
