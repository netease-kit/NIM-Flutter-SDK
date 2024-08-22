// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import Foundation
import NIMSDK

enum V2SettingEnum {
  /// 群组消息免打扰模式转换中间层枚举类型
  /// - Parameters: 原生群禁言枚举类型
  /// - Returns: String
  static func settingMessageMuteEnum(_ value: V2NIMTeamMessageMuteMode) -> String {
    switch value {
    case .TEAM_MESSAGE_MUTE_MODE_OFF:
      return "teamMessageMuteModeOff"
    case .TEAM_MESSAGE_MUTE_MODE_ON:
      return "teamMessageMuteModeOn"
    case .TEAM_MESSAGE_MUTE_MODE_MANAGER_OFF:
      return "teamMessageMuteModeManagerOff"
    @unknown default:
      return "teamMessageMuteModeOff"
    }
  }

  /// 群组消息免打扰模式中间层类型转换原生类型
  /// - Parameters: 中间层群禁言枚举类型
  /// - Returns: V2NIMTeamMessageMuteMode
  static func stringToSettingMessageMuteEnum(_ value: String) -> V2NIMTeamMessageMuteMode {
    switch value {
    case "teamMessageMuteModeOff":
      return .TEAM_MESSAGE_MUTE_MODE_OFF
    case "teamMessageMuteModeOn":
      return .TEAM_MESSAGE_MUTE_MODE_ON
    case "teamMessageMuteModeManagerOff":
      return .TEAM_MESSAGE_MUTE_MODE_MANAGER_OFF
    default:
      return .TEAM_MESSAGE_MUTE_MODE_OFF
    }
  }

  /// 单聊消息免打扰模式转换中间层枚举类型
  /// - Parameters: 原生禁言枚举类型
  /// - Returns: String
  static func settingP2PMessageMuteEnum(_ value: V2NIMP2PMessageMuteMode) -> String {
    switch value {
    case .NIM_P2P_MESSAGE_MUTE_MODE_ON:
      return "p2pMessageMuteModeOff"
    case .NIM_P2P_MESSAGE_MUTE_MODE_OFF:
      return "p2pMessageMuteModeOn"
    @unknown default:
      return "p2pMessageMuteModeOff"
    }
  }

  /// 单聊消息免打扰模式中间层类型转换原生类型
  /// - Parameters: 单聊中间层禁言类型
  /// - Returns: V2NIMP2PMessageMuteMode
  static func stringToSettingP2PMessageMuteEnum(_ value: String) -> V2NIMP2PMessageMuteMode {
    switch value {
    case "p2pMessageMuteModeOff":
      return .NIM_P2P_MESSAGE_MUTE_MODE_OFF
    case "p2pMessageMuteModeOn":
      return .NIM_P2P_MESSAGE_MUTE_MODE_ON
    default:
      return .NIM_P2P_MESSAGE_MUTE_MODE_OFF
    }
  }
}
