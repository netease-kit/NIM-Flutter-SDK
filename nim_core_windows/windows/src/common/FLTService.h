// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#ifndef FLTSERVICE_H
#define FLTSERVICE_H

#include "../NimCore.h"
#include "NimResult.h"
#include "flutter/method_result.h"

#define DECLARE_FUN(fun)                           \
  void fun(const flutter::EncodableMap* arguments, \
           FLTService::MethodResult result);

class FLTService {
 public:
  using MethodResult =
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>;

 public:
  virtual void onMethodCalled(
      const std::string& method, const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>
          result) = 0;

  std::string getServiceName() const;

  void notifyEvent(const std::string& eventName,
                   flutter::EncodableMap& arguments);

  static void notifyEventEx(const std::string& serviceName,
                            const std::string& eventName,
                            flutter::EncodableMap& arguments);

 protected:
  std::string m_serviceName;
};

#endif  // FLTSERVICE_H
