// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import Foundation
import NIMSDK

extension V2NIMUserSearchOption {
  func toDictionary() -> [String: Any] {
    var dict = [String: Any]()
    dict[#keyPath(V2NIMUserSearchOption.keyword)] = keyword
    dict[#keyPath(V2NIMUserSearchOption.searchName)] = searchName
    dict[#keyPath(V2NIMUserSearchOption.searchAccountId)] = searchAccountId
    dict[#keyPath(V2NIMUserSearchOption.searchMobile)] = searchMobile
    return dict
  }

  static func fromDictionary(_ dict: [String: Any]) -> V2NIMUserSearchOption {
    let option = V2NIMUserSearchOption()
    if let keyword = dict[#keyPath(V2NIMUserSearchOption.keyword)] as? String {
      option.keyword = keyword
    }
    if let searchName = dict[#keyPath(V2NIMUserSearchOption.searchName)] as? Bool {
      option.searchName = searchName
    }
    if let searchAccountId = dict[#keyPath(V2NIMUserSearchOption.searchAccountId)] as? Bool {
      option.searchAccountId = searchAccountId
    }
    if let searchMobile = dict[#keyPath(V2NIMUserSearchOption.searchMobile)] as? Bool {
      option.searchMobile = searchMobile
    }
    return option
  }
}
