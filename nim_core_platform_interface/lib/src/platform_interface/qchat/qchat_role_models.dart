// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:json_annotation/json_annotation.dart';
import 'package:nim_core_platform_interface/nim_core_platform_interface.dart';

part 'qchat_role_models.g.dart';

@JsonSerializable(explicitToJson: true)
class QChatCreateServerRoleParam extends QChatAntiSpamConfigParam {
  /// 服务器id
  final int serverId;

  /// 身份组名称
  final String name;

  /// 身份组类型，详细见[QChatRoleType]
  final QChatRoleType type;

  /// 身份组图片url
  String? icon;

  /// 身份组扩展字段
  String? extension;

  /// 身份组优先级，everyone最低为0，数字越小优先级越高
  int? priority;

  QChatCreateServerRoleParam(this.serverId, this.name, this.type,
      {this.icon, this.extension, this.priority});

  factory QChatCreateServerRoleParam.fromJson(Map<String, dynamic> json) =>
      _$QChatCreateServerRoleParamFromJson(json);

  Map<String, dynamic> toJson() => _$QChatCreateServerRoleParamToJson(this);
}

enum QChatRoleType {
  /// everyone身份组，不允许主动创建EVERYONE类型的身份组，服务器自动创建
  /// 所有服务器成员默认属于everyone身份组，不能查询（查询结果为空）、添加、删除成员
  /// 只能修改权限属性，不能修改其它属性
  everyone,

  /// 自定义身份组
  custom
}

@JsonSerializable(explicitToJson: true)
class QChatCreateServerRoleResult {
  /// Server身份组
  @JsonKey(fromJson: _serverRoleFromJsonNullable)
  final QChatServerRole? role;

  QChatCreateServerRoleResult({this.role});

  factory QChatCreateServerRoleResult.fromJson(Map<String, dynamic> json) =>
      _$QChatCreateServerRoleResultFromJson(json);

  Map<String, dynamic> toJson() => _$QChatCreateServerRoleResultToJson(this);

  @override
  String toString() {
    return 'QChatCreateServerRoleResult{role: $role}';
  }
}

QChatServerRole? _serverRoleFromJsonNullable(Map? map) {
  if (map == null) {
    return null;
  }
  return QChatServerRole.fromJson(map.cast<String, dynamic>());
}

List<QChatServerRole>? serverRoleListFromJsonNullable(List<dynamic>? dataList) {
  return dataList
      ?.map((e) => QChatServerRole.fromJson((e as Map).cast<String, dynamic>()))
      .toList();
}

@JsonSerializable(explicitToJson: true)
class QChatServerRole {
  /// 服务器id
  int? serverId = 0;

  /// 身份组id
  int? roleId = 0;

  /// 身份组名称
  String? name;

  /// 身份组图片url
  String? icon;

  /// 身份组扩展字段
  String? extension;

  /// 表示哪些资源的权限
  @JsonKey(fromJson: resourceAuthsFromJsonNullable)
  Map<QChatRoleResource, QChatRoleOption>? resourceAuths;

  /// 身份组类型，详细见[QChatRoleType]
  QChatRoleType? type;

  /// 该身份组的成员数量，everyone身份组数量为-1
  int? memberCount = 0;

  /// 身份组优先级，everyone最低为0，数字越小优先级越高
  int? priority = 0;

  /// 创建时间
  int? createTime = 0;

  /// 更新时间
  int? updateTime = 0;

  QChatServerRole();

  factory QChatServerRole.fromJson(Map<String, dynamic> json) =>
      _$QChatServerRoleFromJson(json);

  Map<String, dynamic> toJson() => _$QChatServerRoleToJson(this);

  @override
  String toString() {
    return 'QChatServerRole{serverId: $serverId, roleId: $roleId, name: $name, icon: $icon, extension: $extension, resourceAuths: $resourceAuths, type: $type, memberCount: $memberCount, priority: $priority, createTime: $createTime, updateTime: $updateTime}';
  }
}

enum QChatRoleResource {
  /// 管理服务器：修改服务器,仅server有
  manageServer,

  /// 管理频道，server和channel都有
  manageChannel,

  /// 管理身份组的权限，server和channel都有
  manageRole,

  /// 发送消息，server和channel都有
  sendMsg,

  /// 修改自己在该server的服务器成员信息，仅server有
  accountInfoSelf,

  /// 邀请他人进入server的，仅server有
  inviteServer,

  /// 踢除他人的权限，仅server有
  kickServer,

  /// 修改他人在该server的服务器成员信息，仅server有
  accountInfoOther,

  /// 撤回他人消息的权限，server和channel都有
  recallMsg,

  /// 删除他人消息的权限，server和channel都有
  deleteMsg,

  /// @ 他人的权限，server和channel都有
  remindOther,

  /// @ everyone，server和channel都有
  remindEveryone,

  /// 管理黑白名单的权限，server和channel都有
  manageBlackWhiteList,

  /// 封禁他人的权限，仅server有，允许成员永久封禁其他成员访问此服务器
  banServerMember,

  /// RTC频道：连接的权限
  rtcChannelConnect,

  /// RTC频道：断开他人连接的权限
  rtcChannelDisconnectOther,

  /// RTC频道：开启麦克风的权限
  rtcChannelOpenMicrophone,

  /// RTC频道：开启摄像头的权限
  rtcChannelOpenCamera,

  /// RTC频道：开启/关闭他人麦克风的权限
  rtcChannelOpenCloseOtherMicrophone,

  /// RTC频道：开启/关闭他人摄像头的权限
  rtcChannelOpenCloseOtherCamera,

  /// RTC频道：开启/关闭全员麦克风的权限
  rtcChannelOpenCloseEveryoneMicrophone,

  /// RTC频道：开启/关闭全员摄像头的权限
  rtcChannelOpenCloseEveryoneCamera,

  /// RTC频道：打开自己屏幕共享的权限
  rtcChannelOpenScreenShare,

  /// RTC频道：关闭他人屏幕共享的权限
  rtcChannelCloseOtherScreenShare,

  /// 服务器申请处理权限
  serverApplyHandle,

  /// 申请邀请历史查看权限，有这个权限才可以查询server级别的申请/邀请记录
  inviteApplyHistoryQuery,

  /// @身份组的权限，server和channel都有
  mentionedRole
}

extension QChatRoleResourceExtension on QChatRoleResource {
  QChatRoleResourceValueInfo valueInfo() {
    QChatRoleResourceValueInfo result;
    switch (this) {
      case QChatRoleResource.manageServer:
        result = QChatRoleResourceValueInfo(1, 1, 'manageServer');
        break;
      case QChatRoleResource.manageChannel:
        result = QChatRoleResourceValueInfo(2, 0, 'manageChannel');
        break;
      case QChatRoleResource.manageRole:
        result = QChatRoleResourceValueInfo(3, 0, 'manageRole');
        break;
      case QChatRoleResource.sendMsg:
        result = QChatRoleResourceValueInfo(4, 0, 'sendMsg');
        break;
      case QChatRoleResource.accountInfoSelf:
        result = QChatRoleResourceValueInfo(5, 1, 'accountInfoSelf');
        break;
      case QChatRoleResource.inviteServer:
        result = QChatRoleResourceValueInfo(6, 1, 'inviteServer');
        break;
      case QChatRoleResource.kickServer:
        result = QChatRoleResourceValueInfo(7, 1, 'kickServer');
        break;
      case QChatRoleResource.accountInfoOther:
        result = QChatRoleResourceValueInfo(8, 1, 'accountInfoOther');
        break;
      case QChatRoleResource.recallMsg:
        result = QChatRoleResourceValueInfo(9, 0, 'recallMsg');
        break;
      case QChatRoleResource.deleteMsg:
        result = QChatRoleResourceValueInfo(10, 0, 'deleteMsg');
        break;
      case QChatRoleResource.remindOther:
        result = QChatRoleResourceValueInfo(11, 0, 'remindOther');
        break;
      case QChatRoleResource.remindEveryone:
        result = QChatRoleResourceValueInfo(12, 0, 'remindEveryone');
        break;
      case QChatRoleResource.manageBlackWhiteList:
        result = QChatRoleResourceValueInfo(13, 0, 'manageBlackWhiteList');
        break;
      case QChatRoleResource.banServerMember:
        result = QChatRoleResourceValueInfo(14, 1, 'banServerMember');
        break;
      case QChatRoleResource.rtcChannelConnect:
        result = QChatRoleResourceValueInfo(15, 0, 'rtcChannelConnect');
        break;
      case QChatRoleResource.rtcChannelDisconnectOther:
        result = QChatRoleResourceValueInfo(16, 0, 'rtcChannelDisconnectOther');
        break;
      case QChatRoleResource.rtcChannelOpenMicrophone:
        result = QChatRoleResourceValueInfo(17, 0, 'rtcChannelOpenMicrophone');
        break;
      case QChatRoleResource.rtcChannelOpenCamera:
        result = QChatRoleResourceValueInfo(18, 0, 'rtcChannelOpenCamera');
        break;
      case QChatRoleResource.rtcChannelOpenCloseOtherMicrophone:
        result = QChatRoleResourceValueInfo(
            19, 0, 'rtcChannelOpenCloseOtherMicrophone');
        break;
      case QChatRoleResource.rtcChannelOpenCloseOtherCamera:
        result =
            QChatRoleResourceValueInfo(20, 0, 'rtcChannelOpenCloseOtherCamera');
        break;
      case QChatRoleResource.rtcChannelOpenCloseEveryoneMicrophone:
        result = QChatRoleResourceValueInfo(
            21, 0, 'rtcChannelOpenCloseEveryoneMicrophone');
        break;
      case QChatRoleResource.rtcChannelOpenCloseEveryoneCamera:
        result = QChatRoleResourceValueInfo(
            22, 0, 'rtcChannelOpenCloseEveryoneCamera');
        break;
      case QChatRoleResource.rtcChannelOpenScreenShare:
        result = QChatRoleResourceValueInfo(23, 0, 'rtcChannelOpenScreenShare');
        break;
      case QChatRoleResource.rtcChannelCloseOtherScreenShare:
        result = QChatRoleResourceValueInfo(
            24, 0, 'rtcChannelCloseOtherScreenShare');
        break;
      case QChatRoleResource.serverApplyHandle:
        result = QChatRoleResourceValueInfo(25, 1, 'serverApplyHandle');
        break;
      case QChatRoleResource.inviteApplyHistoryQuery:
        result = QChatRoleResourceValueInfo(26, 1, 'inviteApplyHistoryQuery');
        break;
      case QChatRoleResource.mentionedRole:
        result = QChatRoleResourceValueInfo(27, 0, "mentionedRole");
        break;
    }
    return result;
  }

  /// 是否是仅Server才拥有的权限
  bool isOnlyServerPermission() {
    return valueInfo().type == 1;
  }

  /// 是否是仅Channel才拥有的权限
  bool isOnlyChannelPermission() {
    return valueInfo().type == 2;
  }

  /// 是否是Server和Channel都拥有的权限
  bool isAllPermission() {
    return valueInfo().type == 3;
  }
}

class QChatRoleResourceValueInfo {
  final int value;
  final int type;
  final String name;

  QChatRoleResourceValueInfo(this.value, this.type, this.name);

  @override
  String toString() {
    return 'QChatRoleResourceValueInfo{value: $value, type: $type, name: $name}';
  }
}

/// 身份组权限选项
enum QChatRoleOption {
  /// 有权限
  allow,

  /// 无权限
  deny,

  /// 继承
  inherit
}

@JsonSerializable()
class QChatDeleteServerRoleParam {
  /// 服务器id，必填
  final int serverId;

  /// 身份组id，必填
  final int roleId;

  QChatDeleteServerRoleParam(this.serverId, this.roleId);

  factory QChatDeleteServerRoleParam.fromJson(Map<String, dynamic> json) =>
      _$QChatDeleteServerRoleParamFromJson(json);

  Map<String, dynamic> toJson() => _$QChatDeleteServerRoleParamToJson(this);
}

@JsonSerializable(explicitToJson: true)
class QChatUpdateServerRoleParam extends QChatAntiSpamConfigParam {
  /// 服务器id，必填
  final int serverId;

  /// 身份组id，必填
  final int roleId;

  /// 身份组名称
  String? name;

  /// 身份组图片url
  String? icon;

  /// 身份组扩展字段
  String? ext;

  /// 要操作的权限列表，最多操作50个
  Map<QChatRoleResource, QChatRoleOption>? resourceAuths;

  /// 优先级
  int? priority;

  QChatUpdateServerRoleParam(this.serverId, this.roleId,
      {this.name, this.icon, this.ext, this.resourceAuths, this.priority});

  factory QChatUpdateServerRoleParam.fromJson(Map<String, dynamic> json) =>
      _$QChatUpdateServerRoleParamFromJson(json);

  Map<String, dynamic> toJson() => _$QChatUpdateServerRoleParamToJson(this);
}

@JsonSerializable(explicitToJson: true)
class QChatUpdateServerRoleResult {
  /// 频道身份组
  @JsonKey(fromJson: _serverRoleFromJsonNullable)
  final QChatServerRole? role;

  QChatUpdateServerRoleResult(this.role);

  factory QChatUpdateServerRoleResult.fromJson(Map<String, dynamic> json) =>
      _$QChatUpdateServerRoleResultFromJson(json);

  Map<String, dynamic> toJson() => _$QChatUpdateServerRoleResultToJson(this);

  @override
  String toString() {
    return 'QChatUpdateServerRoleResult{role: $role}';
  }
}

@JsonSerializable()
class QChatUpdateServerRolePrioritiesParam {
  ///  服务器id，必填
  final int serverId;

  final Map<int, int> roleIdPriorityMap;

  QChatUpdateServerRolePrioritiesParam(this.serverId, this.roleIdPriorityMap);

  factory QChatUpdateServerRolePrioritiesParam.fromJson(
          Map<String, dynamic> json) =>
      _$QChatUpdateServerRolePrioritiesParamFromJson(json);

  Map<String, dynamic> toJson() =>
      _$QChatUpdateServerRolePrioritiesParamToJson(this);
}

@JsonSerializable()
class QChatUpdateServerRolePrioritiesResult {
  /// 服务器身份组Id和服务器身份组权限构成的Map
  @JsonKey(fromJson: _roleIdPriorityMapFromJsonNullable, defaultValue: {})
  final Map<int, int> roleIdPriorityMap = {};

  QChatUpdateServerRolePrioritiesResult(Map<int, int>? roleIdPriorityMap) {
    if (roleIdPriorityMap != null) {
      this.roleIdPriorityMap.addAll(roleIdPriorityMap);
    }
  }

  factory QChatUpdateServerRolePrioritiesResult.fromJson(
          Map<String, dynamic> json) =>
      _$QChatUpdateServerRolePrioritiesResultFromJson(json);

  Map<String, dynamic> toJson() =>
      _$QChatUpdateServerRolePrioritiesResultToJson(this);

  @override
  String toString() {
    return 'QChatUpdateServerRolePrioritiesResult{roleIdPriorityMap: $roleIdPriorityMap}';
  }
}

Map<int, int>? _roleIdPriorityMapFromJsonNullable(Map? map) {
  return map
      ?.cast<dynamic, dynamic>()
      .map((key, value) => MapEntry(int.parse(key.toString()), value as int));
}

@JsonSerializable(explicitToJson: true)
class QChatGetServerRolesParam {
  /// 服务器Id
  final int serverId;

  /// 查询锚点优先级，填0从最高优先级开始查询
  final int priority;

  /// 查询数量限制
  final int limit;

  /// 以channelId的名义查询，可选，如果传了，则只需要有该channel的管理角色权限即可，否则需要有server的管理权限
  int? channelId;

  /// 以categoryId的名义查询，可选，如果传了，则只需要有该频道分组的管理角色权限即可，否则需要有server的管理权限
  int? categoryId;

  QChatGetServerRolesParam(this.serverId, this.priority, this.limit,
      {this.channelId, this.categoryId});

  factory QChatGetServerRolesParam.fromJson(Map<String, dynamic> json) =>
      _$QChatGetServerRolesParamFromJson(json);

  Map<String, dynamic> toJson() => _$QChatGetServerRolesParamToJson(this);
}

@JsonSerializable(explicitToJson: true)
class QChatGetServerRolesResult {
  /// 服务器身份组列表
  @JsonKey(fromJson: serverRoleListFromJsonNullable, defaultValue: [])
  final List<QChatServerRole> roleList = [];

  /// 我所在的服务器身份组Id集合
  /// 从请求到的服务器身份组列表里，筛选出我所在的身份组的roleId组成的Set集合
  final Set<int> isMemberSet = {};

  QChatGetServerRolesResult(
      {List<QChatServerRole>? roleList, Set<int>? isMemberSet}) {
    if (roleList != null) {
      this.roleList.addAll(roleList);
    }
    if (isMemberSet != null) {
      this.isMemberSet.addAll(isMemberSet);
    }
  }

  factory QChatGetServerRolesResult.fromJson(Map<String, dynamic> json) =>
      _$QChatGetServerRolesResultFromJson(json);

  Map<String, dynamic> toJson() => _$QChatGetServerRolesResultToJson(this);

  @override
  String toString() {
    return 'QChatGetServerRolesResult{roleList: $roleList, isMemberSet: $isMemberSet}';
  }
}

@JsonSerializable()
class QChatAddChannelRoleParam {
  /// 服务器Id，必填
  final int serverId;

  /// 服务器身份组Id，必填，生成的频道身份组从该服务器身份组继承，以此Id作为频道身份组的 parentRoleId
  final int serverRoleId;

  /// 频道Id
  final int channelId;

  QChatAddChannelRoleParam(this.serverId, this.serverRoleId, this.channelId);

  factory QChatAddChannelRoleParam.fromJson(Map<String, dynamic> json) =>
      _$QChatAddChannelRoleParamFromJson(json);

  Map<String, dynamic> toJson() => _$QChatAddChannelRoleParamToJson(this);
}

@JsonSerializable(explicitToJson: true)
class QChatAddChannelRoleResult {
  /// 频道身份组
  @JsonKey(fromJson: _channelRoleFromJsonNullable)
  final QChatChannelRole? role;

  QChatAddChannelRoleResult(this.role);

  factory QChatAddChannelRoleResult.fromJson(Map<String, dynamic> json) =>
      _$QChatAddChannelRoleResultFromJson(json);

  Map<String, dynamic> toJson() => _$QChatAddChannelRoleResultToJson(this);

  @override
  String toString() {
    return 'QChatAddChannelRoleResult{role: $role}';
  }
}

QChatChannelRole? _channelRoleFromJsonNullable(Map? map) {
  if (map == null) {
    return null;
  }
  return QChatChannelRole.fromJson(map.cast<String, dynamic>());
}

List<QChatChannelRole>? _channelRoleListFromJsonNullable(
    List<dynamic>? dataList) {
  return dataList
      ?.map(
          (e) => QChatChannelRole.fromJson((e as Map).cast<String, dynamic>()))
      .toList();
}

@JsonSerializable(explicitToJson: true)
class QChatChannelRole {
  /// 服务器id
  int? serverId = 0;

  ///身份组id
  int? roleId = 0;

  /// 继承服务器的身份组id
  int? parentRoleId = 0;

  /// 频道id
  int? channelId = 0;

  /// 身份组名称
  String? name;

  /// 身份组图标url
  String? icon;

  /// 身份组扩展字段
  String? ext;

  /// 表示哪些资源的权限
  @JsonKey(fromJson: resourceAuthsFromJsonNullable)
  Map<QChatRoleResource, QChatRoleOption>? resourceAuths;

  /// 身份组类型，详细见[QChatRoleType]
  QChatRoleType? type;

  /// 创建时间
  int? createTime = 0;

  /// 更新时间
  int? updateTime = 0;

  QChatChannelRole();

  factory QChatChannelRole.fromJson(Map<String, dynamic> json) =>
      _$QChatChannelRoleFromJson(json);

  Map<String, dynamic> toJson() => _$QChatChannelRoleToJson(this);

  @override
  String toString() {
    return 'QChatChannelRole{serverId: $serverId, roleId: $roleId, parentRoleId: $parentRoleId, channelId: $channelId, name: $name, icon: $icon, ext: $ext, resourceAuths: $resourceAuths, type: $type, createTime: $createTime, updateTime: $updateTime}';
  }
}

Map<QChatRoleResource, QChatRoleOption>? resourceAuthsFromJsonNullable(
    Map? map) {
  return map?.cast<dynamic, dynamic>().map((key, value) => MapEntry(
      enumDecode(_$QChatRoleResourceEnumMap, key.toString())!,
      enumDecode(_$QChatRoleOptionEnumMap, value)!));
}

@JsonSerializable()
class QChatRemoveChannelRoleParam {
  /// 服务器id，必填
  final int serverId;

  /// 频道Id
  final int channelId;

  /// 身份组id，必填
  final int roleId;

  QChatRemoveChannelRoleParam(this.serverId, this.channelId, this.roleId);

  factory QChatRemoveChannelRoleParam.fromJson(Map<String, dynamic> json) =>
      _$QChatRemoveChannelRoleParamFromJson(json);

  Map<String, dynamic> toJson() => _$QChatRemoveChannelRoleParamToJson(this);
}

@JsonSerializable(explicitToJson: true)
class QChatUpdateChannelRoleParam {
  /// 服务器id，必填
  final int serverId;

  /// 频道Id
  final int channelId;

  /// 身份组id，必填
  final int roleId;

  /// 更新的权限Map，必填，最多50个
  final Map<QChatRoleResource, QChatRoleOption> resourceAuths;

  QChatUpdateChannelRoleParam(
      this.serverId, this.channelId, this.roleId, this.resourceAuths);

  factory QChatUpdateChannelRoleParam.fromJson(Map<String, dynamic> json) =>
      _$QChatUpdateChannelRoleParamFromJson(json);

  Map<String, dynamic> toJson() => _$QChatUpdateChannelRoleParamToJson(this);
}

@JsonSerializable(explicitToJson: true)
class QChatUpdateChannelRoleResult {
  /// 频道身份组
  @JsonKey(fromJson: _channelRoleFromJsonNullable)
  final QChatChannelRole? role;

  QChatUpdateChannelRoleResult(this.role);

  factory QChatUpdateChannelRoleResult.fromJson(Map<String, dynamic> json) =>
      _$QChatUpdateChannelRoleResultFromJson(json);

  Map<String, dynamic> toJson() => _$QChatUpdateChannelRoleResultToJson(this);

  @override
  String toString() {
    return 'QChatUpdateChannelRoleResult{role: $role}';
  }
}

@JsonSerializable()
class QChatGetChannelRolesParam {
  /// 服务器id
  final int serverId;

  /// 频道id
  final int channelId;

  /// 查询时间戳
  final int timeTag;

  /// 查询数量限制
  final int limit;

  QChatGetChannelRolesParam(
      this.serverId, this.channelId, this.timeTag, this.limit);

  factory QChatGetChannelRolesParam.fromJson(Map<String, dynamic> json) =>
      _$QChatGetChannelRolesParamFromJson(json);

  Map<String, dynamic> toJson() => _$QChatGetChannelRolesParamToJson(this);
}

@JsonSerializable(explicitToJson: true)
class QChatGetChannelRolesResult {
  /// 频道身份组列表
  @JsonKey(fromJson: _channelRoleListFromJsonNullable)
  final List<QChatChannelRole>? roleList;

  QChatGetChannelRolesResult(this.roleList);

  factory QChatGetChannelRolesResult.fromJson(Map<String, dynamic> json) =>
      _$QChatGetChannelRolesResultFromJson(json);

  Map<String, dynamic> toJson() => _$QChatGetChannelRolesResultToJson(this);

  @override
  String toString() {
    return 'QChatGetChannelRolesResult{roleList: $roleList}';
  }
}

@JsonSerializable()
class QChatAddMembersToServerRoleParam {
  /// 服务器id，必填
  final int serverId;

  /// 身份组id
  final int roleId;

  /// 账户列表
  final List<String> accids;

  QChatAddMembersToServerRoleParam(this.serverId, this.roleId, this.accids);

  factory QChatAddMembersToServerRoleParam.fromJson(
          Map<String, dynamic> json) =>
      _$QChatAddMembersToServerRoleParamFromJson(json);

  Map<String, dynamic> toJson() =>
      _$QChatAddMembersToServerRoleParamToJson(this);
}

@JsonSerializable()
class QChatAddMembersToServerRoleResult {
  final List<String> successAccids = [];
  final List<String> failedAccids = [];

  QChatAddMembersToServerRoleResult(
      List<String>? successAccids, List<String>? failedAccids) {
    if (successAccids != null) {
      this.successAccids.addAll(successAccids);
    }
    if (failedAccids != null) {
      this.failedAccids.addAll(failedAccids);
    }
  }

  factory QChatAddMembersToServerRoleResult.fromJson(
          Map<String, dynamic> json) =>
      _$QChatAddMembersToServerRoleResultFromJson(json);

  Map<String, dynamic> toJson() =>
      _$QChatAddMembersToServerRoleResultToJson(this);

  @override
  String toString() {
    return 'QChatAddMembersToServerRoleResult{successAccids: $successAccids, failedAccids: $failedAccids}';
  }
}

@JsonSerializable()
class QChatRemoveMembersFromServerRoleParam {
  /// 服务器id，必填
  final int serverId;

  /// 身份组id
  final int roleId;

  /// 账户列表
  final List<String> accids;

  QChatRemoveMembersFromServerRoleParam(
      this.serverId, this.roleId, this.accids);

  factory QChatRemoveMembersFromServerRoleParam.fromJson(
          Map<String, dynamic> json) =>
      _$QChatRemoveMembersFromServerRoleParamFromJson(json);

  Map<String, dynamic> toJson() =>
      _$QChatRemoveMembersFromServerRoleParamToJson(this);
}

@JsonSerializable()
class QChatRemoveMembersFromServerRoleResult {
  final List<String> successAccids = [];
  final List<String> failedAccids = [];

  QChatRemoveMembersFromServerRoleResult(
      List<String>? successAccids, List<String>? failedAccids) {
    if (successAccids != null) {
      this.successAccids.addAll(successAccids);
    }
    if (failedAccids != null) {
      this.failedAccids.addAll(failedAccids);
    }
  }

  factory QChatRemoveMembersFromServerRoleResult.fromJson(
          Map<String, dynamic> json) =>
      _$QChatRemoveMembersFromServerRoleResultFromJson(json);

  Map<String, dynamic> toJson() =>
      _$QChatRemoveMembersFromServerRoleResultToJson(this);

  @override
  String toString() {
    return 'QChatRemoveMembersFromServerRoleResult{successAccids: $successAccids, failedAccids: $failedAccids}';
  }
}

@JsonSerializable()
class QChatGetMembersFromServerRoleParam {
  /// 服务器id
  final int serverId;

  ///身份组id
  final int roleId;

  /// 查询锚点时间戳
  final int timeTag;

  /// 查询数量限制
  final int limit;

  /// 用户账号accid，作为查询锚点，第一页时不填
  String? accid;

  QChatGetMembersFromServerRoleParam(
      this.serverId, this.roleId, this.timeTag, this.limit,
      {this.accid});

  factory QChatGetMembersFromServerRoleParam.fromJson(
          Map<String, dynamic> json) =>
      _$QChatGetMembersFromServerRoleParamFromJson(json);

  Map<String, dynamic> toJson() =>
      _$QChatGetMembersFromServerRoleParamToJson(this);
}

@JsonSerializable(explicitToJson: true)
class QChatGetMembersFromServerRoleResult {
  /// 指定服务器身份组下的成员列表
  @JsonKey(fromJson: _serverRoleMemberListFromJsonNullable)
  final List<QChatServerRoleMember>? roleMemberList;

  QChatGetMembersFromServerRoleResult(this.roleMemberList);

  factory QChatGetMembersFromServerRoleResult.fromJson(
          Map<String, dynamic> json) =>
      _$QChatGetMembersFromServerRoleResultFromJson(json);

  Map<String, dynamic> toJson() =>
      _$QChatGetMembersFromServerRoleResultToJson(this);

  @override
  String toString() {
    return 'QChatGetMembersFromServerRoleResult{roleMemberList: $roleMemberList}';
  }
}

List<QChatServerRoleMember>? _serverRoleMemberListFromJsonNullable(
    List<dynamic>? dataList) {
  return dataList
      ?.map((e) =>
          QChatServerRoleMember.fromJson((e as Map).cast<String, dynamic>()))
      .toList();
}

@JsonSerializable(explicitToJson: true)
class QChatServerRoleMember {
  /// 服务器id
  int? serverId = 0;

  /// 身份组id
  int? roleId = 0;

  /// accid
  String? accid;

  /// 创建时间
  int? createTime = 0;

  /// 更新时间
  int? updateTime = 0;

  /// 昵称
  String? nick;

  /// 头像
  String? avatar;

  /// 自定义字段
  String? custom;

  /// 成员类型
  QChatMemberType? type;

  /// 加入时间
  int? jointime = 0;

  /// 邀请者accid
  String? inviter;

  QChatServerRoleMember();

  factory QChatServerRoleMember.fromJson(Map<String, dynamic> json) =>
      _$QChatServerRoleMemberFromJson(json);

  Map<String, dynamic> toJson() => _$QChatServerRoleMemberToJson(this);

  @override
  String toString() {
    return 'QChatServerRoleMember{serverId: $serverId, roleId: $roleId, accid: $accid, createTime: $createTime, updateTime: $updateTime, nick: $nick, avatar: $avatar, custom: $custom, type: $type, jointime: $jointime, inviter: $inviter}';
  }
}

@JsonSerializable()
class QChatGetServerRolesByAccidParam {
  /// 服务器id
  final int serverId;

  ///用户账号
  final String accid;

  /// 查询时间戳
  final int timeTag;

  /// 查询数量限制
  final int limit;

  QChatGetServerRolesByAccidParam(
      this.serverId, this.accid, this.timeTag, this.limit);

  factory QChatGetServerRolesByAccidParam.fromJson(Map<String, dynamic> json) =>
      _$QChatGetServerRolesByAccidParamFromJson(json);

  Map<String, dynamic> toJson() =>
      _$QChatGetServerRolesByAccidParamToJson(this);
}

@JsonSerializable(explicitToJson: true)
class QChatGetServerRolesByAccidResult {
  /// 用户自定义身份组列表
  @JsonKey(fromJson: serverRoleListFromJsonNullable)
  final List<QChatServerRole>? roleList;

  QChatGetServerRolesByAccidResult(this.roleList);

  factory QChatGetServerRolesByAccidResult.fromJson(
          Map<String, dynamic> json) =>
      _$QChatGetServerRolesByAccidResultFromJson(json);

  Map<String, dynamic> toJson() =>
      _$QChatGetServerRolesByAccidResultToJson(this);

  @override
  String toString() {
    return 'QChatGetServerRolesByAccidResult{roleList: $roleList}';
  }
}

@JsonSerializable()
class QChatGetExistingServerRolesByAccidsParam {
  /// 服务器Id
  final int serverId;

  /// accid列表
  final List<String> accids;

  QChatGetExistingServerRolesByAccidsParam(this.serverId, this.accids);

  factory QChatGetExistingServerRolesByAccidsParam.fromJson(
          Map<String, dynamic> json) =>
      _$QChatGetExistingServerRolesByAccidsParamFromJson(json);

  Map<String, dynamic> toJson() =>
      _$QChatGetExistingServerRolesByAccidsParamToJson(this);
}

@JsonSerializable(explicitToJson: true)
class QChatGetExistingServerRolesByAccidsResult {
  /// 服务器自定义身份组Map
  @JsonKey(fromJson: _accidServerRolesMapFromJsonNullable)
  final Map<String, List<QChatServerRole>?>? accidServerRolesMap;

  QChatGetExistingServerRolesByAccidsResult(this.accidServerRolesMap);

  factory QChatGetExistingServerRolesByAccidsResult.fromJson(
          Map<String, dynamic> json) =>
      _$QChatGetExistingServerRolesByAccidsResultFromJson(json);

  Map<String, dynamic> toJson() =>
      _$QChatGetExistingServerRolesByAccidsResultToJson(this);

  @override
  String toString() {
    return 'QChatGetExistingServerRolesByAccidsResult{accidServerRolesMap: $accidServerRolesMap}';
  }
}

Map<String, List<QChatServerRole>?>? _accidServerRolesMapFromJsonNullable(
    Map? map) {
  return map?.cast<dynamic, dynamic>().map((key, value) => MapEntry(
      key.toString(),
      (value as List?)
          ?.map((e) =>
              QChatServerRole.fromJson((e as Map).cast<String, dynamic>()))
          .toList()));
}

@JsonSerializable()
class QChatGetExistingAccidsInServerRoleParam {
  /// 服务器Id
  final int serverId;

  /// 身份组id
  final int roleId;

  /// accid列表
  final List<String> accids;

  QChatGetExistingAccidsInServerRoleParam(
      this.serverId, this.roleId, this.accids);

  factory QChatGetExistingAccidsInServerRoleParam.fromJson(
          Map<String, dynamic> json) =>
      _$QChatGetExistingAccidsInServerRoleParamFromJson(json);

  Map<String, dynamic> toJson() =>
      _$QChatGetExistingAccidsInServerRoleParamToJson(this);
}

@JsonSerializable()
class QChatGetExistingAccidsInServerRoleResult {
  /// 指定服务器身份组下存在的成员列表
  final List<String> accidList = [];

  QChatGetExistingAccidsInServerRoleResult(List<String>? accidList) {
    if (accidList != null) {
      this.accidList.addAll(accidList);
    }
  }

  factory QChatGetExistingAccidsInServerRoleResult.fromJson(
          Map<String, dynamic> json) =>
      _$QChatGetExistingAccidsInServerRoleResultFromJson(json);

  Map<String, dynamic> toJson() =>
      _$QChatGetExistingAccidsInServerRoleResultToJson(this);

  @override
  String toString() {
    return 'QChatGetExistingAccidsInServerRoleResult{accidList: $accidList}';
  }
}

@JsonSerializable()
class QChatGetExistingChannelRolesByServerRoleIdsParam {
  /// 服务器Id
  final int serverId;

  /// 频道Id
  final int channelId;

  /// 身份组Id列表
  final List<int> roleIds;

  QChatGetExistingChannelRolesByServerRoleIdsParam(
      this.serverId, this.channelId, this.roleIds);

  factory QChatGetExistingChannelRolesByServerRoleIdsParam.fromJson(
          Map<String, dynamic> json) =>
      _$QChatGetExistingChannelRolesByServerRoleIdsParamFromJson(json);

  Map<String, dynamic> toJson() =>
      _$QChatGetExistingChannelRolesByServerRoleIdsParamToJson(this);
}

@JsonSerializable(explicitToJson: true)
class QChatGetExistingChannelRolesByServerRoleIdsResult {
  /// 频道身份组列表
  @JsonKey(fromJson: _channelRoleListFromJsonNullable)
  final List<QChatChannelRole>? roleList;

  QChatGetExistingChannelRolesByServerRoleIdsResult(this.roleList);

  factory QChatGetExistingChannelRolesByServerRoleIdsResult.fromJson(
          Map<String, dynamic> json) =>
      _$QChatGetExistingChannelRolesByServerRoleIdsResultFromJson(json);

  Map<String, dynamic> toJson() =>
      _$QChatGetExistingChannelRolesByServerRoleIdsResultToJson(this);

  @override
  String toString() {
    return 'QChatGetExistingChannelRolesByServerRoleIdsResult{roleList: $roleList}';
  }
}

@JsonSerializable()
class QChatGetExistingAccidsOfMemberRolesParam {
  /// 服务器Id
  final int serverId;

  /// 频道Id
  final int channelId;

  /// accid列表
  final List<String> accids;

  QChatGetExistingAccidsOfMemberRolesParam(
      this.serverId, this.channelId, this.accids);

  factory QChatGetExistingAccidsOfMemberRolesParam.fromJson(
          Map<String, dynamic> json) =>
      _$QChatGetExistingAccidsOfMemberRolesParamFromJson(json);

  Map<String, dynamic> toJson() =>
      _$QChatGetExistingAccidsOfMemberRolesParamToJson(this);
}

@JsonSerializable()
class QChatGetExistingAccidsOfMemberRolesResult {
  /// accid列表，代表已经在频道定制过个人权限的用户
  final List<String> accidList = [];

  QChatGetExistingAccidsOfMemberRolesResult(List<String>? accidList) {
    if (accidList != null) {
      this.accidList.addAll(accidList);
    }
  }

  factory QChatGetExistingAccidsOfMemberRolesResult.fromJson(
          Map<String, dynamic> json) =>
      _$QChatGetExistingAccidsOfMemberRolesResultFromJson(json);

  Map<String, dynamic> toJson() =>
      _$QChatGetExistingAccidsOfMemberRolesResultToJson(this);

  @override
  String toString() {
    return 'QChatGetExistingAccidsOfMemberRolesResult{accidList: $accidList}';
  }
}

@JsonSerializable()
class QChatAddMemberRoleParam {
  /// 服务器id，必填
  final int serverId;

  /// 频道id，必填
  final int channelId;

  /// 用户账号，必填
  final String accid;

  QChatAddMemberRoleParam(this.serverId, this.channelId, this.accid);

  factory QChatAddMemberRoleParam.fromJson(Map<String, dynamic> json) =>
      _$QChatAddMemberRoleParamFromJson(json);

  Map<String, dynamic> toJson() => _$QChatAddMemberRoleParamToJson(this);

  @override
  String toString() {
    return 'QChatAddMemberRoleParam{serverId: $serverId, channelId: $channelId, accid: $accid}';
  }
}

@JsonSerializable(explicitToJson: true)
class QChatAddMemberRoleResult {
  /// 用户所在身份组
  @JsonKey(fromJson: _roleFromJsonNullable)
  final QChatMemberRole? role;

  QChatAddMemberRoleResult(this.role);

  factory QChatAddMemberRoleResult.fromJson(Map<String, dynamic> json) =>
      _$QChatAddMemberRoleResultFromJson(json);

  Map<String, dynamic> toJson() => _$QChatAddMemberRoleResultToJson(this);

  @override
  String toString() {
    return 'QChatAddMemberRoleResult{role: $role}';
  }
}

QChatMemberRole? _roleFromJsonNullable(Map? map) {
  if (map == null) {
    return null;
  }
  return QChatMemberRole.fromJson(map.cast<String, dynamic>());
}

@JsonSerializable(explicitToJson: true)
class QChatMemberRole {
  /// 服务器id
  int? serverId;

  /// id
  int? id;

  /// 用户账号
  String? accid;

  /// 频道id
  int? channelId;

  /// 资源的权限列表
  @JsonKey(fromJson: resourceAuthsFromJsonNullable)
  Map<QChatRoleResource, QChatRoleOption>? resourceAuths;

  /// 创建时间
  int? createTime;

  /// 更新时间
  int? updateTime;

  /// 昵称
  String? nick;

  /// 头像
  String? avatar;

  /// 自定义字段
  String? custom;

  /// 成员类型
  QChatMemberType? type;

  /// 加入时间
  int? joinTime;

  /// 邀请者accid
  String? inviter;

  QChatMemberRole();

  factory QChatMemberRole.fromJson(Map<String, dynamic> json) =>
      _$QChatMemberRoleFromJson(json);

  Map<String, dynamic> toJson() => _$QChatMemberRoleToJson(this);

  @override
  String toString() {
    return 'QChatMemberRole{serverId: $serverId, id: $id, accid: $accid, channelId: $channelId, resourceAuths: $resourceAuths, createTime: $createTime, updateTime: $updateTime, nick: $nick, avatar: $avatar, custom: $custom, type: $type, joinTime: $joinTime, inviter: $inviter}';
  }
}

@JsonSerializable()
class QChatRemoveMemberRoleParam {
  /// 服务器id，必填
  final int serverId;

  /// 频道id，必填
  final int channelId;

  /// 用户账号，必填
  final String accid;

  QChatRemoveMemberRoleParam(this.serverId, this.channelId, this.accid);

  factory QChatRemoveMemberRoleParam.fromJson(Map<String, dynamic> json) =>
      _$QChatRemoveMemberRoleParamFromJson(json);

  Map<String, dynamic> toJson() => _$QChatRemoveMemberRoleParamToJson(this);

  @override
  String toString() {
    return 'QChatRemoveMemberRoleParam{serverId: $serverId, channelId: $channelId, accid: $accid}';
  }
}

@JsonSerializable(explicitToJson: true)
class QChatUpdateMemberRoleParam {
  /// 服务器id，必填
  final int serverId;

  /// 频道id，必填
  final int channelId;

  /// 用户账号，必填
  final String accid;

  /// 更新的权限Map，最多50个
  final Map<QChatRoleResource, QChatRoleOption> resourceAuths;

  QChatUpdateMemberRoleParam(
      this.serverId, this.channelId, this.accid, this.resourceAuths);

  factory QChatUpdateMemberRoleParam.fromJson(Map<String, dynamic> json) =>
      _$QChatUpdateMemberRoleParamFromJson(json);

  Map<String, dynamic> toJson() => _$QChatUpdateMemberRoleParamToJson(this);

  @override
  String toString() {
    return 'QChatUpdateMemberRoleParam{serverId: $serverId, channelId: $channelId, accid: $accid, resourceAuths: $resourceAuths}';
  }
}

@JsonSerializable(explicitToJson: true)
class QChatUpdateMemberRoleResult {
  /// 更新后的用户身份组
  @JsonKey(fromJson: _roleFromJsonNullable)
  final QChatMemberRole? role;

  QChatUpdateMemberRoleResult(this.role);

  factory QChatUpdateMemberRoleResult.fromJson(Map<String, dynamic> json) =>
      _$QChatUpdateMemberRoleResultFromJson(json);

  Map<String, dynamic> toJson() => _$QChatUpdateMemberRoleResultToJson(this);

  @override
  String toString() {
    return 'QChatUpdateMemberRoleResult{role: $role}';
  }
}

@JsonSerializable()
class QChatGetMemberRolesParam {
  /// 服务器Id
  final int serverId;

  /// channelId
  final int channelId;

  /// 查询锚点时间戳
  final int timeTag;

  /// 查询数量限制
  final int limit;

  QChatGetMemberRolesParam(
      this.serverId, this.channelId, this.timeTag, this.limit);

  factory QChatGetMemberRolesParam.fromJson(Map<String, dynamic> json) =>
      _$QChatGetMemberRolesParamFromJson(json);

  Map<String, dynamic> toJson() => _$QChatGetMemberRolesParamToJson(this);

  @override
  String toString() {
    return 'QChatGetMemberRolesParam{serverId: $serverId, channelId: $channelId, timeTag: $timeTag, limit: $limit}';
  }
}

@JsonSerializable(explicitToJson: true)
class QChatGetMemberRolesResult {
  /// 用户所在身份组列表
  @JsonKey(fromJson: _memberRoleListFromJsonNullable)
  final List<QChatMemberRole>? roleList;

  QChatGetMemberRolesResult(this.roleList);

  factory QChatGetMemberRolesResult.fromJson(Map<String, dynamic> json) =>
      _$QChatGetMemberRolesResultFromJson(json);

  Map<String, dynamic> toJson() => _$QChatGetMemberRolesResultToJson(this);

  @override
  String toString() {
    return 'QChatGetMemberRolesResult{roleList: $roleList}';
  }
}

List<QChatMemberRole>? _memberRoleListFromJsonNullable(
    List<dynamic>? dataList) {
  return dataList
      ?.map((e) => QChatMemberRole.fromJson((e as Map).cast<String, dynamic>()))
      .toList();
}

@JsonSerializable(explicitToJson: true)
class QChatCheckPermissionParam {
  /// 服务器id，必填
  final int serverId;

  /// 频道id，查询 server 权限时不需要传channelId
  final int? channelId;

  /// 身份组权限资源项
  final QChatRoleResource permission;

  QChatCheckPermissionParam(this.serverId, this.permission, [this.channelId]);

  factory QChatCheckPermissionParam.fromJson(Map<String, dynamic> json) =>
      _$QChatCheckPermissionParamFromJson(json);

  Map<String, dynamic> toJson() => _$QChatCheckPermissionParamToJson(this);

  @override
  String toString() {
    return 'QChatCheckPermissionParam{serverId: $serverId, channelId: $channelId, permission: $permission}';
  }
}

@JsonSerializable()
class QChatCheckPermissionResult {
  /// 频道身份组
  final bool? hasPermission;

  QChatCheckPermissionResult(this.hasPermission);

  factory QChatCheckPermissionResult.fromJson(Map<String, dynamic> json) =>
      _$QChatCheckPermissionResultFromJson(json);

  Map<String, dynamic> toJson() => _$QChatCheckPermissionResultToJson(this);

  @override
  String toString() {
    return 'QChatCheckPermissionResult{hasPermission: $hasPermission}';
  }
}

@JsonSerializable(explicitToJson: true)
class QChatCheckPermissionsParam {
  /// 服务器Id，必填
  final int serverId;

  /// 频道Id，查询 server 权限时不需要传channelId
  final int? channelId;

  /// 身份组权限资源项列表，一次最多可查10个权限项
  final List<QChatRoleResource>? permissions;

  QChatCheckPermissionsParam(this.serverId, this.permissions, [this.channelId]);

  factory QChatCheckPermissionsParam.fromJson(Map<String, dynamic> json) =>
      _$QChatCheckPermissionsParamFromJson(json);

  Map<String, dynamic> toJson() => _$QChatCheckPermissionsParamToJson(this);

  @override
  String toString() {
    return 'QChatCheckPermissionsParam{serverId: $serverId, channelId: $channelId, permissions: $permissions}';
  }
}

@JsonSerializable(explicitToJson: true)
class QChatCheckPermissionsResult {
  /// 权限结果
  @JsonKey(fromJson: resourceAuthsFromJsonNullable)
  final Map<QChatRoleResource, QChatRoleOption>? permissions;

  QChatCheckPermissionsResult(this.permissions);

  factory QChatCheckPermissionsResult.fromJson(Map<String, dynamic> json) =>
      _$QChatCheckPermissionsResultFromJson(json);

  Map<String, dynamic> toJson() => _$QChatCheckPermissionsResultToJson(this);

  @override
  String toString() {
    return 'QChatCheckPermissionsResult{permissions: $permissions}';
  }
}
