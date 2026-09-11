// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMAIModelStreamCallStopParams {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMAIModelStreamCallStopParams {
    let attach = V2NIMAIModelStreamCallStopParams()

    if let accountId = arguments["accountId"] as? String {
      attach.accountId = accountId
    }

    if let requestId = arguments["requestId"] as? String {
      attach.requestId = requestId
    }

    return attach
  }
}
