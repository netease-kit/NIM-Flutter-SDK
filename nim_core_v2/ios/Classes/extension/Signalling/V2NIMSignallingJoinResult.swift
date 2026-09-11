// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMSignallingJoinResult {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMSignallingJoinResult {
    let result = V2NIMSignallingJoinResult()

    if let roomInfo = arguments["roomInfo"] as? [String: Any] {
      result.setValue(V2NIMSignallingRoomInfo.fromDic(roomInfo), forKeyPath: #keyPath(V2NIMSignallingJoinResult.roomInfo))
    }

    if let rtcInfo = arguments["rtcInfo"] as? [String: Any] {
      result.setValue(V2NIMSignallingRtcInfo.fromDic(rtcInfo), forKeyPath: #keyPath(V2NIMSignallingJoinResult.rtcInfo))
    }

    return result
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(roomInfo)] = roomInfo?.toDic()
    keyPaths[#keyPath(rtcInfo)] = rtcInfo?.toDic()
    return keyPaths
  }
}
