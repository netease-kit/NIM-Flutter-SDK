// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#ifndef NIMCORE_H
#define NIMCORE_H

#include <flutter/encodable_value.h>
#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include <flutter/standard_method_codec.h>

class FLTService;
class FLTAuthService;
class FLTMessageService;

class NimCore {
 public:
  using NimMethodChannel = flutter::MethodChannel<flutter::EncodableValue>;

 public:
  SINGLETONG(NimCore)

 private:
  NimCore();
  ~NimCore();

 public:
  void regService();

  void addService(FLTService* service);

  FLTAuthService* getFLTAuthService() const;
  FLTMessageService* getFLTMessageService() const;
  FLTService* getService(const std::string& serviceName) const;

  void onMethodCall(
      const std::string& method, const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

  void invokeMethod(const std::string& method,
                    const flutter::EncodableMap& arguments);

  void setMethodChannel(NimMethodChannel* channel);
  NimMethodChannel* getMethodChannel();

 public:
  void setAppkey(const std::string& appkey);
  std::string getAppkey() const;

  void setLogDir(const std::string& logDir);
  std::string getLogDir() const;

  std::string getAccountId() const;

 private:
  std::unordered_map<std::string, FLTService*> m_services;
  NimMethodChannel* m_channel = nullptr;
  std::string m_appKey = "";
  std::string m_logDir;
};

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class MockMethodResult : public flutter::MethodResult<> {
 public:
  MockMethodResult(
      const std::string serviceName, const std::string methodName,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  virtual void ErrorInternal(const std::string& error_code,
                             const std::string& error_message,
                             const flutter::EncodableValue* details) override;
  virtual void NotImplementedInternal() override;
  virtual void SuccessInternal(const flutter::EncodableValue* result) override;

 private:
  std::string getStringFormEncodableValue(
      const flutter::EncodableValue* value) const;

 private:
  std::string m_serviceName;
  std::string m_methodName;
  std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> m_result;
};
#endif  // NIMCORE
