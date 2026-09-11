// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import Foundation
import NIMSDK

extension V2NIMTeamMemberSearchOption {
  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(keyword)] = keyword
    keyPaths[#keyPath(teamType)] = teamType.rawValue
    keyPaths[#keyPath(teamId)] = teamId
    keyPaths[#keyPath(nextToken)] = nextToken
    keyPaths[#keyPath(order)] = order.rawValue
    keyPaths[#keyPath(limit)] = limit

    return keyPaths
  }
}
