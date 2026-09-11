// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMSignallingEvent {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMSignallingEvent {
    let event = V2NIMSignallingEvent()

    if let eventType = arguments["eventType"] as? Int,
       let eventType = V2NIMSignallingEventType(rawValue: eventType) {
      event.setValue(eventType.rawValue, forKeyPath: #keyPath(V2NIMSignallingEvent.eventType))
    }

    if let channelInfo = arguments["channelInfo"] as? [String: Any] {
      event.setValue(V2NIMSignallingChannelInfo.fromDic(channelInfo), forKeyPath: #keyPath(V2NIMSignallingEvent.channelInfo))
    }

    if let operatorAccountId = arguments["operatorAccountId"] as? String {
      event.setValue(operatorAccountId, forKeyPath: #keyPath(V2NIMSignallingEvent.operatorAccountId))
    }

    if let serverExtension = arguments["serverExtension"] as? String {
      event.setValue(serverExtension, forKeyPath: #keyPath(V2NIMSignallingEvent.serverExtension))
    }

    if let time = arguments["time"] as? Int {
      event.setValue(time / 1000, forKeyPath: #keyPath(V2NIMSignallingEvent.time))
    }

    if let inviteeAccountId = arguments["inviteeAccountId"] as? String {
      event.setValue(inviteeAccountId, forKeyPath: #keyPath(V2NIMSignallingEvent.inviteeAccountId))
    }

    if let inviterAccountId = arguments["inviterAccountId"] as? String {
      event.setValue(inviterAccountId, forKeyPath: #keyPath(V2NIMSignallingEvent.inviterAccountId))
    }

    if let requestId = arguments["requestId"] as? String {
      event.setValue(requestId, forKeyPath: #keyPath(V2NIMSignallingEvent.requestId))
    }

    if let pushConfig = arguments["pushConfig"] as? [String: Any] {
      event.setValue(V2NIMSignallingPushConfig.fromDic(pushConfig), forKeyPath: #keyPath(V2NIMSignallingEvent.pushConfig))
    }

    return event
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMSignallingEvent.eventType)] = eventType.rawValue
    keyPaths[#keyPath(V2NIMSignallingEvent.channelInfo)] = channelInfo.toDic()
    keyPaths[#keyPath(V2NIMSignallingEvent.operatorAccountId)] = operatorAccountId
    keyPaths[#keyPath(V2NIMSignallingEvent.serverExtension)] = serverExtension
    keyPaths[#keyPath(V2NIMSignallingEvent.time)] = time * 1000
    keyPaths[#keyPath(V2NIMSignallingEvent.inviteeAccountId)] = inviteeAccountId
    keyPaths[#keyPath(V2NIMSignallingEvent.inviterAccountId)] = inviterAccountId
    keyPaths[#keyPath(V2NIMSignallingEvent.requestId)] = requestId
    keyPaths[#keyPath(V2NIMSignallingEvent.pushConfig)] = pushConfig?.toDic()
    keyPaths[#keyPath(V2NIMSignallingEvent.unreadEnabled)] = unreadEnabled
    keyPaths[#keyPath(V2NIMSignallingEvent.member)] = member?.toDic()
    return keyPaths
  }
}
