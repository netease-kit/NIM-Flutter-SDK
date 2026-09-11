// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#include "FLTStatisticsService.h"

using namespace nim;

FLTStatisticsService::FLTStatisticsService() {
  m_serviceName = "StatisticsService";
}

FLTStatisticsService::~FLTStatisticsService() {}

void FLTStatisticsService::onMethodCalled(
    const std::string& method, const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  switch (utils::hash_(method.c_str())) {
    case "getDatabaseInfos"_hash:
      getDatabaseInfos(arguments, result);
      return;
    default:
      break;
  }
  if (result) result->NotImplemented();
}

void FLTStatisticsService::getDatabaseInfos(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  auto& instance = v2::V2NIMClient::get();
  auto& statisticsService = instance.getStatisticsService();
  statisticsService.getDatabaseInfos(
      [result](nstd::vector<v2::V2NIMDatabaseInfo> databaseInfos) {
        flutter::EncodableList infoList;
        for (auto& info : databaseInfos) {
          flutter::EncodableMap infoMap;
          infoMap.insert(std::make_pair("path", std::string(info.path)));
          infoMap.insert(std::make_pair("name", std::string(info.name)));
          infoMap.insert(
              std::make_pair("size", static_cast<int64_t>(info.size)));
          infoList.emplace_back(infoMap);
        }
        flutter::EncodableMap resultMap;
        resultMap.insert(std::make_pair("databaseInfoList", infoList));
        result->Success(NimResult::getSuccessResult(resultMap));
      },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}
