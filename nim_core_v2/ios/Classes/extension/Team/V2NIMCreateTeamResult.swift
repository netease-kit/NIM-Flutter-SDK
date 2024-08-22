// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import Foundation
import NIMSDK

extension V2NIMCreateTeamResult {
  func toDictionary() -> [String: Any] {
    var dict: [String: Any] = [:]
    if let team = team {
      dict[#keyPath(V2NIMCreateTeamResult.team)] = team.toDictionary()
    }
    dict[#keyPath(V2NIMCreateTeamResult.failedList)] = failedList ?? []
    return dict
  }

  static func fromDictionary(_ dict: [String: Any]) -> V2NIMCreateTeamResult {
    let result = V2NIMCreateTeamResult()
    if let teamDict = dict[#keyPath(V2NIMCreateTeamResult.team)] as? [String: Any] {
      let team = V2NIMTeam.fromDictionary(teamDict)
      result.setValue(team, forKey: #keyPath(V2NIMCreateTeamResult.team))
    }
    if let failedList = dict[#keyPath(V2NIMCreateTeamResult.failedList)] as? [String] {
      result.setValue(failedList, forKey: #keyPath(V2NIMCreateTeamResult.failedList))
    }

    return result
  }
}
