// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import Foundation
import NIMSDK

extension V2NIMUpdateSelfMemberInfoParams {
  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(teamNick)] = teamNick
    keyPaths[#keyPath(serverExtension)] = serverExtension

    return keyPaths
  }

  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMUpdateSelfMemberInfoParams {
    let params = V2NIMUpdateSelfMemberInfoParams()
    if let teamNick = arguments[#keyPath(teamNick)] as? String {
      params.teamNick = teamNick
    }
    if let serverExtension = arguments[#keyPath(serverExtension)] as? String {
      params.serverExtension = serverExtension
    }
    return params
  }
}
