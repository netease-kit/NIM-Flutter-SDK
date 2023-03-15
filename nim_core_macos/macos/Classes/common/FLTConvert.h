// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#ifndef FLTCONVERT_H
#define FLTCONVERT_H

#include <string>
#include <unordered_map>

#include "FLTService.h"
#include "utils/singleton.h"

class Convert {
 public:
  SINGLETONG(Convert)
  using MessageType = std::unordered_map<std::string, nim::NIMMessageType>;
  using SessionType = std::unordered_map<std::string, nim::NIMSessionType>;
  using Status = std::unordered_map<std::string, nim::NIMMsgLogStatus>;
  using ClientType = std::unordered_map<std::string, nim::NIMClientType>;
  using NosScene = std::unordered_map<std::string, std::string>;
  using MessageDirection = std::unordered_map<std::string, int>;
  using SearchOrder = std::unordered_map<int, nim::NIMFullTextSearchRule>;
  using CacheFileType = std::unordered_map<std::string, std::string>;

  const std::string getUUID();
  const MessageType& getMessageType() const;
  const SessionType& getSessionType() const;
  const Status& getStatus() const;
  const ClientType& getClientType() const;
  const NosScene& getNosScene() const;
  const MessageDirection& getMessageDirection() const;
  const SearchOrder& getSearchOrder() const;

  bool findCacheFileType(const std::string& fileType,
                         std::string& cacheFileType) const;

  const std::unordered_map<std::string, nim::NIMSysMsgType>& getSysMsgType()
      const;
  const std::unordered_map<std::string, nim::NIMSysMsgStatus>& getsysMsgStatus()
      const;
  const std::unordered_map<std::string, int>& getGenderType() const;
#if defined(_WIN32)
  const std::unordered_map<std::string, nim_audio::nim_audio_type>&
  getAudioOutputFormat() const;
#endif
  const std::unordered_map<std::string, nim_chatroom::NIMChatRoomGetMemberType>&
  getChatroomMemberQueryType() const;
  const std::unordered_map<std::string, int>& getChatroomMemberType() const;
  const std::unordered_map<std::string, int>&
  getChatroomQueueModificationLevel() const;
  const std::unordered_map<std::string, nim::NIMTeamJoinMode>& getTeamJoinMode()
      const;
  const std::unordered_map<std::string, nim::NIMTeamInviteMode>&
  getTeamInviteMode() const;
  const std::unordered_map<std::string, nim::NIMTeamBeInviteMode>&
  getTeamBeInviteMode() const;
  const std::unordered_map<std::string, nim::NIMTeamUpdateInfoMode>&
  getTeamUpdateInfoMode() const;
  const std::unordered_map<std::string, nim::NIMTeamUpdateCustomMode>&
  getTeamUpdateCustomMode() const;
  const std::unordered_map<std::string, nim::NIMTeamType>& getTeamType() const;
  const std::unordered_map<std::string, nim::NIMTeamMuteType>& getTeamMuteType()
      const;
  const std::unordered_map<std::string, nim::NIMTeamUserType>&
  getTeamMemberType() const;

  bool convert2IMMessage(const flutter::EncodableMap* arguments,
                         nim::IMMessage& imMessage, std::string& imMessageJson);
  bool convertIMMessage2Map(flutter::EncodableMap& arguments,
                            const nim::IMMessage& imMessage,
                            bool fromCloud = false);

  bool convert2IMAttach(const nim::IMMessage& imMessage,
                        const flutter::EncodableMap* arguments,
                        std::string& imMessageJson);
  bool convertIMAttach2Map(const nim::IMMessage& imMessage,
                           flutter::EncodableMap& arguments);

  bool convertIMSessionData2Map(const nim::SessionData& sessionData,
                                flutter::EncodableMap& arguments);
  bool convertIMSessionInfo2Map(
      const nim::SessionOnLineServiceHelper::SessionInfo& sessionInfo,
      flutter::EncodableMap& arguments);
  bool convertIMRecallMsgNotify2Map(const nim::RecallMsgNotify& recallMsgNotify,
                                    flutter::EncodableMap& arguments);
  bool convertIMStickTopSessionInfo2Map(
      const nim::StickTopSessionInfo& stickTopSessionInfo,
      flutter::EncodableMap& arguments);

  bool convertSessionType(const flutter::EncodableMap* arguments,
                          nim::NIMSessionType& sessionType) const;

  bool convertList2Json(const flutter::EncodableList* arguments,
                        nim_cpp_wrapper_util::Json::Value& value) const;
  bool convertJson2List(flutter::EncodableList& list,
                        const nim_cpp_wrapper_util::Json::Value& values) const;
  bool convertMap2Json(const flutter::EncodableMap* arguments,
                       nim_cpp_wrapper_util::Json::Value& value) const;
  bool convertJson2Map(flutter::EncodableMap& map,
                       const nim_cpp_wrapper_util::Json::Value& values) const;

  std::string getStringFormMapForLog(
      const flutter::EncodableMap* arguments) const;
  std::string getStringFormListForLog(
      const flutter::EncodableList* arguments) const;
  nim_cpp_wrapper_util::Json::Value getJsonValueFromJsonString(
      const std::string& json_string) const;
  void getLogList(const std::string& strLog,
                  std::list<std::string>& listLog) const;

  bool convertPinMessageInfo2Map(const std::string& session,
                                 const nim::PinMessageInfo& pinMessageInfo,
                                 flutter::EncodableMap& arguments);
  bool convertQuickCommentInfo2Map(const nim::QuickCommentInfo& info,
                                   flutter::EncodableMap& commentMap);
  bool convertMsgClientId2MsgKeyMap(const std::string& clientMsgId,
                                    flutter::EncodableMap& msgKeyMap);

 public:
  template <typename TEnum, typename TMap>
  bool convertNIMEnumToDartString(TEnum enumValue, TMap map,
                                  std::string& strValue) const {
    auto iter =
        std::find_if(map.begin(), map.end(),
                     [enumValue](const typename TMap::value_type& pair) {
                       return pair.second == enumValue;
                     });

    if (iter != map.end()) {
      strValue = iter->first;
      return true;
    }
    return false;
  }

  template <typename TEnum, typename TMap>
  bool convertDartStringToNIMEnum(const std::string& strValue, TMap map,
                                  TEnum& enumValue) const {
    auto iter = map.find(strValue);
    if (iter != map.end()) {
      enumValue = iter->second;
      return true;
    }
    return false;
  }

  template <typename Type>
  bool convertDartListToStd(Type& std,
                            const flutter::EncodableList* arguments) const {
    std.clear();
    if (!arguments) {
      return true;
    }

    nim_cpp_wrapper_util::Json::Value values;
    if (!convertList2Json(arguments, values)) {
      return false;
    }
    if (!values.isArray()) {
      return false;
    }

    for (auto& it : values) {
      std.emplace_back(it.as<typename Type::value_type>());
    }

    return true;
  }

 private:
  Convert();
  bool convertMap2ImFile(const flutter::EncodableMap* arguments,
                         nim::IMFile& imFile, std::string& strPath);
  bool convertImFile2Map(flutter::EncodableMap& arguments,
                         const nim::IMFile& imFile, const std::string& strPath,
                         const std::string& strMsgType);

 private:
  MessageType m_messageType;
  SessionType m_sessionType;
  Status m_status;
  ClientType m_clientType;
  NosScene m_nosScene;
  MessageDirection m_messageDirection;
  SearchOrder m_searchOrder;
  CacheFileType m_cacheFileType;
  std::unordered_map<std::string, nim::NIMSysMsgType> m_sysMsgType;
  std::unordered_map<std::string, nim::NIMSysMsgStatus> m_sysMsgStatus;
  std::unordered_map<std::string, int> m_genderType;
#if defined(_WIN32)
  std::unordered_map<std::string, nim_audio::nim_audio_type>
      m_audioOutputFormat;
#endif
  std::unordered_map<std::string, nim_chatroom::NIMChatRoomGetMemberType>
      m_chatroomMemberQueryType;
  std::unordered_map<std::string, int> m_chatroomQueueModificationLevel;
  std::unordered_map<std::string, int> m_chatroomMemberType;
  std::unordered_map<std::string, nim::NIMTeamJoinMode> m_teamJoinMode;
  std::unordered_map<std::string, nim::NIMTeamInviteMode> m_teamInviteMode;
  std::unordered_map<std::string, nim::NIMTeamBeInviteMode> m_teamBeInviteMode;
  std::unordered_map<std::string, nim::NIMTeamUpdateInfoMode>
      m_teamUpdateInfoMode;
  std::unordered_map<std::string, nim::NIMTeamUpdateCustomMode>
      m_teamUpdateCustomMode;
  std::unordered_map<std::string, nim::NIMTeamType> m_teamType;
  std::unordered_map<std::string, nim::NIMTeamMuteType> m_teamMuteType;
  std::unordered_map<std::string, nim::NIMTeamUserType> m_teamMemberType;
};

#endif  // FLTCONVERT_H
