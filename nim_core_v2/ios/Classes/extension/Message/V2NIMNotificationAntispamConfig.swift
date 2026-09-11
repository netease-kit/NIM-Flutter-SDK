// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMNotificationAntispamConfig {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMNotificationAntispamConfig {
    let attach = V2NIMNotificationAntispamConfig()

    if let antispamEnabled = arguments["antispamEnabled"] as? Bool {
      attach.antispamEnabled = antispamEnabled
    }

    if let antispamCustomNotification = arguments["antispamCustomNotification"] as? String {
      attach.antispamCustomNotification = antispamCustomNotification
    }

    return attach
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMNotificationAntispamConfig.antispamEnabled)] = antispamEnabled
    keyPaths[#keyPath(V2NIMNotificationAntispamConfig.antispamCustomNotification)] = antispamCustomNotification
    return keyPaths
  }
}
