// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMMessageQuickCommentNotification {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMMessageQuickCommentNotification {
    let attach = V2NIMMessageQuickCommentNotification()

    if let type = arguments["operationType"] as? UInt,
       let operationType = V2NIMMessageQuickCommentType(rawValue: type) {
      attach.operationType = operationType
    }

    if let quickComment = arguments["quickComment"] as? [String: Any] {
      attach.quickComment = V2NIMMessageQuickComment.fromDic(quickComment)
    }

    return attach
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMMessageQuickCommentNotification.operationType)] = operationType.rawValue
    keyPaths[#keyPath(V2NIMMessageQuickCommentNotification.quickComment)] = quickComment.toDic()
    return keyPaths
  }
}
