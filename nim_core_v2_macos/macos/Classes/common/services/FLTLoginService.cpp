// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#include "FLTLoginService.h"

#include <future>

#include "../NimResult.h"
#include "nim_cpp_wrapper/nim_cpp_api.h"
#include "v2_nim_api.hpp"
#include "v2_nim_def_struct.hpp"
#include "v2_nim_login_service.hpp"

using namespace nim;

flutter::EncodableMap converNIMErrorToMap(const v2::V2NIMError error);
flutter::EncodableMap convertKickedOffDetailToMap(
    const v2::V2NIMKickedOfflineDetail detail);
flutter::EncodableMap convertLoginClientToMap(
    const v2::V2NIMLoginClient& client);

FLTLoginService::FLTLoginService() {
  m_serviceName = "LoginService";

  // 添加监听
  listener.onLoginStatus = [this](v2::V2NIMLoginStatus status) {
    // Handle login status
    flutter::EncodableMap arguments;
    arguments.insert(std::make_pair("status", status));
    notifyEvent("onLoginStatus", arguments);
  };
  listener.onLoginFailed = [this](v2::V2NIMError error) {
    // Handle login error
    flutter::EncodableMap arguments = converNIMErrorToMap(error);
    notifyEvent("onLoginFailed", arguments);
  };
  listener.onKickedOffline = [this](v2::V2NIMKickedOfflineDetail detail) {
    // Handle kicked offline detail
    flutter::EncodableMap arguments = convertKickedOffDetailToMap(detail);
    notifyEvent("onKickedOffline", arguments);
  };
  listener.onLoginClientChanged =
      [this](v2::V2NIMLoginClientChange change,
             std::vector<v2::V2NIMLoginClient> clients) {
        // Handle login client change
        flutter::EncodableMap arguments;
        flutter::EncodableList clientsList;
        for (auto client : clients) {
          clientsList.emplace_back(convertLoginClientToMap(client));
        }
        arguments.insert(std::make_pair("clients", clientsList));
        arguments.insert(std::make_pair("change", change));
        notifyEvent("onLoginClientChanged", arguments);
      };

  v2::V2NIMClient::get().getLoginService().addLoginListener(listener);

  detailListener.onConnectStatus = [this](v2::V2NIMConnectStatus status) {
    // handle connect status change event
    flutter::EncodableMap arguments;
    arguments.insert(std::make_pair("status", status));
    notifyEvent("onConnectStatus", arguments);
  };
  detailListener.onDisconnected = [this](nstd::optional<v2::V2NIMError> error) {
    // handle disconnected error
    if (error.has_value()) {
      flutter::EncodableMap arguments = converNIMErrorToMap(error.value());
      notifyEvent("onDisconnected", arguments);
    }
  };
  detailListener.onConnectFailed = [this](v2::V2NIMError error) {
    // handle connect failed error
    flutter::EncodableMap arguments = converNIMErrorToMap(error);
    notifyEvent("onConnectFailed", arguments);
  };
  detailListener.onDataSync = [this](v2::V2NIMDataSyncType type,
                                     v2::V2NIMDataSyncState state,
                                     nstd::optional<v2::V2NIMError> error) {
    // handle data sync error
    flutter::EncodableMap arguments;
    arguments.insert(std::make_pair("type", type));
    arguments.insert(std::make_pair("state", state));
    if (error.has_value()) {
      flutter::EncodableMap argumentsError = converNIMErrorToMap(error.value());
      arguments.insert(std::make_pair("error", argumentsError));
    }
    notifyEvent("onDataSync", arguments);
  };
  v2::V2NIMClient::get().getLoginService().addLoginDetailListener(
      detailListener);
}

FLTLoginService::~FLTLoginService() {
  // 删除监听
  v2::V2NIMClient::get().getLoginService().removeLoginListener(listener);
  v2::V2NIMClient::get().getLoginService().removeLoginDetailListener(
      detailListener);
}

void FLTLoginService::onMethodCalled(
    const std::string& method, const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  std::cout << "method: " << method;

  if (method == "login") {
    login(arguments, result);
  } else if (method == "logout") {
    logout(result);
  } else if (method == "getLoginUser") {
    getLoginUser(arguments, result);
  } else if (method == "getLoginStatus") {
    getLoginStatus(arguments, result);
  } else if (method == "kickOffline") {
    kickOffline(arguments, result);
  } else if (method == "getKickedOfflineDetail") {
    getKickedOfflineDetail(arguments, result);
  } else if (method == "getConnectStatus") {
    getConnectStatus(arguments, result);
  } else if (method == "getDataSync") {
    getDataSync(arguments, result);
  } else if (method == "getChatroomLinkAddress") {
    getChatroomLinkAddress(arguments, result);
  } else if (method == "setReconnectDelayProvider") {
    setReconnectDelayProvider(arguments, result);
  } else if (method == "getLoginClients") {
    getLoginClients(arguments, result);
  } else {
    result->NotImplemented();
  }
}

v2::V2NIMLoginOption getLoginOption(const flutter::EncodableMap* arguments) {
  v2::V2NIMLoginOption option;
  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("retryCount")) {
      option.retryCount = std::get<int>(iter->second);
    } else if (iter->first == flutter::EncodableValue("timeout")) {
      option.timeout = std::get<int>(iter->second);
    } else if (iter->first == flutter::EncodableValue("forceMode")) {
      option.forceMode = std::get<bool>(iter->second);
    } else if (iter->first == flutter::EncodableValue("authType")) {
      option.authType = v2::V2NIMLoginAuthType(std::get<int>(iter->second));
    } else if (iter->first == flutter::EncodableValue("syncLevel")) {
      option.syncLevel = v2::V2NIMDataSyncLevel(std::get<int>(iter->second));
    }
  }

  return option;
}

v2::V2NIMLoginClient getLoginClient(const flutter::EncodableMap* arguments) {
  v2::V2NIMLoginClient client;
  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("type")) {
      client.type = v2::V2NIMLoginClientType(std::get<int>(iter->second));
    } else if (iter->first == flutter::EncodableValue("os")) {
      client.os = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("timestamp")) {
      int64_t timestamp = iter->second.LongValue();
      client.timestamp = timestamp;
    } else if (iter->first == flutter::EncodableValue("customTag")) {
      client.customTag = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("customClientType")) {
      client.customClientType = std::get<int>(iter->second);
    } else if (iter->first == flutter::EncodableValue("clientId")) {
      client.clientId = std::get<std::string>(iter->second);
    }
  }
  return client;
}

flutter::EncodableMap convertKickedOffDetailToMap(
    const v2::V2NIMKickedOfflineDetail detail) {
  flutter::EncodableMap resultMap;
  resultMap.insert(std::make_pair("reason", detail.reason));
  resultMap.insert(std::make_pair("clientType", detail.clientType));
  resultMap.insert(std::make_pair(
      "customClientType", static_cast<int32_t>(detail.customClientType)));
  resultMap.insert(std::make_pair("reasonDesc", detail.reasonDesc));
  return resultMap;
}

flutter::EncodableMap converDataSyncToMap(
    const v2::V2NIMDataSyncDetail detail) {
  flutter::EncodableMap resultMap;
  resultMap.insert(std::make_pair("state", detail.state));
  resultMap.insert(std::make_pair("type", detail.type));
  return resultMap;
}

flutter::EncodableMap converNIMErrorToMap(const v2::V2NIMError error) {
  flutter::EncodableMap resultMap;
  resultMap.insert(std::make_pair("code", static_cast<int32_t>(error.code)));
  resultMap.insert(std::make_pair("desc", error.desc));
  flutter::EncodableMap detailMap;
  for (auto detailInfo : error.detail) {
    detailMap.insert(std::make_pair(detailInfo.first, detailInfo.second));
  }
  resultMap.insert(std::make_pair("detail", detailMap));
  return resultMap;
}

flutter::EncodableMap convertLoginClientToMap(
    const v2::V2NIMLoginClient& client) {
  flutter::EncodableMap resultMap;
  resultMap.insert(std::make_pair("type", client.type));
  resultMap.insert(std::make_pair("os", client.os));
  resultMap.insert(
      std::make_pair("timestamp", static_cast<int64_t>((client.timestamp))));
  resultMap.insert(std::make_pair("customTag", client.customTag));
  resultMap.insert(std::make_pair(
      "customClientType", static_cast<int32_t>(client.customClientType)));
  resultMap.insert(std::make_pair("clientId", client.clientId));
  return resultMap;
}

void FLTLoginService::login(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  std::string account = "";
  std::string token = "";
  // v2::V2NIMLoginOption option;

  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("accountId")) {
      account = std::get<std::string>(iter->second);
      std::cout << "accountId: " << account << std::endl;
    } else if (iter->first == flutter::EncodableValue("token")) {
      token = std::get<std::string>(iter->second);
      std::cout << "token: " << token << std::endl;
    } else if (iter->first == flutter::EncodableValue("option")) {
      auto params = std::get<flutter::EncodableMap>(iter->second);
      loginOption = getLoginOption(&params);
      std::cout << "option: " << std::endl;
    }
  }

  loginOption.tokenProvider = [this](nstd::string accountId) {
    flutter::EncodableMap arguments;
    arguments.insert(std::make_pair("accountId", accountId));
    std::promise<std::string> promise;
    std::future<std::string> future = promise.get_future();
    notifyEvent(
        "getToken", arguments,
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

  loginOption.loginExtensionProvider = [this](nstd::string accountId) {
    flutter::EncodableMap arguments;
    arguments.insert(std::make_pair("accountId", accountId));
    std::promise<std::string> promise;
    std::future<std::string> future = promise.get_future();
    notifyEvent(
        "getLoginExtension", arguments,
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

  auto& instance = v2::V2NIMClient::get();
  auto& loginService = instance.getLoginService();
  loginService.login(
      account, token, loginOption,
      [result]() {
        // login succeeded
        result->Success(NimResult::getSuccessResult());
      },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, "login failed"));
      });
}

void FLTLoginService::logout(
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  auto& instance = v2::V2NIMClient::get();
  auto& loginService = instance.getLoginService();
  loginService.logout(
      [result]() {
        // login succeeded
        result->Success(NimResult::getSuccessResult());
      },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, "logout failed"));
      });
}

void FLTLoginService::getLoginUser(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  auto& instance = v2::V2NIMClient::get();
  auto& loginService = instance.getLoginService();
  auto loginUser = loginService.getLoginUser();
  result->Success(NimResult::getSuccessResult(std::string(loginUser)));
}

void FLTLoginService::getLoginStatus(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  auto& instance = v2::V2NIMClient::get();
  auto& loginService = instance.getLoginService();
  auto loginStatus = loginService.getLoginStatus();
  flutter::EncodableMap resultMap;
  resultMap.insert(std::make_pair("status", loginStatus));
  result->Success(NimResult::getSuccessResult(resultMap));
}

void FLTLoginService::kickOffline(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  v2::V2NIMLoginClient client;
  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("client")) {
      auto params = std::get<flutter::EncodableMap>(iter->second);
      client = getLoginClient(&params);
      std::cout << "client: " << std::endl;
    }
  }
  auto& instance = v2::V2NIMClient::get();
  auto& loginService = instance.getLoginService();
  loginService.kickOffline(
      client,
      [result]() {
        // kick client succeeded
        result->Success(NimResult::getSuccessResult());
      },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void FLTLoginService::getKickedOfflineDetail(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  auto& instance = v2::V2NIMClient::get();
  auto& loginService = instance.getLoginService();
  const auto kickedOfflineDetail = loginService.getKickedOfflineDetail();
  flutter::EncodableMap resultMap =
      convertKickedOffDetailToMap(*kickedOfflineDetail);
  result->Success(NimResult::getSuccessResult(resultMap));
}

void FLTLoginService::getConnectStatus(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  auto& instance = v2::V2NIMClient::get();
  auto& loginService = instance.getLoginService();
  auto connectStatus = loginService.getConnectStatus();
  flutter::EncodableMap resultMap;
  resultMap.insert(std::make_pair("status", connectStatus));
  result->Success(NimResult::getSuccessResult(resultMap));
}

void FLTLoginService::getDataSync(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  auto& instance = v2::V2NIMClient::get();
  auto& loginService = instance.getLoginService();
  auto dataSyncs = loginService.getDataSync();
  flutter::EncodableMap resultMap;
  flutter::EncodableList dataList;
  for (auto dataSync : dataSyncs) {
    dataList.emplace_back(converDataSyncToMap(dataSync));
  }
  resultMap.insert(std::make_pair("dataSync", dataList));
  result->Success(NimResult::getSuccessResult(resultMap));
}

void FLTLoginService::getChatroomLinkAddress(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  // todo  result->Success(NimResult::getSuccessResult());
}

void FLTLoginService::setReconnectDelayProvider(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  auto& instance = v2::V2NIMClient::get();
  auto& loginService = instance.getLoginService();
  reconnectDelayProvider = [this](uint32_t defaultDelay) {
    flutter::EncodableMap arguments;
    arguments.insert(
        std::make_pair("delay", static_cast<int64_t>(defaultDelay)));
    std::promise<uint32_t> promise;
    std::future<uint32_t> future = promise.get_future();
    notifyEvent("getReconnectDelay", arguments,
                [this, &promise, &defaultDelay](
                    const std::optional<flutter::EncodableValue>& result) {
                  if (result.has_value()) {
                    uint32_t resultINT = std::get<int32_t>(result.value());
                    promise.set_value(resultINT);
                  } else {
                    promise.set_value(defaultDelay);
                  }
                });

    uint32_t resultInt = future.get();
    std::cout << "cpp getReconnectDelay: " << resultInt << std::endl;
    return resultInt;
  };
  loginService.setReconnectDelayProvider(reconnectDelayProvider);
  result->Success(NimResult::getSuccessResult());
}

void FLTLoginService::getLoginClients(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  auto& instance = v2::V2NIMClient::get();
  auto& loginService = instance.getLoginService();
  auto loginClients = loginService.getLoginClients();
  flutter::EncodableMap resultMap;
  flutter::EncodableList dataList;
  for (auto loginClient : loginClients) {
    dataList.emplace_back(convertLoginClientToMap(loginClient));
  }
  resultMap.insert(std::make_pair("loginClient", dataList));
  result->Success(NimResult::getSuccessResult(resultMap));
}
