// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qchat_observer_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QChatStatusChangeEvent _$QChatStatusChangeEventFromJson(
        Map<String, dynamic> json) =>
    QChatStatusChangeEvent(
      $enumDecode(_$NIMAuthStatusEnumMap, json['status']),
    );

Map<String, dynamic> _$QChatStatusChangeEventToJson(
        QChatStatusChangeEvent instance) =>
    <String, dynamic>{
      'status': _$NIMAuthStatusEnumMap[instance.status]!,
    };

const _$NIMAuthStatusEnumMap = {
  NIMAuthStatus.unknown: 'unknown',
  NIMAuthStatus.unLogin: 'unLogin',
  NIMAuthStatus.connecting: 'connecting',
  NIMAuthStatus.logging: 'logging',
  NIMAuthStatus.loggedIn: 'loggedIn',
  NIMAuthStatus.forbidden: 'forbidden',
  NIMAuthStatus.netBroken: 'netBroken',
  NIMAuthStatus.versionError: 'versionError',
  NIMAuthStatus.pwdError: 'pwdError',
  NIMAuthStatus.kickOut: 'kickOut',
  NIMAuthStatus.kickOutByOtherClient: 'kickOutByOtherClient',
  NIMAuthStatus.dataSyncStart: 'dataSyncStart',
  NIMAuthStatus.dataSyncFinish: 'dataSyncFinish',
};

QChatMultiSpotLoginEvent _$QChatMultiSpotLoginEventFromJson(
        Map<String, dynamic> json) =>
    QChatMultiSpotLoginEvent(
      notifyType: $enumDecodeNullable(
          _$QChatMultiSpotNotifyTypeEnumMap, json['notifyType']),
      otherClient: qChatClientFromJson(json['otherClient'] as Map?),
    );

Map<String, dynamic> _$QChatMultiSpotLoginEventToJson(
        QChatMultiSpotLoginEvent instance) =>
    <String, dynamic>{
      'notifyType': _$QChatMultiSpotNotifyTypeEnumMap[instance.notifyType],
      'otherClient': instance.otherClient?.toJson(),
    };

const _$QChatMultiSpotNotifyTypeEnumMap = {
  QChatMultiSpotNotifyType.qchat_in: 'qchat_in',
  QChatMultiSpotNotifyType.qchat_out: 'qchat_out',
};

QChatKickedOutEvent _$QChatKickedOutEventFromJson(Map<String, dynamic> json) =>
    QChatKickedOutEvent(
      extension: json['extension'] as String?,
      clientType: json['clientType'] as int?,
      customClientType: json['customClientType'] as int?,
      kickReason:
          $enumDecodeNullable(_$QChatKickOutReasonEnumMap, json['kickReason']),
    );

Map<String, dynamic> _$QChatKickedOutEventToJson(
        QChatKickedOutEvent instance) =>
    <String, dynamic>{
      'clientType': instance.clientType,
      'kickReason': _$QChatKickOutReasonEnumMap[instance.kickReason],
      'extension': instance.extension,
      'customClientType': instance.customClientType,
    };

const _$QChatKickOutReasonEnumMap = {
  QChatKickOutReason.unknown: 'unknown',
  QChatKickOutReason.kick_by_same_platform: 'kick_by_same_platform',
  QChatKickOutReason.kick_by_server: 'kick_by_server',
  QChatKickOutReason.kick_by_other_platform: 'kick_by_other_platform',
};

QChatMessageUpdateEvent _$QChatMessageUpdateEventFromJson(
        Map<String, dynamic> json) =>
    QChatMessageUpdateEvent(
      message: qChatMessageFromJson(json['message'] as Map?),
      msgUpdateInfo: qChatMsgUpdateInfoFromJson(json['msgUpdateInfo'] as Map?),
    );

Map<String, dynamic> _$QChatMessageUpdateEventToJson(
        QChatMessageUpdateEvent instance) =>
    <String, dynamic>{
      'msgUpdateInfo': instance.msgUpdateInfo?.toJson(),
      'message': instance.message?.toJson(),
    };

QChatMessageRevokeEvent _$QChatMessageRevokeEventFromJson(
        Map<String, dynamic> json) =>
    QChatMessageRevokeEvent(
      msgUpdateInfo: qChatMsgUpdateInfoFromJson(json['msgUpdateInfo'] as Map?),
      message: qChatMessageFromJson(json['message'] as Map?),
    );

Map<String, dynamic> _$QChatMessageRevokeEventToJson(
        QChatMessageRevokeEvent instance) =>
    <String, dynamic>{
      'msgUpdateInfo': instance.msgUpdateInfo?.toJson(),
      'message': instance.message?.toJson(),
    };

QChatMessageDeleteEvent _$QChatMessageDeleteEventFromJson(
        Map<String, dynamic> json) =>
    QChatMessageDeleteEvent(
      msgUpdateInfo: qChatMsgUpdateInfoFromJson(json['msgUpdateInfo'] as Map?),
      message: qChatMessageFromJson(json['message'] as Map?),
    );

Map<String, dynamic> _$QChatMessageDeleteEventToJson(
        QChatMessageDeleteEvent instance) =>
    <String, dynamic>{
      'msgUpdateInfo': instance.msgUpdateInfo?.toJson(),
      'message': instance.message?.toJson(),
    };

QChatUnreadInfoChangedEvent _$QChatUnreadInfoChangedEventFromJson(
        Map<String, dynamic> json) =>
    QChatUnreadInfoChangedEvent(
      lastUnreadInfos:
          qChatUnreadInfListFromJson(json['lastUnreadInfos'] as List?),
      unreadInfos: qChatUnreadInfListFromJson(json['unreadInfos'] as List?),
    );

Map<String, dynamic> _$QChatUnreadInfoChangedEventToJson(
        QChatUnreadInfoChangedEvent instance) =>
    <String, dynamic>{
      'unreadInfos': instance.unreadInfos?.map((e) => e.toJson()).toList(),
      'lastUnreadInfos':
          instance.lastUnreadInfos?.map((e) => e.toJson()).toList(),
    };

AttachmentProgress _$AttachmentProgressFromJson(Map<String, dynamic> json) =>
    AttachmentProgress(
      id: json['id'] as String,
      progress: json['progress'] as double,
    );

Map<String, dynamic> _$AttachmentProgressToJson(AttachmentProgress instance) =>
    <String, dynamic>{
      'id': instance.id,
      'progress': instance.progress,
    };

QChatSystemNotificationUpdateEvent _$QChatSystemNotificationUpdateEventFromJson(
        Map<String, dynamic> json) =>
    QChatSystemNotificationUpdateEvent(
      msgUpdateInfo: qChatMsgUpdateInfoFromJson(json['msgUpdateInfo'] as Map?),
      systemNotification:
          qChatSystemNotificationFromJson(json['systemNotification'] as Map?),
    );

Map<String, dynamic> _$QChatSystemNotificationUpdateEventToJson(
        QChatSystemNotificationUpdateEvent instance) =>
    <String, dynamic>{
      'msgUpdateInfo': instance.msgUpdateInfo?.toJson(),
      'systemNotification': instance.systemNotification?.toJson(),
    };

QChatServerUnreadInfoChangedEvent _$QChatServerUnreadInfoChangedEventFromJson(
        Map<String, dynamic> json) =>
    QChatServerUnreadInfoChangedEvent(
      serverUnreadInfos:
          qChatServerUnreadInfoListFromJson(json['serverUnreadInfos'] as List?),
    );

Map<String, dynamic> _$QChatServerUnreadInfoChangedEventToJson(
        QChatServerUnreadInfoChangedEvent instance) =>
    <String, dynamic>{
      'serverUnreadInfos':
          instance.serverUnreadInfos?.map((e) => e.toJson()).toList(),
    };

QChatServerUnreadInfo _$QChatServerUnreadInfoFromJson(
        Map<String, dynamic> json) =>
    QChatServerUnreadInfo(
      serverId: json['serverId'] as int,
      unreadCount: json['unreadCount'] as int?,
      mentionedCount: json['mentionedCount'] as int?,
      maxCount: json['maxCount'] as int?,
    );

Map<String, dynamic> _$QChatServerUnreadInfoToJson(
        QChatServerUnreadInfo instance) =>
    <String, dynamic>{
      'serverId': instance.serverId,
      'unreadCount': instance.unreadCount,
      'mentionedCount': instance.mentionedCount,
      'maxCount': instance.maxCount,
    };
