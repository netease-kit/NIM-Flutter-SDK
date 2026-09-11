// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import Foundation
import NIMSDK

extension V2NIMUpdatedTeamInfo {
  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(name)] = name
    keyPaths[#keyPath(memberLimit)] = memberLimit
    keyPaths[#keyPath(intro)] = intro
    keyPaths[#keyPath(announcement)] = announcement
    keyPaths[#keyPath(avatar)] = avatar
    keyPaths[#keyPath(serverExtension)] = serverExtension
    keyPaths[#keyPath(joinMode)] = joinMode.rawValue
    keyPaths[#keyPath(agreeMode)] = agreeMode.rawValue
    keyPaths[#keyPath(inviteMode)] = inviteMode.rawValue
    keyPaths[#keyPath(updateInfoMode)] = updateInfoMode.rawValue
    keyPaths[#keyPath(updateExtensionMode)] = updateExtensionMode.rawValue
    keyPaths[#keyPath(chatBannedMode)] = chatBannedMode.rawValue
    keyPaths[#keyPath(customerExtension)] = customerExtension
    return keyPaths
  }

  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMUpdatedTeamInfo {
    let team = V2NIMUpdatedTeamInfo()
    if let name = arguments[#keyPath(name)] as? String {
      team.setValue(name, forKey: #keyPath(V2NIMUpdatedTeamInfo.name))
    }
    if let memberLimit = arguments[#keyPath(memberLimit)] as? Int {
      team.setValue(memberLimit, forKey: #keyPath(V2NIMUpdatedTeamInfo.memberLimit))
    }
    if let intro = arguments[#keyPath(intro)] as? String {
      team.setValue(intro, forKey: #keyPath(V2NIMUpdatedTeamInfo.intro))
    }
    if let announcement = arguments[#keyPath(announcement)] as? String {
      team.setValue(announcement, forKey: #keyPath(V2NIMUpdatedTeamInfo.announcement))
    }
    if let avatar = arguments[#keyPath(avatar)] as? String {
      team.setValue(avatar, forKey: #keyPath(V2NIMUpdatedTeamInfo.avatar))
    }
    if let serverExtension = arguments[#keyPath(serverExtension)] as? String {
      team.setValue(serverExtension, forKey: #keyPath(V2NIMUpdatedTeamInfo.serverExtension))
    }
    if let joinMode = arguments[#keyPath(joinMode)] as? Int,
       let joinMode = V2NIMTeamJoinMode(rawValue: joinMode) {
      team.setValue(joinMode.rawValue, forKey: #keyPath(V2NIMUpdatedTeamInfo.joinMode))
    }
    if let agreeMode = arguments[#keyPath(agreeMode)] as? Int,
       let agreeMode = V2NIMTeamAgreeMode(rawValue: agreeMode) {
      team.setValue(agreeMode.rawValue, forKey: #keyPath(V2NIMUpdatedTeamInfo.agreeMode))
    }
    if let inviteMode = arguments[#keyPath(inviteMode)] as? Int,
       let inviteMode = V2NIMTeamInviteMode(rawValue: inviteMode) {
      team.setValue(inviteMode.rawValue, forKey: #keyPath(V2NIMUpdatedTeamInfo.inviteMode))
    }
    if let updateInfoMode = arguments[#keyPath(updateInfoMode)] as? Int,
       let updateInfoMode = V2NIMTeamUpdateInfoMode(rawValue: updateInfoMode) {
      team.setValue(updateInfoMode.rawValue, forKey: #keyPath(V2NIMUpdatedTeamInfo.updateInfoMode))
    }
    if let updateExtensionMode = arguments[#keyPath(updateExtensionMode)] as? Int,
       let updateExtensionMode = V2NIMTeamUpdateExtensionMode(rawValue: updateExtensionMode) {
      team.setValue(updateExtensionMode.rawValue, forKey: #keyPath(V2NIMUpdatedTeamInfo.updateExtensionMode))
    }
    if let chatBannedMode = arguments[#keyPath(chatBannedMode)] as? Int,
       let chatBannedMode = V2NIMTeamChatBannedMode(rawValue: chatBannedMode) {
      team.setValue(chatBannedMode.rawValue, forKey: #keyPath(V2NIMUpdatedTeamInfo.chatBannedMode))
    }
    if let customerExtension = arguments[#keyPath(customerExtension)] as? String {
      team.setValue(customerExtension, forKey: #keyPath(V2NIMUpdatedTeamInfo.customerExtension))
    }
    return team
  }
}
