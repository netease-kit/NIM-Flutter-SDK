// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#ifndef NIMCORE_H
#define NIMCORE_H

#include <optional>
#include "common/stable.h"
#include "common/utils/singleton.h"
#include "flutter/encodable_value.h"
#include "flutter/method_result.h"

class NimMethodChannel;
class FLTService;
class FLTLoginService;
class FLTMessageService;

using NimResultCallback =
    std::function<void(const flutter::EncodableValue* resultData, bool bNotImplemented)>;

#define UTF8(str) ([(str) isKindOfClass:[NSString class]] ? ([(str) UTF8String] ?: "") : "")

class NimCore {
 public:
  SINGLETONG(NimCore)

 public:
  using InvokeMehtodCallback = std::function<void(const std::optional<flutter::EncodableValue>&)>;
  void setMethodChannel(void* pChannel);
  void invokeMethod(const std::string& eventName, const flutter::EncodableMap& arguments);
  void invokeMethod(const std::string& eventName, const flutter::EncodableMap& arguments,
                    const InvokeMehtodCallback& callback);
  void onMethodCall(const std::string& methodName, const flutter::EncodableMap& arguments,
                    const NimResultCallback& resultCallback = NimResultCallback());

  void regService();
  void cleanService();
  void addService(FLTService* service);
  FLTService* getService(const std::string& serviceName) const;

  FLTLoginService* getFLTLoginService() const;
  FLTMessageService* getFLTMessageService() const;

 private:
  NimCore();
  ~NimCore();

 public:
  void setAppkey(const std::string& appkey);
  std::string getAppkey() const;

  void setLogDir(const std::string& logDir);
  std::string getLogDir() const;

  std::string getAccountId() const;

 private:
  std::unordered_map<std::string, FLTService*> m_services;
  NimMethodChannel* m_methodChannel;
  std::string m_appKey = "";
  std::string m_logDir;
};

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class MockMethodResult : public flutter::MethodResult<> {
 public:
  MockMethodResult(const std::string serviceName, const std::string methodName,
                   const NimResultCallback& resultCallback);
  virtual void ErrorInternal(const std::string& error_code, const std::string& error_message,
                             const flutter::EncodableValue* details) override;
  virtual void NotImplementedInternal() override;
  virtual void SuccessInternal(const flutter::EncodableValue* result) override;

 private:
  std::string getStringFormEncodableValue(const flutter::EncodableValue* value) const;

 private:
  std::string m_serviceName;
  std::string m_methodName;
  NimResultCallback m_resultCallback;
};

#endif  // NIMCORE
