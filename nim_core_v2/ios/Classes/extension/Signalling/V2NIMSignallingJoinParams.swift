// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMSignallingJoinParams {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMSignallingJoinParams {
    let params = V2NIMSignallingJoinParams()

    if let channelId = arguments["channelId"] as? String {
      params.channelId = channelId
    }

    if let serverExtension = arguments["serverExtension"] as? String {
      params.serverExtension = serverExtension
    }

    if let signallingConfig = arguments["signallingConfig"] as? [String: Any] {
      params.signallingConfig = V2NIMSignallingConfig.fromDic(signallingConfig)
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
    keyPaths[#keyPath(channelId)] = channelId
    keyPaths[#keyPath(serverExtension)] = serverExtension
    keyPaths[#keyPath(signallingConfig)] = signallingConfig?.toDic()
    keyPaths[#keyPath(rtcConfig)] = rtcConfig?.toDic()
    return keyPaths
  }
}
