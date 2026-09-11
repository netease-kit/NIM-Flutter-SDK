// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMMessageQuickComment {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMMessageQuickComment {
    let attach = V2NIMMessageQuickComment()

    if let messageRefer = arguments["messageRefer"] as? [String: Any] {
      attach.messageRefer = V2NIMMessageRefer.fromDic(messageRefer)
    }

    if let operatorId = arguments["operatorId"] as? String {
      attach.operatorId = operatorId
    }

    if let index = arguments["index"] as? Int {
      attach.index = TimeInterval(index)
    }

    let createTime = arguments["createTime"] as? Double
    attach.createTime = TimeInterval((createTime ?? 0) / 1000)

    if let serverExtension = arguments["serverExtension"] as? String {
      attach.serverExtension = serverExtension
    }

    return attach
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMMessageQuickComment.messageRefer)] = messageRefer.toDic()
    keyPaths[#keyPath(V2NIMMessageQuickComment.operatorId)] = operatorId
    keyPaths[#keyPath(V2NIMMessageQuickComment.index)] = index
    keyPaths[#keyPath(V2NIMMessageQuickComment.createTime)] = createTime * 1000
    keyPaths[#keyPath(V2NIMMessageQuickComment.serverExtension)] = serverExtension
    return keyPaths
  }
}
