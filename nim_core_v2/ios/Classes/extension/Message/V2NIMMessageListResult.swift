// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMMessageListResult {
  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMMessageListResult.anchorMessage)] = anchorMessage?.toDict()
    keyPaths[#keyPath(V2NIMMessageListResult.messages)] = messages?.map { $0.toDict() }
    return keyPaths
  }
}
