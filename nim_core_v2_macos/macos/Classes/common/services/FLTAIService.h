// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#ifndef FLTAIService_H
#define FLTAIService_H

#include "../FLTService.h"
#include "v2_nim_api.hpp"
#include "v2_nim_def_struct.hpp"
#include "v2_nim_message_service.hpp"
#include "v2_nim_notification_service.hpp"

class FLTAIService : public FLTService {
 public:
  FLTAIService();
  virtual ~FLTAIService();
  virtual void onMethodCalled(
      const std::string& method, const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result)
      override;

 private:
  void getAIUserList(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

  void proxyAIModelCall(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

 private:
  v2::V2NIMAIListener listener;
};

#endif  // FLTAIService_H
