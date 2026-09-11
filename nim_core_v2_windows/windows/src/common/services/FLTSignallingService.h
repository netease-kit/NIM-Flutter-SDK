// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#ifndef FLTSignallingService_H
#define FLTSignallingService_H

#include "../FLTService.h"
#include "v2_nim_api.hpp"
#include "v2_nim_def_struct.hpp"
#include "v2_nim_message_service.hpp"
#include "v2_nim_notification_service.hpp"

v2::V2NIMSignallingCallParams getSignallingCallParams(
    const flutter::EncodableMap* arguments);

v2::V2NIMSignallingCallSetupParams getSignallingCallSetupParams(
    const flutter::EncodableMap* arguments);

v2::V2NIMSignallingConfig getSignallingConfig(
    const flutter::EncodableMap* arguments);

v2::V2NIMSignallingPushConfig getSignallingPushConfig(
    const flutter::EncodableMap* arguments);

v2::V2NIMSignallingRtcConfig getSignallingRtcConfig(
    const flutter::EncodableMap* arguments);

v2::V2NIMSignallingCancelInviteParams getSignallingCancelInviteParams(
    const flutter::EncodableMap* arguments);

v2::V2NIMSignallingJoinParams getSignallingJoinParams(
    const flutter::EncodableMap* arguments);

v2::V2NIMSignallingInviteParams getSignallingInviteParams(
    const flutter::EncodableMap* arguments);

v2::V2NIMSignallingRejectInviteParams getSignallingRejectInviteParams(
    const flutter::EncodableMap* arguments);

v2::V2NIMSignallingAcceptInviteParams getSignallingAcceptInviteParams(
    const flutter::EncodableMap* arguments);

flutter::EncodableMap convertSignallingCallResult(
    const v2::V2NIMSignallingCallResult object);

flutter::EncodableMap convertSignallingJoinResult(
    const v2::V2NIMSignallingJoinResult object);

flutter::EncodableMap convertSignallingRoomInfo(
    const v2::V2NIMSignallingRoomInfo object);

flutter::EncodableMap convertSignallingMember(
    const v2::V2NIMSignallingMember object);

flutter::EncodableMap convertSignallingChannelInfo(
    const v2::V2NIMSignallingChannelInfo object);

flutter::EncodableMap convertSignallingRtcInfo(
    const v2::V2NIMSignallingRtcInfo object);

flutter::EncodableMap convertSignallingCallSetupResult(
    const v2::V2NIMSignallingCallSetupResult object);

flutter::EncodableMap convertSignallingEvent(
    const v2::V2NIMSignallingEvent object);

flutter::EncodableMap convertSignallingPushConfig(
    const v2::V2NIMSignallingPushConfig object);

class FLTSignallingService : public FLTService {
 public:
  FLTSignallingService();
  virtual ~FLTSignallingService();
  virtual void onMethodCalled(
      const std::string& method, const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result)
      override;

 private:
  void call(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

  void callSetup(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

  void createRoom(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

  void closeRoom(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

  void joinRoom(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

  void leaveRoom(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

  void invite(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

  void cancelInvite(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

  void rejectInvite(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

  void acceptInvite(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

  void sendControl(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

  void getRoomInfoByChannelName(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

 private:
  v2::V2NIMSignallingListener listener;
};

#endif  // FLTSignallingService_H
