// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMMessageAIConfigParams {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMMessageAIConfigParams {
    let attach = V2NIMMessageAIConfigParams()

    if let accountId = arguments["accountId"] as? String {
      attach.accountId = accountId
    }

    if let content = arguments["content"] as? [String: Any] {
      attach.content = V2NIMAIModelCallContent.fromDic(content)
    }

    if let messagesDic = arguments["messages"] as? [[String: Any]] {
      var messages = [V2NIMAIModelCallMessage]()
      for messageDic in messagesDic {
        messages.append(V2NIMAIModelCallMessage.fromDic(messageDic))
      }
      attach.messages = messages
    }

    if let promptVariables = arguments["promptVariables"] as? String {
      attach.promptVariables = promptVariables
    }

    if let modelConfigParams = arguments["modelConfigParams"] as? [String: Any] {
      attach.modelConfigParams = V2NIMAIModelConfigParams.fromDic(modelConfigParams)
    }

    if let aiStream = arguments["aiStream"] as? Bool {
      attach.aiStream = aiStream
    }

    return attach
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMMessageAIConfigParams.accountId)] = accountId
    keyPaths[#keyPath(V2NIMMessageAIConfigParams.content)] = content?.toDic()

    var messagesDic = [[String: Any]]()
    for message in messages ?? [] {
      messagesDic.append(message.toDic())
    }

    keyPaths[#keyPath(V2NIMMessageAIConfigParams.messages)] = messagesDic
    keyPaths[#keyPath(V2NIMMessageAIConfigParams.promptVariables)] = promptVariables
    keyPaths[#keyPath(V2NIMMessageAIConfigParams.modelConfigParams)] = modelConfigParams?.toDic()
    keyPaths[#keyPath(V2NIMMessageAIConfigParams.aiStream)] = aiStream
    return keyPaths
  }
}
