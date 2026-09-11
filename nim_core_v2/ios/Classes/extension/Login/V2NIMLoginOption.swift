// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import Foundation
import NIMSDK

extension V2NIMLoginOption {
  static func fromDic(_ json: [String: Any?]) ->
    V2NIMLoginOption {
    let option = V2NIMLoginOption()
    if let typeInt = json["authType"] as? Int,
       let type = V2NIMLoginAuthType(rawValue: typeInt) {
      option.authType = type
    }

    if let syncLevelInt = json["syncLevel"] as? Int,
       let syncLevel = V2NIMDataSyncLevel(rawValue: syncLevelInt) {
      option.syncLevel = syncLevel
    }

    if let retryCount = json["retryCount"] as? Int {
      option.retryCount = retryCount
    }

    if let timeout = json["timeout"] as? Int {
      option.timeout = timeout
    }

    if let forceMode = json["forceMode"] as? Bool {
      option.forceMode = forceMode
    }

    if let offlineMode = json["offlineMode"] as? Bool {
      option.offlineMode = offlineMode
    }
    return option
  }
}
