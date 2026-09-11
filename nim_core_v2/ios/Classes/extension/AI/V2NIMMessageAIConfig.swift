// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMMessageAIConfig {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMMessageAIConfig {
    let attach = V2NIMMessageAIConfig()

    if let accountId = arguments["accountId"] as? String {
      attach.accountId = accountId
    }

    if let status = arguments["aiStatus"] as? Int,
       let aiStatus = V2NIMMessageAIStatus(rawValue: status) {
      attach.aiStatus = aiStatus
    }

    if let aiRAGsList = arguments["aiRAGs"] as? [[String: Any]] {
      var aiRAGs = [V2NIMAIRAGInfo]()
      for it in aiRAGsList {
        let aiRAG = V2NIMAIRAGInfo.fromDic(it)
        aiRAGs.append(aiRAG)
      }
      attach.aiRAGs = aiRAGs
    }

    if let aiStream = arguments["aiStream"] as? Bool {
      attach.aiStream = aiStream
    }

    if let aiStreamStatusInt = arguments["aiStreamStatus"] as? Int,
       let aiStreamStatus = V2NIMMessageAIStreamStatus(rawValue: aiStreamStatusInt) {
      attach.aiStreamStatus = aiStreamStatus
    }

    if let aiStreamLastChunkDic = arguments["aiStreamLastChunk"] as? [String: Any] {
      let aiStreamLastChunk = V2NIMMessageAIStreamChunk.fromDic(aiStreamLastChunkDic)
      attach.setValue(aiStreamLastChunk,
                      forKeyPath: #keyPath(V2NIMMessageAIConfig.aiStreamLastChunk))
    }

    return attach
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMMessageAIConfig.accountId)] = accountId
    keyPaths[#keyPath(V2NIMMessageAIConfig.aiStatus)] = aiStatus.rawValue
    keyPaths[#keyPath(V2NIMMessageAIConfig.aiStreamStatus)] = aiStreamStatus.rawValue

    keyPaths[#keyPath(V2NIMMessageAIConfig.aiStream)] = aiStream
    keyPaths[#keyPath(V2NIMMessageAIConfig.aiRAGs)] = aiRAGs?.map { it in it.toDic() }

    keyPaths[#keyPath(V2NIMMessageAIConfig.aiStreamLastChunk)] = aiStreamLastChunk?.toDic()

    return keyPaths
  }
}
