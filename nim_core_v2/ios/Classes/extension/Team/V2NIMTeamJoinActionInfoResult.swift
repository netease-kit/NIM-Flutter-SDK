// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import Foundation
import NIMSDK

extension V2NIMTeamJoinActionInfoResult {
  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(offset)] = offset
    keyPaths[#keyPath(finished)] = finished
    keyPaths[#keyPath(infos)] = infos?.map { $0.toDic() }

    return keyPaths
  }

  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMTeamJoinActionInfoResult {
    let result = V2NIMTeamJoinActionInfoResult()
    if let offset = arguments[#keyPath(offset)] as? Int {
      result.setValue(offset, forKey: #keyPath(V2NIMTeamJoinActionInfoResult.offset))
    }
    if let finished = arguments[#keyPath(finished)] as? Bool {
      result.setValue(finished, forKey: #keyPath(V2NIMTeamJoinActionInfoResult.finished))
    }
    if let infosJsonObect = arguments[#keyPath(infos)] as? [[String: Any]] {
      var infos = [V2NIMTeamJoinActionInfo]()
      for info in infosJsonObect {
        infos.append(V2NIMTeamJoinActionInfo.fromDic(info))
      }
      result.setValue(infos, forKey: #keyPath(V2NIMTeamJoinActionInfoResult.infos))
    }
    return result
  }
}
