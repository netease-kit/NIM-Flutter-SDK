// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMThreadMessageListOption {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMThreadMessageListOption {
    let attach = V2NIMThreadMessageListOption()

    if let messageRefer = arguments["messageRefer"] as? [String: Any] {
      attach.messageRefer = V2NIMMessageRefer.fromDic(messageRefer)
    }

    let beginTime = arguments["beginTime"] as? Double
    attach.beginTime = TimeInterval((beginTime ?? 0) / 1000)

    let endTime = arguments["endTime"] as? Double
    attach.endTime = TimeInterval((endTime ?? 0) / 1000)

    if let excludeMessageServerId = arguments["excludeMessageServerId"] as? String {
      attach.excludeMessageServerId = excludeMessageServerId
    }

    if let limit = arguments["limit"] as? Int {
      attach.limit = limit
    }

    if let dir = arguments["direction"] as? Int,
       let direction = V2NIMQueryDirection(rawValue: dir) {
      attach.direction = direction
    }

    return attach
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMThreadMessageListOption.messageRefer)] = messageRefer.toDic()
    keyPaths[#keyPath(V2NIMThreadMessageListOption.beginTime)] = beginTime * 1000
    keyPaths[#keyPath(V2NIMThreadMessageListOption.endTime)] = endTime * 1000
    keyPaths[#keyPath(V2NIMThreadMessageListOption.excludeMessageServerId)] = excludeMessageServerId
    keyPaths[#keyPath(V2NIMThreadMessageListOption.limit)] = limit
    keyPaths[#keyPath(V2NIMThreadMessageListOption.direction)] = direction.rawValue
    return keyPaths
  }
}
