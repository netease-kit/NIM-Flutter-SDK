// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NIMUser _$NIMUserFromJson(Map<String, dynamic> json) {
  return NIMUser(
    userId: json['userId'] as String?,
    nick: json['nick'] as String?,
    avatar: json['avatar'] as String?,
    sign: json['signature'] as String?,
    gender: _$enumDecodeNullable(_$NIMUserGenderEnumEnumMap, json['gender']),
    email: json['email'] as String?,
    birth: json['birthday'] as String?,
    mobile: json['mobile'] as String?,
    ext: json['extension'] as String?,
  );
}

Map<String, dynamic> _$NIMUserToJson(NIMUser instance) => <String, dynamic>{
      'userId': instance.userId,
      'nick': instance.nick,
      'signature': instance.sign,
      'avatar': instance.avatar,
      'gender': _$NIMUserGenderEnumEnumMap[instance.gender],
      'email': instance.email,
      'birthday': instance.birth,
      'mobile': instance.mobile,
      'extension': instance.ext,
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

const _$NIMUserGenderEnumEnumMap = {
  NIMUserGenderEnum.unknown: 'unknown',
  NIMUserGenderEnum.male: 'male',
  NIMUserGenderEnum.female: 'female',
};
