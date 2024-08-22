// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import Foundation
import NIMSDK

enum FLTConvertError: Error {
  case runtimeError(String)
}

extension NIMMessageType {
  static func getType(_ sType: String?) throws -> NIMMessageType? {
    switch sType {
    //        case "undef"
    //            return NIMMessageType.undef
    case "text":
      return NIMMessageType.text
    case "image":
      return NIMMessageType.image
    case "audio":
      return NIMMessageType.audio
    case "video":
      return NIMMessageType.video
    case "location":
      return NIMMessageType.location
    case "notification":
      return NIMMessageType.notification
    case "file":
      return NIMMessageType.file
    case "tip":
      return NIMMessageType.tip
    case "robot":
      return NIMMessageType.robot
    case "rtc":
      return NIMMessageType.rtcCallRecord
    case "custom":
      return NIMMessageType.custom
    default:
      break
    }
    throw FLTConvertError
      .runtimeError("MsgTypeEnum not contains \(sType ?? "nuknow NIMSessionType")")
  }
}

extension NIMSessionType {
  static func getType(_ sType: String?) throws -> NIMSessionType? {
    switch sType {
    //        case "none":
    //            return NIMSessionType.P2P
    case "p2p":
      return NIMSessionType.P2P
    case "team":
      return NIMSessionType.team
    case "superTeam":
      return NIMSessionType.superTeam
    case "system":
      return NIMSessionType.YSF
    case "chatRoom":
      return NIMSessionType.chatroom
    default:
      break
    }

    throw FLTConvertError
      .runtimeError("SessionTypeEnum not contains \(sType ?? "nuknow NIMSessionType")")
  }
}

enum NIMNosScene: String {
  /// 用户、群组资料（eg:头像
  case defaultProfile

  /// 私聊、群聊、聊天室发送图片、音频、视频、文件..
  case defaultIm

  /// sdk内部上传文件（eg:日志）并且对应的过期时间不允许修改
  case systemNosScene

  /// 安全文件下载sceneKey前缀， 包含此前缀的都认为是安全文件
  case securityPrefix

  func getScene() -> String {
    switch self {
    case .defaultProfile:
      return NIMNOSSceneTypeAvatar

    case .defaultIm:
      return NIMNOSSceneTypeMessage

    case .systemNosScene:
      return "nim_system"

    case .securityPrefix:
      return NIMNOSSceneTypeSecurity
    }
  }

  static func toDic(scene: String?) -> String {
    switch scene {
    case NIMNOSSceneTypeAvatar:
      return NIMNosScene.defaultProfile.rawValue

    case NIMNOSSceneTypeMessage:
      return NIMNosScene.defaultIm.rawValue
    case "nim_system":
      return NIMNosScene.systemNosScene.rawValue
    case NIMNOSSceneTypeSecurity:
      return NIMNosScene.securityPrefix.rawValue
    default:
      return NIMNosScene.defaultIm.rawValue
    }
  }
}
