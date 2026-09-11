// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMMessageSearchResult {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
//  static func fromDic(_ arguments: [String: Any]) -> V2NIMMessageSearchResult {
//    let result = V2NIMMessageSearchResult()
//
//    return result
//  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(count)] = count
    keyPaths[#keyPath(nextPageToken)] = nextPageToken
    keyPaths[#keyPath(hasMore)] = hasMore
    keyPaths[#keyPath(items)] = items.map { item in
      item.toDic()
    }
    return keyPaths
  }
}
