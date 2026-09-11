// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chatroom_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

V2NIMChatroomMessage _$V2NIMChatroomMessageFromJson(
        Map<String, dynamic> json) =>
    V2NIMChatroomMessage(
      subType: (json['subType'] as num?)?.toInt(),
      routeConfig: nimMessageRouteConfigFromJson(json['routeConfig'] as Map?),
      antispamConfig:
          nimMessageAntispamConfigFromJson(json['antispamConfig'] as Map?),
      text: json['text'] as String?,
      serverExtension: json['serverExtension'] as String?,
      attachment: nimMessageAttachmentFromJson(json['attachment'] as Map?),
      messageConfig:
          V2NIMChatroomMessageConfigFromJson(json['messageConfig'] as Map?),
      messageClientId: json['messageClientId'] as String?,
      createTime: (json['createTime'] as num?)?.toInt(),
      senderId: json['senderId'] as String?,
      sendingState: $enumDecodeNullable(
          _$NIMMessageSendingStateEnumMap, json['sendingState']),
      isSelf: json['isSelf'] as bool?,
      messageType:
          $enumDecodeNullable(_$NIMMessageTypeEnumMap, json['messageType']),
      attachmentUploadState: $enumDecodeNullable(
          _$NIMMessageAttachmentUploadStateEnumMap,
          json['attachmentUploadState']),
      callbackExtension: json['callbackExtension'] as String?,
      locationInfo: V2NIMLocationInfoFromJson(json['locationInfo'] as Map?),
      notifyTargetTags: json['notifyTargetTags'] as String?,
      roomId: json['roomId'] as String?,
      senderClientType: (json['senderClientType'] as num?)?.toInt(),
      userInfoConfig:
          V2NIMUserInfoConfigFromJson(json['userInfoConfig'] as Map?),
    );

Map<String, dynamic> _$V2NIMChatroomMessageToJson(
        V2NIMChatroomMessage instance) =>
    <String, dynamic>{
      'messageClientId': instance.messageClientId,
      'senderClientType': instance.senderClientType,
      'createTime': instance.createTime,
      'senderId': instance.senderId,
      'roomId': instance.roomId,
      'isSelf': instance.isSelf,
      'attachmentUploadState': _$NIMMessageAttachmentUploadStateEnumMap[
          instance.attachmentUploadState],
      'sendingState': _$NIMMessageSendingStateEnumMap[instance.sendingState],
      'messageType': _$NIMMessageTypeEnumMap[instance.messageType],
      'subType': instance.subType,
      'text': instance.text,
      'attachment': instance.attachment?.toJson(),
      'serverExtension': instance.serverExtension,
      'callbackExtension': instance.callbackExtension,
      'routeConfig': instance.routeConfig?.toJson(),
      'antispamConfig': instance.antispamConfig?.toJson(),
      'notifyTargetTags': instance.notifyTargetTags,
      'messageConfig': instance.messageConfig?.toJson(),
      'userInfoConfig': instance.userInfoConfig?.toJson(),
      'locationInfo': instance.locationInfo?.toJson(),
    };

const _$NIMMessageSendingStateEnumMap = {
  NIMMessageSendingState.unknown: 0,
  NIMMessageSendingState.succeeded: 1,
  NIMMessageSendingState.failed: 2,
  NIMMessageSendingState.sending: 3,
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

const _$NIMMessageAttachmentUploadStateEnumMap = {
  NIMMessageAttachmentUploadState.unknown: 0,
  NIMMessageAttachmentUploadState.succeed: 1,
  NIMMessageAttachmentUploadState.failed: 2,
  NIMMessageAttachmentUploadState.uploading: 3,
};

V2NIMChatroomMessageConfig _$V2NIMChatroomMessageConfigFromJson(
        Map<String, dynamic> json) =>
    V2NIMChatroomMessageConfig(
      highPriority: json['highPriority'] as bool?,
      historyEnabled: json['historyEnabled'] as bool?,
    );

Map<String, dynamic> _$V2NIMChatroomMessageConfigToJson(
        V2NIMChatroomMessageConfig instance) =>
    <String, dynamic>{
      'historyEnabled': instance.historyEnabled,
      'highPriority': instance.highPriority,
    };

V2NIMUserInfoConfig _$V2NIMUserInfoConfigFromJson(Map<String, dynamic> json) =>
    V2NIMUserInfoConfig(
      senderAvatar: json['senderAvatar'] as String?,
      senderExtension: json['senderExtension'] as String?,
      senderNick: json['senderNick'] as String?,
      userInfoTimestamp: (json['userInfoTimestamp'] as num?)?.toInt(),
    );

Map<String, dynamic> _$V2NIMUserInfoConfigToJson(
        V2NIMUserInfoConfig instance) =>
    <String, dynamic>{
      'userInfoTimestamp': instance.userInfoTimestamp,
      'senderNick': instance.senderNick,
      'senderAvatar': instance.senderAvatar,
      'senderExtension': instance.senderExtension,
    };

V2NIMLocationInfo _$V2NIMLocationInfoFromJson(Map<String, dynamic> json) =>
    V2NIMLocationInfo(
      x: (json['x'] as num?)?.toDouble(),
      y: (json['y'] as num?)?.toDouble(),
      z: (json['z'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$V2NIMLocationInfoToJson(V2NIMLocationInfo instance) =>
    <String, dynamic>{
      'x': instance.x,
      'y': instance.y,
      'z': instance.z,
    };

V2NIMSendChatroomMessageParams _$V2NIMSendChatroomMessageParamsFromJson(
        Map<String, dynamic> json) =>
    V2NIMSendChatroomMessageParams(
      messageConfig:
          V2NIMChatroomMessageConfigFromJson(json['messageConfig'] as Map?),
      routeConfig: nimMessageRouteConfigFromJson(json['routeConfig'] as Map?),
      antispamConfig:
          nimMessageAntispamConfigFromJson(json['antispamConfig'] as Map?),
      clientAntispamEnabled: json['clientAntispamEnabled'] as bool?,
      clientAntispamReplace: json['clientAntispamReplace'] as String?,
      locationInfo: V2NIMLocationInfoFromJson(json['locationInfo'] as Map?),
      notifyTargetTags: json['notifyTargetTags'] as String?,
      receiverIds: (json['receiverIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$V2NIMSendChatroomMessageParamsToJson(
        V2NIMSendChatroomMessageParams instance) =>
    <String, dynamic>{
      'messageConfig': instance.messageConfig?.toJson(),
      'routeConfig': instance.routeConfig?.toJson(),
      'antispamConfig': instance.antispamConfig?.toJson(),
      'clientAntispamEnabled': instance.clientAntispamEnabled,
      'clientAntispamReplace': instance.clientAntispamReplace,
      'receiverIds': instance.receiverIds,
      'notifyTargetTags': instance.notifyTargetTags,
      'locationInfo': instance.locationInfo?.toJson(),
    };

V2NIMSendChatroomMessageResult _$V2NIMSendChatroomMessageResultFromJson(
        Map<String, dynamic> json) =>
    V2NIMSendChatroomMessageResult(
      message: V2NIMChatroomMessageFromJson(json['message'] as Map?),
      antispamResult: json['antispamResult'] as String?,
      clientAntispamResult:
          nimClientAntispamResultFromJson(json['clientAntispamResult'] as Map?),
    );

Map<String, dynamic> _$V2NIMSendChatroomMessageResultToJson(
        V2NIMSendChatroomMessageResult instance) =>
    <String, dynamic>{
      'message': instance.message?.toJson(),
      'antispamResult': instance.antispamResult,
      'clientAntispamResult': instance.clientAntispamResult?.toJson(),
    };

V2NIMChatroomMemberQueryOption _$V2NIMChatroomMemberQueryOptionFromJson(
        Map<String, dynamic> json) =>
    V2NIMChatroomMemberQueryOption(
      memberRoles: (json['memberRoles'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$V2NIMChatroomMemberRoleEnumMap, e))
          .toList(),
      onlyBlocked: json['onlyBlocked'] as bool?,
      onlyChatBanned: json['onlyChatBanned'] as bool?,
      onlyOnline: json['onlyOnline'] as bool?,
      pageToken: json['pageToken'] as String?,
      limit: (json['limit'] as num?)?.toInt(),
    );

Map<String, dynamic> _$V2NIMChatroomMemberQueryOptionToJson(
        V2NIMChatroomMemberQueryOption instance) =>
    <String, dynamic>{
      'memberRoles': instance.memberRoles
          ?.map((e) => _$V2NIMChatroomMemberRoleEnumMap[e]!)
          .toList(),
      'onlyBlocked': instance.onlyBlocked,
      'onlyChatBanned': instance.onlyChatBanned,
      'onlyOnline': instance.onlyOnline,
      'pageToken': instance.pageToken,
      'limit': instance.limit,
    };

const _$V2NIMChatroomMemberRoleEnumMap = {
  V2NIMChatroomMemberRole.V2NIM_CHATROOM_MEMBER_ROLE_NORMAL: 0,
  V2NIMChatroomMemberRole.V2NIM_CHATROOM_MEMBER_ROLE_CREATOR: 1,
  V2NIMChatroomMemberRole.V2NIM_CHATROOM_MEMBER_ROLE_MANAGER: 2,
  V2NIMChatroomMemberRole.V2NIM_CHATROOM_MEMBER_ROLE_NORMAL_GUEST: 3,
  V2NIMChatroomMemberRole.V2NIM_CHATROOM_MEMBER_ROLE_ANONYMOUS_GUEST: 4,
  V2NIMChatroomMemberRole.V2NIM_CHATROOM_MEMBER_ROLE_VIRTUAL: 5,
};

V2NIMChatroomMemberListResult _$V2NIMChatroomMemberListResultFromJson(
        Map<String, dynamic> json) =>
    V2NIMChatroomMemberListResult(
      pageToken: json['pageToken'] as String?,
      finished: json['finished'] as bool? ?? false,
      memberList: V2NIMChatroomMemberListFromJson(json['memberList'] as List?),
    );

Map<String, dynamic> _$V2NIMChatroomMemberListResultToJson(
        V2NIMChatroomMemberListResult instance) =>
    <String, dynamic>{
      'pageToken': instance.pageToken,
      'finished': instance.finished,
      'memberList': instance.memberList?.map((e) => e.toJson()).toList(),
    };

V2NIMChatroomMessageListOption _$V2NIMChatroomMessageListOptionFromJson(
        Map<String, dynamic> json) =>
    V2NIMChatroomMessageListOption(
      direction: $enumDecodeNullable(
              _$V2NIMMessageQueryDirectionEnumMap, json['direction']) ??
          V2NIMMessageQueryDirection.V2NIM_QUERY_DIRECTION_DESC,
      messageTypes: (json['messageTypes'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$NIMMessageTypeEnumMap, e))
          .toList(),
      beginTime: (json['beginTime'] as num?)?.toInt(),
      limit: (json['limit'] as num?)?.toInt(),
    );

Map<String, dynamic> _$V2NIMChatroomMessageListOptionToJson(
        V2NIMChatroomMessageListOption instance) =>
    <String, dynamic>{
      'direction': _$V2NIMMessageQueryDirectionEnumMap[instance.direction]!,
      'messageTypes': instance.messageTypes
          ?.map((e) => _$NIMMessageTypeEnumMap[e]!)
          .toList(),
      'beginTime': instance.beginTime,
      'limit': instance.limit,
    };

const _$V2NIMMessageQueryDirectionEnumMap = {
  V2NIMMessageQueryDirection.V2NIM_QUERY_DIRECTION_DESC: 0,
  V2NIMMessageQueryDirection.V2NIM_QUERY_DIRECTION_ASC: 1,
};

V2NIMChatroomMemberRoleUpdateParams
    _$V2NIMChatroomMemberRoleUpdateParamsFromJson(Map<String, dynamic> json) =>
        V2NIMChatroomMemberRoleUpdateParams(
          memberRole: $enumDecodeNullable(
              _$V2NIMChatroomMemberRoleEnumMap, json['memberRole']),
          memberLevel: (json['memberLevel'] as num?)?.toInt(),
          notificationExtension: json['notificationExtension'] as String?,
        );

Map<String, dynamic> _$V2NIMChatroomMemberRoleUpdateParamsToJson(
        V2NIMChatroomMemberRoleUpdateParams instance) =>
    <String, dynamic>{
      'memberRole': _$V2NIMChatroomMemberRoleEnumMap[instance.memberRole],
      'memberLevel': instance.memberLevel,
      'notificationExtension': instance.notificationExtension,
    };

V2NIMChatroomUpdateParams _$V2NIMChatroomUpdateParamsFromJson(
        Map<String, dynamic> json) =>
    V2NIMChatroomUpdateParams(
      roomName: json['roomName'] as String?,
      announcement: json['announcement'] as String?,
      liveUrl: json['liveUrl'] as String?,
      serverExtension: json['serverExtension'] as String?,
      notificationEnabled: json['notificationEnabled'] as bool?,
      notificationExtension: json['notificationExtension'] as String?,
    );

Map<String, dynamic> _$V2NIMChatroomUpdateParamsToJson(
        V2NIMChatroomUpdateParams instance) =>
    <String, dynamic>{
      'roomName': instance.roomName,
      'announcement': instance.announcement,
      'liveUrl': instance.liveUrl,
      'serverExtension': instance.serverExtension,
      'notificationEnabled': instance.notificationEnabled,
      'notificationExtension': instance.notificationExtension,
    };

V2NIMChatroomSelfMemberUpdateParams
    _$V2NIMChatroomSelfMemberUpdateParamsFromJson(Map<String, dynamic> json) =>
        V2NIMChatroomSelfMemberUpdateParams(
          roomNick: json['roomNick'] as String?,
          roomAvatar: json['roomAvatar'] as String?,
          serverExtension: json['serverExtension'] as String?,
          notificationEnabled: json['notificationEnabled'] as bool?,
          notificationExtension: json['notificationExtension'] as String?,
          persistence: json['persistence'] as bool?,
        );

Map<String, dynamic> _$V2NIMChatroomSelfMemberUpdateParamsToJson(
        V2NIMChatroomSelfMemberUpdateParams instance) =>
    <String, dynamic>{
      'roomNick': instance.roomNick,
      'roomAvatar': instance.roomAvatar,
      'serverExtension': instance.serverExtension,
      'notificationEnabled': instance.notificationEnabled,
      'notificationExtension': instance.notificationExtension,
      'persistence': instance.persistence,
    };

V2NIMChatroomTagTempChatBannedParams
    _$V2NIMChatroomTagTempChatBannedParamsFromJson(Map<String, dynamic> json) =>
        V2NIMChatroomTagTempChatBannedParams(
          targetTag: json['targetTag'] as String?,
          notifyTargetTags: json['notifyTargetTags'] as String?,
          duration: (json['duration'] as num?)?.toInt(),
          notificationEnabled: json['notificationEnabled'] as bool?,
          notificationExtension: json['notificationExtension'] as String?,
        );

Map<String, dynamic> _$V2NIMChatroomTagTempChatBannedParamsToJson(
        V2NIMChatroomTagTempChatBannedParams instance) =>
    <String, dynamic>{
      'targetTag': instance.targetTag,
      'notifyTargetTags': instance.notifyTargetTags,
      'duration': instance.duration,
      'notificationEnabled': instance.notificationEnabled,
      'notificationExtension': instance.notificationExtension,
    };

V2NIMChatroomTagMemberOption _$V2NIMChatroomTagMemberOptionFromJson(
        Map<String, dynamic> json) =>
    V2NIMChatroomTagMemberOption(
      tag: json['tag'] as String?,
      pageToken: json['pageToken'] as String?,
      limit: (json['limit'] as num?)?.toInt(),
    );

Map<String, dynamic> _$V2NIMChatroomTagMemberOptionToJson(
        V2NIMChatroomTagMemberOption instance) =>
    <String, dynamic>{
      'tag': instance.tag,
      'pageToken': instance.pageToken,
      'limit': instance.limit,
    };

V2NIMChatroomTagsUpdateParams _$V2NIMChatroomTagsUpdateParamsFromJson(
        Map<String, dynamic> json) =>
    V2NIMChatroomTagsUpdateParams(
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      notifyTargetTags: json['notifyTargetTags'] as String?,
      notificationEnabled: json['notificationEnabled'] as bool?,
      notificationExtension: json['notificationExtension'] as String?,
    );

Map<String, dynamic> _$V2NIMChatroomTagsUpdateParamsToJson(
        V2NIMChatroomTagsUpdateParams instance) =>
    <String, dynamic>{
      'tags': instance.tags,
      'notifyTargetTags': instance.notifyTargetTags,
      'notificationEnabled': instance.notificationEnabled,
      'notificationExtension': instance.notificationExtension,
    };

V2NIMChatroomTagMessageOption _$V2NIMChatroomTagMessageOptionFromJson(
        Map<String, dynamic> json) =>
    V2NIMChatroomTagMessageOption(
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      messageTypes: (json['messageTypes'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$NIMMessageTypeEnumMap, e))
          .toList(),
      beginTime: (json['beginTime'] as num?)?.toInt(),
      endTime: (json['endTime'] as num?)?.toInt(),
      limit: (json['limit'] as num?)?.toInt(),
      direction: $enumDecodeNullable(
          _$V2NIMMessageQueryDirectionEnumMap, json['direction']),
    );

Map<String, dynamic> _$V2NIMChatroomTagMessageOptionToJson(
        V2NIMChatroomTagMessageOption instance) =>
    <String, dynamic>{
      'tags': instance.tags,
      'messageTypes': instance.messageTypes
          ?.map((e) => _$NIMMessageTypeEnumMap[e]!)
          .toList(),
      'beginTime': instance.beginTime,
      'endTime': instance.endTime,
      'limit': instance.limit,
      'direction': _$V2NIMMessageQueryDirectionEnumMap[instance.direction],
    };

ChatroomMemberRoleUpdatedEvent _$ChatroomMemberRoleUpdatedEventFromJson(
        Map<String, dynamic> json) =>
    ChatroomMemberRoleUpdatedEvent(
      instanceId: (json['instanceId'] as num).toInt(),
      previousRole: $enumDecodeNullable(
          _$V2NIMChatroomMemberRoleEnumMap, json['previousRole']),
      member: v2NIMChatroomMemberFromJson(json['member'] as Map?),
    );

Map<String, dynamic> _$ChatroomMemberRoleUpdatedEventToJson(
        ChatroomMemberRoleUpdatedEvent instance) =>
    <String, dynamic>{
      'instanceId': instance.instanceId,
      'previousRole': _$V2NIMChatroomMemberRoleEnumMap[instance.previousRole],
      'member': instance.member?.toJson(),
    };

SelfTempChatBannedUpdatedEvent _$SelfTempChatBannedUpdatedEventFromJson(
        Map<String, dynamic> json) =>
    SelfTempChatBannedUpdatedEvent(
      instanceId: (json['instanceId'] as num).toInt(),
      tempChatBanned: json['tempChatBanned'] as bool,
      tempChatBannedDuration: (json['tempChatBannedDuration'] as num).toInt(),
    );

Map<String, dynamic> _$SelfTempChatBannedUpdatedEventToJson(
        SelfTempChatBannedUpdatedEvent instance) =>
    <String, dynamic>{
      'instanceId': instance.instanceId,
      'tempChatBanned': instance.tempChatBanned,
      'tempChatBannedDuration': instance.tempChatBannedDuration,
    };

ChatroomMessageRevokedNotificationEvent
    _$ChatroomMessageRevokedNotificationEventFromJson(
            Map<String, dynamic> json) =>
        ChatroomMessageRevokedNotificationEvent(
          messageClientId: json['messageClientId'] as String?,
          messageTime: (json['messageTime'] as num).toInt(),
          instanceId: (json['instanceId'] as num).toInt(),
        );

Map<String, dynamic> _$ChatroomMessageRevokedNotificationEventToJson(
        ChatroomMessageRevokedNotificationEvent instance) =>
    <String, dynamic>{
      'instanceId': instance.instanceId,
      'messageClientId': instance.messageClientId,
      'messageTime': instance.messageTime,
    };

ChatroomReceiveMessagesEvent _$ChatroomReceiveMessagesEventFromJson(
        Map<String, dynamic> json) =>
    ChatroomReceiveMessagesEvent(
      instanceId: (json['instanceId'] as num).toInt(),
      messages: V2NIMChatroomMessageListFromJson(json['messages'] as List?),
    );

Map<String, dynamic> _$ChatroomReceiveMessagesEventToJson(
        ChatroomReceiveMessagesEvent instance) =>
    <String, dynamic>{
      'instanceId': instance.instanceId,
      'messages': instance.messages?.map((e) => e.toJson()).toList(),
    };

ChatroomSendMessageEvent _$ChatroomSendMessageEventFromJson(
        Map<String, dynamic> json) =>
    ChatroomSendMessageEvent(
      instanceId: (json['instanceId'] as num).toInt(),
      message: V2NIMChatroomMessageFromJson(json['message'] as Map?),
    );

Map<String, dynamic> _$ChatroomSendMessageEventToJson(
        ChatroomSendMessageEvent instance) =>
    <String, dynamic>{
      'instanceId': instance.instanceId,
      'message': instance.message?.toJson(),
    };

ChatroomMemberEnterEvent _$ChatroomMemberEnterEventFromJson(
        Map<String, dynamic> json) =>
    ChatroomMemberEnterEvent(
      instanceId: (json['instanceId'] as num).toInt(),
      member: v2NIMChatroomMemberFromJson(json['member'] as Map?),
    );

Map<String, dynamic> _$ChatroomMemberEnterEventToJson(
        ChatroomMemberEnterEvent instance) =>
    <String, dynamic>{
      'instanceId': instance.instanceId,
      'member': instance.member?.toJson(),
    };

ChatroomMemberExitEvent _$ChatroomMemberExitEventFromJson(
        Map<String, dynamic> json) =>
    ChatroomMemberExitEvent(
      instanceId: (json['instanceId'] as num).toInt(),
      accountId: json['accountId'] as String,
    );

Map<String, dynamic> _$ChatroomMemberExitEventToJson(
        ChatroomMemberExitEvent instance) =>
    <String, dynamic>{
      'instanceId': instance.instanceId,
      'accountId': instance.accountId,
    };

ChatroomMemberInfoUpdatedEvent _$ChatroomMemberInfoUpdatedEventFromJson(
        Map<String, dynamic> json) =>
    ChatroomMemberInfoUpdatedEvent(
      instanceId: (json['instanceId'] as num).toInt(),
      member: v2NIMChatroomMemberFromJson(json['member'] as Map?),
    );

Map<String, dynamic> _$ChatroomMemberInfoUpdatedEventToJson(
        ChatroomMemberInfoUpdatedEvent instance) =>
    <String, dynamic>{
      'instanceId': instance.instanceId,
      'member': instance.member?.toJson(),
    };

SelfChatBannedUpdatedEvent _$SelfChatBannedUpdatedEventFromJson(
        Map<String, dynamic> json) =>
    SelfChatBannedUpdatedEvent(
      instanceId: (json['instanceId'] as num).toInt(),
      chatBanned: json['chatBanned'] as bool,
    );

Map<String, dynamic> _$SelfChatBannedUpdatedEventToJson(
        SelfChatBannedUpdatedEvent instance) =>
    <String, dynamic>{
      'instanceId': instance.instanceId,
      'chatBanned': instance.chatBanned,
    };

ChatroomInfoUpdatedEvent _$ChatroomInfoUpdatedEventFromJson(
        Map<String, dynamic> json) =>
    ChatroomInfoUpdatedEvent(
      instanceId: (json['instanceId'] as num).toInt(),
      info: v2NIMChatroomInfoFromJson(json['info'] as Map?),
    );

Map<String, dynamic> _$ChatroomInfoUpdatedEventToJson(
        ChatroomInfoUpdatedEvent instance) =>
    <String, dynamic>{
      'instanceId': instance.instanceId,
      'info': instance.info?.toJson(),
    };

ChatroomChatBannedUpdatedEvent _$ChatroomChatBannedUpdatedEventFromJson(
        Map<String, dynamic> json) =>
    ChatroomChatBannedUpdatedEvent(
      instanceId: (json['instanceId'] as num).toInt(),
      chatBanned: json['chatBanned'] as bool,
    );

Map<String, dynamic> _$ChatroomChatBannedUpdatedEventToJson(
        ChatroomChatBannedUpdatedEvent instance) =>
    <String, dynamic>{
      'instanceId': instance.instanceId,
      'chatBanned': instance.chatBanned,
    };

ChatroomTagsUpdatedEvent _$ChatroomTagsUpdatedEventFromJson(
        Map<String, dynamic> json) =>
    ChatroomTagsUpdatedEvent(
      instanceId: (json['instanceId'] as num).toInt(),
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$ChatroomTagsUpdatedEventToJson(
        ChatroomTagsUpdatedEvent instance) =>
    <String, dynamic>{
      'instanceId': instance.instanceId,
      'tags': instance.tags,
    };

V2NIMChatroomNotificationAttachment
    _$V2NIMChatroomNotificationAttachmentFromJson(Map<String, dynamic> json) =>
        V2NIMChatroomNotificationAttachment(
          type: $enumDecodeNullable(
              _$V2NIMChatroomMessageNotificationTypeEnumMap, json['type']),
          tags: (json['tags'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList(),
          notificationExtension: json['notificationExtension'] as String?,
          targetIds: (json['targetIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList(),
          operatorId: json['operatorId'] as String?,
          operatorNick: json['operatorNick'] as String?,
          targetNicks: (json['targetNicks'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList(),
          targetTag: json['targetTag'] as String?,
        )..raw = json['raw'] as String?;

Map<String, dynamic> _$V2NIMChatroomNotificationAttachmentToJson(
        V2NIMChatroomNotificationAttachment instance) =>
    <String, dynamic>{
      'raw': instance.raw,
      'type': _$V2NIMChatroomMessageNotificationTypeEnumMap[instance.type],
      'targetIds': instance.targetIds,
      'targetNicks': instance.targetNicks,
      'targetTag': instance.targetTag,
      'operatorId': instance.operatorId,
      'operatorNick': instance.operatorNick,
      'notificationExtension': instance.notificationExtension,
      'tags': instance.tags,
    };

const _$V2NIMChatroomMessageNotificationTypeEnumMap = {
  V2NIMChatroomMessageNotificationType
      .V2NIM_CHATROOM_MESSAGE_NOTIFICATION_TYPE_MEMBER_ENTER: 0,
  V2NIMChatroomMessageNotificationType
      .V2NIM_CHATROOM_MESSAGE_NOTIFICATION_TYPE_MEMBER_EXIT: 1,
  V2NIMChatroomMessageNotificationType
      .V2NIM_CHATROOM_MESSAGE_NOTIFICATION_TYPE_MEMBER_BLOCK_ADDED: 2,
  V2NIMChatroomMessageNotificationType
      .V2NIM_CHATROOM_MESSAGE_NOTIFICATION_TYPE_MEMBER_BLOCK_REMOVED: 3,
  V2NIMChatroomMessageNotificationType
      .V2NIM_CHATROOM_MESSAGE_NOTIFICATION_TYPE_MEMBER_CHAT_BANNED_ADDED: 4,
  V2NIMChatroomMessageNotificationType
      .V2NIM_CHATROOM_MESSAGE_NOTIFICATION_TYPE_MEMBER_CHAT_BANNED_REMOVED: 5,
  V2NIMChatroomMessageNotificationType
      .V2NIM_CHATROOM_MESSAGE_NOTIFICATION_TYPE_ROOM_INFO_UPDATED: 6,
  V2NIMChatroomMessageNotificationType
      .V2NIM_CHATROOM_MESSAGE_NOTIFICATION_TYPE_MEMBER_KICKED: 7,
  V2NIMChatroomMessageNotificationType
      .V2NIM_CHATROOM_MESSAGE_NOTIFICATION_TYPE_MEMBER_TEMP_CHAT_BANNED_ADDED: 8,
  V2NIMChatroomMessageNotificationType
      .V2NIM_CHATROOM_MESSAGE_NOTIFICATION_TYPE_MEMBER_TEMP_CHAT_BANNED_REMOVED: 9,
  V2NIMChatroomMessageNotificationType
      .V2NIM_CHATROOM_MESSAGE_NOTIFICATION_TYPE_MEMBER_INFO_UPDATED: 10,
  V2NIMChatroomMessageNotificationType
      .V2NIM_CHATROOM_MESSAGE_NOTIFICATION_TYPE_QUEUE_CHANGE: 11,
  V2NIMChatroomMessageNotificationType
      .V2NIM_CHATROOM_MESSAGE_NOTIFICATION_TYPE_CHAT_BANNED: 12,
  V2NIMChatroomMessageNotificationType
      .V2NIM_CHATROOM_MESSAGE_NOTIFICATION_TYPE_CHAT_BANNED_REMOVED: 13,
  V2NIMChatroomMessageNotificationType
      .V2NIM_CHATROOM_MESSAGE_NOTIFICATION_TYPE_TAG_TEMP_CHAT_BANNED_ADDED: 14,
  V2NIMChatroomMessageNotificationType
      .V2NIM_CHATROOM_MESSAGE_NOTIFICATION_TYPE_TAG_TEMP_CHAT_BANNED_REMOVED: 15,
  V2NIMChatroomMessageNotificationType
      .V2NIM_CHATROOM_MESSAGE_NOTIFICATION_TYPE_MESSAGE_REVOKE: 16,
  V2NIMChatroomMessageNotificationType
      .V2NIM_CHATROOM_MESSAGE_NOTIFICATION_TYPE_TAGS_UPDATE: 17,
  V2NIMChatroomMessageNotificationType
      .V2NIM_CHATROOM_MESSAGE_NOTIFICATION_TYPE_ROLE_UPDATE: 18,
};

V2NIMChatroomChatBannedNotificationAttachment
    _$V2NIMChatroomChatBannedNotificationAttachmentFromJson(
            Map<String, dynamic> json) =>
        V2NIMChatroomChatBannedNotificationAttachment(
          chatBanned: json['chatBanned'] as bool?,
          tempChatBanned: json['tempChatBanned'] as bool?,
          tempChatBannedDuration:
              (json['tempChatBannedDuration'] as num?)?.toInt(),
        )
          ..raw = json['raw'] as String?
          ..type = $enumDecodeNullable(
              _$V2NIMChatroomMessageNotificationTypeEnumMap, json['type'])
          ..targetIds = (json['targetIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList()
          ..targetNicks = (json['targetNicks'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList()
          ..targetTag = json['targetTag'] as String?
          ..operatorId = json['operatorId'] as String?
          ..operatorNick = json['operatorNick'] as String?
          ..notificationExtension = json['notificationExtension'] as String?
          ..tags = (json['tags'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList();

Map<String, dynamic> _$V2NIMChatroomChatBannedNotificationAttachmentToJson(
        V2NIMChatroomChatBannedNotificationAttachment instance) =>
    <String, dynamic>{
      'raw': instance.raw,
      'type': _$V2NIMChatroomMessageNotificationTypeEnumMap[instance.type],
      'targetIds': instance.targetIds,
      'targetNicks': instance.targetNicks,
      'targetTag': instance.targetTag,
      'operatorId': instance.operatorId,
      'operatorNick': instance.operatorNick,
      'notificationExtension': instance.notificationExtension,
      'tags': instance.tags,
      'chatBanned': instance.chatBanned,
      'tempChatBanned': instance.tempChatBanned,
      'tempChatBannedDuration': instance.tempChatBannedDuration,
    };

V2NIMChatroomMemberEnterNotificationAttachment
    _$V2NIMChatroomMemberEnterNotificationAttachmentFromJson(
            Map<String, dynamic> json) =>
        V2NIMChatroomMemberEnterNotificationAttachment(
          tempChatBannedDuration:
              (json['tempChatBannedDuration'] as num?)?.toInt(),
          chatBanned: json['chatBanned'] as bool?,
          tempChatBanned: json['tempChatBanned'] as bool?,
        )
          ..raw = json['raw'] as String?
          ..type = $enumDecodeNullable(
              _$V2NIMChatroomMessageNotificationTypeEnumMap, json['type'])
          ..targetIds = (json['targetIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList()
          ..targetNicks = (json['targetNicks'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList()
          ..targetTag = json['targetTag'] as String?
          ..operatorId = json['operatorId'] as String?
          ..operatorNick = json['operatorNick'] as String?
          ..notificationExtension = json['notificationExtension'] as String?
          ..tags = (json['tags'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList();

Map<String, dynamic> _$V2NIMChatroomMemberEnterNotificationAttachmentToJson(
        V2NIMChatroomMemberEnterNotificationAttachment instance) =>
    <String, dynamic>{
      'raw': instance.raw,
      'type': _$V2NIMChatroomMessageNotificationTypeEnumMap[instance.type],
      'targetIds': instance.targetIds,
      'targetNicks': instance.targetNicks,
      'targetTag': instance.targetTag,
      'operatorId': instance.operatorId,
      'operatorNick': instance.operatorNick,
      'notificationExtension': instance.notificationExtension,
      'tags': instance.tags,
      'chatBanned': instance.chatBanned,
      'tempChatBanned': instance.tempChatBanned,
      'tempChatBannedDuration': instance.tempChatBannedDuration,
    };

V2NIMChatroomMemberRoleUpdateAttachment
    _$V2NIMChatroomMemberRoleUpdateAttachmentFromJson(
            Map<String, dynamic> json) =>
        V2NIMChatroomMemberRoleUpdateAttachment(
          previousRole: $enumDecodeNullable(
              _$V2NIMChatroomMemberRoleEnumMap, json['previousRole']),
          currentMember:
              v2NIMChatroomMemberFromJson(json['currentMember'] as Map?),
        )
          ..raw = json['raw'] as String?
          ..type = $enumDecodeNullable(
              _$V2NIMChatroomMessageNotificationTypeEnumMap, json['type'])
          ..targetIds = (json['targetIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList()
          ..targetNicks = (json['targetNicks'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList()
          ..targetTag = json['targetTag'] as String?
          ..operatorId = json['operatorId'] as String?
          ..operatorNick = json['operatorNick'] as String?
          ..notificationExtension = json['notificationExtension'] as String?
          ..tags = (json['tags'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList();

Map<String, dynamic> _$V2NIMChatroomMemberRoleUpdateAttachmentToJson(
        V2NIMChatroomMemberRoleUpdateAttachment instance) =>
    <String, dynamic>{
      'raw': instance.raw,
      'type': _$V2NIMChatroomMessageNotificationTypeEnumMap[instance.type],
      'targetIds': instance.targetIds,
      'targetNicks': instance.targetNicks,
      'targetTag': instance.targetTag,
      'operatorId': instance.operatorId,
      'operatorNick': instance.operatorNick,
      'notificationExtension': instance.notificationExtension,
      'tags': instance.tags,
      'previousRole': _$V2NIMChatroomMemberRoleEnumMap[instance.previousRole],
      'currentMember': instance.currentMember?.toJson(),
    };

V2NIMChatroomMessageRevokeNotificationAttachment
    _$V2NIMChatroomMessageRevokeNotificationAttachmentFromJson(
            Map<String, dynamic> json) =>
        V2NIMChatroomMessageRevokeNotificationAttachment(
          messageClientId: json['messageClientId'] as String?,
          messageTime: (json['messageTime'] as num?)?.toInt(),
        )
          ..raw = json['raw'] as String?
          ..type = $enumDecodeNullable(
              _$V2NIMChatroomMessageNotificationTypeEnumMap, json['type'])
          ..targetIds = (json['targetIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList()
          ..targetNicks = (json['targetNicks'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList()
          ..targetTag = json['targetTag'] as String?
          ..operatorId = json['operatorId'] as String?
          ..operatorNick = json['operatorNick'] as String?
          ..notificationExtension = json['notificationExtension'] as String?
          ..tags = (json['tags'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList();

Map<String, dynamic> _$V2NIMChatroomMessageRevokeNotificationAttachmentToJson(
        V2NIMChatroomMessageRevokeNotificationAttachment instance) =>
    <String, dynamic>{
      'raw': instance.raw,
      'type': _$V2NIMChatroomMessageNotificationTypeEnumMap[instance.type],
      'targetIds': instance.targetIds,
      'targetNicks': instance.targetNicks,
      'targetTag': instance.targetTag,
      'operatorId': instance.operatorId,
      'operatorNick': instance.operatorNick,
      'notificationExtension': instance.notificationExtension,
      'tags': instance.tags,
      'messageClientId': instance.messageClientId,
      'messageTime': instance.messageTime,
    };

V2NIMChatroomQueueNotificationAttachment
    _$V2NIMChatroomQueueNotificationAttachmentFromJson(
            Map<String, dynamic> json) =>
        V2NIMChatroomQueueNotificationAttachment(
          elements:
              V2NIMChatroomQueueElementListFromJson(json['elements'] as List?),
          queueChangeType: $enumDecodeNullable(
              _$V2NIMChatroomQueueChangeTypeEnumMap, json['queueChangeType']),
        )
          ..raw = json['raw'] as String?
          ..type = $enumDecodeNullable(
              _$V2NIMChatroomMessageNotificationTypeEnumMap, json['type'])
          ..targetIds = (json['targetIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList()
          ..targetNicks = (json['targetNicks'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList()
          ..targetTag = json['targetTag'] as String?
          ..operatorId = json['operatorId'] as String?
          ..operatorNick = json['operatorNick'] as String?
          ..notificationExtension = json['notificationExtension'] as String?
          ..tags = (json['tags'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList();

Map<String, dynamic> _$V2NIMChatroomQueueNotificationAttachmentToJson(
        V2NIMChatroomQueueNotificationAttachment instance) =>
    <String, dynamic>{
      'raw': instance.raw,
      'type': _$V2NIMChatroomMessageNotificationTypeEnumMap[instance.type],
      'targetIds': instance.targetIds,
      'targetNicks': instance.targetNicks,
      'targetTag': instance.targetTag,
      'operatorId': instance.operatorId,
      'operatorNick': instance.operatorNick,
      'notificationExtension': instance.notificationExtension,
      'tags': instance.tags,
      'elements': instance.elements?.map((e) => e.toJson()).toList(),
      'queueChangeType':
          _$V2NIMChatroomQueueChangeTypeEnumMap[instance.queueChangeType],
    };

const _$V2NIMChatroomQueueChangeTypeEnumMap = {
  V2NIMChatroomQueueChangeType.V2NIM_CHATROOM_QUEUE_CHANGE_TYPE_UNKNOWN: 0,
  V2NIMChatroomQueueChangeType.V2NIM_CHATROOM_QUEUE_CHANGE_TYPE_OFFER: 1,
  V2NIMChatroomQueueChangeType.V2NIM_CHATROOM_QUEUE_CHANGE_TYPE_POLL: 2,
  V2NIMChatroomQueueChangeType.V2NIM_CHATROOM_QUEUE_CHANGE_TYPE_DROP: 3,
  V2NIMChatroomQueueChangeType.V2NIM_CHATROOM_QUEUE_CHANGE_TYPE_PARTCLEAR: 4,
  V2NIMChatroomQueueChangeType.V2NIM_CHATROOM_QUEUE_CHANGE_TYPE_BATCH_UPDATE: 5,
  V2NIMChatroomQueueChangeType.V2NIM_CHATROOM_QUEUE_CHANGE_TYPE_BATCH_OFFER: 6,
};
