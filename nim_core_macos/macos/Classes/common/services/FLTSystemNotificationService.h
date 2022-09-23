// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#ifndef FLTSYSTEMNOTIFICATIONSERVICE_H
#define FLTSYSTEMNOTIFICATIONSERVICE_H

#include "../FLTService.h"

class FLTSystemNotificationService : public FLTService {
 public:
  FLTSystemNotificationService();
  virtual ~FLTSystemNotificationService();
  virtual void onMethodCalled(
      const std::string& method, const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result)
      override;

 private:
  void querySystemMessagesIOSAndDesktop(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void querySystemMessageByTypeIOSAndDesktop(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void querySystemMessageUnreadCount(
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void setSystemMessageRead(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void setSystemMessageStatus(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void resetSystemMessageUnreadCount(
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void deleteSystemMessage(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void clearSystemMessages(
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void clearSystemMessagesByType(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void sendCustomNotification(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

 private:
  void sendCustomSysmsgCallback(const nim::SendMessageArc& arc);
  void receiveSysmsgCallback(const nim::SysMessage& msg);

 private:
  std::string convertSysMsgTypeToString(nim::NIMSysMsgType type);
  nim::NIMSysMsgType convertStringToSysMsgType(const std::string& value);
  std::string convertSysMsgStatusToString(nim::NIMSysMsgStatus type);
  nim::NIMSysMsgStatus convertStringToSysMsgStatus(const std::string& value);
};

#endif  // FLTSYSTEMNOTIFICATIONSERVICE_H