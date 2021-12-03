/*
 * Copyright (c) 2021 NetEase, Inc.  All rights reserved.
 * Use of this source code is governed by a MIT license that can be
 * found in the LICENSE file.
 */

import Foundation
import NIMSDK

enum AuthType: String {
    case AuthLogin  = "login"
    case AuthLogout = "logout"
    case KickOutOtherOnlineClient = "kickOutOtherOnlineClient"
}

class FLTAuthService: FLTBaseService, FLTService {
    
//    override init() {
//        super.init()
//        NIMSDK.shared().loginManager.add(self)
//    }
    
    private var dynamicLoginTokens = [String : String]()
    
    override func onInitialized() {
        NIMSDK.shared().loginManager.add(self)
    }
    
    deinit {
        NIMSDK.shared().loginManager.remove(self)
    }
    
    func serviceName() -> String {
        ServiceType.AuthService.rawValue
    }
    
    func onMethodCalled(_ method: String, _ arguments: [String : Any], _ resultCallback: ResultCallback) {
        switch method {
        case AuthType.AuthLogin.rawValue:
            login(arguments, resultCallback)
            break
        case AuthType.AuthLogout.rawValue:
            logout(arguments, resultCallback)
            break
        default:
            resultCallback.notImplemented()
            break
        }
    }
    
    func register(_ nimCore: NimCore) {
        self.nimCore = nimCore
        nimCore.addService(self)
    }
    
    private func login(_ arguments: [String : Any], _ resultCallback: ResultCallback) {
        if let account = arguments["account"] as? String, let token = arguments["token"] as? String, let authType = arguments["authType"] as? Int {
            let loginExt = arguments["loginExt"] as? String ?? ""
            
            DLog(s: "login argument : \(arguments)")
            
            // 动态登录
            if authType == 1 {
                if token.isEmpty {
                    resultCallback.result(NimResult.error(-1, "dynamic login with empty token").toDic())
                    return
                }
                dynamicLoginTokens[account] = token
            }
            
            weak var weakSelf = self
            NIMSDK.shared().loginManager.login(account, token: token, authType: Int32(authType), loginExt: loginExt) { error in
                if let ns_error = error as NSError? {
                    weakSelf?.DLog(s: "iOS login failed")
                    resultCallback.result(NimResult.error(ns_error.code, ns_error.description).toDic())
                    weakSelf?.loginStatus(ns_error.code)
                }else {
                    weakSelf?.DLog(s: "iOS login success")
                    resultCallback.result(NimResult.success().toDic())
                }
            }
        }
    }
    
    private func logout(_ arguments: [String : Any], _ resultCallback: ResultCallback){
        NIMSDK.shared().loginManager.logout { error in
            if nil == error {
                resultCallback.result(NimResult.success(nil).toDic())
            }else {
                resultCallback.result(NimResult.error(error.debugDescription).toDic())
            }
        }
    }
    
    private func kickOutOtherOnlineClient(_ arguments: [String : Any], _ resultCallback: ResultCallback){
        if let client = NIMLoginClient.fromDic(arguments) as? NIMLoginClient {
            
            NIMSDK.shared().loginManager.kickOtherClient(client) { error in
                if let ns_error = error as NSError? {
                    resultCallback.result(NimResult.error(ns_error.code, ns_error.description).toDic())
                }else {
                    resultCallback.result(NimResult.success().toDic())
                }
            }
        }else {
            resultCallback.result(NimResult.error("nim login client create error").toDic())
        }
        
    }
    func loginStatus(_ code: Int) {
        // 参考 https://g.hz.netease.com/meeting/nim-sdk-flutter/-/blob/null_safety.1/ios/Classes/Section/Login/Model/NIMFLoginUntil.m
        switch code {
        case 302:
            notifyEvent(serviceName(), "onAuthStatusChanged", ["status": "pwdError"])
            break
        case 422:
            notifyEvent(serviceName(), "onAuthStatusChanged", ["status": "forbidden"])
            break
        case 201:
            notifyEvent(serviceName(), "onAuthStatusChanged", ["status": "pwdError"])
            break
        default:
            break
        }
    }
    
}

extension FLTAuthService: NIMLoginManagerDelegate {
    
    // 参考 https://g.hz.netease.com/meeting/nim-sdk-flutter/-/blob/null_safety.1/ios/Classes/Section/Login/Service/NIMFLoginObserver.m
    func onLogin(_ step: NIMLoginStep) {
        var status = "unknown"
        switch step {
        case .linking:
            status = "connecting"
            break
        case .linkOK:
            status = "logging"
            break
        case .linkFailed:
            status = "unLogin"
            break
        case .logining:
            status = "logging"
            break
        case .loginOK:
            status = "loggedIn"
            break
        case .loginFailed:
            status = "unLogin"
            break
        case .syncing:
            status = "dataSyncStart"
            break
        case .syncOK:
            status = "dataSyncFinish"
            break
        case .loseConnection:
            status = "netBroken"
            break
        case .netChanged:
            status = "netBroken"
            break
        default:
            break
        }
        notifyEvent(serviceName(), "onAuthStatusChanged", ["status":status])
    }
    
    func onAutoLoginFailed(_ error: Error) {
        loginStatus((error as NSError).code)
    }
    
    func onKickout(_ result: NIMLoginKickoutResult) {
        if result.reasonCode == .byClient || result.reasonCode == .byClientManually {
            notifyEvent(serviceName(), "onAuthStatusChanged", ["status":"kickOutByOtherClient", "clientType":result.clientType.rawValue, "customClientType": result.customClientType])
        }else {
            notifyEvent(serviceName(), "onAuthStatusChanged", ["status":"kickOut", "clientType":result.clientType.rawValue, "customClientType": result.customClientType])
        }
    }
    
    func onMultiLoginClientsChanged() {
        
    }
    
    func onTeamUsersSyncFinished(_ success: Bool) {
        
    }
    
    func onSuperTeamUsersSyncFinished(_ success: Bool) {
        
    }
    
    func onMultiLoginClientsChanged(with type: NIMMultiLoginType) {
        let clients = NIMSDK.shared().loginManager.currentLoginClients()
        let ret = clients?.map({ client in
            client.toDic()
        })
        notifyEvent(serviceName(), "onOnlineClientsUpdated", ["clients": ret as Any])
    }
    
    func provideDynamicToken(forAccount account: String) -> String {
        if account != nil && !account.isEmpty {
            let semaphore = DispatchSemaphore(value: 0)
            var token = ""
            self.notifyEvent(self.serviceName(), "getDynamicToken", ["account": account as Any], result: { r in
                token = r as? String ?? ""
                semaphore.signal()
            })
            semaphore.wait()
            return token
        }
        return (dynamicLoginTokens[account] ?? "")
    }
}
