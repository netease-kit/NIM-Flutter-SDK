// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMConversationGroupResult {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMConversationGroupResult {
    let group = V2NIMConversationGroupResult()

    if let groupDic = arguments["group"] as? [String: Any] {
      group.setValue(V2NIMConversationGroup.fromDic(groupDic),
                     forKeyPath: #keyPath(V2NIMConversationGroupResult.group))
    }

    if let failedListDic = arguments["failedList"] as? [[String: Any]] {
      let failedList = failedListDic.map { V2NIMConversationOperationResult.fromDic($0) }
      group.setValue(failedList,
                     forKeyPath: #keyPath(V2NIMConversationGroupResult.failedList))
    }

    return group
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(group)] = group?.toDic()
    keyPaths[#keyPath(failedList)] = failedList?.map { $0.toDic() }
    return keyPaths
  }
}
