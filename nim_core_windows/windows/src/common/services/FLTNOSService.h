// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#ifndef FLTNOSSERVICE_H
#define FLTNOSSERVICE_H

#include "../FLTService.h"
class FLTNOSService : public FLTService {
 public:
  FLTNOSService();
  virtual void onMethodCalled(
      const std::string& method, const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result)
      override;

 private:
  void upload(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void download(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

 private:
  void uploadMediaCallback(nim::NIMResCode res_code, const std::string& url);
  void progressCallback(int64_t completed_size, int64_t file_size);
  void speedCallback(int64_t speed);
  void transferInfoCallback(int64_t actual_size, int64_t speed);
  void downloadMediaExCallback(nim::NIMResCode res_code,
                               const nim::DownloadMediaResult& result);

 private:
  std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>
      m_uploadResult;
};

#endif  // FLTNOSSERVICE_H