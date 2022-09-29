// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:json_annotation/json_annotation.dart';
import 'package:nim_core_platform_interface/nim_core_platform_interface.dart';
import 'package:nim_core_platform_interface/src/utils/converter.dart';

part 'avsignalling_models.g.dart';

@JsonSerializable()
class ChannelBaseInfo {
  ///频道名称
  final String channelName;

  ///频道id
  final String channelId;

  ///频道类型
  final ChannelType type;

  ///创建频道时的扩展字段
  final String? channelExt;

  ///频道创建时间
  final int createTimestamp;

  ///频道过期时间
  final int expireTimestamp;

  ///频道创建者accountId
  final String creatorAccountId;

  ///频道状态
  final ChannelStatus channelStatus;

  ChannelBaseInfo(
      {required this.channelName,
      required this.channelId,
      this.channelExt,
      required this.createTimestamp,
      required this.expireTimestamp,
      required this.creatorAccountId,
      required this.type,
      required this.channelStatus});

  factory ChannelBaseInfo.fromJson(Map<String, dynamic> map) =>
      _$ChannelBaseInfoFromJson(map);

  Map<String, dynamic> toJson() => _$ChannelBaseInfoToJson(this);
}

ChannelBaseInfo _channelBaseInfoFromJson(Map map) =>
    _$ChannelBaseInfoFromJson(map.cast<String, dynamic>());

Map<String, dynamic> _channelBaseInfoToJson(ChannelBaseInfo info) =>
    _$ChannelBaseInfoToJson(info);

enum ChannelStatus {
  ///频道正常
  normal,

  ///频道无效了 ，列如被关闭了
  invalid,
}

enum ChannelType {
  /// 音频频道
  audio,

  /// 视频频道
  video,

  /// 自定义频道
  custom,
}

List<MemberInfo>? _memberListFromJson(List<dynamic>? memberList) {
  return memberList
      ?.map((e) => MemberInfo.fromJson((e as Map).cast<String, dynamic>()))
      .toList();
}

@JsonSerializable(explicitToJson: true)
class ChannelFullInfo {
  @JsonKey(fromJson: _channelBaseInfoFromJson, toJson: _channelBaseInfoToJson)
  final ChannelBaseInfo channelBaseInfo;

  ///频道的成员信息
  @JsonKey(fromJson: _memberListFromJson)
  final List<MemberInfo>? members;

  ChannelFullInfo({required this.channelBaseInfo, this.members});

  factory ChannelFullInfo.fromJson(Map<String, dynamic> map) =>
      _$ChannelFullInfoFromJson(map);

  Map<String, dynamic> toJson() => _$ChannelFullInfoToJson(this);
}

ChannelFullInfo _channelFullInfoFromJson(Map map) {
  return ChannelFullInfo.fromJson(map.cast<String, dynamic>());
}

@JsonSerializable()
class MemberInfo {
  ///IM 登录的帐号id
  final String accountId;

  ///音视频Server对应的id
  final int uid;

  ///用户加入频道的时间
  final int joinTime;

  ///用户在频道的过期时间
  final int expireTime;

  MemberInfo(
      {required this.accountId,
      required this.uid,
      required this.joinTime,
      required this.expireTime});

  factory MemberInfo.fromJson(Map<String, dynamic> map) =>
      _$MemberInfoFromJson(map);

  Map<String, dynamic> toJson() => _$MemberInfoToJson(this);
}

MemberInfo? _memberInfoFromJson(Map? map) {
  if (map != null) {
    return MemberInfo.fromJson(map.cast<String, dynamic>());
  }
  return null;
}

@JsonSerializable(explicitToJson: true)
class InviteParam {
  /// 频道id
  final String channelId;

  ///  对方帐号id。
  ///      eg : 邀请与取消邀请时填被邀请人id ，拒绝邀请与接受邀请时填邀请人id
  final String accountId;

  ///requestId 对本次邀请的唯一标识。
  ///发起邀请者需要自行生成(要保证唯一性，不同的邀不能用同一个id)，取消邀请时需要传入同一个requestId。
  ///对于接收方 ，requestId可以在收到相应通知时获取
  final String requestId;

  /// 自定义扩展字段，透传给接收方
  final String? customInfo;

  /// 推送配置 ，仅在发出邀请时有效
  @JsonKey(fromJson: _signallingPushConfigFromJson)
  final SignallingPushConfig? pushConfig;

  /// 相应的通知事件是否存离线 ， 默认不离线
  final bool? offlineEnabled;

  InviteParam(
      {required this.channelId,
      required this.accountId,
      required this.requestId,
      this.customInfo,
      this.pushConfig,
      this.offlineEnabled});

  factory InviteParam.fromJson(Map<String, dynamic> map) =>
      _$InviteParamFromJson(map);

  Map<String, dynamic> toJson() => _$InviteParamToJson(this);
}

SignallingPushConfig? _signallingPushConfigFromJson(Map? map) {
  if (map != null) {
    return SignallingPushConfig.fromJson(map.cast<String, dynamic>());
  }
  return null;
}

///信令推送配置项
@JsonSerializable(explicitToJson: true)
class SignallingPushConfig {
  ///是否需要push
  final bool needPush;

  ///推送标题
  final String? pushTitle;

  ///推送内容
  final String? pushContent;

  ///推送扩展
  @JsonKey(fromJson: castPlatformMapToDartMap)
  final Map<String, dynamic>? pushPayload;

  SignallingPushConfig(
      {required this.needPush,
      this.pushTitle,
      this.pushContent,
      this.pushPayload});

  factory SignallingPushConfig.fromJson(Map<String, dynamic> map) =>
      _$SignallingPushConfigFromJson(map);

  Map<String, dynamic> toJson() => _$SignallingPushConfigToJson(this);
}

@JsonSerializable(explicitToJson: true)
class CallParam {
  ///频道类型
  final ChannelType channelType;

  ///对方的accid
  final String accountId;

  ///邀请id ，发起邀请者自行生成(要保证唯一性)
  final String requestId;

  ///指定频道名
  final String? channelName;

  ///指定频道扩展字段
  final String? channelExt;

  ///  指定自己的uid ， 不指定的话，服务端会自动生成。如果指定请保持维一性
  final int? selfUid;

  ///相应的通知是否存离线
  final bool? offlineEnable;

  /// 邀请者附加的自定义信息，透传给被邀请者
  final String? customInfo;

  ///推送配置
  @JsonKey(fromJson: _signallingPushConfigFromJson)
  final SignallingPushConfig? pushConfig;

  CallParam(
      {required this.channelType,
      required this.requestId,
      required this.accountId,
      this.channelName,
      this.channelExt,
      this.selfUid,
      this.offlineEnable,
      this.pushConfig,
      this.customInfo});

  factory CallParam.fromJson(Map<String, dynamic> map) =>
      _$CallParamFromJson(map);

  Map<String, dynamic> toJson() => _$CallParamToJson(this);
}

@JsonSerializable(explicitToJson: true)
class SignallingEvent {
  /// 获取频道基础信息
  @JsonKey(fromJson: _channelBaseInfoFromJson, toJson: _channelBaseInfoToJson)
  ChannelBaseInfo channelBaseInfo;

  /// 通知来自于谁（由谁触发者的通知）
  /// 例如：
  /// 如果是被邀请事件 ，那么from 就是主动邀请者
  /// 如果是邀请应答事件 ，那么from 就是响应的邀请的人
  /// 注意：如果是多端同步的通知，那么from一般指自己
  String fromAccountId;

  /// 通知触发者附加的自定义信息
  String? customInfo;

  /// 通知事件类型
  SignallingEventType eventType;

  /// 通知产生的时间（指对方发送通知的时间）
  int time;

  SignallingEvent(
      {required this.channelBaseInfo,
      required this.eventType,
      required this.fromAccountId,
      required this.time,
      this.customInfo});

  factory SignallingEvent.fromJson(Map<String, dynamic> map) =>
      _$SignallingEventFromJson(map);

  Map<String, dynamic> toJson() => _$SignallingEventToJson(this);
}

SignallingEvent _signallingEventFromJson(Map map) {
  return SignallingEvent.fromJson(map.cast<String, dynamic>());
}

enum SignallingEventType {
  ///未知事件
  unKnow,

  /// 频道关闭事件
  close,

  ///有人加入频道事件
  join,

  /// 被邀请事件
  invite,

  /// 取消邀请事件
  cancelInvite,

  ///对方拒绝邀请事件
  reject,

  /// 对方接受邀请事件
  accept,

  /// 有用户离开频道事件
  leave,

  ///自定义控制命令事件
  control,
}

enum InviteAckStatus {
  /// 拒绝邀请
  reject,

  /// 接受邀请
  accept
}

@JsonSerializable(explicitToJson: true)
class ChannelCommonEvent {
  ///被操作者帐号id ,
  ///如果是应答则为应答了谁的邀请，
  ///如果为取消则为即取消了对谁的邀请,
  ///如果为邀请则为被邀请对象
  final String? toAccountId;

  ///由发起者生成的唯一请求标识
  final String? requestId;

  ///取确认动作 ， 接受或拒绝
  final InviteAckStatus? ackStatus;

  ///推送配置
  @JsonKey(fromJson: _signallingPushConfigFromJson)
  final SignallingPushConfig? pushConfig;

  ///加入频道的用户信息
  @JsonKey(fromJson: _memberInfoFromJson)
  final MemberInfo? joinMember;

  @JsonKey(fromJson: _signallingEventFromJson)
  SignallingEvent signallingEvent;

  ChannelCommonEvent(this.signallingEvent,
      {this.requestId,
      this.toAccountId,
      this.ackStatus,
      this.pushConfig,
      this.joinMember});

  factory ChannelCommonEvent.fromJson(Map<String, dynamic> map) =>
      _$ChannelCommonEventFromJson(map);

  Map<String, dynamic> toJson() => _$ChannelCommonEventToJson(this);
}

@JsonSerializable(explicitToJson: true)
class SyncChannelEvent {
  @JsonKey(fromJson: _channelFullInfoFromJson)
  final ChannelFullInfo channelFullInfo;

  SyncChannelEvent(this.channelFullInfo);

  factory SyncChannelEvent.fromJson(Map<String, dynamic> map) =>
      _$SyncChannelEventFromJson(map);

  Map<String, dynamic> toJson() => _$SyncChannelEventToJson(this);
}
