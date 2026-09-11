// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import Foundation
import NIMSDK

extension V2NIMCreateTeamResult {
  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMCreateTeamResult.team)] = team?.toDic()
    keyPaths[#keyPath(V2NIMCreateTeamResult.failedList)] = failedList
    return keyPaths
  }

  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMCreateTeamResult {
    let result = V2NIMCreateTeamResult()
    if let teamDict = arguments[#keyPath(V2NIMCreateTeamResult.team)] as? [String: Any] {
      let team = V2NIMTeam.fromDic(teamDict)
      result.setValue(team, forKey: #keyPath(V2NIMCreateTeamResult.team))
    }
    if let failedList = arguments[#keyPath(V2NIMCreateTeamResult.failedList)] as? [String] {
      result.setValue(failedList, forKey: #keyPath(V2NIMCreateTeamResult.failedList))
    }

    return result
  }
}
