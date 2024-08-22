// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#ifndef V2FLTTeamService_H
#define V2FLTTeamService_H

#include "../FLTService.h"
#include "v2_nim_def_enum.hpp"
#include "v2_nim_team_service.hpp"

class V2FLTTeamService : public FLTService {
 public:
  V2FLTTeamService();
  virtual ~V2FLTTeamService();
  virtual void onMethodCalled(
      const std::string& method, const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result)
      override;

 private:
  void createTeam(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void updateTeam(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void leaveTeam(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void getTeamInfo(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void getTeamInfoByIds(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void dismissTeam(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void inviteMember(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void acceptInvitation(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void rejectInvitation(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void kickMember(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void applyJoinTeam(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void acceptJoinApplication(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void rejectJoinApplication(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void updateTeamMemberRole(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void transferTeamOwner(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void updateSelfTeamMemberInfo(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void updateTeamMemberNick(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void setTeamChatBannedMode(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void setTeamMemberChatBannedStatus(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void getJoinedTeamList(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void getJoinedTeamCount(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void getTeamMemberList(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void getTeamMemberListByIds(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void getTeamMemberInvitor(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void getTeamJoinActionInfoList(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void searchTeamByKeyword(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void searchTeamMembers(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

  // 开始监听
  void startTeamEventListening();

 private:
  void convertV2NIMTeamToMap(flutter::EncodableMap& argments,
                             const v2::V2NIMTeam& team);
  void convertMapToV2NIMTeam(const flutter::EncodableMap& arguments,
                             v2::V2NIMTeam& team);

  void convertV2NIMCreateTeamResultToMap(
      flutter::EncodableMap& arguments,
      const v2::V2NIMCreateTeamResult& result);
  void convertMapToV2NIMCreateTeamParam(const flutter::EncodableMap& arguments,
                                        v2::V2NIMCreateTeamResult& result);

  void convertV2NIMTeamMemberListResultToMap(
      flutter::EncodableMap& arguments,
      const v2::V2NIMTeamMemberListResult& result);
  void convertMapToV2NIMTeamMemberListResult(
      const flutter::EncodableMap& arguments,
      v2::V2NIMTeamMemberListResult& result);

  void convertV2NIMTeamMemberToMap(flutter::EncodableMap& arguments,
                                   const v2::V2NIMTeamMember& member);
  void convertMapToV2NIMTeamMember(const flutter::EncodableMap& arguments,
                                   v2::V2NIMTeamMember& member);

  void convertV2NIMTeamJoinActionInfoResultToMap(
      flutter::EncodableMap& arguments,
      const v2::V2NIMTeamJoinActionInfoResult& result);
  void convertMapToV2NIMTeamJoinActionInfoResult(
      const flutter::EncodableMap& arguments,
      v2::V2NIMTeamJoinActionInfoResult& result);

  void convertV2NIMTeamJoinActionInfoToMap(
      flutter::EncodableMap& arguments,
      const v2::V2NIMTeamJoinActionInfo& info);
  void convertMapToV2NIMTeamJoinActionInfo(
      const flutter::EncodableMap& arguments,
      v2::V2NIMTeamJoinActionInfo& info);

 private:
  v2::V2NIMTeamListener listener;
};

#endif /* V2FLTTeamService_hpp */
