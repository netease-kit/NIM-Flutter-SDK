// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:json_annotation/json_annotation.dart';

import '../../../nim_core_v2_platform_interface.dart';
part 'subscription_models.g.dart';

@JsonSerializable(explicitToJson: true)
class NIMUserStatus {
  // 用户账号ID
  String accountId;

  /// 客户端类型
  /// [NIMClientType]
  @JsonKey(unknownEnumValue: NIMClientType.unknown)
  final NIMClientType clientType;

  ///包括以下状态，在线状态参见：枚举名：V2NIMUserStatusType 未知：0 登录：1 登出：2 断开连接： 3 自定义设置值：
  ///10000以上，不包括一万， 一万以内为预定义值
  int? statusType;

  ///用户发布状态的发布时间，服务器时间
  int publishTime;

  ///每次发布时，会生成一个唯一id， 发布自定义事件时会生成该参数，如果id相同，表示同一个事件
  String uniqueId;

  ///用户发布状态时设置的扩展字段
  String? extension;

  /// 获取预留状态中的配置信息，由服务端填入 JsonArray格式
  String? serverExtension;

  NIMUserStatus(
      {required this.accountId,
      required this.clientType,
      this.statusType,
      required this.publishTime,
      required this.uniqueId,
      this.extension,
      this.serverExtension});

  Map<String, dynamic> toJson() => _$NIMUserStatusToJson(this);
  factory NIMUserStatus.fromJson(Map<String, dynamic> map) =>
      _$NIMUserStatusFromJson(map);
}

///自定义用户状态发布回包
@JsonSerializable(explicitToJson: true)
class NIMCustomUserStatusPublishResult {
  ///获取发布自定义用户状态时， 内部生成的唯一ID
  String uniqueId;

  ///获取服务器针对该状态事件生成的ID
  String? serverId;

  ///获取用户状态发布时的时间
  int? publishTime;

  NIMCustomUserStatusPublishResult(
      {required this.uniqueId, this.serverId, this.publishTime});

  Map<String, dynamic> toJson() =>
      _$NIMCustomUserStatusPublishResultToJson(this);
  factory NIMCustomUserStatusPublishResult.fromJson(Map<String, dynamic> map) =>
      _$NIMCustomUserStatusPublishResultFromJson(map);
}

///用户状态订阅结果
@JsonSerializable(explicitToJson: true)
class NIMUserStatusSubscribeResult {
  ///获取查询的用户账号
  String accountId;

  ///获取订阅的有效期，单位秒，范围为 60s 到 30days
  int? duration;

  ///获取我的订阅时间
  int? subscribeTime;

  NIMUserStatusSubscribeResult(
      {required this.accountId, this.duration, this.subscribeTime});

  Map<String, dynamic> toJson() => _$NIMUserStatusSubscribeResultToJson(this);
  factory NIMUserStatusSubscribeResult.fromJson(Map<String, dynamic> map) =>
      _$NIMUserStatusSubscribeResultFromJson(map);
}

@JsonSerializable(explicitToJson: true)
class NIMSubscribeUserStatusOption {
  ///订阅的成员列表， 为空返回参数错误，单次数量不超过100， 列表数量如果超限参数错误
  List<String> accountIds;

  ///订阅的有效期，时间范围为 60~2592000(7天)，单位：秒，过期后需要重新订阅。
  /// 如果未过期的情况下重复订阅，新设置的有效期会覆盖之前的有效期
  ///默认值为60s
  int? duration;

  ///订阅后是否立即同步事件状态值， 默认为false。 为true：表示立即同步当前状态值 但为了性能考虑， 30S内重复订阅，会忽略该参数
  bool? immediateSync = false;

  NIMSubscribeUserStatusOption(
      {required this.accountIds, this.duration, this.immediateSync});

  Map<String, dynamic> toJson() => _$NIMSubscribeUserStatusOptionToJson(this);
  factory NIMSubscribeUserStatusOption.fromJson(Map<String, dynamic> map) =>
      _$NIMSubscribeUserStatusOptionFromJson(map);
}

@JsonSerializable(explicitToJson: true)
class NIMUnsubscribeUserStatusOption {
  /// 取消订阅的成员列表，为空，则表示取消所有订阅的成员， 否则取消指定的成员 单次数量不超过100， 超过返回191004
  List<String> accountIds;

  NIMUnsubscribeUserStatusOption({required this.accountIds});

  Map<String, dynamic> toJson() => _$NIMUnsubscribeUserStatusOptionToJson(this);
  factory NIMUnsubscribeUserStatusOption.fromJson(Map<String, dynamic> map) =>
      _$NIMUnsubscribeUserStatusOptionFromJson(map);
}

@JsonSerializable(explicitToJson: true)
class NIMCustomUserStatusParams {
  ///自定义设置值： 10000以上，包括一万， 一万以内为预定义值 小于1万，返回参数错误 大于int上限，返回参数错误
  int? statusType;

  ///状态的有效期，单位秒，范围为 60s 到 7days，默认值为60s
  int? duration;

  ///用户发布状态时设置的扩展字段
  String? extension;

  ///用户发布状态时是否只广播给在线的订阅者，默认值为TRUE
  bool? onlineOnly = true;

  ///用户发布状态时是否需要多端同步，默认值为FALSE
  bool? multiSync = false;

  NIMCustomUserStatusParams(
      {this.statusType,
      this.duration,
      this.extension,
      this.onlineOnly,
      this.multiSync});

  Map<String, dynamic> toJson() => _$NIMCustomUserStatusParamsToJson(this);
  factory NIMCustomUserStatusParams.fromJson(Map<String, dynamic> map) =>
      _$NIMCustomUserStatusParamsFromJson(map);
}
