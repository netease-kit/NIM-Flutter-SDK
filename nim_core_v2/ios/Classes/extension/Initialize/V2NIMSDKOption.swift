// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMSDKOption {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMSDKOption {
    let option = V2NIMSDKOption()

    if let useV1Login = arguments["useV1Login"] as? Bool {
      option.useV1Login = useV1Login
    }

    if let enableV2CloudConversation = arguments["enableV2CloudConversation"] as? Bool {
      option.enableV2CloudConversation = enableV2CloudConversation
    }

    return option
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(useV1Login)] = useV1Login
    keyPaths[#keyPath(enableV2CloudConversation)] = enableV2CloudConversation
    return keyPaths
  }
}
