// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_search.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NIMMessageSearchExParams _$NIMMessageSearchExParamsFromJson(
        Map<String, dynamic> json) =>
    NIMMessageSearchExParams(
      pageToken: json['pageToken'] as String?,
      conversationId: json['conversationId'] as String?,
      keywordList: (json['keywordList'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      keywordMatchType: $enumDecodeNullable(
          _$NIMSearchKeywordMatchTypeEnumMap, json['keywordMatchType']),
      senderAccountIds: (json['senderAccountIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      messageTypes: (json['messageTypes'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$NIMMessageTypeEnumMap, e))
          .toList(),
      messageSubtypes: (json['messageSubtypes'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      searchStartTime: (json['searchStartTime'] as num?)?.toInt(),
      searchTimePeriod: (json['searchTimePeriod'] as num?)?.toInt(),
      limit: (json['limit'] as num?)?.toInt(),
      direction:
          $enumDecodeNullable(_$NIMSearchDirectionEnumMap, json['direction']),
      strategy:
          $enumDecodeNullable(_$NIMSearchStrategyEnumMap, json['strategy']),
      indices: _nimMessageIndexListFromJson(json['indices'] as List?),
      onlyIndex: json['onlyIndex'] as bool?,
    );

Map<String, dynamic> _$NIMMessageSearchExParamsToJson(
        NIMMessageSearchExParams instance) =>
    <String, dynamic>{
      'conversationId': instance.conversationId,
      'keywordList': instance.keywordList,
      'keywordMatchType':
          _$NIMSearchKeywordMatchTypeEnumMap[instance.keywordMatchType],
      'senderAccountIds': instance.senderAccountIds,
      'messageTypes': instance.messageTypes
          ?.map((e) => _$NIMMessageTypeEnumMap[e]!)
          .toList(),
      'messageSubtypes': instance.messageSubtypes,
      'searchStartTime': instance.searchStartTime,
      'searchTimePeriod': instance.searchTimePeriod,
      'limit': instance.limit,
      'pageToken': instance.pageToken,
      'direction': _$NIMSearchDirectionEnumMap[instance.direction],
      'strategy': _$NIMSearchStrategyEnumMap[instance.strategy],
      'indices': instance.indices?.map((e) => e.toJson()).toList(),
      'onlyIndex': instance.onlyIndex,
    };

const _$NIMSearchKeywordMatchTypeEnumMap = {
  NIMSearchKeywordMatchType.V2NIM_SEARCH_KEYWORD_MATH_TYPE_OR: 0,
  NIMSearchKeywordMatchType.V2NIM_SEARCH_KEYWORD_MATH_TYPE_ADD: 1,
};

const _$NIMMessageTypeEnumMap = {
  NIMMessageType.invalid: -1,
  NIMMessageType.text: 0,
  NIMMessageType.image: 1,
  NIMMessageType.audio: 2,
  NIMMessageType.video: 3,
  NIMMessageType.location: 4,
  NIMMessageType.notification: 5,
  NIMMessageType.file: 6,
  NIMMessageType.avChat: 7,
  NIMMessageType.tip: 10,
  NIMMessageType.robot: 11,
  NIMMessageType.call: 12,
  NIMMessageType.custom: 100,
  NIMMessageType.chatroomNotification: 105,
};

const _$NIMSearchDirectionEnumMap = {
  NIMSearchDirection.V2NIM_SEARCH_DIRECTION_BACKWARD: 0,
  NIMSearchDirection.V2NIM_SEARCH_DIRECTION_FORWARD: 1,
};

const _$NIMSearchStrategyEnumMap = {
  NIMSearchStrategy.V2NIM_SEARCH_STRATEGY_SQL_LIKE: 0,
  NIMSearchStrategy.V2NIM_SEARCH_STRATEGY_FTS: 1,
};

NIMMessageSearchResult _$NIMMessageSearchResultFromJson(
        Map<String, dynamic> json) =>
    NIMMessageSearchResult(
      count: (json['count'] as num?)?.toInt(),
      items: _nimMessageSearchItemListFromJson(json['items'] as List?),
      nextPageToken: json['nextPageToken'] as String?,
      hasMore: json['hasMore'] as bool? ?? false,
    );

Map<String, dynamic> _$NIMMessageSearchResultToJson(
        NIMMessageSearchResult instance) =>
    <String, dynamic>{
      'count': instance.count,
      'items': instance.items?.map((e) => e.toJson()).toList(),
      'nextPageToken': instance.nextPageToken,
      'hasMore': instance.hasMore,
    };

NIMMessageSearchItem _$NIMMessageSearchItemFromJson(
        Map<String, dynamic> json) =>
    NIMMessageSearchItem(
      conversationId: json['conversationId'] as String,
      messages: _nimMessageListFromJson(json['messages'] as List?),
      count: (json['count'] as num).toInt(),
      messageIndexs:
          _nimMessageIndexListFromJson(json['messageIndexs'] as List?),
    );

Map<String, dynamic> _$NIMMessageSearchItemToJson(
        NIMMessageSearchItem instance) =>
    <String, dynamic>{
      'conversationId': instance.conversationId,
      'messages': instance.messages?.map((e) => e.toJson()).toList(),
      'count': instance.count,
      'messageIndexs': instance.messageIndexs?.map((e) => e.toJson()).toList(),
    };

NIMMessageIndex _$NIMMessageIndexFromJson(Map<String, dynamic> json) =>
    NIMMessageIndex(
      conversationId: json['conversationId'] as String,
      messageServerId: (json['messageServerId'] as num).toInt(),
    );

Map<String, dynamic> _$NIMMessageIndexToJson(NIMMessageIndex instance) =>
    <String, dynamic>{
      'conversationId': instance.conversationId,
      'messageServerId': instance.messageServerId,
    };
