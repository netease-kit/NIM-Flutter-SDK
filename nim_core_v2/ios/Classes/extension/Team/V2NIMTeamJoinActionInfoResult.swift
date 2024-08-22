// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import Foundation
import NIMSDK

extension V2NIMTeamJoinActionInfoResult {
  func toDictionary() -> [String: Any] {
    var dict: [String: Any] = [
      #keyPath(offset): offset,
      #keyPath(finished): finished,
    ]
    var infosJsonObect = [[String: Any]]()
    infos?.forEach { info in
      infosJsonObect.append(info.toDictionary())
    }
    dict[#keyPath(infos)] = infosJsonObect
    return dict
  }

  static func fromDictionary(_ dict: [String: Any]) -> V2NIMTeamJoinActionInfoResult {
    let result = V2NIMTeamJoinActionInfoResult()
    if let offset = dict[#keyPath(offset)] as? Int {
      result.setValue(offset, forKey: #keyPath(V2NIMTeamJoinActionInfoResult.offset))
    }
    if let finished = dict[#keyPath(finished)] as? Bool {
      result.setValue(finished, forKey: #keyPath(V2NIMTeamJoinActionInfoResult.finished))
    }
    if let infosJsonObect = dict[#keyPath(infos)] as? [[String: Any]] {
      var infos = [V2NIMTeamJoinActionInfo]()
      for info in infosJsonObect {
        infos.append(V2NIMTeamJoinActionInfo.fromDictionary(info))
      }
      result.setValue(infos, forKey: #keyPath(V2NIMTeamJoinActionInfoResult.infos))
    }
    return result
  }
}
