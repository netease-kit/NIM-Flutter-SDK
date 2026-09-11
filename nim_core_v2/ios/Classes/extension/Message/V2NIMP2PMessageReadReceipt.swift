// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMP2PMessageReadReceipt {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMP2PMessageReadReceipt {
    let attach = V2NIMP2PMessageReadReceipt()

    if let conversationId = arguments["conversationId"] as? String {
      attach.setValue(conversationId,
                      forKeyPath: #keyPath(V2NIMP2PMessageReadReceipt.conversationId))
    }

    if let timestamp = arguments["timestamp"] as? Double {
      attach.setValue(TimeInterval(timestamp / 1000),
                      forKeyPath: #keyPath(V2NIMP2PMessageReadReceipt.timestamp))
    }

    return attach
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMP2PMessageReadReceipt.conversationId)] = conversationId
    keyPaths[#keyPath(V2NIMP2PMessageReadReceipt.timestamp)] = timestamp * 1000
    return keyPaths
  }
}
