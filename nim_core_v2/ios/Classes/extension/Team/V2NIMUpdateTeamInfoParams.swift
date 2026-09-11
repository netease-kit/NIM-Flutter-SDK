// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import Foundation
import NIMSDK

extension V2NIMUpdateTeamInfoParams {
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

    return keyPaths
  }

  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMUpdateTeamInfoParams {
    let params = V2NIMUpdateTeamInfoParams()
    if let name = arguments[#keyPath(name)] as? String {
      params.name = name
    }
    if let memberLimit = arguments[#keyPath(memberLimit)] as? Int {
      params.memberLimit = memberLimit
    }
    if let intro = arguments[#keyPath(intro)] as? String {
      params.intro = intro
    }
    if let announcement = arguments[#keyPath(announcement)] as? String {
      params.announcement = announcement
    }
    if let avatar = arguments[#keyPath(avatar)] as? String {
      params.avatar = avatar
    }
    if let serverExtension = arguments[#keyPath(serverExtension)] as? String {
      params.serverExtension = serverExtension
    }
    if let joinMode = arguments[#keyPath(joinMode)] as? Int, let joinMode = V2NIMTeamJoinMode(rawValue: joinMode) {
      params.joinMode = joinMode
    }
    if let agreeMode = arguments[#keyPath(agreeMode)] as? Int, let agreeMode = V2NIMTeamAgreeMode(rawValue: agreeMode) {
      params.agreeMode = agreeMode
    }
    if let inviteMode = arguments[#keyPath(inviteMode)] as? Int, let inviteMode = V2NIMTeamInviteMode(rawValue: inviteMode) {
      params.inviteMode = inviteMode
    }
    if let updateInfoMode = arguments[#keyPath(updateInfoMode)] as? Int, let updateInfoMode = V2NIMTeamUpdateInfoMode(rawValue: updateInfoMode) {
      params.updateInfoMode = updateInfoMode
    }
    if let updateExtensionMode = arguments[#keyPath(updateExtensionMode)] as? Int, let updateExtensionMode = V2NIMTeamUpdateExtensionMode(rawValue: updateExtensionMode) {
      params.updateExtensionMode = updateExtensionMode
    }
    return params
  }
}
