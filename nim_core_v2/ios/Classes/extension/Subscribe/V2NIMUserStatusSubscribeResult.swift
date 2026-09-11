// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMUserStatusSubscribeResult {
  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMUserStatusSubscribeResult.accountId)] = accountId
    keyPaths[#keyPath(V2NIMUserStatusSubscribeResult.duration)] = duration
    keyPaths[#keyPath(V2NIMUserStatusSubscribeResult.subscribeTime)] = subscribeTime
    return keyPaths
  }
}
