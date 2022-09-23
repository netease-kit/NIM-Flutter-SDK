// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NIMTeam _$NIMTeamFromJson(Map<String, dynamic> json) {
  return NIMTeam(
    id: json['id'] as String?,
    name: json['name'] as String?,
    icon: json['icon'] as String?,
    type: _$enumDecode(_$NIMTeamTypeEnumEnumMap, json['type']),
    announcement: json['announcement'] as String?,
    introduce: json['introduce'] as String?,
    creator: json['creator'] as String?,
    memberCount: json['memberCount'] as int,
    memberLimit: json['memberLimit'] as int,
    verifyType: _$enumDecode(_$NIMVerifyTypeEnumEnumMap, json['verifyType']),
    createTime: json['createTime'] as num,
    isMyTeam: json['isMyTeam'] as bool?,
    extension: json['extension'] as String?,
    extServer: json['extServer'] as String?,
    messageNotifyType: _$enumDecode(
        _$NIMTeamMessageNotifyTypeEnumEnumMap, json['messageNotifyType']),
    teamInviteMode:
        _$enumDecode(_$NIMTeamInviteModeEnumEnumMap, json['teamInviteMode']),
    teamBeInviteModeEnum: _$enumDecode(
        _$NIMTeamBeInviteModeEnumEnumMap, json['teamBeInviteModeEnum']),
    teamUpdateMode:
        _$enumDecode(_$NIMTeamUpdateModeEnumEnumMap, json['teamUpdateMode']),
    teamExtensionUpdateMode: _$enumDecode(
        _$NIMTeamExtensionUpdateModeEnumEnumMap,
        json['teamExtensionUpdateMode']),
    isAllMute: json['isAllMute'] as bool?,
    muteMode: _$enumDecode(_$NIMTeamAllMuteModeEnumEnumMap, json['muteMode']),
  );
}

Map<String, dynamic> _$NIMTeamToJson(NIMTeam instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'icon': instance.icon,
      'type': _$NIMTeamTypeEnumEnumMap[instance.type],
      'announcement': instance.announcement,
      'introduce': instance.introduce,
      'creator': instance.creator,
      'memberCount': instance.memberCount,
      'memberLimit': instance.memberLimit,
      'verifyType': _$NIMVerifyTypeEnumEnumMap[instance.verifyType],
      'createTime': instance.createTime,
      'isMyTeam': instance.isMyTeam,
      'extension': instance.extension,
      'extServer': instance.extServer,
      'messageNotifyType':
          _$NIMTeamMessageNotifyTypeEnumEnumMap[instance.messageNotifyType],
      'teamInviteMode': _$NIMTeamInviteModeEnumEnumMap[instance.teamInviteMode],
      'teamBeInviteModeEnum':
          _$NIMTeamBeInviteModeEnumEnumMap[instance.teamBeInviteModeEnum],
      'teamUpdateMode': _$NIMTeamUpdateModeEnumEnumMap[instance.teamUpdateMode],
      'teamExtensionUpdateMode': _$NIMTeamExtensionUpdateModeEnumEnumMap[
          instance.teamExtensionUpdateMode],
      'isAllMute': instance.isAllMute,
      'muteMode': _$NIMTeamAllMuteModeEnumEnumMap[instance.muteMode],
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

const _$NIMTeamTypeEnumEnumMap = {
  NIMTeamTypeEnum.advanced: 'advanced',
  NIMTeamTypeEnum.normal: 'normal',
  NIMTeamTypeEnum.superTeam: 'superTeam',
};

const _$NIMVerifyTypeEnumEnumMap = {
  NIMVerifyTypeEnum.free: 'free',
  NIMVerifyTypeEnum.apply: 'apply',
  NIMVerifyTypeEnum.private: 'private',
};

const _$NIMTeamMessageNotifyTypeEnumEnumMap = {
  NIMTeamMessageNotifyTypeEnum.all: 'all',
  NIMTeamMessageNotifyTypeEnum.manager: 'manager',
  NIMTeamMessageNotifyTypeEnum.mute: 'mute',
};

const _$NIMTeamInviteModeEnumEnumMap = {
  NIMTeamInviteModeEnum.manager: 'manager',
  NIMTeamInviteModeEnum.all: 'all',
};

const _$NIMTeamBeInviteModeEnumEnumMap = {
  NIMTeamBeInviteModeEnum.needAuth: 'needAuth',
  NIMTeamBeInviteModeEnum.noAuth: 'noAuth',
};

const _$NIMTeamUpdateModeEnumEnumMap = {
  NIMTeamUpdateModeEnum.manager: 'manager',
  NIMTeamUpdateModeEnum.all: 'all',
};

const _$NIMTeamExtensionUpdateModeEnumEnumMap = {
  NIMTeamExtensionUpdateModeEnum.manager: 'manager',
  NIMTeamExtensionUpdateModeEnum.all: 'all',
};

const _$NIMTeamAllMuteModeEnumEnumMap = {
  NIMTeamAllMuteModeEnum.cancel: 'cancel',
  NIMTeamAllMuteModeEnum.muteNormal: 'muteNormal',
  NIMTeamAllMuteModeEnum.muteAll: 'muteAll',
};

NIMTeamNotificationAttachment _$NIMTeamNotificationAttachmentFromJson(
    Map<String, dynamic> json) {
  return NIMTeamNotificationAttachment(
    type: json['type'] as int,
    extension: _parseExtension(json['extension']),
  );
}

Map<String, dynamic> _$NIMTeamNotificationAttachmentToJson(
        NIMTeamNotificationAttachment instance) =>
    <String, dynamic>{
      'type': instance.type,
      'extension': instance.extension,
    };

NIMMemberChangeAttachment _$NIMMemberChangeAttachmentFromJson(
    Map<String, dynamic> json) {
  return NIMMemberChangeAttachment(
    type: json['type'] as int,
    targets:
        (json['targets'] as List<dynamic>?)?.map((e) => e as String).toList(),
    extension: _parseExtension(json['extension']),
  );
}

Map<String, dynamic> _$NIMMemberChangeAttachmentToJson(
        NIMMemberChangeAttachment instance) =>
    <String, dynamic>{
      'type': instance.type,
      'extension': instance.extension,
      'targets': instance.targets,
    };

NIMDismissAttachment _$NIMDismissAttachmentFromJson(Map<String, dynamic> json) {
  return NIMDismissAttachment(
    type: json['type'] as int,
    extension: _parseExtension(json['extension']),
  );
}

Map<String, dynamic> _$NIMDismissAttachmentToJson(
        NIMDismissAttachment instance) =>
    <String, dynamic>{
      'type': instance.type,
      'extension': instance.extension,
    };

NIMLeaveTeamAttachment _$NIMLeaveTeamAttachmentFromJson(
    Map<String, dynamic> json) {
  return NIMLeaveTeamAttachment(
    type: json['type'] as int,
    extension: _parseExtension(json['extension']),
  );
}

Map<String, dynamic> _$NIMLeaveTeamAttachmentToJson(
        NIMLeaveTeamAttachment instance) =>
    <String, dynamic>{
      'type': instance.type,
      'extension': instance.extension,
    };

NIMMuteMemberAttachment _$NIMMuteMemberAttachmentFromJson(
    Map<String, dynamic> json) {
  return NIMMuteMemberAttachment(
    mute: json['mute'] as bool? ?? false,
    type: json['type'] as int,
    targets:
        (json['targets'] as List<dynamic>?)?.map((e) => e as String).toList(),
    extension: _parseExtension(json['extension']),
  );
}

Map<String, dynamic> _$NIMMuteMemberAttachmentToJson(
        NIMMuteMemberAttachment instance) =>
    <String, dynamic>{
      'type': instance.type,
      'extension': instance.extension,
      'mute': instance.mute,
      'targets': instance.targets,
    };

NIMTeamUpdatedFields _$NIMTeamUpdatedFieldsFromJson(Map<String, dynamic> json) {
  return NIMTeamUpdatedFields(
    updatedAnnouncement: json['updatedAnnouncement'] as String?,
    updatedBeInviteMode: _$enumDecodeNullable(
        _$NIMTeamBeInviteModeEnumEnumMap, json['updatedBeInviteMode']),
    updatedExtension: json['updatedExtension'] as String?,
    updatedServerExtension: json['updatedServerExtension'] as String?,
    updatedIcon: json['updatedIcon'] as String?,
    updatedIntroduce: json['updatedIntroduce'] as String?,
    updatedInviteMode: _$enumDecodeNullable(
        _$NIMTeamInviteModeEnumEnumMap, json['updatedInviteMode']),
    updatedMaxMemberCount: json['updatedMaxMemberCount'] as int?,
    updatedName: json['updatedName'] as String?,
    updatedExtensionUpdateMode: _$enumDecodeNullable(
        _$NIMTeamExtensionUpdateModeEnumEnumMap,
        json['updatedExtensionUpdateMode']),
    updatedUpdateMode: _$enumDecodeNullable(
        _$NIMTeamUpdateModeEnumEnumMap, json['updatedUpdateMode']),
    updatedVerifyType: _$enumDecodeNullable(
        _$NIMVerifyTypeEnumEnumMap, json['updatedVerifyType']),
    updatedAllMuteMode: _$enumDecodeNullable(
        _$NIMTeamAllMuteModeEnumEnumMap, json['updatedAllMuteMode']),
  );
}

Map<String, dynamic> _$NIMTeamUpdatedFieldsToJson(
        NIMTeamUpdatedFields instance) =>
    <String, dynamic>{
      'updatedAnnouncement': instance.updatedAnnouncement,
      'updatedBeInviteMode':
          _$NIMTeamBeInviteModeEnumEnumMap[instance.updatedBeInviteMode],
      'updatedExtension': instance.updatedExtension,
      'updatedServerExtension': instance.updatedServerExtension,
      'updatedIcon': instance.updatedIcon,
      'updatedIntroduce': instance.updatedIntroduce,
      'updatedInviteMode':
          _$NIMTeamInviteModeEnumEnumMap[instance.updatedInviteMode],
      'updatedMaxMemberCount': instance.updatedMaxMemberCount,
      'updatedName': instance.updatedName,
      'updatedExtensionUpdateMode': _$NIMTeamExtensionUpdateModeEnumEnumMap[
          instance.updatedExtensionUpdateMode],
      'updatedUpdateMode':
          _$NIMTeamUpdateModeEnumEnumMap[instance.updatedUpdateMode],
      'updatedVerifyType':
          _$NIMVerifyTypeEnumEnumMap[instance.updatedVerifyType],
      'updatedAllMuteMode':
          _$NIMTeamAllMuteModeEnumEnumMap[instance.updatedAllMuteMode],
    };

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

NIMUpdateTeamAttachment _$NIMUpdateTeamAttachmentFromJson(
    Map<String, dynamic> json) {
  return NIMUpdateTeamAttachment(
    type: json['type'] as int,
    extension: _parseExtension(json['extension']),
    updatedFields: _updatedFieldsFromJson(json['updatedFields'] as Map?),
  );
}

Map<String, dynamic> _$NIMUpdateTeamAttachmentToJson(
        NIMUpdateTeamAttachment instance) =>
    <String, dynamic>{
      'type': instance.type,
      'extension': instance.extension,
      'updatedFields': instance.updatedFields.toMap(),
    };
