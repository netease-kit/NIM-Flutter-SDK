// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qchat_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QChatLoginParam _$QChatLoginParamFromJson(Map<String, dynamic> json) =>
    QChatLoginParam();

Map<String, dynamic> _$QChatLoginParamToJson(QChatLoginParam instance) =>
    <String, dynamic>{};

QChatLoginResult _$QChatLoginResultFromJson(Map<String, dynamic> json) =>
    QChatLoginResult(
      _otherClientsFromJson(json['otherClients'] as List),
    );

Map<String, dynamic> _$QChatLoginResultToJson(QChatLoginResult instance) =>
    <String, dynamic>{
      'otherClients': instance.otherClients.map((e) => e.toJson()).toList(),
    };

QChatClient _$QChatClientFromJson(Map<String, dynamic> json) => QChatClient()
  ..clientType = $enumDecodeNullable(_$NIMClientTypeEnumMap, json['clientType'])
  ..os = json['os'] as String?
  ..loginTime = json['loginTime'] as int?
  ..deviceId = json['deviceId'] as String?
  ..customTag = json['customTag'] as String?
  ..customClientType = json['customClientType'] as int?;

Map<String, dynamic> _$QChatClientToJson(QChatClient instance) =>
    <String, dynamic>{
      'clientType': _$NIMClientTypeEnumMap[instance.clientType],
      'os': instance.os,
      'loginTime': instance.loginTime,
      'deviceId': instance.deviceId,
      'customTag': instance.customTag,
      'customClientType': instance.customClientType,
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

QChatKickOtherClientsParam _$QChatKickOtherClientsParamFromJson(
        Map<String, dynamic> json) =>
    QChatKickOtherClientsParam(
      (json['deviceIds'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$QChatKickOtherClientsParamToJson(
        QChatKickOtherClientsParam instance) =>
    <String, dynamic>{
      'deviceIds': instance.deviceIds,
    };

QChatKickOtherClientsResult _$QChatKickOtherClientsResultFromJson(
        Map<String, dynamic> json) =>
    QChatKickOtherClientsResult(
      (json['clientIds'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$QChatKickOtherClientsResultToJson(
        QChatKickOtherClientsResult instance) =>
    <String, dynamic>{
      'clientIds': instance.clientIds,
    };
