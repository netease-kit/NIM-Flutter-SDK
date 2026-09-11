// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMMessagePushConfig {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMMessagePushConfig {
    let attach = V2NIMMessagePushConfig()

    if let pushEnabled = arguments["pushEnabled"] as? Bool {
      attach.pushEnabled = pushEnabled
    }

    if let pushNickEnabled = arguments["pushNickEnabled"] as? Bool {
      attach.pushNickEnabled = pushNickEnabled
    }

    if let pushContent = arguments["pushContent"] as? String {
      attach.pushContent = pushContent
    }

    if let pushPayload = arguments["pushPayload"] as? String {
      attach.pushPayload = pushPayload
    }

    if let forcePush = arguments["forcePush"] as? Bool {
      attach.forcePush = forcePush
    }

    if let forcePushContent = arguments["forcePushContent"] as? String {
      attach.forcePushContent = forcePushContent
    }

    if let forcePushAccountIds = arguments["forcePushAccountIds"] as? [String] {
      attach.forcePushAccountIds = forcePushAccountIds
    }

    return attach
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMMessagePushConfig.pushEnabled)] = pushEnabled
    keyPaths[#keyPath(V2NIMMessagePushConfig.pushNickEnabled)] = pushNickEnabled
    keyPaths[#keyPath(V2NIMMessagePushConfig.pushContent)] = pushContent
    keyPaths[#keyPath(V2NIMMessagePushConfig.pushPayload)] = pushPayload
    keyPaths[#keyPath(V2NIMMessagePushConfig.forcePush)] = forcePush
    keyPaths[#keyPath(V2NIMMessagePushConfig.forcePushContent)] = forcePushContent
    keyPaths[#keyPath(V2NIMMessagePushConfig.forcePushAccountIds)] = forcePushAccountIds
    return keyPaths
  }
}
