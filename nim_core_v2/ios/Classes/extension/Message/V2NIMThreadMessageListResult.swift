// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMThreadMessageListResult {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMThreadMessageListResult {
    let attach = V2NIMThreadMessageListResult()

    if let message = arguments["message"] as? [String: Any] {
      attach.setValue(V2NIMMessage.fromDict(message),
                      forKeyPath: #keyPath(V2NIMThreadMessageListResult.message))
    }

    if let timestamp = arguments["timestamp"] as? Double {
      attach.setValue(TimeInterval(timestamp / 1000),
                      forKeyPath: #keyPath(V2NIMThreadMessageListResult.timestamp))
    }

    if let replyCount = arguments["replyCount"] as? Int {
      attach.setValue(replyCount,
                      forKeyPath: #keyPath(V2NIMThreadMessageListResult.replyCount))
    }

    if let replyListDic = arguments["replyList"] as? [[String: Any]] {
      var replyList = [V2NIMMessage]()
      for replyDic in replyListDic {
        replyList.append(V2NIMMessage.fromDict(replyDic))
      }

      attach.setValue(replyList,
                      forKeyPath: #keyPath(V2NIMThreadMessageListResult.replyList))
    }

    return attach
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMThreadMessageListResult.message)] = message.toDict()
    keyPaths[#keyPath(V2NIMThreadMessageListResult.timestamp)] = timestamp * 1000
    keyPaths[#keyPath(V2NIMThreadMessageListResult.replyCount)] = replyCount

    var replyListDic = [[String: Any]]()
    for reply in replyList {
      replyListDic.append(reply.toDict())
    }
    keyPaths[#keyPath(V2NIMThreadMessageListResult.replyList)] = replyListDic
    return keyPaths
  }
}
