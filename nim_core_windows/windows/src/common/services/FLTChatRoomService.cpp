// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#include "FLTChatRoomService.h"

#include <sstream>

#include "../FLTConvert.h"
#include "../NimResult.h"
#include "FLTMessageService.h"

FLTChatRoomService::FLTChatRoomService() { m_serviceName = "ChatroomService"; }

void FLTChatRoomService::onMethodCalled(
    const std::string& method, const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!checkChatRoomInit()) {
    result->Error("", "",
                  NimResult::getErrorResult(-1, "chatRoom init failed"));
    return;
  }

  if (method == "enterChatroom") {
    enterChatroom(arguments, result);
  } else if (method == "exitChatroom") {
    exitChatroom(arguments, result);
  } else if (method == "createMessage") {
    createMessage(arguments, result);
  } else if (method == "sendMessage") {
    sendMessage(arguments, result);
  } else if (method == "fetchMessageHistory") {
    fetchMessageHistory(arguments, result);
  } else if (method == "fetchChatroomInfo") {
    fetchChatroomInfo(arguments, result);
  } else if (method == "updateChatroomInfo") {
    updateChatroomInfo(arguments, result);
  } else if (method == "fetchChatroomMembers") {
    fetchChatroomMembers(arguments, result);
  } else if (method == "fetchChatroomMembersByAccount") {
    fetchChatroomMembersByAccount(arguments, result);
  } else if (method == "updateChatroomMyMemberInfo") {
    updateChatroomMyMemberInfo(arguments, result);
  } else if (method == "markChatroomMemberInBlackList") {
    markChatroomMemberInBlackList(arguments, result);
  } else if (method == "markChatroomMemberBeManager") {
    markChatroomMemberBeManager(arguments, result);
  } else if (method == "markChatroomMemberMuted") {
    markChatroomMemberMuted(arguments, result);
  } else if (method == "kickChatroomMember") {
    kickChatroomMember(arguments, result);
  } else if (method == "markChatroomMemberTempMuted") {
    markChatroomMemberTempMuted(arguments, result);
  } else if (method == "fetchChatroomQueue") {
    fetchChatroomQueue(arguments, result);
  } else if (method == "updateChatroomQueueEntry") {
    updateChatroomQueueEntry(arguments, result);
  } else if (method == "batchUpdateChatroomQueue") {
    batchUpdateChatroomQueue(arguments, result);
  } else if (method == "pollChatroomQueueEntry") {
    pollChatroomQueueEntry(arguments, result);
  } else if (method == "clearChatroomQueue") {
    clearChatroomQueue(arguments, result);
  } else {
    result->NotImplemented();
  }
}

bool FLTChatRoomService::checkChatRoomInit() {
  if (!m_init) {
    if (!nim_chatroom::ChatRoom::Init("")) {
      return false;
    }

    nim_chatroom::ChatRoom::UnregChatroomCb();
    nim_chatroom::ChatRoom::RegEnterCb(std::bind(
        &FLTChatRoomService::enterCallback, this, std::placeholders::_1,
        std::placeholders::_2, std::placeholders::_3, std::placeholders::_4,
        std::placeholders::_5));
    nim_chatroom::ChatRoom::RegExitCb_2(std::bind(
        &FLTChatRoomService::exitCallback, this, std::placeholders::_1,
        std::placeholders::_2, std::placeholders::_3));
    nim_chatroom::ChatRoom::RegReceiveMsgCb(
        std::bind(&FLTChatRoomService::receiveMsgCallback, this,
                  std::placeholders::_1, std::placeholders::_2));
    nim_chatroom::ChatRoom::RegSendMsgAckCb(std::bind(
        &FLTChatRoomService::sendMsgAckCallback, this, std::placeholders::_1,
        std::placeholders::_2, std::placeholders::_3));
    nim_chatroom::ChatRoom::RegLinkConditionCb(
        std::bind(&FLTChatRoomService::linkConditionCallback, this,
                  std::placeholders::_1, std::placeholders::_2));
    nim_chatroom::ChatRoom::RegNotificationCb(
        std::bind(&FLTChatRoomService::notificationCallback, this,
                  std::placeholders::_1, std::placeholders::_2));
  }

  return true;
}

void FLTChatRoomService::enterChatroom(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  uint64_t roomId = 0;
  nim_chatroom::ChatRoomEnterInfo enterInfo;
  flutter::EncodableMap independentConfigMap;
  std::list<std::string> login_tags;
  std::string notifyTargetTags = "";
  bool useIndependentMode = false;

  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("roomId")) {
      roomId =
          strtoull(std::get<std::string>(iter->second).c_str(), nullptr, 0);
    } else if (iter->first == flutter::EncodableValue("nickname")) {
      std::string nickname = std::get<std::string>(iter->second);
      enterInfo.SetNick(nickname);
    } else if (iter->first == flutter::EncodableValue("avatar")) {
      std::string avatar = std::get<std::string>(iter->second);
      enterInfo.SetAvatar(avatar);
    } else if (iter->first == flutter::EncodableValue("extension")) {
      flutter::EncodableMap extensionMap =
          std::get<flutter::EncodableMap>(iter->second);
      nim_cpp_wrapper_util::Json::Value extensionValue;
      Convert::getInstance()->convertMap2Json(&extensionMap, extensionValue);
      std::cout << "extension: "
                << nim::GetJsonStringWithNoStyled(extensionValue);
      enterInfo.SetExt(extensionValue);
    } else if (iter->first == flutter::EncodableValue("notifyExtension")) {
      flutter::EncodableMap notifyExtensionMap =
          std::get<flutter::EncodableMap>(iter->second);
      nim_cpp_wrapper_util::Json::Value value;
      Convert::getInstance()->convertMap2Json(&notifyExtensionMap, value);
      enterInfo.SetNotifyExt(value);
    } else if (iter->first == flutter::EncodableValue("tags")) {
      flutter::EncodableList tags =
          std::get<flutter::EncodableList>(iter->second);
      for (auto tag : tags) {
        login_tags.emplace_back(std::get<std::string>(tag));
      }
      enterInfo.SetLoginTag(login_tags);
    } else if (iter->first == flutter::EncodableValue("notifyTargetTags")) {
      notifyTargetTags = std::get<std::string>(iter->second);
      enterInfo.SetNotifyTags(notifyTargetTags);
    } else if (iter->first == flutter::EncodableValue("retryCount")) {
      // 不支持的字段
    } else if (iter->first ==
               flutter::EncodableValue("desktopIndependentModeConfig")) {
      useIndependentMode = true;
      independentConfigMap = std::get<flutter::EncodableMap>(iter->second);
      std::cout << "useIndependentMode" << std::endl;
    }
  }

  if (useIndependentMode) {
    nim_chatroom::ChatRoomIndependentEnterInfo independentEnterInfo;
    bool useAnonymousMode = true;

    auto independent_iter = independentConfigMap.begin();
    for (independent_iter; independent_iter != independentConfigMap.end();
         ++independent_iter) {
      if (independent_iter->second.IsNull()) {
        continue;
      }
      if (independent_iter->first == flutter::EncodableValue("appKey")) {
        independentEnterInfo.app_key_ =
            std::get<std::string>(independent_iter->second);
      } else if (independent_iter->first ==
                 flutter::EncodableValue("linkAddresses")) {
        flutter::EncodableList linkAddresses =
            std::get<flutter::EncodableList>(independent_iter->second);
        for (auto address : linkAddresses) {
          independentEnterInfo.address_.emplace_back(
              std::get<std::string>(address));
        }
      } else if (independent_iter->first ==
                 flutter::EncodableValue("account")) {
        independentEnterInfo.accid_ =
            std::get<std::string>(independent_iter->second);
        if (!independentEnterInfo.accid_.empty()) {
          useAnonymousMode = false;
        }
      } else if (independent_iter->first == flutter::EncodableValue("token")) {
        independentEnterInfo.token_ =
            std::get<std::string>(independent_iter->second);
      }
    }
    independentEnterInfo.login_tags_ = login_tags;
    independentEnterInfo.notify_tags_ = notifyTargetTags;

    if (useAnonymousMode) {
      nim_chatroom::ChatRoomAnoymityEnterInfo anonymity_info;
      anonymity_info.app_key_ = independentEnterInfo.app_key_;
      anonymity_info.address_ = independentEnterInfo.address_;
      // anonymity_info.login_tags_ = independentEnterInfo.login_tags_;
      // anonymity_info.notify_tags_ = independentEnterInfo.notify_tags_;
      YXLOG(Info) << "start AnonymousEnter..." << YXLOGEnd;
      if (nim_chatroom::ChatRoom::AnonymousEnter(roomId, anonymity_info,
                                                 enterInfo)) {
        m_enterResult = result;
      } else {
        YXLOG(Info) << "AnonymousEnter failed" << YXLOGEnd;
        result->Error("", "",
                      NimResult::getErrorResult(-1, "enterChatroom failed"));
      }
    } else {
      YXLOG(Info) << "start IndependentEnter..." << YXLOGEnd;
      if (nim_chatroom::ChatRoom::IndependentEnter(roomId,
                                                   independentEnterInfo)) {
        m_enterResult = result;
      } else {
        YXLOG(Info) << "IndependentEnter failed" << YXLOGEnd;
        result->Error("", "",
                      NimResult::getErrorResult(-1, "enterChatroom failed"));
      }
    }
  } else {
    YXLOG(Info) << "start normal Enter..." << YXLOGEnd;
    nim::PluginIn::ChatRoomRequestEnterAsync(
        roomId, [=](int error_code, const std::string& strResult) {
          if (error_code != nim::kNIMResSuccess) {
            YXLOG(Info) << "ChatRoomRequestEnterAsync failed" << YXLOGEnd;
            result->Error(
                "", "",
                NimResult::getErrorResult(error_code, "enterChatroom failed"));
            return;
          }

          m_enterResult = result;
          if (!nim_chatroom::ChatRoom::Enter(roomId, strResult, enterInfo)) {
            YXLOG(Info) << "Enter failed" << YXLOGEnd;
            result->Error(
                "", "", NimResult::getErrorResult(-1, "enterChatroom failed"));
            m_enterResult.reset();
          }
        });
  }
}

void FLTChatRoomService::exitChatroom(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  std::string strRoomId = "";
  auto iter = arguments->find(flutter::EncodableValue("roomId"));
  if (iter != arguments->end()) {
    if (iter->second.IsNull()) {
      result->Error("", "",
                    NimResult::getErrorResult(-1, "exitChatroom params error"));
      return;
    }

    strRoomId = std::get<std::string>(iter->second);
  }

  uint64_t roomId = strtoull(strRoomId.c_str(), nullptr, 0);
  nim_chatroom::ChatRoom::Exit(roomId);
  m_exitResult = result;
}

void FLTChatRoomService::createMessage(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  flutter::EncodableMap attachment;
  std::string strRoomId;
  std::string strMessageType;
  std::string strMessageText;

  nim_chatroom::ChatRoomMessage message;

  auto iter = arguments->find(flutter::EncodableValue("roomId"));
  if (iter != arguments->end()) {
    if (iter->second.IsNull()) {
      result->Error(
          "", "",
          NimResult::getErrorResult(-1, "createChatRoomMessage params error"));
      return;
    }

    strRoomId = std::get<std::string>(iter->second);
  }

  iter = arguments->find(flutter::EncodableValue("messageType"));
  if (iter != arguments->end()) {
    if (iter->second.IsNull()) {
      result->Error(
          "", "",
          NimResult::getErrorResult(-1, "createChatRoomMessage params error"));
      return;
    }

    strMessageType = std::get<std::string>(iter->second);
    if (strMessageType != "custom" && strMessageType != "text") {
      result->Error(
          "", "",
          NimResult::getErrorResult(-1,
                                    "createChatRoomMessage params error, Only "
                                    "supports custom and text"));
      return;
    }
  }

  if (strMessageType == "custom") {
    iter = arguments->find(flutter::EncodableValue("attachment"));
    if (iter != arguments->end()) {
      if (iter->second.IsNull()) {
        result->Error(
            "", "",
            NimResult::getErrorResult(
                -1, "createChatRoomMessage params error, attachment is empty"));
        return;
      }

      attachment = std::get<flutter::EncodableMap>(iter->second);
      nim_cpp_wrapper_util::Json::Value value;
      Convert::getInstance()->convertMap2Json(&attachment, value);
      value["messageType"] = "custom";
      message.msg_attach_ = nim::GetJsonStringWithNoStyled(value);
      message.msg_type_ = nim_chatroom::kNIMChatRoomMsgTypeCustom;
    }
  } else if (strMessageType == "text") {
    iter = arguments->find(flutter::EncodableValue("text"));
    if (iter != arguments->end()) {
      if (iter->second.IsNull()) {
        result->Error(
            "", "",
            NimResult::getErrorResult(
                -1, "createChatRoomMessage params error, text is empty"));
        return;
      }

      strMessageText = std::get<std::string>(iter->second);
      message.msg_attach_ = strMessageText;
      message.msg_body_ = "";
      message.msg_type_ = nim_chatroom::kNIMChatRoomMsgTypeText;
      YXLOG(Info) << "createMessage message.msg_attach_" << message.msg_attach_
                  << YXLOGEnd;
    }
  }

  message.client_msg_id_ = Convert::getInstance()->getUUID();
  flutter::EncodableMap messageMap;
  convertNimMessageToDartMessage(message, messageMap);
  result->Success(NimResult::getSuccessResult(messageMap));
}

void FLTChatRoomService::sendMessage(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  nim_chatroom::ChatRoomMessage message;
  if (!convertDartMessageToNimMessage(message, arguments)) {
    result->Error("", "",
                  NimResult::getErrorResult(-1, "send chatroomMessage failed"));
    return;
  }

  std::string strMessage = nim_chatroom::ChatRoom::CreateRoomMessage(
      message.msg_type_, message.client_msg_id_, message.msg_attach_,
      message.msg_body_, message.msg_setting_, message.timetag_,
      message.sub_type_);

  YXLOG(Info) << " SendMsg" << strMessage << YXLOGEnd;
  nim_chatroom::ChatRoom::SendMsg(m_roomId, strMessage);
  m_sendMsgResultMap[message.client_msg_id_] = result;
}

void FLTChatRoomService::fetchMessageHistory(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  uint64_t roomId = 0;
  nim_chatroom::ChatRoomGetMsgHistoryParameters parameters;

  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("roomId")) {
      roomId =
          strtoull(std::get<std::string>(iter->second).c_str(), nullptr, 0);
    } else if (iter->first == flutter::EncodableValue("startTime")) {
      parameters.start_timetag_ = iter->second.LongValue();
    } else if (iter->first == flutter::EncodableValue("limit")) {
      parameters.limit_ = std::get<int>(iter->second);
    } else if (iter->first == flutter::EncodableValue("direction")) {
      parameters.reverse_ = std::get<int>(iter->second) == 1;
    } else if (iter->first == flutter::EncodableValue("messageTypeList")) {
      flutter::EncodableList messageTypeList =
          std::get<flutter::EncodableList>(iter->second);
      for (auto messageType : messageTypeList) {
        std::string strMessageType = std::get<std::string>(messageType);
        ;
        nim::NIMMessageType type;
        Convert::getInstance()->convertDartStringToNIMEnum(
            strMessageType, Convert::getInstance()->getMessageType(), type);
        parameters.msg_types_.emplace_back(
            static_cast<nim_chatroom::NIMChatRoomMsgType>(type));
      }
    }
  }

  nim_chatroom::ChatRoom::GetMessageHistoryOnlineAsync(
      roomId, parameters,
      [=](int64_t room_id, int error_code,
          const std::list<nim_chatroom::ChatRoomMessage>& msgs) {
        if (error_code == nim::kNIMResSuccess) {
          flutter::EncodableList messageList;
          for (auto msg : msgs) {
            flutter::EncodableMap messageMap;
            convertNimMessageToDartMessage(msg, messageMap);
            messageList.emplace_back(messageMap);
          }
          result->Success(NimResult::getSuccessResult(messageList));
        } else {
          result->Error("", "",
                        NimResult::getErrorResult(
                            error_code, "fetchMessageHistory failed"));
        }
      });
}

void FLTChatRoomService::fetchChatroomInfo(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  std::string strRoomId = "";
  auto iter = arguments->find(flutter::EncodableValue("roomId"));
  if (iter != arguments->end()) {
    if (iter->second.IsNull()) {
      result->Error(
          "", "",
          NimResult::getErrorResult(-1, "fetchChatroomInfo params error"));
      return;
    }

    strRoomId = std::get<std::string>(iter->second);
  }

  uint64_t roomId = strtoull(strRoomId.c_str(), nullptr, 0);
  nim_chatroom::ChatRoom::GetInfoAsync(
      roomId, [=](int64_t room_id, int error_code,
                  const nim_chatroom::ChatRoomInfo& info) {
        if (error_code == nim::kNIMResSuccess) {
          flutter::EncodableMap chatRoomInfo;
          chatRoomInfo.insert(std::make_pair("roomId", strRoomId));
          chatRoomInfo.insert(std::make_pair("name", info.name_));
          chatRoomInfo.insert(
              std::make_pair("announcement", info.announcement_));
          chatRoomInfo.insert(
              std::make_pair("broadcastUrl", info.broadcast_url_));
          chatRoomInfo.insert(std::make_pair("creator", info.creator_id_));
          chatRoomInfo.insert(std::make_pair("validFlag", info.valid_flag_));
          chatRoomInfo.insert(
              std::make_pair("onlineUserCount", info.online_count_));
          chatRoomInfo.insert(std::make_pair("mute", info.mute_all_));
          flutter::EncodableMap extensionMap;
          nim_cpp_wrapper_util::Json::Value value =
              Convert::getInstance()->getJsonValueFromJsonString(info.ext_);
          Convert::getInstance()->convertJson2Map(extensionMap, value);
          chatRoomInfo.insert(std::make_pair("extension", extensionMap));
          std::string strQueuelevel = "";
          Convert::getInstance()->convertNIMEnumToDartString(
              info.queuelevel,
              Convert::getInstance()->getChatroomQueueModificationLevel(),
              strQueuelevel);
          chatRoomInfo.insert(
              std::make_pair("queueModificationLevel", strQueuelevel));
          result->Success(NimResult::getSuccessResult(chatRoomInfo));
        } else {
          result->Error("", "",
                        NimResult::getErrorResult(error_code,
                                                  "fetchChatroomInfo failed"));
        }
      });
}

void FLTChatRoomService::updateChatroomInfo(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  uint64_t roomId = 0;
  bool needNotify = false;
  std::string strNotifyExtension = "";
  nim_chatroom::ChatRoomInfo roomInfo;

  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("roomId")) {
      roomId =
          strtoull(std::get<std::string>(iter->second).c_str(), nullptr, 0);
      roomInfo.id_ = roomId;
    } else if (iter->first == flutter::EncodableValue("request")) {
      flutter::EncodableMap requestMap =
          std::get<flutter::EncodableMap>(iter->second);
      auto request_iter = requestMap.begin();
      for (request_iter; request_iter != requestMap.end(); ++request_iter) {
        if (request_iter->second.IsNull()) {
          continue;
        }

        if (request_iter->first == flutter::EncodableValue("announcement")) {
          roomInfo.announcement_ = std::get<std::string>(request_iter->second);
        } else if (request_iter->first ==
                   flutter::EncodableValue("broadcastUrl")) {
          roomInfo.broadcast_url_ = std::get<std::string>(request_iter->second);
        } else if (request_iter->first ==
                   flutter::EncodableValue("extension")) {
          flutter::EncodableMap extensionMap =
              std::get<flutter::EncodableMap>(request_iter->second);
          nim_cpp_wrapper_util::Json::Value value;
          Convert::getInstance()->convertMap2Json(&extensionMap, value);
          roomInfo.ext_ = nim::GetJsonStringWithNoStyled(value);
        } else if (request_iter->first ==
                   flutter::EncodableValue("queueModificationLevel")) {
          std::string strLevel = std::get<std::string>(request_iter->second);
          Convert::getInstance()->convertDartStringToNIMEnum(
              strLevel,
              Convert::getInstance()->getChatroomQueueModificationLevel(),
              roomInfo.queuelevel);
        }
      }
    } else if (iter->first == flutter::EncodableValue("needNotify")) {
      needNotify = std::get<bool>(iter->second);
    } else if (iter->first == flutter::EncodableValue("notifyExtension")) {
      flutter::EncodableMap notifyExtensionMap =
          std::get<flutter::EncodableMap>(iter->second);
      nim_cpp_wrapper_util::Json::Value value;
      Convert::getInstance()->convertMap2Json(&notifyExtensionMap, value);
      strNotifyExtension = nim::GetJsonStringWithNoStyled(value);
    }
  }

  nim_chatroom::ChatRoom::UpdateRoomInfoAsync(
      roomId, roomInfo, needNotify, strNotifyExtension,
      [=](int64_t room_id, int error_code) {
        if (error_code == nim::kNIMResSuccess) {
          result->Success(NimResult::getSuccessResult());
        } else {
          result->Error("", "",
                        NimResult::getErrorResult(error_code,
                                                  "updateChatroomInfo failed"));
        }
      });
}

void FLTChatRoomService::fetchChatroomMembers(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  int64_t roomId = 0;
  std::string lastMemberAccount = "";
  nim_chatroom::ChatRoomGetMembersParameters params;
  params.timestamp_offset_ = 0;

  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("roomId")) {
      roomId = strtoll(std::get<std::string>(iter->second).c_str(), nullptr, 0);
    } else if (iter->first == flutter::EncodableValue("queryType")) {
      int queryType = static_cast<nim_chatroom::NIMChatRoomGetMemberType>(
          std::get<int>(iter->second));
      switch (queryType) {
        case 0:
          params.type_ = nim_chatroom::kNIMChatRoomGetMemberTypeSolid;
          break;
        case 1:
          params.type_ = nim_chatroom::kNIMChatRoomGetMemberTypeSolidOL;
          break;
        case 2:
          params.type_ = nim_chatroom::kNIMChatRoomGetMemberTypeTempOL;
          break;
        case 3:
          params.type_ = nim_chatroom::kNIMChatRoomGetMemberTypeTemp;
          break;
        default:
          break;
      }

      YXLOG(Info) << "params.type_ : " << params.type_ << YXLOGEnd;
    } else if (iter->first == flutter::EncodableValue("limit")) {
      params.limit_ = std::get<int>(iter->second);
    } else if (iter->first == flutter::EncodableValue("lastMemberAccount")) {
      lastMemberAccount = std::get<std::string>(iter->second);
    }
  }

  if (!lastMemberAccount.empty()) {
    std::list<std::string> ids;
    ids.emplace_back(lastMemberAccount);
    nim_chatroom::ChatRoom::GetMemberInfoByIDsAsync(
        roomId, ids,
        [&, result](int64_t room_id, int error_code,
                    const std::list<nim_chatroom::ChatRoomMemberInfo>& infos) {
          if (error_code == nim::kNIMResSuccess) {
            if (infos.size() > 0) {
              for (auto info : infos) {
                params.timestamp_offset_ = info.enter_timetag_;
                std::cout << "params.timestamp_offset_"
                          << params.timestamp_offset_ << std::endl;
                break;
              }

              nim_chatroom::ChatRoom::GetMembersOnlineAsync(
                  room_id, params,
                  [=](int64_t room_id, int error_code,
                      const std::list<nim_chatroom::ChatRoomMemberInfo>&
                          infos_) {
                    if (error_code == nim::kNIMResSuccess) {
                      flutter::EncodableMap result_map;
                      flutter::EncodableList memberInfoList;
                      for (auto info : infos_) {
                        flutter::EncodableMap memberInfoMap =
                            convertChatRoomMemberInfoToMap(info);
                        memberInfoList.emplace_back(memberInfoMap);
                      }

                      result_map.insert(
                          std::make_pair("memberList", memberInfoList));
                      result->Success(NimResult::getSuccessResult(result_map));
                    } else {
                      result->Error(
                          "", "",
                          NimResult::getErrorResult(
                              error_code, "fetchChatroomMembers failed"));
                    }
                  });
            } else {
              result->Error(
                  "", "",
                  NimResult::getErrorResult(-1,
                                            "fetchChatroomMembers failed, "
                                            "lastMemberAccount not found"));
            }
          } else {
            result->Error(
                "", "",
                NimResult::getErrorResult(-1,
                                          "fetchChatroomMembers failed, "
                                          "lastMemberAccount not found"));
          }
        });
  } else {
    nim_chatroom::ChatRoom::GetMembersOnlineAsync(
        roomId, params,
        [=](int64_t room_id, int error_code,
            const std::list<nim_chatroom::ChatRoomMemberInfo>& infos_) {
          if (error_code == nim::kNIMResSuccess) {
            flutter::EncodableMap result_map;
            flutter::EncodableList memberInfoList;
            for (auto info : infos_) {
              flutter::EncodableMap memberInfoMap =
                  convertChatRoomMemberInfoToMap(info);
              memberInfoList.emplace_back(memberInfoMap);
            }

            result_map.insert(std::make_pair("memberList", memberInfoList));
            result->Success(NimResult::getSuccessResult(result_map));
          } else {
            result->Error("", "",
                          NimResult::getErrorResult(
                              error_code, "fetchChatroomMembers failed"));
          }
        });
  }
}

void FLTChatRoomService::fetchChatroomMembersByAccount(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  uint64_t roomId = 0;
  std::list<std::string> ids;

  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("roomId")) {
      roomId =
          strtoull(std::get<std::string>(iter->second).c_str(), nullptr, 0);
    } else if (iter->first == flutter::EncodableValue("accountList")) {
      flutter::EncodableList accountList =
          std::get<flutter::EncodableList>(iter->second);
      for (auto account : accountList) {
        ids.emplace_back(std::get<std::string>(account));
      }
    }
  }

  nim_chatroom::ChatRoom::GetMemberInfoByIDsAsync(
      roomId, ids,
      [=](int64_t room_id, int error_code,
          const std::list<nim_chatroom::ChatRoomMemberInfo>& infos) {
        if (error_code == nim::kNIMResSuccess) {
          flutter::EncodableMap result_map;
          flutter::EncodableList memberInfoList;
          for (auto info : infos) {
            flutter::EncodableMap memberInfoMap =
                convertChatRoomMemberInfoToMap(info);
            memberInfoList.emplace_back(memberInfoMap);
          }

          result_map.insert(std::make_pair("memberList", memberInfoList));
          result->Success(NimResult::getSuccessResult(result_map));
        } else {
          result->Error(
              "", "",
              NimResult::getErrorResult(
                  error_code, "fetchChatroomMembersByAccount failed"));
        }
      });
}

void FLTChatRoomService::updateChatroomMyMemberInfo(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  std::cout << "FLTChatRoomService::updateChatroomMyMemberInfo" << std::endl;
  YXLOG(Info) << "FLTChatRoomService::updateChatroomMyMemberInfo." << YXLOGEnd;

  if (!arguments) {
    return;
  }

  uint64_t roomId = 0;
  bool needNotify = false;
  std::string strNotifyExtension = "";
  nim_chatroom::ChatRoomMemberInfo memberInfo;
  std::string needSaveJson = "";

  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("roomId")) {
      roomId =
          strtoull(std::get<std::string>(iter->second).c_str(), nullptr, 0);
    } else if (iter->first == flutter::EncodableValue("request")) {
      flutter::EncodableMap requestMap =
          std::get<flutter::EncodableMap>(iter->second);
      auto request_iter = requestMap.begin();
      for (request_iter; request_iter != requestMap.end(); ++request_iter) {
        if (request_iter->second.IsNull()) {
          continue;
        }

        if (request_iter->first == flutter::EncodableValue("nickname")) {
          memberInfo.nick_ = std::get<std::string>(request_iter->second);
        } else if (request_iter->first == flutter::EncodableValue("avatar")) {
          memberInfo.avatar_ = std::get<std::string>(request_iter->second);
        } else if (request_iter->first ==
                   flutter::EncodableValue("extension")) {
          YXLOG(Info) << "updateChatroomMyMemberInfo extension." << YXLOGEnd;
          flutter::EncodableMap extensionMap =
              std::get<flutter::EncodableMap>(request_iter->second);
          nim_cpp_wrapper_util::Json::Value value;
          Convert::getInstance()->convertMap2Json(&extensionMap, value);
          memberInfo.ext_ = nim::GetJsonStringWithNoStyled(value);
          YXLOG(Info) << "updateChatroomMyMemberInfo extension: "
                      << "memberInfo.ext_" << YXLOGEnd;
        } else if (request_iter->first == flutter::EncodableValue("needSave")) {
          bool needSave = std::get<bool>(request_iter->second);
          if (needSave) {
            nim_cpp_wrapper_util::Json::Value value;
            value["need_save"] = true;
            YXLOG(Info) << "updateChatroomMyMemberInfo needSave." << YXLOGEnd;
            needSaveJson = nim::GetJsonStringWithNoStyled(value);
            YXLOG(Info) << "updateChatroomMyMemberInfo needSave."
                        << needSaveJson << YXLOGEnd;
          }
        }
      }
    } else if (iter->first == flutter::EncodableValue("needNotify")) {
      needNotify = std::get<bool>(iter->second);
    } else if (iter->first == flutter::EncodableValue("notifyExtension")) {
      flutter::EncodableMap notifyExtensionMap =
          std::get<flutter::EncodableMap>(iter->second);
      nim_cpp_wrapper_util::Json::Value value;
      Convert::getInstance()->convertMap2Json(&notifyExtensionMap, value);
      YXLOG(Info) << "updateChatroomMyMemberInfo needNotify." << YXLOGEnd;
      strNotifyExtension = nim::GetJsonStringWithNoStyled(value);
      YXLOG(Info) << "updateChatroomMyMemberInfo needNotify."
                  << strNotifyExtension << YXLOGEnd;
    }
  }

  nim_chatroom::ChatRoom::UpdateMyRoomRoleAsync(
      roomId, memberInfo, needNotify, strNotifyExtension,
      [=](int64_t room_id, int error_code) {
        if (error_code == nim::kNIMResSuccess) {
          result->Success(NimResult::getSuccessResult());
        } else {
          result->Error("", "",
                        NimResult::getErrorResult(
                            error_code, "updateMyChatroomMemberInfo failed"));
        }
      },
      needSaveJson);
}

void FLTChatRoomService::markChatroomMemberInBlackList(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  setMemberAttributeOnlineAsync(
      arguments, result, nim_chatroom::kNIMChatRoomMemberAttributeBlackList);
}

void FLTChatRoomService::markChatroomMemberBeManager(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  setMemberAttributeOnlineAsync(
      arguments, result, nim_chatroom::kNIMChatRoomMemberAttributeAdminister);
}

void FLTChatRoomService::markChatroomMemberMuted(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  setMemberAttributeOnlineAsync(
      arguments, result, nim_chatroom::kNIMChatRoomMemberAttributeMuteList);
}

void FLTChatRoomService::markChatroomMemberBeNormal(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  setMemberAttributeOnlineAsync(
      arguments, result, nim_chatroom::kNIMChatRoomMemberAttributeNomalMember);
}

void FLTChatRoomService::kickChatroomMember(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  uint64_t roomId = 0;
  std::string userId = "";
  std::string notify_ext = "";

  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("roomId")) {
      roomId =
          strtoull(std::get<std::string>(iter->second).c_str(), nullptr, 0);
    } else if (iter->first == flutter::EncodableValue("account")) {
      userId = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("notifyExtension")) {
      flutter::EncodableMap notifyExtensionMap =
          std::get<flutter::EncodableMap>(iter->second);
      nim_cpp_wrapper_util::Json::Value value;
      Convert::getInstance()->convertMap2Json(&notifyExtensionMap, value);
      YXLOG(Info) << "kickChatroomMember notifyExtension." << YXLOGEnd;
      notify_ext = nim::GetJsonStringWithNoStyled(value);
      YXLOG(Info) << "kickChatroomMember notifyExtension." << notify_ext
                  << YXLOGEnd;
    }
  }

  nim_chatroom::ChatRoom::KickMemberAsync(
      roomId, userId, notify_ext, [=](int64_t room_id, int error_code) {
        if (error_code == nim::kNIMResSuccess) {
          result->Success(NimResult::getSuccessResult());
        } else {
          result->Error("", "",
                        NimResult::getErrorResult(error_code,
                                                  "kickChatroomMember failed"));
        }
      });
}

void FLTChatRoomService::markChatroomMemberTempMuted(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  uint64_t roomId = 0;
  std::string userId = "";
  std::string notify_ext = "";
  int64_t duration = 0;
  bool needNotify = false;

  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("duration")) {
      duration = iter->second.LongValue();
    } else if (iter->first == flutter::EncodableValue("options")) {
      flutter::EncodableMap optionsMap =
          std::get<flutter::EncodableMap>(iter->second);
      auto options_iter = optionsMap.begin();
      for (options_iter; options_iter != optionsMap.end(); ++options_iter) {
        if (options_iter->second.IsNull()) {
          continue;
        }

        if (options_iter->first == flutter::EncodableValue("roomId")) {
          roomId = strtoull(std::get<std::string>(options_iter->second).c_str(),
                            nullptr, 0);
        } else if (options_iter->first == flutter::EncodableValue("account")) {
          userId = std::get<std::string>(options_iter->second);
        } else if (options_iter->first ==
                   flutter::EncodableValue("notifyExtension")) {
          flutter::EncodableMap notifyExtensionMap =
              std::get<flutter::EncodableMap>(options_iter->second);
          nim_cpp_wrapper_util::Json::Value value;
          Convert::getInstance()->convertMap2Json(&notifyExtensionMap, value);
          YXLOG(Info) << "markChatroomMemberTempMuted notifyExtension."
                      << YXLOGEnd;
          notify_ext = nim::GetJsonStringWithNoStyled(value);
          YXLOG(Info) << "markChatroomMemberTempMuted notifyExtension."
                      << notify_ext << YXLOGEnd;
        }
      }
    } else if (iter->first == flutter::EncodableValue("needNotify")) {
      needNotify = std::get<bool>(iter->second);
    }
  }

  nim_chatroom::ChatRoom::TempMuteMemberAsync(
      roomId, userId, duration, needNotify, notify_ext,
      [=](int64_t room_id, int error_code,
          const nim_chatroom::ChatRoomMemberInfo& info) {
        if (error_code == nim::kNIMResSuccess) {
          result->Success(NimResult::getSuccessResult());
        } else {
          result->Error("", "",
                        NimResult::getErrorResult(
                            error_code, "markChatroomMemberTempMuted failed"));
        }
      });
}

void FLTChatRoomService::fetchChatroomQueue(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  uint64_t roomId = 0;
  auto iter = arguments->find(flutter::EncodableValue("roomId"));
  if (iter != arguments->end()) {
    if (iter->second.IsNull()) {
      result->Error(
          "", "",
          NimResult::getErrorResult(-1, "fetchChatroomQueue params error"));
      return;
    }

    roomId = strtoull(std::get<std::string>(iter->second).c_str(), nullptr, 0);
  }

  YXLOG(Info) << "fetchChatroomQueue room_id: " << roomId << YXLOGEnd;

  nim_chatroom::ChatRoom::QueueListAsync(
      roomId, [=](int64_t room_id, int error_code,
                  const nim_chatroom::ChatRoomQueue& queue) {
        if (error_code == nim::kNIMResSuccess) {
          flutter::EncodableMap resultMap;
          flutter::EncodableList queue_;
          for (auto chatRoomQueueElement : queue) {
            flutter::EncodableMap elementMap;
            elementMap.insert(std::make_pair("key", chatRoomQueueElement.key_));
            elementMap.insert(
                std::make_pair("value", chatRoomQueueElement.value_));
            queue_.emplace_back(elementMap);
          }

          resultMap.insert(std::make_pair("entryList", queue_));
          result->Success(NimResult::getSuccessResult(resultMap));
        } else {
          result->Error("", "",
                        NimResult::getErrorResult(error_code,
                                                  "fetchChatroomQueue failed"));
        }
      });
}

void FLTChatRoomService::updateChatroomQueueEntry(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  uint64_t roomId = 0;
  nim_chatroom::ChatRoomQueueElement element;
  std::string json_extension = "{\"transient\":false}";

  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("roomId")) {
      roomId =
          strtoull(std::get<std::string>(iter->second).c_str(), nullptr, 0);
    } else if (iter->first == flutter::EncodableValue("entry")) {
      flutter::EncodableMap entryMap =
          std::get<flutter::EncodableMap>(iter->second);
      auto entry_iter = entryMap.begin();
      for (entry_iter; entry_iter != entryMap.end(); ++entry_iter) {
        if (entry_iter->second.IsNull()) {
          continue;
        }

        if (entry_iter->first == flutter::EncodableValue("key")) {
          element.key_ = std::get<std::string>(entry_iter->second);
        } else if (entry_iter->first == flutter::EncodableValue("value")) {
          element.value_ = std::get<std::string>(entry_iter->second);
        }
      }
    } else if (iter->first == flutter::EncodableValue("isTransient")) {
      bool isTransient = std::get<bool>(iter->second);
      if (isTransient) {
        json_extension = "{\"transient\":true}";
      } else {
        json_extension = "{\"transient\":false}";
      }
    }
  }

  nim_chatroom::ChatRoom::QueueOfferAsync(
      roomId, element,
      [=](int64_t room_id, int error_code) {
        if (error_code == nim::kNIMResSuccess) {
          result->Success(NimResult::getSuccessResult());
        } else {
          result->Error("", "",
                        NimResult::getErrorResult(
                            error_code, "updateChatroomQueueEntry failed"));
        }
      },
      json_extension);
}

void FLTChatRoomService::batchUpdateChatroomQueue(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  uint64_t roomId = 0;
  nim_chatroom::ChatRoomBatchMembers members;
  bool needNotify = false;
  std::string notifyExtension;

  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("roomId")) {
      roomId =
          strtoull(std::get<std::string>(iter->second).c_str(), nullptr, 0);
    } else if (iter->first == flutter::EncodableValue("entryList")) {
      flutter::EncodableList entryList =
          std::get<flutter::EncodableList>(iter->second);
      for (auto entry : entryList) {
        flutter::EncodableMap entryMap = std::get<flutter::EncodableMap>(entry);
        auto entry_iter = entryMap.begin();
        for (entry_iter; entry_iter != entryMap.end(); ++entry_iter) {
          nim_chatroom::ChatRoomQueueElement element;
          if (entry_iter->second.IsNull()) {
            continue;
          }

          if (entry_iter->first == flutter::EncodableValue("key")) {
            element.key_ = std::get<std::string>(entry_iter->second);
          } else if (entry_iter->first == flutter::EncodableValue("value")) {
            element.value_ = std::get<std::string>(entry_iter->second);
          }

          members.members_values_.insert(
              std::make_pair(element.key_, element.value_));
        }
      }

    } else if (iter->first == flutter::EncodableValue("needNotify")) {
      needNotify = std::get<bool>(iter->second);
    } else if (iter->first == flutter::EncodableValue("notifyExtension")) {
      flutter::EncodableMap notifyExtensionMap =
          std::get<flutter::EncodableMap>(iter->second);
      nim_cpp_wrapper_util::Json::Value value;
      Convert::getInstance()->convertMap2Json(&notifyExtensionMap, value);
      YXLOG(Info) << "batchUpdateChatroomQueue notifyExtension." << YXLOGEnd;
      notifyExtension = nim::GetJsonStringWithNoStyled(value);
      YXLOG(Info) << "batchUpdateChatroomQueue notifyExtension."
                  << notifyExtension << YXLOGEnd;
    }
  }

  nim_chatroom::ChatRoom::QueueBatchUpdateAsync(
      roomId, members, needNotify, notifyExtension,
      [=](int64_t room_id, int error_code,
          const std::list<std::string>& not_in_queue) {
        if (error_code == nim::kNIMResSuccess) {
          flutter::EncodableList queue;
          for (auto item : not_in_queue) {
            queue.emplace_back(item);
          }
          result->Success(NimResult::getSuccessResult(queue));
        } else {
          result->Error("", "",
                        NimResult::getErrorResult(
                            error_code, "batchUpdateChatroomQueue failed"));
        }
      });
}

void FLTChatRoomService::pollChatroomQueueEntry(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  uint64_t roomId = 0;
  std::string key = "";

  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("roomId")) {
      roomId =
          strtoull(std::get<std::string>(iter->second).c_str(), nullptr, 0);
    } else if (iter->first == flutter::EncodableValue("key")) {
      key = std::get<std::string>(iter->second);
    }
  }

  nim_chatroom::ChatRoom::QueuePollAsync(
      roomId, key,
      [=](int64_t room_id, int error_code,
          const nim_chatroom::ChatRoomQueueElement& element) {
        if (error_code == nim::kNIMResSuccess) {
          flutter::EncodableMap element_;
          element_.insert(std::make_pair("key", element.key_));
          element_.insert(std::make_pair("value", element.value_));
          result->Success(NimResult::getSuccessResult(element_));
        } else {
          result->Error("", "",
                        NimResult::getErrorResult(
                            error_code, "pollChatroomQueueEntry failed"));
        }
      });
}

void FLTChatRoomService::clearChatroomQueue(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }
  uint64_t roomId = 0;
  auto iter = arguments->find(flutter::EncodableValue("roomId"));
  if (iter != arguments->end()) {
    if (iter->second.IsNull()) {
      result->Error(
          "", "",
          NimResult::getErrorResult(-1, "clearChatroomQueue params error"));
      return;
    }

    roomId = strtoull(std::get<std::string>(iter->second).c_str(), nullptr, 0);
  }

  nim_chatroom::ChatRoom::QueueDropAsync(
      roomId, [=](int64_t room_id, int error_code) {
        if (error_code == nim::kNIMResSuccess) {
          flutter::EncodableMap element_;
          result->Success(NimResult::getSuccessResult());
        } else {
          result->Error("", "",
                        NimResult::getErrorResult(error_code,
                                                  "clearChatroomQueue failed"));
        }
      });
}

void FLTChatRoomService::enterCallback(
    int64_t room_id, const nim_chatroom::NIMChatRoomEnterStep step,
    int error_code, const nim_chatroom::ChatRoomInfo& info,
    const nim_chatroom::ChatRoomMemberInfo& my_info) {
  std::ostringstream stringstream;
  stringstream << room_id;
  std::string strRoomId = stringstream.str();
  flutter::EncodableMap statusMap;
  statusMap.insert(std::make_pair("roomId", strRoomId));
  statusMap.insert(std::make_pair("code", error_code));

  if (step == nim_chatroom::kNIMChatRoomEnterStepServerConnecting) {
    statusMap.insert(std::make_pair("code", "connecting"));
    notifyEvent("onStatusChanged", statusMap);
    YXLOG(Info) << "onStatusChanged connecting." << YXLOGEnd;
  } else if (step == nim_chatroom::kNIMChatRoomEnterStepServerConnectOver &&
             error_code != nim::kNIMResSuccess) {
    statusMap.insert(std::make_pair("code", "failure"));
    notifyEvent("onStatusChanged", statusMap);
    YXLOG(Info) << "onStatusChanged failure." << YXLOGEnd;
  } else if (step == nim_chatroom::kNIMChatRoomEnterStepRoomAuthOver) {
    if (error_code == nim::kNIMResSuccess) {
      m_roomId = room_id;
      statusMap.insert(std::make_pair("code", "connected"));
      YXLOG(Info) << "onStatusChanged connected." << YXLOGEnd;
    } else {
      statusMap.insert(std::make_pair("code", "failure"));
      YXLOG(Info) << "onStatusChanged failure." << YXLOGEnd;
    }
    notifyEvent("onStatusChanged", statusMap);
  }

  if (step != nim_chatroom::kNIMChatRoomEnterStepRoomAuthOver) {
    return;
  }

  if (!m_enterResult) {
    YXLOG(Info) << "m_enterResult is empty" << YXLOGEnd;
    return;
  }

  if (error_code != nim::kNIMResSuccess) {
    YXLOG(Info) << "enter chatroom failed" << YXLOGEnd;
    m_enterResult->Error(
        "", "", NimResult::getErrorResult(error_code, "enterChatroom failed"));
    m_enterResult.reset();
    return;
  }

  flutter::EncodableMap arguments;
  arguments.insert(std::make_pair("roomId", strRoomId));

  flutter::EncodableMap chatRoomInfo;
  chatRoomInfo.insert(std::make_pair("roomId", strRoomId));
  chatRoomInfo.insert(std::make_pair("name", info.name_));
  chatRoomInfo.insert(std::make_pair("announcement", info.announcement_));
  chatRoomInfo.insert(std::make_pair("broadcastUrl", info.broadcast_url_));
  chatRoomInfo.insert(std::make_pair("creator", info.creator_id_));
  chatRoomInfo.insert(std::make_pair("validFlag", info.valid_flag_));
  chatRoomInfo.insert(std::make_pair("onlineUserCount", info.online_count_));
  chatRoomInfo.insert(std::make_pair("mute", info.mute_all_));

  YXLOG(Info) << "convert extension start" << YXLOGEnd;
  flutter::EncodableMap extension;
  nim_cpp_wrapper_util::Json::Value value =
      Convert::getInstance()->getJsonValueFromJsonString(info.ext_);
  Convert::getInstance()->convertJson2Map(extension, value);
  chatRoomInfo.insert(std::make_pair("extension", extension));
  YXLOG(Info) << "convert extension end" << YXLOGEnd;

  YXLOG(Info) << "convert strQueuelevel start" << YXLOGEnd;
  std::string strQueuelevel = "";
  Convert::getInstance()->convertNIMEnumToDartString(
      info.queuelevel,
      Convert::getInstance()->getChatroomQueueModificationLevel(),
      strQueuelevel);
  chatRoomInfo.insert(std::make_pair("queueModificationLevel", strQueuelevel));
  YXLOG(Info) << "convert strQueuelevel end" << YXLOGEnd;

  arguments.insert(std::make_pair("roomInfo", chatRoomInfo));

  YXLOG(Info) << "convertChatRoomMemberInfoToMap start" << YXLOGEnd;
  flutter::EncodableMap memberInfo = convertChatRoomMemberInfoToMap(my_info);
  YXLOG(Info) << "convertChatRoomMemberInfoToMap end" << YXLOGEnd;

  // tag字段为string, dart接口为list
  flutter::EncodableList tags;
  tags.push_back(flutter::EncodableValue(my_info.tags_));
  memberInfo.insert(std::make_pair("tags", tags));
  arguments.insert(std::make_pair("member", memberInfo));

  YXLOG(Info) << "enter chatroom Success start" << YXLOGEnd;
  m_enterResult->Success(NimResult::getSuccessResult(arguments));
  m_enterResult.reset();
  YXLOG(Info) << "enter chatroom Success end" << YXLOGEnd;
}

void FLTChatRoomService::exitCallback(
    int64_t room_id, int error_code,
    const nim_chatroom::NIMChatRoomExitReasonInfo& exit_info) {
  std::ostringstream stringstream;
  stringstream << room_id;
  std::string strRoomId = stringstream.str();
  flutter::EncodableMap arguments;

  arguments.insert(std::make_pair("roomId", strRoomId));

  flutter::EncodableMap extension;
  nim_cpp_wrapper_util::Json::Value value =
      Convert::getInstance()->getJsonValueFromJsonString(exit_info.notify_ext_);
  Convert::getInstance()->convertJson2Map(extension, value);
  arguments.insert(std::make_pair("extension", extension));

  if (exit_info.code_ == nim_chatroom::kNIMChatRoomExitReasonKickByManager) {
    arguments.insert(std::make_pair("reason", "byManager"));
    notifyEvent("onKickOut", arguments);
  } else if (exit_info.code_ ==
             nim_chatroom::kNIMChatRoomExitReasonKickByMultiSpot) {
    arguments.insert(std::make_pair("reason", "byConflictLogin"));
    notifyEvent("onKickOut", arguments);
  } else if (exit_info.code_ ==
             nim_chatroom::kNIMChatRoomExitReasonRoomInvalid) {
    arguments.insert(std::make_pair("reason", "dismissed"));
    notifyEvent("onKickOut", arguments);
  } else if (exit_info.code_ ==
             nim_chatroom::kNIMChatRoomExitReasonBeBlacklisted) {
    arguments.insert(std::make_pair("reason", "blacklisted"));
    notifyEvent("onKickOut", arguments);
  }

  m_roomId = 0;

  if (exit_info.code_ != nim_chatroom::kNIMChatRoomExitReasonExit) {
    return;
  }

  if (!m_exitResult) {
    return;
  }

  if (error_code == nim::kNIMResSuccess) {
    m_exitResult->Success(NimResult::getSuccessResult());
  } else {
    m_exitResult->Error(
        "", "", NimResult::getErrorResult(error_code, "exitChatroom failed"));
  }

  m_exitResult.reset();
  m_exitResult = nullptr;
}

void FLTChatRoomService::receiveMsgCallback(
    int64_t room_id, const nim_chatroom::ChatRoomMessage& result) {
  flutter::EncodableMap message;
  flutter::EncodableList messageList;
  flutter::EncodableMap arguments;

  YXLOG(Info) << "receiveMsgCallback result.msg_attach_: " << result.msg_attach_
              << YXLOGEnd;
  YXLOG(Info) << "receiveMsgCallback result.msg_type_: " << result.msg_type_
              << YXLOGEnd;

  if (result.msg_type_ == nim_chatroom::kNIMChatRoomMsgTypeNotification) {
    return;
  }

  convertNimMessageToDartMessage(result, message);
  messageList.emplace_back(message);
  arguments.insert(std::make_pair("messageList", messageList));
  notifyEvent("onMessageReceived", arguments);
  YXLOG(Info) << "onMessageReceived" << YXLOGEnd;
}

void FLTChatRoomService::sendMsgAckCallback(
    int64_t room_id, int error_code,
    const nim_chatroom::ChatRoomMessage& result) {
  YXLOG(Info) << "FLTChatRoomService::sendMsgAckCallback" << result.msg_attach_
              << YXLOGEnd;
  std::cout << "FLTChatRoomService::sendMsgAckCallback:" << result.msg_attach_
            << std::endl;

  auto iter = m_sendMsgResultMap.find(result.client_msg_id_);
  if (iter != m_sendMsgResultMap.end()) {
    auto methonRsult = iter->second;
    if (methonRsult) {
      if (error_code == nim::kNIMResSuccess) {
        flutter::EncodableMap messageMap;
        convertNimMessageToDartMessage(result, messageMap);
        YXLOG(Info) << "sendmessage success" << YXLOGEnd;
        methonRsult->Success(NimResult::getSuccessResult(messageMap));
      } else {
        YXLOG(Info) << "sendmessage failed" << YXLOGEnd;
        methonRsult->Error("", "",
                           NimResult::getErrorResult(
                               error_code, "send chatroomMessage failed"));
      }

      m_sendMsgResultMap.erase(iter);
      return;
    }
  }
}

void FLTChatRoomService::linkConditionCallback(
    int64_t room_id, const nim_chatroom::NIMChatRoomLinkCondition& condition) {
  if (condition == nim_chatroom::kNIMChatRoomLinkConditionDead) {
    std::ostringstream stringstream;
    stringstream << room_id;
    std::string strRoomId = stringstream.str();
    flutter::EncodableMap statusMap;
    statusMap.insert(std::make_pair("roomId", strRoomId));
    statusMap.insert(std::make_pair("code", 13002));
    statusMap.insert(std::make_pair("code", "disconnected"));
    notifyEvent("onStatusChanged", statusMap);
    YXLOG(Info) << "onStatusChanged disconnected" << YXLOGEnd;
  }
}

void FLTChatRoomService::notificationCallback(
    int64_t room_id, const nim_chatroom::ChatRoomNotification& notification) {
  flutter::EncodableMap message;
  flutter::EncodableList messageList;
  flutter::EncodableMap arguments;

  flutter::EncodableMap attachMap;
  attachMap.insert(std::make_pair("type", static_cast<int>(notification.id_)));

  if (notification.id_ ==
      nim_chatroom::kNIMChatRoomNotificationIdQueueChanged) {
    nim_chatroom::ChatRoomQueueChangedNotification queueChangedNotification;
    queueChangedNotification.ParseFromNotification(notification);
    attachMap.insert(std::make_pair("key", queueChangedNotification.key_));
    attachMap.insert(
        std::make_pair("content", queueChangedNotification.value_));
    flutter::EncodableMap contentMap;
    contentMap.insert(std::make_pair(queueChangedNotification.key_,
                                     queueChangedNotification.value_));
    attachMap.insert(std::make_pair("contentMap", contentMap));

    std::string strQueueChangeType = "undefined";
    if (queueChangedNotification.type_ == "OFFER") {
      strQueueChangeType = "offer";
    } else if (queueChangedNotification.type_ == "POLL") {
      strQueueChangeType = "poll";
    } else if (queueChangedNotification.type_ == "DROP") {
      strQueueChangeType = "drop";
    } else if (queueChangedNotification.type_ == "BATCH_UPDATE") {
      strQueueChangeType = "batchUpdate";
    }
    attachMap.insert(std::make_pair("queueChangeType", strQueueChangeType));
  } else if (notification.id_ ==
             nim_chatroom::kNIMChatRoomNotificationIdQueueBatchChanged) {
    nim_chatroom::ChatRoomQueueBatchChangedNotification
        queueBatchChangedNotification;
    queueBatchChangedNotification.ParseFromNotification(notification);
    attachMap.insert(std::make_pair("key", queueBatchChangedNotification.key_));
    attachMap.insert(
        std::make_pair("content", queueBatchChangedNotification.value_));
    flutter::EncodableMap contentMap;
    for (auto value : queueBatchChangedNotification.changed_values_) {
      contentMap.insert(std::make_pair(value.first, value.second));
    }
    attachMap.insert(std::make_pair("contentMap", contentMap));
    std::string strQueueChangeType = "undefined";
    if (queueBatchChangedNotification.type_ == "OFFER") {
      strQueueChangeType = "offer";
    } else if (queueBatchChangedNotification.type_ == "POLL") {
      strQueueChangeType = "poll";
    } else if (queueBatchChangedNotification.type_ == "DROP") {
      strQueueChangeType = "drop";
    } else if (queueBatchChangedNotification.type_ == "PARTCLEAR") {
      strQueueChangeType = "partialClear";
    }
    attachMap.insert(std::make_pair("queueChangeType", strQueueChangeType));
  }

  flutter::EncodableList targets;
  for (auto target : notification.target_ids_) {
    targets.emplace_back(target);
  }
  attachMap.insert(std::make_pair("targets", targets));

  flutter::EncodableList targetNicks;
  for (auto targetNick : notification.target_nick_) {
    targetNicks.emplace_back(targetNick);
  }
  attachMap.insert(std::make_pair("targetNicks", targetNicks));

  YXLOG(Info) << "notificationCallback notification.ext_:" << notification.ext_
              << YXLOGEnd;
  flutter::EncodableMap extensionMap;
  nim_cpp_wrapper_util::Json::Value values =
      Convert::getInstance()->getJsonValueFromJsonString(notification.ext_);
  Convert::getInstance()->convertJson2Map(extensionMap, values);
  attachMap.insert(std::make_pair("extension", extensionMap));

  attachMap.insert(std::make_pair("operator", notification.operator_id_));
  attachMap.insert(std::make_pair("operatorNick", notification.operator_nick_));
  attachMap.insert(std::make_pair("messageType", "notification"));
  attachMap.insert(
      std::make_pair("tempMutedDuration", notification.temp_mute_duration_));
  attachMap.insert(std::make_pair("muted", notification.muted_));
  attachMap.insert(std::make_pair("tempMuted", notification.temp_muted_));

  message.insert(std::make_pair("messageAttachment", attachMap));
  message.insert(std::make_pair("timestamp", 0));
  message.insert(std::make_pair("messageType", "notification"));
  message.insert(std::make_pair("messageDirection", "received"));

  messageList.emplace_back(message);
  arguments.insert(std::make_pair("messageList", messageList));
  notifyEvent("onMessageReceived", arguments);
  YXLOG(Info) << "notificationCallback" << YXLOGEnd;
}

flutter::EncodableMap FLTChatRoomService::convertChatRoomMemberInfoToMap(
    const nim_chatroom::ChatRoomMemberInfo& my_info) {
  flutter::EncodableMap memberInfo;
  std::ostringstream ss;
  ss << my_info.room_id_;
  std::string strRoomId = ss.str();
  memberInfo.insert(std::make_pair("roomId", strRoomId));
  memberInfo.insert(std::make_pair("account", my_info.account_id_));
  memberInfo.insert(std::make_pair("memberLevel", my_info.level_));
  memberInfo.insert(std::make_pair("nickname", my_info.nick_));
  memberInfo.insert(std::make_pair("avatar", my_info.avatar_));
  flutter::EncodableMap extension;
  nim_cpp_wrapper_util::Json::Value value =
      Convert::getInstance()->getJsonValueFromJsonString(my_info.ext_);
  Convert::getInstance()->convertJson2Map(extension, value);
  memberInfo.insert(std::make_pair("extension", extension));
  memberInfo.insert(std::make_pair(
      "isOnline",
      my_info.state_ == nim_chatroom::kNIMChatRoomOnlineStateOnline));
  memberInfo.insert(std::make_pair("isInBlackList", my_info.is_blacklist_));
  memberInfo.insert(std::make_pair("isMuted", my_info.is_muted_));
  memberInfo.insert(std::make_pair("isTempMuted", my_info.temp_muted_));
  memberInfo.insert(
      std::make_pair("tempMuteDuration", my_info.temp_muted_duration_));
  memberInfo.insert(std::make_pair("isValid", my_info.is_valid_));
  memberInfo.insert(std::make_pair("enterTime", my_info.enter_timetag_));
  memberInfo.insert(std::make_pair("updateTime", my_info.update_timetag_));
  memberInfo.insert(std::make_pair("notifyTargetTags", my_info.notify_tags_));

  std::string strMemberType;
  Convert::getInstance()->convertNIMEnumToDartString(
      my_info.type_, Convert::getInstance()->getChatroomMemberType(),
      strMemberType);
  memberInfo.insert(std::make_pair("memberType", strMemberType));

  return memberInfo;
}

void FLTChatRoomService::setMemberAttributeOnlineAsync(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result,
    nim_chatroom::NIMChatRoomMemberAttribute attribute) {
  if (!arguments) {
    return;
  }
  uint64_t roomId = 0;
  nim_chatroom::ChatRoomSetMemberAttributeParameters parameters;
  parameters.attribute_ = attribute;

  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("isAdd")) {
      bool isAdd = std::get<bool>(iter->second);
      parameters.opt_ = isAdd;
    } else if (iter->first == flutter::EncodableValue("options")) {
      flutter::EncodableMap optionsMap =
          std::get<flutter::EncodableMap>(iter->second);
      auto options_iter = optionsMap.begin();
      for (options_iter; options_iter != optionsMap.end(); ++options_iter) {
        if (options_iter->second.IsNull()) {
          continue;
        }

        if (options_iter->first == flutter::EncodableValue("roomId")) {
          roomId = strtoull(std::get<std::string>(options_iter->second).c_str(),
                            nullptr, 0);
        } else if (options_iter->first == flutter::EncodableValue("account")) {
          parameters.account_id_ = std::get<std::string>(options_iter->second);
        } else if (options_iter->first ==
                   flutter::EncodableValue("notifyExtension")) {
          flutter::EncodableMap notifyExtensionMap =
              std::get<flutter::EncodableMap>(options_iter->second);
          nim_cpp_wrapper_util::Json::Value value;
          Convert::getInstance()->convertMap2Json(&notifyExtensionMap, value);
          YXLOG(Info) << "setMemberAttributeOnlineAsync notifyExtension."
                      << YXLOGEnd;
          parameters.notify_ext_ = nim::GetJsonStringWithNoStyled(value);
          YXLOG(Info) << "setMemberAttributeOnlineAsync notifyExtension."
                      << parameters.notify_ext_ << YXLOGEnd;
        }
      }
    }
  }

  nim_chatroom::ChatRoom::SetMemberAttributeOnlineAsync(
      roomId, parameters,
      [=](int64_t room_id, int error_code,
          const nim_chatroom::ChatRoomMemberInfo& info) {
        if (error_code == nim::kNIMResSuccess) {
          flutter::EncodableMap memberInfoMap =
              convertChatRoomMemberInfoToMap(info);
          result->Success(NimResult::getSuccessResult(memberInfoMap));
        } else {
          result->Error(
              "", "",
              NimResult::getErrorResult(
                  error_code, "setMemberAttributeOnlineAsync failed"));
        }
      });
}

bool FLTChatRoomService::convertDartMessageToNimMessage(
    nim_chatroom::ChatRoomMessage& message,
    const flutter::EncodableMap* arguments) {
  if (!arguments) {
    return false;
  }

  auto resendIt = arguments->find(flutter::EncodableValue("resend"));
  if (resendIt != arguments->end()) {
    if (!resendIt->second.IsNull()) {
      message.msg_setting_.resend_flag_ = std::get<bool>(resendIt->second);
    }
  }

  auto messageIt = arguments->find(flutter::EncodableValue("message"));
  if (messageIt != arguments->end()) {
    if (messageIt->second.IsNull()) {
      return false;
    }
  } else {
    return false;
  }

  flutter::EncodableMap messageMap =
      std::get<flutter::EncodableMap>(messageIt->second);
  auto iter = messageMap.find(flutter::EncodableValue("messageType"));
  if (iter != messageMap.end()) {
    if (iter->second.IsNull()) {
      return false;
    }

    std::string strMessageType = std::get<std::string>(iter->second);
    nim::NIMMessageType type;
    Convert::getInstance()->convertDartStringToNIMEnum(
        strMessageType, Convert::getInstance()->getMessageType(), type);
    message.msg_type_ = static_cast<nim_chatroom::NIMChatRoomMsgType>(type);
  }

  iter = messageMap.begin();
  for (iter; iter != messageMap.end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("messageId")) {
      message.client_msg_id_ = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("messageSubType")) {
      message.sub_type_ = std::get<int>(iter->second);
    } else if (iter->first == flutter::EncodableValue("fromAccount")) {
      message.from_id_ = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("content")) {
      if (message.msg_type_ == nim_chatroom::kNIMChatRoomMsgTypeText) {
        message.msg_attach_ = std::get<std::string>(iter->second);
      }
    } else if (iter->first == flutter::EncodableValue("timestamp")) {
      message.timetag_ = std::get<int>(iter->second);
    } else if (iter->first == flutter::EncodableValue("messageAttachment")) {
      if (message.msg_type_ == nim_chatroom::kNIMChatRoomMsgTypeCustom) {
        flutter::EncodableMap attachment =
            std::get<flutter::EncodableMap>(iter->second);
        nim_cpp_wrapper_util::Json::Value value;
        Convert::getInstance()->convertMap2Json(&attachment, value);
        message.msg_attach_ = nim::GetJsonStringWithNoStyled(value);
      }
    } else if (iter->first == flutter::EncodableValue("fromNickname")) {
      message.from_nick_ = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("callbackExtension")) {
      message.third_party_callback_ext_ = std::get<std::string>(iter->second);
    } else if (iter->first ==
               flutter::EncodableValue("isHighPriorityMessage")) {
      if (std::get<bool>(iter->second)) {
        message.msg_setting_.high_priority_ = 1;
      }
    } else if (iter->first == flutter::EncodableValue("config")) {
      flutter::EncodableMap config =
          std::get<flutter::EncodableMap>(iter->second);
      auto enableHistoryIt =
          config.find(flutter::EncodableValue("enableHistory"));
      if (enableHistoryIt != config.end()) {
        message.msg_setting_.history_save_ =
            std::get<bool>(enableHistoryIt->second);
      }
    } else if (iter->first == flutter::EncodableValue("senderClientType")) {
      std::string strSenderClientType = std::get<std::string>(iter->second);
      nim::NIMClientType type;
      Convert::getInstance()->convertDartStringToNIMEnum(
          strSenderClientType, Convert::getInstance()->getClientType(), type);
      message.from_client_type_ =
          static_cast<nim_chatroom::NIMChatRoomClientType>(type);
    } else if (iter->first == flutter::EncodableValue("antiSpamOption")) {
      flutter::EncodableMap antiSpamOption =
          std::get<flutter::EncodableMap>(iter->second);
      auto antiSpamOptionIt = antiSpamOption.begin();
      for (antiSpamOptionIt; antiSpamOptionIt != antiSpamOption.end();
           ++antiSpamOptionIt) {
        if (antiSpamOptionIt->second.IsNull()) {
          continue;
        }
        if (antiSpamOptionIt->first == flutter::EncodableValue("enable")) {
          message.msg_setting_.anti_spam_enable_ =
              std::get<bool>(antiSpamOptionIt->second);
        } else if (antiSpamOptionIt->first ==
                   flutter::EncodableValue("content")) {
          message.msg_setting_.anti_spam_content_ =
              std::get<std::string>(antiSpamOptionIt->second);
        } else if (antiSpamOptionIt->first ==
                   flutter::EncodableValue("antiSpamConfigId")) {
          message.msg_setting_.anti_spam_bizid_ =
              std::get<std::string>(antiSpamOptionIt->second);
        }
      }
    } else if (iter->first == flutter::EncodableValue("yidunAntiCheating")) {
      flutter::EncodableMap yidunAntiCheating =
          std::get<flutter::EncodableMap>(iter->second);
      nim_cpp_wrapper_util::Json::Value yidunAntiCheating_;
      if (!Convert::getInstance()->convertMap2Json(&yidunAntiCheating,
                                                   yidunAntiCheating_)) {
        return false;
      }
      message.msg_setting_.yidun_anti_cheating_ = yidunAntiCheating_.asString();
    } else if (iter->first == flutter::EncodableValue("env")) {
      message.msg_setting_.env_config_ = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("extension")) {
      // todo 只读字段不处理
    } else if (iter->first == flutter::EncodableValue("remoteExtension")) {
      flutter::EncodableMap remoteExtension =
          std::get<flutter::EncodableMap>(iter->second);
      nim_cpp_wrapper_util::Json::Value value;
      if (Convert::getInstance()->convertMap2Json(&remoteExtension, value)) {
        message.msg_setting_.ext_ = nim::GetJsonStringWithNoStyled(value);
      }
    }
  }

  return true;
}

void FLTChatRoomService::convertNimMessageToDartMessage(
    const nim_chatroom::ChatRoomMessage& message,
    flutter::EncodableMap& arguments) {
  arguments.insert(std::make_pair("messageId", message.client_msg_id_));

  std::string strMessageType = "";
  Convert::getInstance()->convertNIMEnumToDartString(
      static_cast<nim::NIMMessageType>(message.msg_type_),
      Convert::getInstance()->getMessageType(), strMessageType);
  arguments.insert(std::make_pair("messageType", strMessageType));

  std::string strMessageSubType = "";
  Convert::getInstance()->convertNIMEnumToDartString(
      static_cast<nim::NIMMessageType>(message.sub_type_),
      Convert::getInstance()->getMessageType(), strMessageSubType);
  // arguments.insert(std::make_pair("messageSubType", strMessageSubType));
  arguments.insert(std::make_pair("messageSubType", message.sub_type_));

  arguments.insert(std::make_pair("fromAccount", message.from_id_));

  if (message.from_id_ == NimCore::getInstance()->getAccountId()) {
    arguments.insert(std::make_pair("messageDirection", "outgoing"));
  } else {
    arguments.insert(std::make_pair("messageDirection", "received"));
  }

  arguments.insert(std::make_pair("fromNickname", message.from_nick_));

  if (message.msg_type_ == nim_chatroom::kNIMChatRoomMsgTypeText) {
    arguments.insert(std::make_pair("content", message.msg_attach_));
  } else {
    arguments.insert(std::make_pair("content", ""));
  }

  arguments.insert(std::make_pair("isHighPriorityMessage",
                                  message.msg_setting_.high_priority_ == 1));
  arguments.insert(
      std::make_pair("enableHistory", message.msg_setting_.history_save_));
  arguments.insert(std::make_pair("env", message.msg_setting_.env_config_));
  arguments.insert(std::make_pair("timestamp", message.timetag_));

  YXLOG(Info) << "remoteExtensionMap begin ------------"
              << message.msg_setting_.ext_ << YXLOGEnd;
  flutter::EncodableMap remoteExtensionMap;
  nim_cpp_wrapper_util::Json::Value remoteExtensionValue =
      Convert::getInstance()->getJsonValueFromJsonString(
          message.msg_setting_.ext_);
  if (!remoteExtensionValue.isNull()) {
    Convert::getInstance()->convertJson2Map(remoteExtensionMap,
                                            remoteExtensionValue);
  }
  arguments.insert(std::make_pair("remoteExtension", remoteExtensionMap));
  YXLOG(Info) << "remoteExtensionMap end --------------" << YXLOGEnd;

  flutter::EncodableMap config;
  config.insert(
      std::make_pair("enableHistory", message.msg_setting_.history_save_));
  config.insert(std::make_pair("enableRoaming", false));
  config.insert(std::make_pair("enablePush", false));
  config.insert(std::make_pair("enableSelfSync", false));
  config.insert(std::make_pair("enablePushNick", false));
  config.insert(std::make_pair("enableUnreadCount", false));
  config.insert(std::make_pair("enableRoute", false));
  config.insert(std::make_pair("enablePersist", false));
  arguments.insert(std::make_pair("config", config));

  std::string strSenderClientType = "";
  Convert::getInstance()->convertNIMEnumToDartString(
      static_cast<nim::NIMClientType>(message.from_client_type_),
      Convert::getInstance()->getClientType(), strMessageType);
  arguments.insert(std::make_pair("senderClientType", strSenderClientType));

  flutter::EncodableMap antiSpamOption;
  antiSpamOption.insert(
      std::make_pair("enable", message.msg_setting_.anti_spam_enable_));
  antiSpamOption.insert(
      std::make_pair("content", message.msg_setting_.anti_spam_content_));
  antiSpamOption.insert(std::make_pair("antiSpamConfigId",
                                       message.msg_setting_.anti_spam_bizid_));
  arguments.insert(std::make_pair("antiSpamOption", antiSpamOption));

  if (!message.msg_setting_.yidun_anti_cheating_.empty()) {
    flutter::EncodableMap yidunAntiCheating;
    nim_cpp_wrapper_util::Json::Value values =
        Convert::getInstance()->getJsonValueFromJsonString(
            message.msg_setting_.yidun_anti_cheating_);
    if (values.isObject()) {
      nim_cpp_wrapper_util::Json::Value::Members keys = values.getMemberNames();
      for (auto& it : keys) {
        auto valueTmp = values[it];
        if (valueTmp.isBool()) {
          yidunAntiCheating[flutter::EncodableValue(it)] = valueTmp.asBool();
        } else if (valueTmp.isInt()) {
          yidunAntiCheating[flutter::EncodableValue(it)] = valueTmp.asInt();
        } else if (valueTmp.isInt64()) {
          yidunAntiCheating[flutter::EncodableValue(it)] = valueTmp.asInt64();
        } else if (valueTmp.isDouble()) {
          yidunAntiCheating[flutter::EncodableValue(it)] = valueTmp.asDouble();
        } else if (valueTmp.isString()) {
          yidunAntiCheating[flutter::EncodableValue(it)] = valueTmp.asString();
        } else {
          continue;
        }
      }
      arguments.insert(std::make_pair("yidunAntiCheating", yidunAntiCheating));
    }
  }

  flutter::EncodableMap attachMap;
  YXLOG(Info) << "convertNimMessageToDartMessage type " << message.msg_type_
              << YXLOGEnd;
  if (message.msg_type_ == nim_chatroom::kNIMChatRoomMsgTypeCustom) {
    YXLOG(Info) << "convertNimMessageToDartMessage msg_attach_ "
                << message.msg_attach_ << YXLOGEnd;
    nim_cpp_wrapper_util::Json::Value values =
        Convert::getInstance()->getJsonValueFromJsonString(message.msg_attach_);
    values["messageType"] = "custom";
    Convert::getInstance()->convertJson2Map(attachMap, values);
  }
  arguments.insert(std::make_pair("messageAttachment", attachMap));

  arguments.insert(std::make_pair("env", message.msg_setting_.env_config_));

  flutter::EncodableMap extension;
  extension.insert(std::make_pair("nickname", message.from_nick_));
  extension.insert(std::make_pair("avatar", message.from_avatar_));
  flutter::EncodableMap senderExtension;
  nim_cpp_wrapper_util::Json::Value value =
      Convert::getInstance()->getJsonValueFromJsonString(message.from_ext_);
  Convert::getInstance()->convertJson2Map(senderExtension, value);
  extension.insert(std::make_pair("senderExtension", senderExtension));
  arguments.insert(std::make_pair("extension", extension));
}
