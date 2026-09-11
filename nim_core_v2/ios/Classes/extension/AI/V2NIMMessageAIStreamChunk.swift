// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMMessageAIStreamChunk {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMMessageAIStreamChunk {
    let attach = V2NIMMessageAIStreamChunk()

    if let content = arguments["content"] as? String {
      attach.content = content
    }

    if let messageTime = arguments["messageTime"] as? Int {
      attach.messageTime = TimeInterval(messageTime / 1000)
    }

    if let chunkTime = arguments["chunkTime"] as? Int {
      attach.chunkTime = TimeInterval(chunkTime / 1000)
    }

    if let type = arguments["type"] as? Int {
      attach.type = type
    }

    if let index = arguments["index"] as? Int {
      attach.index = index
    }

    return attach
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMMessageAIStreamChunk.content)] = content
    keyPaths[#keyPath(V2NIMMessageAIStreamChunk.messageTime)] = messageTime * 1000
    keyPaths[#keyPath(V2NIMMessageAIStreamChunk.chunkTime)] = chunkTime * 1000
    keyPaths[#keyPath(V2NIMMessageAIStreamChunk.type)] = type
    keyPaths[#keyPath(V2NIMMessageAIStreamChunk.index)] = index
    return keyPaths
  }
}
