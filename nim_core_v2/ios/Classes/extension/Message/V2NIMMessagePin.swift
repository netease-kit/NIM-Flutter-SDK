// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMMessagePin {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMMessagePin {
    let attach = V2NIMMessagePin()

    if let messageRefer = arguments["messageRefer"] as? [String: Any] {
      attach.messageRefer = V2NIMMessageRefer.fromDic(messageRefer)
    }

    if let operatorId = arguments["operatorId"] as? String {
      attach.operatorId = operatorId
    }

    if let serverExtension = arguments["serverExtension"] as? String {
      attach.serverExtension = serverExtension
    }

    let createTime = arguments["createTime"] as? Double
    attach.createTime = TimeInterval((createTime ?? 0) / 1000)

    let updateTime = arguments["updateTime"] as? Double
    attach.updateTime = TimeInterval((updateTime ?? 0) / 1000)

    return attach
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMMessagePin.messageRefer)] = messageRefer?.toDic()
    keyPaths[#keyPath(V2NIMMessagePin.operatorId)] = operatorId
    keyPaths[#keyPath(V2NIMMessagePin.serverExtension)] = serverExtension
    keyPaths[#keyPath(V2NIMMessagePin.createTime)] = createTime * 1000
    keyPaths[#keyPath(V2NIMMessagePin.updateTime)] = updateTime * 1000
    return keyPaths
  }
}
