// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#include "FLTService.h"

#include "FLTConvert.h"

std::string FLTService::getServiceName() const { return m_serviceName; }

void FLTService::notifyEvent(const std::string& eventName,
                             flutter::EncodableMap& arguments) {
  arguments.insert(std::make_pair(flutter::EncodableValue("serviceName"),
                                  flutter::EncodableValue(m_serviceName)));
  std::string strLog;
  strLog.append("en: ")
      .append(eventName)
      .append(", args: ")
      .append(Convert::getInstance()->getStringFormMapForLog(&arguments));
  std::list<std::string> logList;
  Convert::getInstance()->getLogList(strLog, logList);
  for (auto& it : logList) {
    YXLOG_API(Info) << it << YXLOGEnd;
  }
  NimCore::getInstance()->invokeMethod(eventName, arguments);
  YXLOG_API(Info) << "notifyEvent invoke completation." << YXLOGEnd;
}

void FLTService::notifyEventEx(const std::string& serviceName,
                               const std::string& eventName,
                               flutter::EncodableMap& arguments) {
  arguments.insert(std::make_pair(flutter::EncodableValue("serviceName"),
                                  flutter::EncodableValue(serviceName)));
  std::string strLog;
  strLog.append("en: ")
      .append(eventName)
      .append(", args: ")
      .append(Convert::getInstance()->getStringFormMapForLog(&arguments));
  std::list<std::string> logList;
  Convert::getInstance()->getLogList(strLog, logList);
  for (auto& it : logList) {
    YXLOG_API(Info) << it << YXLOGEnd;
  }
  NimCore::getInstance()->invokeMethod(eventName, arguments);
  YXLOG_API(Info) << "notifyEventEx invoke completation." << YXLOGEnd;
}
