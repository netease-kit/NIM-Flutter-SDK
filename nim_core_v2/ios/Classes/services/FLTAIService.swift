// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import UIKit
import NIMSDK

enum AIServieMethodType: String {
  case getAIUserList
  case proxyAIModelCall
}

class FLTAIService: FLTBaseService, FLTService, V2NIMAIListener {
  override func onInitialized() {
    NIMSDK.shared().v2AIService.add(self)
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
    let params = V2NIMProxyAIModelCallParams.fromDictionary(paramsDic)
    NIMSDK.shared().v2AIService.proxyAIModelCall(params) {
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

  func register(_ nimCore: NimCore) {
    self.nimCore = nimCore
    nimCore.addService(self)
  }

  func onProxyAIModelCall(_ data: V2NIMAIModelCallResult) {
    notifyEvent(serviceName(), "onProxyAIModelCall", data.toDictionary())
  }
}

extension V2NIMAIModelCallContent {
  func toDictionary() -> [String: Any] {
    var dict = [String: Any]()
    dict[#keyPath(V2NIMAIModelCallContent.msg)] = msg
    dict[#keyPath(V2NIMAIModelCallContent.type)] = type.rawValue
    return dict
  }

  static func fromDictionary(_ dict: [String: Any]) -> V2NIMAIModelCallContent {
    let content = V2NIMAIModelCallContent()
    if let msg = dict[#keyPath(V2NIMAIModelCallContent.msg)] as? String {
      content.msg = msg
    }
    if let typeInt = dict[#keyPath(V2NIMAIModelCallContent.type)] as? Int, let type = V2NIMAIModelCallContentType(rawValue: typeInt) {
      content.type = type
    }
    return content
  }
}

extension V2NIMAIModelCallResult {
  func toDictionary() -> [String: Any] {
    var dict = [String: Any]()
    dict[#keyPath(V2NIMAIModelCallResult.accountId)] = accountId
    dict[#keyPath(V2NIMAIModelCallResult.requestId)] = requestId
    dict[#keyPath(V2NIMAIModelCallResult.content)] = content.toDictionary()
    dict[#keyPath(V2NIMAIModelCallResult.code)] = code
    return dict
  }

  static func fromDictionary(_ dict: [String: Any]) -> V2NIMAIModelCallResult {
    let result = V2NIMAIModelCallResult()
    if let accountId = dict[#keyPath(V2NIMAIModelCallResult.accountId)] as? String {
      result.accountId = accountId
    }
    if let requestId = dict[#keyPath(V2NIMAIModelCallResult.requestId)] as? String {
      result.requestId = requestId
    }
    if let contentDict = dict[#keyPath(V2NIMAIModelCallResult.content)] as? [String: Any] {
      result.content = V2NIMAIModelCallContent.fromDictionary(contentDict)
    }
    if let code = dict[#keyPath(V2NIMAIModelCallResult.code)] as? Int {
      result.code = code
    }
    return result
  }
}

extension V2NIMAIUser {
  func toDic() -> [String: Any] {
    var dict = [String: Any]()
    dict[#keyPath(V2NIMAIUser.gender)] = gender
    dict[#keyPath(V2NIMAIUser.createTime)] = createTime * 1000
    dict[#keyPath(V2NIMAIUser.updateTime)] = updateTime * 1000

    if let accountIdValue = accountId, accountIdValue.count > 0 {
      dict[#keyPath(V2NIMAIUser.accountId)] = accountIdValue
    } else {
      dict[#keyPath(V2NIMAIUser.accountId)] = ""
    }
    if let nameValue = name, nameValue.count > 0 {
      dict[#keyPath(V2NIMAIUser.name)] = nameValue
    } else {
      dict[#keyPath(V2NIMAIUser.name)] = ""
    }
    if let avatarValue = avatar, avatarValue.count > 0 {
      dict[#keyPath(V2NIMAIUser.avatar)] = avatarValue
    } else {
      dict[#keyPath(V2NIMAIUser.avatar)] = ""
    }
    if let signValue = sign, signValue.count > 0 {
      dict[#keyPath(V2NIMAIUser.sign)] = signValue
    } else {
      dict[#keyPath(V2NIMAIUser.sign)] = ""
    }
    if let emailValue = email, emailValue.count > 0 {
      dict[#keyPath(V2NIMAIUser.email)] = emailValue
    } else {
      dict[#keyPath(V2NIMAIUser.email)] = ""
    }
    if let birthdayValue = birthday, birthdayValue.count > 0 {
      dict[#keyPath(V2NIMAIUser.birthday)] = birthdayValue
    } else {
      dict[#keyPath(V2NIMAIUser.birthday)] = ""
    }
    if let mobileValue = mobile, mobileValue.count > 0 {
      dict[#keyPath(V2NIMAIUser.mobile)] = mobileValue
    } else {
      dict[#keyPath(V2NIMAIUser.mobile)] = ""
    }
    if let serverExtensionValue = serverExtension, serverExtensionValue.count > 0 {
      dict[#keyPath(V2NIMAIUser.serverExtension)] = serverExtensionValue
    } else {
      dict[#keyPath(V2NIMAIUser.serverExtension)] = ""
    }

    dict[#keyPath(V2NIMAIUser.modelType)] = modelType.rawValue

    if let modelConfigValue = modelConfig?.toDictionary() {
      dict[#keyPath(V2NIMAIUser.modelConfig)] = modelConfigValue
    }

    return dict
  }

  static func fromDic(_ dict: [String: Any]) -> V2NIMAIUser {
    let user = V2NIMAIUser()

    if let modelTypeInt = dict[#keyPath(V2NIMAIUser.modelType)] as? Int, let modelType = V2NIMAIModelType(rawValue: modelTypeInt) {
      user.modelType = modelType
    }
    if let modelConfigDic = dict[#keyPath(V2NIMAIUser.modelConfig)] as? [String: Any] {
      user.modelConfig = V2NIMAIModelConfig.fromDictionary(modelConfigDic)
    }
    if let accountId = dict[#keyPath(V2NIMAIUser.accountId)] as? String {
      user.accountId = accountId
    }
    if let name = dict[#keyPath(V2NIMAIUser.name)] as? String {
      user.name = name
    }
    if let avatar = dict[#keyPath(V2NIMAIUser.avatar)] as? String {
      user.avatar = avatar
    }
    if let sign = dict[#keyPath(V2NIMAIUser.sign)] as? String {
      user.sign = sign
    }
    if let email = dict[#keyPath(V2NIMAIUser.email)] as? String {
      user.email = email
    }
    if let birthday = dict[#keyPath(V2NIMAIUser.birthday)] as? String {
      user.birthday = birthday
    }
    if let mobile = dict[#keyPath(V2NIMAIUser.mobile)] as? String {
      user.mobile = mobile
    }
    if let gender = dict[#keyPath(V2NIMAIUser.gender)] as? Int {
      user.gender = gender
    }
    if let serverExtension = dict[#keyPath(V2NIMAIUser.serverExtension)] as? String {
      user.serverExtension = serverExtension
    }
    if let createTime = dict[#keyPath(V2NIMAIUser.createTime)] as? Double {
      user.createTime = createTime / 1000
    }
    if let updateTime = dict[#keyPath(V2NIMAIUser.updateTime)] as? Double {
      user.updateTime = updateTime / 1000
    }
    return user
  }
}

extension V2NIMAIModelConfig {
  func toDictionary() -> [String: Any] {
    var dict = [String: Any]()
    dict[#keyPath(V2NIMAIModelConfig.model)] = model
    dict[#keyPath(V2NIMAIModelConfig.prompt)] = prompt
    dict[#keyPath(V2NIMAIModelConfig.promptKeys)] = promptKeys
    dict[#keyPath(V2NIMAIModelConfig.maxTokens)] = maxTokens
    dict[#keyPath(V2NIMAIModelConfig.temperature)] = temperature
    dict[#keyPath(V2NIMAIModelConfig.topP)] = topP
    return dict
  }

  static func fromDictionary(_ dict: [String: Any]) -> V2NIMAIModelConfig {
    var config = V2NIMAIModelConfig()
    if let model = dict[#keyPath(V2NIMAIModelConfig.model)] as? String {
      config.model = model
    }
    if let prompt = dict[#keyPath(V2NIMAIModelConfig.prompt)] as? String {
      config.prompt = prompt
    }
    if let promptKeys = dict[#keyPath(V2NIMAIModelConfig.promptKeys)] as? [String] {
      config.promptKeys = promptKeys
    }
    if let maxTokens = dict[#keyPath(V2NIMAIModelConfig.maxTokens)] as? Int {
      config.maxTokens = maxTokens
    }
    if let temperature = dict[#keyPath(V2NIMAIModelConfig.temperature)] as? CGFloat {
      config.temperature = temperature
    }
    if let topP = dict[#keyPath(V2NIMAIModelConfig.topP)] as? CGFloat {
      config.topP = topP
    }
    return config
  }
}

extension V2NIMAIModelCallMessage {
  func toDictionary() -> [String: Any] {
    var dict = [String: Any]()
    dict[#keyPath(V2NIMAIModelCallMessage.role)] = role.rawValue
    dict[#keyPath(V2NIMAIModelCallMessage.msg)] = msg
    dict[#keyPath(V2NIMAIModelCallMessage.type)] = type.rawValue
    return dict
  }

  static func fromDictionary(_ dict: [String: Any]) -> V2NIMAIModelCallMessage {
    let callMessage = V2NIMAIModelCallMessage()
    if let roleType = dict[#keyPath(V2NIMAIModelCallMessage.role)] as? Int, let role = V2NIMAIModelRoleType(rawValue: roleType) {
      callMessage.role = role
    }
    if let msg = dict[#keyPath(V2NIMAIModelCallMessage.msg)] as? String {
      callMessage.msg = msg
    }
    if let typeInt = dict[#keyPath(V2NIMAIModelCallMessage.type)] as? Int, let type = V2NIMAIModelCallContentType(rawValue: typeInt) {
      callMessage.type = type
    }
    return callMessage
  }
}

extension V2NIMProxyAIModelCallParams {
  func toDictionary() -> [String: Any] {
    var dict = [String: Any]()
    dict[#keyPath(V2NIMProxyAIModelCallParams.accountId)] = accountId
    dict[#keyPath(V2NIMProxyAIModelCallParams.requestId)] = requestId
    dict[#keyPath(V2NIMProxyAIModelCallParams.content)] = content.toDictionary()
    if let msgs = messages {
      var messageArray = [[String: Any]]()
      msgs.forEach { message in
        messageArray.append(message.toDictionary())
      }
      dict[#keyPath(V2NIMProxyAIModelCallParams.messages)] = messageArray
    }
    dict[#keyPath(V2NIMProxyAIModelCallParams.promptVariables)] = promptVariables
    if let modelConfigParamsValue = modelConfigParams?.toDictionary() {
      dict[#keyPath(V2NIMProxyAIModelCallParams.modelConfigParams)] = modelConfigParamsValue
    }
    if let antispamConfigValue = antispamConfig?.toDictionary() {
      dict[#keyPath(V2NIMProxyAIModelCallParams.antispamConfig)] = antispamConfigValue
    }
    return dict
  }

  static func fromDictionary(_ dict: [String: Any]) -> V2NIMProxyAIModelCallParams {
    let params = V2NIMProxyAIModelCallParams()
    if let accountId = dict[#keyPath(V2NIMProxyAIModelCallParams.accountId)] as? String {
      params.accountId = accountId
    }
    if let requestId = dict[#keyPath(V2NIMProxyAIModelCallParams.requestId)] as? String {
      params.requestId = requestId
    }
    if let contentDic = dict[#keyPath(V2NIMProxyAIModelCallParams.content)] as? [String: Any] {
      let content = V2NIMAIModelCallContent.fromDic(contentDic)
      params.content = content
    }
    if let messageArray = dict[#keyPath(V2NIMProxyAIModelCallParams.messages)] as? [[String: Any]] {
      var messages = [V2NIMAIModelCallMessage]()
      messageArray.forEach { messageDic in
        let message = V2NIMAIModelCallMessage.fromDictionary(messageDic)
        messages.append(message)
      }
      params.messages = messages
    }
    if let modelConfigParamsDic = dict[#keyPath(V2NIMProxyAIModelCallParams.modelConfigParams)] as? [String: Any] {
      params.modelConfigParams = V2NIMAIModelConfigParams.fromDcitionary(modelConfigParamsDic)
    }
    if let antispamConfigDic = dict[#keyPath(V2NIMProxyAIModelCallParams.antispamConfig)] as? [String: Any] {
      params.antispamConfig = V2NIMProxyAICallAntispamConfig.fromDcitionary(antispamConfigDic)
    }
    return params
  }
}

extension V2NIMProxyAICallAntispamConfig {
  func toDictionary() -> [String: Any] {
    var dict = [String: Any]()
    dict[#keyPath(V2NIMProxyAICallAntispamConfig.antispamBusinessId)] = antispamBusinessId
    dict[#keyPath(V2NIMProxyAICallAntispamConfig.antispamEnabled)] = antispamEnabled
    return dict
  }

  static func fromDcitionary(_ dict: [String: Any]) -> V2NIMProxyAICallAntispamConfig {
    let config = V2NIMProxyAICallAntispamConfig()
    if let antispamEnabled = dict[#keyPath(V2NIMProxyAICallAntispamConfig.antispamEnabled)] as? Bool {
      config.antispamEnabled = antispamEnabled
    }
    if let antispamBusinessId = dict[#keyPath(V2NIMProxyAICallAntispamConfig.antispamBusinessId)] as? String {
      config.antispamBusinessId = antispamBusinessId
    }
    return config
  }
}

extension V2NIMAIModelConfigParams {
  static func fromDcitionary(_ dict: [String: Any]) -> V2NIMAIModelConfigParams {
    let attach = V2NIMAIModelConfigParams()

    if let prompt = dict[#keyPath(V2NIMAIModelConfigParams.prompt)] as? String {
      attach.prompt = prompt
    }

    if let maxTokens = dict[#keyPath(V2NIMAIModelConfigParams.maxTokens)] as? Int {
      attach.maxTokens = maxTokens
    }

    if let topP = dict[#keyPath(V2NIMAIModelConfigParams.topP)] as? CGFloat {
      attach.topP = topP
    }

    if let temperature = dict[#keyPath(V2NIMAIModelConfigParams.temperature)] as? CGFloat {
      attach.temperature = temperature
    }

    return attach
  }

  func toDictionary() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMAIModelConfigParams.prompt)] = prompt
    keyPaths[#keyPath(V2NIMAIModelConfigParams.maxTokens)] = maxTokens
    keyPaths[#keyPath(V2NIMAIModelConfigParams.topP)] = topP
    keyPaths[#keyPath(V2NIMAIModelConfigParams.temperature)] = temperature
    return keyPaths
  }
}
