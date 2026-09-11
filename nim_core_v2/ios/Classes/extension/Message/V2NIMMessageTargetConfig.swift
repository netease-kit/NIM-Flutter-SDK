// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMMessageTargetConfig {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMMessageTargetConfig {
    let config = V2NIMMessageTargetConfig()

    if let inclusive = arguments["inclusive"] as? Bool {
      config.inclusive = inclusive
    }

    if let newMemberVisible = arguments["newMemberVisible"] as? Bool {
      config.newMemberVisible = newMemberVisible
    }

    if let receiverIds = arguments["receiverIds"] as? [String] {
      config.receiverIds = receiverIds
    }

    return config
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMMessageTargetConfig.inclusive)] = inclusive
    keyPaths[#keyPath(V2NIMMessageTargetConfig.newMemberVisible)] = newMemberVisible
    keyPaths[#keyPath(V2NIMMessageTargetConfig.receiverIds)] = receiverIds
    return keyPaths
  }
}
