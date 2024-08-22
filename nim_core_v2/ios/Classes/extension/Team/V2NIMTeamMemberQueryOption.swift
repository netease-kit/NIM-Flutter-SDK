// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import Foundation
import NIMSDK

extension V2NIMTeamMemberQueryOption {
  func toDictionary() -> [String: Any] {
    let dict: [String: Any] = [
      #keyPath(roleQueryType): roleQueryType.rawValue,
      #keyPath(onlyChatBanned): onlyChatBanned,
      #keyPath(direction): direction.rawValue,
      #keyPath(nextToken): nextToken ?? "",
      #keyPath(limit): limit,
    ]
    return dict
  }

  static func fromDictionary(_ dict: [String: Any]) -> V2NIMTeamMemberQueryOption {
    let option = V2NIMTeamMemberQueryOption()
    if let roleQueryType = dict[#keyPath(V2NIMTeamMemberQueryOption.roleQueryType)] as? Int, let roleQueryTypeValue = V2NIMTeamMemberRoleQueryType(rawValue: roleQueryType) {
      option.roleQueryType = roleQueryTypeValue
    }

    if let onlyChatBanned = dict[#keyPath(V2NIMTeamMemberQueryOption.onlyChatBanned)] as? Bool {
      option.onlyChatBanned = onlyChatBanned
    }

    if let direction = dict[#keyPath(V2NIMTeamMemberQueryOption.direction)] as? Int, let directionValue = V2NIMQueryDirection(rawValue: direction) {
      option.direction = directionValue
    }

    if let nextToken = dict[#keyPath(V2NIMTeamMemberQueryOption.nextToken)] as? String {
      option.nextToken = nextToken
    }

    if let limit = dict[#keyPath(V2NIMTeamMemberQueryOption.limit)] as? Int {
      option.limit = limit
    }
    return option
  }
}
