// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qchat_message_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QChatSendMessageParam _$QChatSendMessageParamFromJson(
        Map<String, dynamic> json) =>
    QChatSendMessageParam(
      channelId: json['channelId'] as int,
      serverId: json['serverId'] as int,
      type: $enumDecode(_$NIMMessageTypeEnumMap, json['type']),
      extension: castPlatformMapToDartMap(json['extension'] as Map?),
      antiSpamOption:
          _qChatMessageAntiSpamOptionFromJson(json['antiSpamOption'] as Map?),
      attach: json['attach'] as String?,
      body: json['body'] as String?,
      env: json['env'] as String?,
      historyEnable: json['historyEnable'] as bool? ?? true,
      isRouteEnable: json['isRouteEnable'] as bool? ?? true,
      mentionedAccidList: (json['mentionedAccidList'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      mentionedAll: json['mentionedAll'] as bool? ?? false,
      mentionedRoleIdList: (json['mentionedRoleIdList'] as List<dynamic>?)
          ?.map((e) => e as int)
          .toList(),
      needBadge: json['needBadge'] as bool? ?? true,
      needPushNick: json['needPushNick'] as bool? ?? true,
      pushContent: json['pushContent'] as String?,
      pushEnable: json['pushEnable'] as bool? ?? true,
      pushPayload: castPlatformMapToDartMap(json['pushPayload'] as Map?),
      subType: json['subType'] as int?,
    );

Map<String, dynamic> _$QChatSendMessageParamToJson(
        QChatSendMessageParam instance) =>
    <String, dynamic>{
      'serverId': instance.serverId,
      'channelId': instance.channelId,
      'type': _$NIMMessageTypeEnumMap[instance.type]!,
      'body': instance.body,
      'attach': instance.attach,
      'extension': instance.extension,
      'pushPayload': instance.pushPayload,
      'pushContent': instance.pushContent,
      'mentionedAccidList': instance.mentionedAccidList,
      'mentionedRoleIdList': instance.mentionedRoleIdList,
      'mentionedAll': instance.mentionedAll,
      'historyEnable': instance.historyEnable,
      'pushEnable': instance.pushEnable,
      'needBadge': instance.needBadge,
      'needPushNick': instance.needPushNick,
      'isRouteEnable': instance.isRouteEnable,
      'env': instance.env,
      'antiSpamOption': instance.antiSpamOption?.toJson(),
      'subType': instance.subType,
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

QChatMessageAntiSpamOption _$QChatMessageAntiSpamOptionFromJson(
        Map<String, dynamic> json) =>
    QChatMessageAntiSpamOption(
      antiSpamBusinessId: json['antiSpamBusinessId'] as String?,
      customAntiSpamContent: json['customAntiSpamContent'] as String?,
      isAntiSpamUsingYidun: json['isAntiSpamUsingYidun'] as bool?,
      isCustomAntiSpamEnable: json['isCustomAntiSpamEnable'] as bool?,
      yidunAntiCheating: json['yidunAntiCheating'] as String?,
      yidunAntiSpamExt: json['yidunAntiSpamExt'] as String?,
      yidunCallback: json['yidunCallback'] as String?,
    );

Map<String, dynamic> _$QChatMessageAntiSpamOptionToJson(
        QChatMessageAntiSpamOption instance) =>
    <String, dynamic>{
      'isCustomAntiSpamEnable': instance.isCustomAntiSpamEnable,
      'customAntiSpamContent': instance.customAntiSpamContent,
      'antiSpamBusinessId': instance.antiSpamBusinessId,
      'isAntiSpamUsingYidun': instance.isAntiSpamUsingYidun,
      'yidunCallback': instance.yidunCallback,
      'yidunAntiCheating': instance.yidunAntiCheating,
      'yidunAntiSpamExt': instance.yidunAntiSpamExt,
    };

QChatSendMessageResult _$QChatSendMessageResultFromJson(
        Map<String, dynamic> json) =>
    QChatSendMessageResult(
      qChatMessageFromJson(json['sentMessage'] as Map?),
    );

Map<String, dynamic> _$QChatSendMessageResultToJson(
        QChatSendMessageResult instance) =>
    <String, dynamic>{
      'sentMessage': instance.sentMessage?.toJson(),
    };

QChatMessage _$QChatMessageFromJson(Map<String, dynamic> json) => QChatMessage(
      qChatChannelId: json['qChatChannelId'] as int,
      qChatServerId: json['qChatServerId'] as int,
      subType: json['subType'] as int?,
      serverStatus: json['serverStatus'] as int?,
      pushEnable: json['pushEnable'] as bool?,
      pushContent: json['pushContent'] as String?,
      needPushNick: json['needPushNick'] as bool?,
      needBadge: json['needBadge'] as bool?,
      mentionedRoleIdList: (json['mentionedRoleIdList'] as List<dynamic>?)
          ?.map((e) => e as int)
          .toList(),
      mentionedAll: json['mentionedAll'] as bool?,
      mentionedAccidList: (json['mentionedAccidList'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      historyEnable: json['historyEnable'] as bool?,
      env: json['env'] as String?,
      antiSpamOption:
          _qChatMessageAntiSpamOptionFromJson(json['antiSpamOption'] as Map?),
      uuid: json['uuid'] as String?,
      updateTime: json['updateTime'] as int?,
      time: json['time'] as int?,
      content: json['content'] as String?,
      attachment: NIMMessageAttachment.fromJson(json['attachment'] as Map?),
      resend: json['resend'] as bool?,
      antiSpamResult:
          _qChatMessageAntiSpamResultFromJson(json['antiSpamResult'] as Map?),
      attachStatus: $enumDecodeNullable(
          _$NIMMessageAttachmentStatusEnumMap, json['attachStatus']),
      callbackExtension: json['callbackExtension'] as String?,
      direct: $enumDecodeNullable(_$NIMMessageDirectionEnumMap, json['direct']),
      fromAccount: json['fromAccount'] as String?,
      fromClientType: json['fromClientType'] as int?,
      fromNick: json['fromNick'] as String?,
      localExtension: castPlatformMapToDartMap(json['localExtension'] as Map?),
      msgIdServer: json['msgIdServer'] as int?,
      msgType: $enumDecodeNullable(_$NIMMessageTypeEnumMap, json['msgType']),
      pushPayload: castPlatformMapToDartMap(json['pushPayload'] as Map?),
      remoteExtension:
          castPlatformMapToDartMap(json['remoteExtension'] as Map?),
      replyRefer: _qChatMessageReferFromJson(json['replyRefer'] as Map?),
      rootThread: json['rootThread'] as bool?,
      routeEnable: json['routeEnable'] as bool?,
      status: $enumDecodeNullable(_$NIMMessageStatusEnumMap, json['status']),
      threadRefer: _qChatMessageReferFromJson(json['threadRefer'] as Map?),
      updateContent:
          _qChatMsgUpdateContentFromJson(json['updateContent'] as Map?),
      updateOperatorInfo:
          qChatMsgUpdateInfoFromJson(json['updateOperatorInfo'] as Map?),
    );

Map<String, dynamic> _$QChatMessageToJson(QChatMessage instance) =>
    <String, dynamic>{
      'qChatServerId': instance.qChatServerId,
      'qChatChannelId': instance.qChatChannelId,
      'fromAccount': instance.fromAccount,
      'fromClientType': instance.fromClientType,
      'fromNick': instance.fromNick,
      'time': instance.time,
      'updateTime': instance.updateTime,
      'msgType': _$NIMMessageTypeEnumMap[instance.msgType],
      'content': instance.content,
      'remoteExtension': instance.remoteExtension,
      'uuid': instance.uuid,
      'msgIdServer': instance.msgIdServer,
      'resend': instance.resend,
      'serverStatus': instance.serverStatus,
      'pushPayload': instance.pushPayload,
      'pushContent': instance.pushContent,
      'mentionedAccidList': instance.mentionedAccidList,
      'mentionedAll': instance.mentionedAll,
      'historyEnable': instance.historyEnable,
      'attachment': NIMMessageAttachment.toJson(instance.attachment),
      'attachStatus':
          _$NIMMessageAttachmentStatusEnumMap[instance.attachStatus],
      'pushEnable': instance.pushEnable,
      'needBadge': instance.needBadge,
      'needPushNick': instance.needPushNick,
      'routeEnable': instance.routeEnable,
      'env': instance.env,
      'callbackExtension': instance.callbackExtension,
      'replyRefer': instance.replyRefer?.toJson(),
      'threadRefer': instance.threadRefer?.toJson(),
      'rootThread': instance.rootThread,
      'antiSpamOption': instance.antiSpamOption?.toJson(),
      'antiSpamResult': instance.antiSpamResult?.toJson(),
      'updateContent': instance.updateContent?.toJson(),
      'updateOperatorInfo': instance.updateOperatorInfo?.toJson(),
      'mentionedRoleIdList': instance.mentionedRoleIdList,
      'subType': instance.subType,
      'direct': _$NIMMessageDirectionEnumMap[instance.direct],
      'localExtension': instance.localExtension,
      'status': _$NIMMessageStatusEnumMap[instance.status],
    };

const _$NIMMessageAttachmentStatusEnumMap = {
  NIMMessageAttachmentStatus.initial: 'initial',
  NIMMessageAttachmentStatus.failed: 'failed',
  NIMMessageAttachmentStatus.transferring: 'transferring',
  NIMMessageAttachmentStatus.transferred: 'transferred',
  NIMMessageAttachmentStatus.cancel: 'cancel',
};

const _$NIMMessageDirectionEnumMap = {
  NIMMessageDirection.outgoing: 'outgoing',
  NIMMessageDirection.received: 'received',
};

const _$NIMMessageStatusEnumMap = {
  NIMMessageStatus.draft: 'draft',
  NIMMessageStatus.sending: 'sending',
  NIMMessageStatus.success: 'success',
  NIMMessageStatus.fail: 'fail',
  NIMMessageStatus.read: 'read',
  NIMMessageStatus.unread: 'unread',
};

QChatMessageAntiSpamResult _$QChatMessageAntiSpamResultFromJson(
        Map<String, dynamic> json) =>
    QChatMessageAntiSpamResult(
      isAntiSpam: json['isAntiSpam'] as bool?,
      yidunAntiSpamRes: json['yidunAntiSpamRes'] as String?,
    );

Map<String, dynamic> _$QChatMessageAntiSpamResultToJson(
        QChatMessageAntiSpamResult instance) =>
    <String, dynamic>{
      'isAntiSpam': instance.isAntiSpam,
      'yidunAntiSpamRes': instance.yidunAntiSpamRes,
    };

QChatMsgUpdateContent _$QChatMsgUpdateContentFromJson(
        Map<String, dynamic> json) =>
    QChatMsgUpdateContent(
      content: json['content'] as String?,
      serverStatus: json['serverStatus'] as int?,
      remoteExtension:
          castPlatformMapToDartMap(json['remoteExtension'] as Map?),
    );

Map<String, dynamic> _$QChatMsgUpdateContentToJson(
        QChatMsgUpdateContent instance) =>
    <String, dynamic>{
      'serverStatus': instance.serverStatus,
      'content': instance.content,
      'remoteExtension': instance.remoteExtension,
    };

QChatMsgUpdateInfo _$QChatMsgUpdateInfoFromJson(Map<String, dynamic> json) =>
    QChatMsgUpdateInfo(
      routeEnable: json['routeEnable'] as bool?,
      pushPayload: json['pushPayload'] as String?,
      env: json['env'] as String?,
      pushContent: json['pushContent'] as String?,
      ext: json['ext'] as String?,
      msg: json['msg'] as String?,
      operatorAccount: json['operatorAccount'] as String?,
      operatorClientType: json['operatorClientType'] as int?,
    );

Map<String, dynamic> _$QChatMsgUpdateInfoToJson(QChatMsgUpdateInfo instance) =>
    <String, dynamic>{
      'operatorAccount': instance.operatorAccount,
      'operatorClientType': instance.operatorClientType,
      'msg': instance.msg,
      'ext': instance.ext,
      'pushContent': instance.pushContent,
      'pushPayload': instance.pushPayload,
      'routeEnable': instance.routeEnable,
      'env': instance.env,
    };

QChatMessageRefer _$QChatMessageReferFromJson(Map<String, dynamic> json) =>
    QChatMessageRefer(
      time: json['time'] as int,
      msgIdServer: json['msgIdServer'] as int,
      fromAccount: json['fromAccount'] as String?,
      uuid: json['uuid'] as String?,
    );

Map<String, dynamic> _$QChatMessageReferToJson(QChatMessageRefer instance) =>
    <String, dynamic>{
      'fromAccount': instance.fromAccount,
      'time': instance.time,
      'msgIdServer': instance.msgIdServer,
      'uuid': instance.uuid,
    };

QChatResendMessageParam _$QChatResendMessageParamFromJson(
        Map<String, dynamic> json) =>
    QChatResendMessageParam(
      QChatMessage.fromJson(json['message'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$QChatResendMessageParamToJson(
        QChatResendMessageParam instance) =>
    <String, dynamic>{
      'message': instance.message.toJson(),
    };

QChatDownloadAttachmentParam _$QChatDownloadAttachmentParamFromJson(
        Map<String, dynamic> json) =>
    QChatDownloadAttachmentParam(
      message: QChatMessage.fromJson(json['message'] as Map<String, dynamic>),
      thumb: json['thumb'] as bool,
    );

Map<String, dynamic> _$QChatDownloadAttachmentParamToJson(
        QChatDownloadAttachmentParam instance) =>
    <String, dynamic>{
      'message': instance.message.toJson(),
      'thumb': instance.thumb,
    };

QChatGetMessageHistoryParam _$QChatGetMessageHistoryParamFromJson(
        Map<String, dynamic> json) =>
    QChatGetMessageHistoryParam(
      serverId: json['serverId'] as int,
      channelId: json['channelId'] as int,
      limit: json['limit'] as int?,
      excludeMessageId: json['excludeMessageId'] as int?,
      fromTime: json['fromTime'] as int?,
      reverse: json['reverse'] as bool? ?? false,
      toTime: json['toTime'] as int?,
    );

Map<String, dynamic> _$QChatGetMessageHistoryParamToJson(
        QChatGetMessageHistoryParam instance) =>
    <String, dynamic>{
      'serverId': instance.serverId,
      'channelId': instance.channelId,
      'fromTime': instance.fromTime,
      'toTime': instance.toTime,
      'excludeMessageId': instance.excludeMessageId,
      'limit': instance.limit,
      'reverse': instance.reverse,
    };

QChatGetMessageHistoryResult _$QChatGetMessageHistoryResultFromJson(
        Map<String, dynamic> json) =>
    QChatGetMessageHistoryResult(
      _qChatMessageListFromJson(json['messages'] as List?),
    );

Map<String, dynamic> _$QChatGetMessageHistoryResultToJson(
        QChatGetMessageHistoryResult instance) =>
    <String, dynamic>{
      'messages': instance.messages?.map((e) => e.toJson()).toList(),
    };

QChatUpdateMessageParam _$QChatUpdateMessageParamFromJson(
        Map<String, dynamic> json) =>
    QChatUpdateMessageParam(
      channelId: json['channelId'] as int,
      updateParam: QChatUpdateParam.fromJson(
          json['updateParam'] as Map<String, dynamic>),
      serverId: json['serverId'] as int,
      time: json['time'] as int,
      msgIdServer: json['msgIdServer'] as int,
      extension: castPlatformMapToDartMap(json['extension'] as Map?),
      serverStatus: json['serverStatus'] as int?,
      antiSpamOption: json['antiSpamOption'] == null
          ? null
          : QChatMessageAntiSpamOption.fromJson(
              json['antiSpamOption'] as Map<String, dynamic>),
      subType: json['subType'] as int?,
      body: json['body'] as String?,
    );

Map<String, dynamic> _$QChatUpdateMessageParamToJson(
        QChatUpdateMessageParam instance) =>
    <String, dynamic>{
      'updateParam': instance.updateParam.toJson(),
      'serverId': instance.serverId,
      'channelId': instance.channelId,
      'time': instance.time,
      'msgIdServer': instance.msgIdServer,
      'body': instance.body,
      'extension': instance.extension,
      'serverStatus': instance.serverStatus,
      'antiSpamOption': instance.antiSpamOption?.toJson(),
      'subType': instance.subType,
    };

QChatUpdateParam _$QChatUpdateParamFromJson(Map<String, dynamic> json) =>
    QChatUpdateParam(
      postscript: json['postscript'] as String,
      pushContent: json['pushContent'] as String?,
      env: json['env'] as String?,
      pushPayload: castPlatformMapToDartMap(json['pushPayload'] as Map?),
      routeEnable: json['routeEnable'] as bool? ?? true,
      extension: json['extension'] as String?,
    );

Map<String, dynamic> _$QChatUpdateParamToJson(QChatUpdateParam instance) =>
    <String, dynamic>{
      'postscript': instance.postscript,
      'extension': instance.extension,
      'pushContent': instance.pushContent,
      'pushPayload': instance.pushPayload,
      'routeEnable': instance.routeEnable,
      'env': instance.env,
    };

QChatUpdateMessageResult _$QChatUpdateMessageResultFromJson(
        Map<String, dynamic> json) =>
    QChatUpdateMessageResult(
      qChatMessageFromJson(json['message'] as Map?),
    );

Map<String, dynamic> _$QChatUpdateMessageResultToJson(
        QChatUpdateMessageResult instance) =>
    <String, dynamic>{
      'message': instance.message?.toJson(),
    };

QChatRevokeMessageParam _$QChatRevokeMessageParamFromJson(
        Map<String, dynamic> json) =>
    QChatRevokeMessageParam(
      channelId: json['channelId'] as int,
      serverId: json['serverId'] as int,
      msgIdServer: json['msgIdServer'] as int,
      time: json['time'] as int,
      updateParam: QChatUpdateParam.fromJson(
          json['updateParam'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$QChatRevokeMessageParamToJson(
        QChatRevokeMessageParam instance) =>
    <String, dynamic>{
      'updateParam': instance.updateParam.toJson(),
      'serverId': instance.serverId,
      'channelId': instance.channelId,
      'time': instance.time,
      'msgIdServer': instance.msgIdServer,
    };

QChatRevokeMessageResult _$QChatRevokeMessageResultFromJson(
        Map<String, dynamic> json) =>
    QChatRevokeMessageResult(
      qChatMessageFromJson(json['message'] as Map?),
    );

Map<String, dynamic> _$QChatRevokeMessageResultToJson(
        QChatRevokeMessageResult instance) =>
    <String, dynamic>{
      'message': instance.message?.toJson(),
    };

QChatDeleteMessageResult _$QChatDeleteMessageResultFromJson(
        Map<String, dynamic> json) =>
    QChatDeleteMessageResult(
      qChatMessageFromJson(json['message'] as Map?),
    );

Map<String, dynamic> _$QChatDeleteMessageResultToJson(
        QChatDeleteMessageResult instance) =>
    <String, dynamic>{
      'message': instance.message?.toJson(),
    };

QChatDeleteMessageParam _$QChatDeleteMessageParamFromJson(
        Map<String, dynamic> json) =>
    QChatDeleteMessageParam(
      channelId: json['channelId'] as int,
      serverId: json['serverId'] as int,
      msgIdServer: json['msgIdServer'] as int,
      time: json['time'] as int,
      updateParam: QChatUpdateParam.fromJson(
          json['updateParam'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$QChatDeleteMessageParamToJson(
        QChatDeleteMessageParam instance) =>
    <String, dynamic>{
      'updateParam': instance.updateParam.toJson(),
      'serverId': instance.serverId,
      'channelId': instance.channelId,
      'time': instance.time,
      'msgIdServer': instance.msgIdServer,
    };

QChatMarkMessageReadParam _$QChatMarkMessageReadParamFromJson(
        Map<String, dynamic> json) =>
    QChatMarkMessageReadParam(
      serverId: json['serverId'] as int,
      channelId: json['channelId'] as int,
      ackTimestamp: json['ackTimestamp'] as int,
    );

Map<String, dynamic> _$QChatMarkMessageReadParamToJson(
        QChatMarkMessageReadParam instance) =>
    <String, dynamic>{
      'serverId': instance.serverId,
      'channelId': instance.channelId,
      'ackTimestamp': instance.ackTimestamp,
    };

QChatSendSystemNotificationParam _$QChatSendSystemNotificationParamFromJson(
        Map<String, dynamic> json) =>
    QChatSendSystemNotificationParam(
      serverId: json['serverId'] as int,
      channelId: json['channelId'] as int?,
      body: json['body'] as String?,
      extension: castPlatformMapToDartMap(json['extension'] as Map?),
      pushPayload: castPlatformMapToDartMap(json['pushPayload'] as Map?),
      env: json['env'] as String?,
      pushContent: json['pushContent'] as String?,
      toAccids: (json['toAccids'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      toType: $enumDecodeNullable(
          _$QChatSystemMessageToTypeEnumMap, json['toType']),
      status: json['status'] as int?,
      needBadge: json['needBadge'] as bool? ?? true,
      needPushNick: json['needPushNick'] as bool? ?? true,
      pushEnable: json['pushEnable'] as bool? ?? false,
      isRouteEnable: json['isRouteEnable'] as bool? ?? true,
      attach: json['attach'] as String?,
      persistEnable: json['persistEnable'] as bool? ?? false,
    );

Map<String, dynamic> _$QChatSendSystemNotificationParamToJson(
        QChatSendSystemNotificationParam instance) =>
    <String, dynamic>{
      'serverId': instance.serverId,
      'channelId': instance.channelId,
      'toAccids': instance.toAccids,
      'body': instance.body,
      'attach': instance.attach,
      'extension': instance.extension,
      'status': instance.status,
      'pushPayload': instance.pushPayload,
      'pushContent': instance.pushContent,
      'persistEnable': instance.persistEnable,
      'pushEnable': instance.pushEnable,
      'needBadge': instance.needBadge,
      'needPushNick': instance.needPushNick,
      'isRouteEnable': instance.isRouteEnable,
      'env': instance.env,
      'toType': _$QChatSystemMessageToTypeEnumMap[instance.toType],
    };

const _$QChatSystemMessageToTypeEnumMap = {
  QChatSystemMessageToType.server: 'server',
  QChatSystemMessageToType.channel: 'channel',
  QChatSystemMessageToType.server_accids: 'server_accids',
  QChatSystemMessageToType.channel_accids: 'channel_accids',
  QChatSystemMessageToType.accids: 'accids',
};

QChatSendSystemNotificationResult _$QChatSendSystemNotificationResultFromJson(
        Map<String, dynamic> json) =>
    QChatSendSystemNotificationResult(
      qChatSystemNotificationFromJson(json['sentCustomNotification'] as Map?),
    );

Map<String, dynamic> _$QChatSendSystemNotificationResultToJson(
        QChatSendSystemNotificationResult instance) =>
    <String, dynamic>{
      'sentCustomNotification': instance.sentCustomNotification?.toJson(),
    };

QChatSystemNotification _$QChatSystemNotificationFromJson(
        Map<String, dynamic> json) =>
    QChatSystemNotification(
      type: _systemNotificationTypeFromJson(json['type'] as String?),
      msgIdServer: json['msgIdServer'] as int?,
      extension: json['extension'] as String?,
      status: json['status'] as int?,
      persistEnable: json['persistEnable'] as bool?,
      attach: json['attach'] as String?,
      pushEnable: json['pushEnable'] as bool?,
      needPushNick: json['needPushNick'] as bool?,
      needBadge: json['needBadge'] as bool?,
      pushContent: json['pushContent'] as String?,
      env: json['env'] as String?,
      pushPayload: json['pushPayload'] as String?,
      body: json['body'] as String?,
      channelId: json['channelId'] as int?,
      serverId: json['serverId'] as int?,
      time: json['time'] as int?,
      routeEnable: json['routeEnable'] as bool?,
      fromAccount: json['fromAccount'] as String?,
      fromNick: json['fromNick'] as String?,
      fromDeviceId: json['fromDeviceId'] as String?,
      fromClientType: json['fromClientType'] as int?,
      callbackExtension: json['callbackExtension'] as String?,
      attachment: QChatSystemNotificationAttachment._fromJson(
          json['attachment'] as Map?,
          type: json['type'] as String?),
      updateTime: json['updateTime'] as int?,
      msgIdClient: json['msgIdClient'] as String?,
      toAccids: (json['toAccids'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$QChatSystemNotificationToJson(
        QChatSystemNotification instance) =>
    <String, dynamic>{
      'serverId': instance.serverId,
      'channelId': instance.channelId,
      'toAccids': instance.toAccids,
      'fromAccount': instance.fromAccount,
      'fromClientType': instance.fromClientType,
      'fromDeviceId': instance.fromDeviceId,
      'fromNick': instance.fromNick,
      'time': instance.time,
      'updateTime': instance.updateTime,
      'type': __systemNotificationTypeToJson(instance.type),
      'msgIdClient': instance.msgIdClient,
      'msgIdServer': instance.msgIdServer,
      'body': instance.body,
      'attach': instance.attach,
      'attachment':
          QChatSystemNotificationAttachment._toJson(instance.attachment),
      'extension': instance.extension,
      'status': instance.status,
      'pushPayload': instance.pushPayload,
      'pushContent': instance.pushContent,
      'persistEnable': instance.persistEnable,
      'pushEnable': instance.pushEnable,
      'needBadge': instance.needBadge,
      'needPushNick': instance.needPushNick,
      'routeEnable': instance.routeEnable,
      'env': instance.env,
      'callbackExtension': instance.callbackExtension,
    };

QChatResendSystemNotificationParam _$QChatResendSystemNotificationParamFromJson(
        Map<String, dynamic> json) =>
    QChatResendSystemNotificationParam(
      QChatSystemNotification.fromJson(
          json['systemNotification'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$QChatResendSystemNotificationParamToJson(
        QChatResendSystemNotificationParam instance) =>
    <String, dynamic>{
      'systemNotification': instance.systemNotification.toJson(),
    };

QChatUpdateSystemNotificationParam _$QChatUpdateSystemNotificationParamFromJson(
        Map<String, dynamic> json) =>
    QChatUpdateSystemNotificationParam(
      updateParam: QChatUpdateParam.fromJson(
          json['updateParam'] as Map<String, dynamic>),
      msgIdServer: json['msgIdServer'] as int,
      type: _systemNotificationTypeFromJson(json['type'] as String?),
      status: json['status'] as int?,
      extension: castPlatformMapToDartMap(json['extension'] as Map?),
      body: json['body'] as String?,
    );

Map<String, dynamic> _$QChatUpdateSystemNotificationParamToJson(
        QChatUpdateSystemNotificationParam instance) =>
    <String, dynamic>{
      'updateParam': instance.updateParam.toJson(),
      'msgIdServer': instance.msgIdServer,
      'type': __systemNotificationTypeToJson(instance.type),
      'body': instance.body,
      'extension': instance.extension,
      'status': instance.status,
    };

QChatUpdateSystemNotificationResult
    _$QChatUpdateSystemNotificationResultFromJson(Map<String, dynamic> json) =>
        QChatUpdateSystemNotificationResult(
          qChatSystemNotificationFromJson(
              json['sentCustomNotification'] as Map?),
        );

Map<String, dynamic> _$QChatUpdateSystemNotificationResultToJson(
        QChatUpdateSystemNotificationResult instance) =>
    <String, dynamic>{
      'sentCustomNotification': instance.sentCustomNotification?.toJson(),
    };

QChatMarkSystemNotificationsReadParam
    _$QChatMarkSystemNotificationsReadParamFromJson(
            Map<String, dynamic> json) =>
        QChatMarkSystemNotificationsReadParam(
          (json['pairs'] as List<dynamic>)
              .map((e) => ReadPair.fromJson(e as Map<String, dynamic>))
              .toList(),
        );

Map<String, dynamic> _$QChatMarkSystemNotificationsReadParamToJson(
        QChatMarkSystemNotificationsReadParam instance) =>
    <String, dynamic>{
      'pairs': instance.pairs.map((e) => e.toJson()).toList(),
    };

ReadPair _$ReadPairFromJson(Map<String, dynamic> json) => ReadPair(
      msgId: json['msgId'] as int,
      type: _systemNotificationTypeFromJson(json['type'] as String?),
    );

Map<String, dynamic> _$ReadPairToJson(ReadPair instance) => <String, dynamic>{
      'msgId': instance.msgId,
      'type': __systemNotificationTypeToJson(instance.type),
    };

QChatGetMessageHistoryByIdsParam _$QChatGetMessageHistoryByIdsParamFromJson(
        Map<String, dynamic> json) =>
    QChatGetMessageHistoryByIdsParam(
      serverId: json['serverId'] as int,
      channelId: json['channelId'] as int,
      messageReferList: (json['messageReferList'] as List<dynamic>)
          .map((e) => QChatMessageRefer.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$QChatGetMessageHistoryByIdsParamToJson(
        QChatGetMessageHistoryByIdsParam instance) =>
    <String, dynamic>{
      'serverId': instance.serverId,
      'channelId': instance.channelId,
      'messageReferList':
          instance.messageReferList.map((e) => e.toJson()).toList(),
    };

QChatAddServerRoleMembersAttachment
    _$QChatAddServerRoleMembersAttachmentFromJson(Map<String, dynamic> json) =>
        QChatAddServerRoleMembersAttachment(
          addAccids: (json['addAccids'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList(),
          roleId: json['roleId'] as int?,
          serverId: json['serverId'] as int?,
        );

Map<String, dynamic> _$QChatAddServerRoleMembersAttachmentToJson(
        QChatAddServerRoleMembersAttachment instance) =>
    <String, dynamic>{
      'roleId': instance.roleId,
      'serverId': instance.serverId,
      'addAccids': instance.addAccids,
    };

QChatApplyJoinServerMemberAcceptAttachment
    _$QChatApplyJoinServerMemberAcceptAttachmentFromJson(
            Map<String, dynamic> json) =>
        QChatApplyJoinServerMemberAcceptAttachment(
          applyAccid: json['applyAccid'] as String?,
          requestId: json['requestId'] as int?,
          server: serverFromJsonNullable(json['server'] as Map?),
        );

Map<String, dynamic> _$QChatApplyJoinServerMemberAcceptAttachmentToJson(
        QChatApplyJoinServerMemberAcceptAttachment instance) =>
    <String, dynamic>{
      'server': instance.server?.toJson(),
      'applyAccid': instance.applyAccid,
      'requestId': instance.requestId,
    };

QChatApplyJoinServerMemberAttachment
    _$QChatApplyJoinServerMemberAttachmentFromJson(Map<String, dynamic> json) =>
        QChatApplyJoinServerMemberAttachment(
          requestId: json['requestId'] as int?,
        );

Map<String, dynamic> _$QChatApplyJoinServerMemberAttachmentToJson(
        QChatApplyJoinServerMemberAttachment instance) =>
    <String, dynamic>{
      'requestId': instance.requestId,
    };

QChatApplyJoinServerMemberDoneAttachment
    _$QChatApplyJoinServerMemberDoneAttachmentFromJson(
            Map<String, dynamic> json) =>
        QChatApplyJoinServerMemberDoneAttachment(
          requestId: json['requestId'] as int?,
          server: serverFromJsonNullable(json['server'] as Map?),
        );

Map<String, dynamic> _$QChatApplyJoinServerMemberDoneAttachmentToJson(
        QChatApplyJoinServerMemberDoneAttachment instance) =>
    <String, dynamic>{
      'server': instance.server?.toJson(),
      'requestId': instance.requestId,
    };

QChatCreateChannelCategoryAttachment
    _$QChatCreateChannelCategoryAttachmentFromJson(Map<String, dynamic> json) =>
        QChatCreateChannelCategoryAttachment(
          channelCategory: _qChatChannelCategoryFromJsonNullable(
              json['channelCategory'] as Map?),
        );

Map<String, dynamic> _$QChatCreateChannelCategoryAttachmentToJson(
        QChatCreateChannelCategoryAttachment instance) =>
    <String, dynamic>{
      'channelCategory': instance.channelCategory?.toJson(),
    };

QChatChannelCategory _$QChatChannelCategoryFromJson(
        Map<String, dynamic> json) =>
    QChatChannelCategory(
      serverId: json['serverId'] as int?,
      updateTime: json['updateTime'] as int?,
      createTime: json['createTime'] as int?,
      name: json['name'] as String?,
      viewMode:
          $enumDecodeNullable(_$QChatChannelModeEnumMap, json['viewMode']),
      custom: json['custom'] as String?,
      valid: json['valid'] as bool?,
      owner: json['owner'] as String?,
      categoryId: json['categoryId'] as int?,
      channelNumber: json['channelNumber'] as int?,
    );

Map<String, dynamic> _$QChatChannelCategoryToJson(
        QChatChannelCategory instance) =>
    <String, dynamic>{
      'categoryId': instance.categoryId,
      'serverId': instance.serverId,
      'name': instance.name,
      'custom': instance.custom,
      'owner': instance.owner,
      'viewMode': _$QChatChannelModeEnumMap[instance.viewMode],
      'valid': instance.valid,
      'createTime': instance.createTime,
      'updateTime': instance.updateTime,
      'channelNumber': instance.channelNumber,
    };

const _$QChatChannelModeEnumMap = {
  QChatChannelMode.public: 'public',
  QChatChannelMode.private: 'private',
};

QChatCreateChannelNotificationAttachment
    _$QChatCreateChannelNotificationAttachmentFromJson(
            Map<String, dynamic> json) =>
        QChatCreateChannelNotificationAttachment(
          qChatChannelFromJson(json['channel'] as Map?),
        );

Map<String, dynamic> _$QChatCreateChannelNotificationAttachmentToJson(
        QChatCreateChannelNotificationAttachment instance) =>
    <String, dynamic>{
      'channel': instance.channel?.toJson(),
    };

QChatCreateServerAttachment _$QChatCreateServerAttachmentFromJson(
        Map<String, dynamic> json) =>
    QChatCreateServerAttachment(
      serverFromJsonNullable(json['server'] as Map?),
    );

Map<String, dynamic> _$QChatCreateServerAttachmentToJson(
        QChatCreateServerAttachment instance) =>
    <String, dynamic>{
      'server': instance.server?.toJson(),
    };

QChatDeleteChannelCategoryAttachment
    _$QChatDeleteChannelCategoryAttachmentFromJson(Map<String, dynamic> json) =>
        QChatDeleteChannelCategoryAttachment(
          json['channelCategoryId'] as int?,
        );

Map<String, dynamic> _$QChatDeleteChannelCategoryAttachmentToJson(
        QChatDeleteChannelCategoryAttachment instance) =>
    <String, dynamic>{
      'channelCategoryId': instance.channelCategoryId,
    };

QChatDeleteServerRoleMembersAttachment
    _$QChatDeleteServerRoleMembersAttachmentFromJson(
            Map<String, dynamic> json) =>
        QChatDeleteServerRoleMembersAttachment(
          serverId: json['serverId'] as int?,
          deleteAccids: (json['deleteAccids'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList(),
          roleId: json['roleId'] as int?,
        );

Map<String, dynamic> _$QChatDeleteServerRoleMembersAttachmentToJson(
        QChatDeleteServerRoleMembersAttachment instance) =>
    <String, dynamic>{
      'roleId': instance.roleId,
      'serverId': instance.serverId,
      'deleteAccids': instance.deleteAccids,
    };

QChatInviteServerMemberAcceptAttachment
    _$QChatInviteServerMemberAcceptAttachmentFromJson(
            Map<String, dynamic> json) =>
        QChatInviteServerMemberAcceptAttachment(
          server: serverFromJsonNullable(json['server'] as Map?),
          requestId: json['requestId'] as int?,
          inviteAccid: json['inviteAccid'] as String?,
        );

Map<String, dynamic> _$QChatInviteServerMemberAcceptAttachmentToJson(
        QChatInviteServerMemberAcceptAttachment instance) =>
    <String, dynamic>{
      'server': instance.server?.toJson(),
      'inviteAccid': instance.inviteAccid,
      'requestId': instance.requestId,
    };

QChatInviteServerMemberAttachment _$QChatInviteServerMemberAttachmentFromJson(
        Map<String, dynamic> json) =>
    QChatInviteServerMemberAttachment(
      json['requestId'] as int?,
    );

Map<String, dynamic> _$QChatInviteServerMemberAttachmentToJson(
        QChatInviteServerMemberAttachment instance) =>
    <String, dynamic>{
      'requestId': instance.requestId,
    };

QChatInviteServerMembersDoneAttachment
    _$QChatInviteServerMembersDoneAttachmentFromJson(
            Map<String, dynamic> json) =>
        QChatInviteServerMembersDoneAttachment(
          requestId: json['requestId'] as int?,
          server: serverFromJsonNullable(json['server'] as Map?),
          invitedAccids: (json['invitedAccids'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList(),
        );

Map<String, dynamic> _$QChatInviteServerMembersDoneAttachmentToJson(
        QChatInviteServerMembersDoneAttachment instance) =>
    <String, dynamic>{
      'server': instance.server?.toJson(),
      'invitedAccids': instance.invitedAccids,
      'requestId': instance.requestId,
    };

QChatJoinServerByInviteCodeAttachment
    _$QChatJoinServerByInviteCodeAttachmentFromJson(
            Map<String, dynamic> json) =>
        QChatJoinServerByInviteCodeAttachment(
          server: serverFromJsonNullable(json['server'] as Map?),
          requestId: json['requestId'] as int?,
          inviteCode: json['inviteCode'] as String?,
        );

Map<String, dynamic> _$QChatJoinServerByInviteCodeAttachmentToJson(
        QChatJoinServerByInviteCodeAttachment instance) =>
    <String, dynamic>{
      'server': instance.server?.toJson(),
      'requestId': instance.requestId,
      'inviteCode': instance.inviteCode,
    };

QChatKickServerMembersDoneAttachment
    _$QChatKickServerMembersDoneAttachmentFromJson(Map<String, dynamic> json) =>
        QChatKickServerMembersDoneAttachment(
          server: serverFromJsonNullable(json['server'] as Map?),
          kickedAccids: (json['kickedAccids'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList(),
        );

Map<String, dynamic> _$QChatKickServerMembersDoneAttachmentToJson(
        QChatKickServerMembersDoneAttachment instance) =>
    <String, dynamic>{
      'server': instance.server?.toJson(),
      'kickedAccids': instance.kickedAccids,
    };

QChatLeaveServerAttachment _$QChatLeaveServerAttachmentFromJson(
        Map<String, dynamic> json) =>
    QChatLeaveServerAttachment(
      serverFromJsonNullable(json['server'] as Map?),
    );

Map<String, dynamic> _$QChatLeaveServerAttachmentToJson(
        QChatLeaveServerAttachment instance) =>
    <String, dynamic>{
      'server': instance.server?.toJson(),
    };

QChatQuickCommentAttachment _$QChatQuickCommentAttachmentFromJson(
        Map<String, dynamic> json) =>
    QChatQuickCommentAttachment(
      _qChatQuickCommentFromJson(json['quickComment'] as Map?),
    );

Map<String, dynamic> _$QChatQuickCommentAttachmentToJson(
        QChatQuickCommentAttachment instance) =>
    <String, dynamic>{
      'quickComment': instance.quickComment?.toJson(),
    };

QChatQuickComment _$QChatQuickCommentFromJson(Map<String, dynamic> json) =>
    QChatQuickComment(
      serverId: json['serverId'] as int?,
      channelId: json['channelId'] as int?,
      msgIdServer: json['msgIdServer'] as int?,
      type: json['type'] as int?,
      operateType: $enumDecodeNullable(
          _$QChatQuickCommentOperateTypeEnumMap, json['operateType']),
      msgSenderAccid: json['msgSenderAccid'] as String?,
      msgTime: json['msgTime'] as int?,
    );

Map<String, dynamic> _$QChatQuickCommentToJson(QChatQuickComment instance) =>
    <String, dynamic>{
      'serverId': instance.serverId,
      'channelId': instance.channelId,
      'msgSenderAccid': instance.msgSenderAccid,
      'msgIdServer': instance.msgIdServer,
      'msgTime': instance.msgTime,
      'type': instance.type,
      'operateType':
          _$QChatQuickCommentOperateTypeEnumMap[instance.operateType],
    };

const _$QChatQuickCommentOperateTypeEnumMap = {
  QChatQuickCommentOperateType.add: 'add',
  QChatQuickCommentOperateType.remove: 'remove',
};

QChatRejectApplyServerMemberAttachment
    _$QChatRejectApplyServerMemberAttachmentFromJson(
            Map<String, dynamic> json) =>
        QChatRejectApplyServerMemberAttachment(
          json['requestId'] as int?,
        );

Map<String, dynamic> _$QChatRejectApplyServerMemberAttachmentToJson(
        QChatRejectApplyServerMemberAttachment instance) =>
    <String, dynamic>{
      'requestId': instance.requestId,
    };

QChatRejectInviteServerMemberAttachment
    _$QChatRejectInviteServerMemberAttachmentFromJson(
            Map<String, dynamic> json) =>
        QChatRejectInviteServerMemberAttachment(
          json['requestId'] as int?,
        );

Map<String, dynamic> _$QChatRejectInviteServerMemberAttachmentToJson(
        QChatRejectInviteServerMemberAttachment instance) =>
    <String, dynamic>{
      'requestId': instance.requestId,
    };

QChatServerEnterLeaveAttachment _$QChatServerEnterLeaveAttachmentFromJson(
        Map<String, dynamic> json) =>
    QChatServerEnterLeaveAttachment(
      $enumDecodeNullable(_$QChatInOutTypeEnumMap, json['inOutType']),
    );

Map<String, dynamic> _$QChatServerEnterLeaveAttachmentToJson(
        QChatServerEnterLeaveAttachment instance) =>
    <String, dynamic>{
      'inOutType': _$QChatInOutTypeEnumMap[instance.inOutType],
    };

const _$QChatInOutTypeEnumMap = {
  QChatInOutType.inner: 'inner',
  QChatInOutType.out: 'out',
};

QChatUpdateChannelBlackWhiteMemberAttachment
    _$QChatUpdateChannelBlackWhiteMemberAttachmentFromJson(
            Map<String, dynamic> json) =>
        QChatUpdateChannelBlackWhiteMemberAttachment(
          channelId: json['channelId'] as int?,
          serverId: json['serverId'] as int?,
          channelBlackWhiteOperateType: $enumDecodeNullable(
              _$QChatChannelBlackWhiteOperateTypeEnumMap,
              json['channelBlackWhiteOperateType']),
          channelBlackWhiteToAccids:
              (json['channelBlackWhiteToAccids'] as List<dynamic>?)
                  ?.map((e) => e as String)
                  .toList(),
          channelBlackWhiteType: $enumDecodeNullable(
              _$QChatChannelBlackWhiteTypeEnumMap,
              json['channelBlackWhiteType']),
        );

Map<String, dynamic> _$QChatUpdateChannelBlackWhiteMemberAttachmentToJson(
        QChatUpdateChannelBlackWhiteMemberAttachment instance) =>
    <String, dynamic>{
      'serverId': instance.serverId,
      'channelId': instance.channelId,
      'channelBlackWhiteType':
          _$QChatChannelBlackWhiteTypeEnumMap[instance.channelBlackWhiteType],
      'channelBlackWhiteOperateType':
          _$QChatChannelBlackWhiteOperateTypeEnumMap[
              instance.channelBlackWhiteOperateType],
      'channelBlackWhiteToAccids': instance.channelBlackWhiteToAccids,
    };

const _$QChatChannelBlackWhiteOperateTypeEnumMap = {
  QChatChannelBlackWhiteOperateType.add: 'add',
  QChatChannelBlackWhiteOperateType.remove: 'remove',
};

const _$QChatChannelBlackWhiteTypeEnumMap = {
  QChatChannelBlackWhiteType.white: 'white',
  QChatChannelBlackWhiteType.black: 'black',
};

QChatUpdateChannelBlackWhiteRoleAttachment
    _$QChatUpdateChannelBlackWhiteRoleAttachmentFromJson(
            Map<String, dynamic> json) =>
        QChatUpdateChannelBlackWhiteRoleAttachment(
          channelBlackWhiteOperateType: $enumDecodeNullable(
              _$QChatChannelBlackWhiteOperateTypeEnumMap,
              json['channelBlackWhiteOperateType']),
          serverId: json['serverId'] as int?,
          channelId: json['channelId'] as int?,
          channelBlackWhiteRoleId: json['channelBlackWhiteRoleId'] as int?,
          channelBlackWhiteType: $enumDecodeNullable(
              _$QChatChannelBlackWhiteTypeEnumMap,
              json['channelBlackWhiteType']),
        );

Map<String, dynamic> _$QChatUpdateChannelBlackWhiteRoleAttachmentToJson(
        QChatUpdateChannelBlackWhiteRoleAttachment instance) =>
    <String, dynamic>{
      'serverId': instance.serverId,
      'channelId': instance.channelId,
      'channelBlackWhiteType':
          _$QChatChannelBlackWhiteTypeEnumMap[instance.channelBlackWhiteType],
      'channelBlackWhiteOperateType':
          _$QChatChannelBlackWhiteOperateTypeEnumMap[
              instance.channelBlackWhiteOperateType],
      'channelBlackWhiteRoleId': instance.channelBlackWhiteRoleId,
    };

QChatUpdateChannelCategoryAttachment
    _$QChatUpdateChannelCategoryAttachmentFromJson(Map<String, dynamic> json) =>
        QChatUpdateChannelCategoryAttachment(
          _qChatChannelCategoryFromJsonNullable(
              json['channelCategory'] as Map?),
        );

Map<String, dynamic> _$QChatUpdateChannelCategoryAttachmentToJson(
        QChatUpdateChannelCategoryAttachment instance) =>
    <String, dynamic>{
      'channelCategory': instance.channelCategory?.toJson(),
    };

QChatUpdateChannelCategoryBlackWhiteMemberAttachment
    _$QChatUpdateChannelCategoryBlackWhiteMemberAttachmentFromJson(
            Map<String, dynamic> json) =>
        QChatUpdateChannelCategoryBlackWhiteMemberAttachment(
          serverId: json['serverId'] as int?,
          channelCategoryId: json['channelCategoryId'] as int?,
          toAccids: (json['toAccids'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList(),
          channelBlackWhiteOperateType: $enumDecodeNullable(
              _$QChatChannelBlackWhiteOperateTypeEnumMap,
              json['channelBlackWhiteOperateType']),
          channelBlackWhiteType: $enumDecodeNullable(
              _$QChatChannelBlackWhiteTypeEnumMap,
              json['channelBlackWhiteType']),
        );

Map<String, dynamic>
    _$QChatUpdateChannelCategoryBlackWhiteMemberAttachmentToJson(
            QChatUpdateChannelCategoryBlackWhiteMemberAttachment instance) =>
        <String, dynamic>{
          'serverId': instance.serverId,
          'channelCategoryId': instance.channelCategoryId,
          'channelBlackWhiteType': _$QChatChannelBlackWhiteTypeEnumMap[
              instance.channelBlackWhiteType],
          'channelBlackWhiteOperateType':
              _$QChatChannelBlackWhiteOperateTypeEnumMap[
                  instance.channelBlackWhiteOperateType],
          'toAccids': instance.toAccids,
        };

QChatUpdateChannelCategoryBlackWhiteRoleAttachment
    _$QChatUpdateChannelCategoryBlackWhiteRoleAttachmentFromJson(
            Map<String, dynamic> json) =>
        QChatUpdateChannelCategoryBlackWhiteRoleAttachment(
          serverId: json['serverId'] as int?,
          channelBlackWhiteOperateType: $enumDecodeNullable(
              _$QChatChannelBlackWhiteOperateTypeEnumMap,
              json['channelBlackWhiteOperateType']),
          channelCategoryId: json['channelCategoryId'] as int?,
          roleId: json['roleId'] as int?,
          channelBlackWhiteType: $enumDecodeNullable(
              _$QChatChannelBlackWhiteTypeEnumMap,
              json['channelBlackWhiteType']),
        );

Map<String, dynamic> _$QChatUpdateChannelCategoryBlackWhiteRoleAttachmentToJson(
        QChatUpdateChannelCategoryBlackWhiteRoleAttachment instance) =>
    <String, dynamic>{
      'serverId': instance.serverId,
      'channelCategoryId': instance.channelCategoryId,
      'channelBlackWhiteType':
          _$QChatChannelBlackWhiteTypeEnumMap[instance.channelBlackWhiteType],
      'channelBlackWhiteOperateType':
          _$QChatChannelBlackWhiteOperateTypeEnumMap[
              instance.channelBlackWhiteOperateType],
      'roleId': instance.roleId,
    };

QChatUpdateChannelNotificationAttachment
    _$QChatUpdateChannelNotificationAttachmentFromJson(
            Map<String, dynamic> json) =>
        QChatUpdateChannelNotificationAttachment(
          qChatChannelFromJson(json['channel'] as Map?),
        );

Map<String, dynamic> _$QChatUpdateChannelNotificationAttachmentToJson(
        QChatUpdateChannelNotificationAttachment instance) =>
    <String, dynamic>{
      'channel': instance.channel?.toJson(),
    };

QChatUpdateChannelRoleAuthsAttachment
    _$QChatUpdateChannelRoleAuthsAttachmentFromJson(
            Map<String, dynamic> json) =>
        QChatUpdateChannelRoleAuthsAttachment(
          roleId: json['roleId'] as int?,
          serverId: json['serverId'] as int?,
          channelId: json['channelId'] as int?,
          parentRoleId: json['parentRoleId'] as int?,
          updateAuths:
              resourceAuthsFromJsonNullable(json['updateAuths'] as Map?),
        );

Map<String, dynamic> _$QChatUpdateChannelRoleAuthsAttachmentToJson(
        QChatUpdateChannelRoleAuthsAttachment instance) =>
    <String, dynamic>{
      'roleId': instance.roleId,
      'serverId': instance.serverId,
      'channelId': instance.channelId,
      'parentRoleId': instance.parentRoleId,
      'updateAuths': instance.updateAuths?.map((k, e) => MapEntry(
          _$QChatRoleResourceEnumMap[k]!, _$QChatRoleOptionEnumMap[e]!)),
    };

const _$QChatRoleOptionEnumMap = {
  QChatRoleOption.allow: 'allow',
  QChatRoleOption.deny: 'deny',
  QChatRoleOption.inherit: 'inherit',
};

const _$QChatRoleResourceEnumMap = {
  QChatRoleResource.manageServer: 'manageServer',
  QChatRoleResource.manageChannel: 'manageChannel',
  QChatRoleResource.manageRole: 'manageRole',
  QChatRoleResource.sendMsg: 'sendMsg',
  QChatRoleResource.accountInfoSelf: 'accountInfoSelf',
  QChatRoleResource.inviteServer: 'inviteServer',
  QChatRoleResource.kickServer: 'kickServer',
  QChatRoleResource.accountInfoOther: 'accountInfoOther',
  QChatRoleResource.recallMsg: 'recallMsg',
  QChatRoleResource.deleteMsg: 'deleteMsg',
  QChatRoleResource.remindOther: 'remindOther',
  QChatRoleResource.remindEveryone: 'remindEveryone',
  QChatRoleResource.manageBlackWhiteList: 'manageBlackWhiteList',
  QChatRoleResource.banServerMember: 'banServerMember',
  QChatRoleResource.rtcChannelConnect: 'rtcChannelConnect',
  QChatRoleResource.rtcChannelDisconnectOther: 'rtcChannelDisconnectOther',
  QChatRoleResource.rtcChannelOpenMicrophone: 'rtcChannelOpenMicrophone',
  QChatRoleResource.rtcChannelOpenCamera: 'rtcChannelOpenCamera',
  QChatRoleResource.rtcChannelOpenCloseOtherMicrophone:
      'rtcChannelOpenCloseOtherMicrophone',
  QChatRoleResource.rtcChannelOpenCloseOtherCamera:
      'rtcChannelOpenCloseOtherCamera',
  QChatRoleResource.rtcChannelOpenCloseEveryoneMicrophone:
      'rtcChannelOpenCloseEveryoneMicrophone',
  QChatRoleResource.rtcChannelOpenCloseEveryoneCamera:
      'rtcChannelOpenCloseEveryoneCamera',
  QChatRoleResource.rtcChannelOpenScreenShare: 'rtcChannelOpenScreenShare',
  QChatRoleResource.rtcChannelCloseOtherScreenShare:
      'rtcChannelCloseOtherScreenShare',
  QChatRoleResource.serverApplyHandle: 'serverApplyHandle',
  QChatRoleResource.inviteApplyHistoryQuery: 'inviteApplyHistoryQuery',
  QChatRoleResource.mentionedRole: 'mentionedRole',
};

QChatUpdateChannelVisibilityAttachment
    _$QChatUpdateChannelVisibilityAttachmentFromJson(
            Map<String, dynamic> json) =>
        QChatUpdateChannelVisibilityAttachment(
          $enumDecodeNullable(_$QChatInOutTypeEnumMap, json['inOutType']),
        );

Map<String, dynamic> _$QChatUpdateChannelVisibilityAttachmentToJson(
        QChatUpdateChannelVisibilityAttachment instance) =>
    <String, dynamic>{
      'inOutType': _$QChatInOutTypeEnumMap[instance.inOutType],
    };

QChatUpdateMemberRoleAuthsAttachment
    _$QChatUpdateMemberRoleAuthsAttachmentFromJson(Map<String, dynamic> json) =>
        QChatUpdateMemberRoleAuthsAttachment(
          channelId: json['channelId'] as int?,
          serverId: json['serverId'] as int?,
          accid: json['accid'] as String?,
          updateAuths:
              resourceAuthsFromJsonNullable(json['updateAuths'] as Map?),
        );

Map<String, dynamic> _$QChatUpdateMemberRoleAuthsAttachmentToJson(
        QChatUpdateMemberRoleAuthsAttachment instance) =>
    <String, dynamic>{
      'accid': instance.accid,
      'serverId': instance.serverId,
      'channelId': instance.channelId,
      'updateAuths': instance.updateAuths?.map((k, e) => MapEntry(
          _$QChatRoleResourceEnumMap[k]!, _$QChatRoleOptionEnumMap[e]!)),
    };

QChatUpdatedMyMemberInfo _$QChatUpdatedMyMemberInfoFromJson(
        Map<String, dynamic> json) =>
    QChatUpdatedMyMemberInfo(
      serverId: json['serverId'] as int?,
      avatar: json['avatar'] as String?,
      nick: json['nick'] as String?,
      isAvatarChanged: json['isAvatarChanged'] as bool?,
      isNickChanged: json['isNickChanged'] as bool?,
    );

Map<String, dynamic> _$QChatUpdatedMyMemberInfoToJson(
        QChatUpdatedMyMemberInfo instance) =>
    <String, dynamic>{
      'serverId': instance.serverId,
      'nick': instance.nick,
      'isNickChanged': instance.isNickChanged,
      'avatar': instance.avatar,
      'isAvatarChanged': instance.isAvatarChanged,
    };

QChatMyMemberInfoUpdatedAttachment _$QChatMyMemberInfoUpdatedAttachmentFromJson(
        Map<String, dynamic> json) =>
    QChatMyMemberInfoUpdatedAttachment(
      updatedInfos:
          _qChatUpdatedMyMemberInfoFromJson(json['updatedInfos'] as List?),
    );

Map<String, dynamic> _$QChatMyMemberInfoUpdatedAttachmentToJson(
        QChatMyMemberInfoUpdatedAttachment instance) =>
    <String, dynamic>{
      'updatedInfos': instance.updatedInfos?.map((e) => e.toJson()).toList(),
    };

QChatUpdateServerAttachment _$QChatUpdateServerAttachmentFromJson(
        Map<String, dynamic> json) =>
    QChatUpdateServerAttachment(
      serverFromJsonNullable(json['server'] as Map?),
    );

Map<String, dynamic> _$QChatUpdateServerAttachmentToJson(
        QChatUpdateServerAttachment instance) =>
    <String, dynamic>{
      'server': instance.server?.toJson(),
    };

QChatUpdateServerMemberAttachment _$QChatUpdateServerMemberAttachmentFromJson(
        Map<String, dynamic> json) =>
    QChatUpdateServerMemberAttachment(
      memberFromJson(json['serverMember'] as Map?),
    );

Map<String, dynamic> _$QChatUpdateServerMemberAttachmentToJson(
        QChatUpdateServerMemberAttachment instance) =>
    <String, dynamic>{
      'serverMember': instance.serverMember?.toJson(),
    };

QChatUpdateServerRoleAuthsAttachment
    _$QChatUpdateServerRoleAuthsAttachmentFromJson(Map<String, dynamic> json) =>
        QChatUpdateServerRoleAuthsAttachment(
          serverId: json['serverId'] as int?,
          updateAuths:
              resourceAuthsFromJsonNullable(json['updateAuths'] as Map?),
          roleId: json['roleId'] as int?,
        );

Map<String, dynamic> _$QChatUpdateServerRoleAuthsAttachmentToJson(
        QChatUpdateServerRoleAuthsAttachment instance) =>
    <String, dynamic>{
      'roleId': instance.roleId,
      'serverId': instance.serverId,
      'updateAuths': instance.updateAuths?.map((k, e) => MapEntry(
          _$QChatRoleResourceEnumMap[k]!, _$QChatRoleOptionEnumMap[e]!)),
    };

QChatReplyMessageParam _$QChatReplyMessageParamFromJson(
        Map<String, dynamic> json) =>
    QChatReplyMessageParam(
      message: QChatSendMessageParam.fromJson(
          json['message'] as Map<String, dynamic>),
      replyMessage:
          QChatMessage.fromJson(json['replyMessage'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$QChatReplyMessageParamToJson(
        QChatReplyMessageParam instance) =>
    <String, dynamic>{
      'message': instance.message.toJson(),
      'replyMessage': instance.replyMessage.toJson(),
    };

QChatGetReferMessagesParam _$QChatGetReferMessagesParamFromJson(
        Map<String, dynamic> json) =>
    QChatGetReferMessagesParam(
      message: QChatMessage.fromJson(json['message'] as Map<String, dynamic>),
      referType: $enumDecode(_$QChatMessageReferTypeEnumMap, json['referType']),
    );

Map<String, dynamic> _$QChatGetReferMessagesParamToJson(
        QChatGetReferMessagesParam instance) =>
    <String, dynamic>{
      'message': instance.message.toJson(),
      'referType': _$QChatMessageReferTypeEnumMap[instance.referType]!,
    };

const _$QChatMessageReferTypeEnumMap = {
  QChatMessageReferType.replay: 'replay',
  QChatMessageReferType.thread: 'thread',
  QChatMessageReferType.all: 'all',
};

QChatGetReferMessagesResult _$QChatGetReferMessagesResultFromJson(
        Map<String, dynamic> json) =>
    QChatGetReferMessagesResult(
      replyMessage: qChatMessageFromJson(json['replyMessage'] as Map?),
      threadMessage: qChatMessageFromJson(json['threadMessage'] as Map?),
    );

Map<String, dynamic> _$QChatGetReferMessagesResultToJson(
        QChatGetReferMessagesResult instance) =>
    <String, dynamic>{
      'replyMessage': instance.replyMessage?.toJson(),
      'threadMessage': instance.threadMessage?.toJson(),
    };

QChatGetThreadMessagesParam _$QChatGetThreadMessagesParamFromJson(
        Map<String, dynamic> json) =>
    QChatGetThreadMessagesParam(
      message: QChatMessage.fromJson(json['message'] as Map<String, dynamic>),
      messageQueryOption: json['messageQueryOption'] == null
          ? null
          : QChatMessageQueryOption.fromJson(
              json['messageQueryOption'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$QChatGetThreadMessagesParamToJson(
        QChatGetThreadMessagesParam instance) =>
    <String, dynamic>{
      'message': instance.message.toJson(),
      'messageQueryOption': instance.messageQueryOption?.toJson(),
    };

QChatMessageQueryOption _$QChatMessageQueryOptionFromJson(
        Map<String, dynamic> json) =>
    QChatMessageQueryOption(
      toTime: json['toTime'] as int?,
      fromTime: json['fromTime'] as int?,
      reverse: json['reverse'] as bool? ?? false,
      excludeMessageId: json['excludeMessageId'] as int?,
      limit: json['limit'] as int?,
    );

Map<String, dynamic> _$QChatMessageQueryOptionToJson(
        QChatMessageQueryOption instance) =>
    <String, dynamic>{
      'fromTime': instance.fromTime,
      'toTime': instance.toTime,
      'excludeMessageId': instance.excludeMessageId,
      'limit': instance.limit,
      'reverse': instance.reverse,
    };

QChatGetThreadMessagesResult _$QChatGetThreadMessagesResultFromJson(
        Map<String, dynamic> json) =>
    QChatGetThreadMessagesResult(
      threadMessage: qChatMessageFromJson(json['threadMessage'] as Map?),
      messages: _qChatMessageListFromJson(json['messages'] as List?),
      threadInfo: _qChatMessageThreadInfoFromJson(json['threadInfo'] as Map?),
    );

Map<String, dynamic> _$QChatGetThreadMessagesResultToJson(
        QChatGetThreadMessagesResult instance) =>
    <String, dynamic>{
      'threadMessage': instance.threadMessage?.toJson(),
      'threadInfo': instance.threadInfo?.toJson(),
      'messages': instance.messages?.map((e) => e.toJson()).toList(),
    };

QChatMessageThreadInfo _$QChatMessageThreadInfoFromJson(
        Map<String, dynamic> json) =>
    QChatMessageThreadInfo(
      total: json['total'] as int?,
      lastMsgTime: json['lastMsgTime'] as int?,
    );

Map<String, dynamic> _$QChatMessageThreadInfoToJson(
        QChatMessageThreadInfo instance) =>
    <String, dynamic>{
      'total': instance.total,
      'lastMsgTime': instance.lastMsgTime,
    };

QChatGetMessageThreadInfosParam _$QChatGetMessageThreadInfosParamFromJson(
        Map<String, dynamic> json) =>
    QChatGetMessageThreadInfosParam(
      channelId: json['channelId'] as int,
      serverId: json['serverId'] as int,
      msgList: _qChatMessageListFromJson(json['msgList'] as List?),
    );

Map<String, dynamic> _$QChatGetMessageThreadInfosParamToJson(
        QChatGetMessageThreadInfosParam instance) =>
    <String, dynamic>{
      'serverId': instance.serverId,
      'channelId': instance.channelId,
      'msgList': instance.msgList?.map((e) => e.toJson()).toList(),
    };

QChatGetMessageThreadInfosResult _$QChatGetMessageThreadInfosResultFromJson(
        Map<String, dynamic> json) =>
    QChatGetMessageThreadInfosResult(
      messageThreadInfoMap: _qChatMessageThreadInfoStringMapFromJson(
          json['messageThreadInfoMap'] as Map?),
    );

Map<String, dynamic> _$QChatGetMessageThreadInfosResultToJson(
        QChatGetMessageThreadInfosResult instance) =>
    <String, dynamic>{
      'messageThreadInfoMap':
          instance.messageThreadInfoMap?.map((k, e) => MapEntry(k, e.toJson())),
    };

QChatQuickCommentParam _$QChatQuickCommentParamFromJson(
        Map<String, dynamic> json) =>
    QChatQuickCommentParam(
      QChatMessage.fromJson(json['commentMessage'] as Map<String, dynamic>),
      json['type'] as int,
    );

Map<String, dynamic> _$QChatQuickCommentParamToJson(
        QChatQuickCommentParam instance) =>
    <String, dynamic>{
      'commentMessage': instance.commentMessage.toJson(),
      'type': instance.type,
    };

QChatAddQuickCommentParam _$QChatAddQuickCommentParamFromJson(
        Map<String, dynamic> json) =>
    QChatAddQuickCommentParam(
      QChatMessage.fromJson(json['commentMessage'] as Map<String, dynamic>),
      json['type'] as int,
    );

Map<String, dynamic> _$QChatAddQuickCommentParamToJson(
        QChatAddQuickCommentParam instance) =>
    <String, dynamic>{
      'commentMessage': instance.commentMessage.toJson(),
      'type': instance.type,
    };

QChatRemoveQuickCommentParam _$QChatRemoveQuickCommentParamFromJson(
        Map<String, dynamic> json) =>
    QChatRemoveQuickCommentParam(
      QChatMessage.fromJson(json['commentMessage'] as Map<String, dynamic>),
      json['type'] as int,
    );

Map<String, dynamic> _$QChatRemoveQuickCommentParamToJson(
        QChatRemoveQuickCommentParam instance) =>
    <String, dynamic>{
      'commentMessage': instance.commentMessage.toJson(),
      'type': instance.type,
    };

QChatGetQuickCommentsParam _$QChatGetQuickCommentsParamFromJson(
        Map<String, dynamic> json) =>
    QChatGetQuickCommentsParam(
      serverId: json['serverId'] as int,
      channelId: json['channelId'] as int,
      msgList: _qChatMessageListFromJson(json['msgList'] as List?),
    );

Map<String, dynamic> _$QChatGetQuickCommentsParamToJson(
        QChatGetQuickCommentsParam instance) =>
    <String, dynamic>{
      'serverId': instance.serverId,
      'channelId': instance.channelId,
      'msgList': instance.msgList?.map((e) => e.toJson()).toList(),
    };

QChatGetQuickCommentsResult _$QChatGetQuickCommentsResultFromJson(
        Map<String, dynamic> json) =>
    QChatGetQuickCommentsResult(
      messageQuickCommentDetailMap:
          _qChatMessageQuickCommentDetailMapIntFromJson(
              json['messageQuickCommentDetailMap'] as Map?),
    );

Map<String, dynamic> _$QChatGetQuickCommentsResultToJson(
        QChatGetQuickCommentsResult instance) =>
    <String, dynamic>{
      'messageQuickCommentDetailMap': instance.messageQuickCommentDetailMap
          ?.map((k, e) => MapEntry(k.toString(), e.toJson())),
    };

QChatMessageQuickCommentDetail _$QChatMessageQuickCommentDetailFromJson(
        Map<String, dynamic> json) =>
    QChatMessageQuickCommentDetail(
      channelId: json['channelId'] as int?,
      serverId: json['serverId'] as int?,
      msgIdServer: json['msgIdServer'] as int?,
      details: _qChatQuickCommentDetailListFromJson(json['details'] as List?),
      lastUpdateTime: json['lastUpdateTime'] as int?,
      totalCount: json['totalCount'] as int?,
    );

Map<String, dynamic> _$QChatMessageQuickCommentDetailToJson(
        QChatMessageQuickCommentDetail instance) =>
    <String, dynamic>{
      'serverId': instance.serverId,
      'channelId': instance.channelId,
      'msgIdServer': instance.msgIdServer,
      'totalCount': instance.totalCount,
      'lastUpdateTime': instance.lastUpdateTime,
      'details': instance.details?.map((e) => e.toJson()).toList(),
    };

QChatQuickCommentDetail _$QChatQuickCommentDetailFromJson(
        Map<String, dynamic> json) =>
    QChatQuickCommentDetail(
      type: json['type'] as int?,
      count: json['count'] as int?,
      hasSelf: json['hasSelf'] as bool?,
      severalAccids: (json['severalAccids'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$QChatQuickCommentDetailToJson(
        QChatQuickCommentDetail instance) =>
    <String, dynamic>{
      'type': instance.type,
      'count': instance.count,
      'hasSelf': instance.hasSelf,
      'severalAccids': instance.severalAccids,
    };

QChatMessageCache _$QChatMessageCacheFromJson(Map<String, dynamic> json) =>
    QChatMessageCache(
      threadMessage: qChatMessageFromJson(json['threadMessage'] as Map?),
      message: qChatMessageFromJson(json['message'] as Map?),
      replyMessage: qChatMessageFromJson(json['replyMessage'] as Map?),
      messageQuickCommentDetail: _qChatMessageQuickCommentDetailFromJson(
          json['messageQuickCommentDetail'] as Map?),
    );

Map<String, dynamic> _$QChatMessageCacheToJson(QChatMessageCache instance) =>
    <String, dynamic>{
      'message': instance.message?.toJson(),
      'replyMessage': instance.replyMessage?.toJson(),
      'threadMessage': instance.threadMessage?.toJson(),
      'messageQuickCommentDetail': instance.messageQuickCommentDetail?.toJson(),
    };

QChatGetLastMessageOfChannelsParam _$QChatGetLastMessageOfChannelsParamFromJson(
        Map<String, dynamic> json) =>
    QChatGetLastMessageOfChannelsParam(
      serverId: json['serverId'] as int,
      channelIds:
          (json['channelIds'] as List<dynamic>).map((e) => e as int).toList(),
    );

Map<String, dynamic> _$QChatGetLastMessageOfChannelsParamToJson(
        QChatGetLastMessageOfChannelsParam instance) =>
    <String, dynamic>{
      'serverId': instance.serverId,
      'channelIds': instance.channelIds,
    };

QChatGetLastMessageOfChannelsResult
    _$QChatGetLastMessageOfChannelsResultFromJson(Map<String, dynamic> json) =>
        QChatGetLastMessageOfChannelsResult(
          channelMsgMap:
              _qChatMessageMapIntFromJson(json['channelMsgMap'] as Map?),
        );

Map<String, dynamic> _$QChatGetLastMessageOfChannelsResultToJson(
        QChatGetLastMessageOfChannelsResult instance) =>
    <String, dynamic>{
      'channelMsgMap': instance.channelMsgMap
          ?.map((k, e) => MapEntry(k.toString(), e.toJson())),
    };

QChatSearchMsgByPageParam _$QChatSearchMsgByPageParamFromJson(
        Map<String, dynamic> json) =>
    QChatSearchMsgByPageParam(
      serverId: json['serverId'] as int,
      msgTypes: (json['msgTypes'] as List<dynamic>)
          .map((e) => $enumDecode(_$NIMMessageTypeEnumMap, e))
          .toList(),
      channelId: json['channelId'] as int?,
      limit: json['limit'] as int?,
      fromTime: json['fromTime'] as int?,
      toTime: json['toTime'] as int?,
      sort: $enumDecodeNullable(
          _$QChatMessageSearchSortEnumEnumMap, json['sort']),
      fromAccount: json['fromAccount'] as String?,
      keyword: json['keyword'] as String?,
      cursor: json['cursor'] as String?,
      isIncludeSelf: json['isIncludeSelf'] as bool?,
      order: json['order'] as bool?,
      subTypes:
          (json['subTypes'] as List<dynamic>?)?.map((e) => e as int).toList(),
    );

Map<String, dynamic> _$QChatSearchMsgByPageParamToJson(
        QChatSearchMsgByPageParam instance) =>
    <String, dynamic>{
      'keyword': instance.keyword,
      'serverId': instance.serverId,
      'channelId': instance.channelId,
      'fromAccount': instance.fromAccount,
      'fromTime': instance.fromTime,
      'toTime': instance.toTime,
      'msgTypes':
          instance.msgTypes.map((e) => _$NIMMessageTypeEnumMap[e]!).toList(),
      'subTypes': instance.subTypes,
      'isIncludeSelf': instance.isIncludeSelf,
      'order': instance.order,
      'limit': instance.limit,
      'sort': _$QChatMessageSearchSortEnumEnumMap[instance.sort],
      'cursor': instance.cursor,
    };

const _$QChatMessageSearchSortEnumEnumMap = {
  QChatMessageSearchSortEnum.createTime: 'createTime',
};

QChatSearchMsgByPageResult _$QChatSearchMsgByPageResultFromJson(
        Map<String, dynamic> json) =>
    QChatSearchMsgByPageResult(
      json['hasMore'] as bool?,
      json['nextTimeTag'] as int?,
      json['cursor'] as String?,
      messages: _qChatMessageListFromJson(json['messages'] as List?),
    );

Map<String, dynamic> _$QChatSearchMsgByPageResultToJson(
        QChatSearchMsgByPageResult instance) =>
    <String, dynamic>{
      'hasMore': instance.hasMore,
      'nextTimeTag': instance.nextTimeTag,
      'cursor': instance.cursor,
      'messages': instance.messages?.map((e) => e.toJson()).toList(),
    };

QChatSendTypingEventParam _$QChatSendTypingEventParamFromJson(
        Map<String, dynamic> json) =>
    QChatSendTypingEventParam(
      serverId: json['serverId'] as int,
      channelId: json['channelId'] as int,
      extension: castPlatformMapToDartMap(json['extension'] as Map?),
    );

Map<String, dynamic> _$QChatSendTypingEventParamToJson(
        QChatSendTypingEventParam instance) =>
    <String, dynamic>{
      'serverId': instance.serverId,
      'channelId': instance.channelId,
      'extension': instance.extension,
    };

QChatTypingEvent _$QChatTypingEventFromJson(Map<String, dynamic> json) =>
    QChatTypingEvent(
      serverId: json['serverId'] as int?,
      channelId: json['channelId'] as int?,
      extension: castPlatformMapToDartMap(json['extension'] as Map?),
      time: json['time'] as int?,
      fromAccount: json['fromAccount'] as String?,
      fromNick: json['fromNick'] as String?,
    );

Map<String, dynamic> _$QChatTypingEventToJson(QChatTypingEvent instance) =>
    <String, dynamic>{
      'serverId': instance.serverId,
      'channelId': instance.channelId,
      'fromAccount': instance.fromAccount,
      'fromNick': instance.fromNick,
      'time': instance.time,
      'extension': instance.extension,
    };

QChatSendTypingEventResult _$QChatSendTypingEventResultFromJson(
        Map<String, dynamic> json) =>
    QChatSendTypingEventResult(
      typingEvent: qQChatTypingEventFromJson(json['typingEvent'] as Map?),
    );

Map<String, dynamic> _$QChatSendTypingEventResultToJson(
        QChatSendTypingEventResult instance) =>
    <String, dynamic>{
      'typingEvent': instance.typingEvent?.toJson(),
    };

QChatGetMentionedMeMessagesParam _$QChatGetMentionedMeMessagesParamFromJson(
        Map<String, dynamic> json) =>
    QChatGetMentionedMeMessagesParam(
      channelId: json['channelId'] as int,
      serverId: json['serverId'] as int,
      limit: json['limit'] as int?,
      timetag: json['timetag'] as int?,
    );

Map<String, dynamic> _$QChatGetMentionedMeMessagesParamToJson(
        QChatGetMentionedMeMessagesParam instance) =>
    <String, dynamic>{
      'serverId': instance.serverId,
      'channelId': instance.channelId,
      'timetag': instance.timetag,
      'limit': instance.limit,
    };

QChatGetMentionedMeMessagesResult _$QChatGetMentionedMeMessagesResultFromJson(
        Map<String, dynamic> json) =>
    QChatGetMentionedMeMessagesResult(
      json['hasMore'] as bool?,
      json['nextTimeTag'] as int?,
      json['cursor'] as String?,
      messages: _qChatMessageListFromJson(json['messages'] as List?),
    );

Map<String, dynamic> _$QChatGetMentionedMeMessagesResultToJson(
        QChatGetMentionedMeMessagesResult instance) =>
    <String, dynamic>{
      'hasMore': instance.hasMore,
      'nextTimeTag': instance.nextTimeTag,
      'cursor': instance.cursor,
      'messages': instance.messages?.map((e) => e.toJson()).toList(),
    };

QChatAreMentionedMeMessagesParam _$QChatAreMentionedMeMessagesParamFromJson(
        Map<String, dynamic> json) =>
    QChatAreMentionedMeMessagesParam(
      messages: _qChatMessageListNotEmptyFromJson(json['messages'] as List),
    );

Map<String, dynamic> _$QChatAreMentionedMeMessagesParamToJson(
        QChatAreMentionedMeMessagesParam instance) =>
    <String, dynamic>{
      'messages': instance.messages.map((e) => e.toJson()).toList(),
    };

QChatAreMentionedMeMessagesResult _$QChatAreMentionedMeMessagesResultFromJson(
        Map<String, dynamic> json) =>
    QChatAreMentionedMeMessagesResult(
      result: castMapToTypeOfBoolString(json['result'] as Map?),
    );

Map<String, dynamic> _$QChatAreMentionedMeMessagesResultToJson(
        QChatAreMentionedMeMessagesResult instance) =>
    <String, dynamic>{
      'result': instance.result,
    };
