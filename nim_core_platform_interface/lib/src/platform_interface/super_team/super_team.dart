// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:json_annotation/json_annotation.dart';

import '../../../nim_core_platform_interface.dart';

part 'super_team.g.dart';

@JsonSerializable()
class NIMSuperTeam {
  /// 获取群组ID
  final String? id;

  /// 获取群组名称
  final String? name;

  /// 获取群头像
  final String? icon;

  /// 获取群组类型
  final NIMTeamTypeEnum type;

  /// 获取群组公告
  final String? announcement;

  /// 获取群组简介
  final String? introduce;

  /// 获取创建群组的用户帐号
  final String? creator;

  /// 获取群组的总成员数
  final int memberCount;

  /// 获取群组的成员人数上限
  final int memberLimit;

  /// 获取申请加入群组时的验证类型
  final NIMVerifyTypeEnum verifyType;

  /// 获取群组的创建时间
  final num createTime;

  /// 获取自己是否在这个群里
  final bool? isMyTeam;

  /// 设置群组扩展配置。 通常情况下，该配置应是一个json或xml串，以增强扩展能力
  final String? extension;

  /// 获取服务器设置的扩展配置。 和extension一样，云信不解释该字段，仅负责存储和透传。 不同于extension 该配置只能通过服务器接口设置，对客户端是只读的。
  final String? extServer;

  /// 获取当前账号在此群收到消息之后提醒的类型 普通群只支持全部禁言、全部提醒两种提醒类型
  final NIMTeamMessageNotifyTypeEnum messageNotifyType;

  /// 获取群被邀请模式：被邀请人的同意方式
  final NIMTeamInviteModeEnum teamInviteMode;

  /// 获取群被邀请模式：被邀请人的同意方式
  final NIMTeamBeInviteModeEnum teamBeInviteModeEnum;

  /// 获取群资料修改模式：谁可以修改群资料
  final NIMTeamUpdateModeEnum teamUpdateMode;

  /// 获取群资料扩展字段修改模式：谁可以修改群自定义属性(扩展字段)
  final NIMTeamExtensionUpdateModeEnum teamExtensionUpdateMode;

  /// 是否群全员禁言
  final bool? isAllMute;

  /// 获取群禁言模式
  final NIMTeamAllMuteModeEnum muteMode;

  NIMSuperTeam({
    this.id,
    this.name,
    this.icon,
    required this.type,
    this.announcement,
    this.introduce,
    this.creator,
    required this.memberCount,
    required this.memberLimit,
    required this.verifyType,
    required this.createTime,
    this.isMyTeam,
    this.extension,
    this.extServer,
    required this.messageNotifyType,
    required this.teamInviteMode,
    required this.teamBeInviteModeEnum,
    required this.teamUpdateMode,
    required this.teamExtensionUpdateMode,
    this.isAllMute,
    required this.muteMode,
  });

  factory NIMSuperTeam.fromMap(Map<String, dynamic> map) =>
      _$NIMSuperTeamFromJson(map);

  Map<String, dynamic> toMap() => _$NIMSuperTeamToJson(this);
}

/// 聊天室通知类型
class NIMSuperTeamNotificationTypes {
  //401 ~ 500的id给超大群使用
  /// 超大群拉人
  static const invite = 401;

  /// 超大群踢人
  static const kick = 402;

  /// 超大群退群
  static const leave = 403;

  /// 超大群修改群信息
  static const updateInfo = 404;

  /// 超大群解散
  static const dismiss = 405;

  /// 超大群移交群主
  static const changeOwner = 406;

  /// 超大群添加管理员
  static const addManager = 407;

  /// 超大群删除管理员
  static const removeManager = 408;

  /// 超大群禁言群成员
  static const muteList = 409;

  /// 超大群申请成功进群
  static const applyPass = 410;

  /// 超大群接受邀请进群
  static const inviteAccept = 411;
}
