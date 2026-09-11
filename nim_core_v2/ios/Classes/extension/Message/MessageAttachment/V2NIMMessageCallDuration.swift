// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMMessageCallDuration {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDict(_ arguments: [String: Any]) -> V2NIMMessageCallDuration {
    let callDuration = V2NIMMessageCallDuration()

    if let accountId = arguments["accountId"] as? String {
      callDuration.accountId = accountId
    }

    if let duration = arguments["duration"] as? Int {
      callDuration.duration = duration
    }

    return callDuration
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMMessageCallDuration.accountId)] = accountId
    keyPaths[#keyPath(V2NIMMessageCallDuration.duration)] = duration
    return keyPaths
  }
}
