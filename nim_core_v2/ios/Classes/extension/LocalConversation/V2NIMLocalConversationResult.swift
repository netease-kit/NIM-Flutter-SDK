// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMLocalConversationResult {
  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(offset)] = offset
    keyPaths[#keyPath(finished)] = finished
    keyPaths[#keyPath(conversationList)] = conversationList.map { $0.toDic() }
    return keyPaths
  }

  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ dict: [String: Any]) -> V2NIMLocalConversationResult {
    let result = V2NIMLocalConversationResult()

    if let offset = dict[#keyPath(offset)] as? Int {
      result.setValue(offset, forKey: #keyPath(V2NIMLocalConversationResult.offset))
    }

    if let finished = dict[#keyPath(finished)] as? Bool {
      result.setValue(finished, forKey: #keyPath(V2NIMLocalConversationResult.finished))
    }

    if let jsonArray = dict[#keyPath(conversationList)] as? [[String: Any]] {
      var conversations = [V2NIMLocalConversation]()
      for json in jsonArray {
        let conversation = V2NIMLocalConversation.fromDic(json)
        conversations.append(conversation)
      }
      result.setValue(conversations, forKey: #keyPath(V2NIMLocalConversationResult.conversationList))
    }

    return result
  }
}
