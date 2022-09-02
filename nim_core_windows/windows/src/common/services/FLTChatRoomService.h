// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#ifndef FLTCHATROOMSERVICE_H
#define FLTCHATROOMSERVICE_H

#include "../FLTService.h"
#include "nim_chatroom_cpp_wrapper/nim_chatroom_sdk_cpp_wrapper.h"
#include "nim_chatroom_cpp_wrapper/nim_cpp_chatroom_api.h"

class FLTChatRoomService : public FLTService {
 public:
  FLTChatRoomService();
  virtual void onMethodCalled(
      const std::string& method, const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result)
      override;

 private:
  void enterChatroom(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void exitChatroom(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void createMessage(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void sendMessage(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void fetchMessageHistory(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void fetchChatroomInfo(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void updateChatroomInfo(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

  void fetchChatroomMembers(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void fetchChatroomMembersByAccount(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void updateChatroomMyMemberInfo(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void markChatroomMemberInBlackList(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void markChatroomMemberBeManager(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void markChatroomMemberMuted(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void markChatroomMemberBeNormal(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void kickChatroomMember(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void markChatroomMemberTempMuted(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

  void fetchChatroomQueue(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void updateChatroomQueueEntry(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void batchUpdateChatroomQueue(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void pollChatroomQueueEntry(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void clearChatroomQueue(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

 private:
  void enterCallback(int64_t room_id,
                     const nim_chatroom::NIMChatRoomEnterStep step,
                     int error_code, const nim_chatroom::ChatRoomInfo& info,
                     const nim_chatroom::ChatRoomMemberInfo& my_info);
  void exitCallback(int64_t room_id, int error_code,
                    const nim_chatroom::NIMChatRoomExitReasonInfo& exit_info);
  void receiveMsgCallback(int64_t room_id,
                          const nim_chatroom::ChatRoomMessage& result);
  void sendMsgAckCallback(int64_t room_id, int error_code,
                          const nim_chatroom::ChatRoomMessage& result);
  void linkConditionCallback(
      int64_t room_id, const nim_chatroom::NIMChatRoomLinkCondition& condition);
  void notificationCallback(
      int64_t room_id, const nim_chatroom::ChatRoomNotification& notification);

 private:
  bool checkChatRoomInit();
  flutter::EncodableMap convertChatRoomMemberInfoToMap(
      const nim_chatroom::ChatRoomMemberInfo& my_info);
  void setMemberAttributeOnlineAsync(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result,
      nim_chatroom::NIMChatRoomMemberAttribute attribute);
  bool convertDartMessageToNimMessage(nim_chatroom::ChatRoomMessage& message,
                                      const flutter::EncodableMap* arguments);
  void convertNimMessageToDartMessage(
      const nim_chatroom::ChatRoomMessage& message,
      flutter::EncodableMap& arguments);

 private:
  bool m_init = false;
  std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> m_enterResult;
  std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> m_exitResult;
  std::unordered_map<std::string, FLTService::MethodResult> m_sendMsgResultMap;
  int64_t m_roomId = 0;
};

#endif  // FLTCHATROOMSERVICE_H
