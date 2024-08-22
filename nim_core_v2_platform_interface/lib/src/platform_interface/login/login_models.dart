// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:json_annotation/json_annotation.dart';

part 'login_models.g.dart';

///登录选项
@JsonSerializable(explicitToJson: true)
class NIMLoginOption {
  /// 重试次数
  int? retryCount;

  /// 超时时间
  int? timeout;

  /// 强制登录模式
  bool? forceMode;

  /// 认证类型
  NIMLoginAuthType? authType;

  /// 数据同步等级
  NIMDataSyncLevel? syncLevel;

  NIMLoginOption(
      {this.retryCount,
      this.timeout,
      this.authType,
      this.forceMode,
      this.syncLevel});

  Map<String, dynamic> toJson() => _$NIMLoginOptionToJson(this);

  factory NIMLoginOption.fromJson(Map<String, dynamic> map) =>
      _$NIMLoginOptionFromJson(map);
}

///登录认证类型
enum NIMLoginAuthType {
  /// 默认
  @JsonValue(0)
  authTypeDefault,

  /// 动态token
  @JsonValue(1)
  authTypeDynamicToken,

  /// 第三方
  @JsonValue(2)
  authTypeThirdParty,
}

///同步等级
enum NIMDataSyncLevel {
  /// 全量同步
  @JsonValue(0)
  dataSyncLevelFull,

  /// 同步基础数据
  @JsonValue(1)
  dataSyncLevelBasic,
}

///登录状态
enum NIMLoginStatus {
  /// 登出
  @JsonValue(0)
  loginStatusLogout,

  /// 已登录
  @JsonValue(1)
  loginStatusLogined,

  /// 登录中
  @JsonValue(2)
  loginStatusLogining,

  /// 未登录
  @JsonValue(3)
  loginStatusUnlogin,
}

@JsonSerializable(explicitToJson: true)
class NIMLoginStatusClass {
  NIMLoginStatus status;
  NIMLoginStatusClass(this.status);

  Map<String, dynamic> toJson() => _$NIMLoginStatusClassToJson(this);

  factory NIMLoginStatusClass.fromJson(Map<String, dynamic> map) =>
      _$NIMLoginStatusClassFromJson(map);
}

///登录客户端
@JsonSerializable(explicitToJson: true)
class NIMLoginClient {
  /// 类型
  NIMLoginClientType? type;

  /// 操作系统
  String? os;

  /// 登录时间
  int? timestamp;

  /// 自定义信息，最大32个字符；目前android多端登录，TV端和手表端，可以通过该字段区分
  String? customTag;

  /// 自定义登录端类型
  int? customClientType;

  /// 客户端ID
  String? clientId;

  NIMLoginClient(
      {this.type,
      this.clientId,
      this.os,
      this.customClientType,
      this.customTag,
      this.timestamp});

  Map<String, dynamic> toJson() => _$NIMLoginClientToJson(this);

  factory NIMLoginClient.fromJson(Map<String, dynamic> map) =>
      _$NIMLoginClientFromJson(map);
}

///登录客户端类型
enum NIMLoginClientType {
  /// 未知
  @JsonValue(0)
  loginClientTypeUnknown,

  /// Android
  @JsonValue(1)
  loginClientTypeAndroid,

  /// iOS
  @JsonValue(2)
  loginClientTypeIOS,

  /// PC
  @JsonValue(4)
  loginClientTypePC,

  /// WinPhone
  @JsonValue(8)
  loginClientTypeWinPhone,

  /// Web
  @JsonValue(16)
  loginClientTypeWeb,

  /// RESTFUL
  @JsonValue(32)
  loginClientTypeRestful,

  /// Mac
  @JsonValue(64)
  loginClientTypeMac,

  /// HARMONY
  @JsonValue(65)
  loginClientTypeHarmony,
}

///被踢下线详情
@JsonSerializable(explicitToJson: true)
class NIMKickedOfflineDetail {
  /// 被踢下线原因
  NIMKickedOfflineReason? reason;

  /// 被踢下线描述
  String? reasonDesc;

  /// 登录客户端类型
  NIMLoginClientType? clientType;

  /// 自定义登录端类型
  int? customClientType;

  NIMKickedOfflineDetail(
      {this.customClientType, this.clientType, this.reason, this.reasonDesc});

  Map<String, dynamic> toJson() => _$NIMKickedOfflineDetailToJson(this);

  factory NIMKickedOfflineDetail.fromJson(Map<String, dynamic> map) =>
      _$NIMKickedOfflineDetailFromJson(map);
}

///被踢下线原因
enum NIMKickedOfflineReason {
  /// 被另外一个客户端踢下线 (互斥客户端一端登录挤掉上一个登录中的客户端)
  @JsonValue(1)
  kickedOfflineReasonClientExclusive,

  /// 被服务器踢下线
  @JsonValue(2)
  kickedOfflineReasonServer,

  /// 被另外一个客户端手动选择踢下线
  @JsonValue(3)
  kickedOfflineReasonClient,
}

///连接状态
enum NIMConnectStatus {
  ///< 未连接
  @JsonValue(0)
  nimConnectStatusDisconnected,

  ///< 已连接
  @JsonValue(1)
  nimConnectStatusConnected,

  ///< 连接中
  @JsonValue(2)
  nimConnectStatusConnecting,

  ///< 等待重连
  @JsonValue(3)
  nimConnectStatusWaiting
}

@JsonSerializable(explicitToJson: true)
class NIMConnectStatusClass {
  NIMConnectStatus status;

  NIMConnectStatusClass(this.status);

  Map<String, dynamic> toJson() => _$NIMConnectStatusClassToJson(this);

  factory NIMConnectStatusClass.fromJson(Map<String, dynamic> map) =>
      _$NIMConnectStatusClassFromJson(map);
}

///数据同步类型
@JsonSerializable(explicitToJson: true)
class NIMDataSyncDetail {
  NIMDataSyncType? type;

  NIMDataSyncState? state;

  NIMDataSyncDetail({this.type, this.state});

  Map<String, dynamic> toJson() => _$NIMDataSyncDetailToJson(this);

  factory NIMDataSyncDetail.fromJson(Map<String, dynamic> map) =>
      _$NIMDataSyncDetailFromJson(map);
}

///数据同步类型
enum NIMDataSyncType {
  ///< 不在任何同步进程中
  @JsonValue(0)
  nimDataSyncUnknown,

  ///< 同步主数据
  @JsonValue(1)
  nimDataSyncMain,

  ///< 同步群组成员
  @JsonValue(2)
  nimDataSyncTeamMember,

  ///< 同步超大群组成员
  @JsonValue(3)
  nimDataSyncSuperTeamMember,
}

///数据同步状态
enum NIMDataSyncState {
  /// 等待同步
  @JsonValue(1)
  nimDataSyncStateWaiting,

  /// 同步中
  @JsonValue(2)
  nimDataSyncStateInSyncing,

  /// 同步完成
  @JsonValue(3)
  nimDataSyncStateCompleted,
}

enum NIMLoginClientChange {
  ///<端列表刷新
  @JsonValue(1)
  nimLoginClientChangeList,

  ///<端登录
  @JsonValue(2)
  nimLoginClientChangeLogin,

  ///<端登出
  @JsonValue(3)
  nimLoginClientChangeLogout
}

List<NIMLoginClient>? _loginClientListFromJson(List<dynamic>? clients) {
  return clients
      ?.map((e) => NIMLoginClient.fromJson((e as Map).cast<String, dynamic>()))
      .toList();
}

@JsonSerializable(explicitToJson: true)
class NIMLoginClientChangeEvent {
  ///登录客户端变化事件
  NIMLoginClientChange? change;

  ///登录客户端
  @JsonKey(fromJson: _loginClientListFromJson)
  List<NIMLoginClient>? clients;

  NIMLoginClientChangeEvent({this.change, this.clients});

  Map<String, dynamic> toJson() => _$NIMLoginClientChangeEventToJson(this);

  factory NIMLoginClientChangeEvent.fromJson(Map<String, dynamic> map) =>
      _$NIMLoginClientChangeEventFromJson(map);
}
