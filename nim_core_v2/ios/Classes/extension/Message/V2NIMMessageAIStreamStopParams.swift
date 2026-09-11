// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMMessageAIStreamStopParams {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMMessageAIStreamStopParams {
    let params = V2NIMMessageAIStreamStopParams()

    if let operationTypeInt = arguments["operationType"] as? Int,
       let operationType = V2NIMMessageAIStreamStopOpType(rawValue: operationTypeInt) {
      params.operationType = operationType
    }

    if let updateContent = arguments["updateContent"] as? String {
      params.updateContent = updateContent
    }

    return params
  }
}
