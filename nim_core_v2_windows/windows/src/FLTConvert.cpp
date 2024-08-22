// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#include "FLTConvert.h"

Convert::Convert() {}

std::string Convert::getStringFormMapForLog(
    const flutter::EncodableMap* arguments) const {
  if (!arguments) {
    return "";
  }

  // todo
  return "";
}

void Convert::getLogList(const std::string& strLog,
                         std::list<std::string>& listLog) const {
  listLog.clear();
  int num = 15 * 1024;        // 分割定长大小
  int len = strLog.length();  // 字符串长度
  int end = num;
  for (int start = 0; start < len;) {
    if (end > len)  // 针对最后一个分割串
    {
      listLog.emplace_back(
          strLog.substr(start, len - start));  // 最后一个字符串的原始部分
      break;
    }
    listLog.emplace_back(
        strLog.substr(start, num));  // 从0开始，分割num位字符串
    start = end;
    end = end + num;
  }
}

std::string Convert::getStringFormListForLog(
    const flutter::EncodableList* arguments) const {
  if (!arguments) {
    return "";
  }

  return "";
}
