// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMConversationResult {
  func toDictionary() -> [String: Any] {
    var dict: [String: Any] = [
      #keyPath(offset): offset,
      #keyPath(finished): finished,
    ]
    var jsonArray: [[String: Any]] = []
    conversationList?.forEach { conversation in
      let json = conversation.toDictionary()
      jsonArray.append(json)
    }
    dict[#keyPath(conversationList)] = jsonArray

    return dict
  }

  /// 从字典中解析出对象
  /// - Parameter dict: 字典
  /// - Returns: 对象
  static func fromDictionary(_ dict: [String: Any]) -> V2NIMConversationResult {
    let result = V2NIMConversationResult()
    if let offset = dict[#keyPath(offset)] as? Int {
      result.setValue(offset, forKey: #keyPath(V2NIMConversationResult.offset))
    }
    if let finished = dict[#keyPath(finished)] as? Bool {
      result.setValue(finished, forKey: #keyPath(V2NIMConversationResult.finished))
    }
    if let jsonArray = dict[#keyPath(conversationList)] as? [[String: Any]] {
      var conversations = [V2NIMConversation]()
      for json in jsonArray {
        let conversation = V2NIMConversation.fromDictionary(json)
        conversations.append(conversation)
      }
      result.setValue(conversations, forKey: #keyPath(V2NIMConversationResult.conversationList))
    }
    return result
  }
}
