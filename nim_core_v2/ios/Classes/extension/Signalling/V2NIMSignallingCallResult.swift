// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMSignallingCallResult {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMSignallingCallResult {
    let result = V2NIMSignallingCallResult()

    if let callStatus = arguments["callStatus"] as? Int {
      result.setValue(callStatus, forKeyPath: #keyPath(V2NIMSignallingCallResult.callStatus))
    }

    if let roomInfo = arguments["roomInfo"] as? [String: Any] {
      result.setValue(V2NIMSignallingRoomInfo.fromDic(roomInfo), forKeyPath: #keyPath(V2NIMSignallingCallResult.roomInfo))
    }

    if let rtcInfo = arguments["rtcInfo"] as? [String: Any] {
      result.setValue(V2NIMSignallingRtcInfo.fromDic(rtcInfo), forKeyPath: #keyPath(V2NIMSignallingCallResult.rtcInfo))
    }

    return result
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMSignallingCallResult.callStatus)] = callStatus
    keyPaths[#keyPath(V2NIMSignallingCallResult.roomInfo)] = roomInfo.toDic()
    keyPaths[#keyPath(V2NIMSignallingCallResult.rtcInfo)] = rtcInfo?.toDic()
    return keyPaths
  }
}
