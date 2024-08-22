// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NIMMessageAttachment _$NIMMessageAttachmentFromJson(
        Map<String, dynamic> json) =>
    NIMMessageAttachment(
      raw: json['raw'] as String?,
    );

Map<String, dynamic> _$NIMMessageAttachmentToJson(
        NIMMessageAttachment instance) =>
    <String, dynamic>{
      'raw': instance.raw,
    };

NIMMessageFileAttachment _$NIMMessageFileAttachmentFromJson(
        Map<String, dynamic> json) =>
    NIMMessageFileAttachment(
      path: json['path'] as String?,
      size: (json['size'] as num?)?.toInt(),
      md5: json['md5'] as String?,
      url: json['url'] as String?,
      ext: json['ext'] as String?,
      name: json['name'] as String?,
      sceneName: json['sceneName'] as String?,
      uploadState: $enumDecodeNullable(
          _$NIMMessageAttachmentUploadStateEnumMap, json['uploadState']),
    )..raw = json['raw'] as String?;

Map<String, dynamic> _$NIMMessageFileAttachmentToJson(
        NIMMessageFileAttachment instance) =>
    <String, dynamic>{
      'raw': instance.raw,
      'path': instance.path,
      'size': instance.size,
      'md5': instance.md5,
      'url': instance.url,
      'ext': instance.ext,
      'name': instance.name,
      'sceneName': instance.sceneName,
      'uploadState':
          _$NIMMessageAttachmentUploadStateEnumMap[instance.uploadState],
    };

const _$NIMMessageAttachmentUploadStateEnumMap = {
  NIMMessageAttachmentUploadState.unknown: 0,
  NIMMessageAttachmentUploadState.succeed: 1,
  NIMMessageAttachmentUploadState.failed: 2,
  NIMMessageAttachmentUploadState.uploading: 3,
};

NIMMessageImageAttachment _$NIMMessageImageAttachmentFromJson(
        Map<String, dynamic> json) =>
    NIMMessageImageAttachment(
      width: (json['width'] as num?)?.toInt(),
      height: (json['height'] as num?)?.toInt(),
    )
      ..raw = json['raw'] as String?
      ..path = json['path'] as String?
      ..size = (json['size'] as num?)?.toInt()
      ..md5 = json['md5'] as String?
      ..url = json['url'] as String?
      ..ext = json['ext'] as String?
      ..name = json['name'] as String?
      ..sceneName = json['sceneName'] as String?
      ..uploadState = $enumDecodeNullable(
          _$NIMMessageAttachmentUploadStateEnumMap, json['uploadState']);

Map<String, dynamic> _$NIMMessageImageAttachmentToJson(
        NIMMessageImageAttachment instance) =>
    <String, dynamic>{
      'raw': instance.raw,
      'path': instance.path,
      'size': instance.size,
      'md5': instance.md5,
      'url': instance.url,
      'ext': instance.ext,
      'name': instance.name,
      'sceneName': instance.sceneName,
      'uploadState':
          _$NIMMessageAttachmentUploadStateEnumMap[instance.uploadState],
      'width': instance.width,
      'height': instance.height,
    };

NIMMessageAudioAttachment _$NIMMessageAudioAttachmentFromJson(
        Map<String, dynamic> json) =>
    NIMMessageAudioAttachment(
      duration: (json['duration'] as num?)?.toInt(),
    )
      ..raw = json['raw'] as String?
      ..path = json['path'] as String?
      ..size = (json['size'] as num?)?.toInt()
      ..md5 = json['md5'] as String?
      ..url = json['url'] as String?
      ..ext = json['ext'] as String?
      ..name = json['name'] as String?
      ..sceneName = json['sceneName'] as String?
      ..uploadState = $enumDecodeNullable(
          _$NIMMessageAttachmentUploadStateEnumMap, json['uploadState']);

Map<String, dynamic> _$NIMMessageAudioAttachmentToJson(
        NIMMessageAudioAttachment instance) =>
    <String, dynamic>{
      'raw': instance.raw,
      'path': instance.path,
      'size': instance.size,
      'md5': instance.md5,
      'url': instance.url,
      'ext': instance.ext,
      'name': instance.name,
      'sceneName': instance.sceneName,
      'uploadState':
          _$NIMMessageAttachmentUploadStateEnumMap[instance.uploadState],
      'duration': instance.duration,
    };

NIMMessageVideoAttachment _$NIMMessageVideoAttachmentFromJson(
        Map<String, dynamic> json) =>
    NIMMessageVideoAttachment(
      duration: (json['duration'] as num?)?.toInt(),
      width: (json['width'] as num?)?.toInt(),
      height: (json['height'] as num?)?.toInt(),
    )
      ..raw = json['raw'] as String?
      ..path = json['path'] as String?
      ..size = (json['size'] as num?)?.toInt()
      ..md5 = json['md5'] as String?
      ..url = json['url'] as String?
      ..ext = json['ext'] as String?
      ..name = json['name'] as String?
      ..sceneName = json['sceneName'] as String?
      ..uploadState = $enumDecodeNullable(
          _$NIMMessageAttachmentUploadStateEnumMap, json['uploadState']);

Map<String, dynamic> _$NIMMessageVideoAttachmentToJson(
        NIMMessageVideoAttachment instance) =>
    <String, dynamic>{
      'raw': instance.raw,
      'path': instance.path,
      'size': instance.size,
      'md5': instance.md5,
      'url': instance.url,
      'ext': instance.ext,
      'name': instance.name,
      'sceneName': instance.sceneName,
      'uploadState':
          _$NIMMessageAttachmentUploadStateEnumMap[instance.uploadState],
      'duration': instance.duration,
      'width': instance.width,
      'height': instance.height,
    };

NIMMessageLocationAttachment _$NIMMessageLocationAttachmentFromJson(
        Map<String, dynamic> json) =>
    NIMMessageLocationAttachment(
      longitude: (json['longitude'] as num?)?.toDouble(),
      latitude: (json['latitude'] as num?)?.toDouble(),
      address: json['address'] as String?,
    )..raw = json['raw'] as String?;

Map<String, dynamic> _$NIMMessageLocationAttachmentToJson(
        NIMMessageLocationAttachment instance) =>
    <String, dynamic>{
      'raw': instance.raw,
      'longitude': instance.longitude,
      'latitude': instance.latitude,
      'address': instance.address,
    };

NIMMessageNotificationAttachment _$NIMMessageNotificationAttachmentFromJson(
        Map<String, dynamic> json) =>
    NIMMessageNotificationAttachment(
      type: $enumDecodeNullable(
          _$NIMMessageNotificationTypeEnumMap, json['type']),
      serverExtension: json['serverExtension'] as String?,
      targetIds: (json['targetIds'] as List<dynamic>?)
          ?.map((e) => e as String?)
          .toList(),
      chatBanned: json['chatBanned'] as bool?,
      updatedTeamInfo:
          _nimUpdatedTeamInfoFromJson(json['updatedTeamInfo'] as Map?),
    )..raw = json['raw'] as String?;

Map<String, dynamic> _$NIMMessageNotificationAttachmentToJson(
        NIMMessageNotificationAttachment instance) =>
    <String, dynamic>{
      'raw': instance.raw,
      'type': _$NIMMessageNotificationTypeEnumMap[instance.type],
      'serverExtension': instance.serverExtension,
      'targetIds': instance.targetIds,
      'chatBanned': instance.chatBanned,
      'updatedTeamInfo': instance.updatedTeamInfo?.toJson(),
    };

const _$NIMMessageNotificationTypeEnumMap = {
  NIMMessageNotificationType.teamInvite: 0,
  NIMMessageNotificationType.teamKick: 1,
  NIMMessageNotificationType.teamLeave: 2,
  NIMMessageNotificationType.teamUpdateTInfo: 3,
  NIMMessageNotificationType.teamDismiss: 4,
  NIMMessageNotificationType.teamApplyPass: 5,
  NIMMessageNotificationType.teamOwnerTransfer: 6,
  NIMMessageNotificationType.teamAddManager: 7,
  NIMMessageNotificationType.teamRemoveManager: 8,
  NIMMessageNotificationType.teamInviteAccept: 9,
  NIMMessageNotificationType.teamBannedTeamMember: 10,
  NIMMessageNotificationType.superTeamInvite: 401,
  NIMMessageNotificationType.superTeamKick: 402,
  NIMMessageNotificationType.superTeamLeave: 403,
  NIMMessageNotificationType.superTeamUpdateTinfo: 404,
  NIMMessageNotificationType.superTeamDismiss: 405,
  NIMMessageNotificationType.superTeamOwnerTransfer: 406,
  NIMMessageNotificationType.superTeamAddManager: 407,
  NIMMessageNotificationType.superTeamRemoveManager: 408,
  NIMMessageNotificationType.superTeamBannedTeamMember: 409,
  NIMMessageNotificationType.superTeamApplyPass: 410,
  NIMMessageNotificationType.superTeamInviteAccept: 411,
};

NIMMessageCallDuration _$NIMMessageCallDurationFromJson(
        Map<String, dynamic> json) =>
    NIMMessageCallDuration(
      accountId: json['accountId'] as String?,
      duration: (json['duration'] as num?)?.toInt(),
    );

Map<String, dynamic> _$NIMMessageCallDurationToJson(
        NIMMessageCallDuration instance) =>
    <String, dynamic>{
      'accountId': instance.accountId,
      'duration': instance.duration,
    };

NIMMessageCallAttachment _$NIMMessageCallAttachmentFromJson(
        Map<String, dynamic> json) =>
    NIMMessageCallAttachment(
      type: (json['type'] as num?)?.toInt(),
      channelId: json['channelId'] as String?,
      status: (json['status'] as num?)?.toInt(),
      durations:
          _nimMessageCallDurationListFromJson(json['durations'] as List?),
    )..raw = json['raw'] as String?;

Map<String, dynamic> _$NIMMessageCallAttachmentToJson(
        NIMMessageCallAttachment instance) =>
    <String, dynamic>{
      'raw': instance.raw,
      'type': instance.type,
      'channelId': instance.channelId,
      'status': instance.status,
      'durations': instance.durations?.map((e) => e?.toJson()).toList(),
    };

NIMMessageRefer _$NIMMessageReferFromJson(Map<String, dynamic> json) =>
    NIMMessageRefer(
      senderId: json['senderId'] as String?,
      receiverId: json['receiverId'] as String?,
      messageClientId: json['messageClientId'] as String?,
      messageServerId: json['messageServerId'] as String?,
      conversationType: $enumDecodeNullable(
          _$NIMConversationTypeEnumMap, json['conversationType']),
      conversationId: json['conversationId'] as String?,
      createTime: (json['createTime'] as num?)?.toInt(),
    );

Map<String, dynamic> _$NIMMessageReferToJson(NIMMessageRefer instance) =>
    <String, dynamic>{
      'senderId': instance.senderId,
      'receiverId': instance.receiverId,
      'messageClientId': instance.messageClientId,
      'messageServerId': instance.messageServerId,
      'conversationType':
          _$NIMConversationTypeEnumMap[instance.conversationType],
      'conversationId': instance.conversationId,
      'createTime': instance.createTime,
    };

const _$NIMConversationTypeEnumMap = {
  NIMConversationType.unknown: 0,
  NIMConversationType.p2p: 1,
  NIMConversationType.team: 2,
  NIMConversationType.superTeam: 3,
};

NIMMessage _$NIMMessageFromJson(Map<String, dynamic> json) => NIMMessage(
      isSelf: json['isSelf'] as bool?,
      attachmentUploadState: $enumDecodeNullable(
          _$NIMMessageAttachmentUploadStateEnumMap,
          json['attachmentUploadState'],
          unknownValue: NIMMessageAttachmentUploadState.unknown),
      sendingState: $enumDecodeNullable(
          _$NIMMessageSendingStateEnumMap, json['sendingState']),
      messageType:
          $enumDecodeNullable(_$NIMMessageTypeEnumMap, json['messageType']),
      subType: (json['subType'] as num?)?.toInt(),
      text: json['text'] as String?,
      attachment: _nimMessageAttachmentFromJson(json['attachment'] as Map?),
      serverExtension: json['serverExtension'] as String?,
      localExtension: json['localExtension'] as String?,
      callbackExtension: json['callbackExtension'] as String?,
      messageConfig: _nimMessageConfigFromJson(json['messageConfig'] as Map?),
      pushConfig: _nimMessagePushConfigFromJson(json['pushConfig'] as Map?),
      routeConfig: _nimMessageRouteConfigFromJson(json['routeConfig'] as Map?),
      antispamConfig:
          _nimMessageAntispamConfigFromJson(json['antispamConfig'] as Map?),
      robotConfig: _nimMessageRobotConfigFromJson(json['robotConfig'] as Map?),
      threadRoot: nimMessageReferFromJson(json['threadRoot'] as Map?),
      threadReply: nimMessageReferFromJson(json['threadReply'] as Map?),
      aiConfig: _nimMessageAIConfigFromJson(json['aiConfig'] as Map?),
      messageStatus: _nimMessageStatusFromJson(json['messageStatus'] as Map?),
    )
      ..senderId = json['senderId'] as String?
      ..receiverId = json['receiverId'] as String?
      ..messageClientId = json['messageClientId'] as String?
      ..messageServerId = json['messageServerId'] as String?
      ..conversationType = $enumDecodeNullable(
          _$NIMConversationTypeEnumMap, json['conversationType'])
      ..conversationId = json['conversationId'] as String?
      ..createTime = (json['createTime'] as num?)?.toInt();

Map<String, dynamic> _$NIMMessageToJson(NIMMessage instance) =>
    <String, dynamic>{
      'senderId': instance.senderId,
      'receiverId': instance.receiverId,
      'messageClientId': instance.messageClientId,
      'messageServerId': instance.messageServerId,
      'conversationType':
          _$NIMConversationTypeEnumMap[instance.conversationType],
      'conversationId': instance.conversationId,
      'createTime': instance.createTime,
      'isSelf': instance.isSelf,
      'attachmentUploadState': _$NIMMessageAttachmentUploadStateEnumMap[
          instance.attachmentUploadState],
      'sendingState': _$NIMMessageSendingStateEnumMap[instance.sendingState],
      'messageType': _$NIMMessageTypeEnumMap[instance.messageType],
      'subType': instance.subType,
      'text': instance.text,
      'attachment': instance.attachment?.toJson(),
      'serverExtension': instance.serverExtension,
      'localExtension': instance.localExtension,
      'callbackExtension': instance.callbackExtension,
      'messageConfig': instance.messageConfig?.toJson(),
      'pushConfig': instance.pushConfig?.toJson(),
      'routeConfig': instance.routeConfig?.toJson(),
      'antispamConfig': instance.antispamConfig?.toJson(),
      'robotConfig': instance.robotConfig?.toJson(),
      'threadRoot': instance.threadRoot?.toJson(),
      'threadReply': instance.threadReply?.toJson(),
      'aiConfig': instance.aiConfig?.toJson(),
      'messageStatus': instance.messageStatus?.toJson(),
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
};

NIMSendMessageProgress _$NIMSendMessageProgressFromJson(
        Map<String, dynamic> json) =>
    NIMSendMessageProgress(
      messageClientId: json['messageClientId'] as String?,
      progress: (json['progress'] as num?)?.toInt(),
    );

Map<String, dynamic> _$NIMSendMessageProgressToJson(
        NIMSendMessageProgress instance) =>
    <String, dynamic>{
      'messageClientId': instance.messageClientId,
      'progress': instance.progress,
    };

NIMMessagePushConfig _$NIMMessagePushConfigFromJson(
        Map<String, dynamic> json) =>
    NIMMessagePushConfig(
      pushEnabled: json['pushEnabled'] as bool?,
      pushNickEnabled: json['pushNickEnabled'] as bool?,
      pushContent: json['pushContent'] as String?,
      pushPayload: json['pushPayload'] as String?,
      forcePush: json['forcePush'] as bool?,
      forcePushContent: json['forcePushContent'] as String?,
      forcePushAccountIds: (json['forcePushAccountIds'] as List<dynamic>?)
          ?.map((e) => e as String?)
          .toList(),
    );

Map<String, dynamic> _$NIMMessagePushConfigToJson(
        NIMMessagePushConfig instance) =>
    <String, dynamic>{
      'pushEnabled': instance.pushEnabled,
      'pushNickEnabled': instance.pushNickEnabled,
      'pushContent': instance.pushContent,
      'pushPayload': instance.pushPayload,
      'forcePush': instance.forcePush,
      'forcePushContent': instance.forcePushContent,
      'forcePushAccountIds': instance.forcePushAccountIds,
    };

NIMMessageConfig _$NIMMessageConfigFromJson(Map<String, dynamic> json) =>
    NIMMessageConfig(
      readReceiptEnabled: json['readReceiptEnabled'] as bool?,
      lastMessageUpdateEnabled: json['lastMessageUpdateEnabled'] as bool?,
      historyEnabled: json['historyEnabled'] as bool?,
      roamingEnabled: json['roamingEnabled'] as bool?,
      onlineSyncEnabled: json['onlineSyncEnabled'] as bool?,
      offlineEnabled: json['offlineEnabled'] as bool?,
      unreadEnabled: json['unreadEnabled'] as bool?,
    );

Map<String, dynamic> _$NIMMessageConfigToJson(NIMMessageConfig instance) =>
    <String, dynamic>{
      'readReceiptEnabled': instance.readReceiptEnabled,
      'lastMessageUpdateEnabled': instance.lastMessageUpdateEnabled,
      'historyEnabled': instance.historyEnabled,
      'roamingEnabled': instance.roamingEnabled,
      'onlineSyncEnabled': instance.onlineSyncEnabled,
      'offlineEnabled': instance.offlineEnabled,
      'unreadEnabled': instance.unreadEnabled,
    };

NIMMessageRouteConfig _$NIMMessageRouteConfigFromJson(
        Map<String, dynamic> json) =>
    NIMMessageRouteConfig(
      routeEnabled: json['routeEnabled'] as bool?,
      routeEnvironment: json['routeEnvironment'] as String?,
    );

Map<String, dynamic> _$NIMMessageRouteConfigToJson(
        NIMMessageRouteConfig instance) =>
    <String, dynamic>{
      'routeEnabled': instance.routeEnabled,
      'routeEnvironment': instance.routeEnvironment,
    };

NIMMessageAntispamConfig _$NIMMessageAntispamConfigFromJson(
        Map<String, dynamic> json) =>
    NIMMessageAntispamConfig(
      antispamEnabled: json['antispamEnabled'] as bool?,
      antispamBusinessId: json['antispamBusinessId'] as String?,
      antispamCustomMessage: json['antispamCustomMessage'] as String?,
      antispamCheating: json['antispamCheating'] as String?,
      antispamExtension: json['antispamExtension'] as String?,
    );

Map<String, dynamic> _$NIMMessageAntispamConfigToJson(
        NIMMessageAntispamConfig instance) =>
    <String, dynamic>{
      'antispamEnabled': instance.antispamEnabled,
      'antispamBusinessId': instance.antispamBusinessId,
      'antispamCustomMessage': instance.antispamCustomMessage,
      'antispamCheating': instance.antispamCheating,
      'antispamExtension': instance.antispamExtension,
    };

NIMMessageRobotConfig _$NIMMessageRobotConfigFromJson(
        Map<String, dynamic> json) =>
    NIMMessageRobotConfig(
      accountId: json['accountId'] as String?,
      topic: json['topic'] as String?,
      function: json['function'] as String?,
      customContent: json['customContent'] as String?,
    );

Map<String, dynamic> _$NIMMessageRobotConfigToJson(
        NIMMessageRobotConfig instance) =>
    <String, dynamic>{
      'accountId': instance.accountId,
      'topic': instance.topic,
      'function': instance.function,
      'customContent': instance.customContent,
    };

NIMMessageAIConfig _$NIMMessageAIConfigFromJson(Map<String, dynamic> json) =>
    NIMMessageAIConfig(
      accountId: json['accountId'] as String?,
      aiStatus:
          $enumDecodeNullable(_$NIMMessageAIStatusEnumMap, json['aiStatus']),
    );

Map<String, dynamic> _$NIMMessageAIConfigToJson(NIMMessageAIConfig instance) =>
    <String, dynamic>{
      'accountId': instance.accountId,
      'aiStatus': _$NIMMessageAIStatusEnumMap[instance.aiStatus],
    };

const _$NIMMessageAIStatusEnumMap = {
  NIMMessageAIStatus.unknow: 0,
  NIMMessageAIStatus.at: 1,
  NIMMessageAIStatus.response: 2,
};

NIMMessageAIConfigParams _$NIMMessageAIConfigParamsFromJson(
        Map<String, dynamic> json) =>
    NIMMessageAIConfigParams(
      accountId: json['accountId'] as String?,
      content: _nimAIModelCallContentFromJson(json['content'] as Map?),
      messages: _aiModelCallMessageListFromJson(json['messages'] as List?),
      promptVariables: json['promptVariables'] as String?,
      modelConfigParams:
          _nimAIModelConfigParamsFromJson(json['modelConfigParams'] as Map?),
    );

Map<String, dynamic> _$NIMMessageAIConfigParamsToJson(
        NIMMessageAIConfigParams instance) =>
    <String, dynamic>{
      'accountId': instance.accountId,
      'content': instance.content?.toJson(),
      'messages': instance.messages?.map((e) => e?.toJson()).toList(),
      'promptVariables': instance.promptVariables,
      'modelConfigParams': instance.modelConfigParams?.toJson(),
    };

NIMMessageStatus _$NIMMessageStatusFromJson(Map<String, dynamic> json) =>
    NIMMessageStatus(
      errorCode: (json['errorCode'] as num?)?.toInt(),
      readReceiptSent: json['readReceiptSent'] as bool?,
    );

Map<String, dynamic> _$NIMMessageStatusToJson(NIMMessageStatus instance) =>
    <String, dynamic>{
      'errorCode': instance.errorCode,
      'readReceiptSent': instance.readReceiptSent,
    };

NIMSendMessageParams _$NIMSendMessageParamsFromJson(
        Map<String, dynamic> json) =>
    NIMSendMessageParams(
      messageConfig: _nimMessageConfigFromJson(json['messageConfig'] as Map?),
      routeConfig: _nimMessageRouteConfigFromJson(json['routeConfig'] as Map?),
      pushConfig: _nimMessagePushConfigFromJson(json['pushConfig'] as Map?),
      antispamConfig:
          _nimMessageAntispamConfigFromJson(json['antispamConfig'] as Map?),
      robotConfig: _nimMessageRobotConfigFromJson(json['robotConfig'] as Map?),
      aiConfig: _nimMessageAIConfigParamsFromJson(json['aiConfig'] as Map?),
      clientAntispamEnabled: json['clientAntispamEnabled'] as bool?,
      clientAntispamReplace: json['clientAntispamReplace'] as String?,
    );

Map<String, dynamic> _$NIMSendMessageParamsToJson(
        NIMSendMessageParams instance) =>
    <String, dynamic>{
      'messageConfig': instance.messageConfig?.toJson(),
      'routeConfig': instance.routeConfig?.toJson(),
      'pushConfig': instance.pushConfig?.toJson(),
      'antispamConfig': instance.antispamConfig?.toJson(),
      'robotConfig': instance.robotConfig?.toJson(),
      'aiConfig': instance.aiConfig?.toJson(),
      'clientAntispamEnabled': instance.clientAntispamEnabled,
      'clientAntispamReplace': instance.clientAntispamReplace,
    };

NIMSendMessageResult _$NIMSendMessageResultFromJson(
        Map<String, dynamic> json) =>
    NIMSendMessageResult(
      message: nimMessageFromJson(json['message'] as Map?),
      antispamResult: json['antispamResult'] as String?,
      clientAntispamResult: _nimClientAntispamResultFromJson(
          json['clientAntispamResult'] as Map?),
    );

Map<String, dynamic> _$NIMSendMessageResultToJson(
        NIMSendMessageResult instance) =>
    <String, dynamic>{
      'message': instance.message?.toJson(),
      'antispamResult': instance.antispamResult,
      'clientAntispamResult': instance.clientAntispamResult?.toJson(),
    };

NIMMessageListOption _$NIMMessageListOptionFromJson(
        Map<String, dynamic> json) =>
    NIMMessageListOption(
      conversationId: json['conversationId'] as String?,
      messageTypes: (json['messageTypes'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      beginTime: (json['beginTime'] as num?)?.toInt(),
      endTime: (json['endTime'] as num?)?.toInt(),
      limit: (json['limit'] as num?)?.toInt(),
      anchorMessage: nimMessageFromJson(json['anchorMessage'] as Map?),
      direction:
          $enumDecodeNullable(_$NIMQueryDirectionEnumMap, json['direction']),
      strictMode: json['strictMode'] as bool?,
    );

Map<String, dynamic> _$NIMMessageListOptionToJson(
        NIMMessageListOption instance) =>
    <String, dynamic>{
      'conversationId': instance.conversationId,
      'messageTypes': instance.messageTypes,
      'beginTime': instance.beginTime,
      'endTime': instance.endTime,
      'limit': instance.limit,
      'anchorMessage': instance.anchorMessage?.toJson(),
      'direction': _$NIMQueryDirectionEnumMap[instance.direction],
      'strictMode': instance.strictMode,
    };

const _$NIMQueryDirectionEnumMap = {
  NIMQueryDirection.desc: 0,
  NIMQueryDirection.asc: 1,
};

NIMClearHistoryMessageOption _$NIMClearHistoryMessageOptionFromJson(
        Map<String, dynamic> json) =>
    NIMClearHistoryMessageOption(
      conversationId: json['conversationId'] as String?,
      deleteRoam: json['deleteRoam'] as bool?,
      onlineSync: json['onlineSync'] as bool?,
      serverExtension: json['serverExtension'] as String?,
    );

Map<String, dynamic> _$NIMClearHistoryMessageOptionToJson(
        NIMClearHistoryMessageOption instance) =>
    <String, dynamic>{
      'conversationId': instance.conversationId,
      'deleteRoam': instance.deleteRoam,
      'onlineSync': instance.onlineSync,
      'serverExtension': instance.serverExtension,
    };

NIMClientAntispamResult _$NIMClientAntispamResultFromJson(
        Map<String, dynamic> json) =>
    NIMClientAntispamResult(
      operateType: $enumDecodeNullable(
          _$NIMClientAntispamOperateTypeEnumMap, json['operateType']),
      replacedText: json['replacedText'] as String?,
    );

Map<String, dynamic> _$NIMClientAntispamResultToJson(
        NIMClientAntispamResult instance) =>
    <String, dynamic>{
      'operateType':
          _$NIMClientAntispamOperateTypeEnumMap[instance.operateType],
      'replacedText': instance.replacedText,
    };

const _$NIMClientAntispamOperateTypeEnumMap = {
  NIMClientAntispamOperateType.none: 0,
  NIMClientAntispamOperateType.replace: 1,
  NIMClientAntispamOperateType.clientShield: 2,
  NIMClientAntispamOperateType.serverShield: 3,
};

NIMAIModelCallContent _$NIMAIModelCallContentFromJson(
        Map<String, dynamic> json) =>
    NIMAIModelCallContent(
      msg: json['msg'] as String?,
      type: (json['type'] as num).toInt(),
    );

Map<String, dynamic> _$NIMAIModelCallContentToJson(
        NIMAIModelCallContent instance) =>
    <String, dynamic>{
      'msg': instance.msg,
      'type': instance.type,
    };

NIMAIModelCallMessage _$NIMAIModelCallMessageFromJson(
        Map<String, dynamic> json) =>
    NIMAIModelCallMessage(
      role: $enumDecodeNullable(_$NIMAIModelRoleTypeEnumMap, json['role']),
      msg: json['msg'] as String?,
      type: (json['type'] as num).toInt(),
    );

Map<String, dynamic> _$NIMAIModelCallMessageToJson(
        NIMAIModelCallMessage instance) =>
    <String, dynamic>{
      'role': _$NIMAIModelRoleTypeEnumMap[instance.role],
      'msg': instance.msg,
      'type': instance.type,
    };

const _$NIMAIModelRoleTypeEnumMap = {
  NIMAIModelRoleType.system: 0,
  NIMAIModelRoleType.user: 1,
  NIMAIModelRoleType.assistant: 2,
};

NIMAIModelConfigParams _$NIMAIModelConfigParamsFromJson(
        Map<String, dynamic> json) =>
    NIMAIModelConfigParams(
      prompt: json['prompt'] as String?,
      maxTokens: (json['maxTokens'] as num?)?.toInt(),
      topP: (json['topP'] as num?)?.toDouble(),
      temperature: (json['temperature'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$NIMAIModelConfigParamsToJson(
        NIMAIModelConfigParams instance) =>
    <String, dynamic>{
      'prompt': instance.prompt,
      'maxTokens': instance.maxTokens,
      'topP': instance.topP,
      'temperature': instance.temperature,
    };

NIMProxyAIModelCallParams _$NIMProxyAIModelCallParamsFromJson(
        Map<String, dynamic> json) =>
    NIMProxyAIModelCallParams(
      accountId: json['accountId'] as String?,
      requestId: json['requestId'] as String?,
      content: _nimAIModelCallContentFromJson(json['content'] as Map?),
      messages: _aiModelCallMessageListFromJson(json['messages'] as List?),
      promptVariables: json['promptVariables'] as String?,
      modelConfigParams:
          _nimAIModelConfigParamsFromJson(json['modelConfigParams'] as Map?),
      antispamConfig:
          _nimProxyAICallAntispamConfigFromJson(json['antispamConfig'] as Map?),
    );

Map<String, dynamic> _$NIMProxyAIModelCallParamsToJson(
        NIMProxyAIModelCallParams instance) =>
    <String, dynamic>{
      'accountId': instance.accountId,
      'requestId': instance.requestId,
      'content': instance.content?.toJson(),
      'messages': instance.messages?.map((e) => e?.toJson()).toList(),
      'promptVariables': instance.promptVariables,
      'modelConfigParams': instance.modelConfigParams?.toJson(),
      'antispamConfig': instance.antispamConfig?.toJson(),
    };

NIMAIModelConfig _$NIMAIModelConfigFromJson(Map<String, dynamic> json) =>
    NIMAIModelConfig(
      model: json['model'] as String?,
      prompt: json['prompt'] as String?,
      promptKeys: json['promptKeys'] as List<dynamic>?,
      maxTokens: (json['maxTokens'] as num?)?.toInt(),
      topP: (json['topP'] as num?)?.toDouble(),
      temperature: (json['temperature'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$NIMAIModelConfigToJson(NIMAIModelConfig instance) =>
    <String, dynamic>{
      'model': instance.model,
      'prompt': instance.prompt,
      'promptKeys': instance.promptKeys,
      'maxTokens': instance.maxTokens,
      'topP': instance.topP,
      'temperature': instance.temperature,
    };

NIMProxyAICallAntispamConfig _$NIMProxyAICallAntispamConfigFromJson(
        Map<String, dynamic> json) =>
    NIMProxyAICallAntispamConfig(
      antispamEnabled: json['antispamEnabled'] as bool?,
      antispamBusinessId: json['antispamBusinessId'] as String?,
    );

Map<String, dynamic> _$NIMProxyAICallAntispamConfigToJson(
        NIMProxyAICallAntispamConfig instance) =>
    <String, dynamic>{
      'antispamEnabled': instance.antispamEnabled,
      'antispamBusinessId': instance.antispamBusinessId,
    };

NIMAIModelCallResult _$NIMAIModelCallResultFromJson(
        Map<String, dynamic> json) =>
    NIMAIModelCallResult(
      accountId: json['accountId'] as String?,
      requestId: json['requestId'] as String?,
      content: _nimAIModelCallContentFromJson(json['content'] as Map?),
      code: (json['code'] as num?)?.toInt(),
    );

Map<String, dynamic> _$NIMAIModelCallResultToJson(
        NIMAIModelCallResult instance) =>
    <String, dynamic>{
      'accountId': instance.accountId,
      'requestId': instance.requestId,
      'content': instance.content?.toJson(),
      'code': instance.code,
    };

NIMMessageDeletedNotification _$NIMMessageDeletedNotificationFromJson(
        Map<String, dynamic> json) =>
    NIMMessageDeletedNotification(
      messageRefer: nimMessageReferFromJson(json['messageRefer'] as Map?),
      deleteTime: (json['deleteTime'] as num?)?.toInt(),
      serverExtension: json['serverExtension'] as String?,
    );

Map<String, dynamic> _$NIMMessageDeletedNotificationToJson(
        NIMMessageDeletedNotification instance) =>
    <String, dynamic>{
      'messageRefer': instance.messageRefer?.toJson(),
      'deleteTime': instance.deleteTime,
      'serverExtension': instance.serverExtension,
    };

NIMMessageRevokeNotification _$NIMMessageRevokeNotificationFromJson(
        Map<String, dynamic> json) =>
    NIMMessageRevokeNotification(
      messageRefer: nimMessageReferFromJson(json['messageRefer'] as Map?),
      serverExtension: json['serverExtension'] as String?,
      revokeAccountId: json['revokeAccountId'] as String?,
      postscript: json['postscript'] as String?,
      revokeType: $enumDecodeNullable(
          _$NIMMessageRevokeTypeEnumMap, json['revokeType']),
      callbackExtension: json['callbackExtension'] as String?,
    );

Map<String, dynamic> _$NIMMessageRevokeNotificationToJson(
        NIMMessageRevokeNotification instance) =>
    <String, dynamic>{
      'messageRefer': instance.messageRefer?.toJson(),
      'serverExtension': instance.serverExtension,
      'revokeAccountId': instance.revokeAccountId,
      'postscript': instance.postscript,
      'revokeType': _$NIMMessageRevokeTypeEnumMap[instance.revokeType],
      'callbackExtension': instance.callbackExtension,
    };

const _$NIMMessageRevokeTypeEnumMap = {
  NIMMessageRevokeType.undefined: 0,
  NIMMessageRevokeType.p2pBothway: 1,
  NIMMessageRevokeType.teamBothway: 2,
  NIMMessageRevokeType.superTeamBothway: 3,
  NIMMessageRevokeType.p2pOneway: 4,
  NIMMessageRevokeType.teamOneway: 5,
};

NIMMessageRevokeParams _$NIMMessageRevokeParamsFromJson(
        Map<String, dynamic> json) =>
    NIMMessageRevokeParams(
      postscript: json['postscript'] as String?,
      serverExtension: json['serverExtension'] as String?,
      pushContent: json['pushContent'] as String?,
      pushPayload: json['pushPayload'] as String?,
      env: json['env'] as String?,
    );

Map<String, dynamic> _$NIMMessageRevokeParamsToJson(
        NIMMessageRevokeParams instance) =>
    <String, dynamic>{
      'postscript': instance.postscript,
      'serverExtension': instance.serverExtension,
      'pushContent': instance.pushContent,
      'pushPayload': instance.pushPayload,
      'env': instance.env,
    };

NIMMessageSearchParams _$NIMMessageSearchParamsFromJson(
        Map<String, dynamic> json) =>
    NIMMessageSearchParams(
      keyword: json['keyword'] as String?,
      beginTime: (json['beginTime'] as num?)?.toInt(),
      endTime: (json['endTime'] as num?)?.toInt(),
      conversationLimit: (json['conversationLimit'] as num?)?.toInt(),
      messageLimit: (json['messageLimit'] as num?)?.toInt(),
      sortOrder: $enumDecodeNullable(_$NIMSortOrderEnumMap, json['sortOrder']),
      p2pAccountIds: (json['p2pAccountIds'] as List<dynamic>?)
          ?.map((e) => e as String?)
          .toList(),
      teamIds: (json['teamIds'] as List<dynamic>?)
          ?.map((e) => e as String?)
          .toList(),
      senderAccountIds: (json['senderAccountIds'] as List<dynamic>?)
          ?.map((e) => e as String?)
          .toList(),
      messageTypes: (json['messageTypes'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      messageSubtypes: json['messageSubtypes'] as List<dynamic>?,
    );

Map<String, dynamic> _$NIMMessageSearchParamsToJson(
        NIMMessageSearchParams instance) =>
    <String, dynamic>{
      'keyword': instance.keyword,
      'beginTime': instance.beginTime,
      'endTime': instance.endTime,
      'conversationLimit': instance.conversationLimit,
      'messageLimit': instance.messageLimit,
      'sortOrder': _$NIMSortOrderEnumMap[instance.sortOrder],
      'p2pAccountIds': instance.p2pAccountIds,
      'teamIds': instance.teamIds,
      'senderAccountIds': instance.senderAccountIds,
      'messageTypes': instance.messageTypes,
      'messageSubtypes': instance.messageSubtypes,
    };

const _$NIMSortOrderEnumMap = {
  NIMSortOrder.sortOrderDesc: 0,
  NIMSortOrder.sortOrderAsc: 1,
};

NIMVoiceToTextParams _$NIMVoiceToTextParamsFromJson(
        Map<String, dynamic> json) =>
    NIMVoiceToTextParams(
      voicePath: json['voicePath'] as String?,
      voiceUrl: json['voiceUrl'] as String?,
      mimeType: json['mimeType'] as String?,
      sampleRate: json['sampleRate'] as String?,
      duration: (json['duration'] as num?)?.toInt(),
      sceneName: json['sceneName'] as String?,
    );

Map<String, dynamic> _$NIMVoiceToTextParamsToJson(
        NIMVoiceToTextParams instance) =>
    <String, dynamic>{
      'voicePath': instance.voicePath,
      'voiceUrl': instance.voiceUrl,
      'mimeType': instance.mimeType,
      'sampleRate': instance.sampleRate,
      'duration': instance.duration,
      'sceneName': instance.sceneName,
    };
