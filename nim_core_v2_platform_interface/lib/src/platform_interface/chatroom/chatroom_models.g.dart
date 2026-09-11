// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chatroom_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

V2NIMChatroomEnterResult _$V2NIMChatroomEnterResultFromJson(
        Map<String, dynamic> json) =>
    V2NIMChatroomEnterResult(
      chatroom: v2NIMChatroomInfoFromJson(json['chatroom'] as Map?),
      selfMember: v2NIMChatroomMemberFromJson(json['selfMember'] as Map?),
    );

Map<String, dynamic> _$V2NIMChatroomEnterResultToJson(
        V2NIMChatroomEnterResult instance) =>
    <String, dynamic>{
      'chatroom': instance.chatroom?.toJson(),
      'selfMember': instance.selfMember?.toJson(),
    };

V2NIMChatroomEnterParams _$V2NIMChatroomEnterParamsFromJson(
        Map<String, dynamic> json) =>
    V2NIMChatroomEnterParams(
      accountId: json['accountId'] as String?,
      serverExtension: json['serverExtension'] as String?,
      anonymousMode: json['anonymousMode'] as bool? ?? false,
      antispamConfig: NIMAntispamConfigFromJson(json['antispamConfig'] as Map?),
      authType:
          $enumDecodeNullable(_$NIMLoginAuthTypeEnumMap, json['authType']),
      locationConfig:
          V2NIMChatroomLocationConfigFromJson(json['locationConfig'] as Map?),
      notificationExtension: json['notificationExtension'] as String?,
      roomAvatar: json['roomAvatar'] as String?,
      roomNick: json['roomNick'] as String?,
      tagConfig: V2NIMChatroomTagConfigFromJson(json['tagConfig'] as Map?),
      timeout: (json['timeout'] as num?)?.toInt(),
      token: json['token'] as String?,
    );

Map<String, dynamic> _$V2NIMChatroomEnterParamsToJson(
        V2NIMChatroomEnterParams instance) =>
    <String, dynamic>{
      'anonymousMode': instance.anonymousMode,
      'accountId': instance.accountId,
      'token': instance.token,
      'roomNick': instance.roomNick,
      'roomAvatar': instance.roomAvatar,
      'timeout': instance.timeout,
      'authType': _$NIMLoginAuthTypeEnumMap[instance.authType],
      'serverExtension': instance.serverExtension,
      'notificationExtension': instance.notificationExtension,
      'tagConfig': instance.tagConfig?.toJson(),
      'locationConfig': instance.locationConfig?.toJson(),
      'antispamConfig': instance.antispamConfig?.toJson(),
    };

const _$NIMLoginAuthTypeEnumMap = {
  NIMLoginAuthType.authTypeDefault: 0,
  NIMLoginAuthType.authTypeDynamicToken: 1,
  NIMLoginAuthType.authTypeThirdParty: 2,
};

V2NIMChatroomTagConfig _$V2NIMChatroomTagConfigFromJson(
        Map<String, dynamic> json) =>
    V2NIMChatroomTagConfig(
      notifyTargetTags: json['notifyTargetTags'] as String?,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$V2NIMChatroomTagConfigToJson(
        V2NIMChatroomTagConfig instance) =>
    <String, dynamic>{
      'tags': instance.tags,
      'notifyTargetTags': instance.notifyTargetTags,
    };

V2NIMChatroomLocationConfig _$V2NIMChatroomLocationConfigFromJson(
        Map<String, dynamic> json) =>
    V2NIMChatroomLocationConfig(
      distance: (json['distance'] as num?)?.toDouble(),
      locationInfo: V2NIMLocationInfoFromJson(json['locationInfo'] as Map?),
    );

Map<String, dynamic> _$V2NIMChatroomLocationConfigToJson(
        V2NIMChatroomLocationConfig instance) =>
    <String, dynamic>{
      'locationInfo': instance.locationInfo?.toJson(),
      'distance': instance.distance,
    };

V2NIMChatroomInfo _$V2NIMChatroomInfoFromJson(Map<String, dynamic> json) =>
    V2NIMChatroomInfo(
      serverExtension: json['serverExtension'] as String?,
      announcement: json['announcement'] as String?,
      chatBanned: json['chatBanned'] as bool?,
      creatorAccountId: json['creatorAccountId'] as String?,
      liveUrl: json['liveUrl'] as String?,
      onlineUserCount: (json['onlineUserCount'] as num?)?.toInt(),
      queueLevelMode: $enumDecodeNullable(
          _$V2NIMChatroomQueueLevelModeEnumMap, json['queueLevelMode']),
      roomId: json['roomId'] as String?,
      roomName: json['roomName'] as String?,
      isValidRoom: json['isValidRoom'] as bool?,
    );

Map<String, dynamic> _$V2NIMChatroomInfoToJson(V2NIMChatroomInfo instance) =>
    <String, dynamic>{
      'roomId': instance.roomId,
      'roomName': instance.roomName,
      'announcement': instance.announcement,
      'liveUrl': instance.liveUrl,
      'isValidRoom': instance.isValidRoom,
      'serverExtension': instance.serverExtension,
      'queueLevelMode':
          _$V2NIMChatroomQueueLevelModeEnumMap[instance.queueLevelMode],
      'creatorAccountId': instance.creatorAccountId,
      'onlineUserCount': instance.onlineUserCount,
      'chatBanned': instance.chatBanned,
    };

const _$V2NIMChatroomQueueLevelModeEnumMap = {
  V2NIMChatroomQueueLevelMode.V2NIM_CHATROOM_QUEUE_LEVEL_MODE_ANY: 0,
  V2NIMChatroomQueueLevelMode.V2NIM_CHATROOM_QUEUE_LEVEL_MODE_MANAGER: 1,
};

V2NIMChatroomStatusInfo _$V2NIMChatroomStatusInfoFromJson(
        Map<String, dynamic> json) =>
    V2NIMChatroomStatusInfo(
      status: $enumDecode(_$V2NIMChatroomStatusEnumMap, json['status']),
      error: NIMErrorFromJson(json['error'] as Map?),
    )..instanceId = (json['instanceId'] as num?)?.toInt();

Map<String, dynamic> _$V2NIMChatroomStatusInfoToJson(
        V2NIMChatroomStatusInfo instance) =>
    <String, dynamic>{
      'instanceId': instance.instanceId,
      'status': _$V2NIMChatroomStatusEnumMap[instance.status]!,
      'error': instance.error?.toJson(),
    };

const _$V2NIMChatroomStatusEnumMap = {
  V2NIMChatroomStatus.V2NIM_CHATROOM_STATUS_DISCONNECTED: 0,
  V2NIMChatroomStatus.V2NIM_CHATROOM_STATUS_WAITING: 1,
  V2NIMChatroomStatus.V2NIM_CHATROOM_STATUS_CONNECTING: 2,
  V2NIMChatroomStatus.V2NIM_CHATROOM_STATUS_CONNECTED: 3,
  V2NIMChatroomStatus.V2NIM_CHATROOM_STATUS_ENTERING: 4,
  V2NIMChatroomStatus.V2NIM_CHATROOM_STATUS_ENTERED: 5,
  V2NIMChatroomStatus.V2NIM_CHATROOM_STATUS_EXITED: 6,
};

V2NIMChatroomKickedInfoEvent _$V2NIMChatroomKickedInfoEventFromJson(
        Map<String, dynamic> json) =>
    V2NIMChatroomKickedInfoEvent(
      instanceId: (json['instanceId'] as num?)?.toInt(),
      kickedInfo: V2NIMChatroomKickedInfoFromJson(json['kickedInfo'] as Map?),
    );

Map<String, dynamic> _$V2NIMChatroomKickedInfoEventToJson(
        V2NIMChatroomKickedInfoEvent instance) =>
    <String, dynamic>{
      'instanceId': instance.instanceId,
      'kickedInfo': instance.kickedInfo?.toJson(),
    };

V2NIMChatroomKickedInfo _$V2NIMChatroomKickedInfoFromJson(
        Map<String, dynamic> json) =>
    V2NIMChatroomKickedInfo(
      json['serverExtension'] as String?,
      $enumDecodeNullable(
          _$V2NIMChatroomKickedReasonEnumMap, json['kickedReason']),
    );

Map<String, dynamic> _$V2NIMChatroomKickedInfoToJson(
        V2NIMChatroomKickedInfo instance) =>
    <String, dynamic>{
      'kickedReason': _$V2NIMChatroomKickedReasonEnumMap[instance.kickedReason],
      'serverExtension': instance.serverExtension,
    };

const _$V2NIMChatroomKickedReasonEnumMap = {
  V2NIMChatroomKickedReason.V2NIM_CHATROOM_KICKED_REASON_UNKNOWN: -1,
  V2NIMChatroomKickedReason.V2NIM_CHATROOM_KICKED_REASON_CHATROOM_INVALID: 1,
  V2NIMChatroomKickedReason.V2NIM_CHATROOM_KICKED_REASON_BY_MANAGER: 2,
  V2NIMChatroomKickedReason.V2NIM_CHATROOM_KICKED_REASON_BY_CONFLICT_LOGIN: 3,
  V2NIMChatroomKickedReason.V2NIM_CHATROOM_KICKED_REASON_SILENTLY: 4,
  V2NIMChatroomKickedReason.V2NIM_CHATROOM_KICKED_REASON_BE_BLOCKED: 5,
};

ChatRoomExitInfo _$ChatRoomExitInfoFromJson(Map<String, dynamic> json) =>
    ChatRoomExitInfo(
      instanceId: (json['instanceId'] as num?)?.toInt(),
      error: NIMErrorFromJson(json['error'] as Map?),
    );

Map<String, dynamic> _$ChatRoomExitInfoToJson(ChatRoomExitInfo instance) =>
    <String, dynamic>{
      'instanceId': instance.instanceId,
      'error': instance.error?.toJson(),
    };
