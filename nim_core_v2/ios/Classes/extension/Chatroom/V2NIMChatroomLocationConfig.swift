// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMChatroomLocationConfig {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMChatroomLocationConfig {
    let config = V2NIMChatroomLocationConfig()

    if let locationInfo = arguments["locationInfo"] as? [String: Any] {
      config.locationInfo = V2NIMLocationInfo.fromDic(locationInfo)
    }

    if let distance = arguments["distance"] as? Double {
      config.distance = distance
    }

    return config
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(locationInfo)] = locationInfo?.toDic()
    keyPaths[#keyPath(distance)] = distance
    return keyPaths
  }
}
