// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#include "V2FLTSettingsService.h"

#include "../FLTService.h"
#include "nim_cpp_wrapper/nim_cpp_api.h"
#include "v2_nim_api.hpp"
#include "v2_nim_def_enum.hpp"
#include "v2_nim_def_struct.hpp"
#include "v2_nim_team_service.hpp"

V2FLTSettingsService::V2FLTSettingsService() {
  m_serviceName = "SettingsService";
  listener.onTeamMessageMuteModeChanged =
      [=](nstd::string teamId, v2::V2NIMTeamType teamType,
          v2::V2NIMTeamMessageMuteMode muteMode) {
        flutter::EncodableMap result_map;
        result_map.insert(std::make_pair("teamId", teamId));
        result_map.insert(
            std::make_pair("teamType", static_cast<int>(teamType)));
        result_map.insert(
            std::make_pair("muteMode", static_cast<int>(muteMode)));
        notifyEvent("onTeamMessageMuteModeChanged", result_map);
      };

  listener.onP2PMessageMuteModeChanged =
      [=](nstd::string accountId, v2::V2NIMP2PMessageMuteMode muteMode) {
        flutter::EncodableMap result_map;
        result_map.insert(std::make_pair("accountId", accountId));
        result_map.insert(
            std::make_pair("muteMode", static_cast<int>(muteMode)));
        notifyEvent("onP2PMessageMuteModeChanged", result_map);
      };

  auto& client = v2::V2NIMClient::get();
  auto& settingService = client.getSettingService();
  settingService.addSettingListener(listener);
}

V2FLTSettingsService::~V2FLTSettingsService() {
  auto& client = v2::V2NIMClient::get();
  auto& settingService = client.getSettingService();
  settingService.removeSettingListener(listener);
}

void V2FLTSettingsService::getDndConfig(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  auto& client = v2::V2NIMClient::get();
  auto& settingService = client.getSettingService();
  v2::V2NIMDndConfig config = settingService.getDndConfig();
  flutter::EncodableMap result_map;
  result_map.insert(std::make_pair("showDetail", config.showDetail));
  result_map.insert(std::make_pair("dndOn", config.dndOn));
  result_map.insert(
      std::make_pair("fromH", static_cast<int32_t>(config.fromH)));
  result_map.insert(
      std::make_pair("fromM", static_cast<int32_t>(config.fromM)));
  result_map.insert(std::make_pair("toH", static_cast<int32_t>(config.toH)));
  result_map.insert(std::make_pair("toM", static_cast<int32_t>(config.toM)));
  result->Success(NimResult::getSuccessResult(result_map));
}
void V2FLTSettingsService::setDndConfig(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  v2::V2NIMDndConfig config;
  auto iter = arguments->find(flutter::EncodableValue("config"));
  if (iter != arguments->end()) {
    auto configinfo = std::get<flutter::EncodableMap>(iter->second);
    auto configIter = configinfo.begin();
    for (configIter; configIter != configinfo.end(); ++configIter) {
      if (configIter->second.IsNull()) continue;
      if (configIter->first == flutter::EncodableValue("showDetail")) {
        config.showDetail = std::get<bool>(configIter->second);
      } else if (configIter->first == flutter::EncodableValue("dndOn")) {
        config.dndOn = std::get<bool>(configIter->second);
      } else if (configIter->first == flutter::EncodableValue("fromH")) {
        config.fromH = configIter->second.LongValue();
      } else if (configIter->first == flutter::EncodableValue("fromM")) {
        config.fromM = configIter->second.LongValue();
      } else if (configIter->first == flutter::EncodableValue("toH")) {
        config.toH = configIter->second.LongValue();
      } else if (configIter->first == flutter::EncodableValue("toM")) {
        config.toM = configIter->second.LongValue();
      }
    }
  }
  auto& client = v2::V2NIMClient::get();
  auto& settingService = client.getSettingService();
  settingService.setDndConfig(
      config, [=]() { result->Success(NimResult::getSuccessResult()); },
      [=](v2::V2NIMError error) {
        result->Error("", "",
                      NimResult::getErrorResult(error.code, error.desc));
      });
}
void V2FLTSettingsService::getConversationMuteStatus(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  std::string conversationId;
  auto iter = arguments->find(flutter::EncodableValue("conversationId"));
  if (iter != arguments->end()) {
    conversationId = std::get<std::string>(iter->second);
  }

  auto& client = v2::V2NIMClient::get();
  auto& settingService = client.getSettingService();
  bool mute = settingService.getConversationMuteStatus(conversationId);
  result->Success(NimResult::getSuccessResult(mute));
}
void V2FLTSettingsService::getP2PMessageMuteList(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  auto& client = v2::V2NIMClient::get();
  auto& settingService = client.getSettingService();
  settingService.getP2PMessageMuteList(
      [=](nstd::vector<nstd::string> list) {
        flutter::EncodableList muteList;
        for (auto& item : list) {
          muteList.push_back(flutter::EncodableValue(item));
        }
        flutter::EncodableMap result_map;
        result_map[flutter::EncodableValue("muteList")] = muteList;
        result->Success(NimResult::getSuccessResult(result_map));
      },
      [=](v2::V2NIMError error) {
        result->Error("", "",
                      NimResult::getErrorResult(error.code, error.desc));
      });
}
void V2FLTSettingsService::getP2PMessageMuteMode(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  std::string accountId;
  auto iter = arguments->find(flutter::EncodableValue("accountId"));
  if (iter != arguments->end()) {
    accountId = std::get<std::string>(iter->second);
  }

  auto& client = v2::V2NIMClient::get();
  auto& settingService = client.getSettingService();
  auto mode = settingService.getP2PMessageMuteMode(accountId);
  flutter::EncodableMap result_map;
  result_map[flutter::EncodableValue("muteMode")] =
      flutter::EncodableValue(mode);
  result->Success(NimResult::getSuccessResult(result_map));
}
void V2FLTSettingsService::getTeamMessageMuteMode(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  std::string teamId;
  v2::V2NIMTeamType teamType;

  auto iter = arguments->find(flutter::EncodableValue("teamId"));
  if (iter != arguments->end()) {
    teamId = std::get<std::string>(iter->second);
  }
  iter = arguments->find(flutter::EncodableValue("teamType"));
  if (iter != arguments->end()) {
    teamType = (v2::V2NIMTeamType)std::get<int>(iter->second);
  }

  auto& client = v2::V2NIMClient::get();
  auto& settingService = client.getSettingService();

  v2::V2NIMTeamMessageMuteMode mode =
      settingService.getTeamMessageMuteMode(teamId, teamType);
  flutter::EncodableMap result_map;

  result_map[flutter::EncodableValue("muteMode")] =
      flutter::EncodableValue(mode);
  result->Success(NimResult::getSuccessResult(result_map));
}
void V2FLTSettingsService::setApnsDndConfig(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {}

void V2FLTSettingsService::setAppBackground(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {}

void V2FLTSettingsService::setP2PMessageMuteMode(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  v2::V2NIMP2PMessageMuteMode muteMode;
  std::string accountId;
  auto iter = arguments->find(flutter::EncodableValue("accountId"));
  if (iter != arguments->end()) {
    accountId = std::get<std::string>(iter->second);
  }
  iter = arguments->find(flutter::EncodableValue("muteMode"));
  if (iter != arguments->end()) {
    muteMode = (v2::V2NIMP2PMessageMuteMode)std::get<int>(iter->second);
  }

  auto& client = v2::V2NIMClient::get();
  auto& settingService = client.getSettingService();
  settingService.setP2PMessageMuteMode(
      accountId, muteMode,
      [=]() { result->Success(NimResult::getSuccessResult()); },
      [=](v2::V2NIMError error) {
        result->Error("", "",
                      NimResult::getErrorResult(error.code, error.desc));
      });
}
void V2FLTSettingsService::setPushMobileOnDesktopOnline(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  bool need;
  auto iter = arguments->find(flutter::EncodableValue("need"));
  if (iter != arguments->end()) {
    need = std::get<bool>(iter->second);
  }
  auto& client = v2::V2NIMClient::get();
  auto& settingService = client.getSettingService();

  settingService.setPushMobileOnDesktopOnline(
      need, [=]() { result->Success(NimResult::getSuccessResult()); },
      [=](v2::V2NIMError error) {
        result->Error("", "",
                      NimResult::getErrorResult(error.code, error.desc));
      });
}
void V2FLTSettingsService::setTeamMessageMuteMode(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  v2::V2NIMTeamMessageMuteMode muteMode;
  std::string teamId;
  v2::V2NIMTeamType teamType;
  auto iter = arguments->find(flutter::EncodableValue("teamId"));
  if (iter != arguments->end()) {
    teamId = std::get<std::string>(iter->second);
  }
  iter = arguments->find(flutter::EncodableValue("teamType"));
  if (iter != arguments->end()) {
    teamType = (v2::V2NIMTeamType)std::get<int>(iter->second);
  }
  iter = arguments->find(flutter::EncodableValue("muteMode"));
  if (iter != arguments->end()) {
    muteMode = (v2::V2NIMTeamMessageMuteMode)std::get<int>(iter->second);
  }
  auto& client = v2::V2NIMClient::get();
  auto& settingService = client.getSettingService();
  settingService.setTeamMessageMuteMode(
      teamId, teamType, muteMode,
      [=]() { result->Success(NimResult::getSuccessResult()); },
      [=](v2::V2NIMError error) {
        result->Error("", "",
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void V2FLTSettingsService::onMethodCalled(
    const std::string& method, const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (method == "getConversationMuteStatus") {
    getConversationMuteStatus(arguments, result);
  } else if (method == "getP2PMessageMuteList") {
    getP2PMessageMuteList(arguments, result);
  } else if (method == "getP2PMessageMuteMode") {
    getP2PMessageMuteMode(arguments, result);
  } else if (method == "getTeamMessageMuteMode") {
    getTeamMessageMuteMode(arguments, result);
  } else if (method == "setP2PMessageMuteMode") {
    setP2PMessageMuteMode(arguments, result);
  } else if (method == "setPushMobileOnDesktopOnline") {
    setPushMobileOnDesktopOnline(arguments, result);
  } else if (method == "setTeamMessageMuteMode") {
    setTeamMessageMuteMode(arguments, result);
  } else if (method == "setDndConfig") {
    setDndConfig(arguments, result);
  } else if (method == "getDndConfig") {
    getDndConfig(arguments, result);
  } else {
    result->NotImplemented();
  }
}
