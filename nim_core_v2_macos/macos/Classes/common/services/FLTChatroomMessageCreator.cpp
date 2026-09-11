// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#include "FLTChatroomMessageCreator.h"

#include "../NimResult.h"
#include "FLTMessageService.h"
#include "nim_cpp_wrapper/nim_cpp_api.h"
#include "v2_nim_api.hpp"
#include "v2_nim_def_struct.hpp"

using namespace nim;

int CHAT_ROOM_MESSAGE_BUILD_ERROR = 199001;

FLTChatroomMessageCreator::FLTChatroomMessageCreator() {
  m_serviceName = "V2NIMChatroomMessageCreator";
}

FLTChatroomMessageCreator::~FLTChatroomMessageCreator() {}

void FLTChatroomMessageCreator::onMethodCalled(
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
  } else if (method == "createCustomMessageWithAttachmentAndSubType") {
    createCustomMessageWithAttachmentAndSubType(arguments, result);
  }
}

void FLTChatroomMessageCreator::createTextMessage(
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

  auto message = v2::V2NIMChatroomMessageCreator::createTextMessage(text);
  if (!message) {
    result->Error("", "createTextMessage failed",
                  NimResult::getErrorResult(CHAT_ROOM_MESSAGE_BUILD_ERROR,
                                            "createTextMessage failed"));
    return;
  }
  flutter::EncodableMap messageMap;
  messageMap = convertChatroomMessage(message);
  result->Success(NimResult::getSuccessResult(messageMap));
}

void FLTChatroomMessageCreator::createImageMessage(
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

  auto message = v2::V2NIMChatroomMessageCreator::createImageMessage(
      imagePath, name, sceneName, width, height);
  if (!message) {
    result->Error("", "createImageMessage failed",
                  NimResult::getErrorResult(CHAT_ROOM_MESSAGE_BUILD_ERROR,
                                            "createImageMessage failed"));
    return;
  }
  flutter::EncodableMap messageMap;
  messageMap = convertChatroomMessage(message);
  result->Success(NimResult::getSuccessResult(messageMap));
}

void FLTChatroomMessageCreator::createAudioMessage(
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
  auto message = v2::V2NIMChatroomMessageCreator::createAudioMessage(
      audioPath, name, sceneName, duration);
  if (!message) {
    result->Error("", "createAudioMessage failed",
                  NimResult::getErrorResult(CHAT_ROOM_MESSAGE_BUILD_ERROR,
                                            "createAudioMessage failed"));
    return;
  }
  flutter::EncodableMap messageMap;
  messageMap = convertChatroomMessage(message);
  result->Success(NimResult::getSuccessResult(messageMap));
}

void FLTChatroomMessageCreator::createVideoMessage(
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
  auto message = v2::V2NIMChatroomMessageCreator::createVideoMessage(
      videoPath, name, sceneName, duration, width, height);
  if (!message) {
    result->Error("", "createVideoMessage failed",
                  NimResult::getErrorResult(CHAT_ROOM_MESSAGE_BUILD_ERROR,
                                            "createVideoMessage failed"));
    return;
  }
  flutter::EncodableMap messageMap;
  messageMap = convertChatroomMessage(message);
  result->Success(NimResult::getSuccessResult(messageMap));
}

void FLTChatroomMessageCreator::createFileMessage(
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
  auto message = v2::V2NIMChatroomMessageCreator::createFileMessage(
      filePath, name, sceneName);
  if (!message) {
    result->Error("", "createFileMessage failed",
                  NimResult::getErrorResult(CHAT_ROOM_MESSAGE_BUILD_ERROR,
                                            "createFileMessage failed"));
    return;
  }
  flutter::EncodableMap messageMap;
  messageMap = convertChatroomMessage(message);
  result->Success(NimResult::getSuccessResult(messageMap));
}

void FLTChatroomMessageCreator::createLocationMessage(
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
  auto message = v2::V2NIMChatroomMessageCreator::createLocationMessage(
      latitude, longitude, address);
  if (!message) {
    result->Error("", "createLocationMessage failed",
                  NimResult::getErrorResult(CHAT_ROOM_MESSAGE_BUILD_ERROR,
                                            "createLocationMessage failed"));
    return;
  }
  flutter::EncodableMap messageMap;
  messageMap = convertChatroomMessage(message);
  result->Success(NimResult::getSuccessResult(messageMap));
}

void FLTChatroomMessageCreator::createCustomMessage(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  std::string rawAttachment;
  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("rawAttachment")) {
      rawAttachment = std::get<std::string>(iter->second);
    }
  }
  auto message =
      v2::V2NIMChatroomMessageCreator::createCustomMessage(rawAttachment);
  if (!message) {
    result->Error("", "createCustomMessage failed",
                  NimResult::getErrorResult(CHAT_ROOM_MESSAGE_BUILD_ERROR,
                                            "createCustomMessage failed"));
    return;
  }
  flutter::EncodableMap messageMap;
  messageMap = convertChatroomMessage(message);
  result->Success(NimResult::getSuccessResult(messageMap));
}

void FLTChatroomMessageCreator::createTipsMessage(
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
  auto message = v2::V2NIMChatroomMessageCreator::createTipsMessage(text);
  if (!message) {
    result->Error("", "createTipsMessage failed",
                  NimResult::getErrorResult(CHAT_ROOM_MESSAGE_BUILD_ERROR,
                                            "createTipsMessage failed"));
    return;
  }
  flutter::EncodableMap messageMap;
  messageMap = convertChatroomMessage(message);
  result->Success(NimResult::getSuccessResult(messageMap));
}

void FLTChatroomMessageCreator::createForwardMessage(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  v2::V2NIMChatroomMessage forwardMessage;
  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("message")) {
      const flutter::EncodableMap forwardMessageMap =
          std::get<flutter::EncodableMap>(iter->second);
      forwardMessage = getChatroomMessage(&forwardMessageMap);
    }
  }
  auto message =
      v2::V2NIMChatroomMessageCreator::createForwardMessage(forwardMessage);
  if (!message) {
    result->Success(NimResult::getSuccessResult());
    return;
  }
  flutter::EncodableMap messageMap;
  messageMap = convertChatroomMessage(message);
  result->Success(NimResult::getSuccessResult(messageMap));
}

void FLTChatroomMessageCreator::createCustomMessageWithAttachmentAndSubType(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  std::string rawAttachment;
  auto attachment = nstd::make_shared<v2::V2NIMMessageFileAttachment>();
  int32_t subType;
  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("rawAttachment")) {
      rawAttachment = std::get<std::string>(iter->second);
      attachment->raw = rawAttachment;
    }
    if (iter->first == flutter::EncodableValue("subType")) {
      subType = std::get<int32_t>(iter->second);
    }
  }
  auto message =
      v2::V2NIMChatroomMessageCreator::createCustomMessageWithAttachment(
          attachment, subType);
  if (!message) {
    result->Error("", "createCustomMessageWithAttachmentAndSubType failed",
                  NimResult::getErrorResult(CHAT_ROOM_MESSAGE_BUILD_ERROR,
                                            "createCustomMessage failed"));
    return;
  }
  flutter::EncodableMap messageMap;
  messageMap = convertChatroomMessage(message);
  result->Success(NimResult::getSuccessResult(messageMap));
}