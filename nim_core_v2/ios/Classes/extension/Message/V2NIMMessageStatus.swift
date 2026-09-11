// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMMessageStatus {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMMessageStatus {
    let attach = V2NIMMessageStatus()

    if let errorCode = arguments["errorCode"] as? Int {
      attach.errorCode = errorCode
    }

    if let readReceiptSent = arguments["readReceiptSent"] as? Bool {
      attach.readReceiptSent = readReceiptSent
    }

    return attach
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMMessageStatus.errorCode)] = errorCode
    keyPaths[#keyPath(V2NIMMessageStatus.readReceiptSent)] = readReceiptSent
    return keyPaths
  }
}
