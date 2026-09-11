// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMMessagePinNotification {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMMessagePinNotification {
    let attach = V2NIMMessagePinNotification()

    if let pin = arguments["pin"] as? [String: Any] {
      attach.setValue(V2NIMMessagePin.fromDic(pin),
                      forKeyPath: #keyPath(V2NIMMessagePinNotification.pin))
    }

    if let state = arguments["pinState"] as? UInt,
       let pinState = V2NIMMessagePinState(rawValue: state) {
      attach.setValue(pinState.rawValue,
                      forKeyPath: #keyPath(V2NIMMessagePinNotification.pinState))
    }

    return attach
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMMessagePinNotification.pin)] = pin?.toDic()
    keyPaths[#keyPath(V2NIMMessagePinNotification.pinState)] = pinState.rawValue
    return keyPaths
  }
}
