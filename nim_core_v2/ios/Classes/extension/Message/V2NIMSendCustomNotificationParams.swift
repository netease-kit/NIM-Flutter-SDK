// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMSendCustomNotificationParams {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMSendCustomNotificationParams {
    let attach = V2NIMSendCustomNotificationParams()

    if let notificationConfig = arguments["notificationConfig"] as? [String: Any] {
      attach.notificationConfig = V2NIMNotificationConfig.fromDic(notificationConfig)
    }

    if let pushConfig = arguments["pushConfig"] as? [String: Any] {
      attach.pushConfig = V2NIMNotificationPushConfig.fromDic(pushConfig)
    }

    if let antispamConfig = arguments["antispamConfig"] as? [String: Any] {
      attach.antispamConfig = V2NIMNotificationAntispamConfig.fromDic(antispamConfig)
    }

    if let routeConfig = arguments["routeConfig"] as? [String: Any] {
      attach.routeConfig = V2NIMNotificationRouteConfig.fromDic(routeConfig)
    }

    return attach
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMSendCustomNotificationParams.notificationConfig)] = notificationConfig.toDic()
    keyPaths[#keyPath(V2NIMSendCustomNotificationParams.pushConfig)] = pushConfig.toDic()
    keyPaths[#keyPath(V2NIMSendCustomNotificationParams.antispamConfig)] = antispamConfig.toDic()
    keyPaths[#keyPath(V2NIMSendCustomNotificationParams.routeConfig)] = routeConfig.toDic()
    return keyPaths
  }
}
