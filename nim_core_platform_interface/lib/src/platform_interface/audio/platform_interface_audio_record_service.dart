// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:nim_core_platform_interface/src/method_channel/method_channel_audio_record_service.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import '../../../nim_core_platform_interface.dart';

abstract class AudioRecordServicePlatform extends Service {
  AudioRecordServicePlatform() : super(token: _token);
  static final Object _token = Object();

  static AudioRecordServicePlatform _instance = MethodChannelAudioService();

  static AudioRecordServicePlatform get instance => _instance;

  static set instance(AudioRecordServicePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  // ignore: close_sinks, never closed
  final StreamController<RecordInfo> onAudioRecordStatus =
      StreamController<RecordInfo>.broadcast();

  Future<NIMResult<bool>> startAudioRecord(
      AudioOutputFormat recordType, int maxLength) async {
    throw UnimplementedError('startAudioRecord() is not implemented');
  }

  Future<NIMResult<bool>> stopAudioRecord() async {
    throw UnimplementedError('stopAudioRecord() is not implemented');
  }

  Future<NIMResult<bool>> cancelAudioRecord() async {
    throw UnimplementedError('cancelAudioRecord() is not implemented');
  }

  Future<NIMResult<bool>> isAudioRecording() async {
    throw UnimplementedError('isAudioRecording() is not implemented');
  }

  Future<NIMResult<int>> getAmplitude() async {
    throw UnimplementedError('getAmplitude() is not implemented');
  }
}
