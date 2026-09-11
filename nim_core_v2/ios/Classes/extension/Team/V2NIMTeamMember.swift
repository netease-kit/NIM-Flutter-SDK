// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import Foundation
import NIMSDK

extension V2NIMTeamMember {
  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMTeamMember.teamId)] = teamId
    keyPaths[#keyPath(V2NIMTeamMember.teamType)] = teamType.rawValue
    keyPaths[#keyPath(V2NIMTeamMember.accountId)] = accountId
    keyPaths[#keyPath(V2NIMTeamMember.memberRole)] = memberRole.rawValue
    keyPaths[#keyPath(V2NIMTeamMember.teamNick)] = teamNick
    keyPaths[#keyPath(V2NIMTeamMember.serverExtension)] = serverExtension
    keyPaths[#keyPath(V2NIMTeamMember.joinTime)] = joinTime * 1000
    keyPaths[#keyPath(V2NIMTeamMember.updateTime)] = updateTime * 1000
    keyPaths[#keyPath(V2NIMTeamMember.inTeam)] = inTeam
    keyPaths[#keyPath(V2NIMTeamMember.chatBanned)] = chatBanned
    keyPaths[#keyPath(V2NIMTeamMember.invitorAccountId)] = invitorAccountId
    keyPaths[#keyPath(V2NIMTeamMember.followAccountIds)] = followAccountIds

    return keyPaths
  }

  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMTeamMember {
    let teamMember = V2NIMTeamMember()
    if let teamId = arguments[#keyPath(teamId)] as? String {
      teamMember.setValue(teamId, forKey: #keyPath(V2NIMTeamMember.teamId))
    }
    if let teamType = arguments[#keyPath(teamType)] as? Int,
       let teamType = NIMTeamType(rawValue: teamType) {
      teamMember.setValue(teamType.rawValue, forKey: #keyPath(V2NIMTeamMember.teamType))
    }
    if let accountId = arguments[#keyPath(accountId)] as? String {
      teamMember.setValue(accountId, forKey: #keyPath(V2NIMTeamMember.accountId))
    }
    if let memberRole = arguments[#keyPath(memberRole)] as? Int,
       let memberRole = NIMTeamMemberType(rawValue: memberRole) {
      teamMember.setValue(memberRole.rawValue, forKey: #keyPath(V2NIMTeamMember.memberRole))
    }
    if let teamNick = arguments[#keyPath(teamNick)] as? String {
      teamMember.setValue(teamNick, forKey: #keyPath(V2NIMTeamMember.teamNick))
    }
    if let serverExtension = arguments[#keyPath(serverExtension)] as? String {
      teamMember.setValue(serverExtension, forKey: #keyPath(V2NIMTeamMember.serverExtension))
    }
    if let joinTime = arguments[#keyPath(joinTime)] as? Double {
      teamMember.setValue(joinTime / 1000, forKey: #keyPath(V2NIMTeamMember.joinTime))
    }
    if let updateTime = arguments[#keyPath(updateTime)] as? Double {
      teamMember.setValue(updateTime / 1000, forKey: #keyPath(V2NIMTeamMember.updateTime))
    }
    if let inTeam = arguments[#keyPath(inTeam)] as? Bool {
      teamMember.setValue(inTeam, forKey: #keyPath(V2NIMTeamMember.inTeam))
    }
    if let chatBanned = arguments[#keyPath(chatBanned)] as? Bool {
      teamMember.setValue(chatBanned, forKey: #keyPath(V2NIMTeamMember.chatBanned))
    }
    if let invitorAccountId = arguments[#keyPath(invitorAccountId)] as? String {
      teamMember.setValue(invitorAccountId, forKey: #keyPath(V2NIMTeamMember.invitorAccountId))
    }
    if let followAccountIds = arguments[#keyPath(followAccountIds)] as? [String] {
      teamMember.setValue(followAccountIds, forKey: #keyPath(V2NIMTeamMember.followAccountIds))
    }
    return teamMember
  }
}
