// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qchat_base_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QChatAntiSpamConfigParam _$QChatAntiSpamConfigParamFromJson(
        Map<String, dynamic> json) =>
    QChatAntiSpamConfigParam()
      ..antiSpamConfig = antiSpamConfigFromJson(json['antiSpamConfig'] as Map?);

Map<String, dynamic> _$QChatAntiSpamConfigParamToJson(
        QChatAntiSpamConfigParam instance) =>
    <String, dynamic>{
      'antiSpamConfig': instance.antiSpamConfig?.toJson(),
    };

QChatAntiSpamConfig _$QChatAntiSpamConfigFromJson(Map<String, dynamic> json) =>
    QChatAntiSpamConfig()
      ..antiSpamBusinessId = json['antiSpamBusinessId'] as String?;

Map<String, dynamic> _$QChatAntiSpamConfigToJson(
        QChatAntiSpamConfig instance) =>
    <String, dynamic>{
      'antiSpamBusinessId': instance.antiSpamBusinessId,
    };

AntiSpamConfig _$AntiSpamConfigFromJson(Map<String, dynamic> json) =>
    AntiSpamConfig()
      ..antiSpamBusinessId = json['antiSpamBusinessId'] as String?;

Map<String, dynamic> _$AntiSpamConfigToJson(AntiSpamConfig instance) =>
    <String, dynamic>{
      'antiSpamBusinessId': instance.antiSpamBusinessId,
    };

QChatGetByPageResult _$QChatGetByPageResultFromJson(
        Map<String, dynamic> json) =>
    QChatGetByPageResult(
      hasMore: json['hasMore'] as bool? ?? false,
      nextTimeTag: json['nextTimeTag'] as int?,
    );

Map<String, dynamic> _$QChatGetByPageResultToJson(
        QChatGetByPageResult instance) =>
    <String, dynamic>{
      'hasMore': instance.hasMore,
      'nextTimeTag': instance.nextTimeTag,
    };

QChatUnreadInfo _$QChatUnreadInfoFromJson(Map<String, dynamic> json) =>
    QChatUnreadInfo(
      channelId: json['channelId'] as int,
      serverId: json['serverId'] as int,
      maxCount: json['maxCount'] as int?,
      mentionedCount: json['mentionedCount'] as int?,
      unreadCount: json['unreadCount'] as int?,
      ackTimeTag: json['ackTimeTag'] as int?,
      lastMsgTime: json['lastMsgTime'] as int?,
      time: json['time'] as int?,
    );

Map<String, dynamic> _$QChatUnreadInfoToJson(QChatUnreadInfo instance) =>
    <String, dynamic>{
      'serverId': instance.serverId,
      'channelId': instance.channelId,
      'ackTimeTag': instance.ackTimeTag,
      'unreadCount': instance.unreadCount,
      'mentionedCount': instance.mentionedCount,
      'maxCount': instance.maxCount,
      'lastMsgTime': instance.lastMsgTime,
      'time': instance.time,
    };
