// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMMessageAntispamConfig {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMMessageAntispamConfig {
    let attach = V2NIMMessageAntispamConfig()

    if let antispamEnabled = arguments["antispamEnabled"] as? Bool {
      attach.antispamEnabled = antispamEnabled
    }

    if let antispamBusinessId = arguments["antispamBusinessId"] as? String {
      attach.antispamBusinessId = antispamBusinessId
    }

    if let antispamCustomMessage = arguments["antispamCustomMessage"] as? String {
      attach.antispamCustomMessage = antispamCustomMessage
    }

    if let antispamCheating = arguments["antispamCheating"] as? String {
      attach.antispamCheating = antispamCheating
    }

    if let antispamExtension = arguments["antispamExtension"] as? String {
      attach.antispamExtension = antispamExtension
    }

    return attach
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMMessageAntispamConfig.antispamEnabled)] = antispamEnabled
    keyPaths[#keyPath(V2NIMMessageAntispamConfig.antispamBusinessId)] = antispamBusinessId
    keyPaths[#keyPath(V2NIMMessageAntispamConfig.antispamCustomMessage)] = antispamCustomMessage
    keyPaths[#keyPath(V2NIMMessageAntispamConfig.antispamCheating)] = antispamCheating
    keyPaths[#keyPath(V2NIMMessageAntispamConfig.antispamExtension)] = antispamExtension
    return keyPaths
  }
}
