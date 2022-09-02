// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#include "FLTNOSService.h"

#include "nim_cpp_wrapper/api/nim_cpp_nos.h"

FLTNOSService::FLTNOSService() { m_serviceName = "NOSService"; }

void FLTNOSService::onMethodCalled(
    const std::string& method, const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (method == "upload") {
    upload(arguments, result);
  } else if (method == "download") {
    download(arguments, result);
  } else {
    result->NotImplemented();
  }
}

void FLTNOSService::upload(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  std::string filePath = "";
  auto iter = arguments->find(flutter::EncodableValue("filePath"));
  if (iter != arguments->end()) {
    if (iter->second.IsNull()) {
      result->Error("", "",
                    NimResult::getErrorResult(-1, "upload params error"));
      return;
    }
    filePath = std::get<std::string>(iter->second);
  }

  std::string sceneKey = "";
  iter = arguments->find(flutter::EncodableValue("sceneKey"));
  if (iter != arguments->end()) {
    if (!iter->second.IsNull()) {
      sceneKey = std::get<std::string>(iter->second);
    }
  }

  bool res = false;
  if (sceneKey.empty()) {
    res = nim::NOS::UploadResource(
        filePath,
        std::bind(&FLTNOSService::uploadMediaCallback, this,
                  std::placeholders::_1, std::placeholders::_2),
        std::bind(&FLTNOSService::progressCallback, this, std::placeholders::_1,
                  std::placeholders::_2));
  } else {
    res = nim::NOS::UploadResource2(
        filePath, sceneKey,
        std::bind(&FLTNOSService::uploadMediaCallback, this,
                  std::placeholders::_1, std::placeholders::_2),
        std::bind(&FLTNOSService::progressCallback, this, std::placeholders::_1,
                  std::placeholders::_2));
  }

  m_uploadResult = result;
  if (!res) {
    result->Error("", "", NimResult::getErrorResult(-1, "nos upload failed!"));
    m_uploadResult.reset();
  }
}

void FLTNOSService::download(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  std::string url = "";
  auto iter = arguments->find(flutter::EncodableValue("url"));
  if (iter != arguments->end()) {
    if (iter->second.IsNull()) {
      result->Error(
          "", "",
          NimResult::getErrorResult(-1, "upload params error, url is empty!"));
      return;
    }
    url = std::get<std::string>(iter->second);
  }

  std::string path = "";
  iter = arguments->find(flutter::EncodableValue("path"));
  if (iter != arguments->end()) {
    if (!iter->second.IsNull()) {
      path = std::get<std::string>(iter->second);
    }
  }

  std::string json_extension = "";
  if (!path.empty()) {
    nim_cpp_wrapper_util::Json::Value value;
    value["saveas_filepath"] = path;
    json_extension = nim::GetJsonStringWithNoStyled(value);
  }

  std::cout << "download json_extension:" << json_extension << std::endl;

  bool res = nim::NOS::DownloadResourceEx(
      url, json_extension,
      std::bind(&FLTNOSService::downloadMediaExCallback, this,
                std::placeholders::_1, std::placeholders::_2),
      std::bind(&FLTNOSService::progressCallback, this, std::placeholders::_1,
                std::placeholders::_2));

  if (res) {
    result->Success(NimResult::getSuccessResult());
  } else {
    result->Error("", "",
                  NimResult::getErrorResult(-1, "nos download failed!"));
  }
}

void FLTNOSService::uploadMediaCallback(nim::NIMResCode res_code,
                                        const std::string& url) {
  // YXLOG(Info) << "uploadMediaCallback: url" << url << " res_code: " <<
  // res_code << YXLOGEnd;
  if (res_code == nim::kNIMResSuccess) {
    flutter::EncodableMap arguments;
    arguments.insert(std::make_pair("url", url));
    arguments.insert(std::make_pair("status", "transferred"));
    arguments.insert(std::make_pair("transferType", "upload"));
    if (m_uploadResult) {
      m_uploadResult->Success(
          NimResult::getSuccessResult(flutter::EncodableValue(url)));
      m_uploadResult.reset();
    }
    notifyEvent("onNOSTransferStatus", arguments);
  } else {
    if (m_uploadResult) {
      m_uploadResult->Error(
          "", "",
          NimResult::getErrorResult(res_code, "uploadMediaCallback failed"));
      m_uploadResult.reset();
    }
  }
}

void FLTNOSService::downloadMediaExCallback(
    nim::NIMResCode res_code, const nim::DownloadMediaResult& result) {
  // YXLOG(Info) << "uploadMediaCallback: path" << result.file_path_ << "
  // res_code: " << res_code << YXLOGEnd;
  if (res_code == nim::kNIMResSuccess) {
    flutter::EncodableMap arguments;
    arguments.insert(std::make_pair("path", result.file_path_));
    arguments.insert(std::make_pair("status", "transferred"));
    arguments.insert(std::make_pair("transferType", "download"));
    notifyEvent("onNOSTransferStatus", arguments);
  }
}

void FLTNOSService::progressCallback(int64_t completed_size,
                                     int64_t file_size) {
  // flutter::EncodableMap arguments;
  // double progress = (double)completed_size / file_size;
  // std::cout << "progressCallback: completed_size" << completed_size << "
  // file_size: " << file_size << std::endl;
  // arguments.insert(std::make_pair("progress", progress));
  // notifyEvent("onNOSTransferProgress", arguments);
}

void FLTNOSService::speedCallback(int64_t speed) {}

void FLTNOSService::transferInfoCallback(int64_t actual_size, int64_t speed) {}
