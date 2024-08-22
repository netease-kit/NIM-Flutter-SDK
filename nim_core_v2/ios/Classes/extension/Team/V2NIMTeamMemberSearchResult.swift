// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import Foundation
import NIMSDK

extension V2NIMTeamMemberSearchResult {
  func toDictionary() -> [String: Any] {
    var dict: [String: Any] = [
      #keyPath(nextToken): nextToken,
      #keyPath(finished): finished,
    ]
    var memberListJsonObect = [[String: Any]]()
    memberList?.forEach { member in
      memberListJsonObect.append(member.toDictionary())
    }
    dict[#keyPath(memberList)] = memberListJsonObect
    return dict
  }

  static func fromDictionary(_ dict: [String: Any]) -> V2NIMTeamMemberSearchResult {
    let result = V2NIMTeamMemberSearchResult()
    if let nextToken = dict[#keyPath(nextToken)] as? String {
      result.setValue(nextToken, forKey: #keyPath(V2NIMTeamMemberSearchResult.nextToken))
    }
    if let finished = dict[#keyPath(finished)] as? Bool {
      result.setValue(finished, forKey: #keyPath(V2NIMTeamMemberSearchResult.finished))
    }
    if let memberListJsonObect = dict[#keyPath(memberList)] as? [[String: Any]] {
      var memberList = [V2NIMTeamMember]()
      for member in memberListJsonObect {
        memberList.append(V2NIMTeamMember.fromDictionary(member))
      }
      result.setValue(memberList, forKey: #keyPath(V2NIMTeamMemberSearchResult.memberList))
    }
    return result
  }
}
