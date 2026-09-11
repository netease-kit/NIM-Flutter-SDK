// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMChatroomMemberRoleUpdateParams {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMChatroomMemberRoleUpdateParams {
    let params = V2NIMChatroomMemberRoleUpdateParams()

    if let memberRole = arguments["memberRole"] as? Int,
       let memberRole = V2NIMChatroomMemberRole(rawValue: memberRole) {
      params.memberRole = memberRole
    }

    if let memberLevel = arguments["memberLevel"] as? Int {
      params.memberLevel = memberLevel
    }

    if let notificationExtension = arguments["notificationExtension"] as? String {
      params.notificationExtension = notificationExtension
    }

    return params
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(memberRole)] = memberRole.rawValue
    keyPaths[#keyPath(memberLevel)] = memberLevel
    keyPaths[#keyPath(notificationExtension)] = notificationExtension
    return keyPaths
  }
}
