// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecordInfo _$RecordInfoFromJson(Map<String, dynamic> json) {
  return RecordInfo(
    recordState: _$enumDecode(_$RecordStateEnumMap, json['recordState']),
    filePath: json['filePath'] as String?,
    fileSize: json['fileSize'] as int?,
    recordType:
        _$enumDecodeNullable(_$AudioOutputFormatEnumMap, json['recordType']),
    duration: json['duration'] as int?,
    maxDuration: json['maxDuration'] as int?,
  );
}

Map<String, dynamic> _$RecordInfoToJson(RecordInfo instance) =>
    <String, dynamic>{
      'recordState': _$RecordStateEnumMap[instance.recordState],
      'filePath': instance.filePath,
      'recordType': _$AudioOutputFormatEnumMap[instance.recordType],
      'fileSize': instance.fileSize,
      'duration': instance.duration,
      'maxDuration': instance.maxDuration,
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

const _$RecordStateEnumMap = {
  RecordState.READY: 'READY',
  RecordState.START: 'START',
  RecordState.REACHED_MAX: 'REACHED_MAX',
  RecordState.SUCCESS: 'SUCCESS',
  RecordState.FAIL: 'FAIL',
  RecordState.CANCEL: 'CANCEL',
};

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

const _$AudioOutputFormatEnumMap = {
  AudioOutputFormat.AAC: 'AAC',
  AudioOutputFormat.AMR: 'AMR',
};
