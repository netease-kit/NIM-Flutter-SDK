// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#include "FLTNotificationService.h"

using namespace nim;

FLTNotificationService::FLTNotificationService() {
  m_serviceName = "NotificationService";

  listener.onReceiveCustomNotifications =
      [this](nstd::vector<v2::V2NIMCustomNotification> customNotifications) {
        // handle custom notifications

        flutter::EncodableList customNotificationList;
        for (auto customNotification : customNotifications) {
          customNotificationList.emplace_back(
              convertCustomNotification(customNotification));
        }
        flutter::EncodableMap resultMap;
        resultMap.insert(
            std::make_pair("customNotifications", customNotificationList));
        notifyEvent("onReceiveCustomNotifications", resultMap);
      };

  listener.onReceiveBroadcastNotifications =
      [this](
          nstd::vector<v2::V2NIMBroadcastNotification> broadcastNotifications) {
        // handle broadcast notifications

        flutter::EncodableList broadcastNotificationList;
        for (auto broadcastNotification : broadcastNotifications) {
          broadcastNotificationList.emplace_back(
              convertBroadcastNotification(broadcastNotification));
        }
        flutter::EncodableMap resultMap;
        resultMap.insert(std::make_pair("broadcastNotifications",
                                        broadcastNotificationList));
        notifyEvent("onReceiveBroadcastNotifications", resultMap);
      };

  auto& client = v2::V2NIMClient::get();
  auto& notificationService = client.getNotificationService();

  notificationService.addNotificationListener(listener);
}

FLTNotificationService::~FLTNotificationService() {
  auto& client = v2::V2NIMClient::get();
  auto& notificationService = client.getNotificationService();

  notificationService.removeNotificationListener(listener);
}

void FLTNotificationService::onMethodCalled(
    const std::string& method, const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  switch (utils::hash_(method.c_str())) {
    case "sendCustomNotification"_hash:
      sendCustomNotification(arguments, result);
      return;

    default:
      break;
  }
  if (result) result->NotImplemented();
}

void FLTNotificationService::sendCustomNotification(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  std::string conversationId = "";
  std::string content = "";
  v2::V2NIMSendCustomNotificationParams params;

  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("conversationId")) {
      conversationId = std::get<std::string>(iter->second);
      std::cout << "conversationId: " << conversationId << std::endl;
    } else if (iter->first == flutter::EncodableValue("content")) {
      content = std::get<std::string>(iter->second);
      std::cout << "content: " << content << std::endl;
    } else if (iter->first == flutter::EncodableValue("params")) {
      auto paramsMap = std::get<flutter::EncodableMap>(iter->second);
      params = getSendCustomNotificationParams(&paramsMap);
    }
  }

  auto& instance = v2::V2NIMClient::get();
  auto& notificationService = instance.getNotificationService();
  notificationService.sendCustomNotification(
      conversationId, content, params,
      [result]() { result->Success(NimResult::getSuccessResult()); },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

v2::V2NIMSendCustomNotificationParams getSendCustomNotificationParams(
    const flutter::EncodableMap* arguments) {
  v2::V2NIMSendCustomNotificationParams object;
  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("notificationConfig")) {
      auto notificationConfigMap =
          std::get<flutter::EncodableMap>(iter->second);
      object.notificationConfig = getNotificationConfig(&notificationConfigMap);
    } else if (iter->first == flutter::EncodableValue("pushConfig")) {
      auto pushConfigMap = std::get<flutter::EncodableMap>(iter->second);
      object.pushConfig = getNotificationPushConfig(&pushConfigMap);
    } else if (iter->first == flutter::EncodableValue("antispamConfig")) {
      auto antispamConfigMap = std::get<flutter::EncodableMap>(iter->second);
      object.antispamConfig = getNotificationAntispamConfig(&antispamConfigMap);
    } else if (iter->first == flutter::EncodableValue("routeConfig")) {
      auto routeConfigMap = std::get<flutter::EncodableMap>(iter->second);
      object.routeConfig = getNotificationRouteConfig(&routeConfigMap);
    }
  }
  return object;
}

flutter::EncodableMap convertSendCustomNotificationParams(
    const v2::V2NIMSendCustomNotificationParams object) {
  flutter::EncodableMap resultMap;
  flutter::EncodableMap notificationConfig =
      convertNotificationConfig(object.notificationConfig);
  resultMap.insert(std::make_pair("notificationConfig", notificationConfig));

  flutter::EncodableMap pushConfig =
      convertNotificationPushConfig(object.pushConfig);
  resultMap.insert(std::make_pair("pushConfig", pushConfig));

  flutter::EncodableMap antispamConfig =
      convertNotificationAntispamConfig(object.antispamConfig);
  resultMap.insert(std::make_pair("antispamConfig", antispamConfig));

  flutter::EncodableMap routeConfig =
      convertNotificationRouteConfig(object.routeConfig);
  resultMap.insert(std::make_pair("routeConfig", routeConfig));
  return resultMap;
}

v2::V2NIMCustomNotification getCustomNotification(
    const flutter::EncodableMap* arguments) {
  v2::V2NIMCustomNotification object;
  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("senderId")) {
      object.senderId = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("receiverId")) {
      object.receiverId = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("conversationType")) {
      object.conversationType =
          v2::V2NIMConversationType(std::get<int>(iter->second));
    } else if (iter->first == flutter::EncodableValue("timestamp")) {
      auto timestamp = iter->second.LongValue();
      object.timestamp = timestamp;
    } else if (iter->first == flutter::EncodableValue("content")) {
      object.content = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("notificationConfig")) {
      auto notificationConfigMap =
          std::get<flutter::EncodableMap>(iter->second);
      object.notificationConfig = getNotificationConfig(&notificationConfigMap);
    } else if (iter->first == flutter::EncodableValue("pushConfig")) {
      auto pushConfigMap = std::get<flutter::EncodableMap>(iter->second);
      object.pushConfig = getNotificationPushConfig(&pushConfigMap);
    } else if (iter->first == flutter::EncodableValue("antispamConfig")) {
      auto antispamConfigMap = std::get<flutter::EncodableMap>(iter->second);
      object.antispamConfig = getNotificationAntispamConfig(&antispamConfigMap);
    } else if (iter->first == flutter::EncodableValue("routeConfig")) {
      auto routeConfigMap = std::get<flutter::EncodableMap>(iter->second);
      object.routeConfig = getNotificationRouteConfig(&routeConfigMap);
    }
  }
  return object;
}

flutter::EncodableMap convertCustomNotification(
    const v2::V2NIMCustomNotification object) {
  flutter::EncodableMap resultMap;

  resultMap.insert(std::make_pair("senderId", object.senderId));
  resultMap.insert(std::make_pair("receiverId", object.receiverId));
  resultMap.insert(std::make_pair("conversationType", object.conversationType));
  resultMap.insert(
      std::make_pair("timestamp", static_cast<int64_t>(object.timestamp)));
  resultMap.insert(std::make_pair("content", object.content));

  flutter::EncodableMap notificationConfig =
      convertNotificationConfig(object.notificationConfig);
  resultMap.insert(std::make_pair("notificationConfig", notificationConfig));

  flutter::EncodableMap pushConfig =
      convertNotificationPushConfig(object.pushConfig);
  resultMap.insert(std::make_pair("pushConfig", pushConfig));

  flutter::EncodableMap antispamConfig =
      convertNotificationAntispamConfig(object.antispamConfig);
  resultMap.insert(std::make_pair("antispamConfig", antispamConfig));

  flutter::EncodableMap routeConfig =
      convertNotificationRouteConfig(object.routeConfig);
  resultMap.insert(std::make_pair("routeConfig", routeConfig));
  return resultMap;
}

v2::V2NIMBroadcastNotification getBroadcastNotification(
    const flutter::EncodableMap* arguments) {
  v2::V2NIMBroadcastNotification object;
  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("id")) {
      auto id = iter->second.LongValue();
      object.id = id;
    } else if (iter->first == flutter::EncodableValue("senderId")) {
      object.senderId = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("timestamp")) {
      auto timestamp = iter->second.LongValue();
      object.timestamp = timestamp;
    } else if (iter->first == flutter::EncodableValue("content")) {
      object.content = std::get<std::string>(iter->second);
    }
  }
  return object;
}

flutter::EncodableMap convertBroadcastNotification(
    const v2::V2NIMBroadcastNotification object) {
  flutter::EncodableMap resultMap;

  resultMap.insert(std::make_pair("id", static_cast<int64_t>(object.id)));
  resultMap.insert(std::make_pair("senderId", object.senderId));
  resultMap.insert(
      std::make_pair("timestamp", static_cast<int64_t>(object.timestamp)));
  resultMap.insert(std::make_pair("content", object.content));
  return resultMap;
}