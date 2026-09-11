// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#include "FLTUtilityService.h"

using namespace nim;

FLTUtilityService::FLTUtilityService() {
  m_serviceName = "V2NIMUtilityService";
}

FLTUtilityService::~FLTUtilityService() {}

void FLTUtilityService::onMethodCalled(
    const std::string& method, const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  switch (utils::hash_(method.c_str())) {
    case "exportMessagesToPath"_hash:
      exportMessagesToPath(arguments, result);
      return;
    case "importMessagesFromPath"_hash:
      importMessagesFromPath(arguments, result);
      return;
    case "cancelMigrateMessages"_hash:
      cancelMigrateMessages(arguments, result);
      return;
    default:
      break;
  }
  if (result) result->NotImplemented();
}

void FLTUtilityService::exportMessagesToPath(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (result) {
    result->Success(NimResult::getErrorResult(
        199414, "exportMessagesToPath is not supported on this platform"));
  }
}

void FLTUtilityService::importMessagesFromPath(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (result) {
    result->Success(NimResult::getErrorResult(
        199414, "importMessagesFromPath is not supported on this platform"));
  }
}

void FLTUtilityService::cancelMigrateMessages(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (result) {
    result->Success(NimResult::getErrorResult(
        199414, "cancelMigrateMessages is not supported on this platform"));
  }
}
