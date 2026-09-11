// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMModifyMessageResult {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMModifyMessageResult {
    let result = V2NIMModifyMessageResult()

    if let message = arguments["message"] as? [String: Any] {
      result.setValue(V2NIMMessage.fromDict(message), forKeyPath: #keyPath(V2NIMModifyMessageResult.message))
    }

    if let errorCode = arguments["errorCode"] as? Int {
      result.errorCode = errorCode
    }

    if let antispamResult = arguments["antispamResult"] as? String {
      result.setValue(antispamResult, forKeyPath: #keyPath(V2NIMModifyMessageResult.antispamResult))
    }

    if let clientAntispamResult = arguments["clientAntispamResult"] as? [String: Any] {
      result.setValue(V2NIMClientAntispamResult.fromDic(clientAntispamResult), forKeyPath: #keyPath(V2NIMModifyMessageResult.clientAntispamResult))
    }

    return result
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(message)] = message?.toDict()
    keyPaths[#keyPath(errorCode)] = errorCode
    keyPaths[#keyPath(antispamResult)] = antispamResult
    keyPaths[#keyPath(clientAntispamResult)] = clientAntispamResult?.toDic()
    return keyPaths
  }
}
