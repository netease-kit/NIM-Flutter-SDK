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
    memberLimit: json['memberLimit'] as String?,
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
};

const _$NIMVerifyTypeEnumEnumMap = {
  NIMVerifyTypeEnum.free: 'free',
  NIMVerifyTypeEnum.apply: 'apply',
  NIMVerifyTypeEnum.Private: 'Private',
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
  NIMTeamAllMuteModeEnum.Cancel: 'Cancel',
  NIMTeamAllMuteModeEnum.MuteNormal: 'MuteNormal',
  NIMTeamAllMuteModeEnum.MuteALL: 'MuteALL',
};

NIMTeamNotificationAttachment _$NIMTeamNotificationAttachmentFromJson(
    Map<String, dynamic> json) {
  return NIMTeamNotificationAttachment(
    type: json['type'] as int,
    extension: json['extension'] as Map<String, dynamic>?,
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
    extension: json['extension'] as Map<String, dynamic>?,
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
    extension: json['extension'] as Map<String, dynamic>?,
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
    extension: json['extension'] as Map<String, dynamic>?,
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
    mute: json['mute'] as bool,
    type: json['type'] as int,
    extension: json['extension'] as Map<String, dynamic>?,
  );
}

Map<String, dynamic> _$NIMMuteMemberAttachmentToJson(
        NIMMuteMemberAttachment instance) =>
    <String, dynamic>{
      'type': instance.type,
      'extension': instance.extension,
      'mute': instance.mute,
    };

NIMUpdateTeamAttachment _$NIMUpdateTeamAttachmentFromJson(
    Map<String, dynamic> json) {
  return NIMUpdateTeamAttachment(
    updatedFields: (json['updatedFields'] as Map<String, dynamic>).map(
      (k, e) =>
          MapEntry(_$enumDecode(_$NIMTeamFieldEnumEnumMap, k), e as Object),
    ),
    type: json['type'] as int,
    extension: json['extension'] as Map<String, dynamic>?,
  );
}

Map<String, dynamic> _$NIMUpdateTeamAttachmentToJson(
        NIMUpdateTeamAttachment instance) =>
    <String, dynamic>{
      'type': instance.type,
      'extension': instance.extension,
      'updatedFields': instance.updatedFields
          .map((k, e) => MapEntry(_$NIMTeamFieldEnumEnumMap[k], e)),
    };

const _$NIMTeamFieldEnumEnumMap = {
  NIMTeamFieldEnum.announcement: 'announcement',
  NIMTeamFieldEnum.beInviteMode: 'beInviteMode',
  NIMTeamFieldEnum.extension: 'extension',
  NIMTeamFieldEnum.icon: 'icon',
  NIMTeamFieldEnum.introduce: 'introduce',
  NIMTeamFieldEnum.inviteMode: 'inviteMode',
  NIMTeamFieldEnum.maxMemberCount: 'maxMemberCount',
  NIMTeamFieldEnum.name: 'name',
  NIMTeamFieldEnum.teamExtensionUpdateMode: 'teamExtensionUpdateMode',
  NIMTeamFieldEnum.teamUpdateMode: 'teamUpdateMode',
  NIMTeamFieldEnum.verifyType: 'verifyType',
};
