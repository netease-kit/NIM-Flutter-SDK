// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMLocalConversationOperationResult {
  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(conversationId)] = conversationId
    keyPaths[#keyPath(error)] = error.toDic()
    return keyPaths
  }

  /// 从字典中解析出对象
  /// - Parameter dict: 字典
  /// - Returns: 对象
  static func fromDic(_ dict: [String: Any]) -> V2NIMLocalConversationOperationResult {
    let result = V2NIMLocalConversationOperationResult()

    if let conversationId = dict[#keyPath(conversationId)] as? String {
      result.setValue(conversationId, forKey: #keyPath(V2NIMLocalConversationOperationResult.conversationId))
    }
    return result
  }
}
