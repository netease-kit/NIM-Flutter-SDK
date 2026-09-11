// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#include "FLTSubscriptionService.h"

using namespace nim;

FLTSubscriptionService::FLTSubscriptionService() {
  m_serviceName = "SubscriptionService";

  listener.onUserStatusChanged =
      [this](const nstd::vector<v2::V2NIMUserStatus>& datas) {
        flutter::EncodableList dataList;
        for (auto data : datas) {
          dataList.emplace_back(convertUserStatus(data));
        }

        flutter::EncodableMap resultMap;
        resultMap.insert(std::make_pair("userStatusList", dataList));
        notifyEvent("onUserStatusChanged", resultMap);
      };

  auto& client = v2::V2NIMClient::get();
  auto& subscriptionService = client.getSubscriptionService();

  subscriptionService.addSubscribeListener(listener);
}

FLTSubscriptionService::~FLTSubscriptionService() {
  auto& client = v2::V2NIMClient::get();
  auto& subscriptionService = client.getSubscriptionService();

  subscriptionService.removeSubscribeListener(listener);
}

void FLTSubscriptionService::onMethodCalled(
    const std::string& method, const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  switch (utils::hash_(method.c_str())) {
    case "subscribeUserStatus"_hash:
      subscribeUserStatus(arguments, result);
      return;
    case "unsubscribeUserStatus"_hash:
      unsubscribeUserStatus(arguments, result);
      return;

    case "publishCustomUserStatus"_hash:
      publishCustomUserStatus(arguments, result);
      return;

    case "queryUserStatusSubscriptions"_hash:
      queryUserStatusSubscriptions(arguments, result);
      return;

    default:
      break;
  }
  if (result) result->NotImplemented();
}

void FLTSubscriptionService::subscribeUserStatus(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  v2::V2NIMSubscribeUserStatusOption option;

  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("option")) {
      auto optionMap = std::get<flutter::EncodableMap>(iter->second);
      option = getSubscribeUserStatusOption(&optionMap);
    }
  }

  auto& client = v2::V2NIMClient::get();
  auto& subscriptionService = client.getSubscriptionService();
  subscriptionService.subscribeUserStatus(
      option,
      [result](nstd::vector<nstd::string> failedList) {
        flutter::EncodableList failedIds;
        for (auto failedId : failedList) {
          failedIds.emplace_back(failedId);
        }

        flutter::EncodableMap resultMap;
        resultMap.insert(std::make_pair("accountIds", failedIds));
        result->Success(NimResult::getSuccessResult(resultMap));
      },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void FLTSubscriptionService::unsubscribeUserStatus(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  v2::V2NIMUnsubscribeUserStatusOption option;

  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("option")) {
      auto optionMap = std::get<flutter::EncodableMap>(iter->second);
      option = getUnsubscribeUserStatusOption(&optionMap);
    }
  }

  auto& client = v2::V2NIMClient::get();
  auto& subscriptionService = client.getSubscriptionService();
  subscriptionService.unsubscribeUserStatus(
      option,
      [result](nstd::vector<nstd::string> failedList) {
        flutter::EncodableList failedIds;
        for (auto it : failedList) {
          failedIds.emplace_back(it);
        }

        flutter::EncodableMap resultMap;
        resultMap.insert(std::make_pair("accountIds", failedIds));
        result->Success(NimResult::getSuccessResult(resultMap));
      },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void FLTSubscriptionService::publishCustomUserStatus(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  v2::V2NIMCustomUserStatusParams params;

  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("params")) {
      auto paramsMap = std::get<flutter::EncodableMap>(iter->second);
      params = getCustomUserStatusParams(&paramsMap);
    }
  }

  auto& client = v2::V2NIMClient::get();
  auto& subscriptionService = client.getSubscriptionService();
  subscriptionService.publishCustomUserStatus(
      params,
      [result](const v2::V2NIMCustomUserStatusPublishResult& publishResult) {
        flutter::EncodableMap resultMap =
            convertCustomUserStatusPublishResult(publishResult);
        result->Success(NimResult::getSuccessResult(resultMap));
      },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void FLTSubscriptionService::queryUserStatusSubscriptions(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  nstd::vector<nstd::string> accountIds;

  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("accountIds")) {
      std::vector<std::string> accIds;
      auto accountIdList = std::get<flutter::EncodableList>(iter->second);
      for (auto& it : accountIdList) {
        auto accountId = std::get<std::string>(it);
        accIds.emplace_back(accountId);
      }
      accountIds = accIds;
    }
  }

  auto& client = v2::V2NIMClient::get();
  auto& subscriptionService = client.getSubscriptionService();
  subscriptionService.queryUserStatusSubscriptions(
      accountIds,
      [result](nstd::vector<v2::V2NIMUserStatusSubscribeResult> results) {
        flutter::EncodableList resultList;
        for (auto& res : results) {
          resultList.emplace_back(convertUserStatusSubscribeResult(res));
        }

        flutter::EncodableMap resultMap;
        resultMap.insert(std::make_pair("subscribeResultList", resultList));
        result->Success(NimResult::getSuccessResult(resultMap));
      },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

v2::V2NIMSubscribeUserStatusOption getSubscribeUserStatusOption(
    const flutter::EncodableMap* arguments) {
  v2::V2NIMSubscribeUserStatusOption object;
  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("accountIds")) {
      std::vector<std::string> accountIds;
      auto accountIdList = std::get<flutter::EncodableList>(iter->second);
      for (auto& it : accountIdList) {
        auto accountId = std::get<std::string>(it);
        accountIds.emplace_back(accountId);
      }
      object.accountIds = accountIds;
    } else if (iter->first == flutter::EncodableValue("duration")) {
      object.duration = iter->second.LongValue();
    } else if (iter->first == flutter::EncodableValue("immediateSync")) {
      object.immediateSync = std::get<bool>(iter->second);
    }
  }
  return object;
}

v2::V2NIMUnsubscribeUserStatusOption getUnsubscribeUserStatusOption(
    const flutter::EncodableMap* arguments) {
  v2::V2NIMUnsubscribeUserStatusOption object;
  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("accountIds")) {
      std::vector<std::string> accountIds;
      auto accountIdList = std::get<flutter::EncodableList>(iter->second);
      for (auto& it : accountIdList) {
        auto accountId = std::get<std::string>(it);
        accountIds.emplace_back(accountId);
      }
      object.accountIds = accountIds;
    }
  }
  return object;
}

v2::V2NIMCustomUserStatusParams getCustomUserStatusParams(
    const flutter::EncodableMap* arguments) {
  v2::V2NIMCustomUserStatusParams object;
  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("statusType")) {
      object.statusType = iter->second.LongValue();
    } else if (iter->first == flutter::EncodableValue("duration")) {
      object.duration = iter->second.LongValue();
    } else if (iter->first == flutter::EncodableValue("extension")) {
      object.extension = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("onlineOnly")) {
      object.onlineOnly = std::get<bool>(iter->second);
    } else if (iter->first == flutter::EncodableValue("multiSync")) {
      object.multiSync = std::get<bool>(iter->second);
    }
  }
  return object;
}

flutter::EncodableMap convertCustomUserStatusPublishResult(
    const v2::V2NIMCustomUserStatusPublishResult object) {
  flutter::EncodableMap resultMap;

  resultMap.insert(std::make_pair("uniqueId", object.uniqueId));
  resultMap.insert(std::make_pair("serverId", object.serverId));
  resultMap.insert(
      std::make_pair("publishTime", static_cast<int64_t>(object.publishTime)));
  return resultMap;
}

flutter::EncodableMap convertUserStatusSubscribeResult(
    const v2::V2NIMUserStatusSubscribeResult object) {
  flutter::EncodableMap resultMap;

  resultMap.insert(std::make_pair("accountId", object.accountId));
  resultMap.insert(
      std::make_pair("duration", static_cast<int64_t>(object.duration)));
  resultMap.insert(std::make_pair("subscribeTime",
                                  static_cast<int64_t>(object.subscribeTime)));
  return resultMap;
}

flutter::EncodableMap convertUserStatus(const v2::V2NIMUserStatus object) {
  flutter::EncodableMap resultMap;

  resultMap.insert(std::make_pair("accountId", object.accountId));
  resultMap.insert(
      std::make_pair("statusType", static_cast<int64_t>(object.statusType)));
  resultMap.insert(std::make_pair("clientType", object.clientType));
  resultMap.insert(
      std::make_pair("publishTime", static_cast<int64_t>(object.publishTime)));

  if (object.extension.has_value()) {
    resultMap.insert(std::make_pair("extension", object.extension.value()));
  }

  if (object.serverExtension.has_value()) {
    resultMap.insert(
        std::make_pair("serverExtension", object.serverExtension.value()));
  }

  if (object.uniqueId.has_value()) {
    resultMap.insert(std::make_pair("uniqueId", object.uniqueId.value()));
  }

  if (object.duration.has_value()) {
    resultMap.insert(std::make_pair(
        "duration", static_cast<int32_t>(object.duration.value())));
  }

  return resultMap;
}