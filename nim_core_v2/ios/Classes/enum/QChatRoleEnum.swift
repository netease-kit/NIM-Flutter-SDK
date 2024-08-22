// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

enum FLTQChatRoleType: String {
  case everyone
  case custom

  func convertNIMQChatRoleType() -> NIMQChatRoleType {
    switch self {
    case .everyone:
      return .everyOne
    case .custom:
      return .custom
    }
  }

  static func convert(type: NIMQChatRoleType) -> FLTQChatRoleType? {
    switch type {
    case .everyOne:
      return .everyone
    case .custom:
      return .custom
    default:
      break
    }
    return nil
  }
}

enum FLTQChatPermissionStatus: String {
  case allow
  case deny
  case inherit

  func convertNIMQChatPermissionStatus() -> NIMQChatPermissionStatus {
    switch self {
    case .allow:
      return .allow
    case .deny:
      return .deny
    case .inherit:
      return .extend
    }
  }

  static func convert(type: NIMQChatPermissionStatus) -> FLTQChatPermissionStatus? {
    switch type {
    case .allow:
      return .allow
    case .deny:
      return .deny
    case .extend:
      return .inherit
    default:
      break
    }
    return nil
  }
}

enum FLTQChatPermissionType: String {
  case manageServer
  case manageChannel
  case manageRole
  case sendMsg
  case accountInfoSelf
  case inviteServer
  case kickServer
  case accountInfoOther
  case recallMsg
  case deleteMsg
  case remindOther
  case remindEveryone
  case manageBlackWhiteList
  case banServerMember
  case rtcChannelConnect
  case rtcChannelDisconnectOther
  case rtcChannelOpenMicrophone
  case rtcChannelOpenCamera
  case rtcChannelOpenCloseOtherMicrophone
  case rtcChannelOpenCloseOtherCamera
  case rtcChannelOpenCloseEveryoneMicrophone
  case rtcChannelOpenCloseEveryoneCamera
  case rtcChannelOpenScreenShare
  case rtcChannelCloseOtherScreenShare
  case serverApplyHandle
  case inviteApplyHistoryQuery
  case mentionedRole

  func convertNIMQChatPermissionType() -> NIMQChatPermissionType {
    switch self {
    case .manageServer:
      return .manageServer
    case .manageChannel:
      return .manageChannel
    case .manageRole:
      return .manageRole
    case .sendMsg:
      return .sendMsg
    case .accountInfoSelf:
      return .modifySelfInfo
    case .inviteServer:
      return .inviteToServer
    case .kickServer:
      return .kickOthersInServer
    case .accountInfoOther:
      return .modifyOthersInfoInServer
    case .recallMsg:
      return .revokeMsg
    case .deleteMsg:
      return .deleteOtherMsg
    case .remindOther:
      return .remindOther
    case .remindEveryone:
      return .remindAll
    case .manageBlackWhiteList:
      return .manageBlackWhiteList
    case .banServerMember:
      return .manageBanServerMember
    case .rtcChannelConnect:
      return .rtcChannelConnect
    case .rtcChannelDisconnectOther:
      return .rtcChannelDisconnectOther
    case .rtcChannelOpenMicrophone:
      return .rtcChannelOpenMicrophone
    case .rtcChannelOpenCamera:
      return .rtcChannelOpenCamera
    case .rtcChannelOpenCloseOtherMicrophone:
      return .rtcChannelOpenCloseOtherMicrophone
    case .rtcChannelOpenCloseOtherCamera:
      return .rtcChannelOpenCloseOtherCamera
    case .rtcChannelOpenCloseEveryoneMicrophone:
      return .rtcChannelOpenCloseEveryOneMicrophone
    case .rtcChannelOpenCloseEveryoneCamera:
      return .rtcChannelOpenCloseEveryOneCamera
    case .rtcChannelOpenScreenShare:
      return .rtcChannelOpenMyShareScreen
    case .rtcChannelCloseOtherScreenShare:
      return .rtcChannelCloseOtherShareScreen
    case .serverApplyHandle:
      return .handleServerApply
    case .inviteApplyHistoryQuery:
      return .queryServerInviteApplyHistory
    case .mentionedRole:
      return .queryMentionedRole
    }
  }

  static func convert(type: NIMQChatPermissionType) -> FLTQChatPermissionType? {
    switch type {
    case .manageServer:
      return .manageServer
    case .manageChannel:
      return .manageChannel
    case .manageRole:
      return .manageRole
    case .sendMsg:
      return .sendMsg
    case .modifySelfInfo:
      return .accountInfoSelf
    case .inviteToServer:
      return .inviteServer
    case .kickOthersInServer:
      return .kickServer
    case .modifyOthersInfoInServer:
      return .accountInfoOther
    case .revokeMsg:
      return .recallMsg
    case .deleteOtherMsg:
      return .deleteMsg
    case .remindOther:
      return .remindOther
    case .remindAll:
      return .remindEveryone
    case .manageBlackWhiteList:
      return .manageBlackWhiteList
    case .manageBanServerMember:
      return .banServerMember
    case .rtcChannelConnect:
      return .rtcChannelConnect
    case .rtcChannelDisconnectOther:
      return .rtcChannelDisconnectOther
    case .rtcChannelOpenMicrophone:
      return .rtcChannelOpenMicrophone
    case .rtcChannelOpenCamera:
      return .rtcChannelOpenCamera
    case .rtcChannelOpenCloseOtherMicrophone:
      return .rtcChannelOpenCloseOtherMicrophone
    case .rtcChannelOpenCloseOtherCamera:
      return .rtcChannelOpenCloseOtherCamera
    case .rtcChannelOpenCloseEveryOneMicrophone:
      return .rtcChannelOpenCloseEveryoneMicrophone
    case .rtcChannelOpenCloseEveryOneCamera:
      return .rtcChannelOpenCloseEveryoneCamera
    case .rtcChannelOpenMyShareScreen:
      return .rtcChannelOpenScreenShare
    case .rtcChannelCloseOtherShareScreen:
      return .rtcChannelCloseOtherScreenShare
    case .handleServerApply:
      return .serverApplyHandle
    case .queryServerInviteApplyHistory:
      return .inviteApplyHistoryQuery
    case .queryMentionedRole:
      return .mentionedRole
    default:
      break
    }
    return nil
  }
}
