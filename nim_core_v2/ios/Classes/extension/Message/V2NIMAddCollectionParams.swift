// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMAddCollectionParams {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMAddCollectionParams {
    let attach = V2NIMAddCollectionParams()

    if let collectionType = arguments["collectionType"] as? Int32 {
      attach.collectionType = collectionType
    }

    if let collectionData = arguments["collectionData"] as? String {
      attach.collectionData = collectionData
    }

    if let serverExtension = arguments["serverExtension"] as? String {
      attach.serverExtension = serverExtension
    }

    if let uniqueId = arguments["uniqueId"] as? String {
      attach.uniqueId = uniqueId
    }

    return attach
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMAddCollectionParams.collectionType)] = collectionType
    keyPaths[#keyPath(V2NIMAddCollectionParams.collectionData)] = collectionData
    keyPaths[#keyPath(V2NIMAddCollectionParams.serverExtension)] = serverExtension
    keyPaths[#keyPath(V2NIMAddCollectionParams.uniqueId)] = uniqueId
    return keyPaths
  }
}
