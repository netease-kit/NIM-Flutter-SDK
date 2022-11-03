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

  /// 获取过期时间戳
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
