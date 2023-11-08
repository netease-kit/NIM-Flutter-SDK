// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

enum FLTQChatLoginStep: String {
  /**
   *  连接服务器
   */
  case connecting
  /**
   *  登录
   */
  case logging
  /**
   *  登录成功
   */
  case loggedIn
  /**
   *  登录失败
   */
  case unLogin
  /**
   *  开始同步
   */
  case dataSyncStart
  /**
   *  同步完成
   */
  case dataSyncFinish
  /**
   *  连接断开
   */
  case netBroken

  case unknown
  case forbidden
  case versionError
  case pwdError
  case kickOut
  case kickOutByOtherClient

  func convertNIMQChatLoginStep() -> NIMQChatLoginStep? {
    switch self {
    case .connecting:
      return NIMQChatLoginStep.linking
    case .forbidden, .versionError:
      return NIMQChatLoginStep.linkFailed
    case .logging:
      return NIMQChatLoginStep.logining
    case .loggedIn:
      return NIMQChatLoginStep.loginOK
    case .unLogin, .pwdError:
      return NIMQChatLoginStep.loginFailed
    case .dataSyncStart:
      return NIMQChatLoginStep.syncing
    case .dataSyncFinish:
      return NIMQChatLoginStep.syncOK
    case .netBroken:
      return NIMQChatLoginStep.loseConnection
    default:
      return nil
    }
  }

  static func convert(type: NIMQChatLoginStep) -> FLTQChatLoginStep {
    switch type {
    case .linking:
      return .connecting
    case .logining, .linkOK:
      return .logging
    case .loginOK:
      return .loggedIn
    case .loginFailed:
      return .unLogin
    case .syncing:
      return .dataSyncStart
    case .syncOK:
      return .dataSyncFinish
    case .loseConnection:
      return .netBroken
    default:
      return .unknown
    }
  }
}

enum FLTMultiLoginType: String {
  case qchat_in
  case qchat_out

  func convertNIMMultiLoginType() -> NIMMultiLoginType {
    switch self {
    case .qchat_in:
      return .login
    case .qchat_out:
      return .logout
    }
  }

  static func convert(type: NIMMultiLoginType) -> FLTMultiLoginType? {
    switch type {
    case .login:
      return .qchat_in
    case .logout:
      return .qchat_out
    default:
      break
    }
    return nil
  }
}

enum FLTKickReason: String {
  /**
   *  被另外一个客户端踢下线 (互斥客户端一端登录挤掉上一个登录中的客户端)
   */
  case kick_by_same_platform
  /**
   *  被服务器踢下线
   */
  case kick_by_server
  /**
   *  被另外一个客户端手动选择踢下线
   */
  case kick_by_other_platform

  func convertNIMKickReason() -> NIMKickReason {
    switch self {
    case .kick_by_other_platform:
      return .byClientManually
    case .kick_by_server:
      return .byServer
    case .kick_by_same_platform:
      return .byClient
    }
  }

  static func convert(type: NIMKickReason) -> FLTKickReason? {
    switch type {
    case .byClient:
      return .kick_by_same_platform
    case .byServer:
      return .kick_by_server
    case .byClientManually:
      return .kick_by_other_platform
    default:
      break
    }
    return nil
  }
}

enum FLTQChatSystemNotificationToType: String {
  case server
  case channel
  case server_accids
  case channel_accids
  case accids

  func convertNIMQChatSystemNotificationToType() -> NIMQChatSystemNotificationToType {
    switch self {
    case .server:
      return .server
    case .channel:
      return .channel
    case .server_accids:
      return .serverAccids
    case .channel_accids:
      return .channelAccids
    case .accids:
      return .accids
    }
  }

  static func convert(type: NIMQChatSystemNotificationToType) -> FLTQChatSystemNotificationToType? {
    switch type {
    case .server:
      return .server
    case .channel:
      return .channel
    case .serverAccids:
      return .server_accids
    case .channelAccids:
      return .channel_accids
    case .accids:
      return .accids
    default:
      break
    }
    return nil
  }
}

enum FLTQChatSystemNotificationType: String {
  case server_member_invite
  case server_member_invite_reject
  case server_member_apply
  case server_member_apply_reject
  case server_create
  case server_remove
  case server_update
  case server_member_invite_done
  case server_member_invite_accept
  case server_member_apply_done
  case server_member_apply_accept
  case server_member_kick
  case server_member_leave
  case server_member_update
  case channel_create
  case channel_remove
  case channel_update
  case channel_update_white_black_role
  case channel_update_white_black_member
  case update_quick_comment
  case channel_category_create
  case channel_category_remove
  case channel_category_update
  case channel_category_update_white_black_role
  case channel_category_update_white_black_member
  case server_role_member_add
  case server_role_member_delete
  case server_role_auth_update
  case channel_role_auth_update
  case member_role_auth_update
  case channel_visibility_update
  case server_enter_leave
  case server_member_join_by_invite_code
  case custom

  func convertNIMQChatSystemNotificationType() -> NIMQChatSystemNotificationType {
    switch self {
    case .server_member_invite:
      return .serverMemberInvite
    case .server_member_invite_reject:
      return .serverMemberInviteReject
    case .server_member_apply:
      return .serverMemberApply
    case .server_member_apply_reject:
      return .serverMemberApplyReject
    case .server_create:
      return .serverCreate
    case .server_remove:
      return .serverRemove
    case .server_update:
      return .serverUpdate
    case .server_member_invite_done:
      return .serverMemberInviteDone
    case .server_member_invite_accept:
      return .serverMemberInviteAccept
    case .server_member_apply_done:
      return .serverMemberApplyDone
    case .server_member_apply_accept:
      return .serverMemberApplyAccept
    case .server_member_kick:
      return .serverMemberKick
    case .server_member_leave:
      return .serverMemberLeave
    case .server_member_update:
      return .serverMemberUpdate
    case .channel_create:
      return .channelCreate
    case .channel_remove:
      return .channelRemove
    case .channel_update:
      return .channelUpdate
    case .channel_update_white_black_role:
      return .channelUpdateWhiteBlackRole
    case .channel_update_white_black_member:
      return .channelUpdateWhiteBlackMember
    case .update_quick_comment:
      return .updateQuickComment
    case .channel_category_create:
      return .createChannelCategory
    case .channel_category_remove:
      return .deleteChannelCategory
    case .channel_category_update:
      return .updateChannelCategory
    case .channel_category_update_white_black_role:
      return .updateChannelCategoryBlackWhiteRole
    case .channel_category_update_white_black_member:
      return .updateChannelCategoryBlackWhiteMember
    case .server_role_member_add:
      return .addServerRoleMembers
    case .server_role_member_delete:
      return .removeServerRoleMembers
    case .server_role_auth_update:
      return .serverRoleAuthUpdate
    case .channel_role_auth_update:
      return .channelRoleAuthUpdate
    case .member_role_auth_update:
      return .memberRoleAuthUpdate
    case .channel_visibility_update:
      return .channelVisibilityUpdate
    case .server_enter_leave:
      return .serverEnterLeave
    case .server_member_join_by_invite_code:
      return .serverMemberJoinByInviteCode
    case .custom:
      return .custom
    }
  }

  static func convert(type: NIMQChatSystemNotificationType) -> FLTQChatSystemNotificationType? {
    switch type {
    case .serverMemberInvite:
      return .server_member_invite
    case .serverMemberInviteReject:
      return .server_member_invite_reject
    case .serverMemberApply:
      return .server_member_apply
    case .serverMemberApplyReject:
      return .server_member_apply_reject
    case .serverCreate:
      return .server_create
    case .serverRemove:
      return .server_remove
    case .serverUpdate:
      return .server_update
    case .serverMemberInviteDone:
      return .server_member_invite_done
    case .serverMemberInviteAccept:
      return .server_member_invite_accept
    case .serverMemberApplyDone:
      return .server_member_apply_done
    case .serverMemberApplyAccept:
      return .server_member_apply_accept
    case .serverMemberKick:
      return .server_member_kick
    case .serverMemberLeave:
      return .server_member_leave
    case .serverMemberUpdate:
      return .server_member_update
    case .channelCreate:
      return .channel_create
    case .channelRemove:
      return .channel_remove
    case .channelUpdate:
      return .channel_update
    case .channelUpdateWhiteBlackRole:
      return .channel_update_white_black_role
    case .channelUpdateWhiteBlackMember:
      return .channel_update_white_black_member
    case .updateQuickComment:
      return .update_quick_comment
    case .createChannelCategory:
      return .channel_category_create
    case .deleteChannelCategory:
      return .channel_category_remove
    case .updateChannelCategory:
      return .channel_category_update
    case .updateChannelCategoryBlackWhiteRole:
      return .channel_category_update_white_black_role
    case .updateChannelCategoryBlackWhiteMember:
      return .channel_category_update_white_black_member
    case .addServerRoleMembers:
      return .server_role_member_add
    case .removeServerRoleMembers:
      return .server_role_member_delete
    case .serverRoleAuthUpdate:
      return .server_role_auth_update
    case .channelRoleAuthUpdate:
      return .channel_role_auth_update
    case .memberRoleAuthUpdate:
      return .member_role_auth_update
    case .channelVisibilityUpdate:
      return .channel_visibility_update
    case .serverEnterLeave:
      return .server_enter_leave
    case .serverMemberJoinByInviteCode:
      return .server_member_join_by_invite_code
    case .custom:
      return .custom
    default:
      break
    }
    return nil
  }
}

enum FLTQChatMessageReferType: String {
  case replay
  case thread
  case all

  func convertNIMQChatMessageReferType() -> NIMQChatMessageReferType {
    switch self {
    case .replay:
      return .reply
    case .thread:
      return .thread
    case .all:
      return .all
    }
  }

  static func convert(type: NIMQChatMessageReferType) -> FLTQChatMessageReferType? {
    switch type {
    case .reply:
      return .replay
    case .thread:
      return .thread
    case .all:
      return .all
    default:
      break
    }
    return nil
  }
}

enum FLTQChatSearchMessageSortType: String {
  case createTime

  func convertNIMQChatSearchMessageSortType() -> NIMQChatSearchMessageSortType {
    switch self {
    case .createTime:
      return .sendTime
    }
  }

  static func convert(type: NIMQChatSearchMessageSortType) -> FLTQChatSearchMessageSortType? {
    switch type {
    case .sendTime:
      return .createTime
    default:
      break
    }
    return nil
  }
}
