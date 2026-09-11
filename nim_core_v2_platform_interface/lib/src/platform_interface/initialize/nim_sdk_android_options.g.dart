// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nim_sdk_android_options.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NIMAndroidSDKOptions _$NIMAndroidSDKOptionsFromJson(
        Map<String, dynamic> json) =>
    NIMAndroidSDKOptions(
      improveSDKProcessPriority:
          json['improveSDKProcessPriority'] as bool? ?? true,
      preLoadServers: json['preLoadServers'] as bool? ?? true,
      reducedIM: json['reducedIM'] as bool? ?? false,
      checkManifestConfig: json['checkManifestConfig'] as bool? ?? false,
      consoleLogEnabled: json['consoleLogEnabled'] as bool? ?? false,
      disableAwake: json['disableAwake'] as bool? ?? false,
      enabledQChatMessageCache:
          json['enabledQChatMessageCache'] as bool? ?? false,
      enableServerV2FriendAddApplication:
          json['enableServerV2FriendAddApplication'] as bool? ?? false,
      enableServerV2TeamJoinActionInfo:
          json['enableServerV2TeamJoinActionInfo'] as bool? ?? false,
      searchAccountIdEnabled: json['searchAccountIdEnabled'] as bool? ?? false,
      databaseEncryptKey: json['databaseEncryptKey'] as String?,
      thumbnailSize: (json['thumbnailSize'] as num?)?.toInt() ?? 350,
      fetchServerTimeInterval:
          (json['fetchServerTimeInterval'] as num?)?.toInt() ?? 2000,
      customPushContentType: json['customPushContentType'] as String?,
      mixPushConfig: _mixPushConfigFromMap(json['mixPushConfig'] as Map?),
      notificationConfig:
          _notificationConfigFromMap(json['notificationConfig'] as Map?),
      enableV2CloudConversation:
          json['enableV2CloudConversation'] as bool? ?? false,
      enableMessageNotifierCustomization:
          json['enableMessageNotifierCustomization'] as bool? ?? false,
      enableUserInfoProvider: json['enableUserInfoProvider'] as bool? ?? false,
      enableNotificationChannelProvider:
          json['enableNotificationChannelProvider'] as bool? ?? false,
      appKey: json['appKey'] as String,
      sdkRootDir: json['sdkRootDir'] as String?,
      cdnTrackInterval: (json['cdnTrackInterval'] as num?)?.toInt(),
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
    );

Map<String, dynamic> _$NIMAndroidSDKOptionsToJson(
        NIMAndroidSDKOptions instance) =>
    <String, dynamic>{
      'appKey': instance.appKey,
      'sdkRootDir': instance.sdkRootDir,
      'customClientType': instance.customClientType,
      'cdnTrackInterval': instance.cdnTrackInterval,
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
      'improveSDKProcessPriority': instance.improveSDKProcessPriority,
      'preLoadServers': instance.preLoadServers,
      'reducedIM': instance.reducedIM,
      'checkManifestConfig': instance.checkManifestConfig,
      'consoleLogEnabled': instance.consoleLogEnabled,
      'disableAwake': instance.disableAwake,
      'fetchServerTimeInterval': instance.fetchServerTimeInterval,
      'customPushContentType': instance.customPushContentType,
      'databaseEncryptKey': instance.databaseEncryptKey,
      'thumbnailSize': instance.thumbnailSize,
      'mixPushConfig': _mixPushConfigToMap(instance.mixPushConfig),
      'notificationConfig':
          _notificationConfigToMap(instance.notificationConfig),
      'enabledQChatMessageCache': instance.enabledQChatMessageCache,
      'enableServerV2FriendAddApplication':
          instance.enableServerV2FriendAddApplication,
      'enableServerV2TeamJoinActionInfo':
          instance.enableServerV2TeamJoinActionInfo,
      'searchAccountIdEnabled': instance.searchAccountIdEnabled,
      'enableV2CloudConversation': instance.enableV2CloudConversation,
      'enableUserInfoProvider': instance.enableUserInfoProvider,
      'enableNotificationChannelProvider':
          instance.enableNotificationChannelProvider,
      'enableMessageNotifierCustomization':
          instance.enableMessageNotifierCustomization,
    };

NIMMixPushConfig _$NIMMixPushConfigFromJson(Map<String, dynamic> json) =>
    NIMMixPushConfig(
      xmAppId: json['KEY_XM_APP_ID'] as String?,
      xmAppKey: json['KEY_XM_APP_KEY'] as String?,
      xmCertificateName: json['KEY_XM_CERTIFICATE_NAME'] as String?,
      hwAppId: json['KEY_HW_APP_ID'] as String?,
      hwCertificateName: json['KEY_HW_CERTIFICATE_NAME'] as String?,
      mzAppId: json['KEY_MZ_APP_ID'] as String?,
      mzAppKey: json['KEY_MZ_APP_KEY'] as String?,
      mzCertificateName: json['KEY_MZ_CERTIFICATE_NAME'] as String?,
      fcmCertificateName: json['KEY_FCM_CERTIFICATE_NAME'] as String?,
      vivoCertificateName: json['KEY_VIVO_CERTIFICATE_NAME'] as String?,
      oppoAppId: json['KEY_OPPO_APP_ID'] as String?,
      oppoAppKey: json['KEY_OPPO_APP_KEY'] as String?,
      oppoAppSecret: json['KEY_OPPO_APP_SERCET'] as String?,
      oppoCertificateName: json['KEY_OPPO_CERTIFICATE_NAME'] as String?,
      autoSelectPushType: json['KEY_AUTO_SELECT_PUSH_TYPE'] as bool? ?? false,
      manualProvidePushToken:
          json['KEY_MANUAL_PROVIDE_PUSH_TOKEN'] as bool? ?? false,
      honorCertificateName: json['KEY_HONOR_CERTIFICATE_NAME'] as String?,
    );

Map<String, dynamic> _$NIMMixPushConfigToJson(NIMMixPushConfig instance) =>
    <String, dynamic>{
      'KEY_XM_APP_ID': instance.xmAppId,
      'KEY_XM_APP_KEY': instance.xmAppKey,
      'KEY_XM_CERTIFICATE_NAME': instance.xmCertificateName,
      'KEY_HW_APP_ID': instance.hwAppId,
      'KEY_HW_CERTIFICATE_NAME': instance.hwCertificateName,
      'KEY_MZ_APP_ID': instance.mzAppId,
      'KEY_MZ_APP_KEY': instance.mzAppKey,
      'KEY_MZ_CERTIFICATE_NAME': instance.mzCertificateName,
      'KEY_FCM_CERTIFICATE_NAME': instance.fcmCertificateName,
      'KEY_VIVO_CERTIFICATE_NAME': instance.vivoCertificateName,
      'KEY_OPPO_APP_ID': instance.oppoAppId,
      'KEY_OPPO_APP_KEY': instance.oppoAppKey,
      'KEY_OPPO_APP_SERCET': instance.oppoAppSecret,
      'KEY_OPPO_CERTIFICATE_NAME': instance.oppoCertificateName,
      'KEY_AUTO_SELECT_PUSH_TYPE': instance.autoSelectPushType,
      'KEY_HONOR_CERTIFICATE_NAME': instance.honorCertificateName,
      'KEY_MANUAL_PROVIDE_PUSH_TOKEN': instance.manualProvidePushToken,
    };

NIMStatusBarNotificationConfig _$NIMStatusBarNotificationConfigFromJson(
        Map<String, dynamic> json) =>
    NIMStatusBarNotificationConfig(
      ring: json['ring'] as bool? ?? true,
      notificationSound: json['notificationSound'] as String?,
      vibrate: json['vibrate'] as bool? ?? true,
      ledARGB: (json['ledARGB'] as num?)?.toInt(),
      ledOnMs: (json['ledOnMs'] as num?)?.toInt(),
      ledOffMs: (json['ledOffMs'] as num?)?.toInt(),
      hideContent: json['hideContent'] as bool? ?? false,
      downTimeToggle: json['downTimeToggle'] as bool? ?? false,
      downTimeBegin: json['downTimeBegin'] as String?,
      downTimeEnd: json['downTimeEnd'] as String?,
      downTimeEnableNotification:
          json['downTimeEnableNotification'] as bool? ?? true,
      notificationEntranceClassName:
          json['notificationEntranceClassName'] as String?,
      titleOnlyShowAppName: json['titleOnlyShowAppName'] as bool? ?? false,
      notificationFoldStyle: $enumDecodeNullable(
              _$NIMNotificationFoldStyleEnumMap,
              json['notificationFoldStyle']) ??
          NIMNotificationFoldStyle.all,
      notificationColor: (json['notificationColor'] as num?)?.toInt(),
      showBadge: json['showBadge'] as bool? ?? true,
      customTitleWhenTeamNameEmpty:
          json['customTitleWhenTeamNameEmpty'] as String?,
      notificationExtraType: $enumDecodeNullable(
              _$NIMNotificationExtraTypeEnumMap,
              json['notificationExtraType']) ??
          NIMNotificationExtraType.message,
      asyncNotifierExe: json['asyncNotifierExe'] as bool? ?? false,
      highImportance: json['highImportance'] as bool? ?? false,
    );

Map<String, dynamic> _$NIMStatusBarNotificationConfigToJson(
        NIMStatusBarNotificationConfig instance) =>
    <String, dynamic>{
      'ring': instance.ring,
      'notificationSound': instance.notificationSound,
      'vibrate': instance.vibrate,
      'ledARGB': instance.ledARGB,
      'ledOnMs': instance.ledOnMs,
      'ledOffMs': instance.ledOffMs,
      'hideContent': instance.hideContent,
      'downTimeToggle': instance.downTimeToggle,
      'downTimeBegin': instance.downTimeBegin,
      'downTimeEnd': instance.downTimeEnd,
      'downTimeEnableNotification': instance.downTimeEnableNotification,
      'notificationEntranceClassName': instance.notificationEntranceClassName,
      'titleOnlyShowAppName': instance.titleOnlyShowAppName,
      'notificationFoldStyle':
          _$NIMNotificationFoldStyleEnumMap[instance.notificationFoldStyle]!,
      'notificationColor': instance.notificationColor,
      'showBadge': instance.showBadge,
      'customTitleWhenTeamNameEmpty': instance.customTitleWhenTeamNameEmpty,
      'highImportance': instance.highImportance,
      'asyncNotifierExe': instance.asyncNotifierExe,
      'notificationExtraType':
          _$NIMNotificationExtraTypeEnumMap[instance.notificationExtraType]!,
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

const _$NIMNotificationFoldStyleEnumMap = {
  NIMNotificationFoldStyle.all: 'all',
  NIMNotificationFoldStyle.expand: 'expand',
  NIMNotificationFoldStyle.contact: 'contact',
};

const _$NIMNotificationExtraTypeEnumMap = {
  NIMNotificationExtraType.message: 'message',
  NIMNotificationExtraType.jsonArrStr: 'jsonArrStr',
};

TokenDetail _$TokenDetailFromJson(Map<String, dynamic> json) => TokenDetail(
      type: $enumDecode(_$MixPushTypeEnumEnumMap, json['type']),
      token: json['token'] as String,
    );

Map<String, dynamic> _$TokenDetailToJson(TokenDetail instance) =>
    <String, dynamic>{
      'type': _$MixPushTypeEnumEnumMap[instance.type]!,
      'token': instance.token,
    };

const _$MixPushTypeEnumEnumMap = {
  MixPushTypeEnum.unknown: 0,
  MixPushTypeEnum.xiaoMi: 5,
  MixPushTypeEnum.huaWei: 6,
  MixPushTypeEnum.meiZu: 7,
  MixPushTypeEnum.fcm: 8,
  MixPushTypeEnum.vivo: 9,
  MixPushTypeEnum.oppo: 10,
  MixPushTypeEnum.honor: 11,
};
