// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#ifdef _WIN32
#include "FLTAudioRecorderService.h"

#include "../FLTConvert.h"
#include "../NimResult.h"

FLTAudioRecorderService::FLTAudioRecorderService() {
  m_serviceName = "AudioRecorderService";
}

FLTAudioRecorderService::~FLTAudioRecorderService() {
  nim_audio::Audio::Cleanup();
}

void FLTAudioRecorderService::onMethodCalled(
    const std::string& method, const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!checkAudioRecordInit()) {
    result->Error("", "",
                  NimResult::getErrorResult(-1, "audioRecorder init failed"));
    return;
  }

  if (method == "startRecord") {
    startRecord(arguments, result);
  } else if (method == "stopRecord") {
    stopRecord(result);
  } else if (method == "cancelRecord") {
    cancelRecord(result);
  } else {
    result->NotImplemented();
  }
}

bool FLTAudioRecorderService::checkAudioRecordInit() {
  if (!m_init) {
    if (!nim_audio::Audio::Init(L"flutterWindows")) {
      return false;
    }
  }

  nim_audio::Audio::RegStartCaptureCb(
      &FLTAudioRecorderService::startCaptureCallback);
  nim_audio::Audio::RegStopCaptureCb(
      &FLTAudioRecorderService::stopCaptureCallback);
  nim_audio::Audio::RegCancelAudioCb(
      &FLTAudioRecorderService::cancelRecordCallback);
  return true;
}

void FLTAudioRecorderService::startRecord(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  nim_audio::nim_audio_type audioType;
  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("recordState")) {
    } else if (iter->first == flutter::EncodableValue("filePath")) {
    } else if (iter->first == flutter::EncodableValue("recordType")) {
      std::string strRecordType = std::get<std::string>(iter->second);
      Convert::getInstance()->convertDartStringToNIMEnum(
          strRecordType, Convert::getInstance()->getAudioOutputFormat(),
          audioType);
    } else if (iter->first == flutter::EncodableValue("fileSize")) {
      // 未使用
    } else if (iter->first == flutter::EncodableValue("duration")) {
      // 未使用
    } else if (iter->first == flutter::EncodableValue("maxDuration")) {
      // 未使用
    }
  }

  if (nim_audio::Audio::StartCapture("", "", audioType)) {
    result->Success(NimResult::getSuccessResult());
  } else {
    result->Error("", "", NimResult::getErrorResult(-1, "startRecord failed"));
  }
}

void FLTAudioRecorderService::stopRecord(
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (nim_audio::Audio::StopCapture()) {
    result->Success(NimResult::getSuccessResult());
  } else {
    result->Error("", "", NimResult::getErrorResult(-1, "stopRecord failed"));
  }
}

void FLTAudioRecorderService::cancelRecord(
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (nim_audio::Audio::CancelAudio(L"")) {
    result->Success(NimResult::getSuccessResult());
  } else {
    result->Error("", "", NimResult::getErrorResult(-1, "cancelRecord failed"));
  }
}

void FLTAudioRecorderService::startCaptureCallback(int code) {
  if (code == 200) {
    flutter::EncodableMap arguments;
    arguments.insert(std::make_pair("filePath", ""));
    FLTService::notifyEventEx("AudioRecorderService", "onRecordStart",
                              arguments);
  }
}

void FLTAudioRecorderService::stopCaptureCallback(
    int code, const char* call_id, const char* res_id, const char* file_path,
    const char* file_ext, long file_size, int audio_duration) {
  if (code == 200) {
    flutter::EncodableMap arguments;
    arguments.insert(std::make_pair("filePath", file_path));
    FLTService::notifyEventEx("AudioRecorderService", "onRecordSuccess",
                              arguments);
  }
}

void FLTAudioRecorderService::cancelRecordCallback(int code) {
  if (code == 200) {
    flutter::EncodableMap arguments;
    FLTService::notifyEventEx("AudioRecorderService", "onRecordCancel",
                              arguments);
  }
}
#endif
