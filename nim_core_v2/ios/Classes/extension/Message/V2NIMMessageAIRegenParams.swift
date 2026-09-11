// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMMessageAIRegenParams {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMMessageAIRegenParams {
    let params = V2NIMMessageAIRegenParams()

    if let operationTypeInt = arguments["operationType"] as? Int,
       let operationType = V2NIMMessageAIRegenOpType(rawValue: operationTypeInt) {
      return V2NIMMessageAIRegenParams(operationType)
    }

    return params
  }
}
