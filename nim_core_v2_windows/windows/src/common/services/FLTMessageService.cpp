// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#include "FLTMessageService.h"

#include "../NimResult.h"
#include "nim_cpp_wrapper/nim_cpp_api.h"

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

  auto& client = v2::V2NIMClient::get();
  auto& messageService = client.getMessageService();

  messageService.addMessageListener(listener);
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
  for (iter; iter != arguments->end(); ++iter) {
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
  for (iter; iter != arguments->end(); ++iter) {
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
  for (iter; iter != arguments->end(); ++iter) {
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
  for (iter; iter != arguments->end(); ++iter) {
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
  for (iter; iter != arguments->end(); ++iter) {
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
  for (iter; iter != arguments->end(); ++iter) {
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
  bool onlyDeleteLocal;

  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
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
  bool onlyDeleteLocal;

  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
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
  for (iter; iter != arguments->end(); ++iter) {
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
  for (iter; iter != arguments->end(); ++iter) {
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
  uint64_t createTime;

  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
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

void FLTMessageService::pinMessage(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  v2::V2NIMMessage message;
  nstd::optional<nstd::string> serverExtension;

  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
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
  for (iter; iter != arguments->end(); ++iter) {
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
  for (iter; iter != arguments->end(); ++iter) {
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
  for (iter; iter != arguments->end(); ++iter) {
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
  for (iter; iter != arguments->end(); ++iter) {
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
  for (iter; iter != arguments->end(); ++iter) {
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
  for (iter; iter != arguments->end(); ++iter) {
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
  for (iter; iter != arguments->end(); ++iter) {
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
  for (iter; iter != arguments->end(); ++iter) {
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
  for (iter; iter != arguments->end(); ++iter) {
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
  for (iter; iter != arguments->end(); ++iter) {
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
  for (iter; iter != arguments->end(); ++iter) {
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
  for (iter; iter != arguments->end(); ++iter) {
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
  for (iter; iter != arguments->end(); ++iter) {
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
  for (iter; iter != arguments->end(); ++iter) {
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
  for (iter; iter != arguments->end(); ++iter) {
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
  for (iter; iter != arguments->end(); ++iter) {
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
  for (iter; iter != arguments->end(); ++iter) {
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
  for (iter; iter != arguments->end(); ++iter) {
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
  for (iter; iter != arguments->end(); ++iter) {
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
  for (iter; iter != arguments->end(); ++iter) {
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
  for (iter; iter != arguments->end(); ++iter) {
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
  resultMap.insert(std::make_pair("attachmentUploadState",
                                  object->attachmentUploadState.value()));
  if (object->sendingState.has_value()) {
    resultMap.insert(
        std::make_pair("sendingState", object->sendingState.value()));
  }
  resultMap.insert(std::make_pair("messageType", object->messageType));
  resultMap.insert(
      std::make_pair("subType", static_cast<int32_t>(object->subType)));
  resultMap.insert(std::make_pair("text", object->text));

  if (object->attachment) {
    flutter::EncodableMap attachment =
        convertMessageAttachment(object->attachment);
    resultMap.insert(std::make_pair("attachment", attachment));
  }

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

  if (object->aiConfig.has_value()) {
    flutter::EncodableMap aiConfig =
        convertMessageAIConfig(object->aiConfig.value());
    resultMap.insert(std::make_pair("aiConfig", aiConfig));
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
  return resultMap;
}

flutter::EncodableMap convertMessageRobotConfig(
    const v2::V2NIMMessageRobotConfig object) {
  flutter::EncodableMap resultMap;
  resultMap.insert(std::make_pair("accountId", object.accountId.value()));
  resultMap.insert(std::make_pair("topic", object.topic.value()));
  resultMap.insert(std::make_pair("function", object.function.value()));
  resultMap.insert(
      std::make_pair("customContent", object.customContent.value()));
  return resultMap;
}

flutter::EncodableMap convertMessageAntispamConfig(
    const v2::V2NIMMessageAntispamConfig object) {
  flutter::EncodableMap resultMap;
  resultMap.insert(std::make_pair("antispamEnabled", object.antispamEnabled));
  resultMap.insert(
      std::make_pair("antispamBusinessId", object.antispamBusinessId.value()));
  resultMap.insert(std::make_pair("antispamCustomMessage",
                                  object.antispamCustomMessage.value()));
  resultMap.insert(
      std::make_pair("antispamCheating", object.antispamCheating.value()));
  resultMap.insert(
      std::make_pair("antispamExtension", object.antispamExtension.value()));
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
  if (object->attachmentType) {
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
      default:
        break;
    }
  }
  resultMap.insert(std::make_pair("raw", object->raw));
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

  resultMap.insert(
      std::make_pair("promptVariables", object->promptVariables.value()));

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
  resultMap.insert(std::make_pair("prompt", object.prompt.value()));
  resultMap.insert(std::make_pair("maxTokens", object.maxTokens.value()));
  resultMap.insert(std::make_pair("topP", object.topP.value()));
  resultMap.insert(std::make_pair("temperature", object.temperature.value()));
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
  resultMap.insert(std::make_pair("deleteTime", long(object.deleteTime)));
  resultMap.insert(
      std::make_pair("serverExtension", object.serverExtension.value()));
  return resultMap;
}

flutter::EncodableMap convertUpdatedTeamInfo(
    const nstd::optional<v2::V2NIMUpdatedTeamInfo> object) {
  flutter::EncodableMap resultMap;
  resultMap.insert(std::make_pair("name", object->name.value()));
  if (object->memberLimit.has_value()) {
    resultMap.insert(std::make_pair(
        "memberLimit", static_cast<int64_t>(object->memberLimit.value())));
  }
  resultMap.insert(std::make_pair("intro", object->intro.value()));
  resultMap.insert(
      std::make_pair("announcement", object->announcement.value()));
  resultMap.insert(std::make_pair("avatar", object->avatar.value()));
  resultMap.insert(
      std::make_pair("serverExtension", object->serverExtension.value()));
  resultMap.insert(std::make_pair("joinMode", object->joinMode.value()));
  resultMap.insert(std::make_pair("agreeMode", object->agreeMode.value()));
  resultMap.insert(std::make_pair("inviteMode", object->inviteMode.value()));
  resultMap.insert(
      std::make_pair("updateInfoMode", object->updateInfoMode.value()));
  resultMap.insert(std::make_pair("updateExtensionMode",
                                  object->updateExtensionMode.value()));
  resultMap.insert(
      std::make_pair("chatBannedMode", object->chatBannedMode.value()));
  return resultMap;
}

v2::V2NIMMessageRefer getMessageRefer(const flutter::EncodableMap* arguments) {
  v2::V2NIMMessageRefer object;
  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
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

v2::V2NIMMessage getMessage(const flutter::EncodableMap* arguments) {
  v2::V2NIMMessage object;
  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
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
    } else if (iter->first == flutter::EncodableValue("aiConfig")) {
      auto aiConfigMap = std::get<flutter::EncodableMap>(iter->second);
      object.aiConfig = getMessageAIConfig(&aiConfigMap);
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
  for (iter; iter != arguments->end(); ++iter) {
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
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("aiStatus")) {
      object.aiStatus = v2::V2NIMMessageAIStatus(std::get<int>(iter->second));
    } else if (iter->first == flutter::EncodableValue("accountId")) {
      object.accountId = std::get<std::string>(iter->second);
    }
  }
  return object;
}

v2::V2NIMMessageRobotConfig getMessageRobotConfig(
    const flutter::EncodableMap* arguments) {
  v2::V2NIMMessageRobotConfig object;
  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
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
  for (iter; iter != arguments->end(); ++iter) {
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
  for (iter; iter != arguments->end(); ++iter) {
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
  for (iter; iter != arguments->end(); ++iter) {
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
  for (iter; iter != arguments->end(); ++iter) {
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
  for (iter; iter != arguments->end(); ++iter) {
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
  for (iter; iter != arguments->end(); ++iter) {
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
  for (iter; iter != arguments->end(); ++iter) {
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
  for (iter; iter != arguments->end(); ++iter) {
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
  for (iter; iter != arguments->end(); ++iter) {
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
  for (iter; iter != arguments->end(); ++iter) {
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
  for (iter; iter != arguments->end(); ++iter) {
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
  for (iter; iter != arguments->end(); ++iter) {
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
  for (iter; iter != arguments->end(); ++iter) {
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
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("accountId")) {
      object.accountId = std::get<std::string>(iter->second);
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
    }
  }
  return object;
}

v2::V2NIMAIModelCallContent getAIModelCallContent(
    const flutter::EncodableMap* arguments) {
  v2::V2NIMAIModelCallContent object;
  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
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
  for (iter; iter != arguments->end(); ++iter) {
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
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("prompt")) {
      object.prompt = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("maxTokens")) {
      object.maxTokens = iter->second.LongValue();
    } else if (iter->first == flutter::EncodableValue("topP")) {
      object.topP = std::get<std::double_t>(iter->second);
    } else if (iter->first == flutter::EncodableValue("temperature")) {
      object.temperature = std::get<std::double_t>(iter->second);
    }
  }
  return object;
}

v2::V2NIMSendMessageParams getSendMessageParams(
    const flutter::EncodableMap* arguments) {
  v2::V2NIMSendMessageParams object;
  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
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
    }
  }
  return object;
}

v2::V2NIMSendMessageResult getSendMessageResult(
    const flutter::EncodableMap* arguments) {
  v2::V2NIMSendMessageResult object;
  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
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
  for (iter; iter != arguments->end(); ++iter) {
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
  for (iter; iter != arguments->end(); ++iter) {
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
  for (iter; iter != arguments->end(); ++iter) {
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
    }
  }
  return object;
}

v2::V2NIMMessageDeletedNotification getMessageDeletedNotification(
    const flutter::EncodableMap* arguments) {
  v2::V2NIMMessageDeletedNotification object;
  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
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
  for (iter; iter != arguments->end(); ++iter) {
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
  for (iter; iter != arguments->end(); ++iter) {
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
  for (iter; iter != arguments->end(); ++iter) {
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
  for (iter; iter != arguments->end(); ++iter) {
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
  for (iter; iter != arguments->end(); ++iter) {
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
  for (iter; iter != arguments->end(); ++iter) {
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
  for (iter; iter != arguments->end(); ++iter) {
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
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("keyword")) {
      object.keyword = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("beginTime")) {
      object.beginTime = iter->second.LongValue();
    } else if (iter->first == flutter::EncodableValue("endTime")) {
      object.endTime = iter->second.LongValue();
      ;
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
      std::vector<int64_t> messageSubtypes;
      auto messageSubtypeList = std::get<flutter::EncodableList>(iter->second);
      for (auto& it : messageSubtypeList) {
        auto messageSubtype = it.LongValue();
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
  for (iter; iter != arguments->end(); ++iter) {
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
  for (iter; iter != arguments->end(); ++iter) {
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
  for (iter; iter != arguments->end(); ++iter) {
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
  for (iter; iter != arguments->end(); ++iter) {
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
  for (iter; iter != arguments->end(); ++iter) {
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
  for (iter; iter != arguments->end(); ++iter) {
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
  for (iter; iter != arguments->end(); ++iter) {
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
  for (iter; iter != arguments->end(); ++iter) {
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
      object.limit = iter->second.LongValue();
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
  for (iter; iter != arguments->end(); ++iter) {
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
  for (iter; iter != arguments->end(); ++iter) {
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
  for (iter; iter != arguments->end(); ++iter) {
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
  for (iter; iter != arguments->end(); ++iter) {
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
      //   object.uniqueId = std::get<std::string>(iter->second);
    }
  }
  return object;
}

v2::V2NIMCollectionOption getCollectionOption(
    const flutter::EncodableMap* arguments) {
  v2::V2NIMCollectionOption object;
  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
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
      object.limit = iter->second.LongValue();
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
  for (iter; iter != arguments->end(); ++iter) {
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
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("name")) {
      object.name = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("memberLimit")) {
      object.memberLimit = iter->second.LongValue();
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
    }
  }
  return object;
}
