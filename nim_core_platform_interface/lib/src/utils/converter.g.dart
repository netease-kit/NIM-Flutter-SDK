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

const _$NIMTeamBeInviteModeEnumMap = {
  NIMTeamBeInviteModeEnum.needAuth: 'needAuth',
  NIMTeamBeInviteModeEnum.noAuth: 'noAuth',
};

const _$NIMTeamInviteModeEnumMap = {
  NIMTeamInviteModeEnum.all: 'all',
  NIMTeamInviteModeEnum.manager: 'manager',
};

const _$NIMTeamExtensionUpdateModeEnumMap = {
  NIMTeamExtensionUpdateModeEnum.all: 'all',
  NIMTeamExtensionUpdateModeEnum.manager: 'manager',
};

const _$NIMTeamUpdateModeEnumMap = {
  NIMTeamUpdateModeEnum.all: 'all',
  NIMTeamUpdateModeEnum.manager: 'manager',
};

const _$NIMVerifyTypeEnumMap = {
  NIMVerifyTypeEnum.free: 'free',
  NIMVerifyTypeEnum.apply: 'apply',
  NIMVerifyTypeEnum.private: 'private',
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

const _$QChatSystemNotificationTypeEnumMap = {
  QChatSystemNotificationType.server_member_invite: 'server_member_invite',
  QChatSystemNotificationType.server_member_invite_reject:
      'server_member_invite_reject',
  QChatSystemNotificationType.server_member_apply: 'server_member_apply',
  QChatSystemNotificationType.server_member_apply_reject:
      'server_member_apply_reject',
  QChatSystemNotificationType.server_create: 'server_create',
  QChatSystemNotificationType.server_remove: 'server_remove',
  QChatSystemNotificationType.server_update: 'server_update',
  QChatSystemNotificationType.server_member_invite_done:
      'server_member_invite_done',
  QChatSystemNotificationType.server_member_invite_accept:
      'server_member_invite_accept',
  QChatSystemNotificationType.server_member_apply_done:
      'server_member_apply_done',
  QChatSystemNotificationType.server_member_apply_accept:
      'server_member_apply_accept',
  QChatSystemNotificationType.server_member_kick: 'server_member_kick',
  QChatSystemNotificationType.server_member_leave: 'server_member_leave',
  QChatSystemNotificationType.server_member_update: 'server_member_update',
  QChatSystemNotificationType.channel_create: 'channel_create',
  QChatSystemNotificationType.channel_remove: 'channel_remove',
  QChatSystemNotificationType.channel_update: 'channel_update',
  QChatSystemNotificationType.channel_update_white_black_role:
      'channel_update_white_black_role',
  QChatSystemNotificationType.channel_update_white_black_member:
      'channel_update_white_black_member',
  QChatSystemNotificationType.update_quick_comment: 'update_quick_comment',
  QChatSystemNotificationType.channel_category_create:
      'channel_category_create',
  QChatSystemNotificationType.channel_category_remove:
      'channel_category_remove',
  QChatSystemNotificationType.channel_category_update:
      'channel_category_update',
  QChatSystemNotificationType.channel_category_update_white_black_role:
      'channel_category_update_white_black_role',
  QChatSystemNotificationType.channel_category_update_white_black_member:
      'channel_category_update_white_black_member',
  QChatSystemNotificationType.server_role_member_add: 'server_role_member_add',
  QChatSystemNotificationType.server_role_member_delete:
      'server_role_member_delete',
  QChatSystemNotificationType.server_role_auth_update:
      'server_role_auth_update',
  QChatSystemNotificationType.channel_role_auth_update:
      'channel_role_auth_update',
  QChatSystemNotificationType.member_role_auth_update:
      'member_role_auth_update',
  QChatSystemNotificationType.channel_visibility_update:
      'channel_visibility_update',
  QChatSystemNotificationType.server_enter_leave: 'server_enter_leave',
  QChatSystemNotificationType.server_member_join_by_invite_code:
      'server_member_join_by_invite_code',
  QChatSystemNotificationType.custom: 'custom',
};
