// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#include "FLTFriendService.h"

#include "../NimResult.h"
#include "V2FLTUserService.h"
#include "nim_cpp_wrapper/nim_cpp_api.h"
#include "v2_nim_api.hpp"
#include "v2_nim_def_struct.hpp"

using namespace nim;

flutter::EncodableMap convertV2NIMFriendToMap(v2::V2NIMFriend nimFriend) {
  flutter::EncodableMap arguments;
  arguments.insert(std::make_pair("accountId", nimFriend.accountId));
  arguments.insert(std::make_pair("alias", nimFriend.alias.value()));
  arguments.insert(
      std::make_pair("serverExtension", nimFriend.serverExtension.value()));
  arguments.insert(
      std::make_pair("customerExtension", nimFriend.customerExtension.value()));
  if (nimFriend.createTime.has_value()) {
    arguments.insert(std::make_pair(
        "createTime", static_cast<int64_t>(nimFriend.createTime.value())));
  } else {
    arguments.insert(std::make_pair("createTime", 0));
  }
  if (nimFriend.updateTime.has_value()) {
    arguments.insert(std::make_pair(
        "updateTime", static_cast<int64_t>(nimFriend.updateTime.value())));
  }
  arguments.insert(
      std::make_pair("userProfile", convertNIMUser2Map(nimFriend.userProfile)));
  return arguments;
}

flutter::EncodableMap convertV2NIMFriendAddApplicationToMap(
    v2::V2NIMFriendAddApplication application) {
  flutter::EncodableMap arguments;
  arguments.insert(
      std::make_pair("applicantAccountId", application.applicantAccountId));
  arguments.insert(
      std::make_pair("operatorAccountId", application.operatorAccountId));
  arguments.insert(
      std::make_pair("postscript", application.postscript.value()));
  arguments.insert(std::make_pair("read", application.read));
  arguments.insert(
      std::make_pair("recipientAccountId", application.recipientAccountId));
  arguments.insert(std::make_pair("status", application.status));
  arguments.insert(
      std::make_pair("timestamp", static_cast<int64_t>(application.timestamp)));
  return arguments;
}

FLTFriendService::FLTFriendService() {
  m_serviceName = "FriendService";

  friendListener.onFriendAdded = [this](v2::V2NIMFriend friendInfo) {
    // friend added, handle friendInfo
    flutter::EncodableMap arguments = convertV2NIMFriendToMap(friendInfo);
    notifyEvent("onFriendAdded", arguments);
  };
  friendListener.onFriendDeleted =
      [this](nstd::string accountId, v2::V2NIMFriendDeletionType deletionType) {
        // friend deleted
        flutter::EncodableMap arguments;
        arguments.insert(std::make_pair("accountId", accountId));
        arguments.insert(std::make_pair("deletionType", deletionType));
        notifyEvent("onFriendDeleted", arguments);
      };
  friendListener.onFriendAddApplication =
      [this](v2::V2NIMFriendAddApplication applicationInfo) {
        // friend add application, handle applicationInfo
        flutter::EncodableMap arguments =
            convertV2NIMFriendAddApplicationToMap(applicationInfo);
        notifyEvent("onFriendAddApplication", arguments);
      };
  friendListener.onFriendAddRejected =
      [this](v2::V2NIMFriendAddApplication rejectionInfo) {
        // friend add rejected, handle rejectionInfo
        flutter::EncodableMap arguments =
            convertV2NIMFriendAddApplicationToMap(rejectionInfo);
        notifyEvent("onFriendAddRejected", arguments);
      };
  friendListener.onFriendInfoChanged = [this](v2::V2NIMFriend friendInfo) {
    // friend info changed, handle friendInfo
    flutter::EncodableMap arguments = convertV2NIMFriendToMap(friendInfo);
    notifyEvent("onFriendInfoChanged", arguments);
  };
  // 添加监听
  v2::V2NIMClient::get().getFriendService().addFriendListener(friendListener);
}

FLTFriendService::~FLTFriendService() {
  // 删除监听
  v2::V2NIMClient::get().getFriendService().removeFriendListener(
      friendListener);
}

void FLTFriendService::onMethodCalled(
    const std::string& method, const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  std::cout << "method: " << method;
  if (method == "addFriend") {
    addFriend(arguments, result);
  } else if (method == "deleteFriend") {
    deleteFriend(arguments, result);
  } else if (method == "getFriendList") {
    getFriendList(arguments, result);
  } else if (method == "getFriendByIds") {
    getFriendByIds(arguments, result);
  } else if (method == "checkFriend") {
    checkFriend(arguments, result);
  } else if (method == "acceptAddApplication") {
    acceptAddApplication(arguments, result);
  } else if (method == "rejectAddApplication") {
    rejectAddApplication(arguments, result);
  } else if (method == "setFriendInfo") {
    setFriendInfo(arguments, result);
  } else if (method == "getAddApplicationList") {
    getAddApplicationList(arguments, result);
  } else if (method == "getAddApplicationUnreadCount") {
    getAddApplicationUnreadCount(arguments, result);
  } else if (method == "setAddApplicationRead") {
    setAddApplicationRead(arguments, result);
  } else if (method == "searchFriendByOption") {
    searchFriendByOption(arguments, result);
  }
}

// 获得添加好友参数
v2::V2NIMFriendAddParams getFriendAddParams(
    const flutter::EncodableMap* arguments) {
  v2::V2NIMFriendAddParams params;
  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("addMode")) {
      params.addMode = v2::V2NIMFriendAddMode(std::get<int>(iter->second));
    } else if (iter->first == flutter::EncodableValue("postscript")) {
      params.postscript = std::get<std::string>(iter->second);
    }
  }
  return params;
}

v2::V2NIMFriendDeleteParams getFriendDeleteParams(
    const flutter::EncodableMap* arguments) {
  v2::V2NIMFriendDeleteParams params;
  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("deleteAlias")) {
      params.deleteAlias = std::get<bool>(iter->second);
    }
  }
  return params;
}

v2::V2NIMFriendAddApplication getFriendAddApplication(
    const flutter::EncodableMap* arguments) {
  v2::V2NIMFriendAddApplication applicationInfo;
  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("applicantAccountId")) {
      applicationInfo.applicantAccountId = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("operatorAccountId")) {
      applicationInfo.operatorAccountId = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("recipientAccountId")) {
      applicationInfo.recipientAccountId = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("postscript")) {
      applicationInfo.postscript = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("timestamp")) {
      int64_t timestamp = (iter->second).LongValue();
      applicationInfo.timestamp = timestamp;
    } else if (iter->first == flutter::EncodableValue("status")) {
      applicationInfo.status =
          v2::V2NIMFriendAddApplicationStatus(std::get<int>(iter->second));
    } else if (iter->first == flutter::EncodableValue("read")) {
      applicationInfo.read = std::get<bool>(iter->second);
    }
  }
  return applicationInfo;
}

void FLTFriendService::addFriend(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  // 获取参数
  std::string accountId = "";
  v2::V2NIMFriendAddParams addParams;

  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("accountId")) {
      accountId = std::get<std::string>(iter->second);
      std::cout << "accountId: " << accountId << std::endl;
    } else if (iter->first == flutter::EncodableValue("params")) {
      auto params = std::get<flutter::EncodableMap>(iter->second);
      addParams = getFriendAddParams(&params);
      std::cout << "params: " << std::endl;
    }
  }
  auto& instance = v2::V2NIMClient::get();
  auto& friendService = instance.getFriendService();
  friendService.addFriend(
      accountId, addParams,
      [result]() {
        // add friend success
        result->Success(NimResult::getSuccessResult());
      },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

// 删除好友
void FLTFriendService::deleteFriend(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  std::string accountId = "";
  v2::V2NIMFriendDeleteParams deleteParams;

  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("accountId")) {
      accountId = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("params")) {
      auto params = std::get<flutter::EncodableMap>(iter->second);
      deleteParams = getFriendDeleteParams(&params);
    }
  }

  auto& instance = v2::V2NIMClient::get();
  auto& friendService = instance.getFriendService();
  friendService.deleteFriend(
      accountId, deleteParams,
      [result]() {
        // delete friend success
        result->Success(NimResult::getSuccessResult());
      },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void FLTFriendService::acceptAddApplication(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  v2::V2NIMFriendAddApplication applicationInfo;
  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("application")) {
      auto params = std::get<flutter::EncodableMap>(iter->second);
      applicationInfo = getFriendAddApplication(&params);
    }
  }
  auto& instance = v2::V2NIMClient::get();
  auto& friendService = instance.getFriendService();
  friendService.acceptAddApplication(
      applicationInfo,
      [result]() {
        // accept add application success
        result->Success(NimResult::getSuccessResult());
      },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void FLTFriendService::rejectAddApplication(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  v2::V2NIMFriendAddApplication applicationInfo;
  std::string postscript = "";
  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("application")) {
      auto params = std::get<flutter::EncodableMap>(iter->second);
      applicationInfo = getFriendAddApplication(&params);
    } else if (iter->first == flutter::EncodableValue("postscript")) {
      postscript = std::get<std::string>(iter->second);
    }
  }
  auto& instance = v2::V2NIMClient::get();
  auto& friendService = instance.getFriendService();
  friendService.rejectAddApplication(
      applicationInfo, postscript,
      [result]() {
        // reject add application success
        result->Success(NimResult::getSuccessResult());
      },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

v2::V2NIMFriendSetParams getFriendSetParams(flutter::EncodableMap* params) {
  v2::V2NIMFriendSetParams friendSetParams;
  auto iter = params->begin();
  for (iter; iter != params->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("alias")) {
      friendSetParams.alias = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("serverExtension")) {
      friendSetParams.serverExtension = std::get<std::string>(iter->second);
    }
  }
  return friendSetParams;
}

void FLTFriendService::setFriendInfo(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  std::string accountId = "";
  v2::V2NIMFriendSetParams setParams;
  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("accountId")) {
      accountId = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("params")) {
      auto params = std::get<flutter::EncodableMap>(iter->second);
      setParams = getFriendSetParams(&params);
    }
  }
  auto& instance = v2::V2NIMClient::get();
  auto& friendService = instance.getFriendService();
  friendService.setFriendInfo(
      accountId, setParams,
      [result]() {
        // set friend info success
        result->Success(NimResult::getSuccessResult());
      },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}
void FLTFriendService::getFriendList(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  auto& instance = v2::V2NIMClient::get();
  auto& friendService = instance.getFriendService();
  friendService.getFriendList(
      [result](std::vector<v2::V2NIMFriend> friendList) {
        flutter::EncodableList resultList;
        flutter::EncodableMap resultMap;
        for (auto friendInfo : friendList) {
          flutter::EncodableMap friendMap;
          friendMap = convertV2NIMFriendToMap(friendInfo);
          resultList.emplace_back(flutter::EncodableValue(friendMap));
        }
        resultMap.insert(std::make_pair("friendList", resultList));
        result->Success(NimResult::getSuccessResult(resultMap));
      },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}
void FLTFriendService::getFriendByIds(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  std::vector<std::string> accountIds;
  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("accountIds")) {
      auto params = std::get<flutter::EncodableList>(iter->second);
      for (auto accountId : params) {
        accountIds.emplace_back(std::get<std::string>(accountId));
      }
    }
  }
  auto& instance = v2::V2NIMClient::get();
  auto& friendService = instance.getFriendService();
  friendService.getFriendByIds(
      accountIds,
      [result](std::vector<v2::V2NIMFriend> friendList) {
        flutter::EncodableList resultList;
        flutter::EncodableMap resultMap;
        for (auto friendInfo : friendList) {
          flutter::EncodableMap friendMap;
          friendMap = convertV2NIMFriendToMap(friendInfo);
          resultList.emplace_back(flutter::EncodableValue(friendMap));
        }
        resultMap.insert(std::make_pair("friendList", resultList));
        result->Success(NimResult::getSuccessResult(resultMap));
      },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void FLTFriendService::checkFriend(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  std::vector<std::string> accountIds;
  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("accountIds")) {
      auto params = std::get<flutter::EncodableList>(iter->second);
      for (auto accountId : params) {
        accountIds.emplace_back(std::get<std::string>(accountId));
      }
    }
  }
  auto& instance = v2::V2NIMClient::get();
  auto& friendService = instance.getFriendService();
  friendService.checkFriend(
      accountIds,
      [result](nstd::map<nstd::string, bool> friendMap) {
        flutter::EncodableMap resultMap;
        flutter::EncodableMap friendResultMap;
        for (auto friendInfo : friendMap) {
          friendResultMap.insert(
              std::make_pair(friendInfo.first, friendInfo.second));
        }
        resultMap.insert(std::make_pair("result", friendResultMap));
        result->Success(NimResult::getSuccessResult(resultMap));
      },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

v2::V2NIMFriendAddApplicationQueryOption getFriendAddApplicationQueryOption(
    flutter::EncodableMap* params) {
  v2::V2NIMFriendAddApplicationQueryOption queryOption;
  auto iter = params->begin();
  for (iter; iter != params->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("limit")) {
      queryOption.limit = std::get<int>(iter->second);
    } else if (iter->first == flutter::EncodableValue("offset")) {
      queryOption.offset = std::get<int>(iter->second);
    } else if (iter->first == flutter::EncodableValue("status")) {
      auto status = std::get<flutter::EncodableList>(iter->second);
      std::vector<v2::V2NIMFriendAddApplicationStatus> statusList;
      for (auto statusValue : status) {
        statusList.emplace_back(
            v2::V2NIMFriendAddApplicationStatus(std::get<int>(statusValue)));
      }
      queryOption.status = statusList;
    }
  }
  return queryOption;
}

flutter::EncodableMap convertV2NIMFriendAddApplicationResultToMap(
    v2::V2NIMFriendAddApplicationResult applicationResult) {
  flutter::EncodableMap resultMap;
  flutter::EncodableList infoList;
  for (auto info : applicationResult.infos) {
    flutter::EncodableMap infoMap;
    infoMap = convertV2NIMFriendAddApplicationToMap(info);
    infoList.emplace_back(flutter::EncodableValue(infoMap));
  }
  resultMap.insert(std::make_pair("infos", infoList));
  resultMap.insert(
      std::make_pair("offset", static_cast<int64_t>(applicationResult.offset)));
  resultMap.insert(std::make_pair("finished", applicationResult.finished));
  return resultMap;
}

void FLTFriendService::getAddApplicationList(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  v2::V2NIMFriendAddApplicationQueryOption option;
  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("option")) {
      auto params = std::get<flutter::EncodableMap>(iter->second);
      option = getFriendAddApplicationQueryOption(&params);
    }
  }
  auto& instance = v2::V2NIMClient::get();
  auto& friendService = instance.getFriendService();
  friendService.getAddApplicationList(
      option,
      [result](v2::V2NIMFriendAddApplicationResult applicationResult) {
        flutter::EncodableMap resultMap;
        resultMap =
            convertV2NIMFriendAddApplicationResultToMap(applicationResult);
        result->Success(NimResult::getSuccessResult(resultMap));
      },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void FLTFriendService::getAddApplicationUnreadCount(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  auto& instance = v2::V2NIMClient::get();
  auto& friendService = instance.getFriendService();
  friendService.getAddApplicationUnreadCount(
      [result](int unreadCount) {
        result->Success(NimResult::getSuccessResult(unreadCount));
      },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}
void FLTFriendService::setAddApplicationRead(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  auto& instance = v2::V2NIMClient::get();
  auto& friendService = instance.getFriendService();
  friendService.setAddApplicationRead(
      [result]() { result->Success(NimResult::getSuccessResult()); },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

v2::V2NIMFriendSearchOption getFriendSearchOption(
    flutter::EncodableMap* params) {
  v2::V2NIMFriendSearchOption searchOption;
  auto iter = params->begin();
  for (iter; iter != params->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("keyword")) {
      searchOption.keyword = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("searchAccountId")) {
      searchOption.searchAccountId = std::get<bool>(iter->second);
    } else if (iter->first == flutter::EncodableValue("searchAlias")) {
      searchOption.searchAlias = std::get<bool>(iter->second);
    }
  }
  return searchOption;
}

void FLTFriendService::searchFriendByOption(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  v2::V2NIMFriendSearchOption option;
  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("friendSearchOption")) {
      auto params = std::get<flutter::EncodableMap>(iter->second);
      option = getFriendSearchOption(&params);
    }
  }
  auto& instance = v2::V2NIMClient::get();
  auto& friendService = instance.getFriendService();
  friendService.searchFriendByOption(
      option,
      [result](nstd::vector<v2::V2NIMFriend> friendList) {
        flutter::EncodableMap resultMap;
        flutter::EncodableList resultList;
        for (auto friendInfo : friendList) {
          resultList.emplace_back(convertV2NIMFriendToMap(friendInfo));
        }
        resultMap.insert(std::make_pair("friendList", resultList));
        result->Success(NimResult::getSuccessResult(resultMap));
      },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}
