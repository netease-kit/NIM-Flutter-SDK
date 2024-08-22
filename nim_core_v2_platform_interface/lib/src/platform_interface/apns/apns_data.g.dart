// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'apns_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NIMPushNotificationSetting _$NIMPushNotificationSettingFromJson(
        Map<String, dynamic> json) =>
    NIMPushNotificationSetting(
      type: $enumDecode(_$NIMPushNotificationDisplayTypeEnumMap, json['type']),
      noDisturbing: json['noDisturbing'] as bool,
      noDisturbingStartH: (json['noDisturbingStartH'] as num).toInt(),
      noDisturbingStartM: (json['noDisturbingStartM'] as num).toInt(),
      noDisturbingEndH: (json['noDisturbingEndH'] as num).toInt(),
      noDisturbingEndM: (json['noDisturbingEndM'] as num).toInt(),
      profile:
          $enumDecode(_$NIMPushNotificationProfileEnumMap, json['profile']),
    );

Map<String, dynamic> _$NIMPushNotificationSettingToJson(
        NIMPushNotificationSetting instance) =>
    <String, dynamic>{
      'type': _$NIMPushNotificationDisplayTypeEnumMap[instance.type]!,
      'noDisturbing': instance.noDisturbing,
      'noDisturbingStartH': instance.noDisturbingStartH,
      'noDisturbingStartM': instance.noDisturbingStartM,
      'noDisturbingEndH': instance.noDisturbingEndH,
      'noDisturbingEndM': instance.noDisturbingEndM,
      'profile': _$NIMPushNotificationProfileEnumMap[instance.profile]!,
    };

const _$NIMPushNotificationDisplayTypeEnumMap = {
  NIMPushNotificationDisplayType.pushNotificationDisplayTypeDetail: 1,
  NIMPushNotificationDisplayType.pushNotificationDisplayTypeNoDetail: 2,
};

const _$NIMPushNotificationProfileEnumMap = {
  NIMPushNotificationProfile.pushNotificationProfileNotSet: 0,
  NIMPushNotificationProfile.pushNotificationProfileEnableAll: 1,
  NIMPushNotificationProfile.pushNotificationProfileOnlyHighAndMediumLevel: 2,
  NIMPushNotificationProfile.pushNotificationProfileOnlyHighLevel: 3,
  NIMPushNotificationProfile.pushNotificationProfileDisableAll: 4,
  NIMPushNotificationProfile.pushNotificationProfilePlatformDefault: 5,
};

NIMPushNotificationMultiportConfig _$NIMPushNotificationMultiportConfigFromJson(
        Map<String, dynamic> json) =>
    NIMPushNotificationMultiportConfig(
      shouldPushNotificationWhenPCOnline:
          json['shouldPushNotificationWhenPCOnline'] as bool,
    );

Map<String, dynamic> _$NIMPushNotificationMultiportConfigToJson(
        NIMPushNotificationMultiportConfig instance) =>
    <String, dynamic>{
      'shouldPushNotificationWhenPCOnline':
          instance.shouldPushNotificationWhenPCOnline,
    };
