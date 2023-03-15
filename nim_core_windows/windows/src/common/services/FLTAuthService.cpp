// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#include "FLTAuthService.h"

#include "../FLTConvert.h"
#include "../NimResult.h"
#include "nim_cpp_wrapper/nim_cpp_api.h"

using namespace nim;

FLTAuthService::FLTAuthService() {
  m_serviceName = "AuthService";

  nim::Client::RegKickoutCb(
      std::bind(&FLTAuthService::kickoutCallback, this, std::placeholders::_1));
  nim::Client::RegDisconnectCb(
      std::bind(&FLTAuthService::disconnectCallback, this));
  nim::Client::RegMultispotLoginCb(std::bind(
      &FLTAuthService::multispotLoginCallback, this, std::placeholders::_1));
  nim::Client::RegKickOtherClientCb(std::bind(
      &FLTAuthService::kickOtherCallback, this, std::placeholders::_1));
  nim::Client::RegReloginRequestToeknCb(
      std::bind(&FLTAuthService::reloginRequestToeknCallback, this,
                std::placeholders::_1));
}

FLTAuthService::~FLTAuthService() { nim::Client::UnregClientCb(); }

void FLTAuthService::onMethodCalled(
    const std::string& method, const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  std::cout << "method: " << method;

  if (method == "login") {
    if (!m_accountId.empty()) {
      YXLOG(Info) << "login has been called." << YXLOGEnd;
      if (result) {
        std::string account;
        auto accountIt = arguments->find(flutter::EncodableValue("account"));
        if (accountIt != arguments->end() && !accountIt->second.IsNull()) {
          account = std::get<std::string>(accountIt->second);
        }

        if (m_accountId == account) {
          result->Success(NimResult::getSuccessResult());
        } else {
          result->Error(
              "", "", NimResult::getErrorResult(-2, "login has been called."));
        }
      }
      return;
    }
    login(arguments, result);
  } else if (method == "logout") {
    logout(result);
  } else if (method == "kickOutOtherOnlineClient") {
    kickOutOtherOnlineClient(arguments, result);
  } else {
    result->NotImplemented();
  }
}

void FLTAuthService::login(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  std::string appKey = NimCore::getInstance()->getAppkey();
  std::string account = "";
  std::string token = "";
  LoginParams params;

  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("account")) {
      account = std::get<std::string>(iter->second);
      std::cout << "account: " << account << std::endl;
    } else if (iter->first == flutter::EncodableValue("token")) {
      token = std::get<std::string>(iter->second);
      std::cout << "token: " << token << std::endl;
    } else if (iter->first == flutter::EncodableValue("authType")) {
      params.auth_type_ =
          static_cast<nim::NIMAuthType>(std::get<int>(iter->second));
    } else if (iter->first == flutter::EncodableValue("loginExt")) {
      params.login_ex_ = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("customClientType")) {
      // 不支持
    }
  }

  if (params.auth_type_ != kNIMAuthTypeDefault) {
    m_cacheToken = token;
  }

  std::string json_extension = "";
  Client::LoginCustomDataToJson(params, json_extension);
  YXLOG(Info) << "json_extension: " << json_extension << YXLOGEnd;
  Client::Login(
      appKey, account, token,
      [=](const nim::LoginRes& loginResult) {
        std::cout << "login_step_: " << loginResult.login_step_
                  << " res_code_: " << loginResult.res_code_ << std::endl;
        std::string strStatus = "unknown";
        if (loginResult.res_code_ == 200) {
          if (loginResult.login_step_ == nim::kNIMLoginStepLinking ||
              loginResult.login_step_ == nim::kNIMLoginStepLink) {
            strStatus = "connecting";
          } else if (loginResult.login_step_ == nim::kNIMLoginStepLogining) {
            strStatus = "logging";
          } else if (loginResult.login_step_ == nim::kNIMLoginStepLogin) {
            strStatus = "loggedIn";
          }
        } else if (loginResult.res_code_ == nim::kNIMResUidPassError) {
          strStatus = "pwdError";
        } else if (loginResult.res_code_ == nim::kNIMResForbidden) {
          strStatus = "forbidden";
        } else if (loginResult.res_code_ ==
                   nim::kNIMLocalResAPIErrorVersionError) {
          strStatus = "versionError";
        } else {
          strStatus = "unLogin";
        }

        flutter::EncodableMap arguments;
        arguments.insert(std::make_pair("status", strStatus));
        notifyEvent("onAuthStatusChanged", arguments);

        m_accountId.clear();
        if (loginResult.login_step_ == nim::kNIMLoginStepLogin &&
            loginResult.res_code_ == nim::kNIMResSuccess) {
          m_accountId = account;
          result->Success(NimResult::getSuccessResult());
        } else if (loginResult.login_step_ == nim::kNIMLoginStepLogin &&
                   loginResult.res_code_ != nim::kNIMResSuccess) {
          result->Error(
              "", "",
              NimResult::getErrorResult(loginResult.res_code_, "login failed"));
        }
      },
      json_extension);
}

void FLTAuthService::logout(
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  Client::Logout(nim::kNIMLogoutChangeAccout, [=](nim::NIMResCode code) {
    if (code == nim::kNIMResSuccess) {
      m_accountId.clear();
      result->Success(NimResult::getSuccessResult());
    } else {
      result->Error("", "", NimResult::getErrorResult(code, "logout FAILED"));
    }
  });
}

void FLTAuthService::kickOutOtherOnlineClient(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  std::string strOS;
  nim::NIMClientType type = nim::kNIMClientTypeDefault;
  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("os")) {
      strOS = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("clientType")) {
      std::string value = std::get<std::string>(iter->second);
      Convert::getInstance()->convertDartStringToNIMEnum(
          value, Convert::getInstance()->getClientType(), type);
    }
  }

  for (auto client : m_other_clients_) {
    if (client.client_os_ == strOS && client.client_type_ == type) {
      std::list<std::string> client_ids;
      client_ids.emplace_back(client.device_id_);
      Client::KickOtherClient(client_ids);
      result->Success(NimResult::getSuccessResult());  // 不等待直接返回成功
      return;
    }
  }
}

void FLTAuthService::kickoutCallback(const nim::KickoutRes& result) {
  std::cout << "kickoutCallback " << result.kick_reason_ << std::endl;
  m_accountId.clear();
  flutter::EncodableMap arguments;
  arguments.insert(std::make_pair("status", "kickOutByOtherClient"));
  arguments.insert(
      std::make_pair("clientType", static_cast<int>(result.client_type_)));
  arguments.insert(
      std::make_pair("customClientType", result.custom_client_type_));
  notifyEvent("onAuthStatusChanged", arguments);
}

void FLTAuthService::kickOtherCallback(const nim::KickOtherRes& result) {
  flutter::EncodableMap arguments;
  arguments.insert(std::make_pair("status", "kickOut"));
  arguments.insert(std::make_pair("clientType", ""));        // 不支持
  arguments.insert(std::make_pair("customClientType", ""));  // 不支持
  notifyEvent("onAuthStatusChanged", arguments);
}

void FLTAuthService::disconnectCallback() {
  std::cout << "disconnectCallback" << std::endl;
  flutter::EncodableMap arguments;
  arguments.insert(std::make_pair("status", "netBroken"));
  notifyEvent("onAuthStatusChanged", arguments);
}

void FLTAuthService::multispotLoginCallback(
    const nim::MultiSpotLoginRes& result) {
  std::cout << "multispotLoginCallback: " << result.notify_type_ << std::endl;

  flutter::EncodableMap arguments;
  flutter::EncodableList clientList;
  m_other_clients_.clear();
  m_other_clients_ = result.other_clients_;
  for (auto client : m_other_clients_) {
    arguments.insert(std::make_pair("os", client.client_os_));
    arguments.insert(std::make_pair("loginTime", client.login_time_));
    arguments.insert(std::make_pair("customTag", client.custom_data_));
    std::string strClientType;
    Convert::getInstance()->convertNIMEnumToDartString(
        client.client_type_, Convert::getInstance()->getClientType(),
        strClientType);
    arguments.insert(std::make_pair("clientType", strClientType));
  }
  arguments.insert(std::make_pair("clients", clientList));
  notifyEvent("onOnlineClientsUpdated", arguments);
}

void FLTAuthService::reloginRequestToeknCallback(std::string* pToken) {
  *pToken = m_cacheToken;
  m_cacheToken.clear();
}
