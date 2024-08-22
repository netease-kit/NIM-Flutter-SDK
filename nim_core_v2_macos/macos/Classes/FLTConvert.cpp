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

  flutter::EncodableMap arg = *arguments;
  if (auto itAppKey = arg.find(flutter::EncodableValue("appKey"));
      arg.end() != itAppKey) {
    itAppKey->second = "NOT print";
  }
  if (auto itToken = arg.find(flutter::EncodableValue("token"));
      arg.end() != itToken) {
    itToken->second = "NOT print";
  }
  nim_cpp_wrapper_util::Json::Value value;
  if (!convertMap2Json(&arg, value)) {
    return "";
  }

  return nim::GetJsonStringWithNoStyled(value);
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

  flutter::EncodableList arg = *arguments;
  if (auto it =
          std::find(arg.begin(), arg.end(), flutter::EncodableValue("appKey"));
      arg.end() != it) {
    // wjzh
  }
  nim_cpp_wrapper_util::Json::Value value;
  if (!convertList2Json(&arg, value)) {
    return "";
  }

  return nim::GetJsonStringWithNoStyled(value);
}

bool Convert::convertJson2Map(
    flutter::EncodableMap& map,
    const nim_cpp_wrapper_util::Json::Value& values) const {
  nim_cpp_wrapper_util::Json::Value::Members keys = values.getMemberNames();
  for (auto& it : keys) {
    auto& valueTmp = values[it];
    flutter::EncodableValue key = flutter::EncodableValue(it);
    if (valueTmp.isBool()) {
      map[key] = valueTmp.asBool();
    } else if (valueTmp.isInt()) {
      map[key] = valueTmp.asInt();
    } else if (valueTmp.isInt64()) {
      map[key] = valueTmp.asInt64();
    } else if (valueTmp.isDouble()) {
      map[key] = valueTmp.asDouble();
    } else if (valueTmp.isString()) {
      map[key] = valueTmp.asString();
    } else if (valueTmp.isArray()) {
      flutter::EncodableList listTmp;
      if (!convertJson2List(listTmp, valueTmp)) {
        return false;
      } else {
        map[key] = listTmp;
      }
    } else if (valueTmp.isObject()) {
      flutter::EncodableMap mapTmp;
      if (!convertJson2Map(mapTmp, valueTmp)) {
        return false;
      } else {
        map[key] = mapTmp;
      }
    } else {
      YXLOG(Warn) << "parse failed, it:" << it << YXLOGEnd;
      continue;
    }
  }

  return true;
}

bool Convert::convertJson2List(
    flutter::EncodableList& list,
    const nim_cpp_wrapper_util::Json::Value& values) const {
  for (int index = 0; index < (int)values.size(); index++) {
    auto& valueTmp = values[index];
    if (valueTmp.isNull()) {
      list.emplace_back(flutter::EncodableValue());
    } else if (valueTmp.isBool()) {
      list.emplace_back(flutter::EncodableValue(valueTmp.asBool()));
    } else if (valueTmp.isInt()) {
      list.emplace_back(flutter::EncodableValue(valueTmp.asInt()));
    } else if (valueTmp.isInt64()) {
      list.emplace_back(flutter::EncodableValue(valueTmp.asInt64()));
    } else if (valueTmp.isUInt()) {
      list.emplace_back(flutter::EncodableValue(valueTmp.asInt64()));
    } else if (valueTmp.isUInt64()) {
      list.emplace_back(flutter::EncodableValue(valueTmp.asInt64()));
    } else if (valueTmp.isDouble()) {
      list.emplace_back(flutter::EncodableValue(valueTmp.asDouble()));
    } else if (valueTmp.isString()) {
      list.emplace_back(flutter::EncodableValue(valueTmp.asString()));
    } else if (valueTmp.isArray()) {
      flutter::EncodableList listTmp;
      if (!convertJson2List(listTmp, valueTmp)) {
        return false;
      }
      list.emplace_back(listTmp);
    } else if (valueTmp.isObject()) {
      flutter::EncodableMap mapTmp;
      if (!convertJson2Map(mapTmp, valueTmp)) {
        return false;
      }
      list.emplace_back(mapTmp);
    } else {
      YXLOG(Warn) << "parse failed, valueTmp type: " << valueTmp.type()
                  << YXLOGEnd;
      return false;
    }
  }

  return true;
}

bool Convert::convertMap2Json(const flutter::EncodableMap* arguments,
                              nim_cpp_wrapper_util::Json::Value& value) const {
  for (auto& it : *arguments) {
    if (it.second.IsNull()) {
      // YXLOG(Warn) << "parse failed, key: " << key << " is not value." <<
      // YXLOGEnd;
      continue;
    }
    auto key = std::get<std::string>(it.first);
    if (auto second = std::get_if<bool>(&it.second); second) {
      value[key] = *second;
    } else if (auto second1 = std::get_if<int32_t>(&it.second); second1) {
      value[key] = *second1;
    } else if (auto second2 = std::get_if<int64_t>(&it.second); second2) {
      value[key] = *second2;
    } else if (auto second3 = std::get_if<double>(&it.second); second3) {
      value[key] = *second3;
    } else if (auto second4 = std::get_if<std::string>(&it.second); second4) {
      value[key] = *second4;
    } else if (auto second5 = std::get_if<std::vector<uint8_t>>(&it.second);
               second5) {
      nim_cpp_wrapper_util::Json::Value vec;
      for (auto& it2 : *second5) {
        vec.append(it2);
      }
      value[key] = vec;
    } else if (auto second6 = std::get_if<std::vector<int32_t>>(&it.second);
               second6) {
      nim_cpp_wrapper_util::Json::Value vec;
      for (auto& it2 : *second6) {
        vec.append(it2);
      }
      value[key] = vec;
    } else if (auto second7 = std::get_if<std::vector<int64_t>>(&it.second);
               second7) {
      nim_cpp_wrapper_util::Json::Value vec;
      for (auto& it2 : *second7) {
        vec.append(it2);
      }
      value[key] = vec;
    } else if (auto second8 = std::get_if<std::vector<double>>(&it.second);
               second8) {
      nim_cpp_wrapper_util::Json::Value vec;
      for (auto& it2 : *second8) {
        vec.append(it2);
      }
      value[key] = vec;
    } else if (auto second9 = std::get_if<EncodableList>(&it.second); second9) {
      nim_cpp_wrapper_util::Json::Value listTmp;
      if (!convertList2Json(second9, listTmp)) {
        YXLOG(Warn) << "convertList2Json failed." << YXLOGEnd;
        return false;
      }
      value[key] = listTmp;
    } else if (auto second10 = std::get_if<EncodableMap>(&it.second);
               second10) {
      nim_cpp_wrapper_util::Json::Value mapTmp;
      if (!convertMap2Json(second10, mapTmp)) {
        YXLOG(Warn) << "convertMap2Json failed." << YXLOGEnd;
        return false;
      }
      value[key] = mapTmp;
    }
  }

  return true;
}

bool Convert::convertList2Json(const flutter::EncodableList* arguments,
                               nim_cpp_wrapper_util::Json::Value& value) const {
  if (arguments->size() == 0) {
    value.resize(0);
    return true;
  }

  for (auto& it : *arguments) {
    if (auto second = std::get_if<bool>(&it); second) {
      value.append(*second);
    } else if (auto second1 = std::get_if<int32_t>(&it); second1) {
      value.append(*second1);
    } else if (auto second2 = std::get_if<int64_t>(&it); second2) {
      value.append(*second2);
    } else if (auto second3 = std::get_if<double>(&it); second3) {
      value.append(*second3);
    } else if (auto second4 = std::get_if<std::string>(&it); second4) {
      value.append(*second4);
    } else if (auto second5 = std::get_if<std::vector<uint8_t>>(&it); second5) {
      nim_cpp_wrapper_util::Json::Value vec;
      for (auto& it2 : *second5) {
        vec.append(it2);
      }
      value.append(vec);
    } else if (auto second6 = std::get_if<std::vector<int32_t>>(&it); second6) {
      nim_cpp_wrapper_util::Json::Value vec;
      for (auto& it2 : *second6) {
        vec.append(it2);
      }
      value.append(vec);
    } else if (auto second7 = std::get_if<std::vector<int64_t>>(&it); second7) {
      nim_cpp_wrapper_util::Json::Value vec;
      for (auto& it2 : *second7) {
        vec.append(it2);
      }
      value.append(vec);
    } else if (auto second8 = std::get_if<std::vector<double>>(&it); second8) {
      nim_cpp_wrapper_util::Json::Value vec;
      for (auto& it2 : *second8) {
        vec.append(it2);
      }
      value.append(vec);
    } else if (auto second9 = std::get_if<EncodableList>(&it); second9) {
      nim_cpp_wrapper_util::Json::Value listTmp;
      if (!convertList2Json(second9, listTmp)) {
        return false;
      }
      value.append(listTmp);
    } else if (auto second10 = std::get_if<EncodableMap>(&it); second10) {
      nim_cpp_wrapper_util::Json::Value mapTmp;
      if (!convertMap2Json(second10, mapTmp)) {
        return false;
      }
      value.append(mapTmp);
    }
  }
  return true;
}
