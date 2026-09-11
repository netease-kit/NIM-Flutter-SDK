// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nim_sdk_ios_options.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NIMIOSSDKOptions _$NIMIOSSDKOptionsFromJson(Map<String, dynamic> json) =>
    NIMIOSSDKOptions(
      apnsCername: json['apnsCername'] as String?,
      pkCername: json['pkCername'] as String?,
      maxUploadLogSize: (json['maxUploadLogSize'] as num?)?.toInt(),
      enableFetchAttachmentAutomaticallyAfterReceivingInChatroom:
          json['enableFetchAttachmentAutomaticallyAfterReceivingInChatroom']
              as bool?,
      enableFileProtectionNone: json['enableFileProtectionNone'] as bool?,
      enabledHttpsForInfo: json['enabledHttpsForInfo'] as bool?,
      enabledHttpsForMessage: json['enabledHttpsForMessage'] as bool?,
      maxAutoLoginRetryTimes: (json['maxAutoLoginRetryTimes'] as num?)?.toInt(),
      maximumLogDays: (json['maximumLogDays'] as num?)?.toInt(),
      disableReconnectInBackgroundState:
          json['disableReconnectInBackgroundState'] as bool?,
      disableBackgroundTask: json['disableBackgroundTask'] as bool?,
      enableTeamReceipt: json['enableTeamReceipt'] as bool?,
      enableFileQuickTransfer: json['enableFileQuickTransfer'] as bool?,
      enableAsyncLoadRecentSession:
          json['enableAsyncLoadRecentSession'] as bool?,
      linkQuickSwitch: json['linkQuickSwitch'] as bool?,
      enabledQChatMessageCache: json['enabledQChatMessageCache'] as bool?,
      enableServerV2FriendAddApplication:
          json['enableServerV2FriendAddApplication'] as bool? ?? false,
      enableServerV2TeamJoinActionInfo:
          json['enableServerV2TeamJoinActionInfo'] as bool? ?? false,
      enableV2CloudConversation:
          json['enableV2CloudConversation'] as bool? ?? false,
      autoUpdateApnsToken: json['autoUpdateApnsToken'] as bool? ?? true,
      appKey: json['appKey'] as String,
      sdkRootDir: json['sdkRootDir'] as String?,
      customClientType: (json['customClientType'] as num?)?.toInt(),
      shouldSyncStickTopSessionInfos:
          json['shouldSyncStickTopSessionInfos'] as bool?,
      enableReportLogAutomatically:
          json['enableReportLogAutomatically'] as bool?,
      loginCustomTag: json['loginCustomTag'] as String?,
      enableDatabaseBackup: json['enableDatabaseBackup'] as bool?,
      shouldSyncUnreadCount: json['shouldSyncUnreadCount'] as bool?,
      shouldConsiderRevokedMessageUnreadCount:
          json['shouldConsiderRevokedMessageUnreadCount'] as bool?,
      enableTeamMessageReadReceipt:
          json['enableTeamMessageReadReceipt'] as bool?,
      shouldTeamNotificationMessageMarkUnread:
          json['shouldTeamNotificationMessageMarkUnread'] as bool?,
      enableAnimatedImageThumbnail:
          json['enableAnimatedImageThumbnail'] as bool?,
      enablePreloadMessageAttachment:
          json['enablePreloadMessageAttachment'] as bool?,
      useAssetServerAddressConfig: json['useAssetServerAddressConfig'] as bool?,
      nosSceneConfig: nosSceneConfigFromMap(json['nosSceneConfig'] as Map?),
      serverConfig: serverConfigFromMap(json['serverConfig'] as Map?),
      enableFcs: json['enableFcs'] as bool? ?? true,
    )..disableTraceroute = json['disableTraceroute'] as bool?;

Map<String, dynamic> _$NIMIOSSDKOptionsToJson(NIMIOSSDKOptions instance) =>
    <String, dynamic>{
      'appKey': instance.appKey,
      'sdkRootDir': instance.sdkRootDir,
      'customClientType': instance.customClientType,
      'enableDatabaseBackup': instance.enableDatabaseBackup,
      'loginCustomTag': instance.loginCustomTag,
      'shouldSyncUnreadCount': instance.shouldSyncUnreadCount,
      'shouldConsiderRevokedMessageUnreadCount':
          instance.shouldConsiderRevokedMessageUnreadCount,
      'enableTeamMessageReadReceipt': instance.enableTeamMessageReadReceipt,
      'shouldTeamNotificationMessageMarkUnread':
          instance.shouldTeamNotificationMessageMarkUnread,
      'enableAnimatedImageThumbnail': instance.enableAnimatedImageThumbnail,
      'enablePreloadMessageAttachment': instance.enablePreloadMessageAttachment,
      'shouldSyncStickTopSessionInfos': instance.shouldSyncStickTopSessionInfos,
      'enableReportLogAutomatically': instance.enableReportLogAutomatically,
      'useAssetServerAddressConfig': instance.useAssetServerAddressConfig,
      'nosSceneConfig': instance.nosSceneConfig,
      'serverConfig': serverConfigToJson(instance.serverConfig),
      'enableFcs': instance.enableFcs,
      'apnsCername': instance.apnsCername,
      'pkCername': instance.pkCername,
      'disableTraceroute': instance.disableTraceroute,
      'maxUploadLogSize': instance.maxUploadLogSize,
      'enableFetchAttachmentAutomaticallyAfterReceivingInChatroom':
          instance.enableFetchAttachmentAutomaticallyAfterReceivingInChatroom,
      'enableFileProtectionNone': instance.enableFileProtectionNone,
      'enabledHttpsForInfo': instance.enabledHttpsForInfo,
      'enabledHttpsForMessage': instance.enabledHttpsForMessage,
      'maxAutoLoginRetryTimes': instance.maxAutoLoginRetryTimes,
      'maximumLogDays': instance.maximumLogDays,
      'disableReconnectInBackgroundState':
          instance.disableReconnectInBackgroundState,
      'disableBackgroundTask': instance.disableBackgroundTask,
      'enableTeamReceipt': instance.enableTeamReceipt,
      'enableFileQuickTransfer': instance.enableFileQuickTransfer,
      'enableAsyncLoadRecentSession': instance.enableAsyncLoadRecentSession,
      'linkQuickSwitch': instance.linkQuickSwitch,
      'enabledQChatMessageCache': instance.enabledQChatMessageCache,
      'enableServerV2FriendAddApplication':
          instance.enableServerV2FriendAddApplication,
      'enableServerV2TeamJoinActionInfo':
          instance.enableServerV2TeamJoinActionInfo,
      'enableV2CloudConversation': instance.enableV2CloudConversation,
      'autoUpdateApnsToken': instance.autoUpdateApnsToken,
    };
