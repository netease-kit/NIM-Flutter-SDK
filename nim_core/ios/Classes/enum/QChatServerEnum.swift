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
