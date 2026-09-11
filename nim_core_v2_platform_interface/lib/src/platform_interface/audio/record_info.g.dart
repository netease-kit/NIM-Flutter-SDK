// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecordInfo _$RecordInfoFromJson(Map<String, dynamic> json) => RecordInfo(
      recordState: $enumDecode(_$RecordStateEnumMap, json['recordState']),
      filePath: json['filePath'] as String?,
      fileSize: (json['fileSize'] as num?)?.toInt(),
      recordType:
          $enumDecodeNullable(_$AudioOutputFormatEnumMap, json['recordType']),
      duration: (json['duration'] as num?)?.toInt(),
      maxDuration: (json['maxDuration'] as num?)?.toInt(),
    );

Map<String, dynamic> _$RecordInfoToJson(RecordInfo instance) =>
    <String, dynamic>{
      'recordState': _$RecordStateEnumMap[instance.recordState]!,
      'filePath': instance.filePath,
      'recordType': _$AudioOutputFormatEnumMap[instance.recordType],
      'fileSize': instance.fileSize,
      'duration': instance.duration,
      'maxDuration': instance.maxDuration,
    };

const _$RecordStateEnumMap = {
  RecordState.READY: 'READY',
  RecordState.START: 'START',
  RecordState.REACHED_MAX: 'REACHED_MAX',
  RecordState.SUCCESS: 'SUCCESS',
  RecordState.FAIL: 'FAIL',
  RecordState.CANCEL: 'CANCEL',
};

const _$AudioOutputFormatEnumMap = {
  AudioOutputFormat.AAC: 'AAC',
  AudioOutputFormat.AMR: 'AMR',
};
