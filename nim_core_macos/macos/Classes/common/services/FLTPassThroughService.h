// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#ifndef FLTPASSTHROUGHSERVICE_H
#define FLTPASSTHROUGHSERVICE_H

#include "../FLTService.h"
class FLTPassThroughService : public FLTService {
 public:
  FLTPassThroughService();
  virtual void onMethodCalled(
      const std::string& method, const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result)
      override;

 private:
  void httpProxy(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

 private:
  void receivedHttpMsgCb(const std::string& from_accid, const std::string& body,
                         uint64_t timestamp);
};

#endif  // FLTPASSTHROUGHSERVICE_H