// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import Foundation
import NIMSDK

extension V2NIMTeamMember {
  func toDictionary() -> [String: Any] {
    let dict: [String: Any] = [
      #keyPath(teamId): teamId,
      #keyPath(teamType): teamType.rawValue,
      #keyPath(accountId): accountId,
      #keyPath(memberRole): memberRole.rawValue,
      #keyPath(teamNick): teamNick ?? "",
      #keyPath(serverExtension): serverExtension ?? "",
      #keyPath(joinTime): joinTime * 1000,
      #keyPath(updateTime): updateTime * 1000,
      #keyPath(inTeam): inTeam,
      #keyPath(chatBanned): chatBanned,
    ]
    return dict
  }

  static func fromDictionary(_ dict: [String: Any]) -> V2NIMTeamMember {
    let teamMember = V2NIMTeamMember()
    if let teamId = dict[#keyPath(teamId)] as? String {
      teamMember.setValue(teamId, forKey: #keyPath(V2NIMTeamMember.teamId))
    }
    if let teamType = dict[#keyPath(teamType)] as? Int, let teamType = NIMTeamType(rawValue: teamType) {
      teamMember.setValue(teamType, forKey: #keyPath(V2NIMTeamMember.teamType))
    }
    if let accountId = dict[#keyPath(accountId)] as? String {
      teamMember.setValue(accountId, forKey: #keyPath(V2NIMTeamMember.accountId))
    }
    if let memberRole = dict[#keyPath(memberRole)] as? Int, let memberRole = NIMTeamMemberType(rawValue: memberRole) {
      teamMember.setValue(memberRole, forKey: #keyPath(V2NIMTeamMember.memberRole))
    }
    if let teamNick = dict[#keyPath(teamNick)] as? String {
      teamMember.setValue(teamNick, forKey: #keyPath(V2NIMTeamMember.teamNick))
    }
    if let serverExtension = dict[#keyPath(serverExtension)] as? String {
      teamMember.setValue(serverExtension, forKey: #keyPath(V2NIMTeamMember.serverExtension))
    }
    if let joinTime = dict[#keyPath(joinTime)] as? Double {
      teamMember.setValue(joinTime / 1000, forKey: #keyPath(V2NIMTeamMember.joinTime))
    }
    if let updateTime = dict[#keyPath(updateTime)] as? Double {
      teamMember.setValue(updateTime / 1000, forKey: #keyPath(V2NIMTeamMember.updateTime))
    }
    if let inTeam = dict[#keyPath(inTeam)] as? Bool {
      teamMember.setValue(inTeam, forKey: #keyPath(V2NIMTeamMember.inTeam))
    }
    if let chatBanned = dict[#keyPath(chatBanned)] as? Bool {
      teamMember.setValue(chatBanned, forKey: #keyPath(V2NIMTeamMember.chatBanned))
    }
    return teamMember
  }
}
