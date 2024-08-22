// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import Foundation

import NIMSDK

extension V2NIMTeam {
  func toDictionary() -> [String: Any] {
    let dict: [String: Any] = [
      #keyPath(teamId): teamId,
      #keyPath(teamType): teamType.rawValue,
      #keyPath(name): name,
      #keyPath(ownerAccountId): ownerAccountId,
      #keyPath(memberLimit): memberLimit,
      #keyPath(memberCount): memberCount,
      #keyPath(createTime): createTime * 1000,
      #keyPath(updateTime): updateTime * 1000,
      #keyPath(intro): intro ?? "",
      #keyPath(announcement): announcement ?? "",
      #keyPath(avatar): avatar ?? "",
      #keyPath(serverExtension): serverExtension ?? "",
      #keyPath(customerExtension): customerExtension ?? "",
      #keyPath(joinMode): joinMode.rawValue,
      #keyPath(agreeMode): agreeMode.rawValue,
      #keyPath(inviteMode): inviteMode.rawValue,
      #keyPath(updateInfoMode): updateInfoMode.rawValue,
      #keyPath(updateExtensionMode): updateExtensionMode.rawValue,
      #keyPath(chatBannedMode): chatBannedMode.rawValue,
      #keyPath(isValidTeam): isValidTeam,
    ]
    return dict
  }

  static func fromDictionary(_ dict: [String: Any]) -> V2NIMTeam {
    let team = V2NIMTeam()
    if let teamId = dict[#keyPath(teamId)] as? String {
      team.setValue(teamId, forKey: #keyPath(V2NIMTeam.teamId))
    }
    if let teamType = dict[#keyPath(teamType)] as? Int, let teamType = V2NIMTeamType(rawValue: teamType) {
      team.setValue(teamType, forKey: #keyPath(V2NIMTeam.teamType))
    }
    if let name = dict[#keyPath(name)] as? String {
      team.setValue(name, forKey: #keyPath(V2NIMTeam.name))
    }
    if let ownerAccountId = dict[#keyPath(ownerAccountId)] as? String {
      team.setValue(ownerAccountId, forKey: #keyPath(V2NIMTeam.ownerAccountId))
    }
    if let memberLimit = dict[#keyPath(memberLimit)] as? Int {
      team.setValue(memberLimit, forKey: #keyPath(V2NIMTeam.memberLimit))
    }
    if let memberCount = dict[#keyPath(memberCount)] as? Int {
      team.setValue(memberCount, forKey: #keyPath(V2NIMTeam.memberCount))
    }
    if let createTime = dict[#keyPath(createTime)] as? Int {
      team.setValue(createTime / 1000, forKey: #keyPath(V2NIMTeam.createTime))
    }
    if let updateTime = dict[#keyPath(updateTime)] as? Int {
      team.setValue(updateTime / 1000, forKey: #keyPath(V2NIMTeam.updateTime))
    }
    if let intro = dict[#keyPath(intro)] as? String {
      team.setValue(intro, forKey: #keyPath(V2NIMTeam.intro))
    }
    if let announcement = dict[#keyPath(announcement)] as? String {
      team.setValue(announcement, forKey: #keyPath(V2NIMTeam.announcement))
    }
    if let avatar = dict[#keyPath(avatar)] as? String {
      team.setValue(avatar, forKey: #keyPath(V2NIMTeam.avatar))
    }
    if let serverExtension = dict[#keyPath(serverExtension)] as? String {
      team.setValue(serverExtension, forKey: #keyPath(V2NIMTeam.serverExtension))
    }
    if let customerExtension = dict[#keyPath(customerExtension)] as? String {
      team.setValue(customerExtension, forKey: #keyPath(V2NIMTeam.customerExtension))
    }
    if let joinMode = dict[#keyPath(joinMode)] as? Int, let joinMode = V2NIMTeamJoinMode(rawValue: joinMode) {
      team.setValue(joinMode, forKey: #keyPath(V2NIMTeam.joinMode))
    }
    if let agreeMode = dict[#keyPath(agreeMode)] as? Int, let agreeMode = V2NIMTeamAgreeMode(rawValue: agreeMode) {
      team.setValue(agreeMode, forKey: #keyPath(V2NIMTeam.agreeMode))
    }
    if let inviteMode = dict[#keyPath(inviteMode)] as? Int, let inviteMode = V2NIMTeamInviteMode(rawValue: inviteMode) {
      team.setValue(inviteMode, forKey: #keyPath(V2NIMTeam.inviteMode))
    }
    if let updateInfoMode = dict[#keyPath(updateInfoMode)] as? Int, let updateInfoMode = V2NIMTeamUpdateInfoMode(rawValue: updateInfoMode) {
      team.setValue(updateInfoMode, forKey: #keyPath(V2NIMTeam.updateInfoMode))
    }
    if let updateExtensionMode = dict[#keyPath(updateExtensionMode)] as? Int, let updateExtensionMode = V2NIMTeamUpdateExtensionMode(rawValue: updateExtensionMode) {
      team.setValue(updateExtensionMode, forKey: #keyPath(V2NIMTeam.updateExtensionMode))
    }
    if let chatBannedMode = dict[#keyPath(chatBannedMode)] as? Int, let chatBannedMode = V2NIMTeamChatBannedMode(rawValue: chatBannedMode) {
      team.setValue(chatBannedMode, forKey: #keyPath(V2NIMTeam.chatBannedMode))
    }
    if let isValidTeam = dict[#keyPath(isValidTeam)] as? Bool {
      team.setValue(isValidTeam, forKey: #keyPath(V2NIMTeam.isValidTeam))
    }
    return team
  }
}
