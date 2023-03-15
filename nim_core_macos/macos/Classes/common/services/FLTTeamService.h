// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#ifndef FLTTEAMSERVICE_H
#define FLTTEAMSERVICE_H

#include "../FLTService.h"
class FLTTeamService : public FLTService {
 public:
  FLTTeamService();
  virtual ~FLTTeamService();
  virtual void onMethodCalled(
      const std::string& method, const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result)
      override;

 private:
  void createTeam(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void queryTeamList(
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void queryTeam(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void searchTeam(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void dismissTeam(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void searchTeamIdByName(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void searchTeamsByKeyword(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void applyJoinTeam(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void passApply(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void addMembersEx(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void acceptInvite(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void declineInvite(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void getMemberInvitor(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void removeMembers(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void quitTeam(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void queryMemberList(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void queryTeamMember(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void updateMemberNick(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void isMyTeam(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void transferTeam(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void addManagers(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void removeManagers(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void muteTeamMember(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void muteAllTeamMember(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void queryMutedTeamMembers(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void updateTeamFields(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void updateTeam(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void muteTeam(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void updateMyMemberExtension(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

 private:
  bool getTeamId(const flutter::EncodableMap* arguments, std::string& teamId);
  void convertNIMTeamInfoToDartTeamInfo(
      flutter::EncodableMap& argments, const nim::TeamInfo& info,
      const std::list<nim::TeamMemberProperty>& all_my_member_info_list = {});
  void convertNIMTeamMemberToDartTeamMember(
      flutter::EncodableMap& argments, const nim::TeamMemberProperty& member);

 private:
  void teamEventCallback(const nim::TeamEvent& team_event);
};

#endif  // FLTTEAMSERVICE_H
