// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:json_annotation/json_annotation.dart';

import '../../../nim_core_v2_platform_interface.dart';

part "message_search.g.dart";

///检索消息参数
@JsonSerializable(explicitToJson: true)
class NIMMessageSearchExParams {
  /// 搜索 “全部会话” 还是搜索 “指定的会话”
  /// conversationId 为空（null），搜索全部会话；
  /// conversationId 不为空，搜索指定会话。
  String? conversationId;

  /// 关键字列表，
  /// 最多支持 5 个。当消息发送者以及消息类型均未指定时，必须设置关键字列表；否则，关键字列表可以为空。
  List<String>? keywordList;

  /// 指定关键字列表匹配类型
  /// 可设置为 “或” 关系搜索，或 “与” 关系搜索。取值分别为 V2TIM_KEYWORD_MATCH_TYPE_OR 和 V2TIM_KEYWORD_MATCH_TYPE_AND。默认为 “或” 关系搜索。
  /// 关键字列表为空或为数量为1，该字段无效
  NIMSearchKeywordMatchType? keywordMatchType;

  /// 指定消息发送者，
  /// 最多支持 5 个。
  /// 超过返回参数错误， accountId 默认只检查数量，不检查是否重复
  /// null 和 size==0 都表示没有指定人数
  List<String>? senderAccountIds;

  /// 指定消息类型，
  /// 为 null 或空列表，则表示查询所有消息类型
  /// 关键字不为空时，不支持检索通知类消息
  /// 非文本消息，只检索对应检索字段，如果检索字段为空则该消息不回被检索到
  List<NIMMessageType>? messageTypes;

  /// 指定消息子类型，
  /// 为 null 或空列表，则表示查询所有消息子类型
  /// 关键字不为空时，不支持检索通知类消息
  /// 非文本消息，只检索对应检索字段，如果检索字段为空则该消息不回被检索到
  List<int>? messageSubtypes;

  /// 搜索的起始时间点，
  /// 默认为 0（从现在开始搜索）。UTC 时间戳，单位：毫秒。
  int? searchStartTime = 0;

  /// 从起始时间点开始的过去时间范围，
  /// 默认为 0（不限制时间范围）。24 x 60 x 60 x 1000 代表过去一天，单位：毫秒。
  int? searchTimePeriod = 0;

  /// 搜索的数量限制，
  /// 最大 100
  int? limit;

  /// 搜索的起始位置，第一次填写空字符串，续拉时填写上一次返回的 V2NIMMessageSearchResult 中的 nextPageToken。
  /// 两次查询参数必须一致
  String? pageToken;

  ///检索方向
  NIMSearchDirection? direction;

  ///消息检索的策略
  NIMSearchStrategy? strategy;

  /// 消息索引列表，用于指定检索的消息范围
  /// 与 conversationId 互斥，当 indices 不为空时，conversationId 无效
  @JsonKey(fromJson: _nimMessageIndexListFromJson)
  List<NIMMessageIndex>? indices;

  /// 是否只返回索引，不返回消息体
  /// true：只返回消息索引；false（默认）：返回完整消息
  bool? onlyIndex;

  NIMMessageSearchExParams(
      {this.pageToken,
      this.conversationId,
      this.keywordList,
      this.keywordMatchType,
      this.senderAccountIds,
      this.messageTypes,
      this.messageSubtypes,
      this.searchStartTime,
      this.searchTimePeriod,
      this.limit,
      this.direction,
      this.strategy,
      this.indices,
      this.onlyIndex});

  factory NIMMessageSearchExParams.fromJson(Map<String, dynamic> json) =>
      _$NIMMessageSearchExParamsFromJson(json);

  Map<String, dynamic> toJson() => _$NIMMessageSearchExParamsToJson(this);
}

/// 检索返回结果
@JsonSerializable(explicitToJson: true)
class NIMMessageSearchResult {
  /// 满足检索条件的所有消息数量
  int? count;

  ///单个会话的返回结果
  ///  如果查询会话id不会空， 则返回items会对应会话按指定条数检索出来的消息
  ///   如果会话id为空，则为每一个会话检索出来的内容
  @JsonKey(fromJson: _nimMessageSearchItemListFromJson)
  List<NIMMessageSearchItem>? items;

  ///下次请求的token
  String? nextPageToken;

  ///表示还有数据, false：表示没有数据
  bool hasMore = false;

  NIMMessageSearchResult(
      {this.count, this.items, this.nextPageToken, this.hasMore = false});

  factory NIMMessageSearchResult.fromJson(Map<String, dynamic> json) =>
      _$NIMMessageSearchResultFromJson(json);

  Map<String, dynamic> toJson() => _$NIMMessageSearchResultToJson(this);
}

List<NIMMessageSearchItem>? _nimMessageSearchItemListFromJson(
    List<dynamic>? applicationList) {
  return applicationList
      ?.map((e) =>
          NIMMessageSearchItem.fromJson((e as Map).cast<String, dynamic>()))
      .toList();
}

///单个会话的返回结果
@JsonSerializable(explicitToJson: true)
class NIMMessageSearchItem {
  ///会话id
  String conversationId;

  ///返回的消息列表
  @JsonKey(fromJson: _nimMessageListFromJson)
  List<NIMMessage>? messages;

  ///单个会话的返回数量
  int count;

  /// 消息索引列表，当 onlyIndex 为 true 时返回，仅包含消息索引信息
  @JsonKey(fromJson: _nimMessageIndexListFromJson)
  List<NIMMessageIndex>? messageIndexs;

  NIMMessageSearchItem(
      {required this.conversationId,
      this.messages,
      required this.count,
      this.messageIndexs});

  factory NIMMessageSearchItem.fromJson(Map<String, dynamic> json) =>
      _$NIMMessageSearchItemFromJson(json);

  Map<String, dynamic> toJson() => _$NIMMessageSearchItemToJson(this);
}

List<NIMMessage>? _nimMessageListFromJson(List<dynamic>? applicationList) {
  return applicationList
      ?.map((e) => NIMMessage.fromJson((e as Map).cast<String, dynamic>()))
      .toList();
}

List<NIMMessageIndex>? _nimMessageIndexListFromJson(List<dynamic>? indexList) {
  return indexList
      ?.map((e) => NIMMessageIndex.fromJson((e as Map).cast<String, dynamic>()))
      .toList();
}

/// 搜索关键字匹配条件
enum NIMSearchKeywordMatchType {
  /// 或
  @JsonValue(0)
  V2NIM_SEARCH_KEYWORD_MATH_TYPE_OR,

  /// 与
  @JsonValue(1)
  V2NIM_SEARCH_KEYWORD_MATH_TYPE_ADD
}

/// 检索方向
enum NIMSearchDirection {
  /// 表示时间从新到老查询
  @JsonValue(0)
  V2NIM_SEARCH_DIRECTION_BACKWARD,

  ///表示时间从老到新查询
  @JsonValue(1)
  V2NIM_SEARCH_DIRECTION_FORWARD
}

/// 消息检索的策略
enum NIMSearchStrategy {
  /// 表示基于SQL模糊查询（LIKE）
  ///  数据量大的情况下，该模式检索耗时长
  @JsonValue(0)
  V2NIM_SEARCH_STRATEGY_SQL_LIKE,

  /// 表示基于全文检索（FULL_TEXT_SEARCH
  @JsonValue(1)
  V2NIM_SEARCH_STRATEGY_FTS
}

/// 消息索引信息，用于根据服务端 ID 查询消息
@JsonSerializable(explicitToJson: true)
class NIMMessageIndex {
  /// 会话 ID
  String conversationId;

  /// 消息服务端 ID
  int messageServerId;

  NIMMessageIndex({
    required this.conversationId,
    required this.messageServerId,
  });

  factory NIMMessageIndex.fromJson(Map<String, dynamic> json) =>
      _$NIMMessageIndexFromJson(json);

  Map<String, dynamic> toJson() => _$NIMMessageIndexToJson(this);
}
