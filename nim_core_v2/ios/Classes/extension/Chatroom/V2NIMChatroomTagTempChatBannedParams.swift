// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMChatroomTagTempChatBannedParams {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMChatroomTagTempChatBannedParams {
    let params = V2NIMChatroomTagTempChatBannedParams()

    if let targetTag = arguments["targetTag"] as? String {
      params.targetTag = targetTag
    }

    if let notifyTargetTags = arguments["notifyTargetTags"] as? String {
      params.notifyTargetTags = notifyTargetTags
    }

    if let duration = arguments["duration"] as? UInt {
      params.duration = duration
    }

    if let notificationEnabled = arguments["notificationEnabled"] as? Bool {
      params.notificationEnabled = notificationEnabled
    }

    if let notificationExtension = arguments["notificationExtension"] as? String {
      params.notificationExtension = notificationExtension
    }

    return params
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(targetTag)] = targetTag
    keyPaths[#keyPath(notifyTargetTags)] = notifyTargetTags
    keyPaths[#keyPath(duration)] = duration
    keyPaths[#keyPath(notificationEnabled)] = notificationEnabled
    keyPaths[#keyPath(notificationExtension)] = notificationExtension
    return keyPaths
  }
}
