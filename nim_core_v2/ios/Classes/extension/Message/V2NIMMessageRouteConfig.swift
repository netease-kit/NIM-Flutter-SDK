// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMMessageRouteConfig {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMMessageRouteConfig {
    let attach = V2NIMMessageRouteConfig()

    if let routeEnabled = arguments["routeEnabled"] as? Bool {
      attach.routeEnabled = routeEnabled
    }

    if let routeEnvironment = arguments["routeEnvironment"] as? String {
      attach.routeEnvironment = routeEnvironment
    }

    return attach
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMMessageRouteConfig.routeEnabled)] = routeEnabled
    keyPaths[#keyPath(V2NIMMessageRouteConfig.routeEnvironment)] = routeEnvironment
    return keyPaths
  }
}
