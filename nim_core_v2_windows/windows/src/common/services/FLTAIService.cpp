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

v2::V2NIMCreateUserAIBotParams getCreateUserAIBotParams(
    const flutter::EncodableMap* arguments);

v2::V2NIMUpdateUserAIBotParams getUpdateUserAIBotParams(
    const flutter::EncodableMap* arguments);

v2::V2NIMDeleteUserAIBotParams getDeleteUserAIBotParams(
    const flutter::EncodableMap* arguments);

v2::V2NIMGetUserAIBotParams getGetUserAIBotParams(
    const flutter::EncodableMap* arguments);

v2::V2NIMGetUserAIBotListParams getGetUserAIBotListParams(
    const flutter::EncodableMap* arguments);

v2::V2NIMBindUserAIBotToQrCodeParams getBindUserAIBotToQrCodeParams(
    const flutter::EncodableMap* arguments);

v2::V2NIMRefreshUserAIBotTokenParams getRefreshUserAIBotTokenParams(
    const flutter::EncodableMap* arguments);

flutter::EncodableMap convertUserAIBot(const v2::V2NIMUserAIBot object);

flutter::EncodableMap convertCreateUserAIBotResult(
    const v2::V2NIMCreateUserAIBotResult object);

flutter::EncodableMap convertGetUserAIBotListResult(
    const v2::V2NIMGetUserAIBotListResult object);

flutter::EncodableMap convertRefreshUserAIBotTokenResult(
    const v2::V2NIMRefreshUserAIBotTokenResult object);

FLTAIService::FLTAIService() {
  m_serviceName = "AIService";

  listener.onProxyAIModelCall = [this](v2::V2NIMAIModelCallResult response) {
    flutter::EncodableMap resultMap = convertAIModelCallResult(response);
    notifyEvent("onProxyAIModelCall", resultMap);
  };

  listener.onProxyAIModelStreamCall =
      [this](v2::V2NIMAIModelStreamCallResult response) {
        flutter::EncodableMap resultMap;
        resultMap.insert(
            std::make_pair("code", static_cast<int32_t>(response.code)));
        resultMap.insert(std::make_pair("accountId", response.accountId));
        resultMap.insert(std::make_pair("requestId", response.requestId));
        resultMap.insert(std::make_pair(
            "timestamp", static_cast<int64_t>(response.timestamp)));
        if (response.content.has_value()) {
          const auto& c = response.content.value();
          flutter::EncodableMap contentMap;
          contentMap.insert(std::make_pair("msg", c.msg));
          contentMap.insert(
              std::make_pair("type", static_cast<int32_t>(c.type)));
          // lastChunk
          flutter::EncodableMap chunkMap;
          chunkMap.insert(std::make_pair("content", c.lastChunk.content));
          chunkMap.insert(std::make_pair(
              "chunkTime", static_cast<int64_t>(c.lastChunk.chunkTime)));
          chunkMap.insert(
              std::make_pair("type", static_cast<int32_t>(c.lastChunk.type)));
          chunkMap.insert(
              std::make_pair("index", static_cast<int32_t>(c.lastChunk.index)));
          contentMap.insert(std::make_pair("lastChunk", chunkMap));
          resultMap.insert(std::make_pair("content", contentMap));
        }
        notifyEvent("onProxyAIModelStreamCall", resultMap);
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
    case "stopAIModelStreamCall"_hash:
      stopAIModelStreamCall(arguments, result);
      return;
    case "createUserAIBot"_hash:
      createUserAIBot(arguments, result);
      return;
    case "deleteUserAIBot"_hash:
      deleteUserAIBot(arguments, result);
      return;
    case "updateUserAIBot"_hash:
      updateUserAIBot(arguments, result);
      return;
    case "getUserAIBot"_hash:
      getUserAIBot(arguments, result);
      return;
    case "getUserAIBotList"_hash:
      getUserAIBotList(arguments, result);
      return;
    case "bindUserAIBotToQrCode"_hash:
      bindUserAIBotToQrCode(arguments, result);
      return;
    case "refreshUserAIBotToken"_hash:
      refreshUserAIBotToken(arguments, result);
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

  resultMap.insert(std::make_pair("aiModelType", object->aiModelType));

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

void FLTAIService::stopAIModelStreamCall(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  v2::V2NIMAIModelStreamCallStopParams params;

  auto iter = arguments->begin();
  for (; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("params")) {
      auto paramsMap = std::get<flutter::EncodableMap>(iter->second);
      auto pIter = paramsMap.begin();
      for (; pIter != paramsMap.end(); ++pIter) {
        if (pIter->second.IsNull()) {
          continue;
        }
        if (pIter->first == flutter::EncodableValue("accountId")) {
          params.accountId = std::get<std::string>(pIter->second);
        } else if (pIter->first == flutter::EncodableValue("requestId")) {
          params.requestId = std::get<std::string>(pIter->second);
        }
      }
    }
  }

  auto& instance = v2::V2NIMClient::get();
  auto& aiService = instance.getAIService();
  aiService.stopAIModelStreamCall(
      params, [result]() { result->Success(NimResult::getSuccessResult()); },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void FLTAIService::createUserAIBot(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  v2::V2NIMCreateUserAIBotParams params;
  auto paramsIter = arguments->find(flutter::EncodableValue("params"));
  if (paramsIter != arguments->end() && !paramsIter->second.IsNull()) {
    auto paramsMap = std::get<flutter::EncodableMap>(paramsIter->second);
    params = getCreateUserAIBotParams(&paramsMap);
  }

  auto& aiService = v2::V2NIMClient::get().getAIService();
  aiService.createUserAIBot(
      params,
      [result](v2::V2NIMCreateUserAIBotResult botResult) {
        result->Success(NimResult::getSuccessResult(
            convertCreateUserAIBotResult(botResult)));
      },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void FLTAIService::deleteUserAIBot(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  v2::V2NIMDeleteUserAIBotParams params;
  auto paramsIter = arguments->find(flutter::EncodableValue("params"));
  if (paramsIter != arguments->end() && !paramsIter->second.IsNull()) {
    auto paramsMap = std::get<flutter::EncodableMap>(paramsIter->second);
    params = getDeleteUserAIBotParams(&paramsMap);
  }

  auto& aiService = v2::V2NIMClient::get().getAIService();
  aiService.deleteUserAIBot(
      params, [result]() { result->Success(NimResult::getSuccessResult()); },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void FLTAIService::updateUserAIBot(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  v2::V2NIMUpdateUserAIBotParams params;
  auto paramsIter = arguments->find(flutter::EncodableValue("params"));
  if (paramsIter != arguments->end() && !paramsIter->second.IsNull()) {
    auto paramsMap = std::get<flutter::EncodableMap>(paramsIter->second);
    params = getUpdateUserAIBotParams(&paramsMap);
  }

  auto& aiService = v2::V2NIMClient::get().getAIService();
  aiService.updateUserAIBot(
      params, [result]() { result->Success(NimResult::getSuccessResult()); },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void FLTAIService::getUserAIBot(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  v2::V2NIMGetUserAIBotParams params;
  auto paramsIter = arguments->find(flutter::EncodableValue("params"));
  if (paramsIter != arguments->end() && !paramsIter->second.IsNull()) {
    auto paramsMap = std::get<flutter::EncodableMap>(paramsIter->second);
    params = getGetUserAIBotParams(&paramsMap);
  }

  auto& aiService = v2::V2NIMClient::get().getAIService();
  aiService.getUserAIBot(
      params,
      [result](v2::V2NIMUserAIBot bot) {
        result->Success(NimResult::getSuccessResult(convertUserAIBot(bot)));
      },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void FLTAIService::getUserAIBotList(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  v2::V2NIMGetUserAIBotListParams params;
  auto paramsIter = arguments->find(flutter::EncodableValue("params"));
  if (paramsIter != arguments->end() && !paramsIter->second.IsNull()) {
    auto paramsMap = std::get<flutter::EncodableMap>(paramsIter->second);
    params = getGetUserAIBotListParams(&paramsMap);
  }

  auto& aiService = v2::V2NIMClient::get().getAIService();
  aiService.getUserAIBotList(
      params,
      [result](v2::V2NIMGetUserAIBotListResult listResult) {
        result->Success(NimResult::getSuccessResult(
            convertGetUserAIBotListResult(listResult)));
      },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void FLTAIService::bindUserAIBotToQrCode(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  v2::V2NIMBindUserAIBotToQrCodeParams params;
  auto paramsIter = arguments->find(flutter::EncodableValue("params"));
  if (paramsIter != arguments->end() && !paramsIter->second.IsNull()) {
    auto paramsMap = std::get<flutter::EncodableMap>(paramsIter->second);
    params = getBindUserAIBotToQrCodeParams(&paramsMap);
  }

  auto& aiService = v2::V2NIMClient::get().getAIService();
  aiService.bindUserAIBotToQrCode(
      params, [result]() { result->Success(NimResult::getSuccessResult()); },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void FLTAIService::refreshUserAIBotToken(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  v2::V2NIMRefreshUserAIBotTokenParams params;
  auto paramsIter = arguments->find(flutter::EncodableValue("params"));
  if (paramsIter != arguments->end() && !paramsIter->second.IsNull()) {
    auto paramsMap = std::get<flutter::EncodableMap>(paramsIter->second);
    params = getRefreshUserAIBotTokenParams(&paramsMap);
  }

  auto& aiService = v2::V2NIMClient::get().getAIService();
  aiService.refreshUserAIBotToken(
      params,
      [result](v2::V2NIMRefreshUserAIBotTokenResult tokenResult) {
        result->Success(NimResult::getSuccessResult(
            convertRefreshUserAIBotTokenResult(tokenResult)));
      },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

v2::V2NIMCreateUserAIBotParams getCreateUserAIBotParams(
    const flutter::EncodableMap* arguments) {
  v2::V2NIMCreateUserAIBotParams object;
  for (auto iter = arguments->begin(); iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("accid")) {
      object.accountId = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("name")) {
      object.name = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("icon")) {
      object.avatar = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("sign")) {
      object.sign = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("ex")) {
      object.serverExtension = std::get<std::string>(iter->second);
    }
  }
  return object;
}

v2::V2NIMUpdateUserAIBotParams getUpdateUserAIBotParams(
    const flutter::EncodableMap* arguments) {
  v2::V2NIMUpdateUserAIBotParams object;
  for (auto iter = arguments->begin(); iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("accid")) {
      object.accountId = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("name")) {
      object.name = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("icon")) {
      object.avatar = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("sign")) {
      object.sign = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("ex")) {
      object.serverExtension = std::get<std::string>(iter->second);
    }
  }
  return object;
}

v2::V2NIMDeleteUserAIBotParams getDeleteUserAIBotParams(
    const flutter::EncodableMap* arguments) {
  v2::V2NIMDeleteUserAIBotParams object;
  auto iter = arguments->find(flutter::EncodableValue("accid"));
  if (iter != arguments->end() && !iter->second.IsNull()) {
    object.accountId = std::get<std::string>(iter->second);
  }
  return object;
}

v2::V2NIMGetUserAIBotParams getGetUserAIBotParams(
    const flutter::EncodableMap* arguments) {
  v2::V2NIMGetUserAIBotParams object;
  auto iter = arguments->find(flutter::EncodableValue("accid"));
  if (iter != arguments->end() && !iter->second.IsNull()) {
    object.accountId = std::get<std::string>(iter->second);
  }
  return object;
}

v2::V2NIMGetUserAIBotListParams getGetUserAIBotListParams(
    const flutter::EncodableMap* arguments) {
  v2::V2NIMGetUserAIBotListParams object;
  for (auto iter = arguments->begin(); iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("pageToken")) {
      object.pageToken = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("limit")) {
      object.limit = static_cast<uint32_t>(iter->second.LongValue());
    }
  }
  return object;
}

v2::V2NIMBindUserAIBotToQrCodeParams getBindUserAIBotToQrCodeParams(
    const flutter::EncodableMap* arguments) {
  v2::V2NIMBindUserAIBotToQrCodeParams object;
  for (auto iter = arguments->begin(); iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("accid")) {
      object.accountId = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("token")) {
      object.token = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("qrCode")) {
      object.qrCode = std::get<std::string>(iter->second);
    }
  }
  return object;
}

v2::V2NIMRefreshUserAIBotTokenParams getRefreshUserAIBotTokenParams(
    const flutter::EncodableMap* arguments) {
  v2::V2NIMRefreshUserAIBotTokenParams object;
  auto iter = arguments->find(flutter::EncodableValue("accid"));
  if (iter != arguments->end() && !iter->second.IsNull()) {
    object.accountId = std::get<std::string>(iter->second);
  }
  return object;
}

flutter::EncodableMap convertUserAIBot(const v2::V2NIMUserAIBot object) {
  flutter::EncodableMap resultMap;
  resultMap.insert(std::make_pair("accid", object.accountId));
  if (object.name.has_value()) {
    resultMap.insert(std::make_pair("name", object.name.value()));
  }
  if (object.avatar.has_value()) {
    resultMap.insert(std::make_pair("icon", object.avatar.value()));
  }
  if (object.sign.has_value()) {
    resultMap.insert(std::make_pair("sign", object.sign.value()));
  }
  if (object.gender.has_value()) {
    resultMap.insert(std::make_pair("gender", object.gender.value()));
  }
  if (object.email.has_value()) {
    resultMap.insert(std::make_pair("email", object.email.value()));
  }
  if (object.birthday.has_value()) {
    resultMap.insert(std::make_pair("birth", object.birthday.value()));
  }
  if (object.mobile.has_value()) {
    resultMap.insert(std::make_pair("mobile", object.mobile.value()));
  }
  if (object.serverExtension.has_value()) {
    resultMap.insert(std::make_pair("ex", object.serverExtension.value()));
  }
  if (object.type.has_value()) {
    resultMap.insert(std::make_pair("type", object.type.value()));
  }
  if (object.validFlag.has_value()) {
    resultMap.insert(std::make_pair("validFlag", object.validFlag.value()));
  }
  if (object.createTime.has_value()) {
    resultMap.insert(std::make_pair(
        "createTime", static_cast<int64_t>(object.createTime.value())));
  }
  if (object.updateTime.has_value()) {
    resultMap.insert(std::make_pair(
        "updateTime", static_cast<int64_t>(object.updateTime.value())));
  }
  if (object.ownerId.has_value()) {
    resultMap.insert(std::make_pair("ownerid", object.ownerId.value()));
  }
  if (object.token.has_value()) {
    resultMap.insert(std::make_pair("token", object.token.value()));
  }
  return resultMap;
}

flutter::EncodableMap convertCreateUserAIBotResult(
    const v2::V2NIMCreateUserAIBotResult object) {
  flutter::EncodableMap resultMap;
  resultMap.insert(std::make_pair("token", object.token));
  return resultMap;
}

flutter::EncodableMap convertGetUserAIBotListResult(
    const v2::V2NIMGetUserAIBotListResult object) {
  flutter::EncodableMap resultMap;
  flutter::EncodableList bots;
  for (auto bot : object.bots) {
    bots.emplace_back(convertUserAIBot(bot));
  }
  resultMap.insert(std::make_pair("bots", bots));
  resultMap.insert(std::make_pair("hasMore", object.hasMore));
  if (object.nextToken.has_value()) {
    resultMap.insert(std::make_pair("nextToken", object.nextToken.value()));
  }
  return resultMap;
}

flutter::EncodableMap convertRefreshUserAIBotTokenResult(
    const v2::V2NIMRefreshUserAIBotTokenResult object) {
  flutter::EncodableMap resultMap;
  resultMap.insert(std::make_pair("token", object.token));
  return resultMap;
}
