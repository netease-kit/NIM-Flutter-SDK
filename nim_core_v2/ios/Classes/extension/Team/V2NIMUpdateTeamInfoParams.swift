// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import Foundation
import NIMSDK

extension V2NIMUpdateTeamInfoParams {
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
      #keyPath(updateInfoMode): updateInfoMode.rawValue,
      #keyPath(updateExtensionMode): updateExtensionMode.rawValue,
    ]
    return dict
  }

  static func fromDictionary(_ dict: [String: Any]) -> V2NIMUpdateTeamInfoParams {
    let params = V2NIMUpdateTeamInfoParams()
    if let name = dict[#keyPath(name)] as? String {
      params.name = name
    }
    if let memberLimit = dict[#keyPath(memberLimit)] as? Int {
      params.memberLimit = memberLimit
    }
    if let intro = dict[#keyPath(intro)] as? String {
      params.intro = intro
    }
    if let announcement = dict[#keyPath(announcement)] as? String {
      params.announcement = announcement
    }
    if let avatar = dict[#keyPath(avatar)] as? String {
      params.avatar = avatar
    }
    if let serverExtension = dict[#keyPath(serverExtension)] as? String {
      params.serverExtension = serverExtension
    }
    if let joinMode = dict[#keyPath(joinMode)] as? Int, let joinMode = V2NIMTeamJoinMode(rawValue: joinMode) {
      params.joinMode = joinMode
    }
    if let agreeMode = dict[#keyPath(agreeMode)] as? Int, let agreeMode = V2NIMTeamAgreeMode(rawValue: agreeMode) {
      params.agreeMode = agreeMode
    }
    if let inviteMode = dict[#keyPath(inviteMode)] as? Int, let inviteMode = V2NIMTeamInviteMode(rawValue: inviteMode) {
      params.inviteMode = inviteMode
    }
    if let updateInfoMode = dict[#keyPath(updateInfoMode)] as? Int, let updateInfoMode = V2NIMTeamUpdateInfoMode(rawValue: updateInfoMode) {
      params.updateInfoMode = updateInfoMode
    }
    if let updateExtensionMode = dict[#keyPath(updateExtensionMode)] as? Int, let updateExtensionMode = V2NIMTeamUpdateExtensionMode(rawValue: updateExtensionMode) {
      params.updateExtensionMode = updateExtensionMode
    }
    return params
  }
}
