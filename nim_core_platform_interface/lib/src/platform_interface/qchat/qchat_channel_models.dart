// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:json_annotation/json_annotation.dart';
import 'package:nim_core_platform_interface/nim_core_platform_interface.dart';

part 'qchat_channel_models.g.dart';

@JsonSerializable(explicitToJson: true)
class QChatCreateChannelParam extends QChatAntiSpamConfigParam {
  /// 服务器id，必填
  final int serverId;

  /// 名称，必填
  final String name;

  /// 频道类型[QChatChannelType]，必填
  final QChatChannelType type;

  /// 主题
  String? topic;

  /// 自定义扩展
  String? custom;

  /// 查看模式
  QChatChannelMode? viewMode;

  QChatCreateChannelParam(
      {required this.serverId,
      required this.name,
      required this.type,
      this.custom,
      this.topic,
      this.viewMode});

  factory QChatCreateChannelParam.fromJson(Map<String, dynamic> json) =>
      _$QChatCreateChannelParamFromJson(json);

  Map<String, dynamic> toJson() => _$QChatCreateChannelParamToJson(this);
}

enum QChatChannelMode {
  ///公开的
  public,

  ///私密的
  private
}

enum QChatChannelSyncMode {
  ///不同步
  none,

  ///同步
  sync
}

@JsonSerializable(explicitToJson: true)
class QChatCreateChannelResult {
  @JsonKey(fromJson: qChatChannelFromJson)
  final QChatChannel? channel;

  QChatCreateChannelResult(this.channel);

  factory QChatCreateChannelResult.fromJson(Map<String, dynamic> json) =>
      _$QChatCreateChannelResultFromJson(json);

  Map<String, dynamic> toJson() => _$QChatCreateChannelResultToJson(this);
}

@JsonSerializable(explicitToJson: true)
class QChatChannel {
  /// 频道id
  final int channelId;

  /// 服务器id
  final int serverId;

  /// 名称
  String? name;

  /// 主题
  String? topic;

  /// 自定义扩展
  String? custom;

  /// Channel类型
  QChatChannelType? type;

  /// 是否有效
  bool? valid;

  /// 创建时间
  int? createTime;

  /// 更新时间
  int? updateTime;

  /// 所有者
  String? owner;

  /// 查看模式
  QChatChannelMode? viewMode;

  /// 频道分组Id
  int? categoryId;

  /// 同步模式
  QChatChannelSyncMode? syncMode;

  /// 自定义排序权重值
  int? reorderWeight;

  QChatChannel(
      {required this.channelId,
      required this.serverId,
      this.viewMode,
      this.syncMode,
      this.categoryId,
      this.topic,
      this.custom,
      this.name,
      this.type,
      this.createTime,
      this.reorderWeight,
      this.owner,
      this.updateTime,
      this.valid});

  factory QChatChannel.fromJson(Map<String, dynamic> json) =>
      _$QChatChannelFromJson(json);

  Map<String, dynamic> toJson() => _$QChatChannelToJson(this);
}

QChatChannel? qChatChannelFromJson(Map? map) {
  if (map != null) {
    return QChatChannel.fromJson(map.cast<String, dynamic>());
  }
  return null;
}

enum QChatChannelType {
  /// 消息频道
  messageChannel,

  /// 音视频频道
  RTCChannel,

  /// 自定义频道
  customChannel,
}

@JsonSerializable(explicitToJson: true)
class QChatDeleteChannelParam {
  final int channelId;

  QChatDeleteChannelParam(this.channelId);

  factory QChatDeleteChannelParam.fromJson(Map<String, dynamic> json) =>
      _$QChatDeleteChannelParamFromJson(json);

  Map<String, dynamic> toJson() => _$QChatDeleteChannelParamToJson(this);
}

@JsonSerializable(explicitToJson: true)
class QChatUpdateChannelResult {
  @JsonKey(fromJson: qChatChannelFromJson)
  final QChatChannel? channel;

  QChatUpdateChannelResult(this.channel);

  factory QChatUpdateChannelResult.fromJson(Map<String, dynamic> json) =>
      _$QChatUpdateChannelResultFromJson(json);

  Map<String, dynamic> toJson() => _$QChatUpdateChannelResultToJson(this);
}

@JsonSerializable(explicitToJson: true)
class QChatUpdateChannelParam extends QChatAntiSpamConfigParam {
  ///频道Id，必填
  final int channelId;

  ///频道名称
  String? name;

  ///频道主题
  String? topic;

  ///频道自定义扩展字段
  String? custom;

  ///频道查看模式
  QChatChannelMode? viewMode;

  QChatUpdateChannelParam(
      {required this.channelId,
      this.custom,
      this.topic,
      this.viewMode,
      this.name});

  factory QChatUpdateChannelParam.fromJson(Map<String, dynamic> json) =>
      _$QChatUpdateChannelParamFromJson(json);

  Map<String, dynamic> toJson() => _$QChatUpdateChannelParamToJson(this);
}

/// "查询channel信息"接口入参
@JsonSerializable(explicitToJson: true)
class QChatGetChannelsParam {
  ///查询的频道Id列表
  final List<int> channelIds;

  QChatGetChannelsParam(this.channelIds);

  factory QChatGetChannelsParam.fromJson(Map<String, dynamic> json) =>
      _$QChatGetChannelsParamFromJson(json);

  Map<String, dynamic> toJson() => _$QChatGetChannelsParamToJson(this);
}

List<QChatChannel>? _qChatChannelListFromJson(List<dynamic>? channelList) {
  return channelList
      ?.map((e) => QChatChannel.fromJson((e as Map).cast<String, dynamic>()))
      .toList();
}

@JsonSerializable(explicitToJson: true)
class QChatGetChannelsResult {
  /// 查询到的频道列表
  @JsonKey(fromJson: _qChatChannelListFromJson)
  final List<QChatChannel>? channels;

  QChatGetChannelsResult(this.channels);

  factory QChatGetChannelsResult.fromJson(Map<String, dynamic> json) =>
      _$QChatGetChannelsResultFromJson(json);

  Map<String, dynamic> toJson() => _$QChatGetChannelsResultToJson(this);
}

@JsonSerializable(explicitToJson: true)
class QChatGetChannelsByPageParam {
  /// 服务器Id
  final int serverId;

  /// 查询锚点时间戳
  final int timeTag;

  /// 查询数量限制
  final int limit;

  QChatGetChannelsByPageParam(
      {required this.serverId, required this.timeTag, required this.limit});

  factory QChatGetChannelsByPageParam.fromJson(Map<String, dynamic> json) =>
      _$QChatGetChannelsByPageParamFromJson(json);

  Map<String, dynamic> toJson() => _$QChatGetChannelsByPageParamToJson(this);
}

@JsonSerializable(explicitToJson: true)
class QChatGetChannelsByPageResult extends QChatGetByPageResult {
  ///查询到的频道列表
  @JsonKey(fromJson: _qChatChannelListFromJson)
  final List<QChatChannel>? channels;

  QChatGetChannelsByPageResult(bool? hasMore, int? nextTimeTag,
      {required this.channels})
      : super(hasMore: hasMore ?? false, nextTimeTag: nextTimeTag);

  factory QChatGetChannelsByPageResult.fromJson(Map<String, dynamic> json) =>
      _$QChatGetChannelsByPageResultFromJson(json);

  Map<String, dynamic> toJson() => _$QChatGetChannelsByPageResultToJson(this);
}

@JsonSerializable(explicitToJson: true)
class QChatGetChannelMembersByPageParam {
  /// 服务器id
  final int serverId;

  /// 频道id
  final int channelId;

  /// 查询时间戳，如果传0表示当前时间
  final int timeTag;

  /// 查询数量限制，默认100
  int? limit;

  QChatGetChannelMembersByPageParam(
      {required this.serverId,
      required this.channelId,
      required this.timeTag,
      this.limit});

  factory QChatGetChannelMembersByPageParam.fromJson(
          Map<String, dynamic> json) =>
      _$QChatGetChannelMembersByPageParamFromJson(json);

  Map<String, dynamic> toJson() =>
      _$QChatGetChannelMembersByPageParamToJson(this);
}

List<QChatServerMember>? _qChatServerMemberListFromJson(
    List<dynamic>? memberList) {
  return memberList
      ?.map(
          (e) => QChatServerMember.fromJson((e as Map).cast<String, dynamic>()))
      .toList();
}

@JsonSerializable(explicitToJson: true)
class QChatGetChannelMembersByPageResult extends QChatGetByPageResult {
  /// 查询到的频道成员
  @JsonKey(fromJson: _qChatServerMemberListFromJson)
  final List<QChatServerMember>? members;

  QChatGetChannelMembersByPageResult(bool? hasMore, int? nextTimeTag,
      {required this.members})
      : super(hasMore: hasMore ?? false, nextTimeTag: nextTimeTag);

  factory QChatGetChannelMembersByPageResult.fromJson(
          Map<String, dynamic> json) =>
      _$QChatGetChannelMembersByPageResultFromJson(json);

  Map<String, dynamic> toJson() =>
      _$QChatGetChannelMembersByPageResultToJson(this);
}

List<QChatChannelIdInfo> _qChatChannelIdInfoListFromJson(
    List<dynamic> channelIds) {
  return channelIds
      .map((e) =>
          QChatChannelIdInfo.fromJson((e as Map).cast<String, dynamic>()))
      .toList();
}

///"查询未读信息"接口入参
@JsonSerializable(explicitToJson: true)
class QChatGetChannelUnreadInfosParam {
  @JsonKey(fromJson: _qChatChannelIdInfoListFromJson)
  final List<QChatChannelIdInfo> channelIdInfos;

  QChatGetChannelUnreadInfosParam(this.channelIdInfos);

  factory QChatGetChannelUnreadInfosParam.fromJson(Map<String, dynamic> json) =>
      _$QChatGetChannelUnreadInfosParamFromJson(json);

  Map<String, dynamic> toJson() =>
      _$QChatGetChannelUnreadInfosParamToJson(this);
}

@JsonSerializable(explicitToJson: true)
class QChatChannelIdInfo {
  /// 服务器id
  final int serverId;

  /// 频道id
  final int channelId;

  QChatChannelIdInfo({required this.serverId, required this.channelId});

  factory QChatChannelIdInfo.fromJson(Map<String, dynamic> json) =>
      _$QChatChannelIdInfoFromJson(json);

  Map<String, dynamic> toJson() => _$QChatChannelIdInfoToJson(this);
}

///"订阅频道"接口入参
@JsonSerializable(explicitToJson: true)
class QChatSubscribeChannelParam {
  /// 请求参数，订阅类型，见QChatSubType
  final QChatSubscribeType type;

  /// 请求参数，操作类型，见QChatSubOperateType
  final QChatSubscribeOperateType operateType;

  /// 请求参数，操作的对象：channelInfo列表
  @JsonKey(fromJson: _qChatChannelIdInfoListFromJson)
  final List<QChatChannelIdInfo> channelIdInfos;

  QChatSubscribeChannelParam(
      {required this.type,
      required this.operateType,
      required this.channelIdInfos});

  factory QChatSubscribeChannelParam.fromJson(Map<String, dynamic> json) =>
      _$QChatSubscribeChannelParamFromJson(json);

  Map<String, dynamic> toJson() => _$QChatSubscribeChannelParamToJson(this);
}

///检索频道的接口入参
@JsonSerializable(explicitToJson: true)
class QChatSearchChannelByPageParam {
  /// 检索关键字，目标检索服务器名称
  final String keyword;

  /// 排序规则 true：正序；false：反序
  bool asc = true;

  /// 查询时间范围的开始时间
  int? startTime;

  /// 查询时间范围的结束时间，要求比开始时间大
  int? endTime;

  /// 检索返回的最大记录数，最大和默认都是100
  int? limit;

  /// 服务器类型
  int? serverId;

  /// 排序条件
  QChatChannelSearchSortEnum? sort;

  /// 查询游标，下次查询的起始位置,第一页设置为null，查询下一页是传入上一页返回的cursor
  String? cursor;

  QChatSearchChannelByPageParam(
      {this.serverId,
      this.limit,
      this.asc = true,
      this.endTime,
      required this.keyword,
      this.startTime,
      this.cursor,
      this.sort});

  factory QChatSearchChannelByPageParam.fromJson(Map<String, dynamic> json) =>
      _$QChatSearchChannelByPageParamFromJson(json);

  Map<String, dynamic> toJson() => _$QChatSearchChannelByPageParamToJson(this);
}

enum QChatChannelSearchSortEnum {
  /// 自定义权重排序
  ReorderWeight,

  /// 创建时间，默认
  CreateTime,
}

@JsonSerializable(explicitToJson: true)
class QChatSearchChannelMembersParam {
  /// 服务器ID
  final int serverId;

  /// 频道ID
  final int channelId;

  /// 检索关键字，目标检索昵称、账号，最大100个字符
  final String keyword;

  /// 检索返回的最大记录数，最大和默认都是100
  int? limit;

  QChatSearchChannelMembersParam(
      {required this.keyword,
      this.limit,
      required this.serverId,
      required this.channelId});

  factory QChatSearchChannelMembersParam.fromJson(Map<String, dynamic> json) =>
      _$QChatSearchChannelMembersParamFromJson(json);

  Map<String, dynamic> toJson() => _$QChatSearchChannelMembersParamToJson(this);
}

List<QChatUnreadInfo>? qChatUnreadInfListFromJson(List<dynamic>? infoList) {
  return infoList
      ?.map((e) => QChatUnreadInfo.fromJson((e as Map).cast<String, dynamic>()))
      .toList();
}

@JsonSerializable(explicitToJson: true)
class QChatGetChannelUnreadInfosResult {
  ///查询到的未读信息列表
  @JsonKey(fromJson: qChatUnreadInfListFromJson)
  final List<QChatUnreadInfo>? unreadInfoList;

  QChatGetChannelUnreadInfosResult(this.unreadInfoList);

  factory QChatGetChannelUnreadInfosResult.fromJson(
          Map<String, dynamic> json) =>
      _$QChatGetChannelUnreadInfosResultFromJson(json);

  Map<String, dynamic> toJson() =>
      _$QChatGetChannelUnreadInfosResultToJson(this);
}

@JsonSerializable(explicitToJson: true)
class QChatSubscribeChannelResult {
  ///订阅成功后的未读信息列表
  @JsonKey(fromJson: qChatUnreadInfListFromJson)
  final List<QChatUnreadInfo>? unreadInfoList;

  ///订阅失败的频道id信息列表
  @JsonKey(fromJson: _qChatChannelIdInfoListFromJson)
  final List<QChatChannelIdInfo>? failedList;

  QChatSubscribeChannelResult(
      {required this.unreadInfoList, required this.failedList});

  factory QChatSubscribeChannelResult.fromJson(Map<String, dynamic> json) =>
      _$QChatSubscribeChannelResultFromJson(json);

  Map<String, dynamic> toJson() => _$QChatSubscribeChannelResultToJson(this);
}

@JsonSerializable(explicitToJson: true)
class QChatSearchChannelByPageResult extends QChatGetByPageWithCursorResult {
  /// 查询到的频道列表
  @JsonKey(fromJson: _qChatChannelListFromJson)
  final List<QChatChannel>? channels;

  QChatSearchChannelByPageResult(bool? hasMore, int? nextTimeTag,
      {required this.channels, String? cursor})
      : super(hasMore, nextTimeTag, cursor);

  factory QChatSearchChannelByPageResult.fromJson(Map<String, dynamic> json) =>
      _$QChatSearchChannelByPageResultFromJson(json);

  Map<String, dynamic> toJson() => _$QChatSearchChannelByPageResultToJson(this);
}

List<QChatChannelMember>? _qChatChannelMemberFromJson(
    List<dynamic>? channelMemberList) {
  return channelMemberList
      ?.map((e) =>
          QChatChannelMember.fromJson((e as Map).cast<String, dynamic>()))
      .toList();
}

@JsonSerializable(explicitToJson: true)
class QChatSearchChannelMembersResult {
  ///搜索到的频道成员
  @JsonKey(fromJson: _qChatChannelMemberFromJson)
  final List<QChatChannelMember>? members;

  QChatSearchChannelMembersResult(this.members);

  factory QChatSearchChannelMembersResult.fromJson(Map<String, dynamic> json) =>
      _$QChatSearchChannelMembersResultFromJson(json);

  Map<String, dynamic> toJson() =>
      _$QChatSearchChannelMembersResultToJson(this);
}

@JsonSerializable(explicitToJson: true)
class QChatChannelMember {
  ///服务器id

  int? serverId;

  ///频道id

  int? channelId;

  ///头像

  String? avatar;

  ///用户Id

  String? accid;

  ///昵称

  String? nick;

  ///创建时间

  int? createTime;

  ///更新时间

  int? updateTime;

  QChatChannelMember(
      {this.serverId,
      this.channelId,
      this.updateTime,
      this.createTime,
      this.accid,
      this.avatar,
      this.nick});

  factory QChatChannelMember.fromJson(Map<String, dynamic> json) =>
      _$QChatChannelMemberFromJson(json);

  Map<String, dynamic> toJson() => _$QChatChannelMemberToJson(this);
}
