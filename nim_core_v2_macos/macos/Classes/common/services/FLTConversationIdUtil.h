// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#ifndef FLTConversationIdUtil_H
#define FLTConversationIdUtil_H

#include <stdio.h>

#include "../FLTService.h"
#include "v2_nim_def_enum.hpp"
#include "v2_nim_def_struct.hpp"

class FLTConversationIdUtil : public FLTService {
 public:
  FLTConversationIdUtil();
  virtual ~FLTConversationIdUtil();
  virtual void onMethodCalled(
      const std::string& method, const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result)
      override;

 private:
  void conversationType(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void p2pConversationId(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void teamConversationId(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void superTeamConversationId(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void conversationTargetId(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

#endif /* FLTConversationIdUtil_H */
