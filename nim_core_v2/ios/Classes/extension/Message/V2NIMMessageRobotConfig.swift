// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMMessageRobotConfig {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMMessageRobotConfig {
    let attach = V2NIMMessageRobotConfig()

    if let accountId = arguments["accountId"] as? String {
      attach.accountId = accountId
    }

    if let topic = arguments["topic"] as? String {
      attach.topic = topic
    }

    if let function = arguments["function"] as? String {
      attach.function = function
    }

    if let customContent = arguments["customContent"] as? String {
      attach.customContent = customContent
    }

    return attach
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMMessageRobotConfig.accountId)] = accountId
    keyPaths[#keyPath(V2NIMMessageRobotConfig.topic)] = topic
    keyPaths[#keyPath(V2NIMMessageRobotConfig.function)] = function
    keyPaths[#keyPath(V2NIMMessageRobotConfig.customContent)] = customContent
    return keyPaths
  }
}
