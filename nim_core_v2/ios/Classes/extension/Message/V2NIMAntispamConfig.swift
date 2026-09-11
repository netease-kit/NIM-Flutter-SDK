// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMAntispamConfig {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMAntispamConfig {
    let config = V2NIMAntispamConfig()

    if let antispamBusinessId = arguments["antispamBusinessId"] as? String {
      config.antispamBusinessId = antispamBusinessId
    }

    return config
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(antispamBusinessId)] = antispamBusinessId
    return keyPaths
  }
}
