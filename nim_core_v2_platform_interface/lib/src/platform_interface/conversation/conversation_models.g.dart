// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NIMConversation _$NIMConversationFromJson(Map<String, dynamic> json) =>
    NIMConversation(
      conversationId: json['conversationId'] as String,
      type: $enumDecode(_$NIMConversationTypeEnumMap, json['type']),
      name: json['name'] as String?,
      avatar: json['avatar'] as String?,
      mute: json['mute'] as bool,
      stickTop: json['stickTop'] as bool,
      groupIds: (json['groupIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      localExtension: json['localExtension'] as String?,
      serverExtension: json['serverExtension'] as String?,
      lastMessage: _nimLastMessageFromJson(json['lastMessage'] as Map?),
      unreadCount: (json['unreadCount'] as num?)?.toInt(),
      sortOrder: (json['sortOrder'] as num?)?.toInt(),
      createTime: (json['createTime'] as num).toInt(),
      updateTime: (json['updateTime'] as num).toInt(),
    );

Map<String, dynamic> _$NIMConversationToJson(NIMConversation instance) =>
    <String, dynamic>{
      'conversationId': instance.conversationId,
      'type': _$NIMConversationTypeEnumMap[instance.type]!,
      'name': instance.name,
      'avatar': instance.avatar,
      'mute': instance.mute,
      'stickTop': instance.stickTop,
      'groupIds': instance.groupIds,
      'localExtension': instance.localExtension,
      'serverExtension': instance.serverExtension,
      'lastMessage': instance.lastMessage?.toJson(),
      'unreadCount': instance.unreadCount,
      'sortOrder': instance.sortOrder,
      'createTime': instance.createTime,
      'updateTime': instance.updateTime,
    };

const _$NIMConversationTypeEnumMap = {
  NIMConversationType.unknown: 0,
  NIMConversationType.p2p: 1,
  NIMConversationType.team: 2,
  NIMConversationType.superTeam: 3,
};

NIMLastMessage _$NIMLastMessageFromJson(Map<String, dynamic> json) =>
    NIMLastMessage(
      lastMessageState: $enumDecodeNullable(
          _$NIMLastMessageStateEnumMap, json['lastMessageState']),
      messageRefer: _nimMessageReferFromJson(json['messageRefer'] as Map?),
      messageType:
          $enumDecodeNullable(_$NIMMessageTypeEnumMap, json['messageType']),
      subType: (json['subType'] as num?)?.toInt(),
      sendingState: $enumDecodeNullable(
          _$NIMMessageSendingStateEnumMap, json['sendingState']),
      text: json['text'] as String?,
      attachment: _nimMessageAttachmentFromJson(json['attachment'] as Map?),
      revokeAccountId: json['revokeAccountId'] as String?,
      revokeType: $enumDecodeNullable(
          _$NIMMessageRevokeTypeEnumMap, json['revokeType']),
      serverExtension: json['serverExtension'] as String?,
      callbackExtension: json['callbackExtension'] as String?,
      senderName: json['senderName'] as String?,
    );

Map<String, dynamic> _$NIMLastMessageToJson(NIMLastMessage instance) =>
    <String, dynamic>{
      'lastMessageState':
          _$NIMLastMessageStateEnumMap[instance.lastMessageState],
      'messageRefer': instance.messageRefer?.toJson(),
      'messageType': _$NIMMessageTypeEnumMap[instance.messageType],
      'subType': instance.subType,
      'sendingState': _$NIMMessageSendingStateEnumMap[instance.sendingState],
      'text': instance.text,
      'attachment': instance.attachment?.toJson(),
      'revokeAccountId': instance.revokeAccountId,
      'revokeType': _$NIMMessageRevokeTypeEnumMap[instance.revokeType],
      'serverExtension': instance.serverExtension,
      'callbackExtension': instance.callbackExtension,
      'senderName': instance.senderName,
    };

const _$NIMLastMessageStateEnumMap = {
  NIMLastMessageState.defaultState: 0,
  NIMLastMessageState.revoke: 1,
  NIMLastMessageState.clientFill: 2,
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
};

const _$NIMMessageSendingStateEnumMap = {
  NIMMessageSendingState.unknown: 0,
  NIMMessageSendingState.succeeded: 1,
  NIMMessageSendingState.failed: 2,
  NIMMessageSendingState.sending: 3,
};

const _$NIMMessageRevokeTypeEnumMap = {
  NIMMessageRevokeType.undefined: 0,
  NIMMessageRevokeType.p2pBothway: 1,
  NIMMessageRevokeType.teamBothway: 2,
  NIMMessageRevokeType.superTeamBothway: 3,
  NIMMessageRevokeType.p2pOneway: 4,
  NIMMessageRevokeType.teamOneway: 5,
};

NIMConversationResult _$NIMConversationResultFromJson(
        Map<String, dynamic> json) =>
    NIMConversationResult(
      conversationList:
          _conversationListFromJson(json['conversationList'] as List?),
      offset: (json['offset'] as num).toInt(),
      finished: json['finished'] as bool,
    );

Map<String, dynamic> _$NIMConversationResultToJson(
        NIMConversationResult instance) =>
    <String, dynamic>{
      'conversationList':
          instance.conversationList?.map((e) => e.toJson()).toList(),
      'offset': instance.offset,
      'finished': instance.finished,
    };

NIMConversationFilter _$NIMConversationFilterFromJson(
        Map<String, dynamic> json) =>
    NIMConversationFilter(
      conversationTypes: (json['conversationTypes'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$NIMConversationTypeEnumMap, e))
          .toList(),
      conversationGroupId: json['conversationGroupId'] as String?,
      ignoreMuted: json['ignoreMuted'] as bool?,
    );

Map<String, dynamic> _$NIMConversationFilterToJson(
        NIMConversationFilter instance) =>
    <String, dynamic>{
      'conversationTypes': instance.conversationTypes
          ?.map((e) => _$NIMConversationTypeEnumMap[e]!)
          .toList(),
      'conversationGroupId': instance.conversationGroupId,
      'ignoreMuted': instance.ignoreMuted,
    };

UnreadChangeFilterResult _$UnreadChangeFilterResultFromJson(
        Map<String, dynamic> json) =>
    UnreadChangeFilterResult(
      conversationFilter:
          _nimConversationFilterFromJson(json['conversationFilter'] as Map?),
      unreadCount: (json['unreadCount'] as num?)?.toInt(),
    );

Map<String, dynamic> _$UnreadChangeFilterResultToJson(
        UnreadChangeFilterResult instance) =>
    <String, dynamic>{
      'conversationFilter': instance.conversationFilter?.toJson(),
      'unreadCount': instance.unreadCount,
    };

ReadTimeUpdateResult _$ReadTimeUpdateResultFromJson(
        Map<String, dynamic> json) =>
    ReadTimeUpdateResult(
      conversationId: json['conversationId'] as String,
      readTime: (json['readTime'] as num).toInt(),
    );

Map<String, dynamic> _$ReadTimeUpdateResultToJson(
        ReadTimeUpdateResult instance) =>
    <String, dynamic>{
      'conversationId': instance.conversationId,
      'readTime': instance.readTime,
    };

NIMConversationOperationResult _$NIMConversationOperationResultFromJson(
        Map<String, dynamic> json) =>
    NIMConversationOperationResult(
      conversationId: json['conversationId'] as String?,
      error: json['error'] == null
          ? null
          : NIMError.fromJson(json['error'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$NIMConversationOperationResultToJson(
        NIMConversationOperationResult instance) =>
    <String, dynamic>{
      'conversationId': instance.conversationId,
      'error': instance.error?.toJson(),
    };

NIMConversationTypeClass _$NIMConversationTypeClassFromJson(
        Map<String, dynamic> json) =>
    NIMConversationTypeClass(
      conversationType:
          $enumDecode(_$NIMConversationTypeEnumMap, json['conversationType']),
    );

Map<String, dynamic> _$NIMConversationTypeClassToJson(
        NIMConversationTypeClass instance) =>
    <String, dynamic>{
      'conversationType':
          _$NIMConversationTypeEnumMap[instance.conversationType]!,
    };

NIMConversationOption _$NIMConversationOptionFromJson(
        Map<String, dynamic> json) =>
    NIMConversationOption(
      conversationTypes: (json['conversationTypes'] as List<dynamic>)
          .map((e) => $enumDecode(_$NIMConversationTypeEnumMap, e))
          .toList(),
      onlyUnread: json['onlyUnread'] as bool,
      conversationGroupIds: (json['conversationGroupIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$NIMConversationOptionToJson(
        NIMConversationOption instance) =>
    <String, dynamic>{
      'conversationTypes': instance.conversationTypes
          .map((e) => _$NIMConversationTypeEnumMap[e]!)
          .toList(),
      'onlyUnread': instance.onlyUnread,
      'conversationGroupIds': instance.conversationGroupIds,
    };

NIMConversationUpdate _$NIMConversationUpdateFromJson(
        Map<String, dynamic> json) =>
    NIMConversationUpdate(
      serverExtension: json['serverExtension'] as String,
    );

Map<String, dynamic> _$NIMConversationUpdateToJson(
        NIMConversationUpdate instance) =>
    <String, dynamic>{
      'serverExtension': instance.serverExtension,
    };
