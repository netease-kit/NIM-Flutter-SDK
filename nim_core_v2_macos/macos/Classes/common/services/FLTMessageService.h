// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#ifndef FLTMessageService_H
#define FLTMessageService_H

#include "../FLTService.h"
#include "v2_nim_api.hpp"
#include "v2_nim_def_struct.hpp"
#include "v2_nim_message_service.hpp"
#include "v2_nim_notification_service.hpp"

flutter::EncodableMap convertMessageRefer(
    const nstd::optional<v2::V2NIMMessageRefer> object);
flutter::EncodableMap convertMessage(
    const nstd::optional<v2::V2NIMMessage> object);
flutter::EncodableMap convertMessageStatus(const v2::V2NIMMessageStatus object);
flutter::EncodableMap convertMessageAIConfig(
    const nstd::optional<v2::V2NIMMessageAIConfig> object);
flutter::EncodableMap convertMessageRobotConfig(
    const v2::V2NIMMessageRobotConfig object);
flutter::EncodableMap convertMessageAntispamConfig(
    const v2::V2NIMMessageAntispamConfig object);
flutter::EncodableMap convertMessageRouteConfig(
    const v2::V2NIMMessageRouteConfig object);
flutter::EncodableMap convertMessagePushConfig(
    const v2::V2NIMMessagePushConfig object);
flutter::EncodableMap convertMessageConfig(const v2::V2NIMMessageConfig object);
flutter::EncodableMap convertMessageAttachment(
    const nstd::shared_ptr<v2::V2NIMMessageAttachment> object);
flutter::EncodableMap convertMessageFileAttachment(
    const nstd::shared_ptr<v2::V2NIMMessageFileAttachment> object);
flutter::EncodableMap convertMessageImageAttachment(
    const nstd::shared_ptr<v2::V2NIMMessageImageAttachment> object);
flutter::EncodableMap convertMessageAudioAttachment(
    const nstd::shared_ptr<v2::V2NIMMessageAudioAttachment> object);
flutter::EncodableMap convertMessageVideoAttachment(
    const nstd::shared_ptr<v2::V2NIMMessageVideoAttachment> object);
flutter::EncodableMap convertMessageLocationAttachment(
    const nstd::shared_ptr<v2::V2NIMMessageLocationAttachment> object);
flutter::EncodableMap convertMessageNotificationAttachment(
    const nstd::shared_ptr<v2::V2NIMMessageTeamNotificationAttachment> object);
flutter::EncodableMap convertMessageCallDuration(
    const v2::V2NIMMessageCallDuration object);
flutter::EncodableMap convertMessageCallAttachment(
    const nstd::shared_ptr<v2::V2NIMMessageCallAttachment> object);
flutter::EncodableMap convertMessageAIConfigParams(
    const nstd::optional<v2::V2NIMMessageAIConfigParams> object);
flutter::EncodableMap convertAIModelCallContent(
    const v2::V2NIMAIModelCallContent object);
flutter::EncodableMap convertAIModelCallMessage(
    const v2::V2NIMAIModelCallMessage object);
flutter::EncodableMap convertAIModelConfigParams(
    const v2::V2NIMAIModelConfigParams object);
flutter::EncodableMap convertSendMessageParams(
    const v2::V2NIMSendMessageParams object);
flutter::EncodableMap convertSendMessageResult(
    const v2::V2NIMSendMessageResult object);
flutter::EncodableMap convertClientAntispamResult(
    const nstd::optional<v2::V2NIMClientAntispamResult> object);
flutter::EncodableMap convertMessageListOption(
    const v2::V2NIMMessageListOption object);
flutter::EncodableMap convertClearHistoryMessageOption(
    const v2::V2NIMClearHistoryMessageOption object);
flutter::EncodableMap convertMessageDeletedNotification(
    const v2::V2NIMMessageDeletedNotification object);
flutter::EncodableMap convertMessagePin(const v2::V2NIMMessagePin object);
flutter::EncodableMap convertMessagePinNotification(
    const v2::V2NIMMessagePinNotification object);
flutter::EncodableMap convertMessageQuickComment(
    const v2::V2NIMMessageQuickComment object);
flutter::EncodableMap convertMessageQuickCommentNotification(
    const v2::V2NIMMessageQuickCommentNotification object);
flutter::EncodableMap convertMessageQuickCommentPushConfig(
    const v2::V2NIMMessageQuickCommentPushConfig object);
flutter::EncodableMap convertMessageRevokeNotification(
    const v2::V2NIMMessageRevokeNotification object);
flutter::EncodableMap convertMessageRevokeParams(
    const v2::V2NIMMessageRevokeParams object);
flutter::EncodableMap convertMessageSearchParams(
    const v2::V2NIMMessageSearchParams object);
flutter::EncodableMap convertNotificationAntispamConfig(
    const v2::V2NIMNotificationAntispamConfig object);
flutter::EncodableMap convertNotificationConfig(
    const v2::V2NIMNotificationConfig object);
flutter::EncodableMap convertNotificationPushConfig(
    const v2::V2NIMNotificationPushConfig object);
flutter::EncodableMap convertNotificationRouteConfig(
    const v2::V2NIMNotificationRouteConfig object);
flutter::EncodableMap convertP2PMessageReadReceipt(
    const v2::V2NIMP2PMessageReadReceipt object);
flutter::EncodableMap convertTeamMessageReadReceipt(
    const v2::V2NIMTeamMessageReadReceipt object);
flutter::EncodableMap convertTeamMessageReadReceiptDetail(
    const v2::V2NIMTeamMessageReadReceiptDetail object);
flutter::EncodableMap convertThreadMessageListOption(
    const v2::V2NIMTheadMessageListOption object);
flutter::EncodableMap convertThreadMessageListResult(
    const v2::V2NIMThreadMessageListResult object);
flutter::EncodableMap convertVoiceToTextParams(
    const v2::V2NIMVoiceToTextParams object);
flutter::EncodableMap convertCollection(
    const nstd::optional<v2::V2NIMCollection> object);
flutter::EncodableMap convertAddCollectionParams(
    const v2::V2NIMAddCollectionParams object);
flutter::EncodableMap convertCollectionOption(
    const v2::V2NIMCollectionOption object);
flutter::EncodableMap convertClearHistoryNotification(
    const v2::V2NIMClearHistoryNotification object);
flutter::EncodableMap convertUpdatedTeamInfo(
    const nstd::optional<v2::V2NIMUpdatedTeamInfo> object);

v2::V2NIMMessageRefer getMessageRefer(const flutter::EncodableMap* arguments);
v2::V2NIMMessage getMessage(const flutter::EncodableMap* arguments);
v2::V2NIMMessageStatus getMessageStatus(const flutter::EncodableMap* arguments);
v2::V2NIMMessageAIConfig getMessageAIConfig(
    const flutter::EncodableMap* arguments);
v2::V2NIMMessageRobotConfig getMessageRobotConfig(
    const flutter::EncodableMap* arguments);
v2::V2NIMMessageAntispamConfig getMessageAntispamConfig(
    const flutter::EncodableMap* arguments);
v2::V2NIMMessageRouteConfig getMessageRouteConfig(
    const flutter::EncodableMap* arguments);
v2::V2NIMMessagePushConfig getMessagePushConfig(
    const flutter::EncodableMap* arguments);
v2::V2NIMMessageConfig getMessageConfig(const flutter::EncodableMap* arguments);
nstd::shared_ptr<v2::V2NIMMessageAttachment> getMessageAttachment(
    const flutter::EncodableMap* arguments);
nstd::shared_ptr<v2::V2NIMMessageFileAttachment> getMessageFileAttachment(
    const flutter::EncodableMap* arguments);
nstd::shared_ptr<v2::V2NIMMessageImageAttachment> getMessageImageAttachment(
    const flutter::EncodableMap* arguments);
nstd::shared_ptr<v2::V2NIMMessageAudioAttachment> getMessageAudioAttachment(
    const flutter::EncodableMap* arguments);
nstd::shared_ptr<v2::V2NIMMessageVideoAttachment> getMessageVideoAttachment(
    const flutter::EncodableMap* arguments);
nstd::shared_ptr<v2::V2NIMMessageLocationAttachment>
getMessageLocationAttachment(const flutter::EncodableMap* arguments);
nstd::shared_ptr<v2::V2NIMMessageTeamNotificationAttachment>
getMessageNotificationAttachment(const flutter::EncodableMap* arguments);
v2::V2NIMMessageCallDuration getMessageCallDuration(
    const flutter::EncodableMap* arguments);
nstd::shared_ptr<v2::V2NIMMessageCallAttachment> getMessageCallAttachment(
    const flutter::EncodableMap* arguments);
v2::V2NIMMessageAIConfigParams getMessageAIConfigParams(
    const flutter::EncodableMap* arguments);
v2::V2NIMAIModelCallContent getAIModelCallContent(
    const flutter::EncodableMap* arguments);
v2::V2NIMAIModelCallMessage getAIModelCallMessage(
    const flutter::EncodableMap* arguments);
v2::V2NIMAIModelConfigParams getAIModelConfigParams(
    const flutter::EncodableMap* arguments);
v2::V2NIMSendMessageParams getSendMessageParams(
    const flutter::EncodableMap* arguments);
v2::V2NIMSendMessageResult getSendMessageResult(
    const flutter::EncodableMap* arguments);
v2::V2NIMClientAntispamResult getClientAntispamResult(
    const flutter::EncodableMap* arguments);
v2::V2NIMMessageListOption getMessageListOption(
    const flutter::EncodableMap* arguments);
v2::V2NIMClearHistoryMessageOption getClearHistoryMessageOption(
    const flutter::EncodableMap* arguments);
v2::V2NIMMessageDeletedNotification getMessageDeletedNotification(
    const flutter::EncodableMap* arguments);
v2::V2NIMMessagePin getMessagePin(const flutter::EncodableMap* arguments);
v2::V2NIMMessagePinNotification getMessagePinNotification(
    const flutter::EncodableMap* arguments);
v2::V2NIMMessageQuickComment getMessageQuickComment(
    const flutter::EncodableMap* arguments);
v2::V2NIMMessageQuickCommentNotification getMessageQuickCommentNotification(
    const flutter::EncodableMap* arguments);
v2::V2NIMMessageQuickCommentPushConfig getMessageQuickCommentPushConfig(
    const flutter::EncodableMap* arguments);
v2::V2NIMMessageRevokeNotification getMessageRevokeNotification(
    const flutter::EncodableMap* arguments);
v2::V2NIMMessageRevokeParams getMessageRevokeParams(
    const flutter::EncodableMap* arguments);
v2::V2NIMMessageSearchParams getMessageSearchParams(
    const flutter::EncodableMap* arguments);
v2::V2NIMNotificationAntispamConfig getNotificationAntispamConfig(
    const flutter::EncodableMap* arguments);
v2::V2NIMNotificationConfig getNotificationConfig(
    const flutter::EncodableMap* arguments);
v2::V2NIMNotificationPushConfig getNotificationPushConfig(
    const flutter::EncodableMap* arguments);
v2::V2NIMNotificationRouteConfig getNotificationRouteConfig(
    const flutter::EncodableMap* arguments);
v2::V2NIMP2PMessageReadReceipt getP2PMessageReadReceipt(
    const flutter::EncodableMap* arguments);
v2::V2NIMTeamMessageReadReceipt getTeamMessageReadReceipt(
    const flutter::EncodableMap* arguments);
v2::V2NIMTeamMessageReadReceiptDetail getTeamMessageReadReceiptDetail(
    const flutter::EncodableMap* arguments);
v2::V2NIMTheadMessageListOption getThreadMessageListOption(
    const flutter::EncodableMap* arguments);
v2::V2NIMThreadMessageListResult getThreadMessageListResult(
    const flutter::EncodableMap* arguments);
v2::V2NIMVoiceToTextParams getVoiceToTextParams(
    const flutter::EncodableMap* arguments);
v2::V2NIMCollection getCollection(const flutter::EncodableMap* arguments);
v2::V2NIMAddCollectionParams getAddCollectionParams(
    const flutter::EncodableMap* arguments);
v2::V2NIMCollectionOption getCollectionOption(
    const flutter::EncodableMap* arguments);
v2::V2NIMClearHistoryNotification getClearHistoryNotification(
    const flutter::EncodableMap* arguments);
v2::V2NIMUpdatedTeamInfo getUpdatedTeamInfo(
    const flutter::EncodableMap* arguments);

class FLTMessageService : public FLTService {
 public:
  FLTMessageService();
  virtual ~FLTMessageService();
  virtual void onMethodCalled(
      const std::string& method, const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result)
      override;

 private:
  void sendMessage(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

  void replyMessage(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

  void revokeMessage(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

  void getMessageList(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

  void getMessageListByIds(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

  void getMessageListByRefers(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

  void deleteMessage(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

  void deleteMessages(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

  void clearHistoryMessage(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

  void updateMessageLocalExtension(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

  void insertMessageToLocal(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

  void pinMessage(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

  void unpinMessage(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

  void updatePinMessage(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

  void getPinnedMessageList(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

  void addQuickComment(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

  void removeQuickComment(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

  void getQuickCommentList(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

  void addCollection(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

  void removeCollections(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

  void updateCollectionExtension(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

  void getCollectionListByOption(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

  void sendP2PMessageReceipt(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

  void getP2PMessageReceipt(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

  void isPeerRead(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

  void sendTeamMessageReceipts(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

  void getTeamMessageReceipts(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

  void getTeamMessageReceiptDetail(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

  void voiceToText(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

  void cancelMessageAttachmentUpload(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

  void searchCloudMessages(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

  void getLocalThreadMessageList(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

  void getThreadMessageList(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

 private:
  v2::V2NIMMessageListener listener;
};

#endif  // FLTMessageService_H
