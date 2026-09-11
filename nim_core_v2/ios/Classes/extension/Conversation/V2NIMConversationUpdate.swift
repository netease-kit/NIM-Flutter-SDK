// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMConversationUpdate {
  func toDictionary() -> [String: Any] {
    let dict: [String: Any] = [
      #keyPath(serverExtension): serverExtension as Any,
    ]
    return dict
  }

  /// 从字典中解析出对象
  /// - Parameter dict: 字典
  /// - Returns: 对象
  static func fromDictionary(_ dict: [String: Any]) -> V2NIMConversationUpdate {
    let update = V2NIMConversationUpdate()
    if let serverExtension = dict[#keyPath(serverExtension)] as? String {
      update.setValue(serverExtension, forKey: #keyPath(V2NIMConversationUpdate.serverExtension))
    }
    return update
  }
}
