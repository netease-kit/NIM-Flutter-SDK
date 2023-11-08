// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nim_sdk_android_options.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NIMAndroidSDKOptions _$NIMAndroidSDKOptionsFromJson(Map<String, dynamic> json) {
  return NIMAndroidSDKOptions(
    improveSDKProcessPriority:
        json['improveSDKProcessPriority'] as bool? ?? true,
    preLoadServers: json['preLoadServers'] as bool? ?? true,
    reducedIM: json['reducedIM'] as bool? ?? false,
    enableFcs: json['enableFcs'] as bool? ?? true,
    checkManifestConfig: json['checkManifestConfig'] as bool? ?? false,
    disableAwake: json['disableAwake'] as bool? ?? false,
    databaseEncryptKey: json['databaseEncryptKey'] as String?,
    thumbnailSize: json['thumbnailSize'] as int? ?? 350,
    enabledQChatMessageCache:
        json['enabledQChatMessageCache'] as bool? ?? false,
    fetchServerTimeInterval: json['fetchServerTimeInterval'] as int? ?? 2000,
    customPushContentType: json['customPushContentType'] as String?,
    mixPushConfig: _mixPushConfigFromMap(json['mixPushConfig'] as Map?),
    notificationConfig:
        _notificationConfigFromMap(json['notificationConfig'] as Map?),
    appKey: json['appKey'] as String,
    sdkRootDir: json['sdkRootDir'] as String?,
    cdnTrackInterval: json['cdnTrackInterval'] as int?,
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
  );
}

Map<String, dynamic> _$NIMAndroidSDKOptionsToJson(
    NIMAndroidSDKOptions instance) {
  final val = <String, dynamic>{
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
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('autoLoginInfo', loginInfoToMap(instance.autoLoginInfo));
  val['nosSceneConfig'] = instance.nosSceneConfig;
  val["serverConfig"] = serverConfigToJson(instance.serverConfig);
  val['improveSDKProcessPriority'] = instance.improveSDKProcessPriority;
  val['preLoadServers'] = instance.preLoadServers;
  val['reducedIM'] = instance.reducedIM;
  val['enableFcs'] = instance.enableFcs;
  val['checkManifestConfig'] = instance.checkManifestConfig;
  val['disableAwake'] = instance.disableAwake;
  val['fetchServerTimeInterval'] = instance.fetchServerTimeInterval;
  val['customPushContentType'] = instance.customPushContentType;
  val['databaseEncryptKey'] = instance.databaseEncryptKey;
  val['thumbnailSize'] = instance.thumbnailSize;
  val['mixPushConfig'] = _mixPushConfigToMap(instance.mixPushConfig);
  val['notificationConfig'] =
      _notificationConfigToMap(instance.notificationConfig);
  val['enabledQChatMessageCache'] = instance.enabledQChatMessageCache;
  return val;
}

NIMMixPushConfig _$NIMMixPushConfigFromJson(Map<String, dynamic> json) {
  return NIMMixPushConfig(
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
    autoSelectPushType: json['KEY_AUTO_SELECT_PUSH_TYPE'] as bool,
    honorCertificateName: json['KEY_HONOR_CERTIFICATE_NAME'] as String?,
  );
}

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
    };

NIMStatusBarNotificationConfig _$NIMStatusBarNotificationConfigFromJson(
    Map<String, dynamic> json) {
  return NIMStatusBarNotificationConfig(
    ring: json['ring'] as bool,
    notificationSound: json['notificationSound'] as String?,
    vibrate: json['vibrate'] as bool,
    ledARGB: json['ledARGB'] as int?,
    ledOnMs: json['ledOnMs'] as int?,
    ledOffMs: json['ledOffMs'] as int?,
    hideContent: json['hideContent'] as bool,
    downTimeToggle: json['downTimeToggle'] as bool,
    downTimeBegin: json['downTimeBegin'] as String?,
    downTimeEnd: json['downTimeEnd'] as String?,
    downTimeEnableNotification: json['downTimeEnableNotification'] as bool,
    notificationEntranceClassName:
        json['notificationEntranceClassName'] as String?,
    titleOnlyShowAppName: json['titleOnlyShowAppName'] as bool,
    notificationFoldStyle: _$enumDecodeNullable(
            _$NIMNotificationFoldStyleEnumMap, json['notificationFoldStyle']) ??
        NIMNotificationFoldStyle.all,
    notificationColor: json['notificationColor'] as int?,
    showBadge: json['showBadge'] as bool,
    customTitleWhenTeamNameEmpty:
        json['customTitleWhenTeamNameEmpty'] as String?,
    notificationExtraType: _$enumDecodeNullable(
            _$NIMNotificationExtraTypeEnumMap, json['notificationExtraType']) ??
        NIMNotificationExtraType.message,
  );
}

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
          _$NIMNotificationFoldStyleEnumMap[instance.notificationFoldStyle],
      'notificationColor': instance.notificationColor,
      'showBadge': instance.showBadge,
      'customTitleWhenTeamNameEmpty': instance.customTitleWhenTeamNameEmpty,
      'notificationExtraType':
          _$NIMNotificationExtraTypeEnumMap[instance.notificationExtraType],
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
