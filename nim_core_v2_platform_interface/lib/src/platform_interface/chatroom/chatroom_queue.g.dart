// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chatroom_queue.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

V2NIMChatroomQueueElement _$V2NIMChatroomQueueElementFromJson(
        Map<String, dynamic> json) =>
    V2NIMChatroomQueueElement(
      key: json['key'] as String?,
      value: json['value'] as String?,
      accountId: json['accountId'] as String?,
      nick: json['nick'] as String?,
      extension: json['extension'] as String?,
    );

Map<String, dynamic> _$V2NIMChatroomQueueElementToJson(
        V2NIMChatroomQueueElement instance) =>
    <String, dynamic>{
      'key': instance.key,
      'value': instance.value,
      'accountId': instance.accountId,
      'nick': instance.nick,
      'extension': instance.extension,
    };

V2NIMChatroomQueueOfferParams _$V2NIMChatroomQueueOfferParamsFromJson(
        Map<String, dynamic> json) =>
    V2NIMChatroomQueueOfferParams(
      elementKey: json['elementKey'] as String,
      elementValue: json['elementValue'] as String,
      transient: json['transient'] as bool? ?? false,
      elementOwnerAccountId: json['elementOwnerAccountId'] as String?,
    );

Map<String, dynamic> _$V2NIMChatroomQueueOfferParamsToJson(
        V2NIMChatroomQueueOfferParams instance) =>
    <String, dynamic>{
      'elementKey': instance.elementKey,
      'elementValue': instance.elementValue,
      'transient': instance.transient,
      'elementOwnerAccountId': instance.elementOwnerAccountId,
    };

queueVoidEvent _$queueVoidEventFromJson(Map<String, dynamic> json) =>
    queueVoidEvent(
      instanceId: (json['instanceId'] as num).toInt(),
    );

Map<String, dynamic> _$queueVoidEventToJson(queueVoidEvent instance) =>
    <String, dynamic>{
      'instanceId': instance.instanceId,
    };

onChatroomQueueOfferedEvent _$onChatroomQueueOfferedEventFromJson(
        Map<String, dynamic> json) =>
    onChatroomQueueOfferedEvent(
      instanceId: (json['instanceId'] as num).toInt(),
      element: V2NIMChatroomQueueElementFromJson(json['element'] as Map?),
    );

Map<String, dynamic> _$onChatroomQueueOfferedEventToJson(
        onChatroomQueueOfferedEvent instance) =>
    <String, dynamic>{
      'instanceId': instance.instanceId,
      'element': instance.element?.toJson(),
    };

onChatroomQueuePartClearedEvent _$onChatroomQueuePartClearedEventFromJson(
        Map<String, dynamic> json) =>
    onChatroomQueuePartClearedEvent(
      instanceId: (json['instanceId'] as num).toInt(),
      elements:
          V2NIMChatroomQueueElementListFromJson(json['elements'] as List?),
    );

Map<String, dynamic> _$onChatroomQueuePartClearedEventToJson(
        onChatroomQueuePartClearedEvent instance) =>
    <String, dynamic>{
      'instanceId': instance.instanceId,
      'elements': instance.elements?.map((e) => e.toJson()).toList(),
    };

onChatroomQueueBatchOfferedEvent _$onChatroomQueueBatchOfferedEventFromJson(
        Map<String, dynamic> json) =>
    onChatroomQueueBatchOfferedEvent(
      instanceId: (json['instanceId'] as num).toInt(),
      elements:
          V2NIMChatroomQueueElementListFromJson(json['elements'] as List?),
    );

Map<String, dynamic> _$onChatroomQueueBatchOfferedEventToJson(
        onChatroomQueueBatchOfferedEvent instance) =>
    <String, dynamic>{
      'instanceId': instance.instanceId,
      'elements': instance.elements?.map((e) => e.toJson()).toList(),
    };

onChatroomQueueBatchUpdatedEvent _$onChatroomQueueBatchUpdatedEventFromJson(
        Map<String, dynamic> json) =>
    onChatroomQueueBatchUpdatedEvent(
      instanceId: (json['instanceId'] as num).toInt(),
      elements:
          V2NIMChatroomQueueElementListFromJson(json['elements'] as List?),
    );

Map<String, dynamic> _$onChatroomQueueBatchUpdatedEventToJson(
        onChatroomQueueBatchUpdatedEvent instance) =>
    <String, dynamic>{
      'instanceId': instance.instanceId,
      'elements': instance.elements?.map((e) => e.toJson()).toList(),
    };

onChatroomQueuePolledEvent _$onChatroomQueuePolledEventFromJson(
        Map<String, dynamic> json) =>
    onChatroomQueuePolledEvent(
      instanceId: (json['instanceId'] as num).toInt(),
      element: V2NIMChatroomQueueElementFromJson(json['element'] as Map?),
    );

Map<String, dynamic> _$onChatroomQueuePolledEventToJson(
        onChatroomQueuePolledEvent instance) =>
    <String, dynamic>{
      'instanceId': instance.instanceId,
      'element': instance.element?.toJson(),
    };
