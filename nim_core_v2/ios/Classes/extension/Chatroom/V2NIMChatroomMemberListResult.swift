// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMChatroomMemberListResult {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMChatroomMemberListResult {
    let result = V2NIMChatroomMemberListResult()

    if let pageToken = arguments["pageToken"] as? String {
      result.setValue(pageToken, forKeyPath: #keyPath(V2NIMChatroomMemberListResult.pageToken))
    }

    if let finished = arguments["finished"] as? Bool {
      result.setValue(finished, forKeyPath: #keyPath(V2NIMChatroomMemberListResult.finished))
    }

    if let memberList = arguments["memberList"] as? [[String: Any]] {
      var members = [V2NIMChatroomMember]()
      for member in memberList {
        members.append(V2NIMChatroomMember.fromDic(member))
      }
      result.setValue(members, forKeyPath: #keyPath(V2NIMChatroomMemberListResult.memberList))
    }

    return result
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(pageToken)] = pageToken
    keyPaths[#keyPath(finished)] = finished

    var members = [[String: Any]]()
    for member in memberList {
      if let member = member as? V2NIMChatroomMember {
        members.append(member.toDic())
      }
    }
    keyPaths[#keyPath(memberList)] = members

    return keyPaths
  }
}
