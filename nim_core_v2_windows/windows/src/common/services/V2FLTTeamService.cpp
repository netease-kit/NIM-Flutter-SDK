// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#include "V2FLTTeamService.h"

#include <sstream>

#include "../FLTService.h"
#include "nim_cpp_wrapper/nim_cpp_api.h"
#include "v2_nim_api.hpp"
#include "v2_nim_def_enum.hpp"
#include "v2_nim_def_struct.hpp"
#include "v2_nim_team_service.hpp"

V2FLTTeamService::V2FLTTeamService() {
  m_serviceName = "TeamService";
  v2::V2NIMTeamListener listener;

  listener.onSyncStarted = [=]() {
    // team sync started
    flutter::EncodableMap arguments;
    notifyEvent("onSyncStarted", arguments);
  };
  listener.onSyncFinished = [=]() {
    // team sync finished
    flutter::EncodableMap arguments;
    notifyEvent("onSyncFinished", arguments);
  };
  listener.onSyncFailed = [=](v2::V2NIMError error) {
    // team sync failed, handle error
    flutter::EncodableMap arguments;
    flutter::EncodableMap errorMap;
    errorMap.insert(std::make_pair("code", static_cast<int>(error.code)));
    errorMap.insert(std::make_pair("desc", error.desc));
    arguments.insert(std::make_pair("error", errorMap));
    notifyEvent("onSyncFailed", arguments);
  };
  listener.onTeamCreated = [=](v2::V2NIMTeam team) {
    // team created
    flutter::EncodableMap arguments;
    convertV2NIMTeamToMap(arguments, team);
    notifyEvent("onTeamCreated", arguments);
  };
  listener.onTeamDismissed = [=](nstd::vector<v2::V2NIMTeam> teams) {
    // team dismissed
    flutter::EncodableMap result_map;
    for (auto& team : teams) {
      flutter::EncodableMap teamMap;
      convertV2NIMTeamToMap(teamMap, team);
      notifyEvent("onTeamDismissed", teamMap);
    }
  };
  listener.onTeamJoined = [=](v2::V2NIMTeam team) {
    // team joined
    flutter::EncodableMap teamMap;
    convertV2NIMTeamToMap(teamMap, team);
    notifyEvent("onTeamJoined", teamMap);
  };
  listener.onTeamLeft = [=](v2::V2NIMTeam team, bool isKicked) {
    // team left
    flutter::EncodableMap result_map;
    flutter::EncodableMap teamMap;
    convertV2NIMTeamToMap(teamMap, team);
    result_map.insert(std::make_pair("team", teamMap));
    result_map.insert(std::make_pair("isKicked", isKicked));
    notifyEvent("onTeamLeft", result_map);
  };
  listener.onTeamInfoUpdated = [=](v2::V2NIMTeam team) {
    // team info updated
    flutter::EncodableMap teamMap;
    convertV2NIMTeamToMap(teamMap, team);
    notifyEvent("onTeamInfoUpdated", teamMap);
  };
  listener.onTeamMemberJoined =
      [=](nstd::vector<v2::V2NIMTeamMember> teamMembers) {
        // team member joined
        flutter::EncodableList members;
        flutter::EncodableMap result_map;
        for (auto& member : teamMembers) {
          flutter::EncodableMap memberMap;
          convertV2NIMTeamMemberToMap(memberMap, member);
          members.emplace_back(memberMap);
        }
        result_map.insert(std::make_pair("memberList", members));
        notifyEvent("onTeamMemberJoined", result_map);
      };
  listener.onTeamMemberKicked =
      [=](nstd::string operateAccountId,
          nstd::vector<v2::V2NIMTeamMember> teamMembers) {
        // team member kicked
        flutter::EncodableList members;
        flutter::EncodableMap result_map;
        for (auto& member : teamMembers) {
          flutter::EncodableMap memberMap;
          convertV2NIMTeamMemberToMap(memberMap, member);
          members.emplace_back(memberMap);
        }
        result_map.insert(std::make_pair("memberList", members));
        result_map.insert(
            std::make_pair("operatorAccountId", operateAccountId));
        notifyEvent("onTeamMemberKicked", result_map);
      };
  listener.onTeamMemberLeft =
      [=](nstd::vector<v2::V2NIMTeamMember> teamMembers) {
        // team member left
        flutter::EncodableList members;
        flutter::EncodableMap result_map;
        for (auto& member : teamMembers) {
          flutter::EncodableMap memberMap;
          convertV2NIMTeamMemberToMap(memberMap, member);
          members.emplace_back(memberMap);
        }
        result_map.insert(std::make_pair("memberList", members));
        notifyEvent("onTeamMemberLeft", result_map);
      };
  listener.onTeamMemberInfoUpdated =
      [=](nstd::vector<v2::V2NIMTeamMember> teamMembers) {
        // team member info updated
        flutter::EncodableList members;
        flutter::EncodableMap result_map;
        for (auto& member : teamMembers) {
          flutter::EncodableMap memberMap;
          convertV2NIMTeamMemberToMap(memberMap, member);
          members.emplace_back(memberMap);
        }
        result_map.insert(std::make_pair("memberList", members));
        notifyEvent("onTeamMemberInfoUpdated", result_map);
      };
  listener.onReceiveTeamJoinActionInfo =
      [=](v2::V2NIMTeamJoinActionInfo joinActionInfo) {
        // receive team join action info
        flutter::EncodableMap result_map;
        convertV2NIMTeamJoinActionInfoToMap(result_map, joinActionInfo);
        notifyEvent("onReceiveTeamJoinActionInfo", result_map);
      };

  auto& client = v2::V2NIMClient::get();
  auto& teamService = client.getTeamService();

  teamService.addTeamListener(listener);
}

V2FLTTeamService::~V2FLTTeamService() {
  auto& client = v2::V2NIMClient::get();
  auto& teamService = client.getTeamService();
  teamService.removeTeamListener(listener);
}

void startEventListening() {}

void V2FLTTeamService::createTeam(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (arguments == NULL) {
    return;
  }

  v2::V2NIMCreateTeamParams createTeamParams;
  nstd::vector<nstd::string> inviteeAccountIds;
  v2::V2NIMAntispamConfig antispamConfig;

  auto& client = v2::V2NIMClient::get();
  auto& teamService = client.getTeamService();

  auto iter1 = arguments->begin();
  for (iter1; iter1 != arguments->end(); ++iter1) {
    if (iter1->second.IsNull()) {
      continue;
    }

    if (iter1->first == flutter::EncodableValue("inviteeAccountIds")) {
      auto inviteeAccountList = std::get<flutter::EncodableList>(iter1->second);
      for (auto& it : inviteeAccountList) {
        auto accountId = std::get<std::string>(it);
        inviteeAccountIds.push_back(accountId);
      }
    }
  }

  std::string postscript;
  auto postscriptIter = arguments->find(flutter::EncodableValue("postscript"));
  if (postscriptIter != arguments->end()) {
    if (!postscriptIter->second.IsNull()) {
      postscript = std::get<std::string>(postscriptIter->second);
    }
  }

  auto antispamConfigIter =
      arguments->find(flutter::EncodableValue("antispamConfig"));
  if (antispamConfigIter != arguments->end()) {
    auto antispamConfigParam =
        std::get<flutter::EncodableMap>(antispamConfigIter->second);

    auto options_antispam_iter = antispamConfigParam.begin();

    for (options_antispam_iter;
         options_antispam_iter != antispamConfigParam.end();
         ++options_antispam_iter) {
      if (options_antispam_iter->second.IsNull()) continue;

      if (options_antispam_iter->first ==
          flutter::EncodableValue("antispamBusinessId")) {
        antispamConfig.antispamBusinessId =
            std::get<std::string>(options_antispam_iter->second);
      }
    }
  }

  auto iter = arguments->find(flutter::EncodableValue("createTeamParams"));
  if (iter != arguments->end()) {
    if (iter->second.IsNull()) {
      result->Error("", "",
                    NimResult::getErrorResult(
                        -1, "createTeam createTeamOptions params error"));
      return;
    }

    auto createTeamParamsIter = std::get<flutter::EncodableMap>(iter->second);
    auto options_iter = createTeamParamsIter.begin();
    for (options_iter; options_iter != createTeamParamsIter.end();
         ++options_iter) {
      if (options_iter->second.IsNull()) continue;
      if (options_iter->first == flutter::EncodableValue("name")) {
        createTeamParams.name = std::get<std::string>(options_iter->second);
      } else if (options_iter->first == flutter::EncodableValue("teamType")) {
        int teamTypeInt = std::get<int>(options_iter->second);
        v2::V2NIMTeamType teamType =
            static_cast<v2::V2NIMTeamType>(teamTypeInt);
        createTeamParams.teamType = teamType;
      } else if (options_iter->first == flutter::EncodableValue("joinMode")) {
        int joinModeInt = std::get<int>(options_iter->second);
        v2::V2NIMTeamJoinMode joinMode =
            static_cast<v2::V2NIMTeamJoinMode>(joinModeInt);
        createTeamParams.joinMode = joinMode;
      } else if (options_iter->first == flutter::EncodableValue("intro")) {
        createTeamParams.intro = std::get<std::string>(options_iter->second);
      } else if (options_iter->first ==
                 flutter::EncodableValue("announcement")) {
        createTeamParams.announcement =
            std::get<std::string>(options_iter->second);
      } else if (options_iter->first ==
                 flutter::EncodableValue("serverExtension")) {
        createTeamParams.serverExtension =
            std::get<std::string>(options_iter->second);
      } else if (options_iter->first == flutter::EncodableValue("joinMode")) {
        int joinModeInt = std::get<int>(options_iter->second);
        v2::V2NIMTeamJoinMode joinMode =
            static_cast<v2::V2NIMTeamJoinMode>(joinModeInt);
        createTeamParams.joinMode = joinMode;
      } else if (options_iter->first == flutter::EncodableValue("agreeMode")) {
        int agreeModeInt = std::get<int>(options_iter->second);
        v2::V2NIMTeamAgreeMode agreeMode =
            static_cast<v2::V2NIMTeamAgreeMode>(agreeModeInt);
        createTeamParams.agreeMode = agreeMode;
      } else if (options_iter->first == flutter::EncodableValue("inviteMode")) {
        int inviteModeInt = std::get<int>(options_iter->second);
        v2::V2NIMTeamInviteMode inviteMode =
            static_cast<v2::V2NIMTeamInviteMode>(inviteModeInt);
        createTeamParams.inviteMode = inviteMode;
      } else if (options_iter->first ==
                 flutter::EncodableValue("updateInfoMode")) {
        int updateInfoModeInt = std::get<int>(options_iter->second);
        v2::V2NIMTeamUpdateInfoMode updateInfoMode =
            static_cast<v2::V2NIMTeamUpdateInfoMode>(updateInfoModeInt);
        createTeamParams.updateInfoMode = updateInfoMode;
      } else if (options_iter->first ==
                 flutter::EncodableValue("updateExtensionMode")) {
        int updateExtensionModeInt = std::get<int>(options_iter->second);
        v2::V2NIMTeamUpdateExtensionMode updateExtensionMode =
            static_cast<v2::V2NIMTeamUpdateExtensionMode>(
                updateExtensionModeInt);
        createTeamParams.updateExtensionMode = updateExtensionMode;
      } else if (options_iter->first ==
                 flutter::EncodableValue("chatBannedMode")) {
        int chatBannedModeInt = std::get<int>(options_iter->second);
        v2::V2NIMTeamChatBannedMode chatBannedMode =
            static_cast<v2::V2NIMTeamChatBannedMode>(chatBannedModeInt);
        createTeamParams.chatBannedMode = chatBannedMode;
      } else if (options_iter->first == flutter::EncodableValue("avatar")) {
        createTeamParams.avatar = std::get<std::string>(options_iter->second);
      } else if (options_iter->first ==
                 flutter::EncodableValue("memberLimit")) {
        createTeamParams.memberLimit = std::get<int>(options_iter->second);
      }
    }
  }

  teamService.createTeam(
      createTeamParams, inviteeAccountIds, postscript, antispamConfig,
      [=](v2::V2NIMCreateTeamResult teamResult) {
        flutter::EncodableMap result_map;
        convertV2NIMCreateTeamResultToMap(result_map, teamResult);
        result->Success(NimResult::getSuccessResult(result_map));
      },
      [=](v2::V2NIMError error) {
        result->Error("", "",
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void V2FLTTeamService::searchTeamByKeyword(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  std::string keyword;
  auto iter = arguments->find(flutter::EncodableValue("keyword"));
  if (iter != arguments->end()) {
    keyword = std::get<std::string>(iter->second);
  }

  auto& client = v2::V2NIMClient::get();
  auto& teamService = client.getTeamService();

  teamService.searchTeamByKeyword(
      keyword,
      [=](nstd::vector<v2::V2NIMTeam> teams) {
        // get team info success
        flutter::EncodableList teamList;
        flutter::EncodableMap result_map;
        for (auto& team : teams) {
          flutter::EncodableMap teamMap;
          convertV2NIMTeamToMap(teamMap, team);
          teamList.emplace_back(teamMap);
        }
        result_map.insert(std::make_pair("teamList", teamList));
        result->Success(NimResult::getSuccessResult(result_map));
      },
      [=](v2::V2NIMError error) {
        result->Error("", "",
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void V2FLTTeamService::dismissTeam(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  v2::V2NIMTeamType teamType;
  std::string teamId;
  auto iter = arguments->find(flutter::EncodableValue("teamId"));
  if (iter != arguments->end()) {
    teamId = std::get<std::string>(iter->second);
  }
  auto iter2 = arguments->find(flutter::EncodableValue("teamType"));
  if (iter2 != arguments->end()) {
    teamType = static_cast<v2::V2NIMTeamType>(std::get<int>(iter2->second));
  }
  auto& client = v2::V2NIMClient::get();
  auto& teamService = client.getTeamService();
  teamService.dismissTeam(
      teamId, teamType, [=] { result->Success(NimResult::getSuccessResult()); },
      [=](v2::V2NIMError error) {
        result->Error("", "",
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void V2FLTTeamService::searchTeamMembers(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  v2::V2NIMTeamMemberSearchOption option;

  auto iter = arguments->find(flutter::EncodableValue("searchOption"));
  if (iter != arguments->end()) {
    auto searchOption = std::get<flutter::EncodableMap>(iter->second);
    auto searchOptionIter = searchOption.begin();
    for (searchOptionIter; searchOptionIter != searchOption.end();
         ++searchOptionIter) {
      if (searchOptionIter->second.IsNull()) continue;
      if (searchOptionIter->first == flutter::EncodableValue("keyword")) {
        option.keyword = std::get<std::string>(searchOptionIter->second);
      } else if (searchOptionIter->first ==
                 flutter::EncodableValue("teamType")) {
        option.teamType = static_cast<v2::V2NIMTeamType>(
            std::get<int>(searchOptionIter->second));
      } else if (searchOptionIter->first == flutter::EncodableValue("teamId")) {
        option.teamId = std::get<std::string>(searchOptionIter->second);
      } else if (searchOptionIter->first ==
                 flutter::EncodableValue("nextToken")) {
        option.nextToken = std::get<std::string>(searchOptionIter->second);
      } else if (searchOptionIter->first == flutter::EncodableValue("order")) {
        option.order = static_cast<v2::V2NIMSortOrder>(
            std::get<int>(searchOptionIter->second));
      } else if (searchOptionIter->first == flutter::EncodableValue("limit")) {
        option.limit = std::get<int>(searchOptionIter->second);
      }
    }
  }

  auto& client = v2::V2NIMClient::get();
  auto& teamService = client.getTeamService();
  teamService.searchTeamMembers(
      option,
      [=](v2::V2NIMTeamMemberListResult listResult) {
        flutter::EncodableMap result_map;
        convertV2NIMTeamMemberListResultToMap(result_map, listResult);
        result->Success(NimResult::getSuccessResult(result_map));
      },
      [=](v2::V2NIMError error) {
        // search team members failed, handle error
        result->Error("", "",
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void V2FLTTeamService::getTeamMemberInvitor(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  std::string teamId;
  v2::V2NIMTeamType teamType;
  nstd::vector<nstd::string> accountIds;
  auto iter = arguments->find(flutter::EncodableValue("teamId"));
  if (iter != arguments->end()) {
    teamId = std::get<std::string>(iter->second);
  }
  auto iter2 = arguments->find(flutter::EncodableValue("teamType"));
  if (iter2 != arguments->end()) {
    teamType = static_cast<v2::V2NIMTeamType>(std::get<int>(iter2->second));
  }
  auto iter3 = arguments->find(flutter::EncodableValue("accountIds"));
  if (iter3 != arguments->end()) {
    auto accountIdsParam = std::get<flutter::EncodableList>(iter3->second);
    for (auto& accountId : accountIdsParam) {
      accountIds.push_back(std::get<std::string>(accountId));
    }
  }
  auto& client = v2::V2NIMClient::get();
  auto& teamService = client.getTeamService();
  teamService.getTeamMemberInvitor(
      teamId, teamType, accountIds,
      [=](nstd::map<nstd::string, nstd::string> invitors) {
        // get team member invitor success
        flutter::EncodableMap result_map;
        for (auto& invitor : invitors) {
          result_map.insert(std::make_pair(invitor.first, invitor.second));
        }
        result->Success(NimResult::getSuccessResult(result_map));
      },
      [=](v2::V2NIMError error) {
        // get team member invitor failed, handle error
        result->Error("", "",
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void V2FLTTeamService::getTeamJoinActionInfoList(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  v2::V2NIMTeamJoinActionInfoQueryOption option;
  auto iter = arguments->find(flutter::EncodableValue("queryOption"));
  if (iter != arguments->end()) {
    auto queryOption = std::get<flutter::EncodableMap>(iter->second);
    auto queryOptionIter = queryOption.begin();
    for (queryOptionIter; queryOptionIter != queryOption.end();
         ++queryOptionIter) {
      if (queryOptionIter->second.IsNull()) continue;
      if (queryOptionIter->first == flutter::EncodableValue("offset")) {
        option.offset = std::get<int>(queryOptionIter->second);
      } else if (queryOptionIter->first == flutter::EncodableValue("limit")) {
        option.limit = std::get<int>(queryOptionIter->second);
      } else if (queryOptionIter->first == flutter::EncodableValue("types")) {
        auto types = std::get<flutter::EncodableList>(queryOptionIter->second);
        for (auto& type : types) {
          option.types.push_back(
              static_cast<v2::V2NIMTeamJoinActionType>(std::get<int>(type)));
        }
      } else if (queryOptionIter->first == flutter::EncodableValue("status")) {
        auto statuss =
            std::get<flutter::EncodableList>(queryOptionIter->second);
        for (auto& status : statuss) {
          option.status.push_back(static_cast<v2::V2NIMTeamJoinActionStatus>(
              std::get<int>(status)));
        }
      }
    }
  }

  auto& client = v2::V2NIMClient::get();
  auto& teamService = client.getTeamService();
  teamService.getTeamJoinActionInfoList(
      option,
      [=](v2::V2NIMTeamJoinActionInfoResult infoResult) {
        // get team join action info list success
        flutter::EncodableMap result_map;
        convertV2NIMTeamJoinActionInfoResultToMap(result_map, infoResult);
        result->Success(NimResult::getSuccessResult(result_map));
      },
      [=](v2::V2NIMError error) {
        // get team join action info list failed, handle error
        result->Error("", "",
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void V2FLTTeamService::getTeamMemberListByIds(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  std::string teamId;
  v2::V2NIMTeamType teamType;
  nstd::vector<nstd::string> accountIds;
  auto iter = arguments->find(flutter::EncodableValue("teamId"));
  if (iter != arguments->end()) {
    teamId = std::get<std::string>(iter->second);
  }
  auto iter2 = arguments->find(flutter::EncodableValue("teamType"));
  if (iter2 != arguments->end()) {
    teamType = static_cast<v2::V2NIMTeamType>(std::get<int>(iter2->second));
  }
  auto iter3 = arguments->find(flutter::EncodableValue("accountIds"));
  if (iter3 != arguments->end()) {
    auto accountIdsParam = std::get<flutter::EncodableList>(iter3->second);
    for (auto& accountId : accountIdsParam) {
      accountIds.push_back(std::get<std::string>(accountId));
    }
  }
  auto& client = v2::V2NIMClient::get();
  auto& teamService = client.getTeamService();
  teamService.getTeamMemberListByIds(
      teamId, teamType, accountIds,
      [=](nstd::vector<v2::V2NIMTeamMember> teamMembers) {
        // get team member list success
        flutter::EncodableList members;
        flutter::EncodableMap result_map;
        for (auto& member : teamMembers) {
          flutter::EncodableMap memberMap;
          convertV2NIMTeamMemberToMap(memberMap, member);
          members.emplace_back(memberMap);
        }
        result_map.insert(std::make_pair("memberList", members));
        result->Success(NimResult::getSuccessResult(result_map));
      },
      [=](v2::V2NIMError error) {
        result->Error("", "",
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void V2FLTTeamService::getTeamInfoByIds(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  nstd::vector<nstd::string> teamIds;
  v2::V2NIMTeamType teamType;
  auto iter = arguments->find(flutter::EncodableValue("teamIds"));
  if (iter != arguments->end()) {
    auto teamIdsParam = std::get<flutter::EncodableList>(iter->second);
    for (auto& teamId : teamIdsParam) {
      teamIds.push_back(std::get<std::string>(teamId));
    }
  }
  auto iter2 = arguments->find(flutter::EncodableValue("teamType"));
  if (iter2 != arguments->end()) {
    teamType = static_cast<v2::V2NIMTeamType>(std::get<int>(iter2->second));
  }
  auto& client = v2::V2NIMClient::get();
  auto& teamService = client.getTeamService();
  teamService.getTeamInfoByIds(
      teamIds, teamType,
      [=](nstd::vector<v2::V2NIMTeam> teams) {
        // get team info success
        flutter::EncodableList teamList;
        flutter::EncodableMap result_map;
        for (auto& team : teams) {
          flutter::EncodableMap teamMap;
          convertV2NIMTeamToMap(teamMap, team);
          teamList.emplace_back(teamMap);
        }
        result_map.insert(std::make_pair("teamList", teamList));
        result->Success(NimResult::getSuccessResult(result_map));
      },
      [=](v2::V2NIMError error) {
        // get team info failed, handle error
        result->Error("", "",
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void V2FLTTeamService::getTeamInfo(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  std::string teamId;
  v2::V2NIMTeamType teamType;
  auto iter = arguments->find(flutter::EncodableValue("teamId"));
  if (iter != arguments->end()) {
    teamId = std::get<std::string>(iter->second);
  }
  auto iter2 = arguments->find(flutter::EncodableValue("teamType"));
  if (iter2 != arguments->end()) {
    teamType = static_cast<v2::V2NIMTeamType>(std::get<int>(iter2->second));
  }
  auto& client = v2::V2NIMClient::get();
  auto& teamService = client.getTeamService();
  teamService.getTeamInfo(
      teamId, teamType,
      [=](v2::V2NIMTeam team) {
        // get team info success
        flutter::EncodableMap result_map;
        convertV2NIMTeamToMap(result_map, team);
        result->Success(NimResult::getSuccessResult(result_map));
      },
      [=](v2::V2NIMError error) {
        // get team info failed, handle error
        result->Error("", "",
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void V2FLTTeamService::leaveTeam(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  std::string teamId;
  v2::V2NIMTeamType teamType;
  auto iter = arguments->find(flutter::EncodableValue("teamId"));
  if (iter != arguments->end()) {
    teamId = std::get<std::string>(iter->second);
  }
  auto iter2 = arguments->find(flutter::EncodableValue("teamType"));
  if (iter2 != arguments->end()) {
    teamType = static_cast<v2::V2NIMTeamType>(std::get<int>(iter2->second));
  }
  auto& client = v2::V2NIMClient::get();
  auto& teamService = client.getTeamService();
  teamService.leaveTeam(
      teamId, teamType, [=] { result->Success(NimResult::getSuccessResult()); },
      [=](v2::V2NIMError error) {
        result->Error("", "",
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void V2FLTTeamService::updateTeam(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  std::string teamId;
  v2::V2NIMTeamType teamType;
  v2::V2NIMUpdateTeamInfoParams updateTeamParams;
  v2::V2NIMAntispamConfig antispamConfig;
  auto iter = arguments->find(flutter::EncodableValue("teamId"));
  if (iter != arguments->end()) {
    teamId = std::get<std::string>(iter->second);
  }
  auto iter2 = arguments->find(flutter::EncodableValue("teamType"));
  if (iter2 != arguments->end()) {
    teamType = static_cast<v2::V2NIMTeamType>(std::get<int>(iter2->second));
  }
  auto iter3 = arguments->find(flutter::EncodableValue("updateTeamInfoParams"));
  if (iter3 != arguments->end()) {
    auto updateTeamParamsParam = std::get<flutter::EncodableMap>(iter3->second);
    auto updateTeamParamsIter = updateTeamParamsParam.begin();
    for (updateTeamParamsIter;
         updateTeamParamsIter != updateTeamParamsParam.end();
         ++updateTeamParamsIter) {
      if (updateTeamParamsIter->second.IsNull()) continue;
      if (updateTeamParamsIter->first == flutter::EncodableValue("name")) {
        updateTeamParams.name =
            std::get<std::string>(updateTeamParamsIter->second);
      } else if (updateTeamParamsIter->first ==
                 flutter::EncodableValue("memberLimit")) {
        updateTeamParams.memberLimit =
            std::get<int>(updateTeamParamsIter->second);
      } else if (updateTeamParamsIter->first ==
                 flutter::EncodableValue("intro")) {
        updateTeamParams.intro =
            std::get<std::string>(updateTeamParamsIter->second);
      } else if (updateTeamParamsIter->first ==
                 flutter::EncodableValue("announcement")) {
        updateTeamParams.announcement =
            std::get<std::string>(updateTeamParamsIter->second);
      } else if (updateTeamParamsIter->first ==
                 flutter::EncodableValue("avatar")) {
        updateTeamParams.avatar =
            std::get<std::string>(updateTeamParamsIter->second);
      } else if (updateTeamParamsIter->first ==
                 flutter::EncodableValue("serverExtension")) {
        updateTeamParams.serverExtension =
            std::get<std::string>(updateTeamParamsIter->second);
      } else if (updateTeamParamsIter->first ==
                 flutter::EncodableValue("joinMode")) {
        int joinModeInt = std::get<int>(updateTeamParamsIter->second);
        v2::V2NIMTeamJoinMode joinMode =
            static_cast<v2::V2NIMTeamJoinMode>(joinModeInt);
        updateTeamParams.joinMode = joinMode;
      } else if (updateTeamParamsIter->first ==
                 flutter::EncodableValue("agreeMode")) {
        v2::V2NIMTeamAgreeMode agreeMode = static_cast<v2::V2NIMTeamAgreeMode>(
            std::get<int>(updateTeamParamsIter->second));
        updateTeamParams.agreeMode = agreeMode;
      } else if (updateTeamParamsIter->first ==
                 flutter::EncodableValue("inviteMode")) {
        v2::V2NIMTeamInviteMode inviteMode =
            static_cast<v2::V2NIMTeamInviteMode>(
                std::get<int>(updateTeamParamsIter->second));
        updateTeamParams.inviteMode = inviteMode;
      } else if (updateTeamParamsIter->first ==
                 flutter::EncodableValue("updateInfoMode")) {
        v2::V2NIMTeamUpdateInfoMode updateInfoMode =
            static_cast<v2::V2NIMTeamUpdateInfoMode>(
                std::get<int>(updateTeamParamsIter->second));
        updateTeamParams.updateInfoMode = updateInfoMode;
      } else if (updateTeamParamsIter->first ==
                 flutter::EncodableValue("updateExtensionMode")) {
        v2::V2NIMTeamUpdateExtensionMode updateExtensionMode =
            static_cast<v2::V2NIMTeamUpdateExtensionMode>(
                std::get<int>(updateTeamParamsIter->second));
        updateTeamParams.updateExtensionMode = updateExtensionMode;
      }
    }
  }
  auto iter4 = arguments->find(flutter::EncodableValue("antispamConfig"));
  if (iter4 != arguments->end()) {
    auto antispamConfigParam = std::get<flutter::EncodableMap>(iter4->second);
    auto antispamConfigIter = antispamConfigParam.begin();
    for (antispamConfigIter; antispamConfigIter != antispamConfigParam.end();
         ++antispamConfigIter) {
      if (antispamConfigIter->second.IsNull()) continue;
      if (antispamConfigIter->first ==
          flutter::EncodableValue("antispamBusinessId")) {
        antispamConfig.antispamBusinessId =
            std::get<std::string>(antispamConfigIter->second);
      }
    }
  }

  auto& client = v2::V2NIMClient::get();
  auto& teamService = client.getTeamService();
  teamService.updateTeamInfo(
      teamId, teamType, updateTeamParams, antispamConfig,
      [=] { result->Success(NimResult::getSuccessResult()); },
      [=](v2::V2NIMError error) {
        result->Error("", "",
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void V2FLTTeamService::inviteMember(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  std::string teamId;
  v2::V2NIMTeamType teamType;
  nstd::vector<nstd::string> inviteeAccountIds;
  std::string postscript;

  auto iter = arguments->find(flutter::EncodableValue("teamId"));
  if (iter != arguments->end()) {
    teamId = std::get<std::string>(iter->second);
  }
  auto iter2 = arguments->find(flutter::EncodableValue("teamType"));
  if (iter2 != arguments->end()) {
    teamType = static_cast<v2::V2NIMTeamType>(std::get<int>(iter2->second));
  }
  auto iter3 = arguments->find(flutter::EncodableValue("inviteeAccountIds"));
  if (iter3 != arguments->end()) {
    auto inviteeAccountIdsParam =
        std::get<flutter::EncodableList>(iter3->second);
    for (auto& accountId : inviteeAccountIdsParam) {
      inviteeAccountIds.push_back(std::get<std::string>(accountId));
    }
  }
  auto iter4 = arguments->find(flutter::EncodableValue("postscript"));
  if (iter4 != arguments->end()) {
    postscript = std::get<std::string>(iter4->second);
  }

  auto& client = v2::V2NIMClient::get();
  auto& teamService = client.getTeamService();
  teamService.inviteMember(
      teamId, teamType, inviteeAccountIds, postscript,
      [=](nstd::vector<nstd::string> vertors) {
        flutter::EncodableList result_list;
        for (auto& vector : vertors) {
          result_list.emplace_back(vector);
        }
        flutter::EncodableMap result_map;
        result_map.insert(std::make_pair("failedList", result_list));
        result->Success(NimResult::getSuccessResult(result_map));
      },
      [=](v2::V2NIMError error) {
        result->Error("", "",
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void V2FLTTeamService::acceptInvitation(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  v2::V2NIMTeamJoinActionInfo invitationInfo;
  auto iter = arguments->find(flutter::EncodableValue("invitationInfo"));
  if (iter != arguments->end()) {
    auto invitationInfoParam = std::get<flutter::EncodableMap>(iter->second);
    auto invitationInfoIter = invitationInfoParam.begin();
    for (invitationInfoIter; invitationInfoIter != invitationInfoParam.end();
         ++invitationInfoIter) {
      if (invitationInfoIter->second.IsNull()) continue;
      if (invitationInfoIter->first == flutter::EncodableValue("teamId")) {
        invitationInfo.teamId =
            std::get<std::string>(invitationInfoIter->second);
      } else if (invitationInfoIter->first ==
                 flutter::EncodableValue("teamType")) {
        invitationInfo.teamType = static_cast<v2::V2NIMTeamType>(
            std::get<int>(invitationInfoIter->second));
      } else if (invitationInfoIter->first ==
                 flutter::EncodableValue("operatorAccountId")) {
        invitationInfo.operatorAccountId =
            std::get<std::string>(invitationInfoIter->second);
      } else if (invitationInfoIter->first ==
                 flutter::EncodableValue("postscript")) {
        invitationInfo.postscript =
            std::get<std::string>(invitationInfoIter->second);
      } else if (invitationInfoIter->first ==
                 flutter::EncodableValue("actionStatus")) {
        invitationInfo.actionStatus =
            static_cast<v2::V2NIMTeamJoinActionStatus>(
                std::get<int>(invitationInfoIter->second));
      } else if (invitationInfoIter->first ==
                 flutter::EncodableValue("timestamp")) {
        invitationInfo.timestamp = invitationInfoIter->second.LongValue();
      } else if (invitationInfoIter->first ==
                 flutter::EncodableValue("actionType")) {
        invitationInfo.actionType = static_cast<v2::V2NIMTeamJoinActionType>(
            std::get<int>(invitationInfoIter->second));
      }
    }
  }

  auto& client = v2::V2NIMClient::get();
  auto& teamService = client.getTeamService();
  teamService.acceptInvitation(
      invitationInfo,
      [=](v2::V2NIMTeam team) {
        flutter::EncodableMap result_map;
        convertV2NIMTeamToMap(result_map, team);
        result->Success(NimResult::getSuccessResult(result_map));
      },
      [=](v2::V2NIMError error) {
        result->Error("", "",
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void V2FLTTeamService::rejectInvitation(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  v2::V2NIMTeamJoinActionInfo invitationInfo;
  std::string postscript;
  auto iter = arguments->find(flutter::EncodableValue("invitationInfo"));
  if (iter != arguments->end()) {
    auto invitationInfoParam = std::get<flutter::EncodableMap>(iter->second);
    auto invitationInfoIter = invitationInfoParam.begin();
    for (invitationInfoIter; invitationInfoIter != invitationInfoParam.end();
         ++invitationInfoIter) {
      if (invitationInfoIter->second.IsNull()) continue;
      if (invitationInfoIter->first == flutter::EncodableValue("teamId")) {
        invitationInfo.teamId =
            std::get<std::string>(invitationInfoIter->second);
      } else if (invitationInfoIter->first ==
                 flutter::EncodableValue("teamType")) {
        invitationInfo.teamType = static_cast<v2::V2NIMTeamType>(
            std::get<int>(invitationInfoIter->second));
      } else if (invitationInfoIter->first ==
                 flutter::EncodableValue("operatorAccountId")) {
        invitationInfo.operatorAccountId =
            std::get<std::string>(invitationInfoIter->second);
      } else if (invitationInfoIter->first ==
                 flutter::EncodableValue("postscript")) {
        invitationInfo.postscript =
            std::get<std::string>(invitationInfoIter->second);
      } else if (invitationInfoIter->first ==
                 flutter::EncodableValue("actionStatus")) {
        invitationInfo.actionStatus =
            static_cast<v2::V2NIMTeamJoinActionStatus>(
                std::get<int>(invitationInfoIter->second));
      } else if (invitationInfoIter->first ==
                 flutter::EncodableValue("actionType")) {
        invitationInfo.actionType = static_cast<v2::V2NIMTeamJoinActionType>(
            std::get<int>(invitationInfoIter->second));
      } else if (invitationInfoIter->first ==
                 flutter::EncodableValue("timestamp")) {
        invitationInfo.timestamp = invitationInfoIter->second.LongValue();
      }
    }
  }
  auto iter2 = arguments->find(flutter::EncodableValue("postscript"));
  if (iter2 != arguments->end()) {
    postscript = std::get<std::string>(iter2->second);
  }
  auto& client = v2::V2NIMClient::get();
  auto& teamService = client.getTeamService();

  teamService.rejectInvitation(
      invitationInfo, postscript,
      [=] { result->Success(NimResult::getSuccessResult()); },
      [=](v2::V2NIMError error) {
        result->Error("", "",
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void V2FLTTeamService::kickMember(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  std::string teamId;
  v2::V2NIMTeamType teamType;
  nstd::vector<nstd::string> memberAccountIds;
  auto iter = arguments->find(flutter::EncodableValue("teamId"));
  if (iter != arguments->end()) {
    teamId = std::get<std::string>(iter->second);
  }
  auto iter2 = arguments->find(flutter::EncodableValue("teamType"));
  if (iter2 != arguments->end()) {
    teamType = static_cast<v2::V2NIMTeamType>(std::get<int>(iter2->second));
  }

  auto iter4 = arguments->find(flutter::EncodableValue("memberAccountIds"));
  if (iter4 != arguments->end()) {
    auto memberAccountIdList = std::get<flutter::EncodableList>(iter4->second);
    for (auto& accountId : memberAccountIdList) {
      memberAccountIds.push_back(std::get<std::string>(accountId));
    }
  }

  auto& client = v2::V2NIMClient::get();
  auto& teamService = client.getTeamService();
  teamService.kickMember(
      teamId, teamType, memberAccountIds,
      [=] { result->Success(NimResult::getSuccessResult()); },
      [=](v2::V2NIMError error) {
        result->Error("", "",
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void V2FLTTeamService::applyJoinTeam(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  std::string teamId;
  v2::V2NIMTeamType teamType;
  std::string postscript;
  auto iter = arguments->find(flutter::EncodableValue("teamId"));
  if (iter != arguments->end()) {
    teamId = std::get<std::string>(iter->second);
  }
  auto iter2 = arguments->find(flutter::EncodableValue("teamType"));
  if (iter2 != arguments->end()) {
    teamType = static_cast<v2::V2NIMTeamType>(std::get<int>(iter2->second));
  }
  auto iter3 = arguments->find(flutter::EncodableValue("postscript"));
  if (iter3 != arguments->end()) {
    postscript = std::get<std::string>(iter3->second);
  }
  auto& client = v2::V2NIMClient::get();
  auto& teamService = client.getTeamService();
  teamService.applyJoinTeam(
      teamId, teamType, postscript,
      [=](v2::V2NIMTeam team) {
        flutter::EncodableMap result_map;
        convertV2NIMTeamToMap(result_map, team);
        result->Success(NimResult::getSuccessResult(result_map));
      },
      [=](v2::V2NIMError error) {
        result->Error("", "",
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void V2FLTTeamService::acceptJoinApplication(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  v2::V2NIMTeamJoinActionInfo joinInfo;
  auto iter = arguments->find(flutter::EncodableValue("joinInfo"));
  if (iter != arguments->end()) {
    auto joinInfoParam = std::get<flutter::EncodableMap>(iter->second);
    auto joinInfoIter = joinInfoParam.begin();
    for (joinInfoIter; joinInfoIter != joinInfoParam.end(); ++joinInfoIter) {
      if (joinInfoIter->second.IsNull()) continue;
      if (joinInfoIter->first == flutter::EncodableValue("teamId")) {
        joinInfo.teamId = std::get<std::string>(joinInfoIter->second);
      } else if (joinInfoIter->first == flutter::EncodableValue("teamType")) {
        joinInfo.teamType =
            static_cast<v2::V2NIMTeamType>(std::get<int>(joinInfoIter->second));
      } else if (joinInfoIter->first ==
                 flutter::EncodableValue("operatorAccountId")) {
        joinInfo.operatorAccountId =
            std::get<std::string>(joinInfoIter->second);
      } else if (joinInfoIter->first == flutter::EncodableValue("postscript")) {
        joinInfo.postscript = std::get<std::string>(joinInfoIter->second);
      } else if (joinInfoIter->first ==
                 flutter::EncodableValue("actionStatus")) {
        joinInfo.actionStatus = static_cast<v2::V2NIMTeamJoinActionStatus>(
            std::get<int>(joinInfoIter->second));
      } else if (joinInfoIter->first == flutter::EncodableValue("actionType")) {
        joinInfo.actionType = static_cast<v2::V2NIMTeamJoinActionType>(
            std::get<int>(joinInfoIter->second));
      } else if (joinInfoIter->first == flutter::EncodableValue("timestamp")) {
        joinInfo.timestamp = joinInfoIter->second.LongValue();
      }
    }
  }
  auto& client = v2::V2NIMClient::get();
  auto& teamService = client.getTeamService();
  teamService.acceptJoinApplication(
      joinInfo, [=] { result->Success(NimResult::getSuccessResult()); },
      [=](v2::V2NIMError error) {
        result->Error("", "",
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void V2FLTTeamService::rejectJoinApplication(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  v2::V2NIMTeamJoinActionInfo joinInfo;
  std::string postscript;
  auto iter = arguments->find(flutter::EncodableValue("joinInfo"));
  if (iter != arguments->end()) {
    auto joinInfoParam = std::get<flutter::EncodableMap>(iter->second);
    auto joinInfoIter = joinInfoParam.begin();
    for (joinInfoIter; joinInfoIter != joinInfoParam.end(); ++joinInfoIter) {
      if (joinInfoIter->second.IsNull()) continue;
      if (joinInfoIter->first == flutter::EncodableValue("teamId")) {
        joinInfo.teamId = std::get<std::string>(joinInfoIter->second);
      } else if (joinInfoIter->first == flutter::EncodableValue("teamType")) {
        joinInfo.teamType =
            static_cast<v2::V2NIMTeamType>(std::get<int>(joinInfoIter->second));
      } else if (joinInfoIter->first ==
                 flutter::EncodableValue("operatorAccountId")) {
        joinInfo.operatorAccountId =
            std::get<std::string>(joinInfoIter->second);
      } else if (joinInfoIter->first == flutter::EncodableValue("postscript")) {
        joinInfo.postscript = std::get<std::string>(joinInfoIter->second);
      } else if (joinInfoIter->first ==
                 flutter::EncodableValue("actionStatus")) {
        joinInfo.actionStatus = static_cast<v2::V2NIMTeamJoinActionStatus>(
            std::get<int>(joinInfoIter->second));
      } else if (joinInfoIter->first == flutter::EncodableValue("actionType")) {
        joinInfo.actionType = static_cast<v2::V2NIMTeamJoinActionType>(
            std::get<int>(joinInfoIter->second));
      } else if (joinInfoIter->first == flutter::EncodableValue("timestamp")) {
        joinInfo.timestamp = joinInfoIter->second.LongValue();
      }
    }
  }
  auto iter2 = arguments->find(flutter::EncodableValue("postscript"));
  if (iter2 != arguments->end()) {
    postscript = std::get<std::string>(iter2->second);
  }
  auto& client = v2::V2NIMClient::get();
  auto& teamService = client.getTeamService();
  teamService.rejectJoinApplication(
      joinInfo, postscript,
      [=] { result->Success(NimResult::getSuccessResult()); },
      [=](v2::V2NIMError error) {
        result->Error("", "",
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void V2FLTTeamService::updateTeamMemberRole(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  std::string teamId;
  v2::V2NIMTeamType teamType;
  nstd::vector<nstd::string> memberAccountIds;
  v2::V2NIMTeamMemberRole memberRole;
  auto iter = arguments->find(flutter::EncodableValue("teamId"));
  if (iter != arguments->end()) {
    teamId = std::get<std::string>(iter->second);
  }
  auto iter2 = arguments->find(flutter::EncodableValue("teamType"));
  if (iter2 != arguments->end()) {
    teamType = static_cast<v2::V2NIMTeamType>(std::get<int>(iter2->second));
  }
  auto iter3 = arguments->find(flutter::EncodableValue("memberAccountIds"));
  if (iter3 != arguments->end()) {
    auto memberAccountIdList = std::get<flutter::EncodableList>(iter3->second);
    for (auto& accountId : memberAccountIdList) {
      memberAccountIds.push_back(std::get<std::string>(accountId));
    }
  }
  auto iter4 = arguments->find(flutter::EncodableValue("memberRole"));
  if (iter4 != arguments->end()) {
    memberRole =
        static_cast<v2::V2NIMTeamMemberRole>(std::get<int>(iter4->second));
  }
  auto& client = v2::V2NIMClient::get();
  auto& teamService = client.getTeamService();
  teamService.updateTeamMemberRole(
      teamId, teamType, memberAccountIds, memberRole,
      [=] { result->Success(NimResult::getSuccessResult()); },
      [=](v2::V2NIMError error) {
        result->Error("", "",
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void V2FLTTeamService::transferTeamOwner(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  std::string teamId;
  v2::V2NIMTeamType teamType;
  std::string accountId;
  bool isLeave;
  auto iter = arguments->find(flutter::EncodableValue("teamId"));
  if (iter != arguments->end()) {
    teamId = std::get<std::string>(iter->second);
  }
  auto iter2 = arguments->find(flutter::EncodableValue("teamType"));
  if (iter2 != arguments->end()) {
    teamType = static_cast<v2::V2NIMTeamType>(std::get<int>(iter2->second));
  }
  auto iter3 = arguments->find(flutter::EncodableValue("accountId"));
  if (iter3 != arguments->end()) {
    accountId = std::get<std::string>(iter3->second);
  }
  auto iter4 = arguments->find(flutter::EncodableValue("leave"));
  if (iter4 != arguments->end()) {
    isLeave = std::get<bool>(iter4->second);
  }
  auto& client = v2::V2NIMClient::get();
  auto& teamService = client.getTeamService();
  teamService.transferTeamOwner(
      teamId, teamType, accountId, isLeave,
      [=] { result->Success(NimResult::getSuccessResult()); },
      [=](v2::V2NIMError error) {
        result->Error("", "",
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void V2FLTTeamService::updateSelfTeamMemberInfo(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  std::string teamId;
  v2::V2NIMTeamType teamType;
  v2::V2NIMUpdateSelfMemberInfoParams updateTeamMemberInfoParams;
  auto iter = arguments->find(flutter::EncodableValue("teamId"));
  if (iter != arguments->end()) {
    teamId = std::get<std::string>(iter->second);
  }
  auto iter2 = arguments->find(flutter::EncodableValue("teamType"));
  if (iter2 != arguments->end()) {
    teamType = static_cast<v2::V2NIMTeamType>(std::get<int>(iter2->second));
  }
  auto iter3 = arguments->find(flutter::EncodableValue("memberInfoParams"));
  if (iter3 != arguments->end()) {
    auto updateTeamMemberInfoParamsParam =
        std::get<flutter::EncodableMap>(iter3->second);
    auto updateTeamMemberInfoParamsIter =
        updateTeamMemberInfoParamsParam.begin();
    for (updateTeamMemberInfoParamsIter; updateTeamMemberInfoParamsIter !=
                                         updateTeamMemberInfoParamsParam.end();
         ++updateTeamMemberInfoParamsIter) {
      if (updateTeamMemberInfoParamsIter->second.IsNull()) continue;
      if (updateTeamMemberInfoParamsIter->first ==
          flutter::EncodableValue("teamNick")) {
        updateTeamMemberInfoParams.teamNick =
            std::get<std::string>(updateTeamMemberInfoParamsIter->second);
      } else if (updateTeamMemberInfoParamsIter->first ==
                 flutter::EncodableValue("serverExtension")) {
        updateTeamMemberInfoParams.serverExtension =
            std::get<std::string>(updateTeamMemberInfoParamsIter->second);
      }
    }
  }
  auto& client = v2::V2NIMClient::get();
  auto& teamService = client.getTeamService();
  teamService.updateSelfTeamMemberInfo(
      teamId, teamType, updateTeamMemberInfoParams,
      [=] { result->Success(NimResult::getSuccessResult()); },
      [=](v2::V2NIMError error) {
        result->Error("", "",
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void V2FLTTeamService::updateTeamMemberNick(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  std::string teamId;
  v2::V2NIMTeamType teamType;
  std::string accountId;
  std::string teamNick;
  auto iter = arguments->find(flutter::EncodableValue("teamId"));
  if (iter != arguments->end()) {
    teamId = std::get<std::string>(iter->second);
  }
  auto iter2 = arguments->find(flutter::EncodableValue("teamType"));
  if (iter2 != arguments->end()) {
    teamType = static_cast<v2::V2NIMTeamType>(std::get<int>(iter2->second));
  }
  auto iter3 = arguments->find(flutter::EncodableValue("accountId"));

  if (iter3 != arguments->end()) {
    accountId = std::get<std::string>(iter3->second);
  }
  auto iter4 = arguments->find(flutter::EncodableValue("teamNick"));
  if (iter4 != arguments->end()) {
    teamNick = std::get<std::string>(iter4->second);
  }

  auto& client = v2::V2NIMClient::get();
  auto& teamService = client.getTeamService();
  teamService.updateTeamMemberNick(
      teamId, teamType, accountId, teamNick,
      [=] { result->Success(NimResult::getSuccessResult()); },
      [=](v2::V2NIMError error) {
        result->Error("", "",
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void V2FLTTeamService::setTeamChatBannedMode(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  std::string teamId;
  v2::V2NIMTeamType teamType;
  v2::V2NIMTeamChatBannedMode chatBannedMode;
  auto iter = arguments->find(flutter::EncodableValue("teamId"));
  if (iter != arguments->end()) {
    teamId = std::get<std::string>(iter->second);
  }
  auto iter2 = arguments->find(flutter::EncodableValue("teamType"));
  if (iter2 != arguments->end()) {
    teamType = static_cast<v2::V2NIMTeamType>(std::get<int>(iter2->second));
  }
  auto iter3 = arguments->find(flutter::EncodableValue("chatBannedMode"));
  if (iter3 != arguments->end()) {
    chatBannedMode =
        static_cast<v2::V2NIMTeamChatBannedMode>(std::get<int>(iter3->second));
  }
  auto& client = v2::V2NIMClient::get();
  auto& teamService = client.getTeamService();
  teamService.setTeamChatBannedMode(
      teamId, teamType, chatBannedMode,
      [=] { result->Success(NimResult::getSuccessResult()); },
      [=](v2::V2NIMError error) {
        result->Error("", "",
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void V2FLTTeamService::setTeamMemberChatBannedStatus(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  std::string teamId;
  v2::V2NIMTeamType teamType;
  std::string accountId;
  bool chatBanned;
  auto iter = arguments->find(flutter::EncodableValue("teamId"));
  if (iter != arguments->end()) {
    teamId = std::get<std::string>(iter->second);
  }
  auto iter2 = arguments->find(flutter::EncodableValue("teamType"));
  if (iter2 != arguments->end()) {
    teamType = static_cast<v2::V2NIMTeamType>(std::get<int>(iter2->second));
  }
  auto iter3 = arguments->find(flutter::EncodableValue("accountId"));
  if (iter3 != arguments->end()) {
    accountId = std::get<std::string>(iter3->second);
  }
  auto iter4 = arguments->find(flutter::EncodableValue("chatBanned"));
  if (iter4 != arguments->end()) {
    chatBanned = std::get<bool>(iter4->second);
  }
  auto& client = v2::V2NIMClient::get();
  auto& teamService = client.getTeamService();
  teamService.setTeamMemberChatBannedStatus(
      teamId, teamType, accountId, chatBanned,
      [=] { result->Success(NimResult::getSuccessResult()); },
      [=](v2::V2NIMError error) {
        result->Error("", "",
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void V2FLTTeamService::getJoinedTeamList(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  nstd::vector<v2::V2NIMTeamType> types;
  auto iter = arguments->find(flutter::EncodableValue("teamTypes"));
  if (iter != arguments->end()) {
    auto typesParam = std::get<flutter::EncodableList>(iter->second);
    for (auto& type : typesParam) {
      types.push_back(static_cast<v2::V2NIMTeamType>(std::get<int>(type)));
    }
  }
  auto& client = v2::V2NIMClient::get();
  auto& teamService = client.getTeamService();
  teamService.getJoinedTeamList(
      types,
      [=](nstd::vector<v2::V2NIMTeam> teams) {
        flutter::EncodableList result_list;
        flutter::EncodableMap result_map;
        for (auto& team : teams) {
          flutter::EncodableMap team_map;
          convertV2NIMTeamToMap(team_map, team);
          result_list.emplace_back(team_map);
        }
        result_map.insert(std::make_pair("teamList", result_list));
        result->Success(NimResult::getSuccessResult(result_map));
      },
      [=](v2::V2NIMError error) {
        result->Error("", "",
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void V2FLTTeamService::getJoinedTeamCount(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  nstd::vector<v2::V2NIMTeamType> types;
  auto iter = arguments->find(flutter::EncodableValue("teamTypes"));
  if (iter != arguments->end()) {
    auto typesParam = std::get<flutter::EncodableList>(iter->second);
    for (auto& type : typesParam) {
      types.push_back(static_cast<v2::V2NIMTeamType>(std::get<int>(type)));
    }
  }
  auto& client = v2::V2NIMClient::get();
  auto& teamService = client.getTeamService();
  int count = teamService.getJoinedTeamCount(types);
  result->Success(NimResult::getSuccessResult(count));
}

void V2FLTTeamService::getTeamMemberList(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  std::string teamId;
  v2::V2NIMTeamType teamType;
  v2::V2NIMTeamMemberQueryOption queryOption;
  auto iter = arguments->find(flutter::EncodableValue("teamId"));
  if (iter != arguments->end()) {
    teamId = std::get<std::string>(iter->second);
  }
  auto iter2 = arguments->find(flutter::EncodableValue("teamType"));
  if (iter2 != arguments->end()) {
    teamType = static_cast<v2::V2NIMTeamType>(std::get<int>(iter2->second));
  }
  auto iter3 = arguments->find(flutter::EncodableValue("queryOption"));
  if (iter3 != arguments->end()) {
    auto queryOptionParam = std::get<flutter::EncodableMap>(iter3->second);
    auto queryOptionIter = queryOptionParam.begin();
    for (queryOptionIter; queryOptionIter != queryOptionParam.end();
         ++queryOptionIter) {
      if (queryOptionIter->second.IsNull()) continue;
      if (queryOptionIter->first == flutter::EncodableValue("roleQueryType")) {
        queryOption.roleQueryType =
            static_cast<v2::V2NIMTeamMemberRoleQueryType>(
                std::get<int>(queryOptionIter->second));
      } else if (queryOptionIter->first ==
                 flutter::EncodableValue("onlyChatBanned")) {
        queryOption.onlyChatBanned = std::get<bool>(queryOptionIter->second);
      } else if (queryOptionIter->first ==
                 flutter::EncodableValue("direction")) {
        queryOption.direction = static_cast<v2::V2NIMQueryDirection>(
            std::get<int>(queryOptionIter->second));
      } else if (queryOptionIter->first ==
                 flutter::EncodableValue("nextToken")) {
        queryOption.nextToken = std::get<std::string>(queryOptionIter->second);
      } else if (queryOptionIter->first == flutter::EncodableValue("limit")) {
        queryOption.limit = std::get<int>(queryOptionIter->second);
      }
    }
  }
  auto& client = v2::V2NIMClient::get();
  auto& teamService = client.getTeamService();
  teamService.getTeamMemberList(
      teamId, teamType, queryOption,
      [=](v2::V2NIMTeamMemberListResult memberListrResult) {
        flutter::EncodableMap result_map;
        convertV2NIMTeamMemberListResultToMap(result_map, memberListrResult);
        result->Success(NimResult::getSuccessResult(result_map));
      },
      [=](v2::V2NIMError error) {
        result->Error("", "",
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void V2FLTTeamService::onMethodCalled(
    const std::string& method, const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (method == "createTeam") {
    createTeam(arguments, result);
  } else if (method == "updateTeamInfo") {
    updateTeam(arguments, result);
  } else if (method == "leaveTeam") {
    leaveTeam(arguments, result);
  } else if (method == "getTeamInfo") {
    getTeamInfo(arguments, result);
  } else if (method == "getTeamInfoByIds") {
    getTeamInfoByIds(arguments, result);
  } else if (method == "dismissTeam") {
    dismissTeam(arguments, result);
  } else if (method == "inviteMember") {
    inviteMember(arguments, result);
  } else if (method == "acceptInvitation") {
    acceptInvitation(arguments, result);
  } else if (method == "rejectInvitation") {
    rejectInvitation(arguments, result);
  } else if (method == "kickMember") {
    kickMember(arguments, result);
  } else if (method == "applyJoinTeam") {
    applyJoinTeam(arguments, result);
  } else if (method == "acceptJoinApplication") {
    acceptJoinApplication(arguments, result);
  } else if (method == "rejectJoinApplication") {
    rejectJoinApplication(arguments, result);
  } else if (method == "updateTeamMemberRole") {
    updateTeamMemberRole(arguments, result);
  } else if (method == "transferTeamOwner") {
    transferTeamOwner(arguments, result);
  } else if (method == "updateSelfTeamMemberInfo") {
    updateSelfTeamMemberInfo(arguments, result);
  } else if (method == "updateTeamMemberNick") {
    updateTeamMemberNick(arguments, result);
  } else if (method == "setTeamChatBannedMode") {
    setTeamChatBannedMode(arguments, result);
  } else if (method == "setTeamMemberChatBannedStatus") {
    setTeamMemberChatBannedStatus(arguments, result);
  } else if (method == "getJoinedTeamList") {
    getJoinedTeamList(arguments, result);
  } else if (method == "getJoinedTeamCount") {
    getJoinedTeamCount(arguments, result);
  } else if (method == "getTeamMemberList") {
    getTeamMemberList(arguments, result);
  } else if (method == "getTeamMemberListByIds") {
    getTeamMemberListByIds(arguments, result);
  } else if (method == "getTeamJoinActionInfoList") {
    getTeamJoinActionInfoList(arguments, result);
  } else if (method == "getTeamMemberInvitor") {
    getTeamMemberInvitor(arguments, result);
  } else if (method == "searchTeamByKeyword") {
    searchTeamByKeyword(arguments, result);
  } else if (method == "searchTeamMembers") {
    searchTeamMembers(arguments, result);
  } else {
    result->NotImplemented();
  }
}

void V2FLTTeamService::convertV2NIMTeamToMap(flutter::EncodableMap& argments,
                                             const v2::V2NIMTeam& team) {
  argments.insert(std::make_pair("teamId", team.teamId));
  argments.insert(std::make_pair("teamType", static_cast<int>(team.teamType)));
  argments.insert(std::make_pair("name", team.name));
  argments.insert(std::make_pair("ownerAccountId", team.ownerAccountId));
  argments.insert(
      std::make_pair("memberCount", static_cast<int>(team.memberCount)));
  argments.insert(
      std::make_pair("memberLimit", static_cast<int>(team.memberLimit)));
  argments.insert(
      std::make_pair("createTime", static_cast<int64_t>(team.createTime)));
  argments.insert(
      std::make_pair("updateTime", static_cast<int64_t>(team.updateTime)));
  argments.insert(std::make_pair("intro", team.intro.value()));
  argments.insert(std::make_pair("announcement", team.announcement.value()));
  argments.insert(std::make_pair("avatar", team.avatar.value()));
  argments.insert(
      std::make_pair("serverExtension", team.serverExtension.value()));
  argments.insert(
      std::make_pair("customerExtension", team.customerExtension.value()));
  argments.insert(std::make_pair("joinMode", static_cast<int>(team.joinMode)));
  argments.insert(
      std::make_pair("inviteMode", static_cast<int>(team.inviteMode)));
  argments.insert(
      std::make_pair("updateInfoMode", static_cast<int>(team.updateInfoMode)));
  argments.insert(std::make_pair("updateExtensionMode",
                                 static_cast<int>(team.updateExtensionMode)));
  argments.insert(
      std::make_pair("chatBannedMode", static_cast<int>(team.chatBannedMode)));
  argments.insert(
      std::make_pair("agreeMode", static_cast<int>(team.agreeMode)));
  argments.insert(std::make_pair("isValidTeam", team.isValidTeam));
}

void V2FLTTeamService::convertMapToV2NIMTeam(
    const flutter::EncodableMap& arguments, v2::V2NIMTeam& team) {
  auto iter = arguments.find(flutter::EncodableValue("teamId"));
  if (iter != arguments.end()) {
    team.teamId = std::get<std::string>(iter->second);
  }
  auto iter2 = arguments.find(flutter::EncodableValue("teamType"));
  if (iter2 != arguments.end()) {
    team.teamType =
        static_cast<v2::V2NIMTeamType>(std::get<int>(iter2->second));
  }
  auto iter3 = arguments.find(flutter::EncodableValue("name"));
  if (iter3 != arguments.end()) {
    team.name = std::get<std::string>(iter3->second);
  }
  auto iter4 = arguments.find(flutter::EncodableValue("ownerAccountId"));
  if (iter4 != arguments.end()) {
    team.ownerAccountId = std::get<std::string>(iter4->second);
  }
  auto iter5 = arguments.find(flutter::EncodableValue("memberCount"));
  if (iter5 != arguments.end()) {
    team.memberCount = std::get<int>(iter5->second);
  }
  auto iter6 = arguments.find(flutter::EncodableValue("memberLimit"));
  if (iter6 != arguments.end()) {
    team.memberLimit = std::get<int>(iter6->second);
  }
  auto iter7 = arguments.find(flutter::EncodableValue("intro"));
  if (iter7 != arguments.end()) {
    team.intro = std::get<std::string>(iter7->second);
  }
  auto iter8 = arguments.find(flutter::EncodableValue("announcement"));
  if (iter8 != arguments.end()) {
    team.announcement = std::get<std::string>(iter8->second);
  }
  auto iter9 = arguments.find(flutter::EncodableValue("avatar"));
  if (iter9 != arguments.end()) {
    team.avatar = std::get<std::string>(iter9->second);
  }
  auto iter10 = arguments.find(flutter::EncodableValue("serverExtension"));
  if (iter10 != arguments.end()) {
    team.serverExtension = std::get<std::string>(iter10->second);
  }
  auto iter11 = arguments.find(flutter::EncodableValue("customerExtension"));
  if (iter11 != arguments.end()) {
    team.customerExtension = std::get<std::string>(iter11->second);
  }
  auto iter12 = arguments.find(flutter::EncodableValue("joinMode"));
  if (iter12 != arguments.end()) {
    team.joinMode =
        static_cast<v2::V2NIMTeamJoinMode>(std::get<int>(iter12->second));
  }
  auto iter13 = arguments.find(flutter::EncodableValue("inviteMode"));
  if (iter13 != arguments.end()) {
    team.inviteMode =
        static_cast<v2::V2NIMTeamInviteMode>(std::get<int>(iter13->second));
  }
  auto iter14 = arguments.find(flutter::EncodableValue("updateInfoMode"));
  if (iter14 != arguments.end()) {
    team.updateInfoMode =
        static_cast<v2::V2NIMTeamUpdateInfoMode>(std::get<int>(iter14->second));
  }
  auto iter15 = arguments.find(flutter::EncodableValue("updateExtensionMode"));
  if (iter15 != arguments.end()) {
    team.updateExtensionMode = static_cast<v2::V2NIMTeamUpdateExtensionMode>(
        std::get<int>(iter15->second));
  }
  auto iter16 = arguments.find(flutter::EncodableValue("chatBannedMode"));
  if (iter16 != arguments.end()) {
    team.chatBannedMode =
        static_cast<v2::V2NIMTeamChatBannedMode>(std::get<int>(iter16->second));
  }
  auto iter17 = arguments.find(flutter::EncodableValue("agreeMode"));
  if (iter17 != arguments.end()) {
    team.agreeMode =
        static_cast<v2::V2NIMTeamAgreeMode>(std::get<int>(iter17->second));
  }
  auto iter18 = arguments.find(flutter::EncodableValue("isValidTeam"));
  if (iter18 != arguments.end()) {
    team.isValidTeam = std::get<bool>(iter18->second);
  }
}

void V2FLTTeamService::convertV2NIMCreateTeamResultToMap(
    flutter::EncodableMap& arguments, const v2::V2NIMCreateTeamResult& result) {
  auto team = flutter::EncodableMap();
  convertV2NIMTeamToMap(team, result.team);
  arguments.insert(std::make_pair("team", team));
  auto failedList = flutter::EncodableList();
  for (auto& failed : result.failedList) {
    failedList.push_back(flutter::EncodableValue(failed));
  }
  arguments.insert(std::make_pair("failedList", failedList));
}

void V2FLTTeamService::convertMapToV2NIMCreateTeamParam(
    const flutter::EncodableMap& arguments, v2::V2NIMCreateTeamResult& result) {
  auto team = v2::V2NIMTeam();
  auto iter = arguments.find(flutter::EncodableValue("team"));
  if (iter != arguments.end()) {
    convertMapToV2NIMTeam(std::get<flutter::EncodableMap>(iter->second), team);
    result.team = team;
  }

  auto failedListFinder = arguments.find(flutter::EncodableValue("failedList"));
  if (failedListFinder != arguments.end()) {
    auto failedListData =
        std::get<flutter::EncodableMap>(failedListFinder->second);
    auto failedListIter = failedListData.begin();
    for (failedListIter; failedListIter != failedListData.end();
         ++failedListIter) {
      if (failedListIter->second.IsNull()) continue;
      result.failedList.push_back(
          std::get<std::string>(failedListIter->second));
    }
  }
}

void V2FLTTeamService::convertV2NIMTeamMemberListResultToMap(
    flutter::EncodableMap& arguments,
    const v2::V2NIMTeamMemberListResult& result) {
  auto finished = flutter::EncodableValue(result.finished);
  auto nextToken = flutter::EncodableValue(result.nextToken);
  flutter::EncodableList teamMemberList;

  for (auto teamMember : result.memberList) {
    flutter::EncodableMap teamMemberMap;
    convertV2NIMTeamMemberToMap(teamMemberMap, teamMember);
    teamMemberList.emplace_back(teamMemberMap);
  }
  arguments.insert(std::make_pair("finished", finished));
  arguments.insert(std::make_pair("nextToken", nextToken));
  arguments.insert(std::make_pair("memberList", teamMemberList));
}

void V2FLTTeamService::convertMapToV2NIMTeamMemberListResult(
    const flutter::EncodableMap& arguments,
    v2::V2NIMTeamMemberListResult& result) {
  auto finishedIter = arguments.find(flutter::EncodableValue("finished"));
  if (finishedIter != arguments.end()) {
    result.finished = std::get<bool>(finishedIter->second);
  }
  auto nextTokenIter = arguments.find(flutter::EncodableValue("nextToken"));
  if (nextTokenIter != arguments.end()) {
    result.nextToken = std::get<std::string>(nextTokenIter->second);
  }
  auto memberListIter = arguments.find(flutter::EncodableValue("memberList"));
  if (memberListIter != arguments.end()) {
    auto memberListData =
        std::get<flutter::EncodableList>(memberListIter->second);
    for (auto memberData : memberListData) {
      v2::V2NIMTeamMember member;
      convertMapToV2NIMTeamMember(std::get<flutter::EncodableMap>(memberData),
                                  member);
      result.memberList.push_back(member);
    }
  }
}

void V2FLTTeamService::convertV2NIMTeamMemberToMap(
    flutter::EncodableMap& arguments, const v2::V2NIMTeamMember& member) {
  arguments.insert(std::make_pair("teamId", member.teamId));
  arguments.insert(std::make_pair("accountId", member.accountId));
  arguments.insert(
      std::make_pair("teamType", static_cast<int>(member.teamType)));
  arguments.insert(std::make_pair("teamNick", member.teamNick.value()));
  arguments.insert(
      std::make_pair("serverExtension", member.serverExtension.value()));
  arguments.insert(std::make_pair("memberRole",
                                  static_cast<int>(member.memberRole.value())));
  arguments.insert(
      std::make_pair("invitorAccountId", member.invitorAccountId.value()));
  arguments.insert(std::make_pair("inTeam", member.inTeam.value()));
  arguments.insert(std::make_pair("chatBanned", member.chatBanned.value()));
  arguments.insert(std::make_pair(
      "updateTime", static_cast<int64_t>(member.updateTime.value())));
  arguments.insert(std::make_pair(
      "joinTime", static_cast<int64_t>(member.joinTime.value())));
}

void V2FLTTeamService::convertMapToV2NIMTeamMember(
    const flutter::EncodableMap& arguments, v2::V2NIMTeamMember& member) {
  auto iter = arguments.find(flutter::EncodableValue("teamId"));
  if (iter != arguments.end()) {
    member.teamId = std::get<std::string>(iter->second);
  }
  auto iter2 = arguments.find(flutter::EncodableValue("accountId"));
  if (iter2 != arguments.end()) {
    member.accountId = std::get<std::string>(iter2->second);
  }
  auto iter3 = arguments.find(flutter::EncodableValue("teamType"));
  if (iter3 != arguments.end()) {
    member.teamType =
        static_cast<v2::V2NIMTeamType>(std::get<int>(iter3->second));
  }
  auto iter4 = arguments.find(flutter::EncodableValue("teamNick"));
  if (iter4 != arguments.end()) {
    member.teamNick = std::get<std::string>(iter4->second);
  }
  auto iter5 = arguments.find(flutter::EncodableValue("serverExtension"));
  if (iter5 != arguments.end()) {
    member.serverExtension = std::get<std::string>(iter5->second);
  }
  auto iter6 = arguments.find(flutter::EncodableValue("memberRole"));
  if (iter6 != arguments.end()) {
    member.memberRole =
        static_cast<v2::V2NIMTeamMemberRole>(std::get<int>(iter6->second));
  }
  auto iter7 = arguments.find(flutter::EncodableValue("invitorAccountId"));
  if (iter7 != arguments.end()) {
    member.invitorAccountId = std::get<std::string>(iter7->second);
  }
  auto iter8 = arguments.find(flutter::EncodableValue("inTeam"));
  if (iter8 != arguments.end()) {
    member.inTeam = std::get<bool>(iter8->second);
  }
  auto iter9 = arguments.find(flutter::EncodableValue("chatBanned"));
  if (iter9 != arguments.end()) {
    member.chatBanned = std::get<bool>(iter9->second);
  }
  auto iter10 = arguments.find(flutter::EncodableValue("joinTime"));
  if (iter10 != arguments.end()) {
    member.joinTime = iter10->second.LongValue();
  }
  auto iter11 = arguments.find(flutter::EncodableValue("updateTime"));
  if (iter11 != arguments.end()) {
    member.updateTime = iter11->second.LongValue();
  }
}

void V2FLTTeamService::convertV2NIMTeamJoinActionInfoResultToMap(
    flutter::EncodableMap& arguments,
    const v2::V2NIMTeamJoinActionInfoResult& result) {
  arguments.insert(std::make_pair("finished", result.finished));
  arguments.insert(
      std::make_pair("offset", static_cast<int64_t>(result.offset)));
  flutter::EncodableList actionInfoList;

  for (auto info : result.infos) {
    flutter::EncodableMap infoMap;
    convertV2NIMTeamJoinActionInfoToMap(infoMap, info);
    actionInfoList.emplace_back(infoMap);
  }
  arguments.insert(std::make_pair("infos", actionInfoList));
}

void V2FLTTeamService::convertMapToV2NIMTeamJoinActionInfoResult(
    const flutter::EncodableMap& arguments,
    v2::V2NIMTeamJoinActionInfoResult& result) {
  auto finishedIter = arguments.find(flutter::EncodableValue("finished"));
  if (finishedIter != arguments.end()) {
    result.finished = std::get<bool>(finishedIter->second);
  }
  auto infosIter = arguments.find(flutter::EncodableValue("infos"));
  if (infosIter != arguments.end()) {
    auto infosData = std::get<flutter::EncodableList>(infosIter->second);
    for (auto infoData : infosData) {
      v2::V2NIMTeamJoinActionInfo info;
      convertMapToV2NIMTeamJoinActionInfo(
          std::get<flutter::EncodableMap>(infoData), info);
      result.infos.push_back(info);
    }
  }
  auto offsetIter = arguments.find(flutter::EncodableValue("offset"));
  if (offsetIter != arguments.end()) {
    result.offset = std::get<int>(offsetIter->second);
  }
}

void V2FLTTeamService::convertV2NIMTeamJoinActionInfoToMap(
    flutter::EncodableMap& arguments, const v2::V2NIMTeamJoinActionInfo& info) {
  arguments.insert(std::make_pair("teamId", info.teamId));
  arguments.insert(std::make_pair("operatorAccountId", info.operatorAccountId));
  arguments.insert(std::make_pair("teamType", static_cast<int>(info.teamType)));
  arguments.insert(
      std::make_pair("actionType", static_cast<int>(info.actionType)));
  if (info.postscript.has_value()) {
    arguments.insert(std::make_pair("postscript", info.postscript.value()));
  }
  arguments.insert(
      std::make_pair("actionStatus", static_cast<int>(info.actionStatus)));

  arguments.insert(
      std::make_pair("timestamp", static_cast<int64_t>(info.timestamp)));
}

void V2FLTTeamService::convertMapToV2NIMTeamJoinActionInfo(
    const flutter::EncodableMap& arguments, v2::V2NIMTeamJoinActionInfo& info) {
  auto iter = arguments.find(flutter::EncodableValue("teamId"));
  if (iter != arguments.end()) {
    info.teamId = std::get<std::string>(iter->second);
  }
  auto iter2 = arguments.find(flutter::EncodableValue("operatorAccountId"));
  if (iter2 != arguments.end()) {
    info.operatorAccountId = std::get<std::string>(iter2->second);
  }
  auto iter3 = arguments.find(flutter::EncodableValue("teamType"));
  if (iter3 != arguments.end()) {
    info.teamType =
        static_cast<v2::V2NIMTeamType>(std::get<int>(iter3->second));
  }
  auto iter4 = arguments.find(flutter::EncodableValue("actionType"));
  if (iter4 != arguments.end()) {
    info.actionType =
        static_cast<v2::V2NIMTeamJoinActionType>(std::get<int>(iter4->second));
  }
  auto iter5 = arguments.find(flutter::EncodableValue("actionStatus"));
  if (iter5 != arguments.end()) {
    info.actionStatus = static_cast<v2::V2NIMTeamJoinActionStatus>(
        std::get<int>(iter5->second));
  }
  auto iter6 = arguments.find(flutter::EncodableValue("postscript"));
  if (iter6 != arguments.end()) {
    info.postscript = std::get<std::string>(iter6->second);
  }
  auto iter7 = arguments.find(flutter::EncodableValue("timestamp"));
  if (iter7 != arguments.end()) {
    info.timestamp = iter7->second.LongValue();
  }
}
