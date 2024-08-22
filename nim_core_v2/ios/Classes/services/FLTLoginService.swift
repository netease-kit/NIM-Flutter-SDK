// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import Foundation
import NIMSDK

@objc
public protocol NEIMKitClientListener: NSObjectProtocol {
  @objc optional func onDataSync(_ type: V2NIMDataSyncType, state: V2NIMDataSyncState, error: V2NIMError?)
  /// 登录连接状态回调
  /// - Parameter status: 连接状态
  @objc optional func onConnectStatus(_ status: V2NIMConnectStatus)

  ///  连接失败回调
  ///  - Parameter error: 错误信息
  @objc optional func onConnectFailed(_ error: V2NIMError?)

  /// 断开连接回调
  /// - Parameter error: 错误信息
  @objc optional func onDisconnected(_ error: V2NIMError?)

  ///  登录状态变更回调
  ///  - Parameter status: 登录状态
  @objc optional func onLoginStatus(_ status: V2NIMLoginStatus)

  /// 登录失败回调
  /// - Parameter error: 错误信息
  @objc optional func onLoginFailed(_ error: V2NIMError)

  /// 被踢下线回调
  /// - Parameter detail: 被踢下线的详细信息
  @objc optional func onKickedOffline(_ detail: V2NIMKickedOfflineDetail)

  /// 登录客户端变更回调
  /// - Parameter change: 多端登录变动事件
  /// - Parameter clients: 登录客户端信息
  @objc optional func onLoginClientChanged(_ change: V2NIMLoginClientChange, clients: [V2NIMLoginClient]?)
}

@objc protocol IMKitClientDetailListenerManagerListener: NSObjectProtocol {
  /// 数据同步回调
  /// - Parameter type: 数据同步类型
  /// - Parameter state: 同步状态
  /// - Parameter error： 错误信息
  @objc optional func onDataSync(_ type: V2NIMDataSyncType, state: V2NIMDataSyncState, error: V2NIMError?)

  /// 登录连接状态回调
  /// - Parameter status: 连接状态
  @objc optional func onConnectStatus(_ status: V2NIMConnectStatus)

  ///  连接失败回调
  ///  - Parameter error: 错误信息
  @objc optional func onConnectFailed(_ error: V2NIMError?)

  /// 断开连接回调
  /// - Parameter error: 错误信息
  @objc optional func onDisconnected(_ error: V2NIMError?)
}

class IMKitClientDetailListenerManager: NSObject, V2NIMLoginDetailListener {
  public static let instance = IMKitClientDetailListenerManager()
  weak var delegate: IMKitClientDetailListenerManagerListener?
  override private init() {
    super.init()
    NIMSDK.shared().v2LoginService.add(self)
  }

  deinit {
    NIMSDK.shared().v2LoginService.remove(self)
  }

  ///  数据完成同步完成回调
  ///  - Parameter type: 数据同步类型
  ///  - Parameter state: 数据同步状态
  ///  - Parameter error: 错误信息
  public func onDataSync(_ type: V2NIMDataSyncType, state: V2NIMDataSyncState, error: V2NIMError?) {
    delegate?.onDataSync?(type, state: state, error: error)
  }

  /// 登录连接状态回调
  /// - Parameter status: 连接状态
  public func onConnectStatus(_ status: V2NIMConnectStatus) {
    delegate?.onConnectStatus?(status)
  }

  ///  连接失败回调
  ///  - Parameter error: 错误信息
  public func onConnectFailed(_ error: V2NIMError?) {
    delegate?.onConnectFailed?(error)
  }

  /// 断开连接回调
  /// - Parameter error: 错误信息
  public func onDisconnected(_ error: V2NIMError?) {
    delegate?.onDisconnected?(error)
  }
}

class FLTLoginService: FLTBaseService, FLTService, V2NIMLoginListener, V2NIMTokenProvider, V2NIMLoginExtensionProvider, V2NIMReconnectDelayProvider, IMKitClientDetailListenerManagerListener {
  func onLoginStatus(_ status: V2NIMLoginStatus) {
    notifyEvent(serviceName(), "onLoginStatus", ["status": status.rawValue])
  }

  func onLoginFailed(_ error: V2NIMError) {
    notifyEvent(serviceName(), "onLoginFailed", error.toDictionary())
  }

  func onKickedOffline(_ detail: V2NIMKickedOfflineDetail) {
    notifyEvent(serviceName(), "onKickedOffline", detail.toDictionary())
  }

  func onLoginClientChanged(_ change: V2NIMLoginClientChange, clients: [V2NIMLoginClient]?) {
    notifyEvent(serviceName(), "onLoginClientChanged", ["change": change.rawValue,
                                                        "clients": clients?.map { client in
                                                          client.toDictionary()
                                                        }])
  }

  func onConnectFailed(_ error: V2NIMError?) {
    notifyEvent(serviceName(), "onConnectFailed", error?.toDictionary())
  }

  func onConnectStatus(_ status: V2NIMConnectStatus) {
    notifyEvent(serviceName(), "onConnectStatus", ["status": status.rawValue])
  }

  func onDisconnected(_ error: V2NIMError?) {
    notifyEvent(serviceName(), "onDisconnected", error?.toDictionary())
  }

  func onDataSync(_ type: V2NIMDataSyncType, state: V2NIMDataSyncState, error: V2NIMError?) {
    notifyEvent(serviceName(), "onDataSync", ["type": type.rawValue, "state": state.rawValue, "error": error?.toDictionary()])
  }

  func getReconnectDelay(_ delay: Int32) -> Int32 {
    let semaphore = DispatchSemaphore(value: 0)
    var customDelay = -1
    notifyEvent(
      serviceName(),
      "getReconnectDelay",
      ["delay": Int(delay) as Any],
      result: { r in
        if let value = r as? NSNumber {
          customDelay = value.intValue
        }
        semaphore.signal()
      }
    )
//    let timeout = DispatchTime.now() + .seconds(30)
    semaphore.wait()
    print("getReconnectDelay ", Int32(customDelay))
    return Int32(customDelay)
  }

  func getLoginExtension(_ accountId: String) -> String? {
    if !accountId.isEmpty {
      let semaphore = DispatchSemaphore(value: 0)
      var logExtension = ""
      notifyEvent(
        serviceName(),
        "getLoginExtension",
        ["accountId": accountId as Any],
        result: { r in
          logExtension = r as? String ?? ""
          semaphore.signal()
        }
      )
      semaphore.wait()
      print("getLoginExtension ", logExtension)
      return logExtension
    }
    return nil
  }

  func getToken(_ accountId: String) -> String? {
    if !accountId.isEmpty {
      let semaphore = DispatchSemaphore(value: 0)
      var token = ""
      notifyEvent(
        serviceName(),
        "getToken",
        ["accountId": accountId as Any],
        result: { r in
          token = r as? String ?? ""
          semaphore.signal()
        }
      )
      semaphore.wait()
      return token
    }
    return nil
  }

  private let paramErrorTip = "param Error"
  private let paramErrorCode = 199_414

  private func loginCallback(_ error: Error?, _ data: Any?, _ resultCallback: ResultCallback) {
    if let ns_error = error as NSError? {
      errorCallBack(resultCallback, ns_error.description, ns_error.code)
    } else {
      successCallBack(resultCallback, data)
    }
  }

  private var dynamicLoginTokens = [String: String]()

  override func onInitialized() {
    IMKitClientDetailListenerManager.instance.delegate = self
    NIMSDK.shared().v2LoginService.add(self)
  }

  deinit {
    NIMSDK.shared().v2LoginService.remove(self)
  }

  func serviceName() -> String {
    ServiceType.LoginService.rawValue
  }

  func onMethodCalled(_ method: String, _ arguments: [String: Any],
                      _ resultCallback: ResultCallback) {
    switch method {
    case "login":
      login(arguments, resultCallback)
    case "logout":
      logout(arguments, resultCallback)
    case "getLoginUser":
      getLoginUser(arguments, resultCallback)
    case "getLoginStatus":
      getLoginStatus(arguments, resultCallback)
    case "kickOffline":
      kickOffline(arguments, resultCallback)
    case "getKickedOfflineDetail":
      getKickedOfflineDetail(arguments, resultCallback)
    case "getConnectStatus":
      getConnectStatus(arguments, resultCallback)
    case "getDataSync":
      getDataSync(arguments, resultCallback)
    case "getChatroomLinkAddress":
      getChatroomLinkAddress(arguments, resultCallback)
    case "setReconnectDelayProvider":
      setReconnectDelayProvider(arguments, resultCallback)
    case "getLoginClients":
      getLoginClients(arguments, resultCallback)
    default:
      resultCallback.notImplemented()
    }
  }

  func register(_ nimCore: NimCore) {
    self.nimCore = nimCore
    nimCore.addService(self)
  }

  private func login(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let account = arguments["accountId"] as? String, let token = arguments["token"] as? String else {
      errorCallBack(resultCallback, paramErrorTip, paramErrorCode)
      return
    }

    DLog(s: "login argument : \(arguments)")
    var loginOption = V2NIMLoginOption()
    if let optionDic = arguments["option"] as? [String: Any?] {
      loginOption = V2NIMLoginOption.fromDic(optionDic)
    }

    loginOption.tokenProvider = self
    loginOption.loginExtensionProvider = self

    weak var weakSelf = self
    // 登录
    NIMSDK.shared().v2LoginService.login(account, token: token, option: loginOption) {
      weakSelf?.loginCallback(nil, nil, resultCallback)
    } failure: { error in
      weakSelf?.loginCallback(error.nserror, nil, resultCallback)
    }
  }

  private func logout(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    weak var weakSelf = self
    NIMSDK.shared().v2LoginService.logout {
      weakSelf?.loginCallback(nil, nil, resultCallback)
    } failure: { error in
      weakSelf?.loginCallback(error.nserror, nil, resultCallback)
    }
  }

  private func getLoginUser(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    let user = NIMSDK.shared().v2LoginService.getLoginUser()
    successCallBack(resultCallback, user)
  }

  private func getLoginStatus(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    let status = NIMSDK.shared().v2LoginService.getLoginStatus()
    successCallBack(resultCallback, ["status": status.rawValue])
  }

  private func kickOffline(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let clientDic = arguments["client"] as? [String: Any?] else {
      errorCallBack(resultCallback, paramErrorTip, paramErrorCode)
      return
    }
    let client = V2NIMLoginClient.fromDic(clientDic)
    weak var weakSelf = self
    NIMSDK.shared().v2LoginService.kickOffline(client) {
      weakSelf?.loginCallback(nil, nil, resultCallback)
    } failure: { error in
      weakSelf?.loginCallback(error.nserror, nil, resultCallback)
    }
  }

  private func getKickedOfflineDetail(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    let detail = NIMSDK.shared().v2LoginService.getKickedOfflineDetail()
    successCallBack(resultCallback, detail?.toDictionary())
  }

  private func getConnectStatus(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    let status = NIMSDK.shared().v2LoginService.getConnectStatus()
    successCallBack(resultCallback, ["status": status.rawValue])
  }

  private func getDataSync(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    let dataSync = NIMSDK.shared().v2LoginService.getDataSync()
    var list = [[String: Any?]]()
    dataSync?.forEach { detail in
      list.append(detail.toDictionary())
    }
    successCallBack(resultCallback,
                    ["dataSync": list])
  }

  private func getLoginClients(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    let loginClients = NIMSDK.shared().v2LoginService.getLoginClients()
    var list = [[String: Any?]]()
    loginClients?.forEach { client in
      list.append(client.toDictionary())
    }
    successCallBack(resultCallback, ["loginClient": list])
  }

  private func getChatroomLinkAddress(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let roomId = arguments["roomId"] as? String else {
      errorCallBack(resultCallback, paramErrorTip, paramErrorCode)
      return
    }
    weak var weakSelf = self
    NIMSDK.shared().v2LoginService.getChatroomLinkAddress(roomId) { address in
      weakSelf?.loginCallback(nil, address, resultCallback)
    } failure: { error in
      weakSelf?.loginCallback(error.nserror, nil, resultCallback)
    }
  }

  private func setReconnectDelayProvider(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
//   NIMSDK.shared().v2LoginService.setReconnectDelayProvider(self)
    successCallBack(resultCallback, nil)
  }
}
