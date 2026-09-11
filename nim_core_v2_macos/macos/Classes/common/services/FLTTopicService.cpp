// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#include "FLTTopicService.h"

#include "../NimResult.h"
#include "FLTMessageService.h"
#include "nim_cpp_wrapper/nim_cpp_api.h"

flutter::EncodableMap convertTopicRefer(const v2::V2NIMTopicRefer object);
flutter::EncodableMap convertTopic(const v2::V2NIMTopic object);
flutter::EncodableMap convertTopicListResult(
    const v2::V2NIMTopicListResult object);
flutter::EncodableMap convertTopicMessageListResult(
    const v2::V2NIMTopicMessageListResult object);

v2::V2NIMTopicRefer getTopicRefer(const flutter::EncodableMap* arguments);
v2::V2NIMTopic getTopic(const flutter::EncodableMap* arguments);
v2::V2NIMUpdateTopicParams getUpdateTopicParams(
    const flutter::EncodableMap* arguments);
v2::V2NIMRemoveTopicsParams getRemoveTopicsParams(
    const flutter::EncodableMap* arguments);
v2::V2NIMCreateTopicParams getCreateTopicParams(
    const flutter::EncodableMap* arguments);
v2::V2NIMSendTopicMessageParams getSendTopicMessageParams(
    const flutter::EncodableMap* arguments);
v2::V2NIMTopicListOption getTopicListOption(
    const flutter::EncodableMap* arguments);
v2::V2NIMTopicMessageListOption getTopicMessageListOption(
    const flutter::EncodableMap* arguments);

std::string topicIdToString(const flutter::EncodableValue& value) {
  if (auto topicId = std::get_if<std::string>(&value)) {
    return *topicId;
  }
  return std::to_string(value.LongValue());
}

int64_t topicIdToInt64(const std::string& topicId) {
  try {
    return std::stoll(topicId);
  } catch (...) {
    return 0;
  }
}

FLTTopicService::FLTTopicService() {
  m_serviceName = "TopicService";

  listener.onTopicAdded = [this](v2::V2NIMTopic topic) {
    flutter::EncodableMap resultMap = convertTopic(topic);
    notifyEvent("onTopicAdded", resultMap);
  };

  listener.onTopicsRemoved =
      [this](nstd::vector<v2::V2NIMTopicRefer> topicRefers) {
        flutter::EncodableList topicList;
        for (auto topicRefer : topicRefers) {
          topicList.emplace_back(convertTopicRefer(topicRefer));
        }
        flutter::EncodableMap resultMap;
        resultMap.insert(std::make_pair("topics", topicList));
        notifyEvent("onTopicsRemoved", resultMap);
      };

  listener.onTopicUpdated = [this](v2::V2NIMTopic topic) {
    flutter::EncodableMap resultMap = convertTopic(topic);
    notifyEvent("onTopicUpdated", resultMap);
  };

  auto& topicService = v2::V2NIMClient::get().getTopicService();
  topicService.addTopicListener(listener);
}

FLTTopicService::~FLTTopicService() {
  auto& topicService = v2::V2NIMClient::get().getTopicService();
  topicService.removeTopicListener(listener);
}

void FLTTopicService::onMethodCalled(
    const std::string& method, const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  switch (utils::hash_(method.c_str())) {
    case "removeTopics"_hash:
      removeTopics(arguments, result);
      return;
    case "updateTopic"_hash:
      updateTopic(arguments, result);
      return;
    case "sendTopicMessage"_hash:
      sendTopicMessage(arguments, result);
      return;
    case "replyTopicMessage"_hash:
      replyTopicMessage(arguments, result);
      return;
    case "getTopicByRefer"_hash:
      getTopicByRefer(arguments, result);
      return;
    case "getTopicListByOption"_hash:
      getTopicListByOption(arguments, result);
      return;
    case "getTopicMessageList"_hash:
      getTopicMessageList(arguments, result);
      return;
    default:
      break;
  }
  if (result) result->NotImplemented();
}

void FLTTopicService::removeTopics(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  v2::V2NIMRemoveTopicsParams params;
  auto paramsIter = arguments->find(flutter::EncodableValue("params"));
  if (paramsIter != arguments->end() && !paramsIter->second.IsNull()) {
    auto paramsMap = std::get<flutter::EncodableMap>(paramsIter->second);
    params = getRemoveTopicsParams(&paramsMap);
  }

  auto& topicService = v2::V2NIMClient::get().getTopicService();
  topicService.removeTopics(
      params, [result]() { result->Success(NimResult::getSuccessResult()); },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void FLTTopicService::updateTopic(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  v2::V2NIMUpdateTopicParams params;
  auto paramsIter = arguments->find(flutter::EncodableValue("params"));
  if (paramsIter != arguments->end() && !paramsIter->second.IsNull()) {
    auto paramsMap = std::get<flutter::EncodableMap>(paramsIter->second);
    params = getUpdateTopicParams(&paramsMap);
  }

  auto& topicService = v2::V2NIMClient::get().getTopicService();
  topicService.updateTopic(
      params,
      [result](const v2::V2NIMTopic& topic) {
        result->Success(NimResult::getSuccessResult(convertTopic(topic)));
      },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void FLTTopicService::sendTopicMessage(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  v2::V2NIMMessage message;
  std::string conversationId;
  nstd::optional<v2::V2NIMTopic> topic;
  v2::V2NIMSendTopicMessageParams params;

  for (auto iter = arguments->begin(); iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("message")) {
      auto messageMap = std::get<flutter::EncodableMap>(iter->second);
      message = getMessage(&messageMap);
    } else if (iter->first == flutter::EncodableValue("conversationId")) {
      conversationId = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("topic")) {
      auto topicMap = std::get<flutter::EncodableMap>(iter->second);
      topic = getTopic(&topicMap);
    } else if (iter->first == flutter::EncodableValue("params")) {
      auto paramsMap = std::get<flutter::EncodableMap>(iter->second);
      params = getSendTopicMessageParams(&paramsMap);
    }
  }

  if (!topic.has_value() && !params.createTopicParams.has_value()) {
    params.createTopicParams = v2::V2NIMCreateTopicParams();
  }

  auto& topicService = v2::V2NIMClient::get().getTopicService();
  topicService.sendTopicMessage(
      message, conversationId, topic, params,
      [result](v2::V2NIMSendMessageResult msgResult) {
        result->Success(
            NimResult::getSuccessResult(convertSendMessageResult(msgResult)));
      },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      },
      [=](uint32_t progress) {});
}

void FLTTopicService::replyTopicMessage(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  v2::V2NIMMessage message;
  v2::V2NIMMessage replyMessage;
  v2::V2NIMTopic topic;
  v2::V2NIMSendMessageParams params;

  for (auto iter = arguments->begin(); iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("message")) {
      auto messageMap = std::get<flutter::EncodableMap>(iter->second);
      message = getMessage(&messageMap);
    } else if (iter->first == flutter::EncodableValue("replyMessage")) {
      auto messageMap = std::get<flutter::EncodableMap>(iter->second);
      replyMessage = getMessage(&messageMap);
    } else if (iter->first == flutter::EncodableValue("topic")) {
      auto topicMap = std::get<flutter::EncodableMap>(iter->second);
      topic = getTopic(&topicMap);
    } else if (iter->first == flutter::EncodableValue("params")) {
      auto paramsMap = std::get<flutter::EncodableMap>(iter->second);
      params = getSendMessageParams(&paramsMap);
    }
  }

  auto& topicService = v2::V2NIMClient::get().getTopicService();
  topicService.replyTopicMessage(
      message, replyMessage, topic, params,
      [result](v2::V2NIMSendMessageResult msgResult) {
        result->Success(
            NimResult::getSuccessResult(convertSendMessageResult(msgResult)));
      },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      },
      [=](uint32_t progress) {});
}

void FLTTopicService::getTopicByRefer(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  v2::V2NIMTopicRefer topicRefer;
  auto referIter = arguments->find(flutter::EncodableValue("topicRefer"));
  if (referIter != arguments->end() && !referIter->second.IsNull()) {
    auto referMap = std::get<flutter::EncodableMap>(referIter->second);
    topicRefer = getTopicRefer(&referMap);
  }

  auto& topicService = v2::V2NIMClient::get().getTopicService();
  topicService.getTopicByRefer(
      topicRefer,
      [result](const v2::V2NIMTopic& topic) {
        result->Success(NimResult::getSuccessResult(convertTopic(topic)));
      },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void FLTTopicService::getTopicListByOption(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  v2::V2NIMTopicListOption option;
  auto optionIter = arguments->find(flutter::EncodableValue("option"));
  if (optionIter != arguments->end() && !optionIter->second.IsNull()) {
    auto optionMap = std::get<flutter::EncodableMap>(optionIter->second);
    option = getTopicListOption(&optionMap);
  }

  auto& topicService = v2::V2NIMClient::get().getTopicService();
  topicService.getTopicListByOption(
      option,
      [result](const v2::V2NIMTopicListResult& listResult) {
        result->Success(
            NimResult::getSuccessResult(convertTopicListResult(listResult)));
      },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void FLTTopicService::getTopicMessageList(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  v2::V2NIMTopicMessageListOption option;
  auto optionIter = arguments->find(flutter::EncodableValue("option"));
  if (optionIter != arguments->end() && !optionIter->second.IsNull()) {
    auto optionMap = std::get<flutter::EncodableMap>(optionIter->second);
    option = getTopicMessageListOption(&optionMap);
  }

  auto& topicService = v2::V2NIMClient::get().getTopicService();
  topicService.getTopicMessageList(
      option,
      [result](const v2::V2NIMTopicMessageListResult& listResult) {
        result->Success(NimResult::getSuccessResult(
            convertTopicMessageListResult(listResult)));
      },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

flutter::EncodableMap convertTopicRefer(const v2::V2NIMTopicRefer object) {
  flutter::EncodableMap resultMap;
  resultMap.insert(std::make_pair("conversationId", object.conversationId));
  resultMap.insert(std::make_pair("topicId", topicIdToInt64(object.topicId)));
  resultMap.insert(
      std::make_pair("createTime", static_cast<int64_t>(object.createTime)));
  return resultMap;
}

flutter::EncodableMap convertTopic(const v2::V2NIMTopic object) {
  flutter::EncodableMap resultMap;
  resultMap.insert(std::make_pair("conversationId", object.conversationId));
  resultMap.insert(std::make_pair("topicId", topicIdToInt64(object.topicId)));
  resultMap.insert(
      std::make_pair("createTime", static_cast<int64_t>(object.createTime)));
  resultMap.insert(std::make_pair("topicName", object.topicName));
  resultMap.insert(std::make_pair("messageClientId", object.messageClientId));
  resultMap.insert(std::make_pair("messageServerId", object.messageServerId));
  resultMap.insert(
      std::make_pair("messageTime", static_cast<int64_t>(object.messageTime)));
  if (object.serverExtension.has_value()) {
    resultMap.insert(
        std::make_pair("serverExtension", object.serverExtension.value()));
  }
  resultMap.insert(
      std::make_pair("updateTime", static_cast<int64_t>(object.updateTime)));
  return resultMap;
}

flutter::EncodableMap convertTopicListResult(
    const v2::V2NIMTopicListResult object) {
  flutter::EncodableMap resultMap;
  flutter::EncodableList topicList;
  for (auto topic : object.topicList) {
    topicList.emplace_back(convertTopic(topic));
  }
  resultMap.insert(std::make_pair("topicList", topicList));
  resultMap.insert(std::make_pair("nextToken", object.nextToken));
  resultMap.insert(std::make_pair("hasMore", object.hasMore));
  return resultMap;
}

flutter::EncodableMap convertTopicMessageListResult(
    const v2::V2NIMTopicMessageListResult object) {
  flutter::EncodableMap resultMap;
  flutter::EncodableList replyList;
  for (auto message : object.replyList) {
    replyList.emplace_back(convertMessage(message));
  }
  resultMap.insert(std::make_pair("replyList", replyList));
  resultMap.insert(std::make_pair("hasMore", object.hasMore));
  if (object.anchorMessage.has_value()) {
    resultMap.insert(
        std::make_pair("anchorMessage", convertMessage(object.anchorMessage)));
  }
  return resultMap;
}

v2::V2NIMTopicRefer getTopicRefer(const flutter::EncodableMap* arguments) {
  v2::V2NIMTopicRefer object;
  for (auto iter = arguments->begin(); iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("conversationId")) {
      object.conversationId = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("topicId")) {
      object.topicId = topicIdToString(iter->second);
    } else if (iter->first == flutter::EncodableValue("createTime")) {
      object.createTime = iter->second.LongValue();
    }
  }
  return object;
}

v2::V2NIMTopic getTopic(const flutter::EncodableMap* arguments) {
  v2::V2NIMTopic object;
  for (auto iter = arguments->begin(); iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("conversationId")) {
      object.conversationId = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("topicId")) {
      object.topicId = topicIdToString(iter->second);
    } else if (iter->first == flutter::EncodableValue("createTime")) {
      object.createTime = iter->second.LongValue();
    } else if (iter->first == flutter::EncodableValue("topicName")) {
      object.topicName = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("messageClientId")) {
      object.messageClientId = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("messageServerId")) {
      object.messageServerId = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("messageTime")) {
      object.messageTime = iter->second.LongValue();
    } else if (iter->first == flutter::EncodableValue("serverExtension")) {
      object.serverExtension = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("updateTime")) {
      object.updateTime = iter->second.LongValue();
    }
  }
  return object;
}

v2::V2NIMUpdateTopicParams getUpdateTopicParams(
    const flutter::EncodableMap* arguments) {
  v2::V2NIMUpdateTopicParams object;
  for (auto iter = arguments->begin(); iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("topic")) {
      auto topicMap = std::get<flutter::EncodableMap>(iter->second);
      object.topic = getTopic(&topicMap);
    } else if (iter->first == flutter::EncodableValue("topicName")) {
      object.topicName = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("serverExtension")) {
      object.serverExtension = std::get<std::string>(iter->second);
    }
  }
  return object;
}

v2::V2NIMRemoveTopicsParams getRemoveTopicsParams(
    const flutter::EncodableMap* arguments) {
  v2::V2NIMRemoveTopicsParams object;
  auto iter = arguments->find(flutter::EncodableValue("topicList"));
  if (iter != arguments->end() && !iter->second.IsNull()) {
    auto topicList = std::get<flutter::EncodableList>(iter->second);
    for (auto topicValue : topicList) {
      auto topicMap = std::get<flutter::EncodableMap>(topicValue);
      object.topicList.push_back(getTopic(&topicMap));
    }
  }
  return object;
}

v2::V2NIMCreateTopicParams getCreateTopicParams(
    const flutter::EncodableMap* arguments) {
  v2::V2NIMCreateTopicParams object;
  for (auto iter = arguments->begin(); iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("topicName")) {
      object.topicName = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("serverExtension")) {
      object.serverExtension = std::get<std::string>(iter->second);
    }
  }
  return object;
}

v2::V2NIMSendTopicMessageParams getSendTopicMessageParams(
    const flutter::EncodableMap* arguments) {
  v2::V2NIMSendTopicMessageParams object;
  for (auto iter = arguments->begin(); iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("sendMessageParams")) {
      auto paramsMap = std::get<flutter::EncodableMap>(iter->second);
      object.sendMessageParams = getSendMessageParams(&paramsMap);
    } else if (iter->first == flutter::EncodableValue("createTopicParams")) {
      auto paramsMap = std::get<flutter::EncodableMap>(iter->second);
      object.createTopicParams = getCreateTopicParams(&paramsMap);
    }
  }
  return object;
}

v2::V2NIMTopicListOption getTopicListOption(
    const flutter::EncodableMap* arguments) {
  v2::V2NIMTopicListOption object;
  for (auto iter = arguments->begin(); iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("conversationId")) {
      object.conversationId = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("beginTime")) {
      object.beginTime = iter->second.LongValue();
    } else if (iter->first == flutter::EncodableValue("endTime")) {
      object.endTime = iter->second.LongValue();
    } else if (iter->first == flutter::EncodableValue("nextToken")) {
      object.nextToken = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("limit")) {
      object.limit = static_cast<uint32_t>(iter->second.LongValue());
    } else if (iter->first == flutter::EncodableValue("direction")) {
      object.direction = v2::V2NIMQueryDirection(
          static_cast<int32_t>(iter->second.LongValue()));
    }
  }
  return object;
}

v2::V2NIMTopicMessageListOption getTopicMessageListOption(
    const flutter::EncodableMap* arguments) {
  v2::V2NIMTopicMessageListOption object;
  for (auto iter = arguments->begin(); iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("topic")) {
      auto topicMap = std::get<flutter::EncodableMap>(iter->second);
      object.topic = getTopic(&topicMap);
    } else if (iter->first == flutter::EncodableValue("beginTime")) {
      object.beginTime = iter->second.LongValue();
    } else if (iter->first == flutter::EncodableValue("endTime")) {
      object.endTime = iter->second.LongValue();
    } else if (iter->first == flutter::EncodableValue("anchorMessage")) {
      auto messageMap = std::get<flutter::EncodableMap>(iter->second);
      object.anchorMessage = getMessage(&messageMap);
    } else if (iter->first == flutter::EncodableValue("limit")) {
      object.limit = static_cast<uint32_t>(iter->second.LongValue());
    } else if (iter->first == flutter::EncodableValue("direction")) {
      object.direction = v2::V2NIMQueryDirection(
          static_cast<int32_t>(iter->second.LongValue()));
    } else if (iter->first == flutter::EncodableValue("sortOrder")) {
      object.sortOrder =
          v2::V2NIMSortOrder(static_cast<int32_t>(iter->second.LongValue()));
    }
  }
  return object;
}
