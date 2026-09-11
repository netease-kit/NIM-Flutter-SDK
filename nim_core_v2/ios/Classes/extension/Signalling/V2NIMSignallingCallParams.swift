// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMSignallingCallParams {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMSignallingCallParams {
    let params = V2NIMSignallingCallParams()

    if let calleeAccountId = arguments["calleeAccountId"] as? String {
      params.calleeAccountId = calleeAccountId
    }

    if let requestId = arguments["requestId"] as? String {
      params.requestId = requestId
    }

    if let channelType = arguments["channelType"] as? Int,
       let channelType = V2NIMSignallingChannelType(rawValue: channelType) {
      params.channelType = channelType
    }

    if let channelName = arguments["channelName"] as? String {
      params.channelName = channelName
    }

    if let channelExtension = arguments["channelExtension"] as? String {
      params.channelExtension = channelExtension
    }

    if let serverExtension = arguments["serverExtension"] as? String {
      params.serverExtension = serverExtension
    }

    if let signallingConfig = arguments["signallingConfig"] as? [String: Any] {
      params.signallingConfig = V2NIMSignallingConfig.fromDic(signallingConfig)
    }

    if let pushConfig = arguments["pushConfig"] as? [String: Any] {
      params.pushConfig = V2NIMSignallingPushConfig.fromDic(pushConfig)
    }

    if let rtcConfig = arguments["rtcConfig"] as? [String: Any] {
      params.rtcConfig = V2NIMSignallingRtcConfig.fromDic(rtcConfig)
    }

    return params
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(calleeAccountId)] = calleeAccountId
    keyPaths[#keyPath(requestId)] = requestId
    keyPaths[#keyPath(channelType)] = channelType.rawValue
    keyPaths[#keyPath(channelName)] = channelName
    keyPaths[#keyPath(channelExtension)] = channelExtension
    keyPaths[#keyPath(serverExtension)] = serverExtension
    keyPaths[#keyPath(signallingConfig)] = signallingConfig?.toDic()
    keyPaths[#keyPath(pushConfig)] = pushConfig?.toDic()
    keyPaths[#keyPath(rtcConfig)] = rtcConfig?.toDic()
    return keyPaths
  }
}
