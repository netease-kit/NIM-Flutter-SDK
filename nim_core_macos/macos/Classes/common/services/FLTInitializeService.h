// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#ifndef FLTINITIALIZESERVICE_H
#define FLTINITIALIZESERVICE_H

#include "../FLTService.h"

class FLTInitializeService : public FLTService {
 public:
  FLTInitializeService();
  virtual void onMethodCalled(
      const std::string& method, const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result)
      override;

 private:
  void initializeSDK(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

 private:
  std::string m_appKey;
  bool m_init = false;
};

#endif  // FLTINITIALIZESERVICE_H