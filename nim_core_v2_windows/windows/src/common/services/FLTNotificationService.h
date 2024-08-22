// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#ifndef FLTNotificationService_H
#define FLTNotificationService_H

#include "../FLTService.h"
#include "../NimResult.h"
#include "FLTMessageService.h"
#include "nim_cpp_wrapper/nim_cpp_api.h"
#include "v2_nim_api.hpp"
#include "v2_nim_def_struct.hpp"
#include "v2_nim_login_service.hpp"

v2::V2NIMSendCustomNotificationParams getSendCustomNotificationParams(
    const flutter::EncodableMap* arguments);
flutter::EncodableMap convertSendCustomNotificationParams(
    const v2::V2NIMSendCustomNotificationParams object);
v2::V2NIMCustomNotification getCustomNotification(
    const flutter::EncodableMap* arguments);
flutter::EncodableMap convertCustomNotification(
    const v2::V2NIMCustomNotification object);
v2::V2NIMBroadcastNotification getBroadcastNotification(
    const flutter::EncodableMap* arguments);
flutter::EncodableMap convertBroadcastNotification(
    const v2::V2NIMBroadcastNotification object);

class FLTNotificationService : public FLTService {
 public:
  FLTNotificationService();
  virtual ~FLTNotificationService();
  virtual void onMethodCalled(
      const std::string& method, const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result)
      override;

 private:
  void sendCustomNotification(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

 private:
  v2::V2NIMNotificationListener listener;
};

#endif  // FLTNotificationService_H
