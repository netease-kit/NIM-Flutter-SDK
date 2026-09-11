// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

let nimCoreMessageType = "nimCoreMessageType"

@objc
extension V2NIMMessageAttachment {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMMessageAttachment {
    let attach = V2NIMMessageAttachment()

    if let raw = arguments["raw"] as? String {
      attach.raw = raw
    }

    return attach
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  public func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMMessageAttachment.raw)] = raw
    return keyPaths
  }
}
