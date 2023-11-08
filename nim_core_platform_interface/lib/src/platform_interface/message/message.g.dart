// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NIMMessage _$NIMMessageFromJson(Map<String, dynamic> json) {
  return NIMMessage(
    messageId: json['messageId'] as String? ?? '-1',
    sessionId: json['sessionId'] as String?,
    sessionType: _$enumDecodeNullable(
        _$NIMSessionTypeEnumMap, json['sessionType'],
        unknownValue: NIMSessionType.p2p),
    messageType: _$enumDecodeNullable(
            _$NIMMessageTypeEnumMap, json['messageType'],
            unknownValue: NIMMessageType.undef) ??
        NIMMessageType.undef,
    messageSubType: json['messageSubType'] as int?,
    status: _$enumDecodeNullable(_$NIMMessageStatusEnumMap, json['status'],
        unknownValue: NIMMessageStatus.sending),
    messageDirection: _$enumDecode(
        _$NIMMessageDirectionEnumMap, json['messageDirection'],
        unknownValue: NIMMessageDirection.outgoing),
    fromAccount: json['fromAccount'] as String?,
    content: json['content'] as String?,
    timestamp: json['timestamp'] as int,
    messageAttachment:
        NIMMessageAttachment._fromMap(json['messageAttachment'] as Map?),
    attachmentStatus: _$enumDecodeNullable(
        _$NIMMessageAttachmentStatusEnumMap, json['attachmentStatus'],
        unknownValue: NIMMessageAttachmentStatus.transferred),
    uuid: json['uuid'] as String?,
    serverId: json['serverId'] as int?,
    config: NIMCustomMessageConfig._fromMap(json['config'] as Map?),
    remoteExtension: castPlatformMapToDartMap(json['remoteExtension'] as Map?),
    localExtension: castPlatformMapToDartMap(json['localExtension'] as Map?),
    callbackExtension: json['callbackExtension'] as String?,
    pushPayload: castPlatformMapToDartMap(json['pushPayload'] as Map?),
    pushContent: json['pushContent'] as String?,
    memberPushOption:
        NIMMemberPushOption._fromMap(json['memberPushOption'] as Map?),
    senderClientType: _$enumDecodeNullable(
        _$NIMClientTypeEnumMap, json['senderClientType'],
        unknownValue: NIMClientType.unknown),
    antiSpamOption: NIMAntiSpamOption._fromMap(json['antiSpamOption'] as Map?),
    messageAck: json['messageAck'] as bool? ?? false,
    hasSendAck: json['hasSendAck'] as bool? ?? false,
    ackCount: json['ackCount'] as int? ?? 0,
    unAckCount: json['unAckCount'] as int? ?? 0,
    clientAntiSpam: json['clientAntiSpam'] as bool? ?? false,
    isInBlackList: json['isInBlackList'] as bool? ?? false,
    isChecked: json['isChecked'] as bool? ?? false,
    sessionUpdate: json['sessionUpdate'] as bool? ?? true,
    messageThreadOption:
        NIMMessageThreadOption._fromMap(json['messageThreadOption'] as Map?),
    quickCommentUpdateTime: json['quickCommentUpdateTime'] as int?,
    isDeleted: json['isDeleted'] as bool? ?? false,
    yidunAntiCheating:
        castPlatformMapToDartMap(json['yidunAntiCheating'] as Map?),
    env: json['env'] as String?,
    fromNickname: json['fromNickname'] as String?,
    isRemoteRead: json['isRemoteRead'] as bool?,
    yidunAntiSpamExt: json['yidunAntiSpamExt'] as String?,
    yidunAntiSpamRes: json['yidunAntiSpamRes'] as String?,
    robotInfo: NIMMessageRobotInfo._fromMap(json['robotInfo'] as Map?),
  );
}

Map<String, dynamic> _$NIMMessageToJson(NIMMessage instance) =>
    <String, dynamic>{
      'messageId': instance.messageId,
      'sessionId': instance.sessionId,
      'sessionType': _$NIMSessionTypeEnumMap[instance.sessionType],
      'messageType': _$NIMMessageTypeEnumMap[instance.messageType],
      'messageSubType': instance.messageSubType,
      'status': _$NIMMessageStatusEnumMap[instance.status],
      'messageDirection':
          _$NIMMessageDirectionEnumMap[instance.messageDirection],
      'fromAccount': instance.fromAccount,
      'content': instance.content,
      'timestamp': instance.timestamp,
      'messageAttachment':
          NIMMessageAttachment._toMap(instance.messageAttachment),
      'attachmentStatus':
          _$NIMMessageAttachmentStatusEnumMap[instance.attachmentStatus],
      'uuid': instance.uuid,
      'serverId': instance.serverId,
      'config': NIMCustomMessageConfig._toMap(instance.config),
      'remoteExtension': instance.remoteExtension,
      'localExtension': instance.localExtension,
      'callbackExtension': instance.callbackExtension,
      'pushPayload': instance.pushPayload,
      'pushContent': instance.pushContent,
      'memberPushOption': NIMMemberPushOption._toMap(instance.memberPushOption),
      'senderClientType': _$NIMClientTypeEnumMap[instance.senderClientType],
      'antiSpamOption': NIMAntiSpamOption._toMap(instance.antiSpamOption),
      'messageAck': instance.messageAck,
      'hasSendAck': instance.hasSendAck,
      'ackCount': instance.ackCount,
      'unAckCount': instance.unAckCount,
      'clientAntiSpam': instance.clientAntiSpam,
      'isInBlackList': instance.isInBlackList,
      'isChecked': instance.isChecked,
      'sessionUpdate': instance.sessionUpdate,
      'messageThreadOption':
          NIMMessageThreadOption._toMap(instance.messageThreadOption),
      'quickCommentUpdateTime': instance.quickCommentUpdateTime,
      'isDeleted': instance.isDeleted,
      'yidunAntiCheating': instance.yidunAntiCheating,
      'env': instance.env,
      'fromNickname': instance.fromNickname,
      'isRemoteRead': instance.isRemoteRead,
      'yidunAntiSpamRes': instance.yidunAntiSpamRes,
      'yidunAntiSpamExt': instance.yidunAntiSpamExt,
      'robotInfo': NIMMessageRobotInfo._toMap(instance.robotInfo),
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

const _$NIMSessionTypeEnumMap = {
  NIMSessionType.none: 'none',
  NIMSessionType.p2p: 'p2p',
  NIMSessionType.team: 'team',
  NIMSessionType.superTeam: 'superTeam',
  NIMSessionType.system: 'system',
  NIMSessionType.ysf: 'ysf',
  NIMSessionType.chatRoom: 'chatRoom',
};

const _$NIMMessageTypeEnumMap = {
  NIMMessageType.undef: 'undef',
  NIMMessageType.text: 'text',
  NIMMessageType.image: 'image',
  NIMMessageType.audio: 'audio',
  NIMMessageType.video: 'video',
  NIMMessageType.location: 'location',
  NIMMessageType.file: 'file',
  NIMMessageType.avchat: 'avchat',
  NIMMessageType.notification: 'notification',
  NIMMessageType.tip: 'tip',
  NIMMessageType.robot: 'robot',
  NIMMessageType.netcall: 'netcall',
  NIMMessageType.custom: 'custom',
  NIMMessageType.appCustom: 'appCustom',
  NIMMessageType.qiyuCustom: 'qiyuCustom',
};

const _$NIMMessageStatusEnumMap = {
  NIMMessageStatus.draft: 'draft',
  NIMMessageStatus.sending: 'sending',
  NIMMessageStatus.success: 'success',
  NIMMessageStatus.fail: 'fail',
  NIMMessageStatus.read: 'read',
  NIMMessageStatus.unread: 'unread',
};

const _$NIMMessageDirectionEnumMap = {
  NIMMessageDirection.outgoing: 'outgoing',
  NIMMessageDirection.received: 'received',
};

const _$NIMMessageAttachmentStatusEnumMap = {
  NIMMessageAttachmentStatus.initial: 'initial',
  NIMMessageAttachmentStatus.failed: 'failed',
  NIMMessageAttachmentStatus.transferring: 'transferring',
  NIMMessageAttachmentStatus.transferred: 'transferred',
  NIMMessageAttachmentStatus.cancel: 'cancel',
};

const _$NIMClientTypeEnumMap = {
  NIMClientType.unknown: 'unknown',
  NIMClientType.android: 'android',
  NIMClientType.ios: 'ios',
  NIMClientType.windows: 'windows',
  NIMClientType.wp: 'wp',
  NIMClientType.web: 'web',
  NIMClientType.rest: 'rest',
  NIMClientType.macos: 'macos',
};

NIMCustomMessageConfig _$NIMCustomMessageConfigFromJson(
    Map<String, dynamic> json) {
  return NIMCustomMessageConfig(
    enableHistory: json['enableHistory'] as bool? ?? true,
    enableRoaming: json['enableRoaming'] as bool? ?? true,
    enableSelfSync: json['enableSelfSync'] as bool? ?? true,
    enablePush: json['enablePush'] as bool? ?? true,
    enablePushNick: json['enablePushNick'] as bool? ?? true,
    enableUnreadCount: json['enableUnreadCount'] as bool? ?? true,
    enableRoute: json['enableRoute'] as bool? ?? true,
    enablePersist: json['enablePersist'] as bool? ?? true,
  );
}

Map<String, dynamic> _$NIMCustomMessageConfigToJson(
        NIMCustomMessageConfig instance) =>
    <String, dynamic>{
      'enableHistory': instance.enableHistory,
      'enableRoaming': instance.enableRoaming,
      'enableSelfSync': instance.enableSelfSync,
      'enablePush': instance.enablePush,
      'enablePushNick': instance.enablePushNick,
      'enableUnreadCount': instance.enableUnreadCount,
      'enableRoute': instance.enableRoute,
      'enablePersist': instance.enablePersist,
    };

NIMFileAttachment _$NIMFileAttachmentFromJson(Map<String, dynamic> json) {
  return NIMFileAttachment(
    path: json['path'] as String?,
    size: json['size'] as int?,
    md5: json['md5'] as String?,
    url: json['url'] as String?,
    base64: json['base64'] as String?,
    displayName: json['name'] as String?,
    extension: json['ext'] as String?,
    expire: json['expire'] as int?,
    nosScene: json['sen'] as String? ?? 'defaultIm',
    forceUpload: json['force_upload'] as bool,
  );
}

Map<String, dynamic> _$NIMFileAttachmentToJson(NIMFileAttachment instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('path', instance.path);
  writeNotNull('url', instance.url);
  writeNotNull('base64', instance.base64);
  val['size'] = instance.size;
  writeNotNull('md5', instance.md5);
  val['name'] = instance.displayName;
  val['ext'] = instance.extension;
  val['expire'] = instance.expire;
  val['sen'] = instance.nosScene;
  val['force_upload'] = instance.forceUpload;
  return val;
}

NIMAudioAttachment _$NIMAudioAttachmentFromJson(Map<String, dynamic> json) {
  return NIMAudioAttachment(
    duration: json['dur'] as int?,
    autoTransform: json['autoTransform'] as bool?,
    text: json['text'] as String?,
    path: json['path'] as String?,
    size: json['size'] as int?,
    md5: json['md5'] as String?,
    url: json['url'] as String?,
    base64: json['base64'] as String?,
    displayName: json['name'] as String?,
    extension: json['ext'] as String?,
    expire: json['expire'] as int?,
    nosScene: json['sen'] as String? ?? 'defaultIm',
    forceUpload: json['force_upload'] as bool,
  );
}

Map<String, dynamic> _$NIMAudioAttachmentToJson(NIMAudioAttachment instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('path', instance.path);
  writeNotNull('url', instance.url);
  val['size'] = instance.size;
  writeNotNull('md5', instance.md5);
  writeNotNull('base64', instance.base64);
  val['name'] = instance.displayName;
  val['ext'] = instance.extension;
  val['expire'] = instance.expire;
  val['sen'] = instance.nosScene;
  val['force_upload'] = instance.forceUpload;
  val['dur'] = instance.duration;
  val['autoTransform'] = instance.autoTransform;
  val['text'] = instance.text;
  return val;
}

NIMVideoAttachment _$NIMVideoAttachmentFromJson(Map<String, dynamic> json) {
  return NIMVideoAttachment(
    duration: json['dur'] as int?,
    width: json['w'] as int?,
    height: json['h'] as int?,
    thumbPath: json['thumbPath'] as String?,
    thumbUrl: json['thumbUrl'] as String?,
    path: json['path'] as String?,
    size: json['size'] as int?,
    md5: json['md5'] as String?,
    url: json['url'] as String?,
    base64: json['base64'] as String?,
    displayName: json['name'] as String?,
    extension: json['ext'] as String?,
    expire: json['expire'] as int?,
    nosScene: json['sen'] as String? ?? 'defaultIm',
    forceUpload: json['force_upload'] as bool,
  );
}

Map<String, dynamic> _$NIMVideoAttachmentToJson(NIMVideoAttachment instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('path', instance.path);
  writeNotNull('url', instance.url);
  val['size'] = instance.size;
  writeNotNull('md5', instance.md5);
  val['name'] = instance.displayName;
  writeNotNull('base64', instance.base64);
  val['ext'] = instance.extension;
  val['expire'] = instance.expire;
  val['sen'] = instance.nosScene;
  val['force_upload'] = instance.forceUpload;
  val['dur'] = instance.duration;
  val['w'] = instance.width;
  val['h'] = instance.height;
  val['thumbPath'] = instance.thumbPath;
  val['thumbUrl'] = instance.thumbUrl;
  return val;
}

NIMImageAttachment _$NIMImageAttachmentFromJson(Map<String, dynamic> json) {
  return NIMImageAttachment(
    thumbPath: json['thumbPath'] as String?,
    thumbUrl: json['thumbUrl'] as String?,
    width: json['w'] as int?,
    height: json['h'] as int?,
    path: json['path'] as String?,
    size: json['size'] as int?,
    md5: json['md5'] as String?,
    url: json['url'] as String?,
    base64: json['base64'] as String?,
    displayName: json['name'] as String?,
    extension: json['ext'] as String?,
    expire: json['expire'] as int?,
    nosScene: json['sen'] as String? ?? 'defaultIm',
    forceUpload: json['force_upload'] as bool,
  );
}

Map<String, dynamic> _$NIMImageAttachmentToJson(NIMImageAttachment instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('path', instance.path);
  writeNotNull('url', instance.url);
  val['size'] = instance.size;
  writeNotNull('md5', instance.md5);
  val['name'] = instance.displayName;
  val['ext'] = instance.extension;
  val['expire'] = instance.expire;
  val['sen'] = instance.nosScene;
  writeNotNull('base64', instance.base64);
  val['force_upload'] = instance.forceUpload;
  writeNotNull('thumbPath', instance.thumbPath);
  writeNotNull('thumbUrl', instance.thumbUrl);
  val['w'] = instance.width;
  val['h'] = instance.height;
  return val;
}

NIMLocationAttachment _$NIMLocationAttachmentFromJson(
    Map<String, dynamic> json) {
  return NIMLocationAttachment(
    latitude: (json['lat'] as num).toDouble(),
    longitude: (json['lng'] as num).toDouble(),
    address: json['title'] as String,
  );
}

Map<String, dynamic> _$NIMLocationAttachmentToJson(
        NIMLocationAttachment instance) =>
    <String, dynamic>{
      'lat': instance.latitude,
      'lng': instance.longitude,
      'title': instance.address,
    };

NIMMessageReceipt _$NIMMessageReceiptFromJson(Map<String, dynamic> json) {
  return NIMMessageReceipt(
    sessionId: json['sessionId'] as String,
    time: json['time'] as int,
  );
}

Map<String, dynamic> _$NIMMessageReceiptToJson(NIMMessageReceipt instance) =>
    <String, dynamic>{
      'sessionId': instance.sessionId,
      'time': instance.time,
    };

NIMTeamMessageReceipt _$NIMTeamMessageReceiptFromJson(
    Map<String, dynamic> json) {
  return NIMTeamMessageReceipt(
    messageId: json['messageId'] as String,
    ackCount: json['ackCount'] as int?,
    unAckCount: json['unAckCount'] as int?,
    newReaderAccount: json['newReaderAccount'] as String?,
  );
}

Map<String, dynamic> _$NIMTeamMessageReceiptToJson(
        NIMTeamMessageReceipt instance) =>
    <String, dynamic>{
      'messageId': instance.messageId,
      'ackCount': instance.ackCount,
      'unAckCount': instance.unAckCount,
      'newReaderAccount': instance.newReaderAccount,
    };

NIMAttachmentProgress _$NIMAttachmentProgressFromJson(
    Map<String, dynamic> json) {
  return NIMAttachmentProgress(
    id: json['id'] as String,
    progress: (json['progress'] as num?)?.toDouble(),
  );
}

Map<String, dynamic> _$NIMAttachmentProgressToJson(
        NIMAttachmentProgress instance) =>
    <String, dynamic>{
      'id': instance.id,
      'progress': instance.progress,
    };

NIMRevokeMessage _$NIMRevokeMessageFromJson(Map<String, dynamic> json) {
  return NIMRevokeMessage(
    message: _nimMessageFromMap(json['message'] as Map?),
    attach: json['attach'] as String?,
    revokeAccount: json['revokeAccount'] as String?,
    customInfo: json['customInfo'] as String?,
    notificationType: json['notificationType'] as int?,
    revokeType: _$enumDecodeNullable(
        _$RevokeMessageTypeEnumMap, json['revokeType'],
        unknownValue: RevokeMessageType.undefined),
    callbackExt: json['callbackExt'] as String?,
  );
}

Map<String, dynamic> _$NIMRevokeMessageToJson(NIMRevokeMessage instance) =>
    <String, dynamic>{
      'message': _nimMessageToMap(instance.message),
      'attach': instance.attach,
      'revokeAccount': instance.revokeAccount,
      'customInfo': instance.customInfo,
      'notificationType': instance.notificationType,
      'revokeType': _$RevokeMessageTypeEnumMap[instance.revokeType],
      'callbackExt': instance.callbackExt,
    };

const _$RevokeMessageTypeEnumMap = {
  RevokeMessageType.undefined: 'undefined',
  RevokeMessageType.p2pDeleteMsg: 'p2pDeleteMsg',
  RevokeMessageType.teamDeleteMsg: 'teamDeleteMsg',
  RevokeMessageType.superTeamDeleteMsg: 'superTeamDeleteMsg',
  RevokeMessageType.p2pOneWayDeleteMsg: 'p2pOneWayDeleteMsg',
  RevokeMessageType.teamOneWayDeleteMsg: 'teamOneWayDeleteMsg',
};

NIMBroadcastMessage _$NIMBroadcastMessageFromJson(Map<String, dynamic> json) {
  return NIMBroadcastMessage(
    id: json['id'] as int?,
    fromAccount: json['fromAccount'] as String?,
    time: json['time'] as int?,
    content: json['content'] as String?,
  );
}

Map<String, dynamic> _$NIMBroadcastMessageToJson(
        NIMBroadcastMessage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fromAccount': instance.fromAccount,
      'time': instance.time,
      'content': instance.content,
    };

NIMAntiSpamOption _$NIMAntiSpamOptionFromJson(Map<String, dynamic> json) {
  return NIMAntiSpamOption(
    enable: json['enable'] as bool? ?? false,
    content: json['content'] as String?,
    antiSpamConfigId: json['antiSpamConfigId'] as String?,
  );
}

Map<String, dynamic> _$NIMAntiSpamOptionToJson(NIMAntiSpamOption instance) =>
    <String, dynamic>{
      'enable': instance.enable,
      'content': instance.content,
      'antiSpamConfigId': instance.antiSpamConfigId,
    };

NIMMemberPushOption _$NIMMemberPushOptionFromJson(Map<String, dynamic> json) {
  return NIMMemberPushOption(
    forcePushContent: json['forcePushContent'] as String?,
    forcePushList: (json['forcePushList'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    isForcePush: json['isForcePush'] as bool? ?? true,
  );
}

Map<String, dynamic> _$NIMMemberPushOptionToJson(
        NIMMemberPushOption instance) =>
    <String, dynamic>{
      'forcePushList': instance.forcePushList,
      'forcePushContent': instance.forcePushContent,
      'isForcePush': instance.isForcePush,
    };

NIMMessageThreadOption _$NIMMessageThreadOptionFromJson(
    Map<String, dynamic> json) {
  return NIMMessageThreadOption(
    replyMessageFromAccount: json['replyMessageFromAccount'] as String,
    replyMessageIdClient: json['replyMessageIdClient'] as String,
    replyMessageIdServer: json['replyMessageIdServer'] as int?,
    replyMessageTime: json['replyMessageTime'] as int?,
    replyMessageToAccount: json['replyMessageToAccount'] as String,
    threadMessageFromAccount: json['threadMessageFromAccount'] as String,
    threadMessageIdClient: json['threadMessageIdClient'] as String,
    threadMessageIdServer: json['threadMessageIdServer'] as int?,
    threadMessageTime: json['threadMessageTime'] as int?,
    threadMessageToAccount: json['threadMessageToAccount'] as String,
  );
}

Map<String, dynamic> _$NIMMessageThreadOptionToJson(
        NIMMessageThreadOption instance) =>
    <String, dynamic>{
      'replyMessageFromAccount': instance.replyMessageFromAccount,
      'replyMessageToAccount': instance.replyMessageToAccount,
      'replyMessageTime': instance.replyMessageTime,
      'replyMessageIdServer': instance.replyMessageIdServer,
      'replyMessageIdClient': instance.replyMessageIdClient,
      'threadMessageFromAccount': instance.threadMessageFromAccount,
      'threadMessageToAccount': instance.threadMessageToAccount,
      'threadMessageTime': instance.threadMessageTime,
      'threadMessageIdServer': instance.threadMessageIdServer,
      'threadMessageIdClient': instance.threadMessageIdClient,
    };

NIMChatroomMessage _$NIMChatroomMessageFromJson(Map<String, dynamic> json) {
  return NIMChatroomMessage(
    enableHistory: json['enableHistory'] as bool? ?? true,
    isHighPriorityMessage: json['isHighPriorityMessage'] as bool? ?? false,
    extension: _chatroomMessageExtensionFromMap(json['extension'] as Map?),
    messageId: json['messageId'] as String? ?? '-1',
    sessionId: json['sessionId'] as String?,
    sessionType: _$enumDecodeNullable(
        _$NIMSessionTypeEnumMap, json['sessionType'],
        unknownValue: NIMSessionType.p2p),
    messageType: _$enumDecodeNullable(
            _$NIMMessageTypeEnumMap, json['messageType'],
            unknownValue: NIMMessageType.undef) ??
        NIMMessageType.undef,
    messageSubType: json['messageSubType'] as int?,
    status: _$enumDecodeNullable(_$NIMMessageStatusEnumMap, json['status'],
        unknownValue: NIMMessageStatus.sending),
    messageDirection: _$enumDecode(
        _$NIMMessageDirectionEnumMap, json['messageDirection'],
        unknownValue: NIMMessageDirection.outgoing),
    fromAccount: json['fromAccount'] as String?,
    content: json['content'] as String?,
    timestamp: json['timestamp'] as int,
    messageAttachment:
        NIMMessageAttachment._fromMap(json['messageAttachment'] as Map?),
    attachmentStatus: _$enumDecodeNullable(
        _$NIMMessageAttachmentStatusEnumMap, json['attachmentStatus'],
        unknownValue: NIMMessageAttachmentStatus.transferred),
    uuid: json['uuid'] as String?,
    serverId: json['serverId'] as int?,
    remoteExtension: castPlatformMapToDartMap(json['remoteExtension'] as Map?),
    localExtension: castPlatformMapToDartMap(json['localExtension'] as Map?),
    callbackExtension: json['callbackExtension'] as String?,
    pushPayload: castPlatformMapToDartMap(json['pushPayload'] as Map?),
    pushContent: json['pushContent'] as String?,
    memberPushOption:
        NIMMemberPushOption._fromMap(json['memberPushOption'] as Map?),
    senderClientType: _$enumDecodeNullable(
        _$NIMClientTypeEnumMap, json['senderClientType'],
        unknownValue: NIMClientType.unknown),
    antiSpamOption: NIMAntiSpamOption._fromMap(json['antiSpamOption'] as Map?),
    messageAck: json['messageAck'] as bool? ?? false,
    hasSendAck: json['hasSendAck'] as bool? ?? false,
    ackCount: json['ackCount'] as int? ?? 0,
    unAckCount: json['unAckCount'] as int? ?? 0,
    clientAntiSpam: json['clientAntiSpam'] as bool? ?? false,
    isInBlackList: json['isInBlackList'] as bool? ?? false,
    isChecked: json['isChecked'] as bool? ?? false,
    sessionUpdate: json['sessionUpdate'] as bool? ?? true,
    messageThreadOption:
        NIMMessageThreadOption._fromMap(json['messageThreadOption'] as Map?),
    quickCommentUpdateTime: json['quickCommentUpdateTime'] as int?,
    isDeleted: json['isDeleted'] as bool? ?? false,
    yidunAntiCheating:
        castPlatformMapToDartMap(json['yidunAntiCheating'] as Map?),
    env: json['env'] as String?,
    fromNickname: json['fromNickname'] as String?,
    isRemoteRead: json['isRemoteRead'] as bool?,
    yidunAntiSpamExt: json['yidunAntiSpamExt'] as String?,
    yidunAntiSpamRes: json['yidunAntiSpamRes'] as String?,
  )..config = NIMCustomMessageConfig._fromMap(json['config'] as Map?);
}

Map<String, dynamic> _$NIMChatroomMessageToJson(NIMChatroomMessage instance) =>
    <String, dynamic>{
      'messageId': instance.messageId,
      'sessionId': instance.sessionId,
      'sessionType': _$NIMSessionTypeEnumMap[instance.sessionType],
      'messageType': _$NIMMessageTypeEnumMap[instance.messageType],
      'messageSubType': instance.messageSubType,
      'status': _$NIMMessageStatusEnumMap[instance.status],
      'messageDirection':
          _$NIMMessageDirectionEnumMap[instance.messageDirection],
      'fromAccount': instance.fromAccount,
      'content': instance.content,
      'timestamp': instance.timestamp,
      'messageAttachment':
          NIMMessageAttachment._toMap(instance.messageAttachment),
      'attachmentStatus':
          _$NIMMessageAttachmentStatusEnumMap[instance.attachmentStatus],
      'uuid': instance.uuid,
      'serverId': instance.serverId,
      'config': NIMCustomMessageConfig._toMap(instance.config),
      'remoteExtension': instance.remoteExtension,
      'localExtension': instance.localExtension,
      'callbackExtension': instance.callbackExtension,
      'pushPayload': instance.pushPayload,
      'pushContent': instance.pushContent,
      'memberPushOption': NIMMemberPushOption._toMap(instance.memberPushOption),
      'senderClientType': _$NIMClientTypeEnumMap[instance.senderClientType],
      'antiSpamOption': NIMAntiSpamOption._toMap(instance.antiSpamOption),
      'messageAck': instance.messageAck,
      'hasSendAck': instance.hasSendAck,
      'ackCount': instance.ackCount,
      'unAckCount': instance.unAckCount,
      'clientAntiSpam': instance.clientAntiSpam,
      'isInBlackList': instance.isInBlackList,
      'isChecked': instance.isChecked,
      'sessionUpdate': instance.sessionUpdate,
      'messageThreadOption':
          NIMMessageThreadOption._toMap(instance.messageThreadOption),
      'quickCommentUpdateTime': instance.quickCommentUpdateTime,
      'isDeleted': instance.isDeleted,
      'yidunAntiCheating': instance.yidunAntiCheating,
      'env': instance.env,
      'fromNickname': instance.fromNickname,
      'isRemoteRead': instance.isRemoteRead,
      'yidunAntiSpamExt': instance.yidunAntiSpamExt,
      'yidunAntiSpamRes': instance.yidunAntiSpamRes,
      'enableHistory': instance.enableHistory,
      'isHighPriorityMessage': instance.isHighPriorityMessage,
      'extension': _chatroomMessageExtensionToMap(instance.extension),
    };

NIMChatroomMessageExtension _$NIMChatroomMessageExtensionFromJson(
    Map<String, dynamic> json) {
  return NIMChatroomMessageExtension(
    nickname: json['nickname'] as String?,
    avatar: json['avatar'] as String?,
    senderExtension: castPlatformMapToDartMap(json['senderExtension'] as Map?),
  );
}

Map<String, dynamic> _$NIMChatroomMessageExtensionToJson(
        NIMChatroomMessageExtension instance) =>
    <String, dynamic>{
      'nickname': instance.nickname,
      'avatar': instance.avatar,
      'senderExtension': instance.senderExtension,
    };

NIMSession _$NIMSessionFromJson(Map<String, dynamic> json) {
  return NIMSession(
    sessionId: json['sessionId'] as String,
    senderAccount: json['senderAccount'] as String?,
    senderNickname: json['senderNickname'] as String?,
    sessionType: _$enumDecode(_$NIMSessionTypeEnumMap, json['sessionType']),
    lastMessageId: json['lastMessageId'] as String?,
    lastMessageType:
        _$enumDecodeNullable(_$NIMMessageTypeEnumMap, json['lastMessageType']),
    lastMessageStatus: _$enumDecodeNullable(
        _$NIMMessageStatusEnumMap, json['lastMessageStatus']),
    lastMessageContent: json['lastMessageContent'] as String?,
    lastMessageTime: json['lastMessageTime'] as int?,
    lastMessageAttachment:
        NIMMessageAttachment._fromMap(json['lastMessageAttachment'] as Map?),
    unreadCount: json['unreadCount'] as int?,
    extension: castPlatformMapToDartMap(json['extension'] as Map?),
    sessionForWeb: castPlatformMapToDartMap(json['sessionForWeb'] as Map?),
    tag: json['tag'] as int?,
  );
}

Map<String, dynamic> _$NIMSessionToJson(NIMSession instance) =>
    <String, dynamic>{
      'sessionId': instance.sessionId,
      'senderAccount': instance.senderAccount,
      'senderNickname': instance.senderNickname,
      'sessionType': _$NIMSessionTypeEnumMap[instance.sessionType],
      'lastMessageId': instance.lastMessageId,
      'lastMessageType': _$NIMMessageTypeEnumMap[instance.lastMessageType],
      'lastMessageStatus':
          _$NIMMessageStatusEnumMap[instance.lastMessageStatus],
      'lastMessageContent': instance.lastMessageContent,
      'lastMessageTime': instance.lastMessageTime,
      'lastMessageAttachment':
          NIMMessageAttachment._toMap(instance.lastMessageAttachment),
      'unreadCount': instance.unreadCount,
      'extension': instance.extension,
      'sessionForWeb': instance.sessionForWeb,
      'tag': instance.tag,
    };

NIMTeamMessageAckInfo _$NIMTeamMessageAckInfoFromJson(
    Map<String, dynamic> json) {
  return NIMTeamMessageAckInfo(
    teamId: json['teamId'] as String?,
    msgId: json['msgId'] as String?,
    ackAccountList: (json['ackAccountList'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    unAckAccountList: (json['unAckAccountList'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
  );
}

Map<String, dynamic> _$NIMTeamMessageAckInfoToJson(
        NIMTeamMessageAckInfo instance) =>
    <String, dynamic>{
      'teamId': instance.teamId,
      'msgId': instance.msgId,
      'ackAccountList': instance.ackAccountList,
      'unAckAccountList': instance.unAckAccountList,
    };

NIMMessageRobotInfo _$NIMMessageRobotInfoFromJson(Map<String, dynamic> json) {
  return NIMMessageRobotInfo(
    function: json['function'] as String?,
    topic: json['topic'] as String?,
    customContent: json['customContent'] as String?,
    account: json['account'] as String?,
  );
}

Map<String, dynamic> _$NIMMessageRobotInfoToJson(
        NIMMessageRobotInfo instance) =>
    <String, dynamic>{
      'function': instance.function,
      'topic': instance.topic,
      'customContent': instance.customContent,
      'account': instance.account,
    };

GetMessagesDynamicallyResult _$GetMessagesDynamicallyResultFromJson(
        Map<String, dynamic> json) =>
    GetMessagesDynamicallyResult(
      messages: GetMessagesDynamicallyResult.messageListFromMap(
          json['messages'] as List?),
      isReliable: json['isReliable'] as bool?,
    );

Map<String, dynamic> _$GetMessagesDynamicallyResultToJson(
        GetMessagesDynamicallyResult instance) =>
    <String, dynamic>{
      'messages': instance.messages?.map((e) => e.toMap()).toList(),
      'isReliable': instance.isReliable,
    };

GetMessagesDynamicallyParam _$GetMessagesDynamicallyParamFromJson(
        Map<String, dynamic> json) =>
    GetMessagesDynamicallyParam(
      json['sessionId'] as String,
      $enumDecode(_$NIMSessionTypeEnumMap, json['sessionType']),
      fromTime: json['fromTime'] as int?,
      toTime: json['toTime'] as int?,
      anchorServerId: json['anchorServerId'] as int?,
      anchorClientId: json['anchorClientId'] as String?,
      limit: json['limit'] as int?,
      direction: $enumDecodeNullable(
          _$NIMGetMessageDirectionEnumMap, json['direction']),
    );

Map<String, dynamic> _$GetMessagesDynamicallyParamToJson(
        GetMessagesDynamicallyParam instance) =>
    <String, dynamic>{
      'sessionId': instance.sessionId,
      'sessionType': _$NIMSessionTypeEnumMap[instance.sessionType]!,
      'fromTime': instance.fromTime,
      'toTime': instance.toTime,
      'anchorServerId': instance.anchorServerId,
      'anchorClientId': instance.anchorClientId,
      'limit': instance.limit,
      'direction': _$NIMGetMessageDirectionEnumMap[instance.direction],
    };

const _$NIMGetMessageDirectionEnumMap = {
  NIMGetMessageDirection.forward: 'forward',
  NIMGetMessageDirection.backward: 'backward',
};
