// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import Foundation
import NIMSDK

enum UserType: String {
  case GetUserInfo = "getUserInfo"
  case FetchUserInfoList = "fetchUserInfoList"
  case UpdateMyUserInfo = "updateMyUserInfo"
  case SearchUserIdListByNick = "searchUserIdListByNick"
  case SearchUserInfoListByKeyword = "searchUserInfoListByKeyword"
  case GetFriendList = "getFriendList"
  case GetFriend = "getFriend"
  case AddFriend = "addFriend"
  case AckAddFriend = "ackAddFriend"
  case DeleteFriend = "deleteFriend"
  case UpdateFriend = "updateFriend"
  case IsMyFriend = "isMyFriend"
  case GetBlackList = "getBlackList"
  case AddToBlackList = "addToBlackList"
  case RemoveFromBlackList = "removeFromBlackList"
  case IsInBlackList = "isInBlackList"
  case GetMuteList = "getMuteList"
  case SetMute = "setMute"
  case IsMute = "isMute"
  case getCurrentAccount
}

class FLTUserService: FLTBaseService, FLTService {
//    override init() {
//        super.init()
//        NIMSDK.shared().userManager.add(self)
//    }

  override func onInitialized() {
    NIMSDK.shared().userManager.add(self)
  }

  deinit {
    NIMSDK.shared().userManager.remove(self)
  }

  // MARK: Service Protocol

  func serviceName() -> String {
    ServiceType.UserService.rawValue
  }

  func onMethodCalled(_ method: String, _ arguments: [String: Any],
                      _ resultCallback: ResultCallback) {
    switch method {
    case UserType.GetUserInfo.rawValue:
      getUserInfo(arguments, resultCallback)
    case UserType.FetchUserInfoList.rawValue:
      fetchUserInfoList(arguments, resultCallback)
    case UserType.UpdateMyUserInfo.rawValue:
      updateMyUserInfo(arguments, resultCallback)
    case UserType.SearchUserIdListByNick.rawValue:
      searchUserIdListByNick(arguments, resultCallback)
    case UserType.SearchUserInfoListByKeyword.rawValue:
      searchUserInfoListByKeyword(arguments, resultCallback)
    case UserType.GetFriendList.rawValue:
      getFriendList(resultCallback)
    case UserType.GetFriend.rawValue:
      getFriend(arguments, resultCallback)
    case UserType.AddFriend.rawValue:
      addFriend(arguments, resultCallback)
    case UserType.AckAddFriend.rawValue:
      ackAddFriend(arguments, resultCallback)
    case UserType.DeleteFriend.rawValue:
      deleteFriend(arguments, resultCallback)
    case UserType.UpdateFriend.rawValue:
      updateFriend(arguments, resultCallback)
    case UserType.IsMyFriend.rawValue:
      isMyFriend(arguments, resultCallback)
    case UserType.GetBlackList.rawValue:
      getBlackList(arguments, resultCallback)
    case UserType.AddToBlackList.rawValue:
      addToBlackList(arguments, resultCallback)
    case UserType.RemoveFromBlackList.rawValue:
      removeFromBlackList(arguments, resultCallback)
    case UserType.IsInBlackList.rawValue:
      isInBlackList(arguments, resultCallback)
    case UserType.GetMuteList.rawValue:
      getMuteList(arguments, resultCallback)
    case UserType.SetMute.rawValue:
      setMute(arguments, resultCallback)
    case UserType.IsMute.rawValue:
      isMute(arguments, resultCallback)
    case UserType.getCurrentAccount.rawValue:
      getCurrentAccount(resultCallback)
    default:
      resultCallback.notImplemented()
    }
  }

  func register(_ nimCore: NimCore) {
    self.nimCore = nimCore
    nimCore.addService(self)
  }

  // MARK: Public Method

  func getUserInfo(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    let userId = arguments["userId"] as? String
    if userId != nil,
       !userId!.isEmpty {
      let user = NIMSDK.shared().userManager.userInfo(userId!)
      if user != nil,
         user?.userInfo != nil {
        let result = NimResult(converNIMUserToDict(user!), 0, nil)
        resultCallback.result(result.toDic())
      } else {
        // 没查到
        let result = NimResult(nil, 0, nil)
        resultCallback.result(result.toDic())
      }
    } else {
      let result = NimResult(nil, -1, "getUserInfo but the userId is empty!")
      resultCallback.result(result.toDic())
    }
  }

  // MARK: Public Method

  func getFriend(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    getUserInfo(arguments, resultCallback)
  }

  func fetchUserInfoList(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    let userIds = arguments["userIdList"] as? [String]
    if userIds != nil, userIds!.count > 0 {
      NIMSDK.shared().userManager.fetchUserInfos(userIds!) { [weak self] retUsers, error in
        if error != nil {
          let nserror = error! as NSError
          let result = NimResult(nil, NSNumber(value: nserror.code), nserror.description)
          resultCallback.result(result.toDic())
        } else {
          if let users = retUsers {
            var jsonArray = [[String: Any?]]()
            for user: NIMUser in users {
              if let userDict = self?.converNIMUserToDict(user) {
                jsonArray.append(userDict)
              }
            }
            let result = NimResult(["userInfoList": jsonArray], 0, nil)
            resultCallback.result(result.toDic())
          } else {
            let result = NimResult(nil, 0, "userId does not exist")
            resultCallback.result(result.toDic())
          }
        }
      }
    } else {
      let result = NimResult(nil, -1, "fetchUserInfos but the userIds is empty!")
      resultCallback.result(result.toDic())
    }
  }

  func updateMyUserInfo(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    var args = [NSNumber: Any]()
    args[NSNumber(value: NIMUserInfoUpdateTag.nick.rawValue)] = arguments["nick"] as? String
    args[NSNumber(value: NIMUserInfoUpdateTag.avatar.rawValue)] = arguments["avatar"] as? String
    args[NSNumber(value: NIMUserInfoUpdateTag.birth.rawValue)] =
      arguments["birthday"] as? String
    args[NSNumber(value: NIMUserInfoUpdateTag.email.rawValue)] = arguments["email"] as? String
    if let gender = arguments["gender"] as? String {
      var g = NIMUserGender.unknown
      if gender == "male" {
        g = .male
      } else if gender == "female" {
        g = .female
      }
      args[NSNumber(value: NIMUserInfoUpdateTag.gender.rawValue)] = NSNumber(value: g
        .rawValue)
    }
    args[NSNumber(value: NIMUserInfoUpdateTag.mobile.rawValue)] = arguments["mobile"] as? String
    args[NSNumber(value: NIMUserInfoUpdateTag.sign.rawValue)] =
      arguments["signature"] as? String
    args[NSNumber(value: NIMUserInfoUpdateTag.ext.rawValue)] = arguments["extension"] as? String
    NIMSDK.shared().userManager.updateMyUserInfo(args) { error in
      if error != nil {
        let nserror = error! as NSError
        let result = NimResult(nil, NSNumber(value: nserror.code), nserror.description)
        resultCallback.result(result.toDic())
      } else {
        let result = NimResult(nil, 0, nil)
        resultCallback.result(result.toDic())
      }
    }
  }

  func searchUserIdListByNick(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    let nick = arguments["nick"] as? String
    if nick != nil, !nick!.isEmpty {
      let option = NIMUserSearchOption()
      option.ignoreingCase = true
      option.searchContent = nick
      option.searchContentOption = NIMUserSearchContentOption.nickName
      option.searchRange = NIMUserSearchRangeOption.all
      NIMSDK.shared().userManager.searchUser(with: option) { users, error in
        if error != nil {
          let nserror = error! as NSError
          let result = NimResult(nil, NSNumber(value: nserror.code), nserror.description)
          resultCallback.result(result.toDic())
        } else {
          var array: [String] = .init()
          for user: NIMUser in users! {
            array.append(user.userId!)
          }
          let result = NimResult(["userIdList": array], 0, nil)
          resultCallback.result(result.toDic())
        }
      }
    } else {
      let result = NimResult(nil, -1, "searchUserIdByNick but the nick is empty!")
      resultCallback.result(result.toDic())
    }
  }

  func searchUserInfoListByKeyword(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    let keyword = arguments["keyword"] as? String
    if keyword != nil, !keyword!.isEmpty {
      let option = NIMUserSearchOption()
      option.ignoreingCase = true
      option.searchContent = keyword
      option.searchContentOption = NIMUserSearchContentOption.all
      option.searchRange = NIMUserSearchRangeOption.friends
      NIMSDK.shared().userManager.searchUser(with: option) { users, error in
        if error != nil {
          let nserror = error! as NSError
          let result = NimResult(nil, NSNumber(value: nserror.code), nserror.description)
          resultCallback.result(result.toDic())
        } else {
          var array: [[String: Any?]] = .init()
          for user: NIMUser in users! {
            array.append(self.converNIMUserToDict(user))
          }
          let result = NimResult(["userInfoList": array], 0, nil)
          resultCallback.result(result.toDic())
        }
      }
    } else {
      let result = NimResult(nil, -1, "searchUserInfosByKeyword but the keyword is empty!")
      resultCallback.result(result.toDic())
    }
  }

  func getFriendList(_ resultCallback: ResultCallback) {
    guard let friends = NIMSDK.shared().userManager.myFriends() else {
      let result = NimResult(nil, 0, nil)
      resultCallback.result(result.toDic())
      return
    }
    var array = [[String: Any?]]()
    for friend in friends {
      array.append(converNIMUserToDict(friend))
    }
    let result = NimResult(["friendList": array], 0, nil)
    resultCallback.result(result.toDic())
  }

  func addFriend(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    let request = NIMUserRequest()
    request.operation = NIMUserOperation.add
    if let type = arguments["verifyType"] as? Int {
      if type == 0 {
        request.operation = NIMUserOperation.add
      } else if type == 1 {
        request.operation = NIMUserOperation.request
      }
    }
    request.message = arguments["message"] as? String
    request.userId = arguments["userId"] as? String ?? ""
    NIMSDK.shared().userManager.requestFriend(request) { error in
      if error != nil {
        let nserror = error! as NSError
        let result = NimResult(nil, NSNumber(value: nserror.code), nserror.description)
        resultCallback.result(result.toDic())
      } else {
        let result = NimResult(nil, 0, nil)
        resultCallback.result(result.toDic())
      }
    }
  }

  func ackAddFriend(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    let userId = arguments["userId"] as? String
    if userId == nil || userId!.isEmpty {
      let result = NimResult(nil, -1, "ackAddFriend but userId is empty")
      resultCallback.result(result.toDic())
      return
    }
    let isAgree = arguments["isAgree"] as? Bool
    let request = NIMUserRequest()
    request.userId = userId!
    request.operation = isAgree ?? false ? NIMUserOperation.verify : NIMUserOperation.reject
    NIMSDK.shared().userManager.requestFriend(request) { error in
      if error != nil {
        let nserror = error! as NSError
        let result = NimResult(nil, NSNumber(value: nserror.code), nserror.description)
        resultCallback.result(result.toDic())
      } else {
        let result = NimResult(nil, 0, nil)
        resultCallback.result(result.toDic())
      }
    }
  }

  func deleteFriend(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    let userId = arguments["userId"] as? String
    if userId == nil || userId!.isEmpty {
      let result = NimResult(nil, -1, "deleteFriend but userId is empty")
      resultCallback.result(result.toDic())
      return
    }
    let includeAlias = arguments["includeAlias"] as? Bool
    NIMSDK.shared().userManager
      .deleteFriend(userId!, removeAlias: includeAlias ?? false) { error in
        if error != nil {
          let nserror = error! as NSError
          let result = NimResult(nil, NSNumber(value: nserror.code), nserror.description)
          resultCallback.result(result.toDic())
        } else {
          let result = NimResult(nil, 0, nil)
          resultCallback.result(result.toDic())
        }
      }
  }

  func updateFriend(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    let userId = arguments["userId"] as? String
    if userId == nil || userId!.isEmpty {
      let result = NimResult(nil, -1, "updateFriend but userId is empty")
      resultCallback.result(result.toDic())
      return
    }
    let alias = arguments["alias"] as? String
    let user = NIMUser()
    user.userId = userId
    user.alias = alias ?? ""
    NIMSDK.shared().userManager.update(user) { error in
      if error != nil {
        let nserror = error! as NSError
        let result = NimResult(nil, NSNumber(value: nserror.code), nserror.description)
        resultCallback.result(result.toDic())
      } else {
        let result = NimResult(nil, 0, nil)
        resultCallback.result(result.toDic())
      }
    }
  }

  func isMyFriend(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    let userId = arguments["userId"] as? String
    if userId == nil {
      let result = NimResult(nil, -1, "isMyFriend but userId is empty")
      resultCallback.result(result.toDic())
      return
    }
    let isFriend = NIMSDK.shared().userManager.isMyFriend(userId!)
    let result = NimResult(isFriend, 0, nil)
    resultCallback.result(result.toDic())
  }

  func getBlackList(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let list = NIMSDK.shared().userManager.myBlackList() else {
      let result = NimResult(nil, 0, nil)
      resultCallback.result(result.toDic())
      return
    }
    let jsonArray = list.compactMap { user in
      user.userId
    }
    let result = NimResult(["userIdList": jsonArray], 0, nil)
    resultCallback.result(result.toDic())
  }

  func addToBlackList(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    let userId = arguments["userId"] as? String
    if userId == nil || userId!.isEmpty {
      let result = NimResult(nil, -1, "addToBlackList but userId is empty")
      resultCallback.result(result.toDic())
      return
    }
    NIMSDK.shared().userManager.add(toBlackList: userId!) { error in
      if error != nil {
        let nserror = error! as NSError
        let result = NimResult(nil, NSNumber(value: nserror.code), nserror.description)
        resultCallback.result(result.toDic())
      } else {
        let result = NimResult(nil, 0, nil)
        resultCallback.result(result.toDic())
      }
    }
  }

  func removeFromBlackList(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    let userId = arguments["userId"] as? String
    if userId == nil || userId!.isEmpty {
      let result = NimResult(nil, -1, "removeFromBlackList but userId is empty")
      resultCallback.result(result.toDic())
      return
    }
    NIMSDK.shared().userManager.remove(fromBlackBlackList: userId!) { error in
      if error != nil {
        let nserror = error! as NSError
        let result = NimResult(nil, NSNumber(value: nserror.code), nserror.description)
        resultCallback.result(result.toDic())
      } else {
        let result = NimResult(nil, 0, nil)
        resultCallback.result(result.toDic())
      }
    }
  }

  func isInBlackList(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    let userId = arguments["userId"] as? String
    if userId == nil {
      let result = NimResult(nil, -1, "isInBlackList but userId is empty")
      resultCallback.result(result.toDic())
      return
    }
    let isBlack = NIMSDK.shared().userManager.isUser(inBlackList: userId!)
    let result = NimResult(isBlack, 0, nil)
    resultCallback.result(result.toDic())
  }

  func getMuteList(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let list = NIMSDK.shared().userManager.myMuteUserList() else {
      let result = NimResult(nil, 0, nil)
      resultCallback.result(result.toDic())
      return
    }
    let jsonArray = list.compactMap { user in
      user.userId
    }
    let result = NimResult(["userIdList": jsonArray], 0, nil)
    resultCallback.result(result.toDic())
  }

  func setMute(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    let userId = arguments["userId"] as? String
    if userId == nil || userId!.isEmpty {
      let result = NimResult(nil, -1, "setMute but userId is empty")
      resultCallback.result(result.toDic())
      return
    }
    let isMute = arguments["isMute"] as? Bool ?? false
    NIMSDK.shared().userManager.updateNotifyState(!isMute, forUser: userId!) { error in
      if error != nil {
        let nserror = error! as NSError
        let result = NimResult(nil, NSNumber(value: nserror.code), nserror.description)
        resultCallback.result(result.toDic())
      } else {
        let result = NimResult(nil, 0, nil)
        resultCallback.result(result.toDic())
      }
    }
  }

  func isMute(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    let userId = arguments["userId"] as? String
    if userId == nil {
      let result = NimResult(nil, -1, "isMute but userId is empty")
      resultCallback.result(result.toDic())
      return
    }
    let notify = NIMSDK.shared().userManager.notify(forNewMsg: userId!)
    let result = NimResult(!notify, 0, nil)
    resultCallback.result(result.toDic())
  }

  func getCurrentAccount(_ resultCallback: ResultCallback) {
    let accId = NIMSDK.shared().loginManager.currentAccount()
    let result = NimResult(accId, 0, nil)
    resultCallback.result(result.toDic())
  }

  // MARK: Private Method

  private func converNIMUserToDict(_ user: NIMUser) -> [String: Any] {
    var target = [String: Any]()
    if var dic = user.userInfo?.toDic() {
      if let gender = user.userInfo?.gender {
        switch gender {
        case .unknown:
          dic["gender"] = "unknown"
        case .male:
          dic["gender"] = "male"
        case .female:
          dic["gender"] = "female"
        default:
          dic["gender"] = "unknown"
        }
      }
      target = dic
    }
    if let uid = user.userId {
      target["userId"] = uid
    }
    target["alias"] = user.alias ?? ""
    if let ex = user.userInfo?.ext {
      target["extension"] = ex
    }

    target["serverExtension"] = user.serverExt ?? ""
    return target
  }
}

extension FLTUserService: NIMUserManagerDelegate {
  func onFriendChanged(_ user: NIMUser) {
    if NIMSDK.shared().userManager.isMyFriend(user.userId!) {
      notifyEvent(
        serviceName(),
        "onFriendAddedOrUpdated",
        ["addedOrUpdatedFriendList": [converNIMUserToDict(user) as [String: Any]]]
      )
    } else {
      notifyEvent(
        serviceName(),
        "onFriendAccountDeleted",
        ["deletedFriendAccountList": [user.userId as Any]]
      )
    }
  }

  func onUserInfoChanged(_ user: NIMUser) {
    notifyEvent(
      serviceName(),
      "onUserInfoChanged",
      ["changedUserInfoList": [converNIMUserToDict(user) as [String: Any]]]
    )
  }

  func onBlackListChanged() {
    notifyEvent(serviceName(), "onBlackListChanged", nil)
  }

  func onMuteListChanged() {
    notifyEvent(serviceName(), "onMuteListChanged", nil)
  }
}
