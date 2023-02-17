// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

enum FLTQChatServerInviteMode: String {
  case agreeNeed
  case agreeNeedNot

  func convertToQChatServerInviteMode() -> NIMQChatServerInviteMode {
    switch self {
    case .agreeNeed:
      return .needApprove
    case .agreeNeedNot:
      return .autoEnter
    }
  }

  static func convert(type: NIMQChatServerInviteMode) -> FLTQChatServerInviteMode? {
    switch type {
    case .needApprove:
      return .agreeNeed
    case .autoEnter:
      return .agreeNeedNot
    default:
      return nil
    }
  }
}

enum FLTQChatServerApplyMode: String {
  case agreeNeed
  case agreeNeedNot

  func convertToQChatServerApplyMode() -> NIMQChatServerApplyMode {
    switch self {
    case .agreeNeed:
      return .needApprove
    case .agreeNeedNot:
      return .autoEnter
    }
  }

  static func convert(type: NIMQChatServerApplyMode) -> FLTQChatServerApplyMode? {
    switch type {
    case .needApprove:
      return .agreeNeed
    case .autoEnter:
      return .agreeNeedNot
    default:
      return nil
    }
  }
}

enum FLTQChatServerMemberType: String {
  case normal
  case owner

  func convertToQChatServerMemberType() -> NIMQChatServerMemberType {
    switch self {
    case .normal:
      return .common
    case .owner:
      return .owner
    }
  }

  static func convert(type: NIMQChatServerMemberType) -> FLTQChatServerMemberType? {
    switch type {
    case .owner:
      return .owner
    case .common:
      return .normal
    default:
      return nil
    }
  }
}

enum FLTQChatSearchServerType: String {
  case undefined
  case square
  case personal

  func convertToQChatSearchServerType() -> NIMQChatSearchServerType? {
    switch self {
    case .personal:
      return .personal
    case .square:
      return .square
    default:
      return nil
    }
  }

  static func convert(type: NIMQChatSearchServerType) -> FLTQChatSearchServerType? {
    switch type {
    case .personal:
      return .personal
    case .square:
      return .square
    default:
      return .undefined
    }
  }
}

enum FLTQChatSearchServerSortType: String {
  case reorderWeight
  case createTime
  case totalMember

  func convertToQChatSearchServerSortType() -> NIMQChatSearchServerSortType {
    switch self {
    case .reorderWeight:
      return .customWeight
    case .createTime:
      return .createTime
    case .totalMember:
      return .memberCount
    }
  }

  static func convert(type: NIMQChatSearchServerSortType) -> FLTQChatSearchServerSortType? {
    switch type {
    case .customWeight:
      return .reorderWeight
    case .createTime:
      return .createTime
    case .memberCount:
      return .totalMember
    default:
      return nil
    }
  }
}

enum FLTQChatPushNotificationProfile: String {
  case all
  case highMidLevel
  case highLevel
  case none
  case inherit

  func convertToPushNotificationProfile() -> NIMPushNotificationProfile {
    switch self {
    case .all:
      return .enableAll
    case .highMidLevel:
      return .onlyHighAndMediumLevel
    case .highLevel:
      return .onlyHighLevel
    case .none:
      return .disableAll
    case .inherit:
      return .platformDefault
    }
  }

  static func convert(type: NIMPushNotificationProfile) -> FLTQChatPushNotificationProfile? {
    switch type {
    case .enableAll:
      return .all
    case .onlyHighAndMediumLevel:
      return .highMidLevel
    case .onlyHighLevel:
      return .highLevel
    case .disableAll:
      return FLTQChatPushNotificationProfile.none
    case .platformDefault:
      return .inherit
    default:
      return nil
    }
  }
}

enum FLTQChatUserPushNotificationConfigType: String {
  case channel
  case server
  case channelCategory

  func convertToPushNotificationProfile() -> NIMQChatUserPushNotificationConfigType {
    switch self {
    case .channel:
      return .channel
    case .server:
      return .server
    case .channelCategory:
      return .category
    }
  }

  static func convert(type: NIMQChatUserPushNotificationConfigType)
    -> FLTQChatUserPushNotificationConfigType? {
    switch type {
    case .channel:
      return .channel
    case .server:
      return .server
    case .category:
      return .channelCategory
    default:
      return nil
    }
  }
}

enum FLTQChatInviteApplyInfoStatusTag: String {
  case initial
  case accept
  case reject
  case acceptByOther
  case rejectByOther
  case autoJoin
  case expired

  func convertToPushNotificationProfile() -> NIMQChatInviteApplyInfoStatusTag {
    switch self {
    case .initial:
      return .`init`
    case .accept:
      return .agree
    case .reject:
      return .refuse
    case .acceptByOther:
      return .agreeByInviteApply
    case .rejectByOther:
      return .refuseByInviteApply
    case .autoJoin:
      return .autoJoinByInviteApply
    case .expired:
      return .expired
    }
  }

  static func convert(type: NIMQChatInviteApplyInfoStatusTag)
    -> FLTQChatInviteApplyInfoStatusTag? {
    switch type {
    case .`init`:
      return .initial
    case .agree:
      return .accept
    case .refuse:
      return .reject
    case .agreeByInviteApply:
      return .acceptByOther
    case .refuseByInviteApply:
      return .rejectByOther
    case .autoJoinByInviteApply:
      return .autoJoin
    case .expired:
      return .expired
    default:
      return nil
    }
  }
}

enum FLTQChatInviteApplyInfoTypeTag: String {
  case apply
  case invite
  case beInvited
  case generateInviteCode
  case joinByInviteCode

  func convertToPushNotificationProfile() -> NIMQChatInviteApplyInfoTypeTag {
    switch self {
    case .apply:
      return .apply
    case .invite:
      return .invite
    case .beInvited:
      return .inviteAck
    case .generateInviteCode:
      return .inviteCode
    case .joinByInviteCode:
      return .inviteJoinByCode
    }
  }

  static func convert(type: NIMQChatInviteApplyInfoTypeTag)
    -> FLTQChatInviteApplyInfoTypeTag? {
    switch type {
    case .apply:
      return .apply
    case .invite:
      return .invite
    case .inviteAck:
      return .beInvited
    case .inviteCode:
      return .generateInviteCode
    case .inviteJoinByCode:
      return .joinByInviteCode
    default:
      return nil
    }
  }
}
