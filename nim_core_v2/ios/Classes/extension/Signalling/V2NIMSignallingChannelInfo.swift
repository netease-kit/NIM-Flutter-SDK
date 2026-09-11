// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMSignallingChannelInfo {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMSignallingChannelInfo {
    let info = V2NIMSignallingChannelInfo()

    if let channelName = arguments["channelName"] as? String {
      info.setValue(channelName, forKeyPath: #keyPath(V2NIMSignallingChannelInfo.channelName))
    }

    if let channelId = arguments["channelId"] as? String {
      info.setValue(channelId, forKeyPath: #keyPath(V2NIMSignallingChannelInfo.channelId))
    }

    return info
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMSignallingChannelInfo.channelName)] = channelName
    keyPaths[#keyPath(V2NIMSignallingChannelInfo.channelId)] = channelId
    keyPaths[#keyPath(V2NIMSignallingChannelInfo.channelType)] = channelType.rawValue
    keyPaths[#keyPath(V2NIMSignallingChannelInfo.channelExtension)] = channelExtension
    keyPaths[#keyPath(V2NIMSignallingChannelInfo.createTime)] = createTime * 1000
    keyPaths[#keyPath(V2NIMSignallingChannelInfo.expireTime)] = expireTime * 1000
    keyPaths[#keyPath(V2NIMSignallingChannelInfo.creatorAccountId)] = creatorAccountId
    return keyPaths
  }
}
