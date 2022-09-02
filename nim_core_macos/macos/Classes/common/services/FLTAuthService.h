// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#ifndef FLTAUTHSERVICE_H
#define FLTAUTHSERVICE_H

#include "../FLTService.h"
class FLTAuthService : public FLTService {
 public:
  FLTAuthService();
  virtual ~FLTAuthService();
  virtual void onMethodCalled(
      const std::string& method, const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result)
      override;
  std::string getAccountId() const { return m_accountId; }

 private:
  void login(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void logout(
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void kickOutOtherOnlineClient(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

 private:
  void kickoutCallback(const nim::KickoutRes& result);
  void kickOtherCallback(const nim::KickOtherRes& result);
  void disconnectCallback();
  void multispotLoginCallback(const nim::MultiSpotLoginRes& result);
  void reloginRequestToeknCallback(std::string* pToken);

 private:
  std::string m_accountId;
  std::string m_cacheToken;
  std::list<nim::OtherClientPres> m_other_clients_;
};

#endif  // FLTAUTHSERVICE_H
