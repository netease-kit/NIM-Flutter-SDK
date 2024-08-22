// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NIMNOSTransferProgress _$NIMNOSTransferProgressFromJson(
    Map<String, dynamic> json) {
  return NIMNOSTransferProgress(
    key: json['key'] as String,
    transferred: json['transferred'] as int?,
    total: json['total'] as int?,
  );
}

Map<String, dynamic> _$NIMNOSTransferProgressToJson(
        NIMNOSTransferProgress instance) =>
    <String, dynamic>{
      'key': instance.key,
      'transferred': instance.transferred,
      'total': instance.total,
    };

NIMNOSTransferStatus _$NIMNOSTransferStatusFromJson(Map<String, dynamic> json) {
  return NIMNOSTransferStatus(
    transferType:
        _$enumDecodeNullable(_$NIMNOSTransferTypeEnumMap, json['transferType']),
    path: json['path'] as String?,
    md5: json['md5'] as String?,
    url: json['url'] as String?,
    size: json['size'] as int?,
    status: _$enumDecodeNullable(_$NIMNosTransferStatusEnumMap, json['status']),
    extension: json['extension'] as String?,
  );
}

Map<String, dynamic> _$NIMNOSTransferStatusToJson(
        NIMNOSTransferStatus instance) =>
    <String, dynamic>{
      'transferType': _$NIMNOSTransferTypeEnumMap[instance.transferType],
      'path': instance.path,
      'md5': instance.md5,
      'url': instance.url,
      'size': instance.size,
      'status': _$NIMNosTransferStatusEnumMap[instance.status],
      'extension': instance.extension,
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

const _$NIMNOSTransferTypeEnumMap = {
  NIMNOSTransferType.upload: 'upload',
  NIMNOSTransferType.download: 'download',
};

const _$NIMNosTransferStatusEnumMap = {
  NIMNosTransferStatus.def: 'def',
  NIMNosTransferStatus.transferring: 'transferring',
  NIMNosTransferStatus.transferred: 'transferred',
  NIMNosTransferStatus.fail: 'fail',
};
