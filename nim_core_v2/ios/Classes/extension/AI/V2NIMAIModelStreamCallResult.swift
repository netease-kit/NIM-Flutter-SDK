// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMAIModelStreamCallResult {
  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMAIModelStreamCallResult.code)] = code
    keyPaths[#keyPath(V2NIMAIModelStreamCallResult.accountId)] = accountId
    keyPaths[#keyPath(V2NIMAIModelStreamCallResult.requestId)] = requestId
    keyPaths[#keyPath(V2NIMAIModelStreamCallResult.content)] = content.toDic()
    keyPaths[#keyPath(V2NIMAIModelStreamCallResult.timestamp)] = timestamp
    keyPaths[#keyPath(V2NIMAIModelStreamCallResult.aiRAGs)] = aiRAGs.map { $0.toDic() }
    return keyPaths
  }
}
