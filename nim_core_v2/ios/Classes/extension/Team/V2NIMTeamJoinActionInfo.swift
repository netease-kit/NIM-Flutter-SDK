// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import Foundation
import NIMSDK

extension V2NIMTeamJoinActionInfo {
  func toDictionary() -> [String: Any] {
    let dict: [String: Any] = [
      #keyPath(actionType): actionType.rawValue,
      #keyPath(teamId): teamId,
      #keyPath(teamType): teamType.rawValue,
      #keyPath(operatorAccountId): operatorAccountId,
      #keyPath(postscript): postscript,
      #keyPath(timestamp): timestamp * 1000,
      #keyPath(actionStatus): actionStatus.rawValue,
    ]
    return dict
  }

  static func fromDictionary(_ dictionary: [String: Any]) -> V2NIMTeamJoinActionInfo {
    let info = V2NIMTeamJoinActionInfo()
    if let actionType = dictionary[#keyPath(actionType)] as? Int {
      info.setValue(NSNumber(integerLiteral: actionType), forKey: #keyPath(V2NIMTeamJoinActionInfo.actionType))
    }

    if let teamId = dictionary[#keyPath(teamId)] as? String {
      info.setValue(teamId, forKey: #keyPath(V2NIMTeamJoinActionInfo.teamId))
    }

    if let teamType = dictionary[#keyPath(teamType)] as? Int {
      info.setValue(NSNumber(integerLiteral: teamType), forKey: #keyPath(V2NIMTeamJoinActionInfo.teamType))
    }

    if let operatorAccountId = dictionary[#keyPath(operatorAccountId)] as? String {
      info.setValue(operatorAccountId, forKey: #keyPath(V2NIMTeamJoinActionInfo.operatorAccountId))
    }

    if let postscript = dictionary[#keyPath(postscript)] as? String {
      info.setValue(postscript, forKey: #keyPath(V2NIMTeamJoinActionInfo.postscript))
    }

    if let timestamp = dictionary[#keyPath(timestamp)] as? Double {
      info.setValue(timestamp / 1000, forKey: #keyPath(V2NIMTeamJoinActionInfo.timestamp))
    }

    if let actionStatus = dictionary[#keyPath(actionStatus)] as? Int {
      info.setValue(NSNumber(integerLiteral: actionStatus), forKey: #keyPath(V2NIMTeamJoinActionInfo.actionStatus))
    }

    return info
  }
}
