// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import Foundation
import NIMSDK

extension V2NIMUserSearchOption {
  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMUserSearchOption.keyword)] = keyword
    keyPaths[#keyPath(V2NIMUserSearchOption.searchName)] = searchName
    keyPaths[#keyPath(V2NIMUserSearchOption.searchAccountId)] = searchAccountId
    keyPaths[#keyPath(V2NIMUserSearchOption.searchMobile)] = searchMobile
    return keyPaths
  }

  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMUserSearchOption {
    let option = V2NIMUserSearchOption()

    if let keyword = arguments[#keyPath(V2NIMUserSearchOption.keyword)] as? String {
      option.keyword = keyword
    }

    if let searchName = arguments[#keyPath(V2NIMUserSearchOption.searchName)] as? Bool {
      option.searchName = searchName
    }

    if let searchAccountId = arguments[#keyPath(V2NIMUserSearchOption.searchAccountId)] as? Bool {
      option.searchAccountId = searchAccountId
    }

    if let searchMobile = arguments[#keyPath(V2NIMUserSearchOption.searchMobile)] as? Bool {
      option.searchMobile = searchMobile
    }
    return option
  }
}
