
// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#include "V2FLTUserService.h"

#include <sstream>

#include "../FLTService.h"
#include "nim_cpp_wrapper/nim_cpp_api.h"
#include "v2_nim_api.hpp"
#include "v2_nim_def_enum.hpp"
#include "v2_nim_def_struct.hpp"
#include "v2_nim_user_service.hpp"

V2FLTUserService::V2FLTUserService() {
  m_serviceName = "UserService";

  userListener.onBlockListAdded = [this](v2::V2NIMUser user) {
    flutter::EncodableMap arguments = convertNIMUser2Map(user);
    notifyEvent("onBlockListAdded", arguments);
  };

  userListener.onBlockListRemoved = [this](nstd::string accountId) {
    flutter::EncodableMap arguments;
    arguments.insert(std::make_pair("userId", accountId));
    notifyEvent("onBlockListRemoved", arguments);
  };

  userListener.onUserProfileChanged =
      [this](nstd::vector<v2::V2NIMUser> userList) {
        flutter::EncodableMap arguments;
        flutter::EncodableList userList_;
        for (auto user : userList) {
          flutter::EncodableMap user_ = convertNIMUser2Map(user);
          userList_.emplace_back(user_);
        }
        arguments.insert(std::make_pair("userInfoList", userList_));
        notifyEvent("onUserProfileChanged", arguments);
      };

  auto& client = v2::V2NIMClient::get();
  auto& userService = client.getUserService();

  userService.addUserListener(userListener);
}

V2FLTUserService::~V2FLTUserService() {
  v2::V2NIMClient::get().getUserService().removeUserListener(userListener);
}

void V2FLTUserService::onMethodCalled(
    const std::string& method, const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (method == "getUserList") {
    getUserList(arguments, result);
  } else if (method == "updateSelfUserProfile") {
    updateSelfUserProfile(arguments, result);
  } else if (method == "addUserToBlockList") {
    addUserToBlockList(arguments, result);
  } else if (method == "removeUserFromBlockList") {
    removeUserFromBlockList(arguments, result);
  } else if (method == "getBlockList") {
    getBlockList(arguments, result);
  } else if (method == "getUserListFromCloud") {
    getUserListFromCloud(arguments, result);
  } else if (method == "searchUserByOption") {
    searchUserByOption(arguments, result);
  } else {
    result->NotImplemented();
  }
}

void V2FLTUserService::getUserList(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    result->Error(
        "", "", NimResult::getErrorResult(199414, "getUserList params error!"));
    return;
  }

  std::vector<std::string> accids;
  auto iter = arguments->find(flutter::EncodableValue("userIdList"));
  if (iter != arguments->end()) {
    if (iter->second.IsNull()) {
      result->Error("", "",
                    NimResult::getErrorResult(
                        199414, "getUserList but the userIdList is empty!"));
      return;
    }
    auto userList = std::get<flutter::EncodableList>(iter->second);
    for (auto user : userList) {
      std::string userId = std::get<std::string>(user);
      accids.emplace_back(userId);
    }
  }

  auto& client = v2::V2NIMClient::get();
  auto& userService = client.getUserService();

  userService.getUserList(
      accids,
      [result](const nstd::vector<v2::V2NIMUser>& userList) {
        flutter::EncodableMap arguments;
        flutter::EncodableList userList_;
        if (userList.size() > 0) {
          for (auto user : userList) {
            flutter::EncodableMap userMap = convertNIMUser2Map(user);
            userList_.emplace_back(userMap);
          }
        }
        arguments.insert(
            std::make_pair("userInfoList", flutter::EncodableValue(userList_)));
        result->Success(NimResult::getSuccessResult(arguments));
      },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void V2FLTUserService::getUserListFromCloud(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    result->Error("", "",
                  NimResult::getErrorResult(
                      199414, "getUserListFromCloud params error!"));
    return;
  }

  std::vector<std::string> accids;
  auto iter = arguments->find(flutter::EncodableValue("userIdList"));
  if (iter != arguments->end()) {
    if (iter->second.IsNull()) {
      result->Error(
          "", "",
          NimResult::getErrorResult(
              199414, "getUserListFromCloud but the userIdList is empty!"));
      return;
    }
    auto userList = std::get<flutter::EncodableList>(iter->second);
    for (auto user : userList) {
      std::string userId = std::get<std::string>(user);
      accids.emplace_back(userId);
    }
  }

  auto& client = v2::V2NIMClient::get();
  auto& userService = client.getUserService();
  userService.getUserListFromCloud(
      accids,
      [result](const nstd::vector<v2::V2NIMUser>& userList) {
        if (userList.size() > 0) {
          flutter::EncodableMap resultMap;
          flutter::EncodableList userList_;
          for (auto user : userList) {
            flutter::EncodableMap userMap = convertNIMUser2Map(user);
            userList_.emplace_back(userMap);
          }

          resultMap.insert(std::make_pair("userInfoList",
                                          flutter::EncodableValue(userList_)));
          result->Success(NimResult::getSuccessResult(resultMap));
        } else {
          result->Error("", "",
                        NimResult::getErrorResult(
                            199414, "getUserListFromCloud failed!"));
        }
      },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void V2FLTUserService::updateSelfUserProfile(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    result->Error("", "",
                  NimResult::getErrorResult(
                      199414, "updateSelfUserProfile params error!"));
    return;
  }
  flutter::EncodableMap updateMapData;
  auto iterArgument = arguments->begin();
  for (iterArgument; iterArgument != arguments->end(); ++iterArgument) {
    if (iterArgument->second.IsNull()) continue;
    if (iterArgument->first == flutter::EncodableValue("updateParam")) {
      updateMapData = std::get<flutter::EncodableMap>(iterArgument->second);
    }
  }
  if (updateMapData.empty()) {
    result->Error("", "",
                  NimResult::getErrorResult(
                      199414, "updateSelfUserProfile params error!"));
    return;
  }
  v2::V2NIMUserUpdateParams updateParams;
  auto iter = updateMapData.begin();
  for (iter; iter != updateMapData.end(); ++iter) {
    if (iter->second.IsNull()) continue;
    if (iter->first == flutter::EncodableValue("name")) {
      updateParams.name = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("gender")) {
      updateParams.gender = std::get<int32_t>(iter->second);
    } else if (iter->first == flutter::EncodableValue("sign")) {
      updateParams.sign = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("avatar")) {
      updateParams.avatar = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("email")) {
      updateParams.email = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("birthday")) {
      updateParams.birthday = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("serverExtension")) {
      updateParams.serverExtension = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("mobile")) {
      updateParams.mobile = std::get<std::string>(iter->second);
    }
  }

  auto& client = v2::V2NIMClient::get();
  auto& userService = client.getUserService();

  userService.updateSelfUserProfile(
      updateParams,
      [result]() { result->Success(NimResult::getSuccessResult()); },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void V2FLTUserService::addUserToBlockList(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    result->Error(
        "", "",
        NimResult::getErrorResult(199414, "addUserToBlockList params error!"));
    return;
  }

  std::string userId = "";
  auto iter = arguments->find(EncodableValue("userId"));
  if (iter != arguments->end()) {
    userId = std::get<std::string>(iter->second);
  }
  auto& client = v2::V2NIMClient::get();
  auto& userService = client.getUserService();

  userService.addUserToBlockList(
      userId, [result]() { result->Success(NimResult::getSuccessResult()); },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void V2FLTUserService::removeUserFromBlockList(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    result->Error("", "",
                  NimResult::getErrorResult(
                      199414, "removeUserFromBlockList params error!"));
    return;
  }

  std::string userId = "";
  auto iter = arguments->find(EncodableValue("userId"));
  if (iter != arguments->end()) {
    userId = std::get<std::string>(iter->second);
  }

  auto& client = v2::V2NIMClient::get();
  auto& userService = client.getUserService();

  userService.removeUserFromBlockList(
      userId, [result]() { result->Success(NimResult::getSuccessResult()); },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void V2FLTUserService::getBlockList(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  auto& client = v2::V2NIMClient::get();
  auto& userService = client.getUserService();

  userService.getBlockList(
      [result](nstd::vector<nstd::string> userIdList) {
        flutter::EncodableMap result_map;
        flutter::EncodableList userMapList;
        for (auto userId : userIdList) {
          userMapList.emplace_back(userId);
        }
        result_map.insert(std::make_pair("userIdList", userMapList));
        result->Success(NimResult::getSuccessResult(result_map));
      },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void V2FLTUserService::searchUserByOption(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    result->Error(
        "", "",
        NimResult::getErrorResult(199414, "searchUserByOption params error!"));
    return;
  }

  flutter::EncodableMap searchMapData;
  auto iterArgument = arguments->begin();
  for (iterArgument; iterArgument != arguments->end(); ++iterArgument) {
    if (iterArgument->second.IsNull()) continue;
    if (iterArgument->first == flutter::EncodableValue("userSearchOption")) {
      searchMapData = std::get<flutter::EncodableMap>(iterArgument->second);
    }
  }
  if (searchMapData.empty()) {
    result->Error("", "",
                  NimResult::getErrorResult(
                      199414, "updateSelfUserProfile params error!"));
    return;
  }
  std::string searchName = "";
  v2::V2NIMUserSearchOption searchOption;
  auto iter = searchMapData.begin();
  for (iter; iter != searchMapData.end(); ++iter) {
    if (iter->second.IsNull()) continue;
    if (iter->first == flutter::EncodableValue("searchName")) {
      searchOption.searchName = std::get<bool>(iter->second);
    } else if (iter->first == flutter::EncodableValue("keyword")) {
      searchOption.keyword = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("searchAccountId")) {
      searchOption.searchAccountId = std::get<bool>(iter->second);
    } else if (iter->first == flutter::EncodableValue("searchMobile")) {
      searchOption.searchMobile = std::get<bool>(iter->second);
    }
  }

  auto& client = v2::V2NIMClient::get();
  auto& userService = client.getUserService();

  userService.searchUserByOption(
      searchOption,
      [result](const nstd::vector<v2::V2NIMUser>& userList) {
        if (userList.size() > 0) {
          flutter::EncodableMap arguments;
          flutter::EncodableList userMapList;
          for (auto user : userList) {
            flutter::EncodableMap userMap = convertNIMUser2Map(user);
            userMapList.emplace_back(userMap);
          }

          arguments.insert(std::make_pair(
              "userInfoList", flutter::EncodableValue(userMapList)));
          result->Success(NimResult::getSuccessResult(arguments));
        } else {
          result->Error(
              "", "",
              NimResult::getErrorResult(199414, "searchUserByOption failed!"));
        }
      },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

flutter::EncodableMap convertNIMUser2Map(
    const nstd::optional<v2::V2NIMUser> user) {
  flutter::EncodableMap resultMap;
  resultMap.insert(std::make_pair("accountId", user->accountId));
  resultMap.insert(std::make_pair("name", user->name.value()));
  resultMap.insert(std::make_pair("avatar", user->avatar.value()));
  resultMap.insert(std::make_pair("sign", user->sign.value()));
  if (user->gender.has_value()) {
    resultMap.insert(
        std::make_pair("gender", static_cast<int64_t>(user->gender.value())));
  }
  resultMap.insert(std::make_pair("email", user->email.value()));
  resultMap.insert(std::make_pair("birthday", user->birthday.value()));
  resultMap.insert(std::make_pair("mobile", user->mobile.value()));
  resultMap.insert(
      std::make_pair("serverExtension", user->serverExtension.value()));
  resultMap.insert(
      std::make_pair("createTime", static_cast<int64_t>(user->createTime)));
  resultMap.insert(
      std::make_pair("updateTime", static_cast<int64_t>(user->updateTime)));
  return resultMap;
}
