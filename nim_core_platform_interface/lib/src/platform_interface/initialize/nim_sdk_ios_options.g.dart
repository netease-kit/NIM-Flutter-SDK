// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nim_sdk_ios_options.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NIMIOSSDKOptions _$NIMIOSSDKOptionsFromJson(Map<String, dynamic> json) {
  return NIMIOSSDKOptions(
    apnsCername: json['apnsCername'] as String?,
    pkCername: json['pkCername'] as String?,
    maxUploadLogSize: json['maxUploadLogSize'] as int?,
    enableFetchAttachmentAutomaticallyAfterReceivingInChatroom:
        json['enableFetchAttachmentAutomaticallyAfterReceivingInChatroom']
            as bool?,
    enableFileProtectionNone: json['enableFileProtectionNone'] as bool?,
    enabledHttpsForInfo: json['enabledHttpsForInfo'] as bool?,
    enabledHttpsForMessage: json['enabledHttpsForMessage'] as bool?,
    maxAutoLoginRetryTimes: json['maxAutoLoginRetryTimes'] as int?,
    maximumLogDays: json['maximumLogDays'] as int?,
    disableReconnectInBackgroundState:
        json['disableReconnectInBackgroundState'] as bool?,
    enableTeamReceipt: json['enableTeamReceipt'] as bool?,
    enableFileQuickTransfer: json['enableFileQuickTransfer'] as bool?,
    enableAsyncLoadRecentSession: json['enableAsyncLoadRecentSession'] as bool?,
    linkQuickSwitch: json['linkQuickSwitch'] as bool?,
    enabledQChatMessageCache: json['enabledQChatMessageCache'] as bool?,
    appKey: json['appKey'] as String,
    sdkRootDir: json['sdkRootDir'] as String?,
    customClientType: json['customClientType'] as int?,
    shouldSyncStickTopSessionInfos:
        json['shouldSyncStickTopSessionInfos'] as bool?,
    enableReportLogAutomatically: json['enableReportLogAutomatically'] as bool?,
    loginCustomTag: json['loginCustomTag'] as String?,
    enableDatabaseBackup: json['enableDatabaseBackup'] as bool?,
    shouldSyncUnreadCount: json['shouldSyncUnreadCount'] as bool?,
    shouldConsiderRevokedMessageUnreadCount:
        json['shouldConsiderRevokedMessageUnreadCount'] as bool?,
    enableTeamMessageReadReceipt: json['enableTeamMessageReadReceipt'] as bool?,
    shouldTeamNotificationMessageMarkUnread:
        json['shouldTeamNotificationMessageMarkUnread'] as bool?,
    enableAnimatedImageThumbnail: json['enableAnimatedImageThumbnail'] as bool?,
    enablePreloadMessageAttachment:
        json['enablePreloadMessageAttachment'] as bool?,
    useAssetServerAddressConfig: json['useAssetServerAddressConfig'] as bool?,
    autoLoginInfo: loginInfoFromMap(json['autoLoginInfo'] as Map?),
    nosSceneConfig: nosSceneConfigFromMap(json['nosSceneConfig'] as Map?),
    serverConfig: serverConfigFromMap(json['serverConfig'] as Map?),
    enableFcs: json['enableFcs'] as bool? ?? true,
  )..disableTraceroute = json['disableTraceroute'] as bool?;
}

Map<String, dynamic> _$NIMIOSSDKOptionsToJson(NIMIOSSDKOptions instance) {
  final val = <String, dynamic>{
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
    'enableFcs': instance.enableFcs,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('autoLoginInfo', loginInfoToMap(instance.autoLoginInfo));
  val['nosSceneConfig'] = instance.nosSceneConfig;
  val['serverConfig'] = serverConfigToJson(instance.serverConfig);
  val['apnsCername'] = instance.apnsCername;
  val['pkCername'] = instance.pkCername;
  val['disableTraceroute'] = instance.disableTraceroute;
  val['maxUploadLogSize'] = instance.maxUploadLogSize;
  val['enableFetchAttachmentAutomaticallyAfterReceivingInChatroom'] =
      instance.enableFetchAttachmentAutomaticallyAfterReceivingInChatroom;
  val['enableFileProtectionNone'] = instance.enableFileProtectionNone;
  val['enabledHttpsForInfo'] = instance.enabledHttpsForInfo;
  val['enabledHttpsForMessage'] = instance.enabledHttpsForMessage;
  val['maxAutoLoginRetryTimes'] = instance.maxAutoLoginRetryTimes;
  val['maximumLogDays'] = instance.maximumLogDays;
  val['disableReconnectInBackgroundState'] =
      instance.disableReconnectInBackgroundState;
  val['enableTeamReceipt'] = instance.enableTeamReceipt;
  val['enableFileQuickTransfer'] = instance.enableFileQuickTransfer;
  val['enableAsyncLoadRecentSession'] = instance.enableAsyncLoadRecentSession;
  val['linkQuickSwitch'] = instance.linkQuickSwitch;
  val['enabledQChatMessageCache'] = instance.enabledQChatMessageCache;
  return val;
}
