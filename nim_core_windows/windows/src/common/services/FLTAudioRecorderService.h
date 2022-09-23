// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#ifndef FLTAUDIORECORDERSERVICE_H
#define FLTAUDIORECORDERSERVICE_H

#include "../FLTService.h"
class FLTAudioRecorderService : public FLTService {
 public:
  FLTAudioRecorderService();
  virtual ~FLTAudioRecorderService();
  virtual void onMethodCalled(
      const std::string& method, const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result)
      override;

 private:
  void startRecord(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void stopRecord(
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void cancelRecord(
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  bool checkAudioRecordInit();

 private:
  static void startCaptureCallback(int code);
  static void stopCaptureCallback(int code, const char* call_id,
                                  const char* res_id, const char* file_path,
                                  const char* file_ext, long file_size,
                                  int audio_duration);
  static void cancelRecordCallback(int code);

 private:
  bool m_init = false;
};

#endif  // FLTAUDIORECORDERSERVICE_H
