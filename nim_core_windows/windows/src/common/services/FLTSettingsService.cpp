// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#include "FLTSettingsService.h"

#include "../FLTConvert.h"

FLTSettingsService::FLTSettingsService() {
  m_serviceName = "SettingsService";
  nim::Global::RegSDKDBError(
      std::bind(&FLTSettingsService::SDKDBError, this, std::placeholders::_1));
}

FLTSettingsService::~FLTSettingsService() {}

void FLTSettingsService::onMethodCalled(
    const std::string& method, const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  switch (utils::hash_(method.c_str())) {
    case "getSizeOfDirCache"_hash:
      getSizeOfDirCache(arguments, result);
      return;
    case "clearDirCache"_hash:
      clearDirCache(arguments, result);
      return;
    case "uploadLogs"_hash:
      uploadLogs(arguments, result);
      return;
    default:
      break;
  }
  if (result) result->NotImplemented();
}

void FLTSettingsService::getSizeOfDirCache(
    const flutter::EncodableMap* arguments, FLTService::MethodResult result) {
  auto it = arguments->find(flutter::EncodableValue("fileTypes"));
  if (it == arguments->end() || it->second.IsNull()) {
    if (result) {
      result->Error(
          "", "",
          NimResult::getErrorResult(
              -1, "getSizeOfDirCache params error, fileTypes is empty"));
    }
    return;
  }
  auto fileTypesTmp = std::get<flutter::EncodableList>(it->second);
  std::list<std::string> fileTypeList;
  Convert::getInstance()->convertDartListToStd(fileTypeList, &fileTypesTmp);
  if (fileTypeList.empty()) {
    if (result) {
      result->Error(
          "", "",
          NimResult::getErrorResult(
              -1, "getSizeOfDirCache params error, fileTypes is error"));
    }
    return;
  }
  int64_t startTime = 0;
  int64_t endTime = 0;
  it = arguments->find(flutter::EncodableValue("startTime"));
  if (it != arguments->end() && !it->second.IsNull()) {
    startTime = it->second.LongValue();
  }
  it = arguments->find(flutter::EncodableValue("endTime"));
  if (it != arguments->end() && !it->second.IsNull()) {
    endTime = it->second.LongValue();
  }

  nim::Global::GetSDKCachedFileInfoAsync(
      NimCore::getInstance()->getAccountId(), fileTypeList.front(), endTime, "",
      [result](nim::NIMResCode res_code,
               const nim::Global::CachedFileInfo& info) {
        if (!result) {
          return;
        }

        if (nim::kNIMResSuccess == res_code) {
          result->Success(NimResult::getSuccessResult(info.file_total_size_));
        } else {
          result->Error(
              "", "",
              NimResult::getErrorResult(res_code, "getSizeOfDirCache failed!"));
        }
      });
}

void FLTSettingsService::clearDirCache(const flutter::EncodableMap* arguments,
                                       FLTService::MethodResult result) {
  auto it = arguments->find(flutter::EncodableValue("fileTypes"));
  if (it == arguments->end() || it->second.IsNull()) {
    if (result) {
      result->Error("", "",
                    NimResult::getErrorResult(
                        -1, "clearDirCache params error, fileTypes is empty"));
    }
    return;
  }
  auto fileTypesTmp = std::get<flutter::EncodableList>(it->second);
  std::list<std::string> fileTypeList;
  Convert::getInstance()->convertDartListToStd(fileTypeList, &fileTypesTmp);
  if (fileTypeList.empty()) {
    if (result) {
      result->Error("", "",
                    NimResult::getErrorResult(
                        -1, "clearDirCache params error, fileTypes is error"));
    }
    return;
  }
  int64_t startTime = 0;
  int64_t endTime = 0;
  it = arguments->find(flutter::EncodableValue("startTime"));
  if (it != arguments->end() && !it->second.IsNull()) {
    startTime = it->second.LongValue();
  }
  it = arguments->find(flutter::EncodableValue("endTime"));
  if (it != arguments->end() && !it->second.IsNull()) {
    endTime = it->second.LongValue();
  }

  nim::Global::DeleteSDKCachedFileAsync(
      NimCore::getInstance()->getAccountId(), fileTypeList.front(), endTime, "",
      [result](nim::NIMResCode res_code) {
        if (!result) {
          return;
        }

        if (nim::kNIMResSuccess == res_code) {
          result->Success(NimResult::getSuccessResult());
        } else {
          result->Error(
              "", "",
              NimResult::getErrorResult(res_code, "clearDirCache failed!"));
        }
      });
}

void FLTSettingsService::uploadLogs(const flutter::EncodableMap* arguments,
                                    FLTService::MethodResult result) {
  // wjzh
  std::string chatroomId;
  auto it = arguments->find(flutter::EncodableValue("chatroomId"));
  if (it != arguments->end() && !it->second.IsNull()) {
    chatroomId = std::get<std::string>(it->second);
  }

  std::string comment;
  it = arguments->find(flutter::EncodableValue("comment"));
  if (it != arguments->end() && !it->second.IsNull()) {
    comment = std::get<std::string>(it->second);
  }

  // wjzh
  bool partial = true;
  it = arguments->find(flutter::EncodableValue("partial"));
  if (it != arguments->end() && !it->second.IsNull()) {
    partial = std::get<bool>(it->second);
  }

  nim::Global::UploadSDKLog(comment, [result](nim::NIMResCode res_code) {
    if (!result) {
      return;
    }

    if (nim::kNIMResSuccess == res_code) {
      result->Success(NimResult::getSuccessResult());
    } else {
      result->Error("", "",
                    NimResult::getErrorResult(res_code, "uploadLogs failed!"));
    }
  });
}

///////////////////////////////////////////////////////////////////////////////////////////////////
void FLTSettingsService::SDKDBError(
    const nim::Global::SDKDBErrorInfo& error_info) {
  std::string db_name_;
  int error_code_;
  int operation_;
  std::string description_;
  std::string attach_;
  YXLOG(Warn) << "sdkDBError, db_name: " << error_info.db_name_
              << ", error_code: " << error_info.error_code_
              << ", operation: " << error_info.operation_
              << ", description: " << error_info.description_
              << ", attach: " << error_info.attach_ << YXLOGEnd;
}