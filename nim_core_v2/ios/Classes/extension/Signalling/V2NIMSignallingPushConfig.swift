// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMSignallingPushConfig {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMSignallingPushConfig {
    let config = V2NIMSignallingPushConfig()

    if let pushEnabled = arguments["pushEnabled"] as? Bool {
      config.pushEnabled = pushEnabled
    }

    if let pushTitle = arguments["pushTitle"] as? String {
      config.pushTitle = pushTitle
    }

    if let pushContent = arguments["pushContent"] as? String {
      config.pushContent = pushContent
    }

    if let pushPayload = arguments["pushPayload"] as? String {
      config.pushPayload = pushPayload
    }

    return config
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMSignallingPushConfig.pushEnabled)] = pushEnabled
    keyPaths[#keyPath(V2NIMSignallingPushConfig.pushTitle)] = pushTitle
    keyPaths[#keyPath(V2NIMSignallingPushConfig.pushContent)] = pushContent
    keyPaths[#keyPath(V2NIMSignallingPushConfig.pushPayload)] = pushPayload
    return keyPaths
  }
}
