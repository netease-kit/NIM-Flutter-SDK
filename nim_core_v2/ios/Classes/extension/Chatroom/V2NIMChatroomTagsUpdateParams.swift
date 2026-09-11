// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMChatroomTagsUpdateParams {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMChatroomTagsUpdateParams {
    let params = V2NIMChatroomTagsUpdateParams()

    if let tags = arguments["tags"] as? [String] {
      params.tags = tags
    }

    if let notifyTargetTags = arguments["notifyTargetTags"] as? String {
      params.notifyTargetTags = notifyTargetTags
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
    keyPaths[#keyPath(tags)] = tags
    keyPaths[#keyPath(notifyTargetTags)] = notifyTargetTags
    keyPaths[#keyPath(notificationEnabled)] = notificationEnabled
    keyPaths[#keyPath(notificationExtension)] = notificationExtension
    return keyPaths
  }
}
