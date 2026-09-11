// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import Foundation
import NIMSDK

extension V2NIMCustomUserStatusParams {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMCustomUserStatusParams {
    let params = V2NIMCustomUserStatusParams()

    if let statusType = arguments["statusType"] as? Int32 {
      params.statusType = statusType
    }

    if let duration = arguments["duration"] as? Int {
      params.duration = duration
    }

    if let ext = arguments["extension"] as? NSString {
      params.extension = ext
    }

    if let onlineOnly = arguments["onlineOnly"] as? Bool {
      params.onlineOnly = onlineOnly
    }

    if let multiSync = arguments["multiSync"] as? Bool {
      params.multiSync = multiSync
    }

    return params
  }
}
