// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#include "FLTChatroomQueueService.h"

#include <sstream>

#include "../FLTService.h"
#include "flutter/encodable_value.h"
#include "v2_nim_api.hpp"
#include "v2_nim_def_callback.hpp"
#include "v2_nim_def_enum.hpp"
#include "v2_nim_def_struct.hpp"

flutter::EncodableMap convertChatroomQueueElementToEncodableMap(
    const v2::V2NIMChatroomQueueElement& element);

v2::V2NIMChatroomQueueElement convertToQueueElement(
    const flutter::EncodableMap* map);

flutter::EncodableList convertToEncodableList(
    const std::vector<v2::V2NIMChatroomQueueElement>& elements);
v2::V2NIMChatroomQueueListener createQueueListener(const int32_t instanceId);

v2::V2NIMChatroomQueueOfferParams convertToQueueOfferParams(
    const flutter::EncodableMap* params);
//
template <typename T>
T GetValueOrDefault(const flutter::EncodableMap* map, const std::string& key,
                    const T& defaultValue) {
  if (!map) return defaultValue;

  auto iter = map->find(flutter::EncodableValue(key));
  if (iter == map->end() || iter->second.IsNull()) {
    return defaultValue;
  }

  // 根据类型进行不同的处理
  if constexpr (std::is_same_v<T, std::string>) {
    return std::get<std::string>(iter->second);
  } else if constexpr (std::is_same_v<T, int32_t> ||
                       std::is_same_v<T, uint32_t>) {
    return static_cast<T>(std::get<int32_t>(iter->second));
  } else if constexpr (std::is_same_v<T, int64_t>) {
    return static_cast<T>(std::get<int64_t>(iter->second));
  } else if constexpr (std::is_same_v<T, bool>) {
    return std::get<bool>(iter->second);
  } else if constexpr (std::is_same_v<T, double>) {
    return std::get<double>(iter->second);
  } else {
    return defaultValue;
  }
}

FLTChatroomQueueService::FLTChatroomQueueService() {
  m_serviceName = "V2NIMChatroomQueueService";
}

FLTChatroomQueueService::~FLTChatroomQueueService() {}

void FLTChatroomQueueService::onMethodCalled(
    const std::string& method, const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (method == "queueInit") {
    queueInit(arguments, result);
  } else if (method == "queueDrop") {
    queueDrop(arguments, result);
  } else if (method == "queueOffer") {
    queueOffer(arguments, result);
  } else if (method == "queuePoll") {
    queuePoll(arguments, result);
  } else if (method == "queuePeek") {
    queuePeek(arguments, result);
  } else if (method == "queueList") {
    queueList(arguments, result);
  } else if (method == "queueBatchUpdate") {
    queueBatchUpdate(arguments, result);
  } else if (method == "addQueueListener") {
    addQueueListener(arguments, result);
  } else if (method == "removeQueueListener") {
    removeQueueListener(arguments, result);
  } else {
    result->NotImplemented();
  }
}

// 初始化队列
void FLTChatroomQueueService::queueInit(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  uint32_t instanceId = 0;
  uint32_t size = 0;
  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) continue;
    if (iter->first == flutter::EncodableValue("instanceId")) {
      instanceId = std::get<int32_t>(iter->second);
    } else if (iter->first == flutter::EncodableValue("size")) {
      size = std::get<int32_t>(iter->second);
    }
  }
  auto client = v2::V2NIMChatroomClient::getInstance(instanceId);
  if (!client) {
    return result->Error("199414", "Invalid chatroomService instanceId");
  }
  client->getChatroomQueueService().queueInit(
      size, [result]() { result->Success(NimResult::getSuccessResult()); },
      [result](const v2::V2NIMError& error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

// 清空队列
void FLTChatroomQueueService::queueDrop(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  uint32_t instanceId = GetValueOrDefault<uint32_t>(arguments, "instanceId", 0);
  auto client = v2::V2NIMChatroomClient::getInstance(instanceId);
  if (!client) {
    return result->Error("199414", "Invalid chatroomService instanceId");
  }
  client->getChatroomQueueService().queueDrop(
      [result]() { result->Success(NimResult::getSuccessResult()); },
      [result](const v2::V2NIMError& error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

// 入队
void FLTChatroomQueueService::queueOffer(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  v2::V2NIMChatroomQueueOfferParams offParams;
  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("offerParams")) {
      auto paramsMap = std::get<flutter::EncodableMap>(iter->second);
      offParams = convertToQueueOfferParams(&paramsMap);
    }
  }

  uint32_t instanceId = GetValueOrDefault<uint32_t>(arguments, "instanceId", 0);
  auto client = v2::V2NIMChatroomClient::getInstance(instanceId);
  if (!client) {
    return result->Error("199414", "Invalid chatroomService instanceId");
  }
  client->getChatroomQueueService().queueOffer(
      offParams, [result]() { result->Success(NimResult::getSuccessResult()); },
      [result](const v2::V2NIMError& error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

// 出队
void FLTChatroomQueueService::queuePoll(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  std::string elementKey =
      GetValueOrDefault<std::string>(arguments, "elementKey", "");

  uint32_t instanceId = GetValueOrDefault<uint32_t>(arguments, "instanceId", 0);
  auto client = v2::V2NIMChatroomClient::getInstance(instanceId);
  if (!client) {
    return result->Error("199414", "Invalid chatroomService instanceId");
  }
  client->getChatroomQueueService().queuePoll(
      elementKey,
      [result](const v2::V2NIMChatroomQueueElement& element) {
        flutter::EncodableMap resultMap =
            convertChatroomQueueElementToEncodableMap(element);
        result->Success(NimResult::getSuccessResult(resultMap));
      },
      [result](const v2::V2NIMError& error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

// 查看队首元素
void FLTChatroomQueueService::queuePeek(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  uint32_t instanceId = GetValueOrDefault<uint32_t>(arguments, "instanceId", 0);
  auto client = v2::V2NIMChatroomClient::getInstance(instanceId);
  if (!client) {
    return result->Error("199414", "Invalid chatroomService instanceId");
  }
  client->getChatroomQueueService().queuePeek(
      [result](const v2::V2NIMChatroomQueueElement& element) {
        flutter::EncodableMap resultMap =
            convertChatroomQueueElementToEncodableMap(element);
        result->Success(NimResult::getSuccessResult(resultMap));
      },
      [result](const v2::V2NIMError& error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

// 获取队列列表
void FLTChatroomQueueService::queueList(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  uint32_t instanceId = GetValueOrDefault<uint32_t>(arguments, "instanceId", 0);
  auto client = v2::V2NIMChatroomClient::getInstance(instanceId);
  if (!client) {
    return result->Error("199414", "Invalid chatroomService instanceId");
  }
  client->getChatroomQueueService().queueList(
      [result](const std::vector<v2::V2NIMChatroomQueueElement>& elements) {
        flutter::EncodableList resultList;
        flutter::EncodableMap resultMapData;
        for (const auto& element : elements) {
          flutter::EncodableMap elementMap =
              convertChatroomQueueElementToEncodableMap(element);
          resultList.emplace_back(elementMap);
        }
        resultMapData.insert(
            std::make_pair("elements", flutter::EncodableValue(resultList)));
        result->Success(NimResult::getSuccessResult(resultMapData));
      },
      [result](const v2::V2NIMError& error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

// 批量更新队列
void FLTChatroomQueueService::queueBatchUpdate(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  bool notificationEnabled;
  std::string notificationExtension;
  std::vector<v2::V2NIMChatroomQueueElement> elements;
  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("notificationEnabled")) {
      notificationEnabled = std::get<bool>(iter->second);
    } else if (iter->first == flutter::EncodableValue("elements")) {
      auto elementsList = std::get<flutter::EncodableList>(iter->second);
      for (const auto& elementValue : elementsList) {
        auto elementMap = std::get<flutter::EncodableMap>(elementValue);

        v2::V2NIMChatroomQueueElement element =
            convertToQueueElement(&elementMap);
        elements.push_back(element);
      }
    } else if (iter->first ==
               flutter::EncodableValue("notificationExtension")) {
      notificationExtension = std::get<std::string>(iter->second);
    }
  }

  uint32_t instanceId = GetValueOrDefault<uint32_t>(arguments, "instanceId", 0);
  auto client = v2::V2NIMChatroomClient::getInstance(instanceId);
  if (!client) {
    return result->Error("199414", "Invalid chatroomService instanceId");
  }
  client->getChatroomQueueService().queueBatchUpdate(
      elements, notificationEnabled, notificationExtension,
      [result](const std::vector<std::string>& failedKeys) {
        flutter::EncodableList failedKeysList;
        flutter::EncodableMap resultMapData;
        for (const auto& key : failedKeys) {
          failedKeysList.push_back(flutter::EncodableValue(key));
        }
        resultMapData.insert(std::make_pair(
            "notExistKeys", flutter::EncodableValue(failedKeysList)));
        result->Success(NimResult::getSuccessResult(resultMapData));
      },
      [result](const v2::V2NIMError& error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

// 批量更新队列
void FLTChatroomQueueService::addQueueListener(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  uint32_t instanceId = GetValueOrDefault<uint32_t>(arguments, "instanceId", 0);
  auto it = queueListenerMap.find(instanceId);
  if (it != queueListenerMap.end()) {
    result->Success(NimResult::getSuccessResult());
    return;
  }

  v2::V2NIMChatroomQueueListener listener;
  // 聊天室新增队列元素
  listener.onChatroomQueueOffered =
      [this, instanceId](const v2::V2NIMChatroomQueueElement& element) {
        flutter::EncodableMap arguments;
        arguments.insert(std::make_pair(
            "element", convertChatroomQueueElementToEncodableMap(element)));
        arguments.insert(
            std::make_pair("instanceId", static_cast<int32_t>(instanceId)));
        notifyEvent("onChatroomQueueOffered", arguments);
      };

  // 聊天室移除队列元素
  listener.onChatroomQueuePolled =
      [this, instanceId](const v2::V2NIMChatroomQueueElement& element) {
        flutter::EncodableMap ret;
        ret.insert(
            std::make_pair("instanceId", static_cast<int64_t>(instanceId)));
        ret.insert(std::make_pair(
            "element",
            flutter::EncodableValue(
                convertChatroomQueueElementToEncodableMap(element))));
        notifyEvent("onChatroomQueuePolled", ret);
      };

  // 聊天室清空队列元素
  listener.onChatroomQueueDropped = [this, instanceId]() {
    flutter::EncodableMap ret;
    ret.insert(std::make_pair("instanceId", static_cast<int64_t>(instanceId)));
    notifyEvent("onChatroomQueueDropped", ret);
  };

  // 聊天室清理部分队列元素
  listener.onChatroomQueuePartCleared =
      [this, instanceId](
          const std::vector<v2::V2NIMChatroomQueueElement>& keyValues) {
        flutter::EncodableMap ret;
        ret.insert(
            std::make_pair("instanceId", static_cast<int64_t>(instanceId)));
        ret.insert(std::make_pair(
            "elements",
            flutter::EncodableValue(convertToEncodableList(keyValues))));

        notifyEvent("onChatroomQueuePartCleared", ret);
      };

  // 聊天室批量更新队列元素
  listener.onChatroomQueueBatchUpdated =
      [this, instanceId](
          const std::vector<v2::V2NIMChatroomQueueElement>& keyValues) {
        flutter::EncodableMap ret;
        ret.insert(
            std::make_pair("instanceId", static_cast<int64_t>(instanceId)));
        ret.insert(std::make_pair(
            "elements",
            flutter::EncodableValue(convertToEncodableList(keyValues))));

        notifyEvent("onChatroomQueueBatchUpdated", ret);
      };

  // 聊天室批量添加队列元素
  listener.onChatroomQueueBatchOffered =
      [this, instanceId](
          const std::vector<v2::V2NIMChatroomQueueElement>& keyValues) {
        flutter::EncodableMap ret;
        ret.insert(
            std::make_pair("instanceId", static_cast<int64_t>(instanceId)));
        ret.insert(std::make_pair(
            "elements",
            flutter::EncodableValue(convertToEncodableList(keyValues))));

        notifyEvent("onChatroomQueueBatchOffered", ret);
      };

  // 保存监听器
  queueListenerMap[instanceId] = listener;

  // 获取客户端实例并注册监听器
  auto client = v2::V2NIMChatroomClient::getInstance(instanceId);
  if (client) {
    client->getChatroomQueueService().addQueueListener(listener);
  }

  result->Success(NimResult::getSuccessResult());
}

// 批量更新队列
void FLTChatroomQueueService::removeQueueListener(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  uint32_t instanceId = GetValueOrDefault<uint32_t>(arguments, "instanceId", 0);
  auto it = queueListenerMap.find(instanceId);
  if (it != queueListenerMap.end()) {
    v2::V2NIMChatroomQueueListener listener = it->second;
    auto instance = v2::V2NIMChatroomClient::getInstance(instanceId);
    auto& service = instance->getChatroomQueueService();
    service.removeQueueListener(listener);
    queueListenerMap.erase(it);
  }
  result->Success(NimResult::getSuccessResult());
}

v2::V2NIMChatroomQueueOfferParams convertToQueueOfferParams(
    const flutter::EncodableMap* params) {
  v2::V2NIMChatroomQueueOfferParams result;

  if (!params) return result;

  // 转换 elementKey
  auto keyIter = params->find(flutter::EncodableValue("elementKey"));
  if (keyIter != params->end() && !keyIter->second.IsNull()) {
    result.elementKey = std::get<std::string>(keyIter->second);
  }

  // 转换 elementValue
  auto valueIter = params->find(flutter::EncodableValue("elementValue"));
  if (valueIter != params->end() && !valueIter->second.IsNull()) {
    result.elementValue = std::get<std::string>(valueIter->second);
  }

  // 转换 transient
  auto transientIter = params->find(flutter::EncodableValue("transient"));
  if (transientIter != params->end() && !transientIter->second.IsNull()) {
    result.transient = std::get<bool>(transientIter->second);
  }

  // 转换 elementOwnerAccountId
  auto ownerIter =
      params->find(flutter::EncodableValue("elementOwnerAccountId"));
  if (ownerIter != params->end() && !ownerIter->second.IsNull()) {
    result.elementOwnerAccountId = std::get<std::string>(ownerIter->second);
  }

  return result;
};

// 将 V2NIMChatroomQueueElement 对象转换为 Flutter EncodableMap
flutter::EncodableMap convertChatroomQueueElementToEncodableMap(
    const v2::V2NIMChatroomQueueElement& element) {
  flutter::EncodableMap map;

  // 添加 key 字段
  map.insert(std::make_pair(flutter::EncodableValue("key"),
                            flutter::EncodableValue(element.key)));

  // 添加 value 字段
  map.insert(std::make_pair(flutter::EncodableValue("value"),
                            flutter::EncodableValue(element.value)));

  // 添加可选字段 accountId
  if (element.accountId.has_value()) {
    map.insert(
        std::make_pair(flutter::EncodableValue("accountId"),
                       flutter::EncodableValue(element.accountId.value())));
  } else {
    map.insert(std::make_pair(flutter::EncodableValue("accountId"),
                              flutter::EncodableValue()));  // 插入 null
  }

  // 添加可选字段 nick
  if (element.nick.has_value()) {
    map.insert(std::make_pair(flutter::EncodableValue("nick"),
                              flutter::EncodableValue(element.nick.value())));
  } else {
    map.insert(std::make_pair(flutter::EncodableValue("nick"),
                              flutter::EncodableValue()));  // 插入 null
  }

  // 添加可选字段 extension
  if (element.extension.has_value()) {
    map.insert(
        std::make_pair(flutter::EncodableValue("extension"),
                       flutter::EncodableValue(element.extension.value())));
  } else {
    map.insert(std::make_pair(flutter::EncodableValue("extension"),
                              flutter::EncodableValue()));  // 插入 null
  }

  return map;
};

v2::V2NIMChatroomQueueElement convertToQueueElement(
    const flutter::EncodableMap* map) {
  v2::V2NIMChatroomQueueElement element;

  if (!map) return element;

  // 转换 key
  auto keyIter = map->find(flutter::EncodableValue("key"));
  if (keyIter != map->end() && !keyIter->second.IsNull()) {
    element.key = std::get<std::string>(keyIter->second);
  }

  // 转换 value
  auto valueIter = map->find(flutter::EncodableValue("value"));
  if (valueIter != map->end() && !valueIter->second.IsNull()) {
    element.value = std::get<std::string>(valueIter->second);
  }

  // 转换 accountId
  auto accountIdIter = map->find(flutter::EncodableValue("accountId"));
  if (accountIdIter != map->end() && !accountIdIter->second.IsNull()) {
    element.accountId = std::get<std::string>(accountIdIter->second);
  }

  // 转换 nick
  auto nickIter = map->find(flutter::EncodableValue("nick"));
  if (nickIter != map->end() && !nickIter->second.IsNull()) {
    element.nick = std::get<std::string>(nickIter->second);
  }

  // 转换 extension
  auto extensionIter = map->find(flutter::EncodableValue("extension"));
  if (extensionIter != map->end() && !extensionIter->second.IsNull()) {
    element.extension = std::get<std::string>(extensionIter->second);
  }

  return element;
};
// 辅助函数：将元素列表转换为 EncodableList
flutter::EncodableList convertToEncodableList(
    const std::vector<v2::V2NIMChatroomQueueElement>& elements) {
  flutter::EncodableList list;
  for (const auto& element : elements) {
    list.emplace_back(convertChatroomQueueElementToEncodableMap(element));
  }
  return list;
};
