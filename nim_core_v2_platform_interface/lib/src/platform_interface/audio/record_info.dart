// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:json_annotation/json_annotation.dart';

part 'record_info.g.dart';

@JsonSerializable()
class RecordInfo {
  final RecordState recordState;
  final String? filePath;
  final AudioOutputFormat? recordType;
  final int? fileSize;
  final int? duration;
  final int? maxDuration;

  const RecordInfo(
      {required this.recordState,
      required this.filePath,
      this.fileSize,
      required this.recordType,
      this.duration,
      this.maxDuration});

  factory RecordInfo.fromJson(Map<String, dynamic> map) {
    AudioOutputFormat format = map["recordType"] == ".amr"
        ? AudioOutputFormat.AMR
        : AudioOutputFormat.AAC;
    return RecordInfo(
        recordState: covertState(map["recordState"]),
        filePath: map["filePath"],
        fileSize: map["fileSize"],
        recordType: format,
        duration: map["duration"],
        maxDuration: map["maxDuration"]);
  }

  static RecordState covertState(String state) {
    RecordState recordState = RecordState.READY;
    switch (state) {
      case "onRecordReady":
        recordState = RecordState.READY;
        break;
      case "onRecordStart":
        recordState = RecordState.START;
        break;
      case "onRecordSuccess":
        recordState = RecordState.SUCCESS;
        break;
      case "onRecordFail":
        recordState = RecordState.FAIL;
        break;
      case "onRecordCancel":
        recordState = RecordState.CANCEL;
        break;
      case "onRecordReachedMaxTime":
        recordState = RecordState.REACHED_MAX;
        break;
    }
    return recordState;
  }
}

enum AudioOutputFormat { AAC, AMR }

enum RecordState { READY, START, REACHED_MAX, SUCCESS, FAIL, CANCEL }
