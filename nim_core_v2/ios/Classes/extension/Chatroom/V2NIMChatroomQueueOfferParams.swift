// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMChatroomQueueOfferParams {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMChatroomQueueOfferParams {
    let params = V2NIMChatroomQueueOfferParams()

    if let elementKey = arguments["elementKey"] as? String {
      params.elementKey = elementKey
    }

    if let elementValue = arguments["elementValue"] as? String {
      params.elementValue = elementValue
    }

    if let transient = arguments["transient"] as? Bool {
      params.transient = transient
    }

    if let elementOwnerAccountId = arguments["elementOwnerAccountId"] as? String {
      params.elementOwnerAccountId = elementOwnerAccountId
    }

    return params
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(elementKey)] = elementKey
    keyPaths[#keyPath(elementValue)] = elementValue
    keyPaths[#keyPath(transient)] = transient
    keyPaths[#keyPath(elementOwnerAccountId)] = elementOwnerAccountId
    return keyPaths
  }
}
