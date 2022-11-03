// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#include "FLTTeamService.h"

#include <sstream>

#include "../FLTConvert.h"
#include "FLTMessageService.h"

FLTTeamService::FLTTeamService() {
  m_serviceName = "TeamService";
  nim::Team::RegTeamEventCb(std::bind(&FLTTeamService::teamEventCallback, this,
                                      std::placeholders::_1));
}

FLTTeamService::~FLTTeamService() { nim::Team::UnregTeamCb(); }

void FLTTeamService::onMethodCalled(
    const std::string& method, const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  std::cout << "FLTTeamService method: " << method;

  if (method == "createTeam") {
    createTeam(arguments, result);
  } else if (method == "queryTeamList") {
    queryTeamList(result);
  } else if (method == "queryTeam") {
    queryTeam(arguments, result);
  } else if (method == "searchTeam") {
    searchTeam(arguments, result);
  } else if (method == "dismissTeam") {
    dismissTeam(arguments, result);
  } else if (method == "searchTeamIdByName") {
    searchTeamIdByName(arguments, result);
  } else if (method == "searchTeamsByKeyword") {
    searchTeamsByKeyword(arguments, result);
  } else if (method == "applyJoinTeam") {
    applyJoinTeam(arguments, result);
  } else if (method == "passApply") {
    passApply(arguments, result);
  } else if (method == "addMembersEx") {
    addMembersEx(arguments, result);
  } else if (method == "acceptInvite") {
    acceptInvite(arguments, result);
  } else if (method == "declineInvite") {
    declineInvite(arguments, result);
  } else if (method == "getMemberInvitor") {
    getMemberInvitor(arguments, result);
  } else if (method == "removeMembers") {
    removeMembers(arguments, result);
  } else if (method == "quitTeam") {
    quitTeam(arguments, result);
  } else if (method == "queryMemberList") {
    queryMemberList(arguments, result);
  } else if (method == "queryTeamMember") {
    queryTeamMember(arguments, result);
  } else if (method == "updateMemberNick") {
    updateMemberNick(arguments, result);
  } else if (method == "updateMyMemberExtension") {
    updateMyMemberExtension(arguments, result);
  } else if (method == "isMyTeam") {
    isMyTeam(arguments, result);
  } else if (method == "transferTeam") {
    transferTeam(arguments, result);
  } else if (method == "addManagers") {
    addManagers(arguments, result);
  } else if (method == "removeManagers") {
    removeManagers(arguments, result);
  } else if (method == "muteTeamMember") {
    muteTeamMember(arguments, result);
  } else if (method == "muteAllTeamMember") {
    muteAllTeamMember(arguments, result);
  } else if (method == "queryMutedTeamMembers") {
    queryMutedTeamMembers(arguments, result);
  } else if (method == "updateTeamFields") {
    updateTeamFields(arguments, result);
  } else if (method == "updateTeam") {
    updateTeam(arguments, result);
  } else if (method == "muteTeam") {
    muteTeam(arguments, result);
  } else {
    result->NotImplemented();
  }
}

void FLTTeamService::createTeam(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  nim::TeamInfo team_info;
  std::list<std::string> ids;
  std::string invitation_postscript;

  auto iter = arguments->find(flutter::EncodableValue("createTeamOptions"));
  if (iter != arguments->end()) {
    if (iter->second.IsNull()) {
      result->Error("", "",
                    NimResult::getErrorResult(
                        -1, "createTeam createTeamOptions params error"));
      return;
    }
    auto createTeamOptions = std::get<flutter::EncodableMap>(iter->second);
    auto options_iter = createTeamOptions.begin();
    for (options_iter; options_iter != createTeamOptions.end();
         ++options_iter) {
      if (options_iter->second.IsNull()) continue;

      if (options_iter->first == flutter::EncodableValue("name")) {
        team_info.SetName(std::get<std::string>(options_iter->second));
      } else if (options_iter->first == flutter::EncodableValue("avatarUrl")) {
        team_info.SetIcon(std::get<std::string>(options_iter->second));
      } else if (options_iter->first == flutter::EncodableValue("introduce")) {
        team_info.SetIntro(std::get<std::string>(options_iter->second));
      } else if (options_iter->first ==
                 flutter::EncodableValue("announcement")) {
        team_info.SetAnnouncement(std::get<std::string>(options_iter->second));
      } else if (options_iter->first == flutter::EncodableValue("extension")) {
        team_info.SetCustom(std::get<std::string>(options_iter->second));
      } else if (options_iter->first == flutter::EncodableValue("postscript")) {
        invitation_postscript = std::get<std::string>(options_iter->second);
      } else if (options_iter->first == flutter::EncodableValue("teamType")) {
        std::string strTeamType = std::get<std::string>(options_iter->second);
        nim::NIMTeamType type;
        Convert::getInstance()->convertDartStringToNIMEnum(
            strTeamType, Convert::getInstance()->getTeamType(), type);
        team_info.SetType(type);
      } else if (options_iter->first == flutter::EncodableValue("verifyType")) {
        std::string strVerifyType = std::get<std::string>(options_iter->second);
        nim::NIMTeamJoinMode mode;
        Convert::getInstance()->convertDartStringToNIMEnum(
            strVerifyType, Convert::getInstance()->getTeamJoinMode(), mode);
        team_info.SetJoinMode(mode);
      } else if (options_iter->first == flutter::EncodableValue("inviteMode")) {
        std::string strInviteMode = std::get<std::string>(options_iter->second);
        nim::NIMTeamInviteMode mode;
        Convert::getInstance()->convertDartStringToNIMEnum(
            strInviteMode, Convert::getInstance()->getTeamInviteMode(), mode);
        team_info.SetInviteMode(mode);
      } else if (options_iter->first ==
                 flutter::EncodableValue("beInviteMode")) {
        std::string strbeInviteMode =
            std::get<std::string>(options_iter->second);
        nim::NIMTeamBeInviteMode mode;
        Convert::getInstance()->convertDartStringToNIMEnum(
            strbeInviteMode, Convert::getInstance()->getTeamBeInviteMode(),
            mode);
        team_info.SetBeInviteMode(mode);
      } else if (options_iter->first ==
                 flutter::EncodableValue("updateInfoMode")) {
        std::string strUpdateInfoMode =
            std::get<std::string>(options_iter->second);
        nim::NIMTeamUpdateInfoMode mode;
        Convert::getInstance()->convertDartStringToNIMEnum(
            strUpdateInfoMode, Convert::getInstance()->getTeamUpdateInfoMode(),
            mode);
        team_info.SetUpdateInfoMode(mode);
      } else if (options_iter->first ==
                 flutter::EncodableValue("extensionUpdateMode")) {
        std::string strExtensionUpdateMode =
            std::get<std::string>(options_iter->second);
        nim::NIMTeamUpdateCustomMode mode;
        Convert::getInstance()->convertDartStringToNIMEnum(
            strExtensionUpdateMode,
            Convert::getInstance()->getTeamUpdateCustomMode(), mode);
        team_info.SetUpdateCustomMode(mode);
      }
    }
  }

  auto members_iter = arguments->find(flutter::EncodableValue("members"));
  if (members_iter != arguments->end()) {
    if (members_iter->second.IsNull()) {
      result->Error(
          "", "",
          NimResult::getErrorResult(-1, "createTeam members params error"));
      return;
    }
    auto members = std::get<flutter::EncodableList>(members_iter->second);
    for (auto member : members) {
      ids.emplace_back(std::get<std::string>(member));
    }
  }

  bool res = nim::Team::CreateTeamAsync(
      team_info, ids, invitation_postscript,
      [=](const nim::TeamEvent& team_event) {
        if (team_event.res_code_ == nim::kNIMResSuccess ||
            team_event.res_code_ == nim::kNIMResTeamInviteSuccess) {
          nim::Team::QueryTeamInfoAsync(
              team_event.team_id_,
              [=](const std::string& tid, const nim::TeamInfo& team_info) {
                if (team_info.IsValid()) {
                  flutter::EncodableMap arguments_;
                  flutter::EncodableMap teamInfoMap;
                  flutter::EncodableList failedInviteAccounts;
                  std::list<nim::TeamMemberProperty> all_my_member_info_list;
                  all_my_member_info_list.push_back(
                      team_event.member_property_);
                  convertNIMTeamInfoToDartTeamInfo(teamInfoMap, team_info,
                                                   all_my_member_info_list);
                  arguments_.insert(std::make_pair("team", teamInfoMap));
                  for (auto id : team_event.invalid_ids_) {
                    failedInviteAccounts.emplace_back(id);
                  }
                  arguments_.insert(std::make_pair("failedInviteAccounts",
                                                   failedInviteAccounts));
                  result->Success(NimResult::getSuccessResult(arguments_));
                } else {
                  result->Error(
                      "", "",
                      NimResult::getErrorResult(-1, "createTeam failed!"));
                }
              });
        } else {
          result->Error("", "",
                        NimResult::getErrorResult(team_event.res_code_,
                                                  "createTeam failed"));
        }
      });

  if (!res) {
    result->Error("", "", NimResult::getErrorResult(-1, "createTeam failed"));
  }
}

void FLTTeamService::queryTeamList(
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  nim::Team::QueryMyAllMemberInfosAsync(
      [=](int count,
          const std::list<nim::TeamMemberProperty>& all_my_member_info_list) {
        nim::Team::QueryAllMyTeamsInfoAsync(
            [=](int team_count,
                const std::list<nim::TeamInfo>& team_info_list) {
              flutter::EncodableMap arguments;
              flutter::EncodableList teamInfoList;
              for (auto team_info : team_info_list) {
                flutter::EncodableMap teamInfoMap;
                convertNIMTeamInfoToDartTeamInfo(teamInfoMap, team_info,
                                                 all_my_member_info_list);
                teamInfoList.emplace_back(teamInfoMap);
              }
              arguments.insert(std::make_pair("teamList", teamInfoList));
              result->Success(NimResult::getSuccessResult(arguments));
            });
      });
}

void FLTTeamService::queryTeam(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  std::string tid;
  if (!getTeamId(arguments, tid)) {
    result->Error("", "",
                  NimResult::getErrorResult(-1, "queryTeam params error"));
    return;
  }

  nim::Team::QueryMyAllMemberInfosAsync(
      [=](int count,
          const std::list<nim::TeamMemberProperty>& all_my_member_info_list) {
        nim::Team::QueryTeamInfoAsync(
            tid, [=](const std::string& tid, const nim::TeamInfo& team_info) {
              flutter::EncodableMap teamInfoMap;
              convertNIMTeamInfoToDartTeamInfo(teamInfoMap, team_info,
                                               all_my_member_info_list);
              result->Success(NimResult::getSuccessResult(teamInfoMap));
            });
      });
}

void FLTTeamService::searchTeam(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  std::string tid;
  if (!getTeamId(arguments, tid)) {
    result->Error("", "",
                  NimResult::getErrorResult(-1, "searchTeam params error"));
    return;
  }

  bool res = nim::Team::QueryTeamInfoOnlineAsync(
      tid, [=](const nim::TeamEvent& team_event) {
        if (team_event.res_code_ == nim::kNIMResSuccess) {
          flutter::EncodableMap teamInfoMap;
          std::list<nim::TeamMemberProperty> all_my_member_info_list;
          all_my_member_info_list.push_back(team_event.member_property_);
          convertNIMTeamInfoToDartTeamInfo(teamInfoMap, team_event.team_info_,
                                           all_my_member_info_list);
          result->Success(NimResult::getSuccessResult(teamInfoMap));
        } else {
          result->Error("", "",
                        NimResult::getErrorResult(team_event.res_code_,
                                                  "searchTeam failed!"));
        }
      });

  if (!res) {
    result->Error("", "", NimResult::getErrorResult(-1, "searchTeam failed"));
  }
}

void FLTTeamService::dismissTeam(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  std::string tid;
  if (!getTeamId(arguments, tid)) {
    result->Error("", "",
                  NimResult::getErrorResult(-1, "dismissTeam params error"));
    return;
  }

  bool res =
      nim::Team::DismissAsync(tid, [=](const nim::TeamEvent& team_event) {
        if (team_event.res_code_ == nim::kNIMResSuccess) {
          result->Success(NimResult::getSuccessResult());
        } else {
          result->Error("", "",
                        NimResult::getErrorResult(team_event.res_code_,
                                                  "dismissTeam failed"));
        }
      });

  if (!res) {
    result->Error("", "", NimResult::getErrorResult(-1, "dismissTeam failed"));
  }
}

void FLTTeamService::searchTeamIdByName(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  // todo
  result->NotImplemented();
}

void FLTTeamService::searchTeamsByKeyword(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  std::string keyword;
  auto iter = arguments->find(flutter::EncodableValue("keyword"));
  if (iter != arguments->end()) {
    if (iter->second.IsNull()) {
      result->Error(
          "", "",
          NimResult::getErrorResult(-1, "searchTeamsByKeyword params error"));
      return;
    }

    keyword = std::get<std::string>(iter->second);
  }

  nim::Team::QueryMyAllMemberInfosAsync(
      [=](int count,
          const std::list<nim::TeamMemberProperty>& all_my_member_info_list) {
        nim::Team::QueryTeamInfoByKeywordAsync(
            keyword, [=](int team_count,
                         const std::list<nim::TeamInfo>& team_info_list) {
              flutter::EncodableMap result_map;
              flutter::EncodableList teamInfoList;
              for (auto team_info : team_info_list) {
                flutter::EncodableMap teamInfoMap;
                convertNIMTeamInfoToDartTeamInfo(teamInfoMap, team_info,
                                                 all_my_member_info_list);
                teamInfoList.emplace_back(teamInfoMap);
              }
              result_map.insert(std::make_pair("teamList", teamInfoList));
              result->Success(NimResult::getSuccessResult(result_map));
            });
      });
}

void FLTTeamService::applyJoinTeam(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  std::string tid;
  std::string reason;

  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) continue;

    if (iter->first == flutter::EncodableValue("teamId")) {
      tid = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("postscript")) {
      reason = std::get<std::string>(iter->second);
    }
  }

  bool res = nim::Team::ApplyJoinAsync(
      tid, reason, [=](const nim::TeamEvent& team_event) {
        if (team_event.res_code_ == nim::kNIMResSuccess) {
          flutter::EncodableMap teamInfoMap;
          std::list<nim::TeamMemberProperty> all_my_member_info_list;
          all_my_member_info_list.push_back(team_event.member_property_);
          convertNIMTeamInfoToDartTeamInfo(teamInfoMap, team_event.team_info_,
                                           all_my_member_info_list);
          result->Success(NimResult::getSuccessResult(teamInfoMap));
        } else {
          result->Error("", "",
                        NimResult::getErrorResult(team_event.res_code_,
                                                  "applyJoinTeam failed"));
        }
      });

  if (!res) {
    result->Error("", "",
                  NimResult::getErrorResult(-1, "applyJoinTeam failed"));
  }
}

void FLTTeamService::passApply(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  std::string tid;
  std::string applicant_id;

  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) continue;

    if (iter->first == flutter::EncodableValue("teamId")) {
      tid = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("account")) {
      applicant_id = std::get<std::string>(iter->second);
    }
  }

  bool res = nim::Team::PassJoinApplyAsync(
      tid, applicant_id, [=](const nim::TeamEvent& team_event) {
        if (team_event.res_code_ == nim::kNIMResSuccess) {
          result->Success(NimResult::getSuccessResult());
        } else {
          result->Error("", "",
                        NimResult::getErrorResult(team_event.res_code_,
                                                  "passApply failed"));
        }
      });

  if (!res) {
    result->Error("", "", NimResult::getErrorResult(-1, "passApply failed"));
  }
}

void FLTTeamService::addMembersEx(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  std::string tid;
  std::string invitation_postscript;
  std::list<std::string> ids;

  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) continue;

    if (iter->first == flutter::EncodableValue("teamId")) {
      tid = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("accounts")) {
      auto accounts = std::get<flutter::EncodableList>(iter->second);
      for (auto account : accounts) {
        ids.emplace_back(std::get<std::string>(account));
      }
    } else if (iter->first == flutter::EncodableValue("msg")) {
      invitation_postscript = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("customInfo")) {
      // 不支持
    }
  }

  bool res = nim::Team::InviteAsync(
      tid, ids, invitation_postscript, [=](const nim::TeamEvent& team_event) {
        bool bSuccess = false;
        if (team_event.res_code_ == nim::kNIMResSuccess) {
          bSuccess = true;
        } else if (team_event.res_code_ == 801 &&
                   team_event.team_info_.GetType() ==
                       nim::kNIMTeamTypeAdvanced) {
          bSuccess = true;
        }

        if (bSuccess) {
          flutter::EncodableMap result_map;
          flutter::EncodableList teamMemberExList;
          for (auto teamMember : team_event.ids_) {
            teamMemberExList.emplace_back(teamMember);
          }
          result_map.insert(
              std::make_pair("teamMemberExList", teamMemberExList));
          result->Success(NimResult::getSuccessResult(result_map));
        } else {
          result->Error("", "",
                        NimResult::getErrorResult(team_event.res_code_,
                                                  "addMembersEx failed"));
        }
      });

  if (!res) {
    result->Error("", "", NimResult::getErrorResult(-1, "addMembersEx failed"));
  }
}

void FLTTeamService::acceptInvite(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  std::string tid;
  std::string invitor_id;

  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) continue;

    if (iter->first == flutter::EncodableValue("teamId")) {
      tid = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("inviter")) {
      invitor_id = std::get<std::string>(iter->second);
    }
  }

  bool res = nim::Team::AcceptInvitationAsync(
      tid, invitor_id, [=](const nim::TeamEvent& team_event) {
        if (team_event.res_code_ == nim::kNIMResSuccess) {
          result->Success(NimResult::getSuccessResult());
        } else {
          result->Error("", "",
                        NimResult::getErrorResult(team_event.res_code_,
                                                  "acceptInvite failed"));
        }
      });

  if (!res) {
    result->Error("", "", NimResult::getErrorResult(-1, "acceptInvite failed"));
  }
}

void FLTTeamService::declineInvite(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  std::string teamId;
  std::string inviter;
  std::string reason;

  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) continue;

    if (iter->first == flutter::EncodableValue("teamId")) {
      teamId = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("inviter")) {
      inviter = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("reason")) {
      reason = std::get<std::string>(iter->second);
    }
  }

  bool res = nim::Team::RejectInvitationAsync(
      teamId, inviter, reason, [=](const nim::TeamEvent& team_event) {
        if (team_event.res_code_ == nim::kNIMResSuccess) {
          result->Success(NimResult::getSuccessResult());
        } else {
          result->Error("", "",
                        NimResult::getErrorResult(team_event.res_code_,
                                                  "declineInvite failed"));
        }
      });

  if (!res) {
    result->Error("", "",
                  NimResult::getErrorResult(-1, "declineInvite failed"));
  }
}

void FLTTeamService::getMemberInvitor(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  std::string tid;
  std::list<std::string> members;

  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) continue;

    if (iter->first == flutter::EncodableValue("teamId")) {
      tid = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("members")) {
      auto members_ = std::get<flutter::EncodableList>(iter->second);
      for (auto member : members_) {
        members.emplace_back(std::get<std::string>(member));
      }
    }
  }

  nim::Team::QueryTeamMembersInvitor(
      tid, members,
      [=](nim::NIMResCode error_code, const std::string& tid,
          const std::map<std::string, std::string>& merbers_map) {
        if (error_code == nim::kNIMResSuccess) {
          flutter::EncodableMap result_map;
          auto members_iter = merbers_map.begin();
          for (members_iter; members_iter != merbers_map.end();
               ++members_iter) {
            result_map.insert(
                std::make_pair(members_iter->first, members_iter->second));
          }
          result->Success(NimResult::getSuccessResult(result_map));
        } else {
          result->Error(
              "", "",
              NimResult::getErrorResult(error_code, "getMemberInvitor failed"));
        }
      });
}

void FLTTeamService::removeMembers(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  std::string tid;
  std::list<std::string> ids;

  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) continue;

    if (iter->first == flutter::EncodableValue("teamId")) {
      tid = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("members")) {
      auto members = std::get<flutter::EncodableList>(iter->second);
      for (auto member : members) {
        ids.emplace_back(std::get<std::string>(member));
      }
    }
  }
  bool res =
      nim::Team::KickAsync(tid, ids, [=](const nim::TeamEvent& team_event) {
        if (team_event.res_code_ == nim::kNIMResSuccess) {
          result->Success(NimResult::getSuccessResult());
        } else {
          result->Error("", "",
                        NimResult::getErrorResult(team_event.res_code_,
                                                  "removeMembers failed"));
        }
      });

  if (!res) {
    result->Error("", "",
                  NimResult::getErrorResult(-1, "removeMembers failed"));
  }
}

void FLTTeamService::quitTeam(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  std::string tid;
  if (!getTeamId(arguments, tid)) {
    result->Error("", "",
                  NimResult::getErrorResult(-1, "quitTeam params error"));
    return;
  }
  bool res = nim::Team::LeaveAsync(tid, [=](const nim::TeamEvent& team_event) {
    if (team_event.res_code_ == nim::kNIMResSuccess) {
      result->Success(NimResult::getSuccessResult());
    } else {
      result->Error(
          "", "",
          NimResult::getErrorResult(team_event.res_code_, "quitTeam failed"));
    }
  });

  if (!res) {
    result->Error("", "", NimResult::getErrorResult(-1, "quitTeam failed"));
  }
}

void FLTTeamService::queryMemberList(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  std::string tid;
  if (!getTeamId(arguments, tid)) {
    result->Error(
        "", "", NimResult::getErrorResult(-1, "queryMemberList params error"));
    return;
  }

  bool res = nim::Team::QueryTeamMembersAsync(
      tid, [=](const std::string& tid, int member_count,
               const std::list<nim::TeamMemberProperty>& props) {
        flutter::EncodableMap result_map;
        flutter::EncodableList members;
        for (auto prop : props) {
          flutter::EncodableMap member;
          convertNIMTeamMemberToDartTeamMember(member, prop);
          members.emplace_back(member);
        }

        result_map.insert(std::make_pair("teamMemberList", members));
        result->Success(NimResult::getSuccessResult(result_map));
      });

  if (!res) {
    result->Error("", "",
                  NimResult::getErrorResult(-1, "queryMemberList failed"));
  }
}

void FLTTeamService::queryTeamMember(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  std::string tid;
  std::string id;

  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) continue;

    if (iter->first == flutter::EncodableValue("teamId")) {
      tid = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("account")) {
      id = std::get<std::string>(iter->second);
    }
  }

  bool res = nim::Team::QueryTeamMemberAsync(
      tid, id, [=](const nim::TeamMemberProperty& team_member_property) {
        flutter::EncodableMap member;
        convertNIMTeamMemberToDartTeamMember(member, team_member_property);
        result->Success(NimResult::getSuccessResult(member));
      });

  if (!res) {
    result->Error("", "",
                  NimResult::getErrorResult(-1, "queryTeamMember failed"));
  }
}

void FLTTeamService::updateMemberNick(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  nim::TeamMemberProperty prop;

  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) continue;

    if (iter->first == flutter::EncodableValue("teamId")) {
      prop.SetTeamID(std::get<std::string>(iter->second));
    } else if (iter->first == flutter::EncodableValue("account")) {
      prop.SetAccountID(std::get<std::string>(iter->second));
    } else if (iter->first == flutter::EncodableValue("nick")) {
      prop.SetNick(std::get<std::string>(iter->second));
    }
  }

  std::cout << "updateMemberNick: " << prop.GetTeamID() << " "
            << prop.GetAccountID() << " " << prop.GetNick() << std::endl;

  bool res = nim::Team::UpdateOtherNickAsync(
      prop, [=](const nim::TeamEvent& team_event) {
        if (team_event.res_code_ == nim::kNIMResSuccess) {
          result->Success(NimResult::getSuccessResult());
        } else {
          result->Error("", "",
                        NimResult::getErrorResult(team_event.res_code_,
                                                  "updateMemberNick failed"));
        }
      });

  if (!res) {
    result->Error("", "",
                  NimResult::getErrorResult(-1, "updateMemberNick failed"));
  }
}

void FLTTeamService::isMyTeam(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  // todo dart层没接口
}

void FLTTeamService::transferTeam(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  std::string tid;
  std::string new_owner_id;
  bool is_leave;

  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) continue;

    if (iter->first == flutter::EncodableValue("teamId")) {
      tid = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("account")) {
      new_owner_id = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("quit")) {
      is_leave = std::get<bool>(iter->second);
    }
  }

  bool res = nim::Team::TransferTeamAsync(
      tid, new_owner_id, is_leave, [=](const nim::TeamEvent& team_event) {
        if (team_event.res_code_ == nim::kNIMResSuccess) {
          nim::Team::QueryTeamMembersAsync(
              tid, [=](const std::string& tid, int member_count,
                       const std::list<nim::TeamMemberProperty>& props) {
                flutter::EncodableMap result_map;
                flutter::EncodableList members;
                for (auto prop : props) {
                  flutter::EncodableMap member;
                  convertNIMTeamMemberToDartTeamMember(member, prop);
                  members.emplace_back(member);
                }

                result_map.insert(std::make_pair("teamMemberList", members));
                result->Success(NimResult::getSuccessResult(result_map));
              });
        } else {
          result->Error("", "",
                        NimResult::getErrorResult(team_event.res_code_,
                                                  "transferTeam failed"));
        }
      });

  if (!res) {
    result->Error("", "", NimResult::getErrorResult(-1, "transferTeam failed"));
  }
}

void FLTTeamService::addManagers(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  std::string tid;
  std::list<std::string> ids;

  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) continue;

    if (iter->first == flutter::EncodableValue("teamId")) {
      tid = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("accounts")) {
      auto accounts = std::get<flutter::EncodableList>(iter->second);
      for (auto account : accounts) {
        ids.emplace_back(std::get<std::string>(account));
      }
    }
  }

  bool res = nim::Team::AddManagersAsync(
      tid, ids, [=](const nim::TeamEvent& team_event) {
        if (team_event.res_code_ == nim::kNIMResSuccess) {
          nim::Team::QueryTeamMembersAsync(
              tid, [=](const std::string& tid, int member_count,
                       const std::list<nim::TeamMemberProperty>& props) {
                flutter::EncodableMap result_map;
                flutter::EncodableList members;
                for (auto prop : props) {
                  flutter::EncodableMap member;
                  convertNIMTeamMemberToDartTeamMember(member, prop);
                  members.emplace_back(member);
                }

                result_map.insert(std::make_pair("teamMemberList", members));
                result->Success(NimResult::getSuccessResult(result_map));
              });
        } else {
          result->Error("", "",
                        NimResult::getErrorResult(team_event.res_code_,
                                                  "addManagers failed"));
        }
      });

  if (!res) {
    result->Error("", "", NimResult::getErrorResult(-1, "addManagers failed"));
  }
}

void FLTTeamService::removeManagers(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  std::string tid;
  std::list<std::string> ids;

  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) continue;

    if (iter->first == flutter::EncodableValue("teamId")) {
      tid = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("managers")) {
      auto accounts = std::get<flutter::EncodableList>(iter->second);
      for (auto account : accounts) {
        ids.emplace_back(std::get<std::string>(account));
      }
    }
  }

  bool res = nim::Team::RemoveManagersAsync(
      tid, ids, [=](const nim::TeamEvent& team_event) {
        if (team_event.res_code_ == nim::kNIMResSuccess) {
          nim::Team::QueryTeamMembersAsync(
              tid, [=](const std::string& tid, int member_count,
                       const std::list<nim::TeamMemberProperty>& props) {
                flutter::EncodableMap result_map;
                flutter::EncodableList members;
                for (auto prop : props) {
                  flutter::EncodableMap member;
                  convertNIMTeamMemberToDartTeamMember(member, prop);
                  members.emplace_back(member);
                }

                result_map.insert(std::make_pair("teamMemberList", members));
                result->Success(NimResult::getSuccessResult(result_map));
              });
        } else {
          result->Error("", "",
                        NimResult::getErrorResult(team_event.res_code_,
                                                  "removeManagers failed"));
        }
      });

  if (!res) {
    result->Error("", "",
                  NimResult::getErrorResult(-1, "removeManagers failed"));
  }
}

void FLTTeamService::muteTeamMember(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  std::string tid;
  std::string member_id;
  bool mute;

  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) continue;

    if (iter->first == flutter::EncodableValue("teamId")) {
      tid = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("account")) {
      member_id = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("mute")) {
      mute = std::get<bool>(iter->second);
    }
  }

  bool res = nim::Team::MuteMemberAsync(
      tid, member_id, mute, [=](const nim::TeamEvent& team_event) {
        if (team_event.res_code_ == nim::kNIMResSuccess) {
          result->Success(NimResult::getSuccessResult());
        } else {
          result->Error("", "",
                        NimResult::getErrorResult(team_event.res_code_,
                                                  "muteTeamMember failed"));
        }
      });

  if (!res) {
    result->Error("", "",
                  NimResult::getErrorResult(-1, "muteTeamMember failed"));
  }
}

void FLTTeamService::muteAllTeamMember(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  std::string tid;
  bool mute;

  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) continue;

    if (iter->first == flutter::EncodableValue("teamId")) {
      tid = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("mute")) {
      mute = std::get<bool>(iter->second);
    }
  }

  bool res =
      nim::Team::MuteAsync(tid, mute, [=](const nim::TeamEvent& team_event) {
        if (team_event.res_code_ == nim::kNIMResSuccess) {
          result->Success(NimResult::getSuccessResult());
        } else {
          result->Error("", "",
                        NimResult::getErrorResult(team_event.res_code_,
                                                  "muteAllTeamMember failed"));
        }
      });

  if (!res) {
    result->Error("", "",
                  NimResult::getErrorResult(-1, "muteAllTeamMember failed"));
  }
}

void FLTTeamService::queryMutedTeamMembers(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  std::string tid;
  if (!getTeamId(arguments, tid)) {
    result->Error("", "",
                  NimResult::getErrorResult(-1, "queryTeam params error"));
    return;
  }

  bool res = nim::Team::QueryMuteListOnlineAsync(
      tid,
      [=](nim::NIMResCode error_code, const std::string& tid,
          const std::list<nim::TeamMemberProperty>& team_member_propertys) {
        if (error_code == nim::kNIMResSuccess) {
          flutter::EncodableMap result_map;
          flutter::EncodableList members;
          for (auto prop : team_member_propertys) {
            flutter::EncodableMap member;
            convertNIMTeamMemberToDartTeamMember(member, prop);
            members.emplace_back(member);
          }

          result_map.insert(std::make_pair("teamMemberList", members));
          result->Success(NimResult::getSuccessResult(result_map));
        } else {
          result->Error("", "",
                        NimResult::getErrorResult(
                            error_code, "queryMutedTeamMembers failed"));
        }
      });

  if (!res) {
    result->Error(
        "", "", NimResult::getErrorResult(-1, "queryMutedTeamMembers failed"));
  }
}

void FLTTeamService::updateTeamFields(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  std::string tid;
  nim::TeamInfo team_info;
  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) continue;

    if (iter->first == flutter::EncodableValue("teamId")) {
      tid = std::get<std::string>(iter->second);
      team_info.SetTeamID(tid);
    } else if (iter->first == flutter::EncodableValue("request")) {
      auto request = std::get<flutter::EncodableMap>(iter->second);
      auto request_iter = request.begin();
      for (request_iter; request_iter != request.end(); ++request_iter) {
        if (request_iter->second.IsNull()) continue;

        if (request_iter->first == flutter::EncodableValue("announcement")) {
          team_info.SetAnnouncement(
              std::get<std::string>(request_iter->second));
        } else if (request_iter->first ==
                   flutter::EncodableValue("beInviteMode")) {
          team_info.SetBeInviteMode(static_cast<nim::NIMTeamBeInviteMode>(
              std::get<int>(request_iter->second)));
        } else if (request_iter->first ==
                   flutter::EncodableValue("extension")) {
          team_info.SetCustom(std::get<std::string>(request_iter->second));
        } else if (request_iter->first == flutter::EncodableValue("icon")) {
          team_info.SetIcon(std::get<std::string>(request_iter->second));
        } else if (request_iter->first ==
                   flutter::EncodableValue("introduce")) {
          team_info.SetIntro(std::get<std::string>(request_iter->second));
        } else if (request_iter->first ==
                   flutter::EncodableValue("inviteMode")) {
          team_info.SetInviteMode(static_cast<nim::NIMTeamInviteMode>(
              std::get<int>(request_iter->second)));
        } else if (request_iter->first ==
                   flutter::EncodableValue("maxMemberCount")) {
          team_info.SetMemberMaxCount(std::get<int>(request_iter->second));
        } else if (request_iter->first == flutter::EncodableValue("name")) {
          team_info.SetName(std::get<std::string>(request_iter->second));
        } else if (request_iter->first ==
                   flutter::EncodableValue("teamExtensionUpdateMode")) {
          team_info.SetUpdateCustomMode(
              static_cast<nim::NIMTeamUpdateCustomMode>(
                  std::get<int>(request_iter->second)));
        } else if (request_iter->first ==
                   flutter::EncodableValue("teamUpdateMode")) {
          team_info.SetUpdateInfoMode(static_cast<nim::NIMTeamUpdateInfoMode>(
              std::get<int>(request_iter->second)));
        } else if (request_iter->first ==
                   flutter::EncodableValue("verifyType")) {
          team_info.SetJoinMode(static_cast<nim::NIMTeamJoinMode>(
              std::get<int>(request_iter->second)));
        }
      }
    }
  }

  bool res = nim::Team::UpdateTeamInfoAsync(
      tid, team_info, [=](const nim::TeamEvent& team_event) {
        if (team_event.res_code_ == nim::kNIMResSuccess) {
          result->Success(NimResult::getSuccessResult());
        } else {
          result->Error("", "",
                        NimResult::getErrorResult(team_event.res_code_,
                                                  "updateTeam failed"));
        }
      });

  if (!res) {
    result->Error("", "", NimResult::getErrorResult(-1, "updateTeam failed"));
  }
}

void FLTTeamService::updateTeam(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  // 接口已废弃
  if (!arguments) {
    return;
  }

  std::string tid;
  nim::TeamInfo team_info;
  std::string strField;
  std::string strValue;

  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) continue;

    if (iter->first == flutter::EncodableValue("teamId")) {
      tid = std::get<std::string>(iter->second);
      team_info.SetTeamID(tid);
    } else if (iter->first == flutter::EncodableValue("field")) {
      strField = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("value")) {
      strValue = std::get<std::string>(iter->second);
    }
  }

  if (strField == "announcement") {
    team_info.SetAnnouncement(strValue);
  } else if (strField == "beInviteMode") {
    nim::NIMTeamBeInviteMode mode;
    Convert::getInstance()->convertDartStringToNIMEnum(
        strValue, Convert::getInstance()->getTeamBeInviteMode(), mode);
    team_info.SetBeInviteMode(mode);
  } else if (strField == "extension") {
    team_info.SetCustom(strValue);
  } else if (strField == "icon") {
    team_info.SetIcon(strValue);
  } else if (strField == "introduce") {
    team_info.SetIntro(strValue);
  } else if (strField == "inviteMode") {
    nim::NIMTeamInviteMode mode;
    Convert::getInstance()->convertDartStringToNIMEnum(
        strValue, Convert::getInstance()->getTeamInviteMode(), mode);
    team_info.SetInviteMode(mode);
  } else if (strField == "maxMemberCount") {
    team_info.SetMemberMaxCount(atoi(strValue.c_str()));
  } else if (strField == "name") {
    team_info.SetName(strValue);
  } else if (strField == "teamExtensionUpdateMode") {
    nim::NIMTeamUpdateCustomMode mode;
    Convert::getInstance()->convertDartStringToNIMEnum(
        strValue, Convert::getInstance()->getTeamUpdateCustomMode(), mode);
    team_info.SetUpdateCustomMode(mode);
  } else if (strField == "teamUpdateMode") {
    nim::NIMTeamUpdateInfoMode mode;
    Convert::getInstance()->convertDartStringToNIMEnum(
        strValue, Convert::getInstance()->getTeamUpdateInfoMode(), mode);
    team_info.SetUpdateInfoMode(mode);
  } else if (strField == "verifyType") {
    nim::NIMTeamJoinMode mode;
    Convert::getInstance()->convertDartStringToNIMEnum(
        strValue, Convert::getInstance()->getTeamJoinMode(), mode);
    team_info.SetJoinMode(mode);
  }

  bool res = nim::Team::UpdateTeamInfoAsync(
      tid, team_info, [=](const nim::TeamEvent& team_event) {
        if (team_event.res_code_ == nim::kNIMResSuccess) {
          result->Success(NimResult::getSuccessResult());
        } else {
          result->Error("", "",
                        NimResult::getErrorResult(team_event.res_code_,
                                                  "updateTeam failed"));
        }
      });

  if (!res) {
    result->Error("", "", NimResult::getErrorResult(-1, "updateTeam failed"));
  }
}

void FLTTeamService::updateMyMemberExtension(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  nim::TeamMemberProperty prop;

  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) continue;

    if (iter->first == flutter::EncodableValue("teamId")) {
      prop.SetTeamID(std::get<std::string>(iter->second));
    } else if (iter->first == flutter::EncodableValue("extension")) {
      flutter::EncodableMap extensionMap =
          std::get<flutter::EncodableMap>(iter->second);
      nim_cpp_wrapper_util::Json::Value extensionValue;
      std::string strExtension = "";
      if (Convert::getInstance()->convertMap2Json(&extensionMap,
                                                  extensionValue)) {
        prop.SetCustom(nim::GetJsonStringWithNoStyled(extensionValue));
      } else {
        result->Error(
            "", "",
            NimResult::getErrorResult(1, "updateMyMemberExtension failed"));
        return;
      }
    }
  }

  bool res = nim::Team::UpdateMyPropertyAsync(
      prop, [=](const nim::TeamEvent& team_event) {
        if (team_event.res_code_ == nim::kNIMResSuccess) {
          result->Success(NimResult::getSuccessResult());
        } else {
          result->Error(
              "", "",
              NimResult::getErrorResult(team_event.res_code_,
                                        "updateMyMemberExtension failed"));
        }
      });

  if (!res) {
    result->Error(
        "", "",
        NimResult::getErrorResult(-1, "updateMyMemberExtension failed"));
  }
}

void FLTTeamService::muteTeam(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  nim::TeamMemberProperty prop;

  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) continue;

    if (iter->first == flutter::EncodableValue("teamId")) {
      prop.SetTeamID(std::get<std::string>(iter->second));
    } else if (iter->first == flutter::EncodableValue("notifyType")) {
      std::string strNotifyType = std::get<std::string>(iter->second);
      int64_t bits = 0;
      if (strNotifyType == "all") {
        bits &= ~nim::kNIMTeamBitsConfigMaskMuteNotify;
      } else if (strNotifyType == "manager") {
        bits |= nim::kNIMTeamBitsConfigMaskOnlyAdmin;
      } else if (strNotifyType == "mute") {
        bits |= nim::kNIMTeamBitsConfigMaskMuteNotify;
      }
      prop.SetBits(bits);
    }
  }

  bool res = nim::Team::UpdateMyPropertyAsync(
      prop, [=](const nim::TeamEvent& team_event) {
        if (team_event.res_code_ == nim::kNIMResSuccess) {
          result->Success(NimResult::getSuccessResult());
        } else {
          result->Error("", "",
                        NimResult::getErrorResult(team_event.res_code_,
                                                  "muteTeam failed"));
        }
      });

  if (!res) {
    result->Error("", "", NimResult::getErrorResult(-1, "muteTeam failed"));
  }
}

bool FLTTeamService::getTeamId(const flutter::EncodableMap* arguments,
                               std::string& teamId) {
  auto iter = arguments->find(flutter::EncodableValue("teamId"));
  if (iter != arguments->end()) {
    if (iter->second.IsNull()) {
      return false;
    }

    teamId = std::get<std::string>(iter->second);
    return true;
  }

  return false;
}

void FLTTeamService::convertNIMTeamInfoToDartTeamInfo(
    flutter::EncodableMap& argments, const nim::TeamInfo& info,
    const std::list<nim::TeamMemberProperty>& all_my_member_info_list) {
  argments.insert(std::make_pair("id", info.GetTeamID()));
  argments.insert(std::make_pair("name", info.GetName()));
  argments.insert(std::make_pair("icon", info.GetIcon()));
  argments.insert(std::make_pair("announcement", info.GetAnnouncement()));
  argments.insert(std::make_pair("introduce", info.GetIntro()));
  argments.insert(std::make_pair("creator", info.GetOwnerID()));
  argments.insert(std::make_pair("memberCount", info.GetMemberCount()));
  argments.insert(std::make_pair("memberLimit", info.GetMemberMaxCount()));
  argments.insert(std::make_pair("createTime", info.GetCreateTimetag()));
  argments.insert(std::make_pair("extension", info.GetCustom()));
  argments.insert(std::make_pair(
      "isAllMute", info.GetMuteType() == nim::kNIMTeamMuteTypeAllMute));
  argments.insert(std::make_pair("extServer", info.GetServerCustom()));
  argments.insert(std::make_pair("isMyTeam", true));  // todo

  std::string messageNotifyType = "all";
  if (all_my_member_info_list.size() != 0) {
    auto teamID = info.GetTeamID();
    auto findIt = std::find_if(all_my_member_info_list.begin(),
                               all_my_member_info_list.end(),
                               [teamID](const auto& member_info) {
                                 return teamID == member_info.GetTeamID();
                               });
    if (all_my_member_info_list.end() != findIt) {
      auto member_info = *findIt;
      auto bits = member_info.GetBits();
      if (bits == 0) {
        messageNotifyType = "all";
      } else if (bits == 1) {
        messageNotifyType = "mute";
      } else if (bits == 2) {
        messageNotifyType = "manager";
      }
    }
  }
  argments.insert(std::make_pair("messageNotifyType", messageNotifyType));

  std::string strTeamType;
  Convert::getInstance()->convertNIMEnumToDartString(
      info.GetType(), Convert::getInstance()->getTeamType(), strTeamType);
  argments.insert(std::make_pair("type", strTeamType));

  std::string strVerifyType;
  Convert::getInstance()->convertNIMEnumToDartString(
      info.GetJoinMode(), Convert::getInstance()->getTeamJoinMode(),
      strVerifyType);
  argments.insert(std::make_pair("verifyType", strVerifyType));

  std::string strInviteMode;
  Convert::getInstance()->convertNIMEnumToDartString(
      info.GetInviteMode(), Convert::getInstance()->getTeamInviteMode(),
      strInviteMode);
  argments.insert(std::make_pair("teamInviteMode", strInviteMode));

  std::string strBeInviteMode;
  Convert::getInstance()->convertNIMEnumToDartString(
      info.GetBeInviteMode(), Convert::getInstance()->getTeamBeInviteMode(),
      strBeInviteMode);
  argments.insert(std::make_pair("teamBeInviteModeEnum", strBeInviteMode));

  std::string strTeamUpdateMode;
  Convert::getInstance()->convertNIMEnumToDartString(
      info.GetUpdateInfoMode(), Convert::getInstance()->getTeamUpdateInfoMode(),
      strTeamUpdateMode);
  argments.insert(std::make_pair("teamUpdateMode", strTeamUpdateMode));

  std::string strTeamExtensionUpdateMode;
  Convert::getInstance()->convertNIMEnumToDartString(
      info.GetUpdateCustomMode(),
      Convert::getInstance()->getTeamUpdateCustomMode(),
      strTeamExtensionUpdateMode);
  argments.insert(
      std::make_pair("teamExtensionUpdateMode", strTeamExtensionUpdateMode));

  std::string strMuteMode;
  Convert::getInstance()->convertNIMEnumToDartString(
      info.GetMuteType(), Convert::getInstance()->getTeamMuteType(),
      strMuteMode);
  argments.insert(std::make_pair("muteMode", strMuteMode));
}

void FLTTeamService::convertNIMTeamMemberToDartTeamMember(
    flutter::EncodableMap& argments, const nim::TeamMemberProperty& member) {
  argments.insert(std::make_pair("id", member.GetTeamID()));
  argments.insert(std::make_pair("account", member.GetAccountID()));
  argments.insert(std::make_pair("teamNick", member.GetNick()));
  argments.insert(std::make_pair("isInTeam", member.IsValid()));
  flutter::EncodableMap extensionMap;
  nim_cpp_wrapper_util::Json::Value value;
  value =
      Convert::getInstance()->getJsonValueFromJsonString(member.GetCustom());
  Convert::getInstance()->convertJson2Map(extensionMap, value);
  argments.insert(std::make_pair("extension", extensionMap));
  argments.insert(std::make_pair("isMute", member.IsMute()));
  argments.insert(std::make_pair("joinTime", member.GetCreateTimetag()));
  argments.insert(std::make_pair("invitorAccid", member.GetInvitorAccID()));
  std::string strTeamMemberType;
  Convert::getInstance()->convertNIMEnumToDartString(
      member.GetUserType(), Convert::getInstance()->getTeamMemberType(),
      strTeamMemberType);
  argments.insert(std::make_pair("type", strTeamMemberType));
}

void FLTTeamService::teamEventCallback(const nim::TeamEvent& team_event) {
  flutter::EncodableMap result_map;
  flutter::EncodableList teamList;
  flutter::EncodableMap team_info_map;
  std::list<nim::TeamMemberProperty> all_my_member_info_list;
  all_my_member_info_list.push_back(team_event.member_property_);
  convertNIMTeamInfoToDartTeamInfo(team_info_map, team_event.team_info_,
                                   all_my_member_info_list);
  teamList.emplace_back(team_info_map);

  if (nim::kNIMNotificationIdTeamKick == team_event.notification_id_ ||
      nim::kNIMNotificationIdTeamDismiss == team_event.notification_id_ ||
      nim::kNIMNotificationIdTeamLeave == team_event.notification_id_) {
    result_map.insert(std::make_pair("team", teamList));
    notifyEvent("onTeamListRemove", result_map);
  } else if (nim::kNIMNotificationIdTeamSyncCreate ==
                 team_event.notification_id_ ||
             nim::kNIMNotificationIdTeamUpdate == team_event.notification_id_) {
    result_map.insert(std::make_pair("teamList", teamList));
    notifyEvent("onTeamListUpdate", result_map);
  }

  FLTMessageService* pFLTMessageService =
      NimCore::getInstance()->getFLTMessageService();
  if (pFLTMessageService) {
    pFLTMessageService->TeamEventCB(team_event);
  }
}
