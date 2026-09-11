// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMCollection {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMCollection {
    let attach = V2NIMCollection()

    if let collectionId = arguments["collectionId"] as? String {
      attach.collectionId = collectionId
    }

    if let collectionType = arguments["collectionType"] as? Int32 {
      attach.collectionType = collectionType
    }

    if let collectionData = arguments["collectionData"] as? String {
      attach.setValue(collectionData,
                      forKeyPath: #keyPath(V2NIMCollection.collectionData))
    }

    if let serverExtension = arguments["serverExtension"] as? String {
      attach.serverExtension = serverExtension
    }

    let createTime = arguments["createTime"] as? Double
    attach.createTime = TimeInterval((createTime ?? 0) / 1000)

    let updateTime = arguments["updateTime"] as? Double
    attach.updateTime = TimeInterval((updateTime ?? 0) / 1000)

    if let uniqueId = arguments["uniqueId"] as? String {
      attach.uniqueId = uniqueId
    }

    return attach
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMCollection.collectionId)] = collectionId
    keyPaths[#keyPath(V2NIMCollection.collectionType)] = collectionType
    keyPaths[#keyPath(V2NIMCollection.collectionData)] = collectionData
    keyPaths[#keyPath(V2NIMCollection.serverExtension)] = serverExtension
    keyPaths[#keyPath(V2NIMCollection.createTime)] = createTime * 1000
    keyPaths[#keyPath(V2NIMCollection.updateTime)] = updateTime * 1000
    keyPaths[#keyPath(V2NIMCollection.uniqueId)] = uniqueId
    return keyPaths
  }
}
