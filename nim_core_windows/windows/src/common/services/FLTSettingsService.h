// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#ifndef FLTSETTINGSSERVICE_H
#define FLTSETTINGSSERVICE_H

#include "../FLTService.h"

class FLTSettingsService : public FLTService {
 public:
  FLTSettingsService();
  virtual ~FLTSettingsService();
  virtual void onMethodCalled(
      const std::string& method, const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result)
      override;

 private:
  DECLARE_FUN(getSizeOfDirCache);
  DECLARE_FUN(clearDirCache);
  DECLARE_FUN(uploadLogs);

 private:
  void SDKDBError(const nim::Global::SDKDBErrorInfo& error_info);
};

#endif  // FLTSettingsService
