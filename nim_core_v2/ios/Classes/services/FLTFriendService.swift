// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import Foundation
import NIMSDK

class FLTFriendService: FLTBaseService, FLTService,
  V2NIMFriendListener {
  func serviceName() -> String {
    ServiceType.FriendService.rawValue
  }

  private let paramErrorTip = "param Error"
  private let paramErrorCode = 199_414

  private func friendCallback(_ error: Error?, _ data: Any?, _ resultCallback: ResultCallback) {
    if let ns_error = error as NSError? {
      errorCallBack(resultCallback, ns_error.description, ns_error.code)
    } else {
      successCallBack(resultCallback, data)
    }
  }

  override func onInitialized() {
    NIMSDK.shared().v2FriendService.add(self)
  }

  deinit {
    NIMSDK.shared().v2FriendService.remove(self)
  }

  func onMethodCalled(_ method: String, _ arguments: [String: Any], _ resultCallback: ResultCallback) {
    switch method {
    case "addFriend":
      addFriend(arguments, resultCallback)
    case "deleteFriend":
      deleteFriend(arguments, resultCallback)
    case "setFriendInfo":
      setFriendInfo(arguments, resultCallback)
    case "acceptAddApplication":
      acceptAddApplication(arguments, resultCallback)
    case "rejectAddApplication":
      rejectAddApplication(arguments, resultCallback)
    case "getFriendList":
      getFriendList(arguments, resultCallback)
    case "getFriendByIds":
      getFriendByIds(arguments, resultCallback)
    case "searchFriendByOption":
      searchFriendByOption(arguments, resultCallback)
    case "checkFriend":
      checkFriend(arguments, resultCallback)
    case "getAddApplicationList":
      getAddApplicationList(arguments, resultCallback)
    case "getAddApplicationUnreadCount":
      getAddApplicationUnreadCount(arguments, resultCallback)
    case "setAddApplicationRead":
      setAddApplicationRead(arguments, resultCallback)

    default:
      resultCallback.notImplemented()
    }
  }

  func register(_ nimCore: NimCore) {
    self.nimCore = nimCore
    nimCore.addService(self)
  }

  func onFriendAdded(_ friendInfo: V2NIMFriend) {
    notifyEvent(serviceName(), "onFriendAdded", friendInfo.toDict() as [String: Any])
  }

  func onFriendDeleted(_ accountId: String, deletionType: V2NIMFriendDeletionType) {
    notifyEvent(serviceName(), "onFriendDeleted", ["accountId": accountId, "deletionType": deletionType.rawValue])
  }

  func onFriendAddApplication(_ application: V2NIMFriendAddApplication) {
    notifyEvent(serviceName(), "onFriendAddApplication", application.toDict())
  }

  func onFriendAddRejected(_ rejectionInfo: V2NIMFriendAddApplication) {
    notifyEvent(serviceName(), "onFriendAddRejected", rejectionInfo.toDict())
  }

  func onFriendInfoChanged(_ friendInfo: V2NIMFriend) {
    notifyEvent(serviceName(), "onFriendInfoChanged", friendInfo.toDict())
  }

  private func addFriend(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let accountId = arguments["accountId"] as? String else {
      errorCallBack(resultCallback, paramErrorTip, paramErrorCode)
      return
    }

    var params = V2NIMFriendAddParams()
    if let paramsMap = arguments["params"] as? [String: Any?] {
      params = V2NIMFriendAddParams.fromDict(paramsMap)
    }

    weak var weakSelf = self
    NIMSDK.shared().v2FriendService.addFriend(accountId, params: params) {
      weakSelf?.friendCallback(nil, nil, resultCallback)
    } failure: { error in
      weakSelf?.friendCallback(error.nserror, nil, resultCallback)
    }
  }

  private func deleteFriend(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let accountId = arguments["accountId"] as? String else {
      errorCallBack(resultCallback, paramErrorTip, paramErrorCode)
      return
    }

    var params = V2NIMFriendDeleteParams()
    if let paramsMap = arguments["params"] as? [String: Any?] {
      params = V2NIMFriendDeleteParams.fromDict(paramsMap)
    }

    weak var weakSelf = self
    NIMSDK.shared().v2FriendService.deleteFriend(accountId, params: params) {
      weakSelf?.friendCallback(nil, nil, resultCallback)
    } failure: { error in
      weakSelf?.friendCallback(error.nserror, nil, resultCallback)
    }
  }

  private func setFriendInfo(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let accountId = arguments["accountId"] as? String else {
      errorCallBack(resultCallback, paramErrorTip, paramErrorCode)
      return
    }

    var params = V2NIMFriendSetParams()
    if let paramsMap = arguments["params"] as? [String: Any?] {
      params = V2NIMFriendSetParams.fromDict(paramsMap)
    }

    weak var weakSelf = self
    NIMSDK.shared().v2FriendService.setFriendInfo(accountId, params: params) {
      weakSelf?.friendCallback(nil, nil, resultCallback)
    } failure: { error in
      weakSelf?.friendCallback(error.nserror, nil, resultCallback)
    }
  }

  private func acceptAddApplication(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    var application = V2NIMFriendAddApplication()
    if let paramsMap = arguments["application"] as? [String: Any?] {
      application = V2NIMFriendAddApplication.fromDict(paramsMap)
    }

    weak var weakSelf = self
    NIMSDK.shared().v2FriendService.accept(application) {
      weakSelf?.friendCallback(nil, nil, resultCallback)
    } failure: { error in
      weakSelf?.friendCallback(error.nserror, nil, resultCallback)
    }
  }

  private func rejectAddApplication(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    var application = V2NIMFriendAddApplication()
    if let paramsMap = arguments["application"] as? [String: Any?] {
      application = V2NIMFriendAddApplication.fromDict(paramsMap)
    }

    let postscript = arguments["postscript"] as? String ?? ""

    weak var weakSelf = self
    NIMSDK.shared().v2FriendService.reject(application, postscript: postscript) {
      weakSelf?.friendCallback(nil, nil, resultCallback)
    } failure: { error in
      weakSelf?.friendCallback(error.nserror, nil, resultCallback)
    }
  }

  private func getFriendList(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    weak var weakSelf = self
    NIMSDK.shared().v2FriendService.getFriendList { friends in
      weakSelf?.friendCallback(nil,
                               ["friendList": friends.map { $0.toDict() }],
                               resultCallback)
    } failure: { error in
      weakSelf?.friendCallback(error.nserror, nil, resultCallback)
    }
  }

  private func getFriendByIds(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let accountIds = arguments["accountIds"] as? [String] else {
      errorCallBack(resultCallback, paramErrorTip, paramErrorCode)
      return
    }

    weak var weakSelf = self
    NIMSDK.shared().v2FriendService.getFriendByIds(accountIds) { friends in
      weakSelf?.friendCallback(nil,
                               ["friendList": friends.map { $0.toDict() }],
                               resultCallback)
    } failure: { error in
      weakSelf?.friendCallback(error.nserror, nil, resultCallback)
    }
  }

  private func searchFriendByOption(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let optionMap = arguments["friendSearchOption"] as? [String: Any?] else {
      errorCallBack(resultCallback, paramErrorTip, paramErrorCode)
      return
    }

    let option = V2NIMFriendSearchOption.fromDict(optionMap)

    weak var weakSelf = self
    NIMSDK.shared().v2FriendService.searchFriend(by: option) { friends in
      weakSelf?.friendCallback(nil,
                               ["friendList": friends.map { $0.toDict() }],
                               resultCallback)
    } failure: { error in
      weakSelf?.friendCallback(error.nserror, nil, resultCallback)
    }
  }

  private func checkFriend(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let accountIds = arguments["accountIds"] as? [String] else {
      errorCallBack(resultCallback, paramErrorTip, paramErrorCode)
      return
    }

    weak var weakSelf = self
    NIMSDK.shared().v2FriendService.checkFriend(accountIds) { result in
      weakSelf?.friendCallback(nil, ["result": result], resultCallback)
    } failure: { error in
      weakSelf?.friendCallback(error.nserror, nil, resultCallback)
    }
  }

  private func getAddApplicationList(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    var option = V2NIMFriendAddApplicationQueryOption()
    if let optionMap = arguments["option"] as? [String: Any?] {
      option = V2NIMFriendAddApplicationQueryOption.fromDict(optionMap)
    }

    weak var weakSelf = self
    NIMSDK.shared().v2FriendService.getAddApplicationList(option) { result in
      weakSelf?.friendCallback(nil,
                               result.toDict(),
                               resultCallback)
    } failure: { error in
      weakSelf?.friendCallback(error.nserror, nil, resultCallback)
    }
  }

  private func getAddApplicationUnreadCount(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    weak var weakSelf = self
    NIMSDK.shared().v2FriendService.getAddApplicationUnreadCount { count in
      weakSelf?.friendCallback(nil, count, resultCallback)
    } failure: { error in
      weakSelf?.friendCallback(error.nserror, nil, resultCallback)
    }
  }

  private func setAddApplicationRead(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    weak var weakSelf = self
    NIMSDK.shared().v2FriendService.setAddApplicationRead { _ in
      weakSelf?.friendCallback(nil, nil, resultCallback)
    } failure: { error in
      weakSelf?.friendCallback(error.nserror, nil, resultCallback)
    }
  }
}
