// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#ifndef FLTUSERSERVICE_H
#define FLTUSERSERVICE_H

#include "../FLTService.h"

class FLTUserService : public FLTService {
 public:
  FLTUserService();
  virtual ~FLTUserService();
  virtual void onMethodCalled(
      const std::string& method, const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result)
      override;

 private:
  void getUserInfo(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void fetchUserInfoList(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void updateMyUserInfo(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void searchUserInfoListByKeyword(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void getBlackList(
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void addToBlackList(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void removeFromBlackList(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void getMuteList(
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void setMute(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void IsInBlackList(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void IsMute(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void searchUserIdListByNick(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

  void getFriendList(
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void getFriend(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void addFriend(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void ackAddFriend(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void deleteFriend(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void updateFriend(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void isMyFriend(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

 private:
  void friendChangeCallback(const nim::FriendChangeEvent& event);
  void specialRelationshipChangedCallback(
      const nim::SpecialRelationshipChangeEvent& event);
  void userNameCardChangedCallback(
      const std::list<nim::UserNameCard>& userList);
  void dataSyncCallback(nim::NIMDataSyncType sync_type,
                        nim::NIMDataSyncStatus status,
                        const std::string& data_sync_info);
};

#endif  // FLTUSERSERVICE_H
