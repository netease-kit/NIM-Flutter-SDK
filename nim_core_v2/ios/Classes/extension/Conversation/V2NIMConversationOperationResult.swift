// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMConversationOperationResult {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMConversationOperationResult {
    let result = V2NIMConversationOperationResult()

    if let conversationId = arguments["conversationId"] as? String {
      result.setValue(conversationId,
                      forKeyPath: #keyPath(V2NIMConversationOperationResult.conversationId))
    }

    if let error = arguments["error"] as? [String: Any] {
      result.setValue(V2NIMError.fromDic(error),
                      forKeyPath: #keyPath(V2NIMConversationOperationResult.error))
    }

    return result
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(conversationId)] = conversationId
    keyPaths[#keyPath(error)] = error.toDic()
    return keyPaths
  }
}
