// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import Foundation
import NIMSDK

enum QChatMethod: String {
  case login
  case logout
  case kickOtherClients
}

class FLTQChatService: FLTBaseService, FLTService {
  var loginAction: (() -> Void)?

  private let paramErrorTip = "参数错误"
  private let paramErrorCode = 414

  override func onInitialized() {
    NIMSDK.shared().qchatManager.add(self)
  }

  deinit {
    NIMSDK.shared().qchatManager.remove(self)
  }

  func serviceName() -> String {
    ServiceType.QChatService.rawValue
  }

  func onMethodCalled(_ method: String, _ arguments: [String: Any],
                      _ resultCallback: ResultCallback) {
    switch method {
    case QChatMethod.login.rawValue:
      login(arguments, resultCallback)
    case QChatMethod.logout.rawValue:
      logout(arguments, resultCallback)
    case QChatMethod.kickOtherClients.rawValue:
      kickOtherClients(arguments, resultCallback)
    default:
      resultCallback.notImplemented()
    }
  }

  func register(_ nimCore: NimCore) {
    self.nimCore = nimCore
    nimCore.addService(self)
  }

  func qChatCallback(_ error: Error?, _ data: Any?, _ resultCallback: ResultCallback) {
    if let ns_error = error as NSError? {
      errorCallBack(resultCallback, ns_error.description, ns_error.code)
    } else {
      successCallBack(resultCallback, data)
    }
  }

  func login(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    let param = NIMQChatLoginParam()
    NIMSDK.shared().qchatManager.login(param) { error, info in
      self.loginAction = {
        var result = [String: Any]()
        var array = [Any]()
        if let clientArray = NIMSDK.shared().qchatManager.currentLoginClients() {
          for client in clientArray {
            if var map = client.toDic() {
              map["deviceId"] = client.value(forKeyPath: "deviceId")
              array.append(map)
            }
          }
        }
        result["otherClients"] = array
        self.qChatCallback(error, result, resultCallback)
      }
    }
  }

  func logout(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    NIMSDK.shared().qchatManager.logout { error in
      self.qChatCallback(error, nil, resultCallback)
    }
  }

  func kickOtherClients(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let deviceIds = arguments["deviceIds"] as? [String] else {
      print("kickOtherClients parameter error, deviceIds is nil")
      errorCallBack(resultCallback, paramErrorTip, paramErrorCode)
      return
    }
    guard let clientArray = NIMSDK.shared().qchatManager.currentLoginClients() else {
      print("kickOtherClients there are no other clients")
      errorCallBack(resultCallback, paramErrorTip, paramErrorCode)
      return
    }

    var successDeviceIdArray = [String]()
    var count = clientArray.count
    for client in clientArray {
      if let deviceIdFromClient = client.value(forKeyPath: "deviceId") as? String {
        if deviceIds.contains(deviceIdFromClient) {
          NIMSDK.shared().qchatManager.kickOtherClient(client) { error in
            count = count - 1
            if error == nil {
              successDeviceIdArray.append(deviceIdFromClient)
            }
            if count <= 0 {
              self.qChatCallback(
                error,
                ["clientIds": successDeviceIdArray],
                resultCallback
              )
              return
            }
          }
        } else {
          count = count - 1
        }
      } else {
        count = count - 1
      }
    }
    if count <= 0 {
      qChatCallback(nil, ["clientIds": successDeviceIdArray], resultCallback)
    }
  }
}

extension FLTQChatService: NIMQChatManagerDelegate {
  func qchatOnlineStatus(_ result: NIMQChatOnlineStatusResult) {
    if let loginInvokeAction = loginAction {
      loginInvokeAction()
      loginAction = nil
    }
  }
}
