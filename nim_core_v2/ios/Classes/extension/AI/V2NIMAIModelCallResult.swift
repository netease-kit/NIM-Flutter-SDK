// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMAIModelCallResult {
  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMAIModelCallResult.accountId)] = accountId
    keyPaths[#keyPath(V2NIMAIModelCallResult.requestId)] = requestId
    keyPaths[#keyPath(V2NIMAIModelCallResult.content)] = content.toDic()
    keyPaths[#keyPath(V2NIMAIModelCallResult.code)] = code
    keyPaths[#keyPath(V2NIMAIModelCallResult.timestamp)] = timestamp * 1000
    keyPaths[#keyPath(V2NIMAIModelCallResult.aiStream)] = aiStream
    keyPaths[#keyPath(V2NIMAIModelCallResult.aiStreamStatus)] = aiStreamStatus.rawValue
    keyPaths[#keyPath(V2NIMAIModelCallResult.aiRAGs)] = aiRAGs.map { $0.toDic() }
    return keyPaths
  }

  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMAIModelCallResult {
    let result = V2NIMAIModelCallResult()
    if let accountId = arguments[#keyPath(V2NIMAIModelCallResult.accountId)] as? String {
      result.accountId = accountId
    }
    if let requestId = arguments[#keyPath(V2NIMAIModelCallResult.requestId)] as? String {
      result.requestId = requestId
    }
    if let contentDict = arguments[#keyPath(V2NIMAIModelCallResult.content)] as? [String: Any] {
      result.content = V2NIMAIModelCallContent.fromDic(contentDict)
    }
    if let code = arguments[#keyPath(V2NIMAIModelCallResult.code)] as? Int {
      result.code = code
    }
    return result
  }
}
