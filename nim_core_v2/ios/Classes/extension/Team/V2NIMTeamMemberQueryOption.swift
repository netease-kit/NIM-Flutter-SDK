// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import Foundation
import NIMSDK

extension V2NIMTeamMemberQueryOption {
  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(roleQueryType)] = roleQueryType.rawValue
    keyPaths[#keyPath(onlyChatBanned)] = onlyChatBanned
    keyPaths[#keyPath(direction)] = direction.rawValue
    keyPaths[#keyPath(nextToken)] = nextToken
    keyPaths[#keyPath(limit)] = limit

    return keyPaths
  }

  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMTeamMemberQueryOption {
    let option = V2NIMTeamMemberQueryOption()
    if let roleQueryType = arguments[#keyPath(V2NIMTeamMemberQueryOption.roleQueryType)] as? Int, let roleQueryTypeValue = V2NIMTeamMemberRoleQueryType(rawValue: roleQueryType) {
      option.roleQueryType = roleQueryTypeValue
    }

    if let onlyChatBanned = arguments[#keyPath(V2NIMTeamMemberQueryOption.onlyChatBanned)] as? Bool {
      option.onlyChatBanned = onlyChatBanned
    }

    if let direction = arguments[#keyPath(V2NIMTeamMemberQueryOption.direction)] as? Int, let directionValue = V2NIMQueryDirection(rawValue: direction) {
      option.direction = directionValue
    }

    if let nextToken = arguments[#keyPath(V2NIMTeamMemberQueryOption.nextToken)] as? String {
      option.nextToken = nextToken
    }

    if let limit = arguments[#keyPath(V2NIMTeamMemberQueryOption.limit)] as? Int {
      option.limit = limit
    }
    return option
  }
}
