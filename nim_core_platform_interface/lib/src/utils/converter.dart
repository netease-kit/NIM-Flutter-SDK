// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:core';

import 'package:json_annotation/json_annotation.dart';

import 'package:nim_core_platform_interface/nim_core_platform_interface.dart';

part 'converter.g.dart';

mixin EnumConverter<E, T> {
  E enumFromValue(Map<E, T> map, T t, {E? defaultEnum}) {
    return _$enumDecode(map, t, unknownValue: defaultEnum);
  }

  T enumToValue(Map<E, T> map, E e) {
    return map[e] as T;
  }
}

@JsonSerializable()
class NIMMessageTypeConverter with EnumConverter<NIMMessageType, String> {
  final NIMMessageType? messageType;

  NIMMessageTypeConverter({this.messageType});

  NIMMessageType fromValue(String value, {NIMMessageType? defaultType}) {
    return enumFromValue(_$NIMMessageTypeEnumMap, value,
        defaultEnum: defaultType);
  }

  String toValue() {
    return super.enumToValue(_$NIMMessageTypeEnumMap, messageType!);
  }
}

@JsonSerializable()
class QChatSystemNotificationTypeConverter
    with EnumConverter<QChatSystemNotificationType, String> {
  final QChatSystemNotificationType? type;

  QChatSystemNotificationTypeConverter({this.type});

  QChatSystemNotificationType fromValue(String value,
      {QChatSystemNotificationType? defaultType}) {
    return enumFromValue(_$QChatSystemNotificationTypeEnumMap, value,
        defaultEnum: defaultType);
  }

  String toValue() {
    return super.enumToValue(_$QChatSystemNotificationTypeEnumMap, type!);
  }
}

@JsonSerializable()
class NIMSessionTypeConverter with EnumConverter<NIMSessionType, String> {
  final NIMSessionType? sessionType;

  NIMSessionTypeConverter({this.sessionType});

  NIMSessionType fromValue(String value, {NIMSessionType? defaultType}) {
    return enumFromValue(_$NIMSessionTypeEnumMap, value,
        defaultEnum: defaultType);
  }

  String toValue() {
    return super.enumToValue(_$NIMSessionTypeEnumMap, sessionType!);
  }
}

@JsonSerializable()
class NIMTeamBeInviteModeEnumConverter
    with EnumConverter<NIMTeamBeInviteModeEnum, String> {
  final NIMTeamBeInviteModeEnum? nimTeamBeInviteModeEnum;

  NIMTeamBeInviteModeEnumConverter({this.nimTeamBeInviteModeEnum});

  NIMTeamBeInviteModeEnum fromValue(String value,
      {NIMTeamBeInviteModeEnum? defaultType}) {
    return enumFromValue(_$NIMTeamBeInviteModeEnumMap, value,
        defaultEnum: defaultType);
  }

  String toValue() {
    return super
        .enumToValue(_$NIMTeamBeInviteModeEnumMap, nimTeamBeInviteModeEnum!);
  }
}

@JsonSerializable()
class NIMTeamInviteModeEnumConverter
    with EnumConverter<NIMTeamInviteModeEnum, String> {
  final NIMTeamInviteModeEnum? nimTeamInviteModeEnum;

  NIMTeamInviteModeEnumConverter({this.nimTeamInviteModeEnum});

  NIMTeamInviteModeEnum fromValue(String value,
      {NIMTeamInviteModeEnum? defaultType}) {
    return enumFromValue(_$NIMTeamInviteModeEnumMap, value,
        defaultEnum: defaultType);
  }

  String toValue() {
    return super
        .enumToValue(_$NIMTeamInviteModeEnumMap, nimTeamInviteModeEnum!);
  }
}

@JsonSerializable()
class NIMTeamExtensionUpdateModeEnumConverter
    with EnumConverter<NIMTeamExtensionUpdateModeEnum, String> {
  final NIMTeamExtensionUpdateModeEnum? nimTeamExtensionUpdateModeEnum;

  NIMTeamExtensionUpdateModeEnumConverter(
      {this.nimTeamExtensionUpdateModeEnum});

  NIMTeamExtensionUpdateModeEnum fromValue(String value,
      {NIMTeamExtensionUpdateModeEnum? defaultType}) {
    return enumFromValue(_$NIMTeamExtensionUpdateModeEnumMap, value,
        defaultEnum: defaultType);
  }

  String toValue() {
    return super.enumToValue(
        _$NIMTeamExtensionUpdateModeEnumMap, nimTeamExtensionUpdateModeEnum!);
  }
}

@JsonSerializable()
class NIMTeamUpdateModeEnumConverter
    with EnumConverter<NIMTeamUpdateModeEnum, String> {
  final NIMTeamUpdateModeEnum? nimTeamUpdateModeEnum;

  NIMTeamUpdateModeEnumConverter({this.nimTeamUpdateModeEnum});

  NIMTeamUpdateModeEnum fromValue(String value,
      {NIMTeamUpdateModeEnum? defaultType}) {
    return enumFromValue(_$NIMTeamUpdateModeEnumMap, value,
        defaultEnum: defaultType);
  }

  String toValue() {
    return super
        .enumToValue(_$NIMTeamUpdateModeEnumMap, nimTeamUpdateModeEnum!);
  }
}

@JsonSerializable()
class NIMVerifyTypeEnumConverter with EnumConverter<NIMVerifyTypeEnum, String> {
  final NIMVerifyTypeEnum? nimVerifyTypeEnum;

  NIMVerifyTypeEnumConverter({this.nimVerifyTypeEnum});

  NIMVerifyTypeEnum fromValue(String value, {NIMVerifyTypeEnum? defaultType}) {
    return enumFromValue(_$NIMVerifyTypeEnumMap, value,
        defaultEnum: defaultType);
  }

  String toValue() {
    return super.enumToValue(_$NIMVerifyTypeEnumMap, nimVerifyTypeEnum!);
  }
}

@JsonSerializable()
class SystemMessageStatusConverter
    with EnumConverter<SystemMessageStatus, String> {
  final SystemMessageStatus? status;

  SystemMessageStatusConverter({this.status});

  SystemMessageStatus fromValue(String value,
      {SystemMessageStatus? defaultType}) {
    return enumFromValue(_$SystemMessageStatusEnumMap, value,
        defaultEnum: defaultType);
  }

  String toValue() {
    return super.enumToValue(_$SystemMessageStatusEnumMap, status!);
  }
}

@JsonSerializable()
class SystemMessageTypeConverter with EnumConverter<SystemMessageType, String> {
  final SystemMessageType? type;

  SystemMessageTypeConverter({this.type});

  SystemMessageType fromValue(String? value, {SystemMessageType? defaultType}) {
    if (value == null) {
      return SystemMessageType.undefined;
    } else {
      return enumFromValue(_$SystemMessageTypeEnumMap, value,
          defaultEnum: defaultType);
    }
  }

  String toValue() {
    return super.enumToValue(_$SystemMessageTypeEnumMap, type!);
  }
}

Map<String, dynamic>? castPlatformMapToDartMap(Map? map) {
  return map?.cast<String, dynamic>();
}

Map<String, String>? castMapToTypeOfStringString(Map? map) {
  return map?.cast<String, String>();
}

Map<String, int>? castMapToTypeOfStringInt(Map? map) {
  return map?.cast<String, int>();
}

Map<String, bool>? castMapToTypeOfBoolString(Map? map) {
  return map?.cast<String, bool>();
}

K? enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source != null) {}

  final entries = enumValues.entries.where((element) {
    return element.value == source;
  }).toList();

  return entries.length > 0 ? entries.first.key : unknownValue;
}
