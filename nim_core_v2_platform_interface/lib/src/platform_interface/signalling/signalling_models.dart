// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:json_annotation/json_annotation.dart';

part 'signalling_models.g.dart';

///直接呼叫请求参数
@JsonSerializable(explicitToJson: true)
class NIMSignallingCallParams {
  /// 被呼叫者账号ID，参数为空，或者为空串，返回参数错误
  String calleeAccountId;

  /// 请求ID，可以用UUID实现，主要为了便于业务实现请求响应绑定，参数为空，或者为空串，返回参数错误
  String requestId;

  /// 频道类型，房间创建后跟频道类型绑定，必须为枚举类型之一，否则返回参数错误
  NIMSignallingChannelType channelType;

  /// 频道名称，建议使用与业务有相关场景的名称，便于页面显示
  String? channelName;

  /// 频道相关扩展字段，跟频道绑定，json格式，长度限制4096
  String? channelExtension;

  /// 服务器扩展字段，json格式，长度限制4096
  String? serverExtension;

  /// 信令相关配置
  @JsonKey(fromJson: _NIMSignallingConfigFromJson)
  NIMSignallingConfig? signallingConfig;

  /// 推送相关配置
  @JsonKey(fromJson: _NIMSignallingPushConfigFromJson)
  NIMSignallingPushConfig? pushConfig;

  /// 音视频相关参数配置
  @JsonKey(fromJson: _NIMSignallingRtcConfigFromJson)
  NIMSignallingRtcConfig? rtcConfig;

  NIMSignallingCallParams({
    required this.calleeAccountId,
    required this.requestId,
    required this.channelType,
    this.channelName,
    this.channelExtension,
    this.serverExtension,
    this.signallingConfig,
    this.pushConfig,
    this.rtcConfig,
  });

  factory NIMSignallingCallParams.fromJson(Map<String, dynamic> map) =>
      _$NIMSignallingCallParamsFromJson(map);

  Map<String, dynamic> toJson() => _$NIMSignallingCallParamsToJson(this);
}

NIMSignallingConfig? _NIMSignallingConfigFromJson(Map? map) {
  if (map != null) {
    return NIMSignallingConfig.fromJson(map.cast<String, dynamic>());
  }
  return null;
}

NIMSignallingPushConfig? _NIMSignallingPushConfigFromJson(Map? map) {
  if (map != null) {
    return NIMSignallingPushConfig.fromJson(map.cast<String, dynamic>());
  }
  return null;
}

NIMSignallingRtcConfig? _NIMSignallingRtcConfigFromJson(Map? map) {
  if (map != null) {
    return NIMSignallingRtcConfig.fromJson(map.cast<String, dynamic>());
  }
  return null;
}

///信令相关配置
@JsonSerializable(explicitToJson: true)
class NIMSignallingConfig {
  /// 是否需要存离线消息
  bool offlineEnabled = true;

  /// 是否需要计未读
  bool unreadEnabled = true;

  /// 用户uid
  int? selfUid;

  NIMSignallingConfig({
    this.offlineEnabled = true,
    this.unreadEnabled = true,
    this.selfUid,
  });

  factory NIMSignallingConfig.fromJson(Map<String, dynamic> map) =>
      _$NIMSignallingConfigFromJson(map);

  Map<String, dynamic> toJson() => _$NIMSignallingConfigToJson(this);
}

///信令推送相关配置
@JsonSerializable(explicitToJson: true)
class NIMSignallingPushConfig {
  /// 是否需要推送
  bool? pushEnabled;

  /// 推送标题
  String? pushTitle;

  /// 推送文案
  String? pushContent;

  /// 推送数据
  String? pushPayload;

  NIMSignallingPushConfig({
    this.pushEnabled,
    this.pushTitle,
    this.pushContent,
    this.pushPayload,
  });

  factory NIMSignallingPushConfig.fromJson(Map<String, dynamic> map) =>
      _$NIMSignallingPushConfigFromJson(map);

  Map<String, dynamic> toJson() => _$NIMSignallingPushConfigToJson(this);
}

///音视频相关配置
@JsonSerializable(explicitToJson: true)
class NIMSignallingRtcConfig {
  /// 云信音视频房间频道名称，注意与信令房间频道名称不同
  String? rtcChannelName;

  /// 音视频房间token过期时间
  int? rtcTokenTtl;

  /// JSON格式字符串，音视频SDK相关参数，IM信令仅透传相关参数
  String? rtcParams;

  NIMSignallingRtcConfig({
    this.rtcChannelName,
    this.rtcTokenTtl,
    this.rtcParams,
  });

  factory NIMSignallingRtcConfig.fromJson(Map<String, dynamic> map) =>
      _$NIMSignallingRtcConfigFromJson(map);

  Map<String, dynamic> toJson() => _$NIMSignallingRtcConfigToJson(this);
}

NIMSignallingRoomInfo? _NIMSignallingRoomInfoFromJson(Map? map) {
  if (map != null) {
    return NIMSignallingRoomInfo.fromJson(map.cast<String, dynamic>());
  }
  return null;
}

NIMSignallingRtcInfo? _NIMSignallingRtcInfoFromJson(Map? map) {
  if (map != null) {
    return NIMSignallingRtcInfo.fromJson(map.cast<String, dynamic>());
  }
  return null;
}

///信令呼叫结果
@JsonSerializable(explicitToJson: true)
class NIMSignallingCallResult {
  /// 获取频道房间相关信息
  @JsonKey(fromJson: _NIMSignallingRoomInfoFromJson)
  NIMSignallingRoomInfo? roomInfo;

  /// 获取音视频房间相关信息
  @JsonKey(fromJson: _NIMSignallingRtcInfoFromJson)
  NIMSignallingRtcInfo? rtcInfo;

  /// 获取呼叫状态
  int callStatus;

  NIMSignallingCallResult({
    this.roomInfo,
    this.rtcInfo,
    required this.callStatus,
  });

  factory NIMSignallingCallResult.fromJson(Map<String, dynamic> map) =>
      _$NIMSignallingCallResultFromJson(map);

  Map<String, dynamic> toJson() => _$NIMSignallingCallResultToJson(this);
}

///音视频房间相关信息
@JsonSerializable(explicitToJson: true)
class NIMSignallingRtcInfo {
  /// 获取进入音视频对应的Token
  String rtcToken;

  /// 获取音视频房间token过期时间
  int? rtcTokenTtl;

  /// 获取音视频SDK相关参数的JSON格式字符串
  String? rtcParams;

  NIMSignallingRtcInfo({
    required this.rtcToken,
    this.rtcTokenTtl,
    this.rtcParams,
  });

  factory NIMSignallingRtcInfo.fromJson(Map<String, dynamic> map) =>
      _$NIMSignallingRtcInfoFromJson(map);

  Map<String, dynamic> toJson() => _$NIMSignallingRtcInfoToJson(this);
}

///呼叫建立请求参数
@JsonSerializable(explicitToJson: true)
class NIMSignallingCallSetupParams {
  /// 信令频道ID，唯一标识了该频道房间
  String channelId;

  /// 接受的呼叫者账号ID
  String callerAccountId;

  /// 请求ID，可以用UUID实现，主要为了便于业务实现请求响应绑定
  String requestId;

  /// 服务器扩展字段，json格式，长度限制4096
  String? serverExtension;

  /// 信令相关配置，在接受场景无效
  @JsonKey(fromJson: _NIMSignallingConfigFromJson)
  NIMSignallingConfig? signallingConfig;

  /// 音视频相关参数配置
  @JsonKey(fromJson: _NIMSignallingRtcConfigFromJson)
  NIMSignallingRtcConfig? rtcConfig;

  NIMSignallingCallSetupParams({
    required this.channelId,
    required this.callerAccountId,
    required this.requestId,
    this.serverExtension,
    this.signallingConfig,
    this.rtcConfig,
  });

  factory NIMSignallingCallSetupParams.fromJson(Map<String, dynamic> map) =>
      _$NIMSignallingCallSetupParamsFromJson(map);

  Map<String, dynamic> toJson() => _$NIMSignallingCallSetupParamsToJson(this);
}

///接受呼叫请求结果
@JsonSerializable(explicitToJson: true)
class NIMSignallingCallSetupResult {
  /// 获取频道房间相关信息
  @JsonKey(fromJson: _NIMSignallingRoomInfoFromJson)
  NIMSignallingRoomInfo? roomInfo;

  /// 获取音视频房间相关信息
  @JsonKey(fromJson: _NIMSignallingRtcInfoFromJson)
  NIMSignallingRtcInfo? rtcInfo;

  /// 获取呼叫状态
  int callStatus;

  NIMSignallingCallSetupResult({
    this.roomInfo,
    this.rtcInfo,
    required this.callStatus,
  });

  factory NIMSignallingCallSetupResult.fromJson(Map<String, dynamic> map) =>
      _$NIMSignallingCallSetupResultFromJson(map);

  Map<String, dynamic> toJson() => _$NIMSignallingCallSetupResultToJson(this);
}

///获取 NIMSignallingChannelType 枚举类型对应的 value
int getNIMSignallingChannelTypeValue(NIMSignallingChannelType type) {
  return _$NIMSignallingChannelTypeEnumMap[type]!;
}

///信令频道类型
enum NIMSignallingChannelType {
  /// 音频频道
  @JsonValue(1)
  nimSignallingChannelTypeAudio,

  /// 视频频道
  @JsonValue(2)
  nimSignallingChannelTypeVideo,

  /// 自定义频道
  @JsonValue(3)
  nimSignallingChannelTypeCustom,
}

///信令频道信息
@JsonSerializable(explicitToJson: true)
class NIMSignallingChannelInfo {
  /// 获取信令频道名称
  String? channelName;

  /// 获取信令频道ID
  String channelId;

  /// 获取频道类型
  NIMSignallingChannelType channelType;

  /// 获取频道相关扩展字段
  String? channelExtension;

  /// 获取频道房间创建时间
  int? createTime;

  /// 获取频道房间过期时间
  int? expireTime;

  /// 获取创建者账号ID
  String creatorAccountId;

  NIMSignallingChannelInfo({
    this.channelName,
    required this.channelId,
    required this.channelType,
    this.channelExtension,
    this.createTime,
    this.expireTime,
    required this.creatorAccountId,
  });

  factory NIMSignallingChannelInfo.fromJson(Map<String, dynamic> map) =>
      _$NIMSignallingChannelInfoFromJson(map);

  Map<String, dynamic> toJson() => _$NIMSignallingChannelInfoToJson(this);
}

///加入信令房间请求参数
@JsonSerializable(explicitToJson: true)
class NIMSignallingJoinParams {
  /// 信令频道ID，唯一标识了该频道房间
  String channelId;

  /// 服务器扩展字段，长度限制4096，json格式
  String? serverExtension;

  /// 信令相关配置
  @JsonKey(fromJson: _NIMSignallingConfigFromJson)
  NIMSignallingConfig? signallingConfig;

  /// 音视频相关参数配置
  @JsonKey(fromJson: _NIMSignallingRtcConfigFromJson)
  NIMSignallingRtcConfig? rtcConfig;

  NIMSignallingJoinParams({
    required this.channelId,
    this.serverExtension,
    this.signallingConfig,
    this.rtcConfig,
  });

  factory NIMSignallingJoinParams.fromJson(Map<String, dynamic> map) =>
      _$NIMSignallingJoinParamsFromJson(map);

  Map<String, dynamic> toJson() => _$NIMSignallingJoinParamsToJson(this);
}

NIMSignallingChannelInfo? _NIMSignallingChannelInfoFromJson(Map? map) {
  if (map != null) {
    return NIMSignallingChannelInfo.fromJson(map.cast<String, dynamic>());
  }
  return null;
}

List<NIMSignallingMember>? _NIMSignallingMemberListFromJson(
    List<dynamic>? channelList) {
  return channelList
      ?.map((e) =>
          NIMSignallingMember.fromJson((e as Map).cast<String, dynamic>()))
      .toList();
}

///房间相关信息
@JsonSerializable(explicitToJson: true)
class NIMSignallingRoomInfo {
  /// 获取频道房间相关信息
  @JsonKey(fromJson: _NIMSignallingChannelInfoFromJson)
  NIMSignallingChannelInfo? channelInfo;

  /// 获取成员列表信息
  @JsonKey(fromJson: _NIMSignallingMemberListFromJson)
  List<NIMSignallingMember>? members;

  NIMSignallingRoomInfo({
    this.channelInfo,
    this.members,
  });

  factory NIMSignallingRoomInfo.fromJson(Map<String, dynamic> map) =>
      _$NIMSignallingRoomInfoFromJson(map);

  Map<String, dynamic> toJson() => _$NIMSignallingRoomInfoToJson(this);
}

///信令频道成员信息
@JsonSerializable(explicitToJson: true)
class NIMSignallingMember {
  /// 获取成员账号ID
  String accountId;

  /// 获取成员UID
  int uid;

  /// 获取用户加入信令频道房间时间
  int? joinTime;

  /// 获取用户信令频道房间过期时间
  int? expireTime;

  /// 获取成员操作的设备ID
  String deviceId;

  NIMSignallingMember({
    required this.accountId,
    required this.uid,
    this.joinTime,
    this.expireTime,
    required this.deviceId,
  });

  factory NIMSignallingMember.fromJson(Map<String, dynamic> map) =>
      _$NIMSignallingMemberFromJson(map);

  Map<String, dynamic> toJson() => _$NIMSignallingMemberToJson(this);
}

///邀请成员加入信令房间请求参数
@JsonSerializable(explicitToJson: true)
class NIMSignallingInviteParams {
  /// 信令频道ID，唯一标识了该频道房间
  String channelId;

  /// 被邀请者账号ID
  String inviteeAccountId;

  /// 请求ID，可以用UUID实现，主要为了便于业务实现请求响应绑定
  String requestId;

  /// 服务器扩展字段，长度限制4096，json格式
  String? serverExtension;

  /// 信令相关配置
  @JsonKey(fromJson: _NIMSignallingConfigFromJson)
  NIMSignallingConfig? signallingConfig;

  /// 推送相关配置
  @JsonKey(fromJson: _NIMSignallingPushConfigFromJson)
  NIMSignallingPushConfig? pushConfig;

  NIMSignallingInviteParams({
    required this.channelId,
    required this.inviteeAccountId,
    required this.requestId,
    this.serverExtension,
    this.signallingConfig,
    this.pushConfig,
  });

  factory NIMSignallingInviteParams.fromJson(Map<String, dynamic> map) =>
      _$NIMSignallingInviteParamsFromJson(map);

  Map<String, dynamic> toJson() => _$NIMSignallingInviteParamsToJson(this);
}

///取消之前的邀请成员加入信令房间请求参数
@JsonSerializable(explicitToJson: true)
class NIMSignallingCancelInviteParams {
  /// 信令频道ID，唯一标识了该频道房间
  String channelId;

  /// 被邀请者账号ID
  String inviteeAccountId;

  /// 请求ID，可以用UUID实现，主要为了便于业务实现请求响应绑定
  String requestId;

  /// 服务器扩展字段，长度限制4096，json格式
  String? serverExtension;

  /// 是否需要存离线消息
  bool offlineEnabled = true;

  NIMSignallingCancelInviteParams({
    required this.channelId,
    required this.inviteeAccountId,
    required this.requestId,
    this.serverExtension,
    this.offlineEnabled = true,
  });

  factory NIMSignallingCancelInviteParams.fromJson(Map<String, dynamic> map) =>
      _$NIMSignallingCancelInviteParamsFromJson(map);

  Map<String, dynamic> toJson() =>
      _$NIMSignallingCancelInviteParamsToJson(this);
}

///拒绝别人邀请加入信令房间请求参数
@JsonSerializable(explicitToJson: true)
class NIMSignallingRejectInviteParams {
  /// 信令频道ID，唯一标识了该频道房间
  String channelId;

  /// 邀请者账号ID
  String inviterAccountId;

  /// 请求ID，可以用UUID实现，主要为了便于业务实现请求响应绑定
  String requestId;

  /// 服务器扩展字段，长度限制4096，json格式
  String? serverExtension;

  /// 是否需要存离线消息
  bool offlineEnabled = true;

  NIMSignallingRejectInviteParams({
    required this.channelId,
    required this.inviterAccountId,
    required this.requestId,
    this.serverExtension,
    this.offlineEnabled = true,
  });

  factory NIMSignallingRejectInviteParams.fromJson(Map<String, dynamic> map) =>
      _$NIMSignallingRejectInviteParamsFromJson(map);

  Map<String, dynamic> toJson() =>
      _$NIMSignallingRejectInviteParamsToJson(this);
}

///接受别人邀请加入信令房间请求参数
@JsonSerializable(explicitToJson: true)
class NIMSignallingAcceptInviteParams {
  /// 信令频道ID，唯一标识了该频道房间
  String channelId;

  /// 邀请者账号ID
  String inviterAccountId;

  /// 请求ID，可以用UUID实现，主要为了便于业务实现请求响应绑定
  String requestId;

  /// 服务器扩展字段，长度限制4096，json格式
  String? serverExtension;

  /// 是否需要存离线消息。true：需要。false：不需要
  bool offlineEnabled = true;

  NIMSignallingAcceptInviteParams({
    required this.channelId,
    required this.inviterAccountId,
    required this.requestId,
    this.serverExtension,
    this.offlineEnabled = true,
  });

  factory NIMSignallingAcceptInviteParams.fromJson(Map<String, dynamic> map) =>
      _$NIMSignallingAcceptInviteParamsFromJson(map);

  Map<String, dynamic> toJson() =>
      _$NIMSignallingAcceptInviteParamsToJson(this);
}

NIMSignallingMember? _NIMSignallingMemberFromJson(Map? map) {
  if (map != null) {
    return NIMSignallingMember.fromJson(map.cast<String, dynamic>());
  }
  return null;
}

///信令频道事件类型
enum NIMSignallingEventType {
  /// 未知
  @JsonValue(0)
  NIMSignallingEventTypeUnknown,

  /// 关闭信令频道房间
  @JsonValue(1)
  NIMSignallingEventTypeClose,

  /// 加入信令频道房间
  @JsonValue(2)
  NIMSignallingEventTypeJoin,

  /// 邀请加入信令频道房间
  @JsonValue(3)
  NIMSignallingEventTypeInvite,

  /// 取消邀请加入信令频道房间
  @JsonValue(4)
  NIMSignallingEventTypeCancelInvite,

  /// 拒绝邀请
  @JsonValue(5)
  NIMSignallingEventTypeReject,

  /// 接受邀请
  @JsonValue(6)
  NIMSignallingEventTypeAccept,

  /// 离开信令频道房间
  @JsonValue(7)
  NIMSignallingEventTypeLeave,

  /// 自定义控制命令
  @JsonValue(8)
  NIMSignallingEventTypeControl,
}

/// 信令通道回调
@JsonSerializable(explicitToJson: true)
class NIMSignallingEvent {
  /// 获取信令频道事件类型
  NIMSignallingEventType eventType;

  /// 获取信令频道房间相关信息
  @JsonKey(fromJson: _NIMSignallingChannelInfoFromJson)
  NIMSignallingChannelInfo? channelInfo;

  /// 获取操作者ID
  String operatorAccountId;

  /// 获取服务器扩展字段
  String? serverExtension;

  /// 获取操作的时间点
  int time;

  /// 获取被邀请者账号ID
  String? inviteeAccountId;

  /// 获取邀请者账号ID
  String? inviterAccountId;

  /// 获取本次请求发起产生的请求ID
  String? requestId;

  /// 获取推送相关配置
  @JsonKey(fromJson: _NIMSignallingPushConfigFromJson)
  NIMSignallingPushConfig? pushConfig;

  /// 获取是否需要计未读
  bool? unreadEnabled;

  /// 获取成员信息
  @JsonKey(fromJson: _NIMSignallingMemberFromJson)
  NIMSignallingMember? member;

  NIMSignallingEvent({
    required this.eventType,
    required this.channelInfo,
    required this.operatorAccountId,
    this.serverExtension,
    required this.time,
    this.inviteeAccountId,
    this.inviterAccountId,
    this.requestId,
    this.pushConfig,
    this.unreadEnabled,
    this.member,
  });

  factory NIMSignallingEvent.fromJson(Map<String, dynamic> map) =>
      _$NIMSignallingEventFromJson(map);

  Map<String, dynamic> toJson() => _$NIMSignallingEventToJson(this);
}

///加入信令房间相关信息回包
@JsonSerializable(explicitToJson: true)
class V2NIMSignallingJoinResult {
  /// 频道房间相关信息
  @JsonKey(fromJson: _NIMSignallingRoomInfoFromJson)
  NIMSignallingRoomInfo? roomInfo;

  /// 音视频房间相关信息
  @JsonKey(fromJson: _NIMSignallingRtcInfoFromJson)
  NIMSignallingRtcInfo? rtcInfo;

  V2NIMSignallingJoinResult({this.roomInfo, this.rtcInfo});

  factory V2NIMSignallingJoinResult.fromJson(Map<String, dynamic> map) =>
      _$V2NIMSignallingJoinResultFromJson(map);

  Map<String, dynamic> toJson() => _$V2NIMSignallingJoinResultToJson(this);
}
