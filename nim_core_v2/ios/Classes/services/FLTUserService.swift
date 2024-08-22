// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK
import UIKit

enum V2UserAPITypeEnums: String {
  case getUserList
  case getUserListFromCloud
  case searchUserByOption
  case updateSelfUserProfile
  case addUserToBlockList
  case removeUserFromBlockList
  case getBlockList
}

class FLTUserService: FLTBaseService, FLTService, V2NIMUserListener {
  override func onInitialized() {
    NIMSDK.shared().v2UserService.add(self)
  }

  deinit {
    NIMSDK.shared().v2UserService.remove(self)
  }

  func register(_ nimCore: NimCore) {
    self.nimCore = nimCore
    nimCore.addService(self)
  }

  func serviceName() -> String {
    ServiceType.UserService.rawValue
  }

  /**
   * 用户信息变更回调
   *
   * - Parameter users: 收到内容
   */
  func onUserProfileChanged(_ users: [V2NIMUser]) {
    notifyEvent(serviceName(), "onUserProfileChanged", ["userInfoList": users.map { $0.toDictionary() }])
  }

  /**
   * 黑名单添加通知
   *
   * - Parameter user: 加入黑名单用户
   */
  func onBlockListAdded(_ user: V2NIMUser) {
    let userInfo = user.toDictionary()
    print("onBlockListAdded -> \(userInfo)")
    notifyEvent(serviceName(), "onBlockListAdded", user.toDictionary())
  }

  /**
   * 黑名单移除通知
   * - Parameter accountId: 移除黑名的用户账号ID
   */
  func onBlockListRemoved(_ accountId: String) {
    notifyEvent(serviceName(), "onBlockListRemoved", ["userId": accountId])
  }

  /// 获取用户列表
  public func getUserList(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let accountIds = arguments["userIdList"] as? [String] else {
      parameterError(resultCallback)
      return
    }
    weak var weakSelf = self
    NIMSDK.shared().v2UserService.getUserList(accountIds) { users in
      var userList = [[String: Any]]()
      for user in users {
        userList.append(user.toDictionary())
      }
      weakSelf?.successCallBack(resultCallback, ["userInfoList": userList])
    } failure: { error in
      weakSelf?.errorCallBack(resultCallback, error.nserror.localizedDescription, Int(error.code))
    }
  }

  /// 从云端获取用户列表
  public func getUserListFromCloud(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let accountIds = arguments["userIdList"] as? [String] else {
      parameterError(resultCallback)
      return
    }
    weak var weakSelf = self
    NIMSDK.shared().v2UserService.getUserList(fromCloud: accountIds, success: { users in
      var userList: [[String: Any]] = []
      for user in users {
        userList.append(user.toDictionary())
      }
      weakSelf?.successCallBack(resultCallback, ["userInfoList": userList])
    }, failure: { error in
      weakSelf?.errorCallBack(resultCallback, error.nserror.localizedDescription, Int(error.code))
    })
  }

  /// 根据搜索条件搜索用户
  public func searchUserByOption(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let userSearchOptionArguments = arguments["userSearchOption"] as? [String: Any] else {
      parameterError(resultCallback)
      return
    }
    weak var weakSelf = self
    let searchOption = V2NIMUserSearchOption.fromDictionary(userSearchOptionArguments)
    NIMSDK.shared().v2UserService.searchUser(by: searchOption) { users in
      var userList: [[String: Any]] = []
      for user in users {
        userList.append(user.toDictionary())
      }
      weakSelf?.successCallBack(resultCallback, ["userInfoList": userList])
    } failure: { error in
      weakSelf?.errorCallBack(resultCallback, error.nserror.localizedDescription, Int(error.code))
    }
  }

  /// 更新自己的用户信息
  public func updateSelfUserProfile(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let updateParamArguments = arguments["updateParam"] as? [String: Any] else {
      parameterError(resultCallback)
      return
    }
    let updateParams = V2NIMUserUpdateParams.fromDictionary(updateParamArguments)
    weak var weakSelf = self
    NIMSDK.shared().v2UserService.updateSelfUserProfile(updateParams) {
      weakSelf?.successCallBack(resultCallback, nil)
    } failure: { error in
      weakSelf?.errorCallBack(resultCallback, error.nserror.localizedDescription, Int(error.code))
    }
  }

  /// 添加用户到黑名单
  public func addUserToBlockList(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let accountId = arguments["userId"] as? String else {
      parameterError(resultCallback)
      return
    }

    weak var weakSelf = self
    NIMSDK.shared().v2UserService.addUser(toBlockList: accountId) {
      weakSelf?.successCallBack(resultCallback, nil)
    } failure: { error in
      weakSelf?.errorCallBack(resultCallback, error.nserror.localizedDescription, Int(error.code))
    }
  }

  /// 从黑名单移除用户
  public func removeUserFromBlockList(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let accountId = arguments["userId"] as? String else {
      parameterError(resultCallback)
      return
    }
    weak var weakSelf = self
    NIMSDK.shared().v2UserService.removeUser(fromBlockList: accountId) {
      weakSelf?.successCallBack(resultCallback, nil)
    } failure: { error in
      weakSelf?.errorCallBack(resultCallback, error.nserror.localizedDescription, Int(error.code))
    }
  }

  /// 获取黑名单列表
  public func getBlockList(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    weak var weakSelf = self
    NIMSDK.shared().v2UserService.getBlockList { blackList in
      weakSelf?.successCallBack(resultCallback, ["userIdList": blackList])
    } failure: { error in
      weakSelf?.errorCallBack(resultCallback, error.nserror.localizedDescription, Int(error.code))
    }
  }

  func onMethodCalled(_ method: String, _ arguments: [String: Any],
                      _ resultCallback: ResultCallback) {
    switch method {
    case V2UserAPITypeEnums.getUserList.rawValue:
      getUserList(arguments, resultCallback)
    case V2UserAPITypeEnums.getUserListFromCloud.rawValue:
      getUserListFromCloud(arguments, resultCallback)
    case V2UserAPITypeEnums.searchUserByOption.rawValue:
      searchUserByOption(arguments, resultCallback)
    case V2UserAPITypeEnums.updateSelfUserProfile.rawValue:
      updateSelfUserProfile(arguments, resultCallback)
    case V2UserAPITypeEnums.addUserToBlockList.rawValue:
      addUserToBlockList(arguments, resultCallback)
    case V2UserAPITypeEnums.removeUserFromBlockList.rawValue:
      removeUserFromBlockList(arguments, resultCallback)
    case V2UserAPITypeEnums.getBlockList.rawValue:
      getBlockList(arguments, resultCallback)
    default:
      resultCallback.notImplemented()
    }
  }
}
