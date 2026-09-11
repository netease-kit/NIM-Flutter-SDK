// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#ifndef FLTSubscriptionService_H
#define FLTSubscriptionService_H

#include "../FLTService.h"
#include "v2_nim_api.hpp"
#include "v2_nim_def_struct.hpp"
#include "v2_nim_message_service.hpp"
#include "v2_nim_notification_service.hpp"

v2::V2NIMSubscribeUserStatusOption getSubscribeUserStatusOption(
    const flutter::EncodableMap* arguments);

v2::V2NIMUnsubscribeUserStatusOption getUnsubscribeUserStatusOption(
    const flutter::EncodableMap* arguments);

v2::V2NIMCustomUserStatusParams getCustomUserStatusParams(
    const flutter::EncodableMap* arguments);

flutter::EncodableMap convertCustomUserStatusPublishResult(
    const v2::V2NIMCustomUserStatusPublishResult object);

flutter::EncodableMap convertUserStatusSubscribeResult(
    const v2::V2NIMUserStatusSubscribeResult object);

flutter::EncodableMap convertUserStatus(const v2::V2NIMUserStatus object);

class FLTSubscriptionService : public FLTService {
 public:
  FLTSubscriptionService();
  virtual ~FLTSubscriptionService();
  virtual void onMethodCalled(
      const std::string& method, const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result)
      override;

 private:
  void subscribeUserStatus(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

  void unsubscribeUserStatus(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

  void publishCustomUserStatus(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

  void queryUserStatusSubscriptions(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

 private:
  v2::V2NIMSubscribeListener listener;
};

#endif  // FLTSubscriptionService_H
