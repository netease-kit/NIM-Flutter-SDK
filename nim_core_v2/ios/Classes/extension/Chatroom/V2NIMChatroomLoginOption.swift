// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMChatroomLoginOption {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMChatroomLoginOption {
    let option = V2NIMChatroomLoginOption()

    if let authType = arguments["authType"] as? Int,
       let authType = V2NIMLoginAuthType(rawValue: authType) {
      option.authType = authType
    }

    return option
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(authType)] = authType.rawValue
    return keyPaths
  }
}
