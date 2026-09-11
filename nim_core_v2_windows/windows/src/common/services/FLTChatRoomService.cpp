// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#include "FLTChatRoomService.h"

#include "../NimResult.h"
#include "FLTMessageService.h"
#include "nim_cpp_wrapper/nim_cpp_api.h"

v2::V2NIMSendChatroomMessageParams getSendChatroomMessageParams(
    const flutter::EncodableMap* arguments);

v2::V2NIMChatroomMessageListOption getChatroomMessageListOption(
    const flutter::EncodableMap* arguments);

v2::V2NIMChatroomTagMessageOption getChatroomTagMessageOption(
    const flutter::EncodableMap* arguments);

v2::V2NIMChatroomMemberQueryOption getChatroomMemberQueryOption(
    const flutter::EncodableMap* arguments);

v2::V2NIMChatroomMemberRoleUpdateParams getChatroomMemberRoleUpdateParams(
    const flutter::EncodableMap* arguments);

v2::V2NIMAntispamConfig getAntispamConfig(
    const flutter::EncodableMap* arguments);

v2::V2NIMChatroomUpdateParams getChatroomUpdateParams(
    const flutter::EncodableMap* arguments);

v2::V2NIMChatroomSelfMemberUpdateParams getChatroomSelfMemberUpdateParams(
    const flutter::EncodableMap* arguments);

v2::V2NIMChatroomLocationConfig getChatroomLocationConfig(
    const flutter::EncodableMap* arguments);

v2::V2NIMChatroomTagsUpdateParams getChatroomTagsUpdateParams(
    const flutter::EncodableMap* arguments);

v2::V2NIMChatroomTagTempChatBannedParams getChatroomTagTempChatBannedParams(
    const flutter::EncodableMap* arguments);

v2::V2NIMChatroomTagMemberOption getChatroomTagMemberOption(
    const flutter::EncodableMap* arguments);

v2::V2NIMChatroomMessageConfig getChatroomMessageConfig(
    const flutter::EncodableMap* arguments);

FLTChatRoomService::FLTChatRoomService() {
  m_serviceName = "V2NIMChatroomService";
}

FLTChatRoomService::~FLTChatRoomService() {}

void FLTChatRoomService::onMethodCalled(
    const std::string& method, const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  switch (utils::hash_(method.c_str())) {
    case "sendMessage"_hash:
      sendMessage(arguments, result);
      return;
    case "cancelMessageAttachmentUpload"_hash:
      cancelMessageAttachmentUpload(arguments, result);
      return;
    case "getMessageList"_hash:
      getMessageList(arguments, result);
      return;
    case "getMessageListByTag"_hash:
      getMessageListByTag(arguments, result);
      return;
    case "getMemberByIds"_hash:
      getMemberByIds(arguments, result);
      return;
    case "getMemberListByOption"_hash:
      getMemberListByOption(arguments, result);
      return;
    case "updateMemberRole"_hash:
      updateMemberRole(arguments, result);
      return;
    case "setMemberBlockedStatus"_hash:
      setMemberBlockedStatus(arguments, result);
      return;
    case "setMemberChatBannedStatus"_hash:
      setMemberChatBannedStatus(arguments, result);
      return;
    case "setMemberTempChatBanned"_hash:
      setMemberTempChatBanned(arguments, result);
      return;
    case "updateChatroomInfo"_hash:
      updateChatroomInfo(arguments, result);
      return;
    case "updateSelfMemberInfo"_hash:
      updateSelfMemberInfo(arguments, result);
      return;
    case "kickMember"_hash:
      kickMember(arguments, result);
      return;
    case "updateChatroomLocationInfo"_hash:
      updateChatroomLocationInfo(arguments, result);
      return;
    case "updateChatroomTags"_hash:
      updateChatroomTags(arguments, result);
      return;
    case "setTempChatBannedByTag"_hash:
      setTempChatBannedByTag(arguments, result);
      return;
    case "getMemberCountByTag"_hash:
      getMemberCountByTag(arguments, result);
      return;
    case "getMemberListByTag"_hash:
      getMemberListByTag(arguments, result);
      return;
    case "addChatroomListener"_hash:
      addChatroomListener(arguments, result);
      return;
    case "removeChatroomListener"_hash:
      removeChatroomListener(arguments, result);
      return;

    default:
      break;
  }
  if (result) result->NotImplemented();
}

void FLTChatRoomService::sendMessage(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  uint32_t instanceId = 0;
  v2::V2NIMChatroomMessage message;
  v2::V2NIMSendChatroomMessageParams params;

  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("instanceId")) {
      instanceId = iter->second.LongValue();
      std::cout << "instanceId: " << instanceId << std::endl;
    } else if (iter->first == flutter::EncodableValue("message")) {
      auto paramsMap = std::get<flutter::EncodableMap>(iter->second);
      message = getChatroomMessage(&paramsMap);
      std::cout << "message: " << std::endl;
    } else if (iter->first == flutter::EncodableValue("params")) {
      auto paramsMap = std::get<flutter::EncodableMap>(iter->second);
      params = getSendChatroomMessageParams(&paramsMap);
    }
  }

  auto instance = v2::V2NIMChatroomClient::getInstance(instanceId);
  auto& service = instance->getChatroomService();
  service.sendMessage(
      message, params,
      [result](v2::V2NIMSendChatroomMessageResult msgResult) {
        flutter::EncodableMap resultMap =
            convertSendChatroomMessageResult(msgResult);
        result->Success(NimResult::getSuccessResult(resultMap));
      },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      },
      [=](uint32_t progress) {
        flutter::EncodableMap ret;
        auto messageClientId = message.messageClientId;
        ret.insert(
            std::make_pair("instanceId", static_cast<int64_t>(instanceId)));
        ret.insert(std::make_pair("messageClientId", messageClientId));
        ret.insert(std::make_pair("progress", static_cast<int64_t>(progress)));
        notifyEvent("onSendMessageProgress", ret);
      });
}

void FLTChatRoomService::cancelMessageAttachmentUpload(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  uint32_t instanceId = 0;
  v2::V2NIMChatroomMessage message;

  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("instanceId")) {
      instanceId = iter->second.LongValue();
      std::cout << "instanceId: " << instanceId << std::endl;
    } else if (iter->first == flutter::EncodableValue("message")) {
      auto paramsMap = std::get<flutter::EncodableMap>(iter->second);
      message = getChatroomMessage(&paramsMap);
      std::cout << "message: " << std::endl;
    }
  }

  auto instance = v2::V2NIMChatroomClient::getInstance(instanceId);
  auto& service = instance->getChatroomService();
  service.cancelMessageAttachmentUpload(
      message, [result]() { result->Success(NimResult::getSuccessResult()); },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void FLTChatRoomService::getMessageList(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  uint32_t instanceId = 0;
  v2::V2NIMChatroomMessageListOption option;

  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("instanceId")) {
      instanceId = iter->second.LongValue();
      std::cout << "instanceId: " << instanceId << std::endl;
    } else if (iter->first == flutter::EncodableValue("option")) {
      auto paramsMap = std::get<flutter::EncodableMap>(iter->second);
      option = getChatroomMessageListOption(&paramsMap);
    }
  }

  auto instance = v2::V2NIMChatroomClient::getInstance(instanceId);
  auto& service = instance->getChatroomService();
  service.getMessageList(
      option,
      [result](nstd::vector<v2::V2NIMChatroomMessage> messages) {
        flutter::EncodableList messagesList;
        for (auto message : messages) {
          messagesList.emplace_back(convertChatroomMessage(&message));
        }
        flutter::EncodableMap resultMap;
        resultMap.insert(std::make_pair("messageList", messagesList));
        result->Success(NimResult::getSuccessResult(resultMap));
      },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void FLTChatRoomService::getMessageListByTag(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  int32_t instanceId = 0;
  v2::V2NIMChatroomTagMessageOption messageOption;

  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("instanceId")) {
      instanceId = iter->second.LongValue();
      std::cout << "instanceId: " << instanceId << std::endl;
    } else if (iter->first == flutter::EncodableValue("messageOption")) {
      auto paramsMap = std::get<flutter::EncodableMap>(iter->second);
      messageOption = getChatroomTagMessageOption(&paramsMap);
    }
  }

  auto instance = v2::V2NIMChatroomClient::getInstance(instanceId);
  auto& service = instance->getChatroomService();
  service.getMessageListByTag(
      messageOption,
      [result](nstd::vector<v2::V2NIMChatroomMessage> messages) {
        flutter::EncodableList messagesList;
        for (auto message : messages) {
          messagesList.emplace_back(convertChatroomMessage(&message));
        }
        flutter::EncodableMap resultMap;
        resultMap.insert(std::make_pair("messageList", messagesList));
        result->Success(NimResult::getSuccessResult(resultMap));
      },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void FLTChatRoomService::getMemberByIds(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  int32_t instanceId = 0;
  std::vector<std::string> accountIds;

  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("instanceId")) {
      instanceId = iter->second.LongValue();
      std::cout << "instanceId: " << instanceId << std::endl;
    } else if (iter->first == flutter::EncodableValue("accountIds")) {
      std::vector<std::string> accIds;
      auto accountIdsList = std::get<flutter::EncodableList>(iter->second);
      for (auto& it : accountIdsList) {
        auto accountId = std::get<std::string>(it);
        accIds.emplace_back(accountId);
      }
      accountIds = accIds;
    }
  }

  auto instance = v2::V2NIMChatroomClient::getInstance(instanceId);
  auto& service = instance->getChatroomService();
  service.getMemberByIds(
      accountIds,
      [result](nstd::vector<v2::V2NIMChatroomMember> members) {
        flutter::EncodableList membersList;
        for (auto member : members) {
          membersList.emplace_back(convertChatroomMember(&member));
        }
        flutter::EncodableMap resultMap;
        resultMap.insert(std::make_pair("memberList", membersList));
        result->Success(NimResult::getSuccessResult(resultMap));
      },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void FLTChatRoomService::getMemberListByOption(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  int32_t instanceId = 0;
  v2::V2NIMChatroomMemberQueryOption queryOption;

  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("instanceId")) {
      instanceId = iter->second.LongValue();
      std::cout << "instanceId: " << instanceId << std::endl;
    } else if (iter->first == flutter::EncodableValue("queryOption")) {
      auto paramsMap = std::get<flutter::EncodableMap>(iter->second);
      queryOption = getChatroomMemberQueryOption(&paramsMap);
    }
  }

  auto instance = v2::V2NIMChatroomClient::getInstance(instanceId);
  auto& service = instance->getChatroomService();
  service.getMemberListByOption(
      queryOption,
      [result](v2::V2NIMChatroomMemberListResult queryResult) {
        flutter::EncodableMap resultMap;
        resultMap.insert(std::make_pair("pageToken", queryResult.pageToken));
        resultMap.insert(std::make_pair("finished", queryResult.finished));

        flutter::EncodableList membersList;
        for (auto member : queryResult.memberList) {
          membersList.emplace_back(convertChatroomMember(&member));
        }
        resultMap.insert(std::make_pair("memberList", membersList));

        result->Success(NimResult::getSuccessResult(resultMap));
      },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void FLTChatRoomService::updateMemberRole(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  int32_t instanceId = 0;
  std::string accountId;
  v2::V2NIMChatroomMemberRoleUpdateParams updateParams;

  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("instanceId")) {
      instanceId = iter->second.LongValue();
      std::cout << "instanceId: " << instanceId << std::endl;
    } else if (iter->first == flutter::EncodableValue("accountId")) {
      accountId = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("updateParams")) {
      auto updateParamsMap = std::get<flutter::EncodableMap>(iter->second);
      updateParams = getChatroomMemberRoleUpdateParams(&updateParamsMap);
    }
  }

  auto instance = v2::V2NIMChatroomClient::getInstance(instanceId);
  auto& service = instance->getChatroomService();
  service.updateMemberRole(
      accountId, updateParams,
      [result]() { result->Success(NimResult::getSuccessResult()); },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void FLTChatRoomService::setMemberBlockedStatus(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  int32_t instanceId = 0;
  std::string accountId;
  bool blocked;
  std::string notificationExtension;

  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("instanceId")) {
      instanceId = iter->second.LongValue();
      std::cout << "instanceId: " << instanceId << std::endl;
    } else if (iter->first == flutter::EncodableValue("accountId")) {
      accountId = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("blocked")) {
      blocked = std::get<bool>(iter->second);
    } else if (iter->first ==
               flutter::EncodableValue("notificationExtension")) {
      notificationExtension = std::get<std::string>(iter->second);
    }
  }

  auto instance = v2::V2NIMChatroomClient::getInstance(instanceId);
  auto& service = instance->getChatroomService();
  service.setMemberBlockedStatus(
      accountId, blocked, notificationExtension,
      [result]() { result->Success(NimResult::getSuccessResult()); },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void FLTChatRoomService::setMemberChatBannedStatus(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  int32_t instanceId = 0;
  std::string accountId;
  bool chatBanned;
  std::string notificationExtension;

  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("instanceId")) {
      instanceId = iter->second.LongValue();
      std::cout << "instanceId: " << instanceId << std::endl;
    } else if (iter->first == flutter::EncodableValue("accountId")) {
      accountId = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("chatBanned")) {
      chatBanned = std::get<bool>(iter->second);
    } else if (iter->first ==
               flutter::EncodableValue("notificationExtension")) {
      notificationExtension = std::get<std::string>(iter->second);
    }
  }

  auto instance = v2::V2NIMChatroomClient::getInstance(instanceId);
  auto& service = instance->getChatroomService();
  service.setMemberChatBannedStatus(
      accountId, chatBanned, notificationExtension,
      [result]() { result->Success(NimResult::getSuccessResult()); },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void FLTChatRoomService::setMemberTempChatBanned(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  int32_t instanceId = 0;
  std::string accountId;
  uint64_t tempChatBannedDuration;
  bool notificationEnabled;
  std::string notificationExtension;

  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("instanceId")) {
      instanceId = iter->second.LongValue();
      std::cout << "instanceId: " << instanceId << std::endl;
    } else if (iter->first == flutter::EncodableValue("accountId")) {
      accountId = std::get<std::string>(iter->second);
    } else if (iter->first ==
               flutter::EncodableValue("tempChatBannedDuration")) {
      tempChatBannedDuration = iter->second.LongValue();
      std::cout << "tempChatBannedDuration: " << tempChatBannedDuration
                << std::endl;
    } else if (iter->first == flutter::EncodableValue("notificationEnabled")) {
      notificationEnabled = std::get<bool>(iter->second);
    } else if (iter->first ==
               flutter::EncodableValue("notificationExtension")) {
      notificationExtension = std::get<std::string>(iter->second);
    }
  }

  auto instance = v2::V2NIMChatroomClient::getInstance(instanceId);
  auto& service = instance->getChatroomService();
  service.setMemberTempChatBanned(
      accountId, tempChatBannedDuration, notificationEnabled,
      notificationExtension,
      [result]() { result->Success(NimResult::getSuccessResult()); },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void FLTChatRoomService::updateChatroomInfo(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  int32_t instanceId = 0;
  v2::V2NIMChatroomUpdateParams updateParams;
  v2::V2NIMAntispamConfig antispamConfig;

  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("instanceId")) {
      instanceId = iter->second.LongValue();
      std::cout << "instanceId: " << instanceId << std::endl;
    } else if (iter->first == flutter::EncodableValue("updateParams")) {
      auto paramsMap = std::get<flutter::EncodableMap>(iter->second);
      updateParams = getChatroomUpdateParams(&paramsMap);
    } else if (iter->first == flutter::EncodableValue("antispamConfig")) {
      auto paramsMap = std::get<flutter::EncodableMap>(iter->second);
      antispamConfig = getAntispamConfig(&paramsMap);
    }
  }

  auto instance = v2::V2NIMChatroomClient::getInstance(instanceId);
  auto& service = instance->getChatroomService();
  service.updateChatroomInfo(
      updateParams, antispamConfig,
      [result]() { result->Success(NimResult::getSuccessResult()); },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void FLTChatRoomService::updateSelfMemberInfo(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  int32_t instanceId = 0;
  v2::V2NIMChatroomSelfMemberUpdateParams updateParams;
  v2::V2NIMAntispamConfig antispamConfig;

  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("instanceId")) {
      instanceId = iter->second.LongValue();
      std::cout << "instanceId: " << instanceId << std::endl;
    } else if (iter->first == flutter::EncodableValue("updateParams")) {
      auto paramsMap = std::get<flutter::EncodableMap>(iter->second);
      updateParams = getChatroomSelfMemberUpdateParams(&paramsMap);
    } else if (iter->first == flutter::EncodableValue("antispamConfig")) {
      auto paramsMap = std::get<flutter::EncodableMap>(iter->second);
      antispamConfig = getAntispamConfig(&paramsMap);
    }
  }

  auto instance = v2::V2NIMChatroomClient::getInstance(instanceId);
  auto& service = instance->getChatroomService();
  service.updateSelfMemberInfo(
      updateParams, antispamConfig,
      [result]() { result->Success(NimResult::getSuccessResult()); },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void FLTChatRoomService::kickMember(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  int32_t instanceId = 0;
  std::string accountId;
  std::string notificationExtension;

  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("instanceId")) {
      instanceId = iter->second.LongValue();
      std::cout << "instanceId: " << instanceId << std::endl;
    } else if (iter->first == flutter::EncodableValue("accountId")) {
      accountId = std::get<std::string>(iter->second);
    } else if (iter->first ==
               flutter::EncodableValue("notificationExtension")) {
      notificationExtension = std::get<std::string>(iter->second);
    }
  }

  auto instance = v2::V2NIMChatroomClient::getInstance(instanceId);
  auto& service = instance->getChatroomService();
  service.kickMember(
      accountId, notificationExtension,
      [result]() { result->Success(NimResult::getSuccessResult()); },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void FLTChatRoomService::updateChatroomLocationInfo(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  int32_t instanceId = 0;
  v2::V2NIMChatroomLocationConfig locationConfig;

  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("instanceId")) {
      instanceId = iter->second.LongValue();
      std::cout << "instanceId: " << instanceId << std::endl;
    } else if (iter->first == flutter::EncodableValue("locationConfig")) {
      auto paramsMap = std::get<flutter::EncodableMap>(iter->second);
      locationConfig = getChatroomLocationConfig(&paramsMap);
    }
  }

  auto instance = v2::V2NIMChatroomClient::getInstance(instanceId);
  auto& service = instance->getChatroomService();
  service.updateChatroomLocationInfo(
      locationConfig,
      [result]() { result->Success(NimResult::getSuccessResult()); },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void FLTChatRoomService::updateChatroomTags(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  int32_t instanceId = 0;
  v2::V2NIMChatroomTagsUpdateParams updateParams;

  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("instanceId")) {
      instanceId = iter->second.LongValue();
      std::cout << "instanceId: " << instanceId << std::endl;
    } else if (iter->first == flutter::EncodableValue("updateParams")) {
      auto paramsMap = std::get<flutter::EncodableMap>(iter->second);
      updateParams = getChatroomTagsUpdateParams(&paramsMap);
    }
  }

  auto instance = v2::V2NIMChatroomClient::getInstance(instanceId);
  auto& service = instance->getChatroomService();
  service.updateChatroomTags(
      updateParams,
      [result]() { result->Success(NimResult::getSuccessResult()); },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void FLTChatRoomService::setTempChatBannedByTag(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  uint32_t instanceId = 0;
  v2::V2NIMChatroomTagTempChatBannedParams params;

  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("instanceId")) {
      instanceId = iter->second.LongValue();
      std::cout << "instanceId: " << instanceId << std::endl;
    } else if (iter->first == flutter::EncodableValue("params")) {
      auto paramsMap = std::get<flutter::EncodableMap>(iter->second);
      params = getChatroomTagTempChatBannedParams(&paramsMap);
    }
  }

  auto instance = v2::V2NIMChatroomClient::getInstance(instanceId);
  auto& service = instance->getChatroomService();
  service.setTempChatBannedByTag(
      params, [result]() { result->Success(NimResult::getSuccessResult()); },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void FLTChatRoomService::getMemberCountByTag(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  uint32_t instanceId = 0;
  std::string tag;

  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("instanceId")) {
      instanceId = iter->second.LongValue();
      std::cout << "instanceId: " << instanceId << std::endl;
    } else if (iter->first == flutter::EncodableValue("tag")) {
      tag = std::get<std::string>(iter->second);
      std::cout << "tag: " << tag << std::endl;
    }
  }

  auto instance = v2::V2NIMChatroomClient::getInstance(instanceId);
  auto& service = instance->getChatroomService();
  service.getMemberCountByTag(
      tag,
      [result](uint64_t memberCount) {
        flutter::EncodableMap resultMap;
        resultMap.insert(
            std::make_pair("memberCount", static_cast<int64_t>(memberCount)));
        result->Success(NimResult::getSuccessResult(resultMap));
      },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void FLTChatRoomService::getMemberListByTag(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  uint32_t instanceId = 0;
  v2::V2NIMChatroomTagMemberOption option;

  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("instanceId")) {
      instanceId = iter->second.LongValue();
      std::cout << "instanceId: " << instanceId << std::endl;
    } else if (iter->first == flutter::EncodableValue("option")) {
      auto paramsMap = std::get<flutter::EncodableMap>(iter->second);
      option = getChatroomTagMemberOption(&paramsMap);
    }
  }

  auto instance = v2::V2NIMChatroomClient::getInstance(instanceId);
  auto& service = instance->getChatroomService();
  service.getMemberListByTag(
      option,
      [result](v2::V2NIMChatroomMemberListResult queryResult) {
        flutter::EncodableMap resultMap;
        resultMap.insert(std::make_pair("pageToken", queryResult.pageToken));
        resultMap.insert(std::make_pair("finished", queryResult.finished));

        flutter::EncodableList membersList;
        for (auto member : queryResult.memberList) {
          membersList.emplace_back(convertChatroomMember(&member));
        }
        resultMap.insert(std::make_pair("memberList", membersList));

        result->Success(NimResult::getSuccessResult(resultMap));
      },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void FLTChatRoomService::addChatroomListener(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  uint32_t instanceId = 0;

  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("instanceId")) {
      instanceId = iter->second.LongValue();
      std::cout << "instanceId: " << instanceId << std::endl;
    }
  }

  auto it = chatroomServiceListeners.find(instanceId);
  if (it != chatroomServiceListeners.end()) {
    result->Success(NimResult::getSuccessResult());
    return;
  }

  v2::V2NIMChatroomListener listener;
  listener.onSendMessage = [=](const v2::V2NIMChatroomMessage& message) {
    flutter::EncodableMap resultMap;
    auto messageMap = convertChatroomMessage(&message);
    resultMap.insert(std::make_pair("message", messageMap));
    resultMap.insert(
        std::make_pair("instanceId", static_cast<int64_t>(instanceId)));

    notifyEvent("onSendMessage", resultMap);
  };

  listener.onReceiveMessages =
      [=](nstd::vector<v2::V2NIMChatroomMessage> messages) {
        flutter::EncodableList messagesList;
        for (auto message : messages) {
          messagesList.emplace_back(convertChatroomMessage(&message));
        }
        flutter::EncodableMap resultMap;
        resultMap.insert(std::make_pair("messages", messagesList));
        resultMap.insert(
            std::make_pair("instanceId", static_cast<int64_t>(instanceId)));
        notifyEvent("onReceiveMessages", resultMap);
      };

  listener.onChatroomMemberEnter = [=](v2::V2NIMChatroomMember member) {
    flutter::EncodableMap resultMap;
    auto memberMap = convertChatroomMember(&member);
    resultMap.insert(std::make_pair("member", memberMap));
    resultMap.insert(
        std::make_pair("instanceId", static_cast<int64_t>(instanceId)));

    notifyEvent("onChatroomMemberEnter", resultMap);
  };

  listener.onChatroomMemberExit = [=](nstd::string accountId) {
    flutter::EncodableMap resultMap;
    resultMap.insert(std::make_pair("accountId", accountId));
    resultMap.insert(
        std::make_pair("instanceId", static_cast<int64_t>(instanceId)));

    notifyEvent("onChatroomMemberExit", resultMap);
  };

  listener.onChatroomMemberRoleUpdated =
      [=](v2::V2NIMChatroomMemberRole previousRole,
          v2::V2NIMChatroomMember member) {
        flutter::EncodableMap resultMap;
        auto memberMap = convertChatroomMember(&member);
        resultMap.insert(std::make_pair("member", memberMap));
        resultMap.insert(
            std::make_pair("instanceId", static_cast<int64_t>(instanceId)));
        resultMap.insert(std::make_pair("previousRole", previousRole));

        notifyEvent("onChatroomMemberRoleUpdated", resultMap);
      };

  listener.onChatroomMemberInfoUpdated = [=](v2::V2NIMChatroomMember member) {
    flutter::EncodableMap resultMap;
    auto memberMap = convertChatroomMember(&member);
    resultMap.insert(std::make_pair("member", memberMap));
    resultMap.insert(
        std::make_pair("instanceId", static_cast<int64_t>(instanceId)));

    notifyEvent("onChatroomMemberInfoUpdated", resultMap);
  };

  listener.onSelfChatBannedUpdated = [=](bool chatBanned) {
    flutter::EncodableMap resultMap;
    resultMap.insert(std::make_pair("chatBanned", chatBanned));
    resultMap.insert(
        std::make_pair("instanceId", static_cast<int64_t>(instanceId)));

    notifyEvent("onSelfChatBannedUpdated", resultMap);
  };

  listener.onSelfTempChatBannedUpdated = [=](bool tempChatBanned,
                                             uint64_t tempChatBannedDuration) {
    flutter::EncodableMap resultMap;
    resultMap.insert(std::make_pair("tempChatBanned", tempChatBanned));
    resultMap.insert(
        std::make_pair("tempChatBannedDuration",
                       static_cast<int64_t>(tempChatBannedDuration)));
    resultMap.insert(
        std::make_pair("instanceId", static_cast<int64_t>(instanceId)));

    notifyEvent("onSelfTempChatBannedUpdated", resultMap);
  };

  listener.onChatroomInfoUpdated = [=](v2::V2NIMChatroomInfo chatroomInfo) {
    flutter::EncodableMap resultMap;
    auto chatroomInfoMap = convertChatroomInfo(chatroomInfo);
    resultMap.insert(std::make_pair("info", chatroomInfoMap));
    resultMap.insert(
        std::make_pair("instanceId", static_cast<int64_t>(instanceId)));

    notifyEvent("onChatroomInfoUpdated", resultMap);
  };

  listener.onChatroomChatBannedUpdated = [=](bool chatBanned) {
    flutter::EncodableMap resultMap;
    resultMap.insert(std::make_pair("chatBanned", chatBanned));
    resultMap.insert(
        std::make_pair("instanceId", static_cast<int64_t>(instanceId)));

    notifyEvent("onChatroomChatBannedUpdated", resultMap);
  };

  listener.onMessageRevokedNotification = [=](nstd::string messageClientId,
                                              uint64_t messageTime) {
    flutter::EncodableMap resultMap;
    resultMap.insert(std::make_pair("messageClientId", messageClientId));
    resultMap.insert(
        std::make_pair("messageTime", static_cast<int64_t>(messageTime)));
    resultMap.insert(
        std::make_pair("instanceId", static_cast<int64_t>(instanceId)));

    notifyEvent("onMessageRevokedNotification", resultMap);
  };

  listener.onChatroomTagsUpdated = [=](nstd::vector<nstd::string> tags) {
    flutter::EncodableList tagsList;
    for (auto tag : tags) {
      tagsList.emplace_back(tag);
    }

    flutter::EncodableMap resultMap;
    resultMap.insert(std::make_pair("tags", tagsList));
    resultMap.insert(
        std::make_pair("instanceId", static_cast<int64_t>(instanceId)));

    notifyEvent("onChatroomTagsUpdated", resultMap);
  };

  auto instance = v2::V2NIMChatroomClient::getInstance(instanceId);
  auto& service = instance->getChatroomService();
  service.addChatroomListener(listener);
  chatroomServiceListeners[instanceId] = listener;
  result->Success(NimResult::getSuccessResult());
}

void FLTChatRoomService::removeChatroomListener(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  uint32_t instanceId = 0;

  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("instanceId")) {
      instanceId = iter->second.LongValue();
      std::cout << "instanceId: " << instanceId << std::endl;
    }
  }

  auto it = chatroomServiceListeners.find(instanceId);
  if (it != chatroomServiceListeners.end()) {
    v2::V2NIMChatroomListener listener = it->second;
    auto instance = v2::V2NIMChatroomClient::getInstance(instanceId);
    auto& service = instance->getChatroomService();
    service.removeChatroomListener(listener);
    chatroomServiceListeners.erase(it);
  }
  result->Success(NimResult::getSuccessResult());
}

//********************************************************

v2::V2NIMUserInfoConfig getUserInfoConfig(
    const flutter::EncodableMap* arguments) {
  v2::V2NIMUserInfoConfig object;
  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("userInfoTimestamp")) {
      object.userInfoTimestamp = iter->second.LongValue();
    } else if (iter->first == flutter::EncodableValue("senderNick")) {
      object.senderNick = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("senderAvatar")) {
      object.senderAvatar = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("senderExtension")) {
      object.senderExtension = std::get<std::string>(iter->second);
    }
  }
  return object;
}

v2::V2NIMLocationInfo getLocationInfo(const flutter::EncodableMap* arguments) {
  v2::V2NIMLocationInfo object;
  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("x")) {
      object.x = std::get<double>(iter->second);
    } else if (iter->first == flutter::EncodableValue("y")) {
      object.y = std::get<double>(iter->second);
    } else if (iter->first == flutter::EncodableValue("z")) {
      object.z = std::get<double>(iter->second);
    }
  }
  return object;
}

v2::V2NIMChatroomMessage getChatroomMessage(
    const flutter::EncodableMap* arguments) {
  v2::V2NIMChatroomMessage object;
  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("messageClientId")) {
      object.messageClientId = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("senderClientType")) {
      object.senderClientType =
          v2::V2NIMLoginClientType(std::get<int>(iter->second));
    } else if (iter->first == flutter::EncodableValue("createTime")) {
      auto createTime = iter->second.LongValue();
      object.createTime = createTime;
    } else if (iter->first == flutter::EncodableValue("senderId")) {
      object.senderId = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("roomId")) {
      object.roomId = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("isSelf")) {
      object.isSelf = std::get<bool>(iter->second);
    } else if (iter->first ==
               flutter::EncodableValue("attachmentUploadState")) {
      object.attachmentUploadState =
          v2::V2NIMMessageAttachmentUploadState(std::get<int>(iter->second));
    } else if (iter->first == flutter::EncodableValue("sendingState")) {
      object.sendingState =
          v2::V2NIMMessageSendingState(std::get<int>(iter->second));
    } else if (iter->first == flutter::EncodableValue("messageType")) {
      object.messageType = v2::V2NIMMessageType(std::get<int>(iter->second));
    } else if (iter->first == flutter::EncodableValue("subType")) {
      auto subType = iter->second.LongValue();
      object.subType = subType;
    } else if (iter->first == flutter::EncodableValue("text")) {
      object.text = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("attachment")) {
      auto attachmentMap = std::get<flutter::EncodableMap>(iter->second);
      object.attachment = getMessageAttachment(&attachmentMap);
    } else if (iter->first == flutter::EncodableValue("serverExtension")) {
      object.serverExtension = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("callbackExtension")) {
      object.callbackExtension = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("routeConfig")) {
      auto routeConfigMap = std::get<flutter::EncodableMap>(iter->second);
      object.routeConfig = getMessageRouteConfig(&routeConfigMap);
    } else if (iter->first == flutter::EncodableValue("antispamConfig")) {
      auto antispamConfigMap = std::get<flutter::EncodableMap>(iter->second);
      object.antispamConfig = getMessageAntispamConfig(&antispamConfigMap);
    } else if (iter->first == flutter::EncodableValue("notifyTargetTags")) {
      object.notifyTargetTags = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("messageConfig")) {
      auto messageConfigMap = std::get<flutter::EncodableMap>(iter->second);
      object.messageConfig = getChatroomMessageConfig(&messageConfigMap);
    } else if (iter->first == flutter::EncodableValue("userInfoConfig")) {
      auto userInfoConfigMap = std::get<flutter::EncodableMap>(iter->second);
      object.userInfoConfig = getUserInfoConfig(&userInfoConfigMap);
    } else if (iter->first == flutter::EncodableValue("locationInfo")) {
      auto locationInfoMap = std::get<flutter::EncodableMap>(iter->second);
      object.locationInfo = getLocationInfo(&locationInfoMap);
    }
  }
  return object;
}

v2::V2NIMSendChatroomMessageParams getSendChatroomMessageParams(
    const flutter::EncodableMap* arguments) {
  v2::V2NIMSendChatroomMessageParams object;
  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("messageConfig")) {
      auto messageConfigMap = std::get<flutter::EncodableMap>(iter->second);
      object.messageConfig = getChatroomMessageConfig(&messageConfigMap);
    } else if (iter->first == flutter::EncodableValue("routeConfig")) {
      auto routeConfigMap = std::get<flutter::EncodableMap>(iter->second);
      object.routeConfig = getMessageRouteConfig(&routeConfigMap);
    } else if (iter->first == flutter::EncodableValue("antispamConfig")) {
      auto antispamConfigMap = std::get<flutter::EncodableMap>(iter->second);
      object.antispamConfig = getMessageAntispamConfig(&antispamConfigMap);
    } else if (iter->first ==
               flutter::EncodableValue("clientAntispamEnabled")) {
      object.clientAntispamEnabled = std::get<bool>(iter->second);
    } else if (iter->first ==
               flutter::EncodableValue("clientAntispamReplace")) {
      object.clientAntispamReplace = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("receiverIds")) {
      std::vector<nstd::string> receiverIds;
      auto receiverIdsList = std::get<flutter::EncodableList>(iter->second);
      for (auto& it : receiverIdsList) {
        auto receiverId = std::get<std::string>(it);
        receiverIds.emplace_back(receiverId);
      }
      object.receiverIds = receiverIds;
    } else if (iter->first == flutter::EncodableValue("notifyTargetTags")) {
      object.notifyTargetTags = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("locationInfo")) {
      auto locationInfoMap = std::get<flutter::EncodableMap>(iter->second);
      object.locationInfo = getLocationInfo(&locationInfoMap);
    }
  }
  return object;
}

v2::V2NIMChatroomMessageListOption getChatroomMessageListOption(
    const flutter::EncodableMap* arguments) {
  v2::V2NIMChatroomMessageListOption object;
  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("direction")) {
      object.direction = v2::V2NIMQueryDirection(std::get<int>(iter->second));
    } else if (iter->first == flutter::EncodableValue("messageTypes")) {
      std::vector<v2::V2NIMMessageType> messageTypes;
      auto messageTypeList = std::get<flutter::EncodableList>(iter->second);
      for (auto& it : messageTypeList) {
        auto messageType = std::get<int>(it);
        messageTypes.emplace_back(v2::V2NIMMessageType(messageType));
      }
      object.messageTypes = messageTypes;
    } else if (iter->first == flutter::EncodableValue("beginTime")) {
      auto beginTime = iter->second.LongValue();
      object.beginTime = beginTime;
    } else if (iter->first == flutter::EncodableValue("limit")) {
      auto limit = iter->second.LongValue();
      object.limit = limit;
    }
  }
  return object;
}

v2::V2NIMChatroomTagMessageOption getChatroomTagMessageOption(
    const flutter::EncodableMap* arguments) {
  v2::V2NIMChatroomTagMessageOption object;
  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("tags")) {
      std::vector<std::string> tags;
      auto tagsList = std::get<flutter::EncodableList>(iter->second);
      for (auto& it : tagsList) {
        auto tag = std::get<std::string>(it);
        tags.emplace_back(tag);
      }
      object.tags = tags;
    } else if (iter->first == flutter::EncodableValue("messageTypes")) {
      std::vector<v2::V2NIMMessageType> messageTypes;
      auto messageTypeList = std::get<flutter::EncodableList>(iter->second);
      for (auto& it : messageTypeList) {
        auto messageType = std::get<int>(it);
        messageTypes.emplace_back(v2::V2NIMMessageType(messageType));
      }
      object.messageTypes = messageTypes;
    } else if (iter->first == flutter::EncodableValue("beginTime")) {
      auto beginTime = iter->second.LongValue();
      object.beginTime = beginTime;
    } else if (iter->first == flutter::EncodableValue("endTime")) {
      auto endTime = iter->second.LongValue();
      object.endTime = endTime;
    } else if (iter->first == flutter::EncodableValue("limit")) {
      auto limit = iter->second.LongValue();
      object.limit = limit;
    } else if (iter->first == flutter::EncodableValue("direction")) {
      object.direction = v2::V2NIMQueryDirection(std::get<int>(iter->second));
    }
  }
  return object;
}

v2::V2NIMChatroomMemberQueryOption getChatroomMemberQueryOption(
    const flutter::EncodableMap* arguments) {
  v2::V2NIMChatroomMemberQueryOption object;
  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("memberRoles")) {
      std::vector<v2::V2NIMChatroomMemberRole> memberRoles;
      auto memberRolesList = std::get<flutter::EncodableList>(iter->second);
      for (auto& it : memberRolesList) {
        auto memberRole = std::get<int>(it);
        memberRoles.emplace_back(v2::V2NIMChatroomMemberRole(memberRole));
      }
      object.memberRoles = memberRoles;
    } else if (iter->first == flutter::EncodableValue("onlyBlocked")) {
      object.onlyBlocked = std::get<bool>(iter->second);
    } else if (iter->first == flutter::EncodableValue("onlyChatBanned")) {
      object.onlyChatBanned = std::get<bool>(iter->second);
    } else if (iter->first == flutter::EncodableValue("onlyOnline")) {
      object.onlyOnline = std::get<bool>(iter->second);
    } else if (iter->first == flutter::EncodableValue("pageToken")) {
      object.pageToken = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("limit")) {
      auto limit = iter->second.LongValue();
      object.limit = limit;
    }
  }
  return object;
}

v2::V2NIMChatroomMemberRoleUpdateParams getChatroomMemberRoleUpdateParams(
    const flutter::EncodableMap* arguments) {
  v2::V2NIMChatroomMemberRoleUpdateParams object;
  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("memberRole")) {
      object.memberRole =
          v2::V2NIMChatroomMemberRole(std::get<int>(iter->second));
    } else if (iter->first == flutter::EncodableValue("memberLevel")) {
      object.memberLevel = static_cast<uint32_t>(std::get<int>(iter->second));
    } else if (iter->first ==
               flutter::EncodableValue("notificationExtension")) {
      object.notificationExtension = std::get<std::string>(iter->second);
    }
  }
  return object;
}

v2::V2NIMChatroomUpdateParams getChatroomUpdateParams(
    const flutter::EncodableMap* arguments) {
  v2::V2NIMChatroomUpdateParams object;
  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("roomName")) {
      object.roomName = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("announcement")) {
      object.announcement = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("liveUrl")) {
      object.liveUrl = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("serverExtension")) {
      object.serverExtension = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("notificationEnabled")) {
      object.notificationEnabled = std::get<bool>(iter->second);
    } else if (iter->first ==
               flutter::EncodableValue("notificationExtension")) {
      object.notificationExtension = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("queueLevelMode")) {
      object.queueLevelMode =
          v2::V2NIMChatroomQueueLevelMode(std::get<int>(iter->second));
    }
  }
  return object;
}

v2::V2NIMAntispamConfig getAntispamConfig(
    const flutter::EncodableMap* arguments) {
  v2::V2NIMAntispamConfig object;
  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("antispamBusinessId")) {
      object.antispamBusinessId = std::get<std::string>(iter->second);
    }
  }
  return object;
}

v2::V2NIMChatroomSelfMemberUpdateParams getChatroomSelfMemberUpdateParams(
    const flutter::EncodableMap* arguments) {
  v2::V2NIMChatroomSelfMemberUpdateParams object;
  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("roomNick")) {
      object.roomNick = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("roomAvatar")) {
      object.roomAvatar = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("serverExtension")) {
      object.serverExtension = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("notificationEnabled")) {
      object.notificationEnabled = std::get<bool>(iter->second);
    } else if (iter->first ==
               flutter::EncodableValue("notificationExtension")) {
      object.notificationExtension = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("persistence")) {
      object.persistence = std::get<bool>(iter->second);
    }
  }
  return object;
}

v2::V2NIMChatroomLocationConfig getChatroomLocationConfig(
    const flutter::EncodableMap* arguments) {
  v2::V2NIMChatroomLocationConfig object;
  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("locationInfo")) {
      auto paramsMap = std::get<flutter::EncodableMap>(iter->second);
      object.locationInfo = getLocationInfo(&paramsMap);
    } else if (iter->first == flutter::EncodableValue("distance")) {
      object.distance = std::get<double>(iter->second);
    }
  }
  return object;
}

v2::V2NIMChatroomTagsUpdateParams getChatroomTagsUpdateParams(
    const flutter::EncodableMap* arguments) {
  v2::V2NIMChatroomTagsUpdateParams object;
  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("tags")) {
      std::vector<std::string> tags;
      auto tagsList = std::get<flutter::EncodableList>(iter->second);
      for (auto& it : tagsList) {
        auto tag = std::get<std::string>(it);
        tags.emplace_back(tag);
      }
      object.tags = tags;
    } else if (iter->first == flutter::EncodableValue("notifyTargetTags")) {
      object.notifyTargetTags = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("notificationEnabled")) {
      object.notificationEnabled = std::get<bool>(iter->second);
    } else if (iter->first ==
               flutter::EncodableValue("notificationExtension")) {
      object.notificationExtension = std::get<std::string>(iter->second);
    }
  }
  return object;
}

v2::V2NIMChatroomTagTempChatBannedParams getChatroomTagTempChatBannedParams(
    const flutter::EncodableMap* arguments) {
  v2::V2NIMChatroomTagTempChatBannedParams object;
  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("targetTag")) {
      object.targetTag = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("notifyTargetTags")) {
      object.notifyTargetTags = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("duration")) {
      object.duration = iter->second.LongValue();
    } else if (iter->first == flutter::EncodableValue("notificationEnabled")) {
      object.notificationEnabled = std::get<bool>(iter->second);
    } else if (iter->first ==
               flutter::EncodableValue("notificationExtension")) {
      object.notificationExtension = std::get<std::string>(iter->second);
    }
  }
  return object;
}

v2::V2NIMChatroomTagMemberOption getChatroomTagMemberOption(
    const flutter::EncodableMap* arguments) {
  v2::V2NIMChatroomTagMemberOption object;
  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("tag")) {
      object.tag = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("pageToken")) {
      object.pageToken = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("limit")) {
      object.limit = iter->second.LongValue();
    }
  }
  return object;
}

v2::V2NIMChatroomMessageConfig getChatroomMessageConfig(
    const flutter::EncodableMap* arguments) {
  v2::V2NIMChatroomMessageConfig object;
  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("historyEnabled")) {
      object.historyEnabled = std::get<bool>(iter->second);
    } else if (iter->first == flutter::EncodableValue("highPriority")) {
      object.highPriority = std::get<bool>(iter->second);
    }
  }
  return object;
}