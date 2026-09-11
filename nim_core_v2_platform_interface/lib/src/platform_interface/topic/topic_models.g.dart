// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'topic_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

V2NIMTopicRefer _$V2NIMTopicReferFromJson(Map<String, dynamic> json) =>
    V2NIMTopicRefer(
      conversationId: json['conversationId'] as String?,
      topicId: (json['topicId'] as num?)?.toInt(),
      createTime: (json['createTime'] as num?)?.toInt(),
    );

Map<String, dynamic> _$V2NIMTopicReferToJson(V2NIMTopicRefer instance) =>
    <String, dynamic>{
      'conversationId': instance.conversationId,
      'topicId': instance.topicId,
      'createTime': instance.createTime,
    };

V2NIMTopic _$V2NIMTopicFromJson(Map<String, dynamic> json) => V2NIMTopic(
      conversationId: json['conversationId'] as String?,
      topicId: (json['topicId'] as num?)?.toInt(),
      createTime: (json['createTime'] as num?)?.toInt(),
      topicName: json['topicName'] as String?,
      messageClientId: json['messageClientId'] as String?,
      messageServerId: json['messageServerId'] as String?,
      messageTime: (json['messageTime'] as num?)?.toInt(),
      serverExtension: json['serverExtension'] as String?,
      updateTime: (json['updateTime'] as num?)?.toInt(),
      data: json['data'] as String?,
    );

Map<String, dynamic> _$V2NIMTopicToJson(V2NIMTopic instance) =>
    <String, dynamic>{
      'conversationId': instance.conversationId,
      'topicId': instance.topicId,
      'createTime': instance.createTime,
      'topicName': instance.topicName,
      'messageClientId': instance.messageClientId,
      'messageServerId': instance.messageServerId,
      'messageTime': instance.messageTime,
      'serverExtension': instance.serverExtension,
      'updateTime': instance.updateTime,
      'data': instance.data,
    };

V2NIMUpdateTopicParams _$V2NIMUpdateTopicParamsFromJson(
        Map<String, dynamic> json) =>
    V2NIMUpdateTopicParams(
      topic: nimTopicFromJson(json['topic'] as Map?),
      topicName: json['topicName'] as String?,
      serverExtension: json['serverExtension'] as String?,
    );

Map<String, dynamic> _$V2NIMUpdateTopicParamsToJson(
        V2NIMUpdateTopicParams instance) =>
    <String, dynamic>{
      'topic': instance.topic?.toJson(),
      'topicName': instance.topicName,
      'serverExtension': instance.serverExtension,
    };

V2NIMRemoveTopicsParams _$V2NIMRemoveTopicsParamsFromJson(
        Map<String, dynamic> json) =>
    V2NIMRemoveTopicsParams(
      topicList: nimTopicListFromJson(json['topicList'] as List?),
    );

Map<String, dynamic> _$V2NIMRemoveTopicsParamsToJson(
        V2NIMRemoveTopicsParams instance) =>
    <String, dynamic>{
      'topicList': instance.topicList?.map((e) => e.toJson()).toList(),
    };

V2NIMCreateTopicParams _$V2NIMCreateTopicParamsFromJson(
        Map<String, dynamic> json) =>
    V2NIMCreateTopicParams(
      topicName: json['topicName'] as String?,
      serverExtension: json['serverExtension'] as String?,
    );

Map<String, dynamic> _$V2NIMCreateTopicParamsToJson(
        V2NIMCreateTopicParams instance) =>
    <String, dynamic>{
      'topicName': instance.topicName,
      'serverExtension': instance.serverExtension,
    };

V2NIMSendTopicMessageParams _$V2NIMSendTopicMessageParamsFromJson(
        Map<String, dynamic> json) =>
    V2NIMSendTopicMessageParams(
      sendMessageParams:
          nimSendMessageParamsFromJson(json['sendMessageParams'] as Map?),
      createTopicParams:
          nimCreateTopicParamsFromJson(json['createTopicParams'] as Map?),
    );

Map<String, dynamic> _$V2NIMSendTopicMessageParamsToJson(
        V2NIMSendTopicMessageParams instance) =>
    <String, dynamic>{
      'sendMessageParams': instance.sendMessageParams?.toJson(),
      'createTopicParams': instance.createTopicParams?.toJson(),
    };

V2NIMTopicListOption _$V2NIMTopicListOptionFromJson(
        Map<String, dynamic> json) =>
    V2NIMTopicListOption(
      conversationId: json['conversationId'] as String?,
      beginTime: (json['beginTime'] as num?)?.toInt(),
      endTime: (json['endTime'] as num?)?.toInt(),
      nextToken: json['nextToken'] as String?,
      limit: (json['limit'] as num?)?.toInt(),
      direction:
          $enumDecodeNullable(_$NIMQueryDirectionEnumMap, json['direction']),
    );

Map<String, dynamic> _$V2NIMTopicListOptionToJson(
        V2NIMTopicListOption instance) =>
    <String, dynamic>{
      'conversationId': instance.conversationId,
      'beginTime': instance.beginTime,
      'endTime': instance.endTime,
      'nextToken': instance.nextToken,
      'limit': instance.limit,
      'direction': _$NIMQueryDirectionEnumMap[instance.direction],
    };

const _$NIMQueryDirectionEnumMap = {
  NIMQueryDirection.desc: 0,
  NIMQueryDirection.asc: 1,
};

V2NIMTopicListResult _$V2NIMTopicListResultFromJson(
        Map<String, dynamic> json) =>
    V2NIMTopicListResult(
      topicList: nimTopicListFromJson(json['topicList'] as List?),
      nextToken: json['nextToken'] as String?,
      hasMore: json['hasMore'] as bool?,
    );

Map<String, dynamic> _$V2NIMTopicListResultToJson(
        V2NIMTopicListResult instance) =>
    <String, dynamic>{
      'topicList': instance.topicList?.map((e) => e.toJson()).toList(),
      'nextToken': instance.nextToken,
      'hasMore': instance.hasMore,
    };

V2NIMTopicMessageListOption _$V2NIMTopicMessageListOptionFromJson(
        Map<String, dynamic> json) =>
    V2NIMTopicMessageListOption(
      topic: nimTopicFromJson(json['topic'] as Map?),
      beginTime: (json['beginTime'] as num?)?.toInt(),
      endTime: (json['endTime'] as num?)?.toInt(),
      anchorMessage: nimMessageFromJson(json['anchorMessage'] as Map?),
      limit: (json['limit'] as num?)?.toInt(),
      direction:
          $enumDecodeNullable(_$NIMQueryDirectionEnumMap, json['direction']),
      sortOrder: $enumDecodeNullable(_$NIMSortOrderEnumMap, json['sortOrder']),
    );

Map<String, dynamic> _$V2NIMTopicMessageListOptionToJson(
        V2NIMTopicMessageListOption instance) =>
    <String, dynamic>{
      'topic': instance.topic?.toJson(),
      'beginTime': instance.beginTime,
      'endTime': instance.endTime,
      'anchorMessage': instance.anchorMessage?.toJson(),
      'limit': instance.limit,
      'direction': _$NIMQueryDirectionEnumMap[instance.direction],
      'sortOrder': _$NIMSortOrderEnumMap[instance.sortOrder],
    };

const _$NIMSortOrderEnumMap = {
  NIMSortOrder.sortOrderDesc: 0,
  NIMSortOrder.sortOrderAsc: 1,
};

V2NIMTopicMessageListResult _$V2NIMTopicMessageListResultFromJson(
        Map<String, dynamic> json) =>
    V2NIMTopicMessageListResult(
      replyList: nimMessageListFromJson(json['replyList'] as List?),
      hasMore: json['hasMore'] as bool?,
      anchorMessage: nimMessageFromJson(json['anchorMessage'] as Map?),
    );

Map<String, dynamic> _$V2NIMTopicMessageListResultToJson(
        V2NIMTopicMessageListResult instance) =>
    <String, dynamic>{
      'replyList': instance.replyList?.map((e) => e.toJson()).toList(),
      'hasMore': instance.hasMore,
      'anchorMessage': instance.anchorMessage?.toJson(),
    };
