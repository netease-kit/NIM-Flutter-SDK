// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#include "FLTConversationIdUtil.h"

#include <iostream>
#include <regex>
#include <string>

#include "../FLTService.h"
#include "nim_cpp_wrapper/nim_cpp_api.h"
#include "v2_nim_api.hpp"
#include "v2_nim_def_enum.hpp"
#include "v2_nim_def_struct.hpp"
#include "v2_nim_login_service.hpp"
#include "v2_nim_utilities.hpp"

FLTConversationIdUtil::FLTConversationIdUtil() {
  m_serviceName = "ConversationIdUtil";
}

FLTConversationIdUtil::~FLTConversationIdUtil() {}

void FLTConversationIdUtil::onMethodCalled(
    const std::string& method, const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (method == "conversationType") {
    conversationType(arguments, result);
  } else if (method == "p2pConversationId") {
    p2pConversationId(arguments, result);
  } else if (method == "teamConversationId") {
    teamConversationId(arguments, result);
  } else if (method == "superTeamConversationId") {
    superTeamConversationId(arguments, result);
  } else if (method == "conversationTargetId") {
    conversationTargetId(arguments, result);
  } else {
    result->NotImplemented();
  }
}

void FLTConversationIdUtil::conversationType(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    result->Error(
        "", "",
        NimResult::getErrorResult(199414, "conversationType params error!"));
    return;
  }

  std::string conversationId;
  auto iter = arguments->find(EncodableValue("conversationId"));
  if (iter != arguments->end()) {
    conversationId = std::get<std::string>(iter->second);
  }

  std::string token;
  std::istringstream tokenStream(conversationId);
  int64_t typeValue = -1;

  for (int i = 0; std::getline(tokenStream, token, '|'); ++i) {
    if (i == 1) {
      typeValue = static_cast<int64_t>(std::stoi(token));
    }
  }
  flutter::EncodableMap resultMapData;
  resultMapData.insert(
      std::make_pair("conversationType", flutter::EncodableValue(typeValue)));
  //     auto resultType =
  //     v2::V2NIMConversationIdUtil::parseConversationType(conversationId);
  result->Success(NimResult::getSuccessResult(resultMapData));
}
void FLTConversationIdUtil::p2pConversationId(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    result->Error(
        "", "",
        NimResult::getErrorResult(199414, "p2pConversationId params error!"));
    return;
  }

  std::string accountId = "";
  auto iter = arguments->find(EncodableValue("accountId"));
  if (iter != arguments->end()) {
    accountId = std::get<std::string>(iter->second);
  }
  auto& client = v2::V2NIMClient::get();
  std::string loginUser = client.getLoginService().getLoginUser();
  std::string resultId = loginUser + "|1|" + accountId;
  //    std::string resultId =
  //    v2::V2NIMConversationIdUtil::p2pConversationId(conversationId);
  result->Success(NimResult::getSuccessResult(resultId));
}
void FLTConversationIdUtil::teamConversationId(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    result->Error(
        "", "",
        NimResult::getErrorResult(199414, "teamConversationId params error!"));
    return;
  }

  std::string teamId = "";
  auto iter = arguments->find(EncodableValue("teamId"));
  if (iter != arguments->end()) {
    teamId = std::get<std::string>(iter->second);
  }
  auto& client = v2::V2NIMClient::get();
  std::string loginUser = client.getLoginService().getLoginUser();
  std::string resultId = loginUser + "|2|" + teamId;
  //        std::string resultId =
  //        v2::V2NIMConversationIdUtil::teamConversationId(teamId);
  result->Success(NimResult::getSuccessResult(resultId));
}
void FLTConversationIdUtil::superTeamConversationId(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    result->Error("", "",
                  NimResult::getErrorResult(
                      199414, "superTeamConversationId params error!"));
    return;
  }

  std::string teamId = "";
  auto iter = arguments->find(EncodableValue("superTeamId"));
  if (iter != arguments->end()) {
    teamId = std::get<std::string>(iter->second);
  }
  auto& client = v2::V2NIMClient::get();
  std::string loginUser = client.getLoginService().getLoginUser();
  std::string resultId = loginUser + "|3|" + teamId;
  //      std::string resultId =
  //      v2::V2NIMConversationIdUtil::superTeamConversationId(teamId);
  result->Success(NimResult::getSuccessResult(resultId));
}
void FLTConversationIdUtil::conversationTargetId(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    result->Error("", "",
                  NimResult::getErrorResult(
                      199414, "conversationTargetId params error!"));
    return;
  }

  std::string conversationId = "";
  auto iter = arguments->find(EncodableValue("conversationId"));
  if (iter != arguments->end()) {
    conversationId = std::get<std::string>(iter->second);
  }
  std::string resultId = "";
  std::regex reg("\\|([^|]+)$");  // 匹配最后一个竖线后面的内容

  std::smatch match;
  if (std::regex_search(conversationId, match, reg)) {
    resultId = match[1];
  }

  //      v2::V2NIMConversationIdUtil::parseConversationTargetId(conversationId);
  result->Success(NimResult::getSuccessResult(resultId));
}
