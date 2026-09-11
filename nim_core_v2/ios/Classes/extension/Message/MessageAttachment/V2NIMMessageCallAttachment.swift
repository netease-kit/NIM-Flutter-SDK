// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMMessageCallAttachment {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDict(_ arguments: [String: Any]) -> V2NIMMessageCallAttachment {
    let superAttach = super.fromDic(arguments)
    let attach = V2NIMMessageCallAttachment()
    attach.raw = superAttach.raw

    if let type = arguments["type"] as? Int {
      attach.type = type
    }

    if let channelId = arguments["channelId"] as? String {
      attach.channelId = channelId
    }

    if let status = arguments["status"] as? Int {
      attach.status = status
    }

    if let durationsMap = arguments["durations"] as? [[String: Any]] {
      var durations = [V2NIMMessageCallDuration]()
      for durationMap in durationsMap {
        let duration = V2NIMMessageCallDuration()
        if let dur = durationMap["duration"] as? Int {
          duration.duration = dur
        }

        if let accountId = durationMap["accountId"] as? String {
          duration.accountId = accountId
        }

        durations.append(duration)
      }
      attach.durations = durations
    }

    return attach
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  override public func toDic() -> [String: Any] {
    var keyPaths = super.toDic()
    keyPaths[nimCoreMessageType] = V2NIMMessageType.MESSAGE_TYPE_CALL.rawValue
    keyPaths[#keyPath(V2NIMMessageCallAttachment.type)] = type
    keyPaths[#keyPath(V2NIMMessageCallAttachment.channelId)] = channelId
    keyPaths[#keyPath(V2NIMMessageCallAttachment.status)] = status

    var durationDic = [[String: Any]]()
    for duration in durations {
      durationDic.append(duration.toDic())
    }

    keyPaths[#keyPath(V2NIMMessageCallAttachment.durations)] = durationDic
    return keyPaths
  }
}
