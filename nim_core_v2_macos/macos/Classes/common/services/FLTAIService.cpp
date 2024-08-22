// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#include "FLTAIService.h"

#include "../NimResult.h"
#include "FLTMessageService.h"
#include "nim_cpp_wrapper/nim_cpp_api.h"

v2::V2NIMProxyAIModelCallParams getProxyAIModelCallParams(
    const flutter::EncodableMap* arguments);

flutter::EncodableMap convertNIMAIUser(
    const nstd::shared_ptr<v2::V2NIMAIUser> object);

flutter::EncodableMap convertProxyAIModelCallParams(
    const v2::V2NIMProxyAIModelCallParams object);

v2::V2NIMProxyAICallAntispamConfig getProxyAICallAntispamConfig(
    const flutter::EncodableMap* arguments);

flutter::EncodableMap convertProxyAICallAntispamConfig(
    const v2::V2NIMProxyAICallAntispamConfig object);

flutter::EncodableMap convertAIModelCallResult(
    const v2::V2NIMAIModelCallResult object);

flutter::EncodableMap convertAIModelConfig(const v2::V2NIMAIModelConfig object);

FLTAIService::FLTAIService() {
  m_serviceName = "AIService";

  listener.onProxyAIModelCall = [this](v2::V2NIMAIModelCallResult response) {
    // handle proxy ai model call

    flutter::EncodableMap resultMap = convertAIModelCallResult(response);
    notifyEvent("onProxyAIModelCall", resultMap);
  };

  auto& client = v2::V2NIMClient::get();
  auto& aiService = client.getAIService();

  aiService.addAIListener(listener);
}

FLTAIService::~FLTAIService() {
  auto& client = v2::V2NIMClient::get();
  auto& aiService = client.getAIService();

  aiService.removeAIListener(listener);
}

void FLTAIService::onMethodCalled(
    const std::string& method, const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  switch (utils::hash_(method.c_str())) {
    case "getAIUserList"_hash:
      getAIUserList(arguments, result);
      return;
    case "proxyAIModelCall"_hash:
      proxyAIModelCall(arguments, result);
      return;

    default:
      break;
  }
  if (result) result->NotImplemented();
}

void FLTAIService::getAIUserList(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  auto& instance = v2::V2NIMClient::get();
  auto& aiService = instance.getAIService();
  aiService.getAIUserList(
      [result](nstd::vector<nstd::shared_ptr<v2::V2NIMAIUser>> aiUsers) {
        flutter::EncodableList aiUserList;
        for (auto aiUser : aiUsers) {
          aiUserList.emplace_back(convertNIMAIUser(aiUser));
        }
        flutter::EncodableMap resultMap;
        resultMap.insert(std::make_pair("userList", aiUserList));
        result->Success(NimResult::getSuccessResult(resultMap));
      },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void FLTAIService::proxyAIModelCall(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  v2::V2NIMProxyAIModelCallParams params;

  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("params")) {
      auto paramsMap = std::get<flutter::EncodableMap>(iter->second);
      params = getProxyAIModelCallParams(&paramsMap);
    }
  }

  auto& instance = v2::V2NIMClient::get();
  auto& aiService = instance.getAIService();
  aiService.proxyAIModelCall(
      params, [result]() { result->Success(NimResult::getSuccessResult()); },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

flutter::EncodableMap convertNIMAIUser(
    const nstd::shared_ptr<v2::V2NIMAIUser> object) {
  flutter::EncodableMap resultMap;

  resultMap.insert(std::make_pair("accountId", object->accountId));
  resultMap.insert(std::make_pair("name", object->name.value()));
  resultMap.insert(std::make_pair("avatar", object->avatar.value()));
  resultMap.insert(std::make_pair("sign", object->sign.value()));
  resultMap.insert(std::make_pair("email", object->email.value()));
  resultMap.insert(std::make_pair("birthday", object->birthday.value()));
  resultMap.insert(std::make_pair("mobile", object->mobile.value()));
  if (object->gender.has_value()) {
    resultMap.insert(
        std::make_pair("gender", static_cast<int32_t>(object->gender.value())));
  }
  resultMap.insert(
      std::make_pair("serverExtension", object->serverExtension.value()));
  resultMap.insert(
      std::make_pair("createTime", static_cast<int64_t>(object->createTime)));
  resultMap.insert(
      std::make_pair("updateTime", static_cast<int64_t>(object->updateTime)));

  resultMap.insert(std::make_pair("modelType", object->modelType));

  flutter::EncodableMap modelConfig = convertAIModelConfig(object->modelConfig);
  resultMap.insert(std::make_pair("modelConfig", modelConfig));
  return resultMap;
}

v2::V2NIMProxyAIModelCallParams getProxyAIModelCallParams(
    const flutter::EncodableMap* arguments) {
  v2::V2NIMProxyAIModelCallParams object;
  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("accountId")) {
      object.accountId = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("requestId")) {
      object.requestId = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("content")) {
      auto contentMap = std::get<flutter::EncodableMap>(iter->second);
      object.content = getAIModelCallContent(&contentMap);
    } else if (iter->first == flutter::EncodableValue("messages")) {
      std::vector<v2::V2NIMAIModelCallMessage> messageList;
      auto messageListMap = std::get<flutter::EncodableList>(iter->second);
      for (auto& it : messageListMap) {
        auto message = std::get<flutter::EncodableMap>(it);
        messageList.emplace_back(getAIModelCallMessage(&message));
      }
      object.messages = messageList;
    } else if (iter->first == flutter::EncodableValue("promptVariables")) {
      object.promptVariables = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("modelConfigParams")) {
      auto modelConfigParamsMap = std::get<flutter::EncodableMap>(iter->second);
      object.modelConfigParams = getAIModelConfigParams(&modelConfigParamsMap);
    } else if (iter->first == flutter::EncodableValue("antispamConfig")) {
      auto antispamConfigMap = std::get<flutter::EncodableMap>(iter->second);
      object.antispamConfig = getProxyAICallAntispamConfig(&antispamConfigMap);
    }
  }
  return object;
}

flutter::EncodableMap convertProxyAIModelCallParams(
    const v2::V2NIMProxyAIModelCallParams object) {
  flutter::EncodableMap resultMap;

  resultMap.insert(std::make_pair("accountId", object.accountId));
  resultMap.insert(std::make_pair("requestId", object.requestId));

  flutter::EncodableMap content = convertAIModelCallContent(object.content);
  resultMap.insert(std::make_pair("content", content));

  if (object.messages.has_value()) {
    flutter::EncodableList messageList;
    auto messages = object.messages.value();
    for (auto message : messages) {
      messageList.emplace_back(convertAIModelCallMessage(message));
    }
    resultMap.insert(std::make_pair("messages", messageList));
  }

  resultMap.insert(
      std::make_pair("promptVariables", object.promptVariables.value()));

  if (object.modelConfigParams.has_value()) {
    flutter::EncodableMap modelConfigParams =
        convertAIModelConfigParams(object.modelConfigParams.value());
    resultMap.insert(std::make_pair("modelConfigParams", modelConfigParams));
  }

  if (object.antispamConfig.has_value()) {
    flutter::EncodableMap antispamConfig =
        convertProxyAICallAntispamConfig(object.antispamConfig.value());
    resultMap.insert(std::make_pair("antispamConfig", antispamConfig));
  }
  return resultMap;
}

v2::V2NIMProxyAICallAntispamConfig getProxyAICallAntispamConfig(
    const flutter::EncodableMap* arguments) {
  v2::V2NIMProxyAICallAntispamConfig object;
  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("antispamEnabled")) {
      object.antispamEnabled = std::get<bool>(iter->second);
    } else if (iter->first == flutter::EncodableValue("antispamBusinessId")) {
      object.antispamBusinessId = std::get<std::string>(iter->second);
    }
  }
  return object;
}

flutter::EncodableMap convertProxyAICallAntispamConfig(
    const v2::V2NIMProxyAICallAntispamConfig object) {
  flutter::EncodableMap resultMap;

  resultMap.insert(
      std::make_pair("antispamEnabled", object.antispamEnabled.value()));
  resultMap.insert(
      std::make_pair("antispamBusinessId", object.antispamBusinessId.value()));
  return resultMap;
}

flutter::EncodableMap convertAIModelCallResult(
    const v2::V2NIMAIModelCallResult object) {
  flutter::EncodableMap resultMap;

  resultMap.insert(std::make_pair("code", static_cast<int32_t>(object.code)));
  resultMap.insert(std::make_pair("accountId", object.accountId));
  resultMap.insert(std::make_pair("requestId", object.requestId));

  if (object.content.has_value()) {
    flutter::EncodableMap content =
        convertAIModelCallContent(object.content.value());
    resultMap.insert(std::make_pair("content", content));
  }
  return resultMap;
}

flutter::EncodableMap convertAIModelConfig(
    const v2::V2NIMAIModelConfig object) {
  flutter::EncodableMap resultMap;

  resultMap.insert(std::make_pair("model", object.model));
  resultMap.insert(std::make_pair("prompt", object.prompt));

  if (object.promptKeys.has_value()) {
    flutter::EncodableList promptKeyList;
    auto promptKeys = object.promptKeys.value();
    for (auto promptKey : promptKeys) {
      promptKeyList.emplace_back(promptKey);
    }
    resultMap.insert(std::make_pair("promptKeyList", promptKeyList));
  }

  if (object.maxTokens.has_value()) {
    resultMap.insert(std::make_pair(
        "maxTokens", static_cast<int32_t>(object.maxTokens.value())));
  }
  if (object.topP.has_value()) {
    resultMap.insert(std::make_pair("topP", std::stod(object.topP.value())));
  }
  if (object.temperature.has_value()) {
    resultMap.insert(
        std::make_pair("temperature", std::stod(object.temperature.value())));
  }
  return resultMap;
}
