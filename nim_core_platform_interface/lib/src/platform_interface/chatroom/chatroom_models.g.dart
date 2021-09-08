// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chatroom_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NIMChatRoomEnterRequest _$NIMChatRoomEnterRequestFromJson(
    Map<String, dynamic> json) {
  return NIMChatRoomEnterRequest(
    roomId: json['roomId'] as String,
    nickname: json['nickname'] as String?,
    avatar: json['avatar'] as String?,
    extension: castPlatformMapToDartMap(json['extension'] as Map?),
    notifyExtension: castPlatformMapToDartMap(json['notifyExtension'] as Map?),
    tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
    notifyTargetTags: json['notifyTargetTags'] as String?,
    retryCount: json['retryCount'] as int?,
  );
}

Map<String, dynamic> _$NIMChatRoomEnterRequestToJson(
        NIMChatRoomEnterRequest instance) =>
    <String, dynamic>{
      'roomId': instance.roomId,
      'nickname': instance.nickname,
      'avatar': instance.avatar,
      'extension': instance.extension,
      'notifyExtension': instance.notifyExtension,
      'tags': instance.tags,
      'notifyTargetTags': instance.notifyTargetTags,
      'retryCount': instance.retryCount,
    };

NIMChatroomEnterResult _$NIMChatroomEnterResultFromJson(
    Map<String, dynamic> json) {
  return NIMChatroomEnterResult(
    roomId: json['roomId'] as String,
    roomInfo: _chatroomInfoFromJson(json['roomInfo'] as Map),
    member: _chatroomMemberFromJson(json['member'] as Map),
  );
}

Map<String, dynamic> _$NIMChatroomEnterResultToJson(
        NIMChatroomEnterResult instance) =>
    <String, dynamic>{
      'roomId': instance.roomId,
      'roomInfo': _chatroomInfoToJson(instance.roomInfo),
      'member': _chatroomMemberToJson(instance.member),
    };

NIMChatroomInfo _$NIMChatroomInfoFromJson(Map<String, dynamic> json) {
  return NIMChatroomInfo(
    roomId: json['roomId'] as String,
    name: json['name'] as String?,
    announcement: json['announcement'] as String?,
    broadcastUrl: json['broadcastUrl'] as String?,
    creator: json['creator'] as String?,
    validFlag: json['validFlag'] as int? ?? 0,
    onlineUserCount: json['onlineUserCount'] as int? ?? 0,
    mute: json['mute'] as int? ?? 0,
    extension: castPlatformMapToDartMap(json['extension'] as Map?),
    ext: json['ext'] as String?,
    queueModificationLevel: _$enumDecode(
        _$NIMChatroomQueueModificationLevelEnumMap,
        json['queueModificationLevel'],
        unknownValue: NIMChatroomQueueModificationLevel.anyone),
  );
}

Map<String, dynamic> _$NIMChatroomInfoToJson(NIMChatroomInfo instance) =>
    <String, dynamic>{
      'roomId': instance.roomId,
      'name': instance.name,
      'announcement': instance.announcement,
      'broadcastUrl': instance.broadcastUrl,
      'creator': instance.creator,
      'validFlag': instance.validFlag,
      'onlineUserCount': instance.onlineUserCount,
      'mute': instance.mute,
      'extension': instance.extension,
      'ext': instance.ext,
      'queueModificationLevel': _$NIMChatroomQueueModificationLevelEnumMap[
          instance.queueModificationLevel],
    };

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

const _$NIMChatroomQueueModificationLevelEnumMap = {
  NIMChatroomQueueModificationLevel.anyone: 'anyone',
  NIMChatroomQueueModificationLevel.manager: 'manager',
};

NIMChatroomMember _$NIMChatroomMemberFromJson(Map<String, dynamic> json) {
  return NIMChatroomMember(
    roomId: json['roomId'] as String,
    account: json['account'] as String,
    memberType: _$enumDecode(_$NIMChatroomMemberTypeEnumMap, json['memberType'],
        unknownValue: NIMChatroomMemberType.unknown),
    nickname: json['nickname'] as String?,
    avatar: json['avatar'] as String?,
    extension: castPlatformMapToDartMap(json['extension'] as Map?),
    roomExt: json['roomExt'] as String?,
    isOnline: json['isOnline'] as bool,
    isInBlackList: json['isInBlackList'] as bool,
    isMuted: json['isMuted'] as bool,
    isTempMuted: json['isTempMuted'] as bool,
    tempMuteDuration: json['tempMuteDuration'] as int?,
    isValid: json['isValid'] as bool,
    enterTime: json['enterTime'] as int?,
    tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
    notifyTargetTags: json['notifyTargetTags'] as String?,
  );
}

Map<String, dynamic> _$NIMChatroomMemberToJson(NIMChatroomMember instance) =>
    <String, dynamic>{
      'roomId': instance.roomId,
      'account': instance.account,
      'memberType': _$NIMChatroomMemberTypeEnumMap[instance.memberType],
      'nickname': instance.nickname,
      'avatar': instance.avatar,
      'extension': instance.extension,
      'roomExt': instance.roomExt,
      'isOnline': instance.isOnline,
      'isInBlackList': instance.isInBlackList,
      'isMuted': instance.isMuted,
      'isTempMuted': instance.isTempMuted,
      'tempMuteDuration': instance.tempMuteDuration,
      'isValid': instance.isValid,
      'enterTime': instance.enterTime,
      'tags': instance.tags,
      'notifyTargetTags': instance.notifyTargetTags,
    };

const _$NIMChatroomMemberTypeEnumMap = {
  NIMChatroomMemberType.unknown: 'unknown',
  NIMChatroomMemberType.guest: 'guest',
  NIMChatroomMemberType.restricted: 'restricted',
  NIMChatroomMemberType.normal: 'normal',
  NIMChatroomMemberType.creator: 'creator',
  NIMChatroomMemberType.manager: 'manager',
  NIMChatroomMemberType.anonymous: 'anonymous',
};

NIMChatroomStatusEvent _$NIMChatroomStatusEventFromJson(
    Map<String, dynamic> json) {
  return NIMChatroomStatusEvent(
    json['roomId'] as String,
    _$enumDecode(_$NIMChatroomStatusEnumMap, json['status']),
    json['code'] as int?,
  );
}

Map<String, dynamic> _$NIMChatroomStatusEventToJson(
        NIMChatroomStatusEvent instance) =>
    <String, dynamic>{
      'roomId': instance.roomId,
      'status': _$NIMChatroomStatusEnumMap[instance.status],
      'code': instance.code,
    };

const _$NIMChatroomStatusEnumMap = {
  NIMChatroomStatus.connecting: 'connecting',
  NIMChatroomStatus.connected: 'connected',
  NIMChatroomStatus.disconnected: 'disconnected',
  NIMChatroomStatus.failure: 'failure',
};

NIMChatroomKickOutEvent _$NIMChatroomKickOutEventFromJson(
    Map<String, dynamic> json) {
  return NIMChatroomKickOutEvent(
    json['roomId'] as String,
    _$enumDecode(_$NIMChatroomKickOutReasonEnumMap, json['reason']),
    castPlatformMapToDartMap(json['extension'] as Map?),
  );
}

Map<String, dynamic> _$NIMChatroomKickOutEventToJson(
        NIMChatroomKickOutEvent instance) =>
    <String, dynamic>{
      'roomId': instance.roomId,
      'reason': _$NIMChatroomKickOutReasonEnumMap[instance.reason],
      'extension': instance.extension,
    };

const _$NIMChatroomKickOutReasonEnumMap = {
  NIMChatroomKickOutReason.unknown: 'unknown',
  NIMChatroomKickOutReason.dismissed: 'dismissed',
  NIMChatroomKickOutReason.byManager: 'byManager',
  NIMChatroomKickOutReason.byConflictLogin: 'byConflictLogin',
  NIMChatroomKickOutReason.blacklisted: 'blacklisted',
};

NIMChatroomNotificationAttachment _$NIMChatroomNotificationAttachmentFromJson(
    Map<String, dynamic> json) {
  return NIMChatroomNotificationAttachment(
    type: json['type'] as int,
    targets:
        (json['targets'] as List<dynamic>?)?.map((e) => e as String).toList(),
    targetNicks: (json['targetNicks'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    operator: json['operator'] as String?,
    operatorNick: json['operatorNick'] as String?,
    extension: castPlatformMapToDartMap(json['extension'] as Map?),
  );
}

Map<String, dynamic> _$NIMChatroomNotificationAttachmentToJson(
        NIMChatroomNotificationAttachment instance) =>
    <String, dynamic>{
      'type': instance.type,
      'targets': instance.targets,
      'targetNicks': instance.targetNicks,
      'operator': instance.operator,
      'operatorNick': instance.operatorNick,
      'extension': instance.extension,
    };

NIMChatroomMemberInAttachment _$NIMChatroomMemberInAttachmentFromJson(
    Map<String, dynamic> json) {
  return NIMChatroomMemberInAttachment(
    muted: json['muted'] as bool? ?? false,
    tempMuted: json['tempMuted'] as bool? ?? false,
    tempMutedDuration: json['tempMutedDuration'] as int? ?? 0,
    targets:
        (json['targets'] as List<dynamic>?)?.map((e) => e as String).toList(),
    targetNicks: (json['targetNicks'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    operator: json['operator'] as String?,
    operatorNick: json['operatorNick'] as String?,
    extension: castPlatformMapToDartMap(json['extension'] as Map?),
  );
}

Map<String, dynamic> _$NIMChatroomMemberInAttachmentToJson(
        NIMChatroomMemberInAttachment instance) =>
    <String, dynamic>{
      'targets': instance.targets,
      'targetNicks': instance.targetNicks,
      'operator': instance.operator,
      'operatorNick': instance.operatorNick,
      'extension': instance.extension,
      'muted': instance.muted,
      'tempMuted': instance.tempMuted,
      'tempMutedDuration': instance.tempMutedDuration,
    };

NIMChatroomTempMuteAttachment _$NIMChatroomTempMuteAttachmentFromJson(
    Map<String, dynamic> json) {
  return NIMChatroomTempMuteAttachment(
    type: json['type'] as int,
    duration: json['duration'] as int,
    targets:
        (json['targets'] as List<dynamic>?)?.map((e) => e as String).toList(),
    targetNicks: (json['targetNicks'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    operator: json['operator'] as String?,
    operatorNick: json['operatorNick'] as String?,
    extension: castPlatformMapToDartMap(json['extension'] as Map?),
  );
}

Map<String, dynamic> _$NIMChatroomTempMuteAttachmentToJson(
        NIMChatroomTempMuteAttachment instance) =>
    <String, dynamic>{
      'type': instance.type,
      'targets': instance.targets,
      'targetNicks': instance.targetNicks,
      'operator': instance.operator,
      'operatorNick': instance.operatorNick,
      'extension': instance.extension,
      'duration': instance.duration,
    };

NIMChatroomQueueChangeAttachment _$NIMChatroomQueueChangeAttachmentFromJson(
    Map<String, dynamic> json) {
  return NIMChatroomQueueChangeAttachment(
    type: json['type'] as int,
    queueChangeType: _$enumDecode(
        _$NIMChatroomQueueChangeTypeEnumMap, json['queueChangeType']),
    content: json['content'] as String?,
    key: json['key'] as String?,
    contentMap: castMapToTypeOfStringString(json['contentMap'] as Map?),
    targets:
        (json['targets'] as List<dynamic>?)?.map((e) => e as String).toList(),
    targetNicks: (json['targetNicks'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    operator: json['operator'] as String?,
    operatorNick: json['operatorNick'] as String?,
    extension: castPlatformMapToDartMap(json['extension'] as Map?),
  );
}

Map<String, dynamic> _$NIMChatroomQueueChangeAttachmentToJson(
        NIMChatroomQueueChangeAttachment instance) =>
    <String, dynamic>{
      'type': instance.type,
      'targets': instance.targets,
      'targetNicks': instance.targetNicks,
      'operator': instance.operator,
      'operatorNick': instance.operatorNick,
      'extension': instance.extension,
      'contentMap': instance.contentMap,
      'queueChangeType':
          _$NIMChatroomQueueChangeTypeEnumMap[instance.queueChangeType],
      'key': instance.key,
      'content': instance.content,
    };

const _$NIMChatroomQueueChangeTypeEnumMap = {
  NIMChatroomQueueChangeType.undefined: 'undefined',
  NIMChatroomQueueChangeType.offer: 'offer',
  NIMChatroomQueueChangeType.poll: 'poll',
  NIMChatroomQueueChangeType.drop: 'drop',
  NIMChatroomQueueChangeType.partialClear: 'partialClear',
  NIMChatroomQueueChangeType.batchUpdate: 'batchUpdate',
};

NIMChatroomUpdateRequest _$NIMChatroomUpdateRequestFromJson(
    Map<String, dynamic> json) {
  return NIMChatroomUpdateRequest(
    name: json['name'] as String?,
    announcement: json['announcement'] as String?,
    broadcastUrl: json['broadcastUrl'] as String?,
    extension: castPlatformMapToDartMap(json['extension'] as Map?),
    queueModificationLevel: _$enumDecodeNullable(
        _$NIMChatroomQueueModificationLevelEnumMap,
        json['queueModificationLevel']),
  );
}

Map<String, dynamic> _$NIMChatroomUpdateRequestToJson(
        NIMChatroomUpdateRequest instance) =>
    <String, dynamic>{
      'name': instance.name,
      'announcement': instance.announcement,
      'broadcastUrl': instance.broadcastUrl,
      'extension': instance.extension,
      'queueModificationLevel': _$NIMChatroomQueueModificationLevelEnumMap[
          instance.queueModificationLevel],
    };

K? _$enumDecodeNullable<K, V>(
  Map<K, V> enumValues,
  dynamic source, {
  K? unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<K, V>(enumValues, source, unknownValue: unknownValue);
}

NIMChatroomUpdateMyMemberInfoRequest
    _$NIMChatroomUpdateMyMemberInfoRequestFromJson(Map<String, dynamic> json) {
  return NIMChatroomUpdateMyMemberInfoRequest(
    nickname: json['nickname'] as String?,
    avatar: json['avatar'] as String?,
    extension: castPlatformMapToDartMap(json['extension'] as Map?),
    needSave: json['needSave'] as bool,
  );
}

Map<String, dynamic> _$NIMChatroomUpdateMyMemberInfoRequestToJson(
        NIMChatroomUpdateMyMemberInfoRequest instance) =>
    <String, dynamic>{
      'nickname': instance.nickname,
      'avatar': instance.avatar,
      'extension': instance.extension,
      'needSave': instance.needSave,
    };

NIMChatroomMemberOptions _$NIMChatroomMemberOptionsFromJson(
    Map<String, dynamic> json) {
  return NIMChatroomMemberOptions(
    roomId: json['roomId'] as String,
    account: json['account'] as String,
    notifyExtension: castPlatformMapToDartMap(json['notifyExtension'] as Map?),
  );
}

Map<String, dynamic> _$NIMChatroomMemberOptionsToJson(
        NIMChatroomMemberOptions instance) =>
    <String, dynamic>{
      'roomId': instance.roomId,
      'account': instance.account,
      'notifyExtension': instance.notifyExtension,
    };
