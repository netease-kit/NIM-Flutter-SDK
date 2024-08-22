// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import '../message/v2_message_enum.dart';
import 'team_enum.dart';
import 'team_member.dart';
import 'team.dart';
import 'package:json_annotation/json_annotation.dart';

part 'team_param.g.dart';

/// 创建群组参数
@JsonSerializable()
class NIMCreateTeamParams {
  /// 群组名称
  String name;

  /// 群组类型
  NIMTeamType teamType;

  /// 群组人数上限
  int? memberLimit;

  /// 群组介绍
  String? intro;

  /// 群组公告
  String? announcement;

  /// 群组头像
  String? avatar;

  /// 服务端扩展字段
  String? serverExtension;

  /// 申请入群模式
  NIMTeamJoinMode? joinMode;

  /// 被邀请人同意入群模式
  NIMTeamAgreeMode? agreeMode;

  /// 邀请入群模式
  NIMTeamInviteMode? inviteMode;

  /// 群组资料修改模式
  NIMTeamUpdateInfoMode? updateInfoMode;

  /// 群组扩展字段修改模式
  NIMTeamUpdateExtensionMode? updateExtensionMode;

  /// 群组禁言模式
  NIMTeamChatBannedMode? chatBannedMode;

  NIMCreateTeamParams({
    required this.name,
    required this.teamType,
    this.memberLimit,
    this.intro,
    this.announcement,
    this.avatar,
    this.serverExtension,
    this.joinMode,
    this.agreeMode,
    this.inviteMode,
    this.updateInfoMode,
    this.updateExtensionMode,
    this.chatBannedMode,
  });

  factory NIMCreateTeamParams.fromJson(Map<String, dynamic> map) =>
      _$NIMCreateTeamParamsFromJson(map);

  Map<String, dynamic> toJson() => _$NIMCreateTeamParamsToJson(this);
}

/// 修改群组信息参数
@JsonSerializable()
class NIMUpdateTeamInfoParams {
  /// 群组名称
  String? name;

  /// 群组人数上限（当输出时，如果未被更新，此时值为0）
  int? memberLimit;

  /// 群组介绍
  String? intro;

  /// 群组公告
  String? announcement;

  /// 群组头像
  String? avatar;

  /// 服务端扩展字段
  String? serverExtension;

  /// 申请入群模式（当输出时，如果未被更新，此时值为-1）
  NIMTeamJoinMode? joinMode;

  /// 被邀请人同意入群模式（当输出时，如果未被更新，此时值为-1）
  NIMTeamAgreeMode? agreeMode;

  /// 邀请入群模式（当输出时，如果未被更新，此时值为-1）
  NIMTeamInviteMode? inviteMode;

  /// 群组资料修改模式（当输出时，如果未被更新，此时值为-1）
  NIMTeamUpdateInfoMode? updateInfoMode;

  /// 群组扩展字段修改模式（当输出时，如果未被更新，此时值为-1）
  NIMTeamUpdateExtensionMode? updateExtensionMode;

  NIMUpdateTeamInfoParams({
    this.name,
    this.memberLimit,
    this.intro,
    this.announcement,
    this.avatar,
    this.serverExtension,
    this.joinMode,
    this.agreeMode,
    this.inviteMode,
    this.updateInfoMode,
    this.updateExtensionMode,
  });

  factory NIMUpdateTeamInfoParams.fromJson(Map<String, dynamic> map) =>
      _$NIMUpdateTeamInfoParamsFromJson(map);

  Map<String, dynamic> toJson() => _$NIMUpdateTeamInfoParamsToJson(this);
}

/// 群信息更新通知
@JsonSerializable()
class NIMUpdatedTeamInfo {
  /// 群组名称，nil表示未更新
  String? name;

  /// 群组人数上限，0表示未更新
  int? memberLimit;

  /// 群组介绍，nil表示未更新
  String? intro;

  /// 群组公告，nil表示未更新
  String? announcement;

  /// 群组头像，nil表示未更新
  String? avatar;

  /// 服务端扩展字段，nil表示未更新
  String? serverExtension;

  /// 申请入群模式，-1表示未更新
  NIMTeamJoinMode? joinMode;

  /// 被邀请人同意入群模式，-1表示未更新
  NIMTeamAgreeMode? agreeMode;

  /// 邀请入群模式，-1表示未更新
  NIMTeamInviteMode? inviteMode;

  /// 群组资料修改模式，-1表示未更新
  NIMTeamUpdateInfoMode? updateInfoMode;

  /// 群组扩展字段修改模式，-1表示未更新
  NIMTeamUpdateExtensionMode? updateExtensionMode;

  /// 群组禁言状态，-1表示未更新
  int? chatBannedMode;

  NIMUpdatedTeamInfo({
    this.name,
    this.memberLimit,
    this.intro,
    this.announcement,
    this.avatar,
    this.serverExtension,
    this.joinMode,
    this.agreeMode,
    this.inviteMode,
    this.updateInfoMode,
    this.updateExtensionMode,
    this.chatBannedMode,
  });

  factory NIMUpdatedTeamInfo.fromJson(Map<String, dynamic> map) =>
      _$NIMUpdatedTeamInfoFromJson(map);

  Map<String, dynamic> toJson() => _$NIMUpdatedTeamInfoToJson(this);
}

/// 修改自己的群成员信息参数
@JsonSerializable()
class NIMUpdateSelfMemberInfoParams {
  /// 群组昵称
  String? teamNick;

  /// 服务端扩展字段
  String? serverExtension;

  NIMUpdateSelfMemberInfoParams({this.teamNick, this.serverExtension});

  factory NIMUpdateSelfMemberInfoParams.fromJson(Map<String, dynamic> map) =>
      _$NIMUpdateSelfMemberInfoParamsFromJson(map);

  Map<String, dynamic> toJson() => _$NIMUpdateSelfMemberInfoParamsToJson(this);
}

/// 群组成员查询参数
@JsonSerializable()
class NIMTeamMemberQueryOption {
  /// 查询成员类型
  NIMTeamMemberRoleQueryType roleQueryType;

  /// 是否只返回聊天禁言成员列表，YES true： 只返回聊天禁言成员列表，NO 全部成员列表
  bool? onlyChatBanned;

  /// 查询方向
  NIMQueryDirection? direction;

  /// 分页偏移，首次传""，后续拉取采用上一次返回的nextToken
  String? nextToken;

  /// 分页拉取数量，不建议超过100
  int? limit;

  NIMTeamMemberQueryOption({
    required this.roleQueryType,
    this.onlyChatBanned,
    this.direction,
    this.nextToken,
    this.limit,
  });

  factory NIMTeamMemberQueryOption.fromJson(Map<String, dynamic> map) =>
      _$NIMTeamMemberQueryOptionFromJson(map);

  Map<String, dynamic> toJson() => _$NIMTeamMemberQueryOptionToJson(this);
}

/// 入群操作信息
@JsonSerializable()
class NIMTeamJoinActionInfo {
  /// 入群操作类型
  NIMTeamJoinActionType actionType;

  /// 群组id
  String teamId;

  /// 群组类型
  NIMTeamType teamType;

  /// 操作账号id
  String? operatorAccountId;

  /// 附言
  String? postscript;

  /// 时间戳
  int? timestamp;

  /// 操作状态
  NIMTeamJoinActionStatus actionStatus;

  NIMTeamJoinActionInfo({
    required this.actionType,
    required this.teamId,
    required this.teamType,
    this.operatorAccountId,
    this.postscript,
    this.timestamp,
    required this.actionStatus,
  });

  factory NIMTeamJoinActionInfo.fromJson(Map<String, dynamic> map) =>
      _$NIMTeamJoinActionInfoFromJson(map);

  Map<String, dynamic> toJson() => _$NIMTeamJoinActionInfoToJson(this);
}

/// 群加入相关信息查询参数
@JsonSerializable()
class NIMTeamJoinActionInfoQueryOption {
  /// 入群操作类型列表，输入类型为NIMTeamJoinActionType
  List<int>? types;

  /// 查询偏移，首次传0， 下一次传上一次返回的offset，默认0
  int? offset;

  /// 查询数量，默认50
  int? limit;

  /// 入群操作状态列表，输入类型为NIMTeamJoinActionStatus
  List<int>? status;

  NIMTeamJoinActionInfoQueryOption({
    this.types,
    this.offset,
    this.limit = 50,
    this.status,
  });

  factory NIMTeamJoinActionInfoQueryOption.fromJson(Map<String, dynamic> map) =>
      _$NIMTeamJoinActionInfoQueryOptionFromJson(map);

  Map<String, dynamic> toJson() =>
      _$NIMTeamJoinActionInfoQueryOptionToJson(this);
}

/// 群成员搜索参数
@JsonSerializable()
class NIMTeamMemberSearchOption {
  /// 搜索关键词，不为空
  String keyword;

  /// 群组类型
  NIMTeamType teamType;

  /// 群组id， 如果不传则检索所有群， 如果需要检索特定的群， 则需要同时传入teamId+teamType
  String? teamId;

  /// 起始位置，首次传@""， 后续传上次返回的pageToken
  String nextToken;

  /// NIM_SORT_ORDER_DESC 按joinTime降序，NIM_SORT_ORDER_ASC 按joinTime升序
  NIMSortOrder? order;

  /// 查询成员的个数。 默认10。
  int? limit;

  /// 初始传入的pageToken
  static late String initPageToken;

  NIMTeamMemberSearchOption({
    required this.keyword,
    required this.teamType,
    this.teamId,
    required this.nextToken,
    this.order,
    this.limit,
  });

  factory NIMTeamMemberSearchOption.fromJson(Map<String, dynamic> map) =>
      _$NIMTeamMemberSearchOptionFromJson(map);

  Map<String, dynamic> toJson() => _$NIMTeamMemberSearchOptionToJson(this);
}
