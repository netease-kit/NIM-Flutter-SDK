// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#include "FLTUserService.h"

#include "../FLTConvert.h"
#include "nim_cpp_wrapper/api/nim_cpp_client.h"
#include "nim_cpp_wrapper/api/nim_cpp_user.h"

FLTUserService::FLTUserService() {
  m_serviceName = "UserService";
  nim::Friend::RegChangeCb(std::bind(&FLTUserService::friendChangeCallback,
                                     this, std::placeholders::_1));
  nim::User::RegSpecialRelationshipChangedCb(
      std::bind(&FLTUserService::specialRelationshipChangedCallback, this,
                std::placeholders::_1));
  nim::User::RegUserNameCardChangedCb(
      std::bind(&FLTUserService::userNameCardChangedCallback, this,
                std::placeholders::_1));
  nim::DataSync::RegCompleteCb(
      std::bind(&FLTUserService::dataSyncCallback, this, std::placeholders::_1,
                std::placeholders::_2, std::placeholders::_3));
}

FLTUserService::~FLTUserService() {
  nim::User::UnregUserCb();
  nim::Friend::UnregFriendCb();
}

void FLTUserService::onMethodCalled(
    const std::string& method, const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (method == "getUserInfo") {
    getUserInfo(arguments, result);
  } else if (method == "fetchUserInfoList") {
    fetchUserInfoList(arguments, result);
  } else if (method == "updateMyUserInfo") {
    updateMyUserInfo(arguments, result);
  } else if (method == "searchUserInfoListByKeyword") {
    searchUserInfoListByKeyword(arguments, result);
  } else if (method == "getBlackList") {
    getBlackList(result);
  } else if (method == "addToBlackList") {
    addToBlackList(arguments, result);
  } else if (method == "removeFromBlackList") {
    removeFromBlackList(arguments, result);
  } else if (method == "getMuteList") {
    getMuteList(result);
  } else if (method == "setMute") {
    setMute(arguments, result);
  } else if (method == "isMute") {
    IsMute(arguments, result);
  } else if (method == "isInBlackList") {
    IsInBlackList(arguments, result);
  } else if (method == "searchUserIdListByNick") {
    searchUserIdListByNick(arguments, result);
  } else if (method == "getFriendList") {
    getFriendList(result);
  } else if (method == "getFriend") {
    getFriend(arguments, result);
  } else if (method == "addFriend") {
    addFriend(arguments, result);
  } else if (method == "ackAddFriend") {
    ackAddFriend(arguments, result);
  } else if (method == "deleteFriend") {
    deleteFriend(arguments, result);
  } else if (method == "updateFriend") {
    updateFriend(arguments, result);
  } else if (method == "isMyFriend") {
    isMyFriend(arguments, result);
  } else {
    result->NotImplemented();
  }
}

void FLTUserService::getUserInfo(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    result->Error("", "",
                  NimResult::getErrorResult(-1, "getUserInfo params error!"));
    return;
  }

  std::string userId = "";
  auto iter = arguments->find(EncodableValue("userId"));
  if (iter != arguments->end()) {
    userId = std::get<std::string>(iter->second);
  }

  if (userId.empty()) {
    result->Error("", "",
                  NimResult::getErrorResult(-1, "getUserInfo params error!"));
    return;
  }

  std::list<std::string> accids;
  accids.emplace_back(userId);
  nim::User::GetUserNameCard(accids, [result](
                                         const std::list<nim::UserNameCard>&
                                             userList) {
    if (userList.size() > 0) {
      nim::UserNameCard user = userList.front();
      flutter::EncodableMap userMap;
      userMap.insert(std::make_pair(flutter::EncodableValue("userId"),
                                    flutter::EncodableValue(user.GetAccId())));
      userMap.insert(std::make_pair(flutter::EncodableValue("nick"),
                                    flutter::EncodableValue(user.GetName())));
      std::string strGender;
      Convert::getInstance()->convertNIMEnumToDartString(
          user.GetGender(), Convert::getInstance()->getGenderType(), strGender);
      userMap.insert(std::make_pair(flutter::EncodableValue("gender"),
                                    flutter::EncodableValue(strGender)));
      userMap.insert(
          std::make_pair(flutter::EncodableValue("signature"),
                         flutter::EncodableValue(user.GetSignature())));
      userMap.insert(
          std::make_pair(flutter::EncodableValue("avatar"),
                         flutter::EncodableValue(user.GetIconUrl())));
      userMap.insert(std::make_pair(flutter::EncodableValue("email"),
                                    flutter::EncodableValue(user.GetEmail())));
      userMap.insert(std::make_pair(flutter::EncodableValue("birthday"),
                                    flutter::EncodableValue(user.GetBirth())));
      userMap.insert(std::make_pair(flutter::EncodableValue("mobile"),
                                    flutter::EncodableValue(user.GetMobile())));
      userMap.insert(std::make_pair(
          flutter::EncodableValue("extension"),
          flutter::EncodableValue(
              nim::GetJsonStringWithNoStyled(user.GetExpand()))));
      result->Success(NimResult::getSuccessResult(userMap));
    } else {
      result->Error("", "",
                    NimResult::getErrorResult(
                        -1, "getUserInfo but the userId is not found!"));
    }
  });
}

void FLTUserService::fetchUserInfoList(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    result->Error(
        "", "",
        NimResult::getErrorResult(-1, "fetchUserInfoList params error!"));
    return;
  }

  std::list<std::string> accids;
  auto iter = arguments->find(flutter::EncodableValue("userIdList"));
  if (iter != arguments->end()) {
    if (iter->second.IsNull()) {
      result->Error("", "",
                    NimResult::getErrorResult(
                        -1, "fetchUserInfoList but the userIdList is empty!"));
      return;
    }
    auto userList = std::get<flutter::EncodableList>(iter->second);
    for (auto user : userList) {
      std::string userId = std::get<std::string>(user);
      accids.emplace_back(userId);
    }
  }

  bool res = nim::User::GetUserNameCardOnline(
      accids, [result](const std::list<nim::UserNameCard>& userList) {
        if (userList.size() > 0) {
          flutter::EncodableMap arguments;
          flutter::EncodableList userList_;
          for (auto user : userList) {
            flutter::EncodableMap userMap;
            userMap.insert(std::make_pair(flutter::EncodableValue("userId"),
                                          user.GetAccId()));
            userMap.insert(std::make_pair("nick", user.GetName()));
            std::string strGender;
            Convert::getInstance()->convertNIMEnumToDartString(
                user.GetGender(), Convert::getInstance()->getGenderType(),
                strGender);
            userMap.insert(std::make_pair("gender", strGender));
            userMap.insert(std::make_pair("signature", user.GetSignature()));
            userMap.insert(std::make_pair("avatar", user.GetIconUrl()));
            userMap.insert(std::make_pair("email", user.GetEmail()));
            userMap.insert(std::make_pair("birthday", user.GetBirth()));
            userMap.insert(std::make_pair("mobile", user.GetMobile()));
            userMap.insert(std::make_pair(
                "extension", nim::GetJsonStringWithNoStyled(user.GetExpand())));
            userList_.emplace_back(userMap);
          }

          arguments.insert(
              std::make_pair(flutter::EncodableValue("userInfoList"),
                             flutter::EncodableValue(userList_)));
          result->Success(NimResult::getSuccessResult(arguments));
        } else {
          result->Error(
              "", "",
              NimResult::getErrorResult(-1, "fetchUserInfoList failed!"));
        }
      });

  if (!res) {
    result->Error("", "",
                  NimResult::getErrorResult(-1, "fetchUserInfoList failed!"));
  }
}

void FLTUserService::updateMyUserInfo(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    result->Error(
        "", "",
        NimResult::getErrorResult(-1, "updateMyUserInfo params error!"));
    return;
  }

  nim::UserNameCard namecard;
  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) continue;

    if (iter->first == flutter::EncodableValue("userId")) {
      namecard.SetAccId(std::get<std::string>(iter->second));
    } else if (iter->first == flutter::EncodableValue("nick")) {
      namecard.SetName(std::get<std::string>(iter->second));
    } else if (iter->first == flutter::EncodableValue("gender")) {
      int nGender = 0;
      std::string strGender = std::get<std::string>(iter->second);
      Convert::getInstance()->convertDartStringToNIMEnum(
          strGender, Convert::getInstance()->getGenderType(), nGender);
      Convert::getInstance()->getGenderType();
      namecard.SetGender(nGender);
    } else if (iter->first == flutter::EncodableValue("signature")) {
      namecard.SetSignature(std::get<std::string>(iter->second));
    } else if (iter->first == flutter::EncodableValue("avatar")) {
      namecard.SetIconUrl(std::get<std::string>(iter->second));
    } else if (iter->first == flutter::EncodableValue("email")) {
      namecard.SetEmail(std::get<std::string>(iter->second));
    } else if (iter->first == flutter::EncodableValue("birthday")) {
      namecard.SetBirth(std::get<std::string>(iter->second));
    } else if (iter->first == flutter::EncodableValue("extension")) {
      namecard.SetExpand(Convert::getInstance()->getJsonValueFromJsonString(
          std::get<std::string>(iter->second)));
    } else if (iter->first == flutter::EncodableValue("mobile")) {
      namecard.SetMobile(std::get<std::string>(iter->second));
    }
  }

  if (namecard.GetAccId().empty()) {
    namecard.SetAccId(NimCore::getInstance()->getAccountId());
  }

  bool res =
      nim::User::UpdateMyUserNameCard(namecard, [=](nim::NIMResCode res_code) {
        std::cout << "UpdateMyUserNameCard:" << res_code << std::endl;
        if (res_code == 200) {
          result->Success(NimResult::getSuccessResult());
        } else {
          result->Error(
              "", "",
              NimResult::getErrorResult(res_code, "updateMyUserInfo failed!"));
        }
      });

  if (!res) {
    result->Error("", "",
                  NimResult::getErrorResult(-1, "updateMyUserInfo failed!"));
  }
}

void FLTUserService::searchUserInfoListByKeyword(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    result->Error("", "",
                  NimResult::getErrorResult(
                      -1, "searchUserInfoListByKeyword params error!"));
    return;
  }

  std::string keyword;
  auto iter = arguments->find(EncodableValue("keyword"));
  if (iter != arguments->end()) {
    if (iter->second.IsNull()) {
      return;
    }

    keyword = std::get<std::string>(iter->second);
  }

  bool res = nim::User::QueryUserListByKeyword(
      keyword, [=](const std::list<nim::UserNameCard>& userList) {
        if (userList.size() > 0) {
          flutter::EncodableMap result_map;
          flutter::EncodableList userList_;
          for (auto user : userList) {
            flutter::EncodableMap userMap;
            userMap.insert(std::make_pair("userId", user.GetAccId()));
            userMap.insert(std::make_pair("nick", user.GetName()));
            std::string strGender;
            Convert::getInstance()->convertNIMEnumToDartString(
                user.GetGender(), Convert::getInstance()->getGenderType(),
                strGender);
            userMap.insert(std::make_pair("gender", strGender));
            userMap.insert(std::make_pair("signature", user.GetSignature()));
            userMap.insert(std::make_pair("avatar", user.GetIconUrl()));
            userMap.insert(std::make_pair("email", user.GetEmail()));
            userMap.insert(std::make_pair("birthday", user.GetBirth()));
            userMap.insert(std::make_pair("mobile", user.GetMobile()));
            userMap.insert(std::make_pair(
                "extension", nim::GetJsonStringWithNoStyled(user.GetExpand())));
            userList_.emplace_back(flutter::EncodableValue(userMap));
          }
          result_map.insert(std::make_pair("userInfoList", userList_));
          result->Success(NimResult::getSuccessResult(result_map));
        } else {
          result->Error("", "",
                        NimResult::getErrorResult(
                            -1, "searchUserInfoListByKeyword failed!"));
        }
      });

  if (!res) {
    result->Error(
        "", "",
        NimResult::getErrorResult(-1, "searchUserInfoListByKeyword failed!"));
  }
}

void FLTUserService::getBlackList(
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  nim::User::GetBlacklist(
      [=](nim::NIMResCode res_code,
          const std::list<nim::BlackMuteListInfo>& userList) {
        if (res_code == nim::kNIMResSuccess) {
          if (userList.size() > 0) {
            flutter::EncodableMap result_map;
            flutter::EncodableMap blackMap;
            flutter::EncodableList userList_;
            for (auto user : userList) {
              if (user.set_black_) {
                userList_.emplace_back(flutter::EncodableValue(user.accid_));
              }
            }
            blackMap.insert(std::make_pair(flutter::EncodableValue("blackList"),
                                           flutter::EncodableValue(userList_)));

            result_map.insert(std::make_pair("userIdList", userList_));
            result->Success(NimResult::getSuccessResult(result_map));
          } else {
            result->Error(
                "", "", NimResult::getErrorResult(-1, "getBlackList failed!"));
          }
        } else {
          result->Error(
              "", "",
              NimResult::getErrorResult(res_code, "getBlackList failed!"));
        }
      });
}

void FLTUserService::addToBlackList(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    result->Error(
        "", "", NimResult::getErrorResult(-1, "addToBlackList params error!"));
    return;
  }

  std::string userId = "";
  auto iter = arguments->find(EncodableValue("userId"));
  if (iter != arguments->end()) {
    userId = std::get<std::string>(iter->second);
  }

  if (userId.empty()) {
    result->Error("", "", NimResult::getErrorResult(-1, "params error!"));
    return;
  }

  bool res = nim::User::SetBlack(
      userId, true,
      [=](nim::NIMResCode res_code, const std::string& accid, bool set_opt) {
        if (res_code == nim::kNIMResSuccess) {
          result->Success(NimResult::getSuccessResult());
        } else {
          result->Error(
              "", "",
              NimResult::getErrorResult(res_code, "addToBlackList failed!"));
        }
      });

  if (!res) {
    result->Error("", "",
                  NimResult::getErrorResult(-1, "addToBlackList failed!"));
  }
}

void FLTUserService::removeFromBlackList(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    result->Error(
        "", "",
        NimResult::getErrorResult(-1, "removeFromBlackList params error!"));
    return;
  }

  std::string userId = "";
  auto iter = arguments->find(EncodableValue("userId"));
  if (iter != arguments->end()) {
    userId = std::get<std::string>(iter->second);
  }

  if (userId.empty()) {
    result->Error(
        "", "",
        NimResult::getErrorResult(-1, "removeFromBlackList params error!"));
    return;
  }

  bool res = nim::User::SetBlack(
      userId, false,
      [=](nim::NIMResCode res_code, const std::string& accid, bool set_opt) {
        if (res_code == nim::kNIMResSuccess) {
          result->Success(NimResult::getSuccessResult());
        } else {
          result->Error("", "",
                        NimResult::getErrorResult(
                            res_code, "removeFromBlackList failed!"));
        }
      });

  if (!res) {
    result->Error("", "",
                  NimResult::getErrorResult(-1, "removeFromBlackList failed!"));
  }
}

void FLTUserService::getMuteList(
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  nim::User::GetMutelist(
      [=](nim::NIMResCode res_code,
          const std::list<nim::BlackMuteListInfo>& userList) {
        if (res_code == nim::kNIMResSuccess) {
          if (userList.size() > 0) {
            flutter::EncodableMap result_map;
            flutter::EncodableList userList_;
            for (auto user : userList) {
              if (user.set_mute_) {
                userList_.emplace_back(flutter::EncodableValue(user.accid_));
              }
            }
            result_map.insert(std::make_pair("userIdList", userList_));
            result->Success(NimResult::getSuccessResult(result_map));
          } else {
            result->Error("", "",
                          NimResult::getErrorResult(-1, "getMuteList failed!"));
          }
        } else {
          result->Error(
              "", "",
              NimResult::getErrorResult(res_code, "getMuteList failed!"));
        }
      });
}

void FLTUserService::setMute(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    result->Error("", "",
                  NimResult::getErrorResult(-1, "setMute params error!"));
    return;
  }

  std::string userId = "";
  auto iter = arguments->find(EncodableValue("userId"));
  if (iter != arguments->end()) {
    if (iter->second.IsNull()) {
      result->Error("", "",
                    NimResult::getErrorResult(-1, "setMute params error!"));
      return;
    }
    userId = std::get<std::string>(iter->second);
  }

  bool mute = false;
  auto iter2 = arguments->find(EncodableValue("isMute"));
  if (iter2 != arguments->end()) {
    if (iter2->second.IsNull()) {
      result->Error("", "", NimResult::getErrorResult(-1, "params error!"));
      return;
    }
    mute = std::get<bool>(iter2->second);
  }

  bool res = nim::User::SetMute(
      userId, mute,
      [=](nim::NIMResCode res_code, const std::string& accid, bool set_opt) {
        if (res_code == nim::kNIMResSuccess) {
          result->Success(NimResult::getSuccessResult());
        } else {
          result->Error("", "",
                        NimResult::getErrorResult(res_code, "setMute failed!"));
        }
      });

  if (!res) {
    result->Error("", "", NimResult::getErrorResult(-1, "setMute failed!"));
  }
}
void FLTUserService::IsInBlackList(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    result->Error("", "",
                  NimResult::getErrorResult(-1, "IsInBlackList params error!"));
    return;
  }

  std::string userId = "";
  auto iter = arguments->find(EncodableValue("userId"));
  if (iter != arguments->end()) {
    if (iter->second.IsNull()) {
      result->Error(
          "", "", NimResult::getErrorResult(-1, "IsInBlackList params error!"));
      return;
    }
    userId = std::get<std::string>(iter->second);
  }

  nim::User::GetBlacklist(
      [=](nim::NIMResCode res_code,
          const std::list<nim::BlackMuteListInfo>& userList) {
        if (res_code == nim::kNIMResSuccess) {
          if (userList.size() > 0) {
            for (auto user : userList) {
              if (user.set_black_ && user.accid_ == userId) {
                result->Success(
                    NimResult::getSuccessResult(flutter::EncodableValue(true)));
                return;
              }
            }
          }

          result->Success(
              NimResult::getSuccessResult(flutter::EncodableValue(false)));
        } else {
          result->Error(
              "", "",
              NimResult::getErrorResult(res_code, "IsInBlackList failed!"));
        }
      });
}
void FLTUserService::IsMute(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    result->Error("", "",
                  NimResult::getErrorResult(-1, "IsMute params error!"));
    return;
  }

  std::string userId = "";
  auto iter = arguments->find(EncodableValue("userId"));
  if (iter != arguments->end()) {
    if (iter->second.IsNull()) {
      result->Error("", "",
                    NimResult::getErrorResult(-1, "IsMute params error!"));
      return;
    }
    userId = std::get<std::string>(iter->second);
  }

  nim::User::GetMutelist(
      [=](nim::NIMResCode res_code,
          const std::list<nim::BlackMuteListInfo>& userList) {
        if (res_code == nim::kNIMResSuccess) {
          if (userList.size() > 0) {
            for (auto user : userList) {
              if (user.set_mute_ && user.accid_ == userId) {
                result->Success(
                    NimResult::getSuccessResult(flutter::EncodableValue(true)));
                return;
              }
            }
          }

          result->Success(
              NimResult::getSuccessResult(flutter::EncodableValue(false)));
        } else {
          result->Error("", "",
                        NimResult::getErrorResult(res_code, "IsMute failed!"));
        }
      });
}
void FLTUserService::searchUserIdListByNick(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    result->Error(
        "", "",
        NimResult::getErrorResult(-1, "searchUserIdListByNick params error!"));
    return;
  }

  std::string nick;
  auto iter = arguments->find(EncodableValue("nick"));
  if (iter != arguments->end()) {
    if (iter->second.IsNull()) {
      result->Error("", "",
                    NimResult::getErrorResult(
                        -1, "searchUserIdListByNick params error!"));
      return;
    }

    nick = std::get<std::string>(iter->second);
  }

  bool res = nim::User::QueryUserListByKeyword(
      nick, [=](const std::list<nim::UserNameCard>& userList) {
        if (userList.size() > 0) {
          flutter::EncodableMap result_map;
          flutter::EncodableList userList_;
          for (auto user : userList) {
            if (user.GetName() == nick) {
              userList_.emplace_back(flutter::EncodableValue(user.GetAccId()));
            }
          }
          result_map.insert(std::make_pair("userIdList", userList_));
          result->Success(NimResult::getSuccessResult(result_map));
        } else {
          result->Error(
              "", "",
              NimResult::getErrorResult(-1, "searchUserIdListByNick failed!"));
        }
      });

  if (!res) {
    result->Error(
        "", "",
        NimResult::getErrorResult(-1, "searchUserIdListByNick failed!"));
  }
}

void FLTUserService::getFriendList(
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  nim::Friend::GetList([=](nim::NIMResCode res_code,
                           const std::list<nim::FriendProfile>& userList) {
    if (res_code == nim::kNIMResSuccess) {
      if (userList.size() > 0) {
        flutter::EncodableMap result_map;
        flutter::EncodableList userList_;
        for (auto user : userList) {
          flutter::EncodableMap userMap;
          userMap.insert(
              std::make_pair(flutter::EncodableValue("userId"),
                             flutter::EncodableValue(user.GetAccId())));
          userMap.insert(
              std::make_pair(flutter::EncodableValue("alias"),
                             flutter::EncodableValue(user.GetAlias())));
          userMap.insert(std::make_pair(
              flutter::EncodableValue("extension"),
              flutter::EncodableValue(
                  nim::GetJsonStringWithNoStyled(user.GetEx()))));
          userMap.insert(
              std::make_pair(flutter::EncodableValue("serverExtension"),
                             flutter::EncodableValue(user.GetServerEx())));
          userList_.emplace_back(flutter::EncodableValue(userMap));
        }
        result_map.insert(std::make_pair("friendList", userList_));
        result->Success(NimResult::getSuccessResult(result_map));
      } else {
        result->Error("", "",
                      NimResult::getErrorResult(-1, "getFriendList failed!"));
      }
    } else {
      result->Error(
          "", "", NimResult::getErrorResult(res_code, "getFriendList failed!"));
    }
  });
}

void FLTUserService::getFriend(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    result->Error("", "",
                  NimResult::getErrorResult(-1, "getFriend params error!"));
    return;
  }

  std::string userId = "";
  auto iter = arguments->find(EncodableValue("userId"));
  if (iter != arguments->end()) {
    userId = std::get<std::string>(iter->second);
  }

  if (userId.empty()) {
    result->Error("", "",
                  NimResult::getErrorResult(-1, "getFriend params error!"));
    return;
  }

  nim::Friend::GetFriendProfile(userId, [=](const std::string& accid,
                                            const nim::FriendProfile& user) {
    flutter::EncodableMap userMap;
    userMap.insert(std::make_pair(flutter::EncodableValue("userId"),
                                  flutter::EncodableValue(user.GetAccId())));
    userMap.insert(std::make_pair(flutter::EncodableValue("alias"),
                                  flutter::EncodableValue(user.GetAlias())));
    userMap.insert(std::make_pair(
        flutter::EncodableValue("extension"),
        flutter::EncodableValue(nim::GetJsonStringWithNoStyled(user.GetEx()))));
    userMap.insert(std::make_pair(flutter::EncodableValue("serverExtension"),
                                  flutter::EncodableValue(user.GetServerEx())));
    result->Success(NimResult::getSuccessResult(userMap));
  });
}

void FLTUserService::addFriend(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    result->Error("", "",
                  NimResult::getErrorResult(-1, "addFriend params error!"));
    return;
  }

  std::string userId = "";
  std::string message = "";
  int verifyType = 0;
  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) continue;

    if (iter->first == flutter::EncodableValue("verifyType")) {
      verifyType = std::get<int>(iter->second) + 1;
      std::cout << " verifyType:" << verifyType;
    } else if (iter->first == flutter::EncodableValue("userId")) {
      userId = std::get<std::string>(iter->second);
      std::cout << " userId:" << userId;
    } else if (iter->first == flutter::EncodableValue("message")) {
      message = std::get<std::string>(iter->second);
    }
  }

  bool res = nim::Friend::Request(
      userId, static_cast<nim::NIMVerifyType>(verifyType), message,
      [=](nim::NIMResCode res_code) {
        if (res_code == nim::kNIMResSuccess) {
          result->Success(NimResult::getSuccessResult());
        } else {
          result->Error(
              "", "", NimResult::getErrorResult(res_code, "addFriend failed!"));
        }
      });

  if (!res) {
    result->Error("", "", NimResult::getErrorResult(-1, "addFriend failed!"));
  }
}

void FLTUserService::ackAddFriend(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    result->Error("", "",
                  NimResult::getErrorResult(-1, "ackAddFriend params error!"));
    return;
  }

  std::string userId = "";
  nim::NIMVerifyType type = nim::kNIMVerifyTypeAgree;
  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) continue;

    if (iter->first == flutter::EncodableValue("isAgree")) {
      type = std::get<bool>(iter->second) ? nim::kNIMVerifyTypeAgree
                                          : nim::kNIMVerifyTypeReject;
    } else if (iter->first == flutter::EncodableValue("userId")) {
      userId = std::get<std::string>(iter->second);
    }
  }

  bool res =
      nim::Friend::Request(userId, type, "", [=](nim::NIMResCode res_code) {
        if (res_code == nim::kNIMResSuccess) {
          result->Success(NimResult::getSuccessResult());
        } else {
          result->Error(
              "", "",
              NimResult::getErrorResult(res_code, "ackAddFriend failed!"));
        }
      });

  if (!res) {
    result->Error("", "",
                  NimResult::getErrorResult(-1, "ackAddFriend failed!"));
  }
}

void FLTUserService::deleteFriend(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    result->Error("", "",
                  NimResult::getErrorResult(-1, "deleteFriend params error!"));
    return;
  }

  std::string userId = "";
  bool includeAlias = false;
  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) continue;

    if (iter->first == flutter::EncodableValue("includeAlias")) {
      includeAlias = std::get<bool>(iter->second);
    } else if (iter->first == flutter::EncodableValue("userId")) {
      userId = std::get<std::string>(iter->second);
    }
  }

  nim::DeleteFriendOption opt;
  opt.delete_alias_ = includeAlias;

  bool res = nim::Friend::DeleteEx(userId, opt, [=](nim::NIMResCode res_code) {
    if (res_code == nim::kNIMResSuccess) {
      result->Success(NimResult::getSuccessResult());
    } else {
      result->Error(
          "", "", NimResult::getErrorResult(res_code, "deleteFriend failed!"));
    }
  });

  if (!res) {
    result->Error("", "",
                  NimResult::getErrorResult(-1, "deleteFriend failed!"));
  }
}

void FLTUserService::updateFriend(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    result->Error("", "",
                  NimResult::getErrorResult(-1, "updateFriend params error!"));
    return;
  }

  std::string userId = "";
  std::string alias = "";
  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) continue;

    if (iter->first == flutter::EncodableValue("alias")) {
      alias = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("userId")) {
      userId = std::get<std::string>(iter->second);
    }
  }

  nim::FriendProfile profile;
  profile.SetAlias(alias);
  profile.SetAccId(userId);

  bool res = nim::Friend::Update(profile, [=](nim::NIMResCode res_code) {
    if (res_code == nim::kNIMResSuccess) {
      result->Success(NimResult::getSuccessResult());
    } else {
      result->Error(
          "", "", NimResult::getErrorResult(res_code, "updateFriend failed!"));
    }
  });

  if (!res) {
    result->Error("", "",
                  NimResult::getErrorResult(-1, "updateFriend failed!"));
  }
}

void FLTUserService::isMyFriend(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    result->Error("", "",
                  NimResult::getErrorResult(-1, "isMyFriend params error!"));
    return;
  }

  std::string userId = "";
  auto iter = arguments->find(EncodableValue("userId"));
  if (iter != arguments->end()) {
    if (iter->second.IsNull()) {
      result->Error("", "",
                    NimResult::getErrorResult(-1, "isMyFriend params error!"));
      return;
    }
    userId = std::get<std::string>(iter->second);
  }

  nim::Friend::GetList([=](nim::NIMResCode res_code,
                           const std::list<nim::FriendProfile>& userList) {
    if (res_code == nim::kNIMResSuccess) {
      if (userList.size() > 0) {
        for (auto user : userList) {
          if (user.GetAccId() == userId) {
            result->Success(
                NimResult::getSuccessResult(flutter::EncodableValue(true)));
            return;
          }
        }
      }
      result->Success(
          NimResult::getSuccessResult(flutter::EncodableValue(false)));
    } else {
      result->Error("", "",
                    NimResult::getErrorResult(res_code, "isMyFriend failed!"));
    }
  });
}

void FLTUserService::friendChangeCallback(const nim::FriendChangeEvent& event) {
  std::string strContent = event.content_;

  if (event.type_ == nim::kNIMFriendChangeTypeRequest) {
    nim::FriendAddEvent addEvent;
    nim::Friend::ParseFriendAddEvent(event, addEvent);
    flutter::EncodableMap arguments;
    flutter::EncodableList userList;
    flutter::EncodableMap user;
    user.insert(std::make_pair("userId", addEvent.accid_));
    user.insert(std::make_pair("alias", ""));      // undone
    user.insert(std::make_pair("extension", ""));  // undone
    user.insert(std::make_pair("serverExtension", addEvent.server_ex_));
    userList.emplace_back(user);
    arguments.insert(std::make_pair("addedOrUpdatedFriendList", userList));

    notifyEvent("onFriendAddedOrUpdated", arguments);
  } else if (event.type_ == nim::kNIMFriendChangeTypeDel) {
    nim::FriendDelEvent delEvent;
    nim::Friend::ParseFriendDelEvent(event, delEvent);

    flutter::EncodableMap arguments;
    flutter::EncodableList userList;
    flutter::EncodableMap user;
    user.insert(std::make_pair("userId", delEvent.accid_));
    userList.emplace_back(user);
    arguments.insert(std::make_pair("deletedFriendAccountList", userList));

    notifyEvent("onFriendAccountDeleted", arguments);
  } else if (event.type_ == nim::kNIMFriendChangeTypeUpdate) {
    nim::FriendProfileUpdateEvent updateEvent;
    nim::Friend::ParseFriendProfileUpdateEvent(event, updateEvent);

    flutter::EncodableMap arguments;
    flutter::EncodableList userList;
    flutter::EncodableMap user;
    user.insert(std::make_pair("userId", updateEvent.profile_.GetAccId()));
    user.insert(std::make_pair("alias", updateEvent.profile_.GetAlias()));
    user.insert(std::make_pair("extension", nim::GetJsonStringWithNoStyled(
                                                updateEvent.profile_.GetEx())));
    user.insert(
        std::make_pair("serverExtension", updateEvent.profile_.GetServerEx()));
    userList.emplace_back(user);
    arguments.insert(std::make_pair("addedOrUpdatedFriendList", userList));

    notifyEvent("onFriendAddedOrUpdated", arguments);
  } else if (event.type_ == nim::kNIMFriendChangeTypeSyncList) {
    nim::FriendProfileSyncEvent syncEvent;
    nim::Friend::ParseFriendProfileSyncEvent(event, syncEvent);
    // todo
  }
}
void FLTUserService::specialRelationshipChangedCallback(
    const nim::SpecialRelationshipChangeEvent& event) {
  flutter::EncodableMap arguments;
  if (event.type_ == nim::kNIMUserSpecialRelationshipChangeTypeMarkBlack) {
    notifyEvent("onBlackListChanged", arguments);
  } else if (event.type_ ==
             nim::kNIMUserSpecialRelationshipChangeTypeMarkMute) {
    notifyEvent("onMuteListChanged", arguments);
  } else if (event.type_ ==
             nim::kNIMUserSpecialRelationshipChangeTypeSyncMuteAndBlackList) {
    // todo
  }
}

void FLTUserService::userNameCardChangedCallback(
    const std::list<nim::UserNameCard>& userList) {
  flutter::EncodableMap arguments;
  flutter::EncodableList userList_;
  for (auto user : userList) {
    flutter::EncodableMap user_;
    user_.insert(std::make_pair("userId", user.GetAccId()));
    user_.insert(std::make_pair("nick", user.GetName()));
    user_.insert(std::make_pair("avatar", user.GetIconUrl()));
    user_.insert(std::make_pair("signature", user.GetSignature()));
    std::string strGender;
    Convert::getInstance()->convertNIMEnumToDartString(
        user.GetGender(), Convert::getInstance()->getGenderType(), strGender);
    user_.insert(std::make_pair("gender", strGender));
    user_.insert(std::make_pair("email", user.GetEmail()));
    user_.insert(std::make_pair("birthday", user.GetBirth()));
    user_.insert(std::make_pair("mobile", user.GetMobile()));
    user_.insert(std::make_pair(
        "extension", nim::GetJsonStringWithNoStyled(user.GetExpand())));
    userList_.emplace_back(user_);
  }
  arguments.insert(std::make_pair("changedUserInfoList", userList_));
  notifyEvent("onUserInfoChanged", arguments);
}

void FLTUserService::dataSyncCallback(nim::NIMDataSyncType sync_type,
                                      nim::NIMDataSyncStatus status,
                                      const std::string& data_sync_info) {
  std::cout << "dataSyncCallback: sync_type" << sync_type << std::endl;
  std::cout << "dataSyncCallback: status" << status << std::endl;

  YXLOG(Info) << "dataSyncCallback: sync_type" << sync_type << YXLOGEnd;
  YXLOG(Info) << "dataSyncCallback: status" << status << YXLOGEnd;

  // todo
}
