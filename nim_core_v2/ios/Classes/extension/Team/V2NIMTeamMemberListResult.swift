// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import Foundation
import NIMSDK

extension V2NIMTeamMemberListResult {
  func toDictionary() -> [String: Any] {
    var dict: [String: Any] = [
      #keyPath(finished): finished,
      #keyPath(nextToken): nextToken ?? "",
    ]
    var listJsonObject = [[String: Any]]()

    memberList?.forEach { member in
      listJsonObject.append(member.toDictionary())
    }
    dict[#keyPath(memberList)] = listJsonObject

    return dict
  }

  static func fromDictionary(_ dict: [String: Any]) -> V2NIMTeamMemberListResult {
    let result = V2NIMTeamMemberListResult()
    if let finished = dict[#keyPath(finished)] as? Bool {
      result.setValue(finished, forKey: #keyPath(V2NIMTeamMemberListResult.finished))
    }
    if let nextToken = dict[#keyPath(nextToken)] as? String {
      result.setValue(nextToken, forKey: #keyPath(V2NIMTeamMemberListResult.nextToken))
    }
    if let memberListJsonObect = dict[#keyPath(memberList)] as? [[String: Any]] {
      var memberList = [V2NIMTeamMember]()
      for member in memberListJsonObect {
        memberList.append(V2NIMTeamMember.fromDictionary(member))
      }
      result.setValue(memberList, forKey: #keyPath(V2NIMTeamMemberListResult.memberList))
    }
    return result
  }
}
