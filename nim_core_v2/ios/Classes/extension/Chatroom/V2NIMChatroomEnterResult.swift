// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMChatroomEnterResult {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMChatroomEnterResult {
    let result = V2NIMChatroomEnterResult()

    if let chatroom = arguments["chatroom"] as? [String: Any] {
      result.setValue(V2NIMChatroomInfo.fromDic(chatroom), forKeyPath: #keyPath(V2NIMChatroomEnterResult.chatroom))
    }

    if let selfMember = arguments["selfMember"] as? [String: Any] {
      result.setValue(V2NIMChatroomMember.fromDic(selfMember), forKeyPath: #keyPath(V2NIMChatroomEnterResult.selfMember))
    }

    return result
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(chatroom)] = chatroom.toDic()
    keyPaths[#keyPath(selfMember)] = selfMember.toDic()
    return keyPaths
  }
}
