// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:json_annotation/json_annotation.dart';
import 'package:nim_core_platform_interface/nim_core_platform_interface.dart';

part 'create_team_options.g.dart';

@JsonSerializable()
class NIMCreateTeamOptions {
  /// 群名
  final String? name;

  /// 群类型
  final NIMTeamTypeEnum? teamType;

  /// 群头像
  final String? avatarUrl;

  /// 群简介
  final String? introduce;

  /// 群公告
  final String? announcement;

  /// 群扩展字段
  final String? extension;

  ///   邀请他人的附言
  ///    高级群有效，普通群无需附言
  final String? postscript;

  ///  申请加入群组的验证模式
  final NIMVerifyTypeEnum? verifyType;

  ///  群邀请权限
  final NIMTeamInviteModeEnum? inviteMode;

  /// 被邀请模式, 只有高级群有效
  final NIMTeamBeInviteModeEnum? beInviteMode;

  /// 群资料修改模式：谁可以修改群资料 ,只有高级群有效;
  final NIMTeamUpdateModeEnum? updateInfoMode;

  /// 群资料扩展字段修改模式：谁可以修改群自定义属性(扩展字段) , 只有高级群有效
  final NIMTeamExtensionUpdateModeEnum? extensionUpdateMode;

  /// 指定创建群组的最大群成员数量 ，MaxMemberCount不能超过应用级配置的最大人数
  final int? maxMemberCount;

  NIMCreateTeamOptions(
      {this.name,
      this.teamType = NIMTeamTypeEnum.normal,
      this.avatarUrl,
      this.introduce,
      this.announcement,
      this.extension,
      this.postscript,
      this.verifyType,
      this.inviteMode,
      this.beInviteMode,
      this.updateInfoMode,
      this.extensionUpdateMode,
      this.maxMemberCount});

  factory NIMCreateTeamOptions.fromMap(Map<String, dynamic> map) =>
      _$NIMCreateTeamOptionsFromJson(map);

  Map<String, dynamic> toMap() => _$NIMCreateTeamOptionsToJson(this);
}
