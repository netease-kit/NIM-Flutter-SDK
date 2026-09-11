// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMChatroomMemberQueryOption {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMChatroomMemberQueryOption {
    let option = V2NIMChatroomMemberQueryOption()

    if let memberRoles = arguments["memberRoles"] as? [Int] {
      option.memberRoles = memberRoles
    }

    if let onlyBlocked = arguments["onlyBlocked"] as? Bool {
      option.onlyBlocked = onlyBlocked
    }

    if let onlyChatBanned = arguments["onlyChatBanned"] as? Bool {
      option.onlyChatBanned = onlyChatBanned
    }

    if let onlyOnline = arguments["onlyOnline"] as? Bool {
      option.onlyOnline = onlyOnline
    }

    if let pageToken = arguments["pageToken"] as? String {
      option.pageToken = pageToken
    }

    if let limit = arguments["limit"] as? Int {
      option.limit = limit
    }

    return option
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(onlyBlocked)] = onlyBlocked
    keyPaths[#keyPath(onlyChatBanned)] = onlyChatBanned
    keyPaths[#keyPath(onlyOnline)] = onlyOnline
    keyPaths[#keyPath(pageToken)] = pageToken
    keyPaths[#keyPath(limit)] = limit

    if let memberRoles = memberRoles {
      var memberRolesList = [Int]()
      for memberRole in memberRoles {
        if let memberRole = memberRole as? V2NIMChatroomMemberRole {
          memberRolesList.append(memberRole.rawValue)
        }
      }
      keyPaths[#keyPath(V2NIMChatroomMemberQueryOption.memberRoles)] = memberRolesList
    }
    return keyPaths
  }
}
