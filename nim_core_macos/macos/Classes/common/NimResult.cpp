// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#include "NimResult.h"

using namespace flutter;

EncodableValue NimResult::getErrorResult(int code, const std::string& msg) {
  EncodableMap result;
  result.insert(std::make_pair(EncodableValue("code"), EncodableValue(code)));
  result.insert(
      std::make_pair(EncodableValue("errorDetails"), EncodableValue(msg)));
  result.insert(std::make_pair(EncodableValue("data"), EncodableValue()));
  return EncodableValue(result);
}

EncodableValue NimResult::getErrorResult(int code, const std::string& msg,
                                         const EncodableMap& data) {
  EncodableMap result;
  result.insert(std::make_pair(EncodableValue("code"), EncodableValue(code)));
  result.insert(
      std::make_pair(EncodableValue("errorDetails"), EncodableValue(msg)));
  result.insert(std::make_pair(EncodableValue("data"), EncodableValue(data)));
  return EncodableValue(result);
}

EncodableValue NimResult::getSuccessResult() {
  EncodableMap result;
  result.insert(std::make_pair(EncodableValue("code"), EncodableValue(0)));
  result.insert(
      std::make_pair(EncodableValue("errorDetails"), EncodableValue("")));
  result.insert(std::make_pair(EncodableValue("data"), EncodableValue()));
  return EncodableValue(result);
}

EncodableValue NimResult::getSuccessResult(int32_t data) {
  return getSuccessResult(EncodableValue(data));
}

EncodableValue NimResult::getSuccessResult(int64_t data) {
  return getSuccessResult(EncodableValue(data));
}

EncodableValue NimResult::getSuccessResult(const std::string& data) {
  return getSuccessResult(EncodableValue(data));
}

EncodableValue NimResult::getSuccessResult(const EncodableValue& data) {
  EncodableMap result;
  result.insert(std::make_pair(EncodableValue("code"), EncodableValue(0)));
  result.insert(
      std::make_pair(EncodableValue("errorDetails"), EncodableValue("")));
  result.insert(std::make_pair(EncodableValue("data"), data));
  return EncodableValue(result);
}

EncodableValue NimResult::getSuccessResult(const EncodableMap& data) {
  EncodableMap result;
  result.insert(std::make_pair(EncodableValue("code"), EncodableValue(0)));
  result.insert(
      std::make_pair(EncodableValue("errorDetails"), EncodableValue("")));
  result.insert(std::make_pair(EncodableValue("data"), data));
  return EncodableValue(result);
}

EncodableValue NimResult::getSuccessResult(const EncodableList& data) {
  EncodableMap result;
  result.insert(std::make_pair(EncodableValue("code"), EncodableValue(0)));
  result.insert(
      std::make_pair(EncodableValue("errorDetails"), EncodableValue("")));
  result.insert(std::make_pair(EncodableValue("data"), data));
  return EncodableValue(result);
}

EncodableValue NimResult::getSuccessResult(const std::string& msg,
                                           const EncodableMap& data) {
  EncodableMap result;
  result.insert(std::make_pair(EncodableValue("code"), EncodableValue(0)));
  result.insert(
      std::make_pair(EncodableValue("errorDetails"), EncodableValue(msg)));
  result.insert(std::make_pair(EncodableValue("data"), EncodableValue(data)));
  return EncodableValue(result);
}
