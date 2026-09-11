// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import Foundation
import NIMSDK

extension V2NIMTeamMemberSearchResult {
  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMTeamMemberSearchResult.nextToken)] = nextToken
    keyPaths[#keyPath(V2NIMTeamMemberSearchResult.finished)] = finished
    keyPaths[#keyPath(V2NIMTeamMemberSearchResult.memberList)] = memberList?.map { $0.toDic() }
    return keyPaths
  }

  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMTeamMemberSearchResult {
    let result = V2NIMTeamMemberSearchResult()
    if let nextToken = arguments[#keyPath(nextToken)] as? String {
      result.setValue(nextToken, forKey: #keyPath(V2NIMTeamMemberSearchResult.nextToken))
    }
    if let finished = arguments[#keyPath(finished)] as? Bool {
      result.setValue(finished, forKey: #keyPath(V2NIMTeamMemberSearchResult.finished))
    }
    if let memberListJsonObect = arguments[#keyPath(memberList)] as? [[String: Any]] {
      var memberList = [V2NIMTeamMember]()
      for member in memberListJsonObect {
        memberList.append(V2NIMTeamMember.fromDic(member))
      }
      result.setValue(memberList, forKey: #keyPath(V2NIMTeamMemberSearchResult.memberList))
    }
    return result
  }
}
