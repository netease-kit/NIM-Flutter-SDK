// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

// TODO: ios no error
extension V2NIMDataSyncDetail {
  func toDictionary() -> [String: Any?] {
    var dict: [String: Any?] = [
      "type": type.rawValue,
      "state": state.rawValue,
    ]
    return dict
  }

  static func fromDic(_ json: [String: Any?]) -> V2NIMDataSyncDetail {
    let detail = V2NIMDataSyncDetail()
    if let typeInt = json["type"] as? Int,
       let type = V2NIMDataSyncType(rawValue: typeInt) {
      detail.setValue(type.rawValue, forKey: #keyPath(V2NIMDataSyncDetail.type))
    }
    if let stateInt = json["state"] as? Int,
       let state = V2NIMDataSyncState(rawValue: stateInt) {
      detail.setValue(state.rawValue, forKey: #keyPath(V2NIMDataSyncDetail.state))
    }
    return detail
  }
}
