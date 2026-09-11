// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMCollectionOption {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMCollectionOption {
    let attach = V2NIMCollectionOption()

    let beginTime = arguments["beginTime"] as? Double
    attach.beginTime = TimeInterval((beginTime ?? 0) / 1000)

    let endTime = arguments["endTime"] as? Double
    attach.endTime = TimeInterval((endTime ?? 0) / 1000)

    if let dir = arguments["direction"] as? Int,
       let direction = V2NIMQueryDirection(rawValue: dir) {
      attach.direction = direction
    }

    if let anchorCollection = arguments["anchorCollection"] as? [String: Any] {
      attach.anchorCollection = V2NIMCollection.fromDic(anchorCollection)
    }

    if let limit = arguments["limit"] as? Int {
      attach.limit = limit
    }

    if let collectionType = arguments["collectionType"] as? Int {
      attach.collectionType = collectionType
    }

    return attach
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMCollectionOption.beginTime)] = beginTime * 1000
    keyPaths[#keyPath(V2NIMCollectionOption.endTime)] = endTime * 1000
    keyPaths[#keyPath(V2NIMCollectionOption.direction)] = direction.rawValue
    keyPaths[#keyPath(V2NIMCollectionOption.anchorCollection)] = anchorCollection?.toDic()
    keyPaths[#keyPath(V2NIMCollectionOption.limit)] = limit
    keyPaths[#keyPath(V2NIMCollectionOption.collectionType)] = collectionType
    return keyPaths
  }
}
