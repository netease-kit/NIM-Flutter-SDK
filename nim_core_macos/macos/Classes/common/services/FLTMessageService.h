// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#ifndef FLTMESSAGESERVICE_H
#define FLTMESSAGESERVICE_H

#include "../FLTService.h"

class FLTMessageService : public FLTService {
 public:
  FLTMessageService();
  virtual ~FLTMessageService();
  virtual void onMethodCalled(
      const std::string& method, const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result)
      override;

 private:
  void sendMessage(const flutter::EncodableMap* arguments,
                   FLTService::MethodResult result);
  void sendMessageReceipt(const flutter::EncodableMap* arguments,
                          FLTService::MethodResult result);
  void sendTeamMessageReceipt(const flutter::EncodableMap* arguments,
                              FLTService::MethodResult result);
  void refreshTeamMessageReceipt(const flutter::EncodableMap* arguments,
                                 FLTService::MethodResult result);
  void fetchTeamMessageReceiptDetail(const flutter::EncodableMap* arguments,
                                     FLTService::MethodResult result);
  void queryTeamMessageReceiptDetail(const flutter::EncodableMap* arguments,
                                     FLTService::MethodResult result);
  void saveMessage(const flutter::EncodableMap* arguments,
                   FLTService::MethodResult result);
  void updateMessage(const flutter::EncodableMap* arguments,
                     FLTService::MethodResult result);
  void forwardMessage(const flutter::EncodableMap* arguments,
                      FLTService::MethodResult result);
  void voiceToText(const flutter::EncodableMap* arguments,
                   FLTService::MethodResult result);
  void createMessage(const flutter::EncodableMap* arguments,
                     FLTService::MethodResult result);
  void queryMessageList(const flutter::EncodableMap* arguments,
                        FLTService::MethodResult result);
  void queryMessageListEx(const flutter::EncodableMap* arguments,
                          FLTService::MethodResult result);
  void queryLastMessage(const flutter::EncodableMap* arguments,
                        FLTService::MethodResult result);
  void queryMessageListByUuid(const flutter::EncodableMap* arguments,
                              FLTService::MethodResult result);
  void deleteChattingHistory(const flutter::EncodableMap* arguments,
                             FLTService::MethodResult result);
  void deleteChattingHistoryList(const flutter::EncodableMap* arguments,
                                 FLTService::MethodResult result);
  void clearChattingHistory(const flutter::EncodableMap* arguments,
                            FLTService::MethodResult result);
  void clearMsgDatabase(const flutter::EncodableMap* arguments,
                        FLTService::MethodResult result);
  void pullMessageHistoryExType(const flutter::EncodableMap* arguments,
                                FLTService::MethodResult result);
  void pullMessageHistory(const flutter::EncodableMap* arguments,
                          FLTService::MethodResult result);
  void clearServerHistory(const flutter::EncodableMap* arguments,
                          FLTService::MethodResult result);
  void deleteMsgSelf(const flutter::EncodableMap* arguments,
                     FLTService::MethodResult result);
  void deleteMsgListSelf(const flutter::EncodableMap* arguments,
                         FLTService::MethodResult result);
  void searchMessage(const flutter::EncodableMap* arguments,
                     FLTService::MethodResult result);
  void searchAllMessage(const flutter::EncodableMap* arguments,
                        FLTService::MethodResult result);
  void searchRoamingMsg(const flutter::EncodableMap* arguments,
                        FLTService::MethodResult result);
  void searchCloudMessageHistory(const flutter::EncodableMap* arguments,
                                 FLTService::MethodResult result);
  void downloadAttachment(const flutter::EncodableMap* arguments,
                          FLTService::MethodResult result);
  void cancelUploadAttachment(const flutter::EncodableMap* arguments,
                              FLTService::MethodResult result);
  void revokeMessage(const flutter::EncodableMap* arguments,
                     FLTService::MethodResult result);
  void replyMessage(const flutter::EncodableMap* arguments,
                    FLTService::MethodResult result);
  void queryReplyCountInThreadTalkBlock(const flutter::EncodableMap* arguments,
                                        FLTService::MethodResult result);
  void queryThreadTalkHistory(const flutter::EncodableMap* arguments,
                              FLTService::MethodResult result);
  void clearAllSessionUnreadCount(const flutter::EncodableMap* arguments,
                                  FLTService::MethodResult result);

  // session
  DECLARE_FUN(querySessionList);
  DECLARE_FUN(querySessionListFiltered);
  DECLARE_FUN(querySession);
  DECLARE_FUN(createSession);
  DECLARE_FUN(updateSession);
  DECLARE_FUN(updateSessionWithMessage);
  DECLARE_FUN(queryTotalUnreadCount);
  DECLARE_FUN(setChattingAccount);
  DECLARE_FUN(clearSessionUnreadCount);
  DECLARE_FUN(deleteSession);
  DECLARE_FUN(checkLocalAntiSpam);

  // server session
  DECLARE_FUN(queryMySessionList);
  DECLARE_FUN(queryMySession);
  DECLARE_FUN(updateMySession);
  DECLARE_FUN(deleteMySession);

  // 快捷评论
  DECLARE_FUN(addQuickComment);
  DECLARE_FUN(removeQuickComment);
  DECLARE_FUN(queryQuickComment);

  // 收藏
  DECLARE_FUN(addCollect);
  DECLARE_FUN(removeCollect);
  DECLARE_FUN(updateCollect);
  DECLARE_FUN(queryCollect);

  // Pin
  DECLARE_FUN(addMessagePin);
  DECLARE_FUN(updateMessagePin);
  DECLARE_FUN(removeMessagePin);
  DECLARE_FUN(queryMessagePinForSession);

  // StickTopSession
  DECLARE_FUN(addStickTopSession);
  DECLARE_FUN(removeStickTopSession);
  DECLARE_FUN(updateStickTopSession);
  DECLARE_FUN(queryStickTopSession);

 public:
  void TeamEventCB(const nim::TeamEvent& arc);

 private:
  void SendMessageCB(const nim::SendMessageArc& arc);
  void ReceiveCB(const nim::IMMessage& arc);
  void ReceiveMessagesCB(const std::list<nim::IMMessage>& arc);
  void ReceiveBroadcastMsgCB(const nim::BroadcastMessage& arc);
  void RecallMsgsCB(const nim::NIMResCode,
                    const std::list<nim::RecallMsgNotify>& arc);
  void MessageStatusChangedCB(const nim::MessageStatusChangedResult& arc);
  void ChangeCB(nim::NIMResCode, const nim::SessionData& arc, int);
  void SendMessageAttachmentProgress(const std::string& client_msg_id,
                                     int64_t completed_size, int64_t file_size);
  void SessionChangedCB(const nim::SessionOnLineServiceHelper::SessionInfo&);
  void AddPinMessageNotifyCB(const std::string& session, int to_type,
                             const nim::PinMessageInfo& pin);
  void UnPinMessageNotifyCB(const std::string& session, int to_type,
                            const std::string& id);
  void UpdatePinMessageNotifyCB(const std::string& session, int to_type,
                                const nim::PinMessageInfo& pin);
  void AddQuickCommentNotifyCB(const std::string& session,
                               nim::NIMSessionType type,
                               const std::string& msg_client_id,
                               const nim::QuickCommentInfo& info);
  void RemoveQuickCommentNotifyCB(const std::string& session,
                                  nim::NIMSessionType type,
                                  const std::string& msg_client_id,
                                  const std::string& quick_comment_id,
                                  const std::string& ext);
  void SetToStickTopSessionNotifyCB(const nim::StickTopSession&);
  void CancelStickTopSessionNotifyCB(const std::string& session_id,
                                     nim::NIMSessionType);
  void UpdateStickTopSessionNotifyCB(const nim::StickTopSession&);

 private:
  typedef struct tagSendMsgResult {
    nim::Talk::FileUpPrgCallback* pFileUpPrgCallback = nullptr;
    FLTService::MethodResult methodResult = nullptr;
    nim::IMMessage imMessage;
  } SendMsgResult;

 private:
  std::map<std::string, tagSendMsgResult> m_mapSendMsgResult;
  std::recursive_mutex m_mutexSendMsgResult;
};

#endif  // FLTMESSAGESERVICE_H
