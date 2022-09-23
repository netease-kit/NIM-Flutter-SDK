// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:json_annotation/json_annotation.dart';
import 'package:nim_core_platform_interface/src/platform_interface/nim_base.dart';

part 'auth_models.g.dart';

/// 用户登录认证信息
@JsonSerializable()
class NIMLoginInfo {
  /// 账号
  final String account;

  /// 令牌
  final String token;

  /// 认证类型
  @JsonKey(toJson: _valueOfNIMAuthType, fromJson: _authTypeFromValue)
  final NIMAuthType authType;

  ///
  /// 登录自定义字段
  ///
  /// [authType]为[NIMAuthType.authTypeThirdParty]时使用该字段内容去第三方服务器鉴权
  final String? loginExt;

  /// 自定义客户端类型，为空、小于等于0视为没有自定义类型
  final int? customClientType;

  NIMLoginInfo({
    required this.account,
    required this.token,
    this.authType = NIMAuthType.authTypeDefault,
    this.loginExt,
    this.customClientType,
  });

  Map<String, dynamic> toMap() => _$NIMLoginInfoToJson(this);

  factory NIMLoginInfo.fromMap(Map<String, dynamic> map) =>
      _$NIMLoginInfoFromJson(map);
}

/// 认证类型
enum NIMAuthType {
  authTypeDefault,
  authTypeDynamic,
  authTypeThirdParty,
}

int _valueOfNIMAuthType(NIMAuthType authType) => authType.index;

NIMAuthType _authTypeFromValue(int? value) =>
    NIMAuthType.values.firstWhere((element) => value == element.index,
        orElse: () => NIMAuthType.authTypeDefault);

/// 登录/登出状态事件
enum NIMAuthStatus {
  /// 未知状态
  unknown,

  /// 未登录 或 登录失败
  unLogin,

  /// 正在连接服务器
  connecting,

  /// 正在登录中
  logging,

  /// 已成功登录
  loggedIn,

  /// 被服务器拒绝连接，403，422
  forbidden,

  /// 网络连接已断开
  netBroken,

  /// 客户端版本错误
  versionError,

  /// 用户名或密码错误
  pwdError,

  /// 被其他端的登录踢掉
  kickOut,

  /// 被同时在线的其他端主动踢掉
  kickOutByOtherClient,

  /// 数据同步开始
  ///
  /// 同步开始时，SDK 数据库中的数据可能还是旧数据。
  ///（如果是首次登录，那么 SDK 数据库中还没有数据，
  /// 重新登录时 SDK 数据库中还是上一次退出时保存的数据）
  /// 在同步过程中，SDK 数据的更新会通过相应的监听接口发出数据变更通知。
  dataSyncStart,

  /// 数据同步完成
  dataSyncFinish,
}

extension NIMAuthStatusToString on NIMAuthStatus {
  String get name {
    return toString().split('.').last;
  }
}

/// 登录/登出状态变更事件
class NIMAuthStatusEvent {
  /// 当前状态
  final NIMAuthStatus status;

  NIMAuthStatusEvent(this.status);
}

class NIMKickOutByOtherClientEvent extends NIMAuthStatusEvent {
  /// 如果自己被其他断踢掉, 通过该接口获取踢掉你的客户端类型。
  ///
  /// 注意：如果当前状态不是被其他端踢出(包含服务端禁用并踢出)，比如自动登录监听到417，则该接口返回值无效。
  ///
  /// [NIMClientType]
  final int? clientType;

  /// 如果自己被其他断踢掉, 通过该接口获取踢掉你的客户端自定义类型。
  /// 注意：如果当前状态不是被其他端踢出(包含服务端禁用并踢出)，比如自动登录监听到417，则该接口返回值无效。
  final int? customClientType;

  NIMKickOutByOtherClientEvent(
    NIMAuthStatus status,
    this.clientType,
    this.customClientType,
  ) : super(status);
}

/// 数据同步状态变更事件，可监听数据同步开始、结束
class NIMDataSyncStatusEvent extends NIMAuthStatusEvent {
  NIMDataSyncStatusEvent(NIMAuthStatus status) : super(status);
}

/// 当前在线端信息
@JsonSerializable()
class NIMOnlineClient {
  /// 系统信息字符串
  final String os;

  /// 客户端类型
  /// [NIMClientType]
  @JsonKey(unknownEnumValue: NIMClientType.unknown)
  final NIMClientType clientType;

  /// 登录时间
  final int loginTime;

  /// 自定义字段
  final String? customTag;

  NIMOnlineClient({
    required this.os,
    required this.clientType,
    required this.loginTime,
    this.customTag,
  });

  factory NIMOnlineClient.fromMap(Map<String, dynamic> map) =>
      _$NIMOnlineClientFromJson(map);

  Map<String, dynamic> toMap() => _$NIMOnlineClientToJson(this);
}
