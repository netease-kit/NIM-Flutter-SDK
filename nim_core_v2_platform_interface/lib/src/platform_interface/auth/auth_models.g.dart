// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NIMLoginInfo _$NIMLoginInfoFromJson(Map<String, dynamic> json) => NIMLoginInfo(
      account: json['account'] as String,
      token: json['token'] as String,
      authType: json['authType'] == null
          ? NIMAuthType.authTypeDefault
          : _authTypeFromValue((json['authType'] as num?)?.toInt()),
      loginExt: json['loginExt'] as String?,
      customClientType: (json['customClientType'] as num?)?.toInt(),
    );

Map<String, dynamic> _$NIMLoginInfoToJson(NIMLoginInfo instance) =>
    <String, dynamic>{
      'account': instance.account,
      'token': instance.token,
      'authType': _valueOfNIMAuthType(instance.authType),
      'loginExt': instance.loginExt,
      'customClientType': instance.customClientType,
    };

NIMOnlineClient _$NIMOnlineClientFromJson(Map<String, dynamic> json) =>
    NIMOnlineClient(
      os: json['os'] as String,
      clientType: $enumDecode(_$NIMClientTypeEnumMap, json['clientType'],
          unknownValue: NIMClientType.unknown),
      loginTime: (json['loginTime'] as num).toInt(),
      customTag: json['customTag'] as String?,
    );

Map<String, dynamic> _$NIMOnlineClientToJson(NIMOnlineClient instance) =>
    <String, dynamic>{
      'os': instance.os,
      'clientType': _$NIMClientTypeEnumMap[instance.clientType]!,
      'loginTime': instance.loginTime,
      'customTag': instance.customTag,
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
