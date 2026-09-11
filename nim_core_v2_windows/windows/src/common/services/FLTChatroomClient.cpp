// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#include "FLTChatroomClient.h"

#include <future>
#include <iostream>

#include "../NimResult.h"
#include "v2_nim_api.hpp"
#include "v2_nim_def_callback.hpp"
#include "v2_nim_def_enum.hpp"
#include "v2_nim_def_struct.hpp"

v2::V2NIMBasicOption convertToBasicOption(
    const flutter::EncodableMap* arguments);

v2::V2NIMLinkOption convertToLinkOption(const flutter::EncodableMap* arguments);

v2::V2NIMFCSOption convertToFCSOption(const flutter::EncodableMap* arguments);

v2::V2NIMPrivateServerOption convertToPrivateServerOption(
    const flutter::EncodableMap* arguments);

v2::V2NIMDatabaseOption convertToDatabaseOption(
    const flutter::EncodableMap* arguments);

flutter::EncodableMap convertKickedInfoToMap(
    const v2::V2NIMChatroomKickedInfo& info);
flutter::EncodableMap convertErrorToMap(const v2::V2NIMError& error);
flutter::EncodableMap convertChatroomInfoToEncodableMap(
    const v2::V2NIMChatroomInfo& info);
flutter::EncodableMap convertChatroomCdnInfoToEncodableMap(
    const v2::V2NIMChatroomCdnInfo& cdnInfo);
flutter::EncodableMap convertEnterInfoToMap(
    const v2::V2NIMChatroomEnterInfo& info);
v2::V2NIMChatroomEnterParams convertToChatroomEnterParams(
    const flutter::EncodableMap* params);
v2::V2NIMChatroomTagConfig convertToChatroomTagConfig(
    const flutter::EncodableMap* params);
flutter::EncodableMap convertChatroomMemberToMap(
    const v2::V2NIMChatroomMember& member);
v2::V2NIMLocationInfo convertToLocationInfo(
    const flutter::EncodableMap* params);
v2::V2NIMChatroomLocationConfig convertToLocationConfig(
    const flutter::EncodableMap* params);
v2::V2NIMAntispamConfig convertToAntispamConfig(
    const flutter::EncodableMap* params);
v2::V2NIMChatroomLoginOption convertToChatroomLoginOption(
    const flutter::EncodableMap* optionMap);
// 辅助函数：从 EncodableMap 中获取值，不存在时返回默认值
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
// 将 V2NIMChatroomInfo 转换为 EncodableMap
flutter::EncodableMap convertChatroomInfoToEncodableMap(
    const v2::V2NIMChatroomInfo& info) {
  flutter::EncodableMap map;

  map.insert(std::make_pair("roomId", flutter::EncodableValue(info.roomId)));
  map.insert(
      std::make_pair("roomName", flutter::EncodableValue(info.roomName)));
  map.insert(std::make_pair("announcement",
                            flutter::EncodableValue(info.announcement)));
  map.insert(std::make_pair("liveUrl", flutter::EncodableValue(info.liveUrl)));
  map.insert(
      std::make_pair("isValidRoom", flutter::EncodableValue(info.isValidRoom)));
  map.insert(std::make_pair("serverExtension",
                            flutter::EncodableValue(info.serverExtension)));
  map.insert(std::make_pair(
      "queueLevelMode",
      flutter::EncodableValue(static_cast<int32_t>(info.queueLevelMode))));
  map.insert(std::make_pair("creatorAccountId",
                            flutter::EncodableValue(info.creatorAccountId)));
  map.insert(std::make_pair("onlineUserCount",
                            static_cast<int32_t>(info.onlineUserCount)));
  map.insert(
      std::make_pair("chatBanned", flutter::EncodableValue(info.chatBanned)));

  return map;
}

// 将 V2NIMChatroomCdnInfo 转换为 EncodableMap
flutter::EncodableMap convertChatroomCdnInfoToEncodableMap(
    const v2::V2NIMChatroomCdnInfo& cdnInfo) {
  flutter::EncodableMap map;

  //  // 处理基础类型字段
  map.insert(
      std::make_pair("enabled", flutter::EncodableValue(cdnInfo.enabled)));
  map.insert(
      std::make_pair("timestamp", static_cast<int64_t>(cdnInfo.timestamp)));
  map.insert(std::make_pair("pollingInterval",
                            static_cast<int64_t>(cdnInfo.pollingInterval)));
  map.insert(
      std::make_pair("decryptType", static_cast<int32_t>(cdnInfo.decryptType)));
  map.insert(std::make_pair("decryptKey",
                            flutter::EncodableValue(cdnInfo.decryptKey)));
  map.insert(std::make_pair("pollingTimeout",
                            static_cast<int64_t>(cdnInfo.pollingTimeout)));

  // 处理数组字段
  flutter::EncodableList urlList;
  for (const auto& url : cdnInfo.cdnUrls) {
    urlList.push_back(flutter::EncodableValue(url));
  }
  map.insert(std::make_pair(flutter::EncodableValue("cdnUrls"),
                            flutter::EncodableValue(urlList)));

  return map;
}

FLTChatroomClient::FLTChatroomClient() {
  m_serviceName = "V2NIMChatroomClient";
}

FLTChatroomClient::~FLTChatroomClient() {}

void FLTChatroomClient::onMethodCalled(
    const std::string& method, const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (method == "init") {
    init(arguments, result);
  } else if (method == "uninit") {
    uninit(arguments, result);
  } else if (method == "newInstance") {
    newInstance(arguments, result);
  } else if (method == "destroyInstance") {
    destroyInstance(arguments, result);
  } else if (method == "getInstance") {
    getInstance(arguments, result);
  } else if (method == "getInstanceList") {
    getInstanceList(arguments, result);
  } else if (method == "destroyAll") {
    destroyAll(arguments, result);
  } else if (method == "updateAppKey") {
    updateAppKey(arguments, result);
  } else if (method == "enter") {
    enter(arguments, result);
  } else if (method == "exit") {
    exit(arguments, result);
  } else if (method == "getChatroomInfo") {
    getChatroomInfo(arguments, result);
  } else if (method == "addChatroomClientListener") {
    addChatroomClientListener(arguments, result);
  } else if (method == "removeChatroomClientListener") {
    removeChatroomClientListener(arguments, result);
  } else {
    result->NotImplemented();
  }
}

// 初始化 SDK
void FLTChatroomClient::init(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  std::string appkey = "";
  std::string sdkRootDir = "";
  v2::V2NIMInitOption option;
  v2::V2NIMBasicOption basicOption;
  v2::V2NIMLinkOption linkOption;
  v2::V2NIMDatabaseOption databaseOption;
  v2::V2NIMFCSOption fcsOption;
  v2::V2NIMPrivateServerOption privateServerOption;

  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("appKey")) {
      appkey = std::get<std::string>(iter->second);
      option.appkey = appkey;
      std::cout << "appkey: " << appkey << std::endl;
    } else if (iter->first == flutter::EncodableValue("sdkRootDir")) {
      sdkRootDir = std::get<std::string>(iter->second);
      option.appDataPath = sdkRootDir;
      std::cout << "sdkRootDir: " << sdkRootDir << std::endl;
    } else if (iter->first == flutter::EncodableValue("basicOption")) {
      auto params = std::get<flutter::EncodableMap>(iter->second);
      basicOption = convertToBasicOption(&params);
      option.basicOption = basicOption;
      std::cout << "basicOption: " << std::endl;
    } else if (iter->first == flutter::EncodableValue("linkOption")) {
      auto paramsLink = std::get<flutter::EncodableMap>(iter->second);
      linkOption = convertToLinkOption(&paramsLink);
      option.linkOption = linkOption;
      std::cout << "linkOption: " << std::endl;
    } else if (iter->first == flutter::EncodableValue("databaseOption")) {
      auto paramsDataBase = std::get<flutter::EncodableMap>(iter->second);
      databaseOption = convertToDatabaseOption(&paramsDataBase);
      option.databaseOption = databaseOption;
      std::cout << "databaseOption: " << std::endl;

    } else if (iter->first == flutter::EncodableValue("fcsOption")) {
      auto paramsFcs = std::get<flutter::EncodableMap>(iter->second);
      fcsOption = convertToFCSOption(&paramsFcs);
      option.fcsOption = fcsOption;
      std::cout << "fcsOption: " << std::endl;
    } else if (iter->first == flutter::EncodableValue("privateServerOption")) {
      auto paramsPrivate = std::get<flutter::EncodableMap>(iter->second);
      privateServerOption = convertToPrivateServerOption(&paramsPrivate);
      option.privateServerOption = privateServerOption;
      std::cout << "privateServerOption: " << std::endl;
    }
  }
  std::cout << "Info: FLTChatroomClient init:" << std::endl;
  auto error = v2::V2NIMChatroomClient::init(option);
  if (error.has_value_) {
    // handle error
    std::string msg = "V2NIMChatroomClient init failed";

    result->Error(
        "", "",
        NimResult::getErrorResult(error.value_.code, error.value_.desc));
  } else {
    result->Success(NimResult::getSuccessResult());
  }
}

// 反初始化 SDK
void FLTChatroomClient::uninit(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  v2::V2NIMChatroomClient::uninit();
  result->Success(NimResult::getSuccessResult());
}

// 创建新的聊天室客户端实例
void FLTChatroomClient::newInstance(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  std::cout << "Info: FLTChatroomClient newInstance:" << std::endl;

  auto instance = v2::V2NIMChatroomClient::newInstance();
  flutter::EncodableMap resultMap;
  std::cout << "Info: FLTChatroomClient newInstance end:" << std::endl;

  resultMap.insert(std::make_pair(
      "instanceId", static_cast<int32_t>(instance->getInstanceId())));

  result->Success(NimResult::getSuccessResult(resultMap));
}

// 销毁聊天室客户端实例
void FLTChatroomClient::destroyInstance(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  int32_t instanceId = GetValueOrDefault<int32_t>(arguments, "instanceId", 0);

  v2::V2NIMChatroomClient::destroyInstance(instanceId);
  result->Success(NimResult::getSuccessResult());
}

// 获取聊天室客户端实例
void FLTChatroomClient::getInstance(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  int32_t instanceId = GetValueOrDefault<int32_t>(arguments, "instanceId", 0);

  auto client = v2::V2NIMChatroomClient::getInstance(instanceId);
  if (client) {
    flutter::EncodableMap resultMap;
    resultMap.insert(std::make_pair(
        "instanceId", static_cast<int64_t>(client->getInstanceId())));
    result->Success(NimResult::getSuccessResult(resultMap));
  } else {
    v2::V2NIMError error;
    error.code = 199415;
    error.desc = "Chatroom client instance not found";
    result->Error(std::to_string(error.code), error.desc);
  }
}

// 获取所有实例列表
void FLTChatroomClient::getInstanceList(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  auto instances = v2::V2NIMChatroomClient::getInstanceList();
  flutter::EncodableMap instanceMap;
  flutter::EncodableList instanceList;
  for (auto& instance : instances) {
    instanceList.emplace_back(static_cast<int64_t>(instance->getInstanceId()));
  }
  instanceMap.insert(
      std::make_pair("instanceList", flutter::EncodableValue(instanceList)));

  result->Success(NimResult::getSuccessResult(instanceMap));
}

// 销毁所有实例
void FLTChatroomClient::destroyAll(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  v2::V2NIMChatroomClient::destroyAll();
  result->Success(NimResult::getSuccessResult());
}

// 更新 AppKey
void FLTChatroomClient::updateAppKey(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  std::string appKey = GetValueOrDefault<std::string>(arguments, "appKey", "");
  auto chatroomClient = v2::V2NIMChatroomClient::newInstance();
  auto error = chatroomClient->updateAppKey(appKey);
  if (error.has_value_) {
    // handle error
    std::string msg = "V2NIMChatroomClient updateAppKey failed";

    result->Error(
        "", "",
        NimResult::getErrorResult(error.value_.code, error.value_.desc));
  } else {
    result->Success(NimResult::getSuccessResult());
  }
}

// 进入聊天室
void FLTChatroomClient::enter(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  int32_t instanceId = GetValueOrDefault<int32_t>(arguments, "instanceId", 0);
  std::string roomId = GetValueOrDefault<std::string>(arguments, "roomId", "");
  v2::V2NIMChatroomEnterParams enterParams;
  flutter::EncodableMap paramsMapData;
  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) continue;
    if (iter->first == flutter::EncodableValue("enterParams")) {
      paramsMapData = std::get<flutter::EncodableMap>(iter->second);
    }
  }
  enterParams = convertToChatroomEnterParams(&paramsMapData);
  v2::V2NIMChatroomLoginOption loginOption =
      convertToChatroomLoginOption(&paramsMapData);
  loginOption.tokenProvider = [this, instanceId](nstd::string roomId,
                                                 nstd::string accountId) {
    flutter::EncodableMap tokenArguments;
    tokenArguments.insert(std::make_pair("accountId", accountId));
    tokenArguments.insert(std::make_pair("roomId", roomId));
    tokenArguments.insert(std::make_pair("instanceId", instanceId));
    std::promise<std::string> promise;
    std::future<std::string> future = promise.get_future();
    notifyEvent(
        "getToken", tokenArguments,
        [this, &promise](const std::optional<flutter::EncodableValue>& result) {
          if (result.has_value()) {
            std::string resultStr = std::get<std::string>(result.value());
            promise.set_value(resultStr);
          } else {
            promise.set_value("");
          }
        });

    nstd::string result = future.get();
    std::cout << "cpp getToken: " << result.c_str() << std::endl;
    return result;
  };

  loginOption.loginExtensionProvider = [this, instanceId](
                                           nstd::string roomId,
                                           nstd::string accountId) {
    flutter::EncodableMap tokenArguments;
    tokenArguments.insert(std::make_pair("accountId", accountId));
    tokenArguments.insert(std::make_pair("roomId", roomId));
    tokenArguments.insert(std::make_pair("instanceId", instanceId));
    std::promise<std::string> promise;
    std::future<std::string> future = promise.get_future();
    notifyEvent(
        "getLoginExtension", tokenArguments,
        [this, &promise](const std::optional<flutter::EncodableValue>& result) {
          if (result.has_value()) {
            std::string resultStr = std::get<std::string>(result.value());
            promise.set_value(resultStr);
          } else {
            promise.set_value("");
          }
        });

    nstd::string result = future.get();
    std::cout << "cpp loginExtensionProvider: " << result.c_str() << std::endl;
    return result;
  };

  enterParams.loginOption = loginOption;
  enterParams.linkProvider = [this, instanceId](nstd::string roomId,
                                                nstd::string accountId) {
    flutter::EncodableMap tokenArguments;
    tokenArguments.insert(std::make_pair("accountId", accountId));
    tokenArguments.insert(std::make_pair("roomId", roomId));
    tokenArguments.insert(std::make_pair("instanceId", instanceId));
    std::promise<flutter::EncodableList> promise;
    std::future<flutter::EncodableList> future = promise.get_future();
    notifyEvent(
        "getLinkAddress", tokenArguments,
        [this, &promise](const std::optional<flutter::EncodableValue>& result) {
          flutter::EncodableList addressList;
          flutter::EncodableMap* errorMap;
          if (result.has_value()) {
            const auto& value = result.value();
            if (std::holds_alternative<flutter::EncodableList>(value)) {
              addressList = std::get<flutter::EncodableList>(value);
            }
          }
          promise.set_value(addressList);
        });

    flutter::EncodableList resultList = future.get();
    nstd::vector<nstd::string> result;
    result.reserve(resultList.size());  // 预分配空间，提升性能

    for (auto value : resultList) {
      // 检查元素是否为字符串类型
      auto strValue = std::get<std::string>(value);
      result.push_back(strValue);
    }
    return result;
  };

  auto client = v2::V2NIMChatroomClient::getInstance(instanceId);
  if (!client) {
    v2::V2NIMError error;
    error.code = 199414;
    error.desc = "Invalid chatroom client instanceId";
    return result->Error(std::to_string(error.code), error.desc);
  }

  client->enter(
      roomId, enterParams,
      [result](const v2::V2NIMChatroomEnterResult& enterResult) {
        flutter::EncodableMap resultMap;
        resultMap.insert(std::make_pair(
            "chatroom",
            convertChatroomInfoToEncodableMap(enterResult.chatroom)));
        resultMap.insert(std::make_pair(
            "selfMember", convertChatroomMemberToMap(enterResult.selfMember)));
        result->Success(NimResult::getSuccessResult(resultMap));
      },
      [result](const v2::V2NIMError& error) {
        result->Error(std::to_string(error.code), error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

// 退出聊天室
void FLTChatroomClient::exit(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  int32_t instanceId = GetValueOrDefault<int32_t>(arguments, "instanceId", 0);

  auto client = v2::V2NIMChatroomClient::getInstance(instanceId);
  if (!client) {
    v2::V2NIMError error;
    error.code = 199414;
    error.desc = "Invalid chatroom client instanceId";
    return result->Error(std::to_string(error.code), error.desc);
  }

  client->exit();
  result->Success(NimResult::getSuccessResult());
}

// 获取聊天室信息
void FLTChatroomClient::getChatroomInfo(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  int32_t instanceId = GetValueOrDefault<int32_t>(arguments, "instanceId", 0);

  auto client = v2::V2NIMChatroomClient::getInstance(instanceId);
  if (!client) {
    v2::V2NIMError error;
    error.code = 199414;
    error.desc = "Invalid chatroom client instanceId";
    return result->Error(std::to_string(error.code), error.desc);
  }

  auto info = client->getChatroomInfo();
  flutter::EncodableMap resultMap = convertChatroomInfoToEncodableMap(info);
  result->Success(NimResult::getSuccessResult(resultMap));
}

// 添加聊天室客户端监听器
void FLTChatroomClient::addChatroomClientListener(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    v2::V2NIMError error;
    error.code = 199416;
    error.desc = "Invalid arguments";
    return result->Error(std::to_string(error.code), error.desc);
  }

  int32_t instanceId = GetValueOrDefault<int32_t>(arguments, "instanceId", 0);

  auto it = chatroomClientListenerMap.find(instanceId);
  if (it != chatroomClientListenerMap.end()) {
    return result->Success(NimResult::getSuccessResult());
  }

  v2::V2NIMChatroomClientListener listener;

  // 聊天室状态变化
  listener.onChatroomStatus = [this, instanceId](
                                  v2::V2NIMChatroomStatus status,
                                  const nstd::optional<v2::V2NIMError>& error) {
    flutter::EncodableMap ret;
    ret.insert(std::make_pair("instanceId", static_cast<int64_t>(instanceId)));
    ret.insert(std::make_pair(
        "status", flutter::EncodableValue(static_cast<int>(status))));
    if (error.has_value_) {
      ret.insert(std::make_pair(
          "status", flutter::EncodableValue(convertErrorToMap(error.value_))));
    }

    notifyEvent("onChatroomStatus", ret);
  };

  // 聊天室成员进入
  listener.onChatroomEntered = [this, instanceId]() {
    flutter::EncodableMap ret;
    ret.insert(std::make_pair("instanceId", static_cast<int64_t>(instanceId)));
    notifyEvent("onChatroomEntered", ret);
  };

  // 聊天室人员被踢
  listener.onChatroomKicked = [this, instanceId](
                                  const v2::V2NIMChatroomKickedInfo& info) {
    flutter::EncodableMap ret;
    ret.insert(std::make_pair("instanceId", static_cast<int64_t>(instanceId)));
    ret.insert(std::make_pair(
        "kickedInfo", flutter::EncodableValue(convertKickedInfoToMap(info))));

    notifyEvent("onChatroomKicked", ret);
  };

  // 聊天室退出
  listener.onChatroomExited = [this, instanceId](
                                  const nstd::optional<v2::V2NIMError>& error) {
    flutter::EncodableMap ret;
    if (error.has_value_) {
      ret.insert(std::make_pair(
          "status", flutter::EncodableValue(convertErrorToMap(error.value_))));
    }

    ret.insert(std::make_pair("instanceId", static_cast<int64_t>(instanceId)));

    notifyEvent("onChatroomExited", ret);
  };

  // 保存监听器
  chatroomClientListenerMap[instanceId] = listener;

  // 获取客户端实例并注册监听器
  auto client = v2::V2NIMChatroomClient::getInstance(instanceId);
  if (client) {
    client->addChatroomClientListener(listener);
  }

  result->Success(NimResult::getSuccessResult());
}

// 移除聊天室客户端监听器
void FLTChatroomClient::removeChatroomClientListener(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    v2::V2NIMError error;
    error.code = 199416;
    error.desc = "Invalid arguments";
    return result->Error(std::to_string(error.code), error.desc);
  }

  int32_t instanceId = GetValueOrDefault<int32_t>(arguments, "instanceId", 0);

  auto it = chatroomClientListenerMap.find(instanceId);
  if (it == chatroomClientListenerMap.end()) {
    return result->Success(
        NimResult::getSuccessResult());  // 监听器不存在，直接返回成功
  }

  // 获取客户端实例并移除监听器
  auto client = v2::V2NIMChatroomClient::getInstance(instanceId);
  if (client) {
    client->removeChatroomClientListener(it->second);
  }

  // 从映射中移除监听器
  chatroomClientListenerMap.erase(it);

  result->Success(NimResult::getSuccessResult());
}

flutter::EncodableMap convertChatroomMemberToMap(
    const v2::V2NIMChatroomMember& member) {
  flutter::EncodableMap map;

  // 基础字段
  map.insert(std::make_pair("roomId", flutter::EncodableValue(member.roomId)));
  map.insert(
      std::make_pair("accountId", flutter::EncodableValue(member.accountId)));
  map.insert(std::make_pair("memberRole", static_cast<int>(member.memberRole)));
  map.insert(
      std::make_pair("isOnline", flutter::EncodableValue(member.isOnline)));
  map.insert(
      std::make_pair("blocked", flutter::EncodableValue(member.blocked)));
  map.insert(
      std::make_pair("chatBanned", flutter::EncodableValue(member.chatBanned)));
  map.insert(std::make_pair("tempChatBanned",
                            flutter::EncodableValue(member.tempChatBanned)));
  map.insert(
      std::make_pair("tempChatBannedDuration",
                     static_cast<int64_t>(member.tempChatBannedDuration)));
  map.insert(std::make_pair("notifyTargetTags",
                            flutter::EncodableValue(member.notifyTargetTags)));
  map.insert(
      std::make_pair("enterTime", static_cast<int64_t>(member.enterTime)));
  map.insert(
      std::make_pair("updateTime", static_cast<int64_t>(member.updateTime)));
  map.insert(std::make_pair("valid", flutter::EncodableValue(member.valid)));

  //   可选字段
  if (member.memberLevel.has_value()) {
    map.insert(std::make_pair(
        "memberLevel", static_cast<int32_t>(member.memberLevel.value())));
  } else {
    map.insert(std::make_pair("memberLevel", 0));
  }

  if (member.roomNick.has_value()) {
    map.insert(std::make_pair(
        "roomNick", flutter::EncodableValue(member.roomNick.value())));
  }

  if (member.roomAvatar.has_value()) {
    map.insert(std::make_pair(
        "roomAvatar", flutter::EncodableValue(member.roomAvatar.value())));
  }

  if (member.serverExtension.has_value()) {
    map.insert(std::make_pair(
        "serverExtension",
        flutter::EncodableValue(member.serverExtension.value())));
  }

  //   tags 数组
  flutter::EncodableList tagsList;
  for (const auto& tag : member.tags) {
    tagsList.push_back(flutter::EncodableValue(tag));
  }
  map.insert(std::make_pair("tags", flutter::EncodableValue(tagsList)));

  // multiEnterInfo 数组
  flutter::EncodableList enterInfoList;
  for (const auto& info : member.multiEnterInfo) {
    enterInfoList.emplace_back(convertEnterInfoToMap(info));
  }
  map.insert(
      std::make_pair("multiEnterInfo", flutter::EncodableValue(enterInfoList)));

  return map;
};

flutter::EncodableMap convertEnterInfoToMap(
    const v2::V2NIMChatroomEnterInfo& info) {
  flutter::EncodableMap map;

  map.insert(
      std::make_pair("roomNick", flutter::EncodableValue(info.roomNick)));
  map.insert(
      std::make_pair("roomAvatar", flutter::EncodableValue(info.roomAvatar)));
  map.insert(std::make_pair("enterTime", static_cast<int64_t>(info.enterTime)));
  map.insert(
      std::make_pair("clientType", static_cast<int32_t>(info.clientType)));

  return map;
};

flutter::EncodableMap convertKickedInfoToMap(
    const v2::V2NIMChatroomKickedInfo& info) {
  flutter::EncodableMap map;

  // 被踢原因（枚举转换为整数）
  map.insert(
      std::make_pair("kickedReason", static_cast<int>(info.kickedReason)));

  // 被踢扩展字段
  map.insert(std::make_pair("serverExtension",
                            flutter::EncodableValue(info.serverExtension)));

  return map;
};

flutter::EncodableMap convertErrorToMap(const v2::V2NIMError& error) {
  flutter::EncodableMap map;

  // 基础字段
  map.insert(std::make_pair("code", static_cast<int32_t>(error.code)));
  map.insert(std::make_pair("desc", flutter::EncodableValue(error.desc)));

  // 错误详情 map
  flutter::EncodableMap detailMap;
  for (const auto& pair : error.detail) {
    detailMap.insert(std::make_pair(flutter::EncodableValue(pair.first),
                                    flutter::EncodableValue(pair.second)));
  }
  map.insert(std::make_pair("detail", flutter::EncodableValue(detailMap)));

  return map;
};

v2::V2NIMChatroomEnterParams convertToChatroomEnterParams(
    const flutter::EncodableMap* params) {
  v2::V2NIMChatroomEnterParams enterParams;

  if (!params) return enterParams;

  // 账号ID
  auto accountIdIter = params->find(flutter::EncodableValue("accountId"));
  if (accountIdIter != params->end() && !accountIdIter->second.IsNull()) {
    enterParams.accountId = std::get<std::string>(accountIdIter->second);
  }

  // 静态token
  auto tokenIter = params->find(flutter::EncodableValue("token"));
  if (tokenIter != params->end() && !tokenIter->second.IsNull()) {
    enterParams.token = std::get<std::string>(tokenIter->second);
  }

  // 可选昵称
  auto roomNickIter = params->find(flutter::EncodableValue("roomNick"));
  if (roomNickIter != params->end() && !roomNickIter->second.IsNull()) {
    enterParams.roomNick = std::get<std::string>(roomNickIter->second);
  }

  // 可选头像
  auto roomAvatarIter = params->find(flutter::EncodableValue("roomAvatar"));
  if (roomAvatarIter != params->end() && !roomAvatarIter->second.IsNull()) {
    enterParams.roomAvatar = std::get<std::string>(roomAvatarIter->second);
  }

  // 登录超时时间
  auto timeoutIter = params->find(flutter::EncodableValue("timeout"));
  if (timeoutIter != params->end() && !timeoutIter->second.IsNull()) {
    enterParams.timeout = timeoutIter->second.LongValue();
  }

  // 登录配置信息
  auto loginOptionIter = params->find(flutter::EncodableValue("loginOption"));
  if (loginOptionIter != params->end() && !loginOptionIter->second.IsNull()) {
    const auto loginOptionMap =
        std::get<flutter::EncodableMap>(loginOptionIter->second);
    enterParams.loginOption = convertToChatroomLoginOption(&loginOptionMap);
  }

  // 匿名模式
  auto anonymousModeIter =
      params->find(flutter::EncodableValue("anonymousMode"));
  if (anonymousModeIter != params->end() &&
      !anonymousModeIter->second.IsNull()) {
    enterParams.anonymousMode = std::get<bool>(anonymousModeIter->second);
  }

  // 可选用户扩展字段
  auto serverExtensionIter =
      params->find(flutter::EncodableValue("serverExtension"));
  if (serverExtensionIter != params->end() &&
      !serverExtensionIter->second.IsNull()) {
    enterParams.serverExtension =
        std::get<std::string>(serverExtensionIter->second);
  }

  // 可选通知扩展字段
  auto notificationExtensionIter =
      params->find(flutter::EncodableValue("notificationExtension"));
  if (notificationExtensionIter != params->end() &&
      !notificationExtensionIter->second.IsNull()) {
    enterParams.notificationExtension =
        std::get<std::string>(notificationExtensionIter->second);
  }

  // 标签配置信息
  auto tagConfigIter = params->find(flutter::EncodableValue("tagConfig"));
  if (tagConfigIter != params->end() && !tagConfigIter->second.IsNull()) {
    auto tagConfigMap = std::get<flutter::EncodableMap>(tagConfigIter->second);
    enterParams.tagConfig = convertToChatroomTagConfig(&tagConfigMap);
  }

  // 可选位置配置信息
  auto locationConfigIter =
      params->find(flutter::EncodableValue("locationConfig"));
  if (locationConfigIter != params->end() &&
      !locationConfigIter->second.IsNull()) {
    auto locationConfigMap =
        std::get<flutter::EncodableMap>(locationConfigIter->second);
    enterParams.locationConfig = convertToLocationConfig(&locationConfigMap);
  }

  // 反垃圾配置信息
  auto antispamConfigIter =
      params->find(flutter::EncodableValue("antispamConfig"));
  if (antispamConfigIter != params->end() &&
      !antispamConfigIter->second.IsNull()) {
    auto antispamConfigMap =
        std::get<flutter::EncodableMap>(antispamConfigIter->second);
    enterParams.antispamConfig = convertToAntispamConfig(&antispamConfigMap);
  }

  return enterParams;
}

v2::V2NIMChatroomTagConfig convertToChatroomTagConfig(
    const flutter::EncodableMap* params) {
  v2::V2NIMChatroomTagConfig config;

  if (!params) return config;

  //   解析 tags 数组
  auto tagsIter = params->find(flutter::EncodableValue("tags"));
  if (tagsIter != params->end() && !tagsIter->second.IsNull()) {
    auto tagsList = std::get<flutter::EncodableList>(tagsIter->second);
    for (auto value : tagsList) {
      if (!value.IsNull()) {
        config.tags.push_back(std::get<std::string>(value));
      }
    }
  }

  // 解析 notifyTargetTags 字符串
  auto notifyTargetTagsIter =
      params->find(flutter::EncodableValue("notifyTargetTags"));
  if (notifyTargetTagsIter != params->end() &&
      !notifyTargetTagsIter->second.IsNull()) {
    config.notifyTargetTags =
        std::get<std::string>(notifyTargetTagsIter->second);
  }

  return config;
}

v2::V2NIMLocationInfo convertToLocationInfo(
    const flutter::EncodableMap* params) {
  v2::V2NIMLocationInfo info;
  if (!params) return info;
  auto iter = params->begin();
  for (iter; iter != params->end(); ++iter) {
    if (iter->second.IsNull()) continue;
    if (iter->first == flutter::EncodableValue("x")) {
      info.x = std::get<double>(iter->second);
    } else if (iter->first == flutter::EncodableValue("y")) {
      info.y = std::get<double>(iter->second);
    } else if (iter->first == flutter::EncodableValue("z")) {
      info.z = std::get<double>(iter->second);
    }
  }

  return info;
}

v2::V2NIMChatroomLocationConfig convertToLocationConfig(
    const flutter::EncodableMap* params) {
  v2::V2NIMChatroomLocationConfig config;

  if (!params) return config;

  // 解析 locationInfo 嵌套结构体
  auto locationInfoIter = params->find(flutter::EncodableValue("locationInfo"));
  if (locationInfoIter != params->end() && !locationInfoIter->second.IsNull()) {
    auto locationInfoMap =
        std::get<flutter::EncodableMap>(locationInfoIter->second);
    config.locationInfo = convertToLocationInfo(&locationInfoMap);
  }

  // 解析 distance 可选字段
  auto distanceIter = params->find(flutter::EncodableValue("distance"));
  if (distanceIter != params->end() && !distanceIter->second.IsNull()) {
    config.distance = std::get<double>(distanceIter->second);
  }

  return config;
}

v2::V2NIMAntispamConfig convertToAntispamConfig(
    const flutter::EncodableMap* params) {
  v2::V2NIMAntispamConfig config;

  if (!params) return config;

  // 解析 antispamBusinessId 字符串
  auto businessIdIter =
      params->find(flutter::EncodableValue("antispamBusinessId"));
  if (businessIdIter != params->end() && !businessIdIter->second.IsNull()) {
    config.antispamBusinessId = std::get<std::string>(businessIdIter->second);
  }

  return config;
}

v2::V2NIMChatroomLoginOption convertToChatroomLoginOption(
    const flutter::EncodableMap* optionMap) {
  v2::V2NIMChatroomLoginOption option;
  auto iter = optionMap->begin();
  for (iter; iter != optionMap->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("authType")) {
      option.authType = v2::V2NIMLoginAuthType(std::get<int>(iter->second));
    }
  }
  return option;
}

v2::V2NIMBasicOption convertToBasicOption(
    const flutter::EncodableMap* arguments) {
  v2::V2NIMBasicOption option;
  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("useHttps")) {
      option.useHttps = std::get<bool>(iter->second);
    } else if (iter->first == flutter::EncodableValue("useHttpdns")) {
      option.useHttpdns = std::get<bool>(iter->second);
    } else if (iter->first ==
               flutter::EncodableValue("enableCloudConversation")) {
      option.enableCloudConversation = std::get<bool>(iter->second);
    } else if (iter->first ==
               flutter::EncodableValue("enableCloudFriendAddApplication")) {
      option.enableCloudFriendAddApplication = std::get<bool>(iter->second);
    } else if (iter->first ==
               flutter::EncodableValue("enableCloudTeamJoinActionInfo")) {
      option.enableCloudTeamJoinActionInfo = std::get<bool>(iter->second);
    } else if (iter->first == flutter::EncodableValue("customClientType")) {
      option.customClientType = std::get<int>(iter->second);
    } else if (iter->first == flutter::EncodableValue("customTag")) {
      option.customTag = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("logMaxSize")) {
      option.logMaxSize = std::get<int>(iter->second);
    } else if (iter->first == flutter::EncodableValue("logReserveDays")) {
      option.logReserveDays = std::get<int>(iter->second);
    } else if (iter->first == flutter::EncodableValue("sdkLogLevel")) {
      option.sdkLogLevel = v2::V2NIMSDKLogLevel(std::get<int>(iter->second));
    } else if (iter->first ==
               flutter::EncodableValue("customizeLogCollectionDirectory")) {
      option.customizeLogCollectionDirectory =
          std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("disableAppNap")) {
      option.disableAppNap = std::get<bool>(iter->second);
    } else if (iter->first == flutter::EncodableValue("enableCompass")) {
      option.enableCompass = std::get<bool>(iter->second);
    } else if (iter->first ==
               flutter::EncodableValue("teamNotificationBadge")) {
      option.teamNotificationBadge = std::get<bool>(iter->second);
    } else if (iter->first ==
               flutter::EncodableValue("reduceUnreadOnMessageRecall")) {
      option.reduceUnreadOnMessageRecall = std::get<bool>(iter->second);
    } else if (iter->first == flutter::EncodableValue("conversationSnapshot")) {
      option.conversationSnapshot = std::get<bool>(iter->second);
    } else if (iter->first == flutter::EncodableValue("compassDataEndpoint")) {
      option.compassDataEndpoint = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("abTestEndpoint")) {
      option.abTestEndpoint = std::get<std::string>(iter->second);
    }
  }
  option.sdkType = nim::kNIMSDKTypeFlutter;
  return option;
}

v2::V2NIMLinkOption convertToLinkOption(
    const flutter::EncodableMap* arguments) {
  v2::V2NIMLinkOption option;
  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("linkTimeout")) {
      option.linkTimeout = std::get<int>(iter->second);
    } else if (iter->first == flutter::EncodableValue("protocolTimeout")) {
      option.protocolTimeout = std::get<int>(iter->second);
    } else if (iter->first ==
               flutter::EncodableValue("asymmetricEncryptionAlgorithm")) {
      option.asymmetricEncryptionAlgorithm =
          v2::V2NIMAsymmetricEncryptionAlgorithm(std::get<int>(iter->second));
    } else if (iter->first ==
               flutter::EncodableValue("symmetricEncryptionAlgorithm")) {
      option.symmetricEncryptionAlgorithm =
          v2::V2NIMSymmetricEncryptionAlgorithm(std::get<int>(iter->second));
    }
  }
  return option;
}

v2::V2NIMFCSOption convertToFCSOption(const flutter::EncodableMap* arguments) {
  v2::V2NIMFCSOption option;
  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("fcsAuthType")) {
      option.fcsAuthType = v2::V2NIMFCSAuthType(std::get<int>(iter->second));
    } else if (iter->first == flutter::EncodableValue("customAuthRefer")) {
      option.customAuthRefer = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("customAuthUA")) {
      option.customAuthUA = std::get<std::string>(iter->second);
    }
  }

  return option;
}

v2::V2NIMDatabaseOption convertToDatabaseOption(
    const flutter::EncodableMap* arguments) {
  v2::V2NIMDatabaseOption option;
  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("encryptionKey")) {
      option.encryptionKey = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("enableBackup")) {
      option.enableBackup = std::get<bool>(iter->second);
    } else if (iter->first == flutter::EncodableValue("enableRestore")) {
      option.enableRestore = std::get<bool>(iter->second);
    } else if (iter->first == flutter::EncodableValue("backupFolder")) {
      option.backupFolder = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("sqlcipherVersion")) {
      option.sqlcipherVersion =
          v2::V2NIMSQLCipherVersion(std::get<int>(iter->second));
    }
  }
  return option;
}

v2::V2NIMPrivateServerOption convertToPrivateServerOption(
    const flutter::EncodableMap* arguments) {
  v2::V2NIMPrivateServerOption option;
  auto iter = arguments->begin();

  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("ipProtocolVersion")) {
      option.ipProtocolVersion =
          v2::V2NIMIPProtocolVersion(std::get<int>(iter->second));
    } else if (iter->first == flutter::EncodableValue("lbsAddresses")) {
      auto lbsAddresses = std::get<flutter::EncodableList>(iter->second);
      for (auto address : lbsAddresses) {
        std::string add = std::get<std::string>(address);
        option.lbsAddresses.append(add);
      }
    } else if (iter->first == flutter::EncodableValue("nosLbsAddress")) {
      option.nosLbsAddress = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("defaultLinkAddress")) {
      option.defaultLinkAddress = std::get<std::string>(iter->second);
    } else if (iter->first ==
               flutter::EncodableValue("defaultLinkAddressIpv6")) {
      option.defaultLinkAddressIpv6 = std::get<std::string>(iter->second);
    } else if (iter->first ==
               flutter::EncodableValue("defaultNosUploadAddress")) {
      option.defaultNosUploadAddress = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("defaultNosUploadHost")) {
      option.defaultNosUploadHost = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("nosDownloadAddress")) {
      option.nosDownloadAddress = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("nosAccelerateHosts")) {
      auto nosAccelerateHosts = std::get<flutter::EncodableList>(iter->second);
      for (auto address : nosAccelerateHosts) {
        std::string add = std::get<std::string>(address);
        option.nosAccelerateHosts.append(add);
      }
    } else if (iter->first == flutter::EncodableValue("nosAccelerateAddress")) {
      option.nosAccelerateAddress = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("probeIpv4Url")) {
      option.probeIpv4Url = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("probeIpv6Url")) {
      option.probeIpv6Url = std::get<std::string>(iter->second);
    } else if (iter->first ==
               flutter::EncodableValue("asymmetricEncryptionKeyA")) {
      option.asymmetricEncryptionKeyA = std::get<std::string>(iter->second);
    } else if (iter->first ==
               flutter::EncodableValue("asymmetricEncryptionKeyB")) {
      option.asymmetricEncryptionKeyB = std::get<std::string>(iter->second);
    } else if (iter->first ==
               flutter::EncodableValue("asymmetricEncryptionKeyVersion")) {
      option.asymmetricEncryptionKeyVersion = std::get<int>(iter->second);
    }
  }
  return option;
}

// 辅助转换函数
v2::V2NIMChatroomLoginOption convertToLoginOption(
    const flutter::EncodableMap* params) {
  v2::V2NIMChatroomLoginOption option;

  if (!params) return option;

  auto authTypeIter = params->find(flutter::EncodableValue("authType"));
  if (authTypeIter != params->end() && !authTypeIter->second.IsNull()) {
    option.authType = static_cast<v2::V2NIMLoginAuthType>(
        std::get<int32_t>(authTypeIter->second));
  }

  // 函数指针字段不通过 Flutter 传递
  option.tokenProvider = nullptr;
  option.loginExtensionProvider = nullptr;

  return option;
}
