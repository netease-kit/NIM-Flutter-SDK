// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#include "FLTMessageService.h"

#include "../FLTConvert.h"

FLTMessageService::FLTMessageService() {
  m_serviceName = "MessageService";

  nim::Talk::RegSendMsgCb(std::bind(&FLTMessageService::SendMessageCB, this,
                                    std::placeholders::_1));
  nim::Talk::RegReceiveCb(
      std::bind(&FLTMessageService::ReceiveCB, this, std::placeholders::_1));
  nim::Talk::RegReceiveMessagesCb(std::bind(
      &FLTMessageService::ReceiveMessagesCB, this, std::placeholders::_1));
  nim::Talk::RegReceiveBroadcastMsgCb(std::bind(
      &FLTMessageService::ReceiveBroadcastMsgCB, this, std::placeholders::_1));
  nim::Talk::RegRecallMsgsCallback(std::bind(&FLTMessageService::RecallMsgsCB,
                                             this, std::placeholders::_1,
                                             std::placeholders::_2));
  nim::MsgLog::RegMessageStatusChangedCb(std::bind(
      &FLTMessageService::MessageStatusChangedCB, this, std::placeholders::_1));
  // nim::Team::RegTeamEventCb(std::bind(&FLTMessageService::TeamEventCB, this,
  // std::placeholders::_1));
  nim::Session::RegChangeCb(
      std::bind(&FLTMessageService::ChangeCB, this, std::placeholders::_1,
                std::placeholders::_2, std::placeholders::_3));
  nim::Session::RegSetToStickTopSessionNotifyCB(
      std::bind(&FLTMessageService::SetToStickTopSessionNotifyCB, this,
                std::placeholders::_1));
  nim::Session::RegCancelStickTopSessionNotifyCB(
      std::bind(&FLTMessageService::CancelStickTopSessionNotifyCB, this,
                std::placeholders::_1, std::placeholders::_2));
  nim::Session::RegUpdateStickTopSessionNotifyCB(
      std::bind(&FLTMessageService::UpdateStickTopSessionNotifyCB, this,
                std::placeholders::_1));
  nim::SessionOnLineService::RegSessionChanged(std::bind(
      &FLTMessageService::SessionChangedCB, this, std::placeholders::_1));

  nim::TalkEx::PinMsg::RegAddPinMessage(std::bind(
      &FLTMessageService::AddPinMessageNotifyCB, this, std::placeholders::_1,
      std::placeholders::_2, std::placeholders::_3));
  nim::TalkEx::PinMsg::RegUnPinMessage(std::bind(
      &FLTMessageService::UnPinMessageNotifyCB, this, std::placeholders::_1,
      std::placeholders::_2, std::placeholders::_3));
  nim::TalkEx::PinMsg::RegUpdatePinMessage(std::bind(
      &FLTMessageService::UpdatePinMessageNotifyCB, this, std::placeholders::_1,
      std::placeholders::_2, std::placeholders::_3));
  nim::TalkEx::QuickComment::RegAddQuickCommentNotify(std::bind(
      &FLTMessageService::AddQuickCommentNotifyCB, this, std::placeholders::_1,
      std::placeholders::_2, std::placeholders::_3, std::placeholders::_4));
  nim::TalkEx::QuickComment::RegRemoveQuickCommentNotify(std::bind(
      &FLTMessageService::RemoveQuickCommentNotifyCB, this,
      std::placeholders::_1, std::placeholders::_2, std::placeholders::_3,
      std::placeholders::_4, std::placeholders::_5));
}

FLTMessageService::~FLTMessageService() {
  nim::Talk::UnregTalkCb();
  nim::MsgLog::UnregMsglogCb();
  // nim::Team::UnregTeamCb();
  nim::Session::UnregSessionCb();
  nim::SessionOnLineService::UnregSessionOnLineServiceCb();
  nim::TalkEx::PinMsg::UnregAllCb();
}

void FLTMessageService::onMethodCalled(
    const std::string& method, const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  switch (utils::hash_(method.c_str())) {
    case "sendMessage"_hash:
      sendMessage(arguments, result);
      return;
    case "sendMessageReceipt"_hash:
      sendMessageReceipt(arguments, result);
      return;
    case "sendTeamMessageReceipt"_hash:
      sendTeamMessageReceipt(arguments, result);
      return;
    case "refreshTeamMessageReceipt"_hash:
      refreshTeamMessageReceipt(arguments, result);
      return;
    case "fetchTeamMessageReceiptDetail"_hash:
      fetchTeamMessageReceiptDetail(arguments, result);
      return;
    case "queryTeamMessageReceiptDetail"_hash:
      queryTeamMessageReceiptDetail(arguments, result);
      return;
    case "saveMessage"_hash:
      saveMessage(arguments, result);
      return;
    case "updateMessage"_hash:
      updateMessage(arguments, result);
      return;
    case "forwardMessage"_hash:
      forwardMessage(arguments, result);
      return;
    case "voiceToText"_hash:
      voiceToText(arguments, result);
      return;
    case "createMessage"_hash:
      createMessage(arguments, result);
      return;
    case "queryMessageList"_hash:
      queryMessageList(arguments, result);
      return;
    case "queryMessageListEx"_hash:
      queryMessageListEx(arguments, result);
      return;
    case "queryLastMessage"_hash:
      queryLastMessage(arguments, result);
      return;
    case "queryMessageListByUuid"_hash:
      queryMessageListByUuid(arguments, result);
      return;
    case "deleteChattingHistory"_hash:
      deleteChattingHistory(arguments, result);
      return;
    case "deleteChattingHistoryList"_hash:
      // deleteChattingHistoryList(arguments, result);
      // return;
      break;
    case "clearChattingHistory"_hash:
      clearChattingHistory(arguments, result);
      return;
    case "clearMsgDatabase"_hash:
      clearMsgDatabase(arguments, result);
      return;
    case "pullMessageHistoryExType"_hash:
      pullMessageHistoryExType(arguments, result);
      return;
    case "pullMessageHistory"_hash:
      pullMessageHistory(arguments, result);
      return;
    case "clearServerHistory"_hash:
      clearServerHistory(arguments, result);
      return;
    case "deleteMsgSelf"_hash:
      deleteMsgSelf(arguments, result);
      return;
    case "deleteMsgListSelf"_hash:
      deleteMsgListSelf(arguments, result);
      return;
    case "searchMessage"_hash:
      searchMessage(arguments, result);
      return;
    case "searchAllMessage"_hash:
      searchAllMessage(arguments, result);
      return;
    case "searchRoamingMsg"_hash:
      searchRoamingMsg(arguments, result);
      return;
    case "searchCloudMessageHistory"_hash:
      searchCloudMessageHistory(arguments, result);
      return;
    case "downloadAttachment"_hash:
      downloadAttachment(arguments, result);
      return;
    case "cancelUploadAttachment"_hash:
      cancelUploadAttachment(arguments, result);
      return;
    case "revokeMessage"_hash:
      revokeMessage(arguments, result);
      return;
    case "replyMessage"_hash:
      replyMessage(arguments, result);
      return;
    case "queryReplyCountInThreadTalkBlock"_hash:
      queryReplyCountInThreadTalkBlock(arguments, result);
      return;
    case "queryThreadTalkHistory"_hash:
      queryThreadTalkHistory(arguments, result);
      return;
    case "querySessionList"_hash:
      querySessionList(arguments, result);
      return;
    case "querySessionListFiltered"_hash:
      querySessionListFiltered(arguments, result);
      return;
    case "querySession"_hash:
      querySession(arguments, result);
      return;
    case "createSession"_hash:
      // createSession(arguments, result);
      // return;
      break;
    case "updateSession"_hash:
      // updateSession(arguments, result);
      // return;
      break;
    case "updateSessionWithMessage"_hash:
      // updateSessionWithMessage(arguments, result);
      // return;
      break;
    case "queryTotalUnreadCount"_hash:
      queryTotalUnreadCount(arguments, result);
      return;
    case "setChattingAccount"_hash:
      // setChattingAccount(arguments, result);
      // return;
      break;
    case "clearSessionUnreadCount"_hash:
      clearSessionUnreadCount(arguments, result);
      return;
    case "deleteSession"_hash:
      deleteSession(arguments, result);
      return;
    case "checkLocalAntiSpam"_hash:
      checkLocalAntiSpam(arguments, result);
      return;
    case "queryMySessionList"_hash:
      queryMySessionList(arguments, result);
      return;
    case "queryMySession"_hash:
      queryMySession(arguments, result);
      return;
    case "updateMySession"_hash:
      updateMySession(arguments, result);
      return;
    case "deleteMySession"_hash:
      deleteMySession(arguments, result);
      return;
    case "addQuickComment"_hash:
      addQuickComment(arguments, result);
      return;
    case "removeQuickComment"_hash:
      removeQuickComment(arguments, result);
      return;
    case "queryQuickComment"_hash:
      queryQuickComment(arguments, result);
      return;
    case "addCollect"_hash:
      addCollect(arguments, result);
      return;
    case "removeCollect"_hash:
      removeCollect(arguments, result);
      return;
    case "updateCollect"_hash:
      updateCollect(arguments, result);
      return;
    case "queryCollect"_hash:
      queryCollect(arguments, result);
      return;
    case "addMessagePin"_hash:
      addMessagePin(arguments, result);
      return;
    case "updateMessagePin"_hash:
      updateMessagePin(arguments, result);
      return;
    case "removeMessagePin"_hash:
      removeMessagePin(arguments, result);
      return;
    case "queryMessagePinForSession"_hash:
      queryMessagePinForSession(arguments, result);
      return;
    case "addStickTopSession"_hash:
      addStickTopSession(arguments, result);
      return;
    case "removeStickTopSession"_hash:
      removeStickTopSession(arguments, result);
      return;
    case "updateStickTopSession"_hash:
      updateStickTopSession(arguments, result);
      return;
    case "queryStickTopSession"_hash:
      queryStickTopSession(arguments, result);
      return;
    case "clearAllSessionUnreadCount"_hash:
      clearAllSessionUnreadCount(arguments, result);
      return;
    default:
      break;
  }
  if (result) result->NotImplemented();
}

void FLTMessageService::sendMessage(const flutter::EncodableMap* arguments,
                                    FLTService::MethodResult result) {
  nim::IMMessage imMessage;
  std::string imMessageJson;
  if (!Convert::getInstance()->convert2IMMessage(arguments, imMessage,
                                                 imMessageJson)) {
    if (result) {
      result->Error(
          "", "",
          NimResult::getErrorResult(-1, "sendMessage but message error!"));
    }
    return;
  }

  nim::Talk::FileUpPrgCallback* pFileUpPrgCallback =
      new nim::Talk::FileUpPrgCallback(
          std::bind(&FLTMessageService::SendMessageAttachmentProgress, this,
                    imMessage.client_msg_id_, std::placeholders::_1,
                    std::placeholders::_2));
  if (pFileUpPrgCallback) {
    std::lock_guard<std::recursive_mutex> lockGuard(m_mutexSendMsgResult);
    m_mapSendMsgResult[imMessage.client_msg_id_] = SendMsgResult();
    m_mapSendMsgResult[imMessage.client_msg_id_].pFileUpPrgCallback =
        pFileUpPrgCallback;
    m_mapSendMsgResult[imMessage.client_msg_id_].imMessage = imMessage;
    if (result) {
      m_mapSendMsgResult[imMessage.client_msg_id_].methodResult = result;
    }
  }
  nim::Talk::SendMsg(imMessageJson, "", pFileUpPrgCallback);
  imMessage.status_ = nim::kNIMMsgLogStatusSending;
  flutter::EncodableMap ret;
  if (!Convert::getInstance()->convertIMMessage2Map(ret, imMessage)) {
    YXLOG(Info) << "convertIMMessage2Map failed." << YXLOGEnd;
  } else {
    notifyEvent("onMessageStatus", ret);
  }
}

void FLTMessageService::sendMessageReceipt(
    const flutter::EncodableMap* arguments, FLTService::MethodResult result) {
  nim::IMMessage imMessage;
  std::string imMessageJson;
  if (!Convert::getInstance()->convert2IMMessage(arguments, imMessage,
                                                 imMessageJson)) {
    if (result) {
      result->Error("", "",
                    NimResult::getErrorResult(
                        -1, "sendMessageReceipt but message error!"));
    }
    return;
  }

  auto sessionIdIt = arguments->find(flutter::EncodableValue("sessionId"));
  if (sessionIdIt != arguments->end() && !sessionIdIt->second.IsNull()) {
    auto sessionId = std::get<std::string>(sessionIdIt->second);
    if (!sessionId.empty() && sessionId != imMessage.receiver_accid_) {
      imMessage.receiver_accid_ = sessionId;
    }
  }

  if (imMessage.receiver_accid_.empty()) {
    if (result) {
      result->Error("", "",
                    NimResult::getErrorResult(
                        -1, "sendMessageReceipt but sessionId is null!"));
    }
    return;
  }

  nim::MsgLog::SendReceiptAsync(
      imMessage.ToJsonString(true),
      [result](const nim::MessageStatusChangedResult& ret) {
        if (!result) {
          return;
        }

        if (nim::kNIMResSuccess == ret.rescode_) {
          result->Success(NimResult::getSuccessResult());
        } else {
          result->Error("", "",
                        NimResult::getErrorResult(
                            ret.rescode_, "send sendMessageReceipt failed!"));
        }
      });
}

void FLTMessageService::sendTeamMessageReceipt(
    const flutter::EncodableMap* arguments, FLTService::MethodResult result) {
  nim::IMMessage imMessage;
  std::string imMessageJson;
  if (!Convert::getInstance()->convert2IMMessage(arguments, imMessage,
                                                 imMessageJson)) {
    if (result) {
      result->Error("", "",
                    NimResult::getErrorResult(
                        -1, "sendTeamMessageReceipt but message error!"));
    }
    return;
  }

  nim::Team::TeamMsgAckRead(
      imMessage.receiver_accid_, std::list<nim::IMMessage>{imMessage},
      [result](const nim::TeamEvent& ret) {
        if (!result) {
          return;
        }

        if (nim::kNIMResSuccess == ret.res_code_) {
          result->Success(NimResult::getSuccessResult());
        } else {
          result->Error("", "",
                        NimResult::getErrorResult(
                            ret.res_code_, "sendTeamMessageReceipt failed!"));
        }
      });
}

void FLTMessageService::refreshTeamMessageReceipt(
    const flutter::EncodableMap* arguments, FLTService::MethodResult result) {
  flutter::EncodableList messageListTmp;
  auto messageListIt = arguments->find(flutter::EncodableValue("messageList"));
  if (messageListIt != arguments->end() && !messageListIt->second.IsNull()) {
    messageListTmp = std::get<flutter::EncodableList>(messageListIt->second);
  }
  if (messageListTmp.empty()) {
    if (result) {
      result->Error(
          "", "",
          NimResult::getErrorResult(
              -1, "refreshTeamMessageReceipt but messageList error!"));
    }
    return;
  }
  for (auto& it : messageListTmp) {
    flutter::EncodableMap messageMapTmp = std::get<flutter::EncodableMap>(it);
    nim::IMMessage imMessage;
    std::string imMessageJson;
    if (!Convert::getInstance()->convert2IMMessage(&messageMapTmp, imMessage,
                                                   imMessageJson)) {
      if (result) {
        result->Error(
            "", "",
            NimResult::getErrorResult(
                -1, "refreshTeamMessageReceipt but messageList error!"));
      }
    } else {
      nim::Team::TeamMsgQueryUnreadList(
          imMessage.receiver_accid_, imMessage,
          [result](const nim::TeamEvent& ret) {
            if (!result) {
              return;
            }

            if (nim::kNIMResSuccess == ret.res_code_) {
              result->Success(NimResult::getSuccessResult());
            } else {
              result->Error(
                  "", "",
                  NimResult::getErrorResult(
                      ret.res_code_, "refreshTeamMessageReceipt failed!"));
            }
          });
    }
    // wjzh 不支持列表，只取列表第一个
    break;
  }
}

void FLTMessageService::fetchTeamMessageReceiptDetail(
    const flutter::EncodableMap* arguments, FLTService::MethodResult result) {
  std::list<std::string> accids;
  auto accountListIt = arguments->find(flutter::EncodableValue("accountList"));
  if (accountListIt != arguments->end() && !accountListIt->second.IsNull()) {
    flutter::EncodableList accountListTmp =
        std::get<flutter::EncodableList>(accountListIt->second);
    for (auto& it : accountListTmp) {
      accids.emplace_back(std::get<std::string>(it));
    }
  }
  nim::IMMessage imMessage;
  std::string imMessageJson;
  if (!Convert::getInstance()->convert2IMMessage(arguments, imMessage,
                                                 imMessageJson)) {
    if (result) {
      result->Error("", "",
                    NimResult::getErrorResult(
                        -1, "fetchTeamMessageReceiptDetail failed!"));
    }
  } else {
    nim::Team::TeamMsgQueryUnreadList(
        imMessage.receiver_accid_, imMessage, accids,
        [result](const nim::TeamEvent& ret) {
          if (!result) {
            return;
          }

          if (nim::kNIMResSuccess == ret.res_code_) {
            flutter::EncodableMap retMap;
            retMap[flutter::EncodableValue("teamId")] = ret.team_id_;
            if (nim::kNIMNotificationIdLocalGetTeamMsgUnreadList ==
                ret.notification_id_) {
              if (ret.src_data_.isMember("client_msg_id")) {
                retMap[flutter::EncodableValue("msgId")] =
                    ret.src_data_["client_msg_id"].asString();
              }
              if (ret.src_data_.isMember("read")) {
                flutter::EncodableList listTmp;
                if (Convert::getInstance()->convertJson2List(
                        listTmp, ret.src_data_["read"])) {
                  retMap[flutter::EncodableValue("ackAccountList")] = listTmp;
                } else {
                  // wjzh
                }
              }
              if (ret.src_data_.isMember("unread")) {
                flutter::EncodableList listTmp;
                if (Convert::getInstance()->convertJson2List(
                        listTmp, ret.src_data_["unread"])) {
                  retMap[flutter::EncodableValue("unAckAccountList")] = listTmp;
                } else {
                  // wjzh
                }
              }
            } else {
              // wjzh
              return;
            }
            result->Success(NimResult::getSuccessResult(retMap));
          } else {
            result->Error(
                "", "",
                NimResult::getErrorResult(
                    ret.res_code_, "fetchTeamMessageReceiptDetail failed!"));
          }
        });
  }
}

void FLTMessageService::queryTeamMessageReceiptDetail(
    const flutter::EncodableMap* arguments, FLTService::MethodResult result) {
  std::list<std::string> accids;
  auto accountListIt = arguments->find(flutter::EncodableValue("accountList"));
  if (accountListIt != arguments->end() && !accountListIt->second.IsNull()) {
    flutter::EncodableList accountListTmp =
        std::get<flutter::EncodableList>(accountListIt->second);
    for (auto& it : accountListTmp) {
      accids.emplace_back(std::get<std::string>(it));
    }
  }
  nim::IMMessage imMessage;
  std::string imMessageJson;
  if (!Convert::getInstance()->convert2IMMessage(arguments, imMessage,
                                                 imMessageJson)) {
    if (result) {
      result->Error("", "",
                    NimResult::getErrorResult(
                        -1, "queryTeamMessageReceiptDetail failed!"));
    }
  } else {
    nim::Team::TeamMsgQueryUnreadList(
        imMessage.receiver_accid_, imMessage, accids,
        [result](const nim::TeamEvent& ret) {
          if (!result) {
            return;
          }

          if (nim::kNIMResSuccess == ret.res_code_) {
            flutter::EncodableMap retMap;
            retMap[flutter::EncodableValue("teamId")] = ret.team_id_;
            if (nim::kNIMNotificationIdLocalGetTeamMsgUnreadList ==
                ret.notification_id_) {
              if (ret.src_data_.isMember("client_msg_id")) {
                retMap[flutter::EncodableValue("msgId")] =
                    ret.src_data_["client_msg_id"].asString();
              }
              if (ret.src_data_.isMember("read")) {
                flutter::EncodableList listTmp;
                if (Convert::getInstance()->convertJson2List(
                        listTmp, ret.src_data_["read"])) {
                  retMap[flutter::EncodableValue("ackAccountList")] = listTmp;
                } else {
                  // wjzh
                }
              }
              if (ret.src_data_.isMember("unread")) {
                flutter::EncodableList listTmp;
                if (Convert::getInstance()->convertJson2List(
                        listTmp, ret.src_data_["unread"])) {
                  retMap[flutter::EncodableValue("unAckAccountList")] = listTmp;
                } else {
                  // wjzh
                }
              }
            } else {
              // wjzh
              return;
            }
            result->Success(NimResult::getSuccessResult(retMap));
          } else {
            result->Error(
                "", "",
                NimResult::getErrorResult(
                    ret.res_code_, "queryTeamMessageReceiptDetail failed!"));
          }
        });
  }
}

void FLTMessageService::saveMessage(const flutter::EncodableMap* arguments,
                                    FLTService::MethodResult result) {
  std::string fromAccount;
  auto fromAccountIt = arguments->find(flutter::EncodableValue("fromAccount"));
  if (fromAccountIt != arguments->end() && !fromAccountIt->second.IsNull()) {
    fromAccount = std::get<std::string>(fromAccountIt->second);
  }
  if (fromAccount.empty()) {
    if (result) {
      result->Error(
          "", "",
          NimResult::getErrorResult(-1, "saveMessage but fromAccount error!"));
    }
    return;
  }

  nim::IMMessage imMessage;
  std::string imMessageJson;
  if (!Convert::getInstance()->convert2IMMessage(arguments, imMessage,
                                                 imMessageJson)) {
    if (result) {
      result->Error(
          "", "",
          NimResult::getErrorResult(-1, "saveMessage but message error!"));
    }
  } else {
    if (!nim::MsgLog::WriteMsglogToLocalAsync(
            fromAccount, imMessage,
            BS_TRUE == imMessage.msg_setting_.is_update_session_,
            [result, imMessage](nim::NIMResCode res_code,
                                const std::string& msg_id) {
              if (!result) {
                return;
              }

              if (nim::kNIMResSuccess == res_code) {
                flutter::EncodableMap ret;
                Convert::getInstance()->convertIMMessage2Map(ret, imMessage);
                result->Success(NimResult::getSuccessResult(ret));
              } else {
                result->Error("", "",
                              NimResult::getErrorResult(
                                  res_code, "save message failed!"));
              }
            })) {
      if (result) {
        result->Error("", "",
                      NimResult::getErrorResult(-1, "save message error!"));
      }
    }
  }
}

void FLTMessageService::updateMessage(const flutter::EncodableMap* arguments,
                                      FLTService::MethodResult result) {
  nim::IMMessage imMessage;
  std::string imMessageJson;
  if (!Convert::getInstance()->convert2IMMessage(arguments, imMessage,
                                                 imMessageJson)) {
    if (result) {
      result->Error(
          "", "",
          NimResult::getErrorResult(-1, "updateMessage but message error!"));
    }
  } else {
    if (!nim::MsgLog::WriteMsglogToLocalAsync(
            imMessage.sender_accid_, imMessage,
            BS_TRUE == imMessage.msg_setting_.is_update_session_,
            [result, imMessage](nim::NIMResCode res_code,
                                const std::string& msg_id) {
              if (!result) {
                return;
              }

              if (nim::kNIMResSuccess == res_code) {
                flutter::EncodableMap ret;
                Convert::getInstance()->convertIMMessage2Map(ret, imMessage);
                result->Success(NimResult::getSuccessResult(ret));
              } else {
                result->Error("", "",
                              NimResult::getErrorResult(
                                  res_code, "updateMessage message failed!"));
              }
            })) {
      if (result) {
        result->Error(
            "", "",
            NimResult::getErrorResult(-1, "updateMessage message error!"));
      }
    }
  }
}

void FLTMessageService::forwardMessage(const flutter::EncodableMap* arguments,
                                       FLTService::MethodResult result) {
  nim::IMMessage imMessage;
  std::string imMessageJson;
  if (!Convert::getInstance()->convert2IMMessage(arguments, imMessage,
                                                 imMessageJson)) {
    if (result) {
      result->Error(
          "", "",
          NimResult::getErrorResult(-1, "forwardMessage but message error!"));
    }
    return;
  }

  std::string sessionId;
  auto sessionIdIt = arguments->find(flutter::EncodableValue("sessionId"));
  if (sessionIdIt != arguments->end() && !sessionIdIt->second.IsNull()) {
    sessionId = std::get<std::string>(sessionIdIt->second);
  }

  if (sessionId.empty()) {
    if (result) {
      result->Error(
          "", "",
          NimResult::getErrorResult(-1, "forwardMessage but sessionId error!"));
    }
    return;
  }

  nim::NIMSessionType sessionType = nim::kNIMSessionTypeP2P;
  if (!Convert::getInstance()->convertSessionType(arguments, sessionType)) {
    if (result) {
      result->Error("", "",
                    NimResult::getErrorResult(
                        -1, "forwardMessage but sessionType error!"));
    }
    return;
  }

  std::string uuid = Convert::getInstance()->getUUID();
  std::string newImMessageJson = nim::Talk::CreateRetweetMessage(
      imMessageJson, uuid, sessionType, sessionId, nim::MessageSetting());

  nim::IMMessage newImMessage;
  if (!nim::Talk::ParseIMMessage(newImMessageJson, newImMessage)) {
    if (result) {
      result->Error(
          "", "",
          NimResult::getErrorResult(-1, "forwardMessage but message error!"));
    }
    return;
  }

  // 转发消息生成后发送给目标用户
  nim::Talk::FileUpPrgCallback* pFileUpPrgCallback =
      new nim::Talk::FileUpPrgCallback(
          std::bind(&FLTMessageService::SendMessageAttachmentProgress, this,
                    newImMessage.client_msg_id_, std::placeholders::_1,
                    std::placeholders::_2));
  if (pFileUpPrgCallback) {
    std::lock_guard<std::recursive_mutex> lockGuard(m_mutexSendMsgResult);
    m_mapSendMsgResult[newImMessage.client_msg_id_] = SendMsgResult();
    m_mapSendMsgResult[newImMessage.client_msg_id_].pFileUpPrgCallback =
        pFileUpPrgCallback;
    m_mapSendMsgResult[newImMessage.client_msg_id_].imMessage = newImMessage;
    if (result) {
      m_mapSendMsgResult[newImMessage.client_msg_id_].methodResult = result;
    }
  }
  nim::Talk::SendMsg(newImMessageJson, "", pFileUpPrgCallback);
  newImMessage.status_ = nim::kNIMMsgLogStatusSending;
  flutter::EncodableMap ret;
  if (!Convert::getInstance()->convertIMMessage2Map(ret, newImMessage)) {
    if (result) {
      result->Error("", "",
                    NimResult::getErrorResult(
                        -1, "forwardMessage but new message error!"));
    }
    return;
  } else {
    notifyEvent("onMessageStatus", ret);
  }
}

void FLTMessageService::voiceToText(const flutter::EncodableMap* arguments,
                                    FLTService::MethodResult result) {
  nim::IMMessage imMessage;
  std::string imMessageJson;
  if (!Convert::getInstance()->convert2IMMessage(arguments, imMessage,
                                                 imMessageJson)) {
    if (result) {
      result->Error(
          "", "",
          NimResult::getErrorResult(-1, "forwardMessage but message error!"));
    }
    return;
  }

  nim::IMAudio audio;
  if (!nim::Talk::ParseAudioMessageAttach(imMessage, audio)) {
    if (result) {
      result->Error(
          "", "",
          NimResult::getErrorResult(-1, "voiceToText but message error!"));
    }
    return;
  }

  nim::AudioInfo audioInfo;
  audioInfo.duration_ = audio.duration_;
  auto sampleRate = arguments->find(flutter::EncodableValue("sampleRate"));
  if (sampleRate != arguments->end() && !sampleRate->second.IsNull()) {
    audioInfo.samplerate_ = std::get<std::string>(sampleRate->second);
  }

  auto mimeType = arguments->find(flutter::EncodableValue("mimeType"));
  if (mimeType != arguments->end() && !mimeType->second.IsNull()) {
    audioInfo.mime_type_ = std::get<std::string>(mimeType->second);
  }
  audioInfo.url_ = audio.url_;
  if (!nim::Tool::GetAudioTextAsync(
          audioInfo, [result](int rescode, const std::string& text) {
            if (!result) {
              return;
            }

            if (nim::kNIMResSuccess == rescode) {
              result->Success(NimResult::getSuccessResult(text));
            } else {
              result->Error(
                  "", "",
                  NimResult::getErrorResult(rescode, "voiceToText failed!"));
            }
          })) {
    if (result) {
      result->Error("", "",
                    NimResult::getErrorResult(-1, "voiceToText error!"));
    }
  }
}

void FLTMessageService::createMessage(const flutter::EncodableMap* arguments,
                                      FLTService::MethodResult result) {
  nim::IMMessage imMessage;
  std::string imMessageJson;
  if (!Convert::getInstance()->convert2IMMessage(arguments, imMessage,
                                                 imMessageJson)) {
    if (result) {
      result->Error("", "",
                    NimResult::getErrorResult(-1, "create message failed!"));
    }
    return;
  }

  flutter::EncodableMap ret;
  if (!Convert::getInstance()->convertIMMessage2Map(ret, imMessage)) {
    if (result) {
      result->Error("", "",
                    NimResult::getErrorResult(-1, "create message error!"));
    }
    return;
  }

  if (result) {
    result->Success(NimResult::getSuccessResult(ret));
  }
}

void FLTMessageService::queryMessageList(const flutter::EncodableMap* arguments,
                                         FLTService::MethodResult result) {
  nim::NIMSessionType sessionType = nim::kNIMSessionTypeP2P;
  if (!Convert::getInstance()->convertSessionType(arguments, sessionType)) {
    if (result) {
      result->Error("", "",
                    NimResult::getErrorResult(
                        -1, "queryMessageList but sessionType error!"));
    }
    return;
  }

  std::string accountId;
  auto accountIt = arguments->find(flutter::EncodableValue("account"));
  if (accountIt != arguments->end() && !accountIt->second.IsNull()) {
    accountId = std::get<std::string>(accountIt->second);
  }

  int limit = 100;
  auto limitIt = arguments->find(flutter::EncodableValue("limit"));
  if (limitIt != arguments->end() && !limitIt->second.IsNull()) {
    limit = std::get<int>(limitIt->second);
  }

  int64_t offset = 0;
  auto offsetIt = arguments->find(flutter::EncodableValue("offset"));
  if (offsetIt != arguments->end() && !offsetIt->second.IsNull()) {
    offset = offsetIt->second.LongValue();
  }

  if (!nim::MsgLog::QueryMsgAsync(
          accountId, sessionType, limit, offset,
          [result](nim::NIMResCode resCode, const std::string& id,
                   nim::NIMSessionType to_type,
                   const nim::QueryMsglogResult& res) {
            if (!result) {
              return;
            }
            if (nim::kNIMResSuccess == resCode) {
              flutter::EncodableList retList;
              for (auto& it : res.msglogs_) {
                flutter::EncodableMap imMessage;
                if (Convert::getInstance()->convertIMMessage2Map(imMessage,
                                                                 it)) {
                  retList.emplace_back(imMessage);
                } else {
                  // wjzh
                }
              }
              flutter::EncodableMap ret;
              ret[flutter::EncodableValue("messageList")] = retList;
              result->Success(NimResult::getSuccessResult(ret));
            } else {
              result->Error("", "",
                            NimResult::getErrorResult(
                                resCode, "queryMessageList failed!"));
            }
          })) {
    if (result) {
      result->Error(
          "", "",
          NimResult::getErrorResult(-1, "queryMessageList but param error!"));
    }
  }
}

void FLTMessageService::queryMessageListEx(
    const flutter::EncodableMap* arguments, FLTService::MethodResult result) {
  auto messageIt = arguments->find(flutter::EncodableValue("message"));
  if (messageIt == arguments->end() || messageIt->second.IsNull()) {
    if (result) {
      result->Error("", "",
                    NimResult::getErrorResult(
                        -1, "queryMessageListEx but message is empty!"));
    }
    return;
  }
  auto message = std::get<flutter::EncodableMap>(messageIt->second);
  nim::IMMessage imMessage;
  std::string imMessageJson;
  if (!Convert::getInstance()->convert2IMMessage(&message, imMessage,
                                                 imMessageJson)) {
    if (result) {
      result->Error("", "",
                    NimResult::getErrorResult(
                        -1, "queryMessageListEx but message error!"));
    }
    return;
  }

  int limit = 100;
  auto limitIt = arguments->find(flutter::EncodableValue("limit"));
  if (limitIt != arguments->end() && !limitIt->second.IsNull()) {
    limit = std::get<int>(limitIt->second);
  }

  bool direction = true;  // old
  auto directionIt = arguments->find(flutter::EncodableValue("direction"));
  if (directionIt != arguments->end() && !directionIt->second.IsNull()) {
    direction = 0 == std::get<int>(directionIt->second);
  }

  std::list<nim::NIMMessageType> msg_type = {
      nim::kNIMMessageTypeText,     nim::kNIMMessageTypeImage,
      nim::kNIMMessageTypeAudio,    nim::kNIMMessageTypeVideo,
      nim::kNIMMessageTypeLocation, nim::kNIMMessageTypeNotification,
      nim::kNIMMessageTypeFile,     nim::kNIMMessageTypeTips,
      nim::kNIMMessageTypeRobot,    nim::kNIMMessageTypeG2NetCall,
      nim::kNIMMessageTypeCustom};

  if (!nim::MsgLog::QueryMsgOfSpecifiedTypeInASessionAsync(
          imMessage.session_type_, imMessage.receiver_accid_, limit,
          direction ? 0 : imMessage.timetag_,
          direction ? imMessage.timetag_ : 0, imMessage.client_msg_id_,
          direction, msg_type,
          [result](nim::NIMResCode resCode, const std::string& id,
                   nim::NIMSessionType to_type,
                   const nim::QueryMsglogResult& res) {
            if (!result) {
              return;
            }
            if (nim::kNIMResSuccess == resCode) {
              flutter::EncodableList retList;
              for (auto& it : res.msglogs_) {
                flutter::EncodableMap imMessage;
                if (Convert::getInstance()->convertIMMessage2Map(imMessage,
                                                                 it)) {
                  retList.emplace_back(imMessage);
                } else {
                  // wjzh
                }
              }
              flutter::EncodableMap ret;
              ret[flutter::EncodableValue("messageList")] = retList;
              result->Success(NimResult::getSuccessResult(ret));
            } else {
              result->Error("", "",
                            NimResult::getErrorResult(
                                resCode, "queryMessageListEx failed!"));
            }
          })) {
    if (result) {
      result->Error("", "",
                    NimResult::getErrorResult(-1, "queryMessageListEx error!"));
    }
  }
}

void FLTMessageService::queryLastMessage(const flutter::EncodableMap* arguments,
                                         FLTService::MethodResult result) {
  nim::NIMSessionType sessionType = nim::kNIMSessionTypeP2P;
  if (!Convert::getInstance()->convertSessionType(arguments, sessionType)) {
    if (result) {
      result->Error("", "",
                    NimResult::getErrorResult(
                        -1, "queryLastMessage but sessionType error!"));
    }
    return;
  }

  std::string accountId;
  auto accountIt = arguments->find(flutter::EncodableValue("account"));
  if (accountIt != arguments->end() && !accountIt->second.IsNull()) {
    accountId = std::get<std::string>(accountIt->second);
  }

  if (!nim::MsgLog::QueryMsgAsync(
          accountId, sessionType, 1,
          std::chrono::duration_cast<std::chrono::milliseconds>(
              std::chrono::system_clock::now().time_since_epoch())
                  .count() +
              1000 * 5,
          [result](nim::NIMResCode resCode, const std::string& id,
                   nim::NIMSessionType to_type,
                   const nim::QueryMsglogResult& res) {
            if (!result) {
              return;
            }
            if (nim::kNIMResSuccess == resCode) {
              flutter::EncodableList retList;
              for (auto& it : res.msglogs_) {
                flutter::EncodableMap imMessage;
                if (Convert::getInstance()->convertIMMessage2Map(imMessage,
                                                                 it)) {
                  retList.emplace_back(imMessage);
                } else {
                  // wjzh
                }
              }
              if (!retList.empty()) {
                result->Success(NimResult::getSuccessResult(retList.at(0)));
              } else {
                result->Error(
                    "", "",
                    NimResult::getErrorResult(
                        (int)resCode, "queryLastMessage result is empty!"));
              }

            } else {
              result->Error("", "",
                            NimResult::getErrorResult(
                                resCode, "queryLastMessage failed!"));
            }
          })) {
    if (result) {
      result->Error(
          "", "",
          NimResult::getErrorResult(-1, "queryLastMessage but param error!"));
    }
  }
}

void FLTMessageService::queryMessageListByUuid(
    const flutter::EncodableMap* arguments, FLTService::MethodResult result) {
  flutter::EncodableList uuidListTmp;
  auto uuidListIt = arguments->find(flutter::EncodableValue("uuidList"));
  if (uuidListIt != arguments->end() && !uuidListIt->second.IsNull()) {
    uuidListTmp = std::get<flutter::EncodableList>(uuidListIt->second);
  }
  if (uuidListTmp.empty()) {
    if (result) {
      result->Error("", "",
                    NimResult::getErrorResult(
                        -1, "queryMessageListByUuid but uuidList error!"));
    }
    return;
  }

  for (auto& it : uuidListTmp) {
    auto uuid = std::get<std::string>(it);
    if (!nim::MsgLog::QueryMsgByIDAysnc(
            uuid, [result](nim::NIMResCode res_code, const std::string& msg_id,
                           const nim::IMMessage& msg) {
              if (!result) {
                return;
              }
              if (nim::kNIMResSuccess == res_code) {
                flutter::EncodableList retList;
                flutter::EncodableMap imMessage;
                if (Convert::getInstance()->convertIMMessage2Map(imMessage,
                                                                 msg)) {
                  retList.emplace_back(imMessage);
                } else {
                  // wjzh
                }

                flutter::EncodableMap ret;
                ret[flutter::EncodableValue("messageList")] = retList;
                result->Success(NimResult::getSuccessResult(ret));
              } else {
                result->Error("", "",
                              NimResult::getErrorResult(
                                  res_code, "queryMessageListByUuid failed!"));
              }
            })) {
      if (result) {
        result->Error(
            "", "",
            NimResult::getErrorResult(-1, "queryMessageListByUuid error!"));
      }
    }
    // wjzh 不支持列表，只取列表第一个
    break;
  }
}

void FLTMessageService::deleteChattingHistory(
    const flutter::EncodableMap* arguments, FLTService::MethodResult result) {
  auto messageIt = arguments->find(flutter::EncodableValue("message"));
  if (messageIt == arguments->end() || messageIt->second.IsNull()) {
    if (result) {
      result->Error("", "",
                    NimResult::getErrorResult(
                        -1, "deleteChattingHistory but message is empty!"));
    }
    return;
  }
  auto message = std::get<flutter::EncodableMap>(messageIt->second);
  nim::IMMessage imMessage;
  std::string imMessageJson;
  if (!Convert::getInstance()->convert2IMMessage(&message, imMessage,
                                                 imMessageJson)) {
    if (result) {
      result->Error("", "",
                    NimResult::getErrorResult(
                        -1, "deleteChattingHistory but message error!"));
    }
    return;
  }

  // wjzh
  bool ignore = false;
  auto ignoreIt = arguments->find(flutter::EncodableValue("ignore"));
  if (ignoreIt != arguments->end() && !ignoreIt->second.IsNull()) {
    ignore = std::get<bool>(ignoreIt->second);
  }

  if (!nim::MsgLog::DeleteAsync(
          imMessage.receiver_accid_, imMessage.session_type_,
          imMessage.client_msg_id_,
          [result](nim::NIMResCode res_code, const std::string& msg_id) {
            if (!result) {
              return;
            }
            if (nim::kNIMResSuccess == res_code) {
              result->Success(NimResult::getSuccessResult(msg_id));
            } else {
              result->Error(
                  "", "",
                  NimResult::getErrorResult(res_code, "DeleteAsync failed!"));
            }
          })) {
    if (result) {
      result->Error("", "",
                    NimResult::getErrorResult(-1, "DeleteAsync error!"));
    }
  }
}

void FLTMessageService::deleteChattingHistoryList(
    const flutter::EncodableMap* arguments, FLTService::MethodResult result) {}

void FLTMessageService::clearChattingHistory(
    const flutter::EncodableMap* arguments, FLTService::MethodResult result) {
  nim::NIMSessionType sessionType = nim::kNIMSessionTypeP2P;
  if (!Convert::getInstance()->convertSessionType(arguments, sessionType)) {
    if (result) {
      result->Error("", "",
                    NimResult::getErrorResult(
                        -1, "clearChattingHistory but sessionType error!"));
    }
    return;
  }

  std::string accountId;
  auto accountIt = arguments->find(flutter::EncodableValue("account"));
  if (accountIt != arguments->end() && !accountIt->second.IsNull()) {
    accountId = std::get<std::string>(accountIt->second);
  }

  if (!nim::MsgLog::BatchStatusDeleteAsync(
          accountId, sessionType,
          [result](nim::NIMResCode res_code, const std::string& uid,
                   nim::NIMSessionType to_type) {
            if (!result) {
              return;
            }
            if (nim::kNIMResSuccess == res_code) {
              result->Success(NimResult::getSuccessResult(uid));
            } else {
              result->Error("", "",
                            NimResult::getErrorResult(
                                res_code, "clearChattingHistory failed!"));
            }
          })) {
    if (result) {
      result->Error("", "",
                    NimResult::getErrorResult(
                        -1, "clearChattingHistory but param error!"));
    }
  }
}

void FLTMessageService::clearMsgDatabase(const flutter::EncodableMap* arguments,
                                         FLTService::MethodResult result) {
  bool clearRecent = false;
  auto clearRecentIt = arguments->find(flutter::EncodableValue("clearRecent"));
  if (clearRecentIt != arguments->end() && !clearRecentIt->second.IsNull()) {
    clearRecent = std::get<bool>(clearRecentIt->second);
  }

  if (!nim::MsgLog::DeleteAllAsyncEx(
          clearRecent, false, [result](nim::NIMResCode res_code) {
            if (!result) {
              return;
            }
            if (nim::kNIMResSuccess == res_code) {
              result->Success(NimResult::getSuccessResult());
            } else {
              result->Error("", "",
                            NimResult::getErrorResult(
                                res_code, "clearMsgDatabase failed!"));
            }
          })) {
    if (result) {
      result->Error(
          "", "",
          NimResult::getErrorResult(-1, "clearMsgDatabase but param error!"));
    }
  }
}

void FLTMessageService::pullMessageHistoryExType(
    const flutter::EncodableMap* arguments, FLTService::MethodResult result) {
  auto messageIt = arguments->find(flutter::EncodableValue("message"));
  if (messageIt == arguments->end() || messageIt->second.IsNull()) {
    if (result) {
      result->Error("", "",
                    NimResult::getErrorResult(
                        -1, "pullMessageHistoryExType but message is empty!"));
    }
    return;
  }
  auto message = std::get<flutter::EncodableMap>(messageIt->second);
  nim::IMMessage imMessage;
  std::string imMessageJson;
  if (!Convert::getInstance()->convert2IMMessage(&message, imMessage,
                                                 imMessageJson)) {
    if (result) {
      result->Error("", "",
                    NimResult::getErrorResult(
                        -1, "pullMessageHistoryExType but message error!"));
    }
    return;
  }

  int64_t toTime = 0;
  auto toTimeIt = arguments->find(flutter::EncodableValue("toTime"));
  if (toTimeIt != arguments->end() && !toTimeIt->second.IsNull()) {
    toTime = toTimeIt->second.LongValue();
  }

  int limit = 100;
  auto limitIt = arguments->find(flutter::EncodableValue("limit"));
  if (limitIt != arguments->end() && !limitIt->second.IsNull()) {
    limit = std::get<int>(limitIt->second);
  }

  bool direction = true;  // old
  auto directionIt = arguments->find(flutter::EncodableValue("direction"));
  if (directionIt != arguments->end() && !directionIt->second.IsNull()) {
    direction = 0 == std::get<int>(directionIt->second);
  }

  std::vector<nim::NIMMessageType> messageTypeList;
  auto messageTypeListIt =
      arguments->find(flutter::EncodableValue("messageTypeList"));
  if (messageTypeListIt != arguments->end() &&
      !messageTypeListIt->second.IsNull()) {
    flutter::EncodableList messageTypeListTmp =
        std::get<flutter::EncodableList>(messageTypeListIt->second);
    auto messageType = Convert::getInstance()->getMessageType();
    for (auto& it : messageTypeListTmp) {
      if (auto it2 = messageType.find(std::get<std::string>(it));
          it2 != messageType.end()) {
        messageTypeList.emplace_back(it2->second);
      } else {
        if (result) {
          result->Error("", "",
                        NimResult::getErrorResult(
                            -1, "pullMessageHistoryExType but param error!"));
        }
        return;
      }
    }
  }

  bool persist = false;
  auto persistIt = arguments->find(flutter::EncodableValue("persist"));
  if (persistIt != arguments->end() && !persistIt->second.IsNull()) {
    persist = std::get<bool>(persistIt->second);
  }

  nim::MsgLog::QueryMsgOnlineAsyncParam param;
  param.id_ = imMessage.receiver_accid_;
  param.to_type_ = imMessage.session_type_;
  param.limit_count_ = limit;
  param.from_time_ = imMessage.timetag_;
  param.end_time_ = toTime;
  param.end_msg_id_ = imMessage.readonly_server_id_;
  param.reverse_ = !direction;
  param.need_save_to_local_ = persist;
  param.msg_type_list_ = messageTypeList;
  param.is_exclusion_type_ = false;
  if (!nim::MsgLog::QueryMsgOnlineAsync(
          param, [result](nim::NIMResCode resCode, const std::string& id,
                          nim::NIMSessionType to_type,
                          const nim::QueryMsglogResult& res) {
            if (nim::kNIMResSuccess == resCode) {
              flutter::EncodableList retList;
              for (auto& it : res.msglogs_) {
                flutter::EncodableMap imMessage;
                if (Convert::getInstance()->convertIMMessage2Map(imMessage, it,
                                                                 true)) {
                  retList.emplace_back(imMessage);
                } else {
                  // wjzh
                }
              }
              flutter::EncodableMap ret;
              ret[flutter::EncodableValue("messageList")] = retList;
              result->Success(NimResult::getSuccessResult(ret));
            } else {
              result->Error("", "",
                            NimResult::getErrorResult(
                                resCode, "pullMessageHistoryExType failed!"));
            }
          })) {
    if (result) {
      result->Error("", "",
                    NimResult::getErrorResult(
                        -1, "pullMessageHistoryExType but param error!"));
    }
  }
}

void FLTMessageService::pullMessageHistory(
    const flutter::EncodableMap* arguments, FLTService::MethodResult result) {
  auto messageIt = arguments->find(flutter::EncodableValue("message"));
  if (messageIt == arguments->end() || messageIt->second.IsNull()) {
    if (result) {
      result->Error("", "",
                    NimResult::getErrorResult(
                        -1, "pullMessageHistory but message error!"));
    }
    return;
  }

  auto message = std::get<flutter::EncodableMap>(messageIt->second);
  nim::IMMessage imMessage;
  std::string imMessageJson;
  if (!Convert::getInstance()->convert2IMMessage(&message, imMessage,
                                                 imMessageJson)) {
    if (result) {
      result->Error("", "",
                    NimResult::getErrorResult(
                        -1, "pullMessageHistory but message error!"));
    }
    return;
  }

  int limit = 100;
  auto limitIt = arguments->find(flutter::EncodableValue("limit"));
  if (limitIt != arguments->end() && !limitIt->second.IsNull()) {
    limit = std::get<int>(limitIt->second);
  }

  bool persist = false;
  auto persistIt = arguments->find(flutter::EncodableValue("persist"));
  if (persistIt != arguments->end() && !persistIt->second.IsNull()) {
    persist = std::get<bool>(persistIt->second);
  }

  if (!nim::MsgLog::QueryMsgOnlineAsync(
          imMessage.receiver_accid_, imMessage.session_type_, limit, 0,
          imMessage.timetag_, imMessage.readonly_server_id_, true, persist,
          [result](nim::NIMResCode resCode, const std::string& id,
                   nim::NIMSessionType to_type,
                   const nim::QueryMsglogResult& res) {
            if (nim::kNIMResSuccess == resCode) {
              flutter::EncodableList retList;
              for (auto& it : res.msglogs_) {
                flutter::EncodableMap imMessage;
                if (Convert::getInstance()->convertIMMessage2Map(imMessage,
                                                                 it)) {
                  retList.emplace_back(imMessage);
                } else {
                  // wjzh
                }
              }
              flutter::EncodableMap ret;
              ret[flutter::EncodableValue("messageList")] = retList;
              result->Success(NimResult::getSuccessResult(ret));
            } else {
              result->Error("", "",
                            NimResult::getErrorResult(
                                resCode, "pullMessageHistory failed!"));
            }
          })) {
    if (result) {
      result->Error(
          "", "",
          NimResult::getErrorResult(-1, "pullMessageHistory but param error!"));
    }
  }
}

void FLTMessageService::clearServerHistory(
    const flutter::EncodableMap* arguments, FLTService::MethodResult result) {
  nim::NIMSessionType sessionType = nim::kNIMSessionTypeP2P;
  if (!Convert::getInstance()->convertSessionType(arguments, sessionType)) {
    if (result) {
      result->Error("", "",
                    NimResult::getErrorResult(
                        -1, "clearServerHistory but sessionType error!"));
    }
    return;
  }

  std::string sessionId;
  auto sessionIt = arguments->find(flutter::EncodableValue("sessionId"));
  if (sessionIt != arguments->end() && !sessionIt->second.IsNull()) {
    sessionId = std::get<std::string>(sessionIt->second);
  }

  bool sync = false;
  auto syncIt = arguments->find(flutter::EncodableValue("sync"));
  if (syncIt != arguments->end() && !syncIt->second.IsNull()) {
    sync = std::get<bool>(syncIt->second);
  }

  nim::MsgLog::DeleteHistoryOnlineAsync(
      sessionId, sessionType, sync, "",
      [result](const nim::NIMResCode resCode, const std::string&,
               nim::NIMSessionType, uint64_t, const std::string& str) {
        if (!result) {
          return;
        }
        if (nim::kNIMResSuccess == resCode) {
          result->Success(NimResult::getSuccessResult(str));
        } else {
          result->Error(
              "", "",
              NimResult::getErrorResult(resCode, "clearServerHistory failed!"));
        }
      });
}

void FLTMessageService::deleteMsgSelf(const flutter::EncodableMap* arguments,
                                      FLTService::MethodResult result) {
  auto messageIt = arguments->find(flutter::EncodableValue("message"));
  if (messageIt == arguments->end() || messageIt->second.IsNull()) {
    if (result) {
      result->Error(
          "", "",
          NimResult::getErrorResult(-1, "deleteMsgSelf but message error!"));
    }
    return;
  }
  auto message = std::get<flutter::EncodableMap>(messageIt->second);
  nim::IMMessage imMessage;
  std::string imMessageJson;
  if (!Convert::getInstance()->convert2IMMessage(&message, imMessage,
                                                 imMessageJson)) {
    if (result) {
      result->Error(
          "", "",
          NimResult::getErrorResult(-1, "deleteMsgSelf but param error!"));
    }
    return;
  }

  std::string ext;
  auto extIt = arguments->find(flutter::EncodableValue("ext"));
  if (extIt != arguments->end() && !extIt->second.IsNull()) {
    ext = std::get<std::string>(extIt->second);
  }

  nim::MsgLog::DeleteMessageSelfAsync(
      imMessage, ext, [result](nim::NIMResCode res_code) {
        if (!result) {
          return;
        }
        if (nim::kNIMResSuccess == res_code) {
          result->Success(NimResult::getSuccessResult());
        } else {
          result->Error(
              "", "",
              NimResult::getErrorResult(res_code, "deleteMsgSelf failed!"));
        }
      });
}

void FLTMessageService::deleteMsgListSelf(
    const flutter::EncodableMap* arguments, FLTService::MethodResult result) {
  std::string ext;
  auto extIt = arguments->find(flutter::EncodableValue("ext"));
  if (extIt != arguments->end() && !extIt->second.IsNull()) {
    ext = std::get<std::string>(extIt->second);
  }

  std::list<std::tuple<nim::IMMessage, std::string>> msgList;
  auto messageListIt = arguments->find(flutter::EncodableValue("messageList"));
  if (messageListIt != arguments->end() && !messageListIt->second.IsNull()) {
    flutter::EncodableList messageListTmp =
        std::get<flutter::EncodableList>(messageListIt->second);
    for (auto& it : messageListTmp) {
      flutter::EncodableMap messageMapTmp = std::get<flutter::EncodableMap>(it);
      nim::IMMessage imMessage;
      std::string imMessageJson;
      if (!Convert::getInstance()->convert2IMMessage(&messageMapTmp, imMessage,
                                                     imMessageJson)) {
        if (result) {
          // wjzh
        }
      } else {
        msgList.emplace_back(std::make_tuple(imMessage, ext));
      }
    }
  }

  nim::MsgLog::DeleteMessageSelfAsync(
      msgList, [result](nim::NIMResCode res_code) {
        if (!result) {
          return;
        }
        if (nim::kNIMResSuccess == res_code) {
          result->Success(NimResult::getSuccessResult());
        } else {
          result->Error(
              "", "",
              NimResult::getErrorResult(res_code, "deleteMsgListSelf failed!"));
        }
      });
}

void FLTMessageService::searchMessage(const flutter::EncodableMap* arguments,
                                      FLTService::MethodResult result) {
  nim::NIMSessionType sessionType = nim::kNIMSessionTypeP2P;
  if (!Convert::getInstance()->convertSessionType(arguments, sessionType)) {
    if (result) {
      result->Error("", "",
                    NimResult::getErrorResult(
                        -1, "searchMessage but sessionType error!"));
    }
    return;
  }

  std::string sessionId;
  auto sessionIt = arguments->find(flutter::EncodableValue("sessionId"));
  if (sessionIt != arguments->end() && !sessionIt->second.IsNull()) {
    sessionId = std::get<std::string>(sessionIt->second);
  }

  int64_t startTime = 0;
  int64_t endTime = 0;
  int limit = 100;
  bool order = false;
  std::list<nim::NIMMessageType> messageTypeList;
  std::list<int> messageSubTypeList;
  bool allMessageTypes = false;
  std::string searchContent;
  std::list<std::string> fromIds;
  bool enableContentTransfer = false;

  auto searchOptionIt =
      arguments->find(flutter::EncodableValue("searchOption"));
  if (searchOptionIt != arguments->end() && !searchOptionIt->second.IsNull()) {
    auto searchOption = std::get<flutter::EncodableMap>(searchOptionIt->second);
    auto startTimeIt = searchOption.find(flutter::EncodableValue("startTime"));
    if (startTimeIt != searchOption.end() && !startTimeIt->second.IsNull()) {
      startTime = startTimeIt->second.LongValue();
    }
    auto endTimeIt = searchOption.find(flutter::EncodableValue("endTime"));
    if (endTimeIt != searchOption.end() && !endTimeIt->second.IsNull()) {
      endTime = endTimeIt->second.LongValue();
    }
    auto limitIt = searchOption.find(flutter::EncodableValue("limit"));
    if (limitIt != searchOption.end() && !limitIt->second.IsNull()) {
      limit = std::get<int>(limitIt->second);
    }
    auto orderIt = searchOption.find(flutter::EncodableValue("order"));
    if (orderIt != searchOption.end() && !orderIt->second.IsNull()) {
      auto orderTmp = std::get<int>(orderIt->second);
      auto searchOrder = Convert::getInstance()->getSearchOrder();
      if (auto it = searchOrder.find(orderTmp); searchOrder.end() != it) {
        order = it->second == nim::kNIMFullTextSearchOrderByDesc;
      } else {
        YXLOG(Warn) << "parse failed, order: " << orderTmp << YXLOGEnd;
      }
    }
    auto messageTypeListIt =
        arguments->find(flutter::EncodableValue("msgTypeList"));
    if (messageTypeListIt != arguments->end() &&
        !messageTypeListIt->second.IsNull()) {
      flutter::EncodableList messageTypeListTmp =
          std::get<flutter::EncodableList>(messageTypeListIt->second);
      auto messageType = Convert::getInstance()->getMessageType();
      for (auto& it : messageTypeListTmp) {
        if (auto it2 = messageType.find(std::get<std::string>(it));
            it2 != messageType.end()) {
          messageTypeList.emplace_back(it2->second);
        } else {
        }
      }
    }

    auto messageSubTypeListIt =
        arguments->find(flutter::EncodableValue("messageSubTypes"));
    if (messageSubTypeListIt != arguments->end() &&
        !messageSubTypeListIt->second.IsNull()) {
      flutter::EncodableList messageSubTypeListTmp =
          std::get<flutter::EncodableList>(messageSubTypeListIt->second);
      for (auto& it : messageSubTypeListTmp) {
        messageSubTypeList.emplace_back(std::get<int>(it));
      }
    }
    auto allMessageTypesIt =
        searchOption.find(flutter::EncodableValue("allMessageTypes"));
    if (allMessageTypesIt != searchOption.end() &&
        !allMessageTypesIt->second.IsNull()) {
      allMessageTypes = std::get<bool>(allMessageTypesIt->second);
    }
    auto searchContentIt =
        searchOption.find(flutter::EncodableValue("searchContent"));
    if (searchContentIt != searchOption.end() &&
        !searchContentIt->second.IsNull()) {
      searchContent = std::get<std::string>(searchContentIt->second);
    }

    // auto fromIdsIt = searchOption.find(flutter::EncodableValue("fromIds"));
    // if (fromIdsIt != searchOption.end() && !fromIdsIt->second.IsNull()) {
    //   auto fromIdsTmp = std::get<flutter::EncodableList>(fromIdsIt->second);
    //   for (auto& it : fromIdsTmp) {
    //     fromIds.emplace_back(std::get<std::string>(it));
    //   }
    // }
    fromIds.emplace_back(sessionId);

    // wjzh
    auto enableContentTransferIt =
        searchOption.find(flutter::EncodableValue("enableContentTransfer"));
    if (enableContentTransferIt != searchOption.end() &&
        !enableContentTransferIt->second.IsNull()) {
      enableContentTransfer = std::get<bool>(enableContentTransferIt->second);
    }
  }

  nim::MsgLog::QueryMsgByOptionsAsyncParam param;
  switch (sessionType) {
    case nim::kNIMSessionTypeP2P:
      param.query_range_ = nim::kNIMMsgLogQueryRangeP2P;
      break;
    case nim::kNIMSessionTypeTeam:
      param.query_range_ = nim::kNIMMsgLogQueryRangeTeam;
      break;
    case nim::kNIMSessionTypeSuperTeam:
      param.query_range_ = nim::kNIMMsgLogQueryRangeSuperTeam;
      break;
    default:
      break;
  }
  param.ids_ = fromIds;
  param.limit_count_ = limit;
  param.from_time_ = startTime + 1;
  param.end_time_ = endTime - 1;
  param.reverse_ = order;
  param.search_content_ = searchContent;
  if (allMessageTypes) {
    messageTypeList.clear();
    auto messageTypeTmp = Convert::getInstance()->getMessageType();
    for (auto& [key, value] : messageTypeTmp) {
      messageTypeList.emplace_back(value);
    }
  } else if (messageTypeList.empty()) {
    messageTypeList.emplace_back(nim::kNIMMessageTypeText);
  }

  int index = 0;
  for (auto& it : messageTypeList) {
    param.msg_type_ = it;
    if (index < messageSubTypeList.size()) {
      param.msg_sub_type_ = *(std::next(messageSubTypeList.begin(), index));
    }
    if (!nim::MsgLog::QueryMsgByOptionsAsyncEx(
            param,
            [result, order](nim::NIMResCode res_code, const std::string& id,
                            nim::NIMSessionType to_type,
                            const nim::QueryMsglogResult& res) {
              if (!result) {
                return;
              }
              if (nim::kNIMResSuccess == res_code) {
                flutter::EncodableList retList;
                for (auto& it : res.msglogs_) {
                  flutter::EncodableMap imMessage;
                  if (Convert::getInstance()->convertIMMessage2Map(imMessage,
                                                                   it)) {
                    retList.emplace_back(imMessage);
                  } else {
                    // wjzh
                  }
                }
                flutter::EncodableMap ret;
                // 查询结果始终保持正序
                if (order) {
                  std::reverse(retList.begin(), retList.end());
                }
                ret[flutter::EncodableValue("messageList")] = retList;
                result->Success(NimResult::getSuccessResult(ret));
              } else {
                result->Error("", "",
                              NimResult::getErrorResult(
                                  res_code, "searchMessage failed!"));
              }
            })) {
      if (result) {
        result->Error(
            "", "",
            NimResult::getErrorResult(-1, "searchMessage but param error!"));
      }
    }
    // wjzh 不支持列表，只取列表第一个
    break;
  }
}

void FLTMessageService::searchAllMessage(const flutter::EncodableMap* arguments,
                                         FLTService::MethodResult result) {
  int64_t startTime = 0;
  int64_t endTime = 0;
  int limit = 100;
  bool order = false;
  std::list<nim::NIMMessageType> messageTypeList;
  std::list<int> messageSubTypeList;
  bool allMessageTypes = false;
  std::string searchContent;
  std::list<std::string> fromIds;
  bool enableContentTransfer = false;

  auto searchOptionIt =
      arguments->find(flutter::EncodableValue("searchOption"));
  if (searchOptionIt != arguments->end() && !searchOptionIt->second.IsNull()) {
    auto searchOption = std::get<flutter::EncodableMap>(searchOptionIt->second);
    auto startTimeIt = searchOption.find(flutter::EncodableValue("startTime"));
    if (startTimeIt != searchOption.end() && !startTimeIt->second.IsNull()) {
      startTime = startTimeIt->second.LongValue();
    }
    auto endTimeIt = searchOption.find(flutter::EncodableValue("endTime"));
    if (endTimeIt != searchOption.end() && !endTimeIt->second.IsNull()) {
      endTime = endTimeIt->second.LongValue();
    }
    auto limitIt = searchOption.find(flutter::EncodableValue("limit"));
    if (limitIt != searchOption.end() && !limitIt->second.IsNull()) {
      limit = std::get<int>(limitIt->second);
    }
    auto orderIt = searchOption.find(flutter::EncodableValue("order"));
    if (orderIt != searchOption.end() && !orderIt->second.IsNull()) {
      auto orderTmp = std::get<int>(orderIt->second);
      auto searchOrder = Convert::getInstance()->getSearchOrder();
      if (auto it = searchOrder.find(orderTmp); searchOrder.end() != it) {
        order = it->second == nim::kNIMFullTextSearchOrderByDesc;
      } else {
        YXLOG(Warn) << "parse failed, order: " << orderTmp << YXLOGEnd;
      }
    }
    auto messageTypeListIt =
        arguments->find(flutter::EncodableValue("msgTypeList"));
    if (messageTypeListIt != arguments->end() &&
        !messageTypeListIt->second.IsNull()) {
      flutter::EncodableList messageTypeListTmp =
          std::get<flutter::EncodableList>(messageTypeListIt->second);
      auto messageType = Convert::getInstance()->getMessageType();
      for (auto& it : messageTypeListTmp) {
        if (auto it2 = messageType.find(std::get<std::string>(it));
            it2 != messageType.end()) {
          messageTypeList.emplace_back(it2->second);
        } else {
        }
      }
    }

    auto messageSubTypeListIt =
        arguments->find(flutter::EncodableValue("messageSubTypes"));
    if (messageSubTypeListIt != arguments->end() &&
        !messageSubTypeListIt->second.IsNull()) {
      flutter::EncodableList messageSubTypeListTmp =
          std::get<flutter::EncodableList>(messageSubTypeListIt->second);
      for (auto& it : messageSubTypeListTmp) {
        messageSubTypeList.emplace_back(std::get<int>(it));
      }
    }
    auto allMessageTypesIt =
        searchOption.find(flutter::EncodableValue("allMessageTypes"));
    if (allMessageTypesIt != searchOption.end() &&
        !allMessageTypesIt->second.IsNull()) {
      allMessageTypes = std::get<bool>(allMessageTypesIt->second);
    }
    auto searchContentIt =
        searchOption.find(flutter::EncodableValue("searchContent"));
    if (searchContentIt != searchOption.end() &&
        !searchContentIt->second.IsNull()) {
      searchContent = std::get<std::string>(searchContentIt->second);
    }
    auto fromIdsIt = searchOption.find(flutter::EncodableValue("fromIds"));
    if (fromIdsIt != searchOption.end() && !fromIdsIt->second.IsNull()) {
      auto fromIdsTmp = std::get<flutter::EncodableList>(fromIdsIt->second);
      for (auto& it : fromIdsTmp) {
        fromIds.emplace_back(std::get<std::string>(it));
      }
    }

    // wjzh
    auto enableContentTransferIt =
        searchOption.find(flutter::EncodableValue("enableContentTransfer"));
    if (enableContentTransferIt != searchOption.end() &&
        !enableContentTransferIt->second.IsNull()) {
      enableContentTransfer = std::get<bool>(enableContentTransferIt->second);
    }
  }

  nim::MsgLog::QueryMsgByOptionsAsyncParam param;
  param.query_range_ = nim::kNIMMsgLogQueryRangeAll;
  param.ids_ = fromIds;
  param.limit_count_ = limit;
  param.from_time_ = startTime + 1;
  param.end_time_ = endTime - 1;
  param.reverse_ = order;
  param.search_content_ = searchContent;
  if (allMessageTypes) {
    messageTypeList.clear();
    auto messageTypeTmp = Convert::getInstance()->getMessageType();
    for (auto& [key, value] : messageTypeTmp) {
      messageTypeList.emplace_back(value);
    }
  } else if (messageTypeList.empty()) {
    messageTypeList.emplace_back(nim::kNIMMessageTypeText);
  }

  int index = 0;
  for (auto& it : messageTypeList) {
    param.msg_type_ = it;
    if (index < messageSubTypeList.size()) {
      param.msg_sub_type_ = *(std::next(messageSubTypeList.begin(), index));
    }
    if (!nim::MsgLog::QueryMsgByOptionsAsyncEx(
            param,
            [result, order](nim::NIMResCode res_code, const std::string& id,
                            nim::NIMSessionType to_type,
                            const nim::QueryMsglogResult& res) {
              if (!result) {
                return;
              }
              if (nim::kNIMResSuccess == res_code) {
                flutter::EncodableList retList;
                for (auto& it : res.msglogs_) {
                  flutter::EncodableMap imMessage;
                  if (Convert::getInstance()->convertIMMessage2Map(imMessage,
                                                                   it)) {
                    retList.emplace_back(imMessage);
                  } else {
                    // wjzh
                  }
                }
                flutter::EncodableMap ret;
                // 查询结果始终保持正序
                if (order) {
                  std::reverse(retList.begin(), retList.end());
                }
                ret[flutter::EncodableValue("messageList")] = retList;
                result->Success(NimResult::getSuccessResult(ret));
              } else {
                result->Error("", "",
                              NimResult::getErrorResult(
                                  res_code, "searchAllMessage failed!"));
              }
            })) {
      if (result) {
        result->Error(
            "", "",
            NimResult::getErrorResult(-1, "searchAllMessage but param error!"));
      }
    }
    // wjzh 不支持列表，只取列表第一个
    break;
  }
}

void FLTMessageService::searchRoamingMsg(const flutter::EncodableMap* arguments,
                                         FLTService::MethodResult result) {
  std::string otherAccid;
  auto otherAccidIt = arguments->find(flutter::EncodableValue("otherAccid"));
  if (otherAccidIt != arguments->end() && !otherAccidIt->second.IsNull()) {
    otherAccid = std::get<std::string>(otherAccidIt->second);
  }

  int64_t startTime = 0;
  auto fromTimeIt = arguments->find(flutter::EncodableValue("fromTime"));
  if (fromTimeIt != arguments->end() && !fromTimeIt->second.IsNull()) {
    startTime = fromTimeIt->second.LongValue();
  }

  int64_t endTime = 0;
  auto endTimeIt = arguments->find(flutter::EncodableValue("endTime"));
  if (endTimeIt != arguments->end() && !endTimeIt->second.IsNull()) {
    endTime = endTimeIt->second.LongValue();
  }

  std::string keyword;
  auto keywordIt = arguments->find(flutter::EncodableValue("keyword"));
  if (keywordIt != arguments->end() && !keywordIt->second.IsNull()) {
    keyword = std::get<std::string>(keywordIt->second);
  }

  int limit = 100;
  auto limitIt = arguments->find(flutter::EncodableValue("limit"));
  if (limitIt != arguments->end() && !limitIt->second.IsNull()) {
    limit = std::get<int>(limitIt->second);
  }

  bool reverse = false;
  auto reverseIt = arguments->find(flutter::EncodableValue("reverse"));
  if (reverseIt != arguments->end() && !reverseIt->second.IsNull()) {
    reverse = std::get<bool>(reverseIt->second);
  }

  nim::MsgLog::QueryMsgByKeywordOnlineParam param;
  param.id_ = otherAccid;
  param.keyword_ = keyword;
  param.to_type_ = nim::kNIMSessionTypeP2P;
  param.limit_count_ = limit;
  param.from_time_ = startTime;
  param.end_time_ = endTime;
  param.reverse_ = reverse;
  if (!nim::MsgLog::QueryMsgByKeywordOnlineAsync(
          param, [result](nim::NIMResCode res_code, const std::string& id,
                          nim::NIMSessionType to_type,
                          const nim::QueryMsglogResult& res) {
            if (!result) {
              return;
            }
            if (nim::kNIMResSuccess == res_code) {
              flutter::EncodableList retList;
              for (auto& it : res.msglogs_) {
                flutter::EncodableMap imMessage;
                if (Convert::getInstance()->convertIMMessage2Map(imMessage,
                                                                 it)) {
                  retList.emplace_back(imMessage);
                } else {
                  // wjzh
                }
              }
              result->Success(NimResult::getSuccessResult(retList));
            } else {
              result->Error("", "",
                            NimResult::getErrorResult(
                                res_code, "searchRoamingMsg failed!"));
            }
          })) {
    if (result) {
      result->Error(
          "", "",
          NimResult::getErrorResult(-1, "searchRoamingMsg but param error!"));
    }
  } else {
    result->Error(
        "", "",
        NimResult::getErrorResult(-1, "searchRoamingMsg but param error!"));
  }
}

void FLTMessageService::searchCloudMessageHistory(
    const flutter::EncodableMap* arguments, FLTService::MethodResult result) {
  auto messageKeywordSearchConfigIt =
      arguments->find(flutter::EncodableValue("messageKeywordSearchConfig"));
  if (messageKeywordSearchConfigIt == arguments->end() ||
      messageKeywordSearchConfigIt->second.IsNull()) {
    if (result) {
      result->Error(
          "", "",
          NimResult::getErrorResult(-1,
                                    "searchCloudMessageHistory but "
                                    "messageKeywordSearchConfig error!"));
    }
    return;
  }

  auto messageKeywordSearchConfig =
      std::get<flutter::EncodableMap>(messageKeywordSearchConfigIt->second);
  int64_t startTime = 0;
  auto fromTimeIt =
      messageKeywordSearchConfig.find(flutter::EncodableValue("fromTime"));
  if (fromTimeIt != messageKeywordSearchConfig.end() &&
      !fromTimeIt->second.IsNull()) {
    startTime = fromTimeIt->second.LongValue();
  }

  int64_t endTime = 0;
  auto endTimeIt =
      messageKeywordSearchConfig.find(flutter::EncodableValue("toTime"));
  if (endTimeIt != messageKeywordSearchConfig.end() &&
      !endTimeIt->second.IsNull()) {
    endTime = endTimeIt->second.LongValue();
  }

  std::string keyword;
  auto keywordIt =
      messageKeywordSearchConfig.find(flutter::EncodableValue("keyword"));
  if (keywordIt != messageKeywordSearchConfig.end() &&
      !keywordIt->second.IsNull()) {
    keyword = std::get<std::string>(keywordIt->second);
  }

  int32_t sessionLimit = 1;
  auto sessionLimitIt =
      messageKeywordSearchConfig.find(flutter::EncodableValue("sessionLimit"));
  if (sessionLimitIt != messageKeywordSearchConfig.end() &&
      !sessionLimitIt->second.IsNull()) {
    sessionLimit = std::get<int32_t>(sessionLimitIt->second);
  }

  int32_t msgLimit = 1;
  auto msgLimitIt =
      messageKeywordSearchConfig.find(flutter::EncodableValue("msgLimit"));
  if (msgLimitIt != messageKeywordSearchConfig.end() &&
      !msgLimitIt->second.IsNull()) {
    msgLimit = std::get<int32_t>(msgLimitIt->second);
  }

  uint32_t search_rule = nim::kNIMFullTextSearchOrderByDesc;
  auto ascIt = messageKeywordSearchConfig.find(flutter::EncodableValue("asc"));
  if (ascIt != messageKeywordSearchConfig.end() && !ascIt->second.IsNull()) {
    auto orderTmp = std::get<bool>(ascIt->second);
    auto searchOrder = Convert::getInstance()->getSearchOrder();
    if (auto it = searchOrder.find(orderTmp); searchOrder.end() != it) {
      search_rule = it->second;
    } else {
      YXLOG(Warn) << "parse failed, asc: " << orderTmp << YXLOGEnd;
    }
  }

  std::list<std::string> p2pList;
  auto p2pListIt =
      messageKeywordSearchConfig.find(flutter::EncodableValue("p2pList"));
  if (p2pListIt != messageKeywordSearchConfig.end() &&
      !p2pListIt->second.IsNull()) {
    auto p2pListTmp = std::get<flutter::EncodableList>(p2pListIt->second);
    for (auto& it : p2pListTmp) {
      p2pList.emplace_back(std::get<std::string>(it));
    }
  }

  std::list<std::string> teamList;
  auto teamListIt =
      messageKeywordSearchConfig.find(flutter::EncodableValue("teamList"));
  if (teamListIt != messageKeywordSearchConfig.end() &&
      !teamListIt->second.IsNull()) {
    auto teamListTmp = std::get<flutter::EncodableList>(teamListIt->second);
    for (auto& it : teamListTmp) {
      teamList.emplace_back(std::get<std::string>(it));
    }
  }

  std::list<std::string> senderList;
  auto senderListIt =
      messageKeywordSearchConfig.find(flutter::EncodableValue("senderList"));
  if (senderListIt != messageKeywordSearchConfig.end() &&
      !senderListIt->second.IsNull()) {
    auto senderListTmp = std::get<flutter::EncodableList>(senderListIt->second);
    for (auto& it : senderListTmp) {
      senderList.emplace_back(std::get<std::string>(it));
    }
  }

  std::list<nim::NIMMessageType> messageTypeList;
  auto messageTypeListIt =
      messageKeywordSearchConfig.find(flutter::EncodableValue("msgTypeList"));
  if (messageTypeListIt != messageKeywordSearchConfig.end() &&
      !messageTypeListIt->second.IsNull()) {
    flutter::EncodableList messageTypeListTmp =
        std::get<flutter::EncodableList>(messageTypeListIt->second);
    auto messageType = Convert::getInstance()->getMessageType();
    for (auto& it : messageTypeListTmp) {
      if (auto it2 = messageType.find(std::get<std::string>(it));
          it2 != messageType.end()) {
        messageTypeList.emplace_back(it2->second);
      } else {
        if (result) {
          result->Error(
              "", "",
              NimResult::getErrorResult(
                  -1, "searchCloudMessageHistory but msgTypeList error!"));
        }
        return;
      }
    }
  }

  std::list<uint32_t> messageSubTypeList;
  auto messageSubTypeListIt = messageKeywordSearchConfig.find(
      flutter::EncodableValue("msgSubtypeList"));
  if (messageSubTypeListIt != messageKeywordSearchConfig.end() &&
      !messageSubTypeListIt->second.IsNull()) {
    flutter::EncodableList messageSubTypeListTmp =
        std::get<flutter::EncodableList>(messageSubTypeListIt->second);
    for (auto& it : messageSubTypeListTmp) {
      messageSubTypeList.emplace_back(std::get<int32_t>(it));
    }
  }

  nim::MsgLog::FullTextSearchOnlineAsyncParam param;
  param.keyword_ = keyword;
  param.from_time_ = startTime;
  param.to_time_ = endTime;
  param.session_limit_ = sessionLimit;
  param.msglog_limit_ = msgLimit;
  param.search_rule_ = search_rule;
  param.p2p_filter_list_ = p2pList;
  param.team_filter_list_ = teamList;
  param.sender_filter_list_ = senderList;
  param.msg_type_filter_list_ = messageTypeList;
  param.msg_sub_type_filter_list_ = messageSubTypeList;
  nim::MsgLog::FullTextSearchOnlineAsync(
      param,
      [result](nim::NIMResCode res_code, const nim::QueryMsglogResult& res) {
        if (!result) {
          return;
        }
        if (nim::kNIMResSuccess == res_code) {
          flutter::EncodableList retList;
          for (auto& it : res.msglogs_) {
            flutter::EncodableMap imMessage;
            if (Convert::getInstance()->convertIMMessage2Map(imMessage, it)) {
              retList.emplace_back(imMessage);
            } else {
              // wjzh
            }
          }
          flutter::EncodableMap ret;
          ret[flutter::EncodableValue("messageList")] = retList;
          result->Success(NimResult::getSuccessResult(ret));
        } else {
          result->Error("", "",
                        NimResult::getErrorResult(
                            res_code, "searchCloudMessageHistory failed!"));
        }
      });
}

void FLTMessageService::downloadAttachment(
    const flutter::EncodableMap* arguments, FLTService::MethodResult result) {
  nim::IMMessage imMessage;
  std::string imMessageJson;
  if (!Convert::getInstance()->convert2IMMessage(arguments, imMessage,
                                                 imMessageJson)) {
    if (result) {
      result->Error("", "",
                    NimResult::getErrorResult(
                        -1, "downloadAttachment but message error!"));
    }
    return;
  }

  // wjzh
  bool thumb = false;
  auto thumbIt = arguments->find(flutter::EncodableValue("thumb"));
  if (thumbIt != arguments->end() && !thumbIt->second.IsNull()) {
    thumb = std::get<bool>(thumbIt->second);
  }

  if (!nim::NOS::FetchMedia(
          imMessage,
          [result](nim::NIMResCode res_code, const std::string& file_path,
                   const std::string& call_id, const std::string& res_idt) {
            if (!result) {
              return;
            }

            if (nim::kNIMResSuccess == res_code) {
              result->Success(NimResult::getSuccessResult());
            } else {
              result->Error("", "",
                            NimResult::getErrorResult(
                                res_code, "downloadAttachment failed!"));
            }
          },
          [this, result, id = imMessage.client_msg_id_](int64_t completed_size,
                                                        int64_t file_size) {
            SendMessageAttachmentProgress(id, completed_size, file_size);
          })) {
    if (result) {
      result->Error("", "",
                    NimResult::getErrorResult(-1, "downloadAttachment error!"));
    }
  }
}

void FLTMessageService::cancelUploadAttachment(
    const flutter::EncodableMap* arguments, FLTService::MethodResult result) {
  nim::IMMessage imMessage;
  std::string imMessageJson;
  if (!Convert::getInstance()->convert2IMMessage(arguments, imMessage,
                                                 imMessageJson)) {
    if (result) {
      result->Error("", "",
                    NimResult::getErrorResult(
                        -1, "cancelUploadAttachment but message error!"));
    }
    return;
  }
  if (!nim::Talk::StopSendMsg(imMessage.client_msg_id_, imMessage.type_)) {
    if (result) {
      result->Error(
          "", "",
          NimResult::getErrorResult(-1, "cancelUploadAttachment error!"));
    }
  } else {
    if (result) {
      result->Success(NimResult::getSuccessResult());
    }
  }
}

void FLTMessageService::revokeMessage(const flutter::EncodableMap* arguments,
                                      FLTService::MethodResult result) {
  nim::IMMessage imMessage;
  std::string imMessageJson;
  if (!Convert::getInstance()->convert2IMMessage(arguments, imMessage,
                                                 imMessageJson)) {
    if (result) {
      result->Error("", "",
                    NimResult::getErrorResult(
                        -1, "cancelUploadAttachment but message error!"));
    }
    return;
  }

  std::string customApnsText;
  auto customApnsTextIt =
      arguments->find(flutter::EncodableValue("customApnsText"));
  if (customApnsTextIt != arguments->end() &&
      !customApnsTextIt->second.IsNull()) {
    customApnsText = std::get<std::string>(customApnsTextIt->second);
  }

  std::string pushPayload;
  auto pushPayloadtIt = arguments->find(flutter::EncodableValue("pushPayload"));
  if (pushPayloadtIt != arguments->end() && !pushPayloadtIt->second.IsNull()) {
    auto pushPayloadtTmp =
        std::get<flutter::EncodableMap>(pushPayloadtIt->second);
    nim_cpp_wrapper_util::Json::Value pushPayload_json;
    if (!Convert::getInstance()->convertMap2Json(&pushPayloadtTmp,
                                                 pushPayload_json)) {
      if (result) {
        result->Error("", "",
                      NimResult::getErrorResult(
                          -1, "revokeMessage but pushPayload error!"));
      }
      return;
    }
    pushPayload = nim::GetJsonStringWithNoStyled(pushPayload_json);
  }

  // wjzh
  bool shouldNotifyBeCount = false;
  auto shouldNotifyBeCountIt =
      arguments->find(flutter::EncodableValue("shouldNotifyBeCount"));
  if (shouldNotifyBeCountIt != arguments->end() &&
      !shouldNotifyBeCountIt->second.IsNull()) {
    shouldNotifyBeCount = std::get<bool>(shouldNotifyBeCountIt->second);
  }

  // wjzh
  std::string postscript;
  auto postscriptIt = arguments->find(flutter::EncodableValue("postscript"));
  if (postscriptIt != arguments->end() && !postscriptIt->second.IsNull()) {
    postscript = std::get<std::string>(postscriptIt->second);
  }

  std::string attach;
  auto attachIt = arguments->find(flutter::EncodableValue("attach"));
  if (attachIt != arguments->end() && !attachIt->second.IsNull()) {
    attach = std::get<std::string>(attachIt->second);
  }

  if (imMessage.client_msg_id_.empty()) {
    if (result) {
      result->Error("", "",
                    NimResult::getErrorResult(
                        -1, "revokeMessage but message.uuid == null!"));
    }
    return;
  }

  if (!nim::MsgLog::QueryMsgByIDAysnc(
          imMessage.client_msg_id_,
          [result, attach, customApnsText, pushPayload](
              nim::NIMResCode res_code, const std::string& msg_id,
              const nim::IMMessage& msg) {
            if (nim::kNIMResSuccess == res_code) {
              if (msg.client_msg_id_.empty()) {
                if (result) {
                  result->Error(
                      "", "",
                      NimResult::getErrorResult(
                          -1, "revokeMessage but uuid can not queried!"));
                }
                return;
              } else {
                nim::Talk::RecallMsg2(
                    msg, attach,
                    [result](const nim::NIMResCode res_code,
                             const std::list<nim::RecallMsgNotify>&) {
                      if (!result) {
                        return;
                      }
                      if (nim::kNIMResSuccess == res_code) {
                        result->Success(NimResult::getSuccessResult());
                      } else {
                        result->Error("", "",
                                      NimResult::getErrorResult(
                                          res_code, "revokeMessage error!"));
                      }
                    },
                    customApnsText, pushPayload, "");
              }
            } else {
              if (result) {
                result->Error(
                    "", "",
                    NimResult::getErrorResult(
                        res_code,
                        "revokeMessage but QueryMsgByIDAysnc failed!"));
              }
            }
          })) {
    if (result) {
      result->Error("", "",
                    NimResult::getErrorResult(
                        -1, "revokeMessage but QueryMsgByIDAysnc error!"));
    }
  }
}

void FLTMessageService::replyMessage(const flutter::EncodableMap* arguments,
                                     FLTService::MethodResult result) {
  nim::IMMessage imMessage;
  std::string imMessageJson;
  auto messageIt = arguments->find(flutter::EncodableValue("message"));
  if (messageIt != arguments->end() && !messageIt->second.IsNull()) {
    auto messageTmp = std::get<flutter::EncodableMap>(messageIt->second);
    if (!Convert::getInstance()->convert2IMMessage(&messageTmp, imMessage,
                                                   imMessageJson)) {
      if (result) {
        result->Error(
            "", "",
            NimResult::getErrorResult(-1, "replyMessage but message error!"));
      }
      return;
    }
  }

  nim::IMMessage imMessageReply;
  std::string imMessageJsonReply;
  auto replyMsgIt = arguments->find(flutter::EncodableValue("replyMsg"));
  if (replyMsgIt != arguments->end() && !replyMsgIt->second.IsNull()) {
    auto replyMsgTmp = std::get<flutter::EncodableMap>(replyMsgIt->second);
    if (!Convert::getInstance()->convert2IMMessage(&replyMsgTmp, imMessageReply,
                                                   imMessageJsonReply)) {
      if (result) {
        result->Error(
            "", "",
            NimResult::getErrorResult(-1, "replyMessage but replyMsg error!"));
      }
      return;
    }
  }

  // wjzh
  bool resend = false;
  auto resendIt = arguments->find(flutter::EncodableValue("resend"));
  if (resendIt != arguments->end() && !resendIt->second.IsNull()) {
    resend = std::get<bool>(resendIt->second);
  }

  nim::Talk::FileUpPrgCallback* pFileUpPrgCallback =
      new nim::Talk::FileUpPrgCallback(
          std::bind(&FLTMessageService::SendMessageAttachmentProgress, this,
                    imMessage.client_msg_id_, std::placeholders::_1,
                    std::placeholders::_2));
  if (pFileUpPrgCallback) {
    std::lock_guard<std::recursive_mutex> lockGuard(m_mutexSendMsgResult);
    m_mapSendMsgResult[imMessageReply.client_msg_id_] = SendMsgResult();
    m_mapSendMsgResult[imMessageReply.client_msg_id_].pFileUpPrgCallback =
        pFileUpPrgCallback;
    m_mapSendMsgResult[imMessageReply.client_msg_id_].imMessage =
        imMessageReply;
    if (result) {
      m_mapSendMsgResult[imMessageReply.client_msg_id_].methodResult = result;
    }
  }

  nim::Talk::ReplyMessage(imMessage, imMessageJsonReply, pFileUpPrgCallback);
}

void FLTMessageService::queryReplyCountInThreadTalkBlock(
    const flutter::EncodableMap* arguments, FLTService::MethodResult result) {
  auto messageIt = arguments->find(flutter::EncodableValue("message"));
  if (messageIt == arguments->end() || messageIt->second.IsNull()) {
    if (result) {
      result->Error(
          "", "",
          NimResult::getErrorResult(
              -1, "queryReplyCountInThreadTalkBlock but message is empty!"));
    }
    return;
  }
  auto message = std::get<flutter::EncodableMap>(messageIt->second);
  nim::IMMessage imMessage;
  std::string imMessageJson;
  if (!Convert::getInstance()->convert2IMMessage(&message, imMessage,
                                                 imMessageJson)) {
    if (result) {
      result->Error(
          "", "",
          NimResult::getErrorResult(
              -1, "queryReplyCountInThreadTalkBlock but message error!"));
    }
    return;
  }

  nim::MsgLog::QueryMessageIsThreadRoot(
      imMessage.client_msg_id_,
      [result](const nim::NIMResCode res_code, const std::string& client_id,
               bool is_root, int reply_count) {
        if (!result) {
          return;
        }
        if (nim::kNIMResSuccess == res_code) {
          result->Success(NimResult::getSuccessResult((int32_t)reply_count));
        } else {
          result->Error(
              "", "",
              NimResult::getErrorResult(
                  res_code, "queryReplyCountInThreadTalkBlock error!"));
        }
      });
}

void FLTMessageService::queryThreadTalkHistory(
    const flutter::EncodableMap* arguments, FLTService::MethodResult result) {
  auto messageIt = arguments->find(flutter::EncodableValue("message"));
  if (messageIt == arguments->end() || messageIt->second.IsNull()) {
    if (result) {
      result->Error("", "",
                    NimResult::getErrorResult(
                        -1, "queryThreadTalkHistory but message error!"));
    }
    return;
  }
  auto message = std::get<flutter::EncodableMap>(messageIt->second);
  nim::IMMessage imMessage;
  std::string imMessageJson;
  if (!Convert::getInstance()->convert2IMMessage(&message, imMessage,
                                                 imMessageJson)) {
    if (result) {
      result->Error("", "",
                    NimResult::getErrorResult(
                        -1, "queryThreadTalkHistory but message error!"));
    }
    return;
  }

  int64_t startTime = 0;
  auto fromTimeIt = arguments->find(flutter::EncodableValue("fromTime"));
  if (fromTimeIt != arguments->end() && !fromTimeIt->second.IsNull()) {
    startTime = fromTimeIt->second.LongValue();
  }

  int64_t endTime = 0;
  auto endTimeIt = arguments->find(flutter::EncodableValue("toTime"));
  if (endTimeIt != arguments->end() && !endTimeIt->second.IsNull()) {
    endTime = endTimeIt->second.LongValue();
  }

  int32_t limit = 100;
  auto limitIt = arguments->find(flutter::EncodableValue("limit"));
  if (limitIt != arguments->end() && !limitIt->second.IsNull()) {
    limit = std::get<int32_t>(limitIt->second);
  }

  int32_t reverse = 0;
  auto directionIt = arguments->find(flutter::EncodableValue("direction"));
  if (directionIt != arguments->end() && !directionIt->second.IsNull()) {
    reverse = std::get<int32_t>(directionIt->second);
  }

  // wjzh
  bool persist = false;
  auto persistIt = arguments->find(flutter::EncodableValue("persist"));
  if (persistIt != arguments->end() && !persistIt->second.IsNull()) {
    persist = std::get<bool>(persistIt->second);
  }

  nim::MsgLog::QueryThreadHistoryMsgAsyncParam param;
  param.from_time = startTime;
  param.to_time = endTime;
  param.limit = limit;
  param.reverse = reverse;
  nim::MsgLog::QueryThreadHistoryMsg(
      imMessage, param,
      [result](const nim::NIMResCode res_code, const nim::IMMessage& root_msg,
               int total, uint64_t last_msg_time,
               const std::list<nim::IMMessage>& msg_list) {
        if (!result) {
          return;
        }
        if (nim::kNIMResSuccess == res_code) {
          flutter::EncodableMap ret;
          flutter::EncodableMap imMessage;
          if (Convert::getInstance()->convertIMMessage2Map(imMessage,
                                                           root_msg)) {
            ret[flutter::EncodableValue("thread")] = imMessage;
          } else {
            // wjzh
          }

          flutter::EncodableList replyList;
          for (auto& it : msg_list) {
            flutter::EncodableMap imMessageTmp;
            if (Convert::getInstance()->convertIMMessage2Map(imMessageTmp,
                                                             it)) {
              replyList.emplace_back(imMessageTmp);
            } else {
              // wjzh
            }
          }

          ret[flutter::EncodableValue("replyList")] = replyList;
          ret[flutter::EncodableValue("time")] = (int64_t)last_msg_time;
          result->Success(NimResult::getSuccessResult(ret));
        } else {
          result->Error("", "",
                        NimResult::getErrorResult(
                            res_code, "queryThreadTalkHistory error!"));
        }
      });
}

void FLTMessageService::querySessionList(const flutter::EncodableMap* arguments,
                                         FLTService::MethodResult result) {
  int limit = 100;
  auto limitIt = arguments->find(flutter::EncodableValue("limit"));
  if (limitIt != arguments->end() && !limitIt->second.IsNull()) {
    limit = std::get<int32_t>(limitIt->second);
  }

  nim::Session::QueryLastFewSessionAsync(
      limit, [result](int unread_count, const nim::SessionDataList& ret) {
        if (!result) {
          return;
        }

        flutter::EncodableList replyList;
        for (auto& it : ret.sessions_) {
          flutter::EncodableMap tmp;
          if (Convert::getInstance()->convertIMSessionData2Map(it, tmp)) {
            replyList.emplace_back(tmp);
          } else {
            YXLOG(Warn) << "convertIMSessionData2Map failed." << YXLOGEnd;
          }
        }

        flutter::EncodableMap retList;
        retList[flutter::EncodableValue("resultList")] = replyList;
        result->Success(NimResult::getSuccessResult(retList));
      });
}

void FLTMessageService::querySessionListFiltered(
    const flutter::EncodableMap* arguments, FLTService::MethodResult result) {
  std::list<nim::NIMMessageType> messageTypeList;
  auto filterMessageTypeListIt =
      arguments->find(flutter::EncodableValue("filterMessageTypeList"));
  if (filterMessageTypeListIt != arguments->end() &&
      !filterMessageTypeListIt->second.IsNull()) {
    flutter::EncodableList filterMessageTypeListTmp =
        std::get<flutter::EncodableList>(filterMessageTypeListIt->second);
    auto messageType = Convert::getInstance()->getMessageType();
    for (auto& it : filterMessageTypeListTmp) {
      if (auto it2 = messageType.find(std::get<std::string>(it));
          it2 != messageType.end()) {
        messageTypeList.emplace_back(it2->second);
      } else {
        if (result) {
          result->Error(
              "", "",
              NimResult::getErrorResult(
                  -1,
                  "querySessionListFiltered but filterMessageTypeList error!"));
        }
        return;
      }
    }
  }

  nim::Session::QueryAllRecentSessionAsyncEx(
      messageTypeList,
      [result](int unread_count, const nim::SessionDataList& ret) {
        if (!result) {
          return;
        }

        flutter::EncodableList replyList;
        for (auto& it : ret.sessions_) {
          flutter::EncodableMap tmp;
          if (Convert::getInstance()->convertIMSessionData2Map(it, tmp)) {
            replyList.emplace_back(tmp);
          } else {
            YXLOG(Warn) << "convertIMSessionData2Map failed." << YXLOGEnd;
          }

          flutter::EncodableMap retList;
          retList[flutter::EncodableValue("resultList")] = replyList;
          result->Success(NimResult::getSuccessResult(retList));
        }
      });
}

void FLTMessageService::querySession(const flutter::EncodableMap* arguments,
                                     FLTService::MethodResult result) {
  std::string sessionId;
  auto sessionIdIt = arguments->find(flutter::EncodableValue("sessionId"));
  if (sessionIdIt != arguments->end() && !sessionIdIt->second.IsNull()) {
    sessionId = std::get<std::string>(sessionIdIt->second);
  }

  if (sessionId.empty()) {
    if (result) {
      result->Error("", "",
                    NimResult::getErrorResult(
                        -1, "querySession but sessionId is empty!"));
    }
    return;
  }

  nim::NIMSessionType sessionType = nim::kNIMSessionTypeP2P;
  if (!Convert::getInstance()->convertSessionType(arguments, sessionType)) {
    if (result) {
      result->Error(
          "", "",
          NimResult::getErrorResult(-1, "querySession but sessionType error!"));
    }
    return;
  }

  nim::Session::QuerySessionDataById(
      sessionType, sessionId,
      [result](nim::NIMResCode res_code, const nim::SessionData& ret) {
        if (!result) {
          return;
        }

        if (nim::kNIMResSuccess == res_code) {
          flutter::EncodableMap tmp;
          if (Convert::getInstance()->convertIMSessionData2Map(ret, tmp)) {
          } else {
            YXLOG(Warn) << "convertIMSessionData2Map failed." << YXLOGEnd;
          }

          result->Success(NimResult::getSuccessResult(tmp));
        } else {
          result->Error(
              "", "",
              NimResult::getErrorResult(res_code, "querySession error!"));
        }
      });
}

void FLTMessageService::createSession(const flutter::EncodableMap* arguments,
                                      FLTService::MethodResult result) {
  std::string sessionId;
  auto sessionIdIt = arguments->find(flutter::EncodableValue("sessionId"));
  if (sessionIdIt != arguments->end() && !sessionIdIt->second.IsNull()) {
    sessionId = std::get<std::string>(sessionIdIt->second);
  }

  if (sessionId.empty()) {
    if (result) {
      result->Error(
          "", "",
          NimResult::getErrorResult(-1, "createSession but sessionId error!"));
    }
    return;
  }

  nim::NIMSessionType sessionType = nim::kNIMSessionTypeP2P;
  if (!Convert::getInstance()->convertSessionType(arguments, sessionType)) {
    if (result) {
      result->Error("", "",
                    NimResult::getErrorResult(
                        -1, "createSession but sessionType error!"));
    }
    return;
  }

  int tag = 0;
  auto tagIt = arguments->find(flutter::EncodableValue("tag"));
  if (tagIt != arguments->end() && !tagIt->second.IsNull()) {
    tag = std::get<int32_t>(tagIt->second);
  }

  int64_t time = 0;
  auto timeIt = arguments->find(flutter::EncodableValue("time"));
  if (timeIt != arguments->end() && !timeIt->second.IsNull()) {
    time = timeIt->second.LongValue();
  }

  bool linkToLastMessage = false;
  auto linkToLastMessageIt =
      arguments->find(flutter::EncodableValue("linkToLastMessage"));
  if (linkToLastMessageIt != arguments->end() &&
      !linkToLastMessageIt->second.IsNull()) {
    linkToLastMessage = std::get<bool>(linkToLastMessageIt->second);
  }

  /*
      if (!nim::MsgLog::WriteMsglogToLocalAsync(fromAccount, imMessage, BS_TRUE
     == imMessage.msg_setting_.is_update_session_, [result,
     imMessage](nim::NIMResCode res_code, const std::string& msg_id) { if
     (!result) { return;
                                                    }

                                                    if (nim::kNIMResSuccess ==
     res_code) { flutter::EncodableMap ret;
                                                        Convert::getInstance()->convertIMMessage2Map(ret,
     imMessage); result->Success(NimResult::getSuccessResult(ret)); } else {
                                                        result->Error("", "",
     NimResult::getErrorResult(res_code, "save message failed!"));
                                                    }
                                                })) {
          if (result) {
              result->Error("", "", NimResult::getErrorResult(-1, "save message
     error!"));
          }
      }
      */
}

void FLTMessageService::updateSession(const flutter::EncodableMap* arguments,
                                      FLTService::MethodResult result) {
  // wjzh
  bool needNotify = false;
  std::string sessionId;
  nim::NIMSessionType sessionType = nim::kNIMSessionTypeP2P;
  // wjzh
  int tag = 0;
  // wjzh
  std::string extension;

  auto needNotifyIt = arguments->find(flutter::EncodableValue("needNotify"));
  if (needNotifyIt != arguments->end() && !needNotifyIt->second.IsNull()) {
    needNotify = std::get<bool>(needNotifyIt->second);
  }

  auto sessionIt = arguments->find(flutter::EncodableValue("session"));
  if (sessionIt != arguments->end() && !sessionIt->second.IsNull()) {
    auto sessionTmp = std::get<flutter::EncodableMap>(sessionIt->second);
    auto sessionIdIt = sessionTmp.find(flutter::EncodableValue("sessionId"));
    if (sessionIdIt != sessionTmp.end() && !sessionIdIt->second.IsNull()) {
      sessionId = std::get<std::string>(sessionIdIt->second);
    }

    if (!Convert::getInstance()->convertSessionType(&sessionTmp, sessionType)) {
      if (result) {
        result->Error("", "",
                      NimResult::getErrorResult(
                          -1, "updateSession but sessionType error!"));
      }
      return;
    }

    auto tagIt = sessionTmp.find(flutter::EncodableValue("tag"));
    if (tagIt != sessionTmp.end() && !tagIt->second.IsNull()) {
      tag = std::get<int32_t>(tagIt->second);
    }

    nim_cpp_wrapper_util::Json::Value extension_json;
    if (!Convert::getInstance()->convertMap2Json(&sessionTmp, extension_json)) {
      if (result) {
        result->Error(
            "", "",
            NimResult::getErrorResult(-1, "updateSession but session error!"));
      }
      return;
    }
    extension = nim::GetJsonStringWithNoStyled(extension_json);
  }

  nim::SessionOnLineService::UpdateSession(
      sessionType, sessionId, extension, [result](nim::NIMResCode res_code) {
        if (!result) {
          return;
        }

        if (nim::kNIMResSuccess == res_code) {
          result->Success(NimResult::getSuccessResult());
        } else {
          result->Error(
              "", "",
              NimResult::getErrorResult(res_code, "updateSession error!"));
        }
      });
}

void FLTMessageService::updateSessionWithMessage(
    const flutter::EncodableMap* arguments, FLTService::MethodResult result) {
  // wjzh
  bool needNotify = false;
  nim::IMMessage imMessage;

  auto needNotifyIt = arguments->find(flutter::EncodableValue("needNotify"));
  if (needNotifyIt != arguments->end() && !needNotifyIt->second.IsNull()) {
    needNotify = std::get<bool>(needNotifyIt->second);
  }

  auto messageIt = arguments->find(flutter::EncodableValue("message"));
  if (messageIt != arguments->end() && !messageIt->second.IsNull()) {
    auto message = std::get<flutter::EncodableMap>(messageIt->second);
    std::string imMessageJson;
    if (!Convert::getInstance()->convert2IMMessage(&message, imMessage,
                                                   imMessageJson)) {
      if (result) {
        result->Error("", "",
                      NimResult::getErrorResult(
                          -1, "updateSessionWithMessage but message error!"));
      }
      return;
    }
  }

  /*nim::Session::UpdateHasmoreRoammsg(imMessage, [result](nim::NIMResCode
  res_code) { if (!result) { return;
      }

      if (nim::kNIMResSuccess == res_code) {
          result->Success(NimResult::getSuccessResult());
      } else {
          result->Error("", "", NimResult::getErrorResult(res_code,
  "updateSessionWithMessage error!"));
      }
  });*/
}

void FLTMessageService::queryTotalUnreadCount(
    const flutter::EncodableMap* arguments, FLTService::MethodResult result) {
  // wjzh
  int queryType = 0;
  auto queryTypeIt = arguments->find(flutter::EncodableValue("queryType"));
  if (queryTypeIt != arguments->end() && !queryTypeIt->second.IsNull()) {
    queryType = std::get<int32_t>(queryTypeIt->second);
  }
  // fixme: PC端暂不支持按照通知类型过滤未读数，已经同步SDK，SDK修复后修改
  nim::Session::QueryAllRecentSessionAsync(
      [result](int resCode, const nim::SessionDataList& ret) {
        if (!result) {
          return;
        }

        flutter::EncodableMap retMap;
        retMap[flutter::EncodableValue("count")] = resCode;
        result->Success(NimResult::getSuccessResult(retMap));
      });
}

void FLTMessageService::setChattingAccount(
    const flutter::EncodableMap* arguments, FLTService::MethodResult result) {}

void FLTMessageService::clearSessionUnreadCount(
    const flutter::EncodableMap* arguments, FLTService::MethodResult result) {
  std::list<nim::MultiUnreadCountZeroInfo> unread_zero_info_list;
  auto requestListIt = arguments->find(flutter::EncodableValue("requestList"));
  if (requestListIt != arguments->end() && !requestListIt->second.IsNull()) {
    flutter::EncodableList requestListTmp =
        std::get<flutter::EncodableList>(requestListIt->second);
    auto sessionTypeEnum = Convert::getInstance()->getSessionType();
    for (auto& it : requestListTmp) {
      nim::MultiUnreadCountZeroInfo info;
      flutter::EncodableMap requestTmp = std::get<flutter::EncodableMap>(it);
      auto sessionIdIt = requestTmp.find(flutter::EncodableValue("sessionId"));
      if (sessionIdIt != requestTmp.end() && !sessionIdIt->second.IsNull()) {
        info.id_ = std::get<std::string>(sessionIdIt->second);
      }

      nim::NIMSessionType sessionType = nim::kNIMSessionTypeP2P;
      if (!Convert::getInstance()->convertSessionType(&requestTmp,
                                                      sessionType)) {
        if (result) {
          result->Error(
              "", "",
              NimResult::getErrorResult(
                  -1, "clearSessionUnreadCount but sessionType error!"));
        }
        return;
      }
      info.type_ = sessionType;
      unread_zero_info_list.emplace_back(info);
    }
  }

  bool super_team = false;
  auto findIt =
      std::find_if(unread_zero_info_list.begin(), unread_zero_info_list.end(),
                   [&super_team](const auto& it) {
                     if (nim::kNIMSessionTypeSuperTeam == it.type_) {
                       super_team = true;
                       return true;
                     } else {
                       return false;
                     }
                   });

  if (!nim::Session::SetMultiUnreadCountZeroAsync(
          super_team, unread_zero_info_list,
          [result, unread_zero_info_list](
              nim::NIMResCode res_code, const std::list<nim::SessionData>& ret,
              int unread_count) {
            if (!result) {
              return;
            }

            if (nim::kNIMResSuccess == res_code) {
              YXLOG(Info) << "setMultiUnreadCountZeroAsync, unread_count: "
                          << unread_count << YXLOGEnd;
              flutter::EncodableList replyList;
              auto sessionType = Convert::getInstance()->getSessionType();
              for (auto& it : ret) {
                auto findIt = std::find_if(
                    unread_zero_info_list.begin(), unread_zero_info_list.end(),
                    [it](const auto& it2) {
                      return it.id_ == it2.id_ && it.type_ == it2.type_;
                    });
                if (unread_zero_info_list.end() == findIt) {
                  flutter::EncodableMap mapTmp;
                  mapTmp[flutter::EncodableValue("sessionId")] = it.id_;

                  for (auto& it2 : sessionType) {
                    if (it2.second == it.type_) {
                      mapTmp[flutter::EncodableValue("sessionType")] =
                          it2.first;
                      break;
                    }
                  }

                  replyList.emplace_back(mapTmp);
                }
              }
              flutter::EncodableMap retList;
              retList[flutter::EncodableValue("failList")] = replyList;
              result->Success(NimResult::getSuccessResult(retList));
            } else {
              result->Error("", "",
                            NimResult::getErrorResult(
                                res_code, "clearSessionUnreadCount failed!"));
            }
          })) {
    if (result) {
      result->Error(
          "", "",
          NimResult::getErrorResult(-1, "clearSessionUnreadCount error!"));
    }
  }
}

void FLTMessageService::deleteSession(const flutter::EncodableMap* arguments,
                                      FLTService::MethodResult result) {
  std::string sessionId;
  nim::NIMSessionType sessionType = nim::kNIMSessionTypeP2P;
  // wjzh
  bool sendAck = false;
  // wjzh
  std::string deleteType;

  auto sendAckIt = arguments->find(flutter::EncodableValue("sendAck"));
  if (sendAckIt != arguments->end() && !sendAckIt->second.IsNull()) {
    sendAck = std::get<bool>(sendAckIt->second);
  }

  bool delete_roaming = false;
  auto deleteTypeIt = arguments->find(flutter::EncodableValue("deleteType"));
  if (deleteTypeIt != arguments->end() && !deleteTypeIt->second.IsNull()) {
    std::string deleteTypeTmp = std::get<std::string>(deleteTypeIt->second);
    std::transform(deleteTypeTmp.begin(), deleteTypeTmp.end(),
                   deleteTypeTmp.begin(), ::tolower);
    if (deleteTypeTmp == "localandremote") {
      delete_roaming = true;
    } else if (deleteTypeTmp == "remote") {
      if (result) {
        result->Error("", "",
                      NimResult::getErrorResult(
                          -1, "deleteSession but deleteType error!"));
      }
      return;
    }
  }

  auto sessionInfoIt = arguments->find(flutter::EncodableValue("sessionInfo"));
  if (sessionInfoIt != arguments->end() && !sessionInfoIt->second.IsNull()) {
    auto sessionInfoTmp =
        std::get<flutter::EncodableMap>(sessionInfoIt->second);
    auto sessionIdIt =
        sessionInfoTmp.find(flutter::EncodableValue("sessionId"));
    if (sessionIdIt != sessionInfoTmp.end() && !sessionIdIt->second.IsNull()) {
      sessionId = std::get<std::string>(sessionIdIt->second);
    }

    if (!Convert::getInstance()->convertSessionType(&sessionInfoTmp,
                                                    sessionType)) {
      if (result) {
        result->Error("", "",
                      NimResult::getErrorResult(
                          -1, "deleteSession but sessionType error!"));
      }
      return;
    }
  }

  if (!nim::Session::DeleteRecentSessionEx(
          sessionType, sessionId,
          [result](nim::NIMResCode res_code, const nim::SessionData& ret, int) {
            if (!result) {
              return;
            }

            if (nim::kNIMResSuccess == res_code) {
              result->Success(NimResult::getSuccessResult());
            } else {
              result->Error(
                  "", "",
                  NimResult::getErrorResult(res_code, "deleteSession failed!"));
            }
          },
          delete_roaming)) {
    if (result) {
      result->Error("", "",
                    NimResult::getErrorResult(-1, "deleteSession error!"));
    }
  }
}

void FLTMessageService::checkLocalAntiSpam(
    const flutter::EncodableMap* arguments, FLTService::MethodResult result) {
  std::string content;
  std::string replacement;

  auto contentIt = arguments->find(flutter::EncodableValue("content"));
  if (contentIt != arguments->end() && !contentIt->second.IsNull()) {
    content = std::get<std::string>(contentIt->second);
  }

  auto replacementIt = arguments->find(flutter::EncodableValue("replacement"));
  if (replacementIt != arguments->end() && !replacementIt->second.IsNull()) {
    replacement = std::get<std::string>(replacementIt->second);
  }

  nim::Tool::FilterClientAntispam(
      content, replacement, "",
      [result](bool succeed, int ret, const std::string& text) {
        if (!result) {
          return;
        }

        flutter::EncodableMap requestTmp;
        requestTmp[flutter::EncodableValue("operator")] = succeed ? 0 : ret;
        requestTmp[flutter::EncodableValue("content")] = text;
        result->Success(NimResult::getSuccessResult(requestTmp));
      });
}

void FLTMessageService::addQuickComment(const flutter::EncodableMap* arguments,
                                        FLTService::MethodResult result) {
  nim::IMMessage msg;
  nim::QuickCommentInfo info;
  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) continue;

    if (iter->first == flutter::EncodableValue("msg")) {
      auto messageMap = std::get<flutter::EncodableMap>(iter->second);
      std::string imMessageJson;
      if (!Convert::getInstance()->convert2IMMessage(&messageMap, msg,
                                                     imMessageJson)) {
        if (result) {
          result->Error("", "",
                        NimResult::getErrorResult(
                            -1, "addQuickComment but message error!"));
          return;
        }
      }

    } else if (iter->first == flutter::EncodableValue("replyType")) {
      info.reply_type = std::get<int>(iter->second);
    } else if (iter->first == flutter::EncodableValue("ext")) {
      info.ext = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("needPush")) {
      info.need_push = std::get<bool>(iter->second);
    } else if (iter->first == flutter::EncodableValue("needBadge")) {
      info.need_badge = std::get<bool>(iter->second);
    } else if (iter->first == flutter::EncodableValue("pushTitle")) {
      info.push_title = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("pushContent")) {
      info.push_content = std::get<std::string>(iter->second);
    }
  }

  nim::TalkEx::QuickComment::AddQuickComment(
      msg, info, [=](int code, const nim::QuickCommentInfo& commentInfo) {
        if (code == nim::kNIMResSuccess) {
          result->Success(NimResult::getSuccessResult());
        } else {
          result->Error(
              "", "",
              NimResult::getErrorResult(code, "addQuickComment failed"));
        }
      });
}

void FLTMessageService::removeQuickComment(
    const flutter::EncodableMap* arguments, FLTService::MethodResult result) {
  nim::IMMessage msg;
  nim::RemoveQuickCommentParam param;

  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) continue;

    if (iter->first == flutter::EncodableValue("msg")) {
      auto messageMap = std::get<flutter::EncodableMap>(iter->second);
      std::string imMessageJson;
      if (!Convert::getInstance()->convert2IMMessage(&messageMap, msg,
                                                     imMessageJson)) {
        if (result) {
          result->Error("", "",
                        NimResult::getErrorResult(
                            -1, "addQuickComment but message error!"));
          return;
        }
      }
    } else if (iter->first == flutter::EncodableValue("replyType")) {
      param.reply_type = std::get<int>(iter->second);
    } else if (iter->first == flutter::EncodableValue("ext")) {
      param.ext = std::get<std::string>(iter->second);
    }
  }

  nim::TalkEx::QuickComment::RemoveQuickComment(
      msg, param, [=](int code, const std::string& id) {
        if (code == nim::kNIMResSuccess) {
          result->Success(NimResult::getSuccessResult());
        } else {
          result->Error(
              "", "",
              NimResult::getErrorResult(code, "removeQuickComment failed"));
        }
      });
}

void FLTMessageService::queryQuickComment(
    const flutter::EncodableMap* arguments, FLTService::MethodResult result) {
  nim::QueryQuickCommentsParam query_param;
  auto messageListIt = arguments->find(flutter::EncodableValue("msgList"));
  if (messageListIt != arguments->end() && !messageListIt->second.IsNull()) {
    flutter::EncodableList messageListTmp =
        std::get<flutter::EncodableList>(messageListIt->second);
    for (auto& it : messageListTmp) {
      flutter::EncodableMap messageMapTmp = std::get<flutter::EncodableMap>(it);
      nim::IMMessage imMessage;
      std::string imMessageJson;
      if (Convert::getInstance()->convert2IMMessage(&messageMapTmp, imMessage,
                                                    imMessageJson)) {
        query_param.AddMessage(imMessage);
      }
    }
  }

  nim::TalkEx::QuickComment::QueryQuickCommentList(
      query_param,
      [=](int code, const nim::QueryQuickCommentsResponse& response) {
        if (code == nim::kNIMResSuccess) {
          flutter::EncodableMap resultMap;
          flutter::EncodableList commentOptionList;
          flutter::EncodableMap commentOptionMap;

          for (auto commentItem : response.message_quick_comment_list) {
            flutter::EncodableList commentList;
            for (auto commentInfo : commentItem.quick_comment_list) {
              flutter::EncodableMap commentMap;
              Convert::getInstance()->convertQuickCommentInfo2Map(commentInfo,
                                                                  commentMap);
              commentList.emplace_back(commentMap);
            }

            flutter::EncodableMap keyMap;
            Convert::getInstance()->convertMsgClientId2MsgKeyMap(
                commentItem.message_client_id, keyMap);
            commentOptionMap.insert(std::make_pair("key", keyMap));
            commentOptionMap.insert(
                std::make_pair("quickCommentList", commentList));
            commentOptionMap.insert(std::make_pair("modify", false));  // 不支持
            commentOptionMap.insert(std::make_pair("time", 0));  // 不支持
            commentOptionList.emplace_back(commentOptionMap);
          }

          resultMap.insert(std::make_pair("quickCommentOptionWrapperList",
                                          commentOptionList));
          result->Success(NimResult::getSuccessResult(resultMap));
        } else {
          result->Error(
              "", "",
              NimResult::getErrorResult(code, "queryQuickComment failed"));
        }
      });
}

void FLTMessageService::addCollect(const flutter::EncodableMap* arguments,
                                   FLTService::MethodResult result) {
  nim::CollectInfo collect_info;

  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) continue;

    if (iter->first == flutter::EncodableValue("type")) {
      collect_info.type = std::get<int>(iter->second);
    } else if (iter->first == flutter::EncodableValue("data")) {
      collect_info.data = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("ext")) {
      collect_info.ext = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("uniqueId")) {
      collect_info.unique_id = std::get<std::string>(iter->second);
    }
  }

  nim::TalkEx::Collect::AddCollect(
      collect_info, [=](int code, const nim::CollectInfo& info) {
        if (code == nim::kNIMResSuccess) {
          flutter::EncodableMap resultMap;
          resultMap.insert(std::make_pair("id", static_cast<int64_t>(info.id)));
          resultMap.insert(std::make_pair("type", info.type));
          resultMap.insert(std::make_pair("data", info.data));
          resultMap.insert(std::make_pair("ext", info.ext));
          resultMap.insert(std::make_pair("uniqueId", info.unique_id));
          resultMap.insert(std::make_pair(
              "createTime", static_cast<int64_t>(info.create_time)));
          resultMap.insert(std::make_pair(
              "updateTime", static_cast<int64_t>(info.update_time)));
          result->Success(NimResult::getSuccessResult(resultMap));
        } else {
          result->Error("", "",
                        NimResult::getErrorResult(code, "addCollect failed"));
        }
      });
}

void FLTMessageService::removeCollect(const flutter::EncodableMap* arguments,
                                      FLTService::MethodResult result) {
  nim::RemoveCollectsParm collect_list;

  auto collectsIt = arguments->find(flutter::EncodableValue("collects"));
  if (collectsIt == arguments->end() || collectsIt->second.IsNull()) {
    if (result) {
      result->Error("", "",
                    NimResult::getErrorResult(
                        -1, "removeCollect but collects is empty!"));
    }
    return;
  }

  auto collectsList = std::get<flutter::EncodableList>(collectsIt->second);
  for (auto collect : collectsList) {
    flutter::EncodableMap collectsMap =
        std::get<flutter::EncodableMap>(collect);
    auto iter = collectsMap.begin();
    nim::CollectInfo info;
    for (iter; iter != collectsMap.end(); ++iter) {
      if (iter->second.IsNull()) continue;

      if (iter->first == flutter::EncodableValue("id")) {
        info.id = std::get<int>(iter->second);
      } else if (iter->first == flutter::EncodableValue("type")) {
        info.type = std::get<int>(iter->second);
      } else if (iter->first == flutter::EncodableValue("data")) {
        info.data = std::get<std::string>(iter->second);
      } else if (iter->first == flutter::EncodableValue("ext")) {
        info.ext = std::get<std::string>(iter->second);
      } else if (iter->first == flutter::EncodableValue("uniqueId")) {
        info.unique_id = std::get<std::string>(iter->second);
      } else if (iter->first == flutter::EncodableValue("createTime")) {
        info.create_time = std::get<double>(iter->second);
      } else if (iter->first == flutter::EncodableValue("updateTime")) {
        info.update_time = std::get<double>(iter->second);
      }
    }

    collect_list.Add(info);
  }

  nim::TalkEx::Collect::RemoveCollects(collect_list, [=](int code, int count) {
    if (code == nim::kNIMResSuccess) {
      result->Success(
          NimResult::getSuccessResult(flutter::EncodableValue(count)));
    } else {
      result->Error("", "",
                    NimResult::getErrorResult(code, "removeCollect failed"));
    }
  });
}

void FLTMessageService::updateCollect(const flutter::EncodableMap* arguments,
                                      FLTService::MethodResult result) {
  uint64_t collet_create_time = 0;
  uint64_t collet_id = 0;
  std::string ext = "";

  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) continue;

    nim::CollectInfo info;
    if (iter->first == flutter::EncodableValue("id")) {
      collet_id = std::get<int>(iter->second);
    } else if (iter->first == flutter::EncodableValue("ext")) {
      ext = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("createTime")) {
      collet_create_time = std::get<double>(iter->second);
    }
  }

  nim::MatchCollectParm collect_match_param(collet_create_time, collet_id);
  nim::TalkEx::Collect::UpdateCollectExt(
      collect_match_param, ext, [=](int code, const nim::CollectInfo& info) {
        if (code == nim::kNIMResSuccess) {
          flutter::EncodableMap resultMap;
          resultMap.insert(std::make_pair("id", static_cast<int64_t>(info.id)));
          resultMap.insert(std::make_pair("type", info.type));
          resultMap.insert(std::make_pair("data", info.data));
          resultMap.insert(std::make_pair("ext", info.ext));
          resultMap.insert(std::make_pair("uniqueId", info.unique_id));
          resultMap.insert(std::make_pair(
              "createTime", static_cast<int64_t>(info.create_time)));
          resultMap.insert(std::make_pair(
              "updateTime", static_cast<int64_t>(info.update_time)));
          result->Success(NimResult::getSuccessResult(resultMap));
        } else {
          result->Error(
              "", "", NimResult::getErrorResult(code, "updateCollect failed"));
        }
      });
}

void FLTMessageService::queryCollect(const flutter::EncodableMap* arguments,
                                     FLTService::MethodResult result) {
  nim::QueryCollectsParm query_collect_list_param;

  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) continue;

    nim::CollectInfo info;
    if (iter->first == flutter::EncodableValue("anchor")) {
      auto anchorMap = std::get<flutter::EncodableMap>(iter->second);
      auto idIt = anchorMap.find(flutter::EncodableValue("id"));
      if (idIt == anchorMap.end() || idIt->second.IsNull()) {
        if (result) {
          result->Error(
              "", "",
              NimResult::getErrorResult(-1, "queryCollect but id is empty!"));
        }
        return;
      }
      query_collect_list_param.exclude_id = std::get<int>(iter->second);
    } else if (iter->first == flutter::EncodableValue("toTime")) {
      query_collect_list_param.to_time = iter->second.LongValue();
    } else if (iter->first == flutter::EncodableValue("type")) {
      query_collect_list_param.type = std::get<int>(iter->second);
    } else if (iter->first == flutter::EncodableValue("limit")) {
      query_collect_list_param.limit = std::get<int>(iter->second);
    } else if (iter->first == flutter::EncodableValue("direction")) {
      query_collect_list_param.reverse = std::get<int>(iter->second) == 0;
    }
  }

  nim::TalkEx::Collect::QueryCollectList(
      query_collect_list_param,
      [=](int code, int count, const nim::CollectInfoList& infoList) {
        if (code == nim::kNIMResSuccess) {
          flutter::EncodableMap resultMap;
          flutter::EncodableList collectList;
          for (auto info : infoList.list) {
            flutter::EncodableMap collectMap;
            collectMap.insert(
                std::make_pair("id", static_cast<int64_t>(info.id)));
            collectMap.insert(std::make_pair("type", info.type));
            collectMap.insert(std::make_pair("data", info.data));
            collectMap.insert(std::make_pair("ext", info.ext));
            collectMap.insert(std::make_pair("uniqueId", info.unique_id));
            collectMap.insert(std::make_pair(
                "createTime", static_cast<int64_t>(info.create_time)));
            collectMap.insert(std::make_pair(
                "updateTime", static_cast<int64_t>(info.update_time)));
            collectList.emplace_back(collectMap);
          }
          resultMap.insert(std::make_pair("collects", collectList));
          resultMap.insert(std::make_pair("totalCount", count));
          result->Success(NimResult::getSuccessResult(resultMap));
        } else {
          result->Error("", "",
                        NimResult::getErrorResult(code, "queryCollect failed"));
        }
      });
}

void FLTMessageService::addMessagePin(const flutter::EncodableMap* arguments,
                                      FLTService::MethodResult result) {
  nim::IMMessage msg;
  nim::PinMessageInfo pin_info;

  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) continue;

    if (iter->first == flutter::EncodableValue("message")) {
      auto messageMap = std::get<flutter::EncodableMap>(iter->second);
      std::string imMessageJson;
      if (!Convert::getInstance()->convert2IMMessage(&messageMap, msg,
                                                     imMessageJson)) {
        if (result) {
          result->Error("", "",
                        NimResult::getErrorResult(
                            -1, "addMessagePin but message error!"));
          return;
        }
      }
    } else if (iter->first == flutter::EncodableValue("ext")) {
      pin_info.ext = std::get<std::string>(iter->second);
    }
  }

  nim::TalkEx::PinMsg::AddPinMessage(
      msg, pin_info,
      [=](int code, const std::string& session, int to_type,
          const nim::PinMessageInfo& info) {
        if (code == nim::kNIMResSuccess) {
          result->Success(NimResult::getSuccessResult());
        } else {
          result->Error(
              "", "", NimResult::getErrorResult(code, "addMessagePin failed"));
        }
      });
}

void FLTMessageService::updateMessagePin(const flutter::EncodableMap* arguments,
                                         FLTService::MethodResult result) {
  nim::IMMessage msg;
  std::string ext = "";
  std::string sessionId = "";

  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) continue;

    if (iter->first == flutter::EncodableValue("message")) {
      auto messageMap = std::get<flutter::EncodableMap>(iter->second);
      std::string imMessageJson;
      if (!Convert::getInstance()->convert2IMMessage(&messageMap, msg,
                                                     imMessageJson)) {
        if (result) {
          result->Error("", "",
                        NimResult::getErrorResult(
                            -1, "updateMessagePin but message error!"));
          return;
        }
      }

      std::cout << "updateMessagePin imMessageJson: " << imMessageJson
                << std::endl;
    } else if (iter->first == flutter::EncodableValue("ext")) {
      ext = std::get<std::string>(iter->second);
    }
  }

  if (msg.sender_accid_ == NimCore::getInstance()->getAccountId()) {
    sessionId = msg.receiver_accid_;
  } else {
    sessionId = msg.sender_accid_;
  }

  nim::TalkEx::PinMsg::QueryAllPinMessage(
      sessionId, msg.type_,
      [=](int code, const std::string& session, int to_type,
          const nim::QueryAllPinMessageResponse& response) {
        if (code == nim::kNIMResSuccess) {
          for (auto pinInfo : response.pin_list) {
            if (pinInfo.client_id == msg.client_msg_id_) {
              nim::ModifyPinMessageParam modify_param;
              modify_param.session = pinInfo.session_id;
              modify_param.to_type = pinInfo.to_type;
              modify_param.id = pinInfo.id;
              modify_param.ext = ext;

              nim::TalkEx::PinMsg::UpdatePinMessage(
                  modify_param,
                  [=](int code_, const std::string& session, int to_type,
                      const nim::PinMessageInfo& info) {
                    if (code_ == nim::kNIMResSuccess) {
                      result->Success(NimResult::getSuccessResult());
                    } else {
                      result->Error("", "",
                                    NimResult::getErrorResult(
                                        code_, "updateMessagePin failed"));
                    }
                  });
              return;
            }
          }
        } else {
          result->Error(
              "", "",
              NimResult::getErrorResult(code, "updateMessagePin failed"));
        }
      });
}

void FLTMessageService::removeMessagePin(const flutter::EncodableMap* arguments,
                                         FLTService::MethodResult result) {
  nim::IMMessage msg;
  std::string ext = "";
  std::string sessionId = "";

  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) continue;

    if (iter->first == flutter::EncodableValue("message")) {
      auto messageMap = std::get<flutter::EncodableMap>(iter->second);
      std::string imMessageJson;
      if (!Convert::getInstance()->convert2IMMessage(&messageMap, msg,
                                                     imMessageJson)) {
        if (result) {
          result->Error("", "",
                        NimResult::getErrorResult(
                            -1, "removeMessagePin but message error!"));
          return;
        }
      }
    } else if (iter->first == flutter::EncodableValue("ext")) {
      ext = std::get<std::string>(iter->second);
    }
  }

  if (msg.sender_accid_ == NimCore::getInstance()->getAccountId()) {
    sessionId = msg.receiver_accid_;
  } else {
    sessionId = msg.sender_accid_;
  }

  nim::TalkEx::PinMsg::QueryAllPinMessage(
      sessionId, msg.session_type_,
      [=](int code, const std::string& session, int to_type,
          const nim::QueryAllPinMessageResponse& response) {
        if (code == nim::kNIMResSuccess) {
          for (auto pinInfo : response.pin_list) {
            if (pinInfo.client_id == msg.client_msg_id_) {
              nim::ModifyPinMessageParam modify_param;
              modify_param.session = pinInfo.session_id;
              modify_param.to_type = pinInfo.to_type;
              modify_param.id = pinInfo.id;
              modify_param.ext = ext;
              nim::TalkEx::PinMsg::UnPinMessage(
                  modify_param, [=](int code_, const std::string& session,
                                    int to_type, const std::string& id) {
                    if (code_ == nim::kNIMResSuccess) {
                      result->Success(NimResult::getSuccessResult());
                    } else {
                      result->Error("", "",
                                    NimResult::getErrorResult(
                                        code_, "removeMessagePin failed"));
                    }
                  });
              return;
            }
          }
        } else {
          result->Error(
              "", "",
              NimResult::getErrorResult(code, "removeMessagePin failed"));
        }
      });
}

void FLTMessageService::queryMessagePinForSession(
    const flutter::EncodableMap* arguments, FLTService::MethodResult result) {
  std::string session = "";
  nim::NIMSessionType sessionType = nim::kNIMSessionTypeP2P;

  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) continue;

    if (iter->first == flutter::EncodableValue("sessionId")) {
      session = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("sessionType")) {
      Convert::getInstance()->convertSessionType(arguments, sessionType);
      std::cout << "queryMessagePinForSession: " << sessionType << std::endl;
    }
  }
  nim::TalkEx::PinMsg::QueryAllPinMessage(
      session, static_cast<int>(sessionType),
      [=](int code, const std::string& sessionId, int to_type,
          const nim::QueryAllPinMessageResponse& response) {
        if (code == nim::kNIMResSuccess) {
          flutter::EncodableMap resultMap;
          flutter::EncodableList pinList;
          for (auto pin : response.pin_list) {
            flutter::EncodableMap pinMap;
            pinMap.insert(std::make_pair("sessionId", pin.session_id));
            std::string strSessionType = "p2p";
            Convert::getInstance()->convertNIMEnumToDartString(
                static_cast<nim::NIMSessionType>(to_type),
                Convert::getInstance()->getSessionType(), strSessionType);
            pinMap.insert(std::make_pair("sessionType", strSessionType));
            pinMap.insert(
                std::make_pair("messageFromAccount", pin.from_account));
            pinMap.insert(std::make_pair("messageToAccount", pin.to_account));
            pinMap.insert(std::make_pair("messageUuid", pin.client_id));
            pinMap.insert(std::make_pair("messageId", ""));
            pinMap.insert(std::make_pair("messageServerId",
                                         static_cast<int64_t>(pin.server_id)));
            pinMap.insert(
                std::make_pair("pinOperatorAccount", pin.operator_account));
            pinMap.insert(std::make_pair("pinExt", pin.ext));
            pinMap.insert(std::make_pair(
                "pinCreateTime", static_cast<int64_t>(pin.create_time)));
            pinMap.insert(std::make_pair(
                "pinUpdateTime", static_cast<int64_t>(pin.update_time)));
            pinList.emplace_back(pinMap);
          }
          resultMap.insert(std::make_pair("pinList", pinList));
          result->Success(NimResult::getSuccessResult(resultMap));
        } else {
          result->Error(
              "", "",
              NimResult::getErrorResult(code, "removeMessagePin failed"));
        }
      });
}

void FLTMessageService::queryMySessionList(
    const flutter::EncodableMap* arguments, FLTService::MethodResult result) {
  uint64_t minTimestamp = 0;
  auto it = arguments->find(flutter::EncodableValue("minTimestamp"));
  if (it != arguments->end() && !it->second.IsNull()) {
    minTimestamp = it->second.LongValue();
  }

  uint64_t maxTimestamp = 0;
  it = arguments->find(flutter::EncodableValue("maxTimestamp"));
  if (it != arguments->end() && !it->second.IsNull()) {
    maxTimestamp = it->second.LongValue();
  }

  bool need_last_msg = true;
  it = arguments->find(flutter::EncodableValue("needLastMsg"));
  if (it != arguments->end() && !it->second.IsNull()) {
    need_last_msg = (1 == std::get<int>(it->second));
  }

  int limit = 100;
  it = arguments->find(flutter::EncodableValue("limit"));
  if (it != arguments->end() && !it->second.IsNull()) {
    limit = std::get<int>(it->second);
  }

  // wjzh
  int hasMore = 100;
  it = arguments->find(flutter::EncodableValue("hasMore"));
  if (it != arguments->end() && !it->second.IsNull()) {
    hasMore = std::get<int>(it->second);
  }

  nim::SessionOnLineService::QuerySessionList(
      minTimestamp, maxTimestamp, need_last_msg, limit,
      [result](
          const nim::SessionOnLineServiceHelper::QuerySessionListResult& ret) {
        if (!result) {
          return;
        }

        if (nim::kNIMResSuccess == ret.res_code) {
          flutter::EncodableMap tmpRet;
          flutter::EncodableList retList;
          for (auto& it : ret.session_list_) {
            flutter::EncodableMap tmpSessionInfo;
            if (Convert::getInstance()->convertIMSessionInfo2Map(
                    it, tmpSessionInfo)) {
              retList.emplace_back(tmpSessionInfo);
            }
          }

          tmpRet[flutter::EncodableValue("hasMore")] = ret.has_more_;
          tmpRet[flutter::EncodableValue("sessionList")] = retList;
          flutter::EncodableMap tmp;
          tmp[flutter::EncodableValue("mySessionList")] = tmpRet;
          result->Success(NimResult::getSuccessResult(tmp));
        } else {
          result->Error(
              "", "",
              NimResult::getErrorResult(ret.res_code, "deleteSession failed!"));
        }
      });
}

void FLTMessageService::queryMySession(const flutter::EncodableMap* arguments,
                                       FLTService::MethodResult result) {
  std::string sessionId;
  auto sessionIdIt = arguments->find(flutter::EncodableValue("sessionId"));
  if (sessionIdIt != arguments->end() && !sessionIdIt->second.IsNull()) {
    sessionId = std::get<std::string>(sessionIdIt->second);
  }

  if (sessionId.empty()) {
    if (result) {
      result->Error(
          "", "",
          NimResult::getErrorResult(-1, "queryMySession but sessionId error!"));
    }
    return;
  }

  nim::NIMSessionType sessionType = nim::kNIMSessionTypeP2P;
  if (!Convert::getInstance()->convertSessionType(arguments, sessionType)) {
    if (result) {
      result->Error("", "",
                    NimResult::getErrorResult(
                        -1, "queryMySession but sessionType error!"));
    }
    return;
  }

  nim::SessionOnLineService::QuerySession(
      sessionType, sessionId,
      [result](nim::NIMResCode res_code,
               const nim::SessionOnLineServiceHelper::SessionInfo& ret) {
        if (!result) {
          return;
        }

        if (nim::kNIMResSuccess == res_code) {
          flutter::EncodableMap tmpSessionInfo;
          if (!Convert::getInstance()->convertIMSessionInfo2Map(
                  ret, tmpSessionInfo)) {
            YXLOG(Info) << "convertIMSessionInfo2Map failed." << YXLOGEnd;
          }
          flutter::EncodableMap tmp;
          tmp[flutter::EncodableValue("recentSession")] = tmpSessionInfo;
          result->Success(NimResult::getSuccessResult(tmp));
        } else {
          result->Error(
              "", "",
              NimResult::getErrorResult(res_code, "queryMySession failed!"));
        }
      });
}

void FLTMessageService::updateMySession(const flutter::EncodableMap* arguments,
                                        FLTService::MethodResult result) {
  std::string sessionId;
  auto sessionIdIt = arguments->find(flutter::EncodableValue("sessionId"));
  if (sessionIdIt != arguments->end() && !sessionIdIt->second.IsNull()) {
    sessionId = std::get<std::string>(sessionIdIt->second);
  }

  if (sessionId.empty()) {
    if (result) {
      result->Error(
          "", "",
          NimResult::getErrorResult(-1, "queryMySession but sessionId error!"));
    }
    return;
  }

  nim::NIMSessionType sessionType = nim::kNIMSessionTypeP2P;
  if (!Convert::getInstance()->convertSessionType(arguments, sessionType)) {
    if (result) {
      result->Error("", "",
                    NimResult::getErrorResult(
                        -1, "queryMySession but sessionType error!"));
    }
    return;
  }

  std::string ext;
  auto extIt = arguments->find(flutter::EncodableValue("ext"));
  if (extIt != arguments->end() && !extIt->second.IsNull()) {
    ext = std::get<std::string>(extIt->second);
  }

  nim::SessionOnLineService::UpdateSession(
      sessionType, sessionId, ext, [result](nim::NIMResCode res_code) {
        if (!result) {
          return;
        }

        if (nim::kNIMResSuccess == res_code) {
          result->Success(NimResult::getSuccessResult());
        } else {
          result->Error(
              "", "",
              NimResult::getErrorResult(res_code, "updateMySession failed!"));
        }
      });
}

void FLTMessageService::deleteMySession(const flutter::EncodableMap* arguments,
                                        FLTService::MethodResult result) {
  nim::SessionOnLineServiceHelper::DeleteSessionParam param;
  auto it = arguments->find(flutter::EncodableValue("sessionList"));
  if (it != arguments->end() && !it->second.IsNull()) {
    for (auto& it2 : std::get<flutter::EncodableList>(it->second)) {
      auto tmpMap = std::get<flutter::EncodableMap>(it2);
      std::string sessionId;
      auto sessionIdIt = tmpMap.find(flutter::EncodableValue("sessionId"));
      if (sessionIdIt != tmpMap.end() && !sessionIdIt->second.IsNull()) {
        sessionId = std::get<std::string>(sessionIdIt->second);
      }

      nim::NIMSessionType sessionType = nim::kNIMSessionTypeP2P;
      if (Convert::getInstance()->convertSessionType(&tmpMap, sessionType)) {
        param.AddSession(sessionType, sessionId);
      }
    }
  }

  if (param.delete_list_.empty()) {
    if (result) {
      result->Error("", "",
                    NimResult::getErrorResult(
                        -1, "deleteMySession but sessionList is empty!"));
    }
    return;
  }
  nim::SessionOnLineService::DeleteSession(
      param, [result](nim::NIMResCode res_code) {
        if (!result) {
          return;
        }

        if (nim::kNIMResSuccess == res_code) {
          result->Success(NimResult::getSuccessResult());
        } else {
          result->Error(
              "", "",
              NimResult::getErrorResult(res_code, "deleteMySession failed!"));
        }
      });
}

void FLTMessageService::addStickTopSession(
    const flutter::EncodableMap* arguments, FLTService::MethodResult result) {
  std::string sessionId;
  auto sessionIdIt = arguments->find(flutter::EncodableValue("sessionId"));
  if (sessionIdIt != arguments->end() && !sessionIdIt->second.IsNull()) {
    sessionId = std::get<std::string>(sessionIdIt->second);
  }
  if (sessionId.empty()) {
    if (result) {
      result->Error("", "",
                    NimResult::getErrorResult(
                        -1, "addStickTopSession but sessionId error!"));
    }
    return;
  }

  nim::NIMSessionType sessionType = nim::kNIMSessionTypeP2P;
  if (!Convert::getInstance()->convertSessionType(arguments, sessionType)) {
    if (result) {
      result->Error("", "",
                    NimResult::getErrorResult(
                        -1, "addStickTopSession but sessionType error!"));
    }
    return;
  }

  std::string ext;
  auto extIt = arguments->find(flutter::EncodableValue("ext"));
  if (extIt != arguments->end() && !extIt->second.IsNull()) {
    ext = std::get<std::string>(extIt->second);
  }

  nim::Session::SetToStickTopSession(
      sessionId, sessionType, ext,
      [result](nim::NIMResCode res_code, const nim::StickTopSession& session) {
        if (nim::kNIMResSuccess == res_code) {
          flutter::EncodableMap retTmp;
          Convert::getInstance()->convertIMStickTopSessionInfo2Map(
              session.stick_top_info_, retTmp);
          flutter::EncodableMap ret;
          ret[flutter::EncodableValue("stickTopSessionInfo")] = retTmp;
          result->Success(NimResult::getSuccessResult(ret));
        } else {
          result->Error("", "",
                        NimResult::getErrorResult(
                            res_code, "addStickTopSession failed!"));
        }
      });
}

void FLTMessageService::removeStickTopSession(
    const flutter::EncodableMap* arguments, FLTService::MethodResult result) {
  std::string sessionId;
  auto sessionIdIt = arguments->find(flutter::EncodableValue("sessionId"));
  if (sessionIdIt != arguments->end() && !sessionIdIt->second.IsNull()) {
    sessionId = std::get<std::string>(sessionIdIt->second);
  }
  if (sessionId.empty()) {
    if (result) {
      result->Error("", "",
                    NimResult::getErrorResult(
                        -1, "removeStickTopSession but sessionId error!"));
    }
    return;
  }

  nim::NIMSessionType sessionType = nim::kNIMSessionTypeP2P;
  if (!Convert::getInstance()->convertSessionType(arguments, sessionType)) {
    if (result) {
      result->Error("", "",
                    NimResult::getErrorResult(
                        -1, "removeStickTopSession but sessionType error!"));
    }
    return;
  }

  // wjzh
  std::string ext;
  auto extIt = arguments->find(flutter::EncodableValue("ext"));
  if (extIt != arguments->end() && !extIt->second.IsNull()) {
    ext = std::get<std::string>(extIt->second);
  }

  nim::Session::CancelToStickTopSession(
      sessionId, sessionType,
      [result](nim::NIMResCode res_code, const std::string& session_id,
               nim::NIMSessionType) {
        if (nim::kNIMResSuccess == res_code) {
          result->Success(NimResult::getSuccessResult());
        } else {
          result->Error("", "",
                        NimResult::getErrorResult(
                            res_code, "removeStickTopSession failed!"));
        }
      });
}

void FLTMessageService::updateStickTopSession(
    const flutter::EncodableMap* arguments, FLTService::MethodResult result) {
  std::string sessionId;
  auto sessionIdIt = arguments->find(flutter::EncodableValue("sessionId"));
  if (sessionIdIt != arguments->end() && !sessionIdIt->second.IsNull()) {
    sessionId = std::get<std::string>(sessionIdIt->second);
  }
  if (sessionId.empty()) {
    if (result) {
      result->Error("", "",
                    NimResult::getErrorResult(
                        -1, "updateStickTopSession but sessionId error!"));
    }
    return;
  }

  nim::NIMSessionType sessionType = nim::kNIMSessionTypeP2P;
  if (!Convert::getInstance()->convertSessionType(arguments, sessionType)) {
    if (result) {
      result->Error("", "",
                    NimResult::getErrorResult(
                        -1, "updateStickTopSession but sessionType error!"));
    }
    return;
  }

  std::string ext;
  auto extIt = arguments->find(flutter::EncodableValue("ext"));
  if (extIt != arguments->end() && !extIt->second.IsNull()) {
    ext = std::get<std::string>(extIt->second);
  }

  nim::Session::UpdateToStickTopSession(
      sessionId, sessionType, ext,
      [result](nim::NIMResCode res_code, const nim::StickTopSession& session) {
        if (nim::kNIMResSuccess == res_code) {
          flutter::EncodableMap retTmp;
          Convert::getInstance()->convertIMStickTopSessionInfo2Map(
              session.stick_top_info_, retTmp);
          flutter::EncodableMap ret;
          ret[flutter::EncodableValue("stickTopSessionInfo")] = retTmp;
          result->Success(NimResult::getSuccessResult(ret));
        } else {
          result->Error("", "",
                        NimResult::getErrorResult(
                            res_code, "updateStickTopSession failed!"));
        }
      });
}

void FLTMessageService::queryStickTopSession(
    const flutter::EncodableMap* arguments, FLTService::MethodResult result) {
  nim::Session::QueryStickTopSessionList(
      [result](nim::NIMResCode res_code,
               const nim::StickTopSessionList& sessionList) {
        if (nim::kNIMResSuccess == res_code) {
          flutter::EncodableMap ret;
          flutter::EncodableList retList;
          for (auto& it : sessionList.sessions_) {
            flutter::EncodableMap tmp;
            Convert::getInstance()->convertIMStickTopSessionInfo2Map(
                it.stick_top_info_, tmp);
            retList.emplace_back(tmp);
          }
          ret[flutter::EncodableValue("stickTopSessionInfoList")] = retList;
          result->Success(NimResult::getSuccessResult(ret));
        } else {
          result->Error("", "",
                        NimResult::getErrorResult(
                            res_code, "queryStickTopSession failed!"));
        }
      });
}

void FLTMessageService::clearAllSessionUnreadCount(
    const flutter::EncodableMap* arguments, FLTService::MethodResult result) {
  nim::Session::SetAllUnreadCountZeroAsync(
      [result](nim::NIMResCode res_code, const nim::SessionData&, int) {
        if (!result) {
          return;
        }

        if (nim::kNIMResSuccess == res_code) {
          result->Success(NimResult::getSuccessResult());
        } else {
          result->Error("", "",
                        NimResult::getErrorResult(
                            res_code, "clearAllSessionUnreadCount failed!"));
        }
      },
      "");
}

///////////////////////////////////////////////////////////////////////////////////////////////////
void FLTMessageService::SendMessageAttachmentProgress(
    const std::string& client_msg_id, int64_t completed_size,
    int64_t file_size) {
  flutter::EncodableMap ret;
  ret[flutter::EncodableValue("id")] = client_msg_id;
  ret[flutter::EncodableValue("progress")] =
      (0 == file_size) ? 0.0 : completed_size * 100 / (double)file_size;
  notifyEvent("onAttachmentProgress", ret);
}

void FLTMessageService::SendMessageCB(const nim::SendMessageArc& arc) {
  YXLOG(Info) << "sendMessageCB, msg_id_: " << arc.msg_id_
              << ", rescode_: " << arc.rescode_ << YXLOGEnd;
  std::lock_guard<std::recursive_mutex> lockGuard(m_mutexSendMsgResult);
  if (auto it = m_mapSendMsgResult.find(arc.msg_id_);
      m_mapSendMsgResult.end() != it) {
    if (it->second.pFileUpPrgCallback) {
      delete it->second.pFileUpPrgCallback;
      it->second.pFileUpPrgCallback = nullptr;
    }

    nim::IMMessage imMessage = it->second.imMessage;
    imMessage.client_msg_id_ = arc.msg_id_;
    imMessage.receiver_accid_ = arc.talk_id_;
    imMessage.timetag_ = arc.msg_timetag_;
    imMessage.third_party_callback_ext_ = arc.third_party_callback_ext_;
    imMessage.msg_setting_.anti_spam_res = arc.anti_spam_res_;

    if (nim::kNIMResSuccess == arc.rescode_) {
      imMessage.status_ = nim::kNIMMsgLogStatusSent;
      bool res = nim::MsgLog::QueryMsgByIDAysnc(
          arc.msg_id_, [=](nim::NIMResCode res_code, const std::string& msg_id,
                           const nim::IMMessage& msg) {
            nim::IMMessage tempMessage = imMessage;

            if (nim::kNIMResSuccess == res_code) {
              tempMessage = msg;
              tempMessage.status_ = nim::kNIMMsgLogStatusSent;
            } else {
              YXLOG(Info) << "sendMessage success but QueryMsgByIDAysnc failed."
                          << YXLOGEnd;
            }

            flutter::EncodableMap ret;
            if (!Convert::getInstance()->convertIMMessage2Map(ret,
                                                              tempMessage)) {
              YXLOG(Info) << "convertIMMessage2Map failed." << YXLOGEnd;
            }
            it->second.methodResult->Success(NimResult::getSuccessResult(ret));
            notifyEvent("onMessageStatus", ret);
            m_mapSendMsgResult.erase(it);
          });

      if (!res) {
        flutter::EncodableMap ret;
        if (!Convert::getInstance()->convertIMMessage2Map(ret, imMessage)) {
          YXLOG(Info) << "convertIMMessage2Map failed." << YXLOGEnd;
        }
        it->second.methodResult->Success(NimResult::getSuccessResult(ret));
        notifyEvent("onMessageStatus", ret);
        m_mapSendMsgResult.erase(it);
      }
    } else {
      it->second.methodResult->Error(
          "", "",
          NimResult::getErrorResult(arc.rescode_, "sendMessage failed!"));
      imMessage.status_ = nim::kNIMMsgLogStatusSendFailed;
      flutter::EncodableMap ret;
      if (!Convert::getInstance()->convertIMMessage2Map(ret, imMessage)) {
        YXLOG(Info) << "convertIMMessage2Map failed." << YXLOGEnd;
      }
      notifyEvent("onMessageStatus", ret);
      m_mapSendMsgResult.erase(it);
    }
  }
}

void FLTMessageService::ReceiveCB(const nim::IMMessage& arc) {
  YXLOG(Info) << "receiveCB, arc: " << arc.ToJsonString(true) << YXLOGEnd;
  flutter::EncodableMap imMessage;
  if (Convert::getInstance()->convertIMMessage2Map(imMessage, arc)) {
    flutter::EncodableList replyList;
    replyList.emplace_back(imMessage);
    flutter::EncodableMap ret;
    ret[flutter::EncodableValue("messageList")] = replyList;
    notifyEvent("onMessage", ret);
  } else {
    YXLOG(Warn) << "receiveCB convertIMMessage2Map failed." << YXLOGEnd;
  }
}

void FLTMessageService::ReceiveMessagesCB(
    const std::list<nim::IMMessage>& arc) {
  {
    std::string strLog;
    for (auto& it : arc) {
      if (strLog.empty()) {
        strLog = "[";
      } else {
        strLog.append(", ");
      }
      strLog.append(it.ToJsonString(true));
    }
    strLog.append("]");
    YXLOG(Info) << "receiveMessagesCB, arc: " << strLog << YXLOGEnd;
  }
  flutter::EncodableList replyList;
  for (auto& it : arc) {
    flutter::EncodableMap imMessage;
    if (Convert::getInstance()->convertIMMessage2Map(imMessage, it)) {
      replyList.emplace_back(imMessage);
    } else {
      // wjzh
    }
  }

  if (replyList.empty()) {
    YXLOG(Warn) << "replyList is empty." << YXLOGEnd;
    return;
  }
  flutter::EncodableMap ret;
  ret[flutter::EncodableValue("messageList")] = replyList;
  notifyEvent("onMessage", ret);
}

void FLTMessageService::ReceiveBroadcastMsgCB(
    const nim::BroadcastMessage& arc) {
  YXLOG(Info) << "receiveBroadcastMsgCB, body: " << arc.body_
              << ", time: " << arc.time_ << ", id: " << arc.id_
              << ", from_id: " << arc.from_id_ << YXLOGEnd;
  flutter::EncodableMap ret;
  ret[flutter::EncodableValue("id")] = arc.id_;
  ret[flutter::EncodableValue("fromAccount")] = arc.from_id_;
  ret[flutter::EncodableValue("time")] = arc.time_;
  ret[flutter::EncodableValue("content")] = arc.body_;
  notifyEvent("onBroadcastMessage", ret);
}

void FLTMessageService::RecallMsgsCB(
    const nim::NIMResCode res_code,
    const std::list<nim::RecallMsgNotify>& arc) {
  {
    std::string strLog;
    for (auto& it : arc) {
      if (strLog.empty()) {
        strLog = "[";
      } else {
        strLog.append(", ");
      }
      // strLog.append();
    }
    strLog.append("]");
    YXLOG(Info) << "recallMsgsCB, res_code: " << res_code << YXLOGEnd;
  }

  if (nim::kNIMResSuccess != res_code) {
    return;
  }

  for (auto& it : arc) {
    flutter::EncodableMap tmp;
    if (Convert::getInstance()->convertIMRecallMsgNotify2Map(it, tmp)) {
      notifyEvent("onMessageRevoked", tmp);
    }
  }
}

void FLTMessageService::MessageStatusChangedCB(
    const nim::MessageStatusChangedResult& arc) {
  YXLOG(Info) << "messageStatusChangedCB, rescode: " << arc.rescode_
              << YXLOGEnd;
  if (nim::kNIMResSuccess != arc.rescode_) {
    return;
  }

  flutter::EncodableList retList;
  for (auto& it : arc.results_) {
    flutter::EncodableMap tmp;
    tmp[flutter::EncodableValue("sessionId")] = it.talk_id_;
    tmp[flutter::EncodableValue("time")] = it.msg_timetag_;
    retList.emplace_back(tmp);
  }

  flutter::EncodableMap ret;
  ret[flutter::EncodableValue("messageReceiptList")] = retList;
  notifyEvent("onMessageReceipt", ret);
}

void FLTMessageService::TeamEventCB(const nim::TeamEvent& arc) {
  YXLOG(Info) << "teamEventCB, res_code: " << arc.res_code_
              << ", notification_id: " << arc.notification_id_ << YXLOGEnd;
  if (nim::kNIMResSuccess != arc.res_code_) {
    return;
  }

  if (nim::kNIMNotificationIdLocalGetTeamMsgUnreadList !=
      arc.notification_id_) {
    // wjzh
    return;
  }

  flutter::EncodableList retList;
  flutter::EncodableMap tmp;
  if (arc.src_data_.isMember("client_msg_id")) {
    tmp[flutter::EncodableValue("messageId")] =
        arc.src_data_["client_msg_id"].asString();
  }
  if (arc.src_data_.isMember("read")) {
    flutter::EncodableList listTmp;
    if (Convert::getInstance()->convertJson2List(listTmp,
                                                 arc.src_data_["read"])) {
      tmp[flutter::EncodableValue("ackCount")] = (int)listTmp.size();
    } else {
      // wjzh
    }
  }
  if (arc.src_data_.isMember("unread")) {
    flutter::EncodableList listTmp;
    if (Convert::getInstance()->convertJson2List(listTmp,
                                                 arc.src_data_["unread"])) {
      tmp[flutter::EncodableValue("unAckCount")] = (int)listTmp.size();
    } else {
      // wjzh
    }
  }

  // wjzh
  // ret[flutter::EncodableValue("newReaderAccount")] = it.msg_timetag_;
  retList.emplace_back(tmp);
  flutter::EncodableMap ret;
  ret[flutter::EncodableValue("teamMessageReceiptList")] = retList;
  notifyEvent("onTeamMessageReceipt", ret);
}

void FLTMessageService::ChangeCB(nim::NIMResCode res_code,
                                 const nim::SessionData& arc, int) {
  YXLOG(Info) << "changeCB, res_code: " << res_code
              << ", command: " << arc.command_ << ", id: " << arc.id_
              << ", unread_count: " << arc.unread_count_ << YXLOGEnd;
  if (nim::kNIMResSuccess != res_code) {
    return;
  }

  if (nim::kNIMSessionCommandAdd == arc.command_ ||
      nim::kNIMSessionCommandUpdate == arc.command_ ||
      nim::kNIMSessionCommandRemove == arc.command_) {
  } else {
    // wjzh
    return;
  }

  flutter::EncodableMap tmp;
  if (Convert::getInstance()->convertIMSessionData2Map(arc, tmp)) {
    flutter::EncodableList retList;
    retList.emplace_back(tmp);
    flutter::EncodableMap ret;
    ret[flutter::EncodableValue("data")] = retList;
    if (nim::kNIMSessionCommandAdd == arc.command_ ||
        nim::kNIMSessionCommandUpdate == arc.command_) {
      notifyEvent("onSessionUpdate", ret);
    } else if (nim::kNIMSessionCommandRemove == arc.command_) {
      notifyEvent("onSessionDelete", ret);
    }
  } else {
    YXLOG(Warn) << "convertIMSessionData2Map failed." << YXLOGEnd;
  }
}

void FLTMessageService::SessionChangedCB(
    const nim::SessionOnLineServiceHelper::SessionInfo& rec) {
  YXLOG(Info) << "sessionChangedCB, sessionId: " << rec.id_
              << ", sessionType: " << rec.type_
              << ", last_message_type: " << rec.last_message_type_ << YXLOGEnd;
  flutter::EncodableMap sessionInfo;
  if (Convert::getInstance()->convertIMSessionInfo2Map(rec, sessionInfo)) {
    notifyEvent("onMySessionUpdate", sessionInfo);
  } else {
    YXLOG(Warn) << "convertIMSessionInfo2Map failed." << YXLOGEnd;
  }
}

void FLTMessageService::AddPinMessageNotifyCB(const std::string& session,
                                              int to_type,
                                              const nim::PinMessageInfo& pin) {
  YXLOG(Info) << "AddPinMessageNotifyCB: session" << session << ", to_type"
              << to_type << YXLOGEnd;
  flutter::EncodableMap pinMap;
  if (Convert::getInstance()->convertPinMessageInfo2Map(session, pin, pinMap)) {
    notifyEvent("onMessagePinAdded", pinMap);
  } else {
    YXLOG(Warn) << "AddPinMessageNotifyCB convertPinMessageInfo2Map failed."
                << YXLOGEnd;
  }
}

void FLTMessageService::UnPinMessageNotifyCB(const std::string& session,
                                             int to_type,
                                             const std::string& id) {
  YXLOG(Info) << "UnPinMessageNotifyCB: session" << session << ", to_type"
              << to_type << ", id" << id << YXLOGEnd;
  flutter::EncodableMap pinMap;
  nim::PinMessageInfo pin;
  pin.to_type = to_type;
  pin.id = id;
  if (Convert::getInstance()->convertPinMessageInfo2Map(session, pin, pinMap)) {
    notifyEvent("onMessagePinRemoved", pinMap);
  } else {
    YXLOG(Warn) << "UnPinMessageNotifyCB convertPinMessageInfo2Map failed."
                << YXLOGEnd;
  }
}

void FLTMessageService::UpdatePinMessageNotifyCB(
    const std::string& session, int to_type, const nim::PinMessageInfo& pin) {
  YXLOG(Info) << "UpdatePinMessageNotifyCB: session" << session << ", to_type"
              << to_type << YXLOGEnd;
  flutter::EncodableMap pinMap;
  ;
  if (Convert::getInstance()->convertPinMessageInfo2Map(session, pin, pinMap)) {
    notifyEvent("onMessagePinUpdated", pinMap);
  } else {
    YXLOG(Warn) << "UpdatePinMessageNotifyCB convertPinMessageInfo2Map failed."
                << YXLOGEnd;
  }
}

void FLTMessageService::AddQuickCommentNotifyCB(
    const std::string& session, nim::NIMSessionType type,
    const std::string& msg_client_id, const nim::QuickCommentInfo& info) {
  YXLOG(Info) << "AddQuickCommentNotifyCB session: " << session
              << "type: " << type << "msg_client_id: " << msg_client_id
              << YXLOGEnd;
  flutter::EncodableMap commentMap;
  flutter::EncodableMap keyMap;
  Convert::getInstance()->convertMsgClientId2MsgKeyMap(msg_client_id, keyMap);
  std::string strSessionType = "p2p";
  Convert::getInstance()->convertNIMEnumToDartString(
      type, Convert::getInstance()->getSessionType(), strSessionType);
  keyMap.insert(std::make_pair("sessionType", strSessionType));
  commentMap.insert(std::make_pair("key", keyMap));

  flutter::EncodableMap commentOptionMap;
  Convert::getInstance()->convertQuickCommentInfo2Map(info, commentOptionMap);
  commentMap.insert(std::make_pair("commentOption", commentOptionMap));
  notifyEvent("onQuickCommentAdd", commentMap);
}

void FLTMessageService::RemoveQuickCommentNotifyCB(
    const std::string& session, nim::NIMSessionType type,
    const std::string& msg_client_id, const std::string& quick_comment_id,
    const std::string& ext) {
  YXLOG(Info) << "RemoveQuickCommentNotifyCB session: " << session
              << "type: " << type << "msg_client_id: " << msg_client_id
              << YXLOGEnd;
  flutter::EncodableMap commentMap;
  flutter::EncodableMap keyMap;
  Convert::getInstance()->convertMsgClientId2MsgKeyMap(msg_client_id, keyMap);
  std::string strSessionType = "p2p";
  Convert::getInstance()->convertNIMEnumToDartString(
      type, Convert::getInstance()->getSessionType(), strSessionType);
  keyMap.insert(std::make_pair("sessionType", strSessionType));
  commentMap.insert(std::make_pair("key", keyMap));

  flutter::EncodableMap commentOptionMap;
  nim::QuickCommentInfo info;
  info.ext = ext;
  info.client_id = msg_client_id;
  Convert::getInstance()->convertQuickCommentInfo2Map(info, commentOptionMap);
  commentMap.insert(std::make_pair("commentOption", commentOptionMap));
  notifyEvent("onQuickCommentRemove", commentMap);
}

void FLTMessageService::SetToStickTopSessionNotifyCB(
    const nim::StickTopSession& rec) {
  YXLOG(Info) << "setToStickTopSessionNotifyCB, sessionId: "
              << rec.stick_top_info_.id_
              << ", sessionType: " << rec.stick_top_info_.type_ << YXLOGEnd;
  flutter::EncodableMap sessionInfo;
  if (Convert::getInstance()->convertIMStickTopSessionInfo2Map(
          rec.stick_top_info_, sessionInfo)) {
    notifyEvent("onStickTopSessionAdd", sessionInfo);
  } else {
    YXLOG(Warn) << "convertIMStickTopSessionInfo2Map failed." << YXLOGEnd;
  }
}

void FLTMessageService::CancelStickTopSessionNotifyCB(
    const std::string& session_id, nim::NIMSessionType sessionType) {
  YXLOG(Info) << "cancelStickTopSessionNotifyCB, sessionId: " << session_id
              << ", sessionType: " << sessionType << YXLOGEnd;

  nim::StickTopSessionInfo stick_top_info;
  stick_top_info.id_ = session_id;
  stick_top_info.type_ = sessionType;
  flutter::EncodableMap sessionInfo;
  if (Convert::getInstance()->convertIMStickTopSessionInfo2Map(stick_top_info,
                                                               sessionInfo)) {
    notifyEvent("onStickTopSessionRemove", sessionInfo);
  } else {
    YXLOG(Warn) << "convertIMStickTopSessionInfo2Map failed." << YXLOGEnd;
  }
}

void FLTMessageService::UpdateStickTopSessionNotifyCB(
    const nim::StickTopSession& rec) {
  YXLOG(Info) << "updateStickTopSessionNotifyCB, sessionId: "
              << rec.stick_top_info_.id_
              << ", sessionType: " << rec.stick_top_info_.type_ << YXLOGEnd;

  flutter::EncodableMap sessionInfo;
  if (Convert::getInstance()->convertIMStickTopSessionInfo2Map(
          rec.stick_top_info_, sessionInfo)) {
    notifyEvent("onStickTopSessionUpdate", sessionInfo);
  } else {
    YXLOG(Warn) << "convertIMStickTopSessionInfo2Map failed." << YXLOGEnd;
  }
}
