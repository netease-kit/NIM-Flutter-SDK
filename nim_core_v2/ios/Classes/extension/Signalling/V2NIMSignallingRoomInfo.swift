// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMSignallingRoomInfo {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMSignallingRoomInfo {
    let info = V2NIMSignallingRoomInfo()

    if let channelInfo = arguments["channelInfo"] as? [String: Any] {
      info.setValue(V2NIMSignallingChannelInfo.fromDic(channelInfo), forKeyPath: #keyPath(V2NIMSignallingRoomInfo.channelInfo))
    }

    if let members = arguments["members"] as? [[String: Any]] {
      let members = members.map { V2NIMSignallingMember.fromDic($0) }
      info.setValue(members, forKeyPath: #keyPath(V2NIMSignallingRoomInfo.members))
    }

    return info
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMSignallingRoomInfo.channelInfo)] = channelInfo.toDic()

    var memberList = [[String: Any]]()
    for member in members {
      memberList.append(member.toDic())
    }
    keyPaths[#keyPath(V2NIMSignallingRoomInfo.members)] = memberList
    return keyPaths
  }
}
