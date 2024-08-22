// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import Foundation
import NIMSDK

extension V2NIMUpdateSelfMemberInfoParams {
  func toDictionary() -> [String: Any] {
    let dict: [String: Any] = [
      #keyPath(teamNick): teamNick ?? "",
      #keyPath(serverExtension): serverExtension ?? "",
    ]
    return dict
  }

  static func fromDictionary(_ dict: [String: Any]) -> V2NIMUpdateSelfMemberInfoParams {
    let params = V2NIMUpdateSelfMemberInfoParams()
    if let teamNick = dict[#keyPath(teamNick)] as? String {
      params.teamNick = teamNick
    }
    if let serverExtension = dict[#keyPath(serverExtension)] as? String {
      params.serverExtension = serverExtension
    }
    return params
  }
}
