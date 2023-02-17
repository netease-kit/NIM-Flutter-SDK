// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

part of nim_core;

class AudioService {
  factory AudioService() {
    if (_singleton == null) {
      _singleton = AudioService._();
    }
    return _singleton!;
  }

  AudioService._();

  static AudioService? _singleton;

  AudioRecordServicePlatform get _platform =>
      AudioRecordServicePlatform.instance;

  Stream<RecordInfo> get onAudioRecordStatus =>
      AudioRecordServicePlatform.instance.onAudioRecordStatus.stream;

  ///开始录制，支持参数设置录音格式和最大录音长度，默认为AAC和120s
  Future<NIMResult<bool>> startRecord(
      AudioOutputFormat recordType, int maxDuration) async {
    return _platform.startAudioRecord(recordType, maxDuration);
  }

  Future<NIMResult<bool>> stopRecord() async {
    return _platform.stopAudioRecord();
  }

  Future<NIMResult<bool>> cancelRecord() async {
    return _platform.cancelAudioRecord();
  }

  Future<NIMResult<bool>> isAudioRecording() async {
    return _platform.isAudioRecording();
  }

  Future<NIMResult<int>> getAmplitude() async {
    return _platform.getAmplitude();
  }
}
