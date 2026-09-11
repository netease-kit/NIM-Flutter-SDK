// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMSendMessageResult {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMSendMessageResult {
    let attach = V2NIMSendMessageResult()

    if let message = arguments["message"] as? [String: Any] {
      attach.setValue(V2NIMMessage.fromDict(message),
                      forKeyPath: #keyPath(V2NIMSendMessageResult.message))
    }

    if let antispamResult = arguments["antispamResult"] as? String {
      attach.setValue(antispamResult,
                      forKeyPath: #keyPath(V2NIMSendMessageResult.antispamResult))
    }

    if let clientAntispamResult = arguments["clientAntispamResult"] as? [String: Any] {
      attach.setValue(V2NIMClientAntispamResult.fromDic(clientAntispamResult),
                      forKeyPath: #keyPath(V2NIMSendMessageResult.clientAntispamResult))
    }

    return attach
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMSendMessageResult.message)] = message?.toDict()
    keyPaths[#keyPath(V2NIMSendMessageResult.antispamResult)] = antispamResult
    keyPaths[#keyPath(V2NIMSendMessageResult.clientAntispamResult)] = clientAntispamResult?.toDic()
    return keyPaths
  }
}
