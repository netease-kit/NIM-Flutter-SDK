// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nim_sdk_macos_options.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NIMMACOSSDKOptions _$NIMMACOSSDKOptionsFromJson(Map<String, dynamic> json) {
  return NIMMACOSSDKOptions(
    enableAppNap: json['enableAppNap'] as bool?,
    pushCertName: json['pushCertName'] as String?,
    pushToken: json['pushToken'] as String?,
    databaseEncryptKey: json['databaseEncryptKey'] as String?,
    enableClientAntispam: json['enableClientAntispam'] as bool?,
    useAssetServerConfig: json['useAssetServerConfig'] as bool?,
    enabledHttps: json['enabledHttps'] as bool?,
    needUpdateLbsBeforeRelogin: json['needUpdateLbsBeforeRelogin'] as bool?,
    shouldVchatMissMessageMarkUnread:
        json['shouldVchatMissMessageMarkUnread'] as bool?,
    maxAutoLoginRetryTimes: json['maxAutoLoginRetryTimes'] as int?,
    preloadImageNameTemplate: json['preloadImageNameTemplate'] as String?,
    preloadImageQuality: json['preloadImageQuality'] as int?,
    preloadImageResize: json['preloadImageResize'] as String?,
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
    autoLoginInfo: loginInfoFromMap(json['autoLoginInfo'] as Map?),
    nosSceneConfig: nosSceneConfigFromMap(json['nosSceneConfig'] as Map?),
  );
}

Map<String, dynamic> _$NIMMACOSSDKOptionsToJson(NIMMACOSSDKOptions instance) {
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
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('autoLoginInfo', loginInfoToMap(instance.autoLoginInfo));
  val['nosSceneConfig'] = instance.nosSceneConfig;
  val['databaseEncryptKey'] = instance.databaseEncryptKey;
  val['preloadImageQuality'] = instance.preloadImageQuality;
  val['preloadImageResize'] = instance.preloadImageResize;
  val['preloadImageNameTemplate'] = instance.preloadImageNameTemplate;
  val['maxAutoLoginRetryTimes'] = instance.maxAutoLoginRetryTimes;
  val['enabledHttps'] = instance.enabledHttps;
  val['shouldVchatMissMessageMarkUnread'] =
      instance.shouldVchatMissMessageMarkUnread;
  val['enableClientAntispam'] = instance.enableClientAntispam;
  val['needUpdateLbsBeforeRelogin'] = instance.needUpdateLbsBeforeRelogin;
  val['pushCertName'] = instance.pushCertName;
  val['pushToken'] = instance.pushToken;
  val['enableAppNap'] = instance.enableAppNap;
  val['useAssetServerConfig'] = instance.useAssetServerConfig;
  return val;
}
