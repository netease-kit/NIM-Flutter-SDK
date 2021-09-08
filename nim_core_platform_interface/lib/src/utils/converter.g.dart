// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'converter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NIMMessageTypeConverter _$NIMMessageTypeConverterFromJson(
    Map<String, dynamic> json) {
  return NIMMessageTypeConverter(
    messageType:
        _$enumDecodeNullable(_$NIMMessageTypeEnumMap, json['messageType']),
  );
}

Map<String, dynamic> _$NIMMessageTypeConverterToJson(
        NIMMessageTypeConverter instance) =>
    <String, dynamic>{
      'messageType': _$NIMMessageTypeEnumMap[instance.messageType],
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

const _$NIMMessageTypeEnumMap = {
  NIMMessageType.undef: 'undef',
  NIMMessageType.text: 'text',
  NIMMessageType.image: 'image',
  NIMMessageType.audio: 'audio',
  NIMMessageType.video: 'video',
  NIMMessageType.location: 'location',
  NIMMessageType.file: 'file',
  NIMMessageType.avchat: 'avchat',
  NIMMessageType.notification: 'notification',
  NIMMessageType.tip: 'tip',
  NIMMessageType.robot: 'robot',
  NIMMessageType.netcall: 'netcall',
  NIMMessageType.custom: 'custom',
  NIMMessageType.appCustom: 'appCustom',
  NIMMessageType.qiyuCustom: 'qiyuCustom',
};

NIMSessionTypeConverter _$NIMSessionTypeConverterFromJson(
    Map<String, dynamic> json) {
  return NIMSessionTypeConverter(
    sessionType:
        _$enumDecodeNullable(_$NIMSessionTypeEnumMap, json['sessionType']),
  );
}

Map<String, dynamic> _$NIMSessionTypeConverterToJson(
        NIMSessionTypeConverter instance) =>
    <String, dynamic>{
      'sessionType': _$NIMSessionTypeEnumMap[instance.sessionType],
    };

const _$NIMSessionTypeEnumMap = {
  NIMSessionType.none: 'none',
  NIMSessionType.p2p: 'p2p',
  NIMSessionType.team: 'team',
  NIMSessionType.superTeam: 'superTeam',
  NIMSessionType.system: 'system',
  NIMSessionType.ysf: 'ysf',
  NIMSessionType.chatRoom: 'chatRoom',
};

SystemMessageStatusConverter _$SystemMessageStatusConverterFromJson(
    Map<String, dynamic> json) {
  return SystemMessageStatusConverter(
    status: _$enumDecodeNullable(_$SystemMessageStatusEnumMap, json['status']),
  );
}

Map<String, dynamic> _$SystemMessageStatusConverterToJson(
        SystemMessageStatusConverter instance) =>
    <String, dynamic>{
      'status': _$SystemMessageStatusEnumMap[instance.status],
    };

const _$SystemMessageStatusEnumMap = {
  SystemMessageStatus.init: 'init',
  SystemMessageStatus.passed: 'passed',
  SystemMessageStatus.declined: 'declined',
  SystemMessageStatus.ignored: 'ignored',
  SystemMessageStatus.expired: 'expired',
  SystemMessageStatus.extension1: 'extension1',
  SystemMessageStatus.extension2: 'extension2',
  SystemMessageStatus.extension3: 'extension3',
  SystemMessageStatus.extension4: 'extension4',
  SystemMessageStatus.extension5: 'extension5',
};

SystemMessageTypeConverter _$SystemMessageTypeConverterFromJson(
    Map<String, dynamic> json) {
  return SystemMessageTypeConverter(
    type: _$enumDecodeNullable(_$SystemMessageTypeEnumMap, json['type']),
  );
}

Map<String, dynamic> _$SystemMessageTypeConverterToJson(
        SystemMessageTypeConverter instance) =>
    <String, dynamic>{
      'type': _$SystemMessageTypeEnumMap[instance.type],
    };

const _$SystemMessageTypeEnumMap = {
  SystemMessageType.undefined: 'undefined',
  SystemMessageType.applyJoinTeam: 'applyJoinTeam',
  SystemMessageType.rejectTeamApply: 'rejectTeamApply',
  SystemMessageType.teamInvite: 'teamInvite',
  SystemMessageType.declineTeamInvite: 'declineTeamInvite',
  SystemMessageType.addFriend: 'addFriend',
  SystemMessageType.superTeamApply: 'superTeamApply',
  SystemMessageType.superTeamApplyReject: 'superTeamApplyReject',
  SystemMessageType.superTeamInvite: 'superTeamInvite',
  SystemMessageType.superTeamInviteReject: 'superTeamInviteReject',
};
