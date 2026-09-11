// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMSignallingRtcConfig {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMSignallingRtcConfig {
    let config = V2NIMSignallingRtcConfig()

    if let rtcChannelName = arguments["rtcChannelName"] as? String {
      config.rtcChannelName = rtcChannelName
    }

    if let rtcTokenTtl = arguments["rtcTokenTtl"] as? Int {
      config.rtcTokenTtl = rtcTokenTtl
    }

    if let rtcParams = arguments["rtcParams"] as? String {
      config.rtcParams = rtcParams
    }

    return config
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMSignallingRtcConfig.rtcChannelName)] = rtcChannelName
    keyPaths[#keyPath(V2NIMSignallingRtcConfig.rtcTokenTtl)] = rtcTokenTtl
    keyPaths[#keyPath(V2NIMSignallingRtcConfig.rtcParams)] = rtcParams
    return keyPaths
  }
}
