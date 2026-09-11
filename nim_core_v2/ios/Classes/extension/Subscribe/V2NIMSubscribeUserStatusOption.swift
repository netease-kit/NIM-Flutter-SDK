// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMSubscribeUserStatusOption {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMSubscribeUserStatusOption {
    let option = V2NIMSubscribeUserStatusOption()

    if let accountIds = arguments["accountIds"] as? [String] {
      option.accountIds = accountIds
    }

    if let duration = arguments["duration"] as? Int {
      option.duration = duration
    }

    if let immediateSync = arguments["immediateSync"] as? Bool {
      option.immediateSync = immediateSync
    }

    return option
  }
}
