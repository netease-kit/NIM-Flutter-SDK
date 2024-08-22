// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#ifndef FLTLOGINSERVICE_H
#define FLTLOGINSERVICE_H

#include "../FLTService.h"
#include "../NimResult.h"
#include "nim_cpp_wrapper/nim_cpp_api.h"
#include "v2_nim_api.hpp"
#include "v2_nim_def_struct.hpp"
#include "v2_nim_login_service.hpp"
class FLTLoginService : public FLTService {
 public:
  FLTLoginService();
  virtual ~FLTLoginService();
  virtual void onMethodCalled(
      const std::string& method, const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result)
      override;

 private:
  void login(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void logout(
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void getLoginUser(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void getLoginStatus(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void kickOffline(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void getKickedOfflineDetail(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void getConnectStatus(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void getDataSync(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void getChatroomLinkAddress(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void setReconnectDelayProvider(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void getLoginClients(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

 private:
  v2::V2NIMLoginListener listener;
  v2::V2NIMLoginDetailListener detailListener;
  v2::V2NIMLoginOption loginOption;
  v2::V2NIMReconnectDelayProvider reconnectDelayProvider;
};

#endif  // FLTLOGINSERVICE_H
