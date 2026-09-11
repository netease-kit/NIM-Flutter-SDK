// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMFriend {
  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMFriend.accountId)] = accountId
    keyPaths[#keyPath(V2NIMFriend.alias)] = alias
    keyPaths[#keyPath(V2NIMFriend.serverExtension)] = serverExtension
    keyPaths[#keyPath(V2NIMFriend.customerExtension)] = customerExtension
    keyPaths[#keyPath(V2NIMFriend.createTime)] = createTime * 1000.0
    keyPaths[#keyPath(V2NIMFriend.updateTime)] = updateTime * 1000.0
    keyPaths[#keyPath(V2NIMFriend.userProfile)] = userProfile?.toDic()

    return keyPaths
  }
}
