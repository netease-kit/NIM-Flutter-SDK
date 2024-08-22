// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import Foundation
import NIMSDK

extension V2NIMTeamMemberSearchOption {
  func toDictionary() -> [String: Any] {
    let dict: [String: Any] = [
      #keyPath(keyword): keyword,
      #keyPath(teamType): teamType.rawValue,
      #keyPath(teamId): teamId ?? "",
      #keyPath(nextToken): nextToken,
      #keyPath(order): order.rawValue,
      #keyPath(limit): limit,
    ]
    return dict
  }
}
