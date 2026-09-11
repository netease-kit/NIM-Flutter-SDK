// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import Foundation
import NIMSDK

extension V2NIMTeamJoinActionInfo {
  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(actionType)] = actionType.rawValue
    keyPaths[#keyPath(teamId)] = teamId
    keyPaths[#keyPath(teamType)] = teamType.rawValue
    keyPaths[#keyPath(operatorAccountId)] = operatorAccountId
    keyPaths[#keyPath(postscript)] = postscript
    keyPaths[#keyPath(timestamp)] = timestamp * 1000
    keyPaths[#keyPath(actionStatus)] = actionStatus.rawValue
    keyPaths[#keyPath(serverExtension)] = serverExtension
    keyPaths["read"] = read

    return keyPaths
  }

  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMTeamJoinActionInfo {
    let info = V2NIMTeamJoinActionInfo()
    if let actionType = arguments[#keyPath(actionType)] as? Int {
      info.setValue(NSNumber(integerLiteral: actionType), forKey: #keyPath(V2NIMTeamJoinActionInfo.actionType))
    }

    if let teamId = arguments[#keyPath(teamId)] as? String {
      info.setValue(teamId, forKey: #keyPath(V2NIMTeamJoinActionInfo.teamId))
    }

    if let teamType = arguments[#keyPath(teamType)] as? Int {
      info.setValue(NSNumber(integerLiteral: teamType), forKey: #keyPath(V2NIMTeamJoinActionInfo.teamType))
    }

    if let operatorAccountId = arguments[#keyPath(operatorAccountId)] as? String {
      info.setValue(operatorAccountId, forKey: #keyPath(V2NIMTeamJoinActionInfo.operatorAccountId))
    }

    if let postscript = arguments[#keyPath(postscript)] as? String {
      info.setValue(postscript, forKey: #keyPath(V2NIMTeamJoinActionInfo.postscript))
    }

    if let timestamp = arguments[#keyPath(timestamp)] as? Double {
      info.setValue(timestamp / 1000, forKey: #keyPath(V2NIMTeamJoinActionInfo.timestamp))
    }

    if let actionStatus = arguments[#keyPath(actionStatus)] as? Int {
      info.setValue(NSNumber(integerLiteral: actionStatus), forKey: #keyPath(V2NIMTeamJoinActionInfo.actionStatus))
    }

    if let serverExtension = arguments[#keyPath(serverExtension)] as? String {
      info.setValue(serverExtension, forKey: #keyPath(V2NIMTeamJoinActionInfo.serverExtension))
    }

    return info
  }
}
