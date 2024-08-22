// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import Foundation
import NIMSDK

extension V2NIMTeamJoinActionInfoQueryOption {
  func toDictionary() -> [String: Any] {
    let dict: [String: Any] = [
      #keyPath(types): types ?? [],
      #keyPath(offset): offset,
      #keyPath(limit): limit,
      #keyPath(status): status ?? [],
    ]
    return dict
  }

  static func fromDictionary(_ dict: [String: Any]) -> V2NIMTeamJoinActionInfoQueryOption {
    let option = V2NIMTeamJoinActionInfoQueryOption()
    if let types = dict[#keyPath(types)] as? [NSNumber] {
      option.types = types
    }
    if let offset = dict[#keyPath(offset)] as? Int {
      option.offset = offset
    }
    if let limit = dict[#keyPath(limit)] as? Int {
      option.limit = limit
    }
    if let status = dict[#keyPath(status)] as? [NSNumber] {
      option.status = status
    }
    return option
  }
}
