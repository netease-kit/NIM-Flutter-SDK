// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import Foundation
import NIMSDK

extension V2NIMUpdatedTeamInfo {
  func toDictionary() -> [String: Any] {
    let dict: [String: Any] = [
      #keyPath(name): name ?? "",
      #keyPath(memberLimit): memberLimit,
      #keyPath(intro): intro ?? "",
      #keyPath(announcement): announcement ?? "",
      #keyPath(avatar): avatar ?? "",
      #keyPath(serverExtension): serverExtension ?? "",
      #keyPath(joinMode): joinMode.rawValue,
      #keyPath(agreeMode): agreeMode.rawValue,
      #keyPath(inviteMode): inviteMode.rawValue,
      #keyPath(updateInfoMode): inviteMode.rawValue,
      #keyPath(updateExtensionMode): updateExtensionMode.rawValue,
      #keyPath(chatBannedMode): chatBannedMode.rawValue,
    ]
    return dict
  }

  static func fromDictionary(_ dict: [String: Any]) -> V2NIMUpdatedTeamInfo {
    let team = V2NIMUpdatedTeamInfo()
    if let name = dict[#keyPath(name)] as? String {
      team.setValue(name, forKey: #keyPath(V2NIMUpdatedTeamInfo.name))
    }
    if let memberLimit = dict[#keyPath(memberLimit)] as? Int {
      team.setValue(memberLimit, forKey: #keyPath(V2NIMUpdatedTeamInfo.memberLimit))
    }
    if let intro = dict[#keyPath(intro)] as? String {
      team.setValue(intro, forKey: #keyPath(V2NIMUpdatedTeamInfo.intro))
    }
    if let announcement = dict[#keyPath(announcement)] as? String {
      team.setValue(announcement, forKey: #keyPath(V2NIMUpdatedTeamInfo.announcement))
    }
    if let avatar = dict[#keyPath(avatar)] as? String {
      team.setValue(avatar, forKey: #keyPath(V2NIMUpdatedTeamInfo.avatar))
    }
    if let serverExtension = dict[#keyPath(serverExtension)] as? String {
      team.setValue(serverExtension, forKey: #keyPath(V2NIMUpdatedTeamInfo.serverExtension))
    }
    if let joinMode = dict[#keyPath(joinMode)] as? Int, let joinMode = V2NIMTeamJoinMode(rawValue: joinMode) {
      team.setValue(joinMode, forKey: #keyPath(V2NIMUpdatedTeamInfo.joinMode))
    }
    if let agreeMode = dict[#keyPath(agreeMode)] as? Int, let agreeMode = V2NIMTeamAgreeMode(rawValue: agreeMode) {
      team.setValue(agreeMode, forKey: #keyPath(V2NIMUpdatedTeamInfo.agreeMode))
    }
    if let inviteMode = dict[#keyPath(inviteMode)] as? Int, let inviteMode = V2NIMTeamInviteMode(rawValue: inviteMode) {
      team.setValue(inviteMode, forKey: #keyPath(V2NIMUpdatedTeamInfo.inviteMode))
    }
    if let updateInfoMode = dict[#keyPath(updateInfoMode)] as? Int, let updateInfoMode = V2NIMTeamUpdateInfoMode(rawValue: updateInfoMode) {
      team.setValue(updateInfoMode, forKey: #keyPath(V2NIMUpdatedTeamInfo.updateInfoMode))
    }
    if let updateExtensionMode = dict[#keyPath(updateExtensionMode)] as? Int, let updateExtensionMode = V2NIMTeamUpdateExtensionMode(rawValue: updateExtensionMode) {
      team.setValue(updateExtensionMode, forKey: #keyPath(V2NIMUpdatedTeamInfo.updateExtensionMode))
    }
    if let chatBannedMode = dict[#keyPath(chatBannedMode)] as? Int, let chatBannedMode = V2NIMTeamChatBannedMode(rawValue: chatBannedMode) {
      team.setValue(chatBannedMode, forKey: #keyPath(V2NIMUpdatedTeamInfo.chatBannedMode))
    }
    return team
  }
}
