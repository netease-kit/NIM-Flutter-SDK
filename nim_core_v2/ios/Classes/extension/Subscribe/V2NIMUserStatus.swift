// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMUserStatus {
  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMUserStatus.accountId)] = accountId
    keyPaths[#keyPath(V2NIMUserStatus.statusType)] = statusType.rawValue
    keyPaths[#keyPath(V2NIMUserStatus.clientType)] = clientType.rawValue
    keyPaths[#keyPath(V2NIMUserStatus.publishTime)] = publishTime * 1000
    keyPaths[#keyPath(V2NIMUserStatus.uniqueId)] = uniqueId
    keyPaths[#keyPath(V2NIMUserStatus.extension)] = self.extension
    keyPaths[#keyPath(V2NIMUserStatus.serverExtension)] = serverExtension
    return keyPaths
  }
}
