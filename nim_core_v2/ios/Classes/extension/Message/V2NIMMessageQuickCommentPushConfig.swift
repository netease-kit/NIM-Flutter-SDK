// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMMessageQuickCommentPushConfig {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMMessageQuickCommentPushConfig {
    let attach = V2NIMMessageQuickCommentPushConfig()

    if let pushEnabled = arguments["pushEnabled"] as? Bool {
      attach.pushEnabled = pushEnabled
    }

    if let needBadge = arguments["needBadge"] as? Bool {
      attach.needBadge = needBadge
    }

    if let title = arguments["pushTitle"] as? String {
      attach.pushTitle = title
    }

    if let pushContent = arguments["pushContent"] as? String {
      attach.pushContent = pushContent
    }

    if let pushPayload = arguments["pushPayload"] as? String {
      attach.pushPayload = pushPayload
    }

    return attach
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMMessageQuickCommentPushConfig.pushEnabled)] = pushEnabled
    keyPaths[#keyPath(V2NIMMessageQuickCommentPushConfig.needBadge)] = needBadge
    keyPaths[#keyPath(V2NIMMessageQuickCommentPushConfig.pushTitle)] = pushTitle
    keyPaths[#keyPath(V2NIMMessageQuickCommentPushConfig.pushContent)] = pushContent
    keyPaths[#keyPath(V2NIMMessageQuickCommentPushConfig.pushPayload)] = pushPayload
    return keyPaths
  }
}
