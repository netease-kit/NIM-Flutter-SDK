// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#include "FLTSystemNotificationService.h"

#include "../FLTConvert.h"

FLTSystemNotificationService::FLTSystemNotificationService() {
  m_serviceName = "SystemMessageService";
  nim::SystemMsg::RegSendCustomSysmsgCb(
      std::bind(&FLTSystemNotificationService::sendCustomSysmsgCallback, this,
                std::placeholders::_1));
  nim::SystemMsg::RegSysmsgCb(
      std::bind(&FLTSystemNotificationService::receiveSysmsgCallback, this,
                std::placeholders::_1));
}

FLTSystemNotificationService::~FLTSystemNotificationService() {
  nim::SystemMsg::UnregSysmsgCb();
}

void FLTSystemNotificationService::onMethodCalled(
    const std::string& method, const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (method == "querySystemMessagesIOSAndDesktop") {
    querySystemMessagesIOSAndDesktop(arguments, result);
  } else if (method == "querySystemMessageByTypeIOSAndDesktop") {
    querySystemMessageByTypeIOSAndDesktop(arguments, result);
  } else if (method == "querySystemMessageUnreadCount") {
    querySystemMessageUnreadCount(result);
  } else if (method == "resetSystemMessageUnreadCount") {
    resetSystemMessageUnreadCount(result);
  } else if (method == "setSystemMessageStatus") {
    setSystemMessageStatus(arguments, result);
  } else if (method == "setSystemMessageRead") {
    setSystemMessageRead(arguments, result);
  } else if (method == "deleteSystemMessage") {
    deleteSystemMessage(arguments, result);
  } else if (method == "clearSystemMessages") {
    clearSystemMessages(result);
  } else if (method == "clearSystemMessagesByType") {
    clearSystemMessagesByType(arguments, result);
  } else if (method == "sendCustomNotification") {
    sendCustomNotification(arguments, result);
  } else {
    result->NotImplemented();
  }
}

void FLTSystemNotificationService::querySystemMessagesIOSAndDesktop(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  int limit = 0;
  auto iter = arguments->find(flutter::EncodableValue("limit"));
  if (iter != arguments->end()) {
    if (iter->second.IsNull()) {
      result->Error(
          "", "",
          NimResult::getErrorResult(
              -1,
              "querySystemMessagesIOSAndDesktop params error, limit is empty"));
      return;
    }

    limit = std::get<int>(iter->second);
  }

  int64_t lastTime = 0;
  iter = arguments->find(flutter::EncodableValue("systemMessage"));
  if (iter != arguments->end()) {
    if (iter->second.IsNull()) {
      result->Error(
          "", "",
          NimResult::getErrorResult(-1,
                                    "querySystemMessagesIOSAndDesktop params "
                                    "error, systemMessage is empty"));
      return;
    }

    auto messageMap = std::get<flutter::EncodableMap>(iter->second);
    auto messageMapIter = messageMap.find(flutter::EncodableValue("time"));
    if (messageMapIter != arguments->end()) {
      if (messageMapIter->second.IsNull()) {
        result->Error(
            "", "",
            NimResult::getErrorResult(-1,
                                      "querySystemMessagesIOSAndDesktop params "
                                      "error, systemMessage time is empty"));
        return;
      }
      lastTime = messageMapIter->second.LongValue();
    }
  }

  bool res = nim::SystemMsg::QueryMsgAsync(
      limit, lastTime,
      [=](int, int, const std::list<nim::SysMessage>& msgList) {
        flutter::EncodableMap arguments;
        flutter::EncodableList msgList_;
        for (auto msg : msgList) {
          flutter::EncodableMap msg_;
          msg_.insert(std::make_pair("messageId", msg.id_));
          msg_.insert(
              std::make_pair("type", convertSysMsgTypeToString(msg.type_)));
          msg_.insert(std::make_pair("fromAccount", msg.sender_accid_));
          msg_.insert(std::make_pair("targetId", msg.receiver_accid_));
          msg_.insert(
              std::make_pair("time", static_cast<int64_t>(msg.timetag_)));
          msg_.insert(std::make_pair("status",
                                     convertSysMsgStatusToString(msg.status_)));
          msg_.insert(std::make_pair("content", msg.content_));
          msg_.insert(std::make_pair("attach", msg.attach_));
          msg_.insert(std::make_pair("unread",
                                     msg.status_ == nim::kNIMSysMsgStatusNone));
          msg_.insert(std::make_pair("customInfo", msg.callbac_ext_));

          msgList_.emplace_back(msg_);
        }

        arguments.insert(std::make_pair("systemMessageList", msgList_));
        result->Success(NimResult::getSuccessResult(arguments));
      });

  if (!res) {
    result->Error("", "",
                  NimResult::getErrorResult(
                      -1, "querySystemMessagesIOSAndDesktop failed"));
  }
}

void FLTSystemNotificationService::querySystemMessageByTypeIOSAndDesktop(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  int limit = 0;
  auto iter = arguments->find(flutter::EncodableValue("limit"));
  if (iter != arguments->end()) {
    if (iter->second.IsNull()) {
      result->Error(
          "", "",
          NimResult::getErrorResult(-1,
                                    "querySystemMessageByTypeIOSAndDesktop "
                                    "params error, limit is empty"));
      return;
    }

    limit = std::get<int>(iter->second);
  }

  int64_t lastTime = 0;
  iter = arguments->find(flutter::EncodableValue("systemMessage"));
  if (iter != arguments->end()) {
    if (iter->second.IsNull()) {
      result->Error(
          "", "",
          NimResult::getErrorResult(-1,
                                    "querySystemMessageByTypeIOSAndDesktop "
                                    "params error, systemMessage is empty"));
      return;
    }

    auto messageMap = std::get<flutter::EncodableMap>(iter->second);
    auto messageMapIter = messageMap.find(flutter::EncodableValue("time"));
    if (messageMapIter != arguments->end()) {
      if (messageMapIter->second.IsNull()) {
        result->Error("", "",
                      NimResult::getErrorResult(
                          -1,
                          "querySystemMessageByTypeIOSAndDesktop params error, "
                          "systemMessage time is empty"));
        return;
      }
      lastTime = messageMapIter->second.LongValue();
    }
  }

  std::vector<nim::NIMSysMsgType> vecMessageType;
  iter = arguments->find(flutter::EncodableValue("systemMessageTypeList"));
  if (iter != arguments->end()) {
    if (iter->second.IsNull()) {
      result->Error("", "",
                    NimResult::getErrorResult(
                        -1,
                        "querySystemMessageByTypeIOSAndDesktop params error, "
                        "systemMessageTypeList is empty"));
      return;
    }

    flutter::EncodableList typeList =
        std::get<flutter::EncodableList>(iter->second);
    for (auto type : typeList) {
      std::string strType = std::get<std::string>(type);
      vecMessageType.emplace_back(convertStringToSysMsgType(strType));
    }
  }

  bool res = nim::SystemMsg::QueryMsgAsync(
      limit, lastTime,
      [=](int, int, const std::list<nim::SysMessage>& msgList) {
        flutter::EncodableMap arguments;
        flutter::EncodableList msgList_;
        for (auto msg : msgList) {
          auto iter = std::find(vecMessageType.begin(), vecMessageType.end(),
                                msg.type_);
          if (iter != vecMessageType.end()) {
            flutter::EncodableMap msg_;
            msg_.insert(std::make_pair("messageId", msg.id_));
            msg_.insert(
                std::make_pair("type", convertSysMsgTypeToString(msg.type_)));
            msg_.insert(std::make_pair("fromAccount", msg.sender_accid_));
            msg_.insert(std::make_pair("targetId", msg.receiver_accid_));
            msg_.insert(
                std::make_pair("time", static_cast<int64_t>(msg.timetag_)));
            msg_.insert(std::make_pair(
                "status", convertSysMsgStatusToString(msg.status_)));
            msg_.insert(std::make_pair("content", msg.content_));
            msg_.insert(std::make_pair("attach", msg.attach_));
            msg_.insert(std::make_pair(
                "unread", msg.status_ == nim::kNIMSysMsgStatusNone));
            msg_.insert(std::make_pair("customInfo", msg.callbac_ext_));

            msgList_.emplace_back(msg_);
          }
        }

        arguments.insert(std::make_pair("systemMessageList", msgList_));
        result->Success(NimResult::getSuccessResult(arguments));
      });

  if (!res) {
    result->Error("", "",
                  NimResult::getErrorResult(-1, "querySystemMessageByType"));
  }
}

void FLTSystemNotificationService::querySystemMessageUnreadCount(
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  nim::SystemMsg::QueryUnreadCount([=](nim::NIMResCode res_code,
                                       int unread_count) {
    if (res_code == nim::kNIMResSuccess) {
      result->Success(
          NimResult::getSuccessResult(flutter::EncodableValue(unread_count)));
    } else {
      result->Error("", "",
                    NimResult::getErrorResult(
                        res_code, "querySystemMessageUnreadCount failed"));
    }
  });
}

void FLTSystemNotificationService::setSystemMessageRead(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  uint64_t id = 0;
  auto iter = arguments->find(EncodableValue("messageId"));
  if (iter != arguments->end()) {
    if (iter->second.IsNull()) {
      result->Error(
          "", "",
          NimResult::getErrorResult(-1, "setSystemMessageRead params error"));
      return;
    }

    id = iter->second.LongValue();
  }

  bool res = nim::SystemMsg::SetStatusAsync(
      id, nim::kNIMSysMsgStatusRead, [=](nim::NIMResCode code, int64_t, int) {
        if (code == nim::kNIMResSuccess) {
          result->Success(NimResult::getSuccessResult());
        } else {
          result->Error(
              "", "",
              NimResult::getErrorResult(code, "setSystemMessageRead failed"));
        }
      });

  if (!res) {
    result->Error("", "",
                  NimResult::getErrorResult(-1, "setSystemMessageRead failed"));
  }
}

void FLTSystemNotificationService::setSystemMessageStatus(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  uint64_t id = 0;
  auto iter = arguments->find(EncodableValue("messageId"));
  if (iter != arguments->end()) {
    if (iter->second.IsNull()) {
      result->Error(
          "", "",
          NimResult::getErrorResult(-1, "setSystemMessageStatus params error"));
      return;
    }

    id = iter->second.LongValue();
  }

  nim::NIMSysMsgStatus status = nim::kNIMSysMsgStatusNone;
  iter = arguments->find(EncodableValue("systemMessageStatus"));
  if (iter != arguments->end()) {
    if (iter->second.IsNull()) {
      result->Error(
          "", "",
          NimResult::getErrorResult(-1, "setSystemMessageStatus params error"));
      return;
    }

    status = convertStringToSysMsgStatus(std::get<std::string>(iter->second));
  }

  bool res = nim::SystemMsg::SetStatusAsync(
      id, status, [=](nim::NIMResCode code, int64_t, int) {
        if (code == nim::kNIMResSuccess) {
          result->Success(NimResult::getSuccessResult());
        } else {
          result->Error(
              "", "",
              NimResult::getErrorResult(code, "setSystemMessageStatus failed"));
        }
      });

  if (!res) {
    result->Error(
        "", "", NimResult::getErrorResult(-1, "setSystemMessageStatus failed"));
  }
}

void FLTSystemNotificationService::resetSystemMessageUnreadCount(
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  nim::SystemMsg::ReadAllAsync([=](nim::NIMResCode res_code, int unread_count) {
    if (res_code == nim::kNIMResSuccess) {
      result->Success(NimResult::getSuccessResult());
    } else {
      result->Error("", "",
                    NimResult::getErrorResult(
                        res_code, "resetSystemMessageUnreadCount failed"));
    }
  });
}

void FLTSystemNotificationService::deleteSystemMessage(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  uint64_t id = 0;
  auto iter = arguments->find(EncodableValue("messageId"));
  if (iter != arguments->end()) {
    if (iter->second.IsNull()) {
      result->Error("", "", NimResult::getErrorResult(-1, "params error"));
      return;
    }

    id = iter->second.LongValue();
  }

  bool res =
      nim::SystemMsg::DeleteAsync(id, [=](nim::NIMResCode code, int64_t, int) {
        if (code == nim::kNIMResSuccess) {
          result->Success(NimResult::getSuccessResult());
        } else {
          result->Error(
              "", "",
              NimResult::getErrorResult(code, "deleteSystemMessage failed"));
        }
      });

  if (!res) {
    result->Error("", "",
                  NimResult::getErrorResult(-1, "deleteSystemMessage failed"));
  }
}

void FLTSystemNotificationService::clearSystemMessages(
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  nim::SystemMsg::DeleteAllAsync([=](nim::NIMResCode res_code,
                                     int unread_count) {
    if (res_code == nim::kNIMResSuccess) {
      result->Success(NimResult::getSuccessResult());
    } else {
      result->Error(
          "", "",
          NimResult::getErrorResult(res_code, "clearSystemMessages failed"));
    }
  });
}

void FLTSystemNotificationService::clearSystemMessagesByType(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  result->NotImplemented();
}

void FLTSystemNotificationService::sendCustomNotification(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  std::string receiver_id = "";
  nim::NIMSysMsgType type = nim::kNIMSysMsgTypeCustomP2PMsg;
  std::string client_msg_id = nim::Tool::GetUuid();
  std::string content;
  nim::SysMessageSetting msg_setting;
  int64_t timetag = 0;

  flutter::EncodableMap arguments_;
  auto iter = arguments->find(EncodableValue("customNotification"));
  if (iter != arguments->end()) {
    if (iter->second.IsNull()) {
      result->Error("", "", NimResult::getErrorResult(-1, "params error"));
      return;
    }

    arguments_ = std::get<flutter::EncodableMap>(iter->second);
  }

  auto iter2 = arguments_.begin();
  for (iter2; iter2 != arguments_.end(); ++iter2) {
    if (iter2->second.IsNull()) {
      continue;
    }

    if (iter2->first == flutter::EncodableValue("sessionId")) {
      receiver_id =
          std::get<std::string>(iter2->second);  // 不确定字段含义是否一致
    } else if (iter2->first == flutter::EncodableValue("sessionType")) {
      std::string session_type = std::get<std::string>(iter2->second);
      if (session_type == "p2p") {
        type = nim::kNIMSysMsgTypeCustomP2PMsg;
      } else if (session_type == "team") {
        type = nim::kNIMSysMsgTypeCustomTeamMsg;
      }
      // 发送消息时不需要fromAccount
    } else if (iter2->first == flutter::EncodableValue("fromAccount")) {
      // receiver_id = std::get<std::string>(iter2->second);
    } else if (iter2->first == flutter::EncodableValue("time")) {
      timetag = std::get<int64_t>(iter2->second);
    } else if (iter2->first == flutter::EncodableValue("content")) {
      content = std::get<std::string>(iter2->second);
    } else if (iter2->first ==
               flutter::EncodableValue("sendToOnlineUserOnly")) {
      msg_setting.need_offline_ =
          std::get<bool>(iter2->second) ? BS_FALSE : BS_TRUE;
    } else if (iter2->first == flutter::EncodableValue("apnsText")) {
      // 不支持
    } else if (iter2->first == flutter::EncodableValue("pushPayload")) {
      auto pushPayload = std::get<flutter::EncodableMap>(iter2->second);
      nim_cpp_wrapper_util::Json::Value push_payload;
      if (Convert::getInstance()->convertMap2Json(&pushPayload, push_payload)) {
        msg_setting.push_payload_ = push_payload;
      }
    } else if (iter2->first == flutter::EncodableValue("config")) {
      auto config = std::get<flutter::EncodableMap>(iter2->second);
      auto config_iter = config.begin();
      for (config_iter; config_iter != config.end(); ++config_iter) {
        if (config_iter->second.IsNull()) {
          continue;
        }
        if (config_iter->first == flutter::EncodableValue("enablePush")) {
          msg_setting.need_push_ =
              std::get<bool>(config_iter->second) ? BS_TRUE : BS_FALSE;
        } else if (config_iter->first ==
                   flutter::EncodableValue("enablePushNick")) {
          msg_setting.push_need_prefix_ =
              std::get<bool>(config_iter->second) ? BS_TRUE : BS_FALSE;
        } else if (config_iter->first ==
                   flutter::EncodableValue("enableUnreadCount")) {
          msg_setting.push_need_badge_ =
              std::get<bool>(config_iter->second) ? BS_TRUE : BS_FALSE;
        }
      }
    } else if (iter2->first == flutter::EncodableValue("antiSpamOption")) {
      auto antiSpamOption = std::get<flutter::EncodableMap>(iter2->second);
      auto antiSpamOption_iter = antiSpamOption.begin();
      for (antiSpamOption_iter; antiSpamOption_iter != antiSpamOption.end();
           ++antiSpamOption_iter) {
        if (antiSpamOption_iter->second.IsNull()) {
          continue;
        }
        if (antiSpamOption_iter->first == flutter::EncodableValue("enable")) {
          msg_setting.anti_spam_enable_ =
              std::get<bool>(antiSpamOption_iter->second) ? BS_TRUE : BS_FALSE;
        } else if (antiSpamOption_iter->first ==
                   flutter::EncodableValue("content")) {
          msg_setting.anti_spam_content_ =
              std::get<std::string>(antiSpamOption_iter->second);
        } else if (antiSpamOption_iter->first ==
                   flutter::EncodableValue("antiSpamConfigId")) {
          // 不支持
        }
      }
    } else if (iter2->first == flutter::EncodableValue("env")) {
      msg_setting.env_config_ = std::get<std::string>(iter2->second);
    }
  }

  std::string strMessage = nim::SystemMsg::CreateCustomNotificationMsg(
      receiver_id, type, client_msg_id, content, msg_setting, timetag);
  nim::SystemMsg::SendCustomNotificationMsg(strMessage);
  result->Success(NimResult::getSuccessResult());
}

void FLTSystemNotificationService::sendCustomSysmsgCallback(
    const nim::SendMessageArc& arc) {
  flutter::EncodableMap arguments;
  arguments.insert(std::make_pair("messageId", arc.talk_id_));
  arguments.insert(std::make_pair("time", arc.msg_timetag_));
  notifyEvent("onReceiveSystemMsg", arguments);
}

void FLTSystemNotificationService::receiveSysmsgCallback(
    const nim::SysMessage& msg) {
  flutter::EncodableMap arguments;

  if (msg.type_ == nim::kNIMSysMsgTypeCustomP2PMsg ||
      msg.type_ == nim::kNIMSysMsgTypeCustomTeamMsg) {
    arguments.insert(std::make_pair("sessionId", std::to_string(msg.id_)));
    if (msg.type_ == nim::kNIMSysMsgTypeCustomP2PMsg) {
      arguments.insert(std::make_pair("sessionType", "p2p"));
    } else {
      arguments.insert(std::make_pair("sessionType", "team"));
    }

    arguments.insert(std::make_pair("fromAccount", msg.sender_accid_));
    arguments.insert(std::make_pair("time", msg.timetag_));
    arguments.insert(std::make_pair("content", msg.attach_));
    arguments.insert(
        std::make_pair("apnsText", msg.msg_setting_.push_content_));
    notifyEvent("onCustomNotification", arguments);
  } else {
    arguments.insert(std::make_pair("messageId", msg.id_));
    arguments.insert(
        std::make_pair("type", convertSysMsgTypeToString(msg.type_)));
    arguments.insert(std::make_pair("fromAccount", msg.sender_accid_));
    arguments.insert(std::make_pair("targetId", msg.receiver_accid_));
    arguments.insert(std::make_pair("time", msg.timetag_));
    arguments.insert(
        std::make_pair("status", convertSysMsgStatusToString(msg.status_)));
    arguments.insert(std::make_pair("content", msg.content_));
    arguments.insert(
        std::make_pair("unread", msg.status_ == nim::kNIMSysMsgStatusNone));
    arguments.insert(std::make_pair("customInfo", msg.callbac_ext_));
    notifyEvent("onReceiveSystemMsg", arguments);
  }
}

std::string FLTSystemNotificationService::convertSysMsgTypeToString(
    nim::NIMSysMsgType type) {
  std::string strType = "";
  Convert::getInstance()->convertNIMEnumToDartString(
      type, Convert::getInstance()->getSysMsgType(), strType);
  return strType;
}

nim::NIMSysMsgType FLTSystemNotificationService::convertStringToSysMsgType(
    const std::string& value) {
  nim::NIMSysMsgType type;
  Convert::getInstance()->convertDartStringToNIMEnum(
      value, Convert::getInstance()->getSysMsgType(), type);
  return type;
}

std::string FLTSystemNotificationService::convertSysMsgStatusToString(
    nim::NIMSysMsgStatus type) {
  std::string strStatus = "";
  Convert::getInstance()->convertNIMEnumToDartString(
      type, Convert::getInstance()->getsysMsgStatus(), strStatus);
  return strStatus;
}

nim::NIMSysMsgStatus FLTSystemNotificationService::convertStringToSysMsgStatus(
    const std::string& value) {
  nim::NIMSysMsgStatus status;
  Convert::getInstance()->convertDartStringToNIMEnum(
      value, Convert::getInstance()->getsysMsgStatus(), status);
  return status;
}

// onUnreadCountChange 不支持