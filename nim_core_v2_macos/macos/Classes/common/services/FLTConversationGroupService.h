// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#ifndef FLTCONVERSATIONGROUPSERVICE_H
#define FLTCONVERSATIONGROUPSERVICE_H

#include "../FLTService.h"
#include "v2_nim_api.hpp"

class FLTConversationGroupService : public FLTService {
 public:
  explicit FLTConversationGroupService(bool enableCloudConversation);
  virtual ~FLTConversationGroupService();

  virtual void onMethodCalled(
      const std::string& method, const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result)
      override;

 private:
  void createConversationGroup(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void deleteConversationGroup(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void updateConversationGroup(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void addConversationsToGroup(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void removeConversationsFromGroup(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void getConversationGroup(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void getConversationGroupList(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void getConversationGroupListByIds(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

 private:
  bool m_enableCloudConversation;
  v2::V2NIMConversationGroupListener conversationGroupListener;
};

#endif  // FLTCONVERSATIONGROUPSERVICE_H
