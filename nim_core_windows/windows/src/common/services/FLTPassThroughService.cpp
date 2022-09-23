// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#include "FLTPassThroughService.h"

#include "nim_cpp_wrapper/api/nim_cpp_pass_through_proxy.h"

FLTPassThroughService::FLTPassThroughService() {
  m_serviceName = "PassThroughService";
  nim::PassThroughProxy::RegReceivedHttpMsgCb(
      std::bind(&FLTPassThroughService::receivedHttpMsgCb, this,
                std::placeholders::_1, std::placeholders::_2,
                std::placeholders::_3),
      "");
}

void FLTPassThroughService::onMethodCalled(
    const std::string& method, const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (method == "httpProxy") {
    httpProxy(arguments, result);
  } else {
    result->NotImplemented();
  }
}

void FLTPassThroughService::httpProxy(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  std::string zone = "";
  std::string path = "";
  std::string header = "";
  std::string body = "";
  int method = 2;

  flutter::EncodableMap proxyData;
  auto iter = arguments->find(flutter::EncodableValue("passThroughProxyData"));
  if (iter != arguments->end()) {
    if (iter->second.IsNull()) {
      result->Error("", "", NimResult::getErrorResult(-1, "params error"));
      return;
    }
    proxyData = std::get<flutter::EncodableMap>(iter->second);
  }

  if (proxyData.empty()) {
    result->Error("", "", NimResult::getErrorResult(-1, "params error"));
    return;
  }

  auto iter2 = proxyData.begin();
  for (iter2; iter2 != proxyData.end(); ++iter2) {
    if (iter2->second.IsNull()) {
      continue;
    }

    if (iter2->first == flutter::EncodableValue("zone")) {
      zone = std::get<std::string>(iter2->second);
    } else if (iter2->first == flutter::EncodableValue("path")) {
      path = std::get<std::string>(iter2->second);
    } else if (iter2->first == flutter::EncodableValue("method")) {
      method = std::get<int>(iter2->second);
    } else if (iter2->first == flutter::EncodableValue("header")) {
      header = std::get<std::string>(iter2->second);
    } else if (iter2->first == flutter::EncodableValue("body")) {
      body = std::get<std::string>(iter2->second);
    }
  }
  nim::PassThroughProxy::SendHttpRequest(
      zone, path, static_cast<nim::NIMSendHttpRequestMethods>(method), header,
      body, "",
      [=](int res_code, const std::string& strHeader,
          const std::string& strBody, const std::string& json_extension) {
        if (res_code == 200) {
          flutter::EncodableMap arguments;
          flutter::EncodableMap data;
          data.insert(std::make_pair("zone", zone));
          data.insert(std::make_pair("path", path));
          data.insert(std::make_pair("method", method));
          data.insert(std::make_pair("header", header));
          data.insert(std::make_pair("body", body));
          arguments.insert(std::make_pair("passThroughProxyData", data));
          result->Success(NimResult::getSuccessResult(arguments));
        } else {
          result->Error(
              "", "", NimResult::getErrorResult(res_code, "httpProxy failed"));
        }
      });
}

void FLTPassThroughService::receivedHttpMsgCb(const std::string& from_accid,
                                              const std::string& body,
                                              uint64_t timestamp) {
  flutter::EncodableMap arguments;
  flutter::EncodableMap data;
  data.insert(std::make_pair("fromAccid", from_accid));
  data.insert(std::make_pair("body", body));
  data.insert(std::make_pair("time", (int64_t)timestamp));
  arguments.insert(std::make_pair("passThroughProxyData", data));

  notifyEvent("onPassthrough", arguments);
}