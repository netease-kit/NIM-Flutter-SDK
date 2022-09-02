// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#ifndef FLTEVENTSUBSCRIBESERVICE_H
#define FLTEVENTSUBSCRIBESERVICE_H

#include "../FLTService.h"

typedef struct tagEventSubscribeRequest {
  int event_type = 0;
  int64_t ttl = 0;
  nim::NIMEventSubscribeSyncEventType sync_type;
  std::list<std::string> accid_list;
} EventSubscribeRequest;

class FLTEventSubscribeService : public FLTService {
 public:
  FLTEventSubscribeService();
  virtual void onMethodCalled(
      const std::string& method, const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result)
      override;

 private:
  void registerEventSubscribe(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void unregisterEventSubscribe(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void batchUnSubscribeEvent(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void publishEvent(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void querySubscribeEvent(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  EventSubscribeRequest convertEventSubscribeRequest(
      const flutter::EncodableMap* arguments);

 private:
  void pushEventCallback(nim::NIMResCode res_code,
                         const nim::EventData& event_data);
  void batchPushEventCallback(nim::NIMResCode res_code,
                              const std::list<nim::EventData>& event_list);
};

#endif  // FLTEVENTSUBSCRIBESERVICE_H