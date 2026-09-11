// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMMessageLocationAttachment {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDict(_ arguments: [String: Any]) -> V2NIMMessageLocationAttachment {
    let superAttach = super.fromDic(arguments)
    let attach = V2NIMMessageLocationAttachment()
    attach.raw = superAttach.raw

    if let longitude = arguments["longitude"] as? Double {
      attach.longitude = longitude
    }

    if let latitude = arguments["latitude"] as? Double {
      attach.latitude = latitude
    }

    if let address = arguments["address"] as? String {
      attach.address = address
    }

    return attach
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  override public func toDic() -> [String: Any] {
    var keyPaths = super.toDic()
    keyPaths[nimCoreMessageType] = V2NIMMessageType.MESSAGE_TYPE_LOCATION.rawValue
    keyPaths[#keyPath(V2NIMMessageLocationAttachment.longitude)] = longitude
    keyPaths[#keyPath(V2NIMMessageLocationAttachment.latitude)] = latitude
    keyPaths[#keyPath(V2NIMMessageLocationAttachment.address)] = address
    return keyPaths
  }
}
