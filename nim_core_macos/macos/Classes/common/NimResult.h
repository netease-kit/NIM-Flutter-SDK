// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#ifndef NIMRESULT_H
#define NIMRESULT_H

#include "flutter/encodable_value.h"

using namespace flutter;

class NimResult {
 public:
  static EncodableValue getErrorResult(int code, const std::string& msg);
  static EncodableValue getErrorResult(int code, const std::string& msg,
                                       const flutter::EncodableMap& data);

  static EncodableValue getSuccessResult();
  static EncodableValue getSuccessResult(int32_t data);
  static EncodableValue getSuccessResult(int64_t data);
  static EncodableValue getSuccessResult(const std::string& data);
  static EncodableValue getSuccessResult(const flutter::EncodableValue& data);
  static EncodableValue getSuccessResult(const flutter::EncodableMap& data);
  static EncodableValue getSuccessResult(const flutter::EncodableList& data);
  static EncodableValue getSuccessResult(const std::string& msg,
                                         const flutter::EncodableMap& data);
};

#endif  // NIMRESULT_H
