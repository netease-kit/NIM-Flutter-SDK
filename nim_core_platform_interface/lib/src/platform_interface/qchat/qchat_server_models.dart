// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:json_annotation/json_annotation.dart';

import 'qchat_base_models.dart';

part 'qchat_server_models.g.dart';

@JsonSerializable(explicitToJson: true)
class QChatCreateServerParam extends QChatAntiSpamConfigParam {
  /// 名称，必填
  final String name;

  /// 图标
  String? icon;

  /// 自定义扩展UserIdentifyTag
  String? custom;

  /// 邀请模式：[QChatInviteMode.agreeNeed]-邀请需要同意(默认),[QChatInviteMode.agreeNeedNot]-邀请不需要同意
  QChatInviteMode inviteMode = QChatInviteMode.agreeNeed;

  /// 申请模式：[QChatApplyJoinMode.agreeNeedNot]-申请不需要同意(默认)，[QChatApplyJoinMode.agreeNeed]-申请需要同意
  QChatApplyJoinMode applyJoinMode = QChatApplyJoinMode.agreeNeedNot;

  /// 服务器搜索类型，客户自定义：比如服务器行业类型等,大于0的正整数
  int? searchType;

  /// 服务器是否允许被搜索，1可以被搜索，0不可被搜索，默认允许
  bool? searchEnable = true;

  QChatCreateServerParam(this.name);

  factory QChatCreateServerParam.fromJson(Map<String, dynamic> json) =>
      _$QChatCreateServerParamFromJson(json);

  Map<String, dynamic> toJson() => _$QChatCreateServerParamToJson(this);

  @override
  String toString() {
    return 'QChatCreateServerParam{antiSpamConfig: $antiSpamConfig, name: $name, icon: $icon, custom: $custom, inviteMode: $inviteMode, applyJoinMode: $applyJoinMode, searchType: $searchType, searchEnable: $searchEnable}';
  }
}

enum QChatInviteMode {
  /// 邀请需要同意
  agreeNeed,

  /// 邀请不需要同意
  agreeNeedNot
}

extension QChatInviteModeExtension on QChatInviteMode {
  int value() {
    int result = -1;
    switch (this) {
      case QChatInviteMode.agreeNeed:
        result = 0;
        break;
      case QChatInviteMode.agreeNeedNot:
        result = 1;
        break;
    }
    return result;
  }

  static QChatInviteMode? typeOfValue(int value) {
    for (QChatInviteMode e in QChatInviteMode.values) {
      if (e.value() == value) {
        return e;
      }
    }
    return null;
  }
}

enum QChatApplyJoinMode {
  /// 申请不需要同意
  agreeNeedNot,

  /// 申请需要同意
  agreeNeed
}

extension QChatApplyJoinModeExtension on QChatApplyJoinMode {
  int value() {
    int result = -1;
    switch (this) {
      case QChatApplyJoinMode.agreeNeedNot:
        result = 0;
        break;
      case QChatApplyJoinMode.agreeNeed:
        result = 1;
        break;
    }
    return result;
  }

  static QChatApplyJoinMode? typeOfValue(int value) {
    for (QChatApplyJoinMode e in QChatApplyJoinMode.values) {
      if (e.value() == value) {
        return e;
      }
    }
    return null;
  }
}

@JsonSerializable(explicitToJson: true)
class QChatCreateServerResult {
  /// 创建成功的服务器
  @JsonKey(fromJson: serverFromJsonNullable)
  final QChatServer? server;

  QChatCreateServerResult(this.server);

  factory QChatCreateServerResult.fromJson(Map<String, dynamic> json) =>
      _$QChatCreateServerResultFromJson(json);

  Map<String, dynamic> toJson() => _$QChatCreateServerResultToJson(this);

  @override
  String toString() {
    return 'QChatCreateServerResult{server: $server}';
  }
}

QChatServer? serverFromJsonNullable(Map? map) {
  if (map == null) {
    return null;
  }
  return QChatServer.fromJson(map.cast<String, dynamic>());
}

List<QChatServer>? _serverListFromJsonNullable(List<dynamic>? dataList) {
  return dataList
      ?.map((e) => QChatServer.fromJson((e as Map).cast<String, dynamic>()))
      .toList();
}

@JsonSerializable(explicitToJson: true)
class QChatServer {
  /// id
  int? serverId = 0;

  /// 名称
  String? name;

  /// 图标
  String? icon;

  /// 自定义扩展
  String? custom;

  /// 所有者
  String? owner;

  /// 成员数
  int? memberNumber = 0;

  /// 邀请模式：[QChatInviteMode.agreeNeed]-邀请需要同意(默认),[QChatInviteMode.agreeNeedNot]-邀请不需要同意
  QChatInviteMode? inviteMode = QChatInviteMode.agreeNeed;

  /// 申请模式：[QChatApplyJoinMode.agreeNeedNot]-申请不需要同意(默认)，[QChatApplyJoinMode.agreeNeed]-申请需要同意
  QChatApplyJoinMode? applyMode = QChatApplyJoinMode.agreeNeedNot;

  /// 有效标志：false-无效，true-有效
  bool? valid = false;

  /// 创建时间
  int? createTime = 0;

  /// 更新时间
  int? updateTime = 0;

  /// 频道数
  int? channelNum = 0;

  /// 频道类别数
  int? channelCategoryNum = 0;

  /// 服务器搜索类型，客户自定义：比如服务器行业类型等,大于0的正整数
  int? searchType;

  /// 服务器是否允许被搜索，true-可以被搜索，false-不可被搜索，默认允许
  bool? searchEnable = true;

  /// 自定义排序权重值
  int? reorderWeight;

  QChatServer();

  factory QChatServer.fromJson(Map<String, dynamic> json) =>
      _$QChatServerFromJson(json);

  Map<String, dynamic> toJson() => _$QChatServerToJson(this);

  @override
  String toString() {
    return 'QChatServer{serverId: $serverId, name: $name, icon: $icon, custom: $custom, owner: $owner, memberNumber: $memberNumber, inviteMode: $inviteMode, applyMode: $applyMode, valid: $valid, createTime: $createTime, updateTime: $updateTime, channelNum: $channelNum, channelCategoryNum: $channelCategoryNum, searchType: $searchType, searchEnable: $searchEnable, reorderWeight: $reorderWeight}';
  }
}

@JsonSerializable()
class QChatGetServersParam {
  /// 将要查询的服务器Id列表
  final List<int> serverIds;

  QChatGetServersParam(this.serverIds);

  factory QChatGetServersParam.fromJson(Map<String, dynamic> json) =>
      _$QChatGetServersParamFromJson(json);

  Map<String, dynamic> toJson() => _$QChatGetServersParamToJson(this);

  @override
  String toString() {
    return 'QChatGetServersParam{serverIds: $serverIds}';
  }
}

@JsonSerializable()
class QChatGetServersResult {
  /// 查询到的服务器列表
  @JsonKey(fromJson: _serverListFromJsonNullable)
  final List<QChatServer>? servers;

  QChatGetServersResult(this.servers);

  factory QChatGetServersResult.fromJson(Map<String, dynamic> json) =>
      _$QChatGetServersResultFromJson(json);

  Map<String, dynamic> toJson() => _$QChatGetServersResultToJson(this);

  @override
  String toString() {
    return 'QChatGetServersResult{servers: $servers}';
  }
}

@JsonSerializable()
class QChatGetServersByPageParam {
  /// 查询锚点时间戳
  final int timeTag;

  /// 查询数量限制
  final int limit;

  QChatGetServersByPageParam(this.timeTag, this.limit);

  factory QChatGetServersByPageParam.fromJson(Map<String, dynamic> json) =>
      _$QChatGetServersByPageParamFromJson(json);

  Map<String, dynamic> toJson() => _$QChatGetServersByPageParamToJson(this);

  @override
  String toString() {
    return 'QChatGetServersByPageParam{timeTag: $timeTag, limit: $limit}';
  }
}

@JsonSerializable(explicitToJson: true)
class QChatGetServersByPageResult extends QChatGetByPageResult {
  /// 查询到的服务器列表
  @JsonKey(fromJson: _serverListFromJsonNullable)
  final List<QChatServer>? servers;

  QChatGetServersByPageResult(bool? hasMore, int? nextTimeTag, this.servers)
      : super(hasMore: hasMore ?? false, nextTimeTag: nextTimeTag);

  factory QChatGetServersByPageResult.fromJson(Map<String, dynamic> json) =>
      _$QChatGetServersByPageResultFromJson(json);

  Map<String, dynamic> toJson() => _$QChatGetServersByPageResultToJson(this);

  @override
  String toString() {
    return 'QChatGetServersByPageResult{hasMore: $hasMore, nextTimeTag: $nextTimeTag, servers: $servers}';
  }
}

@JsonSerializable(explicitToJson: true)
class QChatUpdateServerParam extends QChatAntiSpamConfigParam {
  /// 将要修改的服务器Id，必填
  final int serverId;

  /// 名称
  String? name;

  /// 图标
  String? icon;

  /// 自定义扩展
  String? custom;

  /// 邀请模式：[QChatInviteMode.agreeNeed]-邀请需要同意(默认),[QChatInviteMode.agreeNeedNot]-邀请不需要同意
  QChatInviteMode? inviteMode;

  /// 申请模式：[QChatApplyJoinMode.agreeNeedNot]-申请不需要同意(默认)，[QChatApplyJoinMode.agreeNeed]-申请需要同意
  QChatApplyJoinMode? applyMode;

  /// 服务器搜索类型，客户自定义：比如服务器行业类型等,大于0的正整数
  int? searchType;

  /// 服务器是否允许被搜索，true-可以被搜索，false-不可被搜索，默认允许
  bool? searchEnable;

  QChatUpdateServerParam(this.serverId);

  factory QChatUpdateServerParam.fromJson(Map<String, dynamic> json) =>
      _$QChatUpdateServerParamFromJson(json);

  Map<String, dynamic> toJson() => _$QChatUpdateServerParamToJson(this);

  @override
  String toString() {
    return 'QChatUpdateServerParam{serverId: $serverId, name: $name, icon: $icon, custom: $custom, inviteMode: $inviteMode, applyMode: $applyMode, searchType: $searchType, searchEnable: $searchEnable}';
  }
}

@JsonSerializable(explicitToJson: true)
class QChatUpdateServerResult {
  /// 更新成功的服务器
  @JsonKey(fromJson: serverFromJsonNullable)
  final QChatServer? server;

  QChatUpdateServerResult(this.server);

  factory QChatUpdateServerResult.fromJson(Map<String, dynamic> json) =>
      _$QChatUpdateServerResultFromJson(json);

  Map<String, dynamic> toJson() => _$QChatUpdateServerResultToJson(this);

  @override
  String toString() {
    return 'QChatUpdateServerResult{server: $server}';
  }
}

@JsonSerializable()
class QChatDeleteServerParam {
  /// 将要删除的服务器Id
  final int serverId;

  QChatDeleteServerParam(this.serverId);

  factory QChatDeleteServerParam.fromJson(Map<String, dynamic> json) =>
      _$QChatDeleteServerParamFromJson(json);

  Map<String, dynamic> toJson() => _$QChatDeleteServerParamToJson(this);

  @override
  String toString() {
    return 'QChatDeleteServerParam{serverId: $serverId}';
  }
}

@JsonSerializable()
class QChatSubscribeServerParam {
  /// 请求参数，订阅类型，见[QChatSubscribeType]
  final QChatSubscribeType type;

  /// 请求参数，操作类型，见[QChatSubscribeOperateType]
  final QChatSubscribeOperateType operateType;

  /// 请求参数，操作的对象：serverId列表
  final List<int> serverIds;

  QChatSubscribeServerParam(this.type, this.operateType, this.serverIds);

  factory QChatSubscribeServerParam.fromJson(Map<String, dynamic> json) =>
      _$QChatSubscribeServerParamFromJson(json);

  Map<String, dynamic> toJson() => _$QChatSubscribeServerParamToJson(this);

  @override
  String toString() {
    return 'QChatSubscribeServerParam{type: $type, operateType: $operateType, serverIds: $serverIds}';
  }
}

@JsonSerializable()
class QChatSubscribeServerResult {
  /// 订阅失败的服务器Id列表
  final List<int>? failedList;

  QChatSubscribeServerResult(this.failedList);

  factory QChatSubscribeServerResult.fromJson(Map<String, dynamic> json) =>
      _$QChatSubscribeServerResultFromJson(json);

  Map<String, dynamic> toJson() => _$QChatSubscribeServerResultToJson(this);

  @override
  String toString() {
    return 'QChatSubscribeServerResult{failedList: $failedList}';
  }
}

@JsonSerializable(explicitToJson: true)
class QChatInviteServerMembersParam extends QChatServerJoinParam {
  /// 邀请加入的服务器Id，必填
  final int serverId;

  /// 邀请加入的成员的accid列表，必填
  final List<String> accids;

  /// 附言(最长5000)
  String postscript = "";

  QChatInviteServerMembersParam(this.serverId, this.accids);

  factory QChatInviteServerMembersParam.fromJson(Map<String, dynamic> json) =>
      _$QChatInviteServerMembersParamFromJson(json);

  Map<String, dynamic> toJson() => _$QChatInviteServerMembersParamToJson(this);

  @override
  String toString() {
    return 'QChatInviteServerMembersParam{serverId: $serverId, accids: $accids, postscript: $postscript}';
  }
}

abstract class QChatServerJoinParam {
  /// 有效时长，单位: 毫秒
  int? ttl;

  @override
  String toString() {
    return 'QChatServerJoinParam{ttl: $ttl}';
  }
}

@JsonSerializable(explicitToJson: true)
class QChatInviteServerMembersResult {
  /// 因为用户服务器数量超限导致失败的accid列表
  List<String> _failedAccids = [];

  /// 因为用户被服务器封禁导致失败的accid列表
  List<String> _bannedAccids = [];

  /// 邀请信息
  @JsonKey(fromJson: _applyServerMemberInfoFromJson)
  QChatInviteApplyServerMemberInfo? inviteServerMemberInfo;

  QChatInviteServerMembersResult(
      {List<String>? failedAccids,
      List<String>? bannedAccids,
      this.inviteServerMemberInfo}) {
    if (failedAccids != null) {
      this._failedAccids = [...failedAccids];
    }
    if (bannedAccids != null) {
      this._bannedAccids = [...bannedAccids];
    }
  }

  factory QChatInviteServerMembersResult.fromJson(Map<String, dynamic> json) =>
      _$QChatInviteServerMembersResultFromJson(json);

  Map<String, dynamic> toJson() => _$QChatInviteServerMembersResultToJson(this);

  /// 获取因为用户服务器数量超限导致失败的accid列表
  List<String> get failedAccids => _failedAccids;

  /// 获取因为用户被服务器封禁导致失败的accid列表
  List<String> get bannedAccids => _bannedAccids;

  @override
  String toString() {
    return 'QChatInviteServerMembersResult{failedAccids: $_failedAccids, bannedAccids: $_bannedAccids, inviteServerMemberInfo: $inviteServerMemberInfo}';
  }
}

@JsonSerializable()
class QChatAcceptServerInviteParam extends QChatJoinServerOperationParam {
  /// 接受加入的服务器Id，必填
  final int serverId;

  /// 发起邀请者的accid，必填
  final String accid;

  QChatAcceptServerInviteParam(this.serverId, this.accid, int requestId)
      : super(requestId);

  factory QChatAcceptServerInviteParam.fromJson(Map<String, dynamic> json) =>
      _$QChatAcceptServerInviteParamFromJson(json);

  Map<String, dynamic> toJson() => _$QChatAcceptServerInviteParamToJson(this);

  @override
  String toString() {
    return 'QChatAcceptServerInviteParam{requestId: $requestId, serverId: $serverId, accid: $accid}';
  }
}

@JsonSerializable()
class QChatRejectServerInviteParam extends QChatJoinServerOperationParam {
  /// 拒绝加入的服务器Id，必填
  final int serverId;

  /// 发起邀请者的accid，必填
  final String accid;

  ///  附言(最长5000)
  String postscript = "";

  QChatRejectServerInviteParam(this.serverId, this.accid, int requestId)
      : super(requestId);

  factory QChatRejectServerInviteParam.fromJson(Map<String, dynamic> json) =>
      _$QChatRejectServerInviteParamFromJson(json);

  Map<String, dynamic> toJson() => _$QChatRejectServerInviteParamToJson(this);

  @override
  String toString() {
    return 'QChatRejectServerInviteParam{serverId: $serverId, accid: $accid, postscript: $postscript}';
  }
}

@JsonSerializable()
class QChatGenerateInviteCodeParam {
  /// 服务器ID
  final int serverId;

  /// 有效期（毫秒）
  int? ttl;

  QChatGenerateInviteCodeParam(this.serverId);

  factory QChatGenerateInviteCodeParam.fromJson(Map<String, dynamic> json) =>
      _$QChatGenerateInviteCodeParamFromJson(json);

  Map<String, dynamic> toJson() => _$QChatGenerateInviteCodeParamToJson(this);

  @override
  String toString() {
    return 'QChatGenerateInviteCodeParam{serverId: $serverId, ttl: $ttl}';
  }
}

@JsonSerializable()
class QChatGenerateInviteCodeResult {
  /// 服务器ID
  final int? serverId;

  /// 唯一标识
  final int? requestId;

  /// 邀请码
  final String? inviteCode;

  /// 过期时间戳ms
  final int? expireTime;

  QChatGenerateInviteCodeResult(
      this.serverId, this.requestId, this.inviteCode, this.expireTime);

  factory QChatGenerateInviteCodeResult.fromJson(Map<String, dynamic> json) =>
      _$QChatGenerateInviteCodeResultFromJson(json);

  Map<String, dynamic> toJson() => _$QChatGenerateInviteCodeResultToJson(this);

  @override
  String toString() {
    return 'QChatGenerateInviteCodeResult{serverId: $serverId, requestId: $requestId, inviteCode: $inviteCode, expireTime: $expireTime}';
  }
}

@JsonSerializable()
class QChatJoinByInviteCodeParam {
  /// 服务器ID
  final int? serverId;

  /// 邀请码
  final String? inviteCode;

  /// 附言
  String? postscript;

  QChatJoinByInviteCodeParam(this.serverId, this.inviteCode);

  factory QChatJoinByInviteCodeParam.fromJson(Map<String, dynamic> json) =>
      _$QChatJoinByInviteCodeParamFromJson(json);

  Map<String, dynamic> toJson() => _$QChatJoinByInviteCodeParamToJson(this);

  /// 参数是否合法
  bool isValid() => serverId != null && serverId! > 0;

  @override
  String toString() {
    return 'QChatJoinByInviteCodeParam{serverId: $serverId, inviteCode: $inviteCode, postscript: $postscript}';
  }
}

@JsonSerializable()
class QChatApplyServerJoinParam extends QChatServerJoinParam {
  /// 申请加入的服务器Id
  final int serverId;

  /// 附言(最长5000)
  String postscript = "";

  QChatApplyServerJoinParam(this.serverId);

  factory QChatApplyServerJoinParam.fromJson(Map<String, dynamic> json) =>
      _$QChatApplyServerJoinParamFromJson(json);

  Map<String, dynamic> toJson() => _$QChatApplyServerJoinParamToJson(this);

  @override
  String toString() {
    return 'QChatApplyServerJoinParam{ttl: $ttl, serverId: $serverId, postscript: $postscript}';
  }
}

@JsonSerializable(explicitToJson: true)
class QChatApplyServerJoinResult {
  /// 申请信息
  @JsonKey(fromJson: _applyServerMemberInfoFromJson)
  QChatInviteApplyServerMemberInfo? applyServerMemberInfo;

  QChatApplyServerJoinResult(this.applyServerMemberInfo);

  factory QChatApplyServerJoinResult.fromJson(Map<String, dynamic> json) =>
      _$QChatApplyServerJoinResultFromJson(json);

  Map<String, dynamic> toJson() => _$QChatApplyServerJoinResultToJson(this);

  @override
  String toString() {
    return 'QChatApplyServerJoinResult{applyServerMemberInfo: $applyServerMemberInfo}';
  }
}

QChatInviteApplyServerMemberInfo? _applyServerMemberInfoFromJson(Map? map) {
  if (map == null) {
    return null;
  }
  return QChatInviteApplyServerMemberInfo.fromJson(map.cast<String, dynamic>());
}

@JsonSerializable()
class QChatInviteApplyServerMemberInfo {
  /// 申请邀请唯一标识
  int? requestId = 0;

  /// 过期时间戳
  int? expireTime = 0;

  QChatInviteApplyServerMemberInfo(this.requestId, this.expireTime);

  factory QChatInviteApplyServerMemberInfo.fromJson(
          Map<String, dynamic> json) =>
      _$QChatInviteApplyServerMemberInfoFromJson(json);

  Map<String, dynamic> toJson() =>
      _$QChatInviteApplyServerMemberInfoToJson(this);

  @override
  String toString() {
    return 'QChatInviteApplyServerMemberInfo{requestId: $requestId, expireTime: $expireTime}';
  }
}

@JsonSerializable()
class QChatAcceptServerApplyParam extends QChatJoinServerOperationParam {
  /// 同意加入的服务器Id
  final int serverId;

  /// 申请者Id
  final String accid;

  QChatAcceptServerApplyParam(this.serverId, this.accid, int requestId)
      : super(requestId);

  factory QChatAcceptServerApplyParam.fromJson(Map<String, dynamic> json) =>
      _$QChatAcceptServerApplyParamFromJson(json);

  Map<String, dynamic> toJson() => _$QChatAcceptServerApplyParamToJson(this);

  @override
  String toString() {
    return 'QChatAcceptServerApplyParam{requestId: $requestId, serverId: $serverId, accid: $accid}';
  }
}

abstract class QChatJoinServerOperationParam {
  /// 申请/邀请唯一标识
  final int requestId;

  QChatJoinServerOperationParam(this.requestId);

  @override
  String toString() {
    return 'QChatJoinServerOperationParam{requestId: $requestId}';
  }
}

@JsonSerializable()
class QChatRejectServerApplyParam extends QChatJoinServerOperationParam {
  /// 拒绝申请加入的服务器Id
  final int serverId;

  /// 申请者Id
  final String accid;

  /// 附言(最长5000)
  String postscript = "";

  QChatRejectServerApplyParam(this.serverId, this.accid, int requestId)
      : super(requestId);

  factory QChatRejectServerApplyParam.fromJson(Map<String, dynamic> json) =>
      _$QChatRejectServerApplyParamFromJson(json);

  Map<String, dynamic> toJson() => _$QChatRejectServerApplyParamToJson(this);

  @override
  String toString() {
    return 'QChatRejectServerApplyParam{serverId: $serverId, accid: $accid, postscript: $postscript}';
  }
}

@JsonSerializable()
class QChatKickServerMembersParam {
  /// 服务器Id，必填
  final int serverId;

  /// 被踢用户的accid列表，必填
  final List<String> accids;

  QChatKickServerMembersParam(this.serverId, this.accids);

  factory QChatKickServerMembersParam.fromJson(Map<String, dynamic> json) =>
      _$QChatKickServerMembersParamFromJson(json);

  Map<String, dynamic> toJson() => _$QChatKickServerMembersParamToJson(this);

  @override
  String toString() {
    return 'QChatKickServerMembersParam{serverId: $serverId, accids: $accids}';
  }
}

@JsonSerializable()
class QChatLeaveServerParam {
  /// 服务器Id
  final int serverId;

  QChatLeaveServerParam(this.serverId);

  factory QChatLeaveServerParam.fromJson(Map<String, dynamic> json) =>
      _$QChatLeaveServerParamFromJson(json);

  Map<String, dynamic> toJson() => _$QChatLeaveServerParamToJson(this);

  @override
  String toString() {
    return 'QChatLeaveServerParam{serverId: $serverId}';
  }
}

@JsonSerializable(explicitToJson: true)
class QChatUpdateMyMemberInfoParam extends QChatAntiSpamConfigParam {
  /// 服务器id，必填
  final int serverId;

  /// 昵称
  String? nick;

  /// 头像
  String? avatar;

  /// 自定义扩展
  String? custom;

  QChatUpdateMyMemberInfoParam(this.serverId);

  factory QChatUpdateMyMemberInfoParam.fromJson(Map<String, dynamic> json) =>
      _$QChatUpdateMyMemberInfoParamFromJson(json);

  Map<String, dynamic> toJson() => _$QChatUpdateMyMemberInfoParamToJson(this);

  @override
  String toString() {
    return 'QChatUpdateMyMemberInfoParam{serverId: $serverId, nick: $nick, avatar: $avatar, custom: $custom}';
  }
}

@JsonSerializable(explicitToJson: true)
class QChatUpdateMyMemberInfoResult {
  /// 更新后的服务器成员
  @JsonKey(fromJson: memberFromJson)
  final QChatServerMember? member;

  QChatUpdateMyMemberInfoResult(this.member);

  factory QChatUpdateMyMemberInfoResult.fromJson(Map<String, dynamic> json) =>
      _$QChatUpdateMyMemberInfoResultFromJson(json);

  Map<String, dynamic> toJson() => _$QChatUpdateMyMemberInfoResultToJson(this);

  @override
  String toString() {
    return 'QChatUpdateMyMemberInfoResult{member: $member}';
  }
}

@JsonSerializable(explicitToJson: true)
class QChatGetServerMembersParam {
  /// 查询的服务器成员列表，必填，Pair.first填serverId，Pair.second填accid
  @JsonKey(fromJson: _serverIdAccidPairListFromMap)
  final List<PairIntWithString> serverIdAccidPairList;

  QChatGetServerMembersParam(this.serverIdAccidPairList);

  factory QChatGetServerMembersParam.fromJson(Map<String, dynamic> json) =>
      _$QChatGetServerMembersParamFromJson(json);

  Map<String, dynamic> toJson() => _$QChatGetServerMembersParamToJson(this);

  @override
  String toString() {
    return 'QChatGetServerMembersParam{serverIdAccidPairList: $serverIdAccidPairList}';
  }
}

@JsonSerializable(explicitToJson: true)
class QChatGetServerMembersResult {
  ///  查询到的频道成员
  @JsonKey(fromJson: _memberListFromJson)
  final List<QChatServerMember>? serverMembers;

  QChatGetServerMembersResult(this.serverMembers);

  factory QChatGetServerMembersResult.fromJson(Map<String, dynamic> json) =>
      _$QChatGetServerMembersResultFromJson(json);

  Map<String, dynamic> toJson() => _$QChatGetServerMembersResultToJson(this);

  @override
  String toString() {
    return 'QChatGetServerMembersResult{serverMembers: $serverMembers}';
  }
}

QChatServerMember? memberFromJson(Map? map) {
  if (map == null) {
    return null;
  }
  return QChatServerMember.fromJson(map.cast<String, dynamic>());
}

List<QChatServerMember>? _memberListFromJson(List<dynamic>? dataList) {
  return dataList
      ?.map(
          (e) => QChatServerMember.fromJson((e as Map).cast<String, dynamic>()))
      .toList();
}

@JsonSerializable(explicitToJson: true)
class QChatServerMember {
  /// 服务器id
  int? serverId = 0;

  /// accid
  String? accid;

  /// 昵称
  String? nick;

  /// 头像
  String? avatar;

  /// 自定义扩展
  String? custom;

  /// 类型：[QChatMemberType.normal]-普通成员，[QChatMemberType.owner]-所有者
  QChatMemberType? type = QChatMemberType.normal;

  /// 加入时间
  int? joinTime = 0;

  /// 邀请人
  String? inviter;

  /// 有效标志
  bool? valid = false;

  /// 创建时间
  int? createTime = 0;

  /// 更新时间
  int? updateTime = 0;

  QChatServerMember({this.valid = false});

  factory QChatServerMember.fromJson(Map<String, dynamic> json) =>
      _$QChatServerMemberFromJson(json);

  Map<String, dynamic> toJson() => _$QChatServerMemberToJson(this);

  @override
  String toString() {
    return 'QChatServerMember{serverId: $serverId, accid: $accid, nick: $nick, avatar: $avatar, custom: $custom, type: $type, joinTime: $joinTime, inviter: $inviter, valid: $valid, createTime: $createTime, updateTime: $updateTime}';
  }
}

@JsonSerializable()
class QChatGetServerMembersByPageParam {
  /// 服务器Id
  final int serverId;

  /// 查询锚点时间戳
  final int timeTag;

  /// 查询数量限制
  final int limit;

  QChatGetServerMembersByPageParam(this.serverId, this.timeTag, this.limit);

  factory QChatGetServerMembersByPageParam.fromJson(
          Map<String, dynamic> json) =>
      _$QChatGetServerMembersByPageParamFromJson(json);

  Map<String, dynamic> toJson() =>
      _$QChatGetServerMembersByPageParamToJson(this);

  @override
  String toString() {
    return 'QChatGetServerMembersByPageParam{serverId: $serverId, timeTag: $timeTag, limit: $limit}';
  }
}

@JsonSerializable(explicitToJson: true)
class QChatGetServerMembersByPageResult extends QChatGetByPageResult {
  /// 查询到的频道成员
  @JsonKey(fromJson: _memberListFromJson)
  final List<QChatServerMember>? serverMembers;

  QChatGetServerMembersByPageResult(
      bool? hasMore, int? nextTimeTag, this.serverMembers)
      : super(hasMore: hasMore ?? false, nextTimeTag: nextTimeTag);

  factory QChatGetServerMembersByPageResult.fromJson(
          Map<String, dynamic> json) =>
      _$QChatGetServerMembersByPageResultFromJson(json);

  Map<String, dynamic> toJson() =>
      _$QChatGetServerMembersByPageResultToJson(this);

  @override
  String toString() {
    return 'QChatGetServerMembersByPageResult{hasMore: $hasMore, nextTimeTag: $nextTimeTag, serverMembers: $serverMembers}';
  }
}

@JsonSerializable(explicitToJson: true)
class QChatSearchServerByPageParam {
  /// 检索关键字，目标检索服务器名称
  final String keyword;

  /// 排序规则 true：正序；false：反序
  bool? asc;

  /// 搜索类型，[QChatSearchServerTypeEnum]
  final QChatSearchServerTypeEnum searchType;

  ///  查询时间范围的开始时间
  int? startTime;

  /// 查询时间范围的结束时间，要求比开始时间大
  int? endTime;

  /// 检索返回的最大记录数，最大和默认都是100
  int? limit;

  /// 服务器类型
  List<int?>? serverTypes;

  /// 排序条件
  QChatServerSearchSortEnum? sort;

  /// 查询游标，下次查询的起始位置,第一页设置为null，查询下一页是传入上一页返回的cursor
  String? cursor;

  QChatSearchServerByPageParam(this.keyword, this.asc, this.searchType,
      {this.startTime,
      this.endTime,
      this.limit,
      this.serverTypes,
      this.sort,
      this.cursor});

  factory QChatSearchServerByPageParam.fromJson(Map<String, dynamic> json) =>
      _$QChatSearchServerByPageParamFromJson(json);

  Map<String, dynamic> toJson() => _$QChatSearchServerByPageParamToJson(this);

  /// 是否合法
  bool isValid() {
    if (keyword.isEmpty) {
      return false;
    }
    if (searchType == QChatSearchServerTypeEnum.undefined) {
      return false;
    }
    if (startTime != null && startTime! < 0) {
      return false;
    }

    if (endTime != null && endTime! < 0) {
      return false;
    }

    if (limit != null && limit! < 0) {
      return false;
    }

    if (serverTypes == null || serverTypes!.isEmpty) {
      return false;
    } else if (serverTypes!.any((element) => element == null || element < 0)) {
      return false;
    }
    return true;
  }
}

enum QChatSearchServerTypeEnum {
  /// 未定义类型
  undefined,

  /// 广场搜索
  square,

  /// 个人服务器搜索
  personal
}

extension QChatSearchServerTypeEnumExtension on QChatSearchServerTypeEnum {
  int value() {
    int result = -1;
    switch (this) {
      case QChatSearchServerTypeEnum.undefined:
        result = -1;
        break;
      case QChatSearchServerTypeEnum.square:
        result = 1;
        break;
      case QChatSearchServerTypeEnum.personal:
        result = 2;
        break;
    }
    return result;
  }

  static QChatSearchServerTypeEnum? typeOfValue(int value) {
    for (QChatSearchServerTypeEnum e in QChatSearchServerTypeEnum.values) {
      if (e.value() == value) {
        return e;
      }
    }
    return null;
  }
}

/// 服务器搜索排序条件
enum QChatServerSearchSortEnum {
  /// 自定义权重排序
  reorderWeight,

  /// 创建时间，默认
  createTime,

  /// 服务器总人数
  totalMember
}

extension QChatServerSearchSortEnumExtension on QChatServerSearchSortEnum {
  int value() {
    int result = -1;
    switch (this) {
      case QChatServerSearchSortEnum.reorderWeight:
        result = 0;
        break;
      case QChatServerSearchSortEnum.createTime:
        result = 1;
        break;
      case QChatServerSearchSortEnum.totalMember:
        result = 2;
        break;
    }
    return result;
  }

  static QChatServerSearchSortEnum? typeOfValue(int value) {
    for (QChatServerSearchSortEnum e in QChatServerSearchSortEnum.values) {
      if (e.value() == value) {
        return e;
      }
    }
    return null;
  }
}

@JsonSerializable(explicitToJson: true)
class QChatSearchServerByPageResult extends QChatGetByPageWithCursorResult {
  /// 查询到的服务器
  @JsonKey(fromJson: _serverListFromJsonNullable)
  final List<QChatServer>? servers;

  QChatSearchServerByPageResult(this.servers, bool? hasMore, int? nextTimeTag,
      [String? cursor])
      : super(hasMore, nextTimeTag, cursor);

  factory QChatSearchServerByPageResult.fromJson(Map<String, dynamic> json) =>
      _$QChatSearchServerByPageResultFromJson(json);

  Map<String, dynamic> toJson() => _$QChatSearchServerByPageResultToJson(this);

  @override
  String toString() {
    return 'QChatSearchServerByPageResult{servers: $servers,hasMore: $hasMore, nextTimeTag: $nextTimeTag, cursor: $cursor}';
  }
}

List<PairIntWithString> _serverIdAccidPairListFromMap(List<dynamic> dataList) {
  return dataList
      .map(
          (e) => PairIntWithString.fromJson((e as Map).cast<String, dynamic>()))
      .toList();
}

@JsonSerializable()
class PairIntWithString {
  final int? first;
  final String? second;

  PairIntWithString(this.first, this.second);

  factory PairIntWithString.fromJson(Map<String, dynamic> json) =>
      _$PairIntWithStringFromJson(json);

  Map<String, dynamic> toJson() => _$PairIntWithStringToJson(this);

  @override
  String toString() {
    return 'PairIntWithString{first: $first, second: $second}';
  }
}

@JsonSerializable(explicitToJson: true)
class QChatUpdateServerMemberInfoParam extends QChatAntiSpamConfigParam {
  /// 服务器id，必填
  final int serverId;

  /// 被修改信息的服务器成员的accid，必填
  final String accid;

  /// 昵称
  String? nick;

  /// 头像
  String? avatar;

  QChatUpdateServerMemberInfoParam(this.serverId, this.accid,
      {this.nick, this.avatar});

  factory QChatUpdateServerMemberInfoParam.fromJson(
          Map<String, dynamic> json) =>
      _$QChatUpdateServerMemberInfoParamFromJson(json);

  Map<String, dynamic> toJson() =>
      _$QChatUpdateServerMemberInfoParamToJson(this);

  @override
  String toString() {
    return 'QChatUpdateServerMemberInfoParam{serverId: $serverId, accid: $accid, nick: $nick, avatar: $avatar}';
  }
}

@JsonSerializable(explicitToJson: true)
class QChatUpdateServerMemberInfoResult {
  /// 更新后的服务器成员
  @JsonKey(fromJson: memberFromJson)
  QChatServerMember? member;

  QChatUpdateServerMemberInfoResult(this.member);

  factory QChatUpdateServerMemberInfoResult.fromJson(
          Map<String, dynamic> json) =>
      _$QChatUpdateServerMemberInfoResultFromJson(json);

  Map<String, dynamic> toJson() =>
      _$QChatUpdateServerMemberInfoResultToJson(this);

  @override
  String toString() {
    return 'QChatUpdateServerMemberInfoResult{member: $member}';
  }
}

@JsonSerializable(explicitToJson: true)
class QChatBanServerMemberParam extends QChatUpdateServerMemberBanParam {
  QChatBanServerMemberParam(int? serverId, String? targetAccid,
      [String? customExt])
      : super(serverId, targetAccid, customExt);

  factory QChatBanServerMemberParam.fromJson(Map<String, dynamic> json) =>
      _$QChatBanServerMemberParamFromJson(json);

  Map<String, dynamic> toJson() => _$QChatBanServerMemberParamToJson(this);
}

@JsonSerializable(explicitToJson: true)
class QChatUnbanServerMemberParam extends QChatUpdateServerMemberBanParam {
  QChatUnbanServerMemberParam(int? serverId, String? targetAccid,
      [String? customExt])
      : super(serverId, targetAccid, customExt);

  factory QChatUnbanServerMemberParam.fromJson(Map<String, dynamic> json) =>
      _$QChatUnbanServerMemberParamFromJson(json);

  Map<String, dynamic> toJson() => _$QChatUnbanServerMemberParamToJson(this);
}

abstract class QChatUpdateServerMemberBanParam {
  /// 服务器id
  final int? serverId;

  /// 目标用户accid
  final String? targetAccid;

  /// 自定义扩展
  String? customExt;

  QChatUpdateServerMemberBanParam(this.serverId, this.targetAccid,
      [this.customExt]);

  @override
  String toString() {
    return 'QChatUpdateServerMemberBanParam{serverId: $serverId, targetAccid: $targetAccid, customExt: $customExt}';
  }
}

@JsonSerializable()
class QChatGetBannedServerMembersByPageParam {
  /// 服务器id
  final int serverId;

  /// 查询时间戳，如果传0表示当前时间
  final int timeTag;

  /// 查询数量限制，默认100
  final int? limit;

  QChatGetBannedServerMembersByPageParam(this.serverId, this.timeTag,
      [this.limit]);

  factory QChatGetBannedServerMembersByPageParam.fromJson(
          Map<String, dynamic> json) =>
      _$QChatGetBannedServerMembersByPageParamFromJson(json);

  Map<String, dynamic> toJson() =>
      _$QChatGetBannedServerMembersByPageParamToJson(this);
}

@JsonSerializable(explicitToJson: true)
class QChatGetBannedServerMembersByPageResult extends QChatGetByPageResult {
  /// 服务器成员封禁列表
  @JsonKey(fromJson: _serverMemberBanInfoListNullable)
  final List<QChatBannedServerMember>? serverMemberBanInfoList;

  QChatGetBannedServerMembersByPageResult(
      bool? hasMore, int? nextTimeTag, this.serverMemberBanInfoList)
      : super(hasMore: hasMore ?? false, nextTimeTag: nextTimeTag);

  factory QChatGetBannedServerMembersByPageResult.fromJson(
          Map<String, dynamic> json) =>
      _$QChatGetBannedServerMembersByPageResultFromJson(json);

  Map<String, dynamic> toJson() =>
      _$QChatGetBannedServerMembersByPageResultToJson(this);

  @override
  String toString() {
    return 'QChatGetBannedServerMembersByPageResult{serverMemberBanInfoList: $serverMemberBanInfoList}';
  }
}

List<QChatBannedServerMember>? _serverMemberBanInfoListNullable(
    List<dynamic>? dataList) {
  return dataList
      ?.map((e) =>
          QChatBannedServerMember.fromJson((e as Map).cast<String, dynamic>()))
      .toList();
}

@JsonSerializable()
class QChatBannedServerMember {
  /// 服务器id
  int? serverId;

  /// 用户accid
  String? accid;

  /// 自定义扩展
  String? custom;

  /// 封禁时间
  int? banTime;

  /// 有效标志：false-无效，true-有效
  bool? isValid;

  /// 创建时间
  int? createTime;

  /// 更新时间
  int? updateTime;

  QChatBannedServerMember();

  factory QChatBannedServerMember.fromJson(Map<String, dynamic> json) =>
      _$QChatBannedServerMemberFromJson(json);

  Map<String, dynamic> toJson() => _$QChatBannedServerMemberToJson(this);

  @override
  String toString() {
    return 'QChatBannedServerMember{serverId: $serverId, accid: $accid, custom: $custom, banTime: $banTime, isValid: $isValid, createTime: $createTime, updateTime: $updateTime}';
  }
}

@JsonSerializable(explicitToJson: true)
class QChatUpdateUserServerPushConfigParam
    extends QChatUpdateUserPushConfigParam {
  /// 服务器Id，必填
  final int serverId;

  QChatUpdateUserServerPushConfigParam(
      this.serverId, QChatPushMsgType pushMsgType)
      : super(pushMsgType);

  factory QChatUpdateUserServerPushConfigParam.fromJson(
          Map<String, dynamic> json) =>
      _$QChatUpdateUserServerPushConfigParamFromJson(json);

  Map<String, dynamic> toJson() =>
      _$QChatUpdateUserServerPushConfigParamToJson(this);

  @override
  String toString() {
    return 'QChatUpdateUserServerPushConfigParam{serverId: $serverId}';
  }
}

@JsonSerializable()
class QChatGetUserServerPushConfigsParam {
  /// serverId列表
  final List<int> serverIdList;

  QChatGetUserServerPushConfigsParam(this.serverIdList);

  factory QChatGetUserServerPushConfigsParam.fromJson(
          Map<String, dynamic> json) =>
      _$QChatGetUserServerPushConfigsParamFromJson(json);

  Map<String, dynamic> toJson() =>
      _$QChatGetUserServerPushConfigsParamToJson(this);

  @override
  String toString() {
    return 'QChatGetUserServerPushConfigsParam{serverIdList: $serverIdList}';
  }
}

@JsonSerializable(explicitToJson: true)
class QChatGetUserPushConfigsResult {
  /// 查询到的用户推送配置
  @JsonKey(fromJson: _userPushConfigsNullable)
  final List<QChatUserPushConfig>? userPushConfigs;

  QChatGetUserPushConfigsResult(this.userPushConfigs);

  factory QChatGetUserPushConfigsResult.fromJson(Map<String, dynamic> json) =>
      _$QChatGetUserPushConfigsResultFromJson(json);

  Map<String, dynamic> toJson() => _$QChatGetUserPushConfigsResultToJson(this);

  @override
  String toString() {
    return 'QChatGetUserPushConfigsResult{userPushConfigs: $userPushConfigs}';
  }
}

List<QChatUserPushConfig>? _userPushConfigsNullable(List<dynamic>? dataList) {
  return dataList
      ?.map((e) =>
          QChatUserPushConfig.fromJson((e as Map).cast<String, dynamic>()))
      .toList();
}

@JsonSerializable()
class QChatUserPushConfig {
  /// 服务器id
  int? serverId;

  /// 频道id
  int? channelId;

  /// 频道分组id
  int? channelCategoryId;

  /// 推送维度
  QChatDimension? dimension;

  /// 推送接收哪些消息类型
  QChatPushMsgType? pushMsgType;

  QChatUserPushConfig();

  factory QChatUserPushConfig.fromJson(Map<String, dynamic> json) =>
      _$QChatUserPushConfigFromJson(json);

  Map<String, dynamic> toJson() => _$QChatUserPushConfigToJson(this);

  @override
  String toString() {
    return 'QChatUserPushConfig{serverId: $serverId, channelId: $channelId, channelCategoryId: $channelCategoryId, dimension: $dimension, pushMsgType: $pushMsgType}';
  }
}

enum QChatDimension {
  /// 频道维度
  channel,

  /// 服务器维度
  server,

  /// 频道分组维度
  channelCategory
}

@JsonSerializable()
class QChatSearchServerMemberByPageParam {
  /// 检索关键字，目标检索昵称、账号，最大100个字符
  final String keyword;

  /// 服务器ID
  final int serverId;

  /// 检索返回的最大记录数，最大和默认都是100
  int? limit;

  QChatSearchServerMemberByPageParam(this.keyword, this.serverId, [this.limit]);

  factory QChatSearchServerMemberByPageParam.fromJson(
          Map<String, dynamic> json) =>
      _$QChatSearchServerMemberByPageParamFromJson(json);

  Map<String, dynamic> toJson() =>
      _$QChatSearchServerMemberByPageParamToJson(this);

  @override
  String toString() {
    return 'QChatSearchServerMemberByPageParam{keyword: $keyword, serverId: $serverId, limit: $limit}';
  }
}

@JsonSerializable(explicitToJson: true)
class QChatSearchServerMemberByPageResult {
  /// 查询到的服务器成员
  @JsonKey(fromJson: _memberListFromJson)
  final List<QChatServerMember>? members;

  QChatSearchServerMemberByPageResult(this.members);

  factory QChatSearchServerMemberByPageResult.fromJson(
          Map<String, dynamic> json) =>
      _$QChatSearchServerMemberByPageResultFromJson(json);

  Map<String, dynamic> toJson() =>
      _$QChatSearchServerMemberByPageResultToJson(this);

  @override
  String toString() {
    return 'QChatSearchServerMemberByPageResult{members: $members}';
  }
}

@JsonSerializable()
class QChatGetInviteApplyRecordOfServerParam {
  /// 服务器ID
  final int serverId;

  /// 开始时间戳
  int? fromTime;

  /// 结束时间戳
  int? toTime;

  /// 是否逆序，同历史消息查询，默认从现在查到过去
  bool? reverse;

  /// 最大数量限制，默认100，最大100
  int? limit;

  /// 排除id
  int? excludeRecordId;

  QChatGetInviteApplyRecordOfServerParam(this.serverId,
      {this.fromTime,
      this.toTime,
      this.reverse,
      this.limit,
      this.excludeRecordId});

  factory QChatGetInviteApplyRecordOfServerParam.fromJson(
          Map<String, dynamic> json) =>
      _$QChatGetInviteApplyRecordOfServerParamFromJson(json);

  Map<String, dynamic> toJson() =>
      _$QChatGetInviteApplyRecordOfServerParamToJson(this);

  @override
  String toString() {
    return 'QChatGetInviteApplyRecordOfServerParam{serverId: $serverId, fromTime: $fromTime, toTime: $toTime, reverse: $reverse, limit: $limit, excludeRecordId: $excludeRecordId}';
  }
}

@JsonSerializable(explicitToJson: true)
class QChatGetInviteApplyRecordOfServerResult {
  /// 申请邀请记录
  @JsonKey(fromJson: _recordsNullable)
  final List<QChatInviteApplyRecord>? records;

  QChatGetInviteApplyRecordOfServerResult(this.records);

  factory QChatGetInviteApplyRecordOfServerResult.fromJson(
          Map<String, dynamic> json) =>
      _$QChatGetInviteApplyRecordOfServerResultFromJson(json);

  Map<String, dynamic> toJson() =>
      _$QChatGetInviteApplyRecordOfServerResultToJson(this);

  @override
  String toString() {
    return 'QChatGetInviteApplyRecordOfServerResult{records: $records}';
  }
}

@JsonSerializable(explicitToJson: true)
class QChatInviteApplyRecord {
  /// 操作者账号
  String? accid;

  /// 申请/邀请记录类型
  QChatInviteApplyRecordType? type;

  /// 服务器Id
  int? serverId;

  /// 申请/邀请记录状态
  QChatInviteApplyRecordStatus? status;

  /// 申请/邀请唯一标识
  int? requestId;

  /// 创建时间
  int? createTime;

  /// 更新时间
  int? updateTime;

  /// 过期时间
  int? expireTime;

  /// 邀请申请信息结果数据
  @JsonKey(fromJson: _applyRecordDataNullable)
  QChatInviteApplyRecordData? data;

  /// 记录唯一标识
  int? recordId;

  QChatInviteApplyRecord();

  factory QChatInviteApplyRecord.fromJson(Map<String, dynamic> json) =>
      _$QChatInviteApplyRecordFromJson(json);

  Map<String, dynamic> toJson() => _$QChatInviteApplyRecordToJson(this);

  @override
  String toString() {
    return 'QChatInviteApplyRecord{accid: $accid, type: $type, serverId: $serverId, status: $status, requestId: $requestId, createTime: $createTime, updateTime: $updateTime, expireTime: $expireTime, data: $data, recordId: $recordId}';
  }
}

QChatInviteApplyRecordData? _applyRecordDataNullable(Map? map) {
  if (map == null) {
    return null;
  }
  return QChatInviteApplyRecordData.fromJson(map.cast<String, dynamic>());
}

@JsonSerializable(explicitToJson: true)
class QChatInviteApplyRecordData {
  /// 申请附言
  String? applyPostscript;

  /// 处理申请的accid（同意或拒绝申请的操作者accid）
  String? updateAccid;

  /// 处理申请/邀请的附言
  String? updatePostscript;

  /// 邀请附言
  String? invitePostscript;

  /// 邀请码
  String? inviteCode;

  /// 被邀请用户数量
  int? invitedUserCount;

  /// 被邀请用户信息
  @JsonKey(fromJson: _invitedUsersNullable)
  List<QChatInvitedUserInfo>? invitedUsers;

  QChatInviteApplyRecordData();

  factory QChatInviteApplyRecordData.fromJson(Map<String, dynamic> json) =>
      _$QChatInviteApplyRecordDataFromJson(json);

  Map<String, dynamic> toJson() => _$QChatInviteApplyRecordDataToJson(this);

  @override
  String toString() {
    return 'QChatInviteApplyRecordData{applyPostscript: $applyPostscript, updateAccid: $updateAccid, updatePostscript: $updatePostscript, invitePostscript: $invitePostscript, inviteCode: $inviteCode, invitedUserCount: $invitedUserCount, invitedUsers: $invitedUsers}';
  }
}

List<QChatInvitedUserInfo>? _invitedUsersNullable(List<dynamic>? dataList) {
  return dataList
      ?.map((e) =>
          QChatInvitedUserInfo.fromJson((e as Map).cast<String, dynamic>()))
      .toList();
}

@JsonSerializable()
class QChatInvitedUserInfo {
  /// 被邀请用户的accid
  String? accid;

  /// 被邀请用户当前的状态
  QChatInviteApplyRecordStatus? status;

  /// 处理邀请的附言
  String? updatePostscript;

  /// 处理邀请的时间
  int? updateTime;

  QChatInvitedUserInfo();

  factory QChatInvitedUserInfo.fromJson(Map<String, dynamic> json) =>
      _$QChatInvitedUserInfoFromJson(json);

  Map<String, dynamic> toJson() => _$QChatInvitedUserInfoToJson(this);

  @override
  String toString() {
    return 'QChatInvitedUserInfo{accid: $accid, status: $status, updatePostscript: $updatePostscript, updateTime: $updateTime}';
  }
}

enum QChatInviteApplyRecordType {
  /// 申请
  apply,

  /// 邀请
  invite,

  /// 被邀请
  beInvited,

  /// 生成邀请码
  generateInviteCode,

  /// 通过邀请码加入
  joinByInviteCode,
}

enum QChatInviteApplyRecordStatus {
  /// 初始状态
  initial,

  /// 同意
  accept,

  /// 拒绝
  reject,

  /// 通过其他操作同意
  acceptByOther,

  /// 通过其他操作拒绝
  rejectByOther,

  /// 自动加入
  autoJoin,

  /// 过期
  expired
}

@JsonSerializable()
class QChatGetInviteApplyRecordOfSelfParam {
  /// 开始时间戳
  int? fromTime;

  /// 结束时间戳
  int? toTime;

  /// 是否逆序，同历史消息查询，默认从现在查到过去
  bool? reverse;

  /// limit，默认100，最大100
  int? limit;

  /// 排除id
  int? excludeRecordId;

  factory QChatGetInviteApplyRecordOfSelfParam.fromJson(
          Map<String, dynamic> json) =>
      _$QChatGetInviteApplyRecordOfSelfParamFromJson(json);

  Map<String, dynamic> toJson() =>
      _$QChatGetInviteApplyRecordOfSelfParamToJson(this);

  QChatGetInviteApplyRecordOfSelfParam(
      {this.fromTime,
      this.toTime,
      this.reverse,
      this.limit,
      this.excludeRecordId});

  @override
  String toString() {
    return 'QChatGetInviteApplyRecordOfSelfParam{fromTime: $fromTime, toTime: $toTime, reverse: $reverse, limit: $limit, excludeRecordId: $excludeRecordId}';
  }
}

@JsonSerializable(explicitToJson: true)
class QChatGetInviteApplyRecordOfSelfResult {
  /// 申请邀请记录
  @JsonKey(fromJson: _recordsNullable)
  final List<QChatInviteApplyRecord>? records;

  QChatGetInviteApplyRecordOfSelfResult(this.records);

  factory QChatGetInviteApplyRecordOfSelfResult.fromJson(
          Map<String, dynamic> json) =>
      _$QChatGetInviteApplyRecordOfSelfResultFromJson(json);

  Map<String, dynamic> toJson() =>
      _$QChatGetInviteApplyRecordOfSelfResultToJson(this);

  @override
  String toString() {
    return 'QChatGetInviteApplyRecordOfSelfResult{records: $records}';
  }
}

List<QChatInviteApplyRecord>? _recordsNullable(List<dynamic>? dataList) {
  return dataList
      ?.map((e) =>
          QChatInviteApplyRecord.fromJson((e as Map).cast<String, dynamic>()))
      .toList();
}

@JsonSerializable()
class QChatServerMarkReadParam {
  /// serverId列表
  final List<int> serverIds;

  QChatServerMarkReadParam(this.serverIds);

  factory QChatServerMarkReadParam.fromJson(Map<String, dynamic> json) =>
      _$QChatServerMarkReadParamFromJson(json);

  Map<String, dynamic> toJson() => _$QChatServerMarkReadParamToJson(this);

  @override
  String toString() {
    return 'QChatServerMarkReadParam{serverIds: $serverIds}';
  }
}

@JsonSerializable()
class QChatServerMarkReadResult {
  /// 清空未读数成功的serverId列表
  final List<int>? successServerIds;

  /// 清空未读数失败的serverId列表
  final List<int>? failedServerIds;

  /// 清空未读的服务器时间戳，这个时间戳之前的频道消息都认为是已读
  final int? timestamp;

  QChatServerMarkReadResult(
      this.successServerIds, this.failedServerIds, this.timestamp);

  factory QChatServerMarkReadResult.fromJson(Map<String, dynamic> json) =>
      _$QChatServerMarkReadResultFromJson(json);

  Map<String, dynamic> toJson() => _$QChatServerMarkReadResultToJson(this);

  @override
  String toString() {
    return 'QChatServerMarkReadResult{successServerIds: $successServerIds, failedServerIds: $failedServerIds, timestamp: $timestamp}';
  }
}

@JsonSerializable(explicitToJson: true)
class QChatSubscribeAllChannelParam {
  /// 请求参数，订阅类型，见[QChatSubType],只支持[QChatSubscribeType.channelMsg],
  /// [QChatSubscribeType.channelMsgUnreadCount],
  /// [QChatSubscribeType.channelMsgUnreadStatus]
  final QChatSubscribeType type;

  /// 请求参数，操作的对象：serverId列表
  final List<int> serverIds;

  QChatSubscribeAllChannelParam(this.type, this.serverIds);

  factory QChatSubscribeAllChannelParam.fromJson(Map<String, dynamic> json) =>
      _$QChatSubscribeAllChannelParamFromJson(json);

  Map<String, dynamic> toJson() => _$QChatSubscribeAllChannelParamToJson(this);

  @override
  String toString() {
    return 'QChatSubscribeAllChannelParam{type: $type, serverIds: $serverIds}';
  }
}

@JsonSerializable(explicitToJson: true)
class QChatSubscribeAllChannelResult {
  /// 订阅成功后的未读信息列表
  @JsonKey(fromJson: _unreadInfoListNullable)
  final List<QChatUnreadInfo>? unreadInfoList;

  /// 订阅失败的服务器id列表
  @JsonKey(fromJson: _failedListNullable)
  final List<int>? failedList;

  QChatSubscribeAllChannelResult(this.unreadInfoList, this.failedList);

  factory QChatSubscribeAllChannelResult.fromJson(Map<String, dynamic> json) =>
      _$QChatSubscribeAllChannelResultFromJson(json);

  Map<String, dynamic> toJson() => _$QChatSubscribeAllChannelResultToJson(this);

  @override
  String toString() {
    return 'QChatSubscribeAllChannelResult{unreadInfoList: $unreadInfoList, failedList: $failedList}';
  }
}

List<QChatUnreadInfo>? _unreadInfoListNullable(List<dynamic>? dataList) {
  return dataList
      ?.map((e) => QChatUnreadInfo.fromJson((e as Map).cast<String, dynamic>()))
      .toList();
}

List<int>? _failedListNullable(List<dynamic>? dataList) {
  return dataList?.map((e) => e is int ? e : int.parse(e)).toList();
}

@JsonSerializable(explicitToJson: true)
class QChatSubscribeServerAsVisitorParam {
  /// 请求参数，操作类型，见[QChatSubscribeOperateType]
  final QChatSubscribeOperateType operateType;

  /// 请求参数，操作的对象：serverId列表
  final List<int> serverIds;

  QChatSubscribeServerAsVisitorParam(this.operateType, this.serverIds);

  factory QChatSubscribeServerAsVisitorParam.fromJson(
          Map<String, dynamic> json) =>
      _$QChatSubscribeServerAsVisitorParamFromJson(json);

  Map<String, dynamic> toJson() =>
      _$QChatSubscribeServerAsVisitorParamToJson(this);
}

@JsonSerializable()
class QChatSubscribeServerAsVisitorResult {
  /// 订阅失败的服务器id列表
  @JsonKey(fromJson: _failedListNullable)
  final List<int>? failedList;

  QChatSubscribeServerAsVisitorResult(this.failedList);

  factory QChatSubscribeServerAsVisitorResult.fromJson(
          Map<String, dynamic> json) =>
      _$QChatSubscribeServerAsVisitorResultFromJson(json);

  Map<String, dynamic> toJson() =>
      _$QChatSubscribeServerAsVisitorResultToJson(this);
}

@JsonSerializable()
class QChatEnterServerAsVisitorParam {
  /// serverId列表，最多10个
  final List<int> serverIds;

  QChatEnterServerAsVisitorParam(this.serverIds);

  factory QChatEnterServerAsVisitorParam.fromJson(Map<String, dynamic> json) =>
      _$QChatEnterServerAsVisitorParamFromJson(json);

  Map<String, dynamic> toJson() => _$QChatEnterServerAsVisitorParamToJson(this);
}

@JsonSerializable()
class QChatEnterServerAsVisitorResult {
  /// 失败的服务器Id列表
  @JsonKey(fromJson: _failedListNullable)
  final List<int>? failedList;

  QChatEnterServerAsVisitorResult(this.failedList);

  factory QChatEnterServerAsVisitorResult.fromJson(Map<String, dynamic> json) =>
      _$QChatEnterServerAsVisitorResultFromJson(json);

  Map<String, dynamic> toJson() =>
      _$QChatEnterServerAsVisitorResultToJson(this);
}

@JsonSerializable()
class QChatLeaveServerAsVisitorParam {
  /// serverId列表，最多10个
  final List<int> serverIds;

  QChatLeaveServerAsVisitorParam(this.serverIds);

  factory QChatLeaveServerAsVisitorParam.fromJson(Map<String, dynamic> json) =>
      _$QChatLeaveServerAsVisitorParamFromJson(json);

  Map<String, dynamic> toJson() => _$QChatLeaveServerAsVisitorParamToJson(this);
}

@JsonSerializable()
class QChatLeaveServerAsVisitorResult {
  /// 失败的服务器Id列表
  @JsonKey(fromJson: _failedListNullable)
  final List<int>? failedList;

  QChatLeaveServerAsVisitorResult(this.failedList);

  factory QChatLeaveServerAsVisitorResult.fromJson(Map<String, dynamic> json) =>
      _$QChatLeaveServerAsVisitorResultFromJson(json);

  Map<String, dynamic> toJson() =>
      _$QChatLeaveServerAsVisitorResultToJson(this);
}
