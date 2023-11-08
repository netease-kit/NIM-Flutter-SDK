// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import Foundation
import NIMSDK

enum AuthType: String {
  case AuthLogin = "login"
  case AuthLogout = "logout"
  case KickOutOtherOnlineClient = "kickOutOtherOnlineClient"
}

class FLTAuthService: FLTBaseService, FLTService {
//    override init() {
//        super.init()
//        NIMSDK.shared().loginManager.add(self)
//    }

  private var dynamicLoginTokens = [String: String]()

  override func onInitialized() {
    NIMSDK.shared().loginManager.add(self)
  }

  deinit {
    NIMSDK.shared().loginManager.remove(self)
  }

  func serviceName() -> String {
    ServiceType.AuthService.rawValue
  }

  func onMethodCalled(_ method: String, _ arguments: [String: Any],
                      _ resultCallback: ResultCallback) {
    switch method {
    case AuthType.AuthLogin.rawValue:
      login(arguments, resultCallback)
    case AuthType.AuthLogout.rawValue:
      logout(arguments, resultCallback)
    case AuthType.KickOutOtherOnlineClient.rawValue:
      kickOutOtherOnlineClient(arguments, resultCallback)
    default:
      resultCallback.notImplemented()
    }
  }

  func register(_ nimCore: NimCore) {
    self.nimCore = nimCore
    nimCore.addService(self)
  }

  private func login(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    if let account = arguments["account"] as? String, let token = arguments["token"] as? String,
       let authType = arguments["authType"] as? Int {
      let loginExt = arguments["loginExt"] as? String ?? ""

      DLog(s: "login argument : \(arguments)")

      // 动态登录
      if authType == 1 {
        if token.isEmpty {
          resultCallback
            .result(NimResult.error(-1, "dynamic login with empty token").toDic())
          return
        }
        dynamicLoginTokens[account] = token
      }

      weak var weakSelf = self
      NIMSDK.shared().loginManager
        .login(account, token: token, authType: Int32(authType),
               loginExt: loginExt) { error in
          if let ns_error = error as NSError? {
            weakSelf?.DLog(s: "iOS login failed")
            resultCallback
              .result(NimResult.error(ns_error.code, ns_error.description).toDic())
            weakSelf?.loginStatus(ns_error.code)
          } else {
            weakSelf?.DLog(s: "iOS login success")
            resultCallback.result(NimResult.success().toDic())
          }
        }
    }
  }

  private func logout(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    NIMSDK.shared().loginManager.logout { error in
      if error == nil {
        resultCallback.result(NimResult.success(nil).toDic())
      } else {
        resultCallback.result(NimResult.error(error.debugDescription).toDic())
      }
    }
  }

  private func kickOutOtherOnlineClient(_ arguments: [String: Any],
                                        _ resultCallback: ResultCallback) {
    if let client = NIMLoginClient.fromDic(arguments) as? NIMLoginClient {
      if let cls = NIMSDK.shared().loginManager.currentLoginClients() {
        var kickClient: NIMLoginClient?
        for cl in cls {
          if cl.timestamp == client.timestamp,
             cl.os == client.os, cl.type == client.type, cl.customTag == client.customTag {
            kickClient = cl
          }
        }
        if kickClient != nil {
          NIMSDK.shared().loginManager.kickOtherClient(kickClient!) { error in
            if let ns_error = error as NSError? {
              resultCallback
                .result(NimResult.error(ns_error.code, ns_error.description).toDic())
            } else {
              resultCallback.result(NimResult.success().toDic())
            }
          }
        } else {
          resultCallback.result(NimResult.error("nim login client find error").toDic())
        }
      }
    } else {
      resultCallback.result(NimResult.error("nim login client create error").toDic())
    }
  }

  func loginStatus(_ code: Int) {
    // 参考
    // https://g.hz.netease.com/meeting/nim-sdk-flutter/-/blob/null_safety.1/ios/Classes/Section/Login/Model/NIMFLoginUntil.m
    switch code {
    case 302:
      notifyEvent(serviceName(), "onAuthStatusChanged", ["status": "pwdError"])
    case 422:
      notifyEvent(serviceName(), "onAuthStatusChanged", ["status": "forbidden"])
    case 201:
      notifyEvent(serviceName(), "onAuthStatusChanged", ["status": "pwdError"])
    case 417:
      notifyEvent(serviceName(), "onAuthStatusChanged", ["status": "kickOut"])
    default:
      break
    }
  }
}

extension FLTAuthService: NIMLoginManagerDelegate {
  // 参考
  // https://g.hz.netease.com/meeting/nim-sdk-flutter/-/blob/null_safety.1/ios/Classes/Section/Login/Service/NIMFLoginObserver.m
  func onLogin(_ step: NIMLoginStep) {
    var status = "unknown"
    switch step {
    case .linking:
      status = "connecting"
    case .linkOK:
      status = "logging"
    case .linkFailed:
      status = "unLogin"
    case .logining:
      status = "logging"
    case .loginOK:
      status = "loggedIn"
    case .loginFailed:
      status = "unLogin"
    case .syncing:
      status = "dataSyncStart"
    case .syncOK:
      status = "dataSyncFinish"
    case .loseConnection:
      status = "netBroken"
    case .netChanged:
      status = "netBroken"
    default:
      break
    }
    notifyEvent(serviceName(), "onAuthStatusChanged", ["status": status])
  }

  func onAutoLoginFailed(_ error: Error) {
    loginStatus((error as NSError).code)
  }

  func onKickout(_ result: NIMLoginKickoutResult) {
    if result.reasonCode == .byClient || result.reasonCode == .byClientManually {
      notifyEvent(
        serviceName(),
        "onAuthStatusChanged",
        [
          "status": "kickOutByOtherClient",
          "clientType": result.clientType.rawValue,
          "customClientType": result.customClientType,
        ]
      )
    } else if result.reasonCode == .byServer {
      notifyEvent(serviceName(), "onAuthStatusChanged", ["status": "forbidden"])
    } else {
      notifyEvent(
        serviceName(),
        "onAuthStatusChanged",
        [
          "status": "kickOut",
          "clientType": result.clientType.rawValue,
          "customClientType": result.customClientType,
        ]
      )
    }
  }

  func onMultiLoginClientsChanged() {}

  func onTeamUsersSyncFinished(_ success: Bool) {}

  func onSuperTeamUsersSyncFinished(_ success: Bool) {}

  func onMultiLoginClientsChanged(with type: NIMMultiLoginType) {
    let clients = NIMSDK.shared().loginManager.currentLoginClients()
    let ret = clients?.map { client in
      client.toDic()
    }
    notifyEvent(serviceName(), "onOnlineClientsUpdated", ["clients": ret as Any])
  }

  func provideDynamicToken(forAccount account: String) -> String {
    if account != nil, !account.isEmpty {
      let semaphore = DispatchSemaphore(value: 0)
      var token = ""
      notifyEvent(
        serviceName(),
        "getDynamicToken",
        ["account": account as Any],
        result: { r in
          token = r as? String ?? ""
          semaphore.signal()
        }
      )
      semaphore.wait()
      return token
    }
    return dynamicLoginTokens[account] ?? ""
  }
}
