// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMProxyAICallAntispamConfig {
  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMProxyAICallAntispamConfig.antispamBusinessId)] = antispamBusinessId
    keyPaths[#keyPath(V2NIMProxyAICallAntispamConfig.antispamEnabled)] = antispamEnabled
    return keyPaths
  }

  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMProxyAICallAntispamConfig {
    let config = V2NIMProxyAICallAntispamConfig()
    if let antispamEnabled = arguments[#keyPath(V2NIMProxyAICallAntispamConfig.antispamEnabled)] as? Bool {
      config.antispamEnabled = antispamEnabled
    }
    if let antispamBusinessId = arguments[#keyPath(V2NIMProxyAICallAntispamConfig.antispamBusinessId)] as? String {
      config.antispamBusinessId = antispamBusinessId
    }
    return config
  }
}
