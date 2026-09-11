// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMLocalConversationFilter {
  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(conversationTypes)] = conversationTypes
    keyPaths[#keyPath(ignoreMuted)] = ignoreMuted
    return keyPaths
  }

  /// 从字典中解析出对象
  /// - Parameter dict: 字典
  /// - Returns: 对象
  static func fromDic(_ dict: [String: Any]) -> V2NIMLocalConversationFilter {
    let filter = V2NIMLocalConversationFilter()

    if let conversationTypesInt = dict[#keyPath(conversationTypes)] as? [Int] {
      let conversationTypes = conversationTypesInt.map {
        type in
        NSNumber(value: type)
      }
      filter.setValue(conversationTypes, forKey: #keyPath(V2NIMLocalConversationFilter.conversationTypes))
    }

    if let ignoreMuted = dict[#keyPath(ignoreMuted)] as? Bool {
      filter.setValue(ignoreMuted, forKey: #keyPath(V2NIMLocalConversationFilter.ignoreMuted))
    }
    return filter
  }
}
