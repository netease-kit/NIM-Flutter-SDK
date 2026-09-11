// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMLocationInfo {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMLocationInfo {
    let info = V2NIMLocationInfo()

    if let x = arguments["x"] as? Double {
      info.x = x
    }

    if let y = arguments["y"] as? Double {
      info.y = y
    }

    if let z = arguments["z"] as? Double {
      info.z = z
    }

    return info
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(x)] = x
    keyPaths[#keyPath(y)] = y
    keyPaths[#keyPath(z)] = z
    return keyPaths
  }
}
