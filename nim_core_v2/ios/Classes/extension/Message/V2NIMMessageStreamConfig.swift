// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMMessageStreamConfig {
  static func fromDic(_ arguments: [String: Any]) -> V2NIMMessageStreamConfig {
    let config = V2NIMMessageStreamConfig()

    if let statusValue = arguments["status"] as? Int,
       let status = V2NIMMessageStreamStatus(rawValue: statusValue) {
      config.setValue(status.rawValue, forKeyPath: #keyPath(V2NIMMessageStreamConfig.status))
    }

    if let lastChunkDict = arguments["lastChunk"] as? [String: Any] {
      config.setValue(V2NIMMessageStreamChunk.fromDic(lastChunkDict),
                      forKeyPath: #keyPath(V2NIMMessageStreamConfig.lastChunk))
    }

    if let ragsList = arguments["rags"] as? [[String: Any]] {
      config.setValue(ragsList.map { V2NIMAIRAGInfo.fromDic($0) },
                      forKeyPath: #keyPath(V2NIMMessageStreamConfig.rags))
    }

    return config
  }

  func toDic() -> [String: Any] {
    var dict: [String: Any] = [:]
    dict[#keyPath(V2NIMMessageStreamConfig.status)] = status.rawValue
    if let lastChunk = lastChunk {
      dict[#keyPath(V2NIMMessageStreamConfig.lastChunk)] = lastChunk.toDic()
    }
    if let rags = rags {
      dict[#keyPath(V2NIMMessageStreamConfig.rags)] = rags.map { $0.toDic() }
    }
    return dict
  }
}

extension V2NIMMessageStreamChunk {
  static func fromDic(_ arguments: [String: Any]) -> V2NIMMessageStreamChunk {
    let chunk = V2NIMMessageStreamChunk()

    if let content = arguments["content"] as? String {
      chunk.content = content
    }

    if let messageTime = arguments["messageTime"] as? Int {
      chunk.messageTime = TimeInterval(messageTime / 1000)
    }

    if let chunkTime = arguments["chunkTime"] as? Int {
      chunk.chunkTime = TimeInterval(chunkTime / 1000)
    }

    if let type = arguments["type"] as? Int {
      chunk.type = type
    }

    if let index = arguments["index"] as? Int {
      chunk.index = index
    }

    return chunk
  }

  func toDic() -> [String: Any] {
    var dict: [String: Any] = [:]
    dict[#keyPath(V2NIMMessageStreamChunk.content)] = content
    dict[#keyPath(V2NIMMessageStreamChunk.messageTime)] = Int(messageTime * 1000)
    dict[#keyPath(V2NIMMessageStreamChunk.chunkTime)] = Int(chunkTime * 1000)
    dict[#keyPath(V2NIMMessageStreamChunk.type)] = type
    dict[#keyPath(V2NIMMessageStreamChunk.index)] = index
    return dict
  }
}
