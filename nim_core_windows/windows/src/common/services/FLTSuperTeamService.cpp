// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#include "FLTSuperTeamService.h"

#include "../FLTConvert.h"
#include "FLTMessageService.h"
#include "nim_cpp_wrapper/nim_cpp_api.h"

FLTSuperTeamService::FLTSuperTeamService() {
  m_serviceName = "SuperTeamService";
  nim::SuperTeam::RegSuperTeamEventCb(std::bind(
      &FLTSuperTeamService::teamEventCallback, this, std::placeholders::_1));
}

FLTSuperTeamService::~FLTSuperTeamService() {
  nim::SuperTeam::UnregSuperTeamCb();
}

void FLTSuperTeamService::onMethodCalled(
    const std::string& method, const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  switch (utils::hash_(method.c_str())) {
    case "queryTeamList"_hash:
      queryTeamList(arguments, result);
      return;
    case "queryTeam"_hash:
      queryTeam(arguments, result);
      return;
    case "searchTeam"_hash:
      searchTeam(arguments, result);
      return;
    case "applyJoinTeam"_hash:
      applyJoinTeam(arguments, result);
      return;
    case "passApply"_hash:
      passApply(arguments, result);
      return;
    case "rejectApply"_hash:
      rejectApply(arguments, result);
      return;
    case "addMembers"_hash:
      addMembers(arguments, result);
      return;
    case "removeMembers"_hash:
      removeMembers(arguments, result);
      return;
    case "declineInvite"_hash:
      declineInvite(arguments, result);
      return;
    case "quitTeam"_hash:
      quitTeam(arguments, result);
      return;
    case "queryMemberList"_hash:
      queryMemberList(arguments, result);
      return;
    case "queryTeamMember"_hash:
      queryTeamMember(arguments, result);
      return;
    case "queryMemberListByPage"_hash:
      queryMemberListByPage(arguments, result);
      return;
    case "updateMemberNick"_hash:
      updateMemberNick(arguments, result);
      return;
    case "updateMyTeamNick"_hash:
      updateMyTeamNick(arguments, result);
      return;
    case "updateMyMemberExtension"_hash:
      updateMyMemberExtension(arguments, result);
      return;
    case "transferTeam"_hash:
      transferTeam(arguments, result);
      return;
    case "addManagers"_hash:
      addManagers(arguments, result);
      return;
    case "removeManagers"_hash:
      removeManagers(arguments, result);
      return;
    case "muteTeam"_hash:
      muteTeam(arguments, result);
      return;
    case "muteTeamMembers"_hash:
      muteTeamMember(arguments, result);
      return;
    case "muteAllTeamMember"_hash:
      muteAllTeamMember(arguments, result);
      return;
    case "queryMutedTeamMembers"_hash:
      queryMutedTeamMembers(arguments, result);
      return;
    case "updateTeamFields"_hash:
      updateTeamFields(arguments, result);
      return;
    case "searchTeamIdByName"_hash:
      searchTeamIdByName(arguments, result);
      return;
    case "searchTeamsByKeyword"_hash:
      searchTeamsByKeyword(arguments, result);
      return;
    default:
      break;
  }
  if (result) result->NotImplemented();
}

void FLTSuperTeamService::queryTeamList(const flutter::EncodableMap* arguments,
                                        FLTService::MethodResult result) {
  nim::SuperTeam::QueryAllMySuperTeamsInfoAsync(
      [=](int team_count, const std::list<nim::SuperTeamInfo>& team_info_list) {
        flutter::EncodableMap arguments;
        flutter::EncodableList teamInfoList;
        for (auto team_info : team_info_list) {
          flutter::EncodableMap teamInfoMap;
          convertNIMTeamInfoToDartTeamInfo(teamInfoMap, team_info);
          teamInfoList.emplace_back(teamInfoMap);
        }
        arguments.insert(std::make_pair("teamList", teamInfoList));
        result->Success(NimResult::getSuccessResult(arguments));
      });
}

void FLTSuperTeamService::queryTeam(const flutter::EncodableMap* arguments,
                                    FLTService::MethodResult result) {
  std::string tid;
  if (!getTeamId(arguments, tid)) {
    result->Error("", "",
                  NimResult::getErrorResult(-1, "queryTeam params error"));
    return;
  }
  bool res = nim::SuperTeam::QuerySuperTeamInfoAsync(
      tid, [=](const std::string& tid, const nim::SuperTeamInfo& team_info) {
        flutter::EncodableMap teamInfoMap;
        convertNIMTeamInfoToDartTeamInfo(teamInfoMap, team_info);
        result->Success(NimResult::getSuccessResult(teamInfoMap));
      });

  if (!res) {
    result->Error("", "", NimResult::getErrorResult(-1, "queryTeam failed"));
  }
}

void FLTSuperTeamService::searchTeam(const flutter::EncodableMap* arguments,
                                     FLTService::MethodResult result) {
  std::string tid;
  if (!getTeamId(arguments, tid)) {
    result->Error("", "",
                  NimResult::getErrorResult(-1, "searchTeam params error"));
    return;
  }

  bool res = nim::SuperTeam::QuerySuperTeamInfoOnlineAsync(
      tid, [=](const nim::SuperTeamEvent& team_event) {
        if (team_event.res_code_ == nim::kNIMResSuccess) {
          flutter::EncodableMap teamInfoMap;
          convertNIMTeamInfoToDartTeamInfo(teamInfoMap, team_event.team_info_);
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

void FLTSuperTeamService::applyJoinTeam(const flutter::EncodableMap* arguments,
                                        FLTService::MethodResult result) {
  auto teamIdIt = arguments->find(flutter::EncodableValue("teamId"));
  if (teamIdIt == arguments->end() || teamIdIt->second.IsNull()) {
    if (result) {
      result->Error(
          "", "",
          NimResult::getErrorResult(-1, "applyJoinTeam but teamId is empty!"));
    }
    return;
  }

  std::string teamId = std::get<std::string>(teamIdIt->second);
  std::string postscript;
  auto postscriptIt = arguments->find(flutter::EncodableValue("postscript"));
  if (postscriptIt != arguments->end() && !postscriptIt->second.IsNull()) {
    postscript = std::get<std::string>(postscriptIt->second);
  }

  bool res = nim::SuperTeam::ApplyJoinAsync(
      teamId, postscript,
      [this, result](const nim::SuperTeamEvent& team_event) {
        if (!result) {
          return;
        }

        if (nim::kNIMResSuccess == team_event.res_code_) {
          flutter::EncodableMap teamInfoMap;
          convertNIMTeamInfoToDartTeamInfo(teamInfoMap, team_event.team_info_);
          result->Success(NimResult::getSuccessResult(teamInfoMap));
        } else {
          result->Error("", "",
                        NimResult::getErrorResult(team_event.res_code_,
                                                  "applyJoinTeam failed!"));
        }
      });

  if (!res) {
    result->Error("", "",
                  NimResult::getErrorResult(-1, "applyJoinTeam error!"));
  }
}

void FLTSuperTeamService::passApply(const flutter::EncodableMap* arguments,
                                    FLTService::MethodResult result) {
  auto teamIdIt = arguments->find(flutter::EncodableValue("teamId"));
  if (teamIdIt == arguments->end() || teamIdIt->second.IsNull()) {
    if (result) {
      result->Error(
          "", "",
          NimResult::getErrorResult(-1, "passApply but teamId is empty!"));
    }
    return;
  }
  std::string teamId = std::get<std::string>(teamIdIt->second);

  auto accountIt = arguments->find(flutter::EncodableValue("account"));
  if (accountIt == arguments->end() || accountIt->second.IsNull()) {
    if (result) {
      result->Error(
          "", "",
          NimResult::getErrorResult(-1, "passApply but account is empty!"));
    }
    return;
  }
  std::string account = std::get<std::string>(accountIt->second);

  bool res = nim::SuperTeam::PassJoinApplyAsync(
      teamId, account, [this, result](const nim::SuperTeamEvent& team_event) {
        if (!result) {
          return;
        }

        if (nim::kNIMResSuccess == team_event.res_code_) {
          result->Success(NimResult::getSuccessResult());
        } else {
          result->Error("", "",
                        NimResult::getErrorResult(team_event.res_code_,
                                                  "passApply failed!"));
        }
      });

  if (!res) {
    result->Error("", "", NimResult::getErrorResult(-1, "passApply error!"));
  }
}

void FLTSuperTeamService::rejectApply(const flutter::EncodableMap* arguments,
                                      FLTService::MethodResult result) {
  std::string teamId = "";
  std::string account = "";
  std::string reason = "";

  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) continue;

    if (iter->first == flutter::EncodableValue("teamId")) {
      teamId = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("account")) {
      account = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("reason")) {
      reason = std::get<std::string>(iter->second);
    }
  }

  bool res = nim::SuperTeam::RejectJoinApplyAsync(
      teamId, account, reason, [=](const nim::SuperTeamEvent& team_event) {
        if (nim::kNIMResSuccess == team_event.res_code_) {
          result->Success(NimResult::getSuccessResult());
        } else {
          result->Error("", "",
                        NimResult::getErrorResult(team_event.res_code_,
                                                  "rejectApply failed!"));
        }
      });

  if (!res) {
    result->Error("", "", NimResult::getErrorResult(-1, "rejectApply error!"));
  }
}

void FLTSuperTeamService::addMembers(const flutter::EncodableMap* arguments,
                                     FLTService::MethodResult result) {
  std::string tid;
  std::string invitation_postscript;
  std::list<std::string> ids;

  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) continue;

    if (iter->first == flutter::EncodableValue("teamId")) {
      tid = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("accountList")) {
      auto accounts = std::get<flutter::EncodableList>(iter->second);
      for (auto account : accounts) {
        ids.emplace_back(std::get<std::string>(account));
      }
    } else if (iter->first == flutter::EncodableValue("msg")) {
      // 不支持
      invitation_postscript = std::get<std::string>(iter->second);
    }
  }

  bool res = nim::SuperTeam::InviteAsync(
      tid, ids, [result](const nim::SuperTeamEvent& team_event) {
        if (!result) {
          return;
        }

        if (team_event.res_code_ == nim::kNIMResSuccess) {
          flutter::EncodableMap result_map;
          flutter::EncodableList teamMemberExList;
          for (auto teamMember : team_event.ids_) {
            teamMemberExList.emplace_back(teamMember);
          }
          result_map.insert(std::make_pair("teamMemberList", teamMemberExList));
          result->Success(NimResult::getSuccessResult(result_map));
        } else {
          result->Error("", "",
                        NimResult::getErrorResult(team_event.res_code_,
                                                  "addMembers failed"));
        }
      });

  if (!res) {
    result->Error("", "", NimResult::getErrorResult(-1, "addMembers failed"));
  }
}

void FLTSuperTeamService::declineInvite(const flutter::EncodableMap* arguments,
                                        FLTService::MethodResult result) {
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

  bool res = nim::SuperTeam::RejectInvitationAsync(
      teamId, inviter, reason, [=](const nim::SuperTeamEvent& team_event) {
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

void FLTSuperTeamService::removeMembers(const flutter::EncodableMap* arguments,
                                        FLTService::MethodResult result) {
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

  bool res = nim::SuperTeam::KickAsync(
      tid, ids, [result](const nim::SuperTeamEvent& team_event) {
        if (!result) {
          return;
        }

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

void FLTSuperTeamService::quitTeam(const flutter::EncodableMap* arguments,
                                   FLTService::MethodResult result) {
  std::string tid;
  if (!getTeamId(arguments, tid)) {
    result->Error("", "",
                  NimResult::getErrorResult(-1, "quitTeam params error"));
    return;
  }
  bool res = nim::SuperTeam::LeaveAsync(
      tid, [=](const nim::SuperTeamEvent& team_event) {
        if (team_event.res_code_ == nim::kNIMResSuccess) {
          result->Success(NimResult::getSuccessResult());
        } else {
          result->Error("", "",
                        NimResult::getErrorResult(team_event.res_code_,
                                                  "quitTeam failed"));
        }
      });

  if (!res) {
    result->Error("", "", NimResult::getErrorResult(-1, "quitTeam failed"));
  }
}

void FLTSuperTeamService::queryMemberList(
    const flutter::EncodableMap* arguments, FLTService::MethodResult result) {
  std::string tid;
  if (!getTeamId(arguments, tid)) {
    result->Error(
        "", "", NimResult::getErrorResult(-1, "queryMemberList params error"));
    return;
  }

  bool res = nim::SuperTeam::QuerySuperTeamMembersAsync(
      tid,
      [=](nim::NIMResCode error_code, const std::string& tid, int member_count,
          const std::list<nim::SuperTeamMemberProperty>& props) {
        if (error_code == nim::kNIMResSuccess) {
          flutter::EncodableMap result_map;
          flutter::EncodableList members;
          for (auto prop : props) {
            flutter::EncodableMap member;
            convertNIMTeamMemberToDartTeamMember(member, prop);
            members.emplace_back(member);
          }
          result_map.insert(std::make_pair("teamMemberList", members));
          result->Success(NimResult::getSuccessResult(result_map));
        } else {
          result->Error(
              "", "",
              NimResult::getErrorResult(error_code, "queryMemberList failed"));
        }
      });

  if (!res) {
    result->Error("", "",
                  NimResult::getErrorResult(-1, "queryMemberList failed"));
  }
}

void FLTSuperTeamService::queryTeamMember(
    const flutter::EncodableMap* arguments, FLTService::MethodResult result) {
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

  bool res = nim::SuperTeam::QuerySuperTeamMemberAsync(
      tid, id, [=](const nim::SuperTeamMemberProperty& team_member_property) {
        flutter::EncodableMap member;
        convertNIMTeamMemberToDartTeamMember(member, team_member_property);
        result->Success(NimResult::getSuccessResult(member));
      });

  if (!res) {
    result->Error("", "",
                  NimResult::getErrorResult(-1, "queryTeamMember failed"));
  }
}

void FLTSuperTeamService::queryMemberListByPage(
    const flutter::EncodableMap* arguments, FLTService::MethodResult result) {
  // 不支持
  result->NotImplemented();
}

void FLTSuperTeamService::updateMemberNick(
    const flutter::EncodableMap* arguments, FLTService::MethodResult result) {
  nim::SuperTeamMemberProperty prop;

  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) continue;

    if (iter->first == flutter::EncodableValue("teamId")) {
      prop.SetSuperTeamID(std::get<std::string>(iter->second));
    } else if (iter->first == flutter::EncodableValue("account")) {
      prop.SetAccountID(std::get<std::string>(iter->second));
    } else if (iter->first == flutter::EncodableValue("nick")) {
      prop.SetNick(std::get<std::string>(iter->second));
    }
  }

  bool res = nim::SuperTeam::UpdateOtherNickAsync(
      prop, [=](const nim::SuperTeamEvent& team_event) {
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

void FLTSuperTeamService::updateMyTeamNick(
    const flutter::EncodableMap* arguments, FLTService::MethodResult result) {
  nim::SuperTeamMemberProperty prop;
  prop.SetAccountID(NimCore::getInstance()->getAccountId());

  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) continue;
    if (iter->first == flutter::EncodableValue("teamId")) {
      prop.SetSuperTeamID(std::get<std::string>(iter->second));
    } else if (iter->first == flutter::EncodableValue("nick")) {
      prop.SetNick(std::get<std::string>(iter->second));
    }
  }

  bool res = nim::SuperTeam::UpdateMyPropertyAsync(
      prop, [=](const nim::SuperTeamEvent& team_event) {
        if (team_event.res_code_ == nim::kNIMResSuccess) {
          result->Success(NimResult::getSuccessResult());
        } else {
          result->Error("", "",
                        NimResult::getErrorResult(team_event.res_code_,
                                                  "updateMyTeamNick failed"));
        }
      });

  if (!res) {
    result->Error("", "",
                  NimResult::getErrorResult(-1, "updateMyTeamNick failed"));
  }
}

void FLTSuperTeamService::updateMyMemberExtension(
    const flutter::EncodableMap* arguments, FLTService::MethodResult result) {
  nim::SuperTeamMemberProperty prop;

  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) continue;

    if (iter->first == flutter::EncodableValue("teamId")) {
      prop.SetSuperTeamID(std::get<std::string>(iter->second));
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

  bool res = nim::SuperTeam::UpdateMyPropertyAsync(
      prop, [=](const nim::SuperTeamEvent& team_event) {
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

void FLTSuperTeamService::transferTeam(const flutter::EncodableMap* arguments,
                                       FLTService::MethodResult result) {
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

  bool res = nim::SuperTeam::TransferTeamAsync(
      tid, new_owner_id, is_leave, [=](const nim::SuperTeamEvent& team_event) {
        if (team_event.res_code_ == nim::kNIMResSuccess) {
          nim::SuperTeam::QuerySuperTeamMembersAsync(
              tid, [=](nim::NIMResCode error_code, const std::string& tid,
                       int member_count,
                       const std::list<nim::SuperTeamMemberProperty>& props) {
                if (error_code == nim::kNIMResSuccess) {
                  flutter::EncodableMap result_map;
                  flutter::EncodableList members;
                  for (auto prop : props) {
                    flutter::EncodableMap member;
                    convertNIMTeamMemberToDartTeamMember(member, prop);
                    members.emplace_back(member);
                  }

                  result_map.insert(std::make_pair("teamMemberList", members));
                  result->Success(NimResult::getSuccessResult(result_map));
                } else {
                  result->Error("", "",
                                NimResult::getErrorResult(
                                    error_code, "transferTeam failed"));
                }
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

void FLTSuperTeamService::addManagers(const flutter::EncodableMap* arguments,
                                      FLTService::MethodResult result) {
  std::string tid;
  std::list<std::string> ids;

  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) continue;

    if (iter->first == flutter::EncodableValue("teamId")) {
      tid = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("accountList")) {
      auto accounts = std::get<flutter::EncodableList>(iter->second);
      for (auto account : accounts) {
        ids.emplace_back(std::get<std::string>(account));
      }
    }
  }

  bool res = nim::SuperTeam::AddManagersAsync(
      tid, ids, [=](const nim::SuperTeamEvent& team_event) {
        if (team_event.res_code_ == nim::kNIMResSuccess) {
          nim::SuperTeam::QuerySuperTeamMembersAsync(
              tid, [=](nim::NIMResCode error_code, const std::string& tid,
                       int member_count,
                       const std::list<nim::SuperTeamMemberProperty>& props) {
                if (error_code == nim::kNIMResSuccess) {
                  flutter::EncodableMap result_map;
                  flutter::EncodableList members;
                  for (auto prop : props) {
                    flutter::EncodableMap member;
                    convertNIMTeamMemberToDartTeamMember(member, prop);
                    members.emplace_back(member);
                  }

                  result_map.insert(std::make_pair("teamMemberList", members));
                  result->Success(NimResult::getSuccessResult(result_map));
                } else {
                  result->Error("", "",
                                NimResult::getErrorResult(
                                    error_code, "addManagers failed"));
                }
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

void FLTSuperTeamService::removeManagers(const flutter::EncodableMap* arguments,
                                         FLTService::MethodResult result) {
  std::string tid;
  std::list<std::string> ids;

  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) continue;

    if (iter->first == flutter::EncodableValue("teamId")) {
      tid = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("accountList")) {
      auto accounts = std::get<flutter::EncodableList>(iter->second);
      for (auto account : accounts) {
        ids.emplace_back(std::get<std::string>(account));
      }
    }
  }

  bool res = nim::SuperTeam::RemoveManagersAsync(
      tid, ids, [=](const nim::SuperTeamEvent& team_event) {
        if (team_event.res_code_ == nim::kNIMResSuccess) {
          nim::SuperTeam::QuerySuperTeamMembersAsync(
              tid, [=](nim::NIMResCode error_code, const std::string& tid,
                       int member_count,
                       const std::list<nim::SuperTeamMemberProperty>& props) {
                if (error_code == nim::kNIMResSuccess) {
                  flutter::EncodableMap result_map;
                  flutter::EncodableList members;
                  for (auto prop : props) {
                    flutter::EncodableMap member;
                    convertNIMTeamMemberToDartTeamMember(member, prop);
                    members.emplace_back(member);
                  }

                  result_map.insert(std::make_pair("teamMemberList", members));
                  result->Success(NimResult::getSuccessResult(result_map));
                } else {
                  result->Error("", "",
                                NimResult::getErrorResult(
                                    error_code, "removeManagers failed"));
                }
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

void FLTSuperTeamService::muteTeamMember(const flutter::EncodableMap* arguments,
                                         FLTService::MethodResult result) {
  std::string tid = "";
  std::string member_id = "";
  bool mute = false;

  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) continue;

    if (iter->first == flutter::EncodableValue("teamId")) {
      tid = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("accountList")) {
      auto accountList = std::get<flutter::EncodableList>(iter->second);
      if (accountList.size() < 0) {
        result->Error("", "",
                      NimResult::getErrorResult(
                          -1, "muteTeamMember failed, accountList is empty"));
        return;
      }
      member_id = std::get<std::string>(accountList[0]);  // 不支持设置多个
    } else if (iter->first == flutter::EncodableValue("mute")) {
      mute = std::get<bool>(iter->second);
    }
  }

  bool res = nim::SuperTeam::MuteMemberAsync(
      tid, member_id, mute, [=](const nim::SuperTeamEvent& team_event) {
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

void FLTSuperTeamService::muteAllTeamMember(
    const flutter::EncodableMap* arguments, FLTService::MethodResult result) {
  std::string tid;
  bool mute = false;

  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) continue;

    if (iter->first == flutter::EncodableValue("teamId")) {
      tid = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("mute")) {
      mute = std::get<bool>(iter->second);
    }
  }

  bool res = nim::SuperTeam::MuteAsync(
      tid, mute, [=](const nim::SuperTeamEvent& team_event) {
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

void FLTSuperTeamService::queryMutedTeamMembers(
    const flutter::EncodableMap* arguments, FLTService::MethodResult result) {
  std::string tid;
  if (!getTeamId(arguments, tid)) {
    result->Error(
        "", "",
        NimResult::getErrorResult(-1, "queryMutedTeamMembers params error"));
    return;
  }

  bool res = nim::SuperTeam::QueryMuteListAsync(
      tid,
      [=](nim::NIMResCode error_code, const std::string& tid, int member_count,
          const std::list<nim::SuperTeamMemberProperty>& props) {
        if (error_code == nim::kNIMResSuccess) {
          flutter::EncodableMap result_map;
          flutter::EncodableList members;
          for (auto prop : props) {
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

void FLTSuperTeamService::muteTeam(const flutter::EncodableMap* arguments,
                                   FLTService::MethodResult result) {
  nim::SuperTeamMemberProperty prop;

  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) continue;

    if (iter->first == flutter::EncodableValue("teamId")) {
      prop.SetSuperTeamID(std::get<std::string>(iter->second));
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

  bool res = nim::SuperTeam::UpdateMyPropertyAsync(
      prop, [=](const nim::SuperTeamEvent& team_event) {
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

void FLTSuperTeamService::updateTeamFields(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  std::string tid;
  nim::SuperTeamInfo team_info;
  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) continue;

    if (iter->first == flutter::EncodableValue("teamId")) {
      tid = std::get<std::string>(iter->second);
      team_info.SetSuperTeamID(tid);
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
          team_info.SetInviteMode(static_cast<nim::NIMSuperTeamInviteMode>(
              std::get<int>(request_iter->second)));
        } else if (request_iter->first ==
                   flutter::EncodableValue("maxMemberCount")) {
          team_info.SetMemberMaxCount(std::get<int>(request_iter->second));
        } else if (request_iter->first == flutter::EncodableValue("name")) {
          team_info.SetName(std::get<std::string>(request_iter->second));
        } else if (request_iter->first ==
                   flutter::EncodableValue("teamExtensionUpdateMode")) {
          team_info.SetUpdateCustomMode(
              static_cast<nim::NIMSuperTeamUpdateCustomMode>(
                  std::get<int>(request_iter->second)));
        } else if (request_iter->first ==
                   flutter::EncodableValue("teamUpdateMode")) {
          team_info.SetUpdateInfoMode(
              static_cast<nim::NIMSuperTeamUpdateInfoMode>(
                  std::get<int>(request_iter->second)));
        } else if (request_iter->first ==
                   flutter::EncodableValue("verifyType")) {
          team_info.SetJoinMode(static_cast<nim::NIMSuperTeamJoinMode>(
              std::get<int>(request_iter->second)));
        }
      }
    }
  }

  bool res = nim::SuperTeam::UpdateSuperTeamInfoAsync(
      tid, team_info, [=](const nim::SuperTeamEvent& team_event) {
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

void FLTSuperTeamService::searchTeamIdByName(
    const flutter::EncodableMap* arguments, FLTService::MethodResult result) {
  result->NotImplemented();
}

void FLTSuperTeamService::searchTeamsByKeyword(
    const flutter::EncodableMap* arguments, FLTService::MethodResult result) {
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
  bool res = nim::SuperTeam::QuerySuperTeamsInfoByKeywordAsync(
      keyword,
      [=](int team_count, const std::list<nim::SuperTeamInfo>& team_info_list) {
        flutter::EncodableMap result_map;
        flutter::EncodableList teamInfoList;
        for (auto team_info : team_info_list) {
          flutter::EncodableMap teamInfoMap;
          convertNIMTeamInfoToDartTeamInfo(teamInfoMap, team_info);
          teamInfoList.emplace_back(teamInfoMap);
        }
        result_map.insert(std::make_pair("teamList", teamInfoList));
        result->Success(NimResult::getSuccessResult(result_map));
      });

  if (!res) {
    result->Error("", "",
                  NimResult::getErrorResult(-1, "searchTeamsByKeyword failed"));
  }
}

bool FLTSuperTeamService::getTeamId(const flutter::EncodableMap* arguments,
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

void FLTSuperTeamService::convertNIMTeamInfoToDartTeamInfo(
    flutter::EncodableMap& argments, const nim::SuperTeamInfo& info) {
  argments.insert(std::make_pair("id", info.GetSuperTeamID()));
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
  argments.insert(std::make_pair("isMyTeam", true));            // todo
  argments.insert(std::make_pair("messageNotifyType", "all"));  // todo
  argments.insert(std::make_pair("type", "superTeam"));

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

void FLTSuperTeamService::convertNIMTeamMemberToDartTeamMember(
    flutter::EncodableMap& argments,
    const nim::SuperTeamMemberProperty& member) {
  argments.insert(std::make_pair("id", member.GetSuperTeamID()));
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
  std::string strTeamMemberType;
  Convert::getInstance()->convertNIMEnumToDartString(
      member.GetUserType(), Convert::getInstance()->getTeamMemberType(),
      strTeamMemberType);
  argments.insert(std::make_pair("type", strTeamMemberType));
}

void FLTSuperTeamService::teamEventCallback(
    const nim::SuperTeamEvent& team_event) {
  YXLOG(Info) << "teamEventCallback: " << team_event.notification_id_
              << YXLOGEnd;

  flutter::EncodableMap result_map;
  flutter::EncodableList teamList;
  flutter::EncodableMap team_info_map;
  convertNIMTeamInfoToDartTeamInfo(team_info_map, team_event.team_info_);
  teamList.emplace_back(team_info_map);

  if (nim::kNIMNotificationIdSuperTeamDismiss == team_event.notification_id_) {
    result_map.insert(std::make_pair("team", team_info_map));
    notifyEvent("onSuperTeamRemove", result_map);
  } else if (nim::kNIMNotificationIdSuperTeamUpdate ==
             team_event.notification_id_) {
    result_map.insert(std::make_pair("teamList", teamList));
    notifyEvent("onSuperTeamUpdate", result_map);
  } else if (nim::kNIMNotificationIdTeamMemberChanged ==
                 team_event.notification_id_ ||
             nim::kNIMNotificationIdSuperTeamAddManager ==
                 team_event.notification_id_ ||
             nim::kNIMNotificationIdSuperTeamRemoveManager ==
                 team_event.notification_id_ ||
             nim::kNIMNotificationIdSuperTeamMuteMember ==
                 team_event.notification_id_ ||
             nim::kNIMNotificationIdTeamSyncUpdateMemberProperty ==
                 team_event.notification_id_ ||
             nim::kNIMNotificationIdSuperTeamInvite ==
                 team_event.notification_id_ ||
             nim::kNIMNotificationIdSuperTeamOwnerTransfer ==
                 team_event.notification_id_ ||
             nim::kNIMNotificationIdSuperTeamApplyPass ==
                 team_event.notification_id_ ||
             nim::kNIMNotificationIdSuperTeamInviteAccept ==
                 team_event.notification_id_) {
    for (auto id : team_event.ids_) {
      nim::SuperTeam::QuerySuperTeamMemberAsync(
          team_event.team_id_, id,
          [this](const nim::SuperTeamMemberProperty& team_member_property) {
            flutter::EncodableMap result_map;
            flutter::EncodableList memberList;
            flutter::EncodableMap memberMap;
            convertNIMTeamMemberToDartTeamMember(memberMap,
                                                 team_member_property);
            memberList.emplace_back(memberMap);
            result_map.insert(std::make_pair("teamMemberList", memberList));
            notifyEvent("onSuperTeamMemberUpdate", result_map);
          });
    }
  } else if (nim::kNIMNotificationIdSuperTeamLeave ==
                 team_event.notification_id_ ||
             nim::kNIMNotificationIdSuperTeamKick ==
                 team_event.notification_id_) {
    std::string myAccount = NimCore::getInstance()->getAccountId();
    auto it =
        std::find(team_event.ids_.begin(), team_event.ids_.end(), myAccount);
    if (it == team_event.ids_.end()) {
      flutter::EncodableList memberList;
      for (auto member : team_event.namecards_) {
        flutter::EncodableMap memberMap;
        nim::SuperTeamMemberProperty memberProperty;
        memberProperty.SetAccountID(member.GetAccId());
        memberProperty.SetSuperTeamID(team_event.team_id_);
        memberProperty.SetNick(member.GetName());
        convertNIMTeamMemberToDartTeamMember(memberMap, memberProperty);
        memberList.emplace_back(memberMap);
      }
      result_map.insert(std::make_pair("teamMemberList", memberList));
      notifyEvent("onSuperTeamMemberRemove", result_map);
    } else {
      // 自己退出或者被踢出超大群
      result_map.insert(std::make_pair("team", team_info_map));
      notifyEvent("onSuperTeamRemove", result_map);
    }
  }
}