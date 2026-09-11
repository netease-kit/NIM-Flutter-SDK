// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMSignallingRtcInfo {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMSignallingRtcInfo {
    let info = V2NIMSignallingRtcInfo()

    if let rtcToken = arguments["rtcToken"] as? String {
      info.rtcToken = rtcToken
    }

    if let rtcTokenTtl = arguments["rtcTokenTtl"] as? Int {
      info.rtcTokenTtl = rtcTokenTtl
    }

    if let rtcParams = arguments["rtcParams"] as? String {
      info.rtcParams = rtcParams
    }

    return info
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMSignallingRtcInfo.rtcToken)] = rtcToken
    keyPaths[#keyPath(V2NIMSignallingRtcInfo.rtcTokenTtl)] = rtcTokenTtl
    keyPaths[#keyPath(V2NIMSignallingRtcInfo.rtcParams)] = rtcParams
    return keyPaths
  }
}
