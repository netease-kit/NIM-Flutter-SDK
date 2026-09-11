// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK
import UIKit

enum AIServieMethodType: String {
  case getAIUserList
  case proxyAIModelCall
  case stopAIModelStreamCall
  case createUserAIBot
  case deleteUserAIBot
  case updateUserAIBot
  case getUserAIBot
  case getUserAIBotList
  case bindUserAIBotToQrCode
  case refreshUserAIBotToken
}

class FLTAIService: FLTBaseService, FLTService, V2NIMAIListener {
  override func onInitialized() {
    NIMSDK.shared().v2AIService.add(self)
  }

  deinit {
    NIMSDK.shared().v2AIService.remove(self)
  }

  func serviceName() -> String {
    ServiceType.AIService.rawValue
  }

  func onMethodCalled(_ method: String, _ arguments: [String: Any], _ resultCallback: ResultCallback) {
    switch method {
    case AIServieMethodType.getAIUserList.rawValue:
      getAIUserList(arguments, resultCallback)
    case AIServieMethodType.proxyAIModelCall.rawValue:
      proxyAIModelCall(arguments, resultCallback)
    case AIServieMethodType.stopAIModelStreamCall.rawValue:
      stopAIModelStreamCall(arguments, resultCallback)
    case AIServieMethodType.createUserAIBot.rawValue:
      createUserAIBot(arguments, resultCallback)
    case AIServieMethodType.deleteUserAIBot.rawValue:
      deleteUserAIBot(arguments, resultCallback)
    case AIServieMethodType.updateUserAIBot.rawValue:
      updateUserAIBot(arguments, resultCallback)
    case AIServieMethodType.getUserAIBot.rawValue:
      getUserAIBot(arguments, resultCallback)
    case AIServieMethodType.getUserAIBotList.rawValue:
      getUserAIBotList(arguments, resultCallback)
    case AIServieMethodType.bindUserAIBotToQrCode.rawValue:
      bindUserAIBotToQrCode(arguments, resultCallback)
    case AIServieMethodType.refreshUserAIBotToken.rawValue:
      refreshUserAIBotToken(arguments, resultCallback)
    default:
      resultCallback.notImplemented()
    }
  }

  func proxyAIModelCall(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let paramsDic = arguments["params"] as? [String: Any] else {
      parameterError(resultCallback)
      return
    }
    weak var weakSelf = self
    let params = V2NIMProxyAIModelCallParams.fromDic(paramsDic)
    NIMSDK.shared().v2AIService.proxyAIModelCall(params) {
      weakSelf?.successCallBack(resultCallback, nil)
    } failure: { error in
      weakSelf?.errorCallBack(resultCallback, error.nserror.localizedDescription, Int(error.code))
    }
  }

  func stopAIModelStreamCall(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let paramsDic = arguments["params"] as? [String: Any] else {
      parameterError(resultCallback)
      return
    }
    weak var weakSelf = self
    let params = V2NIMAIModelStreamCallStopParams.fromDic(paramsDic)
    NIMSDK.shared().v2AIService.stopAIModelStreamCall(params) {
      weakSelf?.successCallBack(resultCallback, nil)
    } failure: { error in
      weakSelf?.errorCallBack(resultCallback, error.nserror.localizedDescription, Int(error.code))
    }
  }

  func getAIUserList(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    weak var weakSelf = self
    NIMSDK.shared().v2AIService.getAIUserList { aiUsers in
      var userList = [[String: Any]]()
      aiUsers?.forEach { aiUser in
        userList.append(aiUser.toDic())
      }
      weakSelf?.successCallBack(resultCallback, ["userList": userList])
    } failure: { error in
      weakSelf?.errorCallBack(resultCallback, error.nserror.localizedDescription, Int(error.code))
    }
  }

  func createUserAIBot(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let paramsDic = arguments["params"] as? [String: Any] else {
      parameterError(resultCallback)
      return
    }
    weak var weakSelf = self
    let params = V2NIMCreateUserAIBotParams.fromDic(paramsDic)
    NIMSDK.shared().v2AIService.createUserAIBot(params) { result in
      weakSelf?.successCallBack(resultCallback, result?.toDic())
    } failure: { error in
      weakSelf?.errorCallBack(resultCallback, error.nserror.localizedDescription, Int(error.code))
    }
  }

  func deleteUserAIBot(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let paramsDic = arguments["params"] as? [String: Any] else {
      parameterError(resultCallback)
      return
    }
    weak var weakSelf = self
    let params = V2NIMDeleteUserAIBotParams.fromDic(paramsDic)
    NIMSDK.shared().v2AIService.deleteUserAIBot(params) {
      weakSelf?.successCallBack(resultCallback, nil)
    } failure: { error in
      weakSelf?.errorCallBack(resultCallback, error.nserror.localizedDescription, Int(error.code))
    }
  }

  func updateUserAIBot(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let paramsDic = arguments["params"] as? [String: Any] else {
      parameterError(resultCallback)
      return
    }
    weak var weakSelf = self
    let params = V2NIMUpdateUserAIBotParams.fromDic(paramsDic)
    NIMSDK.shared().v2AIService.updateUserAIBot(params) {
      weakSelf?.successCallBack(resultCallback, nil)
    } failure: { error in
      weakSelf?.errorCallBack(resultCallback, error.nserror.localizedDescription, Int(error.code))
    }
  }

  func getUserAIBot(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let paramsDic = arguments["params"] as? [String: Any] else {
      parameterError(resultCallback)
      return
    }
    weak var weakSelf = self
    let params = V2NIMGetUserAIBotParams.fromDic(paramsDic)
    NIMSDK.shared().v2AIService.getUserAIBot(params) { result in
      weakSelf?.successCallBack(resultCallback, result?.toDic())
    } failure: { error in
      weakSelf?.errorCallBack(resultCallback, error.nserror.localizedDescription, Int(error.code))
    }
  }

  func getUserAIBotList(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    let params = (arguments["params"] as? [String: Any]).map {
      V2NIMGetUserAIBotListParams.fromDic($0)
    }
    weak var weakSelf = self
    NIMSDK.shared().v2AIService.getUserAIBotList(params) { result in
      weakSelf?.successCallBack(resultCallback, result?.toDic())
    } failure: { error in
      weakSelf?.errorCallBack(resultCallback, error.nserror.localizedDescription, Int(error.code))
    }
  }

  func bindUserAIBotToQrCode(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let paramsDic = arguments["params"] as? [String: Any] else {
      parameterError(resultCallback)
      return
    }
    weak var weakSelf = self
    let params = V2NIMBindUserAIBotToQrCodeParams.fromDic(paramsDic)
    NIMSDK.shared().v2AIService.bindUserAIBot(toQrCode: params) {
      weakSelf?.successCallBack(resultCallback, nil)
    } failure: { error in
      weakSelf?.errorCallBack(resultCallback, error.nserror.localizedDescription, Int(error.code))
    }
  }

  func refreshUserAIBotToken(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let paramsDic = arguments["params"] as? [String: Any] else {
      parameterError(resultCallback)
      return
    }
    weak var weakSelf = self
    let params = V2NIMRefreshUserAIBotTokenParams.fromDic(paramsDic)
    NIMSDK.shared().v2AIService.refreshUserAIBotToken(params) { result in
      weakSelf?.successCallBack(resultCallback, result?.toDic())
    } failure: { error in
      weakSelf?.errorCallBack(resultCallback, error.nserror.localizedDescription, Int(error.code))
    }
  }

  func register(_ nimCore: NimCore) {
    self.nimCore = nimCore
    nimCore.addService(self)
  }

  func onProxyAIModelCall(_ data: V2NIMAIModelCallResult) {
    notifyEvent(serviceName(), "onProxyAIModelCall", data.toDic())
  }

  func onProxyAIModelStreamCall(_ data: V2NIMAIModelStreamCallResult) {
    notifyEvent(serviceName(), "onProxyAIModelStreamCall", data.toDic())
  }
}
