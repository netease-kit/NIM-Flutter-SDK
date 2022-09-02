// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#include "FLTEventSubscribeService.h"

#include "../FLTConvert.h"
#include "nim_cpp_wrapper/api/nim_cpp_subscribe_event.h"

FLTEventSubscribeService::FLTEventSubscribeService() {
  m_serviceName = "EventSubscribeService";

  nim::SubscribeEvent::RegPushEventCb(
      std::bind(&FLTEventSubscribeService::pushEventCallback, this,
                std::placeholders::_1, std::placeholders::_2));
  nim::SubscribeEvent::RegBatchPushEventCb(
      std::bind(&FLTEventSubscribeService::batchPushEventCallback, this,
                std::placeholders::_1, std::placeholders::_2));
}

void FLTEventSubscribeService::onMethodCalled(
    const std::string& method, const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  std::cout << "method: " << method;

  if (method == "registerEventSubscribe") {
    registerEventSubscribe(arguments, result);
  } else if (method == "unregisterEventSubscribe") {
    unregisterEventSubscribe(arguments, result);
  } else if (method == "batchUnSubscribeEvent") {
    batchUnSubscribeEvent(arguments, result);
  } else if (method == "publishEvent") {
    publishEvent(arguments, result);
  } else if (method == "querySubscribeEvent") {
    querySubscribeEvent(arguments, result);
  } else {
    result->NotImplemented();
  }
}

void FLTEventSubscribeService::registerEventSubscribe(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  EventSubscribeRequest request = convertEventSubscribeRequest(arguments);
  bool res = nim::SubscribeEvent::Subscribe(
      request.event_type, request.ttl, request.sync_type, request.accid_list,
      [=](nim::NIMResCode res_code, int event_type,
          const std::list<std::string>& faild_list) {
        if (res_code == nim::kNIMResSuccess) {
          flutter::EncodableMap result_map;
          flutter::EncodableList userList_;
          for (auto user : faild_list) {
            userList_.emplace_back(user);
          }
          result_map.insert(
              std::make_pair("eventSubscribeResultList", userList_));
          result->Success(NimResult::getSuccessResult(result_map));
        } else {
          result->Error("", "",
                        NimResult::getErrorResult(
                            res_code, "registerEventSubscribe failed"));
        }
      });
  if (!res) {
    result->Error(
        "", "", NimResult::getErrorResult(-1, "registerEventSubscribe failed"));
  }
}
void FLTEventSubscribeService::unregisterEventSubscribe(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  EventSubscribeRequest request = convertEventSubscribeRequest(arguments);
  bool res = nim::SubscribeEvent::UnSubscribe(
      request.event_type, request.accid_list,
      [=](nim::NIMResCode res_code, int event_type,
          const std::list<std::string>& faild_list) {
        if (res_code == nim::kNIMResSuccess) {
          result->Success(NimResult::getSuccessResult());
        } else {
          result->Error("", "",
                        NimResult::getErrorResult(
                            res_code, "unregisterEventSubscribe failed"));
        }
      });
  if (!res) {
    result->Error(
        "", "",
        NimResult::getErrorResult(-1, "unregisterEventSubscribe failed"));
  }
}

void FLTEventSubscribeService::batchUnSubscribeEvent(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  EventSubscribeRequest request = convertEventSubscribeRequest(arguments);
  bool res = nim::SubscribeEvent::BatchUnSubscribe(
      request.event_type, [=](nim::NIMResCode res_code, int event_type) {
        if (res_code == nim::kNIMResSuccess) {
          result->Success(NimResult::getSuccessResult());
        } else {
          result->Error("", "",
                        NimResult::getErrorResult(
                            res_code, "batchUnSubscribeEvent failed"));
        }
      });

  if (!res) {
    result->Error(
        "", "", NimResult::getErrorResult(-1, "batchUnSubscribeEvent failed"));
  }
}
void FLTEventSubscribeService::publishEvent(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  nim::EventData data;
  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    std::cout << "arguments: " << std::get<std::string>(iter->first)
              << std::endl;
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("eventId")) {
      data.client_msg_id_ = std::get<std::string>(iter->second);
      std::cout << "data.client_msg_id_: " << data.client_msg_id_;
    } else if (iter->first == flutter::EncodableValue("eventType")) {
      data.event_type_ = std::get<int>(iter->second);
      std::cout << "data.event_type_: " << data.event_type_;
    } else if (iter->first == flutter::EncodableValue("eventValue")) {
      data.event_value_ = std::get<int>(iter->second);
      std::cout << "data.event_value_: " << data.event_value_;
    } else if (iter->first == flutter::EncodableValue("config")) {
      data.config_ = std::get<std::string>(iter->second);
      std::cout << "data.config_: " << data.config_;
    } else if (iter->first == flutter::EncodableValue("expiry")) {
      data.ttl_ = std::get<int>(iter->second);
      std::cout << "data.ttl_: " << data.ttl_;
    } else if (iter->first == flutter::EncodableValue("broadcastOnlineOnly")) {
      data.broadcast_type_ = std::get<bool>(iter->second)
                                 ? nim::kNIMEventBroadcastTypeOnline
                                 : nim::kNIMEventBroadcastTypeAll;
    } else if (iter->first == flutter::EncodableValue("syncSelfEnable")) {
      data.sync_self_ = std::get<bool>(iter->second)
                            ? nim::kNIMEventSyncTypeNoSelf
                            : nim::kNIMEventSyncTypeSelf;
    } else if (iter->first == flutter::EncodableValue("publisherAccount")) {
      data.readonly_publisher_accid_ = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("publishTime")) {
      data.readonly_event_time_ = std::get<int>(iter->second);
    } else if (iter->first == flutter::EncodableValue("publisherClientType")) {
      data.readonly_client_type_ = std::get<int>(iter->second);
    } else if (iter->first == flutter::EncodableValue("multiClientConfig")) {
      data.readonly_multi_config_ = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("multiClientConfigMap")) {
      // 只读字段，不处理
    } else if (iter->first == flutter::EncodableValue("nimConfig")) {
      data.readonly_nim_config_ = std::get<std::string>(iter->second);
    }
  }

  bool res = nim::SubscribeEvent::Publish(
      data, [=](nim::NIMResCode res_code, int event_type,
                const nim::EventData& event_data) {
        if (res_code == nim::kNIMResSuccess) {
          result->Success(NimResult::getSuccessResult());
        } else {
          result->Error(
              "", "",
              NimResult::getErrorResult(res_code, "publishEvent failed"));
        }
      });

  if (!res) {
    result->Error("", "", NimResult::getErrorResult(-1, "publishEvent failed"));
  }
}
void FLTEventSubscribeService::querySubscribeEvent(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  EventSubscribeRequest request = convertEventSubscribeRequest(arguments);
  bool res = nim::SubscribeEvent::QuerySubscribe(
      request.event_type, request.accid_list,
      [=](nim::NIMResCode res_code, int event_type,
          const std::list<nim::EventSubscribeData>& subscribe_list) {
        if (res_code == nim::kNIMResSuccess) {
          flutter::EncodableMap result_map;
          flutter::EncodableList subscribeList;
          for (auto subscribe : subscribe_list) {
            flutter::EncodableMap arguments;
            arguments.insert(
                std::make_pair("eventType", subscribe.event_type_));
            arguments.insert(
                std::make_pair("publisherAccount", subscribe.publisher_accid_));
            arguments.insert(std::make_pair("time", subscribe.subscribe_time_));
            arguments.insert(std::make_pair("expiry", subscribe.ttl_));
            subscribeList.emplace_back(arguments);
          }

          result_map.insert(
              std::make_pair("eventSubscribeResultList", subscribeList));
          result->Success(NimResult::getSuccessResult(result_map));
        } else {
          result->Error("", "",
                        NimResult::getErrorResult(
                            res_code, "querySubscribeEvent failed"));
        }
      });
  if (!res) {
    result->Error("", "",
                  NimResult::getErrorResult(-1, "querySubscribeEvent failed"));
  }
}

void FLTEventSubscribeService::pushEventCallback(
    nim::NIMResCode res_code, const nim::EventData& event_data) {
  // do nonthing
}

void FLTEventSubscribeService::batchPushEventCallback(
    nim::NIMResCode res_code, const std::list<nim::EventData>& event_list) {
  if (res_code == nim::kNIMResSuccess) {
    flutter::EncodableList eventList;
    for (auto event : event_list) {
      flutter::EncodableMap arguments;
      arguments.insert(std::make_pair("eventId", event.client_msg_id_));
      arguments.insert(std::make_pair("eventType", event.event_type_));
      arguments.insert(std::make_pair("eventValue", event.event_value_));
      arguments.insert(std::make_pair("config", event.config_));
      arguments.insert(std::make_pair("expiry", event.ttl_));
      arguments.insert(std::make_pair(
          "broadcastOnlineOnly",
          event.broadcast_type_ == nim::kNIMEventBroadcastTypeOnline));
      arguments.insert(std::make_pair(
          "syncSelfEnable", event.sync_self_ == nim::kNIMEventSyncTypeSelf));
      arguments.insert(
          std::make_pair("publisherAccount", event.readonly_publisher_accid_));
      arguments.insert(
          std::make_pair("publishTime", event.readonly_event_time_));
      arguments.insert(
          std::make_pair("publisherClientType", event.readonly_client_type_));
      arguments.insert(
          std::make_pair("multiClientConfig", event.readonly_multi_config_));
      flutter::EncodableMap multiClientConfigMap;
      nim_cpp_wrapper_util::Json::Value values =
          Convert::getInstance()->getJsonValueFromJsonString(
              event.readonly_multi_config_);
      Convert::getInstance()->convertJson2Map(multiClientConfigMap, values);
      arguments.insert(
          std::make_pair("multiClientConfigMap", multiClientConfigMap));
      arguments.insert(std::make_pair("nimConfig", event.readonly_nim_config_));
      eventList.emplace_back(arguments);
    }
    flutter::EncodableMap arguments_;
    arguments_.insert(std::make_pair("eventList", eventList));
    notifyEvent("observeEventChanged", arguments_);
  }
}

EventSubscribeRequest FLTEventSubscribeService::convertEventSubscribeRequest(
    const flutter::EncodableMap* arguments) {
  EventSubscribeRequest request;
  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("eventType")) {
      request.event_type = std::get<int>(iter->second);
    } else if (iter->first == flutter::EncodableValue("expiry")) {
      request.ttl = iter->second.LongValue();
    } else if (iter->first == flutter::EncodableValue("syncCurrentValue")) {
      request.sync_type = std::get<bool>(iter->second)
                              ? nim::kNIMEventSubscribeSyncTypeSync
                              : nim::kNIMEventSubscribeSyncTypeUnSync;
    } else if (iter->first == flutter::EncodableValue("publishers")) {
      flutter::EncodableList userList =
          std::get<flutter::EncodableList>(iter->second);
      for (auto user : userList) {
        std::string accid = std::get<std::string>(user);
        request.accid_list.emplace_back(accid);
      }
    }
  }
  return request;
}