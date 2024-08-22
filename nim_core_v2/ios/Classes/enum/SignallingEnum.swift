// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

enum FLTSignalingChannelType: String {
  case audio
  case video
  case custom

  func convertNIMSignalingChannelType() -> NIMSignalingChannelType {
    switch self {
    case .audio:
      return NIMSignalingChannelType.audio
    case .video:
      return NIMSignalingChannelType.video
    case .custom:
      return NIMSignalingChannelType.custom
    }
  }

  static func convert(type: NIMSignalingChannelType) -> FLTSignalingChannelType? {
    switch type {
    case NIMSignalingChannelType.audio:
      return .audio
    case NIMSignalingChannelType.video:
      return .video
    case NIMSignalingChannelType.custom:
      return .custom
    default:
      break
    }
    return nil
  }
}

enum FLTSignnallingChannelStatus: String {
  case normal
  case invalid

  func convertNIMchannelStatus() -> Bool {
    switch self {
    case .normal:
      return false
    case .invalid:
      return true
    }
  }

  static func convert(status: Bool) -> FLTSignnallingChannelStatus? {
    switch status {
    case false:
      return .normal
    case true:
      return .invalid
    }
  }
}

enum FLTSignalingEventType: String {
  case unKnow
  case close
  case join
  case invite
  case cancelInvite
  case reject
  case accept
  case leave
  case control

  func convertNIMSignalingEventType() -> NIMSignalingEventType? {
    switch self {
    case .close:
      return NIMSignalingEventType.close
    case .join:
      return NIMSignalingEventType.join
    case .invite:
      return NIMSignalingEventType.invite
    case .cancelInvite:
      return NIMSignalingEventType.cancelInvite
    case .reject:
      return NIMSignalingEventType.reject
    case .accept:
      return NIMSignalingEventType.accept
    case .leave:
      return NIMSignalingEventType.leave
    case .control:
      return NIMSignalingEventType.contrl
    case .unKnow:
      return nil
    }
  }

  static func convert(type: NIMSignalingEventType) -> FLTSignalingEventType {
    switch type {
    case .close:
      return .close
    case .join:
      return .join
    case .invite:
      return .invite
    case .cancelInvite:
      return .cancelInvite
    case .reject:
      return .reject
    case .accept:
      return .accept
    case .leave:
      return .leave
    case .contrl:
      return .control
    default:
      return .unKnow
    }
  }
}
