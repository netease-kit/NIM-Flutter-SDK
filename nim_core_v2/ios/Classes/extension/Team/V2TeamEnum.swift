// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import Foundation

import NIMSDK

/// 枚举转换类
enum V2TeamEnumConverterUtil {
  /// 将群类型转换为对应的字符串
  /// - Parameter value: 群类型
  /// - Returns: 对应的字符串
  static func teamTypeEnumMap(_ value: V2NIMTeamType) -> String {
    switch value {
    case .TEAM_TYPE_INVALID:
      return "typeInvalid"
    case .TEAM_TYPE_NORMAL:
      return "typeNormal"
    case .TEAM_TYPE_SUPER:
      return "typeSuper"
    @unknown default:
      return "typeInvalid"
    }
  }

  /// 将入群方式转换为对应的字符串
  /// - Parameter value: 入群方式
  /// - Returns: 对应的字符串
  static func teamJoinModeEnumMap(_ value: V2NIMTeamJoinMode) -> String {
    switch value {
    case .TEAM_JOIN_MODE_FREE:
      return "joinModeFree"
    case .TEAM_JOIN_MODE_APPLY:
      return "joinModeApply"
    case .TEAM_JOIN_MODE_INVITE:
      return "joinModeInvite"
    @unknown default:
      return "joinModeFree"
    }
  }

  /// 将验证方式转换为对应的字符串
  /// - Parameter value: 验证方式
  /// - Returns: 对应的字符串
  static func teamAgreeModeEnumMap(_ value: V2NIMTeamAgreeMode) -> String {
    switch value {
    case .TEAM_AGREE_MODE_AUTH:
      return "agreeModeAuth"
    case .TEAM_AGREE_MODE_NO_AUTH:
      return "agreeModeNoAuth"
    @unknown default:
      return "agreeModeAuth"
    }
  }

  /// 将邀请方式转换为对应的字符串
  /// - Parameter value: 邀请方式
  /// - Returns: 对应的字符串
  static func teamInviteModeEnumMap(_ value: V2NIMTeamInviteMode) -> String {
    switch value {
    case .TEAM_INVITE_MODE_MANAGER:
      return "inviteModeManager"
    case .TEAM_INVITE_MODE_ALL:
      return "inviteModeAll"
    @unknown default:
      return "inviteModeManager"
    }
  }

  /// 将群信息修改权限转换为对应的字符串
  /// - Parameter value: 群信息修改权限
  /// - Returns: 对应的字符串
  static func teamUpdateInfoModeEnumMap(_ value: V2NIMTeamUpdateInfoMode) -> String {
    switch value {
    case .TEAM_UPDATE_INFO_MODE_MANAGER:
      return "updateInfoModeManager"
    case .TEAM_UPDATE_INFO_MODE_ALL:
      return "updateInfoModeAll"
    @unknown default:
      return "updateInfoModeManager"
    }
  }

  /// 将群扩展信息修改权限转换为对应的字符串
  ///  - Parameter value: 群扩展信息修改权限
  ///  - Returns: 对应的字符串
  static func teamUpdateExtensionModeEnumMap(_ value: V2NIMTeamUpdateExtensionMode) -> String {
    switch value {
    case .TEAM_UPDATE_EXTENSION_MODE_MANAGER:
      return "updateInfoModeManager"
    case .TEAM_UPDATE_EXTENSION_MODE_ALL:
      return "updateExtensionModeAll"
    @unknown default:
      return "updateInfoModeManager"
    }
  }

  /// 将群禁言模式转换为对应的字符串
  /// - Parameter value: 群禁言模式
  /// - Returns: 对应的字符串
  static func teamChatBannedModeEnumMap(_ value: V2NIMTeamChatBannedMode) -> String {
    switch value {
    case .TEAM_CHAT_BANNED_MODE_NONE:
      return "chatBannedModeNone"
    case .TEAM_CHAT_BANNED_MODE_BANNED_NORMAL:
      return "chatBannedModeBannedNormal"
    case .TEAM_CHAT_BANNED_MODE_BANNED_ALL:
      return "chatBannedModeBannedAll"
    @unknown default:
      return "chatBannedModeNone"
    }
  }

  /// 将群成员角色查询类型转换为对应的字符串
  /// - Parameter value: 群成员角色查询类型
  /// - Returns: 对应的字符串
  static func teamMemberRoleEnumMap(_ value: V2NIMTeamMemberRole) -> String {
    switch value {
    case .TEAM_MEMBER_ROLE_OWNER:
      return "memberRoleOwner"
    case .TEAM_MEMBER_ROLE_MANAGER:
      return "memberRoleManager"
    case .TEAM_MEMBER_ROLE_NORMAL:
      return "memberRoleNormal"
    @unknown default:
      return "memberRoleNormal"
    }
  }

  /// 将被邀请模式转换为对应的字符串
  /// - Parameter value: 被邀请模式
  /// - Returns: 对应的字符串
  static func teamJoinModeEnumMap(_ value: V2NIMTeamJoinActionType) -> String {
    switch value {
    case .TEAM_JOIN_ACTION_TYPE_APPLICATION:
      return "joinActionTypeApplication"
    case .TEAM_JOIN_ACTION_TYPE_REJECT_APPLICATION:
      return "joinActionTypeRejectApplication"
    case .TEAM_JOIN_ACTION_TYPE_INVITATION:
      return "joinActionTypeInvitation"
    case .TEAM_JOIN_ACTION_TYPE_REJECT_INVITATION:
      return "joinActionTypeRejectInvitation"
    @unknown default:
      return "joinActionTypeApplication"
    }
  }

  /// 将被邀请状态转换为对应的字符串
  /// - Parameter value: 被邀请状态
  /// - Returns: 对应的字符串
  static func teamJoinActionStatusEnumMap(_ value: V2NIMTeamJoinActionStatus) -> String {
    switch value {
    case .TEAM_JOIN_ACTION_STATUS_INIT:
      return "joinActionStatusInit"
    case .TEAM_JOIN_ACTION_STATUS_AGREED:
      return "joinActionStatusAgreed"
    case .TEAM_JOIN_ACTION_STATUS_REJECTED:
      return "joinActionStatusRejected"
    case .TEAM_JOIN_ACTION_STATUS_EXPIRED:
      return "joinActionStatusExpired"
    @unknown default:
      return "joinActionStatusInit"
    }
  }

  /// 将群成员查询类型转换为对应的字符串
  /// - Parameter value: 群成员查询类型
  /// - Returns: 对应的字符串
  static func teamQueryMemberRoleTypeEnumMap(_ value: V2NIMTeamMemberRoleQueryType) -> String {
    switch value {
    case .TEAM_MEMBER_ROLE_QUERY_TYPE_NORMAL:
      return "memberQueryTypeNormal"
    case .TEAM_MEMBER_ROLE_QUERY_TYPE_ALL:
      return "memberQueryTypeAll"
    case .TEAM_MEMBER_ROLE_QUERY_TYPE_MANAGER:
      return "memberQueryTypeSuper"
    @unknown default:
      return "memberQueryTypeAll"
    }
  }

  /// 将字符串转换为群类型
  /// - Parameter value: 字符串
  /// - Returns: 群类型
  static func stringToTeamType(_ value: String) -> V2NIMTeamType {
    switch value {
    case "typeInvalid":
      return .TEAM_TYPE_INVALID
    case "typeNormal":
      return .TEAM_TYPE_NORMAL
    case "typeSuper":
      return .TEAM_TYPE_SUPER
    default:
      return .TEAM_TYPE_INVALID
    }
  }

  /// 将字符串转换为入群方式
  /// - Parameter value: 字符串
  /// - Returns: 入群方式
  static func stringToTeamJoinMode(_ value: String) -> V2NIMTeamJoinMode {
    switch value {
    case "joinModeFree":
      return .TEAM_JOIN_MODE_FREE
    case "joinModeApply":
      return .TEAM_JOIN_MODE_APPLY
    case "joinModeInvite":
      return .TEAM_JOIN_MODE_INVITE
    default:
      return .TEAM_JOIN_MODE_FREE
    }
  }

  /// 将字符串转换为验证方式
  /// - Parameter value: 字符串
  /// - Returns: 验证方式
  static func stringToTeamAgreeMode(_ value: String) -> V2NIMTeamAgreeMode {
    switch value {
    case "agreeModeAuth":
      return .TEAM_AGREE_MODE_AUTH
    case "agreeModeNoAuth":
      return .TEAM_AGREE_MODE_NO_AUTH
    default:
      return .TEAM_AGREE_MODE_AUTH
    }
  }

  /// 将字符串转换为邀请方式
  /// - Parameter value: 字符串
  /// - Returns: 邀请方式
  static func stringToTeamInviteMode(_ value: String) -> V2NIMTeamInviteMode {
    switch value {
    case "inviteModeManager":
      return .TEAM_INVITE_MODE_MANAGER
    case "inviteModeAll":
      return .TEAM_INVITE_MODE_ALL
    default:
      return .TEAM_INVITE_MODE_MANAGER
    }
  }

  /// 将字符串转换为群信息修改权限
  /// - Parameter value: 字符串
  /// - Returns: 群更新信息权限
  static func stringToTeamUpdateInfoMode(_ value: String) -> V2NIMTeamUpdateInfoMode {
    switch value {
    case "updateInfoModeManager":
      return .TEAM_UPDATE_INFO_MODE_MANAGER
    case "updateInfoModeAll":
      return .TEAM_UPDATE_INFO_MODE_ALL
    default:
      return .TEAM_UPDATE_INFO_MODE_MANAGER
    }
  }

  /// 将字符串转换为群扩展信息修改权限
  /// - Parameter value: 字符串
  /// - Returns: 群扩展信息修改权限
  static func stringToTeamUpdateExtensionMode(_ value: String) -> V2NIMTeamUpdateExtensionMode {
    switch value {
    case "updateExtensionModeManager":
      return .TEAM_UPDATE_EXTENSION_MODE_MANAGER
    case "updateExtensionModeAll":
      return .TEAM_UPDATE_EXTENSION_MODE_ALL
    default:
      return .TEAM_UPDATE_EXTENSION_MODE_MANAGER
    }
  }

  /// 将字符串转换为群禁言模式
  /// - Parameter value: 字符串
  /// - Returns: 群禁言模式
  static func stringToTeamChatBannedMode(_ value: String) -> V2NIMTeamChatBannedMode {
    switch value {
    case "chatBannedModeNone":
      return .TEAM_CHAT_BANNED_MODE_NONE
    case "chatBannedModeBannedNormal":
      return .TEAM_CHAT_BANNED_MODE_BANNED_NORMAL
    case "chatBannedModeBannedAll":
      return .TEAM_CHAT_BANNED_MODE_BANNED_ALL
    default:
      return .TEAM_CHAT_BANNED_MODE_NONE
    }
  }

  /// 将字符串转换为群成员角色
  /// - Parameter value: 字符串
  /// - Returns: 群成员角色
  static func stringToTeamMemberRole(_ value: String) -> V2NIMTeamMemberRole {
    switch value {
    case "memberRoleOwner":
      return .TEAM_MEMBER_ROLE_OWNER
    case "memberRoleManager":
      return .TEAM_MEMBER_ROLE_MANAGER
    case "memberRoleNormal":
      return .TEAM_MEMBER_ROLE_NORMAL
    default:
      return .TEAM_MEMBER_ROLE_NORMAL
    }
  }

  /// 将字符串转换为被邀请模式
  /// - Parameter value: 字符串
  /// - Returns: 被邀请模式
  static func stringToTeamJoinActionType(_ value: String) -> V2NIMTeamJoinActionType {
    switch value {
    case "joinActionTypeApplication":
      return .TEAM_JOIN_ACTION_TYPE_APPLICATION
    case "joinActionTypeRejectApplication":
      return .TEAM_JOIN_ACTION_TYPE_REJECT_APPLICATION
    case "joinActionTypeInvitation":
      return .TEAM_JOIN_ACTION_TYPE_INVITATION
    case "joinActionTypeRejectInvitation":
      return .TEAM_JOIN_ACTION_TYPE_REJECT_INVITATION
    default:
      return .TEAM_JOIN_ACTION_TYPE_APPLICATION
    }
  }

  /// 将字符串转换为被邀请状态
  /// - Parameter value: 字符串
  /// - Returns: 被邀请状态
  static func stringToTeamJoinActionStatus(_ value: String) -> V2NIMTeamJoinActionStatus {
    switch value {
    case "joinActionStatusInit":
      return .TEAM_JOIN_ACTION_STATUS_INIT
    case "joinActionStatusAgreed":
      return .TEAM_JOIN_ACTION_STATUS_AGREED
    case "joinActionStatusRejected":
      return .TEAM_JOIN_ACTION_STATUS_REJECTED
    case "joinActionStatusExpired":
      return .TEAM_JOIN_ACTION_STATUS_EXPIRED
    default:
      return .TEAM_JOIN_ACTION_STATUS_INIT
    }
  }

  /// 将字符串转换为群成员查询类型
  /// - Parameter value: 字符串
  /// - Returns: 群成员查询类型
  static func stringToTeamMemberRoleQueryType(_ value: String) -> V2NIMTeamMemberRoleQueryType {
    switch value {
    case "memberQueryTypeNormal":
      return .TEAM_MEMBER_ROLE_QUERY_TYPE_NORMAL
    case "memberQueryTypeAll":
      return .TEAM_MEMBER_ROLE_QUERY_TYPE_ALL
    case "memberQueryTypeSuper":
      return .TEAM_MEMBER_ROLE_QUERY_TYPE_MANAGER
    default:
      return .TEAM_MEMBER_ROLE_QUERY_TYPE_ALL
    }
  }

  /// 将字符串转换为查询类型
  /// - Parameter value: 字符串
  /// - Returns: 查询方向
  static func stringToQueryDirection(_ value: String) -> V2NIMQueryDirection {
    switch value {
    case "queryDirectionDesc":
      return .QUERY_DIRECTION_DESC
    case "queryDirectionAsc":
      return .QUERY_DIRECTION_ASC
    default:
      return .QUERY_DIRECTION_DESC
    }
  }

  /// 将查询类型转换为对应的字符串
  /// - Parameter value: 查询方向
  /// - Returns: 对应的字符串
  static func teamQueryDirectionToString(_ value: V2NIMQueryDirection) -> String {
    switch value {
    case .QUERY_DIRECTION_DESC:
      return "queryDirectionDesc"
    case .QUERY_DIRECTION_ASC:
      return "queryDirectionAsc"
    @unknown default:
      return "queryDirectionDesc"
    }
  }

  /// 将排序类型转换为对应的字符串
  /// - Parameter value: 排序类型
  /// - Returns: 对应的字符串
  static func teamQueryMemberSortOrderToString(_ value: V2NIMSortOrder) -> String {
    switch value {
    case .SORT_ORDER_DESC:
      return "sortOrderDesc"
    case .SORT_ORDER_ASC:
      return "sortOrderAsc"
    @unknown default:
      return "sortOrderDesc"
    }
  }

  /// 将字符串转换为排序类型
  /// - Parameter value: 字符串
  /// - Returns: 排序类型
  static func teamQueryMemberSortOrderToString(_ value: String) -> V2NIMSortOrder {
    switch value {
    case "sortOrderDesc":
      return .SORT_ORDER_DESC
    case "sortOrderAsc":
      return .SORT_ORDER_ASC
    default:
      return .SORT_ORDER_DESC
    }
  }
}
