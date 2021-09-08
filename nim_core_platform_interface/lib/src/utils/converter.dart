// Copyright (c) 2021 NetEase, Inc.  All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:core';

import 'package:json_annotation/json_annotation.dart';
import 'package:nim_core_platform_interface/src/platform_interface/nim_base.dart';
import 'package:nim_core_platform_interface/src/platform_interface/system_message/system_message.dart';

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
