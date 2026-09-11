// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import Foundation

import NIMSDK

extension V2NIMTeam {
  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMTeam.teamId)] = teamId
    keyPaths[#keyPath(V2NIMTeam.teamType)] = teamType.rawValue
    keyPaths[#keyPath(V2NIMTeam.name)] = name
    keyPaths[#keyPath(V2NIMTeam.ownerAccountId)] = ownerAccountId
    keyPaths[#keyPath(V2NIMTeam.memberLimit)] = memberLimit
    keyPaths[#keyPath(V2NIMTeam.memberCount)] = memberCount
    keyPaths[#keyPath(V2NIMTeam.createTime)] = createTime * 1000
    keyPaths[#keyPath(V2NIMTeam.updateTime)] = updateTime * 1000
    keyPaths[#keyPath(V2NIMTeam.intro)] = intro
    keyPaths[#keyPath(V2NIMTeam.announcement)] = announcement
    keyPaths[#keyPath(V2NIMTeam.avatar)] = avatar
    keyPaths[#keyPath(V2NIMTeam.serverExtension)] = serverExtension
    keyPaths[#keyPath(V2NIMTeam.customerExtension)] = customerExtension
    keyPaths[#keyPath(V2NIMTeam.joinMode)] = joinMode.rawValue
    keyPaths[#keyPath(V2NIMTeam.agreeMode)] = agreeMode.rawValue
    keyPaths[#keyPath(V2NIMTeam.inviteMode)] = inviteMode.rawValue
    keyPaths[#keyPath(V2NIMTeam.updateInfoMode)] = updateInfoMode.rawValue
    keyPaths[#keyPath(V2NIMTeam.updateExtensionMode)] = updateExtensionMode.rawValue
    keyPaths[#keyPath(V2NIMTeam.chatBannedMode)] = chatBannedMode.rawValue
    keyPaths[#keyPath(V2NIMTeam.isValidTeam)] = isValidTeam
    keyPaths[#keyPath(V2NIMTeam.isTeamEffective)] = isTeamEffective

    return keyPaths
  }

  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMTeam {
    let team = V2NIMTeam()
    if let teamId = arguments[#keyPath(teamId)] as? String {
      team.setValue(teamId, forKey: #keyPath(V2NIMTeam.teamId))
    }
    if let teamType = arguments[#keyPath(teamType)] as? Int,
       let teamType = V2NIMTeamType(rawValue: teamType) {
      team.setValue(teamType.rawValue, forKey: #keyPath(V2NIMTeam.teamType))
    }
    if let name = arguments[#keyPath(name)] as? String {
      team.setValue(name, forKey: #keyPath(V2NIMTeam.name))
    }
    if let ownerAccountId = arguments[#keyPath(ownerAccountId)] as? String {
      team.setValue(ownerAccountId, forKey: #keyPath(V2NIMTeam.ownerAccountId))
    }
    if let memberLimit = arguments[#keyPath(memberLimit)] as? Int {
      team.setValue(memberLimit, forKey: #keyPath(V2NIMTeam.memberLimit))
    }
    if let memberCount = arguments[#keyPath(memberCount)] as? Int {
      team.setValue(memberCount, forKey: #keyPath(V2NIMTeam.memberCount))
    }
    if let createTime = arguments[#keyPath(createTime)] as? Int {
      team.setValue(createTime / 1000, forKey: #keyPath(V2NIMTeam.createTime))
    }
    if let updateTime = arguments[#keyPath(updateTime)] as? Int {
      team.setValue(updateTime / 1000, forKey: #keyPath(V2NIMTeam.updateTime))
    }
    if let intro = arguments[#keyPath(intro)] as? String {
      team.setValue(intro, forKey: #keyPath(V2NIMTeam.intro))
    }
    if let announcement = arguments[#keyPath(announcement)] as? String {
      team.setValue(announcement, forKey: #keyPath(V2NIMTeam.announcement))
    }
    if let avatar = arguments[#keyPath(avatar)] as? String {
      team.setValue(avatar, forKey: #keyPath(V2NIMTeam.avatar))
    }
    if let serverExtension = arguments[#keyPath(serverExtension)] as? String {
      team.setValue(serverExtension, forKey: #keyPath(V2NIMTeam.serverExtension))
    }
    if let customerExtension = arguments[#keyPath(customerExtension)] as? String {
      team.setValue(customerExtension, forKey: #keyPath(V2NIMTeam.customerExtension))
    }
    if let joinMode = arguments[#keyPath(joinMode)] as? Int,
       let joinMode = V2NIMTeamJoinMode(rawValue: joinMode) {
      team.setValue(joinMode.rawValue, forKey: #keyPath(V2NIMTeam.joinMode))
    }
    if let agreeMode = arguments[#keyPath(agreeMode)] as? Int,
       let agreeMode = V2NIMTeamAgreeMode(rawValue: agreeMode) {
      team.setValue(agreeMode.rawValue, forKey: #keyPath(V2NIMTeam.agreeMode))
    }
    if let inviteMode = arguments[#keyPath(inviteMode)] as? Int,
       let inviteMode = V2NIMTeamInviteMode(rawValue: inviteMode) {
      team.setValue(inviteMode.rawValue, forKey: #keyPath(V2NIMTeam.inviteMode))
    }
    if let updateInfoMode = arguments[#keyPath(updateInfoMode)] as? Int,
       let updateInfoMode = V2NIMTeamUpdateInfoMode(rawValue: updateInfoMode) {
      team.setValue(updateInfoMode.rawValue, forKey: #keyPath(V2NIMTeam.updateInfoMode))
    }
    if let updateExtensionMode = arguments[#keyPath(updateExtensionMode)] as? Int,
       let updateExtensionMode = V2NIMTeamUpdateExtensionMode(rawValue: updateExtensionMode) {
      team.setValue(updateExtensionMode.rawValue, forKey: #keyPath(V2NIMTeam.updateExtensionMode))
    }
    if let chatBannedMode = arguments[#keyPath(chatBannedMode)] as? Int,
       let chatBannedMode = V2NIMTeamChatBannedMode(rawValue: chatBannedMode) {
      team.setValue(chatBannedMode.rawValue, forKey: #keyPath(V2NIMTeam.chatBannedMode))
    }
    if let isValidTeam = arguments[#keyPath(isValidTeam)] as? Bool {
      team.setValue(isValidTeam, forKey: #keyPath(V2NIMTeam.isValidTeam))
    }

    if let isTeamEffective = arguments[#keyPath(isTeamEffective)] as? Bool {
      team.setValue(isTeamEffective, forKey: #keyPath(V2NIMTeam.isTeamEffective))
    }
    return team
  }
}
