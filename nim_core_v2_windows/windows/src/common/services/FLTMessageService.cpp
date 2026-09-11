// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#include "FLTMessageService.h"

#include <future>

#include "../NimResult.h"
#include "nim_cpp_wrapper/nim_cpp_api.h"

flutter::EncodableMap convertTopicRefer(const v2::V2NIMTopicRefer object);
v2::V2NIMTopicRefer getTopicRefer(const flutter::EncodableMap* arguments);

int MESSAGE_SERIALIZATION_ERROR = 199001;

FLTMessageService::FLTMessageService() {
  m_serviceName = "MessageService";

  listener.onSendMessage = [this](v2::V2NIMMessage message) {
    // send message

    flutter::EncodableMap resultMap = convertMessage(&message);
    notifyEvent("onSendMessage", resultMap);
  };

  listener.onReceiveMessages = [this](nstd::vector<v2::V2NIMMessage> messages) {
    // receive messages

    flutter::EncodableList messagesList;
    for (auto message : messages) {
      messagesList.emplace_back(convertMessage(&message));
    }
    flutter::EncodableMap resultMap;
    resultMap.insert(std::make_pair("messages", messagesList));
    notifyEvent("onReceiveMessages", resultMap);
  };
  listener.onReceiveP2PMessageReadReceipts =
      [this](nstd::vector<v2::V2NIMP2PMessageReadReceipt> readReceipts) {
        // receive p2p message read receipts

        flutter::EncodableList readReceiptsList;
        for (auto readReceipt : readReceipts) {
          flutter::EncodableMap readReceiptMap =
              convertP2PMessageReadReceipt(readReceipt);
          readReceiptsList.emplace_back(readReceiptMap);
        }
        flutter::EncodableMap resultMap;
        resultMap.insert(
            std::make_pair("p2pMessageReadReceipts", readReceiptsList));
        notifyEvent("onReceiveP2PMessageReadReceipts", resultMap);
      };
  listener.onReceiveTeamMessageReadReceipts =
      [this](nstd::vector<v2::V2NIMTeamMessageReadReceipt> readReceipts) {
        // receive team message read receipts

        flutter::EncodableList readReceiptsList;
        for (auto readReceipt : readReceipts) {
          readReceiptsList.emplace_back(
              convertTeamMessageReadReceipt(readReceipt));
        }
        flutter::EncodableMap resultMap;
        resultMap.insert(
            std::make_pair("teamMessageReadReceipts", readReceiptsList));
        notifyEvent("onReceiveTeamMessageReadReceipts", resultMap);
      };
  listener.onMessageRevokeNotifications =
      [this](nstd::vector<v2::V2NIMMessageRevokeNotification>
                 revokeNotifications) {
        // receive message revoke notifications

        flutter::EncodableList revokeNotificationsList;
        for (auto revokeNotification : revokeNotifications) {
          revokeNotificationsList.emplace_back(
              convertMessageRevokeNotification(revokeNotification));
        }
        flutter::EncodableMap resultMap;
        resultMap.insert(
            std::make_pair("revokeNotifications", revokeNotificationsList));
        notifyEvent("onMessageRevokeNotifications", resultMap);
      };
  listener.onMessagePinNotification =
      [this](v2::V2NIMMessagePinNotification pinNotification) {
        // receive message pin notification

        flutter::EncodableMap resultMap =
            convertMessagePinNotification(pinNotification);
        notifyEvent("onMessagePinNotification", resultMap);
      };
  listener.onMessageQuickCommentNotification =
      [this](
          v2::V2NIMMessageQuickCommentNotification quickCommentNotification) {
        // receive message quick comment notification

        flutter::EncodableMap resultMap =
            convertMessageQuickCommentNotification(quickCommentNotification);
        notifyEvent("onMessageQuickCommentNotification", resultMap);
      };
  listener.onMessageDeletedNotifications =
      [this](nstd::vector<v2::V2NIMMessageDeletedNotification>
                 messageDeletedNotification) {
        // receive message deleted notifications

        flutter::EncodableList messageDeletedNotificationList;
        for (auto deletedNotification : messageDeletedNotification) {
          messageDeletedNotificationList.emplace_back(
              convertMessageDeletedNotification(deletedNotification));
        }
        flutter::EncodableMap resultMap;
        resultMap.insert(std::make_pair("deletedNotifications",
                                        messageDeletedNotificationList));
        notifyEvent("onMessageDeletedNotifications", resultMap);
      };
  listener.onClearHistoryNotifications =
      [this](nstd::vector<v2::V2NIMClearHistoryNotification>
                 clearHistoryNotification) {
        // receive clear history notifications

        flutter::EncodableList clearHistoryNotificationList;
        for (auto clearHistoryNoti : clearHistoryNotification) {
          clearHistoryNotificationList.emplace_back(
              convertClearHistoryNotification(clearHistoryNoti));
        }
        flutter::EncodableMap resultMap;
        resultMap.insert(std::make_pair("clearHistoryNotifications",
                                        clearHistoryNotificationList));
        notifyEvent("onClearHistoryNotifications", resultMap);
      };

  listener.onReceiveMessagesModified =
      [this](nstd::vector<v2::V2NIMMessage> messages) {
        // receive messages modified

        flutter::EncodableList messagesList;
        for (auto message : messages) {
          messagesList.emplace_back(convertMessage(&message));
        }
        flutter::EncodableMap resultMap;
        resultMap.insert(std::make_pair("messages", messagesList));
        notifyEvent("onReceiveMessagesModified", resultMap);
      };

  auto& client = v2::V2NIMClient::get();
  auto& messageService = client.getMessageService();

  messageService.addMessageListener(listener);

  messageFilter.shouldIgnore = [this](v2::V2NIMMessage message) {
    flutter::EncodableMap arguments;
    arguments.insert(std::make_pair("message", convertMessage(&message)));
    std::promise<bool> promise;
    std::future<bool> future = promise.get_future();
    notifyEvent(
        "shouldIgnore", arguments,
        [this, &promise](const std::optional<flutter::EncodableValue>& result) {
          if (result.has_value() &&
              std::holds_alternative<bool>(result.value())) {
            bool resultBool = std::get<bool>(result.value());
            promise.set_value(resultBool);
          } else {
            promise.set_value(false);
          }
        });

    bool result = future.get();
    return result;
  };
}

FLTMessageService::~FLTMessageService() {
  auto& client = v2::V2NIMClient::get();
  auto& messageService = client.getMessageService();
  messageService.removeMessageListener(listener);
}

void FLTMessageService::onMethodCalled(
    const std::string& method, const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  switch (utils::hash_(method.c_str())) {
    case "sendMessage"_hash:
      sendMessage(arguments, result);
      return;
    case "replyMessage"_hash:
      replyMessage(arguments, result);
      return;
    case "revokeMessage"_hash:
      revokeMessage(arguments, result);
      return;
    case "getMessageList"_hash:
      getMessageList(arguments, result);
      return;
    case "getMessageListByIds"_hash:
      getMessageListByIds(arguments, result);
      return;
    case "getMessageListByRefers"_hash:
      getMessageListByRefers(arguments, result);
      return;
    case "deleteMessage"_hash:
      deleteMessage(arguments, result);
      return;
    case "deleteMessages"_hash:
      deleteMessages(arguments, result);
      return;
    case "clearHistoryMessage"_hash:
      clearHistoryMessage(arguments, result);
      return;
    case "updateMessageLocalExtension"_hash:
      updateMessageLocalExtension(arguments, result);
      return;
    case "insertMessageToLocal"_hash:
      insertMessageToLocal(arguments, result);
      return;
    case "insertMessageToLocalEx"_hash:
      insertMessageToLocalEx(arguments, result);
      return;
    case "pinMessage"_hash:
      pinMessage(arguments, result);
      return;
    case "unpinMessage"_hash:
      unpinMessage(arguments, result);
      return;
    case "updatePinMessage"_hash:
      updatePinMessage(arguments, result);
      return;
    case "getPinnedMessageList"_hash:
      getPinnedMessageList(arguments, result);
      return;
    case "addQuickComment"_hash:
      addQuickComment(arguments, result);
      return;
    case "removeQuickComment"_hash:
      removeQuickComment(arguments, result);
      return;
    case "getQuickCommentList"_hash:
      getQuickCommentList(arguments, result);
      return;
    case "addCollection"_hash:
      addCollection(arguments, result);
      return;
    case "removeCollections"_hash:
      removeCollections(arguments, result);
      return;
    case "updateCollectionExtension"_hash:
      updateCollectionExtension(arguments, result);
      return;
    case "getCollectionListByOption"_hash:
      getCollectionListByOption(arguments, result);
      return;
    case "sendP2PMessageReceipt"_hash:
      sendP2PMessageReceipt(arguments, result);
      return;
    case "getP2PMessageReceipt"_hash:
      getP2PMessageReceipt(arguments, result);
      return;
    case "isPeerRead"_hash:
      isPeerRead(arguments, result);
      return;
    case "sendTeamMessageReceipts"_hash:
      sendTeamMessageReceipts(arguments, result);
      return;
    case "getTeamMessageReceipts"_hash:
      getTeamMessageReceipts(arguments, result);
      return;
    case "getTeamMessageReceiptDetail"_hash:
      getTeamMessageReceiptDetail(arguments, result);
      return;
    case "voiceToText"_hash:
      voiceToText(arguments, result);
      return;
    case "cancelMessageAttachmentUpload"_hash:
      cancelMessageAttachmentUpload(arguments, result);
      return;
    case "searchCloudMessages"_hash:
      searchCloudMessages(arguments, result);
      return;
    case "getLocalThreadMessageList"_hash:
      getLocalThreadMessageList(arguments, result);
      return;
    case "getThreadMessageList"_hash:
      getThreadMessageList(arguments, result);
      return;
    case "searchCloudMessagesEx"_hash:
      searchCloudMessagesEx(arguments, result);
      return;
    case "getMessageListEx"_hash:
      getMessageListEx(arguments, result);
      return;
    case "searchLocalMessages"_hash:
      searchLocalMessages(arguments, result);
      return;
    case "updateLocalMessage"_hash:
      updateLocalMessage(arguments, result);
      return;
    case "getCollectionListExByOption"_hash:
      getCollectionListExByOption(arguments, result);
      return;
    case "setMessageFilter"_hash:
      setMessageFilter(arguments, result);
      return;
    case "modifyMessage"_hash:
      modifyMessage(arguments, result);
      return;
    case "regenAIMessage"_hash:
      regenAIMessage(arguments, result);
      return;
    case "clearRoamingMessage"_hash:
      clearRoamingMessage(arguments, result);
      return;
    case "translateText"_hash:
      translateText(arguments, result);
      return;
    case "messageDeserialization"_hash:
      messageDeserialization(arguments, result);
      return;
    case "messageSerialization"_hash:
      messageSerialization(arguments, result);
      return;
    case "stopAIStreamMessage"_hash:
      stopAIStreamMessage(arguments, result);
      return;
    case "clearLocalMessage"_hash:
      clearLocalMessage(arguments, result);
      return;
    default:
      break;
  }
  if (result) result->NotImplemented();
}

void FLTMessageService::sendMessage(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  v2::V2NIMMessage message;
  std::string conversationId = "";
  v2::V2NIMSendMessageParams params;

  auto iter = arguments->begin();
  for (; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("message")) {
      auto paramsMap = std::get<flutter::EncodableMap>(iter->second);
      message = getMessage(&paramsMap);
      std::cout << "message: " << std::endl;
    } else if (iter->first == flutter::EncodableValue("conversationId")) {
      conversationId = std::get<std::string>(iter->second);
      std::cout << "conversationId: " << conversationId << std::endl;
    } else if (iter->first == flutter::EncodableValue("params")) {
      auto paramsMap = std::get<flutter::EncodableMap>(iter->second);
      params = getSendMessageParams(&paramsMap);
    }
  }

  auto& instance = v2::V2NIMClient::get();
  auto& messageService = instance.getMessageService();
  messageService.sendMessage(
      message, conversationId, params,
      [result](v2::V2NIMSendMessageResult msgResult) {
        flutter::EncodableMap resultMap = convertSendMessageResult(msgResult);
        result->Success(NimResult::getSuccessResult(resultMap));
      },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      },
      [=](uint32_t progress) {
        flutter::EncodableMap ret;
        auto messageClientId = message.messageClientId;
        ret.insert(std::make_pair("messageClientId", messageClientId));
        ret.insert(std::make_pair("progress", static_cast<int64_t>(progress)));
        notifyEvent("onSendMessageProgress", ret);
      });
}

void FLTMessageService::replyMessage(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  v2::V2NIMMessage message;
  v2::V2NIMMessage replyMessage;
  v2::V2NIMSendMessageParams params;

  auto iter = arguments->begin();
  for (; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("message")) {
      auto paramsMap = std::get<flutter::EncodableMap>(iter->second);
      message = getMessage(&paramsMap);
    } else if (iter->first == flutter::EncodableValue("replyMessage")) {
      auto paramsMap = std::get<flutter::EncodableMap>(iter->second);
      replyMessage = getMessage(&paramsMap);
    } else if (iter->first == flutter::EncodableValue("params")) {
      auto paramsMap = std::get<flutter::EncodableMap>(iter->second);
      params = getSendMessageParams(&paramsMap);
    }
  }

  auto& instance = v2::V2NIMClient::get();
  auto& messageService = instance.getMessageService();
  messageService.replyMessage(
      message, replyMessage, params,
      [result](v2::V2NIMSendMessageResult msgResult) {
        flutter::EncodableMap resultMap = convertSendMessageResult(msgResult);
        result->Success(NimResult::getSuccessResult(resultMap));
      },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      },
      [=](uint32_t progress) {
        flutter::EncodableMap ret;
        auto messageClientId = message.messageClientId;
        ret.insert(std::make_pair("messageClientId", messageClientId));
        ret.insert(std::make_pair("progress", static_cast<int64_t>(progress)));
        notifyEvent("onSendMessageProgress", ret);
      });
}

void FLTMessageService::revokeMessage(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  v2::V2NIMMessage message;
  v2::V2NIMMessageRevokeParams revokeParams;

  auto iter = arguments->begin();
  for (; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("message")) {
      auto paramsMap = std::get<flutter::EncodableMap>(iter->second);
      message = getMessage(&paramsMap);
    } else if (iter->first == flutter::EncodableValue("revokeParams")) {
      auto paramsMap = std::get<flutter::EncodableMap>(iter->second);
      revokeParams = getMessageRevokeParams(&paramsMap);
    }
  }

  auto& instance = v2::V2NIMClient::get();
  auto& messageService = instance.getMessageService();
  messageService.revokeMessage(
      message, revokeParams,
      [result]() { result->Success(NimResult::getSuccessResult()); },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void FLTMessageService::getMessageList(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  v2::V2NIMMessageListOption option;

  auto iter = arguments->begin();
  for (; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("option")) {
      auto paramsMap = std::get<flutter::EncodableMap>(iter->second);
      option = getMessageListOption(&paramsMap);
    }
  }

  auto& instance = v2::V2NIMClient::get();
  auto& messageService = instance.getMessageService();
  messageService.getMessageList(
      option,
      [result](nstd::vector<v2::V2NIMMessage> messages) {
        flutter::EncodableList messagesList;
        for (auto message : messages) {
          messagesList.emplace_back(convertMessage(&message));
        }
        flutter::EncodableMap resultMap;
        resultMap.insert(std::make_pair("messages", messagesList));
        result->Success(NimResult::getSuccessResult(resultMap));
      },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void FLTMessageService::getMessageListByIds(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  std::vector<nstd::string> messageClientIds;

  auto iter = arguments->begin();
  for (; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("messageClientIds")) {
      auto messageIdList = std::get<flutter::EncodableList>(iter->second);
      for (auto& it : messageIdList) {
        auto messageId = std::get<std::string>(it);
        messageClientIds.emplace_back(messageId);
      }
    }
  }

  auto& instance = v2::V2NIMClient::get();
  auto& messageService = instance.getMessageService();
  messageService.getMessageListByIds(
      messageClientIds,
      [result](nstd::vector<v2::V2NIMMessage> messages) {
        flutter::EncodableList messagesList;
        for (auto message : messages) {
          messagesList.emplace_back(convertMessage(&message));
        }
        flutter::EncodableMap resultMap;
        resultMap.insert(std::make_pair("messages", messagesList));
        result->Success(NimResult::getSuccessResult(resultMap));
      },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void FLTMessageService::getMessageListByRefers(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  std::vector<v2::V2NIMMessageRefer> messageRefers;

  auto iter = arguments->begin();
  for (; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("messageRefers")) {
      auto messageRefersList = std::get<flutter::EncodableList>(iter->second);
      for (auto& it : messageRefersList) {
        auto messageReferMap = std::get<flutter::EncodableMap>(it);
        auto messageRefer = getMessageRefer(&messageReferMap);
        messageRefers.emplace_back(messageRefer);
      }
    }
  }

  auto& instance = v2::V2NIMClient::get();
  auto& messageService = instance.getMessageService();
  messageService.getMessageListByRefers(
      messageRefers,
      [result](nstd::vector<v2::V2NIMMessage> messages) {
        flutter::EncodableList messagesList;
        for (auto message : messages) {
          messagesList.emplace_back(convertMessage(&message));
        }
        flutter::EncodableMap resultMap;
        resultMap.insert(std::make_pair("messages", messagesList));
        result->Success(NimResult::getSuccessResult(resultMap));
      },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void FLTMessageService::deleteMessage(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  v2::V2NIMMessage message;
  nstd::optional<nstd::string> serverExtension;
  bool onlyDeleteLocal = true;

  auto iter = arguments->begin();
  for (; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("message")) {
      auto paramsMap = std::get<flutter::EncodableMap>(iter->second);
      message = getMessage(&paramsMap);
    } else if (iter->first == flutter::EncodableValue("serverExtension")) {
      serverExtension = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("onlyDeleteLocal")) {
      onlyDeleteLocal = std::get<bool>(iter->second);
    }
  }

  auto& instance = v2::V2NIMClient::get();
  auto& messageService = instance.getMessageService();
  messageService.deleteMessage(
      message, serverExtension, onlyDeleteLocal,
      [result]() { result->Success(NimResult::getSuccessResult()); },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void FLTMessageService::deleteMessages(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  std::vector<v2::V2NIMMessage> messages;
  nstd::optional<nstd::string> serverExtension;
  bool onlyDeleteLocal = true;

  auto iter = arguments->begin();
  for (; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("messages")) {
      auto messagesList = std::get<flutter::EncodableList>(iter->second);
      for (auto& it : messagesList) {
        auto messageMap = std::get<flutter::EncodableMap>(it);
        auto message = getMessage(&messageMap);
        messages.emplace_back(message);
      }
    } else if (iter->first == flutter::EncodableValue("serverExtension")) {
      serverExtension = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("onlyDeleteLocal")) {
      onlyDeleteLocal = std::get<bool>(iter->second);
    }
  }

  auto& instance = v2::V2NIMClient::get();
  auto& messageService = instance.getMessageService();
  messageService.deleteMessages(
      messages, serverExtension, onlyDeleteLocal,
      [result]() { result->Success(NimResult::getSuccessResult()); },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void FLTMessageService::clearHistoryMessage(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  v2::V2NIMClearHistoryMessageOption option;

  auto iter = arguments->begin();
  for (; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("option")) {
      auto paramsMap = std::get<flutter::EncodableMap>(iter->second);
      option = getClearHistoryMessageOption(&paramsMap);
    }
  }

  auto& instance = v2::V2NIMClient::get();
  auto& messageService = instance.getMessageService();
  messageService.clearHistoryMessage(
      option, [result]() { result->Success(NimResult::getSuccessResult()); },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void FLTMessageService::updateMessageLocalExtension(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  v2::V2NIMMessage message;
  nstd::string localExtension;

  auto iter = arguments->begin();
  for (; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("message")) {
      auto paramsMap = std::get<flutter::EncodableMap>(iter->second);
      message = getMessage(&paramsMap);
    } else if (iter->first == flutter::EncodableValue("localExtension")) {
      localExtension = std::get<std::string>(iter->second);
    }
  }

  auto& instance = v2::V2NIMClient::get();
  auto& messageService = instance.getMessageService();
  messageService.updateMessageLocalExtension(
      message, localExtension,
      [result](v2::V2NIMMessage message) {
        flutter::EncodableMap resultMap = convertMessage(message);
        result->Success(NimResult::getSuccessResult(resultMap));
      },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void FLTMessageService::insertMessageToLocal(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  v2::V2NIMMessage message;
  nstd::string conversationId;
  nstd::string senderId;
  uint64_t createTime = 0;

  auto iter = arguments->begin();
  for (; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("message")) {
      auto paramsMap = std::get<flutter::EncodableMap>(iter->second);
      message = getMessage(&paramsMap);
    } else if (iter->first == flutter::EncodableValue("conversationId")) {
      conversationId = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("senderId")) {
      senderId = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("createTime")) {
      createTime = iter->second.LongValue();
    }
  }

  auto& instance = v2::V2NIMClient::get();
  auto& messageService = instance.getMessageService();
  messageService.insertMessageToLocal(
      message, conversationId, senderId, createTime,
      [result](v2::V2NIMMessage message) {
        flutter::EncodableMap resultMap = convertMessage(message);
        result->Success(NimResult::getSuccessResult(resultMap));
      },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void FLTMessageService::insertMessageToLocalEx(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  v2::V2NIMMessage message;
  v2::V2NIMMessageInsertParams params;

  auto iter = arguments->begin();
  for (; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("message")) {
      auto paramsMap = std::get<flutter::EncodableMap>(iter->second);
      message = getMessage(&paramsMap);
    } else if (iter->first == flutter::EncodableValue("params")) {
      auto paramsMap = std::get<flutter::EncodableMap>(iter->second);
      for (auto& p : paramsMap) {
        if (p.second.IsNull()) continue;
        if (p.first == flutter::EncodableValue("conversationId")) {
          params.conversationId = std::get<std::string>(p.second);
        } else if (p.first == flutter::EncodableValue("senderId")) {
          params.senderId = std::get<std::string>(p.second);
        } else if (p.first == flutter::EncodableValue("createTime")) {
          params.createTime = static_cast<uint64_t>(p.second.LongValue());
        } else if (p.first ==
                   flutter::EncodableValue("lastMessageUpdateEnabled")) {
          params.lastMessageUpdateEnabled = std::get<bool>(p.second);
        }
      }
    }
  }

  auto& instance = v2::V2NIMClient::get();
  auto& messageService = instance.getMessageService();
  messageService.insertMessageToLocalEx(
      message, params,
      [result](v2::V2NIMMessage msg) {
        flutter::EncodableMap resultMap = convertMessage(msg);
        result->Success(NimResult::getSuccessResult(resultMap));
      },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void FLTMessageService::pinMessage(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  v2::V2NIMMessage message;
  nstd::optional<nstd::string> serverExtension;

  auto iter = arguments->begin();
  for (; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("message")) {
      auto paramsMap = std::get<flutter::EncodableMap>(iter->second);
      message = getMessage(&paramsMap);
    } else if (iter->first == flutter::EncodableValue("serverExtension")) {
      serverExtension = std::get<std::string>(iter->second);
    }
  }

  auto& instance = v2::V2NIMClient::get();
  auto& messageService = instance.getMessageService();
  messageService.pinMessage(
      message, serverExtension,
      [result]() { result->Success(NimResult::getSuccessResult()); },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void FLTMessageService::unpinMessage(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  v2::V2NIMMessageRefer messageRefer;
  nstd::optional<nstd::string> serverExtension;

  auto iter = arguments->begin();
  for (; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("messageRefer")) {
      auto paramsMap = std::get<flutter::EncodableMap>(iter->second);
      messageRefer = getMessageRefer(&paramsMap);
    } else if (iter->first == flutter::EncodableValue("serverExtension")) {
      serverExtension = std::get<std::string>(iter->second);
    }
  }

  auto& instance = v2::V2NIMClient::get();
  auto& messageService = instance.getMessageService();
  messageService.unpinMessage(
      messageRefer, serverExtension,
      [result]() { result->Success(NimResult::getSuccessResult()); },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void FLTMessageService::updatePinMessage(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  v2::V2NIMMessage message;
  nstd::optional<nstd::string> serverExtension;

  auto iter = arguments->begin();
  for (; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("message")) {
      auto paramsMap = std::get<flutter::EncodableMap>(iter->second);
      message = getMessage(&paramsMap);
    } else if (iter->first == flutter::EncodableValue("serverExtension")) {
      serverExtension = std::get<std::string>(iter->second);
    }
  }

  auto& instance = v2::V2NIMClient::get();
  auto& messageService = instance.getMessageService();
  messageService.updatePinMessage(
      message, serverExtension,
      [result]() { result->Success(NimResult::getSuccessResult()); },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void FLTMessageService::getPinnedMessageList(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  std::string conversationId;

  auto iter = arguments->begin();
  for (; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("conversationId")) {
      conversationId = std::get<std::string>(iter->second);
    }
  }

  auto& instance = v2::V2NIMClient::get();
  auto& messageService = instance.getMessageService();
  messageService.getPinnedMessageList(
      conversationId,
      [result](nstd::vector<v2::V2NIMMessagePin> messagePins) {
        flutter::EncodableList messagesPinList;
        for (auto messagePin : messagePins) {
          messagesPinList.emplace_back(convertMessagePin(messagePin));
        }
        flutter::EncodableMap resultMap;
        resultMap.insert(std::make_pair("pinMessages", messagesPinList));
        result->Success(NimResult::getSuccessResult(resultMap));
      },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void FLTMessageService::addQuickComment(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  v2::V2NIMMessage message;
  uint64_t index;
  nstd::optional<nstd::string> serverExtension;
  v2::V2NIMMessageQuickCommentPushConfig pushConfig;

  auto iter = arguments->begin();
  for (; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("message")) {
      auto paramsMap = std::get<flutter::EncodableMap>(iter->second);
      message = getMessage(&paramsMap);
    } else if (iter->first == flutter::EncodableValue("index")) {
      index = iter->second.LongValue();
    } else if (iter->first == flutter::EncodableValue("serverExtension")) {
      serverExtension = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("pushConfig")) {
      auto paramsMap = std::get<flutter::EncodableMap>(iter->second);
      pushConfig = getMessageQuickCommentPushConfig(&paramsMap);
    }
  }

  auto& instance = v2::V2NIMClient::get();
  auto& messageService = instance.getMessageService();
  messageService.addQuickComment(
      message, index, serverExtension, pushConfig,
      [result]() { result->Success(NimResult::getSuccessResult()); },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void FLTMessageService::removeQuickComment(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  v2::V2NIMMessageRefer messageRefer;
  uint32_t index;
  nstd::optional<nstd::string> serverExtension;

  auto iter = arguments->begin();
  for (; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("messageRefer")) {
      auto paramsMap = std::get<flutter::EncodableMap>(iter->second);
      messageRefer = getMessageRefer(&paramsMap);
    } else if (iter->first == flutter::EncodableValue("index")) {
      index = iter->second.LongValue();
    } else if (iter->first == flutter::EncodableValue("serverExtension")) {
      serverExtension = std::get<std::string>(iter->second);
    }
  }

  auto& instance = v2::V2NIMClient::get();
  auto& messageService = instance.getMessageService();
  messageService.removeQuickComment(
      messageRefer, index, serverExtension,
      [result]() { result->Success(NimResult::getSuccessResult()); },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void FLTMessageService::getQuickCommentList(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  std::vector<v2::V2NIMMessage> messages;

  auto iter = arguments->begin();
  for (; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("messages")) {
      auto messagesList = std::get<flutter::EncodableList>(iter->second);
      for (auto& it : messagesList) {
        auto messageMap = std::get<flutter::EncodableMap>(it);
        auto message = getMessage(&messageMap);
        messages.emplace_back(message);
      }
    }
  }

  auto& instance = v2::V2NIMClient::get();
  auto& messageService = instance.getMessageService();
  messageService.getQuickCommentList(
      messages,
      [result](
          nstd::map<nstd::string, nstd::vector<v2::V2NIMMessageQuickComment>>
              messageQuickComments) {
        flutter::EncodableMap messagesQuickCommentsMap;
        for (auto& it : messageQuickComments) {
          flutter::EncodableList quickCommentsList;
          for (auto& quickComment : it.second) {
            quickCommentsList.emplace_back(
                convertMessageQuickComment(quickComment));
          }
          messagesQuickCommentsMap.insert(
              std::make_pair(it.first, quickCommentsList));
        }

        result->Success(NimResult::getSuccessResult(messagesQuickCommentsMap));
      },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void FLTMessageService::addCollection(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  v2::V2NIMAddCollectionParams params;

  auto iter = arguments->begin();
  for (; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("params")) {
      auto paramsMap = std::get<flutter::EncodableMap>(iter->second);
      params = getAddCollectionParams(&paramsMap);
    }
  }

  auto& instance = v2::V2NIMClient::get();
  auto& messageService = instance.getMessageService();
  messageService.addCollection(
      params,
      [result](v2::V2NIMCollection collection) {
        flutter::EncodableMap resultMap = convertCollection(collection);
        result->Success(NimResult::getSuccessResult(resultMap));
      },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void FLTMessageService::removeCollections(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  std::vector<v2::V2NIMCollection> collections;

  auto iter = arguments->begin();
  for (; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("collections")) {
      auto collectionsList = std::get<flutter::EncodableList>(iter->second);
      for (auto& it : collectionsList) {
        auto collectionMap = std::get<flutter::EncodableMap>(it);
        auto collection = getCollection(&collectionMap);
        collections.emplace_back(collection);
      }
    }
  }

  auto& instance = v2::V2NIMClient::get();
  auto& messageService = instance.getMessageService();
  messageService.removeCollections(
      collections,
      [result](uint32_t count) {
        result->Success(
            NimResult::getSuccessResult(static_cast<int64_t>(count)));
      },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void FLTMessageService::updateCollectionExtension(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  v2::V2NIMCollection collection;
  nstd::optional<nstd::string> serverExtension;

  auto iter = arguments->begin();
  for (; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("collection")) {
      auto paramsMap = std::get<flutter::EncodableMap>(iter->second);
      collection = getCollection(&paramsMap);
    } else if (iter->first == flutter::EncodableValue("serverExtension")) {
      serverExtension = std::get<std::string>(iter->second);
    }
  }

  auto& instance = v2::V2NIMClient::get();
  auto& messageService = instance.getMessageService();
  messageService.updateCollectionExtension(
      collection, serverExtension,
      [result](v2::V2NIMCollection collection) {
        flutter::EncodableMap resultMap = convertCollection(collection);
        result->Success(NimResult::getSuccessResult(resultMap));
      },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void FLTMessageService::getCollectionListByOption(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  v2::V2NIMCollectionOption option;

  auto iter = arguments->begin();
  for (; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("option")) {
      auto paramsMap = std::get<flutter::EncodableMap>(iter->second);
      option = getCollectionOption(&paramsMap);
    }
  }

  auto& instance = v2::V2NIMClient::get();
  auto& messageService = instance.getMessageService();
  messageService.getCollectionListByOption(
      option,
      [result](nstd::vector<v2::V2NIMCollection> collections) {
        flutter::EncodableList collectionsList;
        for (auto collection : collections) {
          collectionsList.emplace_back(convertCollection(collection));
        }
        flutter::EncodableMap resultMap;
        resultMap.insert(std::make_pair("collections", collectionsList));
        result->Success(NimResult::getSuccessResult(resultMap));
      },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void FLTMessageService::sendP2PMessageReceipt(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  v2::V2NIMMessage message;

  auto iter = arguments->begin();
  for (; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("message")) {
      auto paramsMap = std::get<flutter::EncodableMap>(iter->second);
      message = getMessage(&paramsMap);
    }
  }

  auto& instance = v2::V2NIMClient::get();
  auto& messageService = instance.getMessageService();
  messageService.sendP2PMessageReceipt(
      message, [result]() { result->Success(NimResult::getSuccessResult()); },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void FLTMessageService::getP2PMessageReceipt(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  nstd::string conversationId;

  auto iter = arguments->begin();
  for (; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("conversationId")) {
      conversationId = std::get<std::string>(iter->second);
    }
  }

  auto& instance = v2::V2NIMClient::get();
  auto& messageService = instance.getMessageService();
  messageService.getP2PMessageReceipt(
      conversationId,
      [result](v2::V2NIMP2PMessageReadReceipt readReceipt) {
        flutter::EncodableMap resultMap =
            convertP2PMessageReadReceipt(readReceipt);
        result->Success(NimResult::getSuccessResult(resultMap));
      },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void FLTMessageService::isPeerRead(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  v2::V2NIMMessage message;

  auto iter = arguments->begin();
  for (; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("message")) {
      auto paramsMap = std::get<flutter::EncodableMap>(iter->second);
      message = getMessage(&paramsMap);
    }
  }

  auto& instance = v2::V2NIMClient::get();
  auto& messageService = instance.getMessageService();
  auto isPeerRead = messageService.isPeerRead(message);

  result->Success(NimResult::getSuccessResult(isPeerRead));
}

void FLTMessageService::sendTeamMessageReceipts(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  std::vector<v2::V2NIMMessage> messages;

  auto iter = arguments->begin();
  for (; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("messages")) {
      auto messagesList = std::get<flutter::EncodableList>(iter->second);
      for (auto& it : messagesList) {
        auto messageMap = std::get<flutter::EncodableMap>(it);
        auto message = getMessage(&messageMap);
        messages.emplace_back(message);
      }
    }
  }

  auto& instance = v2::V2NIMClient::get();
  auto& messageService = instance.getMessageService();
  messageService.sendTeamMessageReceipts(
      messages, [result]() { result->Success(NimResult::getSuccessResult()); },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void FLTMessageService::getTeamMessageReceipts(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  std::vector<v2::V2NIMMessage> messages;

  auto iter = arguments->begin();
  for (; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("messages")) {
      auto messagesList = std::get<flutter::EncodableList>(iter->second);
      for (auto& it : messagesList) {
        auto messageMap = std::get<flutter::EncodableMap>(it);
        auto message = getMessage(&messageMap);
        messages.emplace_back(message);
      }
    }
  }

  auto& instance = v2::V2NIMClient::get();
  auto& messageService = instance.getMessageService();
  messageService.getTeamMessageReceipts(
      messages,
      [result](nstd::vector<v2::V2NIMTeamMessageReadReceipt> readReceipts) {
        flutter::EncodableList readReceiptsList;
        for (auto readReceipt : readReceipts) {
          readReceiptsList.emplace_back(
              convertTeamMessageReadReceipt(readReceipt));
        }
        flutter::EncodableMap resultMap;
        resultMap.insert(std::make_pair("readReceipts", readReceiptsList));
        result->Success(NimResult::getSuccessResult(resultMap));
      },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void FLTMessageService::getTeamMessageReceiptDetail(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  v2::V2NIMMessage message;
  nstd::set<nstd::string> memberAccountIds;

  auto iter = arguments->begin();
  for (; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("message")) {
      auto paramsMap = std::get<flutter::EncodableMap>(iter->second);
      message = getMessage(&paramsMap);
    } else if (iter->first == flutter::EncodableValue("memberAccountIds")) {
      auto memberAccountIdList = std::get<flutter::EncodableList>(iter->second);
      for (auto& it : memberAccountIdList) {
        auto memberAccountId = std::get<std::string>(it);
        memberAccountIds.emplace(memberAccountId);
      }
    }
  }

  auto& instance = v2::V2NIMClient::get();
  auto& messageService = instance.getMessageService();
  messageService.getTeamMessageReceiptDetail(
      message, memberAccountIds,
      [result](v2::V2NIMTeamMessageReadReceiptDetail readReceiptDetail) {
        flutter::EncodableMap resultMap =
            convertTeamMessageReadReceiptDetail(readReceiptDetail);
        result->Success(NimResult::getSuccessResult(resultMap));
      },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void FLTMessageService::voiceToText(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  v2::V2NIMVoiceToTextParams params;

  auto iter = arguments->begin();
  for (; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("params")) {
      auto paramsMap = std::get<flutter::EncodableMap>(iter->second);
      params = getVoiceToTextParams(&paramsMap);
    }
  }

  auto& instance = v2::V2NIMClient::get();
  auto& messageService = instance.getMessageService();
  messageService.voiceToText(
      params,
      [result](nstd::string text) {
        //        flutter::EncodableMap resultMap;
        //        resultMap.insert(std::make_pair("result", text));
        std::string resultStr = text;
        result->Success(NimResult::getSuccessResult(resultStr));
      },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void FLTMessageService::cancelMessageAttachmentUpload(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  v2::V2NIMMessage message;

  auto iter = arguments->begin();
  for (; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("message")) {
      auto paramsMap = std::get<flutter::EncodableMap>(iter->second);
      message = getMessage(&paramsMap);
    }
  }

  auto& instance = v2::V2NIMClient::get();
  auto& messageService = instance.getMessageService();
  messageService.cancelMessageAttachmentUpload(
      message, [result]() { result->Success(NimResult::getSuccessResult()); },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void FLTMessageService::searchCloudMessages(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  v2::V2NIMMessageSearchParams params;

  auto iter = arguments->begin();
  for (; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("params")) {
      auto paramsMap = std::get<flutter::EncodableMap>(iter->second);
      params = getMessageSearchParams(&paramsMap);
    }
  }

  auto& instance = v2::V2NIMClient::get();
  auto& messageService = instance.getMessageService();
  messageService.searchCloudMessages(
      params,
      [result](nstd::vector<v2::V2NIMMessage> messages) {
        flutter::EncodableList messagesList;
        for (auto message : messages) {
          messagesList.emplace_back(convertMessage(&message));
        }
        flutter::EncodableMap resultMap;
        resultMap.insert(std::make_pair("messages", messagesList));
        result->Success(NimResult::getSuccessResult(resultMap));
      },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void FLTMessageService::getLocalThreadMessageList(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  v2::V2NIMMessageRefer messageRefer;

  auto iter = arguments->begin();
  for (; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("messageRefer")) {
      auto paramsMap = std::get<flutter::EncodableMap>(iter->second);
      messageRefer = getMessageRefer(&paramsMap);
    }
  }

  auto& instance = v2::V2NIMClient::get();
  auto& messageService = instance.getMessageService();
  messageService.getLocalThreadMessageList(
      messageRefer,
      [result](v2::V2NIMThreadMessageListResult messageListresult) {
        flutter::EncodableMap resultMap;
        resultMap.insert(std::make_pair(
            "result", convertThreadMessageListResult(messageListresult)));
        result->Success(NimResult::getSuccessResult(resultMap));
      },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void FLTMessageService::getThreadMessageList(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  v2::V2NIMThreadMessageListOption option;

  auto iter = arguments->begin();
  for (; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("option")) {
      auto paramsMap = std::get<flutter::EncodableMap>(iter->second);
      option = getThreadMessageListOption(&paramsMap);
    }
  }

  auto& instance = v2::V2NIMClient::get();
  auto& messageService = instance.getMessageService();
  messageService.getThreadMessageList(
      option,
      [result](v2::V2NIMThreadMessageListResult messageListResult) {
        flutter::EncodableMap resultMap;
        resultMap.insert(std::make_pair(
            "result", convertThreadMessageListResult(messageListResult)));
        result->Success(NimResult::getSuccessResult(resultMap));
      },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void FLTMessageService::searchCloudMessagesEx(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  v2::V2NIMMessageSearchExParams params;

  auto iter = arguments->begin();
  for (; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("params")) {
      auto paramsMap = std::get<flutter::EncodableMap>(iter->second);
      params = getMessageSearchExParams(&paramsMap);
    }
  }

  auto& instance = v2::V2NIMClient::get();
  auto& messageService = instance.getMessageService();
  messageService.searchCloudMessagesEx(
      params,
      [result](v2::V2NIMMessageSearchResult searchResult) {
        result->Success(NimResult::getSuccessResult(
            convertMessageSearchResult(searchResult)));
      },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void FLTMessageService::getMessageListEx(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  v2::V2NIMMessageListOption option;

  auto iter = arguments->begin();
  for (; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("option")) {
      auto paramsMap = std::get<flutter::EncodableMap>(iter->second);
      option = getMessageListOption(&paramsMap);
    }
  }

  auto& instance = v2::V2NIMClient::get();
  auto& messageService = instance.getMessageService();
  messageService.getMessageListEx(
      option,
      [result](v2::V2NIMMessageListResult listResult) {
        flutter::EncodableList messagesList;
        for (auto message : listResult.messages) {
          messagesList.emplace_back(convertMessage(&message));
        }
        flutter::EncodableMap resultMap;
        resultMap.insert(std::make_pair("messages", messagesList));
        if (listResult.anchorMessage.has_value()) {
          resultMap.insert(std::make_pair(
              "anchorMessage",
              convertMessage(&listResult.anchorMessage.value())));
        }
        result->Success(NimResult::getSuccessResult(resultMap));
      },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void FLTMessageService::searchLocalMessages(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  v2::V2NIMMessageSearchExParams params;

  auto iter = arguments->begin();
  for (; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("params")) {
      auto paramsMap = std::get<flutter::EncodableMap>(iter->second);
      params = getMessageSearchExParams(&paramsMap);
    }
  }

  auto& instance = v2::V2NIMClient::get();
  auto& messageService = instance.getMessageService();
  messageService.searchLocalMessages(
      params,
      [result](v2::V2NIMMessageSearchResult searchResult) {
        result->Success(NimResult::getSuccessResult(
            convertMessageSearchResult(searchResult)));
      },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void FLTMessageService::updateLocalMessage(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  v2::V2NIMMessage message;
  v2::V2NIMUpdateLocalMessageParams params;

  auto iter = arguments->begin();
  for (; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("message")) {
      auto messageMap = std::get<flutter::EncodableMap>(iter->second);
      message = getMessage(&messageMap);
    } else if (iter->first == flutter::EncodableValue("params")) {
      auto paramsMap = std::get<flutter::EncodableMap>(iter->second);
      params = getUpdateLocalMessageParams(&paramsMap);
    }
  }

  auto& instance = v2::V2NIMClient::get();
  auto& messageService = instance.getMessageService();
  messageService.updateLocalMessage(
      message, params,
      [result](v2::V2NIMMessage updatedMessage) {
        flutter::EncodableMap resultMap = convertMessage(&updatedMessage);
        result->Success(NimResult::getSuccessResult(resultMap));
      },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void FLTMessageService::getCollectionListExByOption(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  v2::V2NIMCollectionOption option;

  auto iter = arguments->begin();
  for (; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("option")) {
      auto optionMap = std::get<flutter::EncodableMap>(iter->second);
      option = getCollectionOption(&optionMap);
    }
  }

  auto& instance = v2::V2NIMClient::get();
  auto& messageService = instance.getMessageService();
  messageService.getCollectionListExByOption(
      option,
      [result](v2::V2NIMCollectionListResult listResult) {
        flutter::EncodableMap resultMap;
        flutter::EncodableList collectionsList;
        for (auto collection : listResult.collectionList) {
          collectionsList.emplace_back(convertCollection(&collection));
        }
        resultMap.insert(std::make_pair("collectionList", collectionsList));
        resultMap.insert(std::make_pair(
            "totalCount", static_cast<int32_t>(listResult.totalCount)));
        result->Success(NimResult::getSuccessResult(resultMap));
      },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void FLTMessageService::messageSerialization(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  v2::V2NIMMessage message;

  auto iter = arguments->begin();
  for (; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("message")) {
      auto messageMap = std::get<flutter::EncodableMap>(iter->second);
      message = getMessage(&messageMap);
    }
  }

  auto text = v2::V2NIMMessageConverter::messageSerialization(message);
  if (!text) {
    result->Error("", "messageSerialization failed",
                  NimResult::getErrorResult(MESSAGE_SERIALIZATION_ERROR,
                                            "messageSerialization failed"));
    return;
  }

  if (text.has_value()) {
    result->Success(NimResult::getSuccessResult(std::string(text.value())));
  } else {
    result->Error("", "messageSerialization empty",
                  NimResult::getErrorResult(MESSAGE_SERIALIZATION_ERROR,
                                            "messageSerialization empty"));
  }
}

void FLTMessageService::messageDeserialization(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  std::string msg;

  auto iter = arguments->begin();
  for (; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("msg")) {
      msg = std::get<std::string>(iter->second);
    }
  }

  nstd::optional<v2::V2NIMMessage> message;
  try {
    message = v2::V2NIMMessageConverter::messageDeserialization(msg);
  } catch (const std::exception& e) {
    result->Error("", e.what(),
                  NimResult::getErrorResult(MESSAGE_SERIALIZATION_ERROR,
                                            "messageDeserialization failed"));
    return;
  } catch (...) {
    result->Error("", "messageDeserialization unknown exception",
                  NimResult::getErrorResult(MESSAGE_SERIALIZATION_ERROR,
                                            "messageDeserialization failed"));
    return;
  }
  if (!message) {
    result->Error("", "messageDeserialization failed",
                  NimResult::getErrorResult(MESSAGE_SERIALIZATION_ERROR,
                                            "messageDeserialization failed"));
    return;
  }
  flutter::EncodableMap messageMap;
  messageMap = convertMessage(message);
  result->Success(NimResult::getSuccessResult(messageMap));
}

void FLTMessageService::setMessageFilter(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  bool filter;

  auto iter = arguments->begin();
  for (; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("filter")) {
      filter = std::get<bool>(iter->second);
    }
  }
  auto& instance = v2::V2NIMClient::get();
  auto& messageService = instance.getMessageService();

  if (filter == true) {
    messageService.setMessageFilter(FLTMessageService::messageFilter);
  } else {
    messageService.setMessageFilter(nstd::nullopt);
  }

  result->Success(NimResult::getSuccessResult());
}

void FLTMessageService::modifyMessage(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  v2::V2NIMMessage message;

  v2::V2NIMModifyMessageParams params;

  auto iter = arguments->begin();
  for (; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("message")) {
      auto paramsMap = std::get<flutter::EncodableMap>(iter->second);
      message = getMessage(&paramsMap);
    }

    if (iter->first == flutter::EncodableValue("params")) {
      auto paramsMap = std::get<flutter::EncodableMap>(iter->second);
      params = getModifyMessageParams(&paramsMap);
    }
  }

  auto& instance = v2::V2NIMClient::get();
  auto& messageService = instance.getMessageService();
  messageService.modifyMessage(
      message, params,
      [result](v2::V2NIMModifyMessageResult messageResult) {
        flutter::EncodableMap resultMap =
            convertModifyMessageResult(&messageResult);
        result->Success(NimResult::getSuccessResult(resultMap));
      },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void FLTMessageService::regenAIMessage(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  v2::V2NIMMessage message;
  v2::V2NIMMessageAIRegenParams params;

  auto iter = arguments->begin();
  for (; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("message")) {
      auto paramsMap = std::get<flutter::EncodableMap>(iter->second);
      message = getMessage(&paramsMap);
    }

    if (iter->first == flutter::EncodableValue("params")) {
      auto paramsMap = std::get<flutter::EncodableMap>(iter->second);
      params = getMessageAIRegenParams(&paramsMap);
    }
  }

  auto& instance = v2::V2NIMClient::get();
  auto& messageService = instance.getMessageService();
  messageService.regenAIMessage(
      message, params,
      [result]() { result->Success(NimResult::getSuccessResult()); },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void FLTMessageService::clearRoamingMessage(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  std::vector<nstd::string> conversationIds;

  auto iter = arguments->begin();
  for (; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("conversationIds")) {
      auto idList = std::get<flutter::EncodableList>(iter->second);
      for (auto& it : idList) {
        auto cId = std::get<std::string>(it);
        conversationIds.emplace_back(cId);
      }
    }
  }
  auto& instance = v2::V2NIMClient::get();
  auto& messageService = instance.getMessageService();
  messageService.clearRoamingMessage(
      conversationIds,
      [result]() { result->Success(NimResult::getSuccessResult()); },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

flutter::EncodableMap convertMessageRefer(
    const nstd::optional<v2::V2NIMMessageRefer> object) {
  flutter::EncodableMap resultMap;
  resultMap.insert(std::make_pair("senderId", object->senderId));
  resultMap.insert(std::make_pair("receiverId", object->receiverId));
  resultMap.insert(std::make_pair("messageClientId", object->messageClientId));
  resultMap.insert(std::make_pair("messageServerId", object->messageServerId));
  resultMap.insert(
      std::make_pair("conversationType", object->conversationType));
  resultMap.insert(std::make_pair("conversationId", object->conversationId));
  resultMap.insert(
      std::make_pair("createTime", static_cast<int64_t>(object->createTime)));
  return resultMap;
}

flutter::EncodableMap convertModifyMessageResult(
    const v2::V2NIMModifyMessageResult* object) {
  flutter::EncodableMap resultMap;
  resultMap.insert(std::make_pair("message", convertMessage(&object->message)));
  resultMap.insert(
      std::make_pair("errorCode", static_cast<int64_t>(object->errorCode)));
  resultMap.insert(std::make_pair("antispamResult", object->antispamResult));
  resultMap.insert(std::make_pair(
      "clientAntispamResult",
      convertClientAntispamResult(object->clientAntispamResult)));
  return resultMap;
}

flutter::EncodableMap convertMessage(
    const nstd::optional<v2::V2NIMMessage> object) {
  flutter::EncodableMap resultMap;
  resultMap.insert(std::make_pair("messageClientId", object->messageClientId));
  resultMap.insert(std::make_pair("messageServerId", object->messageServerId));
  resultMap.insert(
      std::make_pair("createTime", static_cast<int64_t>(object->createTime)));
  resultMap.insert(std::make_pair("senderId", object->senderId));
  resultMap.insert(std::make_pair("senderName", object->senderName));
  resultMap.insert(
      std::make_pair("conversationType", object->conversationType));
  resultMap.insert(std::make_pair("conversationId", object->conversationId));
  resultMap.insert(std::make_pair("receiverId", object->receiverId));

  resultMap.insert(std::make_pair("isSelf", object->isSelf));
  if (object->attachmentUploadState.has_value()) {
    resultMap.insert(std::make_pair("attachmentUploadState",
                                    object->attachmentUploadState.value()));
  }
  if (object->sendingState.has_value()) {
    resultMap.insert(
        std::make_pair("sendingState", object->sendingState.value()));
  }
  resultMap.insert(std::make_pair("messageType", object->messageType));
  resultMap.insert(
      std::make_pair("subType", static_cast<int32_t>(object->subType)));
  resultMap.insert(std::make_pair("messageSource",
                                  static_cast<int32_t>(object->messageSource)));
  resultMap.insert(std::make_pair("text", object->text));

  flutter::EncodableMap attachment =
      convertMessageAttachment(object->attachment);
  resultMap.insert(std::make_pair("attachment", attachment));

  if (object->serverExtension.has_value()) {
    resultMap.insert(
        std::make_pair("serverExtension", object->serverExtension.value()));
  }
  if (object->localExtension.has_value()) {
    resultMap.insert(
        std::make_pair("localExtension", object->localExtension.value()));
  }
  if (object->callbackExtension.has_value()) {
    resultMap.insert(
        std::make_pair("callbackExtension", object->callbackExtension.value()));
  }

  flutter::EncodableMap messageConfig =
      convertMessageConfig(object->messageConfig);
  resultMap.insert(std::make_pair("messageConfig", messageConfig));

  flutter::EncodableMap pushConfig =
      convertMessagePushConfig(object->pushConfig);
  resultMap.insert(std::make_pair("pushConfig", pushConfig));

  flutter::EncodableMap routeConfig =
      convertMessageRouteConfig(object->routeConfig);
  resultMap.insert(std::make_pair("routeConfig", routeConfig));

  flutter::EncodableMap antispamConfig =
      convertMessageAntispamConfig(object->antispamConfig);
  resultMap.insert(std::make_pair("antispamConfig", antispamConfig));

  flutter::EncodableMap robotConfig =
      convertMessageRobotConfig(object->robotConfig);
  resultMap.insert(std::make_pair("robotConfig", robotConfig));

  if (object->threadRoot.has_value()) {
    flutter::EncodableMap threadRoot =
        convertMessageRefer(object->threadRoot.value());
    resultMap.insert(std::make_pair("threadRoot", threadRoot));
  }

  if (object->threadReply.has_value()) {
    flutter::EncodableMap threadReply =
        convertMessageRefer(object->threadReply.value());
    resultMap.insert(std::make_pair("threadReply", threadReply));
  }

  if (object->topicRefer.has_value()) {
    flutter::EncodableMap topicRefer =
        convertTopicRefer(object->topicRefer.value());
    resultMap.insert(std::make_pair("topicRefer", topicRefer));
  }

  if (object->aiConfig.has_value()) {
    flutter::EncodableMap aiConfig =
        convertMessageAIConfig(object->aiConfig.value());
    resultMap.insert(std::make_pair("aiConfig", aiConfig));
  }

  if (object->streamConfig.has_value()) {
    flutter::EncodableMap streamConfig =
        convertMessageStreamConfig(object->streamConfig.value());
    resultMap.insert(std::make_pair("streamConfig", streamConfig));
  }

  if (object->modifyTime.has_value()) {
    resultMap.insert(std::make_pair(
        "modifyTime", static_cast<int64_t>(object->modifyTime.value())));
  }

  if (object->modifyAccountId.has_value()) {
    resultMap.insert(
        std::make_pair("modifyAccountId", object->modifyAccountId.value()));
  }

  flutter::EncodableMap messageStatus =
      convertMessageStatus(object->messageStatus);
  resultMap.insert(std::make_pair("messageStatus", messageStatus));
  return resultMap;
}

flutter::EncodableMap convertMessageStatus(
    const v2::V2NIMMessageStatus object) {
  flutter::EncodableMap resultMap;
  resultMap.insert(std::make_pair("errorCode", object.errorCode));
  resultMap.insert(std::make_pair("readReceiptSent", object.readReceiptSent));
  return resultMap;
}

flutter::EncodableMap convertMessageAIConfig(
    const nstd::optional<v2::V2NIMMessageAIConfig> object) {
  flutter::EncodableMap resultMap;
  resultMap.insert(std::make_pair("accountId", object->accountId));
  resultMap.insert(std::make_pair("aiStatus", object->aiStatus));
  resultMap.insert(std::make_pair("aiStream", object->aiStream));
  resultMap.insert(std::make_pair("aiStreamStatus", object->aiStreamStatus));
  if (object->aiRAGs.has_value()) {
    flutter::EncodableList aiRAGsList;
    for (auto aiRAG : object->aiRAGs.value()) {
      aiRAGsList.emplace_back(convertAIRAGInfo(aiRAG));
    }
    resultMap.insert(std::make_pair("aiRAGs", aiRAGsList));
  }
  if (object->aiStreamLastChunk.has_value()) {
    resultMap.insert(std::make_pair(
        "aiStreamLastChunk",
        convertMessageAIStreamChunk(object->aiStreamLastChunk.value())));
  }
  return resultMap;
}

flutter::EncodableMap convertAIRAGInfo(const v2::V2NIMAIRAGInfo object) {
  flutter::EncodableMap resultMap;
  resultMap.insert(std::make_pair("name", object.name));
  resultMap.insert(std::make_pair("description", object.description));
  resultMap.insert(std::make_pair("icon", object.icon));
  resultMap.insert(std::make_pair("url", object.url));
  resultMap.insert(std::make_pair("title", object.title));
  resultMap.insert(std::make_pair("time", static_cast<int64_t>(object.time)));
  return resultMap;
}

flutter::EncodableMap convertMessageAIStreamChunk(
    const v2::V2NIMMessageAIStreamChunk object) {
  flutter::EncodableMap resultMap;
  resultMap.insert(std::make_pair("content", object.content));
  resultMap.insert(
      std::make_pair("messageTime", static_cast<int64_t>(object.messageTime)));
  resultMap.insert(
      std::make_pair("chunkTime", static_cast<int64_t>(object.chunkTime)));
  resultMap.insert(std::make_pair("type", object.type));
  resultMap.insert(std::make_pair("index", static_cast<int64_t>(object.index)));
  return resultMap;
}

flutter::EncodableMap convertMessageStreamChunk(
    const v2::V2NIMMessageStreamChunk object) {
  flutter::EncodableMap resultMap;
  resultMap.insert(std::make_pair("content", object.content));
  resultMap.insert(
      std::make_pair("messageTime", static_cast<int64_t>(object.messageTime)));
  resultMap.insert(
      std::make_pair("chunkTime", static_cast<int64_t>(object.chunkTime)));
  resultMap.insert(std::make_pair("type", object.type));
  resultMap.insert(std::make_pair("index", static_cast<int64_t>(object.index)));
  return resultMap;
}

flutter::EncodableMap convertMessageStreamConfig(
    const v2::V2NIMMessageStreamConfig object) {
  flutter::EncodableMap resultMap;
  resultMap.insert(std::make_pair("status", object.status));
  if (object.rags.has_value()) {
    flutter::EncodableList ragsList;
    for (auto rag : object.rags.value()) {
      ragsList.emplace_back(convertAIRAGInfo(rag));
    }
    resultMap.insert(std::make_pair("rags", ragsList));
  }
  if (object.lastChunk.has_value()) {
    resultMap.insert(std::make_pair(
        "lastChunk", convertMessageStreamChunk(object.lastChunk.value())));
  }
  return resultMap;
}

flutter::EncodableMap convertMessageRobotConfig(
    const v2::V2NIMMessageRobotConfig object) {
  flutter::EncodableMap resultMap;
  if (object.accountId.has_value()) {
    resultMap.insert(std::make_pair("accountId", object.accountId.value()));
  }
  if (object.topic.has_value()) {
    resultMap.insert(std::make_pair("topic", object.topic.value()));
  }
  if (object.function.has_value()) {
    resultMap.insert(std::make_pair("function", object.function.value()));
  }
  if (object.customContent.has_value()) {
    resultMap.insert(
        std::make_pair("customContent", object.customContent.value()));
  }
  return resultMap;
}

flutter::EncodableMap convertMessageAntispamConfig(
    const v2::V2NIMMessageAntispamConfig object) {
  flutter::EncodableMap resultMap;
  resultMap.insert(std::make_pair("antispamEnabled", object.antispamEnabled));
  if (object.antispamBusinessId.has_value()) {
    resultMap.insert(std::make_pair("antispamBusinessId",
                                    object.antispamBusinessId.value()));
  }
  if (object.antispamCustomMessage.has_value()) {
    resultMap.insert(std::make_pair("antispamCustomMessage",
                                    object.antispamCustomMessage.value()));
  }
  if (object.antispamCheating.has_value()) {
    resultMap.insert(
        std::make_pair("antispamCheating", object.antispamCheating.value()));
  }
  if (object.antispamExtension.has_value()) {
    resultMap.insert(
        std::make_pair("antispamExtension", object.antispamExtension.value()));
  }
  return resultMap;
}

flutter::EncodableMap convertMessageRouteConfig(
    const v2::V2NIMMessageRouteConfig object) {
  flutter::EncodableMap resultMap;
  resultMap.insert(std::make_pair("routeEnabled", object.routeEnabled));
  if (object.routeEnvironment.has_value()) {
    resultMap.insert(
        std::make_pair("routeEnvironment", object.routeEnvironment.value()));
  }
  return resultMap;
}

flutter::EncodableMap convertMessagePushConfig(
    const v2::V2NIMMessagePushConfig object) {
  flutter::EncodableMap resultMap;
  resultMap.insert(std::make_pair("pushEnabled", object.pushEnabled));
  resultMap.insert(std::make_pair("pushNickEnabled", object.pushNickEnabled));
  resultMap.insert(std::make_pair("pushContent", object.pushContent));
  resultMap.insert(std::make_pair("pushPayload", object.pushPayload));
  resultMap.insert(std::make_pair("forcePush", object.forcePush));
  resultMap.insert(std::make_pair("forcePushContent", object.forcePushContent));

  flutter::EncodableList forcePushAccountIds;
  for (auto forcePushAccountId : object.forcePushAccountIds) {
    forcePushAccountIds.emplace_back(forcePushAccountId);
  }
  resultMap.insert(std::make_pair("forcePushAccountIds", forcePushAccountIds));
  return resultMap;
}

flutter::EncodableMap convertMessageConfig(
    const v2::V2NIMMessageConfig object) {
  flutter::EncodableMap resultMap;
  resultMap.insert(
      std::make_pair("readReceiptEnabled", object.readReceiptEnabled));
  resultMap.insert(std::make_pair("lastMessageUpdateEnabled",
                                  object.lastMessageUpdateEnabled));
  resultMap.insert(std::make_pair("historyEnabled", object.historyEnabled));
  resultMap.insert(std::make_pair("roamingEnabled", object.roamingEnabled));
  resultMap.insert(
      std::make_pair("onlineSyncEnabled", object.onlineSyncEnabled));
  resultMap.insert(std::make_pair("offlineEnabled", object.offlineEnabled));
  resultMap.insert(std::make_pair("unreadEnabled", object.unreadEnabled));
  return resultMap;
}

flutter::EncodableMap convertMessageAttachment(
    const nstd::shared_ptr<v2::V2NIMMessageAttachment> object) {
  flutter::EncodableMap resultMap;
  if (object && object->attachmentType) {
    switch (object->attachmentType) {
      case v2::V2NIM_MESSAGE_ATTACHMENT_TYPE_FILE: {
        auto fileAttachment =
            nstd::dynamic_pointer_cast<v2::V2NIMMessageFileAttachment>(object);
        if (fileAttachment) {
          return convertMessageFileAttachment(fileAttachment);
        }
        break;
      }
      case v2::V2NIM_MESSAGE_ATTACHMENT_TYPE_IMAGE: {
        auto imageAttachment =
            nstd::dynamic_pointer_cast<v2::V2NIMMessageImageAttachment>(object);
        if (imageAttachment) {
          return convertMessageImageAttachment(imageAttachment);
        }
        break;
      }
      case v2::V2NIM_MESSAGE_ATTACHMENT_TYPE_AUDIO: {
        auto audioAttachment =
            nstd::dynamic_pointer_cast<v2::V2NIMMessageAudioAttachment>(object);
        if (audioAttachment) {
          return convertMessageAudioAttachment(audioAttachment);
        }
        break;
      }
      case v2::V2NIM_MESSAGE_ATTACHMENT_TYPE_VIDEO: {
        auto videoAttachment =
            nstd::dynamic_pointer_cast<v2::V2NIMMessageVideoAttachment>(object);
        if (videoAttachment) {
          return convertMessageVideoAttachment(videoAttachment);
        }
        break;
      }
      case v2::V2NIM_MESSAGE_ATTACHMENT_TYPE_CALL: {
        auto callAttachment =
            nstd::dynamic_pointer_cast<v2::V2NIMMessageCallAttachment>(object);
        if (callAttachment) {
          return convertMessageCallAttachment(callAttachment);
        }
        break;
      }
      case v2::V2NIM_MESSAGE_ATTACHMENT_TYPE_LOCATION: {
        auto locationAttachment =
            nstd::dynamic_pointer_cast<v2::V2NIMMessageLocationAttachment>(
                object);
        if (locationAttachment) {
          return convertMessageLocationAttachment(locationAttachment);
        }
        break;
      }
      case v2::V2NIM_MESSAGE_ATTACHMENT_TYPE_TEAM_NOTIFICATION: {
        auto notificationAttachment = nstd::dynamic_pointer_cast<
            v2::V2NIMMessageTeamNotificationAttachment>(object);
        if (notificationAttachment) {
          return convertMessageNotificationAttachment(notificationAttachment);
        }
        break;
      }
      case v2::V2NIM_MESSAGE_ATTACHMENT_TYPE_CHATROOM_NOTIFICATION: {
        auto notificationAttachment =
            nstd::dynamic_pointer_cast<v2::V2NIMChatroomNotificationAttachment>(
                object);
        if (notificationAttachment) {
          return convertChatroomNotificationAttachment(notificationAttachment);
        }
        break;
      }
      case v2::
          V2NIM_MESSAGE_ATTACHMENT_TYPE_CHATROOM_MESSAGE_REVOKE_NOTIFICATION: {
        auto notificationAttachment = nstd::dynamic_pointer_cast<
            v2::V2NIMChatroomMessageRevokeNotificationAttachment>(object);
        if (notificationAttachment) {
          return convertChatroomMessageRevokeNotificationAttachment(
              notificationAttachment);
        }
        break;
      }
      case v2::V2NIM_MESSAGE_ATTACHMENT_TYPE_CHATROOM_QUEUE_NOTIFICATION: {
        auto notificationAttachment = nstd::dynamic_pointer_cast<
            v2::V2NIMChatroomQueueNotificationAttachment>(object);
        if (notificationAttachment) {
          return convertChatroomQueueNotificationAttachment(
              notificationAttachment);
        }
        break;
      }
      case v2::
          V2NIM_MESSAGE_ATTACHMENT_TYPE_CHATROOM_CHAT_BANNED_NOTIFICATION: {
        auto notificationAttachment = nstd::dynamic_pointer_cast<
            v2::V2NIMChatroomChatBannedNotificationAttachment>(object);
        if (notificationAttachment) {
          return convertChatroomChatBannedNotificationAttachment(
              notificationAttachment);
        }
        break;
      }
      case v2::
          V2NIM_MESSAGE_ATTACHMENT_TYPE_CHATROOM_MEMBER_ENTER_NOTIFICATION: {
        auto notificationAttachment = nstd::dynamic_pointer_cast<
            v2::V2NIMChatroomMemberEnterNotificationAttachment>(object);
        if (notificationAttachment) {
          return convertChatroomMemberEnterNotificationAttachment(
              notificationAttachment);
        }
        break;
      }
      case v2::
          V2NIM_MESSAGE_ATTACHMENT_TYPE_CHATROOM_MEMBER_ROLE_UPDATE_NOTIFICATION: {
        auto notificationAttachment = nstd::dynamic_pointer_cast<
            v2::V2NIMChatroomMemberRoleUpdateAttachment>(object);
        if (notificationAttachment) {
          return convertChatroomMemberRoleUpdateAttachment(
              notificationAttachment);
        }
        break;
      }
      default:
        break;
    }
  }

  if (object == nullptr) {
    resultMap.insert(std::make_pair("raw", ""));
  } else {
    resultMap.insert(std::make_pair("raw", object->raw));
  }
  return resultMap;
}

flutter::EncodableMap convertMessageFileAttachment(
    const nstd::shared_ptr<v2::V2NIMMessageFileAttachment> object) {
  flutter::EncodableMap resultMap;
  resultMap.insert(std::make_pair("raw", object->raw));
  resultMap.insert(
      std::make_pair("nimCoreMessageType", v2::V2NIM_MESSAGE_TYPE_FILE));
  resultMap.insert(std::make_pair("path", object->path));
  resultMap.insert(std::make_pair("size", static_cast<int64_t>(object->size)));
  resultMap.insert(std::make_pair("md5", object->md5));
  resultMap.insert(std::make_pair("url", object->url));
  resultMap.insert(std::make_pair("ext", object->ext));
  resultMap.insert(std::make_pair("name", object->name));
  resultMap.insert(std::make_pair("sceneName", object->sceneName));
  resultMap.insert(std::make_pair("uploadState", object->uploadState));
  return resultMap;
}

flutter::EncodableMap convertMessageImageAttachment(
    const nstd::shared_ptr<v2::V2NIMMessageImageAttachment> object) {
  flutter::EncodableMap resultMap;
  resultMap.insert(std::make_pair("raw", object->raw));
  resultMap.insert(
      std::make_pair("nimCoreMessageType", v2::V2NIM_MESSAGE_TYPE_IMAGE));
  resultMap.insert(std::make_pair("path", object->path));
  resultMap.insert(std::make_pair("size", static_cast<int64_t>(object->size)));
  resultMap.insert(std::make_pair("md5", object->md5));
  resultMap.insert(std::make_pair("url", object->url));
  resultMap.insert(std::make_pair("ext", object->ext));
  resultMap.insert(std::make_pair("name", object->name));
  resultMap.insert(std::make_pair("sceneName", object->sceneName));
  resultMap.insert(std::make_pair("uploadState", object->uploadState));
  resultMap.insert(
      std::make_pair("width", static_cast<int32_t>(object->width)));
  resultMap.insert(
      std::make_pair("height", static_cast<int32_t>(object->height)));
  return resultMap;
}

flutter::EncodableMap convertMessageAudioAttachment(
    const nstd::shared_ptr<v2::V2NIMMessageAudioAttachment> object) {
  flutter::EncodableMap resultMap;
  resultMap.insert(std::make_pair("raw", object->raw));
  resultMap.insert(
      std::make_pair("nimCoreMessageType", v2::V2NIM_MESSAGE_TYPE_AUDIO));
  resultMap.insert(std::make_pair("path", object->path));
  resultMap.insert(std::make_pair("size", static_cast<int64_t>(object->size)));
  resultMap.insert(std::make_pair("md5", object->md5));
  resultMap.insert(std::make_pair("url", object->url));
  resultMap.insert(std::make_pair("ext", object->ext));
  resultMap.insert(std::make_pair("name", object->name));
  resultMap.insert(std::make_pair("sceneName", object->sceneName));
  resultMap.insert(std::make_pair("uploadState", object->uploadState));
  resultMap.insert(
      std::make_pair("duration", static_cast<int32_t>(object->duration)));
  return resultMap;
}

flutter::EncodableMap convertMessageVideoAttachment(
    const nstd::shared_ptr<v2::V2NIMMessageVideoAttachment> object) {
  flutter::EncodableMap resultMap;
  resultMap.insert(std::make_pair("raw", object->raw));
  resultMap.insert(
      std::make_pair("nimCoreMessageType", v2::V2NIM_MESSAGE_TYPE_VIDEO));
  resultMap.insert(std::make_pair("path", object->path));
  resultMap.insert(std::make_pair("size", static_cast<int64_t>(object->size)));
  resultMap.insert(std::make_pair("md5", object->md5));
  resultMap.insert(std::make_pair("url", object->url));
  resultMap.insert(std::make_pair("ext", object->ext));
  resultMap.insert(std::make_pair("name", object->name));
  resultMap.insert(std::make_pair("sceneName", object->sceneName));
  resultMap.insert(std::make_pair("uploadState", object->uploadState));
  resultMap.insert(
      std::make_pair("duration", static_cast<int32_t>(object->duration)));
  resultMap.insert(
      std::make_pair("width", static_cast<int32_t>(object->width)));
  resultMap.insert(
      std::make_pair("height", static_cast<int32_t>(object->height)));
  return resultMap;
}

flutter::EncodableMap convertMessageLocationAttachment(
    const nstd::shared_ptr<v2::V2NIMMessageLocationAttachment> object) {
  flutter::EncodableMap resultMap;
  resultMap.insert(std::make_pair("raw", object->raw));
  resultMap.insert(
      std::make_pair("nimCoreMessageType", v2::V2NIM_MESSAGE_TYPE_LOCATION));
  resultMap.insert(std::make_pair("longitude", object->longitude));
  resultMap.insert(std::make_pair("latitude", object->latitude));
  resultMap.insert(std::make_pair("address", object->address));
  return resultMap;
}

flutter::EncodableMap convertMessageNotificationAttachment(
    const nstd::shared_ptr<v2::V2NIMMessageTeamNotificationAttachment> object) {
  flutter::EncodableMap resultMap;
  resultMap.insert(std::make_pair("raw", object->raw));
  resultMap.insert(std::make_pair("nimCoreMessageType",
                                  v2::V2NIM_MESSAGE_TYPE_NOTIFICATION));
  resultMap.insert(std::make_pair("type", object->type));
  resultMap.insert(
      std::make_pair("serverExtension", object->serverExtension.value()));

  flutter::EncodableList targetIds;
  for (auto targetId : object->targetIds) {
    targetIds.emplace_back(targetId);
  }
  resultMap.insert(std::make_pair("targetIds", targetIds));
  resultMap.insert(std::make_pair("chatBanned", object->chatBanned));

  if (object->updatedTeamInfo.has_value()) {
    flutter::EncodableMap updatedTeamInfo =
        convertUpdatedTeamInfo(object->updatedTeamInfo.value());
    resultMap.insert(std::make_pair("updatedTeamInfo", updatedTeamInfo));
  }
  return resultMap;
}

flutter::EncodableMap convertUserInfoConfig(
    const v2::V2NIMUserInfoConfig object) {
  flutter::EncodableMap resultMap;
  resultMap.insert(std::make_pair(
      "userInfoTimestamp", static_cast<int64_t>(object.userInfoTimestamp)));
  resultMap.insert(std::make_pair("senderNick", object.senderNick));
  resultMap.insert(std::make_pair("senderAvatar", object.senderAvatar));
  resultMap.insert(std::make_pair("senderExtension", object.senderExtension));
  return resultMap;
}

flutter::EncodableMap convertLocationInfo(const v2::V2NIMLocationInfo object) {
  flutter::EncodableMap resultMap;
  if (object.x.has_value()) {
    resultMap.insert(std::make_pair("x", object.x.value()));
  }

  if (object.y.has_value()) {
    resultMap.insert(std::make_pair("y", object.y.value()));
  }

  if (object.y.has_value()) {
    resultMap.insert(std::make_pair("z", object.z.value()));
  }
  return resultMap;
}

flutter::EncodableMap convertChatroomMessage(
    const nstd::optional<v2::V2NIMChatroomMessage> object) {
  flutter::EncodableMap resultMap;
  resultMap.insert(std::make_pair("messageClientId", object->messageClientId));
  resultMap.insert(
      std::make_pair("senderClientType", object->senderClientType));
  resultMap.insert(
      std::make_pair("createTime", static_cast<int64_t>(object->createTime)));
  resultMap.insert(std::make_pair("senderId", object->senderId));
  resultMap.insert(std::make_pair("roomId", object->roomId));

  resultMap.insert(std::make_pair("isSelf", object->isSelf));
  resultMap.insert(
      std::make_pair("attachmentUploadState", object->attachmentUploadState));
  resultMap.insert(std::make_pair("sendingState", object->sendingState));
  resultMap.insert(std::make_pair("messageType", object->messageType));
  resultMap.insert(
      std::make_pair("subType", static_cast<int32_t>(object->subType)));
  resultMap.insert(std::make_pair("text", object->text));

  flutter::EncodableMap attachment =
      convertMessageAttachment(object->attachment);
  resultMap.insert(std::make_pair("attachment", attachment));

  if (object->serverExtension.has_value()) {
    resultMap.insert(
        std::make_pair("serverExtension", object->serverExtension.value()));
  }
  if (object->callbackExtension.has_value()) {
    resultMap.insert(
        std::make_pair("callbackExtension", object->callbackExtension.value()));
  }

  flutter::EncodableMap routeConfig =
      convertMessageRouteConfig(object->routeConfig);
  resultMap.insert(std::make_pair("routeConfig", routeConfig));
  flutter::EncodableMap antispamConfig =
      convertMessageAntispamConfig(object->antispamConfig);
  resultMap.insert(std::make_pair("antispamConfig", antispamConfig));
  resultMap.insert(
      std::make_pair("notifyTargetTags", object->notifyTargetTags));
  flutter::EncodableMap messageConfig =
      convertChatroomMessageConfig(object->messageConfig);
  resultMap.insert(std::make_pair("messageConfig", messageConfig));

  flutter::EncodableMap userInfoConfig =
      convertUserInfoConfig(object->userInfoConfig);
  resultMap.insert(std::make_pair("userInfoConfig", userInfoConfig));

  if (object->locationInfo.has_value()) {
    flutter::EncodableMap locationInfo =
        convertLocationInfo(object->locationInfo.value());
    resultMap.insert(std::make_pair("locationInfo", locationInfo));
  }

  return resultMap;
}

flutter::EncodableMap convertSendChatroomMessageResult(
    const v2::V2NIMSendChatroomMessageResult object) {
  flutter::EncodableMap resultMap;

  flutter::EncodableMap message = convertChatroomMessage(object.message);
  resultMap.insert(std::make_pair("message", message));

  resultMap.insert(std::make_pair("antispamResult", object.antispamResult));

  if (object.clientAntispamResult.has_value()) {
    flutter::EncodableMap clientAntispamResult =
        convertClientAntispamResult(object.clientAntispamResult.value());
    resultMap.insert(
        std::make_pair("clientAntispamResult", clientAntispamResult));
  }
  return resultMap;
}

flutter::EncodableMap convertChatroomEnterInfo(
    const v2::V2NIMChatroomEnterInfo object) {
  flutter::EncodableMap resultMap;

  resultMap.insert(std::make_pair("roomNick", object.roomNick));
  resultMap.insert(std::make_pair("roomAvatar", object.roomAvatar));
  resultMap.insert(
      std::make_pair("clientType", static_cast<int64_t>(object.clientType)));
  resultMap.insert(
      std::make_pair("enterTime", static_cast<int64_t>(object.enterTime)));

  return resultMap;
}

flutter::EncodableMap convertChatroomMember(
    const nstd::optional<v2::V2NIMChatroomMember> object) {
  flutter::EncodableMap resultMap;
  resultMap.insert(std::make_pair("roomId", object->roomId));
  resultMap.insert(std::make_pair("accountId", object->accountId));
  resultMap.insert(std::make_pair("memberRole", object->memberRole));

  if (object->memberLevel.has_value()) {
    resultMap.insert(std::make_pair(
        "memberLevel", static_cast<int64_t>(object->memberLevel.value())));
  } else {
    resultMap.insert(std::make_pair("memberLevel", 0));
  }

  if (object->roomNick.has_value()) {
    resultMap.insert(std::make_pair("roomNick", object->roomNick.value()));
  }

  if (object->roomAvatar.has_value()) {
    resultMap.insert(std::make_pair("roomAvatar", object->roomAvatar.value()));
  }

  if (object->serverExtension.has_value()) {
    resultMap.insert(
        std::make_pair("serverExtension", object->serverExtension.value()));
  }

  resultMap.insert(std::make_pair("isOnline", object->isOnline));
  resultMap.insert(std::make_pair("blocked", object->blocked));
  resultMap.insert(std::make_pair("chatBanned", object->chatBanned));
  resultMap.insert(std::make_pair("tempChatBanned", object->tempChatBanned));
  resultMap.insert(
      std::make_pair("tempChatBannedDuration",
                     static_cast<int64_t>(object->tempChatBannedDuration)));

  flutter::EncodableList tags;
  for (auto tag : object->tags) {
    tags.emplace_back(tag);
  }
  resultMap.insert(std::make_pair("tags", tags));

  resultMap.insert(
      std::make_pair("notifyTargetTags", object->notifyTargetTags));
  resultMap.insert(
      std::make_pair("enterTime", static_cast<int64_t>(object->enterTime)));
  resultMap.insert(
      std::make_pair("updateTime", static_cast<int64_t>(object->updateTime)));
  resultMap.insert(std::make_pair("valid", object->valid));

  flutter::EncodableList multiEnterInfo;
  for (auto info : object->multiEnterInfo) {
    multiEnterInfo.emplace_back(convertChatroomEnterInfo(info));
  }
  resultMap.insert(std::make_pair("multiEnterInfo", multiEnterInfo));

  return resultMap;
}

flutter::EncodableMap convertChatroomInfo(const v2::V2NIMChatroomInfo object) {
  flutter::EncodableMap resultMap;

  resultMap.insert(std::make_pair("roomId", object.roomId));
  resultMap.insert(std::make_pair("roomName", object.roomName));
  resultMap.insert(std::make_pair("announcement", object.announcement));
  resultMap.insert(std::make_pair("liveUrl", object.liveUrl));
  resultMap.insert(std::make_pair("isValidRoom", object.isValidRoom));
  resultMap.insert(std::make_pair("serverExtension", object.serverExtension));
  resultMap.insert(std::make_pair("queueLevelMode", object.queueLevelMode));
  resultMap.insert(std::make_pair("creatorAccountId", object.creatorAccountId));
  resultMap.insert(std::make_pair(
      "onlineUserCount", static_cast<int32_t>(object.onlineUserCount)));
  resultMap.insert(std::make_pair("chatBanned", object.chatBanned));
  return resultMap;
}

flutter::EncodableMap convertChatroomMessageConfig(
    const v2::V2NIMChatroomMessageConfig object) {
  flutter::EncodableMap resultMap;
  resultMap.insert(std::make_pair("historyEnabled", object.historyEnabled));
  resultMap.insert(std::make_pair("highPriority", object.highPriority));
  return resultMap;
}

flutter::EncodableMap convertChatroomUpdateParams(
    const v2::V2NIMChatroomUpdateParams object) {
  flutter::EncodableMap resultMap;

  if (object.roomName.has_value()) {
    resultMap.insert(std::make_pair("roomName", object.roomName.value()));
  }

  if (object.announcement.has_value()) {
    resultMap.insert(
        std::make_pair("announcement", object.announcement.value()));
  }

  if (object.liveUrl.has_value()) {
    resultMap.insert(std::make_pair("liveUrl", object.liveUrl.value()));
  }

  if (object.serverExtension.has_value()) {
    resultMap.insert(
        std::make_pair("serverExtension", object.serverExtension.value()));
  }

  resultMap.insert(
      std::make_pair("notificationEnabled", object.notificationEnabled));
  resultMap.insert(
      std::make_pair("notificationExtension", object.notificationExtension));

  if (object.queueLevelMode.has_value()) {
    resultMap.insert(
        std::make_pair("queueLevelMode", object.queueLevelMode.value()));
  }
  return resultMap;
}

flutter::EncodableMap convertChatroomQueueElement(
    const v2::V2NIMChatroomQueueElement object) {
  flutter::EncodableMap resultMap;
  resultMap.insert(std::make_pair("key", object.key));
  resultMap.insert(std::make_pair("value", object.value));

  if (object.accountId.has_value()) {
    resultMap.insert(std::make_pair("accountId", object.accountId.value()));
  }

  if (object.nick.has_value()) {
    resultMap.insert(std::make_pair("nick", object.nick.value()));
  }

  if (object.extension.has_value()) {
    resultMap.insert(std::make_pair("extension", object.extension.value()));
  }
  return resultMap;
}

flutter::EncodableMap convertChatroomNotificationAttachment(
    const nstd::shared_ptr<v2::V2NIMChatroomNotificationAttachment> object) {
  flutter::EncodableMap resultMap;
  resultMap.insert(std::make_pair("raw", object->raw));
  resultMap.insert(std::make_pair("nimCoreMessageType", 105));
  resultMap.insert(std::make_pair("type", object->type));

  flutter::EncodableList targetIds;
  for (auto targetId : object->targetIds) {
    targetIds.emplace_back(targetId);
  }
  resultMap.insert(std::make_pair("targetIds", targetIds));

  flutter::EncodableList targetNicks;
  for (auto targetNick : object->targetNicks) {
    targetNicks.emplace_back(targetNick);
  }
  resultMap.insert(std::make_pair("targetNicks", targetNicks));

  if (object->targetTag.has_value()) {
    resultMap.insert(std::make_pair("targetTag", object->targetTag.value()));
  }

  resultMap.insert(std::make_pair("operatorId", object->operatorId));
  resultMap.insert(std::make_pair("operatorNick", object->operatorNick));

  if (object->notificationExtension.has_value()) {
    resultMap.insert(std::make_pair("notificationExtension",
                                    object->notificationExtension.value()));
  }

  flutter::EncodableList tags;
  for (auto tag : object->tags) {
    tags.emplace_back(tag);
  }
  resultMap.insert(std::make_pair("tags", tags));

  if (object->chatroomUpdateParams.has_value()) {
    flutter::EncodableMap chatroomUpdateParams =
        convertChatroomUpdateParams(object->chatroomUpdateParams.value());
    resultMap.insert(
        std::make_pair("chatroomUpdateParams", chatroomUpdateParams));
  }

  if (object->chatroomMember.has_value()) {
    flutter::EncodableMap chatroomMember =
        convertChatroomMember(object->chatroomMember.value());
    resultMap.insert(std::make_pair("chatroomMember", chatroomMember));
  }
  return resultMap;
}

flutter::EncodableMap convertChatroomMessageRevokeNotificationAttachment(
    const nstd::shared_ptr<v2::V2NIMChatroomMessageRevokeNotificationAttachment>
        object) {
  flutter::EncodableMap resultMap =
      convertChatroomNotificationAttachment(object);

  resultMap.insert(std::make_pair("messageClientId", object->messageClientId));
  resultMap.insert(
      std::make_pair("messageTime", static_cast<int64_t>(object->messageTime)));

  return resultMap;
}

flutter::EncodableMap convertChatroomQueueNotificationAttachment(
    const nstd::shared_ptr<v2::V2NIMChatroomQueueNotificationAttachment>
        object) {
  flutter::EncodableMap resultMap =
      convertChatroomNotificationAttachment(object);

  flutter::EncodableList elements;
  for (auto element : object->elements) {
    elements.emplace_back(convertChatroomQueueElement(element));
  }
  resultMap.insert(std::make_pair("elements", elements));

  resultMap.insert(std::make_pair("queueChangeType", object->queueChangeType));

  return resultMap;
}

flutter::EncodableMap convertChatroomChatBannedNotificationAttachment(
    const nstd::shared_ptr<v2::V2NIMChatroomChatBannedNotificationAttachment>
        object) {
  flutter::EncodableMap resultMap =
      convertChatroomNotificationAttachment(object);

  resultMap.insert(std::make_pair("chatBanned", object->chatBanned));
  resultMap.insert(std::make_pair("tempChatBanned", object->tempChatBanned));
  resultMap.insert(
      std::make_pair("tempChatBannedDuration",
                     static_cast<int64_t>(object->tempChatBannedDuration)));

  return resultMap;
}

flutter::EncodableMap convertChatroomMemberEnterNotificationAttachment(
    const nstd::shared_ptr<v2::V2NIMChatroomMemberEnterNotificationAttachment>
        object) {
  flutter::EncodableMap resultMap =
      convertChatroomNotificationAttachment(object);

  resultMap.insert(std::make_pair("chatBanned", object->chatBanned));
  resultMap.insert(std::make_pair("tempChatBanned", object->tempChatBanned));
  resultMap.insert(
      std::make_pair("tempChatBannedDuration",
                     static_cast<int64_t>(object->tempChatBannedDuration)));

  return resultMap;
}

flutter::EncodableMap convertChatroomMemberRoleUpdateAttachment(
    const nstd::shared_ptr<v2::V2NIMChatroomMemberRoleUpdateAttachment>
        object) {
  flutter::EncodableMap resultMap =
      convertChatroomNotificationAttachment(object);

  resultMap.insert(std::make_pair("previousRole", object->previousRole));
  flutter::EncodableMap currentMember =
      convertChatroomMember(object->currentMember);
  resultMap.insert(std::make_pair("currentMember", currentMember));

  return resultMap;
}

flutter::EncodableMap convertMessageCallDuration(
    const v2::V2NIMMessageCallDuration object) {
  flutter::EncodableMap resultMap;
  resultMap.insert(std::make_pair("accountId", object.accountId));
  resultMap.insert(
      std::make_pair("duration", static_cast<int32_t>((object.duration))));
  return resultMap;
}

flutter::EncodableMap convertMessageCallAttachment(
    const nstd::shared_ptr<v2::V2NIMMessageCallAttachment> object) {
  flutter::EncodableMap resultMap;
  resultMap.insert(std::make_pair("raw", object->raw));
  resultMap.insert(
      std::make_pair("nimCoreMessageType", v2::V2NIM_MESSAGE_TYPE_CALL));
  resultMap.insert(std::make_pair("type", static_cast<int32_t>(object->type)));
  resultMap.insert(std::make_pair("channelId", object->channelId));
  resultMap.insert(
      std::make_pair("status", static_cast<int32_t>(object->status)));

  flutter::EncodableList durations;
  for (auto duration : object->durations) {
    durations.emplace_back(convertMessageCallDuration(duration));
  }
  resultMap.insert(std::make_pair("durations", durations));
  return resultMap;
}

flutter::EncodableMap convertMessageAIConfigParams(
    const nstd::optional<v2::V2NIMMessageAIConfigParams> object) {
  flutter::EncodableMap resultMap;
  resultMap.insert(std::make_pair("accountId", object->accountId));
  resultMap.insert(std::make_pair("aiStream", object->aiStream));

  if (object->content.has_value()) {
    flutter::EncodableMap contentMap =
        convertAIModelCallContent(object->content.value());
    resultMap.insert(std::make_pair("content", contentMap));
  }

  if (object->messages.has_value()) {
    auto messages = object->messages.value();
    flutter::EncodableList messagesList;
    for (auto message : messages) {
      messagesList.emplace_back(convertAIModelCallMessage(message));
    }
    resultMap.insert(std::make_pair("messages", messagesList));
  }

  if (object->promptVariables.has_value()) {
    resultMap.insert(
        std::make_pair("promptVariables", object->promptVariables.value()));
  }

  if (object->modelConfigParams.has_value()) {
    flutter::EncodableMap modelConfigParams =
        convertAIModelConfigParams(object->modelConfigParams.value());
    resultMap.insert(std::make_pair("modelConfigParams", modelConfigParams));
  }

  return resultMap;
}

flutter::EncodableMap convertAIModelCallContent(
    const v2::V2NIMAIModelCallContent object) {
  flutter::EncodableMap resultMap;
  resultMap.insert(std::make_pair("msg", object.msg));
  resultMap.insert(std::make_pair("type", static_cast<int64_t>(object.type)));
  return resultMap;
}

flutter::EncodableMap convertAIModelCallMessage(
    const v2::V2NIMAIModelCallMessage object) {
  flutter::EncodableMap resultMap;
  resultMap.insert(std::make_pair("role", object.role));
  resultMap.insert(std::make_pair("msg", object.msg));
  resultMap.insert(std::make_pair("type", static_cast<int64_t>(object.type)));
  return resultMap;
}

flutter::EncodableMap convertAIModelConfigParams(
    const v2::V2NIMAIModelConfigParams object) {
  flutter::EncodableMap resultMap;
  if (object.prompt.has_value()) {
    resultMap.insert(std::make_pair("prompt", object.prompt.value()));
  }
  if (object.maxTokens.has_value()) {
    resultMap.insert(std::make_pair("maxTokens", object.maxTokens.value()));
  }
  if (object.topP.has_value()) {
    resultMap.insert(std::make_pair("topP", object.topP.value()));
  }
  if (object.temperature.has_value()) {
    resultMap.insert(std::make_pair("temperature", object.temperature.value()));
  }
  return resultMap;
}

flutter::EncodableMap convertMessageTargetConfig(
    const v2::V2NIMMessageTargetConfig object) {
  flutter::EncodableMap resultMap;
  flutter::EncodableList receiverIds;
  for (auto receiverId : object.receiverIds) {
    receiverIds.emplace_back(receiverId);
  }
  resultMap.insert(std::make_pair("receiverIds", receiverIds));
  resultMap.insert(std::make_pair("inclusive", object.inclusive));
  resultMap.insert(std::make_pair("newMemberVisible", object.newMemberVisible));
  return resultMap;
}

flutter::EncodableMap convertSendMessageParams(
    const v2::V2NIMSendMessageParams object) {
  flutter::EncodableMap resultMap;

  flutter::EncodableMap messageConfig =
      convertMessageConfig(object.messageConfig);
  resultMap.insert(std::make_pair("messageConfig", messageConfig));

  flutter::EncodableMap routeConfig =
      convertMessageRouteConfig(object.routeConfig);
  resultMap.insert(std::make_pair("routeConfig", routeConfig));

  flutter::EncodableMap pushConfig =
      convertMessagePushConfig(object.pushConfig);
  resultMap.insert(std::make_pair("pushConfig", pushConfig));

  flutter::EncodableMap antispamConfig =
      convertMessageAntispamConfig(object.antispamConfig);
  resultMap.insert(std::make_pair("antispamConfig", antispamConfig));

  flutter::EncodableMap robotConfig =
      convertMessageRobotConfig(object.robotConfig);
  resultMap.insert(std::make_pair("robotConfig", robotConfig));

  if (object.aiConfig.has_value()) {
    flutter::EncodableMap aiConfig =
        convertMessageAIConfigParams(object.aiConfig.value());
    resultMap.insert(std::make_pair("aiConfig", aiConfig));
  }

  if (object.targetConfig.has_value()) {
    flutter::EncodableMap targetConfig =
        convertMessageTargetConfig(object.targetConfig.value());
    resultMap.insert(std::make_pair("targetConfig", targetConfig));
  }

  resultMap.insert(
      std::make_pair("clientAntispamEnabled", object.clientAntispamEnabled));
  resultMap.insert(
      std::make_pair("clientAntispamReplace", object.clientAntispamReplace));

  return resultMap;
}

flutter::EncodableMap convertSendMessageResult(
    const v2::V2NIMSendMessageResult object) {
  flutter::EncodableMap resultMap;

  flutter::EncodableMap message = convertMessage(object.message);
  resultMap.insert(std::make_pair("message", message));

  if (object.antispamResult.has_value()) {
    resultMap.insert(
        std::make_pair("antispamResult", object.antispamResult.value()));
  }

  if (object.clientAntispamResult.has_value()) {
    flutter::EncodableMap clientAntispamResult =
        convertClientAntispamResult(object.clientAntispamResult.value());
    resultMap.insert(
        std::make_pair("clientAntispamResult", clientAntispamResult));
  }
  return resultMap;
}

flutter::EncodableMap convertClientAntispamResult(
    const nstd::optional<v2::V2NIMClientAntispamResult> object) {
  flutter::EncodableMap resultMap;
  resultMap.insert(std::make_pair("operateType", object->operateType));
  resultMap.insert(std::make_pair("replacedText", object->replacedText));
  return resultMap;
}

flutter::EncodableMap convertMessageListOption(
    const v2::V2NIMMessageListOption object) {
  flutter::EncodableMap resultMap;
  resultMap.insert(std::make_pair("conversationId", object.conversationId));

  flutter::EncodableList messageTypes;
  for (auto& it : object.messageTypes) {
    messageTypes.emplace_back(it);
  }
  resultMap.insert(std::make_pair("messageTypes", messageTypes));

  resultMap.insert(
      std::make_pair("beginTime", static_cast<int64_t>(object.beginTime)));
  resultMap.insert(
      std::make_pair("endTime", static_cast<int64_t>(object.endTime)));
  resultMap.insert(std::make_pair("limit", static_cast<int64_t>(object.limit)));

  if (object.anchorMessage.has_value()) {
    flutter::EncodableMap anchorMessage =
        convertMessage(object.anchorMessage.value());
    resultMap.insert(std::make_pair("anchorMessage", anchorMessage));
  }

  resultMap.insert(std::make_pair("direction", object.direction));
  resultMap.insert(std::make_pair("strictMode", object.strictMode));
  return resultMap;
}

flutter::EncodableMap convertClearHistoryMessageOption(
    const v2::V2NIMClearHistoryMessageOption object) {
  flutter::EncodableMap resultMap;
  resultMap.insert(std::make_pair("conversationId", object.conversationId));
  resultMap.insert(std::make_pair("deleteRoam", object.deleteRoam));
  resultMap.insert(std::make_pair("onlineSync", object.onlineSync));
  resultMap.insert(
      std::make_pair("serverExtension", object.serverExtension.value()));
  return resultMap;
}

flutter::EncodableMap convertMessageDeletedNotification(
    const v2::V2NIMMessageDeletedNotification object) {
  flutter::EncodableMap resultMap;
  flutter::EncodableMap messageRefer = convertMessageRefer(object.messageRefer);
  resultMap.insert(std::make_pair("messageRefer", messageRefer));
  resultMap.insert(
      std::make_pair("deleteTime", static_cast<int64_t>(object.deleteTime)));
  resultMap.insert(
      std::make_pair("serverExtension", object.serverExtension.value()));
  return resultMap;
}

flutter::EncodableMap convertMessagePin(const v2::V2NIMMessagePin object) {
  flutter::EncodableMap resultMap;
  flutter::EncodableMap messageRefer = convertMessageRefer(object.messageRefer);
  resultMap.insert(std::make_pair("messageRefer", messageRefer));
  resultMap.insert(std::make_pair("operatorId", object.operatorId));
  resultMap.insert(
      std::make_pair("serverExtension", object.serverExtension.value()));
  resultMap.insert(
      std::make_pair("createTime", static_cast<int64_t>(object.createTime)));
  resultMap.insert(
      std::make_pair("updateTime", static_cast<int64_t>(object.updateTime)));
  return resultMap;
}

flutter::EncodableMap convertMessagePinNotification(
    const v2::V2NIMMessagePinNotification object) {
  flutter::EncodableMap resultMap;
  flutter::EncodableMap pin = convertMessagePin(object.pin);
  resultMap.insert(std::make_pair("pin", pin));
  resultMap.insert(std::make_pair("pinState", object.pinState));
  return resultMap;
}

flutter::EncodableMap convertMessageQuickComment(
    const v2::V2NIMMessageQuickComment object) {
  flutter::EncodableMap resultMap;
  flutter::EncodableMap messageRefer = convertMessageRefer(object.messageRefer);
  resultMap.insert(std::make_pair("messageRefer", messageRefer));
  resultMap.insert(std::make_pair("operatorId", object.operatorId));
  resultMap.insert(std::make_pair("index", static_cast<int64_t>(object.index)));
  if (object.createTime.has_value()) {
    resultMap.insert(std::make_pair(
        "createTime", static_cast<int64_t>(object.createTime.value())));
  }
  resultMap.insert(
      std::make_pair("serverExtension", object.serverExtension.value()));
  return resultMap;
}

flutter::EncodableMap convertMessageQuickCommentNotification(
    const v2::V2NIMMessageQuickCommentNotification object) {
  flutter::EncodableMap resultMap;
  resultMap.insert(std::make_pair("operationType", object.operationType));

  flutter::EncodableMap quickComment =
      convertMessageQuickComment(object.quickComment);
  resultMap.insert(std::make_pair("quickComment", quickComment));
  return resultMap;
}

flutter::EncodableMap convertMessageQuickCommentPushConfig(
    const v2::V2NIMMessageQuickCommentPushConfig object) {
  flutter::EncodableMap resultMap;
  resultMap.insert(std::make_pair("pushEnabled", object.needPush));
  resultMap.insert(std::make_pair("needBadge", object.needBadge));
  resultMap.insert(std::make_pair("pushTitle", object.pushTitle));
  resultMap.insert(std::make_pair("pushContent", object.pushContent));
  resultMap.insert(std::make_pair("pushPayload", object.pushPayload));
  return resultMap;
}

flutter::EncodableMap convertMessageRevokeNotification(
    const v2::V2NIMMessageRevokeNotification object) {
  flutter::EncodableMap resultMap;
  flutter::EncodableMap messageRefer = convertMessageRefer(object.messageRefer);
  resultMap.insert(std::make_pair("messageRefer", messageRefer));
  resultMap.insert(
      std::make_pair("serverExtension", object.serverExtension.value()));
  resultMap.insert(std::make_pair("revokeAccountId", object.revokeAccountId));
  resultMap.insert(std::make_pair("postscript", object.postscript.value()));
  resultMap.insert(std::make_pair("revokeType", object.revokeType));
  resultMap.insert(
      std::make_pair("callbackExtension", object.callbackExtension.value()));
  return resultMap;
}

flutter::EncodableMap convertMessageRevokeParams(
    const v2::V2NIMMessageRevokeParams object) {
  flutter::EncodableMap resultMap;
  resultMap.insert(std::make_pair("postscript", object.postscript.value()));
  resultMap.insert(
      std::make_pair("serverExtension", object.serverExtension.value()));
  resultMap.insert(std::make_pair("pushContent", object.pushContent.value()));
  resultMap.insert(std::make_pair("pushPayload", object.pushPayload.value()));
  resultMap.insert(std::make_pair("env", object.env.value()));
  return resultMap;
}

flutter::EncodableMap convertMessageSearchParams(
    const v2::V2NIMMessageSearchParams object) {
  flutter::EncodableMap resultMap;
  resultMap.insert(std::make_pair("keyword", object.keyword));
  resultMap.insert(
      std::make_pair("beginTime", static_cast<int64_t>(object.beginTime)));
  resultMap.insert(
      std::make_pair("endTime", static_cast<int64_t>(object.endTime)));
  resultMap.insert(std::make_pair(
      "conversationLimit", static_cast<int64_t>(object.conversationLimit)));
  resultMap.insert(std::make_pair("messageLimit",
                                  static_cast<int64_t>(object.messageLimit)));
  resultMap.insert(std::make_pair("sortOrder", object.sortOrder));

  flutter::EncodableList p2pAccountIds;
  for (auto p2pAccountId : object.p2pAccountIds) {
    p2pAccountIds.emplace_back(p2pAccountId);
  }
  resultMap.insert(std::make_pair("p2pAccountIds", p2pAccountIds));

  flutter::EncodableList teamIds;
  for (auto teamId : object.teamIds) {
    teamIds.emplace_back(teamId);
  }
  resultMap.insert(std::make_pair("teamIds", teamIds));

  flutter::EncodableList senderAccountIds;
  for (auto senderAccountId : object.senderAccountIds) {
    senderAccountIds.emplace_back(senderAccountId);
  }
  resultMap.insert(std::make_pair("senderAccountIds", senderAccountIds));

  flutter::EncodableList messageTypes;
  for (auto messageType : object.messageTypes) {
    messageTypes.emplace_back(messageType);
  }
  resultMap.insert(std::make_pair("messageTypes", messageTypes));

  flutter::EncodableList messageSubTypes;
  for (auto messageSubType : object.messageSubTypes) {
    messageSubTypes.emplace_back(static_cast<int64_t>(messageSubType));
  }
  resultMap.insert(std::make_pair("messageSubtypes", messageSubTypes));
  return resultMap;
}

flutter::EncodableMap convertNotificationAntispamConfig(
    const v2::V2NIMNotificationAntispamConfig object) {
  flutter::EncodableMap resultMap;
  resultMap.insert(std::make_pair("antispamEnabled", object.antispamEnabled));
  resultMap.insert(std::make_pair("antispamCustomNotification",
                                  object.antispamCustomMessage.value()));
  return resultMap;
}

flutter::EncodableMap convertNotificationConfig(
    const v2::V2NIMNotificationConfig object) {
  flutter::EncodableMap resultMap;
  resultMap.insert(std::make_pair("offlineEnabled", object.offlineEnabled));
  resultMap.insert(std::make_pair("unreadEnabled", object.unreadEnabled));
  return resultMap;
}

flutter::EncodableMap convertNotificationPushConfig(
    const v2::V2NIMNotificationPushConfig object) {
  flutter::EncodableMap resultMap;
  resultMap.insert(std::make_pair("pushEnabled", object.pushEnabled));
  resultMap.insert(std::make_pair("pushNickEnabled", object.pushNickEnabled));
  resultMap.insert(std::make_pair("pushContent", object.pushContent));
  resultMap.insert(std::make_pair("pushPayload", object.pushPayload));
  resultMap.insert(std::make_pair("forcePush", object.forcePush));
  resultMap.insert(std::make_pair("forcePushContent", object.forcePushContent));

  flutter::EncodableList forcePushAccountIds;
  for (auto forcePushAccountId : object.forcePushAccountIds) {
    forcePushAccountIds.emplace_back(forcePushAccountId);
  }
  resultMap.insert(std::make_pair("forcePushAccountIds", forcePushAccountIds));
  return resultMap;
}

flutter::EncodableMap convertNotificationRouteConfig(
    const v2::V2NIMNotificationRouteConfig object) {
  flutter::EncodableMap resultMap;
  resultMap.insert(std::make_pair("routeEnabled", object.routeEnabled));
  resultMap.insert(
      std::make_pair("routeEnvironment", object.routeEnvironment.value()));
  return resultMap;
}

flutter::EncodableMap convertP2PMessageReadReceipt(
    const v2::V2NIMP2PMessageReadReceipt object) {
  flutter::EncodableMap resultMap;
  resultMap.insert(std::make_pair("conversationId", object.conversationId));
  resultMap.insert(
      std::make_pair("timestamp", static_cast<int64_t>(object.timestamp)));
  return resultMap;
}

flutter::EncodableMap convertTeamMessageReadReceipt(
    const v2::V2NIMTeamMessageReadReceipt object) {
  flutter::EncodableMap resultMap;
  resultMap.insert(std::make_pair("conversationId", object.conversationId));
  resultMap.insert(std::make_pair("messageServerId", object.messageServerId));
  resultMap.insert(std::make_pair("messageClientId", object.messageClientId));
  resultMap.insert(
      std::make_pair("readCount", static_cast<int64_t>(object.readCount)));
  resultMap.insert(
      std::make_pair("unreadCount", static_cast<int64_t>(object.unreadCount)));
  resultMap.insert(
      std::make_pair("latestReadAccount", object.latestReadAccount.value()));
  return resultMap;
}

flutter::EncodableMap convertTeamMessageReadReceiptDetail(
    const v2::V2NIMTeamMessageReadReceiptDetail object) {
  flutter::EncodableMap resultMap;
  flutter::EncodableMap readReceipt =
      convertTeamMessageReadReceipt(object.readReceipt);
  resultMap.insert(std::make_pair("readReceipt", readReceipt));

  flutter::EncodableList readAccountList;
  for (auto readAccount : object.readAccountList) {
    readAccountList.emplace_back(readAccount);
  }
  resultMap.insert(std::make_pair("readAccountList", readAccountList));

  flutter::EncodableList unreadAccountList;
  for (auto unreadAccount : object.unreadAccountList) {
    unreadAccountList.emplace_back(unreadAccount);
  }
  resultMap.insert(std::make_pair("unreadAccountList", unreadAccountList));
  return resultMap;
}

flutter::EncodableMap convertThreadMessageListOption(
    const v2::V2NIMThreadMessageListOption object) {
  flutter::EncodableMap resultMap;
  flutter::EncodableMap messageRefer = convertMessageRefer(object.messageRefer);
  resultMap.insert(std::make_pair("messageRefer", messageRefer));
  if (object.beginTime.has_value()) {
    resultMap.insert(std::make_pair(
        "beginTime", static_cast<int64_t>(object.beginTime.value())));
  }
  if (object.endTime.has_value()) {
    resultMap.insert(std::make_pair(
        "endTime", static_cast<int64_t>(object.endTime.value())));
  }
  resultMap.insert(std::make_pair("excludeMessageServerId",
                                  object.excludeMessageServerId.value()));
  if (object.limit.has_value()) {
    resultMap.insert(
        std::make_pair("limit", static_cast<int64_t>(object.limit.value())));
  }
  resultMap.insert(std::make_pair("direction", object.direction.value()));
  return resultMap;
}

flutter::EncodableMap convertMessageSearchResult(
    const v2::V2NIMMessageSearchResult object) {
  flutter::EncodableMap resultMap;
  flutter::EncodableList itemsList;
  for (auto iteam : object.items) {
    itemsList.emplace_back(convertMessageSearchItem(iteam));
  }
  resultMap.insert(std::make_pair("items", itemsList));
  resultMap.insert(std::make_pair("count", static_cast<int32_t>(object.count)));
  resultMap.insert(std::make_pair("nextPageToken", object.nextPageToken));
  if (!object.nextPageToken.empty()) {
    resultMap.insert(std::make_pair("hasMore", true));
  } else {
    resultMap.insert(std::make_pair("hasMore", false));
  }
  return resultMap;
}

flutter::EncodableMap convertMessageSearchItem(
    const v2::V2NIMMessageSearchItem object) {
  flutter::EncodableMap resultMap;
  flutter::EncodableList messageList;
  for (auto message : object.messages) {
    messageList.emplace_back(convertMessage(message));
  }

  resultMap.insert(std::make_pair("messages", messageList));
  resultMap.insert(std::make_pair("conversationId", object.conversationId));
  resultMap.insert(std::make_pair("count", static_cast<int32_t>(object.count)));

  return resultMap;
}

flutter::EncodableMap convertThreadMessageListResult(
    const v2::V2NIMThreadMessageListResult object) {
  flutter::EncodableMap resultMap;
  flutter::EncodableMap message = convertMessage(object.message);
  resultMap.insert(std::make_pair("message", message));
  resultMap.insert(
      std::make_pair("timestamp", static_cast<int64_t>(object.timestamp)));
  resultMap.insert(
      std::make_pair("replyCount", static_cast<int64_t>(object.replyCount)));

  flutter::EncodableList replyList;
  for (auto reply : object.replyList) {
    replyList.emplace_back(convertMessage(reply));
  }
  resultMap.insert(std::make_pair("replyList", replyList));
  return resultMap;
}

flutter::EncodableMap convertVoiceToTextParams(
    const v2::V2NIMVoiceToTextParams object) {
  flutter::EncodableMap resultMap;
  resultMap.insert(std::make_pair("voicePath", object.voicePath));
  resultMap.insert(std::make_pair("voiceUrl", object.voiceUrl));
  resultMap.insert(std::make_pair("mimeType", object.mimeType));
  resultMap.insert(std::make_pair("sampleRate", object.sampleRate));
  resultMap.insert(
      std::make_pair("duration", static_cast<int64_t>(object.duration)));
  resultMap.insert(std::make_pair("sceneName", object.sceneName));
  return resultMap;
}

flutter::EncodableMap convertCollection(
    const nstd::optional<v2::V2NIMCollection> object) {
  flutter::EncodableMap resultMap;
  resultMap.insert(std::make_pair("collectionId", object->collectionId));
  resultMap.insert(std::make_pair(
      "collectionType", static_cast<int64_t>(object->collectionType)));
  resultMap.insert(std::make_pair("collectionData", object->collectionData));
  resultMap.insert(
      std::make_pair("serverExtension", object->serverExtension.value()));
  resultMap.insert(
      std::make_pair("createTime", static_cast<int64_t>(object->createTime)));
  resultMap.insert(
      std::make_pair("updateTime", static_cast<int64_t>(object->updateTime)));
  return resultMap;
}

flutter::EncodableMap convertAddCollectionParams(
    const v2::V2NIMAddCollectionParams object) {
  flutter::EncodableMap resultMap;
  resultMap.insert(std::make_pair("collectionType",
                                  static_cast<int64_t>(object.collectionType)));
  resultMap.insert(std::make_pair("collectionData", object.collectionData));
  resultMap.insert(
      std::make_pair("serverExtension", object.serverExtension.value()));
  return resultMap;
}

flutter::EncodableMap convertCollectionOption(
    const v2::V2NIMCollectionOption object) {
  flutter::EncodableMap resultMap;
  resultMap.insert(
      std::make_pair("beginTime", static_cast<int64_t>(object.beginTime)));
  resultMap.insert(
      std::make_pair("endTime", static_cast<int64_t>(object.endTime)));

  if (object.anchorCollection.has_value()) {
    flutter::EncodableMap anchorCollection =
        convertCollection(object.anchorCollection.value());
    resultMap.insert(std::make_pair("anchorCollection", anchorCollection));
  }

  resultMap.insert(std::make_pair("direction", object.direction));
  resultMap.insert(std::make_pair("limit", static_cast<int64_t>(object.limit)));
  resultMap.insert(std::make_pair("collectionType",
                                  static_cast<int64_t>(object.collectionType)));
  return resultMap;
}

flutter::EncodableMap convertClearHistoryNotification(
    const v2::V2NIMClearHistoryNotification object) {
  flutter::EncodableMap resultMap;
  resultMap.insert(std::make_pair("conversationId", object.conversationId));
  resultMap.insert(
      std::make_pair("deleteTime", static_cast<int64_t>(object.deleteTime)));
  resultMap.insert(
      std::make_pair("serverExtension", object.serverExtension.value()));
  return resultMap;
}

flutter::EncodableMap convertUpdatedTeamInfo(
    const nstd::optional<v2::V2NIMUpdatedTeamInfo> object) {
  flutter::EncodableMap resultMap;
  if (object->name.has_value()) {
    resultMap.insert(std::make_pair("name", object->name.value()));
  }
  if (object->memberLimit.has_value()) {
    resultMap.insert(std::make_pair(
        "memberLimit", static_cast<int64_t>(object->memberLimit.value())));
  }
  if (object->intro.has_value()) {
    resultMap.insert(std::make_pair("intro", object->intro.value()));
  }
  if (object->announcement.has_value()) {
    resultMap.insert(
        std::make_pair("announcement", object->announcement.value()));
  }
  if (object->avatar.has_value()) {
    resultMap.insert(std::make_pair("avatar", object->avatar.value()));
  }
  if (object->serverExtension.has_value()) {
    resultMap.insert(
        std::make_pair("serverExtension", object->serverExtension.value()));
  }
  if (object->joinMode.has_value()) {
    resultMap.insert(std::make_pair("joinMode", object->joinMode.value()));
  }
  if (object->agreeMode.has_value()) {
    resultMap.insert(std::make_pair("agreeMode", object->agreeMode.value()));
  }
  if (object->inviteMode.has_value()) {
    resultMap.insert(std::make_pair("inviteMode", object->inviteMode.value()));
  }
  if (object->updateInfoMode.has_value()) {
    resultMap.insert(
        std::make_pair("updateInfoMode", object->updateInfoMode.value()));
  }
  if (object->updateExtensionMode.has_value()) {
    resultMap.insert(std::make_pair("updateExtensionMode",
                                    object->updateExtensionMode.value()));
  }
  if (object->chatBannedMode.has_value()) {
    resultMap.insert(
        std::make_pair("chatBannedMode", object->chatBannedMode.value()));
  }
  if (object->customerExtension.has_value()) {
    resultMap.insert(
        std::make_pair("customerExtension", object->customerExtension.value()));
  }
  return resultMap;
}

v2::V2NIMMessageRefer getMessageRefer(const flutter::EncodableMap* arguments) {
  v2::V2NIMMessageRefer object;
  auto iter = arguments->begin();
  for (; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("senderId")) {
      object.senderId = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("receiverId")) {
      object.receiverId = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("messageClientId")) {
      object.messageClientId = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("messageServerId")) {
      object.messageServerId = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("conversationType")) {
      object.conversationType =
          v2::V2NIMConversationType(std::get<int>(iter->second));
    } else if (iter->first == flutter::EncodableValue("conversationId")) {
      object.conversationId = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("createTime")) {
      auto createTime = iter->second.LongValue();
      object.createTime = createTime;
    }
  }
  return object;
}

v2::V2NIMUpdateLocalMessageParams getUpdateLocalMessageParams(
    const flutter::EncodableMap* arguments) {
  v2::V2NIMUpdateLocalMessageParams object;
  auto iter = arguments->begin();
  for (; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("text")) {
      object.text = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("attachment")) {
      auto attachmentMap = std::get<flutter::EncodableMap>(iter->second);
      object.attachment = getMessageAttachment(&attachmentMap);
    } else if (iter->first == flutter::EncodableValue("subType")) {
      object.subType = static_cast<uint32_t>(std::get<int32_t>(iter->second));
    } else if (iter->first == flutter::EncodableValue("localExtension")) {
      object.localExtension = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("sendingState")) {
      object.sendingState =
          v2::V2NIMMessageSendingState(std::get<int>(iter->second));
    }
  }
  return object;
}

v2::V2NIMModifyMessageParams getModifyMessageParams(
    const flutter::EncodableMap* arguments) {
  v2::V2NIMModifyMessageParams object;
  auto iter = arguments->begin();
  for (; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("subType")) {
      object.subType = static_cast<uint32_t>(std::get<int32_t>(iter->second));
    } else if (iter->first == flutter::EncodableValue("text")) {
      object.text = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("attachment")) {
      auto attachmentMap = std::get<flutter::EncodableMap>(iter->second);
      object.attachment = getMessageAttachment(&attachmentMap);
    } else if (iter->first == flutter::EncodableValue("serverExtension")) {
      object.serverExtension = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("antispamConfig")) {
      auto configMap = std::get<flutter::EncodableMap>(iter->second);
      object.antispamConfig = getMessageAntispamConfig(&configMap);
    } else if (iter->first == flutter::EncodableValue("routeConfig")) {
      auto configMap = std::get<flutter::EncodableMap>(iter->second);
      object.routeConfig = getMessageRouteConfig(&configMap);
    } else if (iter->first == flutter::EncodableValue("pushConfig")) {
      auto configMap = std::get<flutter::EncodableMap>(iter->second);
      object.pushConfig = getMessagePushConfig(&configMap);
    } else if (iter->first ==
               flutter::EncodableValue("clientAntispamEnabled")) {
      object.clientAntispamEnabled = std::get<bool>(iter->second);
    } else if (iter->first ==
               flutter::EncodableValue("clientAntispamReplace")) {
      object.clientAntispamReplace = std::get<std::string>(iter->second);
    }
  }
  return object;
}

v2::V2NIMMessage getMessage(const flutter::EncodableMap* arguments) {
  v2::V2NIMMessage object;
  auto iter = arguments->begin();
  for (; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("isSelf")) {
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
    } else if (iter->first == flutter::EncodableValue("localExtension")) {
      object.localExtension = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("callbackExtension")) {
      object.callbackExtension = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("messageConfig")) {
      auto messageConfigMap = std::get<flutter::EncodableMap>(iter->second);
      object.messageConfig = getMessageConfig(&messageConfigMap);
    } else if (iter->first == flutter::EncodableValue("pushConfig")) {
      auto pushConfigMap = std::get<flutter::EncodableMap>(iter->second);
      object.pushConfig = getMessagePushConfig(&pushConfigMap);
    } else if (iter->first == flutter::EncodableValue("routeConfig")) {
      auto routeConfigMap = std::get<flutter::EncodableMap>(iter->second);
      object.routeConfig = getMessageRouteConfig(&routeConfigMap);
    } else if (iter->first == flutter::EncodableValue("antispamConfig")) {
      auto antispamConfigMap = std::get<flutter::EncodableMap>(iter->second);
      object.antispamConfig = getMessageAntispamConfig(&antispamConfigMap);
    } else if (iter->first == flutter::EncodableValue("robotConfig")) {
      auto robotConfigMap = std::get<flutter::EncodableMap>(iter->second);
      object.robotConfig = getMessageRobotConfig(&robotConfigMap);
    } else if (iter->first == flutter::EncodableValue("threadRoot")) {
      auto threadRootMap = std::get<flutter::EncodableMap>(iter->second);
      object.threadRoot = getMessageRefer(&threadRootMap);
    } else if (iter->first == flutter::EncodableValue("threadReply")) {
      auto threadReplyMap = std::get<flutter::EncodableMap>(iter->second);
      object.threadReply = getMessageRefer(&threadReplyMap);
    } else if (iter->first == flutter::EncodableValue("topicRefer")) {
      auto topicReferMap = std::get<flutter::EncodableMap>(iter->second);
      object.topicRefer = getTopicRefer(&topicReferMap);
    } else if (iter->first == flutter::EncodableValue("aiConfig")) {
      auto aiConfigMap = std::get<flutter::EncodableMap>(iter->second);
      object.aiConfig = getMessageAIConfig(&aiConfigMap);
    } else if (iter->first == flutter::EncodableValue("streamConfig")) {
      auto streamConfigMap = std::get<flutter::EncodableMap>(iter->second);
      object.streamConfig = getMessageStreamConfig(&streamConfigMap);
    } else if (iter->first == flutter::EncodableValue("modifyTime")) {
      object.modifyTime = iter->second.LongValue();
    } else if (iter->first == flutter::EncodableValue("modifyAccountId")) {
      object.modifyAccountId = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("messageSource")) {
      object.messageSource =
          v2::V2NIMMessageSource(std::get<int>(iter->second));
    } else if (iter->first == flutter::EncodableValue("messageStatus")) {
      auto messageStatusMap = std::get<flutter::EncodableMap>(iter->second);
      object.messageStatus = getMessageStatus(&messageStatusMap);
    } else if (iter->first == flutter::EncodableValue("messageClientId")) {
      object.messageClientId = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("messageServerId")) {
      object.messageServerId = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("senderId")) {
      object.senderId = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("receiverId")) {
      object.receiverId = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("conversationId")) {
      object.conversationId = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("conversationType")) {
      int conversationType = std::get<int>(iter->second);
      v2::V2NIMConversationType type =
          v2::V2NIMConversationType(conversationType);
      object.conversationType = type;
    } else if (iter->first == flutter::EncodableValue("createTime")) {
      auto createTime = iter->second.LongValue();
      object.createTime = createTime;
    }
  }
  return object;
}

v2::V2NIMMessageStatus getMessageStatus(
    const flutter::EncodableMap* arguments) {
  v2::V2NIMMessageStatus object;
  auto iter = arguments->begin();
  for (; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("errorCode")) {
      object.errorCode = v2::V2NIMErrorCode(std::get<int>(iter->second));
    } else if (iter->first == flutter::EncodableValue("readReceiptSent")) {
      object.readReceiptSent = std::get<bool>(iter->second);
    }
  }
  return object;
}

v2::V2NIMMessageAIConfig getMessageAIConfig(
    const flutter::EncodableMap* arguments) {
  v2::V2NIMMessageAIConfig object;
  auto iter = arguments->begin();
  for (; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("aiStatus")) {
      object.aiStatus = v2::V2NIMMessageAIStatus(std::get<int>(iter->second));
    } else if (iter->first == flutter::EncodableValue("accountId")) {
      object.accountId = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("aiStream")) {
      object.aiStream = std::get<bool>(iter->second);
    } else if (iter->first == flutter::EncodableValue("aiStreamStatus")) {
      object.aiStreamStatus =
          v2::V2NIMMessageAIStreamStatus(std::get<int>(iter->second));
    } else if (iter->first == flutter::EncodableValue("aiRAGs")) {
      std::vector<v2::V2NIMAIRAGInfo> aiRAGs;
      auto aiRAGsList = std::get<flutter::EncodableList>(iter->second);
      for (auto& it : aiRAGsList) {
        auto aiRAGMap = std::get<flutter::EncodableMap>(it);
        aiRAGs.emplace_back(getAIRAGInfo(&aiRAGMap));
      }
      object.aiRAGs = aiRAGs;
    } else if (iter->first == flutter::EncodableValue("aiStreamLastChunk")) {
      auto aiStreamLastChunkMap = std::get<flutter::EncodableMap>(iter->second);
      object.aiStreamLastChunk = getMessageAIStreamChunk(&aiStreamLastChunkMap);
    }
  }
  return object;
}

v2::V2NIMAIRAGInfo getAIRAGInfo(const flutter::EncodableMap* arguments) {
  v2::V2NIMAIRAGInfo object;
  auto iter = arguments->begin();
  for (; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("name")) {
      object.name = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("description")) {
      object.description = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("icon")) {
      object.icon = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("url")) {
      object.url = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("title")) {
      object.title = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("time")) {
      object.time = iter->second.LongValue();
    }
  }
  return object;
}

v2::V2NIMMessageAIStreamChunk getMessageAIStreamChunk(
    const flutter::EncodableMap* arguments) {
  v2::V2NIMMessageAIStreamChunk object;
  auto iter = arguments->begin();
  for (; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("content")) {
      object.content = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("messageTime")) {
      object.messageTime = iter->second.LongValue();
    } else if (iter->first == flutter::EncodableValue("chunkTime")) {
      object.chunkTime = iter->second.LongValue();
    } else if (iter->first == flutter::EncodableValue("type")) {
      object.type = std::get<int>(iter->second);
    } else if (iter->first == flutter::EncodableValue("index")) {
      object.index = iter->second.LongValue();
    }
  }
  return object;
}

v2::V2NIMMessageStreamChunk getMessageStreamChunk(
    const flutter::EncodableMap* arguments) {
  v2::V2NIMMessageStreamChunk object;
  auto iter = arguments->begin();
  for (; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("content")) {
      object.content = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("messageTime")) {
      object.messageTime = iter->second.LongValue();
    } else if (iter->first == flutter::EncodableValue("chunkTime")) {
      object.chunkTime = iter->second.LongValue();
    } else if (iter->first == flutter::EncodableValue("type")) {
      object.type = std::get<int>(iter->second);
    } else if (iter->first == flutter::EncodableValue("index")) {
      object.index = iter->second.LongValue();
    }
  }
  return object;
}

v2::V2NIMMessageStreamConfig getMessageStreamConfig(
    const flutter::EncodableMap* arguments) {
  v2::V2NIMMessageStreamConfig object;
  auto iter = arguments->begin();
  for (; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("status")) {
      object.status = v2::V2NIMMessageStreamStatus(std::get<int>(iter->second));
    } else if (iter->first == flutter::EncodableValue("rags")) {
      std::vector<v2::V2NIMAIRAGInfo> rags;
      auto ragsList = std::get<flutter::EncodableList>(iter->second);
      for (auto& it : ragsList) {
        auto ragMap = std::get<flutter::EncodableMap>(it);
        rags.emplace_back(getAIRAGInfo(&ragMap));
      }
      object.rags = rags;
    } else if (iter->first == flutter::EncodableValue("lastChunk")) {
      auto lastChunkMap = std::get<flutter::EncodableMap>(iter->second);
      object.lastChunk = getMessageStreamChunk(&lastChunkMap);
    }
  }
  return object;
}

v2::V2NIMMessageRobotConfig getMessageRobotConfig(
    const flutter::EncodableMap* arguments) {
  v2::V2NIMMessageRobotConfig object;
  auto iter = arguments->begin();
  for (; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("topic")) {
      object.topic = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("accountId")) {
      object.accountId = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("function")) {
      object.function = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("customContent")) {
      object.customContent = std::get<std::string>(iter->second);
    }
  }
  return object;
}

v2::V2NIMMessageAntispamConfig getMessageAntispamConfig(
    const flutter::EncodableMap* arguments) {
  v2::V2NIMMessageAntispamConfig object;
  auto iter = arguments->begin();
  for (; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("antispamEnabled")) {
      object.antispamEnabled = std::get<bool>(iter->second);
    } else if (iter->first == flutter::EncodableValue("antispamBusinessId")) {
      object.antispamBusinessId = std::get<std::string>(iter->second);
    } else if (iter->first ==
               flutter::EncodableValue("antispamCustomMessage")) {
      object.antispamCustomMessage = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("antispamCheating")) {
      object.antispamCheating = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("antispamExtension")) {
      object.antispamExtension = std::get<std::string>(iter->second);
    }
  }
  return object;
}

v2::V2NIMMessageRouteConfig getMessageRouteConfig(
    const flutter::EncodableMap* arguments) {
  v2::V2NIMMessageRouteConfig object;
  auto iter = arguments->begin();
  for (; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("routeEnabled")) {
      object.routeEnabled = std::get<bool>(iter->second);
    } else if (iter->first == flutter::EncodableValue("routeEnvironment")) {
      object.routeEnvironment = std::get<std::string>(iter->second);
    }
  }
  return object;
}

v2::V2NIMMessagePushConfig getMessagePushConfig(
    const flutter::EncodableMap* arguments) {
  v2::V2NIMMessagePushConfig object;
  auto iter = arguments->begin();
  for (; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("pushEnabled")) {
      object.pushEnabled = std::get<bool>(iter->second);
    } else if (iter->first == flutter::EncodableValue("pushNickEnabled")) {
      object.pushNickEnabled = std::get<bool>(iter->second);
    } else if (iter->first == flutter::EncodableValue("pushContent")) {
      object.pushContent = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("pushPayload")) {
      object.pushPayload = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("forcePush")) {
      object.forcePush = std::get<bool>(iter->second);
    } else if (iter->first == flutter::EncodableValue("forcePushContent")) {
      object.forcePushContent = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("forcePushAccountIds")) {
      std::vector<nstd::string> messageIds;
      auto messageIdList = std::get<flutter::EncodableList>(iter->second);
      for (auto& it : messageIdList) {
        auto messageId = std::get<std::string>(it);
        messageIds.emplace_back(messageId);
      }
      object.forcePushAccountIds = messageIds;
    }
  }
  return object;
}

v2::V2NIMMessageConfig getMessageConfig(
    const flutter::EncodableMap* arguments) {
  v2::V2NIMMessageConfig object;
  auto iter = arguments->begin();
  for (; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("readReceiptEnabled")) {
      object.readReceiptEnabled = std::get<bool>(iter->second);
    } else if (iter->first ==
               flutter::EncodableValue("lastMessageUpdateEnabled")) {
      object.lastMessageUpdateEnabled = std::get<bool>(iter->second);
    } else if (iter->first == flutter::EncodableValue("historyEnabled")) {
      object.historyEnabled = std::get<bool>(iter->second);
    } else if (iter->first == flutter::EncodableValue("roamingEnabled")) {
      object.roamingEnabled = std::get<bool>(iter->second);
    } else if (iter->first == flutter::EncodableValue("onlineSyncEnabled")) {
      object.onlineSyncEnabled = std::get<bool>(iter->second);
    } else if (iter->first == flutter::EncodableValue("offlineEnabled")) {
      object.offlineEnabled = std::get<bool>(iter->second);
    } else if (iter->first == flutter::EncodableValue("unreadEnabled")) {
      object.unreadEnabled = std::get<bool>(iter->second);
    }
  }
  return object;
}

nstd::shared_ptr<v2::V2NIMMessageAttachment> getMessageAttachment(
    const flutter::EncodableMap* arguments) {
  auto object = nstd::make_shared<v2::V2NIMMessageAttachment>();
  auto iter = arguments->begin();
  for (; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("raw")) {
      object->raw = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("nimCoreMessageType")) {
      auto type = v2::V2NIMMessageType(std::get<int>(iter->second));
      switch (type) {
        case v2::V2NIM_MESSAGE_TYPE_FILE:
          return getMessageFileAttachment(arguments);
        case v2::V2NIM_MESSAGE_TYPE_IMAGE:
          return getMessageImageAttachment(arguments);
        case v2::V2NIM_MESSAGE_TYPE_AUDIO:
          return getMessageAudioAttachment(arguments);
        case v2::V2NIM_MESSAGE_TYPE_VIDEO:
          return getMessageVideoAttachment(arguments);
        case v2::V2NIM_MESSAGE_TYPE_LOCATION:
          return getMessageLocationAttachment(arguments);
        case v2::V2NIM_MESSAGE_TYPE_CALL:
          return getMessageCallAttachment(arguments);
        case v2::V2NIM_MESSAGE_TYPE_NOTIFICATION:
          return getMessageNotificationAttachment(arguments);
        default:
          break;
      }
    }
  }
  return object;
}

nstd::shared_ptr<v2::V2NIMMessageFileAttachment> getMessageFileAttachment(
    const flutter::EncodableMap* arguments) {
  auto object = nstd::make_shared<v2::V2NIMMessageFileAttachment>();
  auto iter = arguments->begin();
  for (; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("raw")) {
      object->raw = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("path")) {
      object->path = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("size")) {
      object->size = std::get<int>(iter->second);
    } else if (iter->first == flutter::EncodableValue("md5")) {
      object->md5 = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("url")) {
      object->url = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("ext")) {
      object->ext = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("name")) {
      object->name = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("sceneName")) {
      object->sceneName = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("uploadState")) {
      object->uploadState =
          v2::V2NIMMessageAttachmentUploadState(std::get<int>(iter->second));
    }
  }
  return object;
}

nstd::shared_ptr<v2::V2NIMMessageImageAttachment> getMessageImageAttachment(
    const flutter::EncodableMap* arguments) {
  auto object = nstd::make_shared<v2::V2NIMMessageImageAttachment>();
  object->attachmentType = v2::V2NIM_MESSAGE_ATTACHMENT_TYPE_IMAGE;
  auto iter = arguments->begin();
  for (; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("raw")) {
      object->raw = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("path")) {
      object->path = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("size")) {
      auto size = iter->second.LongValue();
      object->size = size;
    } else if (iter->first == flutter::EncodableValue("md5")) {
      object->md5 = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("url")) {
      object->url = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("ext")) {
      object->ext = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("name")) {
      object->name = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("sceneName")) {
      object->sceneName = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("uploadState")) {
      object->uploadState =
          v2::V2NIMMessageAttachmentUploadState(std::get<int>(iter->second));
    } else if (iter->first == flutter::EncodableValue("width")) {
      object->width = std::get<int32_t>(iter->second);
    } else if (iter->first == flutter::EncodableValue("height")) {
      object->height = std::get<int32_t>(iter->second);
    }
  }
  return object;
}

nstd::shared_ptr<v2::V2NIMMessageAudioAttachment> getMessageAudioAttachment(
    const flutter::EncodableMap* arguments) {
  auto object = nstd::make_shared<v2::V2NIMMessageAudioAttachment>();
  auto iter = arguments->begin();
  for (; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("raw")) {
      object->raw = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("path")) {
      object->path = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("size")) {
      auto size = iter->second.LongValue();
      object->size = size;
    } else if (iter->first == flutter::EncodableValue("md5")) {
      object->md5 = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("url")) {
      object->url = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("ext")) {
      object->ext = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("name")) {
      object->name = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("sceneName")) {
      object->sceneName = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("uploadState")) {
      object->uploadState =
          v2::V2NIMMessageAttachmentUploadState(std::get<int>(iter->second));
    } else if (iter->first == flutter::EncodableValue("duration")) {
      object->duration = iter->second.LongValue();
    }
  }
  return object;
}

nstd::shared_ptr<v2::V2NIMMessageVideoAttachment> getMessageVideoAttachment(
    const flutter::EncodableMap* arguments) {
  auto object = nstd::make_shared<v2::V2NIMMessageVideoAttachment>();
  auto iter = arguments->begin();
  for (; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("raw")) {
      object->raw = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("path")) {
      object->path = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("size")) {
      object->size = iter->second.LongValue();
    } else if (iter->first == flutter::EncodableValue("md5")) {
      object->md5 = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("url")) {
      object->url = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("ext")) {
      object->ext = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("name")) {
      object->name = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("sceneName")) {
      object->sceneName = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("uploadState")) {
      object->uploadState =
          v2::V2NIMMessageAttachmentUploadState(std::get<int>(iter->second));
    } else if (iter->first == flutter::EncodableValue("width")) {
      object->width = iter->second.LongValue();
    } else if (iter->first == flutter::EncodableValue("height")) {
      object->height = iter->second.LongValue();
    } else if (iter->first == flutter::EncodableValue("duration")) {
      object->duration = iter->second.LongValue();
    }
  }
  return object;
}

nstd::shared_ptr<v2::V2NIMMessageLocationAttachment>
getMessageLocationAttachment(const flutter::EncodableMap* arguments) {
  auto object = nstd::make_shared<v2::V2NIMMessageLocationAttachment>();
  auto iter = arguments->begin();
  for (; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("raw")) {
      object->raw = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("longitude")) {
      object->longitude = std::get<double>(iter->second);
    } else if (iter->first == flutter::EncodableValue("latitude")) {
      object->latitude = std::get<double>(iter->second);
    } else if (iter->first == flutter::EncodableValue("address")) {
      object->address = std::get<std::string>(iter->second);
    }
  }
  return object;
}

nstd::shared_ptr<v2::V2NIMMessageTeamNotificationAttachment>
getMessageNotificationAttachment(const flutter::EncodableMap* arguments) {
  auto object = nstd::make_shared<v2::V2NIMMessageTeamNotificationAttachment>();
  auto iter = arguments->begin();
  for (; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("raw")) {
      object->raw = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("type")) {
      object->type =
          v2::V2NIMMessageNotificationType(std::get<int>(iter->second));
    } else if (iter->first == flutter::EncodableValue("serverExtension")) {
      object->serverExtension = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("targetIds")) {
      std::vector<nstd::string> targetIds;
      auto targetIdList = std::get<flutter::EncodableList>(iter->second);
      for (auto& it : targetIdList) {
        auto targetId = std::get<std::string>(it);
        targetIds.emplace_back(targetId);
      }
      object->targetIds = targetIds;
    } else if (iter->first == flutter::EncodableValue("chatBanned")) {
      object->chatBanned = std::get<bool>(iter->second);
    } else if (iter->first == flutter::EncodableValue("updatedTeamInfo")) {
      auto updatedTeamInfoMap = std::get<flutter::EncodableMap>(iter->second);
      object->updatedTeamInfo = getUpdatedTeamInfo(&updatedTeamInfoMap);
    }
  }
  return object;
}

v2::V2NIMMessageCallDuration getMessageCallDuration(
    const flutter::EncodableMap* arguments) {
  v2::V2NIMMessageCallDuration object;
  auto iter = arguments->begin();
  for (; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("accountId")) {
      object.accountId = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("duration")) {
      object.duration = iter->second.LongValue();
    }
  }
  return object;
}

nstd::shared_ptr<v2::V2NIMMessageCallAttachment> getMessageCallAttachment(
    const flutter::EncodableMap* arguments) {
  auto object = nstd::make_shared<v2::V2NIMMessageCallAttachment>();
  auto iter = arguments->begin();
  for (; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("raw")) {
      object->raw = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("type")) {
      object->type = iter->second.LongValue();
    } else if (iter->first == flutter::EncodableValue("channelId")) {
      object->channelId = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("status")) {
      object->status = iter->second.LongValue();
    } else if (iter->first == flutter::EncodableValue("durations")) {
      std::vector<v2::V2NIMMessageCallDuration> durations;
      auto durationList = std::get<flutter::EncodableList>(iter->second);
      for (auto& it : durationList) {
        auto duration = std::get<flutter::EncodableMap>(it);
        durations.emplace_back(getMessageCallDuration(&duration));
      }
      object->durations = durations;
    }
  }
  return object;
}

v2::V2NIMMessageAIConfigParams getMessageAIConfigParams(
    const flutter::EncodableMap* arguments) {
  v2::V2NIMMessageAIConfigParams object;
  auto iter = arguments->begin();
  for (; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("accountId")) {
      object.accountId = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("aiStream")) {
      object.aiStream = std::get<bool>(iter->second);
    } else if (iter->first == flutter::EncodableValue("content")) {
      auto contentMap = std::get<flutter::EncodableMap>(iter->second);
      object.content = getAIModelCallContent(&contentMap);
    } else if (iter->first == flutter::EncodableValue("messages")) {
      std::vector<v2::V2NIMAIModelCallMessage> messages;
      auto messagesList = std::get<flutter::EncodableList>(iter->second);
      for (auto& it : messagesList) {
        auto messageMap = std::get<flutter::EncodableMap>(it);
        auto message = getAIModelCallMessage(&messageMap);
        messages.emplace_back(message);
      }
      object.messages = messages;
    } else if (iter->first == flutter::EncodableValue("promptVariables")) {
      object.promptVariables = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("modelConfigParams")) {
      auto modelConfigParamsMap = std::get<flutter::EncodableMap>(iter->second);
      object.modelConfigParams = getAIModelConfigParams(&modelConfigParamsMap);
    }
  }
  return object;
}

v2::V2NIMMessageTargetConfig getMessageTargetConfig(
    const flutter::EncodableMap* arguments) {
  v2::V2NIMMessageTargetConfig cofing;
  auto iter = arguments->begin();
  for (; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("receiverIds")) {
      std::vector<nstd::string> receiverIds;
      auto receiverIdList = std::get<flutter::EncodableList>(iter->second);
      for (auto& it : receiverIdList) {
        auto receiverId = std::get<std::string>(it);
        receiverIds.emplace_back(receiverId);
      }
      cofing.receiverIds = receiverIds;
    } else if (iter->first == flutter::EncodableValue("inclusive")) {
      cofing.inclusive = std::get<bool>(iter->second);
    } else if (iter->first == flutter::EncodableValue("newMemberVisible")) {
      cofing.newMemberVisible = std::get<bool>(iter->second);
    }
  }
  return cofing;
}

v2::V2NIMAIModelCallContent getAIModelCallContent(
    const flutter::EncodableMap* arguments) {
  v2::V2NIMAIModelCallContent object;
  auto iter = arguments->begin();
  for (; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("type")) {
      object.type = iter->second.LongValue();
    } else if (iter->first == flutter::EncodableValue("msg")) {
      object.msg = std::get<std::string>(iter->second);
    }
  }
  return object;
}

v2::V2NIMAIModelCallMessage getAIModelCallMessage(
    const flutter::EncodableMap* arguments) {
  v2::V2NIMAIModelCallMessage object;
  auto iter = arguments->begin();
  for (; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("role")) {
      object.role = v2::V2NIMAIModelRoleType(std::get<int>(iter->second));
    } else if (iter->first == flutter::EncodableValue("type")) {
      object.type = iter->second.LongValue();
    } else if (iter->first == flutter::EncodableValue("msg")) {
      object.msg = std::get<std::string>(iter->second);
    }
  }
  return object;
}

v2::V2NIMAIModelConfigParams getAIModelConfigParams(
    const flutter::EncodableMap* arguments) {
  v2::V2NIMAIModelConfigParams object;
  auto iter = arguments->begin();
  for (; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("prompt")) {
      object.prompt = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("maxTokens")) {
      object.maxTokens = std::get<std::int32_t>(iter->second);
    } else if (iter->first == flutter::EncodableValue("topP")) {
      object.topP = std::get<std::double_t>(iter->second);
    } else if (iter->first == flutter::EncodableValue("temperature")) {
      object.temperature = std::get<std::double_t>(iter->second);
    }
  }
  return object;
}

v2::V2NIMMessageAIRegenParams getMessageAIRegenParams(
    const flutter::EncodableMap* arguments) {
  v2::V2NIMMessageAIRegenParams object;
  auto iter = arguments->begin();
  for (; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("operationType")) {
      object.operationType =
          v2::V2NIMMessageAIRegenOpType(std::get<int>(iter->second));
    }
  }
  return object;
}

v2::V2NIMSendMessageParams getSendMessageParams(
    const flutter::EncodableMap* arguments) {
  v2::V2NIMSendMessageParams object;
  auto iter = arguments->begin();
  for (; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("messageConfig")) {
      auto messageConfigMap = std::get<flutter::EncodableMap>(iter->second);
      object.messageConfig = getMessageConfig(&messageConfigMap);
    } else if (iter->first == flutter::EncodableValue("routeConfig")) {
      auto routeConfigMap = std::get<flutter::EncodableMap>(iter->second);
      object.routeConfig = getMessageRouteConfig(&routeConfigMap);
    } else if (iter->first == flutter::EncodableValue("pushConfig")) {
      auto pushConfigMap = std::get<flutter::EncodableMap>(iter->second);
      object.pushConfig = getMessagePushConfig(&pushConfigMap);
    } else if (iter->first == flutter::EncodableValue("antispamConfig")) {
      auto antispamConfigMap = std::get<flutter::EncodableMap>(iter->second);
      object.antispamConfig = getMessageAntispamConfig(&antispamConfigMap);
    } else if (iter->first == flutter::EncodableValue("robotConfig")) {
      auto robotConfigMap = std::get<flutter::EncodableMap>(iter->second);
      object.robotConfig = getMessageRobotConfig(&robotConfigMap);
    } else if (iter->first == flutter::EncodableValue("aiConfig")) {
      auto aiConfigMap = std::get<flutter::EncodableMap>(iter->second);
      object.aiConfig = getMessageAIConfigParams(&aiConfigMap);
    } else if (iter->first ==
               flutter::EncodableValue("clientAntispamEnabled")) {
      object.clientAntispamEnabled = std::get<bool>(iter->second);
    } else if (iter->first ==
               flutter::EncodableValue("clientAntispamReplace")) {
      object.clientAntispamReplace = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("targetConfig")) {
      auto targetConfigMap = std::get<flutter::EncodableMap>(iter->second);
      object.targetConfig = getMessageTargetConfig(&targetConfigMap);
    }
  }
  return object;
}

v2::V2NIMSendMessageResult getSendMessageResult(
    const flutter::EncodableMap* arguments) {
  v2::V2NIMSendMessageResult object;
  auto iter = arguments->begin();
  for (; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("message")) {
      auto messageMap = std::get<flutter::EncodableMap>(iter->second);
      object.message = getMessage(&messageMap);
    } else if (iter->first == flutter::EncodableValue("antispamResult")) {
      object.antispamResult = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("clientAntispamResult")) {
      auto clientAntispamResultMap =
          std::get<flutter::EncodableMap>(iter->second);
      object.clientAntispamResult =
          getClientAntispamResult(&clientAntispamResultMap);
    }
  }
  return object;
}

v2::V2NIMClientAntispamResult getClientAntispamResult(
    const flutter::EncodableMap* arguments) {
  v2::V2NIMClientAntispamResult object;
  auto iter = arguments->begin();
  for (; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("operateType")) {
      object.operateType =
          v2::V2NIMClientAntispamOperateType(std::get<int>(iter->second));
    } else if (iter->first == flutter::EncodableValue("replacedText")) {
      object.replacedText = std::get<std::string>(iter->second);
    }
  }
  return object;
}

v2::V2NIMMessageListOption getMessageListOption(
    const flutter::EncodableMap* arguments) {
  v2::V2NIMMessageListOption object;
  auto iter = arguments->begin();
  for (; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("conversationId")) {
      object.conversationId = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("beginTime")) {
      object.beginTime = iter->second.LongValue();
    } else if (iter->first == flutter::EncodableValue("endTime")) {
      object.endTime = iter->second.LongValue();
    } else if (iter->first == flutter::EncodableValue("limit")) {
      object.limit = std::get<int32_t>(iter->second);
    } else if (iter->first == flutter::EncodableValue("reverse")) {
      object.reverse = std::get<bool>(iter->second);
    } else if (iter->first == flutter::EncodableValue("onlyQueryLocal")) {
      object.onlyQueryLocal = std::get<bool>(iter->second);
    } else if (iter->first == flutter::EncodableValue("direction")) {
      object.direction = v2::V2NIMQueryDirection(std::get<int>(iter->second));
    } else if (iter->first == flutter::EncodableValue("strictMode")) {
      object.strictMode = std::get<bool>(iter->second);
    } else if (iter->first == flutter::EncodableValue("messageTypes")) {
      std::vector<v2::V2NIMMessageType> messageTypes;
      auto messageTypeList = std::get<flutter::EncodableList>(iter->second);
      for (auto& it : messageTypeList) {
        auto messageType = std::get<int>(it);
        messageTypes.emplace_back(v2::V2NIMMessageType(messageType));
      }
      object.messageTypes = messageTypes;
    } else if (iter->first == flutter::EncodableValue("anchorMessage")) {
      auto anchorMessageMap = std::get<flutter::EncodableMap>(iter->second);
      object.anchorMessage = getMessage(&anchorMessageMap);
    }
  }
  return object;
}

v2::V2NIMClearHistoryMessageOption getClearHistoryMessageOption(
    const flutter::EncodableMap* arguments) {
  v2::V2NIMClearHistoryMessageOption object;
  auto iter = arguments->begin();
  for (; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("conversationId")) {
      object.conversationId = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("deleteRoam")) {
      object.deleteRoam = std::get<bool>(iter->second);
    } else if (iter->first == flutter::EncodableValue("onlineSync")) {
      object.onlineSync = std::get<bool>(iter->second);
    } else if (iter->first == flutter::EncodableValue("serverExtension")) {
      object.serverExtension = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("clearMode")) {
      object.clearMode = v2::V2NIMClearHistoryMode(std::get<int>(iter->second));
    }
  }
  return object;
}

v2::V2NIMMessageDeletedNotification getMessageDeletedNotification(
    const flutter::EncodableMap* arguments) {
  v2::V2NIMMessageDeletedNotification object;
  auto iter = arguments->begin();
  for (; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("messageRefer")) {
      auto messageReferMap = std::get<flutter::EncodableMap>(iter->second);
      object.messageRefer = getMessageRefer(&messageReferMap);
    } else if (iter->first == flutter::EncodableValue("deleteTime")) {
      object.deleteTime = iter->second.LongValue();
    } else if (iter->first == flutter::EncodableValue("serverExtension")) {
      object.serverExtension = std::get<std::string>(iter->second);
    }
  }
  return object;
}

v2::V2NIMMessagePin getMessagePin(const flutter::EncodableMap* arguments) {
  v2::V2NIMMessagePin object;
  auto iter = arguments->begin();
  for (; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("messageRefer")) {
      auto messageReferMap = std::get<flutter::EncodableMap>(iter->second);
      object.messageRefer = getMessageRefer(&messageReferMap);
    } else if (iter->first == flutter::EncodableValue("operatorId")) {
      object.operatorId = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("serverExtension")) {
      object.serverExtension = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("createTime")) {
      object.createTime = iter->second.LongValue();
    } else if (iter->first == flutter::EncodableValue("updateTime")) {
      object.updateTime = iter->second.LongValue();
    }
  }
  return object;
}

v2::V2NIMMessagePinNotification getMessagePinNotification(
    const flutter::EncodableMap* arguments) {
  v2::V2NIMMessagePinNotification object;
  auto iter = arguments->begin();
  for (; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("pin")) {
      auto pinMap = std::get<flutter::EncodableMap>(iter->second);
      object.pin = getMessagePin(&pinMap);
    } else if (iter->first == flutter::EncodableValue("pinState")) {
      object.pinState = v2::V2NIMMessagePinState(std::get<int>(iter->second));
    }
  }
  return object;
}

v2::V2NIMMessageQuickComment getMessageQuickComment(
    const flutter::EncodableMap* arguments) {
  v2::V2NIMMessageQuickComment object;
  auto iter = arguments->begin();
  for (; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("messageRefer")) {
      auto messageReferMap = std::get<flutter::EncodableMap>(iter->second);
      object.messageRefer = getMessageRefer(&messageReferMap);
    } else if (iter->first == flutter::EncodableValue("operatorId")) {
      object.operatorId = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("index")) {
      object.index = iter->second.LongValue();
    } else if (iter->first == flutter::EncodableValue("createTime")) {
      object.createTime = iter->second.LongValue();
    } else if (iter->first == flutter::EncodableValue("serverExtension")) {
      object.serverExtension = std::get<std::string>(iter->second);
    }
  }
  return object;
}

v2::V2NIMMessageQuickCommentNotification getMessageQuickCommentNotification(
    const flutter::EncodableMap* arguments) {
  v2::V2NIMMessageQuickCommentNotification object;
  auto iter = arguments->begin();
  for (; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("quickComment")) {
      auto quickCommentMap = std::get<flutter::EncodableMap>(iter->second);
      object.quickComment = getMessageQuickComment(&quickCommentMap);
    } else if (iter->first == flutter::EncodableValue("operationType")) {
      object.operationType =
          v2::V2NIMMessageQuickCommentType(std::get<int>(iter->second));
    }
  }
  return object;
}

v2::V2NIMMessageQuickCommentPushConfig getMessageQuickCommentPushConfig(
    const flutter::EncodableMap* arguments) {
  v2::V2NIMMessageQuickCommentPushConfig object;
  auto iter = arguments->begin();
  for (; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("pushEnabled")) {
      object.needPush = std::get<bool>(iter->second);
    } else if (iter->first == flutter::EncodableValue("needBadge")) {
      object.needBadge = std::get<bool>(iter->second);
    } else if (iter->first == flutter::EncodableValue("pushTitle")) {
      object.pushTitle = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("pushContent")) {
      object.pushContent = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("pushPayload")) {
      object.pushPayload = std::get<std::string>(iter->second);
    }
  }
  return object;
}

v2::V2NIMMessageRevokeNotification getMessageRevokeNotification(
    const flutter::EncodableMap* arguments) {
  v2::V2NIMMessageRevokeNotification object;
  auto iter = arguments->begin();
  for (; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("messageRefer")) {
      auto messageReferMap = std::get<flutter::EncodableMap>(iter->second);
      object.messageRefer = getMessageRefer(&messageReferMap);
    } else if (iter->first == flutter::EncodableValue("serverExtension")) {
      object.serverExtension = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("revokeAccountId")) {
      object.revokeAccountId = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("postscript")) {
      object.postscript = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("revokeType")) {
      object.revokeType =
          v2::V2NIMMessageRevokeType(std::get<int>(iter->second));
    } else if (iter->first == flutter::EncodableValue("callbackExtension")) {
      object.callbackExtension = std::get<std::string>(iter->second);
    }
  }
  return object;
}

v2::V2NIMMessageRevokeParams getMessageRevokeParams(
    const flutter::EncodableMap* arguments) {
  v2::V2NIMMessageRevokeParams object;
  auto iter = arguments->begin();
  for (; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("postscript")) {
      object.postscript = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("serverExtension")) {
      object.serverExtension = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("pushContent")) {
      object.pushContent = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("pushPayload")) {
      object.pushPayload = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("env")) {
      object.env = std::get<std::string>(iter->second);
    }
  }
  return object;
}

v2::V2NIMMessageSearchParams getMessageSearchParams(
    const flutter::EncodableMap* arguments) {
  v2::V2NIMMessageSearchParams object;
  auto iter = arguments->begin();
  for (; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("keyword")) {
      object.keyword = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("beginTime")) {
      object.beginTime = iter->second.LongValue();
    } else if (iter->first == flutter::EncodableValue("endTime")) {
      object.endTime = iter->second.LongValue();
    } else if (iter->first == flutter::EncodableValue("conversationLimit")) {
      object.conversationLimit = iter->second.LongValue();
    } else if (iter->first == flutter::EncodableValue("messageLimit")) {
      object.messageLimit = iter->second.LongValue();
    } else if (iter->first == flutter::EncodableValue("sortOrder")) {
      object.sortOrder = v2::V2NIMSortOrder(std::get<int>(iter->second));
    } else if (iter->first == flutter::EncodableValue("p2pAccountIds")) {
      std::vector<nstd::string> p2pAccountIds;
      auto p2pAccountIdList = std::get<flutter::EncodableList>(iter->second);
      for (auto& it : p2pAccountIdList) {
        auto p2pAccountId = std::get<std::string>(it);
        p2pAccountIds.emplace_back(p2pAccountId);
      }
      object.p2pAccountIds = p2pAccountIds;
    } else if (iter->first == flutter::EncodableValue("teamIds")) {
      std::vector<nstd::string> teamIds;
      auto teamIdList = std::get<flutter::EncodableList>(iter->second);
      for (auto& it : teamIdList) {
        auto teamId = std::get<std::string>(it);
        teamIds.emplace_back(teamId);
      }
      object.teamIds = teamIds;
    } else if (iter->first == flutter::EncodableValue("senderAccountIds")) {
      std::vector<nstd::string> senderAccountIds;
      auto senderAccountIdList = std::get<flutter::EncodableList>(iter->second);
      for (auto& it : senderAccountIdList) {
        auto senderAccountId = std::get<std::string>(it);
        senderAccountIds.emplace_back(senderAccountId);
      }
      object.senderAccountIds = senderAccountIds;
    } else if (iter->first == flutter::EncodableValue("messageTypes")) {
      std::vector<v2::V2NIMMessageType> messageTypes;
      auto messageTypesMap = std::get<flutter::EncodableList>(iter->second);
      for (auto& it : messageTypesMap) {
        auto messageType = std::get<int>(it);
        messageTypes.emplace_back(v2::V2NIMMessageType(messageType));
      }
      object.messageTypes = messageTypes;
    } else if (iter->first == flutter::EncodableValue("messageSubtypes")) {
      std::vector<uint32_t> messageSubtypes;
      auto messageSubtypeList = std::get<flutter::EncodableList>(iter->second);
      for (auto& it : messageSubtypeList) {
        auto messageSubtype = std::get<int32_t>(it);
        messageSubtypes.emplace_back(messageSubtype);
      }
      object.messageSubTypes = messageSubtypes;
    }
  }
  return object;
}

v2::V2NIMNotificationAntispamConfig getNotificationAntispamConfig(
    const flutter::EncodableMap* arguments) {
  v2::V2NIMNotificationAntispamConfig object;
  auto iter = arguments->begin();
  for (; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("antispamEnabled")) {
      object.antispamEnabled = std::get<bool>(iter->second);
    } else if (iter->first ==
               flutter::EncodableValue("antispamCustomNotification")) {
      object.antispamCustomMessage = std::get<std::string>(iter->second);
    }
  }
  return object;
}

v2::V2NIMNotificationConfig getNotificationConfig(
    const flutter::EncodableMap* arguments) {
  v2::V2NIMNotificationConfig object;
  auto iter = arguments->begin();
  for (; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("offlineEnabled")) {
      object.offlineEnabled = std::get<bool>(iter->second);
    } else if (iter->first == flutter::EncodableValue("unreadEnabled")) {
      object.unreadEnabled = std::get<bool>(iter->second);
    }
  }
  return object;
}

v2::V2NIMNotificationPushConfig getNotificationPushConfig(
    const flutter::EncodableMap* arguments) {
  v2::V2NIMNotificationPushConfig object;
  auto iter = arguments->begin();
  for (; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("pushEnabled")) {
      object.pushEnabled = std::get<bool>(iter->second);
    } else if (iter->first == flutter::EncodableValue("pushNickEnabled")) {
      object.pushNickEnabled = std::get<bool>(iter->second);
    } else if (iter->first == flutter::EncodableValue("pushContent")) {
      object.pushContent = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("pushPayload")) {
      object.pushPayload = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("forcePush")) {
      object.forcePush = std::get<bool>(iter->second);
    } else if (iter->first == flutter::EncodableValue("forcePushContent")) {
      object.forcePushContent = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("forcePushAccountIds")) {
      std::vector<nstd::string> forcePushAccountIds;
      auto forcePushAccountIdList =
          std::get<flutter::EncodableList>(iter->second);
      for (auto& it : forcePushAccountIdList) {
        auto forcePushAccountId = std::get<std::string>(it);
        forcePushAccountIds.emplace_back(forcePushAccountId);
      }
      object.forcePushAccountIds = forcePushAccountIds;
    }
  }
  return object;
}

v2::V2NIMNotificationRouteConfig getNotificationRouteConfig(
    const flutter::EncodableMap* arguments) {
  v2::V2NIMNotificationRouteConfig object;
  auto iter = arguments->begin();
  for (; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("routeEnabled")) {
      object.routeEnabled = std::get<bool>(iter->second);
    } else if (iter->first == flutter::EncodableValue("routeEnvironment")) {
      object.routeEnvironment = std::get<std::string>(iter->second);
    }
  }
  return object;
}

v2::V2NIMP2PMessageReadReceipt getP2PMessageReadReceipt(
    const flutter::EncodableMap* arguments) {
  v2::V2NIMP2PMessageReadReceipt object;
  auto iter = arguments->begin();
  for (; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("conversationId")) {
      object.conversationId = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("timestamp")) {
      object.timestamp = iter->second.LongValue();
    }
  }
  return object;
}

v2::V2NIMTeamMessageReadReceipt getTeamMessageReadReceipt(
    const flutter::EncodableMap* arguments) {
  v2::V2NIMTeamMessageReadReceipt object;
  auto iter = arguments->begin();
  for (; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("conversationId")) {
      object.conversationId = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("messageServerId")) {
      object.messageServerId = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("messageClientId")) {
      object.messageClientId = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("readCount")) {
      object.readCount = iter->second.LongValue();
    } else if (iter->first == flutter::EncodableValue("unreadCount")) {
      object.unreadCount = iter->second.LongValue();
    } else if (iter->first == flutter::EncodableValue("latestReadAccount")) {
      object.latestReadAccount = std::get<std::string>(iter->second);
    }
  }
  return object;
}

v2::V2NIMTeamMessageReadReceiptDetail getTeamMessageReadReceiptDetail(
    const flutter::EncodableMap* arguments) {
  v2::V2NIMTeamMessageReadReceiptDetail object;
  auto iter = arguments->begin();
  for (; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("readReceipt")) {
      auto readReceiptMap = std::get<flutter::EncodableMap>(iter->second);
      object.readReceipt = getTeamMessageReadReceipt(&readReceiptMap);
    } else if (iter->first == flutter::EncodableValue("readAccountList")) {
      std::vector<nstd::string> readAccountList;
      auto readAccountListMap = std::get<flutter::EncodableList>(iter->second);
      for (auto& it : readAccountListMap) {
        auto readAccount = std::get<std::string>(it);
        readAccountList.emplace_back(readAccount);
      }
      object.readAccountList = readAccountList;
    } else if (iter->first == flutter::EncodableValue("unreadAccountList")) {
      std::vector<nstd::string> unreadAccountList;
      auto unreadAccountListMap =
          std::get<flutter::EncodableList>(iter->second);
      for (auto& it : unreadAccountListMap) {
        auto unreadAccount = std::get<std::string>(it);
        unreadAccountList.emplace_back(unreadAccount);
      }
      object.unreadAccountList = unreadAccountList;
    }
  }
  return object;
}

v2::V2NIMThreadMessageListOption getThreadMessageListOption(
    const flutter::EncodableMap* arguments) {
  v2::V2NIMThreadMessageListOption object;
  auto iter = arguments->begin();
  for (; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("messageRefer")) {
      auto messageReferMap = std::get<flutter::EncodableMap>(iter->second);
      object.messageRefer = getMessageRefer(&messageReferMap);
    } else if (iter->first == flutter::EncodableValue("beginTime")) {
      object.beginTime = iter->second.LongValue();
    } else if (iter->first == flutter::EncodableValue("endTime")) {
      object.endTime = iter->second.LongValue();
    } else if (iter->first ==
               flutter::EncodableValue("excludeMessageServerId")) {
      object.excludeMessageServerId = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("limit")) {
      object.limit = static_cast<uint32_t>(std::get<int>(iter->second));
    } else if (iter->first == flutter::EncodableValue("direction")) {
      object.direction = v2::V2NIMQueryDirection(std::get<int>(iter->second));
    }
  }
  return object;
}

v2::V2NIMThreadMessageListResult getThreadMessageListResult(
    const flutter::EncodableMap* arguments) {
  v2::V2NIMThreadMessageListResult object;
  auto iter = arguments->begin();
  for (; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("message")) {
      auto messageMap = std::get<flutter::EncodableMap>(iter->second);
      object.message = getMessage(&messageMap);
    } else if (iter->first == flutter::EncodableValue("timestamp")) {
      object.timestamp = iter->second.LongValue();
    } else if (iter->first == flutter::EncodableValue("replyCount")) {
      object.replyCount = iter->second.LongValue();
    } else if (iter->first == flutter::EncodableValue("replyList")) {
      std::vector<v2::V2NIMMessage> replyList;
      auto replyListMap = std::get<flutter::EncodableList>(iter->second);
      for (auto& it : replyListMap) {
        auto reply = std::get<flutter::EncodableMap>(it);
        replyList.emplace_back(getMessage(&reply));
      }
      object.replyList = replyList;
    }
  }
  return object;
}

v2::V2NIMVoiceToTextParams getVoiceToTextParams(
    const flutter::EncodableMap* arguments) {
  v2::V2NIMVoiceToTextParams object;
  auto iter = arguments->begin();
  for (; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("voicePath")) {
      object.voicePath = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("voiceUrl")) {
      object.voiceUrl = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("mimeType")) {
      object.mimeType = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("sampleRate")) {
      object.sampleRate = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("duration")) {
      object.duration = iter->second.LongValue();
    } else if (iter->first == flutter::EncodableValue("sceneName")) {
      object.sceneName = std::get<std::string>(iter->second);
    }
  }
  return object;
}

v2::V2NIMCollection getCollection(const flutter::EncodableMap* arguments) {
  v2::V2NIMCollection object;
  auto iter = arguments->begin();
  for (; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("collectionId")) {
      object.collectionId = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("collectionType")) {
      object.collectionType = iter->second.LongValue();
    } else if (iter->first == flutter::EncodableValue("collectionData")) {
      object.collectionData = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("serverExtension")) {
      object.serverExtension = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("createTime")) {
      object.createTime = iter->second.LongValue();
    } else if (iter->first == flutter::EncodableValue("updateTime")) {
      object.updateTime = iter->second.LongValue();
    } else if (iter->first == flutter::EncodableValue("uniqueId")) {
      //   object.uniqueId = std::get<std::string>(iter->second);
    }
  }
  return object;
}

v2::V2NIMAddCollectionParams getAddCollectionParams(
    const flutter::EncodableMap* arguments) {
  v2::V2NIMAddCollectionParams object;
  auto iter = arguments->begin();
  for (; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("collectionType")) {
      object.collectionType = iter->second.LongValue();
    } else if (iter->first == flutter::EncodableValue("collectionData")) {
      object.collectionData = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("serverExtension")) {
      object.serverExtension = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("uniqueId")) {
      object.uniqueId = std::get<std::string>(iter->second);
    }
  }
  return object;
}

v2::V2NIMCollectionOption getCollectionOption(
    const flutter::EncodableMap* arguments) {
  v2::V2NIMCollectionOption object;
  auto iter = arguments->begin();
  for (; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("beginTime")) {
      object.beginTime = iter->second.LongValue();
    } else if (iter->first == flutter::EncodableValue("endTime")) {
      object.endTime = iter->second.LongValue();
    } else if (iter->first == flutter::EncodableValue("direction")) {
      object.direction = v2::V2NIMQueryDirection(std::get<int>(iter->second));
    } else if (iter->first == flutter::EncodableValue("anchorCollection")) {
      auto anchorCollectionMap = std::get<flutter::EncodableMap>(iter->second);
      object.anchorCollection = getCollection(&anchorCollectionMap);
    } else if (iter->first == flutter::EncodableValue("limit")) {
      object.limit = static_cast<uint32_t>(std::get<int>(iter->second));
    } else if (iter->first == flutter::EncodableValue("collectionType")) {
      object.collectionType = iter->second.LongValue();
    }
  }
  return object;
}

v2::V2NIMClearHistoryNotification getClearHistoryNotification(
    const flutter::EncodableMap* arguments) {
  v2::V2NIMClearHistoryNotification object;
  auto iter = arguments->begin();
  for (; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("conversationId")) {
      object.conversationId = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("deleteTime")) {
      object.deleteTime = iter->second.LongValue();
    } else if (iter->first == flutter::EncodableValue("serverExtension")) {
      object.serverExtension = std::get<std::string>(iter->second);
    }
  }
  return object;
}

v2::V2NIMUpdatedTeamInfo getUpdatedTeamInfo(
    const flutter::EncodableMap* arguments) {
  v2::V2NIMUpdatedTeamInfo object;
  auto iter = arguments->begin();
  for (; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("name")) {
      object.name = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("memberLimit")) {
      object.memberLimit = static_cast<uint32_t>(std::get<int>(iter->second));
    } else if (iter->first == flutter::EncodableValue("intro")) {
      object.intro = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("announcement")) {
      object.announcement = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("avatar")) {
      object.avatar = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("serverExtension")) {
      object.serverExtension = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("joinMode")) {
      object.joinMode = v2::V2NIMTeamJoinMode(std::get<int>(iter->second));
    } else if (iter->first == flutter::EncodableValue("agreeMode")) {
      object.agreeMode = v2::V2NIMTeamAgreeMode(std::get<int>(iter->second));
    } else if (iter->first == flutter::EncodableValue("inviteMode")) {
      object.inviteMode = v2::V2NIMTeamInviteMode(std::get<int>(iter->second));
    } else if (iter->first == flutter::EncodableValue("updateInfoMode")) {
      object.updateInfoMode =
          v2::V2NIMTeamUpdateInfoMode(std::get<int>(iter->second));
    } else if (iter->first == flutter::EncodableValue("updateExtensionMode")) {
      object.updateExtensionMode =
          v2::V2NIMTeamUpdateExtensionMode(std::get<int>(iter->second));
    } else if (iter->first == flutter::EncodableValue("chatBannedMode")) {
      object.chatBannedMode =
          v2::V2NIMTeamChatBannedMode(std::get<int>(iter->second));
    } else if (iter->first == flutter::EncodableValue("customerExtension")) {
      object.customerExtension = std::get<std::string>(iter->second);
    }
  }
  return object;
}

v2::V2NIMMessageSearchExParams getMessageSearchExParams(
    const flutter::EncodableMap* arguments) {
  v2::V2NIMMessageSearchExParams object;
  if (!arguments) {
    return object;
  }

  auto iter = arguments->begin();
  for (; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("conversationId")) {
      object.conversationId = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("keywordList")) {
      std::vector<nstd::string> keywordList;
      auto keywordListList = std::get<flutter::EncodableList>(iter->second);
      for (auto& it : keywordListList) {
        auto senderAccountId = std::get<std::string>(it);
        keywordList.emplace_back(senderAccountId);
      }
      object.keywordList = keywordList;
    } else if (iter->first == flutter::EncodableValue("keywordMatchType")) {
      object.keywordMatchType =
          v2::V2NIMSearchKeywordMathType(std::get<int>(iter->second));
    } else if (iter->first == flutter::EncodableValue("senderAccountIds")) {
      std::vector<nstd::string> senderAccountIds;
      auto senderAccountIdList = std::get<flutter::EncodableList>(iter->second);
      for (auto& it : senderAccountIdList) {
        auto senderAccountId = std::get<std::string>(it);
        senderAccountIds.emplace_back(senderAccountId);
      }
      object.senderAccountIds = senderAccountIds;
    } else if (iter->first == flutter::EncodableValue("messageTypes")) {
      std::vector<v2::V2NIMMessageType> messageTypes;
      auto messageTypesMap = std::get<flutter::EncodableList>(iter->second);
      for (auto& it : messageTypesMap) {
        auto messageType = std::get<int>(it);
        messageTypes.emplace_back(v2::V2NIMMessageType(messageType));
      }
      object.messageTypes = messageTypes;
    } else if (iter->first == flutter::EncodableValue("messageSubtypes")) {
      std::vector<int32_t> messageSubtypes;
      auto messageSubtypeList = std::get<flutter::EncodableList>(iter->second);
      for (auto& it : messageSubtypeList) {
        auto messageSubtype = std::get<int32_t>(it);
        messageSubtypes.emplace_back(messageSubtype);
      }
      object.messageSubtypes = messageSubtypes;
    } else if (iter->first == flutter::EncodableValue("searchStartTime")) {
      object.searchStartTime = iter->second.LongValue();
    } else if (iter->first == flutter::EncodableValue("searchTimePeriod")) {
      object.searchTimePeriod = iter->second.LongValue();
    } else if (iter->first == flutter::EncodableValue("direction")) {
      object.direction = v2::V2NIMSearchDirection(std::get<int>(iter->second));
    } else if (iter->first == flutter::EncodableValue("strategy")) {
      object.strategy = v2::V2NIMSearchStrategy(std::get<int>(iter->second));
    } else if (iter->first == flutter::EncodableValue("limit")) {
      object.limit = static_cast<uint32_t>(std::get<int32_t>(iter->second));
    } else if (iter->first == flutter::EncodableValue("pageToken")) {
      object.pageToken = std::get<std::string>(iter->second);
    }
  }
  return object;
}

void FLTMessageService::translateText(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  v2::V2NIMTextTranslateParams params;

  auto paramsIter = arguments->find(flutter::EncodableValue("params"));
  const flutter::EncodableMap* paramsMap = nullptr;
  if (paramsIter != arguments->end() && !paramsIter->second.IsNull()) {
    paramsMap = std::get_if<flutter::EncodableMap>(&paramsIter->second);
  } else {
    paramsMap = arguments;
  }

  if (paramsMap) {
    auto iter = paramsMap->begin();
    for (; iter != paramsMap->end(); ++iter) {
      if (iter->second.IsNull()) {
        continue;
      }
      if (iter->first == flutter::EncodableValue("text")) {
        params.text = std::get<std::string>(iter->second);
      } else if (iter->first == flutter::EncodableValue("sourceLanguage")) {
        params.sourceLanguage = std::get<std::string>(iter->second);
      } else if (iter->first == flutter::EncodableValue("targetLanguage")) {
        params.targetLanguage = std::get<std::string>(iter->second);
      }
    }
  }

  auto& instance = v2::V2NIMClient::get();
  auto& messageService = instance.getMessageService();
  messageService.translateText(
      params,
      [result](const v2::V2NIMTextTranslationResult& translationResult) {
        flutter::EncodableMap resultMap;
        resultMap.insert(
            std::make_pair("translatedText", translationResult.translatedText));
        resultMap.insert(
            std::make_pair("sourceLanguage", translationResult.sourceLanguage));
        resultMap.insert(
            std::make_pair("targetLanguage", translationResult.targetLanguage));
        result->Success(NimResult::getSuccessResult(resultMap));
      },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void FLTMessageService::stopAIStreamMessage(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  v2::V2NIMMessage message;
  v2::V2NIMMessageAIStreamStopParams params;

  auto iter = arguments->begin();
  for (; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("message")) {
      auto messageMap = std::get<flutter::EncodableMap>(iter->second);
      message = getMessage(&messageMap);
    } else if (iter->first == flutter::EncodableValue("params")) {
      auto paramsMap = std::get<flutter::EncodableMap>(iter->second);
      auto pIter = paramsMap.begin();
      for (; pIter != paramsMap.end(); ++pIter) {
        if (pIter->second.IsNull()) {
          continue;
        }
        if (pIter->first == flutter::EncodableValue("operationType")) {
          params.operationType =
              static_cast<v2::V2NIMMessageAIStreamStopOpType>(
                  std::get<int32_t>(pIter->second));
        } else if (pIter->first == flutter::EncodableValue("updateContent")) {
          params.updateContent = std::get<std::string>(pIter->second);
        }
      }
    }
  }

  auto& instance = v2::V2NIMClient::get();
  auto& messageService = instance.getMessageService();
  messageService.stopAIStreamMessage(
      message, params,
      [result]() { result->Success(NimResult::getSuccessResult()); },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void FLTMessageService::clearLocalMessage(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  v2::V2NIMClearLocalMessageParams params;

  if (arguments) {
    auto iter = arguments->find(flutter::EncodableValue("params"));
    if (iter != arguments->end() && !iter->second.IsNull()) {
      auto paramsMap = std::get<flutter::EncodableMap>(iter->second);
      auto pIter = paramsMap.begin();
      for (; pIter != paramsMap.end(); ++pIter) {
        if (pIter->second.IsNull()) {
          continue;
        }
        if (pIter->first == flutter::EncodableValue("anchorTime")) {
          params.anchorTime =
              static_cast<uint64_t>(std::get<int64_t>(pIter->second));
        } else if (pIter->first ==
                   flutter::EncodableValue("deleteConversation")) {
          params.deleteConversation = std::get<bool>(pIter->second);
        }
      }
    }
  }

  auto& instance = v2::V2NIMClient::get();
  auto& messageService = instance.getMessageService();
  messageService.clearLocalMessage(
      params, [result]() { result->Success(NimResult::getSuccessResult()); },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}
