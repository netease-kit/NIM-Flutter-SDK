// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation_group_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

V2NIMConversationGroup _$V2NIMConversationGroupFromJson(
        Map<String, dynamic> json) =>
    V2NIMConversationGroup(
      groupId: json['groupId'] as String,
      name: json['name'] as String?,
      serverExtension: json['serverExtension'] as String?,
      createTime: (json['createTime'] as num?)?.toInt(),
      updateTime: (json['updateTime'] as num?)?.toInt(),
    );

Map<String, dynamic> _$V2NIMConversationGroupToJson(
        V2NIMConversationGroup instance) =>
    <String, dynamic>{
      'groupId': instance.groupId,
      'name': instance.name,
      'serverExtension': instance.serverExtension,
      'createTime': instance.createTime,
      'updateTime': instance.updateTime,
    };

V2NIMConversationOperationResult _$V2NIMConversationOperationResultFromJson(
        Map<String, dynamic> json) =>
    V2NIMConversationOperationResult(
      conversationId: json['conversationId'] as String,
      error: _nimErrorFromJson(json['error'] as Map?),
    );

Map<String, dynamic> _$V2NIMConversationOperationResultToJson(
        V2NIMConversationOperationResult instance) =>
    <String, dynamic>{
      'conversationId': instance.conversationId,
      'error': instance.error?.toJson(),
    };

V2NIMConversationGroupResult _$V2NIMConversationGroupResultFromJson(
        Map<String, dynamic> json) =>
    V2NIMConversationGroupResult(
      failedList: V2NIMConversationOperationResultListFromJson(
          json['failedList'] as List?),
      group: V2NIMConversationGroupFromJson(json['group'] as Map?),
    );

Map<String, dynamic> _$V2NIMConversationGroupResultToJson(
        V2NIMConversationGroupResult instance) =>
    <String, dynamic>{
      'group': instance.group?.toJson(),
      'failedList': instance.failedList?.map((e) => e.toJson()).toList(),
    };

ConversationsAddedEvent _$ConversationsAddedEventFromJson(
        Map<String, dynamic> json) =>
    ConversationsAddedEvent(
      groupId: json['groupId'] as String,
      conversations:
          NIMConversationListFromJson(json['conversations'] as List?),
    );

Map<String, dynamic> _$ConversationsAddedEventToJson(
        ConversationsAddedEvent instance) =>
    <String, dynamic>{
      'groupId': instance.groupId,
      'conversations': instance.conversations?.map((e) => e.toJson()).toList(),
    };

ConversationsRemovedEvent _$ConversationsRemovedEventFromJson(
        Map<String, dynamic> json) =>
    ConversationsRemovedEvent(
      groupId: json['groupId'] as String,
      conversationIds: (json['conversationIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$ConversationsRemovedEventToJson(
        ConversationsRemovedEvent instance) =>
    <String, dynamic>{
      'groupId': instance.groupId,
      'conversationIds': instance.conversationIds,
    };
