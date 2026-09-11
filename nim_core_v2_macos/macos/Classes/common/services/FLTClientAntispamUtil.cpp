// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#include "FLTClientAntispamUtil.h"

#include "v2_nim_api.hpp"

using namespace nim;

FLTClientAntispamUtil::FLTClientAntispamUtil() {
  m_serviceName = "V2NIMClientAntispamUtil";
}

FLTClientAntispamUtil::~FLTClientAntispamUtil() {}

void FLTClientAntispamUtil::onMethodCalled(
    const std::string& method, const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  switch (utils::hash_(method.c_str())) {
    case "checkTextAntispam"_hash:
      checkTextAntispam(arguments, result);
      return;
    default:
      break;
  }
  if (result) result->NotImplemented();
}

void FLTClientAntispamUtil::checkTextAntispam(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  std::string text;
  std::string replace;
  auto iter = arguments->begin();
  for (; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("text")) {
      text = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("replace")) {
      replace = std::get<std::string>(iter->second);
    }
  }

  auto antispamResult =
      v2::V2NIMClientAntispamUtil::checkTextAntispam(text, replace);
  flutter::EncodableMap resultMap;
  resultMap.insert(std::make_pair("operateType", antispamResult.operateType));
  resultMap.insert(std::make_pair("replacedText", antispamResult.replacedText));
  result->Success(NimResult::getSuccessResult(resultMap));
}
