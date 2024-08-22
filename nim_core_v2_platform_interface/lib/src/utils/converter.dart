// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:core';

import 'package:json_annotation/json_annotation.dart';

import 'package:nim_core_v2_platform_interface/nim_core_v2_platform_interface.dart';

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
