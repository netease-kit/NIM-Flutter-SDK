// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMKickedOfflineDetail {
  func toDictionary() -> [String: Any?] {
    var dict: [String: Any?] = [
      "reason": reason.rawValue,
      "clientType": clientType.rawValue,
      "customClientType": customClientType,
      "reasonDesc": reasonDesc,
    ]
    return dict
  }

  static func fromDic(_ json: [String: Any?]) -> V2NIMKickedOfflineDetail {
    let detail = V2NIMKickedOfflineDetail()
    if let reasonInt = json["reason"] as? Int,
       let reason = V2NIMKickedOfflineReason(rawValue: reasonInt) {
      detail.setValue(reason.rawValue, forKey: #keyPath(V2NIMKickedOfflineDetail.reason))
    }
    if let clientTypeInt = json["clientType"] as? Int,
       let clientType = V2NIMLoginClientType(rawValue: clientTypeInt) {
      detail.setValue(clientType.rawValue, forKey: #keyPath(V2NIMKickedOfflineDetail.clientType))
    }

    if let customClientType = json["customClientType"] as? Int {
      detail.setValue(customClientType, forKey: #keyPath(V2NIMKickedOfflineDetail.customClientType))
    }

    if let reasonDesc = json["reasonDesc"] as? String {
      detail.setValue(reasonDesc, forKey: #keyPath(V2NIMKickedOfflineDetail.reasonDesc))
      return detail
    }
    return detail
  }
}
