// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#ifndef FLTClientAntispamUtil_H
#define FLTClientAntispamUtil_H

#include "../FLTService.h"

class FLTClientAntispamUtil : public FLTService {
 public:
  FLTClientAntispamUtil();
  virtual ~FLTClientAntispamUtil();
  virtual void onMethodCalled(
      const std::string& method, const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result)
      override;

 private:
  void checkTextAntispam(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

#endif  // FLTClientAntispamUtil_H
