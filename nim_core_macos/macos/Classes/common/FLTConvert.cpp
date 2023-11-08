// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#include "FLTConvert.h"

Convert::Convert() {
  m_messageType = {{"text", nim::kNIMMessageTypeText},
                   {"image", nim::kNIMMessageTypeImage},
                   {"audio", nim::kNIMMessageTypeAudio},
                   {"video", nim::kNIMMessageTypeVideo},
                   {"location", nim::kNIMMessageTypeLocation},
                   {"notification", nim::kNIMMessageTypeNotification},
                   {"file", nim::kNIMMessageTypeFile},
                   {"tip", nim::kNIMMessageTypeTips},
                   {"robot", nim::kNIMMessageTypeRobot},
                   {"rtc", nim::kNIMMessageTypeG2NetCall},
                   {"custom", nim::kNIMMessageTypeCustom},
                   {"undef", nim::kNIMMessageTypeUnknown}};

  m_sessionType = {{"p2p", nim::kNIMSessionTypeP2P},
                   {"team", nim::kNIMSessionTypeTeam},
                   {"superTeam", nim::kNIMSessionTypeSuperTeam}};

  m_status = {{"sending", nim::kNIMMsgLogStatusSending},
              {"success", nim::kNIMMsgLogStatusSent},
              {"fail", nim::kNIMMsgLogStatusSendFailed},
              {"read", nim::kNIMMsgLogStatusRead},
              {"unread", nim::kNIMMsgLogStatusUnread},
              {"draft", nim::kNIMMsgLogStatusDraft}};

  m_clientType = {{"unknown", nim::kNIMClientTypeDefault},
                  {"android", nim::kNIMClientTypeAndroid},
                  {"ios", nim::kNIMClientTypeiOS},
                  {"windows", nim::kNIMClientTypePCWindows},
                  {"web", nim::kNIMClientTypeWeb},
                  {"rest", nim::kNIMClientTypeRestAPI},
                  {"macos", nim::kNIMClientTypeMacOS}};

  m_nosScene = {{"defaultProfile", nim::kNIMNosDefaultTagResource},
                {"defaultIm", nim::kNIMNosDefaultTagIM}};

  m_messageDirection = {{"outgoing", 0}, {"received", 1}};

  m_searchOrder = {{0, nim::kNIMFullTextSearchOrderByDesc},
                   {1, nim::kNIMFullTextSearchOrderByAsc}};

  m_sysMsgType = {{"applyJoinTeam", nim::kNIMSysMsgTypeTeamApply},
                  {"rejectTeamApply", nim::kNIMSysMsgTypeTeamReject},
                  {"teamInvite", nim::kNIMSysMsgTypeTeamInvite},
                  {"declineTeamInvite", nim::kNIMSysMsgTypeTeamInviteReject},
                  {"addFriend", nim::kNIMSysMsgTypeFriendAdd}};

  m_sysMsgStatus = {{"init", nim::kNIMSysMsgStatusNone},
                    {"passed", nim::kNIMSysMsgStatusPass},
                    {"declined", nim::kNIMSysMsgStatusDecline},
                    {"ignored", nim::kNIMSysMsgStatusDeleted},
                    {"expired", nim::kNIMSysMsgStatusInvalid},
                    {"extension1", nim::kNIMSysMsgStatusRead}};

  m_genderType = {{"unknown", 0}, {"male", 1}, {"female", 2}};

#if defined(_WIN32)
  m_audioOutputFormat = {{"AAC", nim_audio::AAC}, {"AMR", nim_audio::AMR}};
#endif

  m_chatroomMemberQueryType = {
      {"allNormalMember", nim_chatroom::kNIMChatRoomGetMemberTypeSolid},
      {"onlineNormalMember", nim_chatroom::kNIMChatRoomGetMemberTypeSolidOL},
      {"onlineGuestMemberByEnterTimeDesc",
       nim_chatroom::kNIMChatRoomGetMemberTypeTempOL},
      {"onlineGuestMemberByEnterTimeAsc",
       nim_chatroom::kNIMChatRoomGetMemberTypeTemp}};

  m_chatroomMemberType = {{"unknown", -2}, {"guest", 3},   {"restricted", -1},
                          {"normal", 0},   {"creator", 1}, {"manager", 2},
                          {"anonymous", 4}};

  m_chatroomQueueModificationLevel = {{"anyone", 0}, {"manager", 1}};

  m_teamJoinMode = {{"free", nim::kNIMTeamJoinModeNoAuth},
                    {"apply", nim::kNIMTeamJoinModeNeedAuth},
                    {"private", nim::kNIMTeamJoinModeRejectAll}};

  m_teamInviteMode = {{"manager", nim::kNIMTeamInviteModeManager},
                      {"all", nim::kNIMTeamInviteModeEveryone}};

  m_teamBeInviteMode = {{"needAuth", nim::kNIMTeamBeInviteModeNeedAgree},
                        {"noAuth", nim::kNIMTeamBeInviteModeNotNeedAgree}};

  m_teamUpdateInfoMode = {{"manager", nim::kNIMTeamUpdateInfoModeManager},
                          {"all", nim::kNIMTeamUpdateInfoModeEveryone}};

  m_teamUpdateCustomMode = {{"manager", nim::kNIMTeamUpdateCustomModeManager},
                            {"all", nim::kNIMTeamUpdateCustomModeEveryone}};

  m_teamType = {{"advanced", nim::kNIMTeamTypeAdvanced},
                {"normal", nim::kNIMTeamTypeNormal}};

  m_teamMuteType = {{"cancel", nim::kNIMTeamMuteTypeNone},
                    {"muteNormal", nim::kNIMTeamMuteTypeNomalMute},
                    {"muteAll", nim::kNIMTeamMuteTypeAllMute}};

  m_teamMemberType = {{"normal", nim::kNIMTeamUserTypeNomal},
                      {"owner", nim::kNIMTeamUserTypeCreator},
                      {"manager", nim::kNIMTeamUserTypeManager},
                      {"apply", nim::kNIMTeamUserTypeApply}};

  m_cacheFileType = {{"image", nim::kNIMCacheFileImage},
                     {"audio", nim::kNIMCacheFileAudio},
                     {"video", nim::kNIMCacheFileVideo},
                     {"other", nim::kNIMCacheFileOther}};
}

const std::string Convert::getUUID() {
  std::string str = nim::Tool::GetUuid();
  str.erase(std::remove(str.begin(), str.end(), '-'), str.end());
  return str;
}

const Convert::MessageType& Convert::getMessageType() const {
  return m_messageType;
}

const Convert::SessionType& Convert::getSessionType() const {
  return m_sessionType;
}

const Convert::Status& Convert::getStatus() const { return m_status; }

const Convert::ClientType& Convert::getClientType() const {
  return m_clientType;
}

const Convert::NosScene& Convert::getNosScene() const { return m_nosScene; }

const Convert::MessageDirection& Convert::getMessageDirection() const {
  return m_messageDirection;
}

const Convert::SearchOrder& Convert::getSearchOrder() const {
  return m_searchOrder;
}

const std::unordered_map<std::string, nim::NIMSysMsgType>&
Convert::getSysMsgType() const {
  return m_sysMsgType;
}

const std::unordered_map<std::string, nim::NIMSysMsgStatus>&
Convert::getsysMsgStatus() const {
  return m_sysMsgStatus;
}

const std::unordered_map<std::string, int>& Convert::getGenderType() const {
  return m_genderType;
}

#if defined(_WIN32)
const std::unordered_map<std::string, nim_audio::nim_audio_type>&
Convert::getAudioOutputFormat() const {
  return m_audioOutputFormat;
}
#endif

const std::unordered_map<std::string, nim_chatroom::NIMChatRoomGetMemberType>&
Convert::getChatroomMemberQueryType() const {
  return m_chatroomMemberQueryType;
}

const std::unordered_map<std::string, int>& Convert::getChatroomMemberType()
    const {
  return m_chatroomMemberType;
}

const std::unordered_map<std::string, int>&
Convert::getChatroomQueueModificationLevel() const {
  return m_chatroomQueueModificationLevel;
}

const std::unordered_map<std::string, nim::NIMTeamJoinMode>&
Convert::getTeamJoinMode() const {
  return m_teamJoinMode;
}

const std::unordered_map<std::string, nim::NIMTeamInviteMode>&
Convert::getTeamInviteMode() const {
  return m_teamInviteMode;
}

const std::unordered_map<std::string, nim::NIMTeamBeInviteMode>&
Convert::getTeamBeInviteMode() const {
  return m_teamBeInviteMode;
}

const std::unordered_map<std::string, nim::NIMTeamUpdateInfoMode>&
Convert::getTeamUpdateInfoMode() const {
  return m_teamUpdateInfoMode;
}

const std::unordered_map<std::string, nim::NIMTeamUpdateCustomMode>&
Convert::getTeamUpdateCustomMode() const {
  return m_teamUpdateCustomMode;
}

const std::unordered_map<std::string, nim::NIMTeamType>& Convert::getTeamType()
    const {
  return m_teamType;
}

const std::unordered_map<std::string, nim::NIMTeamMuteType>&
Convert::getTeamMuteType() const {
  return m_teamMuteType;
}

const std::unordered_map<std::string, nim::NIMTeamUserType>&
Convert::getTeamMemberType() const {
  return m_teamMemberType;
}

bool Convert::findCacheFileType(const std::string& fileType,
                                std::string& cacheFileType) const {
  return convertDartStringToNIMEnum(fileType, m_cacheFileType, cacheFileType);
}

bool Convert::convert2IMMessage(const flutter::EncodableMap* arguments,
                                nim::IMMessage& imMessage,
                                std::string& imMessageJson) {
  auto resendIt = arguments->find(flutter::EncodableValue("resend"));
  if (resendIt != arguments->end() && !resendIt->second.IsNull()) {
    imMessage.msg_setting_.resend_flag_ =
        std::get<bool>(resendIt->second) ? BS_TRUE : BS_FALSE;
  }

  auto messageIdIt = arguments->find(flutter::EncodableValue("messageId"));
  if (messageIdIt != arguments->end() && !messageIdIt->second.IsNull()) {
    // wjzh
  }

  auto sessionIdIt = arguments->find(flutter::EncodableValue("sessionId"));
  if (sessionIdIt != arguments->end() && !sessionIdIt->second.IsNull()) {
    imMessage.receiver_accid_ = std::get<std::string>(sessionIdIt->second);
  }

  auto sessionTypeIt = arguments->find(flutter::EncodableValue("sessionType"));
  if (sessionTypeIt != arguments->end() && !sessionTypeIt->second.IsNull()) {
    auto sessionType = std::get<std::string>(sessionTypeIt->second);
    if (auto it = m_sessionType.find(sessionType); it != m_sessionType.end()) {
      imMessage.session_type_ = it->second;
    } else {
      YXLOG(Warn) << "parse failed, sessionType: " << sessionType << YXLOGEnd;
      return false;
    }
  }

  auto messageTypeIt = arguments->find(flutter::EncodableValue("messageType"));
  if (messageTypeIt != arguments->end() && !messageTypeIt->second.IsNull()) {
    auto messageType = std::get<std::string>(messageTypeIt->second);
    if (auto it = m_messageType.find(messageType); it != m_messageType.end()) {
      imMessage.type_ = it->second;
    } else {
      YXLOG(Warn) << "parse failed, messageType: " << messageType << YXLOGEnd;
      return false;
    }
  }

  auto messageSubTypeIt =
      arguments->find(flutter::EncodableValue("messageSubType"));
  if (messageSubTypeIt != arguments->end() &&
      !messageSubTypeIt->second.IsNull()) {
    imMessage.sub_type_ =
        atoi(std::get<std::string>(messageTypeIt->second).c_str());
  }

  auto statusIt = arguments->find(flutter::EncodableValue("status"));
  if (statusIt != arguments->end() && !statusIt->second.IsNull()) {
    auto status = std::get<std::string>(statusIt->second);
    if (auto it = m_status.find(status); it != m_status.end()) {
      imMessage.status_ = it->second;
    } else {
      YXLOG(Warn) << "parse failed, status: " << status << YXLOGEnd;
      return false;
    }
  }

  auto messageDirectionIt =
      arguments->find(flutter::EncodableValue("messageDirection"));
  if (messageDirectionIt != arguments->end() &&
      !messageDirectionIt->second.IsNull()) {
    // wjzh
  }

  auto fromAccountIt = arguments->find(flutter::EncodableValue("fromAccount"));
  if (fromAccountIt != arguments->end() && !fromAccountIt->second.IsNull()) {
    imMessage.sender_accid_ = std::get<std::string>(fromAccountIt->second);
  } else {
    imMessage.sender_accid_ = NimCore::getInstance()->getAccountId();
  }

  auto contentIt = arguments->find(flutter::EncodableValue("content"));
  if (contentIt != arguments->end() && !contentIt->second.IsNull()) {
    imMessage.content_ = std::get<std::string>(contentIt->second);
  }

  auto timestampIt = arguments->find(flutter::EncodableValue("timestamp"));
  if (timestampIt != arguments->end() && !timestampIt->second.IsNull()) {
    imMessage.timetag_ = timestampIt->second.LongValue();
  }

  auto uuidIt = arguments->find(flutter::EncodableValue("uuid"));
  if (uuidIt != arguments->end() && !uuidIt->second.IsNull()) {
    imMessage.client_msg_id_ = std::get<std::string>(uuidIt->second);
  }

  if (imMessage.client_msg_id_.empty()) {
    imMessage.client_msg_id_ = getUUID();
  }

  auto serverIdIt = arguments->find(flutter::EncodableValue("serverId"));
  if (serverIdIt != arguments->end() && !serverIdIt->second.IsNull()) {
    imMessage.readonly_server_id_ = serverIdIt->second.LongValue();
  }

  auto configIt = arguments->find(flutter::EncodableValue("config"));
  if (configIt != arguments->end() && !configIt->second.IsNull()) {
    auto config = std::get<flutter::EncodableMap>(configIt->second);
    auto enableHistoryIt =
        config.find(flutter::EncodableValue("enableHistory"));
    if (enableHistoryIt != config.end() && !enableHistoryIt->second.IsNull()) {
      imMessage.msg_setting_.server_history_saved_ =
          std::get<bool>(enableHistoryIt->second) ? BS_TRUE : BS_FALSE;
    }

    auto enablePersistIt =
        config.find(flutter::EncodableValue("enablePersist"));
    if (enablePersistIt != config.end() && !enablePersistIt->second.IsNull()) {
      imMessage.msg_setting_.need_offline_ =
          std::get<bool>(enablePersistIt->second) ? BS_TRUE : BS_FALSE;
    }

    auto enablePushIt = config.find(flutter::EncodableValue("enablePush"));
    if (enablePushIt != config.end() && !enablePushIt->second.IsNull()) {
      imMessage.msg_setting_.need_push_ =
          std::get<bool>(enablePushIt->second) ? BS_TRUE : BS_FALSE;
    }

    auto enablePushNickIt =
        config.find(flutter::EncodableValue("enablePushNick"));
    if (enablePushNickIt != config.end() &&
        !enablePushNickIt->second.IsNull()) {
      imMessage.msg_setting_.push_need_prefix_ =
          std::get<bool>(enablePushNickIt->second) ? BS_TRUE : BS_FALSE;
    }

    auto enableRoamingIt =
        config.find(flutter::EncodableValue("enableRoaming"));
    if (enableRoamingIt != config.end() && !enableRoamingIt->second.IsNull()) {
      imMessage.msg_setting_.roaming_ =
          std::get<bool>(enableRoamingIt->second) ? BS_TRUE : BS_FALSE;
    }

    auto enableRouteIt = config.find(flutter::EncodableValue("enableRoute"));
    if (enableRouteIt != config.end() && !enableRouteIt->second.IsNull()) {
      imMessage.msg_setting_.routable_ =
          std::get<bool>(enableRouteIt->second) ? BS_TRUE : BS_FALSE;
    }

    auto enableSelfSyncIt =
        config.find(flutter::EncodableValue("enableSelfSync"));
    if (enableSelfSyncIt != config.end() &&
        !enableSelfSyncIt->second.IsNull()) {
      imMessage.msg_setting_.self_sync_ =
          std::get<bool>(enableSelfSyncIt->second) ? BS_TRUE : BS_FALSE;
    }

    auto enableUnreadCountIt =
        config.find(flutter::EncodableValue("enableUnreadCount"));
    if (enableUnreadCountIt != config.end() &&
        !enableUnreadCountIt->second.IsNull()) {
      imMessage.msg_setting_.push_need_badge_ =
          std::get<bool>(enableUnreadCountIt->second) ? BS_TRUE : BS_FALSE;
    }
  }

  auto remoteExtensionIt =
      arguments->find(flutter::EncodableValue("remoteExtension"));
  if (remoteExtensionIt != arguments->end() &&
      !remoteExtensionIt->second.IsNull()) {
    auto remoteExtension =
        std::get<flutter::EncodableMap>(remoteExtensionIt->second);
    nim_cpp_wrapper_util::Json::Value server_ext_json;
    if (!convertMap2Json(&remoteExtension, server_ext_json)) {
      return false;
    }
    imMessage.msg_setting_.server_ext_ = server_ext_json;
  }

  auto localExtensionIt =
      arguments->find(flutter::EncodableValue("localExtension"));
  if (localExtensionIt != arguments->end() &&
      !localExtensionIt->second.IsNull()) {
    auto localExtension =
        std::get<flutter::EncodableMap>(localExtensionIt->second);
    nim_cpp_wrapper_util::Json::Value local_ext_json;
    if (!convertMap2Json(&localExtension, local_ext_json)) {
      return false;
    }
    imMessage.msg_setting_.local_ext_ =
        nim::GetJsonStringWithNoStyled(local_ext_json);
  }

  auto callbackExtensionIt =
      arguments->find(flutter::EncodableValue("callbackExtension"));
  if (callbackExtensionIt != arguments->end() &&
      !callbackExtensionIt->second.IsNull()) {
    imMessage.third_party_callback_ext_ =
        std::get<std::string>(callbackExtensionIt->second);
  }

  auto pushPayloadIt = arguments->find(flutter::EncodableValue("pushPayload"));
  if (pushPayloadIt != arguments->end() && !pushPayloadIt->second.IsNull()) {
    auto pushPayload = std::get<flutter::EncodableMap>(pushPayloadIt->second);
    nim_cpp_wrapper_util::Json::Value push_payload;
    if (!convertMap2Json(&pushPayload, push_payload)) {
      return false;
    }
    imMessage.msg_setting_.push_payload_ = push_payload;
  }

  auto pushContentIt = arguments->find(flutter::EncodableValue("pushContent"));
  if (pushContentIt != arguments->end() && !pushContentIt->second.IsNull()) {
    imMessage.msg_setting_.push_content_ =
        std::get<std::string>(pushContentIt->second);
  }

  auto memberPushOptionIt =
      arguments->find(flutter::EncodableValue("memberPushOption"));
  if (memberPushOptionIt != arguments->end() &&
      !memberPushOptionIt->second.IsNull()) {
    auto memberPushOption =
        std::get<flutter::EncodableMap>(memberPushOptionIt->second);
    auto forcePushListIt =
        memberPushOption.find(flutter::EncodableValue("forcePushList"));
    if (forcePushListIt != memberPushOption.end() &&
        !forcePushListIt->second.IsNull()) {
      auto forcePushList =
          std::get<flutter::EncodableList>(forcePushListIt->second);
      for (auto& it : forcePushList) {
        auto itValue = std::get<std::string>(it);
        imMessage.msg_setting_.force_push_ids_list_.emplace_back(itValue);
      }
    }

    auto forcePushContentIt =
        memberPushOption.find(flutter::EncodableValue("forcePushContent"));
    if (forcePushContentIt != memberPushOption.end() &&
        !forcePushContentIt->second.IsNull()) {
      imMessage.msg_setting_.force_push_content_ =
          std::get<std::string>(forcePushContentIt->second);
    }

    auto isForcePushIt =
        memberPushOption.find(flutter::EncodableValue("isForcePush"));
    if (isForcePushIt != memberPushOption.end() &&
        !isForcePushIt->second.IsNull()) {
      imMessage.msg_setting_.is_force_push_ =
          std::get<bool>(isForcePushIt->second) ? BS_TRUE : BS_FALSE;
    }
  }

  auto senderClientTypeIt =
      arguments->find(flutter::EncodableValue("senderClientType"));
  if (senderClientTypeIt != arguments->end() &&
      !senderClientTypeIt->second.IsNull()) {
    auto senderClientType = std::get<std::string>(senderClientTypeIt->second);
    if (auto it = m_clientType.find(senderClientType);
        it != m_clientType.end()) {
      imMessage.readonly_sender_client_type_ = it->second;
    } else {
      // return false;
    }
  }

  auto antiSpamOptionIt =
      arguments->find(flutter::EncodableValue("antiSpamOption"));
  if (antiSpamOptionIt != arguments->end() &&
      !antiSpamOptionIt->second.IsNull()) {
    auto antiSpamOption =
        std::get<flutter::EncodableMap>(antiSpamOptionIt->second);
    auto enableIt = antiSpamOption.find(flutter::EncodableValue("enable"));
    if (enableIt != antiSpamOption.end() && !enableIt->second.IsNull()) {
      imMessage.msg_setting_.anti_spam_enable_ =
          std::get<bool>(enableIt->second) ? BS_TRUE : BS_FALSE;
    }

    auto antiSpamOptionContentIt =
        antiSpamOption.find(flutter::EncodableValue("content"));
    if (antiSpamOptionContentIt != antiSpamOption.end() &&
        !antiSpamOptionContentIt->second.IsNull()) {
      imMessage.msg_setting_.anti_spam_content_ =
          std::get<std::string>(antiSpamOptionContentIt->second);
    }

    auto antiSpamConfigIdIt =
        antiSpamOption.find(flutter::EncodableValue("antiSpamConfigId"));
    if (antiSpamConfigIdIt != antiSpamOption.end() &&
        !antiSpamConfigIdIt->second.IsNull()) {
      imMessage.msg_setting_.anti_apam_biz_id_ =
          std::get<std::string>(antiSpamConfigIdIt->second);
    }
  }

  auto messageAckIt = arguments->find(flutter::EncodableValue("messageAck"));
  if (messageAckIt != arguments->end() && !messageAckIt->second.IsNull()) {
    imMessage.msg_setting_.team_msg_need_ack_ =
        std::get<bool>(messageAckIt->second) ? BS_TRUE : BS_FALSE;
  }

  auto hasSendAckIt = arguments->find(flutter::EncodableValue("hasSendAck"));
  if (hasSendAckIt != arguments->end() && !hasSendAckIt->second.IsNull()) {
    imMessage.msg_setting_.team_msg_ack_sent_ =
        std::get<bool>(hasSendAckIt->second) ? BS_TRUE : BS_FALSE;
  }

  auto ackCountIt = arguments->find(flutter::EncodableValue("ackCount"));
  if (ackCountIt != arguments->end() && !ackCountIt->second.IsNull()) {
    // wjzh
  }

  auto unAckCountIt = arguments->find(flutter::EncodableValue("unAckCount"));
  if (unAckCountIt != arguments->end() && !unAckCountIt->second.IsNull()) {
    imMessage.msg_setting_.team_msg_unread_count_ =
        std::get<int>(unAckCountIt->second);
  }

  auto clientAntiSpamIt =
      arguments->find(flutter::EncodableValue("clientAntiSpam"));
  if (clientAntiSpamIt != arguments->end() &&
      !clientAntiSpamIt->second.IsNull()) {
    imMessage.msg_setting_.client_anti_spam_hitting_ =
        std::get<bool>(clientAntiSpamIt->second) ? BS_TRUE : BS_FALSE;
  }

  auto isInBlackListIt =
      arguments->find(flutter::EncodableValue("isInBlackList"));
  if (isInBlackListIt != arguments->end() &&
      !isInBlackListIt->second.IsNull()) {
    // wjzh
  }

  auto isCheckedIt = arguments->find(flutter::EncodableValue("isChecked"));
  if (isCheckedIt != arguments->end() && !isCheckedIt->second.IsNull()) {
    // wjzh
  }

  auto sessionUpdateIt =
      arguments->find(flutter::EncodableValue("sessionUpdate"));
  if (sessionUpdateIt != arguments->end() &&
      !sessionUpdateIt->second.IsNull()) {
    imMessage.msg_setting_.is_update_session_ =
        std::get<bool>(sessionUpdateIt->second) ? BS_TRUE : BS_FALSE;
  }

  auto messageThreadOptionIt =
      arguments->find(flutter::EncodableValue("messageThreadOption"));
  if (messageThreadOptionIt != arguments->end() &&
      !messageThreadOptionIt->second.IsNull()) {
    auto messageThreadOption =
        std::get<flutter::EncodableMap>(messageThreadOptionIt->second);
    auto replyMessageFromAccountIt = messageThreadOption.find(
        flutter::EncodableValue("replyMessageFromAccount"));
    if (replyMessageFromAccountIt != messageThreadOption.end() &&
        !replyMessageFromAccountIt->second.IsNull()) {
      imMessage.thread_info_.reply_msg_from_account_ =
          std::get<std::string>(replyMessageFromAccountIt->second);
    }

    auto replyMessageToAccountIt = messageThreadOption.find(
        flutter::EncodableValue("replyMessageToAccount"));
    if (replyMessageToAccountIt != messageThreadOption.end() &&
        !replyMessageToAccountIt->second.IsNull()) {
      imMessage.thread_info_.reply_msg_to_account_ =
          std::get<std::string>(replyMessageToAccountIt->second);
    }

    auto replyMessageTimeIt =
        messageThreadOption.find(flutter::EncodableValue("replyMessageTime"));
    if (replyMessageTimeIt != messageThreadOption.end() &&
        !replyMessageTimeIt->second.IsNull()) {
      imMessage.thread_info_.reply_msg_time_ =
          replyMessageTimeIt->second.LongValue();
    }

    auto replyMessageIdServerIt = messageThreadOption.find(
        flutter::EncodableValue("replyMessageIdServer"));
    if (replyMessageIdServerIt != messageThreadOption.end() &&
        !replyMessageIdServerIt->second.IsNull()) {
      imMessage.thread_info_.reply_msg_id_server_ =
          replyMessageIdServerIt->second.LongValue();
    }

    auto replyMessageIdClientIt = messageThreadOption.find(
        flutter::EncodableValue("replyMessageIdClient"));
    if (replyMessageIdClientIt != messageThreadOption.end() &&
        !replyMessageIdClientIt->second.IsNull()) {
      imMessage.thread_info_.reply_msg_id_client_ =
          std::get<std::string>(replyMessageIdClientIt->second);
    }

    auto threadMessageFromAccountIt = messageThreadOption.find(
        flutter::EncodableValue("threadMessageFromAccount"));
    if (threadMessageFromAccountIt != messageThreadOption.end() &&
        !threadMessageFromAccountIt->second.IsNull()) {
      imMessage.thread_info_.thread_msg_from_account_ =
          std::get<std::string>(threadMessageFromAccountIt->second);
    }

    auto threadMessageToAccountIt = messageThreadOption.find(
        flutter::EncodableValue("threadMessageToAccount"));
    if (threadMessageToAccountIt != messageThreadOption.end() &&
        !threadMessageToAccountIt->second.IsNull()) {
      imMessage.thread_info_.thread_msg_to_account_ =
          std::get<std::string>(threadMessageToAccountIt->second);
    }

    auto threadMessageTimeIt =
        messageThreadOption.find(flutter::EncodableValue("threadMessageTime"));
    if (threadMessageTimeIt != messageThreadOption.end() &&
        !threadMessageTimeIt->second.IsNull()) {
      imMessage.thread_info_.thread_msg_time_ =
          threadMessageTimeIt->second.LongValue();
    }

    auto threadMessageIdServerIt = messageThreadOption.find(
        flutter::EncodableValue("threadMessageIdServer"));
    if (threadMessageIdServerIt != messageThreadOption.end() &&
        !threadMessageIdServerIt->second.IsNull()) {
      imMessage.thread_info_.thread_msg_id_server_ =
          threadMessageIdServerIt->second.LongValue();
    }

    auto threadMessageIdClientIt = messageThreadOption.find(
        flutter::EncodableValue("threadMessageIdClient"));
    if (threadMessageIdClientIt != messageThreadOption.end() &&
        !threadMessageIdClientIt->second.IsNull()) {
      imMessage.thread_info_.thread_msg_id_client_ =
          std::get<std::string>(threadMessageIdClientIt->second);
    }
  }

  auto quickCommentUpdateTimeIt =
      arguments->find(flutter::EncodableValue("quickCommentUpdateTime"));
  if (quickCommentUpdateTimeIt != arguments->end() &&
      !quickCommentUpdateTimeIt->second.IsNull()) {
    // wjzh
  }

  auto isDeletedIt = arguments->find(flutter::EncodableValue("isDeleted"));
  if (isDeletedIt != arguments->end() && !isDeletedIt->second.IsNull()) {
    imMessage.thread_info_.deleted_ =
        std::get<bool>(isDeletedIt->second) ? BS_TRUE : BS_FALSE;
  }

  auto yidunAntiCheatingIt =
      arguments->find(flutter::EncodableValue("yidunAntiCheating"));
  if (yidunAntiCheatingIt != arguments->end() &&
      !yidunAntiCheatingIt->second.IsNull()) {
    auto yidunAntiCheating =
        std::get<flutter::EncodableMap>(yidunAntiCheatingIt->second);
    nim_cpp_wrapper_util::Json::Value yidunAntiCheating_;
    if (!convertMap2Json(&yidunAntiCheating, yidunAntiCheating_)) {
      return false;
    }
    imMessage.msg_setting_.yidun_anti_cheating_ =
        nim::GetJsonStringWithNoStyled(yidunAntiCheating_);
  }

  auto envIt = arguments->find(flutter::EncodableValue("env"));
  if (envIt != arguments->end() && !envIt->second.IsNull()) {
    imMessage.msg_setting_.env_config_ = std::get<std::string>(envIt->second);
  }

  auto attachmentStatusIt =
      arguments->find(flutter::EncodableValue("attachmentStatus"));
  if (attachmentStatusIt != arguments->end() &&
      !attachmentStatusIt->second.IsNull()) {
    // wjzh
  }

  if (!convert2IMAttach(imMessage, arguments, imMessageJson)) {
    return false;
  }

  nim::IMMessage msgTmp;
  if (!nim::Talk::ParseIMMessage(imMessageJson, msgTmp)) {
    YXLOG(Warn) << "parseIMMessage failed, msg: " << imMessageJson << YXLOGEnd;
    return false;
  }
  imMessage.attach_ = msgTmp.attach_;
  imMessage.local_res_path_ = msgTmp.local_res_path_;

  return true;
}

bool Convert::convert2IMAttach(const nim::IMMessage& imMessage,
                               const flutter::EncodableMap* arguments,
                               std::string& imMessageJson) {
  flutter::EncodableMap messageAttachment;
  auto messageAttachmentIt =
      arguments->find(flutter::EncodableValue("messageAttachment"));
  if (messageAttachmentIt != arguments->end() &&
      !messageAttachmentIt->second.IsNull()) {
    messageAttachment =
        std::get<flutter::EncodableMap>(messageAttachmentIt->second);
  }
  std::string strPath = imMessage.local_res_path_;
  switch (imMessage.type_) {
    case nim::kNIMMessageTypeText: {
      imMessageJson = nim::Talk::CreateTextMessage(
          imMessage.receiver_accid_, imMessage.session_type_,
          imMessage.client_msg_id_, imMessage.content_, imMessage.msg_setting_,
          imMessage.timetag_);
    }
      return true;
    case nim::kNIMMessageTypeImage: {
      nim::IMImage imImage;
      convertMap2ImFile(&messageAttachment, dynamic_cast<nim::IMFile&>(imImage),
                        strPath);
      auto wIt = messageAttachment.find(flutter::EncodableValue("w"));
      if (wIt != messageAttachment.end() && !wIt->second.IsNull()) {
        imImage.width_ = std::get<int32_t>(wIt->second);
      }

      auto hIt = messageAttachment.find(flutter::EncodableValue("h"));
      if (hIt != messageAttachment.end() && !hIt->second.IsNull()) {
        imImage.height_ = std::get<int32_t>(hIt->second);
      }

      auto thumbPathIt =
          messageAttachment.find(flutter::EncodableValue("thumbPath"));
      if (thumbPathIt != messageAttachment.end() &&
          !thumbPathIt->second.IsNull()) {
        // wjzh
      }

      auto thumbUrlIt =
          messageAttachment.find(flutter::EncodableValue("thumbUrl"));
      if (thumbUrlIt != messageAttachment.end() &&
          !thumbUrlIt->second.IsNull()) {
        // wjzh
      }

      imMessageJson = nim::Talk::CreateImageMessage(
          imMessage.receiver_accid_, imMessage.session_type_,
          imMessage.client_msg_id_, imImage, strPath, imMessage.msg_setting_,
          imMessage.timetag_);
    }
      return true;
    case nim::kNIMMessageTypeAudio: {
      nim::IMAudio imAudio;
      convertMap2ImFile(&messageAttachment, dynamic_cast<nim::IMFile&>(imAudio),
                        strPath);
      auto durIt = messageAttachment.find(flutter::EncodableValue("dur"));
      if (durIt != messageAttachment.end() && !durIt->second.IsNull()) {
        imAudio.duration_ = std::get<int32_t>(durIt->second);
      }

      auto autoTransformIt =
          messageAttachment.find(flutter::EncodableValue("autoTransform"));
      if (autoTransformIt != messageAttachment.end() &&
          !autoTransformIt->second.IsNull()) {
        // wjzh
      }

      auto textIt = messageAttachment.find(flutter::EncodableValue("text"));
      if (textIt != messageAttachment.end() && !textIt->second.IsNull()) {
        // wjzh
      }

      imMessageJson = nim::Talk::CreateAudioMessage(
          imMessage.receiver_accid_, imMessage.session_type_,
          imMessage.client_msg_id_, imAudio, strPath, imMessage.msg_setting_,
          imMessage.timetag_);
    }
      return true;
    case nim::kNIMMessageTypeVideo: {
      nim::IMVideo imVideo;
      convertMap2ImFile(&messageAttachment, dynamic_cast<nim::IMFile&>(imVideo),
                        strPath);
      auto durIt = messageAttachment.find(flutter::EncodableValue("dur"));
      if (durIt != messageAttachment.end() && !durIt->second.IsNull()) {
        imVideo.duration_ = std::get<int32_t>(durIt->second);
      }

      auto wIt = messageAttachment.find(flutter::EncodableValue("w"));
      if (wIt != messageAttachment.end() && !wIt->second.IsNull()) {
        imVideo.width_ = std::get<int32_t>(wIt->second);
      }

      auto hIt = messageAttachment.find(flutter::EncodableValue("h"));
      if (hIt != messageAttachment.end() && !hIt->second.IsNull()) {
        imVideo.height_ = std::get<int32_t>(hIt->second);
      }

      auto thumbPathIt =
          messageAttachment.find(flutter::EncodableValue("thumbPath"));
      if (thumbPathIt != messageAttachment.end() &&
          !thumbPathIt->second.IsNull()) {
        // wjzh
      }

      auto thumbUrlIt =
          messageAttachment.find(flutter::EncodableValue("thumbUrl"));
      if (thumbUrlIt != messageAttachment.end() &&
          !thumbUrlIt->second.IsNull()) {
        // wjzh
      }

      imMessageJson = nim::Talk::CreateVideoMessage(
          imMessage.receiver_accid_, imMessage.session_type_,
          imMessage.client_msg_id_, imVideo, strPath, imMessage.msg_setting_,
          imMessage.timetag_);
    }
      return true;
    case nim::kNIMMessageTypeLocation: {
      nim::IMLocation imLocation;
      auto latIt = messageAttachment.find(flutter::EncodableValue("lat"));
      if (latIt != messageAttachment.end() && !latIt->second.IsNull()) {
        imLocation.latitude_ = std::get<double>(latIt->second);
      }

      auto lngIt = messageAttachment.find(flutter::EncodableValue("lng"));
      if (lngIt != messageAttachment.end() && !lngIt->second.IsNull()) {
        imLocation.longitude_ = std::get<double>(lngIt->second);
      }

      auto titleIt = messageAttachment.find(flutter::EncodableValue("title"));
      if (titleIt != messageAttachment.end() && !titleIt->second.IsNull()) {
        imLocation.description_ = std::get<std::string>(titleIt->second);
      }

      imMessageJson = nim::Talk::CreateLocationMessage(
          imMessage.receiver_accid_, imMessage.session_type_,
          imMessage.client_msg_id_, imLocation, imMessage.msg_setting_,
          imMessage.timetag_);
    }
      return true;
    case nim::kNIMMessageTypeNotification:
      break;
    case nim::kNIMMessageTypeFile: {
      nim::IMFile imFile;
      convertMap2ImFile(&messageAttachment, imFile, strPath);

      imMessageJson = nim::Talk::CreateFileMessage(
          imMessage.receiver_accid_, imMessage.session_type_,
          imMessage.client_msg_id_, imFile, strPath, imMessage.msg_setting_,
          imMessage.timetag_);
    }
      return true;
    case nim::kNIMMessageTypeTips: {
      imMessageJson = nim::Talk::CreateTipMessage(
          imMessage.receiver_accid_, imMessage.session_type_,
          imMessage.client_msg_id_, imMessage.content_, imMessage.msg_setting_,
          imMessage.timetag_);
    }
      return true;
    case nim::kNIMMessageTypeRobot:
      break;
    case nim::kNIMMessageTypeG2NetCall:
      break;
    case nim::kNIMMessageTypeCustom: {
      nim_cpp_wrapper_util::Json::Value value;
      if (!convertMap2Json(arguments, value)) {
        break;
      }
      nim_cpp_wrapper_util::Json::Value values;
      values[nim::kNIMMsgKeyToAccount] = imMessage.receiver_accid_;
      values[nim::kNIMMsgKeyToType] = imMessage.session_type_;
      values[nim::kNIMMsgKeyClientMsgid] = imMessage.client_msg_id_;
      values[nim::kNIMMsgKeyAttach] = nim::GetJsonStringWithNoStyled(value);
      values[nim::kNIMMsgKeyType] = nim::kNIMMessageTypeCustom;
      values[nim::kNIMMsgKeyLocalTalkId] = imMessage.receiver_accid_;
      values[nim::kNIMMsgKeyLocalResId] = imMessage.client_msg_id_;
      values[nim::kNIMMsgKeyLocalReceiveMsgContent] = imMessage.content_;
      if (imMessage.timetag_ > 0) {
        values[nim::kNIMMsgKeyTime] = imMessage.timetag_;
      }
      imMessage.msg_setting_.ToJsonValue(values);

      imMessageJson = nim::GetJsonStringWithNoStyled(values);
    }
      return true;
    case nim::kNIMMessageTypeUnknown: {
      nim_cpp_wrapper_util::Json::Value values;
      values[nim::kNIMMsgKeyToAccount] = imMessage.receiver_accid_;
      values[nim::kNIMMsgKeyToType] = imMessage.session_type_;
      values[nim::kNIMMsgKeyClientMsgid] = imMessage.client_msg_id_;
      values[nim::kNIMMsgKeyType] = nim::kNIMMessageTypeUnknown;
      values[nim::kNIMMsgKeyLocalTalkId] = imMessage.receiver_accid_;
      values[nim::kNIMMsgKeyLocalResId] = imMessage.client_msg_id_;
      if (imMessage.timetag_ > 0) {
        values[nim::kNIMMsgKeyTime] = imMessage.timetag_;
      }
      imMessage.msg_setting_.ToJsonValue(values);

      imMessageJson = nim::GetJsonStringWithNoStyled(values);
    }
      return true;
    default:
      break;
  }

  YXLOG(Warn) << "convert2IMAttach parse failed, messageType: "
              << imMessage.type_ << YXLOGEnd;
  return false;
}

bool Convert::convertIMAttach2Map(const nim::IMMessage& imMessage,
                                  flutter::EncodableMap& arguments) {
  std::string strPath = imMessage.local_res_path_;
  if (strPath.empty()) {
    strPath = nim::Talk::GetAttachmentPathFromMsg(imMessage);
  }
  YXLOG(Info) << "convertIMAttach2Map strPath: " << strPath << YXLOGEnd;

  std::string strMsgType;
  for (auto& it : m_messageType) {
    if (it.second == imMessage.type_) {
      strMsgType = it.first;
      break;
    }
  }
  if (strMsgType.empty()) {
    YXLOG(Warn) << "parse failed, messageType: " << imMessage.type_ << YXLOGEnd;
    return false;
  }
  switch (imMessage.type_) {
    case nim::kNIMMessageTypeText:
      arguments[flutter::EncodableValue("content")] = imMessage.content_;
      return true;
    case nim::kNIMMessageTypeImage: {
      nim::IMImage imImage;
      if (!nim::Talk::ParseImageMessageAttach(imMessage, imImage)) {
        YXLOG(Warn) << "parseImageMessageAttach failed, msg: "
                    << imMessage.ToJsonString(true) << YXLOGEnd;
        return false;
      }

      if (!convertImFile2Map(arguments, dynamic_cast<nim::IMFile&>(imImage),
                             strPath, strMsgType)) {
        return false;
      }

      arguments[flutter::EncodableValue("w")] = imImage.width_;
      arguments[flutter::EncodableValue("h")] = imImage.height_;

      // wjzh
      // arguments[flutter::EncodableValue("thumbPath")] =

      // wjzh
      // arguments[flutter::EncodableValue("thumbUrl")] =
    }
      return true;
    case nim::kNIMMessageTypeAudio: {
      nim::IMAudio imAudio;
      if (!nim::Talk::ParseAudioMessageAttach(imMessage, imAudio)) {
        YXLOG(Warn) << "parseAudioMessageAttach failed, msg: "
                    << imMessage.ToJsonString(true) << YXLOGEnd;
        return false;
      }

      if (!convertImFile2Map(arguments, dynamic_cast<nim::IMFile&>(imAudio),
                             strPath, strMsgType)) {
        return false;
      }

      arguments[flutter::EncodableValue("dur")] = imAudio.duration_;

      // wjzh
      // arguments[flutter::EncodableValue(flutter::EncodableValue("autoTransform")];

      // wjzh
      // arguments[flutter::EncodableValue("text")]
    }
      return true;
    case nim::kNIMMessageTypeVideo: {
      nim::IMVideo imVideo;
      if (!nim::Talk::ParseVideoMessageAttach(imMessage, imVideo)) {
        YXLOG(Warn) << "parseVideoMessageAttach failed, msg: "
                    << imMessage.ToJsonString(true) << YXLOGEnd;
        return false;
      }

      if (!convertImFile2Map(arguments, dynamic_cast<nim::IMFile&>(imVideo),
                             strPath, strMsgType)) {
        return false;
      }

      arguments[flutter::EncodableValue("dur")] = imVideo.duration_;
      arguments[flutter::EncodableValue("w")] = imVideo.width_;
      arguments[flutter::EncodableValue("h")] = imVideo.height_;

      // wjzh
      // arguments[flutter::EncodableValue("thumbPath")] =

      // wjzh
      // arguments[flutter::EncodableValue("thumbUrl")] =
    }
      return true;
    case nim::kNIMMessageTypeLocation: {
      nim::IMLocation imLocation;
      if (!nim::Talk::ParseLocationMessageAttach(imMessage, imLocation)) {
        YXLOG(Warn) << "parseLocationMessageAttach failed, msg: "
                    << imMessage.ToJsonString(true) << YXLOGEnd;
        return false;
      }
      arguments[flutter::EncodableValue("messageType")] = strMsgType;
      arguments[flutter::EncodableValue("lat")] = imLocation.latitude_;
      arguments[flutter::EncodableValue("lng")] = imLocation.longitude_;
      arguments[flutter::EncodableValue("title")] = imLocation.description_;
    }
      return true;
    case nim::kNIMMessageTypeNotification:
      break;
    case nim::kNIMMessageTypeFile: {
      nim::IMFile imFile;
      if (!nim::Talk::ParseFileMessageAttach(imMessage, imFile)) {
        YXLOG(Warn) << "parseFileMessageAttach failed, msg: "
                    << imMessage.ToJsonString(true) << YXLOGEnd;
        return false;
      }

      if (!convertImFile2Map(arguments, imFile, strPath, strMsgType)) {
        return false;
      }
    }
      return true;
    case nim::kNIMMessageTypeTips:
      arguments[flutter::EncodableValue("content")] = imMessage.content_;
      return true;
    case nim::kNIMMessageTypeRobot:
      break;
    case nim::kNIMMessageTypeG2NetCall:
      break;
    case nim::kNIMMessageTypeCustom: {
      nim_cpp_wrapper_util::Json::Value values =
          getJsonValueFromJsonString(imMessage.attach_);
      if (!values.isObject()) {
        YXLOG(Warn) << "parse failed, values is not object: "
                    << imMessage.attach_ << YXLOGEnd;
        return false;
      }

      convertJson2Map(arguments, values);
      arguments[flutter::EncodableValue("messageType")] = strMsgType;
    }
      return true;
    case nim::kNIMMessageTypeUnknown:
      arguments[flutter::EncodableValue("messageType")] = strMsgType;
      return true;
    default:
      break;
  }

  YXLOG(Warn) << "convertIMAttach2Map parse failed, messageType: " << strMsgType
              << YXLOGEnd;
  return false;
}

bool Convert::convertIMSessionData2Map(const nim::SessionData& arc,
                                       flutter::EncodableMap& tmp) {
  tmp[flutter::EncodableValue("sessionId")] = arc.id_;
  tmp[flutter::EncodableValue("senderAccount")] = arc.msg_sender_accid_;
  // wjzh
  // tmp[flutter::EncodableValue("senderNickname")];

  bool bFind = false;
  for (auto& it : m_sessionType) {
    if (it.second == arc.type_) {
      tmp[flutter::EncodableValue("sessionType")] = it.first;
      bFind = true;
      break;
    }
  }
  if (!bFind) {
    YXLOG(Warn) << "parse failed, sessionType: " << arc.type_ << YXLOGEnd;
    return false;
  }

  tmp[flutter::EncodableValue("lastMessageId")] = arc.msg_id_;

  bFind = false;
  for (auto& it : m_messageType) {
    if (it.second == arc.msg_type_) {
      tmp[flutter::EncodableValue("lastMessageType")] = it.first;

      flutter::EncodableMap attach;
      nim::IMMessage imMessage;
      imMessage.type_ = arc.msg_type_;
      imMessage.attach_ = arc.msg_attach_;
      if (Convert::getInstance()->convertIMAttach2Map(imMessage, attach)) {
        tmp[flutter::EncodableValue("lastMessageAttachment")] = attach;
      } else {
        // wjzh
      }

      bFind = true;
      break;
    }
  }
  if (!bFind) {
    YXLOG(Warn) << "parse failed, lastMessageType: " << arc.msg_type_
                << YXLOGEnd;
    return false;
  }

  bFind = false;
  for (auto& it : m_status) {
    if (it.second == arc.msg_status_) {
      tmp[flutter::EncodableValue("lastMessageStatus")] = it.first;
      bFind = true;
      break;
    }
  }
  if (!bFind) {
    YXLOG(Warn) << "parse failed, lastMessageStatus: " << arc.msg_status_
                << YXLOGEnd;
    return false;
  }

  tmp[flutter::EncodableValue("lastMessageContent")] = arc.msg_content_;
  tmp[flutter::EncodableValue("lastMessageTime")] = arc.msg_timetag_;

  tmp[flutter::EncodableValue("unreadCount")] = arc.unread_count_;

  if (!arc.extend_data_.empty()) {
    flutter::EncodableMap mapTmp;
    nim_cpp_wrapper_util::Json::Value value =
        getJsonValueFromJsonString(arc.extend_data_);
    if (!convertJson2Map(mapTmp, value)) {
      YXLOG(Warn) << "parse failed, arc.extend_data_: " << arc.extend_data_
                  << YXLOGEnd;
      return false;
    } else {
      tmp[flutter::EncodableValue("extension")] = mapTmp;
    }
  }

  // wjzh
  // tmp[flutter::EncodableValue("tag"];

  return true;
}

bool Convert::convertIMRecallMsgNotify2Map(
    const nim::RecallMsgNotify& recallMsgNotify,
    flutter::EncodableMap& arguments) {
  flutter::EncodableMap imMessage;
  imMessage[flutter::EncodableValue("fromAccount")] = recallMsgNotify.from_id_;
  imMessage[flutter::EncodableValue("sessionId")] = recallMsgNotify.to_id_;

  bool bFind = false;
  for (auto& it : m_sessionType) {
    if (it.second == recallMsgNotify.session_type_) {
      bFind = true;
      imMessage[flutter::EncodableValue("sessionType")] = it.first;
      break;
    }
  }
  if (!bFind) {
    YXLOG(Warn) << "parse failed, sessionType: "
                << recallMsgNotify.session_type_ << YXLOGEnd;
    // return false;
  }

  imMessage[flutter::EncodableValue("timestamp")] =
      recallMsgNotify.msglog_timetag_;

  flutter::EncodableMap tmp;
  tmp[flutter::EncodableValue("message")] = imMessage;
  tmp[flutter::EncodableValue("revokeAccount")] = recallMsgNotify.operator_id_;
  tmp[flutter::EncodableValue("customInfo")] = recallMsgNotify.notify_;
  tmp[flutter::EncodableValue("attach")] = recallMsgNotify.attach_;
  tmp[flutter::EncodableValue("notificationType")] =
      recallMsgNotify.notify_feature_;
  tmp[flutter::EncodableValue("callbackExt")] = recallMsgNotify.callback_ext_;

  return true;
}

bool Convert::convertIMSessionInfo2Map(
    const nim::SessionOnLineServiceHelper::SessionInfo& arc,
    flutter::EncodableMap& tmp) {
  tmp[flutter::EncodableValue("sessionId")] = arc.id_;
  tmp[flutter::EncodableValue("updateTime")] = (int64_t)arc.update_time_;
  tmp[flutter::EncodableValue("ext")] = arc.ext_;
  tmp[flutter::EncodableValue("lastMsg")] = arc.last_message_;
  tmp[flutter::EncodableValue("lastMsgType")] = arc.last_message_type_;
  tmp[flutter::EncodableValue("lastrecentSessionMsg")] = arc.last_message_;
  bool bFind = false;
  for (auto& it : m_sessionType) {
    if (it.second == arc.type_) {
      tmp[flutter::EncodableValue("sessionType")] = it.first;
      bFind = true;
      break;
    }
  }
  if (!bFind) {
    YXLOG(Warn) << "parse failed, sessionType: " << arc.type_ << YXLOGEnd;
    return false;
  }

  flutter::EncodableMap tmpSessionData;
  flutter::EncodableMap tmpRevokeNotification;
  if (0 == arc.last_message_type_) {
    nim::IMMessage imMessage = arc.GetLastMessage<0>();
    nim::SessionData sessionData;
    sessionData.id_ = imMessage.receiver_accid_;
    sessionData.type_ = imMessage.session_type_;
    sessionData.msg_id_ = imMessage.client_msg_id_;
    sessionData.msg_sender_accid_ = imMessage.sender_accid_;
    sessionData.msg_content_ = imMessage.content_;
    sessionData.msg_timetag_ = imMessage.timetag_;
    sessionData.msg_type_ = imMessage.type_;
    sessionData.msg_attach_ = imMessage.attach_;
    sessionData.msg_status_ = imMessage.status_;
    sessionData.msg_sub_status_ = imMessage.sub_status_;
    sessionData.unread_count_ = imMessage.msg_setting_.team_msg_unread_count_;
    sessionData.extend_data_ = imMessage.msg_setting_.local_ext_;
    // sessionData.is_robot_session_ = nim::kNIMMessageTypeRobot ==
    // imMessage.feature_;

    if (!Convert::convertIMSessionData2Map(sessionData, tmpSessionData)) {
      YXLOG(Info) << "convertIMSessionData2Map failed." << YXLOGEnd;
    }
  } else if (1 == arc.last_message_type_) {
    nim::RecallMsgNotify imRecallMsgNotify = arc.GetLastMessage<1>();
    if (!Convert::convertIMRecallMsgNotify2Map(imRecallMsgNotify,
                                               tmpRevokeNotification)) {
      YXLOG(Info) << "convertIMRecallMsgNotify2Map failed." << YXLOGEnd;
    }
  }

  tmp[flutter::EncodableValue("recentSession")] = tmpSessionData;
  tmp[flutter::EncodableValue("revokeNotification")] = tmpRevokeNotification;

  return true;
}

bool Convert::convertIMStickTopSessionInfo2Map(
    const nim::StickTopSessionInfo& stickTopSessionInfo,
    flutter::EncodableMap& tmp) {
  tmp[flutter::EncodableValue("sessionId")] = stickTopSessionInfo.id_;
  bool bFind = false;
  for (auto& it : m_sessionType) {
    if (it.second == stickTopSessionInfo.type_) {
      tmp[flutter::EncodableValue("sessionType")] = it.first;
      bFind = true;
      break;
    }
  }
  if (!bFind) {
    YXLOG(Warn) << "parse failed, sessionType: " << stickTopSessionInfo.type_
                << YXLOGEnd;
    return false;
  }
  tmp[flutter::EncodableValue("ext")] = stickTopSessionInfo.ext_;
  tmp[flutter::EncodableValue("createTime")] = stickTopSessionInfo.create_time_;
  tmp[flutter::EncodableValue("updateTime")] = stickTopSessionInfo.update_time_;

  return true;
}

bool Convert::convertMap2ImFile(const flutter::EncodableMap* arguments,
                                nim::IMFile& imFile, std::string& strPath) {
  auto pathIt = arguments->find(flutter::EncodableValue("path"));
  if (pathIt != arguments->end() && !pathIt->second.IsNull()) {
    strPath = std::get<std::string>(pathIt->second);
  }

  auto urlIt = arguments->find(flutter::EncodableValue("url"));
  if (urlIt != arguments->end() && !urlIt->second.IsNull()) {
    imFile.url_ = std::get<std::string>(urlIt->second);
  }

  auto sizeIt = arguments->find(flutter::EncodableValue("size"));
  if (sizeIt != arguments->end() && !sizeIt->second.IsNull()) {
    imFile.size_ = sizeIt->second.LongValue();
  }

  auto md5It = arguments->find(flutter::EncodableValue("md5"));
  if (md5It != arguments->end() && !md5It->second.IsNull()) {
    imFile.md5_ = std::get<std::string>(md5It->second);
  }

  auto nameIt = arguments->find(flutter::EncodableValue("name"));
  if (nameIt != arguments->end() && !nameIt->second.IsNull()) {
    imFile.display_name_ = std::get<std::string>(nameIt->second);
  }

  auto extIt = arguments->find(flutter::EncodableValue("ext"));
  if (extIt != arguments->end() && !extIt->second.IsNull()) {
    imFile.file_extension_ = std::get<std::string>(extIt->second);
  }

  auto expireIt = arguments->find(flutter::EncodableValue("expire"));
  if (expireIt != arguments->end() && !expireIt->second.IsNull()) {
    // wjzh
  }

  auto senIt = arguments->find(flutter::EncodableValue("sen"));
  if (senIt != arguments->end() && !senIt->second.IsNull()) {
    auto sen = std::get<std::string>(senIt->second);
    if (auto senEx = m_nosScene.find(sen); senEx != m_nosScene.end()) {
      imFile.msg_attachment_tag_ = senEx->second;
    } else {
      imFile.msg_attachment_tag_ = sen;
    }
  }

  auto forceUploadIt = arguments->find(flutter::EncodableValue("force_upload"));
  if (forceUploadIt != arguments->end() && !forceUploadIt->second.IsNull()) {
    // wjzh
  }

  return true;
}

bool Convert::convertImFile2Map(flutter::EncodableMap& arguments,
                                const nim::IMFile& imFile,
                                const std::string& strPath,
                                const std::string& strMsgType) {
  arguments[flutter::EncodableValue("messageType")] = strMsgType;
  arguments[flutter::EncodableValue("ext")] = imFile.file_extension_;
  arguments[flutter::EncodableValue("path")] = strPath;
  arguments[flutter::EncodableValue("url")] = imFile.url_;
  arguments[flutter::EncodableValue("size")] = (int)imFile.size_;
  arguments[flutter::EncodableValue("md5")] = imFile.md5_;
  arguments[flutter::EncodableValue("name")] = imFile.display_name_;
  arguments[flutter::EncodableValue("ext")] = imFile.file_extension_;

  // wjzh
  // arguments[flutter::EncodableValue("expire")];

  bool bFind = false;
  for (auto& it : m_nosScene) {
    if (imFile.msg_attachment_tag_ == it.second) {
      arguments[flutter::EncodableValue("sen")] = it.first;
      bFind = true;
      break;
    }
  }
  if (!bFind) {
    arguments[flutter::EncodableValue("sen")] = imFile.msg_attachment_tag_;
    // return false;
  }

  // wjzh
  arguments[flutter::EncodableValue("force_upload")] = true;

  return true;
}

bool Convert::convertMap2Json(const flutter::EncodableMap* arguments,
                              nim_cpp_wrapper_util::Json::Value& value) const {
  for (auto& it : *arguments) {
    if (it.second.IsNull()) {
      // YXLOG(Warn) << "parse failed, key: " << key << " is not value." <<
      // YXLOGEnd;
      continue;
    }
    auto key = std::get<std::string>(it.first);
    if (auto second = std::get_if<bool>(&it.second); second) {
      value[key] = *second;
    } else if (auto second1 = std::get_if<int32_t>(&it.second); second1) {
      value[key] = *second1;
    } else if (auto second2 = std::get_if<int64_t>(&it.second); second2) {
      value[key] = *second2;
    } else if (auto second3 = std::get_if<double>(&it.second); second3) {
      value[key] = *second3;
    } else if (auto second4 = std::get_if<std::string>(&it.second); second4) {
      value[key] = *second4;
    } else if (auto second5 = std::get_if<std::vector<uint8_t>>(&it.second);
               second5) {
      nim_cpp_wrapper_util::Json::Value vec;
      for (auto& it2 : *second5) {
        vec.append(it2);
      }
      value[key] = vec;
    } else if (auto second6 = std::get_if<std::vector<int32_t>>(&it.second);
               second6) {
      nim_cpp_wrapper_util::Json::Value vec;
      for (auto& it2 : *second6) {
        vec.append(it2);
      }
      value[key] = vec;
    } else if (auto second7 = std::get_if<std::vector<int64_t>>(&it.second);
               second7) {
      nim_cpp_wrapper_util::Json::Value vec;
      for (auto& it2 : *second7) {
        vec.append(it2);
      }
      value[key] = vec;
    } else if (auto second8 = std::get_if<std::vector<double>>(&it.second);
               second8) {
      nim_cpp_wrapper_util::Json::Value vec;
      for (auto& it2 : *second8) {
        vec.append(it2);
      }
      value[key] = vec;
    } else if (auto second9 = std::get_if<EncodableList>(&it.second); second9) {
      nim_cpp_wrapper_util::Json::Value listTmp;
      if (!convertList2Json(second9, listTmp)) {
        YXLOG(Warn) << "convertList2Json failed." << YXLOGEnd;
        return false;
      }
      value[key] = listTmp;
    } else if (auto second10 = std::get_if<EncodableMap>(&it.second);
               second10) {
      nim_cpp_wrapper_util::Json::Value mapTmp;
      if (!convertMap2Json(second10, mapTmp)) {
        YXLOG(Warn) << "convertMap2Json failed." << YXLOGEnd;
        return false;
      }
      value[key] = mapTmp;
    }
  }

  return true;
}

bool Convert::convertJson2Map(
    flutter::EncodableMap& map,
    const nim_cpp_wrapper_util::Json::Value& values) const {
  nim_cpp_wrapper_util::Json::Value::Members keys = values.getMemberNames();
  for (auto& it : keys) {
    auto& valueTmp = values[it];
    flutter::EncodableValue key = flutter::EncodableValue(it);
    if (valueTmp.isBool()) {
      map[key] = valueTmp.asBool();
    } else if (valueTmp.isInt()) {
      map[key] = valueTmp.asInt();
    } else if (valueTmp.isInt64()) {
      map[key] = valueTmp.asInt64();
    } else if (valueTmp.isDouble()) {
      map[key] = valueTmp.asDouble();
    } else if (valueTmp.isString()) {
      map[key] = valueTmp.asString();
    } else if (valueTmp.isArray()) {
      flutter::EncodableList listTmp;
      if (!convertJson2List(listTmp, valueTmp)) {
        return false;
      } else {
        map[key] = listTmp;
      }
    } else if (valueTmp.isObject()) {
      flutter::EncodableMap mapTmp;
      if (!convertJson2Map(mapTmp, valueTmp)) {
        return false;
      } else {
        map[key] = mapTmp;
      }
    } else {
      YXLOG(Warn) << "parse failed, it:" << it << YXLOGEnd;
      continue;
    }
  }

  return true;
}

bool Convert::convertList2Json(const flutter::EncodableList* arguments,
                               nim_cpp_wrapper_util::Json::Value& value) const {
  if (arguments->size() == 0) {
    value.resize(0);
    return true;
  }

  for (auto& it : *arguments) {
    if (auto second = std::get_if<bool>(&it); second) {
      value.append(*second);
    } else if (auto second1 = std::get_if<int32_t>(&it); second1) {
      value.append(*second1);
    } else if (auto second2 = std::get_if<int64_t>(&it); second2) {
      value.append(*second2);
    } else if (auto second3 = std::get_if<double>(&it); second3) {
      value.append(*second3);
    } else if (auto second4 = std::get_if<std::string>(&it); second4) {
      value.append(*second4);
    } else if (auto second5 = std::get_if<std::vector<uint8_t>>(&it); second5) {
      nim_cpp_wrapper_util::Json::Value vec;
      for (auto& it2 : *second5) {
        vec.append(it2);
      }
      value.append(vec);
    } else if (auto second6 = std::get_if<std::vector<int32_t>>(&it); second6) {
      nim_cpp_wrapper_util::Json::Value vec;
      for (auto& it2 : *second6) {
        vec.append(it2);
      }
      value.append(vec);
    } else if (auto second7 = std::get_if<std::vector<int64_t>>(&it); second7) {
      nim_cpp_wrapper_util::Json::Value vec;
      for (auto& it2 : *second7) {
        vec.append(it2);
      }
      value.append(vec);
    } else if (auto second8 = std::get_if<std::vector<double>>(&it); second8) {
      nim_cpp_wrapper_util::Json::Value vec;
      for (auto& it2 : *second8) {
        vec.append(it2);
      }
      value.append(vec);
    } else if (auto second9 = std::get_if<EncodableList>(&it); second9) {
      nim_cpp_wrapper_util::Json::Value listTmp;
      if (!convertList2Json(second9, listTmp)) {
        return false;
      }
      value.append(listTmp);
    } else if (auto second10 = std::get_if<EncodableMap>(&it); second10) {
      nim_cpp_wrapper_util::Json::Value mapTmp;
      if (!convertMap2Json(second10, mapTmp)) {
        return false;
      }
      value.append(mapTmp);
    }
  }
  return true;
}

bool Convert::convertJson2List(
    flutter::EncodableList& list,
    const nim_cpp_wrapper_util::Json::Value& values) const {
  for (int index = 0; index < (int)values.size(); index++) {
    auto& valueTmp = values[index];
    if (valueTmp.isNull()) {
      list.emplace_back(flutter::EncodableValue());
    } else if (valueTmp.isBool()) {
      list.emplace_back(flutter::EncodableValue(valueTmp.asBool()));
    } else if (valueTmp.isInt()) {
      list.emplace_back(flutter::EncodableValue(valueTmp.asInt()));
    } else if (valueTmp.isInt64()) {
      list.emplace_back(flutter::EncodableValue(valueTmp.asInt64()));
    } else if (valueTmp.isUInt()) {
      list.emplace_back(flutter::EncodableValue(valueTmp.asInt64()));
    } else if (valueTmp.isUInt64()) {
      list.emplace_back(flutter::EncodableValue(valueTmp.asInt64()));
    } else if (valueTmp.isDouble()) {
      list.emplace_back(flutter::EncodableValue(valueTmp.asDouble()));
    } else if (valueTmp.isString()) {
      list.emplace_back(flutter::EncodableValue(valueTmp.asString()));
    } else if (valueTmp.isArray()) {
      flutter::EncodableList listTmp;
      if (!convertJson2List(listTmp, valueTmp)) {
        return false;
      }
      list.emplace_back(listTmp);
    } else if (valueTmp.isObject()) {
      flutter::EncodableMap mapTmp;
      if (!convertJson2Map(mapTmp, valueTmp)) {
        return false;
      }
      list.emplace_back(mapTmp);
    } else {
      YXLOG(Warn) << "parse failed, valueTmp type: " << valueTmp.type()
                  << YXLOGEnd;
      return false;
    }
  }

  return true;
}

bool Convert::convertIMMessage2Map(flutter::EncodableMap& arguments,
                                   const nim::IMMessage& imMessage,
                                   bool fromCloud) {
  if (BS_NOT_INIT != imMessage.msg_setting_.resend_flag_) {
    arguments[flutter::EncodableValue("resend")] =
        BS_TRUE == imMessage.msg_setting_.resend_flag_;
  }

  bool bFind = false;
  for (auto& it : m_sessionType) {
    if (it.second == imMessage.session_type_) {
      arguments[flutter::EncodableValue("sessionType")] = it.first;
      bFind = true;
      break;
    }
  }
  if (!bFind) {
    YXLOG(Warn) << "parse failed, sessionType: " << imMessage.session_type_
                << YXLOGEnd;
    return false;
  }

  bFind = false;
  for (auto& it : m_messageType) {
    if (it.second == imMessage.type_) {
      arguments[flutter::EncodableValue("messageType")] = it.first;
      bFind = true;
      break;
    }
  }
  if (!bFind) {
    YXLOG(Warn) << "parse failed, messageType: " << imMessage.type_ << YXLOGEnd;
    return false;
  }

  arguments[flutter::EncodableValue("messageSubType")] = imMessage.sub_type_;

  bFind = false;
  for (auto& it : m_status) {
    if (it.second == imMessage.status_) {
      arguments[flutter::EncodableValue("status")] = it.first;
      arguments[flutter::EncodableValue("isRemoteRead")] = false;
      bFind = true;
      break;
    }
  }
  if (!bFind) {
    if (nim::kNIMMsgLogStatusReceipt == imMessage.status_) {
      arguments[flutter::EncodableValue("status")] = "read";
      arguments[flutter::EncodableValue("isRemoteRead")] = true;
    } else if (fromCloud) {
      arguments[flutter::EncodableValue("status")] = "success";
    } else {
      YXLOG(Warn) << "parse failed, status: " << imMessage.status_ << YXLOGEnd;
    }
  }

  if (imMessage.sender_accid_ == NimCore::getInstance()->getAccountId()) {
    arguments[flutter::EncodableValue("messageDirection")] =
        m_messageDirection["outgoing"];
  } else {
    arguments[flutter::EncodableValue("messageDirection")] =
        m_messageDirection["received"];
  }

  if (imMessage.session_type_ == nim::kNIMSessionTypeP2P ||
      imMessage.local_talk_id_.empty()) {
    if (imMessage.sender_accid_ == NimCore::getInstance()->getAccountId()) {
      arguments[flutter::EncodableValue("sessionId")] =
          imMessage.receiver_accid_;
    } else {
      arguments[flutter::EncodableValue("sessionId")] = imMessage.sender_accid_;
    }
  } else {
    arguments[flutter::EncodableValue("sessionId")] = imMessage.local_talk_id_;
  }

  arguments[flutter::EncodableValue("fromAccount")] = imMessage.sender_accid_;
  arguments[flutter::EncodableValue("fromNickname")] =
      imMessage.readonly_sender_nickname_.empty()
          ? ""
          : imMessage.readonly_sender_nickname_;
  arguments[flutter::EncodableValue("content")] = imMessage.content_;
  arguments[flutter::EncodableValue("timestamp")] = imMessage.timetag_;

  flutter::EncodableMap messageAttachment;
  if (!convertIMAttach2Map(imMessage, messageAttachment)) {
    return false;
  }
  arguments[flutter::EncodableValue("messageAttachment")] = messageAttachment;

  // wjzh
  // arguments[flutter::EncodableValue("attachmentStatus")];

  arguments[flutter::EncodableValue("uuid")] = imMessage.client_msg_id_;
  arguments[flutter::EncodableValue("serverId")] =
      imMessage.readonly_server_id_;

  flutter::EncodableMap config;
  if (BS_NOT_INIT != imMessage.msg_setting_.server_history_saved_) {
    config[flutter::EncodableValue("enableHistory")] =
        BS_TRUE == imMessage.msg_setting_.server_history_saved_;
  } else {
    config[flutter::EncodableValue("enableHistory")] = true;
  }

  if (BS_NOT_INIT != imMessage.msg_setting_.need_offline_) {
    config[flutter::EncodableValue("enablePersist")] =
        BS_TRUE == imMessage.msg_setting_.need_offline_;
  } else {
    config[flutter::EncodableValue("enablePersist")] = true;
  }

  if (BS_NOT_INIT != imMessage.msg_setting_.need_push_) {
    config[flutter::EncodableValue("enablePush")] =
        BS_TRUE == imMessage.msg_setting_.need_push_;
  } else {
    config[flutter::EncodableValue("enablePush")] = true;
  }

  if (BS_NOT_INIT != imMessage.msg_setting_.push_need_prefix_) {
    config[flutter::EncodableValue("enablePushNick")] =
        BS_TRUE == imMessage.msg_setting_.push_need_prefix_;
  } else {
    config[flutter::EncodableValue("enablePushNick")] = true;
  }

  if (BS_NOT_INIT != imMessage.msg_setting_.roaming_) {
    config[flutter::EncodableValue("enableRoaming")] =
        BS_TRUE == imMessage.msg_setting_.roaming_;
  } else {
    config[flutter::EncodableValue("enableRoaming")] = true;
  }

  if (BS_NOT_INIT != imMessage.msg_setting_.routable_) {
    config[flutter::EncodableValue("enableRoute")] =
        BS_TRUE == imMessage.msg_setting_.routable_;
  } else {
    config[flutter::EncodableValue("enableRoute")] = true;
  }

  if (BS_NOT_INIT != imMessage.msg_setting_.self_sync_) {
    config[flutter::EncodableValue("enableSelfSync")] =
        BS_TRUE == imMessage.msg_setting_.self_sync_;
  } else {
    config[flutter::EncodableValue("enableSelfSync")] = true;
  }

  if (BS_NOT_INIT != imMessage.msg_setting_.push_need_badge_) {
    config[flutter::EncodableValue("enableUnreadCount")] =
        BS_TRUE == imMessage.msg_setting_.push_need_badge_;
  } else {
    config[flutter::EncodableValue("enableUnreadCount")] = true;
  }

  if (!config.empty()) {
    arguments[flutter::EncodableValue("config")] = config;
  }

  if (!imMessage.msg_setting_.server_ext_.isNull()) {
    flutter::EncodableMap mapTmp;
    if (!convertJson2Map(mapTmp, imMessage.msg_setting_.server_ext_)) {
      // wjzh
    } else {
      arguments[flutter::EncodableValue("remoteExtension")] = mapTmp;
    }
  }

  if (!imMessage.msg_setting_.local_ext_.empty()) {
    flutter::EncodableMap mapTmp;
    nim_cpp_wrapper_util::Json::Value value =
        getJsonValueFromJsonString(imMessage.msg_setting_.local_ext_);
    if (!convertJson2Map(mapTmp, value)) {
      // wjzh
    } else {
      arguments[flutter::EncodableValue("localExtension")] = mapTmp;
    }
  }

  arguments[flutter::EncodableValue("callbackExtension")] =
      imMessage.third_party_callback_ext_;

  if (!imMessage.msg_setting_.push_payload_.isNull()) {
    flutter::EncodableMap mapTmp;
    if (!convertJson2Map(mapTmp, imMessage.msg_setting_.push_payload_)) {
      // wjzh
    } else {
      arguments[flutter::EncodableValue("pushPayload")] = mapTmp;
    }
  }

  arguments[flutter::EncodableValue("pushContent")] =
      imMessage.msg_setting_.push_content_;

  flutter::EncodableMap memberPushOption;
  memberPushOption[flutter::EncodableValue("forcePushContent")] =
      imMessage.msg_setting_.force_push_content_;
  if (BS_NOT_INIT != imMessage.msg_setting_.is_force_push_) {
    memberPushOption[flutter::EncodableValue("isForcePush")] =
        BS_TRUE == imMessage.msg_setting_.is_force_push_;
  }

  flutter::EncodableList forcePushList;
  for (auto& it : imMessage.msg_setting_.force_push_ids_list_) {
    forcePushList.emplace_back(it);
  }
  memberPushOption[flutter::EncodableValue("forcePushList")] = forcePushList;
  arguments[flutter::EncodableValue("memberPushOption")] = memberPushOption;

  for (auto& it : m_clientType) {
    if (it.second == imMessage.readonly_sender_client_type_) {
      arguments[flutter::EncodableValue("senderClientType")] = it.first;
      break;
    }
  }
  if (arguments[flutter::EncodableValue("senderClientType")] ==
          flutter::EncodableValue("") ||
      arguments[flutter::EncodableValue("senderClientType")] ==
          flutter::EncodableValue("unknown")) {
#if defined(_WIN32)
    arguments[flutter::EncodableValue("senderClientType")] = "windows";
#else
    arguments[flutter::EncodableValue("senderClientType")] = "macos";
#endif
  }

  flutter::EncodableMap antiSpamOption;
  if (BS_NOT_INIT != imMessage.msg_setting_.anti_spam_enable_) {
    antiSpamOption[flutter::EncodableValue("enable")] =
        BS_TRUE == imMessage.msg_setting_.anti_spam_enable_;
  }
  antiSpamOption[flutter::EncodableValue("content")] =
      imMessage.msg_setting_.anti_spam_content_;
  antiSpamOption[flutter::EncodableValue("antiSpamConfigId")] =
      imMessage.msg_setting_.anti_apam_biz_id_;
  arguments[flutter::EncodableValue("antiSpamOption")] = antiSpamOption;

  if (BS_NOT_INIT != imMessage.msg_setting_.team_msg_need_ack_) {
    arguments[flutter::EncodableValue("messageAck")] =
        BS_TRUE == imMessage.msg_setting_.team_msg_need_ack_;
  }
  if (BS_NOT_INIT != imMessage.msg_setting_.team_msg_ack_sent_) {
    arguments[flutter::EncodableValue("hasSendAck")] =
        BS_TRUE == imMessage.msg_setting_.team_msg_ack_sent_;
  }
  if (BS_NOT_INIT != imMessage.msg_setting_.client_anti_spam_hitting_) {
    arguments[flutter::EncodableValue("clientAntiSpam")] =
        BS_TRUE == imMessage.msg_setting_.client_anti_spam_hitting_;
  }
  if (BS_NOT_INIT != imMessage.msg_setting_.is_update_session_) {
    arguments[flutter::EncodableValue("sessionUpdate")] =
        BS_TRUE == imMessage.msg_setting_.is_update_session_;
  }

  // wjzh
  // arguments[flutter::EncodableValue("ackCount")];

  arguments[flutter::EncodableValue("unAckCount")] =
      imMessage.msg_setting_.team_msg_unread_count_;

  // wjzh
  // arguments[flutter::EncodableValue("isInBlackList")];
  // wjzh
  // arguments[flutter::EncodableValue("isChecked")];

  flutter::EncodableMap messageThreadOption;
  messageThreadOption[flutter::EncodableValue("replyMessageFromAccount")] =
      imMessage.thread_info_.reply_msg_from_account_;
  messageThreadOption[flutter::EncodableValue("replyMessageToAccount")] =
      imMessage.thread_info_.reply_msg_to_account_;
  messageThreadOption[flutter::EncodableValue("replyMessageTime")] =
      (int64_t)imMessage.thread_info_.reply_msg_time_;
  messageThreadOption[flutter::EncodableValue("replyMessageIdServer")] =
      (int64_t)imMessage.thread_info_.reply_msg_id_server_;
  messageThreadOption[flutter::EncodableValue("replyMessageIdClient")] =
      imMessage.thread_info_.reply_msg_id_client_;
  messageThreadOption[flutter::EncodableValue("threadMessageFromAccount")] =
      imMessage.thread_info_.thread_msg_from_account_;
  messageThreadOption[flutter::EncodableValue("threadMessageToAccount")] =
      imMessage.thread_info_.thread_msg_to_account_;
  messageThreadOption[flutter::EncodableValue("threadMessageTime")] =
      (int64_t)imMessage.thread_info_.thread_msg_time_;
  messageThreadOption[flutter::EncodableValue("threadMessageIdServer")] =
      (int64_t)imMessage.thread_info_.thread_msg_id_server_;
  messageThreadOption[flutter::EncodableValue("threadMessageIdClient")] =
      imMessage.thread_info_.thread_msg_id_client_;
  arguments[flutter::EncodableValue("messageThreadOption")] =
      messageThreadOption;

  // wjzh
  // arguments[flutter::EncodableValue("quickCommentUpdateTime")];

  if (BS_NOT_INIT != imMessage.thread_info_.deleted_) {
    arguments[flutter::EncodableValue("isDeleted")] =
        BS_TRUE == imMessage.thread_info_.deleted_;
  }

  if (!imMessage.msg_setting_.yidun_anti_cheating_.empty()) {
    nim_cpp_wrapper_util::Json::Value values =
        getJsonValueFromJsonString(imMessage.msg_setting_.yidun_anti_cheating_);
    if (values.isObject()) {
      flutter::EncodableMap yidunAntiCheating;
      if (convertJson2Map(yidunAntiCheating, values)) {
        arguments[flutter::EncodableValue("yidunAntiCheating")] =
            yidunAntiCheating;
      }
    }
  }

  arguments[flutter::EncodableValue("env")] =
      imMessage.msg_setting_.env_config_;

  return true;
}

bool Convert::convertSessionType(const flutter::EncodableMap* arguments,
                                 nim::NIMSessionType& sessionType) const {
  sessionType = nim::kNIMSessionTypeP2P;
  auto sessionTypeIt = arguments->find(flutter::EncodableValue("sessionType"));
  if (sessionTypeIt == arguments->end() || sessionTypeIt->second.IsNull()) {
    YXLOG(Warn) << "parse failed, sessionType is not found." << YXLOGEnd;
    return false;
  }

  auto sessionTypeEx = std::get<std::string>(sessionTypeIt->second);
  if (auto it = m_sessionType.find(sessionTypeEx); it != m_sessionType.end()) {
    sessionType = it->second;
    return true;
  }

  YXLOG(Warn) << "convertSessionType parse failed, sessionType: "
              << sessionTypeEx << YXLOGEnd;
  return false;
}

std::string Convert::getStringFormMapForLog(
    const flutter::EncodableMap* arguments) const {
  if (!arguments) {
    return "";
  }

  flutter::EncodableMap arg = *arguments;
  if (auto itAppKey = arg.find(flutter::EncodableValue("appKey"));
      arg.end() != itAppKey) {
    itAppKey->second = "NOT print";
  }
  if (auto itToken = arg.find(flutter::EncodableValue("token"));
      arg.end() != itToken) {
    itToken->second = "NOT print";
  }
  nim_cpp_wrapper_util::Json::Value value;
  if (!convertMap2Json(&arg, value)) {
    return "";
  }

  return nim::GetJsonStringWithNoStyled(value);
}

std::string Convert::getStringFormListForLog(
    const flutter::EncodableList* arguments) const {
  if (!arguments) {
    return "";
  }

  flutter::EncodableList arg = *arguments;
  if (auto it =
          std::find(arg.begin(), arg.end(), flutter::EncodableValue("appKey"));
      arg.end() != it) {
    // wjzh
  }
  nim_cpp_wrapper_util::Json::Value value;
  if (!convertList2Json(&arg, value)) {
    return "";
  }

  return nim::GetJsonStringWithNoStyled(value);
}

nim_cpp_wrapper_util::Json::Value Convert::getJsonValueFromJsonString(
    const std::string& json_string) const {
  if (json_string.empty()) {
    return nim_cpp_wrapper_util::Json::Value();
  }

  nim_cpp_wrapper_util::Json::Value values;
  if (!nim::ParseJsonValue(json_string, values)) {
    YXLOG(Warn) << "getJsonValueFromJsonString parse failed, json_string: "
                << json_string << YXLOGEnd;
    return nim_cpp_wrapper_util::Json::Value();
  }

  return values;
}

bool Convert::convertPinMessageInfo2Map(
    const std::string& session, const nim::PinMessageInfo& pinMessageInfo,
    flutter::EncodableMap& arguments) {
  arguments.insert(std::make_pair("sessionId", session));
  std::string strSessionType = "p2p";
  if (!convertNIMEnumToDartString(
          static_cast<nim::NIMSessionType>(pinMessageInfo.to_type),
          m_sessionType, strSessionType)) {
    return false;
  }
  arguments.insert(std::make_pair("sessionType", strSessionType));
  arguments.insert(
      std::make_pair("messageFromAccount", pinMessageInfo.from_account));
  arguments.insert(
      std::make_pair("messageToAccount", pinMessageInfo.to_account));
  arguments.insert(std::make_pair("messageUuid", pinMessageInfo.client_id));
  arguments.insert(std::make_pair("messageId", ""));
  arguments.insert(std::make_pair("pinId", pinMessageInfo.id));
  arguments.insert(std::make_pair(
      "messageServerId", static_cast<int64_t>(pinMessageInfo.server_id)));
  arguments.insert(
      std::make_pair("pinOperatorAccount", pinMessageInfo.operator_account));
  arguments.insert(std::make_pair("pinExt", pinMessageInfo.ext));
  arguments.insert(std::make_pair(
      "pinCreateTime", static_cast<int64_t>(pinMessageInfo.create_time)));
  arguments.insert(std::make_pair(
      "pinUpdateTime", static_cast<int64_t>(pinMessageInfo.update_time)));
  return true;
}

bool Convert::convertQuickCommentInfo2Map(const nim::QuickCommentInfo& info,
                                          flutter::EncodableMap& commentMap) {
  commentMap.insert(std::make_pair("fromAccount", info.from_account));
  commentMap.insert(std::make_pair("replyType", info.reply_type));
  commentMap.insert(std::make_pair("time", static_cast<int64_t>(info.time)));
  commentMap.insert(std::make_pair("ext", info.ext));
  commentMap.insert(std::make_pair("needPush", info.need_push));
  commentMap.insert(std::make_pair("needBadge", info.need_badge));
  commentMap.insert(std::make_pair("pushTitle", info.push_title));
  commentMap.insert(std::make_pair("pushContent", info.push_content));
  // commentMap.insert(std::make_pair("pushPayload", commentInfo.push_payload));
  // todo
  return true;
}

bool Convert::convertMsgClientId2MsgKeyMap(const std::string& clientMsgId,
                                           flutter::EncodableMap& msgKeyMap) {
  msgKeyMap.insert(std::make_pair("sessionType", "p2p"));  // 不支持
  msgKeyMap.insert(std::make_pair("fromAccount", ""));     // 不支持
  msgKeyMap.insert(std::make_pair("toAccount", ""));       // 不支持
  msgKeyMap.insert(std::make_pair("time", 0));             // 不支持
  msgKeyMap.insert(std::make_pair("serverId", 0));         // 不支持
  msgKeyMap.insert(std::make_pair("uuid", clientMsgId));
  return true;
}

void Convert::getLogList(const std::string& strLog,
                         std::list<std::string>& listLog) const {
  listLog.clear();
  int num = 15 * 1024;        // 分割定长大小
  int len = strLog.length();  // 字符串长度
  int end = num;
  for (int start = 0; start < len;) {
    if (end > len)  // 针对最后一个分割串
    {
      listLog.emplace_back(
          strLog.substr(start, len - start));  // 最后一个字符串的原始部分
      break;
    }
    listLog.emplace_back(
        strLog.substr(start, num));  // 从0开始，分割num位字符串
    start = end;
    end = end + num;
  }
}
