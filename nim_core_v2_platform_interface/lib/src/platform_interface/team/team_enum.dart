// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:json_annotation/json_annotation.dart';

/// 群组类型枚举
enum NIMTeamType {
  /// 无效类型
  @JsonValue(0)
  typeInvalid,

  /// 高级群/讨论组
  @JsonValue(1)
  typeNormal,

  /// 超大群
  @JsonValue(2)
  typeSuper,
}

/// 申请入群模式
enum NIMTeamJoinMode {
  ///< 自由加入，无须验证
  @JsonValue(0)
  joinModeFree,

  ///< 需申请，群主或管理同意后加入
  @JsonValue(1)
  joinModeApply,

  ///< 私有群，不接受申请，仅能通过邀请方式入群
  @JsonValue(2)
  joinModeInvite,
}

/// 被邀请人同意入群模式
enum NIMTeamAgreeMode {
  ///< 需要被邀请方同意（默认值）
  @JsonValue(0)
  agreeModeAuth,

  ///< 不需要被邀请人同意
  @JsonValue(1)
  agreeModeNoAuth,
}

/// 邀请入群模式
enum NIMTeamInviteMode {
  ///< 群主，管理员可以邀请其他人入群
  @JsonValue(0)
  inviteModeManager,

  ///< 所有人都可以邀请其他人入群
  @JsonValue(1)
  inviteModeAll,
}

/// 群组资料修改模式
enum NIMTeamUpdateInfoMode {
  ///< 群主/管理员可以修改群组资料
  @JsonValue(0)
  updateInfoModeManager,

  ///< 所有人均可以修改群组资料
  @JsonValue(1)
  updateInfoModeAll,
}

/// 群组禁言模式
enum NIMTeamChatBannedMode {
  ///< 不禁言，群组成员可以自由发言
  @JsonValue(0)
  chatBannedModeNone,

  ///< 普通成员禁言，不包括管理员，群主
  @JsonValue(1)
  chatBannedModeBannedNormal,

  ///< 全员禁言，群组所有成员都被禁言， 该状态只能OpenApi发起
  @JsonValue(2)
  chatBannedModeBannedAll,
}

/// 群组成员角色
enum NIMTeamMemberRole {
  ///< 普通成员
  @JsonValue(0)
  memberRoleNormal,

  ///< 群组拥有者
  @JsonValue(1)
  memberRoleOwner,

  ///< 群组管理员
  @JsonValue(2)
  memberRoleManager,
}

/// 群组成员角色查询类型
enum NIMTeamMemberRoleQueryType {
  ///< 所有成员
  @JsonValue(0)
  memberRoleQueryTypeAll,

  ///< 群组管理员(包括群主)
  @JsonValue(1)
  memberRoleQueryTypeManager,

  ///< 普通成员
  @JsonValue(2)
  memberRoleQueryTypeNormal,
}

/// 成员入群操作类型
enum NIMTeamJoinActionType {
  ///< 申请入群
  @JsonValue(0)
  joinActionTypeApplication,

  ///< 申请人收到管理员拒绝申请
  @JsonValue(1)
  joinActionTypeRejectApplication,

  ///< 邀请入群
  @JsonValue(2)
  joinActionTypeInvitation,

  ///< 成员拒绝邀请入群
  @JsonValue(3)
  joinActionTypeRejectInvitation,
}

/// 成员入群操作处理状态
enum NIMTeamJoinActionStatus {
  ///< 未处理
  @JsonValue(0)
  joinActionStatusInit,

  ///< 已同意
  @JsonValue(1)
  joinActionStatusAgreed,

  ///< 已拒绝
  @JsonValue(2)
  joinActionStatusRejected,

  ///< 已过期
  @JsonValue(3)
  joinActionStatusExpired,
}

/// 排序
enum NIMSortOrder {
  /// 降序
  @JsonValue(0)
  sortOrderDesc,

  /// 升序
  @JsonValue(1)
  sortOrderAsc,
}

/// 群组扩展字段修改模式
enum NIMTeamUpdateExtensionMode {
  ///< 群主/管理员可以修改群组扩展字段
  @JsonValue(0)
  updateExtensionModeManager,

  ///< 所有人均可以修改群组扩展字段
  @JsonValue(1)
  updateExtensionModeAll,
}
