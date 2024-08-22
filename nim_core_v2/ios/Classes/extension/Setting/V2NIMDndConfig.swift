// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import Foundation
import NIMSDK

extension V2NIMDndConfig {
  func toDictionary() -> [String: Any] {
    var dict: [String: Any] = [
      #keyPath(showDetail): showDetail,
      #keyPath(dndOn): dndOn,
      #keyPath(fromH): fromH,
      #keyPath(fromM): fromM,
      #keyPath(toH): toH,
      #keyPath(toM): toM,
    ]
    return dict
  }

  static func fromDitionary(_ arguments: [String: Any]) -> V2NIMDndConfig {
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
