// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMConversationFilter {
  func toDictionary() -> [String: Any] {
    var dict: [String: Any] = [
      #keyPath(conversationTypes): conversationTypes ?? [],
      #keyPath(ignoreMuted): ignoreMuted,
    ]
    if let conversationGroupId, !conversationGroupId.isEmpty {
      dict["conversationGroupId"] = conversationGroupId
    }
    return dict
  }

  static func fromDictionary(_ dict: [String: Any]) -> V2NIMConversationFilter {
    let filter = V2NIMConversationFilter()
    if let conversationTypesInt = dict[#keyPath(conversationTypes)] as? [Int] {
      let conversationTypes = conversationTypesInt.map {
        type in
        NSNumber(value: type)
      }
      filter.setValue(conversationTypes, forKey: #keyPath(V2NIMConversationFilter.conversationTypes))
    }
    if let conversationGroupId = dict[#keyPath(conversationGroupId)] as? String,
       !conversationGroupId.isEmpty {
      filter.setValue(conversationGroupId, forKey: #keyPath(V2NIMConversationFilter.conversationGroupId))
    }
    if let ignoreMuted = dict[#keyPath(ignoreMuted)] as? Bool {
      filter.setValue(ignoreMuted, forKey: #keyPath(V2NIMConversationFilter.ignoreMuted))
    }
    return filter
  }
}
