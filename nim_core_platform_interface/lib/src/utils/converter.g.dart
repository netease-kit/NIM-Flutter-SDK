// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'converter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

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

const _$NIMSessionTypeEnumMap = {
  NIMSessionType.none: 'none',
  NIMSessionType.p2p: 'p2p',
  NIMSessionType.team: 'team',
  NIMSessionType.superTeam: 'superTeam',
  NIMSessionType.system: 'system',
  NIMSessionType.ysf: 'ysf',
  NIMSessionType.chatRoom: 'chatRoom',
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
