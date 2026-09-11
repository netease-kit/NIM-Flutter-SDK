// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMPostscript {
  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMPostscript.fromAccount)] = fromAccount
    keyPaths[#keyPath(V2NIMPostscript.content)] = content
    keyPaths[#keyPath(V2NIMPostscript.time)] = time * 1000.0

    return keyPaths
  }
}
