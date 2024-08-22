// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:json_annotation/json_annotation.dart';

import '../../../nim_core_v2_platform_interface.dart';

part 'friend_models.g.dart';

/// 好友信息
@JsonSerializable(explicitToJson: true)
class NIMFriend {
  /// 好友账号ID
  String accountId;

  /// 好友备注 长度限制：128字符
  String? alias;

  /// 用户扩展字段，建议使用json格式，可客户端，OpenApi设置 长度限制：256字符
  String? serverExtension;

  /// 用户扩展字段，建议使用json格式，仅OpenApi设置 长度限制：256字符
  String? customerExtension;

  /// 好友信息创建时间
  int createTime;

  /// 好友信息更新时间
  int? updateTime;

  /// 获取好友对应的用户信息
  @JsonKey(fromJson: _nimUserInfoFromJson)
  NIMUserInfo? userProfile;

  NIMFriend(
      {required this.accountId,
      this.alias,
      this.serverExtension,
      this.customerExtension,
      required this.createTime,
      this.updateTime,
      this.userProfile});

  Map<String, dynamic> toJson() => _$NIMFriendToJson(this);

  factory NIMFriend.fromJson(Map<String, dynamic> map) =>
      _$NIMFriendFromJson(map);
}

NIMUserInfo? _nimUserInfoFromJson(Map? map) {
  if (map != null) {
    return NIMUserInfo.fromJson(map.cast<String, dynamic>());
  }
  return null;
}

/// 添加好友参数
@JsonSerializable(explicitToJson: true)
class NIMFriendAddParams {
  /// 添加好友模式
  NIMFriendAddMode addMode;

  /// 添加/申请添加好友的附言
  String? postscript;

  NIMFriendAddParams({required this.addMode, this.postscript});

  Map<String, dynamic> toJson() => _$NIMFriendAddParamsToJson(this);

  factory NIMFriendAddParams.fromJson(Map<String, dynamic> map) =>
      _$NIMFriendAddParamsFromJson(map);
}

enum NIMFriendAddMode {
  /// 直接添加对方为好友
  @JsonValue(1)
  nimFriendModeTypeAdd,

  /// 请求添加对方为好友，对方需要验证
  @JsonValue(2)
  nimFriendModeTypeApply
}

/// 删除好友参数
@JsonSerializable(explicitToJson: true)
class NIMFriendDeleteParams {
  /// 是否删除备注
  ///  false， 不需要删
  ///  true， 需要
  bool? deleteAlias;

  NIMFriendDeleteParams({this.deleteAlias});

  Map<String, dynamic> toJson() => _$NIMFriendDeleteParamsToJson(this);

  factory NIMFriendDeleteParams.fromJson(Map<String, dynamic> map) =>
      _$NIMFriendDeleteParamsFromJson(map);
}

@JsonSerializable(explicitToJson: true)
class NIMFriendAddApplication {
  /// 申请者的账号
  String? applicantAccountId;

  /// 被申请者的账号
  String? recipientAccountId;

  /// 操作者的账号
  String? operatorAccountId;

  /// 操作时添加的附言
  String? postscript;

  /// 操作的状态
  NIMFriendAddApplicationStatus? status;

  /// 操作的时间
  int? timestamp;

  /// 是否已读
  bool? read;

  NIMFriendAddApplication(
      {this.applicantAccountId,
      this.recipientAccountId,
      this.operatorAccountId,
      this.postscript,
      this.status,
      this.timestamp,
      this.read});

  Map<String, dynamic> toJson() => _$NIMFriendAddApplicationToJson(this);

  factory NIMFriendAddApplication.fromJson(Map<String, dynamic> map) =>
      _$NIMFriendAddApplicationFromJson(map);
}

enum NIMFriendAddApplicationStatus {
  /// 未处理
  @JsonValue(0)
  nimFriendAddApplicationStatusInit,

  /// 已同意
  @JsonValue(1)
  nimFriendAddApplicationStatusAgreed,

  /// 已拒绝
  @JsonValue(2)
  nimFriendAddApplicationStatusRejected,

  /// 已过期
  @JsonValue(3)
  nimFriendAddApplicationStatusExpired,

  /// 直接加为好友
  @JsonValue(4)
  nimFriendAddApplicationStatusDirectAdd,
}

/// 好友设置参数
@JsonSerializable(explicitToJson: true)
class NIMFriendSetParams {
  /// 别名
  ///  null表示不设置
  ///  为''表示清空别名
  String? alias;

  /// 扩展字段
  ///  null表示不设置
  ///  为''表示清空别名
  String? serverExtension;

  NIMFriendSetParams({this.alias, this.serverExtension});

  Map<String, dynamic> toJson() => _$NIMFriendSetParamsToJson(this);

  factory NIMFriendSetParams.fromJson(Map<String, dynamic> map) =>
      _$NIMFriendSetParamsFromJson(map);
}

@JsonSerializable(explicitToJson: true)
class NIMFriendAddApplicationQueryOption {
  // 首次传0， 下一次传上一次返回的offset，不包含offset
  int? offset;

  // 每次查询的数量
  int? limit;

  // 如果列表为空， 或者size为0， 表示查询所有状态
  // 否则按输入状态查询
  List<NIMFriendAddApplicationStatus>? status;

  NIMFriendAddApplicationQueryOption(
      {required this.offset, required this.limit, this.status});

  Map<String, dynamic> toJson() =>
      _$NIMFriendAddApplicationQueryOptionToJson(this);

  factory NIMFriendAddApplicationQueryOption.fromJson(
          Map<String, dynamic> map) =>
      _$NIMFriendAddApplicationQueryOptionFromJson(map);
}

List<NIMFriendAddApplication>? _friendAddApplicationListFromJson(
    List<dynamic>? applicationList) {
  return applicationList
      ?.map((e) =>
          NIMFriendAddApplication.fromJson((e as Map).cast<String, dynamic>()))
      .toList();
}

/// 查询申请添加好友相关信息列表返回结构
@JsonSerializable(explicitToJson: true)
class NIMFriendAddApplicationResult {
  /// 查询返回的列表
  @JsonKey(fromJson: _friendAddApplicationListFromJson)
  List<NIMFriendAddApplication>? infos;

  /// 下一次的偏移量
  int offset;

  /// 分页结束
  bool? finished;

  NIMFriendAddApplicationResult(
      {this.infos, required this.offset, this.finished});

  Map<String, dynamic> toJson() => _$NIMFriendAddApplicationResultToJson(this);

  factory NIMFriendAddApplicationResult.fromJson(Map<String, dynamic> map) =>
      _$NIMFriendAddApplicationResultFromJson(map);
}

/// 好友信息搜索相关选项参数
/// 可以指定搜索范围， 指定是否搜索好友备注，是否搜索用户账号
///    搜索参数不能均为 false， 均为 false， 返回参数错误
///    按 “或” 搜索
@JsonSerializable(explicitToJson: true)
class NIMFriendSearchOption {
  /// 搜索关键字， 默认搜索好友备注， 可以指定是否同时搜索用户账号
  String keyword;

  /// 是否搜索好友备注
  bool searchAlias;

  /// 是否搜索用户账号
  bool searchAccountId;

  NIMFriendSearchOption(
      {required this.keyword,
      this.searchAlias = true,
      this.searchAccountId = true});

  Map<String, dynamic> toJson() => _$NIMFriendSearchOptionToJson(this);

  factory NIMFriendSearchOption.fromJson(Map<String, dynamic> map) =>
      _$NIMFriendSearchOptionFromJson(map);
}

enum NIMFriendDeletionType {
  /// 自己删除好友
  @JsonValue(1)
  nimFriendDeletionTypeBySelf,

  /// 对方删除你
  @JsonValue(2)
  nimFriendDeletionTypeByFriend,
}

/// 删除好友事件
@JsonSerializable(explicitToJson: true)
class NIMFriendDeletion {
  /// 删除好友的账号
  String accountId;

  /// 删除好友的类型
  NIMFriendDeletionType deletionType;

  NIMFriendDeletion({required this.accountId, required this.deletionType});

  Map<String, dynamic> toJson() => _$NIMFriendDeletionToJson(this);

  factory NIMFriendDeletion.fromJson(Map<String, dynamic> map) =>
      _$NIMFriendDeletionFromJson(map);
}
