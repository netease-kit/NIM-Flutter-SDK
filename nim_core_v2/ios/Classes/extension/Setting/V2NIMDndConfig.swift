// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import Foundation
import NIMSDK

extension V2NIMDndConfig {
  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  public func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMDndConfig.showDetail)] = showDetail
    keyPaths[#keyPath(V2NIMDndConfig.dndOn)] = dndOn
    keyPaths[#keyPath(V2NIMDndConfig.fromH)] = fromH
    keyPaths[#keyPath(V2NIMDndConfig.fromM)] = fromM
    keyPaths[#keyPath(V2NIMDndConfig.toH)] = toH
    keyPaths[#keyPath(V2NIMDndConfig.toM)] = toM

    return keyPaths
  }

  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMDndConfig {
    let config = V2NIMDndConfig()
    if let showDetail = arguments[#keyPath(showDetail)] as? Bool {
      config.showDetail = showDetail
    }
    if let dndOn = arguments[#keyPath(dndOn)] as? Bool {
      config.dndOn = dndOn
    }
    if let fromH = arguments[#keyPath(fromH)] as? Int {
      config.fromH = fromH
    }
    if let fromM = arguments[#keyPath(fromM)] as? Int {
      config.fromM = fromM
    }
    if let toH = arguments[#keyPath(toH)] as? Int {
      config.toH = toH
    }
    if let toM = arguments[#keyPath(toM)] as? Int {
      config.toM = toM
    }
    return config
  }
}
