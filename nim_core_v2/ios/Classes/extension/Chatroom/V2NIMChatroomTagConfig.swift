// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMChatroomTagConfig {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMChatroomTagConfig {
    let config = V2NIMChatroomTagConfig()

    if let tags = arguments["tags"] as? [String] {
      config.tags = tags
    }

    if let notifyTargetTags = arguments["notifyTargetTags"] as? String {
      config.notifyTargetTags = notifyTargetTags
    }

    return config
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(tags)] = tags
    keyPaths[#keyPath(notifyTargetTags)] = notifyTargetTags
    return keyPaths
  }
}
