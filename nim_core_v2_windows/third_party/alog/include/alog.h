// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#ifndef ALOGINSTANCE_H
#define ALOGINSTANCE_H

#include <memory>
#include <string>

#if defined(_WIN32) || defined(WIN32) || defined(_WIN64)
#define API_EXPORT
#else
#ifdef ALOG_API
#define API_EXPORT __attribute__((visibility("default")))
#else
#define API_EXPORT
#endif
#endif

typedef enum { Debug = 1, Info, Warn, Error, Fatal } ALogLevel;

typedef enum {
  LogNormal = 0, /**< 正常日志打印 */
  LogApi         /**< API接口打印 */
} ALogType;

#define ALOGEnd ALog::ALogEnd()
#define ALOG(level) ALog().Init("", __FILE__, __LINE__, LogNormal, level)
#define ALOG_DIY(moduleName, type, level) \
  ALog().Init(moduleName, __FILE__, __LINE__, type, level)

class API_EXPORT ALog {
 public:
  class ALogEnd {};

 public:
  ALog& Init(const char* module, const char* file, long line, ALogType type,
             ALogLevel level);
  ALog& operator<<(int value);
  ALog& operator<<(unsigned int value);
  ALog& operator<<(const std::string& value);
  ALog& operator<<(const char* value);
  ALog& operator<<(long long value);
  ALog& operator<<(unsigned long long value);
  ALog& operator<<(unsigned long value);
  ALog& operator<<(float value);
  ALog& operator<<(const unsigned char* value);
  ALog& operator<<(void* value);
  template <typename T>
  ALog& operator<<(T* value) {
    if (m_level >= m_minLevel) {
      char strTmp[128] = {0};
      sprintf(strTmp, "%p", value);
      m_strLog.append(strTmp);
    }
    return *this;
  }
  void operator<<(const ALog::ALogEnd& value);

 public:
  static ALog* CreateInstance(const std::string& filePath,
                              const std::string& fileName, ALogLevel minLevel);
  static ALog* GetInstance();
  static void DestoryInstance();
  ALog();
  ~ALog();
  void setShortFileName(bool shortFileName = false);

 private:
  explicit ALog(const std::string& file, const std::string& fileName,
                ALogLevel minLevel);
  void write();

 private:
  static std::unique_ptr<ALog> m_log;
  static ALogLevel m_minLevel;
  static bool m_shortFileName;
  std::string m_strLog;
  std::string m_strModule;
  std::string m_strFile;
  long m_line = 0;
  ALogLevel m_level = Info;
  ALogType m_type = LogNormal;
};

#endif  // ALOGINSTANCE_H
