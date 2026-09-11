// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMProxyAIModelCallParams {
  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMProxyAIModelCallParams.accountId)] = accountId
    keyPaths[#keyPath(V2NIMProxyAIModelCallParams.requestId)] = requestId
    keyPaths[#keyPath(V2NIMProxyAIModelCallParams.content)] = content.toDic()
    keyPaths[#keyPath(V2NIMProxyAIModelCallParams.messages)] = messages?.map { $0.toDic() }
    keyPaths[#keyPath(V2NIMProxyAIModelCallParams.promptVariables)] = promptVariables
    keyPaths[#keyPath(V2NIMProxyAIModelCallParams.modelConfigParams)] = modelConfigParams?.toDic()
    keyPaths[#keyPath(V2NIMProxyAIModelCallParams.antispamConfig)] = antispamConfig?.toDic()
    keyPaths[#keyPath(V2NIMProxyAIModelCallParams.aiStream)] = aiStream
    return keyPaths
  }

  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMProxyAIModelCallParams {
    let params = V2NIMProxyAIModelCallParams()
    if let accountId = arguments[#keyPath(V2NIMProxyAIModelCallParams.accountId)] as? String {
      params.accountId = accountId
    }
    if let requestId = arguments[#keyPath(V2NIMProxyAIModelCallParams.requestId)] as? String {
      params.requestId = requestId
    }
    if let promptVariables = arguments[#keyPath(V2NIMProxyAIModelCallParams.promptVariables)] as? String {
      params.promptVariables = promptVariables
    }
    if let contentDic = arguments[#keyPath(V2NIMProxyAIModelCallParams.content)] as? [String: Any] {
      let content = V2NIMAIModelCallContent.fromDic(contentDic)
      params.content = content
    }
    if let messageArray = arguments[#keyPath(V2NIMProxyAIModelCallParams.messages)] as? [[String: Any]] {
      var messages = [V2NIMAIModelCallMessage]()
      for messageDic in messageArray {
        let message = V2NIMAIModelCallMessage.fromDic(messageDic)
        messages.append(message)
      }
      params.messages = messages
    }
    if let modelConfigParamsDic = arguments[#keyPath(V2NIMProxyAIModelCallParams.modelConfigParams)] as? [String: Any] {
      params.modelConfigParams = V2NIMAIModelConfigParams.fromDic(modelConfigParamsDic)
    }
    if let antispamConfigDic = arguments[#keyPath(V2NIMProxyAIModelCallParams.antispamConfig)] as? [String: Any] {
      params.antispamConfig = V2NIMProxyAICallAntispamConfig.fromDic(antispamConfigDic)
    }
    if let aiStream = arguments["aiStream"] as? Bool {
      params.aiStream = aiStream
    }
    return params
  }
}
