// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMClientAntispamResult {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMClientAntispamResult {
    let attach = V2NIMClientAntispamResult()

    if let type = arguments["operateType"] as? Int,
       let operateType = V2NIMClientAntispamOperateType(rawValue: type) {
      attach.operateType = operateType
    }

    if let replacedText = arguments["replacedText"] as? String {
      attach.replacedText = replacedText
    }

    return attach
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMClientAntispamResult.operateType)] = operateType.rawValue
    keyPaths[#keyPath(V2NIMClientAntispamResult.replacedText)] = replacedText
    return keyPaths
  }
}
