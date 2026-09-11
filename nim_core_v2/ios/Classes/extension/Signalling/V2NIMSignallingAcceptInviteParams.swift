// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMSignallingAcceptInviteParams {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMSignallingAcceptInviteParams {
    let params = V2NIMSignallingAcceptInviteParams()

    if let channelId = arguments["channelId"] as? String {
      params.channelId = channelId
    }

    if let inviterAccountId = arguments["inviterAccountId"] as? String {
      params.inviterAccountId = inviterAccountId
    }

    if let requestId = arguments["requestId"] as? String {
      params.requestId = requestId
    }

    if let serverExtension = arguments["serverExtension"] as? String {
      params.serverExtension = serverExtension
    }

    if let offlineEnabled = arguments["offlineEnabled"] as? Bool {
      params.offlineEnabled = offlineEnabled
    }

    return params
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(channelId)] = channelId
    keyPaths[#keyPath(inviterAccountId)] = inviterAccountId
    keyPaths[#keyPath(requestId)] = requestId
    keyPaths[#keyPath(serverExtension)] = serverExtension
    keyPaths[#keyPath(offlineEnabled)] = offlineEnabled
    return keyPaths
  }
}
