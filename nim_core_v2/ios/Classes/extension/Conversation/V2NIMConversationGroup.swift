// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMConversationGroup {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMConversationGroup {
    let group = V2NIMConversationGroup()

    if let groupId = arguments["groupId"] as? String {
      group.setValue(groupId,
                     forKeyPath: #keyPath(V2NIMConversationGroup.groupId))
    }

    if let name = arguments["name"] as? String {
      group.setValue(name,
                     forKeyPath: #keyPath(V2NIMConversationGroup.name))
    }

    if let serverExtension = arguments["serverExtension"] as? String {
      group.setValue(serverExtension,
                     forKeyPath: #keyPath(V2NIMConversationGroup.serverExtension))
    }

    if let createTime = arguments["createTime"] as? Double {
      group.setValue(TimeInterval(createTime / 1000),
                     forKeyPath: #keyPath(V2NIMConversationGroup.createTime))
    }

    if let updateTime = arguments["updateTime"] as? Double {
      group.setValue(TimeInterval(updateTime / 1000),
                     forKeyPath: #keyPath(V2NIMConversationGroup.updateTime))
    }

    return group
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(groupId)] = groupId
    keyPaths[#keyPath(name)] = name
    keyPaths[#keyPath(serverExtension)] = serverExtension
    keyPaths[#keyPath(createTime)] = createTime * 1000
    keyPaths[#keyPath(updateTime)] = updateTime * 1000
    return keyPaths
  }
}
