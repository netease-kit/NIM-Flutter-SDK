// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import Foundation
import NIMSDK

let subscriptionClassName = "FLTSubscriptionService"

enum V2SubscriptionNameType: String {
  case subscribeUserStatus
  case unsubscribeUserStatus
  case publishCustomUserStatus
  case queryUserStatusSubscriptions
}

class FLTSubscriptionService: FLTBaseService, FLTService, V2NIMSubscribeListener {
  override func onInitialized() {
    NIMSDK.shared().v2SubscriptionService.add(self)
  }

  deinit {
    NIMSDK.shared().v2SubscriptionService.remove(self)
  }

  func serviceName() -> String {
    ServiceType.SubscriptionService.rawValue
  }

  func register(_ nimCore: NimCore) {
    self.nimCore = nimCore
    nimCore.addService(self)
  }

  private func subscriptionCallback(_ error: Error?, _ data: Any?, _ resultCallback: ResultCallback) {
    if let ns_error = error as NSError? {
      errorCallBack(resultCallback, ns_error.description, ns_error.code)
    } else {
      successCallBack(resultCallback, data)
    }
  }

  /// 订阅用户状态，包括在线状态，或自定义状态
  /// 单次订阅人数最多100，如果有较多人数需要调用，需多次调用该接口
  /// 如果同一账号多端重复订阅， 订阅有效期会默认后一次覆盖前一次时长
  /// 总订阅人数最多3000， 被订阅人数3000，为了性能考虑
  /// 在线状态事件订阅是单向的，双方需要各自订阅
  /// 如果接口整体失败，则返回调用错误码
  /// 如果部分账号失败，则返回失败账号列表
  /// 订阅接口后，有成员在线状态变更会触发回调：onUserStatusChanged
  ///
  /// - Parameters:
  ///   - arguments: 参数
  ///   - resultCallback: 回调
  func subscribeUserStatus(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let optionDic = arguments["option"] as? [String: Any] else {
      parameterError(resultCallback)
      return
    }

    let option = V2NIMSubscribeUserStatusOption.fromDic(optionDic)

    weak var weakSelf = self
    NIMSDK.shared().v2SubscriptionService.subscribeUserStatus(option) { failedList in
      weakSelf?.subscriptionCallback(nil, ["accountIds": failedList], resultCallback)
    } failure: { error in
      weakSelf?.subscriptionCallback(error.nserror, nil, resultCallback)
      FLTALog.errorLog(subscriptionClassName, desc: "subscribeUserStatus error \(error.nserror.localizedDescription)")
    }
  }

  /// 取消用户状态订阅请求
  /// - Parameters:
  ///   - arguments: 参数
  ///   - resultCallback: 回调
  func unsubscribeUserStatus(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let optionDic = arguments["option"] as? [String: Any] else {
      parameterError(resultCallback)
      return
    }

    let option = V2NIMUnsubscribeUserStatusOption.fromDic(optionDic)

    weak var weakSelf = self
    NIMSDK.shared().v2SubscriptionService.unsubscribeUserStatus(option) { failedList in
      weakSelf?.subscriptionCallback(nil, ["accountIds": failedList], resultCallback)
    } failure: { error in
      weakSelf?.subscriptionCallback(error.nserror, nil, resultCallback)
      FLTALog.errorLog(subscriptionClassName, desc: "unsubscribeUserStatus error \(error.nserror.localizedDescription)")
    }
  }

  /// 发布用户自定义状态，如果默认在线状态不满足业务需求，可以发布自定义用户状态
  /// - Parameters:
  ///   - arguments: 参数
  ///   - resultCallback: 回调
  func publishCustomUserStatus(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let params = arguments["params"] as? [String: Any] else {
      parameterError(resultCallback)
      return
    }

    let param = V2NIMCustomUserStatusParams.fromDic(params)

    weak var weakSelf = self
    NIMSDK.shared().v2SubscriptionService.publishCustomUserStatus(param) { result in
      weakSelf?.subscriptionCallback(nil, result.toDic(), resultCallback)
    } failure: { error in
      weakSelf?.subscriptionCallback(error.nserror, nil, resultCallback)
      FLTALog.errorLog(subscriptionClassName, desc: "publishCustomUserStatus error \(error.nserror.localizedDescription)")
    }
  }

  /// 查询用户状态订阅关系
  /// 输入账号列表，查询自己订阅了哪些账号列表， 返回订阅账号列表
  ///
  /// - Parameters:
  ///   - arguments: 参数
  ///     * accountIds 需要查询的账号列表，查询自己是否订阅了对应账号
  ///   - resultCallback: 回调
  func queryUserStatusSubscriptions(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let accountIds = arguments["accountIds"] as? [String] else {
      parameterError(resultCallback)
      return
    }

    weak var weakSelf = self
    NIMSDK.shared().v2SubscriptionService.queryUserStatusSubscriptions(accountIds) { results in
      let resultsDic: [[String: Any]] = results.compactMap { $0.toDic() }
      weakSelf?.subscriptionCallback(nil, ["subscribeResultList": resultsDic], resultCallback)
    } failure: { error in
      weakSelf?.subscriptionCallback(error.nserror, nil, resultCallback)
      FLTALog.errorLog(subscriptionClassName, desc: "queryUserStatusSubscriptions error \(error.nserror.localizedDescription)")
    }
  }

  func onMethodCalled(_ method: String, _ arguments: [String: Any], _ resultCallback: ResultCallback) {
    switch method {
    case V2SubscriptionNameType.subscribeUserStatus.rawValue:
      subscribeUserStatus(arguments, resultCallback)
    case V2SubscriptionNameType.unsubscribeUserStatus.rawValue:
      unsubscribeUserStatus(arguments, resultCallback)
    case V2SubscriptionNameType.publishCustomUserStatus.rawValue:
      publishCustomUserStatus(arguments, resultCallback)
    case V2SubscriptionNameType.queryUserStatusSubscriptions.rawValue:
      queryUserStatusSubscriptions(arguments, resultCallback)
    default:
      resultCallback.notImplemented()
    }
  }
}

// MARK: - V2NIMSubscribeListener

extension FLTSubscriptionService {
  /// 其它用户状态变更，包括在线状态，和自定义状态
  /// 同账号发布时，指定了多端同步的状态
  /// 在线状态默认值为：
  /// 登录：1
  /// 登出：2
  /// 断开连接： 3
  ///
  /// - Parameter data: 用户状态列表
  func onUserStatusChanged(_ data: [V2NIMUserStatus]) {
    let dataDic = data.compactMap { $0.toDic() }
    notifyEvent(serviceName(), "onUserStatusChanged", ["userStatusList": dataDic])
  }
}
