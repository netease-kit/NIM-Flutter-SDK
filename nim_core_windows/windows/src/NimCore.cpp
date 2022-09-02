// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#include "NimCore.h"

#include <flutter/encodable_value.h>
#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include <flutter/standard_method_codec.h>

#include "common/FLTConvert.h"
#include "common/services/FLTAudioRecorderService.h"
#include "common/services/FLTAuthService.h"
#include "common/services/FLTChatRoomService.h"
#include "common/services/FLTEventSubscribeService.h"
#include "common/services/FLTInitializeService.h"
#include "common/services/FLTMessageService.h"
#include "common/services/FLTNOSService.h"
#include "common/services/FLTPassThroughService.h"
#include "common/services/FLTSettingsService.h"
#include "common/services/FLTSuperTeamService.h"
#include "common/services/FLTSystemNotificationService.h"
#include "common/services/FLTTeamService.h"
#include "common/services/FLTUserService.h"

const std::string kFLTNimCoreService = "serviceName";

NimCore::NimCore() { addService(new FLTInitializeService()); }

NimCore::~NimCore() {}

void NimCore::regService() {
  addService(new FLTAuthService());
  addService(new FLTAudioRecorderService());
  addService(new FLTEventSubscribeService());
  addService(new FLTMessageService());
  addService(new FLTNOSService());
  addService(new FLTPassThroughService());
  addService(new FLTSystemNotificationService());
  addService(new FLTUserService());
  addService(new FLTChatRoomService());
  addService(new FLTTeamService());
  addService(new FLTSettingsService());
  addService(new FLTSuperTeamService());
}

void NimCore::addService(FLTService* service) {
  m_services[service->getServiceName()] = service;
}

FLTAuthService* NimCore::getFLTAuthService() const {
  return dynamic_cast<FLTAuthService*>(getService("AuthService"));
}

FLTMessageService* NimCore::getFLTMessageService() const {
  return dynamic_cast<FLTMessageService*>(getService("MessageService"));
}

FLTService* NimCore::getService(const std::string& serviceName) const {
  auto service = m_services.find(serviceName);
  if (m_services.end() == service) {
    return nullptr;
  }

  return service->second;
}

void NimCore::onMethodCall(
    const std::string& method, const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (nullptr == arguments) {
    if (result) {
      result->NotImplemented();
    }
    return;
  }

  auto serviceName_iter =
      arguments->find(flutter::EncodableValue("serviceName"));
  if (serviceName_iter != arguments->end() &&
      !serviceName_iter->second.IsNull()) {
    std::string serviceName = std::get<std::string>(serviceName_iter->second);
    auto* service = getService(serviceName);
    if (service) {
      std::shared_ptr<MockMethodResult> mockResult =
          std::make_shared<MockMethodResult>(serviceName, method, result);
      YXLOG_API(Info) << "mn: " << method << ", args: "
                      << Convert::getInstance()->getStringFormMapForLog(
                             arguments)
                      << YXLOGEnd;
      service->onMethodCalled(method, arguments, mockResult);
      return;
    }
  } else {
    YXLOG_API(Warn) << "sn not found, mn: " << method << YXLOGEnd;
  }

  if (result) {
    result->NotImplemented();
  }
}

void NimCore::invokeMethod(const std::string& method,
                           const flutter::EncodableMap& arguments) {
  if (m_channel) {
    m_channel->InvokeMethod(
        method, std::make_unique<flutter::EncodableValue>(arguments));
  }
}

void NimCore::setMethodChannel(NimMethodChannel* channel) {
  m_channel = channel;
}

NimCore::NimMethodChannel* NimCore::getMethodChannel() { return m_channel; }

void NimCore::setAppkey(const std::string& appkey) { m_appKey = appkey; }

std::string NimCore::getAppkey() const { return m_appKey; }

void NimCore::setLogDir(const std::string& logDir) { m_logDir = logDir; }

std::string NimCore::getLogDir() const { return m_logDir; }

std::string NimCore::getAccountId() const {
  auto fLTAuthService = getFLTAuthService();
  if (fLTAuthService) {
    return fLTAuthService->getAccountId();
  }
  return "";
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
MockMethodResult::MockMethodResult(
    const std::string serviceName, const std::string methodName,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result)
    : m_serviceName(serviceName),
      m_methodName(methodName),
      m_result(std::move(result)) {}

void MockMethodResult::ErrorInternal(const std::string& error_code,
                                     const std::string& error_message,
                                     const flutter::EncodableValue* details) {
  YXLOG_API(Warn) << "cb error, sn: " << m_serviceName
                  << ", mn: " << m_methodName << ", error_code: " << error_code
                  << ", error_msg: " << error_message
                  << ", details: " << getStringFormEncodableValue(details)
                  << YXLOGEnd;
  if (m_result) m_result->Success(*details);
  // //失败情况下, 也调用success接口，避免dart层抛出异常
  // m_result->Error(error_code, error_message, *details);
}

void MockMethodResult::NotImplementedInternal() {
  YXLOG_API(Warn) << "cb notImplemented, sn: " << m_serviceName
                  << ", mn: " << m_methodName << YXLOGEnd;
  if (m_result) m_result->NotImplemented();
}

void MockMethodResult::SuccessInternal(const flutter::EncodableValue* result) {
  std::string strLog;
  strLog.append("cb succ, sn: ")
      .append(m_serviceName)
      .append(", mn: ")
      .append(m_methodName)
      .append(", result: ")
      .append(getStringFormEncodableValue(result));
  std::list<std::string> logList;
  Convert::getInstance()->getLogList(strLog, logList);
  for (auto& it : logList) {
    YXLOG_API(Info) << it << YXLOGEnd;
  }

  if (m_result) m_result->Success(*result);
}

std::string MockMethodResult::getStringFormEncodableValue(
    const flutter::EncodableValue* value) const {
  if (!value) {
    return "";
  }

  std::string result;
  if (auto it = std::get_if<bool>(value); it) {
    result = *it ? "true" : "false";
  } else if (auto it1 = std::get_if<int32_t>(value); it1) {
    result = std::to_string(*it1);
  } else if (auto it2 = std::get_if<int64_t>(value); it2) {
    result = std::to_string(*it2);
  } else if (auto it3 = std::get_if<double>(value); it3) {
    result = std::to_string(*it3);
  } else if (auto it4 = std::get_if<std::string>(value); it4) {
    result = *it4;
  } else if (auto it5 = std::get_if<std::vector<uint8_t>>(value); it5) {
    result.append("[");
    bool bFirst = true;
    for (auto& it5Tmp : *it5) {
      if (!bFirst) {
        result.append("，");
      }
      result.append(std::to_string(it5Tmp));
      bFirst = false;
    }
    result.append("]");
  } else if (auto it6 = std::get_if<std::vector<int32_t>>(value); it6) {
    result.append("[");
    bool bFirst = true;
    for (auto& it6Tmp : *it6) {
      if (!bFirst) {
        result.append("，");
      }
      result.append(std::to_string(it6Tmp));
      bFirst = false;
    }
    result.append("]");
  } else if (auto it7 = std::get_if<std::vector<int64_t>>(value); it7) {
    result.append("[");
    bool bFirst = true;
    for (auto& it7Tmp : *it7) {
      if (!bFirst) {
        result.append("，");
      }
      result.append(std::to_string(it7Tmp));
      bFirst = false;
    }
    result.append("]");
  } else if (auto it8 = std::get_if<std::vector<double>>(value); it8) {
    result.append("[");
    bool bFirst = true;
    for (auto& it8Tmp : *it8) {
      if (!bFirst) {
        result.append("，");
      }
      result.append(std::to_string(it8Tmp));
      bFirst = false;
    }
    result.append("]");
  } else if (auto it9 = std::get_if<EncodableList>(value); it9) {
    result = Convert::getInstance()->getStringFormListForLog(it9);
  } else if (auto it10 = std::get_if<EncodableMap>(value); it10) {
    result = Convert::getInstance()->getStringFormMapForLog(it10);
  } else {
    // wjzh
  }

  return result;
}