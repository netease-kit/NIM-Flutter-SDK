// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#include "FLTMessageCreator.h"

#include "../NimResult.h"
#include "FLTMessageService.h"
#include "nim_cpp_wrapper/nim_cpp_api.h"
#include "v2_nim_api.hpp"
#include "v2_nim_def_struct.hpp"

using namespace nim;

int MESSAGE_BUILD_ERROR = 199001;

FLTMessageCreator::FLTMessageCreator() {
  m_serviceName = "MessageCreatorService";
}

FLTMessageCreator::~FLTMessageCreator() {}

void FLTMessageCreator::onMethodCalled(
    const std::string& method, const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  std::cout << "method: " << method;
  if (method == "createTextMessage") {
    createTextMessage(arguments, result);
  } else if (method == "createImageMessage") {
    createImageMessage(arguments, result);
  } else if (method == "createAudioMessage") {
    createAudioMessage(arguments, result);
  } else if (method == "createVideoMessage") {
    createVideoMessage(arguments, result);
  } else if (method == "createFileMessage") {
    createFileMessage(arguments, result);
  } else if (method == "createLocationMessage") {
    createLocationMessage(arguments, result);
  } else if (method == "createCustomMessage") {
    createCustomMessage(arguments, result);
  } else if (method == "createTipsMessage") {
    createTipsMessage(arguments, result);
  } else if (method == "createForwardMessage") {
    createForwardMessage(arguments, result);
  } else if (method == "createCallMessage") {
    createCallMessage(arguments, result);
  }
}

void FLTMessageCreator::createTextMessage(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  std::string text;
  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("text")) {
      text = std::get<std::string>(iter->second);
    }
  }

  auto message = v2::V2NIMMessageCreator::createTextMessage(text);
  if (!message) {
    result->Error("", "createTextMessage failed",
                  NimResult::getErrorResult(MESSAGE_BUILD_ERROR,
                                            "createTextMessage failed"));
    return;
  }
  flutter::EncodableMap messageMap;
  messageMap = convertMessage(message);
  result->Success(NimResult::getSuccessResult(messageMap));
}

void FLTMessageCreator::createImageMessage(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  std::string imagePath;
  std::string name;
  std::string sceneName;
  int width;
  int height;
  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("imagePath")) {
      imagePath = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("name")) {
      name = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("sceneName")) {
      sceneName = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("width")) {
      width = std::get<int>(iter->second);
    } else if (iter->first == flutter::EncodableValue("height")) {
      height = std::get<int>(iter->second);
    }
  }

  auto message = v2::V2NIMMessageCreator::createImageMessage(
      imagePath, name, sceneName, width, height);
  if (!message) {
    result->Error("", "createImageMessage failed",
                  NimResult::getErrorResult(MESSAGE_BUILD_ERROR,
                                            "createImageMessage failed"));
    return;
  }
  flutter::EncodableMap messageMap;
  messageMap = convertMessage(message);
  result->Success(NimResult::getSuccessResult(messageMap));
}

void FLTMessageCreator::createAudioMessage(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  std::string audioPath;
  std::string name;
  std::string sceneName;
  int duration;
  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("audioPath")) {
      audioPath = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("name")) {
      name = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("sceneName")) {
      sceneName = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("duration")) {
      duration = std::get<int>(iter->second);
    }
  }
  auto message = v2::V2NIMMessageCreator::createAudioMessage(
      audioPath, name, sceneName, duration);
  if (!message) {
    result->Error("", "createAudioMessage failed",
                  NimResult::getErrorResult(MESSAGE_BUILD_ERROR,
                                            "createAudioMessage failed"));
    return;
  }
  flutter::EncodableMap messageMap;
  messageMap = convertMessage(message);
  result->Success(NimResult::getSuccessResult(messageMap));
}

void FLTMessageCreator::createVideoMessage(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  std::string videoPath;
  std::string name;
  std::string sceneName;
  int width;
  int height;
  int duration;
  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("videoPath")) {
      videoPath = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("name")) {
      name = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("sceneName")) {
      sceneName = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("width")) {
      width = std::get<int>(iter->second);
    } else if (iter->first == flutter::EncodableValue("height")) {
      height = std::get<int>(iter->second);
    } else if (iter->first == flutter::EncodableValue("duration")) {
      duration = std::get<int>(iter->second);
    }
  }
  auto message = v2::V2NIMMessageCreator::createVideoMessage(
      videoPath, name, sceneName, width, height, duration);
  if (!message) {
    result->Error("", "createVideoMessage failed",
                  NimResult::getErrorResult(MESSAGE_BUILD_ERROR,
                                            "createVideoMessage failed"));
    return;
  }
  flutter::EncodableMap messageMap;
  messageMap = convertMessage(message);
  result->Success(NimResult::getSuccessResult(messageMap));
}

void FLTMessageCreator::createFileMessage(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  std::string filePath;
  std::string name;
  std::string sceneName;
  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("filePath")) {
      filePath = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("name")) {
      name = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("sceneName")) {
      sceneName = std::get<std::string>(iter->second);
    }
  }
  auto message =
      v2::V2NIMMessageCreator::createFileMessage(filePath, name, sceneName);
  if (!message) {
    result->Error("", "createFileMessage failed",
                  NimResult::getErrorResult(MESSAGE_BUILD_ERROR,
                                            "createFileMessage failed"));
    return;
  }
  flutter::EncodableMap messageMap;
  messageMap = convertMessage(message);
  result->Success(NimResult::getSuccessResult(messageMap));
}

void FLTMessageCreator::createLocationMessage(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  double latitude;
  double longitude;
  std::string address;
  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("latitude")) {
      latitude = std::get<double>(iter->second);
    } else if (iter->first == flutter::EncodableValue("longitude")) {
      longitude = std::get<double>(iter->second);
    } else if (iter->first == flutter::EncodableValue("address")) {
      address = std::get<std::string>(iter->second);
    }
  }
  auto message = v2::V2NIMMessageCreator::createLocationMessage(
      latitude, longitude, address);
  if (!message) {
    result->Error("", "createLocationMessage failed",
                  NimResult::getErrorResult(MESSAGE_BUILD_ERROR,
                                            "createLocationMessage failed"));
    return;
  }
  flutter::EncodableMap messageMap;
  messageMap = convertMessage(message);
  result->Success(NimResult::getSuccessResult(messageMap));
}

void FLTMessageCreator::createCustomMessage(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  std::string text;
  std::string rawAttachment;
  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("text")) {
      text = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("rawAttachment")) {
      rawAttachment = std::get<std::string>(iter->second);
    }
  }
  auto message =
      v2::V2NIMMessageCreator::createCustomMessage(text, rawAttachment);
  if (!message) {
    result->Error("", "createCustomMessage failed",
                  NimResult::getErrorResult(MESSAGE_BUILD_ERROR,
                                            "createCustomMessage failed"));
    return;
  }
  flutter::EncodableMap messageMap;
  messageMap = convertMessage(message);
  result->Success(NimResult::getSuccessResult(messageMap));
}

void FLTMessageCreator::createTipsMessage(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  std::string text;
  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("text")) {
      text = std::get<std::string>(iter->second);
    }
  }
  auto message = v2::V2NIMMessageCreator::createTipsMessage(text);
  if (!message) {
    result->Error("", "createTipsMessage failed",
                  NimResult::getErrorResult(MESSAGE_BUILD_ERROR,
                                            "createTipsMessage failed"));
    return;
  }
  flutter::EncodableMap messageMap;
  messageMap = convertMessage(message);
  result->Success(NimResult::getSuccessResult(messageMap));
}

void FLTMessageCreator::createForwardMessage(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  v2::V2NIMMessage forwardMessage;
  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("message")) {
      const flutter::EncodableMap forwardMessageMap =
          std::get<flutter::EncodableMap>(iter->second);
      forwardMessage = getMessage(&forwardMessageMap);
    }
  }
  auto message = v2::V2NIMMessageCreator::createForwardMessage(forwardMessage);
  if (!message) {
    result->Error("", "createForwardMessage failed",
                  NimResult::getErrorResult(MESSAGE_BUILD_ERROR,
                                            "createForwardMessage failed"));
    return;
  }
  flutter::EncodableMap messageMap;
  messageMap = convertMessage(message);
  result->Success(NimResult::getSuccessResult(messageMap));
}

void FLTMessageCreator::createCallMessage(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  int type;
  std::string channelId;
  int status;
  std::string text;
  std::vector<v2::V2NIMMessageCallDuration> durations;
  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("type")) {
      type = std::get<int>(iter->second);
    } else if (iter->first == flutter::EncodableValue("channelId")) {
      channelId = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("status")) {
      status = std::get<int>(iter->second);
    } else if (iter->first == flutter::EncodableValue("text")) {
      text = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("durations")) {
      auto durationsList = std::get<flutter::EncodableList>(iter->second);
      for (auto durationMap : durationsList) {
        const flutter::EncodableMap durationMapTemp =
            std::get<flutter::EncodableMap>(durationMap);
        v2::V2NIMMessageCallDuration duration =
            getMessageCallDuration(&durationMapTemp);
        durations.emplace_back(duration);
      }
    }
  }
  auto message = v2::V2NIMMessageCreator::createCallMessage(
      type, channelId, status, durations, text);
  if (!message) {
    result->Error("", "createCallMessage failed",
                  NimResult::getErrorResult(MESSAGE_BUILD_ERROR,
                                            "createCallMessage failed"));
    return;
  }
  flutter::EncodableMap messageMap;
  messageMap = convertMessage(message);
  result->Success(NimResult::getSuccessResult(messageMap));
}
