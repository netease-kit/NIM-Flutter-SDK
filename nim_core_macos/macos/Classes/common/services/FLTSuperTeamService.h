// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#ifndef FLTSUPERTEAMSERVICE_H
#define FLTSUPERTEAMSERVICE_H

#include "../FLTService.h"

class FLTSuperTeamService : public FLTService {
 public:
  FLTSuperTeamService();
  virtual ~FLTSuperTeamService();
  virtual void onMethodCalled(
      const std::string& method, const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result)
      override;

 private:
  DECLARE_FUN(queryTeamList);
  DECLARE_FUN(queryTeam);
  DECLARE_FUN(searchTeam);

  DECLARE_FUN(applyJoinTeam);
  DECLARE_FUN(passApply);
  DECLARE_FUN(rejectApply);
  DECLARE_FUN(addMembers);
  DECLARE_FUN(declineInvite);
  DECLARE_FUN(removeMembers);
  DECLARE_FUN(quitTeam);
  DECLARE_FUN(queryMemberList);
  DECLARE_FUN(queryTeamMember);
  DECLARE_FUN(queryMemberListByPage);
  DECLARE_FUN(updateMemberNick);
  DECLARE_FUN(updateMyTeamNick);
  DECLARE_FUN(updateMyMemberExtension);
  DECLARE_FUN(transferTeam);
  DECLARE_FUN(addManagers);
  DECLARE_FUN(removeManagers);
  DECLARE_FUN(muteTeamMember);
  DECLARE_FUN(muteAllTeamMember);
  DECLARE_FUN(queryMutedTeamMembers);
  DECLARE_FUN(muteTeam);

  DECLARE_FUN(updateTeamFields);
  DECLARE_FUN(searchTeamIdByName);
  DECLARE_FUN(searchTeamsByKeyword);

 private:
  bool getTeamId(const flutter::EncodableMap* arguments, std::string& teamId);
  void convertNIMTeamInfoToDartTeamInfo(flutter::EncodableMap& argments,
                                        const nim::SuperTeamInfo& info);
  void convertNIMTeamMemberToDartTeamMember(
      flutter::EncodableMap& argments,
      const nim::SuperTeamMemberProperty& member);

 private:
  void teamEventCallback(const nim::SuperTeamEvent& team_event);
};

#endif  // FLTSUPERTEAMSERVICE_H
