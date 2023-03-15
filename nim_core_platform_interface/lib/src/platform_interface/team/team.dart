// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:convert';
import 'package:universal_io/io.dart';

import 'package:json_annotation/json_annotation.dart';
import 'package:nim_core_platform_interface/nim_core_platform_interface.dart';

part 'team.g.dart';

@JsonSerializable()
class NIMTeam {
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

  /// 获取群组的创建时间，单位为毫秒
  final num createTime;

  /// 获取自己是否在这个群里
  final bool? isMyTeam;

  /// 设置群组扩展配置。 通常情况下，该配置应是一个json或xml串，以增强扩展能力
  final String? extension;

  /// 获取服务器设置的扩展配置。 和getExtension()一样，云信不解释该字段，仅负责存储和透传。 不同于getExtension(), 该配置只能通过服务器接口设置，对客户端是只读的。
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

  NIMTeam({
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

  factory NIMTeam.fromMap(Map<String, dynamic> map) => _$NIMTeamFromJson(map);

  Map<String, dynamic> toMap() => _$NIMTeamToJson(this);
}

enum NIMVerifyTypeEnum {
  /// 可以自由加入，无需管理员验证
  free,

  /// 需要先申请，管理员统一方可加入
  apply,

  ///私有群，不接受申请，仅能通过邀请方式入群
  private,
}

enum NIMTeamMessageNotifyTypeEnum {
  ///群全部消息提醒
  all,

  /// 管理员消息提醒
  manager,

  /// 群所有消息不提醒
  mute,
}

const NIMTeamMessageNotifyTypeEnumEnumMap = {
  NIMTeamMessageNotifyTypeEnum.all: 'all',
  NIMTeamMessageNotifyTypeEnum.manager: 'manager',
  NIMTeamMessageNotifyTypeEnum.mute: 'mute',
};

enum NIMTeamInviteModeEnum {
  ///只有管理员可以邀请其他人入群（默认）
  manager,

  /// 所有人都可以邀请其他人入群
  all,
}

enum NIMTeamBeInviteModeEnum {
  ///需要被邀请方同意（默认）
  needAuth,

  /// 不需要被邀请方同意
  noAuth,
}

enum NIMTeamAllMuteModeEnum {
  /// 取消全员禁言
  cancel,

  ///全员禁言，不包括管理员
  muteNormal,

  /// 全员禁言，包括群组和管理员，超大群不支持
  /// 该字段已废弃，效果同[muteNormal]
  muteAll,
}

enum NIMTeamExtensionUpdateModeEnum {
  /// 只有管理员/群主可以修改（默认）
  manager,

  /// 所有人可以修改
  all,
}

enum NIMTeamUpdateModeEnum {
  /// 只有管理员/群主可以修改（默认）
  manager,

  /// 所有人可以修改
  all,
}

/// TeamTypeEnum属性	说明
/// [advanced]	高级群，有完善的权限管理功能
/// [normal]	讨论组，仅具有基本的权限管理功能，所有人都能加入，
/// [superTeam]	超大群
/// 仅群主可以踢人

enum NIMTeamTypeEnum {
  advanced,
  normal,
  superTeam,
}

///TeamFieldEnum属性	说明	数据类型
/// [announcement]	群公告
/// [beInviteMode]	群被邀请模式：被邀请人的同意方式
/// [extension]	群扩展字段（客户端自定义信息）
/// [icon]	群头像
/// [introduce]	群简介
/// [inviteMode]	群邀请模式：谁可以邀请他人入群
/// [maxMemberCount]	指定创建群组的最大群成员数量 ，MaxMemberCount不能超过应用级配置的最大人数
/// [name]	群名
/// [teamExtensionUpdateMode]	群资料扩展字段修改模式：谁可以修改群自定义属性(扩展字段)
/// [teamUpdateMode]	群资料修改模式：谁可以修改群资料
/// [verifyType]	申请加入群组的验证模式

enum NIMTeamFieldEnum {
  undefined,
  announcement,
  beInviteMode,
  extension,
  serverExtension,
  icon,
  introduce,
  inviteMode,
  maxMemberCount,
  name,
  teamExtensionUpdateMode,
  teamUpdateMode,
  verifyType,
}

const NIMTeamFieldEnumEnumMap = {
  NIMTeamFieldEnum.undefined: 'undefined',
  NIMTeamFieldEnum.announcement: 'announcement',
  NIMTeamFieldEnum.beInviteMode: 'beInviteMode',
  NIMTeamFieldEnum.extension: 'extension',
  NIMTeamFieldEnum.serverExtension: 'serverExtension',
  NIMTeamFieldEnum.icon: 'icon',
  NIMTeamFieldEnum.introduce: 'introduce',
  NIMTeamFieldEnum.inviteMode: 'inviteMode',
  NIMTeamFieldEnum.maxMemberCount: 'maxMemberCount',
  NIMTeamFieldEnum.name: 'name',
  NIMTeamFieldEnum.teamExtensionUpdateMode: 'teamExtensionUpdateMode',
  NIMTeamFieldEnum.teamUpdateMode: 'teamUpdateMode',
  NIMTeamFieldEnum.verifyType: 'verifyType',
};

class NIMTeamUpdateFieldRequest {
  final _updatedFields = <String, dynamic>{};

  Map<String, dynamic> toMap() {
    return _updatedFields.isEmpty
        ? {}
        : {
            'requestList': _updatedFields.keys.toList(),
            ..._updatedFields,
          };
  }

  setAnnouncement(String? announcement) {
    _updatedFields["announcement"] = announcement;
  }

  setBeInviteMode(NIMTeamBeInviteModeEnum beInviteMode) {
    _updatedFields["beInviteMode"] = beInviteMode.index;
  }

  setExtension(String? extension) {
    _updatedFields["extension"] = extension;
  }

  setIcon(String? icon) {
    _updatedFields["icon"] = icon;
  }

  setIntroduce(String? introduce) {
    _updatedFields['introduce'] = introduce;
  }

  setInviteMode(NIMTeamInviteModeEnum inviteMode) {
    _updatedFields['inviteMode'] = inviteMode.index;
  }

  setMaxMemberCount(int maxMemberCount) {
    _updatedFields['maxMemberCount'] = maxMemberCount;
  }

  setName(String? name) {
    _updatedFields['name'] = name;
  }

  setTeamExtensionUpdateMode(
      NIMTeamExtensionUpdateModeEnum teamExtensionUpdateMode) {
    _updatedFields['teamExtensionUpdateMode'] = teamExtensionUpdateMode.index;
  }

  /// superTeam 中iOS暂不支持
  setTeamUpdateMode(NIMTeamUpdateModeEnum teamUpdateMode) {
    _updatedFields['teamUpdateMode'] = teamUpdateMode.index;
  }

  setVerifyType(NIMVerifyTypeEnum verifyType) {
    _updatedFields['verifyType'] = verifyType.index;
  }
}

String? _parseExtension(dynamic extension) {
  if (extension is Map && Platform.isAndroid && extension.containsKey('ext')) {
    return extension['ext'] as String?;
  } else if (extension is String) {
    return extension;
  } else {
    try {
      return jsonEncode(extension);
    } catch (e) {
      return null;
    }
  }
}

/// 群组通知消息附件
@JsonSerializable()
class NIMTeamNotificationAttachment extends NIMMessageAttachment {
  /// 通知类型，参考 [NIMTeamNotificationTypes]
  final int type;

  /// 扩展字段
  @JsonKey(fromJson: _parseExtension)
  final String? extension;

  NIMTeamNotificationAttachment({required this.type, this.extension});

  factory NIMTeamNotificationAttachment.createTeamNotificationAttachment(
      Map<String, dynamic> map) {
    final int type = map['type'] as int;
    switch (type) {
      case NIMTeamNotificationTypes.acceptInvite:
      case NIMTeamNotificationTypes.inviteMember:
      case NIMTeamNotificationTypes.addTeamManager:
      case NIMTeamNotificationTypes.kickMember:
      case NIMTeamNotificationTypes.transferOwner:
      case NIMTeamNotificationTypes.passTeamApply:
      case NIMTeamNotificationTypes.removeTeamManager:
      case NIMSuperTeamNotificationTypes.invite:
      case NIMSuperTeamNotificationTypes.changeOwner:
      case NIMSuperTeamNotificationTypes.addManager:
      case NIMSuperTeamNotificationTypes.removeManager:
      case NIMSuperTeamNotificationTypes.applyPass:
      case NIMSuperTeamNotificationTypes.inviteAccept:
      case NIMSuperTeamNotificationTypes.kick:
        return NIMMemberChangeAttachment.fromMap(map);
      case NIMTeamNotificationTypes.dismissTeam:
      case NIMSuperTeamNotificationTypes.dismiss:
        return NIMDismissAttachment.fromMap(map);
      case NIMTeamNotificationTypes.leaveTeam:
      case NIMSuperTeamNotificationTypes.leave:
        return NIMLeaveTeamAttachment.fromMap(map);
      case NIMTeamNotificationTypes.muteTeamMember:
      case NIMSuperTeamNotificationTypes.muteList:
        return NIMMuteMemberAttachment.fromMap(map);
      case NIMTeamNotificationTypes.updateTeam:
      case NIMSuperTeamNotificationTypes.updateInfo:
        return NIMUpdateTeamAttachment.fromMap(map);
      default:
        return NIMTeamNotificationAttachment.fromMap(map);
    }
  }

  factory NIMTeamNotificationAttachment.fromMap(Map<String, dynamic> map) =>
      _$NIMTeamNotificationAttachmentFromJson(map);

  @override
  Map<String, dynamic> toMap() => _$NIMTeamNotificationAttachmentToJson(this);
}

@JsonSerializable()
class NIMMemberChangeAttachment extends NIMTeamNotificationAttachment {
  final List<String>? targets;

  NIMMemberChangeAttachment({
    required int type,
    this.targets,
    String? extension,
  }) : super(
          type: type,
          extension: extension,
        );

  factory NIMMemberChangeAttachment.fromMap(Map<String, dynamic> map) =>
      _$NIMMemberChangeAttachmentFromJson(map);

  @override
  Map<String, dynamic> toMap() => _$NIMMemberChangeAttachmentToJson(this);
}

@JsonSerializable()
class NIMDismissAttachment extends NIMTeamNotificationAttachment {
  NIMDismissAttachment({
    required int type,
    String? extension,
  }) : super(
          type: type,
          extension: extension,
        );

  factory NIMDismissAttachment.fromMap(Map<String, dynamic> map) =>
      _$NIMDismissAttachmentFromJson(map);

  @override
  Map<String, dynamic> toMap() => _$NIMDismissAttachmentToJson(this);
}

@JsonSerializable()
class NIMLeaveTeamAttachment extends NIMTeamNotificationAttachment {
  NIMLeaveTeamAttachment({
    required int type,
    String? extension,
  }) : super(
          type: type,
          extension: extension,
        );

  factory NIMLeaveTeamAttachment.fromMap(Map<String, dynamic> map) =>
      _$NIMLeaveTeamAttachmentFromJson(map);

  @override
  Map<String, dynamic> toMap() => _$NIMLeaveTeamAttachmentToJson(this);
}

@JsonSerializable()
class NIMMuteMemberAttachment extends NIMTeamNotificationAttachment {
  /// 是否静音
  @JsonKey(defaultValue: false)
  final bool mute;

  /// 被操作的成员帐号列表
  final List<String>? targets;

  NIMMuteMemberAttachment({
    required this.mute,
    required int type,
    this.targets,
    String? extension,
  }) : super(
          type: type,
          extension: extension,
        );

  factory NIMMuteMemberAttachment.fromMap(Map<String, dynamic> map) =>
      _$NIMMuteMemberAttachmentFromJson(map);

  @override
  Map<String, dynamic> toMap() => _$NIMMuteMemberAttachmentToJson(this);
}

/// 群更新字段
@JsonSerializable()
class NIMTeamUpdatedFields {
  final String? updatedAnnouncement;
  final NIMTeamBeInviteModeEnum? updatedBeInviteMode;
  final String? updatedExtension;
  final String? updatedServerExtension;
  final String? updatedIcon;
  final String? updatedIntroduce;
  final NIMTeamInviteModeEnum? updatedInviteMode;
  final int? updatedMaxMemberCount;
  final String? updatedName;
  final NIMTeamExtensionUpdateModeEnum? updatedExtensionUpdateMode;
  final NIMTeamUpdateModeEnum? updatedUpdateMode;
  final NIMVerifyTypeEnum? updatedVerifyType;
  final NIMTeamAllMuteModeEnum? updatedAllMuteMode;

  NIMTeamUpdatedFields({
    this.updatedAnnouncement,
    this.updatedBeInviteMode,
    this.updatedExtension,
    this.updatedServerExtension,
    this.updatedIcon,
    this.updatedIntroduce,
    this.updatedInviteMode,
    this.updatedMaxMemberCount,
    this.updatedName,
    this.updatedExtensionUpdateMode,
    this.updatedUpdateMode,
    this.updatedVerifyType,
    this.updatedAllMuteMode,
  });

  factory NIMTeamUpdatedFields.fromMap(Map map) =>
      _$NIMTeamUpdatedFieldsFromJson(map.cast());

  Map<String, dynamic> toMap() => _$NIMTeamUpdatedFieldsToJson(this);
}

NIMTeamUpdatedFields _updatedFieldsFromJson(Map? map) {
  if (map != null) {
    return NIMTeamUpdatedFields.fromMap(map);
  }
  return NIMTeamUpdatedFields();
}

/// 群组更新消息附件
@JsonSerializable()
class NIMUpdateTeamAttachment extends NIMTeamNotificationAttachment {
  @JsonKey(fromJson: _updatedFieldsFromJson)
  final NIMTeamUpdatedFields updatedFields;

  NIMUpdateTeamAttachment({
    required int type,
    String? extension,
    required this.updatedFields,
  }) : super(
          type: type,
          extension: extension,
        );

  factory NIMUpdateTeamAttachment.fromMap(Map map) =>
      _$NIMUpdateTeamAttachmentFromJson(map.cast());

  @override
  Map<String, dynamic> toMap() => _$NIMUpdateTeamAttachmentToJson(this);
}

/// 聊天室通知类型
class NIMTeamNotificationTypes {
  ///TEAM：邀请群成员，用于讨论组中，讨论组可直接拉人入群

  static const inviteMember = 0;

  ///TEAM：移除群成员

  static const kickMember = 1;

  ///TEAM：有成员离开群

  static const leaveTeam = 2;

  ///TEAM：群资料更新

  static const updateTeam = 3;

  ///TEAM：群被解散

  static const dismissTeam = 4;

  ///TEAM：管理员通过用户入群申请

  static const passTeamApply = 5;

  ///TEAM：群组拥有者权限转移通知

  static const transferOwner = 6;

  ///TEAM：新增管理员通知

  static const addTeamManager = 7;

  ///TEAM：撤销管理员通知

  static const removeTeamManager = 8;

  ///TEAM：用户接受入群邀请

  static const acceptInvite = 9;

  ///TEAM：群成员禁言/解禁

  static const muteTeamMember = 10;
}
