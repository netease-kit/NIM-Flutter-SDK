// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMConversationOption {
  func toDictionary() -> [String: Any] {
    let dict: [String: Any] = [
      #keyPath(conversationTypes): conversationTypes ?? [],
      #keyPath(onlyUnread): onlyUnread,
      #keyPath(conversationGroupIds): conversationGroupIds ?? [],
    ]
    return dict
  }

  static func fromDictionary(_ dict: [String: Any]) -> V2NIMConversationOption {
    let option = V2NIMConversationOption()
    if let conversationTypes = dict[#keyPath(conversationTypes)] as? [NSNumber] {
      option.conversationTypes = conversationTypes
    }
    if let onlyUnread = dict[#keyPath(onlyUnread)] as? Bool {
      option.onlyUnread = onlyUnread
    }
    if let conversationGroupIds = dict[#keyPath(conversationGroupIds)] as? [String] {
      option.conversationGroupIds = conversationGroupIds
    }
    return option
  }
}
