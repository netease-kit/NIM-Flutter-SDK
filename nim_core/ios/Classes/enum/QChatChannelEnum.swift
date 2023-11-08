// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

enum FLTQChatChannelType: String {
  case messageChannel // 消息频道
  case RTCChannel // 音视频频道
  case customChannel // 自定义频道

  func convertNIMQChatChannelType() -> NIMQChatChannelType {
    switch self {
    case .messageChannel:
      return .msg
    case .RTCChannel:
      return .RTC
    case .customChannel:
      return .custom
    }
  }

  static func convert(type: NIMQChatChannelType) -> FLTQChatChannelType? {
    switch type {
    case .msg:
      return .messageChannel
    case .RTC:
      return .RTCChannel
    case .custom:
      return .customChannel
    default:
      break
    }
    return nil
  }
}

enum FLTQChatVisitorMode: String {
  case visible
  case invisible
  case follow

  func convertNIMQChatVisitorMode() -> NIMQChatVisitorMode {
    switch self {
    case .visible:
      return .visible
    case .invisible:
      return .invisible
    case .follow:
      return .follow
    default:
      return .none
    }
  }

  static func convert(type: NIMQChatVisitorMode) -> FLTQChatVisitorMode? {
    switch type {
    case .follow:
      return .follow
    case .invisible:
      return .invisible
    case .visible:
      return .visible
    default:
      break
    }
    return nil
  }
}

enum FLTQChatChannelSyncMode: String {
  case none
  case sync

  func convertNIMQChatChannelSyncMode() -> NIMQChatChannelSyncMode {
    switch self {
    case .none:
      return .notSync
    case .sync:
      return .sync
    }
  }

  static func convert(type: NIMQChatChannelSyncMode) -> FLTQChatChannelSyncMode? {
    switch type {
    case .notSync:
      return none
    case .sync:
      return .sync
    default:
      break
    }
    return nil
  }
}

enum FLTQChatSubscribeType: String {
  case channelMsg
  case channelMsgUnreadCount
  case channelMsgUnreadStatus
  case serverMsg
  case channelMsgTyping

  func convertNIMQChatSubscribeType() -> NIMQChatSubscribeType {
    switch self {
    case .channelMsg:
      return .channelMsg
    case .channelMsgUnreadCount:
      return .channelMsgUnreadCount
    case .channelMsgUnreadStatus:
      return .channelMsgUnreadStatus
    case .serverMsg:
      return .serverMsg
    case .channelMsgTyping:
      return .channelTypingEvent
    }
  }

  static func convert(type: NIMQChatSubscribeType) -> FLTQChatSubscribeType? {
    switch type {
    case .channelMsg:
      return .channelMsg
    case .channelMsgUnreadCount:
      return .channelMsgUnreadCount
    case .channelMsgUnreadStatus:
      return .channelMsgUnreadStatus
    case .serverMsg:
      return .serverMsg
    case .channelTypingEvent:
      return .channelMsgTyping
    default:
      break
    }
    return nil
  }
}

enum FLTQChatSubscribeOperationType: String {
  case sub
  case unSub

  func convertNIMQChatSubscribeOperationType() -> NIMQChatSubscribeOperationType {
    switch self {
    case .sub:
      return .subscribe
    case .unSub:
      return .unsubscribe
    }
  }

  static func convert(type: NIMQChatSubscribeOperationType) -> FLTQChatSubscribeOperationType? {
    switch type {
    case .subscribe:
      return .sub
    case .unsubscribe:
      return .unSub
    default:
      break
    }
    return nil
  }
}

enum FLTQChatSearchChannelSortType: String {
  case ReorderWeight
  case CreateTime

  func convertNIMQChatSearchChannelSortType() -> NIMQChatSearchChannelSortType {
    switch self {
    case .ReorderWeight:
      return .customWeight
    case .CreateTime:
      return .createTime
    }
  }

  static func convert(type: NIMQChatSearchChannelSortType) -> FLTQChatSearchChannelSortType? {
    switch type {
    case .customWeight:
      return .ReorderWeight
    case .createTime:
      return .CreateTime
    default:
      break
    }
    return nil
  }
}

enum FLTQChatChannelMemberRoleType: String {
  case white
  case black

  func convertNIMQChatChannelMemberRoleType() -> NIMQChatChannelMemberRoleType {
    switch self {
    case .white:
      return .white
    case .black:
      return .black
    }
  }

  static func convert(type: NIMQChatChannelMemberRoleType) -> FLTQChatChannelMemberRoleType? {
    switch type {
    case .white:
      return .white
    case .black:
      return .black
    default:
      break
    }
    return nil
  }
}

enum FLTQChatChannelMemberRoleOpeType: String {
  case add
  case remove

  func convertNIMQChatChannelMemberRoleOpeType() -> NIMQChatChannelMemberRoleOpeType {
    switch self {
    case .add:
      return .add
    case .remove:
      return .remove
    }
  }

  static func convert(type: NIMQChatChannelMemberRoleOpeType) -> FLTQChatChannelMemberRoleOpeType? {
    switch type {
    case .add:
      return .add
    case .remove:
      return .remove
    default:
      break
    }
    return nil
  }
}

enum FLTQChatUpdateQuickCommentType: String {
  case add
  case remove

  func convertNIMQChatUpdateQuickCommentType() -> NIMQChatUpdateQuickCommentType {
    switch self {
    case .add:
      return .add
    case .remove:
      return .delete
    }
  }

  static func convert(type: NIMQChatUpdateQuickCommentType) -> FLTQChatUpdateQuickCommentType? {
    switch type {
    case .add:
      return .add
    case .delete:
      return .remove
    default:
      break
    }
    return nil
  }
}

enum FLTQChatInoutType: String {
  case inner
  case out

  func convertNIMQChatInoutType() -> NIMQChatInoutType {
    switch self {
    case .inner:
      return .in
    case .out:
      return .out
    }
  }

  static func convert(type: NIMQChatInoutType) -> FLTQChatInoutType? {
    switch type {
    case .in:
      return .inner
    case .out:
      return .out
    default:
      break
    }
    return nil
  }
}
