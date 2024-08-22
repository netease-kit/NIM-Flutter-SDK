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

NIMMessageTypeConverter _$NIMMessageTypeConverterFromJson(
        Map<String, dynamic> json) =>
    NIMMessageTypeConverter(
      messageType:
          $enumDecodeNullable(_$NIMMessageTypeEnumMap, json['messageType']),
    );

Map<String, dynamic> _$NIMMessageTypeConverterToJson(
        NIMMessageTypeConverter instance) =>
    <String, dynamic>{
      'messageType': _$NIMMessageTypeEnumMap[instance.messageType],
    };

const _$NIMMessageTypeEnumMap = {
  NIMMessageType.invalid: 'invalid',
  NIMMessageType.text: 'text',
  NIMMessageType.image: 'image',
  NIMMessageType.audio: 'audio',
  NIMMessageType.video: 'video',
  NIMMessageType.location: 'location',
  NIMMessageType.notification: 'notification',
  NIMMessageType.file: 'file',
  NIMMessageType.avChat: 'avChat',
  NIMMessageType.tip: 'tip',
  NIMMessageType.robot: 'robot',
  NIMMessageType.call: 'call',
  NIMMessageType.custom: 'custom',
};

QChatSystemNotificationTypeConverter
    _$QChatSystemNotificationTypeConverterFromJson(Map<String, dynamic> json) =>
        QChatSystemNotificationTypeConverter(
          type: $enumDecodeNullable(
              _$QChatSystemNotificationTypeEnumMap, json['type']),
        );

Map<String, dynamic> _$QChatSystemNotificationTypeConverterToJson(
        QChatSystemNotificationTypeConverter instance) =>
    <String, dynamic>{
      'type': _$QChatSystemNotificationTypeEnumMap[instance.type],
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
  QChatSystemNotificationType.my_member_info_update: 'my_member_info_update',
  QChatSystemNotificationType.custom: 'custom',
};

NIMSessionTypeConverter _$NIMSessionTypeConverterFromJson(
        Map<String, dynamic> json) =>
    NIMSessionTypeConverter(
      sessionType:
          $enumDecodeNullable(_$NIMSessionTypeEnumMap, json['sessionType']),
    );

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
